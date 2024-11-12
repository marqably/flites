import 'package:flites/widgets/error_box/error_box.dart';
import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import '../../states/open_project.dart';
import '../../types/flites_image.dart';

class FileDropArea extends StatefulWidget {
  final Widget child;

  const FileDropArea({
    super.key,
    required this.child,
  });

  @override
  State<FileDropArea> createState() => _FileDropAreaState();
}

class _FileDropAreaState extends State<FileDropArea> {
  static const supportedFormats = [
    Formats.jpeg,
    Formats.png,
    Formats.svg,
    Formats.gif,
    Formats.webp,
    Formats.tiff,
    Formats.bmp,
    Formats.ico,
  ];

  List<String> errors = [];

  @override
  Widget build(BuildContext context) {
    return DropRegion(
      // Formats this region can accept.
      formats: supportedFormats,
      hitTestBehavior: HitTestBehavior.opaque,
      onDropOver: (event) {
        // You can inspect local data here, as well as formats of each item.
        // However on certain platforms (mobile / web) the actual data is
        // only available when the drop is accepted (onPerformDrop).
        final item = event.session.items.first;
        if (item.localData is Map) {
          // This is a drag within the app and has custom local data set.
        }
        if (item.canProvide(Formats.plainText)) {
          // this item contains plain text.
        }
        // This drop region only supports copy operation.
        if (event.session.allowedOperations.contains(DropOperation.copy)) {
          return DropOperation.copy;
        } else {
          return DropOperation.none;
        }
      },
      onPerformDrop: (event) async {
        // reset the error messages
        setState(() => errors = []);

        // add all files
        for (int i = 0; i < event.session.items.length; i++) {
          final item = event.session.items[i];
          final reader = item.dataReader!;

          if (reader.canProvide(Formats.png)) {
            reader.getFile(Formats.png, (file) async {
              final stream = file.getStream();
              final data = await stream.last;

              // create a new FlitesImage
              try {
                final flitesImage = FlitesImage(data);

                // add data
                projectSourceFiles.value = [
                  ...projectSourceFiles.value,
                  flitesImage,
                ];
              } catch (e) {
                setState(() => errors.add('Error reading file!\n$e'));
              }
            }, onError: (error) {
              setState(() => errors.add('Error reading file!\n$error'));
            });
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // errors
          ...(errors.map((error) => ErrorBox(errorMessage: error))),

          // drop area
          Container(
            padding: const EdgeInsets.all(40),
            margin: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: Center(
              child: Text('Drop files here!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.primary,
                  )),
            ),
          ),

          // child
          widget.child,
        ],
      ),
    );
  }
}
