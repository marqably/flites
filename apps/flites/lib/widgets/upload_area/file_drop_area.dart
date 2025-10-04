import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

import '../../states/source_files_state.dart';
import '../../utils/flites_image_factory.dart';

class FileDropArea extends StatefulWidget {
  const FileDropArea({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  State<FileDropArea> createState() => _FileDropAreaState();
}

class _FileDropAreaState extends State<FileDropArea> {
  bool isDragging = false;

  @override
  Widget build(BuildContext context) => DropTarget(
        onDragEntered: (event) {
          setState(() {
            isDragging = true;
          });
        },
        onDragExited: (event) {
          setState(() {
            isDragging = false;
          });
        },
        onDragDone: (event) async {
          if (event.files.isNotEmpty) {
            final result =
                await flitesImageFactory.processDroppedFiles(event.files);
            if (result.isNotEmpty) {
              await SourceFilesState.addImages(droppedImages: result);
            }
          }
          setState(() {
            isDragging = false;
          });
        },
        child: Stack(
          children: [
            Positioned.fill(child: widget.child),
            if (isDragging)
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.6),
                      Color.fromRGBO(2, 0, 38, 0.6),
                      Color.fromRGBO(5, 0, 88, 0.6),
                    ],
                    stops: [0.0, 0.46, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Drop files here',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}
