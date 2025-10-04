# Contributing to Flites

Thank you for your interest in contributing to Flites! 🎉

## Quick Links

- 📖 [Detailed Contributing Guide](docs/contributing.md)
- 🐛 [Report a Bug](https://github.com/marqably/flites/issues/new)
- 💡 [Request a Feature](https://github.com/marqably/flites/issues/new)
- 💬 [Join the Discussion](https://github.com/marqably/flites/discussions)

## Getting Started

1. Fork the repository
2. Run `flutter pub get` to set up dependencies
3. Create your feature branch (`git checkout -b feature/amazing-feature`)
4. Make your changes
5. Run tests (`flutter test`)
6. Submit a Pull Request

## Pre-PR Checklist

Before submitting your Pull Request, please run these checks locally:

```bash
# Run all of these commands from the root directory
dart format .          # Format your code
flutter analyze        # Check for analysis issues
flutter test           # Run all tests
flutter analyze && flutter test  # Run all quality checks
```

If any of these checks fail:

1. Read the error messages carefully
2. Try `dart fix --apply` to auto-fix common issues
3. Ask for help if you're stuck!

## Need Help?

We're here to help! Feel free to:

- Open an issue with questions
- Ask in discussions
- Comment on existing issues

Check out our [detailed contributing guide](docs/contributing.md) for more information.

Remember: Every contribution matters, and we're excited to have you here! 💙
