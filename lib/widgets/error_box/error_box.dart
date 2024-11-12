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
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Text(
        errorMessage,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
