import 'package:flutter/material.dart';
import 'package:newworld/screens/start_screen.dart';
import 'widgets/header.dart';

import 'services/api_service.dart';
import 'services/user_preferences.dart';
import 'services/theme.dart';

import 'models/product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences().init();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  LoadingStatus _loadingStatus = LoadingStatus.loading;
  List<Product>? _products;
  int _authKey = 0;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _onAuthChanged() {
    setState(() => _authKey++);
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _loadingStatus = LoadingStatus.loading;
    });

    ApiService service = ApiService();

    try {
      await Future.delayed(const Duration(seconds: 2));

      _products = await service.getProducts(1);

      _loadingStatus = LoadingStatus.success;
    } catch (e, st) {
  debugPrint('Erreur de chargement : $e');
  debugPrint('$st');
  _loadingStatus = LoadingStatus.error;
}

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingStatus != LoadingStatus.success) {
      return MaterialApp(
        theme: ThemeNewWorld.theme(),
        debugShowCheckedModeBanner: false,
        home: StartScreen(
          loadingStatus: _loadingStatus,
          onReload: _fetchProducts,
        ),
      );
    }

    return MaterialApp(
      key: ValueKey('app_$_authKey'),
      theme: ThemeNewWorld.theme(),
      debugShowCheckedModeBanner: false,
      home: AppTabController(
        products: _products,
        onAuthChanged: _onAuthChanged,
      ),
    );
  }
}
