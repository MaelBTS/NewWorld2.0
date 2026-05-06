/// Classe `API` centralise la configuration nécessaire pour accéder à l'API de new world serveur.
///
/// Cette classe contient l'URL de base de l'API, et l'URL de base pour accéder aux images.
/// Elle est utilisée pour construire les requêtes vers l'API de TMDB et récupérer des informations
/// sur les produits, les affiches de produits, etc.
///
/// Utilisation :
/// - `baseUrl` sert de point de départ pour toutes les requêtes API vers TMDB.
/// - `baseImageUrl` est utilisé pour construire les URL complets des images de produits, telles que les affiches.
///
/// Important :
/// La clé API doit être tenue secrète et ne pas être exposée publiquement, par exemple, dans des dépôts de code source ouverts.
/// Assurez-vous de suivre les meilleures pratiques pour sécuriser votre clé API.
class API {
  /// L'URL de base pour les requêtes API vers TMDB.
  final String baseUrl = 'http://localhost:8000/api';
}
