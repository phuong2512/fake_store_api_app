import 'package:fake_store_api_app/features/cart/data/models/cart_entity.dart';
import 'package:floor/floor.dart';

@Entity(
  tableName: 'cart_items',
  foreignKeys: [
    ForeignKey(
      childColumns: ['cartId'],
      parentColumns: ['id'],
      entity: CartEntity,
      onDelete: ForeignKeyAction.cascade,
    )
  ],
)
class CartItemEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int cartId;
  final int productId;
  final int quantity;

  CartItemEntity({
    this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
  });
}