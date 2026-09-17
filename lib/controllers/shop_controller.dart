import 'package:get/get.dart';

import '../models/home_models.dart';

class CartLine {
  CartLine(this.product, {this.quantity = 1});

  final Product product;
  int quantity;

  double get subtotal => product.price * quantity;
}

class ShopController extends GetxController {
  static ShopController get to => Get.find();

  final RxList<CartLine> cart = <CartLine>[].obs;
  final RxList<Product> wishlist = <Product>[].obs;

  int get cartCount =>
      cart.fold(0, (sum, line) => sum + line.quantity);

  double get cartTotal =>
      cart.fold(0.0, (sum, line) => sum + line.subtotal);

  bool isInCart(Product product) =>
      cart.any((line) => line.product.name == product.name);

  bool isWishlisted(Product product) =>
      wishlist.any((item) => item.name == product.name);

  void addToCart(Product product) {
    final index =
        cart.indexWhere((line) => line.product.name == product.name);
    if (index == -1) {
      cart.add(CartLine(product));
    } else {
      cart[index].quantity++;
      cart.refresh();
    }
  }

  void decrement(Product product) {
    final index =
        cart.indexWhere((line) => line.product.name == product.name);
    if (index == -1) return;
    if (cart[index].quantity > 1) {
      cart[index].quantity--;
      cart.refresh();
    } else {
      cart.removeAt(index);
    }
  }

  void removeFromCart(Product product) {
    cart.removeWhere((line) => line.product.name == product.name);
  }

  void clearCart() => cart.clear();

  void toggleWishlist(Product product) {
    final index = wishlist.indexWhere((item) => item.name == product.name);
    if (index == -1) {
      wishlist.add(product);
    } else {
      wishlist.removeAt(index);
    }
  }
}
