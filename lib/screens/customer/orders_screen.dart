import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/providers/order_provider.dart';
import '../../data/providers/auth_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final auth = context.read<AuthProvider>();
      context.read<OrderProvider>().fetchOrders(auth.user?.id ?? '');
    });
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending': return AppColors.warning;
      case 'accepted': return AppColors.info;
      case 'preparing': return AppColors.secondary;
      case 'on_the_way': return AppColors.primary;
      case 'delivered': return AppColors.success;
      case 'cancelled': return AppColors.error;
      default: return AppColors.textLight;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending': return 'Pending';
      case 'accepted': return 'Accepted';
      case 'preparing': return 'Preparing';
      case 'on_the_way': return 'On the Way';
      case 'delivered': return 'Delivered';
      case 'cancelled': return 'Cancelled';
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (provider.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                    child: const Icon(Icons.receipt_long_outlined, size: 60, color: AppColors.primary),
                  ),
                  const SizedBox(height: 24),
                  const Text('No orders yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  const Text('Your order history will appear here', style: TextStyle(fontSize: 14, color: AppColors.textLight)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.orders.length,
            itemBuilder: (context, index) {
              final order = provider.orders[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(order.restaurantName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _statusColor(order.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _statusColor(order.status)),
                          ),
                          child: Text(_statusLabel(order.status), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _statusColor(order.status))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Order #${order.id.substring(0, 8).toUpperCase()}', style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                    const SizedBox(height: 8),
                    Text('${order.items.length} items', style: const TextStyle(fontSize: 14, color: AppColors.textMedium)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(order.paymentMethod == 'cash' ? 'Cash on Delivery' : order.paymentMethod.toUpperCase(), style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                        Text('Rs. ${order.total.toInt()}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}