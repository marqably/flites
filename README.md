# Flites

Flites is a modern sprite animation tool built with Flutter that makes creating and editing sprite animations intuitive and efficient. Whether you're a game developer, animator, or digital artist, Flites provides the tools you need to create, edit, and preview sprite animations with precision.

## Features

- 🖼️ Multi-frame sprite editing
- 🎨 Canvas controls with zoom and pan
- 🔄 Rotation and transformation tools
- 👁️ Reference frame overlay system
- 🎯 Precise positioning and scaling
- 🗂️ Drag-and-drop frame reordering
- 🎬 Animation preview
- 📱 Cross-platform support
- 🌍 Multiple language support (English, Spanish, German)

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
