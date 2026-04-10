import 'package:flutter/material.dart';

import '../services/user_preferences.dart';

enum LoadingStatus { loading, success, error }

class StartScreen extends StatelessWidget {
  final LoadingStatus loadingStatus;
  final VoidCallback onReload;

  const StartScreen({
    super.key,
    required this.loadingStatus,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserPreferences().backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/netflim.png"),
            const SizedBox(height: 20),
            if (loadingStatus == LoadingStatus.loading) ...[
              CircularProgressIndicator(color: UserPreferences().netflimColor),
            ] else if (loadingStatus == LoadingStatus.error) ...[
              Text(
                "-Service indisponible-",
                style: TextStyle(
                    color: UserPreferences().mainTextColor, fontSize: 16),
              ),
              FloatingActionButton(
                backgroundColor: UserPreferences().netflimColor,
                onPressed: onReload,
                child: const Icon(Icons.refresh),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
