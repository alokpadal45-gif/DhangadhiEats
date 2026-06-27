import 'package:flutter/material.dart';
import '../models/food_item_model.dart';
import '../models/order_model.dart';

class CartProvider extends ChangeNotifier {
  final List<OrderItem> _items = [];
  String? _restaurantId;
  String? _restaurantName;

  List<OrderItem> get items => _items;
  String? get restaurantId => _restaurantId;
  String? get restaurantName => _restaurantName;
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.total);

  double get deliveryFee => subtotal > 0 ? 60.0 : 0.0;

  double get total => subtotal + deliveryFee;

  void addItem(FoodItemModel food, String restaurantId, String restaurantName) {
    if (_restaurantId != null && _restaurantId != restaurantId) {
      clearCart();
    }
    _restaurantId = restaurantId;
    _restaurantName = restaurantName;

    final existingIndex = _items.indexWhere((e) => e.foodItemId == food.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(OrderItem(
        foodItemId: food.id,
        name: food.name,
        price: food.price,
        quantity: 1,
        image: food.image,
      ));
    }
    notifyListeners();
  }

  void removeItem(String foodItemId) {
    final existingIndex = _items.indexWhere((e) => e.foodItemId == foodItemId);
    if (existingIndex >= 0) {
      if (_items[existingIndex].quantity > 1) {
        _items[existingIndex].quantity--;
      } else {
        _items.removeAt(existingIndex);
      }
      if (_items.isEmpty) clearCart();
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _restaurantId = null;
    _restaurantName = null;
    notifyListeners();
  }

  int getItemQuantity(String foodItemId) {
    final index = _items.indexWhere((e) => e.foodItemId == foodItemId);
    return index >= 0 ? _items[index].quantity : 0;
  }
}