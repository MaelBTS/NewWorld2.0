import 'package:dio/dio.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/cart.dart';
import 'api.dart';

/// Classe `ApiService` gère les requêtes réseau pour récupérer des données de
/// produits depuis une API externe.
///
/// Cette classe utilise la bibliothèque Dio pour effectuer des requêtes HTTP.
/// Elle est conçue pour interroger une API spécifique de produits et récupérer des
/// informations telles que les produits populaires.
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

  /// Récupère une liste des produits populaires à partir de l'API.
  ///
  /// [pageNumber] Le numéro de la page à récupérer pour la pagination des résultats.
  ///
  /// Retourne une liste d'objets `Product` si la requête est réussie.
  /// Sinon, lève une exception contenant la réponse de la requête.
  Future<List<Product>> getProducts(int pageNumber) async {
    Response response = await getData("/produits", params: {
      'page': pageNumber,
    });

    if (response.statusCode == 200) {
      Map data = response.data;

      List<dynamic> results = data["results"];
      List<Product> products = [];

      for (Map<String, dynamic> json in results) {
        // Transformation du JSON en objet Product
        Product product = jsonToProduct(json);

        products.add(product);
      }

      return products;
    } else {
      throw response;
    }
  }

  /// Récupère une liste des produits sur un criète de recherge à partir de l'API.
  ///
  /// [pageNumber] Le numéro de la page à récupérer pour la pagination des résultats.
  ///
  /// Retourne une liste d'objets `Product` si la requête est réussie.
  /// Sinon, lève une exception contenant la réponse de la requête.
  Future<List<Product>> searchForProducts(
      int pageNumber, String searchString) async {
    Response response = await getData("/produits",
        params: {'page': pageNumber, 'query': searchString});

    if (response.statusCode == 200) {
      Map data = response.data;

      List<dynamic> results = data["results"];
      List<Product> products = [];

      for (Map<String, dynamic> json in results) {
        // Transformation du JSON en objet Product
        Product product = jsonToProduct(json);

        products.add(product);
      }

      return products;
    } else {
      throw response;
    }
  }

  /// Récupère le détail d'un produit sur la base de son identifiant.
  ///
  /// Retourne un objet `Product` si la requête est réussie.
  /// Sinon, lève une exception contenant la réponse de la requête.
  Future<Product?> getProduct(int productId) async {
    Response response = await getData("/produits/$productId");

    if (response.statusCode == 200) {
      Map<String, dynamic> json = response.data;

      // Transformation du JSON en objet Product
      Product product = jsonToProduct(json);
      return product;
    } else {
      throw response;
    }
  }

  /// Transformation du JSON d'un produit provenant de l'appel API en
  /// un objet Product du Model
  Product jsonToProduct(Map<String, dynamic> json) {
    Product product = Product(
      id: json['id'] as int,
      nom: json['title'] as String,
      quantiteType: json['overview'] as String,
      prix: json['price'] as double,
      tva: json['tax'] as String,
      quantite: json['quantity'] as double,
    );
    return product;
  }

  User jsonToUser(Map<String, dynamic> json) {
    User user = User(
      id: json['id'] as int,
      email: json['email'] as String,
      password: json['password'] as String,
      roles: json['roles'] as List<String>,
    );
    return user;
  }
  
  Cart jsonToCart(Map<String, dynamic> json) {
    Cart cart = Cart(
      id: json['id'] as int,
      utilisateur: jsonToUser(json['user'] as Map<String, dynamic>),
      statut: json['status'] as String,
      date_facturation: DateTime.parse(json['invoice_date'] as String),
      date_livraison: DateTime.parse(json['delivery_date'] as String),
      commentaire: json['comment'] as String,
      produits: (json['products'] as List<dynamic>)
          .map((p) => jsonToProduct(p as Map<String, dynamic>))
          .toList(),
    );
    return cart;
  }
}
