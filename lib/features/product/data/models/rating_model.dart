import 'package:fake_store_api_app/features/product/data/models/rating_entity.dart';
import 'package:fake_store_api_app/features/product/domain/entities/rating.dart';

class RatingModel {
  final double rate;
  final int count;

  RatingModel({required this.rate, required this.count});

  Rating toEntity() {
    return Rating(rate: rate, count: count);
  }

  RatingEntity toDbEntity(int productId) {
    return RatingEntity(productId: productId, rate: rate, count: count);
  }

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'rate': rate, 'count': count};
  }
}
