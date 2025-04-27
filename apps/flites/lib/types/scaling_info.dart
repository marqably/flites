import 'package:flutter/material.dart';

class ScalingInfo {
  final Axis axis;
  final double factor;

  ScalingInfo({required this.axis, required this.factor});

  ScalingInfo.same()
      : axis = Axis.vertical,
        factor = 1;
}
