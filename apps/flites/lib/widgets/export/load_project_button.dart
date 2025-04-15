import 'package:flites/services/project_saving_service.dart';
import 'package:flites/widgets/buttons/stadium_button.dart';
import 'package:flutter/material.dart';

class LoadProjectButton extends StatelessWidget {
  const LoadProjectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return StadiumButton(
      text: 'Load Project',
      onPressed: () async {
        final projectState = await ProjectSavingService().loadProjectFile();
        if (projectState != null) {
          ProjectSavingService().setProjectState(projectState);
        }
      },
    );
  }
}
