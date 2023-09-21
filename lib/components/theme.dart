import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../extras/constants.dart';

// Your color constants (kPrimaryColor, kTextWhiteColor, etc.) should be defined here
//colors
ThemeData getAppTheme(BuildContext context) {
  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: kPrimaryColor,
    primaryColor: kPrimaryColor,
    appBarTheme: const AppBarTheme(
      color: kPrimaryColor,
      elevation: 0,

    ),
    textTheme: GoogleFonts.sourceSans3TextTheme(
      Theme.of(context).textTheme.apply().copyWith(
        bodyLarge: const TextStyle(
          color: kTextWhiteColor,
          fontSize: 40.0,
          fontStyle: FontStyle.normal,
          letterSpacing: 1.5,
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
          color: kTextLightColor,
          fontSize: 20
      ),

      hintStyle: TextStyle(
          fontSize: 18.0,
          color: kTextLightColor,
          height: .8
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: kTextLightColor,
            width: .7
        ),
      ),
      border: UnderlineInputBorder(
          borderSide: BorderSide(
              color: kTextLightColor
          )
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: kTextLightColor,
            width: .7
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: kSecondaryColor,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: kErrorBorderColor,
            width: 1.2
        ),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: kErrorBorderColor,
            width: 1.2
        ),
      ),


    ),
  );
}
