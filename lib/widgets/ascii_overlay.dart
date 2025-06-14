import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class AsciiOverlay extends StatefulWidget {
  final File imageFile;
  final double threshold;

  const AsciiOverlay({
    super.key,
    required this.imageFile,
    required this.threshold,
  });

  @override
  State<AsciiOverlay> createState() => _AsciiOverlayState();
}

class _AsciiOverlayState extends State<AsciiOverlay> {
  img.Image? _processedImage;

  static const String _codeText = '''
      return dynamic[i] 
      if s is one else for i s
      e um ate (s ta ic)] def
      oftmax(x, a xis=-1): x
      x - tf.reduce max(x, axis=ax
      s, k eepdims True) ex
      = tf.exp( ) return ex
      ( tf .reduce_su e x, axi s=axis,
      de f shap e li st( x l ): 
      """Deal with d amic sh ap e
      n tensorflow leanly.""" sta
      c = x.shap as_list()
      d ynam ic = tf.sh e(x) et d
      N s 'l n r t s = i` = x / m''';

  @override
  void initState() {
    super.initState();
    _processImage();
  }

  @override
  void didUpdateWidget(AsciiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageFile != oldWidget.imageFile) {
      _processImage();
    }
  }

  Future<void> _processImage() async {
    final bytes = await widget.imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return;

    const int targetWidth = 100;
    final resized = img.copyResize(
      image,
      width: targetWidth,
      interpolation: img.Interpolation.linear,
    );
    final grayscaleImage = img.grayscale(resized);

    if (!mounted) return;
    setState(() {
      _processedImage = grayscaleImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_processedImage == null) {
      return const SizedBox.shrink();
    }
    return CustomPaint(
      painter: _AsciiPainter(
        image: _processedImage!,
        text: _codeText,
        threshold: widget.threshold,
      ),
      size: Size.infinite,
    );
  }
}

class _AsciiPainter extends CustomPainter {
  final img.Image image;
  final String text;
  final double threshold;

  _AsciiPainter({
    required this.image,
    required this.text,
    required this.threshold,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / image.width;
    final cellHeight = size.height / image.height;
    final random = Random(123);

    int charIndex = 0;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final brightness = pixel.r / 255.0;

        if (brightness < threshold) {
          if (charIndex >= text.length) charIndex = 0;
          final char = text[charIndex++];
          if (char.trim().isEmpty) continue;

          final textStyle = TextStyle(
            fontFamily: 'RobotoMono',
            fontSize: min(cellWidth, cellHeight) * 0.9,
            color: Colors.white.withValues(
              alpha: (1 - brightness) * 0.7 * (random.nextDouble() * 0.5 + 0.5),
            ),
          );
          final textSpan = TextSpan(text: char, style: textStyle);
          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();

          final offset = Offset(
            x * cellWidth,
            y * cellHeight + random.nextDouble() * 5,
          );
          textPainter.paint(canvas, offset);
        } else {
          charIndex++;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AsciiPainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.text != text ||
        oldDelegate.threshold != threshold;
  }
}
