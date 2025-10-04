import 'package:flutter/material.dart';

class ScalingInfo {
  ScalingInfo({required this.axis, required this.factor});

  ScalingInfo.same()
      : axis = Axis.vertical,
        factor = 1;
  final Axis axis;
  final double factor;
}
