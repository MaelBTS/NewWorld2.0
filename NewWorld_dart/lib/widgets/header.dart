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
  final VoidCallback? onAuthChanged;

  /// Constructeur de notre widget
  const AppTabController({super.key, required List<Product>? products, this.onAuthChanged})
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
    _tabController = TabController(
      length: UserPreferences().isLoggedIn == true ? 4 : 3,
      vsync: this,
    );
    _tabController!.addListener(_handleTabSelection);
    _loadData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (UserPreferences().isLoggedIn != true) return;
    try {
      User user = await ApiService().getUser(UserPreferences().userId!);
      if (!mounted) return;
      setState(() => _userFuture = user);
      int? cartId = await ApiService().getCartIdByUserId(user.id);
      if (!mounted) return;
      setState(() => _cartFuture = cartId);
    } catch (_) {}
  }

  void _onLoginSuccess() {
    widget.onAuthChanged?.call();
  }

  void _onLogoutSuccess() {
    widget.onAuthChanged?.call();
  }

  Future<void> _handleTabSelection() async {
    if (!_tabController!.indexIsChanging) return;
    if (UserPreferences().isLoggedIn != true) return;
    try {
      if (_tabController!.index == 1 && _cartFuture == null) {
        int? cartId = await ApiService().getCartIdByUserId(_userFuture!.id);
        if (mounted) setState(() => _cartFuture = cartId);
      } else if (_tabController!.index == 2 && _userFuture == null) {
        User user = await ApiService().getUser(UserPreferences().userId!);
        if (mounted) setState(() => _userFuture = user);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = UserPreferences().isLoggedIn == true;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('New World')),
        backgroundColor: UserPreferences().newWorldColor,
        foregroundColor: UserPreferences().mainTextColor,
        bottom: TabBar(
          controller: _tabController,
          tabs: isLoggedIn
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
        children: isLoggedIn
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
