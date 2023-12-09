import 'package:get/get.dart';

import '../model/CartData.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();
  final Cart cart = Cart();
  Map<String, List<CartItem>> cartItemsByStation = {};
  Map<String, List<CartItem>> groupedItems = {};

  List<CartItem> get items => cart.items;
  double get totalPrice => cart.totalPrice;

  void addItem(CartItem item) {
    cart.addItem(item);
    update(); // Notify listeners for updates
  }
  void removeStationItems(String stationId) {
    items.removeWhere((item) => item.shopID == stationId);
    groupCartItems(); // Regroup items after removal
  }

  void groupCartItems() {
    groupedItems.clear(); // Clear existing items before regrouping

    for (var item in CartController.instance.items) {
      if (!groupedItems.containsKey(item.shopID)) {
        groupedItems[item.shopID] = [];
      }
      groupedItems[item.shopID]!.add(item);
    }
  }

  void removeItem(String itemId) {
    cart.removeItem(itemId);
    update(); // Notify listeners for updates
  }

  void updateItemQuantity(String itemId, int quantity) {

    cart.updateItemQuantity(itemId, quantity);
    update(); // Notify listeners for updates
  }

}
