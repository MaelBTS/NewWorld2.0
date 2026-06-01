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

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _loadingStatus = LoadingStatus.loading;
    });

    ApiService service = ApiService();

    try {
      await Future.delayed(const Duration(seconds: 2));

      _products = await service.getProducts(1);

      Product? product = await service.getProduct(1);

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
    Widget screen;

    switch (_loadingStatus) {
      case LoadingStatus.success:
        screen = AppTabController(products: _products);
        break;
      default:
        screen = StartScreen(
          loadingStatus: _loadingStatus,
          onReload: _fetchProducts,
        );
        break;
    }

    // Test d'accès à Youtube
    //screen = const YoutubeVideoScreen(videoId: '-6lMRysFhrM');

    return MaterialApp(
      home: screen,
      theme: ThemeNewWorld.theme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
