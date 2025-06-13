import 'package:flutter/material.dart';
import '../models/blur_state.dart';
import '../services/image_service.dart';
import '../widgets/image_display.dart';
import '../widgets/blur_controls.dart';
import 'dart:io';

class ImageBlurScreen extends StatefulWidget {
  const ImageBlurScreen({super.key});

  @override
  State<ImageBlurScreen> createState() => _ImageBlurScreenState();
}

class _ImageBlurScreenState extends State<ImageBlurScreen> {
  BlurState _state = const BlurState();

  void _updateBlurValue(double value) {
    setState(() {
      _state = _state.copyWith(blurValue: value);
    });
  }

  void _onImageSelected(File image) {
    setState(() {
      _state = _state.copyWith(image: image, blurValue: 0.0);
    });
  }

  Future<void> _pickImage() async {
    final image = await ImageService.pickImageFromFiles(context);
    if (image != null) {
      _onImageSelected(image);
    }
  }

  void _clearImage() {
    setState(() {
      _state = _state.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ascii blur'),
        actions: [
          IconButton(
            onPressed: _pickImage,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            tooltip: 'Add Image',
          ),
          if (_state.hasImage)
            IconButton(
              onPressed: _clearImage,
              icon: const Icon(Icons.clear),
              tooltip: 'Clear',
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ImageDisplay(
              image: _state.image,
              blurValue: _state.blurValue,
              onImageSelected: _onImageSelected,
            ),
          ),
          if (_state.hasImage)
            BlurControls(value: _state.blurValue, onChanged: _updateBlurValue),
        ],
      ),
    );
  }
}
