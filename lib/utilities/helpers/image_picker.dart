import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImageFromGallery() async {
    try {
      return await _picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return null;
    }
  }

  Future<XFile?> pickImageFromCamera() async {
    try {
      return await _picker.pickImage(source: ImageSource.camera);
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
      return null;
    }
  }
    static Future<void> pickInto(ValueNotifier<File?> target) async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    target.value = image != null ? File(image.path) : null;
  }

  static Future<void> pickMultipleImages(
    ValueNotifier<List<XFile>> selectedImages,
  ) async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage(imageQuality: 85);
    if (pickedImages.isNotEmpty) {
      selectedImages.value =
          [...selectedImages.value, ...pickedImages].take(5).toList();
    }
  }
}
