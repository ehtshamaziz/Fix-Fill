import 'package:get/get.dart';

class CartItem {
  String id;
  String category;
  double price;
  int quantity;
  String shopID;
  CartItem({ required this.id, required this.category, required this.price, required this.quantity, required this.shopID});
}

class Cart {
  List<CartItem> items = [];

  // Adds an item to the cart or increases its quantity if it already exists
  void addItem(CartItem item) {
    var existingItem = items.firstWhereOrNull((it) => it.id == item.id);
    // var existingshop = items.firstWhereOrNull((it) => it.shopID == item.shopID);

    if (existingItem!=null) {
      print(item.price);
      print(item.quantity);
      existingItem.quantity += item.quantity;
      existingItem.price +=item.price;
    } else {
      items.add(item);
    }
  }

  // Removes an item from the cart
  // void removeItem(String itemId) {
  //   items.removeWhere((item) => item.id == itemId);
  // }
  void removeItem(String itemId) {
    for (var item in items) {
      if (item.id == itemId) {
        if (item.quantity > 1) {
          // Decrease quantity by one
          item.quantity -= 1;
        } else {
          // If quantity becomes 0, remove the item from the list
          items.removeWhere((item) => item.id == itemId);
        }
        break; // Exit the loop after updating the item
      }
    }
  }

  // Updates the quantity of an item in the cart
  void updateItemQuantity(String itemId, int quantity) {
    var existingItem = items.firstWhereOrNull((it) => it.id == itemId);
    if (existingItem != null) {
      existingItem.quantity = quantity;
    }


  }

  // Calculates the total price of all items in the cart

  double get totalPrice => items.fold(0, (total, current) => total + (current.price * current.quantity));
}
