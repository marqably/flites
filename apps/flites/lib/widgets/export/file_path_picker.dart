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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _initDefaultPath();
  }

  Future<void> _initDefaultPath() async {
    final downloadsDir = await getDownloadsDirectory();
    if (downloadsDir != null) {
      _controller.text = downloadsDir.path;
      widget.onPathSelected(downloadsDir.path);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDirectory() async {
    final result = await FilePicker.platform.getDirectoryPath();

    if (result != null) {
      _controller.text = result;
      widget.onPathSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              isDense: true,
              filled: true,
              fillColor: context.colors.surface,
            ),
            onChanged: widget.onPathSelected,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.folder_open_outlined),
          tooltip: context.l10n.selectLocation,
          onPressed: _pickDirectory,
        ),
      ],
    );
  }
}
