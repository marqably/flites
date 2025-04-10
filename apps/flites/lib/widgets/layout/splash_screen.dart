import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(0, 0, 0, 1),
            Color.fromRGBO(2, 0, 38, 1),
            Color.fromRGBO(5, 0, 88, 1),
          ],
          stops: [0.0, 0.46, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/images/flites_logo_with_text.svg',
          width: 360,
        ),
      ),
    );
  }
}
