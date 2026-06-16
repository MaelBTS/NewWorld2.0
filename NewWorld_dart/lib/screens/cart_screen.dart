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
  late Future<Cart?> _cartFuture;
  @override
  void initState() {
    super.initState();
    _cartFuture = ApiService().getCart(widget.cartId);
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
        future: _cartFuture,
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

              if (UserPreferences().role == 'commercant') {
                cart.totalPriceHT;
              } else {
                cart.totalPriceTTC;
              }

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
                            'payé le ${cart.date_facturation ?? "non payé"}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ),
                          Text(
                            'livré le ${cart.date_livraison ?? "non livré"}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ),
                          if (cart.commentaire.isNotEmpty)
                            Text(
                              cart.commentaire,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: UserPreferences().mainTextColor),
                            ),
                          const SizedBox(height: 8),
                          if (cart.statut != 'payé') ...[
                            ElevatedButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Confirmer le paiement'),
                                    content: Text('Total: ${cart.totalPrice.toStringAsFixed(2)}€ ${UserPreferences().role == 'commercant' ? '(HT)' : '(TTC)'}\nConfirmer le paiement ?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
                                      ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Payer')),
                                    ],
                                  ),
                                );
                                if (confirm != true) return;
                                try {
                                  await ApiService().payCart(cart);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Paiement effectué')),
                                    );
                                    setState(() => _cartFuture = ApiService().getCart(widget.cartId));
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Erreur de paiement: $e')),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: UserPreferences().newWorldColor,
                                foregroundColor: UserPreferences().mainTextColor,
                              ),
                              child: const Text('Payer'),
                            ),
                            const SizedBox(height: 12),
                          ],
                          Text(
                            'Total: ${cart.totalPrice.toStringAsFixed(2)}€ ${UserPreferences().role == 'commercant' ? '(HT)' : '(TTC)'}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: UserPreferences().mainTextColor),
                          ),
                          const SizedBox(height: 8),
                          for (Product produit in cart.produits)
                            ListTile(
                              title: Text(
                                '${produit.nom} (${produit.panierQuantite.toStringAsFixed(1)} x ${UserPreferences().role == 'commercant' ? produit.prix.toStringAsFixed(2) : (produit.prix * (1 + produit.tva / 100)).toStringAsFixed(2)}€)',
                                style: TextStyle(
                                    color: UserPreferences().mainTextColor),
                              ),
                              subtitle: Text(
                                'Prix: ${(UserPreferences().role == 'commercant' ? produit.prix * produit.panierQuantite : (produit.prix * produit.panierQuantite * (1 + produit.tva / 100))).toStringAsFixed(2)}€ ${UserPreferences().role == 'commercant' ? '(HT)' : '(TTC)'}',
                                style: TextStyle(
                                    color:
                                        UserPreferences().secondaryTextColor),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await ApiService().removeFromCart(cart.id, produit.id);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${produit.nom} retiré du panier')),
                                    );
                                    setState(() => _cartFuture = ApiService().getCart(widget.cartId));
                                  }
                                },
                              ),
                              onTap: () async {
                                final detailedProduct =
                                    await ApiService().getProduct(produit.id);
                                if (detailedProduct != null) {
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
