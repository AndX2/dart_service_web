import 'dart:math';

import 'package:flutter/material.dart';

const _defaultColor = Colors.red;

class ArcPainter extends CustomPainter {
  final Color color;
  final double _value;
  final Paint _paint;

  ArcPainter(
    this._value,
    double width, {
    this.color = _defaultColor,
  }) : _paint = Paint()
          ..color = color
          ..strokeWidth = width
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset(0.0, 0.0) & size;
    canvas.drawArc(rect, -pi / 2, -2 * pi * _value, false, _paint);
  }

  @override
  bool shouldRepaint(ArcPainter oldDelegate) => false;
}
