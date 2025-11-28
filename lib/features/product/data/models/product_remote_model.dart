import 'package:fake_store_api_app/features/product/data/models/product_local_model.dart';
import 'package:fake_store_api_app/features/product/data/models/rating_remote_model.dart';
import 'package:fake_store_api_app/features/product/domain/entities/product.dart';

class ProductRemoteModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final RatingRemoteModel rating;

  ProductRemoteModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory ProductRemoteModel.fromJson(Map<String, dynamic> json) {
    return ProductRemoteModel(
      id: json["id"],
      title: json["title"],
      price: (json["price"] as num).toDouble(),
      description: json["description"],
      category: json["category"],
      image: json["image"],
      rating: RatingRemoteModel.fromJson(json['rating']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "price": price,
      "description": description,
      "category": category,
      "image": image,
      'rating': rating.toJson(),
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      rating: rating.toEntity(),
    );
  }

  ProductLocalModel toLocalModel() {
    return ProductLocalModel(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
    );
  }
}
