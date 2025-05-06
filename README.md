# Flites

Flites is a modern sprite animation tool built with Flutter that makes creating and editing sprite animations intuitive and efficient. You can download the latest version from the [releases page](https://github.com/marqably/flites/releases). Whether you're a game developer, animator, or digital artist, Flites provides the tools you need to create, edit, and preview sprite animations with precision.

## Features

- 🖼️ Multi-frame sprite editing
- 🎨 Canvas controls with zoom and pan
- 🔄 Rotation and transformation tools
- 👁️ Reference frame overlay system
- 🎯 Precise positioning and scaling
- 🗂️ Drag-and-drop frame reordering
- 💥 Custom hitbox editor and export
- 🎬 Animation preview
- 📦 Optimized multi-animation sprite sheet export
- ✨ Code generation wizards for easy integration
- 💾 Project saving and loading
- 📱 Cross-platform support
- 🌍 Multiple language support (English, Spanish, German, French, Italian, Portuguese, Japanese, Korean, Chinese)

## Development

This project uses [Melos](https://melos.invertase.dev/) to manage the monorepo and its packages. Here's how to get started:

### Prerequisites

- Flutter 3.27.2 or higher
- Melos (`dart pub global activate melos`)
- Your favorite IDE

### Setup

1. Clone the repository

    ```bash
    git clone https://github.com/marqably/flites.git
    ```

2. Install dependencies

    ```bash
    melos bootstrap
    ```

3. Run the app

    ```bash
    cd apps/flites
    flutter run
    ```

### Project Structure

```text
flites/
├── apps/
│   └── flites/         # Main application
├── docs/               # Documentation
└── melos.yaml          # Melos configuration
```

### Common Tasks

- **Quality Check**: `melos run qualitycheck`
- **Linting**: `melos run lint`
- **Analyzing Code**: `melos run analyze`
- **Formatting Code**: `melos run format`
- **Running Tests**: `melos run test:all`
- **Fix Common Issues**: `melos run fix`

### Adding New Features

1. Create a new branch from `main`
2. Make your changes
3. Add tests for new functionality
4. Run `melos run analyze` and `melos run test`
5. Submit a PR with a clear description of your changes

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Documentation

- [UI Layouting](docs/ui-layouting.md) - Documentation for panels, controls, and inputs
- [Panel Forms](docs/panel-forms.md) - Guide to creating and managing forms within panels
- [Adding New Tools](docs/adding_new_tools.md) - Guide for extending the editor with new image manipulation tools
- [Adding New Code Wizards](docs/adding_new_code_wizards.md) - Guide for adding new code generation targets
