import 'package:flutter/material.dart';
import 'package:newworld/services/user_preferences.dart';

class MovieActionsMenu extends StatelessWidget {
  // Callbacks pour les actions des boutons
  final VoidCallback onFavoritePressed;
  final VoidCallback onAddToListPressed;
  final bool isFavorite;

  const MovieActionsMenu({
    super.key,
    required this.onFavoritePressed,
    required this.onAddToListPressed,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: UserPreferences().netflimColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Bouton Coup de coeur
          // Icône dynamique
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: UserPreferences().mainTextColor,
            ),
            onPressed: onFavoritePressed,
          ),
          // Bouton Ajouter à votre liste
          IconButton(
            icon: Icon(Icons.playlist_add,
                color: UserPreferences().mainTextColor),
            onPressed: onAddToListPressed,
          ),
        ],
      ),
    );
  }
}
