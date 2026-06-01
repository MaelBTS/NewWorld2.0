import 'package:flutter/material.dart';
import 'package:newworld/screens/product_detail_screen.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../services/user_preferences.dart';
import '../services/favorite.dart';
import '../widgets/product_search_bar.dart';

class ProductListScreen extends StatefulWidget {
  final List<Product> products;
  final String? titleMode;
  final bool? displaySearchBar;

  const ProductListScreen(
      {super.key, required this.products, this.titleMode, this.displaySearchBar});

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends State<ProductListScreen> {
  late String? title;
  late List<Product> products;
  ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    products = widget.products;
    title = widget.titleMode ?? "Produits";
  }

  void onQueryChanged(String search) async {
    if (search.isEmpty) {
      title = "produits";
      products = widget.products;
    } else {
      title = "votre recherche";
      products = await api.searchForProducts(1, search);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserPreferences().backgroundColor,
      body: Column(
        children: [
          title != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title!,
                    style: TextStyle(
                      fontSize: 18,
                      color: UserPreferences().mainTextColor,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          ProductSearchBar(onQueryChanged: onQueryChanged),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = products[index];
                return ListTile(
                  title: Text(
                    product.nom,
                    style: TextStyle(color: UserPreferences().mainTextColor),
                  ),
                  subtitle: Text(
                    'Plus de détails...',
                    style:
                        TextStyle(color: UserPreferences().secondaryTextColor),
                  ),
                  onTap: () async {
                    // Requête vers l'API pour récupérer toutes les informations
                    // complémentaires du produit
                    product = (await ApiService().getProduct(product.id))!;
                    // Navigue vers le ProductScreen avec les détails du produit
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          productId: product.id,
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(
                      Favourites().isAFavourite(product)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        Favourites().isAFavourite(product)
                            ? Favourites().removeFromFavourites(product)
                            : Favourites().addToFavourites(product);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
