import 'package:flutter/material.dart';
import 'package:newworld/services/user_preferences.dart';

class ThemeNewWorld {
  /// Thème spécifique pour la TabBar
  static ThemeData theme() {
    return ThemeData(
      primaryColor: UserPreferences().backgroundColor,
      tabBarTheme: TabBarThemeData(
        labelColor: UserPreferences().mainTextColor,
        unselectedLabelColor: UserPreferences().mainTextColor.withOpacity(0.7),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: UserPreferences().mainTextColor,
            width: 3.0,
          ),
        ),
      ),
      // Ajout pour la searchbar
      inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: UserPreferences().mainTextColor),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                style: BorderStyle.solid,
                color: UserPreferences().mainTextColor),
          )),
    );
  }
}