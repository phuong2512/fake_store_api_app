class CartItemModel {
  final int productId;
  final int quantity;

  const CartItemModel({required this.productId, required this.quantity});

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as int,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
  };
}
