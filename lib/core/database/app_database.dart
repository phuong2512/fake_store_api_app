import 'dart:async';

import 'package:fake_store_api_app/features/auth/data/datasources/user_dao.dart';
import 'package:fake_store_api_app/features/auth/data/models/user_local_model.dart';
import 'package:fake_store_api_app/features/cart/data/datasources/cart_dao.dart';
import 'package:fake_store_api_app/features/cart/data/models/cart_item_local_model.dart';
import 'package:fake_store_api_app/features/cart/data/models/cart_local_model.dart';
import 'package:fake_store_api_app/features/product/data/datasources/product_dao.dart';
import 'package:fake_store_api_app/features/product/data/models/product_local_model.dart';
import 'package:fake_store_api_app/features/product/data/models/rating_local_model.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(
  version: 1,
  entities: [
    UserLocalModel,
    ProductLocalModel,
    RatingLocalModel,
    CartLocalModel,
    CartItemLocalModel,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;

  ProductDao get productDao;

  CartDao get cartDao;
}
