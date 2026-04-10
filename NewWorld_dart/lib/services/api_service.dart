import 'package:dio/dio.dart';
import '../models/product.dart';
import 'api.dart';

/// Classe `ApiService` gère les requêtes réseau pour récupérer des données de
/// films depuis une API externe.
///
/// Cette classe utilise la bibliothèque Dio pour effectuer des requêtes HTTP.
/// Elle est conçue pour interroger une API spécifique de films et récupérer des
/// informations telles que les films populaires.
///
/// Usage :
/// Pour utiliser `ApiService`, créez une instance de la classe, puis invoquez
/// les méthodes fournies pour récupérer les données souhaitées.
class ApiService {
  final API api = API();
  final Dio dio = Dio();

  /// Récupère les données depuis l'API en utilisant un chemin spécifié et des
  /// paramètres optionnels.
  ///
  /// [path] Le chemin de la ressource API à laquelle accéder.
  /// [params] Paramètres optionnels à inclure dans la requête.
  ///
  /// Retourne une réponse Dio si la requête aboutit avec un code de statut 200.
  /// Sinon, lève une exception contenant la réponse de la requête.
  Future<Response> getData(String path, {Map<String, dynamic>? params}) async {
    // Construction de l'URL complète
    String url = api.baseUrl + path;

    // Ajout des paramètres de requête par défaut et ceux fournis
    Map<String, dynamic> query = {};

    // Ajout des paramètres optionnels
    if (params != null) {
      query.addAll(params);
    }

    // Lancement de la requète
    final response = await dio.get(url, queryParameters: query);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw response;
    }
  }

  /// Récupère une liste des films populaires à partir de l'API.
  ///
  /// [pageNumber] Le numéro de la page à récupérer pour la pagination des résultats.
  ///
  /// Retourne une liste d'objets `Movie` si la requête est réussie.
  /// Sinon, lève une exception contenant la réponse de la requête.
  Future<List<Product>> getProducts(int pageNumber) async {
    Response response = await getData("/movie/popular", params: {
      'page': pageNumber,
    });

    if (response.statusCode == 200) {
      Map data = response.data;

      List<dynamic> results = data["results"];
      List<Product> products = [];

      for (Map<String, dynamic> json in results) {
        // Transformation du JSON en objet Movie
        Product movie = jsonToMovie(json);

        products.add(movie);
      }

      return products;
    } else {
      throw response;
    }
  }

  /// Récupère une liste des films sur un criète de recherge à partir de l'API.
  ///
  /// [pageNumber] Le numéro de la page à récupérer pour la pagination des résultats.
  ///
  /// Retourne une liste d'objets `Movie` si la requête est réussie.
  /// Sinon, lève une exception contenant la réponse de la requête.
  Future<List<Product>> searchForMovies(
      int pageNumber, String searchString) async {
    Response response = await getData("/search/movie",
        params: {'page': pageNumber, 'query': searchString});

    if (response.statusCode == 200) {
      Map data = response.data;

      List<dynamic> results = data["results"];
      List<Product> products = [];

      for (Map<String, dynamic> json in results) {
        // Transformation du JSON en objet Movie
        Product movie = jsonToMovie(json);

        products.add(movie);
      }

      return products;
    } else {
      throw response;
    }
  }

  /// Récupère le détail d'un film sur la base de son identifiant.
  ///
  /// Retourne un objet `Movie` si la requête est réussie.
  /// Sinon, lève une exception contenant la réponse de la requête.
  Future<Product?> getMovie(int movieId) async {
    Response response = await getData("/movie/$movieId");

    if (response.statusCode == 200) {
      Map<String, dynamic> json = response.data;

      // Transformation du JSON en objet Movie
      Product movie = jsonToMovie(json);
      return movie;
    } else {
      throw response;
    }
  }

  /// Transformation du JSON d'un film provenant la l'appel API en
  /// un objet Movie du Model
  Product jsonToMovie(Map<String, dynamic> json) {
    Product movie = Product(
      id: json['id'] as int,
      nom: json['title'] as String,
      quantiteType: json['overview'] as String,
    );
    return movie;
  }

  /// Extraction de la liste des genres
  List<String> extractGenres(List<dynamic>? genres) {
// Vérifie si genres est null
    if (genres == null) {
// Retourne une liste vide si la chaîne est null
      return [];
    }
// Extraction et conversion des noms des genres en List<String>
    List<String> genreNames = genres
        .where((genre) =>
            genre is Map<String, dynamic> && genre.containsKey('name'))
        .map((genre) => genre['name'] as String)
        .toList();
    return genreNames;
  }
}
