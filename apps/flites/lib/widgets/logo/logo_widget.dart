import 'package:flites/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
        height: Sizes.p32,
        // width: Sizes.p32,
        'assets/images/flites_logo_white.svg');
  }
}
