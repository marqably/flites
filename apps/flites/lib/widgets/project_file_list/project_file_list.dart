import 'package:flites/types/flites_image.dart';
import 'package:flites/widgets/project_file_list/project_file_item.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

import '../../states/open_project.dart';

class ProjectFileList extends StatefulWidget {
  const ProjectFileList({
    super.key,
  });

  @override
  State<ProjectFileList> createState() => _ProjectFileListState();
}

class _ProjectFileListState extends State<ProjectFileList> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    int i = 0;

    return Watch(
      (context) {
        final isEmpty = projectSourceFiles.value.isEmpty;

        if (isEmpty) {
          return const Center(
              child: Text(
                  'No files added yet. Drag and drop files anywhere on this page.'));
        }

        return ReorderableListView(
          scrollDirection: Axis.horizontal,
          scrollController: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: projectSourceFiles.value.map((file) {
            i++;
            return ProjectFileItem(
              file,
              key: Key('file-$i'),
            );
          }).toList(),
          onReorder: (oldIndex, newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }

            final currentImages = List<FlitesImage>.from(projectSourceFiles
                .value); // TODO(Simon): I think we need to clone this list, no? The following code, especially the setting of the value again, looks like it's already working under the assumption that we have to clone.

            // reorder
            final image = currentImages.removeAt(oldIndex);
            currentImages.insert(newIndex, image);

            projectSourceFiles.value = currentImages;
          },
        );
      },
    );
  }
}
