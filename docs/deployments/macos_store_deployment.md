## macOS App Store deployment (CI/CD)

This guide explains how to build, sign, and upload the macOS app to App Store Connect via GitHub Actions. It complements the workflow in `.github/workflows/macos_store_build.yaml`. Do not commit any confidential values; use GitHub Secrets.

### Prerequisites (one-time)

- App record exists in App Store Connect for your bundle ID (e.g. `<BUNDLE_ID>`) and platform macOS.
- Xcode project is configured for sandboxing and category:
  - `apps/flites/macos/Runner/Info.plist` contains `LSApplicationCategoryType` (e.g. `public.app-category.graphics-design`).
  - `apps/flites/macos/Runner/Release.entitlements` enables `com.apple.security.app-sandbox` and required entitlements.
- Create an App Store Connect API key for the correct Apple Developer team (Team ID of your app, e.g. `<TEAM_ID>`). Download the private key `.p8`.
- Export certificates as password-protected `.p12` files for the same team:
  - Apple Distribution (codesign the app inside the archive)
  - Mac Installer Distribution (sign the .pkg)

### Create signing key and certificates (CLI)

You can create the certificates using the `app-store-connect` CLI. The CLI needs:
- An App Store Connect API key (Issuer ID + Key ID + private key `.p8`) for the correct team
- A private key file used to generate a Certificate Signing Request (CSR) for Apple certificates

1) Install the CLI locally (if not installed)

```bash
python3 -m pip install --upgrade pip
python3 -m pip install --upgrade codemagic-cli-tools
```

2) Export your App Store Connect API credentials as environment variables

```bash
export APP_STORE_CONNECT_ISSUER_ID="<ASC_ISSUER_ID>"
export APP_STORE_CONNECT_KEY_IDENTIFIER="<ASC_KEY_ID>"
export APP_STORE_CONNECT_PRIVATE_KEY="$(cat /absolute/path/AuthKey_<ASC_KEY_ID>.p8)"
```

3) Generate a private key for certificate creation (keep this file secret!)

```bash
# RSA 2048 is widely used for Apple certs
mkdir -p ~/keys/macos && cd ~/keys/macos
openssl genrsa -out macos_signing_key 2048
```

4) Create/refresh the Mac App Store Distribution files for your app bundle id

```bash
app-store-connect fetch-signing-files <BUNDLE_ID> \
  --platform MAC_OS \
  --type MAC_APP_STORE \
  --certificate-key=@file:~/keys/macos/macos_signing_key \
  --create
```

This will generate and download the signing assets for the app (including a distribution certificate). Artifacts are typically saved under `~/Library/MobileDevice/Certificates/` and the command output prints the exact paths.

5) Create and download a Mac Installer Distribution certificate

```bash
app-store-connect certificates create \
  --type MAC_INSTALLER_DISTRIBUTION \
  --certificate-key=@file:~/keys/macos/macos_signing_key \
  --save
```

This saves a `.p12` for the installer certificate (and prints its path). Both the Apple Distribution and Mac Installer Distribution `.p12` files must belong to the same `<TEAM_ID>` as your app.

6) Convert `.p12` files to base64 for GitHub Secrets

```bash
base64 -i /path/to/Apple_Distribution.p12 | pbcopy            # paste into MACOS_DIST_P12_BASE64
base64 -i /path/to/Mac_Installer_Distribution.p12 | pbcopy    # paste into MACOS_INSTALLER_P12_BASE64
```

Notes:
- If your CLI key belongs to a different team than the app, the generated certificates will not work for this app. Ensure the API key is created under the same team as `<TEAM_ID>`.
- Keep `macos_signing_key` and all certificate files secure; do not commit them to the repository.

### Required GitHub Secrets

Add these repository/environment secrets in GitHub (use placeholders below, never commit real values):

