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

    return Watch((context) => ReorderableListView(
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
            final currentImages = projectSourceFiles.value;

            // reorder
            final image = currentImages.removeAt(oldIndex);
            currentImages.insert(newIndex, image);

            projectSourceFiles.value = [...currentImages];
          },
        ));
  }
}
