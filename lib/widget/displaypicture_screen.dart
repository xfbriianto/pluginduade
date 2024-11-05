import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class DisplayPictureScreen extends StatefulWidget {
  final dynamic imageSource; // Bisa XFile atau String
  const DisplayPictureScreen({super.key, required this.imageSource});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  bool _isTakingPicture = false;

  Widget _buildImage() {
    if (kIsWeb) {
      // Untuk web, gunakan Image.memory dengan data bytes
      return Image.memory(widget.imageSource);
    } else {
      // Untuk mobile, gunakan Image.file
      return Image.file(File(widget.imageSource));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display the picture'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => saveImage(context),
          ),
        ],
      ),
      body: _buildImage(),
    );
  }
  
  saveImage(BuildContext context) {}
}