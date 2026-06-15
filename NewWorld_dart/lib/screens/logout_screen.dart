import 'package:flutter/material.dart';
import '../services/user_preferences.dart';

/// Écran de déconnexion affichant un bouton centré.
class LogoutScreen extends StatelessWidget {
  final VoidCallback? onLogout;

  const LogoutScreen({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: UserPreferences().backgroundColor,
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            UserPreferences().isLoggedIn = false; // ✅ effacer les préférences utilisateur
            UserPreferences().userId = null;
            UserPreferences().username = null;
            onLogout?.call(); // ✅ navigation après déconnexion
          },
          icon: const Icon(Icons.logout),
          label: const Text('Se déconnecter'),
          style: ElevatedButton.styleFrom(
            backgroundColor: UserPreferences().newWorldColor,
            foregroundColor: UserPreferences().mainTextColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
