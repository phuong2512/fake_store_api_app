import 'package:fake_store_api_app/features/product/data/models/product_entity.dart';
import 'package:floor/floor.dart';

@Entity(
  tableName: 'ratings',
  foreignKeys: [
    ForeignKey(
      childColumns: ['productId'],
      parentColumns: ['id'],
      entity: ProductEntity,
      onDelete: ForeignKeyAction.cascade,
    )
  ],
)
class RatingEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int productId;
  final double rate;
  final int count;

  RatingEntity({
    this.id,
    required this.productId,
    required this.rate,
    required this.count,
  });
}