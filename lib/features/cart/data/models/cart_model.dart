import 'package:fake_store_api_app/features/cart/data/models/cart_entity.dart';
import 'package:fake_store_api_app/features/cart/domain/entities/cart.dart';

class CartModel {
  final int id;
  final int userId;
  final String date;
  final List<Map<String, dynamic>> products;

  CartModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      userId: json['userId'],
      date: json['date'],
      products: List<Map<String, dynamic>>.from(json['products']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date,
      'products': products,
    };
  }

  CartEntity toEntity() {
    return CartEntity(
      id: id,
      userId: userId,
      date: date,
    );
  }

  Cart toDomain() {
    return Cart(
      id: id,
      userId: userId,
      date: date,
      products: products,
    );
  }
}