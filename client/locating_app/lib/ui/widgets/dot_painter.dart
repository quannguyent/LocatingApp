import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DotPainter extends CustomPainter {
  final int width;
  final Color color;

  DotPainter({this.width, this.color});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..isAntiAlias = true;

    var borderPaint = Paint()..color = Colors.white.withOpacity(0.9);
    Offset center = Offset(width / 2, width / 2);

    canvas.drawCircle(center, width / 2, borderPaint);
    canvas.drawCircle(center, width / 2 - 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}