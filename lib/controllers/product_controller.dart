import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductController extends ChangeNotifier {
  // URL de l'API
  final String apiUrl = 'https://dummyjson.com/products';

  //Liste des produits
  List<Product> products = [];

  // Etats de chargement
  bool isLoading = false;

  // Gestion des erreurs
  String? errorMessage;

  // Méthode pour récupérer les produits depuis l'API
  Future<void> fetchProducts() async {
    //Debut du chargement
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Requette HTTP get
      final response = await http.get(Uri.parse(apiUrl));
      // Vérification du statut HTTP
      if (response.statusCode == 200) {
        // Conversion JSON
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Récupération du tableau produits
        final List<dynamic> productList = data['products'];

        // conversion en liste d'objet Product
        products = productList.map((item) {
          return Product.fromJSON(item);
        }).toList();
      } else {
        throw Exception('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      errorMessage = "Impossible de charger les produits. ";
      debugPrint('Erreur : $e');
    } finally {
      // Fin du chargement
      isLoading = false;

      //Notication de la view
      notifyListeners();
    }
  }
  //
}
