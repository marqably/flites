# Flites

Flites is a modern sprite animation tool built with Flutter that makes creating and editing sprite animations intuitive and efficient. You can download the latest version from the [releases page](https://github.com/marqably/flites/releases). Whether you're a game developer, animator, or digital artist, Flites provides the tools you need to create, edit, and preview sprite animations with precision.

## Try it now 🎮

You can quickly try it using our web version without installing anything:
[web.flites.app](https://web.flites.app)

If you want to play around, you can download and import our [demo flites project](./docs/demo-assets/valkyr.flites).
To import, just go to [web.flites.app](https://web.flites.app), click the flites logo (top left) and click "Open project".

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

Here's how to get started with development:

### Prerequisites

- Flutter 3.27.2 or higher
- Your favorite IDE

### Setup

1. Clone the repository

    ```bash
    git clone https://github.com/marqably/flites.git
    ```

2. Copy env file

    ```bash
    cp .env.example .env
    ```

3. Install dependencies

    ```bash
    flutter pub get
    ```

4. Run the app

    ```bash
    flutter run
    ```

### Project Structure

```text
flites/
├── lib/                # Main application source code
├── docs/               # Documentation
├── test/               # Tests
└── pubspec.yaml        # Flutter project configuration
```

### Common Tasks

- **Quality Check**: `flutter analyze && flutter test`
- **Linting**: `flutter analyze`
- **Analyzing Code**: `flutter analyze`
- **Formatting Code**: `dart format .`
- **Running Tests**: `flutter test`
- **Fix Common Issues**: `dart fix --apply`

### Adding New Features

1. Create a new branch from `main`
2. Make your changes
3. Add tests for new functionality
4. Run `flutter analyze` and `flutter test`
5. Submit a PR with a clear description of your changes

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the AGPL-3.0 License - see the [LICENSE](LICENSE) file for details.

## Documentation

- [UI Layouting](docs/ui-layouting.md) - Documentation for panels, controls, and inputs
- [Panel Forms](docs/panel-forms.md) - Guide to creating and managing forms within panels
- [Adding New Tools](docs/adding_new_tools.md) - Guide for extending the editor with new image manipulation tools
- [Adding New Code Wizards](docs/adding_new_code_wizards.md) - Guide for adding new code generation targets
