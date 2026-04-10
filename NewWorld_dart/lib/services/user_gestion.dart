import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class ListToWatch {
  static final ListToWatch _instance = ListToWatch._internal();

  factory ListToWatch() {
    return _instance;
  }

  ListToWatch._internal();
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  addToListToWatch(Product product) {
    List<String> listToWatch = _prefs?.getStringList('ListToWatch') ?? [];
    final productId = product.id.toString();
    if (!listToWatch.contains(productId)) {
      listToWatch.add(productId);
      _prefs?.setStringList('ListToWatch', listToWatch);
    }
  }

  bool isOnListToWatch(Product product) {
    List<String> listToWatch = _prefs?.getStringList('ListToWatch') ?? [];
    final productId = product.id.toString();
    return listToWatch.contains(productId);
  }

  removeFromListToWatch(Product product) async {
    List<String> listToWatch = _prefs?.getStringList('ListToWatch') ??[];
    final productId = product.id.toString();
    if (listToWatch != [] && listToWatch.contains(productId)){
      listToWatch.remove(productId);
      _prefs?.setStringList('ListToWatch', listToWatch);
    }
  }
  
  list(){
    List<String> listToWatch = _prefs?.getStringList('ListToWatch') ?? [];
    return listToWatch;
  }
}


  
