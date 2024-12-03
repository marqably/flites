import 'package:flites/screens/overview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flites',
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
