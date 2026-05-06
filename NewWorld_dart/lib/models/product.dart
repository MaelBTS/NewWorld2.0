
/// Classe `Product` représente un modèle pour les données de produit.
///
/// Cette classe fournit une structure pour stocker les informations essentielles d'un produit,
/// y compris son identifiant, son nom, sa description, et le chemin de son affiche.
/// Elle offre également une méthode pour obtenir l'URL complet de l'affiche du produit en utilisant
/// l'URL de base pour les images défini dans la classe `API`.
///
/// Usage :
/// Utilisez cette classe pour créer des instances de `Product` avec des données récupérées
/// depuis une API ou une source de données. Vous pouvez également obtenir l'URL de l'affiche
/// d'un produit en appelant la méthode `posterURL`.
///
/// Exemple :
/// ```dart
/// var product = Product(
///   id: 123,
///   name: "Inception",
///   description: "Un voleur, qui s'infiltre dans les rêves...",
///   posterPath: "/pathToPoster.jpg",
/// );
/// print(product.posterURL()); // Affiche l'URL complet de l'affiche.
/// ```
class Product {
  final int id;
  final String nom;
  final String quantiteType;
  final double prix;
  final String tva;
  final double quantite;

  Product({
    required this.id,
    required this.nom,
    required this.quantiteType,
    required this.prix,
    required this.tva,
    required this.quantite,
  });
}
