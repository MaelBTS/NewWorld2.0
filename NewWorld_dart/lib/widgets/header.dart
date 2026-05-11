import 'package:flutter/material.dart';
import 'package:newworld/services/api_service.dart';
import '../models/product.dart';
import '../screens/product_screen.dart';
import '../services/user_preferences.dart';
import 'package:newworld/services/favorite.dart';

/// Contrôleur permettant l'affichage des onglets: Accueil, Recherche, Favoris,
/// et à regarder.
class AppTabController extends StatefulWidget {
  /// Liste des produits populaires chargés à l'initialisation de l'application
  final List<Product>? _products;

  /// Constructeur de notre widget
  const AppTabController({
    super.key,
    required List<Product>? products,
  }) : _products = products;

  /// Surcharge de la gestion d'état
  @override
  _AppTabControllerState createState() => _AppTabControllerState();
}

class _AppTabControllerState extends State<AppTabController>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late Future<List<Product>?> _productsFuture;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
// Ajout de l'écouteur
    _tabController!.addListener(_handleTabSelection);
// Initialisation de la liste de produits par défaut
    _productsFuture = loadProducts();
  }

  /// Méthode asynchrone chargeant la liste de produits à afficher
  Future<List<Product>?> loadProducts() async {
    switch (_tabController!.index) {
// Favoris
      case 1:
        // Récupérer la liste des identifiants
        List<String> productIds = Favourites().list();
// Créer une liste vide pour stocker les produits
        List<Product> products = [];
// Boucler sur chaque identifiant pour récupérer les produits correspondants
        for (String productId in productIds) {
// Appeler l'API pour chaque produit et attendre le résultat
          Product? product = await ApiService().getProduct(int.parse(productId));
// Ajouter le produit à la liste des produits
          if (product != null) products.add(product);
        }
// Retourner la liste complète des produits
        return products;
// A regarder
      case 2:
        // Récupérer la liste des identifiants
        List<String> productIds = ListToWatch().list();
// Créer une liste vide pour stocker les produits
        List<Product> products = [];
// Boucler sur chaque identifiant pour récupérer les produits correspondants
        for (String productId in productIds) {
// Appeler l'API pour chaque produit et attendre le résultat
          Product? product = await ApiService().getProduct(int.parse(productId));
// Ajouter le produit à la liste des produits
          if (product != null) products.add(product);
        }
// Retourner la liste complète des produits
        return products;
      default:
        return [];
    }
  }

  void _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        _productsFuture = loadProducts();
      });
    }
  }

// Construction du contexte
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('New World')),
        backgroundColor: UserPreferences().newWorldColor,
        foregroundColor: UserPreferences().mainTextColor,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Accueil'),
            Tab(icon: Icon(Icons.favorite), text: 'Favoris'),
            Tab(icon: Icon(Icons.list), text: 'connexion'),
          ],
          labelStyle: const TextStyle(fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            color: UserPreferences().backgroundColor,
            child: ProductListScreen(products: widget._products!),
          ),
          FutureBuilder<List<Product>?>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    color: UserPreferences().backgroundColor,
                    child: Center(
                        child: CircularProgressIndicator(
                            color: UserPreferences().newWorldColor)));
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              } else {
                return ProductListScreen(
                    products: snapshot.data ?? [], titleMode: "Favoris");
              }
            },
          ),
          FutureBuilder<List<Product>?>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    color: UserPreferences().backgroundColor,
                    child: Center(
                        child: CircularProgressIndicator(
                            color: UserPreferences().newWorldColor)));
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              } else {
                return ProductListScreen(
                    products: snapshot.data ?? [], titleMode: "A regarder");
              }
            },
          ),
        ],
      ),
    );
  }
}
