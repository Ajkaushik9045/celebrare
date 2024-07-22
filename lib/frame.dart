import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class FramePainter extends CustomPainter {
  final ui.Image frameImage;

  FramePainter(this.frameImage);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..blendMode = BlendMode.dstIn;

    canvas.drawImageRect(
      frameImage,
      Rect.fromLTWH(
          0, 0, frameImage.width.toDouble(), frameImage.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
