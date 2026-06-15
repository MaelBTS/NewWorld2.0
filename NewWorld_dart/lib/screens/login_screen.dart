import 'package:flutter/material.dart';
import '../services/user_preferences.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLogin;

  const LoginScreen({super.key, this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      User? user = await ApiService().login(email, password);

      if (!mounted) return;

      if (user != null) {
        UserPreferences().userId = user.id; // ✅ stocker l'ID utilisateur
        UserPreferences().username = email;
        UserPreferences().isLoggedIn = true; // ✅ marquer l'utilisateur comme connecté
        widget.onLogin?.call(); // ✅ navigation après login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email ou mot de passe incorrect')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    } finally {
      if (mounted)
        {setState(() => _isSubmitting = false);} // ✅ toujours remis à false
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserPreferences().backgroundColor,
      appBar: AppBar(
        title: const Text('Connexion'),
        centerTitle: true,
        backgroundColor: UserPreferences().backgroundColor,
        foregroundColor: UserPreferences().mainTextColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Bienvenue',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: UserPreferences().mainTextColor),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: UserPreferences().mainTextColor,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: const OutlineInputBorder(),
                          labelStyle: TextStyle(
                            color: UserPreferences().mainTextColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Veuillez saisir votre email';
                          }
                          if (!value.contains('@')) {
                            return 'Adresse email invalide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: TextStyle(
                          color: UserPreferences().mainTextColor,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          border: const OutlineInputBorder(),
                          labelStyle: TextStyle(
                            color: UserPreferences().mainTextColor,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Veuillez saisir votre mot de passe';
                          }
                          if (value.trim().length < 6) {
                            return 'Au moins 6 caractères requis';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: UserPreferences().newWorldColor,
                          foregroundColor: UserPreferences().mainTextColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _isSubmitting ? null : _submit,
                        child: _isSubmitting
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: UserPreferences().mainTextColor,
                                ),
                              )
                            : const Text('Se connecter'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
