import 'package:flutter/material.dart';

class ControlHeader extends StatelessWidget {
  const ControlHeader({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: const Color.fromARGB(255, 64, 64, 64),
        ),
      ),
    );
  }
}
