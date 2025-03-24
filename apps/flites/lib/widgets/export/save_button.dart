import 'package:flites/services/project_saving_service.dart';
import 'package:flites/widgets/buttons/stadium_button.dart';
import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return StadiumButton(
      text: 'Save Project',
      onPressed: () {
        ProjectSavingService().saveProject();
      },
    );
  }
}
