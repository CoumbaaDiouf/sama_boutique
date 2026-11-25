import 'package:flutter/material.dart';

import '../controllers/cart_controller.dart';
import '../widgets/cart_item_tile.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartController.instance;

    return Scaffold(
      body: AnimatedBuilder(
        animation: cart,
        builder: (context, child) {
          // Panier vide
          if (cart.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text('Votre panier est vide', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          // Panier avec produits
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    return CartItemTile(item: cart.items[index]);
                  },
                ),
              ),

              // Résumé : total + vider le panier
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${cart.itemCount} article(s)'),
                        Text(
                          'Total : \$${cart.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: cart.clear,
                      icon: const Icon(Icons.delete_sweep_outlined),
                      label: const Text('Vider'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
