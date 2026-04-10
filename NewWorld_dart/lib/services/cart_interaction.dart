import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class Favourites {
  static final Favourites _instance = Favourites._internal();

  factory Favourites() {
    return _instance;
  }

  Favourites._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  addToFavourites(Product product) {
    List<String> favourites = _prefs?.getStringList('Favourites') ?? [];
    final productId = product.id.toString();
    if (!favourites.contains(productId)) {
      favourites.add(productId);
      _prefs?.setStringList('Favourites', favourites);
    }
  }

  bool isAFavourite(Product product) {
    List<String> favourites = _prefs?.getStringList('Favourites') ?? [];
    final productId = product.id.toString();
    return favourites.contains(productId);
  }

  removeFromFavourites(Product product) async {
    List<String> favourites = _prefs?.getStringList('Favourites') ??[];
    final productId = product.id.toString();
    if (favourites != [] && favourites.contains(productId)){
      favourites.remove(productId);
      _prefs?.setStringList('Favourites', favourites);
    }
  }
    
  list(){
    List<String> favourites = _prefs?.getStringList('Favourites') ?? [];
    return favourites;
  }
}
