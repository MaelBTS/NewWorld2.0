import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../services/user_preferences.dart';
import '../services/cart_interaction.dart';
import 'cart_screen.dart';
import '../widgets/movie_search_bar.dart';

class MoviesListScreen extends StatefulWidget {
  final List<Product> movies;
  final String? titleMode;
  final bool? displaySearchBar;

  const MoviesListScreen(
      {super.key, required this.movies, this.titleMode, this.displaySearchBar});

  @override
  MoviesListScreenState createState() => MoviesListScreenState();
}

class MoviesListScreenState extends State<MoviesListScreen> {
  late String? title;
  late List<Product> movies;
  ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    movies = widget.movies;
    title = widget.titleMode ?? "Films populaires";
  }

  void onQueryChanged(String search) async {
    if (search.isEmpty) {
      title = "films populaires";
      movies = widget.movies;
    } else {
      title = "votre recherche";
      movies = await api.searchForMovies(1, search);
    }
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
          MovieSearchBar(onQueryChanged: onQueryChanged),
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                Product movie = movies[index];
                return ListTile(
                  title: Text(
                    movie.nom,
                    style: TextStyle(color: UserPreferences().mainTextColor),
                  ),
                  subtitle: Text(
                    'Plus de détails...',
                    style:
                        TextStyle(color: UserPreferences().secondaryTextColor),
                  ),
                  onTap: () async {
                    // Requête vers l'API pour récupérer toutes les informations
                    // complémentaires du film
                    movie = (await ApiService().getMovie(movie.id))!;
                    // Navigue vers le MovieScreen avec les détails du film
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieScreen(
                          movieId: movie.id,
                          onGoBack: () => setState(() {}),
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(
                      Favourites().isAFavourite(movie)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        Favourites().isAFavourite(movie)
                            ? Favourites().removeFromFavourites(movie)
                            : Favourites().addToFavourites(movie);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
