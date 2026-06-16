import 'package:flutter/material.dart';
import '../services/user_preferences.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback? onRegister;

  const RegisterScreen({super.key, this.onRegister});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _tvaController = TextEditingController();
  bool _isIndividual = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _tvaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserPreferences().backgroundColor,
      appBar: AppBar(
        title: const Text('Inscription'),
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
                      const SizedBox(height: 16),
                      RadioGroup<bool>(
                        groupValue: _isIndividual,
                        onChanged: (value) {
                          setState(() {
                            _isIndividual = value ?? true;
                          });
                        },
                        child: RadioListTile<bool>(
                          title: const Text('commercant'),
                          value: false,
                          toggleable: true,
                        ),
                      ),
                      if (!_isIndividual) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _tvaController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: UserPreferences().mainTextColor,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Numero tva intracommunautaire',
                            border: const OutlineInputBorder(),
                            labelStyle: TextStyle(
                              color: UserPreferences().mainTextColor,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez saisir votre numéro de tva intracommunautaire';
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: UserPreferences().newWorldColor,
                          foregroundColor: UserPreferences().mainTextColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _isSubmitting
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate())
                                  return; // ✅ validation

                                setState(
                                  () => _isSubmitting = true,
                                ); // ✅ début chargement

                                try {
                                  await ApiService().postUser(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                    [],
                                  );

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Inscription réussie !'),
                                      ),
                                    );
                                    widget.onRegister?.call();
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Erreur : $e')),
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(
                                      () => _isSubmitting = false,
                                    ); // ✅ fin chargement
                                  }
                                }
                              },
                        child: _isSubmitting
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: UserPreferences().mainTextColor,
                                ),
                              )
                            : const Text('S\'inscrire'),
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
