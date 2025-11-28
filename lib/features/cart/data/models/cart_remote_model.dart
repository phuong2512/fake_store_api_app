import 'package:fake_store_api_app/features/cart/data/models/cart_local_model.dart';
import 'package:fake_store_api_app/features/cart/domain/entities/cart.dart';

class CartRemoteModel {
  final int id;
  final int userId;
  final String date;
  final List<Map<String, dynamic>> products;

  CartRemoteModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  factory CartRemoteModel.fromJson(Map<String, dynamic> json) {
    return CartRemoteModel(
      id: json['id'],
      userId: json['userId'],
      date: json['date'],
      products: List<Map<String, dynamic>>.from(json['products']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'userId': userId, 'date': date, 'products': products};
  }

  Cart toEntity() {
    return Cart(id: id, userId: userId, date: date, products: products);
  }

  CartLocalModel toLocalModel() {
    return CartLocalModel(userId: userId, date: date);
  }
}
