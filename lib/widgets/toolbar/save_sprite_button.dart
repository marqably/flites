import 'package:flites/states/open_project.dart';
import 'package:flites/utils/generate_sprite.dart';
import 'package:flutter/material.dart';

class SaveSpriteButton extends StatelessWidget {
  const SaveSpriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        final generator = GenerateSprite(projectSourceFiles.value);
        generator.save();
      },
      child: const Text('Save Sprite'),
    );
  }
}
