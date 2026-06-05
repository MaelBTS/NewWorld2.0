import 'package:flutter/material.dart';
import 'package:newworld/services/api_service.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../screens/product_screen.dart';
import '../services/user_preferences.dart';
import 'package:newworld/models/cart.dart';
import '../screens/login_screen.dart';
import '../screens/logout_screen.dart';
import '../screens/register_screen.dart';

/// Contrôleur permettant l'affichage des onglets: Accueil, Panier,
/// Utilisateur et Déconnexion.
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
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    if (UserPreferences().isLoggedIn == true) {
      _tabController = TabController(length: 4, vsync: this);
    } else {
      _tabController = TabController(length: 3, vsync: this);
    }
    // Ajout de l'écouteur
    _tabController!.addListener(_handleTabSelection);
    // Initialisation des chargements par défaut
    _productsFuture = loadProducts();
    _userFuture = loadUser();
  }

  /// Méthode asynchrone chargeant la liste de produits du panier.
  Future<List<Product>?> loadProducts() async {
    switch (_tabController!.index) {
      case 1:
        // Récupérer le panier de l'utilisateur
        int cartId =
            await ApiService().getCartIdByUserId(1) ??
            -1; // Supposons que l'utilisateur a l'ID 1
        if (cartId == -1) {
          return [];
        }
        Cart? cart = await ApiService().getCart(cartId);
        return cart?.produits;
      default:
        return [];
    }
  }

  /// Méthode asynchrone chargeant l'utilisateur connecté.
  Future<User?> loadUser() async {
    final userId = UserPreferences().userId; // ou équivalent
    if (userId == null || userId == 0)
      {return null;} // ✅ ne pas appeler si pas connecté
    return await ApiService().getUser(userId);
  }

  void _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        if (_tabController!.index == 1) {
          _productsFuture = loadProducts();
        } else if (_tabController!.index == 2) {
          _userFuture = loadUser();
        }
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
          tabs: UserPreferences().isLoggedIn == true
              ? [
                  Tab(icon: Icon(Icons.home), text: 'Accueil'),
                  Tab(icon: Icon(Icons.shopping_cart), text: 'Panier'),
                  Tab(icon: Icon(Icons.person), text: 'utilisateurs'),
                  Tab(icon: Icon(Icons.logout), text: 'déconnection'),
                ]
              : [
                  Tab(icon: Icon(Icons.home), text: 'Accueil'),
                  Tab(icon: Icon(Icons.login), text: 'Connexion'),
                  Tab(icon: Icon(Icons.app_registration), text: 'Inscription'),
                ],
          labelStyle: const TextStyle(fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: UserPreferences().isLoggedIn == true
            ? [
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
                            color: UserPreferences().newWorldColor,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erreur: ${snapshot.error}'));
                    } else {
                      return ProductListScreen(
                        products: snapshot.data ?? [],
                        titleMode: "Panier",
                      );
                    }
                  },
                ),
                FutureBuilder<User?>(
                  future: _userFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        color: UserPreferences().backgroundColor,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: UserPreferences().newWorldColor,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erreur: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final user = snapshot.data!;
                      return Container(
                        color: UserPreferences().backgroundColor,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Utilisateur connecté',
                              style: TextStyle(
                                fontSize: 20,
                                color: UserPreferences().mainTextColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Email: ${user.email}',
                              style: TextStyle(
                                color: UserPreferences().secondaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Rôles: ${user.roles.join(', ')}',
                              style: TextStyle(
                                color: UserPreferences().secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(child: Text('Aucun utilisateur trouvé'));
                    }
                  },
                ),
                LogoutScreen(),
              ]
            : [
                Container(
                  color: UserPreferences().backgroundColor,
                  child: ProductListScreen(products: widget._products!),
                ),
                Container(
                  color: UserPreferences().backgroundColor,
                  child: LoginScreen(),
                ),
                Container(
                  color: UserPreferences().backgroundColor,
                  child: RegisterScreen(),
                ),
              ],
      ),
    );
  }
}
