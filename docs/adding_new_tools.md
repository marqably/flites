# Adding New Tools to the Image Editor

## Overview

Adding a new image manipulation tool to Flites involves creating a new widget that encapsulates the tool's specific logic and UI, while leveraging the core functionalities provided by the `ImageEditor` component. This document outlines the general process and key considerations.

## General Structure

A new tool should be implemented as a Flutter `Widget`. This widget will typically:

1. **Use `ImageEditor` as a Wrapper:** The `ImageEditor` provides the foundational canvas features (pan, zoom, background, reference images, bounding box, gesture handling). Your new tool widget will usually return an `ImageEditor` instance in its `build` method.

   ```dart
   // Example: rotate_tool.dart
   class RotateTool extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       // AppShell is often used, but the core is ImageEditor
       return AppShell(
         child: ImageEditor(
           // Provide tool-specific children or overlays if needed
           stackChildren: const [PlayerControls()],
           // The main interactive part of your tool goes here
           child: _buildRotationControls(context),
         ),
       );
     }

     Widget _buildRotationControls(BuildContext context) {
       // ... implementation for the rotation UI ...
     }
   }
   ```

2. **Provide a `child` Widget:** The `child` parameter of the `ImageEditor` is where the tool-specific UI and interaction logic resides. This child widget will be rendered on top of the core canvas elements provided by `ImageEditor`.

   ```dart
   // Example: move_resize_tool.dart (simplified)
   ImageEditor(
     child: SelectedImageRectWrapper( // Helper to get image bounds
       builder: (currentSelection, selectedImageRect) {
         // TransformableBox is the tool-specific UI for move/resize
         return TransformableBox(
           rect: selectedImageRect,
           onChanged: (result, event) {
             // ... handle resize/move updates ...
           },
           contentBuilder: (context, rect, flip) {
             // Often renders the image itself within the tool area
             return FlitesImageRenderer(flitesImage: currentSelection);
           },
           // ... other TransformableBox properties ...
         );
       },
     ),
     // ... other ImageEditor properties ...
   )
   ```

3. **Manage Tool-Specific State:** Any state required solely for the operation of the new tool (e.g., temporary interaction state) should be managed within the tool's widget itself. (See `RotationWrapper` or `TransformableBox` internal state for complex examples if needed).

4. **Interact with Shared State:** The tool will need to read from and potentially update shared application state, primarily:
    * **Canvas State:** Access canvas properties like scale (`canvasScalingFactor`) and position (`canvasPosition`) via the `canvasController` or its associated signals (`canvas_controller.dart`) to correctly position and scale tool-specific elements.
    * **Selected Image:** Get the `selectedImageId` to know which image(s) the tool should operate on. (Often handled by wrappers like `SelectedImageRectWrapper`).
    * **Image Data (`projectSourceFiles`):** Read the properties (position, size, rotation, etc.) of the selected image from `projectSourceFiles`. When the tool modifies the image, it must update the corresponding `FlitesImage` data within `projectSourceFiles` (likely via the `SourceFilesState` controller).

      ```dart
      // Example: move_resize_tool.dart (within onChanged callback)
      onChanged: (result, event) {
        // Read canvas state for calculations
        final scale = canvasScalingFactor.value;
        final position = canvasPosition.value;

        // Update the FlitesImage object (in-memory)
        currentSelection.updatePositionAndSize(
          result.rect,
          scale,
          position,
        );

        // Persist changes via the state controller
        SourceFilesState.saveImageChanges(currentSelection);
      },
      ```

      ```dart
      // Example: rotate_tool.dart (within RotationWrapper's onRotate)
      RotationWrapper(
        // ... other properties ...
        onRotate: (newAngle) {
          // Update the FlitesImage object (in-memory)
          currentSelection.rotation = newAngle;
          // Note: Persistence might happen elsewhere or via a dedicated save action depending on tool design
        },
        initialRotation: currentSelection.rotation, // Read initial state
        // ... child ...
      )
      ```

## Implementation Steps

1. **Create the Tool Widget:**
    * Define a new `StatelessWidget` or `StatefulWidget` for your tool (e.g., `MyNewTool`).
    * Place the widget file in an appropriate directory, potentially `apps/flites/lib/feature_kits/tools/my_new_tool/my_new_tool.dart`.

2. **Implement the `build` Method:**
    * Return an `ImageEditor` instance.
    * Pass a custom `child` widget to the `ImageEditor`. This child widget will contain the visual elements and interaction logic specific to your tool (e.g., handles, overlays, drawing areas).

3. **Develop the `child` Widget:**
    * This widget is responsible for rendering the tool's UI elements onto the canvas.
    * Use `_CanvasPositioned` or similar logic, incorporating `canvasScalingFactor` and `canvasPosition`, to ensure elements are placed correctly relative to the image and the canvas view. (See `RotationWrapper` implementation for an example of manual positioning).
    * Use `FlitesImageRenderer` if you need to render the image itself within your tool's context, although often the `ImageEditor` handles the primary image rendering.
    * Implement gesture detection (e.g., using `GestureDetector`) within the child to handle user interactions specific to the tool. (See `TransformableBox` or `RotationWrapper` source code for gesture handling examples).

4. **Handle State Updates:**
    * When user interaction modifies the image, update the relevant `FlitesImage` properties in the `projectSourceFiles` state, typically by calling methods on the `SourceFilesState` controller. (See code examples in the "Interact with Shared State" section above).

5. **Register the Tool:**
    * Add an entry for your new tool in the relevant enum or list used by the `toolController` (e.g., `ToolType`).
    * Update the UI (e.g., the toolbar) to allow users to select the new tool.
    * Modify the code that switches between tools (likely managed by `toolController`) to instantiate and display `MyNewTool` when it's selected.

## Example Reference

Refer to existing tools like `MoveResizeTool` (`move_resize_tool.dart`) and `RotateTool` (`rotate_tool.dart`) located in `apps/flites/lib/feature_kits/tools/` for practical examples of how tools are structured and interact with the `ImageEditor` and application state. They demonstrate:
    *Using `ImageEditor` as the base.
    * Providing custom `child` widgets (`TransformableBox`, `RotationWrapper`).
    *Reading canvas state and image data.
    * Updating image properties in `projectSourceFiles`.
