import 'package:fake_store_api_app/features/product/data/models/product_local_model.dart';
import 'package:fake_store_api_app/features/product/domain/entities/rating.dart';
import 'package:floor/floor.dart';

@Entity(
  tableName: 'ratings',
  foreignKeys: [
    ForeignKey(
      childColumns: ['productId'],
      parentColumns: ['id'],
      entity: ProductLocalModel,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class RatingLocalModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int productId;
  final double rate;
  final int count;

  RatingLocalModel({
    this.id,
    required this.productId,
    required this.rate,
    required this.count,
  });

  Rating toEntity() {
    return Rating(rate: rate, count: count);
  }

  factory RatingLocalModel.fromEntity(Rating rating, int productId) {
    return RatingLocalModel(
      productId: productId,
      rate: rating.rate,
      count: rating.count,
    );
  }
}
