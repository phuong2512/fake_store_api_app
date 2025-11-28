import 'package:fake_store_api_app/features/cart/domain/entities/cart.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'carts')
class CartLocalModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int userId;
  final String date;

  CartLocalModel({this.id, required this.userId, required this.date});

  Cart toEntity() {
    return Cart(id: id ?? 0, userId: userId, date: date, products: []);
  }

  factory CartLocalModel.fromEntity(Cart cart) {
    return CartLocalModel(id: cart.id, userId: cart.userId, date: cart.date);
  }
}
