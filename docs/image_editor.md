# Image Editor Documentation

## Overview

The image editor is a core component of Flites that provides a canvas-based interface for manipulating images. It acts as a foundation layer, handling common canvas operations like panning, zooming, background rendering, reference images, and bounding boxes. Specific image manipulation tools (like Move/Resize, Rotate) are built as separate widgets that utilize the `ImageEditor`.

## Component Structure

### Core Components

- `ImageEditor`: The main container component. Provides the shared canvas features (pan/zoom, background, reference images, bounding box, gesture handling) and renders a tool-specific `child` widget.
- `FlitesImageRenderer`: A reusable component for rendering both SVG and bitmap images, often used within the tool-specific child widgets.
- `_CanvasBoundingBox`: (Part of `ImageEditor`) Displays the bounding box for the selected image(s).
- `_CanvasReferenceImage`: (Part of `ImageEditor`) Renders reference images on the canvas.
- `_CanvasPositioned`: (Part of `ImageEditor`) A utility component for positioning elements correctly on the scaled and panned canvas.
- `_CanvasGestureHandler`: (Part of `ImageEditor`) Handles pan and zoom gestures for the canvas itself.

### Tool Widgets (Examples)

Separate widgets implement the logic and UI for specific tools. These widgets typically use `ImageEditor` as a wrapper and provide their interactive elements as the `child`.

- `MoveResizeTool`: Uses `ImageEditor` and provides a `TransformableBox` as the child to handle image moving and resizing via handles.
- `RotateTool`: Uses `ImageEditor` and provides a `RotationWrapper` as the child to manage image rotation via a visual control.
- *(Other tools like HitboxTool follow a similar pattern)*

## Features

### Canvas Control (Provided by `ImageEditor`)

- Pan/zoom functionality with mouse controls (via `_CanvasGestureHandler`).
- Canvas scaling with modifier key + scroll.
- Grabbing mode for canvas navigation.
- Background rendering.
- Reference image support with opacity overlay (via `_CanvasReferenceImage`).
- Bounding box visualization for sprite sheets (via `_CanvasBoundingBox`).
- Zoom controls UI.

### Image Manipulation (Provided by Tool Widgets)

- **Move and Resize:** Handled by `MoveResizeTool` using `TransformableBox` (corner handles).
- **Rotation:** Handled by `RotateTool` using `RotationWrapper` (visual rotation control).
- *(Other manipulations handled by their respective tool widgets)*

### Image Support

- SVG files with validation
- PNG images
- GIF files with frame extraction
- Automatic scaling and positioning

## State Management

The editor and related tools use several state controllers/signals:

- `canvasController` / signals in `canvas_controller.dart`: Manages canvas position (`canvasPosition`), scale (`canvasScalingFactor`), and size (`canvasSizePixel`). Also includes `showBoundingBorder`.
- `toolController`: Handles active tool selection (`selectedTool`).
- `selectedImageState` / `selectedImageId`: Tracks the currently selected image ID.
- `selectedReferenceImages`: Manages reference image IDs for overlays.
- `projectSourceFiles`: Holds the main image data for the project, including position, size, rotation etc. Updated by tools via `SourceFilesState`.

## Usage Example

1. Select an image from the project file list.
2. Choose a tool (Move, Rotate, etc.) from the toolbar. This loads the corresponding tool widget which uses `ImageEditor`.
3. Use mouse interactions specific to the active tool:
    - Click and drag background to pan the canvas (handled by `ImageEditor`).
    - Use modifier key + scroll to zoom (handled by `ImageEditor`).
    - Use corner handles to resize (handled by `MoveResizeTool`'s child).
    - Use rotation control to rotate (handled by `RotateTool`'s child).

## Implementation Details

### Canvas Positioning

Images and UI elements within the canvas are positioned using `_CanvasPositioned` or similar logic, taking into account:

- `canvasScalingFactor` signal
- `canvasPosition` signal
- Image properties (position, dimensions) from `projectSourceFiles` or temporary state.

### Image Rendering

The `FlitesImageRenderer` component, typically used within the tool's child widget, handles:

- Automatic detection of image type (SVG/bitmap)
- Applying transformations based on `FlitesImage` properties and `canvasScalingFactor`.
- Consistent rendering across different image formats.