- `MACOS_TEAM_ID`: Your Apple Developer Team ID (e.g. `<TEAM_ID>`).
- `ASC_ISSUER_ID`: App Store Connect API Issuer ID (UUID).
- `ASC_KEY_ID`: App Store Connect API Key ID.
- `ASC_PRIVATE_KEY`: Contents of `AuthKey_<KEY_ID>.p8` (include header/footer).
- `KEYCHAIN_PASSWORD`: Password to secure the temporary CI keychain.
- `MACOS_DIST_P12_BASE64`: Base64 of the Apple Distribution `.p12` (same team as app).
- `MACOS_DIST_P12_PASSWORD`: Password for the above `.p12`.
- `MACOS_INSTALLER_P12_BASE64`: Base64 of the Mac Installer Distribution `.p12` (same team).
- `MACOS_INSTALLER_P12_PASSWORD`: Password for the above `.p12`.

Tips:
- Create base64 locally: `base64 -i /path/to/file.p12 | pbcopy` (macOS).
- Ensure all certs and API key belong to the same team as the app.

### Running the workflow

- Manually trigger from Actions tab (optionally provide `version`/`buildNumber`).
- Or push a tag `v*` (e.g., `v0.0.5`).

### What the workflow does

1. Checks out repo and sets up Flutter stable.
2. Installs `codemagic-cli-tools` and creates a temporary keychain.
3. Imports Apple Distribution and Mac Installer Distribution certificates from secrets.
4. Writes the App Store Connect API key to a file for the upload command.
5. Archives the macOS app with Xcode (`Runner.xcworkspace`, scheme `Runner`, Release).
6. Detects the Mac Installer Distribution certificate Common Name and writes `ExportOptions.plist` for App Store export.
7. Exports a signed `.pkg` via `xcodebuild -exportArchive`.
8. Verifies the `.pkg` signature and uploads it to App Store Connect using the API key.
9. Publishes the resulting `.pkg` as a GitHub Actions artifact.

### Manual steps if things fail

- Certificate/Team errors:
  - Verify the API key belongs to the same Team ID as the app.
  - Verify both `.p12` certificates are for the same Team ID.
  - If a certificate is revoked, re-issue and update the base64 secrets.
- Missing entitlements or category:
  - Update `Info.plist` and entitlements, rebuild, and re-run workflow.
- Notarization: App Store export handles the App Store upload path; separate notarization isn’t needed for Mac App Store distribution.

### Local reproduction (optional)

From `apps/flites/macos` you can replicate the CI steps (replace placeholders like `<TEAM_ID>`, `<ASC_ISSUER_ID>`, `<ASC_KEY_ID>`, etc.):

```bash
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -archivePath build/Runner.xcarchive \
  DEVELOPMENT_TEAM="<TEAM_ID>" \
  CODE_SIGN_STYLE=Manual \
  clean archive

cat > ExportOptions.plist <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>method</key>
  <string>app-store-connect</string>
  <key>teamID</key>
  <string><TEAM_ID></string>
  <key>signingStyle</key>
  <string>manual</string>
  <key>signingCertificate</key>
  <string>Apple Distribution</string>
  <key>installerSigningCertificate</key>
  <string>Mac Installer Distribution: <Company> (<TEAM_ID>)</string>
  <key>destination</key>
  <string>export</string>
  </dict>
</plist>
PLIST

xcodebuild -exportArchive \
  -archivePath build/Runner.xcarchive \
  -exportPath build/export \
  -exportOptionsPlist ExportOptions.plist

pkgutil --check-signature build/export/*.pkg

app-store-connect publish \
  --path build/export/*.pkg \
  --issuer-id <ASC_ISSUER_ID> \
  --key-id <ASC_KEY_ID> \
  --private-key @file:/absolute/path/AuthKey_<KEY_ID>.p8
```

### Troubleshooting

- “Certificate Revoked” on upload: replace the installer certificate with a valid Mac Installer Distribution cert; update secrets.
- “App sandbox not enabled” or “Missing LSApplicationCategoryType”: update entitlements and `Info.plist` and re-run.
- “No profiles found” on export: ensure export method is `app-store-connect` and manual signing with imported certs; Mac App Store packages do not require provisioning profiles.
