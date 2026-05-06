import 'package:flutter/material.dart';
import 'package:newworld/services/user_preferences.dart';

class ProductActionsMenu extends StatelessWidget {
  // Callbacks pour les actions des boutons
  final VoidCallback onFavoritePressed;
  final bool isFavorite;

  const ProductActionsMenu({
    super.key,
    required this.onFavoritePressed,
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
        ],
      ),
    );
  }
}
