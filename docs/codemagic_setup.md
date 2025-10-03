# Codemagic Setup Guide

This guide explains how to set up Codemagic for building and publishing the Flites macOS app to the App Store.

## Prerequisites

- Apple Developer Account with App Manager access
- Codemagic account
- Flites project configured in Codemagic

## Step 1: Create App Store Connect API Key

### In Apple Developer Portal

1. **Navigate to Apple Developer Portal**:
   - Go to [developer.apple.com](https://developer.apple.com)
   - Sign in with your Apple Developer account

2. **Create API Key**:
   - Go to **Account** → **Users and Access** → **Keys**
   - Click the **"+"** button to create a new key
   - **Name**: Give it a descriptive name (e.g., "Flites Codemagic Integration")
   - **Access**: Select **App Manager** role (required for publishing)
   - Click **Generate**

3. **Download and Note Details**:
   - Download the `.p8` file (keep it secure!)
   - Note the **Key ID** (10-character string, e.g., `ABC123DEF4`)
   - Note the **Issuer ID** (found in the Keys section, e.g., `12345678-1234-1234-1234-123456789012`)

## Step 2: Configure Codemagic Environment Variables

### In Codemagic Dashboard

1. **Navigate to Variable Groups**:
   - Go to your Codemagic dashboard
   - Click on **Team Settings** → **Variable groups**
   - Find or create the **"production"** variable group

2. **Add Required Variables**:

   Add these three encrypted environment variables to your **"production"** variable group:

   | Variable Name | Description | Example Value |
   |---------------|-------------|---------------|
   | `APP_STORE_CONNECT_API_KEY` | Content of the `.p8` file | `-----BEGIN PRIVATE KEY-----\nMIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQg...\n-----END PRIVATE KEY-----` |
   | `APP_STORE_CONNECT_KEY_ID` | 10-character Key ID from Apple | `ABC123DEF4` |
   | `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID from Apple Developer Portal | `12345678-1234-1234-1234-123456789012` |

3. **Variable Configuration**:
   - **Encrypt**: Make sure all three variables are marked as **encrypted**
   - **Environment**: Set to **macOS** (or **All** if used across platforms)
   - **Group**: Ensure they're in the **"production"** group

## Step 3: Verify Configuration

### Check codemagic.yaml

The `codemagic.yaml` file should reference the production variable group:

```yaml
workflows:
  macos-release:
    name: macOS Release Build
    max_build_duration: 60
    instance_type: mac_mini_m1
    environment:
      vars:
        FLUTTER_VERSION: "3.24.0"
        XCODE_VERSION: "15.4"
        COCOAPODS_VERSION: "1.15.2"
      groups:
        - production  # This loads the production variable group
      flutter: stable
      xcode: latest
      cocoapods: default
    # ... scripts section ...
    publishing:
      app_store_connect:
        auth: api_key
        api_key: $APP_STORE_CONNECT_API_KEY
        key_id: $APP_STORE_CONNECT_KEY_ID
        issuer_id: $APP_STORE_CONNECT_ISSUER_ID
        submit_to_testflight: false
        submit_to_app_store: true
```

## Step 4: Test the Setup

1. **Trigger a Build**:
   - Go to your Codemagic workflow
   - Trigger a test build to verify the configuration

2. **Check Build Logs**:
   - Look for successful App Store Connect authentication
   - Verify that the publishing step completes without errors

## Troubleshooting

### Common Issues

1. **"App Store Connect integration does not exist"**:
   - Ensure you're using `auth: api_key` instead of `auth: integration`
   - Verify the variable group name matches exactly

2. **"Invalid API key"**:
   - Double-check the `.p8` file content in `APP_STORE_CONNECT_API_KEY`
   - Ensure the Key ID and Issuer ID are correct
   - Verify the API key has App Manager permissions

3. **"Variable not found"**:
   - Check that variables are in the "production" group
   - Ensure variable names match exactly (case-sensitive)
   - Verify variables are marked as encrypted

### Security Notes

- **Never commit** the `.p8` file or API credentials to version control
- **Keep the API key secure** - it provides access to your App Store Connect account
- **Rotate keys periodically** for security best practices
- **Use encrypted variables** in Codemagic to protect sensitive data

## Additional Resources

- [Codemagic App Store Connect Publishing](https://docs.codemagic.io/yaml-publishing/app-store-connect/)
- [Apple Developer API Keys](https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api)
- [Codemagic Environment Variables](https://docs.codemagic.io/variables/environment-variable-groups/)

## Support

If you encounter issues with the setup:

1. Check the Codemagic build logs for specific error messages
2. Verify all environment variables are correctly configured
3. Ensure your Apple Developer account has the necessary permissions
4. Contact Codemagic support if the issue persists
