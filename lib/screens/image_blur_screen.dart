import 'package:flutter/material.dart';
import 'dart:ui';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          _GlassButton(
            onPressed: _pickImage,
            icon: Icons.add_photo_alternate_outlined,
            tooltip: 'Add Image',
          ),
          const SizedBox(width: 8),
          if (_state.hasImage)
            _GlassButton(
              onPressed: _clearImage,
              icon: Icons.clear,
              tooltip: 'Clear',
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: ImageDisplay(
              image: _state.image,
              blurValue: _state.blurValue,
              onImageSelected: _onImageSelected,
            ),
          ),
          if (_state.hasImage)
            SizedBox(
              width: 320,
              height: double.infinity,
              child: _RightControlPanel(
                blurValue: _state.blurValue,
                onBlurChanged: _updateBlurValue,
              ),
            ),
        ],
      ),
    );
  }
}

class _RightControlPanel extends StatelessWidget {
  final double blurValue;
  final ValueChanged<double> onBlurChanged;

  const _RightControlPanel({
    required this.blurValue,
    required this.onBlurChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlurControls(value: blurValue, onChanged: onBlurChanged),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String tooltip;

  const _GlassButton({
    required this.onPressed,
    required this.icon,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 0.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onPressed,
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
