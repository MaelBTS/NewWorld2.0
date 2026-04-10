import '../services/api.dart';

/// Classe `Movie` représente un modèle pour les données de film.
///
/// Cette classe fournit une structure pour stocker les informations essentielles d'un film,
/// y compris son identifiant, son nom, sa description, et le chemin de son affiche.
/// Elle offre également une méthode pour obtenir l'URL complet de l'affiche du film en utilisant
/// l'URL de base pour les images défini dans la classe `API`.
///
/// Usage :
/// Utilisez cette classe pour créer des instances de `Movie` avec des données récupérées
/// depuis une API ou une source de données. Vous pouvez également obtenir l'URL de l'affiche
/// d'un film en appelant la méthode `posterURL`.
///
/// Exemple :
/// ```dart
/// var movie = Movie(
///   id: 123,
///   name: "Inception",
///   description: "Un voleur, qui s'infiltre dans les rêves...",
///   posterPath: "/pathToPoster.jpg",
/// );
/// print(movie.posterURL()); // Affiche l'URL complet de l'affiche.
/// ```
class Product {
  final int id;
  final String nom;
  final String quantiteType;

  Product({
    required this.id,
    required this.nom,
    required this.quantiteType,
  });
}
