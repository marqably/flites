# Codemagic Setup Guide

This guide explains how to set up Codemagic for building and publishing the Flites macOS app to the App Store using the visual workflow editor.

## Prerequisites

- Apple Developer Account with App Manager access
- Codemagic account
- Flites project repository

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

## Step 2: Set Up Codemagic Project

### Create New Project

1. **Navigate to Codemagic Dashboard**:
   - Go to [codemagic.io](https://codemagic.io)
   - Sign in to your account

2. **Add New Project**:
   - Click **"Add application"**
   - Connect your Git provider (GitHub, GitLab, Bitbucket)
   - Select the **Flites repository**
   - Choose **macOS** as the target platform

3. **Configure Project Settings**:
   - **Project name**: `Flites macOS`
   - **Repository**: Your Flites repository
   - **Platform**: macOS
   - **Build type**: App Store

## Step 3: Configure Visual Workflow

### Using Codemagic Visual Editor

1. **Open Workflow Editor**:
   - Go to your project in Codemagic
   - Click **"Workflow editor"** tab
   - Select **macOS** workflow

2. **Set Up Environment Variables**:
   - Go to **Environment variables** section
   - Add these encrypted variables:
     - `APP_STORE_CONNECT_API_KEY` - Content of the `.p8` file
     - `APP_STORE_CONNECT_KEY_ID` - The 10-character Key ID
     - `APP_STORE_CONNECT_ISSUER_ID` - The Issuer ID
   - Mark all as **encrypted** and set environment to **macOS**

3. **Configure Build Steps**:
   - **Flutter version**: `3.24.0`
   - **Xcode version**: `15.4`
   - **CocoaPods version**: `1.15.2`

4. **Set Up Code Signing**:
   - Enable **Automatic code signing**
   - Use your Apple Developer Portal integration
   - Configure for **Mac App Store** distribution

5. **Configure Publishing**:
   - Enable **App Store Connect** publishing
   - Set **Submit to App Store**: `true`
   - Set **Submit to TestFlight**: `false`
   - Use the App Store Connect API key variables

## Step 4: Workflow Configuration Details

### Build Configuration

- **Instance type**: `mac_mini_m1` (recommended for macOS builds)
- **Max build duration**: `60 minutes`
- **Flutter**: `stable`
- **Xcode**: `latest`
- **CocoaPods**: `default`

### Build Steps (in order)

1. **Set up keychain** - Initialize keychain for code signing
2. **Fetch signing files** - Download certificates and provisioning profiles
3. **Install Flutter dependencies** - Run `flutter packages pub get`
4. **Install CocoaPods dependencies** - Run `pod install`
5. **Flutter analyze** - Run `flutter analyze`
6. **Flutter unit tests** - Run `flutter test`
7. **Build macOS app** - Run `flutter build macos --release --no-codesign`
8. **Code sign macOS app** - Sign the app with entitlements
9. **Create archive** - Package the app for distribution

### Artifacts

- **Output**: `apps/flites/build/macos/Build/Products/Release/flites-macos.zip`

## Step 5: Test the Setup

1. **Trigger a Build**:
   - Go to your Codemagic workflow
   - Click **"Start new build"**
   - Select the appropriate branch/tag

2. **Monitor Build Progress**:
   - Watch the build logs in real-time
   - Check for successful App Store Connect authentication
   - Verify that the publishing step completes without errors

## Troubleshooting

### Common Issues

1. **"App Store Connect integration not found"**:
   - Ensure you've created the App Store Connect integration in Codemagic
   - Verify the API key has App Manager permissions
   - Check that all environment variables are correctly set

2. **"Code signing failed"**:
   - Verify your Apple Developer Portal integration is properly configured
   - Ensure certificates and provisioning profiles are valid
   - Check that the bundle identifier matches your App Store Connect app

3. **"Build failed"**:
   - Check Flutter and Xcode versions are compatible
   - Verify all dependencies are properly installed
   - Review build logs for specific error messages

### Security Notes

- **Never commit** the `.p8` file or API credentials to version control
- **Keep the API key secure** - it provides access to your App Store Connect account
- **Use encrypted variables** in Codemagic to protect sensitive data
- **Rotate keys periodically** for security best practices

## Additional Resources

- [Codemagic Visual Workflow Editor](https://docs.codemagic.io/getting-started/building-a-flutter-app/)
- [Codemagic macOS Configuration](https://docs.codemagic.io/yaml-publishing/app-store-connect/)
- [Apple Developer API Keys](https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api)

## Support

If you encounter issues with the setup:

1. Check the Codemagic build logs for specific error messages
2. Verify all environment variables are correctly configured
3. Ensure your Apple Developer account has the necessary permissions
4. Contact Codemagic support if the issue persists
