import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';

class AppSelectImageIcon extends StatelessWidget {
  final File? imageFile;
  final String? initialImageUrl;

  const AppSelectImageIcon({super.key, this.imageFile, this.initialImageUrl});

  @override
  Widget build(BuildContext context) {
    ImageProvider backgroundImage;

    if (imageFile != null) {
      backgroundImage = FileImage(imageFile!);
    } else if (initialImageUrl != null && initialImageUrl!.isNotEmpty) {
      backgroundImage = CachedNetworkImageProvider(initialImageUrl!);
    } else {
      backgroundImage = AssetImage(AppImageStrings.profileImage);
    }

    return CircleAvatar(radius: 30, backgroundImage: backgroundImage);
  }
}
