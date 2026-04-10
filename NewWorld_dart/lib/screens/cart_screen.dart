import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/user_preferences.dart';
import '../widgets/product_card.dart';
import 'user_gestion_screen.dart';

/// Widget MovieScreen qui affiche les détails d'un film
class MovieScreen extends StatefulWidget {
  final int movieId;
  final VoidCallback onGoBack;
  const MovieScreen({super.key, required this.movieId, required this.onGoBack});
  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  String appBarTitle = "Chargement...";
  late Future<Product?> movie;
  @override
  void initState() {
    super.initState();
    movie = ApiService().getMovie(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserPreferences().backgroundColor,
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: UserPreferences().netflimColor,
        foregroundColor: UserPreferences().mainTextColor,
      ),
      body: FutureBuilder<Product?>(
        future: movie,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                    color: UserPreferences().netflimColor));
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
// Récupération du movie
            final movie = snapshot.data;
            if (movie != null) {
// Mettre à jour le titre de l'appBar une fois que le
// film est chargé
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  appBarTitle = movie.nom;
                });
              });
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${movie.tagline}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ), // Affiche le slogan du film
                          Text(
                            'Sortie le ${movie.releaseDate}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ), // Affiche la date de sortie
                          Text(
                            'Genres: ${movie.genres?.join(', ')}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ), // Affiche les genres
                          Text(
                            'Durée: ${movie.runtime} minutes',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ), // Affiche la durée
                          Text(
                            'Note: ${movie.voteAverage}/10',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ), // Affiche la note des internautes
                          const SizedBox(height: 8),
                          // Synopsis du film
                          Text(
                            "Synopsis",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            movie.description,
                            textAlign: TextAlign.justify,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: UserPreferences().mainTextColor),
                          ),
                          for (String key in movie.youtubeKey)
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        YoutubeVideoScreen(videoId: key),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: UserPreferences().netflimColor,
                                foregroundColor:
                                    UserPreferences().mainTextColor,
                              ),
                              child: Text(movie
                                  .youtubeTitle[movie.youtubeKey.indexOf(key)]),
                            ), // Affiche les clés YouTube associées au film
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
// Gestion du cas où `movie` est null
              return const Center(child: Text("Film non trouvé"));
            }
          } else {
            return const Center(child: Text('Aucune donnée'));
          }
        },
      ),
      bottomNavigationBar: FutureBuilder<Product?>(
        future: movie,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return SizedBox.shrink(); // Pas d'erreur pendant loading
          }

          final Product currentMovie = snapshot.data!;
        },
      ),
    );
  }
}
