// lib/image_helper.dart

import 'package:celebrare/imageSelectionDialog.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  Future<Map<String, String>?> pickImage({
    required CropAspectRatio cropAspectRatio,
    required ImageSource imageSource,
    required BuildContext context,
  }) async {
    XFile? pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage == null) return null;

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      aspectRatio: cropAspectRatio,
      compressQuality: 90,
      compressFormat: ImageCompressFormat.jpg,
    );
    if (croppedFile == null) return null;

    // Show the image selection dialog with frames
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) => ImageSelectionDialog(imagePath: croppedFile.path),
    );

    return result;
  }
}