import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:plugin_project/widget/displaypicture_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.cameraDescription});
  final CameraDescription cameraDescription;

  @override
  State<TakePictureScreen> createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.cameraDescription,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_isTakingPicture) return;
    
    try {
      setState(() {
        _isTakingPicture = true;
      });
      
      await _initializeControllerFuture;
      final XFile image = await _controller.takePicture();
      
      if (mounted) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DisplayPictureScreen(
                imageSource: bytes,
              ),
            ),
          );
        } else {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DisplayPictureScreen(
                imageSource: image.path,
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Error taking picture: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isTakingPicture = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isTakingPicture ? null : _takePicture,
        child: const Icon(Icons.camera),
      ),
    );
  }
}



