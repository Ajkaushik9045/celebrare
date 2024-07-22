import 'dart:io';
import 'dart:ui' as ui;

import 'package:celebrare/frame.dart';
import 'package:celebrare/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageSelectionDialog extends StatefulWidget {
  final String imagePath;

  const ImageSelectionDialog({super.key, required this.imagePath});

  @override
  _ImageSelectionDialogState createState() => _ImageSelectionDialogState();
}

class _ImageSelectionDialogState extends State<ImageSelectionDialog> {
  int selectedFrameIndex = -1; // -1 to indicate "Original" selected
  List<ui.Image> frameImages = [];
  bool framesLoaded = false;
  bool imageLoaded = false;

  final List<String> frames = [
    '', // Placeholder for the "Original" box
    'assets/images/user_image_frame_1.png',
    'assets/images/user_image_frame_2.png',
    'assets/images/user_image_frame_3.png',
    'assets/images/user_image_frame_4.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadImageAndFrames();
  }

  @override
  void didUpdateWidget(covariant ImageSelectionDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      _loadImageAndFrames(); // Reload images and frames if path changes
    }
  }

  Future<void> _loadImageAndFrames() async {
    setState(() {
      imageLoaded = false; // Reset image loaded status
      framesLoaded = false; // Reset frames loaded status
    });

    // Load frames
    await _loadFrameImages();

    // Load image
    setState(() {
      imageLoaded = true; // Update image loaded status
    });
  }

  Future<void> _loadFrameImages() async {
    frameImages.clear(); // Clear previous frame images
    for (int i = 1; i < frames.length; i++) {
      final ByteData data = await rootBundle.load(frames[i]);
      final ui.Codec codec =
          await ui.instantiateImageCodec(data.buffer.asUint8List());
      final ui.FrameInfo fi = await codec.getNextFrame();
      frameImages.add(fi.image);
    }
    setState(() {
      framesLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Uploaded Image',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (imageLoaded)
            Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(color: Colors.red),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                  if (selectedFrameIndex >= 0 && framesLoaded)
                    CustomPaint(
                      painter: FramePainter(frameImages[selectedFrameIndex]),
                    ),
                ],
              ),
            )
          else
            const CircularProgressIndicator(),
          const SizedBox(height: 20),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: frames.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFrameIndex = index -
                          1; // -1 for "Original", 0 for first frame, etc.
                    });
                  },
                  child: Container(
                    width: 50,
                    // height: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: selectedFrameIndex == index - 1
                            ? Colors.blue
                            : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: index == 0
                        ? const Center(
                            child: Text(
                              'Original',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Image.asset(
                            frames[index],
                            fit: BoxFit.cover,
                          ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop({
                'imagePath': widget.imagePath,
                'framePath': selectedFrameIndex == -1
                    ? ''
                    : frames[selectedFrameIndex +
                        1], // Adjust index to match frame list
              });
            },
            child: Container(
              width: 220,
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
              ),
              child: const Text(
                'Use This Image',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
