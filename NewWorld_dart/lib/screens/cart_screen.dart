import 'package:flutter/material.dart';
import 'package:newworld/models/cart.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/user_preferences.dart';
import 'product_detail_screen.dart';

/// Widget CartScreen qui affiche les détails d'un produit
class CartScreen extends StatefulWidget {
  final int cartId;
  const CartScreen({super.key, required this.cartId});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String appBarTitle = "panier";
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
        centerTitle: true,
        backgroundColor: UserPreferences().backgroundColor,
        foregroundColor: UserPreferences().mainTextColor,
      ),
      body: FutureBuilder<Cart?>(
        future: cart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                    color: UserPreferences().newWorldColor));
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
                  appBarTitle = cart.utilisateur.email;
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
                            'état du panier: ${cart.statut}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ),
                          Text(
                            'payé le ${cart.date_facturation}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ), // Affiche le slogan du produit
                          Text(
                            'livré le ${cart.date_livraison}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ), // Affiche la date de sortie
                          Text(
                            cart.commentaire,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ), // Affiche les genres
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => ApiService().payCart(cart), 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: UserPreferences().newWorldColor,
                              foregroundColor: UserPreferences().mainTextColor,
                            ),
                            child: Text('Payer'),
                          ),
                          for (Product produit in cart.produits)
                            ListTile(
                              title: Text(
                                produit.nom,
                                style: TextStyle(
                                    color: UserPreferences().mainTextColor),
                              ),
                              subtitle: Text(
                                'Plus de détails...',
                                style: TextStyle(
                                    color:
                                        UserPreferences().secondaryTextColor),
                              ),
                              onTap: () async {
                                // Requête vers l'API pour récupérer toutes les informations
                                // complémentaires du produit
                                final detailedProduct =
                                    await ApiService().getProduct(produit.id);
                                if (detailedProduct != null) {
                                  // Navigue vers le ProductScreen avec les détails du produit
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailScreen(
                                            productId: detailedProduct.id,
                                          ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Erreur: produit introuvable")),
                                  );
                                }
                              },
                            ),
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
    );
  }
}
