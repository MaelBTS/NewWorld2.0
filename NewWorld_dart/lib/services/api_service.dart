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

  ApiService() {
    dio.options.validateStatus = (_) => true;
  }

  String _normalizePath(String path) {
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    return path;
  }

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
    String url = api.baseUrl + _normalizePath(path);

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
    }

    throw Exception(
      'GET $url failed with status ${response.statusCode}: ${response.statusMessage}',
    );
  }

  Future<Response> postData(String path, {Map<String, dynamic>? params}) async {
    // Construction de l'URL complète
    String url = api.baseUrl + _normalizePath(path);

    // Ajout des paramètres de requête par défaut et ceux fournis
    Map<String, dynamic> query = {};

    // Ajout des paramètres optionnels
    if (params != null) {
      query.addAll(params);
    }

    // Lancement de la requète
    final response = await dio.post(url, data: query);

    if (response.statusCode == 200) {
      return response;
    }

    throw Exception(
      'POST $url failed with status ${response.statusCode}: ${response.statusMessage}',
    );
  }

  Future<Response> patchData(
    String path, {
    Map<String, dynamic>? params,
  }) async {
    // Construction de l'URL complète
    String url = api.baseUrl + _normalizePath(path);

    // Ajout des paramètres de requête par défaut et ceux fournis
    Map<String, dynamic> query = {};

    // Ajout des paramètres optionnels
    if (params != null) {
      query.addAll(params);
    }

    // Lancement de la requète
    final response = await dio.patch(url, data: query);

    if (response.statusCode == 200) {
      return response;
    }

    throw Exception(
      'PATCH $url failed with status ${response.statusCode}: ${response.statusMessage}',
    );
  }

  Future<Response> deleteData(
    String path, {
    Map<String, dynamic>? params,
  }) async {
    // Construction de l'URL complète
    String url = api.baseUrl + _normalizePath(path);

    // Ajout des paramètres de requête par défaut et ceux fournis
    Map<String, dynamic> query = {};

    // Ajout des paramètres optionnels
    if (params != null) {
      query.addAll(params);
    }

    // Lancement de la requète
    final response = await dio.delete(url, queryParameters: query);

    if (response.statusCode == 200) {
      return response;
    }

    throw Exception(
      'DELETE $url failed with status ${response.statusCode}: ${response.statusMessage}',
    );
  }

  /// Récupère une liste des produits populaires à partir de l'API.
  ///
  /// [pageNumber] Le numéro de la page à récupérer pour la pagination des résultats.
  ///
  /// Retourne une liste d'objets `Product` si la requête est réussie.
  /// Sinon, lève une exception contenant la réponse de la requête.
  Future<List<Product>> getProducts(int pageNumber) async {
    Response response = await getData(
      "/produits",
      params: {'page': pageNumber},
    );

    if (response.statusCode == 200) {
      Map data = response.data;

      final resultsData = data["results"];
      if (resultsData == null || resultsData is! List) {
        return [];
      }

      List<dynamic> results = resultsData;
      List<Product> products = [];

      for (Map<String, dynamic> json in results) {
        String quantityType = await getQuantityType(
          json['quantite_type_id'] as int,
        );
        List<String> productOverTime = await getProductOverTime(
          json['id'] as int,
        );
        String producteur = await getProducteur(json['producteur_id'] as int);
        // Transformation du JSON en objet Product
        Product product = jsonToProduct(json);
        product.quantiteType = quantityType; // Mise à jour du type de quantité
        product.prix =
            double.tryParse(productOverTime[3]) ?? 0.0; // Mise à jour du prix
        product.tva = productOverTime[1]; // Mise à jour de la TVA
        product.quantite =
            double.tryParse(productOverTime[2]) ??
            0.0; // Mise à jour de la quantité
        product.producteur = producteur; // Mise à jour du producteur
        product.idProduitSurLeTemps = int.parse(
          productOverTime[0],
        ); // Mise à jour de l'id du produit sur le temps
        products.add(product);
      }

      return products;
    } else {
      throw response;
    }
  }

  Future<String> getQuantityType(int id) async {
    Response response = await getData("/quantite_types/$id");

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      return data['type'] as String;
    } else {
      throw response;
    }
  }

  Future<List<String>> getProductOverTime(int id) async {
    Response response = await getData("/produit_sur_le_temps");

    if (response.statusCode == 200) {
      Map data = response.data;

      final resultsData = data["results"];
      if (resultsData == null || resultsData is! List) {
        return ["0", "", "0.0", "0.0"];
      }

      List<dynamic> results = resultsData;

      for (Map<String, dynamic> json in results) {
        if (json['produit_id'] == id &&
            (json['date_fin_prix_vente'] >
                    DateTime.now().toIso8601String().substring(0, 10) ||
                json['date_fin_prix_vente'] == null) &&
            (json['date_fin_tva'] >
                    DateTime.now().toIso8601String().substring(0, 10) ||
                json['date_fin_tva'] == null)) {
          return [
            json['id'] as String,
            json['tva'] as String,
            json['quantite'] as String,
            json['prix_vente'] as String,
          ];
        }
      }
      return ["0.0", "", "0.0"];
    } else {
      throw response;
    }
  }

  Future<String> getProducteur(int id) async {
    Response response = await getData("/producteurs/$id");

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      return data['nom'] as String;
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
    int pageNumber,
    String searchString,
  ) async {
    Response response = await getData(
      "/produits",
      params: {'page': pageNumber,
        'search': searchString,
      },
    );

    if (response.statusCode == 200) {
      Map data = response.data;

      List<dynamic> results = data["results"];
      List<Product> products = [];

      for (Map<String, dynamic> json in results) {
        if (json['nom'].toString().toLowerCase().contains(
          searchString.toLowerCase(),
        )) {
          String quantityType = await getQuantityType(
            json['quantite_type_id'] as int,
          );
          List<String> productOverTime = await getProductOverTime(
            json['id'] as int,
          );
          // Transformation du JSON en objet Product
          Product product = jsonToProduct(json);
          product.quantiteType =
              quantityType; // Mise à jour du type de quantité
          product.prix =
              double.tryParse(productOverTime[3]) ?? 0.0; // Mise à jour du prix
          product.tva = productOverTime[1]; // Mise à jour de la TVA
          product.quantite =
              double.tryParse(productOverTime[2]) ??
              0.0; // Mise à jour de la quantité
          product.idProduitSurLeTemps = int.parse(
            productOverTime[0],
          ); // Mise à jour de l'id du produit sur le temps
          products.add(product);
        }
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

      final int? quantityTypeId = json['quantite_type_id'] is int
          ? json['quantite_type_id'] as int
          : null;
      final int? productId = json['id'] is int ? json['id'] as int : null;

      String quantityType = '';
      if (quantityTypeId != null) {
        quantityType = await getQuantityType(quantityTypeId);
      }

      List<String> productOverTime = productId != null
          ? await getProductOverTime(productId)
          : ["0", "", "0.0", "0.0"];

      // Transformation du JSON en objet Product
      Product product = jsonToProduct(json);
      product.quantiteType = quantityType; // Mise à jour du type de quantité
      product.prix =
          double.tryParse(productOverTime[3]) ?? 0.0; // Mise à jour du prix
      product.tva = productOverTime.length > 1
          ? productOverTime[1]
          : ''; // Mise à jour de la TVA
      product.quantite =
          double.tryParse(
            productOverTime.length > 2 ? productOverTime[2] : '0.0',
          ) ??
          0.0; // Mise à jour de la quantité
      return product;
    } else {
      throw response;
    }
  }

  Future<User?> getUser(int userId) async {
    try {
      Response response = await getData("/users/$userId");
      if (response.statusCode == 200) {
        Map<String, dynamic> json = response.data;
        return jsonToUser(json);
      }
    } catch (_) {
      // Fallback when the detail endpoint is not available.
      Response response = await getData("/users");
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'] as List<dynamic>? ?? [];
        for (final dynamic userJson in results) {
          if (userJson is Map<String, dynamic> && userJson['id'] == userId) {
            return jsonToUser(userJson);
          }
        }
      }
    }

    return null;
  }
  
  Future<User?> login(String email, String password) async {
    Response response = await getData("/users");

    if (response.statusCode == 200) {
      Map<String, dynamic> json = response.data;
      User? user;
      User tryingUser;
      for (Map<String, dynamic> userJson in json['results'] as List<dynamic>) {
        tryingUser = jsonToUser(userJson);
        if (tryingUser.email == email && tryingUser.password == password) {
          user = tryingUser;
          break;
        }
      }
      return user;
    } else {
      throw response;
    }
  }

  /// Récupère l'identifiant du panier associé à un utilisateur.
  ///
  /// Retourne `null` si aucun panier n'est trouvé pour l'utilisateur.
  Future<int?> getCartIdByUserId(int userId) async {
    Response response = await getData(
      "/paniers/",
      params: {'utilisateur_id': userId},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      List<dynamic> results = data['results'] as List<dynamic>? ?? [];
      if (results.isNotEmpty) {
        return results.first['id'] as int?;
      }
      return null;
    } else {
      throw response;
    }
  }

  Future<Cart?> getCart(int cartId) async {
    Response response = await getData("/paniers/$cartId");

    if (response.statusCode == 200) {
      Response liaison = await getData("/produit_paniers/?panier_id=$cartId");
      Map<String, dynamic> json = response.data;
      if (liaison.statusCode == 200) {
        json['products'] = liaison.data['results'];
      } else {
        throw liaison;
      }
      List<Product> products = [];
      for (Map<String, dynamic> product in json['products'] as List<dynamic>) {
        Product? p = await getProduct(product['id'] as int);
        if (p != null) products.add(p);
      }
      return jsonToCart(json, products);
    } else {
      throw response;
    }
  }

  /// Transformation du JSON d'un produit provenant de l'appel API en
  /// un objet Product du Model
  Product jsonToProduct(Map<String, dynamic> json) {
    Product product = Product(
      id: json['id'] as int,
      nom: json['nom'] as String,
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

  Cart jsonToCart(Map<String, dynamic> json, List<Product> products) {
    Cart cart = Cart(
      id: json['id'] as int,
      utilisateur: getUser(json['utilisateur_id'] as int) as User,
      statut: json['statut'] as String,
      date_facturation: DateTime.parse(json['date_facturation'] as String),
      date_livraison: DateTime.parse(json['date_livraison'] as String),
      commentaire: json['commentaire'] as String,
      produits: products,
    );
    return cart;
  }

  Future<int> addToCart(int cartId, int productId, double quantity) async {
    Response response = await postData(
      "/produit_paniers",
      params: {
        'panier_id': cartId,
        'product_id': productId,
        'quantity': quantity,
      },
    );

    if (response.statusCode == 200) {
      // Produit ajouté au panier avec succès
      return 1;
    } else {
      throw response;
    }
  }

  Future<int> removeFromCart(int cartId, int productId) async {
    Response response = await deleteData(
      "/produit_paniers/?panier_id=$cartId&product_id=$productId",
    );

    if (response.statusCode == 200) {
      // Produit retiré du panier avec succès
      return 1;
    } else {
      throw response;
    }
  }

  Future<int> updateCart(int cartId, int productId, double quantity) async {
    Response response = await patchData(
      "/produit_paniers/?panier_id=$cartId&product_id=$productId",
      params: {'quantity': quantity},
    );

    if (response.statusCode == 200) {
      // Quantité du produit mise à jour avec succès
      return 1;
    } else {
      throw response;
    }
  }

  Future<int> payCart(Cart cart) async {
    for (Product product in cart.produits) {
      removeFromCart(cart.id, product.id);
      Response responseReduceQuantity = await getData(
        "/produit_paniers/?panier_id=${cart.id}&product_id=${product.id}",
      );
      Map<String, dynamic> data = responseReduceQuantity.data;
      int productQuantite = data['quantite'] as int;

      Response response = await patchData(
        "/produit_sur_le_temps/${product.idProduitSurLeTemps}",
        params: {'quantite': product.quantite - productQuantite},
      );
      if (response.statusCode == 200) {
        // Quantité du produit mise à jour avec succès
      } else {
        throw response;
      }
    }
    Response response = await patchData(
      "/paniers/${cart.id}",
      params: {
        'statut': 'payé',
        'date_facturation': DateTime.now().toIso8601String().substring(0, 10),
      },
    );

    if (response.statusCode == 200) {
      // Panier validé avec succès
      return 1;
    } else {
      throw response;
    }
  }

  Future<int> deliverCart(Cart cart) async {
    Response response = await patchData(
      "/paniers/${cart.id}",
      params: {
        'date_livraison': DateTime.now().toIso8601String().substring(0, 10),
      },
    );

    Response responseArchive = await postData(
      "/archives/",
      params: {
        'type': 'cart',
        'ancien_id': cart.id,
        'data': cart.toString(),
        'date_archivage': DateTime.now().toIso8601String().substring(0, 10),
      },
    );

    if (responseArchive.statusCode == 200 && response.statusCode == 200) {
      // Panier livré avec succès
      return 1;
    } else {
      throw response;
    }
  }

  Future<int> postUser(
    String email,
    String password,
    List<String> roles,
  ) async {
    Response response = await postData(
      "/users",
      params: {'email': email, 'password': password, 'roles': roles},
    );
    Response responseCart = await postData(
      "/paniers",
      params: {
        'utilisateur_id': response.data['id'] as int,
        'statut': 'en cours',
        'date_facturation': null,
        'date_livraison': null,
        'commentaire': '',
      },
    );

    if (response.statusCode == 200 && responseCart.statusCode == 200) {
      // Utilisateur créé avec succès
      return 1;
    } else {
      throw response;
    }
  }

  Future<int> patchUser(
    int userId,
    String email,
    String password,
    List<String> roles,
  ) async {
    Response response = await patchData(
      "/users/$userId",
      params: {'email': email, 'password': password, 'roles': roles},
    );

    if (response.statusCode == 200) {
      // Utilisateur mis à jour avec succès
      return 1;
    } else {
      throw response;
    }
  }

  Future<int> deleteUser(User user) async {
    Response response = await deleteData("/users/${user.id}");

    Response responseArchive = await postData(
      "/archives/",
      params: {
        'type': 'user',
        'ancien_id': user.id,
        'data': user.toString(),
        'date_archivage': DateTime.now().toIso8601String().substring(0, 10),
      },
    );

    if (response.statusCode == 200 && responseArchive.statusCode == 200) {
      // Utilisateur supprimé avec succès
      return 1;
    } else {
      throw response;
    }
  }
}
