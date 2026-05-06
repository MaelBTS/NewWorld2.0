import 'package:flutter/material.dart';
import 'package:newworld/models/cart.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/user_preferences.dart';
import '../widgets/product_card.dart';
import 'user_gestion_screen.dart';

/// Widget CartScreen qui affiche les détails d'un produit
class CartScreen extends StatefulWidget {
  final int cartId;
  final VoidCallback onGoBack;
  const CartScreen({super.key, required this.cartId, required this.onGoBack});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String appBarTitle = "Chargement...";
  late Future<Cart?> cart;
  @override
  void initState() {
    super.initState();
    cart = ApiService().getCart(widget.cartId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserPreferences().backgroundColor,
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: UserPreferences().netflimColor,
        foregroundColor: UserPreferences().mainTextColor,
      ),
      body: FutureBuilder<Cart?>(
        future: cart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                    color: UserPreferences().netflimColor));
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
// Récupération du panier
            final cart = snapshot.data;
            if (cart != null) {
// Mettre à jour le titre de l'appBar une fois que le
// produit est chargé
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  appBarTitle = cart.nom;
                });
              });
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${cart.tagline}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ), // Affiche le slogan du produit
                          Text(
                            'Sortie le ${cart.releaseDate}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ), // Affiche la date de sortie
                          Text(
                            'Genres: ${cart.genres?.join(', ')}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ), // Affiche les genres
                          Text(
                            'Durée: ${cart.runtime} minutes',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ), // Affiche la durée
                          Text(
                            'Note: ${cart.voteAverage}/10',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ), // Affiche la note des internautes
                          const SizedBox(height: 8),
                          // Synopsis du produit
                          Text(
                            "Synopsis",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cart.description,
                            textAlign: TextAlign.justify,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ),
                          for (String key in cart.youtubeKey)
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        YoutubeVideoScreen(videoId: key),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: UserPreferences().netflimColor,
                                foregroundColor:
                                    UserPreferences().mainTextColor,
                              ),
                              child: Text(cart
                                  .youtubeTitle[cart.youtubeKey.indexOf(key)]),
                            ), // Affiche les clés YouTube associées au produit
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
// Gestion du cas où `cart` est null
              return const Center(child: Text("panier non trouvé"));
            }
          } else {
            return const Center(child: Text('Aucune donnée'));
          }
        },
      ),
      bottomNavigationBar: FutureBuilder<Cart?>(
        future: cart,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return SizedBox.shrink(); // Pas d'erreur pendant loading
          }

          final Cart currentCart = snapshot.data!;
        },
      ),
    );
  }
}
