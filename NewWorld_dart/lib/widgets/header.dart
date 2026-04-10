import 'package:flutter/material.dart';
import 'package:newworld/services/api_service.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';
import '../services/user_preferences.dart';
import 'package:newworld/services/cart_interaction.dart';
import 'package:newworld/services/user_gestion.dart';

/// Contrôleur permettant l'affichage des onglets: Accueil, Recherche, Favoris,
/// et à regarder.
class AppTabController extends StatefulWidget {
  /// Liste des films populaires chargés à l'initialisation de l'application
  final List<Product>? _popularMovies;

  /// Constructeur de notre widget
  const AppTabController({
    super.key,
    required List<Product>? popularMovies,
  }) : _popularMovies = popularMovies;

  /// Surcharge de la gestion d'état
  @override
  _AppTabControllerState createState() => _AppTabControllerState();
}

class _AppTabControllerState extends State<AppTabController>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late Future<List<Product>?> _moviesFuture;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
// Ajout de l'écouteur
    _tabController!.addListener(_handleTabSelection);
// Initialisation de la liste de films par défaut
    _moviesFuture = loadMovies();
  }

  /// Méthode asynchrone chargeant la liste de films à afficher
  Future<List<Product>?> loadMovies() async {
    switch (_tabController!.index) {
// Favoris
      case 1:
        // Récupérer la liste des identifiants
        List<String> movieIds = Favourites().list();
// Créer une liste vide pour stocker les films
        List<Product> movies = [];
// Boucler sur chaque identifiant pour récupérer les films correspondants
        for (String movieId in movieIds) {
// Appeler l'API pour chaque film et attendre le résultat
          Product? movie = await ApiService().getMovie(int.parse(movieId));
// Ajouter le film à la liste des films
          if (movie != null) movies.add(movie);
        }
// Retourner la liste complète des films
        return movies;
// A regarder
      case 2:
        // Récupérer la liste des identifiants
        List<String> movieIds = ListToWatch().list();
// Créer une liste vide pour stocker les films
        List<Product> movies = [];
// Boucler sur chaque identifiant pour récupérer les films correspondants
        for (String movieId in movieIds) {
// Appeler l'API pour chaque film et attendre le résultat
          Product? movie = await ApiService().getMovie(int.parse(movieId));
// Ajouter le film à la liste des films
          if (movie != null) movies.add(movie);
        }
// Retourner la liste complète des films
        return movies;
      default:
        return [];
    }
  }

  void _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        _moviesFuture = loadMovies();
      });
    }
  }

// Construction du contexte
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('NetFlim')),
        backgroundColor: UserPreferences().netflimColor,
        foregroundColor: UserPreferences().mainTextColor,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Accueil'),
            Tab(icon: Icon(Icons.favorite), text: 'Favoris'),
            Tab(icon: Icon(Icons.list), text: 'A regarder'),
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
            child: MoviesListScreen(movies: widget._popularMovies!),
          ),
          FutureBuilder<List<Product>?>(
            future: _moviesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    color: UserPreferences().backgroundColor,
                    child: Center(
                        child: CircularProgressIndicator(
                            color: UserPreferences().netflimColor)));
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              } else {
                return MoviesListScreen(
                    movies: snapshot.data ?? [], titleMode: "Favoris");
              }
            },
          ),
          FutureBuilder<List<Product>?>(
            future: _moviesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    color: UserPreferences().backgroundColor,
                    child: Center(
                        child: CircularProgressIndicator(
                            color: UserPreferences().netflimColor)));
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              } else {
                return MoviesListScreen(
                    movies: snapshot.data ?? [], titleMode: "A regarder");
              }
            },
          ),
        ],
      ),
    );
  }
}
