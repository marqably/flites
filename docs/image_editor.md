# Image Editor Documentation

## Overview

The image editor is a core component of Flites that provides a canvas-based interface for manipulating images. It supports multiple tools and modes for image manipulation, including canvas mode, move/resize mode, and rotation mode.

## Component Structure

### Main Components

- `ImageEditor`: The main container component
- `FlitesImageRenderer`: A reusable component for rendering both SVG and bitmap images
- `CanvasPositioned`: A utility component for positioning elements on the canvas

### Tool-specific Components

The editor is organized into tool-specific canvas components:

- `_CanvasModeToolCanvas`: Handles basic image display
- `_MoveResizeToolCanvas`: Handles image moving and resizing
- `_RotateToolCanvas`: Manages image rotation

## Features

### Canvas Control

- Pan/zoom functionality with mouse controls
- Canvas scaling with modifier key + scroll
- Grabbing mode for canvas navigation

### Image Manipulation

- Move and resize with corner handles
- Rotation with visual rotation control
- Reference image support with opacity overlay
- Bounding box visualization for sprite sheets

### Image Support

- SVG files with validation
- PNG images
- GIF files with frame extraction
- Automatic scaling and positioning

## State Management

The editor uses several state controllers:

- `canvasController`: Manages canvas position, scale, and size
- `toolController`: Handles active tool selection
- `selectedImageState`: Tracks currently selected image
- `selectedReferenceImages`: Manages reference image overlays

## Usage Example

1. Select an image from the project file list
2. Choose a tool (Canvas, Move, or Rotate)
3. Use mouse interactions to manipulate the image:
   - Click and drag to move the canvas
   - Use corner handles to resize (in move mode)
   - Use rotation control to rotate (in rotate mode)
   - Hold modifier key + scroll to zoom

## Implementation Details

### Canvas Positioning

Images are positioned using a coordinate system that takes into account:

- Canvas scaling factor
- Canvas position
- Image position
- Image dimensions

### Image Rendering

The `FlitesImageRenderer` component handles:

- Automatic detection of image type (SVG/bitmap)
- Proper scaling and transformation
- Rotation and positioning
- Consistent rendering across different image formats
