import 'package:flutter/material.dart';
import 'package:newworld/services/api_service.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../screens/product_screen.dart';
import '../services/user_preferences.dart';
import '../screens/login_screen.dart';
import '../screens/logout_screen.dart';
import '../screens/register_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/user_gestion_screen.dart';

/// Contrôleur permettant l'affichage des onglets: Accueil, Panier,
/// Utilisateur et Déconnexion.
class AppTabController extends StatefulWidget {
  /// Liste des produits populaires chargés à l'initialisation de l'application
  final List<Product>? _products;

  /// Constructeur de notre widget
  const AppTabController({super.key, required List<Product>? products})
    : _products = products;

  /// Surcharge de la gestion d'état
  @override
  _AppTabControllerState createState() => _AppTabControllerState();
}

class _AppTabControllerState extends State<AppTabController>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int? _cartFuture;
  User? _userFuture;

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
    setFuture();
  }

  Future<void> setFuture() async {
    User user = await loadUser();
    setState(() {
      // ← notifie Flutter que les données sont prêtes
      _userFuture = user;
    });
    int cartId = await loadCartId();
    setState(() {
      // ← notifie Flutter que les données sont prêtes
      _cartFuture = cartId;
    });
  }

  void _onLoginSuccess() {
    setState(() {
      _tabController?.dispose();
      _tabController = TabController(length: 4, vsync: this);
      _tabController!.addListener(_handleTabSelection);
    });
    setFuture();
  }

  void _onLogoutSuccess() {
    setState(() {
      _tabController?.dispose();
      _tabController = TabController(length: 3, vsync: this);
      _tabController!.addListener(_handleTabSelection);
    });
    setFuture();
  }

  /// Méthode asynchrone chargeant la liste de produits du panier.
  Future<int> loadCartId() async {
    final cartId = await ApiService().getCartIdByUserId(_userFuture!.id) ?? -1;
    if (cartId == -1) {
      throw Exception('Panier introuvable pour l\'utilisateur');
    }
    return cartId;
  }

  /// Méthode asynchrone chargeant l'utilisateur connecté.
  Future<User> loadUser() async {
    final userId = UserPreferences().userId; // ou équivalent
    if (userId == null || userId == 0) {
      throw Exception('Utilisateur non connecté');
    } // ✅ ne pas appeler si pas connecté
    return await ApiService().getUser(userId);
  }

  Future<void> _handleTabSelection() async {
    if (_tabController!.indexIsChanging) {
      if (_tabController!.index == 1 && _cartFuture == null) {
        final cartId = await loadCartId();
        setState(() => _cartFuture = cartId);
      } else if (_tabController!.index == 2 && _userFuture == null) {
        final user = await loadUser();
        setState(() => _userFuture = user);
      }
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
                Container(
                  color: UserPreferences().backgroundColor,
                  child: _cartFuture == null
                      ? const Center(child: CircularProgressIndicator())
                      : CartScreen(cartId: _cartFuture!),
                ),
                Container(
                  color: UserPreferences().backgroundColor,
                  child: _userFuture == null
                      ? const Center(child: CircularProgressIndicator())
                      : UserScreen(user: _userFuture!),
                ),
                Container(
                  color: UserPreferences().backgroundColor,
                  child: LogoutScreen(onLogout: _onLogoutSuccess),
                ),
              ]
            : [
                Container(
                  color: UserPreferences().backgroundColor,
                  child: ProductListScreen(products: widget._products!),
                ),
                Container(
                  color: UserPreferences().backgroundColor,
                  child: LoginScreen(onLogin: _onLoginSuccess),
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
