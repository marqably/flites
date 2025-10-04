# Release Process Documentation

This document outlines the complete process for creating production releases of Flites.

## Overview

Flites uses GitHub Actions workflows to automatically build and release the application across multiple platforms when a Git tag is pushed. The release process is triggered by tags that follow the semantic versioning pattern (e.g., `v1.0.0`).

## Release Workflow Architecture

### Trigger

- **Event**: Push of a tag matching pattern `v*` (e.g., `v1.0.0`, `v1.2.3-beta`)
- **Workflow**: `.github/workflows/release.yaml`

### Build Jobs

The release workflow calls multiple platform-specific build workflows:

1. **Linux AppImage** (`.github/workflows/appimage_build.yaml`)
   - Creates portable AppImage executable
   - Includes desktop integration files
   - Tests in Docker container

2. **Linux Debian** (`.github/workflows/debian_build.yaml`)
   - Creates `.deb` package for Debian/Ubuntu systems
   - Includes proper dependencies and desktop integration
   - Tests installation in Docker container

3. **Windows** (`.github/workflows/windows_build.yaml`)
   - Creates ZIP archive with Windows executable
   - Tests executable functionality

4. **macOS** (`.github/workflows/macos_build.yaml`)
   - Triggers Codemagic build via webhook
   - Currently uses placeholder until Codemagic integration is complete

5. **Web** (`.github/workflows/web_build.yaml`)
   - Creates ZIP archive for web deployment
   - Includes all necessary web assets

### Release Publishing

- Collects all build artifacts
- Creates GitHub Release with comprehensive release notes
- Uploads platform-specific packages as release assets

## How to Create a Release

### Prerequisites

1. **Update Version Numbers**

   ```bash
   # Update version in pubspec.yaml
   # Current version: 0.0.6
   # For release 1.0.0, change to: version: 1.0.0
   ```

2. **Update CHANGELOG.md**

   ```bash
   # Add new section for the release
   # Move items from [Unreleased] to new version section
   # Update dates
   ```

3. **Test the Build**

   ```bash
   # Test locally or via PR to ensure everything works
   melos run qualitycheck
   melos run test:all
   ```

### Release Steps

1. **Create and Push Tag**

   ```bash
   # Create annotated tag
   git tag -a v1.0.0 -m "Release version 1.0.0"
   
   # Push tag to trigger release workflow
   git push origin v1.0.0
   ```

2. **Monitor Workflow**
   - Go to GitHub Actions tab
   - Watch the "Create Release" workflow
   - All platform builds must succeed before release is published

3. **Verify Release**
   - Check GitHub Releases page
   - Verify all platform packages are uploaded
   - Test downloads on different platforms

### Release Types

#### Production Release

- **Tag Format**: `v1.0.0`, `v1.2.3`
- **Behavior**: Creates stable release
- **Prerelease**: `false`

#### Pre-release/Beta

- **Tag Format**: `v1.0.0-beta`, `v1.2.3-alpha`
- **Behavior**: Creates pre-release (marked as prerelease)
- **Prerelease**: `true` (automatically detected)

## Build Configuration

The build process uses `.github/build_config.yaml` to determine:

- File naming conventions
- Artifact upload names
- Platform-specific templates

### Version Management

- **Release builds**: Use tag version (e.g., `v1.0.0` → `1.0.0`)
- **PR builds**: Use `0.0.0-pr{PR_NUMBER}`
- **Manual builds**: Use `0.0.0-manual{RUN_ID}`

## Platform-Specific Details

### Linux

- **AppImage**: Portable executable, no installation required
- **Debian**: Traditional package manager installation
- **Dependencies**: GTK3, standard C++ libraries

### Windows

- **Format**: ZIP archive
- **Executable**: `flites.exe`
- **Requirements**: Windows 10+

### macOS

- **Status**: In development (Codemagic integration)
- **Current**: Placeholder artifact
- **Future**: Native macOS app bundle

### Web

- **Format**: ZIP archive
- **Usage**: Extract and open `index.html`
- **Requirements**: Modern web browser

## Troubleshooting

### Common Issues

1. **Build Failures**
   - Check GitHub Actions logs
   - Verify Flutter version compatibility
   - Ensure all dependencies are available

2. **Missing Artifacts**
   - Verify all platform workflows completed successfully
   - Check artifact upload names match configuration

3. **Release Not Created**
   - Ensure tag format is correct (`v*`)
   - Check workflow permissions
   - Verify all required jobs completed

### Debugging

1. **Manual Workflow Trigger**

   ```bash
   # Use workflow_dispatch to test builds manually
   # Go to Actions → Select workflow → Run workflow
   ```

2. **Local Testing**

   ```bash
   # Test individual platform builds locally
   cd apps/flites
   flutter build linux --release
   flutter build windows --release
   flutter build web --release
   ```

## Security Considerations

- **Secrets**: Codemagic webhook URL stored in repository secrets
- **Permissions**: Workflow has `contents: write` permission for releases
- **Artifacts**: All build artifacts are publicly available in releases

## Future Improvements

1. **macOS Integration**: Complete Codemagic integration for native macOS builds
2. **Code Signing**: Add code signing for Windows and macOS
3. **Automated Testing**: Add automated testing of release artifacts
4. **Release Automation**: Consider automated version bumping and changelog generation

## Contact

For questions about the release process, contact the development team or create an issue in the repository.
