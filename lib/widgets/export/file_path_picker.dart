import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class FilePathPicker extends StatefulWidget {
  const FilePathPicker({
    super.key,
    required this.onPathSelected,
    this.initialPath,
  });

  final void Function(String path) onPathSelected;
  final String? initialPath;

  @override
  State<FilePathPicker> createState() => _FilePathPickerState();
}

class _FilePathPickerState extends State<FilePathPicker> {
  late final TextEditingController _controller;
  late String selectedPath;
  bool isSelectedPathInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    // Initialize with widget's initial path if provided
    selectedPath = widget.initialPath ?? '';
    isSelectedPathInitialized = widget.initialPath != null;
    // Set up initial path if needed
    if (!isSelectedPathInitialized) {
      _initDefaultPath();
    }
  }

  Future<void> _initDefaultPath() async {
    final downloadsDir = await getDownloadsDirectory();
    if (downloadsDir != null) {
      setState(() {
        selectedPath = downloadsDir.path;
        isSelectedPathInitialized = true;
      });
      widget.onPathSelected(selectedPath);
    }
  }

  Future<void> _pickDirectory() async {
    final result = await FilePicker.platform.getDirectoryPath();

    if (result != null) {
      setState(() {
        selectedPath = result;
        isSelectedPathInitialized = true;
      });
      widget.onPathSelected(selectedPath);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickDirectory,
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(Sizes.p4),
        ),
        child: Row(
          children: [
            gapW8,
            Expanded(
              child: Text(
                selectedPath,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            gapW8,
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: context.colors.surfaceContainer,
                borderRadius: BorderRadius.circular(Sizes.p4),
              ),
              child: const Icon(Icons.folder_open_outlined, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
