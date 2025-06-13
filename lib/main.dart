import 'package:flutter/material.dart';
import 'screens/image_blur_screen.dart';

void main() {
  runApp(const AsciiblurApp());
}

class AsciiblurApp extends StatelessWidget {
  const AsciiblurApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ascii Blur',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ImageBlurScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
