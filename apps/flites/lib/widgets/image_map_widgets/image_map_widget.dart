import 'package:flites/main.dart';
import 'package:flites/states/selected_image_row_state.dart';
import 'package:flites/states/source_files_state.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class ImageMapWidget extends StatelessWidget {
  const ImageMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final imageMap = projectSourceFiles.value;
      final selectedRowIndex = selectedImageRow.value;

      return Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 39, 39, 39),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: imageMap.rows.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: selectedRowIndex == index
                    ? BoxDecoration(color: context.colors.onSurface)
                    : null,
                child: TextButton(
                  child: Text(
                    imageMap.rows[index].name,
                  ),
                  onPressed: () {
                    SelectedImageRowState.setSelectedImageRow(index);
                  },
                ),
              );
            },
          ),
          const SizedBox(
            height: 24,
          ),
          TextButton(
            onPressed: () {
              SourceFilesState.addImageRow('New Row');
            },
            child: const Text('Create new Row'),
          ),
        ],
      );
    });
  }
}
