import 'package:flutter/material.dart';
import 'package:newworld/models/user.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../services/user_preferences.dart';
import '../services/favorite.dart';
import 'cart_screen.dart';
import '../widgets/product_search_bar.dart';

class UserScreen extends StatefulWidget {
  final User user;

  const UserScreen(
      {super.key, required this.user});

  @override
  UserScreen createState() => UserScreen();
}

class UserScreenState extends State<UserScreen> {
  late String? title;
  late User user;
  ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  void onQueryChanged(String search) async {
    title = "utilisateurs";
    user = widget.user;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserPreferences().backgroundColor,
      body: Column(
        children: [
          title != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title!,
                    style: TextStyle(
                      fontSize: 18,
                      color: UserPreferences().mainTextColor,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    user.email,
                    style: TextStyle(color: UserPreferences().mainTextColor),
                  ),
                  subtitle: Text(
                    'Plus de détails...',
                    style:
                        TextStyle(color: UserPreferences().secondaryTextColor),
                  ),
                  onTap: () async {
                    // Requête vers l'API pour récupérer toutes les informations
                    // complémentaires de l'utilisateur
                    user = (await ApiService().getUser(user.id))!;
                    // Navigue vers le UserScreen avec les détails de l'utilisateur
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserScreen(
                          user: user,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
