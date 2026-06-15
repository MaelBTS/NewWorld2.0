import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/user_preferences.dart';

/// Widget ProductDetailScreen qui affiche les détails d'un produit
class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String appBarTitle = "Chargement...";
  late Future<Product?> product;
  double _quantity = 1.0;

  @override
  void initState() {
    super.initState();
    product = ApiService().getProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserPreferences().backgroundColor,
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: UserPreferences().newWorldColor,
        foregroundColor: UserPreferences().mainTextColor,
      ),
      body: FutureBuilder<Product?>(
        future: product,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                    color: UserPreferences().newWorldColor));
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
// Récupération du product
            final product = snapshot.data;
            if (product != null) {
// Mettre à jour le titre de l'appBar une fois que le
// produit est chargé
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  appBarTitle = product.nom;
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
                            '${product.prix}€ (TVA: ${product.tva}%)',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ), // Affiche le slogan du produit
                          Text(
                            'quantité : ${product.quantite} ${product.quantiteType}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                color: UserPreferences().mainTextColor,
                                onPressed: _quantity > 0.5
                                    ? () => setState(() => _quantity -= 0.5)
                                    : null,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: UserPreferences().mainTextColor),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _quantity.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: UserPreferences().mainTextColor,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                color: UserPreferences().mainTextColor,
                                onPressed: _quantity < 99.5
                                    ? () => setState(() => _quantity += 0.5)
                                    : null,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                              onPressed: () async{
                                int cartId = await ApiService().getCartIdByUserId(UserPreferences().userId ?? -1) ?? -1;
                                  if (cartId != -1) {
                                    await ApiService().addToCart(cartId, product.id, _quantity);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("$_quantity ajouté au panier")),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Erreur: panier introuvable")),
                                    );
                                  }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: UserPreferences().newWorldColor,
                                foregroundColor:
                                    UserPreferences().mainTextColor,
                              ),
                              child: Text("ajouter au panier"),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
// Gestion du cas où `product` est null
              return const Center(child: Text("produit non trouvé"));
            }
          } else {
            return const Center(child: Text('Aucune donnée'));
          }
        },
      ),
    );
  }
}
