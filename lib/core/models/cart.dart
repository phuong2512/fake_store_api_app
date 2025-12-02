import 'package:fake_store_api_app/core/models/cart_item.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'carts')
class CartModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int userId;
  final String date;
  final List<CartItemModel> products;

  const CartModel({
    this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      userId: json['userId'],
      date: json['date'],
      products: (json['products'] as List)
          .map((e) => CartItemModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date,
      'products': products.map((e) => e.toJson()).toList(),
    };
  }

  CartModel copyWith({
    int? id,
    int? userId,
    String? date,
    List<CartItemModel>? products,
  }) {
    return CartModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      products: products ?? this.products,
    );
  }
}
