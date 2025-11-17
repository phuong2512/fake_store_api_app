import 'package:floor/floor.dart';

@Entity(tableName: 'carts')
class CartEntity {
  @PrimaryKey(autoGenerate: false)
  final int id;
  final int userId;
  final String date;

  CartEntity({
    required this.id,
    required this.userId,
    required this.date,
  });
}