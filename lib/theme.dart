import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

const Color cursorColor = Color.fromARGB(255, 1, 79, 66);


final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.teal,
  hintColor: cursorColor,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: cursorColor,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: cursorColor),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: cursorColor),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: cursorColor),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: cursorColor),
    ),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: cursorColor,
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    color: Colors.black,
    selectedColor: cursorColor,
    fillColor: cursorColor.withOpacity(0.1),
    borderColor: Colors.black,
    selectedBorderColor: cursorColor,
    disabledColor: Colors.grey.shade400,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: cursorColor,
    ),
  ),

  //ElevatedButton
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: gColorTheme1_700,
      foregroundColor: Colors.white, // Letras blancas
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
  ),
);

class ThemeService {
  final _themeKey = 'isDarkMode';

  ThemeMode get themeMode {
    return GetStorage().read(_themeKey) ?? false ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme(bool isDark) {
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    GetStorage().write(_themeKey, isDark);
  }

  bool isDarkMode() {
    return Get.isDarkMode;
  }
}

