import 'package:floor/floor.dart';

@Entity(tableName: 'products')
class ProductEntity {
  @PrimaryKey(autoGenerate: false)
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });
}
