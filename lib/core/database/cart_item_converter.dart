import 'dart:convert';

import 'package:fake_store_api_app/core/models/cart_item.dart';
import 'package:floor/floor.dart';

class CartItemsConverter extends TypeConverter<List<CartItemModel>, String> {
  @override
  List<CartItemModel> decode(String databaseValue) {
    if (databaseValue.isEmpty) return [];
    final List<dynamic> jsonList = json.decode(databaseValue);
    return jsonList.map((e) => CartItemModel.fromJson(e)).toList();
  }

  @override
  String encode(List<CartItemModel> value) {
    final List<Map<String, dynamic>> jsonList = value
        .map((e) => e.toJson())
        .toList();
    return json.encode(jsonList);
  }
}
