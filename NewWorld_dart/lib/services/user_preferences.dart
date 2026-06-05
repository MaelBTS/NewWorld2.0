// Importe shared_preferences pour le stockage persistant des données.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// UserPreferences utilise le modèle Singleton pour gérer les préférences.
///
/// Permet le stockage et la récupération persistants des préférences utilisateur.
class UserPreferences {
  // Instance unique privée de UserPreferences pour le modèle Singleton.
  static final UserPreferences _instance = UserPreferences._internal();

  // Factory constructor retournant l'instance unique.
  factory UserPreferences() {
    return _instance;
  }

  // Constructeur privé pour l'initialisation de l'instance Singleton.
  UserPreferences._internal();

  // Référence privée à SharedPreferences pour le stockage clé-valeur.
  SharedPreferences? _prefs;

  /// Initialise SharedPreferences. Doit être appelé avant toute opération.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Getter pour 'id'. Retourne la valeur ou null si non défini.
  bool? get isLoggedIn {
    return _prefs?.getBool('isLoggedIn');
  }

  /// Setter pour 'id'. Enregistre la valeur dans SharedPreferences.
  set isLoggedIn(bool? isLogged) {
    _prefs?.setBool('isLoggedIn', isLogged!);
  }

  /// Getter pour 'id'. Retourne la valeur ou null si non défini.
  int? get userId {
    return _prefs?.getInt('id');
  }

  /// Setter pour 'id'. Enregistre la valeur dans SharedPreferences.
  set userId(int? id) {
    _prefs?.setInt('id', id!);
  }

  /// Getter pour 'username'. Retourne la valeur ou null si non défini.
  String? get username {
    return _prefs?.getString('username');
  }

  /// Setter pour 'username'. Enregistre la valeur dans SharedPreferences.
  set username(String? value) {
    _prefs?.setString('username', value!);
  }

  /// Getter pour 'new_world_color'. Retourne la valeur ou null si non défini.
  Color get newWorldColor {
    // Récupération de la valeur
    int? aColorStr = _prefs?.getInt('new_world_color');

    // Si valeur nulle par défaut on utilise le rouge Netflim
    aColorStr = aColorStr ?? Color.fromARGB(255, 52, 133, 36).value;

    return Color(aColorStr);
  }

  /// Setter pour 'new_world_color'. Enregistre la valeur dans SharedPreferences.
  set newWorldColor(Color value) {
    _prefs?.setInt('new_world_color', value.value);
  }

  /// Getter pour 'background_color'. Retourne la valeur ou null si non défini.
  Color get backgroundColor {
    // Récupération de la valeur
    int? aColorStr = _prefs?.getInt('background_color');

    // Si valeur nulle par défaut on utilise le rouge Netflim
    aColorStr = aColorStr ?? Color.fromARGB(255, 42, 42, 42).value;

    return Color(aColorStr);
  }

  /// Setter pour 'background_color'. Enregistre la valeur dans SharedPreferences.
  set backgroundColor(Color value) {
    _prefs?.setInt('background_color', value.value);
  }

  /// Getter pour 'main_text_color'. Retourne la valeur ou blanc si non défini.
  Color get mainTextColor {
    // Récupération de la valeur
    int? aColorStr = _prefs?.getInt('main_text_color');

    // Si valeur nulle par défaut on utilise le rouge Netflim
    aColorStr = aColorStr ?? Color.fromARGB(255, 255, 254, 254).value;

    return Color(aColorStr);
  }

  /// Setter pour 'background_color'. Enregistre la valeur dans SharedPreferences.
  set mainTextColor(Color value) {
    _prefs?.setInt('main_text_color', value.value);
  }

  /// Getter pour 'secondary_text_color'. Retourne la valeur ou blanc si non défini.
  Color get secondaryTextColor {
    // Récupération de la valeur
    int? aColorStr = _prefs?.getInt('secondary_text_color');

    // Si valeur nulle par défaut on utilise le rouge Netflim
    aColorStr = aColorStr ?? const Color.fromARGB(255, 60, 60, 60).value;

    return Color(aColorStr);
  }

  /// Setter pour 'secondary_text_color'. Enregistre la valeur dans SharedPreferences.
  set secondaryTextColor(Color value) {
    _prefs?.setInt('secondary_text_color', value.value);
  }

  // Ajoutez ici d'autres getters et setters pour diverses préférences.
}
