import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
          surface: const Color(0xFF0F0F0F),
          surfaceContainer: const Color(0xFF1A1A1A),
          onSurface: Colors.white.withValues(alpha: 0.9),
          onSurfaceVariant: Colors.white.withValues(alpha: 0.6),
          primary: const Color(0xFF6366F1),
          outline: Colors.white.withValues(alpha: 0.1),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        sliderTheme: SliderThemeData(
          trackHeight: 3,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          activeTrackColor: const Color(0xFF6366F1),
          inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
          thumbColor: const Color(0xFF6366F1),
          overlayColor: const Color(0xFF6366F1).withValues(alpha: 0.2),
        ),
      ),
      home: const ImageBlurScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
