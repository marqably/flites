import 'package:flites/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class ErrorBox extends StatelessWidget {
  final String errorMessage;

  const ErrorBox({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
}
