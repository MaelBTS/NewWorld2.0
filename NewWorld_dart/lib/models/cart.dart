
import 'package:newworld/models/user.dart';
import 'package:newworld/models/product.dart';

/// Classe `Cart` représente un modèle pour les données du panier.
///
/// Cette classe fournit une structure pour stocker les informations essentielles d'un panier,
/// y compris son identifiant, son nom, sa description, et le chemin de son affiche.
/// Elle offre également une méthode pour obtenir l'URL complet de l'affiche du panier en utilisant
/// l'URL de base pour les images défini dans la classe `API`.
///
/// Usage :
/// Utilisez cette classe pour créer des instances de `Cart` avec des données récupérées
/// depuis une API ou une source de données. Vous pouvez également obtenir l'URL de l'affiche
/// d'un panier en appelant la méthode `posterURL`.
///
/// Exemple :
/// ```dart
/// var Cart = Cart(
///   id: 123,
///   name: "Inception",
///   description: "Un voleur, qui s'infiltre dans les rêves...",
///   posterPath: "/pathToPoster.jpg",
/// );
/// print(Cart.posterURL()); // Affiche l'URL complet de l'affiche.
/// ```
class Cart {
  final int id;
  final User utilisateur;
  final String statut;
  final DateTime? date_facturation;
  final DateTime? date_livraison;
  final String commentaire;
  List<Product> produits;
  late double totalPrice;

  Cart({
    required this.id,
    required this.utilisateur,
    required this.statut,
    required this.date_facturation,
    required this.date_livraison,
    required this.commentaire,
    required this.produits,
    double totalPrice = 0.0,
  }) {
    totalPrice = 0.0;
    for (Product produit in produits) {
      totalPrice += produit.prix;
    }
  }

  String toString() {
    return "Cart{id: $id, utilisateur: ${utilisateur.email}, statut: $statut, date_facturation: $date_facturation, date_livraison: $date_livraison, commentaire: $commentaire, produits: ${produits.map((p) => p.nom).join(', ')}}";
  }
}
