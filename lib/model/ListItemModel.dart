class ListItemModel {
  bool fuel;
  String id;
  String category;
  double price;
  int ?quantity;

  ListItemModel({required this.fuel,required this.id,required this.category, required this.price, required this.quantity});

  // factory ListItemModel.fromFirestore(var doc) {
  //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //   return ListItemModel(
  //     id: doc.id,
  //     fuel:data['fuel'],
  //     price: data['price'] ?? 0.0,
  //     quantity: data['quantity'] ?? 0,
  //     category: data['category'] ?? '',
  //   );
  // }
}
