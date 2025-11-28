import 'package:fake_store_api_app/features/cart/data/models/cart_local_model.dart';
import 'package:fake_store_api_app/features/cart/domain/entities/cart_item.dart';
import 'package:floor/floor.dart';

@Entity(
  tableName: 'cart_items',
  foreignKeys: [
    ForeignKey(
      childColumns: ['cartId'],
      parentColumns: ['id'],
      entity: CartLocalModel,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class CartItemLocalModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int cartId;
  final int productId;
  final int quantity;

  CartItemLocalModel({
    this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
  });

  CartItem toEntity() {
    return CartItem(productId: productId, quantity: quantity);
  }

  factory CartItemLocalModel.fromEntity(CartItem item, int cartId) {
    return CartItemLocalModel(
      cartId: cartId,
      productId: item.productId,
      quantity: item.quantity,
    );
  }
}
