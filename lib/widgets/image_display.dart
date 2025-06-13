import 'dart:io';
import 'dart:ui';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropTarget(
        onDragDone: (details) => _handleDrop(details),
        onDragEntered: (_) => setState(() => _isDragOver = true),
        onDragExited: (_) => setState(() => _isDragOver = false),
        child: GestureDetector(
          onTap: _handleTap,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: _isDragOver
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : widget.image == null
                  ? Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                      style: BorderStyle.solid,
                    )
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: widget.image == null
                  ? _EmptyState(isDragOver: _isDragOver)
                  : _ImageWithBlur(
                      image: widget.image!,
                      blurValue: widget.blurValue,
                    ),
            ),
          ),
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
      color: isDragOver
          ? Theme.of(
              context,
            ).colorScheme.primaryContainer.withValues(alpha: 0.1)
          : Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isDragOver
                ? Icons.file_download
                : Icons.add_photo_alternate_outlined,
            size: 64,
            color: isDragOver
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            isDragOver
                ? 'Drop image here'
                : 'Drag & drop an image\nor click to select',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isDragOver
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
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
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
      child: Image.file(
        image,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
      ),
    );
  }
}
