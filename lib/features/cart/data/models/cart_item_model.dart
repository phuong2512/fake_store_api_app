import 'package:fake_store_api_app/features/cart/data/models/cart_item_entity.dart';
import 'package:fake_store_api_app/features/cart/domain/entities/cart_item.dart';

class CartItemModel {
  final int? id;
  final int cartId;
  final int productId;
  final int quantity;

  CartItemModel({
    this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
  });

  CartItemEntity toEntity() {
    return CartItemEntity(
      id: id,
      cartId: cartId,
      productId: productId,
      quantity: quantity,
    );
  }

  CartItem toDomain() {
    return CartItem(productId: productId, quantity: quantity);
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      id: entity.id,
      cartId: entity.cartId,
      productId: entity.productId,
      quantity: entity.quantity,
    );
  }
}
