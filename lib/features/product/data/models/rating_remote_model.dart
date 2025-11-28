import 'package:fake_store_api_app/features/product/data/models/rating_local_model.dart';
import 'package:fake_store_api_app/features/product/domain/entities/rating.dart';

class RatingRemoteModel {
  final double rate;
  final int count;

  RatingRemoteModel({required this.rate, required this.count});

  factory RatingRemoteModel.fromJson(Map<String, dynamic> json) {
    return RatingRemoteModel(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'rate': rate, 'count': count};
  }

  Rating toEntity() {
    return Rating(rate: rate, count: count);
  }

  RatingLocalModel toLocalModel(int productId) {
    return RatingLocalModel(productId: productId, rate: rate, count: count);
  }
}
