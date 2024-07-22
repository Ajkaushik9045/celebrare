import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FramedImage extends StatefulWidget {
  final String imagePath;
  final String framePath;

  const FramedImage({
    super.key,
    required this.imagePath,
    required this.framePath,
  });

  @override
  _FramedImageState createState() => _FramedImageState();
}

class _FramedImageState extends State<FramedImage> {
  ui.Image? frameImage;

  @override
  void didUpdateWidget(covariant FramedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.framePath != oldWidget.framePath) {
      _loadFrameImage();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFrameImage();
  }

  Future<void> _loadFrameImage() async {
    if (widget.framePath.isEmpty) {
      // Handle the case where no frame is applied
      setState(() {
        frameImage = null;
      });
      return;
    }

    final ByteData data = await rootBundle.load(widget.framePath);
    final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo fi = await codec.getNextFrame();
    setState(() {
      frameImage = fi.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (frameImage == null && widget.framePath.isNotEmpty) {
      return const CircularProgressIndicator();
    }

    return AspectRatio(
      aspectRatio: 1, // Adjust this if your frames have a different aspect ratio
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            File(widget.imagePath),
            fit: BoxFit.cover,
          ),
          if (frameImage != null)
            CustomPaint(
              painter: FramePainter(frameImage!),
            ),
        ],
      ),
    );
  }
}

class FramePainter extends CustomPainter {
  final ui.Image frameImage;

  FramePainter(this.frameImage);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..blendMode = BlendMode.dstIn;

    canvas.drawImageRect(
      frameImage,
      Rect.fromLTWH(0, 0, frameImage.width.toDouble(), frameImage.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
