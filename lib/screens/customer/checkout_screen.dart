import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/cart_provider.dart';
import '../../data/providers/order_provider.dart';
import 'order_tracking_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  String _paymentMethod = 'cash';
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();
    final orderProvider = context.read<OrderProvider>();

    final success = await orderProvider.placeOrder(
      customerId: auth.user?.id ?? '',
      restaurantId: cart.restaurantId ?? '',
      restaurantName: cart.restaurantName ?? '',
      items: cart.items,
      subtotal: cart.subtotal,
      deliveryFee: cart.deliveryFee,
      total: cart.total,
      paymentMethod: _paymentMethod,
      deliveryAddress: _addressController.text.trim(),
    );

    if (success && mounted) {
      cart.clearCart();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderTrackingScreen(
            order: orderProvider.currentOrder!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppColors.primary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Delivery Address
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Delivery Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText:
                          'Enter your full delivery address in Dhangadhi...',
                      prefixIcon: Icon(Icons.home),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Please enter delivery address';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Payment Method
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.payment, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _paymentOption(
                    'cash',
                    'Cash on Delivery',
                    Icons.money,
                    Colors.green,
                  ),
                  _paymentOption(
                    'esewa',
                    'eSewa',
                    Icons.account_balance_wallet,
                    Colors.green.shade700,
                  ),
                  _paymentOption(
                    'khalti',
                    'Khalti',
                    Icons.account_balance_wallet,
                    Colors.purple,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Order Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.receipt, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...cart.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.name} x${item.quantity}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textMedium,
                              ),
                            ),
                          ),
                          Text(
                            'Rs. ${item.total.toInt()}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textMedium,
                        ),
                      ),
                      Text(
                        'Rs. ${cart.subtotal.toInt()}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Delivery Fee',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textMedium,
                        ),
                      ),
                      Text(
                        'Rs. ${cart.deliveryFee.toInt()}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'Rs. ${cart.total.toInt()}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Consumer<OrderProvider>(
              builder: (context, orderProvider, _) {
                return ElevatedButton(
                  onPressed: orderProvider.isLoading ? null : _placeOrder,
                  child: orderProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Place Order',
                          style: TextStyle(fontSize: 18),
                        ),
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _paymentOption(
      String value, String label, IconData icon, Color color) {
    final isSelected = _paymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : AppColors.textDark,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}