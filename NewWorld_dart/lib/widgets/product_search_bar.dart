import 'package:flutter/material.dart';
import 'package:newworld/services/user_preferences.dart';

/// Barre de recherche customisée
class ProductSearchBar extends StatefulWidget {
  /// Méthode de callback appelée lors d'une modification de la recherche
  final void Function(String) onQueryChanged;
  const ProductSearchBar({super.key, required this.onQueryChanged});
  @override
  _ProductSearchBarState createState() => _ProductSearchBarState();
}

/// Gestion d’état de la barre de recherche
class _ProductSearchBarState extends State<ProductSearchBar> {
  /// Attribut local pour la gestion de la croix d'annulation
  String? search;
  @override
  void initState() {
    super.initState();

    /// On s'assure que search n'est pas nul
    search = "";
  }

  /// Callback du gestionnaire d'état
  void onQueryChanged(String text) {
    if (text != search) {
// Appel du callback du widget
      widget.onQueryChanged(text);
// On stocke la valeur pour gérer l'affichage dynamique
// de la croix d'annulation
      search = text;
    }
  }

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _controller,
        style: const TextStyle(color: Colors.white),
        onChanged: onQueryChanged,
        decoration: InputDecoration(
          labelText: 'Rechercher',
          border: const OutlineInputBorder(),
          prefixIcon: Icon(
            Icons.search,
            color: UserPreferences().mainTextColor,
          ),
          suffixIcon: search!.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                      onQueryChanged("");
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: UserPreferences().mainTextColor,
                  ))
              : const SizedBox.shrink(),
        ),
        cursorColor: UserPreferences().mainTextColor,
      ),
    );
  }
}
