# Flites

Flites is a modern sprite animation tool built with Flutter that makes creating and editing sprite animations intuitive and efficient. You can download the latest version from the [releases page](https://github.com/marqably/flites/releases). Whether you're a game developer, animator, or digital artist, Flites provides the tools you need to create, edit, and preview sprite animations with precision.

## Features

- 🖼️ **Multi-frame sprite editing** with drag-and-drop frame reordering
- 🎨 **Advanced canvas controls** with zoom, pan, and precise positioning
- 🔄 **Transformation tools** for move, resize, and rotate operations
- ��️ **Reference frame overlay system** for comparing animations
- 🎯 **Precise positioning and scaling** with pixel-perfect control
- 💥 **Advanced hitbox editor** with custom collision detection shapes
- 🎬 **Real-time animation preview** with playback controls
- �� **Optimized sprite sheet export** in PNG and SVG formats
- ✨ **Code generation wizards** for Flutter Flame integration
- �� **Automatic hitbox code generation** for game development
- 💾 **Project saving and loading** with `.flites` project files
- 📱 **Cross-platform support** (Windows, macOS, Linux, Web)
- 🌍 **Multi-language support** (English, Spanish, German, French, Italian, Portuguese, Japanese, Korean, Chinese)
- 🖼️ **SVG vector support** for scalable sprite sheets
- 📐 **Customizable tile sizes** for sprite sheet generation
- 🎨 **Visual feedback** for all editing operations

### Intuitive Workflow

![1_intuitive_sprite_creation](https://github.com/user-attachments/assets/bdd1fdd8-4947-4d9c-88a7-371d48b559e0)

### Animation Preview

<https://github.com/user-attachments/assets/a7cf4502-f45c-4221-aeda-f817bb2ea27e>

### Hitbox Editor

<https://github.com/user-attachments/assets/cf54542d-8059-4ba5-859a-dd2db3501a70>

## Quick Start

1. **Download** Flites from the [releases page](https://github.com/marqably/flites/releases)
2. **Import** your sprite frames by dragging and dropping PNG, GIF, or SVG files
3. **Arrange** your frames into animation sequences using the intuitive interface
4. **Edit** with precision using move, resize, rotate, and hitbox tools
5. **Preview** your animations with the built-in player
6. **Export** as optimized PNG or SVG sprite sheets
7. **Generate code** for your game engine (Flutter Flame supported)

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

3. Generate necessary files

    ```bash
    cd apps/flites
    flutter pub get
    ```

4. Run the app

    ```bash
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
