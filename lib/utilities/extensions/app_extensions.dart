import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_kick/data/models/player_model.dart';

extension StringCasingExtension on String {
  /// Capitalizes only the first letter of the string.
  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Converts all letters to uppercase.
  String capitalizeAll() => toUpperCase();

  /// Converts all letters to lowercase.
  String toLowerCased() => toLowerCase();
}

extension ContextTextTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension PlayerModelUpdate on PlayerModel {
  Map<String, dynamic> toUpdateJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "age": age,
      "country": country,
      "height": height,
      "player_position": playerPosition,
      "performance_video_link": performanceVideoLink,
      "profile_picture": profilePicture,
    };
  }
}

extension DateTimeFormatting on DateTime {
  /// Returns something like: 16 Sep 2025, 9:49 PM
  String get formattedShort => DateFormat("d MMM y, h:mm a").format(toLocal());

  /// Returns something like: 2025-09-16 21:49:23
  String get formattedLong => DateFormat("y-MM-dd HH:mm:ss").format(toLocal());

  /// Returns something like: Tuesday, 16 Sep 2025
  String get formattedFullDate => DateFormat("EEEE, d MMM y").format(toLocal());

  /// Returns only time, e.g.: 9:49 PM
  String get formattedTime => DateFormat("h:mm a").format(toLocal());

  /// Returns only date, e.g.: 16/09/2025
  String get formattedDate => DateFormat("dd/MM/yyyy").format(toLocal());
}
