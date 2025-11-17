import 'package:floor/floor.dart';

@Entity(tableName: 'carts')
class CartEntity {
  @PrimaryKey(autoGenerate: true) 
  final int? id; 

  final int userId;
  final String date;

  CartEntity({
    this.id, 
    required this.userId,
    required this.date,
  });
}