import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';

class ErrorBox extends StatelessWidget {
  const ErrorBox({
    required this.errorMessage,
    super.key,
  });
  final String errorMessage;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(Sizes.p8),
        margin: const EdgeInsets.symmetric(vertical: Sizes.p8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(Sizes.p8),
          border: Border.all(color: Colors.red),
        ),
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red),
        ),
      );
}
