import 'package:flutter/material.dart';

class AppCustomIconButtonTheme {
  static IconButtonThemeData lightIconTheme = IconButtonThemeData(
    style: ButtonStyle(
      enableFeedback: false,
      splashFactory: NoSplash.splashFactory,
     

    )
  );


  //
  static IconButtonThemeData darkIconTheme = IconButtonThemeData(
    style: ButtonStyle(
      enableFeedback: false,
      splashFactory: NoSplash.splashFactory,
     

    )
  );
}
