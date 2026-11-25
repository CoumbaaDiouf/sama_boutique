import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartController extends ChangeNotifier {
  CartController._internal();
  static final CartController instance = CartController._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  // Nombre total d'articles (somme des quantités)
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  // Total du panier
  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.total);

  // Ajoute un produit. Retourne false si le stock est atteint.
  bool addProduct(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      if (_items[index].quantity >= product.stock) return false;
      _items[index].quantity++;
    } else {
      if (product.stock <= 0) return false;
      _items.add(CartItem(product: product));
    }

    notifyListeners();
    return true;
  }

  void increase(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    final item = _items[index];
    if (item.quantity < item.product.stock) {
      item.quantity++;
      notifyListeners();
    }
  }

  void decrease(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void remove(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
