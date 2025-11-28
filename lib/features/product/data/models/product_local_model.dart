import 'package:fake_store_api_app/features/product/domain/entities/product.dart';
import 'package:fake_store_api_app/features/product/domain/entities/rating.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'products')
class ProductLocalModel {
  @PrimaryKey(autoGenerate: false)
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  ProductLocalModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  Product toEntity(Rating rating) {
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      rating: rating,
    );
  }

  factory ProductLocalModel.fromEntity(Product product) {
    return ProductLocalModel(
      id: product.id,
      title: product.title,
      price: product.price,
      description: product.description,
      category: product.category,
      image: product.image,
    );
  }
}
