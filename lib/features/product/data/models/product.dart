import 'package:fake_store_api_app/features/product/data/models/rating.dart';
import 'package:fake_store_api_app/features/product/domain/entities/product.dart';

class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final RatingModel rating;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  // (Ghi chú: Hàm chuyển đổi MỚI)
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

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    title: json["title"],
    price: (json["price"] as num).toDouble(),
    description: json["description"],
    category: json["category"],
    image: json["image"],
    rating: RatingModel.fromJson(json['rating']),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "description": description,
    "category": category,
    "image": image,
    'rating': rating.toJson(),
  };
}