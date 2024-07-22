
import 'package:celebrare/framed_image.dart';
import 'package:celebrare/image_helper.dart';
import 'package:celebrare/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Remove if not used
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart'; // Remove if not used// Import your existing file

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _selectedImagePath;
  String? _selectedFramePath;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Add Image / Icon',
            style: GoogleFonts.ptSans(
              textStyle: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ),
          elevation: 5,
          shadowColor: Colors.grey,
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Upload Image",
                        style: TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => _showImageSourceSheet(context),
                        child: Container(
                          height: 35,
                          width: 180,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                AppColors.primaryColor, // Use a constant color
                          ),
                          child: Text(
                            "Choose from Device",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: _selectedImagePath != null && _selectedFramePath != null
                    ? FramedImage(
                        imagePath: _selectedImagePath!,
                        framePath: _selectedFramePath!,
                      )
                    : Text('No image selected'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  pickAndCropImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  pickAndCropImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickAndCropImage(ImageSource camera) async {
    final result = await ImageHelper().pickImage(
      cropAspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
      imageSource: ImageSource.gallery,
      context: context,
    );
    if (result != null) {
      setState(() {
        _selectedImagePath = result['imagePath'];
        _selectedFramePath = result['framePath'];
      });
    }
  }
}
