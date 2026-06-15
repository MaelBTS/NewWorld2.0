import 'package:flutter/material.dart';
import 'package:newworld/models/user.dart';
import '../services/api_service.dart';
import '../services/user_preferences.dart';

class UserScreen extends StatefulWidget {
  final User user;

  const UserScreen({super.key, required this.user});

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  late User user;
  final ApiService api = ApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  Future<void> _openEditUserDialog() async {
    final emailController = TextEditingController(text: user.email);
    final passwordController = TextEditingController(text: '');
    final rolesController = TextEditingController(text: user.roles.join(', '));

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier les informations'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir un email';
                    }
                    if (!value.contains('@')) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Nouveau mot de passe',
                    hintText: 'Laisser vide pour ne pas changer',
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return 'Minimum 6 caractères';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() != true) return;

                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                final roles = rolesController.text
                    .split(',')
                    .map((role) => role.trim())
                    .where((role) => role.isNotEmpty)
                    .toList();

                try {
                  await api.patchUser(user.id, email, password, roles);
                  setState(() {
                    user = User(
                      id: user.id,
                      email: email,
                      password: user.password,
                      roles: roles.isNotEmpty ? roles : user.roles,
                    );
                  });
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Informations mises à jour'),
                      ),
                    );
                  }
                } catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erreur lors de la mise à jour : $error'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserPreferences().backgroundColor,
      appBar: AppBar(
        backgroundColor: UserPreferences().backgroundColor,
        foregroundColor: UserPreferences().mainTextColor,
        centerTitle: true,
        title: const Text('Profil utilisateur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  user.email,
                  style: TextStyle(color: UserPreferences().mainTextColor),
                ),
                subtitle: Text(
                  'email : ${user.email}',
                  style: TextStyle(color: UserPreferences().secondaryTextColor),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _openEditUserDialog,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Mot de passe'),
                subtitle: Text(
                  '••••••••',
                  style: TextStyle(color: UserPreferences().secondaryTextColor),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _openEditUserDialog,
                ),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _openEditUserDialog,
              icon: const Icon(Icons.edit),
              label: const Text('Modifier mes informations'),
              style: ElevatedButton.styleFrom(
                backgroundColor: UserPreferences().newWorldColor,
                foregroundColor: UserPreferences().mainTextColor,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Supprimer le compte'),
                    content: const Text('Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
                if (confirm != true) return;
                try {
                  await ApiService().deleteUser(user);
                  if (context.mounted) {
                    UserPreferences().isLoggedIn = false;
                    UserPreferences().userId = null;
                    UserPreferences().username = null;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Compte supprimé')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: $e')),
                    );
                  }
                }
              },
              icon: const Icon(Icons.delete),
              label: const Text('supprimer mon compte'),
              style: ElevatedButton.styleFrom(
                backgroundColor: UserPreferences().newWorldColor,
                foregroundColor: UserPreferences().mainTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
