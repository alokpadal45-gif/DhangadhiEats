import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  OrderModel? _currentOrder;
  bool _isLoading = false;
  String? _error;

  List<OrderModel> get orders => _orders;
  OrderModel? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> placeOrder({
    required String customerId,
    required String restaurantId,
    required String restaurantName,
    required List<OrderItem> items,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required String paymentMethod,
    required String deliveryAddress,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 2));
      final order = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        customerId: customerId,
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        items: items,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        total: total,
        status: 'pending',
        paymentMethod: paymentMethod,
        isPaid: paymentMethod != 'cash',
        deliveryAddress: deliveryAddress,
        createdAt: DateTime.now(),
      );
      _currentOrder = order;
      _orders.insert(0, order);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrders(String customerId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 1));
      _orders = [];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateOrderStatus(String orderId, String status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      notifyListeners();
    }
  }
}