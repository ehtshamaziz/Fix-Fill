import 'package:cloud_firestore/cloud_firestore.dart';

class ListUpdateModel {
  final String id;
  final double price;
  final int quantity;
  final String category;

  ListUpdateModel({
    required this.id,
    required this.price,
    required this.quantity,
    required this.category,
  });

  factory ListUpdateModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ListUpdateModel(
      id: doc.id,
      price: data['price'] ?? 0.0,
      quantity: data['quantity'] ?? 0,
      category: data['category'] ?? '',
    );
  }
}

class OrderModel {
  final String Status;
  final String id;
  final String userID;

  OrderModel({required this.Status, required this.id, required this.userID});
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
     userID:data['userId']??"",
     Status: data['Status']??""
    );
  }
}
