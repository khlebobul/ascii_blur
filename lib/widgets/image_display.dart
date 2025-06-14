import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import '../services/image_service.dart';

class ImageDisplay extends StatefulWidget {
  final File? image;
  final double blurValue;
  final ValueChanged<File> onImageSelected;

  const ImageDisplay({
    super.key,
    this.image,
    required this.blurValue,
    required this.onImageSelected,
  });

  @override
  State<ImageDisplay> createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  bool _isDragOver = false;
  ui.Image? _imageInfo;

  @override
  void initState() {
    super.initState();
    if (widget.image != null) {
      _loadImageInfo(widget.image!);
    }
  }

  @override
  void didUpdateWidget(ImageDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      if (widget.image != null) {
        _loadImageInfo(widget.image!);
      } else {
        setState(() {
          _imageInfo = null;
        });
      }
    }
  }

  Future<void> _loadImageInfo(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    if (!mounted) return;
    setState(() {
      _imageInfo = frame.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.image != null && _imageInfo != null;

    final imageContainer = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isDragOver
                  ? const Color(0xFF6366F1).withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.1),
              width: _isDragOver ? 2 : 1,
            ),
            color: widget.image == null
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.transparent,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: hasImage
                ? _ImageWithBlur(
                    image: widget.image!,
                    blurValue: widget.blurValue,
                  )
                : _EmptyState(isDragOver: _isDragOver),
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 120, 10, 20),
      child: DropTarget(
        onDragDone: (details) => _handleDrop(details),
        onDragEntered: (_) => setState(() => _isDragOver = true),
        onDragExited: (_) => setState(() => _isDragOver = false),
        child: GestureDetector(
          onTap: _handleTap,
          child: hasImage
              ? Center(
                  child: AspectRatio(
                    aspectRatio: _imageInfo!.width / _imageInfo!.height,
                    child: imageContainer,
                  ),
                )
              : imageContainer,
        ),
      ),
    );
  }

  Future<void> _handleDrop(DropDoneDetails details) async {
    setState(() => _isDragOver = false);

    if (details.files.isNotEmpty) {
      final file = details.files.first;
      if (ImageService.isImageFile(file.path)) {
        final imageFile = await ImageService.handleDroppedFile(file);
        if (imageFile != null) {
          widget.onImageSelected(imageFile);
        }
      }
    }
  }

  Future<void> _handleTap() async {
    final image = await ImageService.pickImageFromFiles(context);
    if (image != null) {
      widget.onImageSelected(image);
    }
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDragOver;

  const _EmptyState({required this.isDragOver});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: isDragOver
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF6366F1).withValues(alpha: 0.1),
                  const Color(0xFF8B5CF6).withValues(alpha: 0.05),
                ],
              )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Icon(
              isDragOver
                  ? Icons.file_download_outlined
                  : Icons.add_photo_alternate_outlined,
              size: 48,
              color: isDragOver
                  ? const Color(0xFF6366F1).withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isDragOver ? 'Drop image here' : 'Drag & drop an image',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: isDragOver
                  ? const Color(0xFF6366F1).withValues(alpha: 0.9)
                  : Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          if (!isDragOver)
            Text(
              'or click to select',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
        ],
      ),
    );
  }
}

class _ImageWithBlur extends StatelessWidget {
  final File image;
  final double blurValue;

  const _ImageWithBlur({required this.image, required this.blurValue});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Image.file(image, fit: BoxFit.cover),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
            ),
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(
                sigmaX: blurValue,
                sigmaY: blurValue,
              ),
              child: Image.file(image, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }
}
