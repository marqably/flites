import 'package:flites/screens/overview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FlitesApp());
}

class FlitesApp extends StatelessWidget {
  const FlitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 172, 233, 255),
          primary: const Color.fromARGB(255, 97, 213, 255),
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Overview(),
      ),
    );
  }
}
