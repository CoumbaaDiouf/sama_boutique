import 'package:flutter/material.dart';

import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  // Création du Controller
  late ProductController controller;

  @override
  void initState() {
    super.initState();

    // Initialisation du Controller
    controller = ProductController();

    // Chargement des produits
    controller.fetchProducts();
  }

  @override
  void dispose() {
    // Libération des ressources
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: controller,

        builder: (context, child) {
          // Etat 1 : Chargement
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Etat 2 : Erreur
          if (controller.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),

                  const SizedBox(height: 10),

                  Text(controller.errorMessage!),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: controller.fetchProducts,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          // Etat 3 : Aucun produit
          if (controller.products.isEmpty) {
            return const Center(child: Text('Aucun produit disponible'));
          }

          // Etat 4 : Affichage des produits
          return RefreshIndicator(
            onRefresh: controller.fetchProducts,

            child: GridView.builder(
              padding: const EdgeInsets.all(12),

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.5,
              ),

              itemCount: controller.products.length,

              itemBuilder: (context, index) {
                final product = controller.products[index];

                return ProductCard(product: product);
              },
            ),
          );
        },
      ),
    );
  }
}
