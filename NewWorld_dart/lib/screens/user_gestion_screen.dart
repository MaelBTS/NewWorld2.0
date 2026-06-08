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
    final passwordController = TextEditingController(text: user.password);
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
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir un mot de passe';
                    }
                    if (value.length < 6) {
                      return 'Minimum 6 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: rolesController,
                  decoration: const InputDecoration(
                    labelText: 'Rôles (séparés par des virgules)',
                  ),
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
                      password: password,
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
                  'ID : ${user.id}',
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
            const SizedBox(height: 12),
            Card(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('Rôles'),
                subtitle: Text(
                  user.roles.join(', '),
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
          ],
        ),
      ),
    );
  }
}
