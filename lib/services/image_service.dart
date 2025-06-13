import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ImageService {
  static Future<File?> pickImageFromFiles(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      if (context.mounted) {
        _showErrorDialog(context, 'Error loading image: $e');
      }
      return null;
    }
  }

  static Future<File?> handleDroppedFile(dynamic file) async {
    try {
      if (kIsWeb) {
        // For web, handle the file differently
        if (file.path != null) {
          return File(file.path);
        }
      } else {
        // For desktop platforms
        if (file is File) {
          return file;
        } else if (file.path != null) {
          return File(file.path);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static bool isImageFile(String path) {
    final extension = path.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
