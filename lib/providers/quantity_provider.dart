import 'package:flutter/foundation.dart';

class QuantityProvider extends ChangeNotifier {
  int _quantity = 1;

  int get quantity => _quantity;

  void setQuantity(int value) {
    _quantity = value;
    notifyListeners();
  }
}
