
/// Classe `User` représente un modèle pour les données de l'utilisateur.
///
/// Cette classe fournit une structure pour stocker les informations essentielles d'un utilisateur,
/// y compris son identifiant, son email, et son mot de passe.
/// Elle offre également une méthode pour obtenir l'URL complet de l'affiche de l'utilisateur en utilisant
/// l'URL de base pour les images défini dans la classe `API`.
///
/// Usage :
/// Utilisez cette classe pour créer des instances de `User` avec des données récupérées
/// depuis une API ou une source de données. Vous pouvez également obtenir l'URL de l'affiche
/// d'un utilisateur en appelant la méthode `posterURL`.
///
/// Exemple :
/// ```dart
/// var User = User(
///   id: 123,
///   email: "john.doe@example.com",
///   password: "securePassword123",
/// );
/// print(Product.posterURL()); // Affiche l'URL complet de l'affiche.
/// ```
class User {
  final int id;
  final String email;
  final String password;
  final List<String> roles;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.roles,
  });

  String toString() {
    return "User{id: $id, email: $email, password: $password, roles: ${roles.join(', ')}}";
  }
}
