# ASCII Blur

A Flutter project that transforms images into an artistic blend of blur and ASCII art.

## Demo

// TODO

## Inspiration

// TODO

## How the ASCII Art Generation Works

The ASCII art effect is created by strategically placing characters over the dark areas of an image. Here's a step-by-step breakdown of the algorithm:

### 1. Image Processing

When an image is loaded, it first gets processed to prepare it for the ASCII generation.

- **Resizing**: To make the processing faster and the character grid manageable, the image is resized to a fixed width (e.g., 100 pixels wide) while maintaining its aspect ratio.
- **Grayscale Conversion**: The resized image is converted to grayscale. This simplifies the brightness analysis, as each pixel will have a single brightness value (from black to white) instead of three color channels (RGB).

```dart
// Part of _AsciiOverlayState in lib/widgets/ascii_overlay.dart

Future<void> _processImage() async {
  final bytes = await widget.imageFile.readAsBytes();
  final image = img.decodeImage(bytes);
  if (image == null) return;

  // Resize for performance and grid size
  const int targetWidth = 100;
  final resized = img.copyResize(
    image,
    width: targetWidth,
    interpolation: img.Interpolation.linear,
  );

  // Convert to grayscale for brightness analysis
  final grayscaleImage = img.grayscale(resized);

  if (!mounted) return;
  setState(() {
    _processedImage = grayscaleImage;
  });
}
```

### 2. Character Mapping based on Brightness

The core of the effect lies in the `_AsciiPainter`. It iterates through each pixel of the downscaled, grayscale image and decides whether to draw a character at that position.

- **Grid Calculation**: The painter treats the image as a grid, where each cell corresponds to a pixel in the processed image.
- **Brightness Check**: For each pixel, it gets the brightness value (a value from 0.0 for black to 1.0 for white).
- **Thresholding**: It checks if the pixel's brightness is *below* a user-defined `threshold`. This is what makes the characters appear on the darker parts of the image. The threshold can be adjusted with a slider in the UI.

### 3. Rendering the Characters

If a pixel's brightness is below the threshold, a character is drawn.

- **Character Selection**: Characters are selected sequentially from a predefined string of code snippets and symbols.
- **Styling and Positioning**:
  - The character is rendered using a monospaced font (`RobotoMono`) to ensure each character occupies a similar amount of space.
  - The color opacity is based on the pixel's original brightness, making characters on darker areas more opaque.
  - A small random vertical offset is added to give the text a slightly jittery, dynamic feel.

```dart
// Part of _AsciiPainter in lib/widgets/ascii_overlay.dart

@override
void paint(Canvas canvas, Size size) {
  final cellWidth = size.width / image.width;
  final cellHeight = size.height / image.height;
  final random = Random(123); // Seeded for consistent randomness
  int charIndex = 0;

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final pixel = image.getPixel(x, y);
      final brightness = pixel.r / 255.0; // Brightness from the red channel

      // Draw character if brightness is below the threshold
      if (brightness < threshold) {
        if (charIndex >= text.length) charIndex = 0; // Loop through text
        final char = text[charIndex++];
        if (char.trim().isEmpty) continue; // Skip whitespace

        final textStyle = TextStyle(
          fontFamily: 'RobotoMono',
          fontSize: min(cellWidth, cellHeight) * 0.9,
          color: Colors.white.withValues(alpha:
            // Opacity is higher for darker pixels
            (1 - brightness) * 0.7 * (random.nextDouble() * 0.5 + 0.5),
          ),
        );
        
        final textPainter = TextPainter(...)
        textPainter.layout();

        // Add a slight random offset for a more organic look
        final offset = Offset(x * cellWidth, y * cellHeight + random.nextDouble() * 5);
        textPainter.paint(canvas, offset);
      } else {
        // Still increment charIndex to maintain character flow
        charIndex++;
      }
    }
  }
}
```
