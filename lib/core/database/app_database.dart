import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:fake_store_api_app/features/auth/data/models/user_entity.dart';
import 'package:fake_store_api_app/features/auth/data/datasources/user_dao.dart';
import 'package:fake_store_api_app/features/product/data/models/product_entity.dart';
import 'package:fake_store_api_app/features/product/data/models/rating_entity.dart';
import 'package:fake_store_api_app/features/product/data/datasources/product_dao.dart';
import 'package:fake_store_api_app/features/cart/data/models/cart_entity.dart';
import 'package:fake_store_api_app/features/cart/data/models/cart_item_entity.dart';
import 'package:fake_store_api_app/features/cart/data/datasources/cart_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [
  UserEntity,
  ProductEntity,
  RatingEntity,
  CartEntity,
  CartItemEntity,
])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  ProductDao get productDao;
  CartDao get cartDao;
}