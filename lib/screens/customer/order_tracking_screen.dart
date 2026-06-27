import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/order_model.dart';
import 'home_screen.dart';

class OrderTrackingScreen extends StatefulWidget {
  final OrderModel order;
  const OrderTrackingScreen({super.key, required this.order});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  int _currentStep = 0;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Order Placed',
      'subtitle': 'Your order has been placed successfully',
      'icon': Icons.check_circle,
      'color': AppColors.success,
    },
    {
      'title': 'Restaurant Accepted',
      'subtitle': 'Restaurant is preparing your food',
      'icon': Icons.restaurant,
      'color': AppColors.info,
    },
    {
      'title': 'Preparing Your Food',
      'subtitle': 'Your food is being prepared',
      'icon': Icons.soup_kitchen,
      'color': AppColors.warning,
    },
    {
      'title': 'Rider On The Way',
      'subtitle': 'Your rider is coming to you',
      'icon': Icons.delivery_dining,
      'color': AppColors.secondary,
    },
    {
      'title': 'Delivered',
      'subtitle': 'Your order has been delivered',
      'icon': Icons.home,
      'color': AppColors.success,
    },
  ];

  @override
  void initState() {
    super.initState();
    _simulateOrderProgress();
  }

  void _simulateOrderProgress() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        setState(() => _currentStep = i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Track Order'),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Order ID Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.delivery_dining,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Order Confirmed!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Order #${widget.order.id.substring(0, 8)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rs. ${widget.order.total.toInt()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Tracking Steps
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
                const Text(
                  'Order Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(_steps.length, (index) {
                  final step = _steps[index];
                  final isCompleted = index <= _currentStep;
                  final isActive = index == _currentStep;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? step['color']
                                  : AppColors.border,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              step['icon'],
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          if (index < _steps.length - 1)
                            Container(
                              width: 2,
                              height: 40,
                              color: isCompleted
                                  ? AppColors.success
                                  : AppColors.border,
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step['title'],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isCompleted
                                      ? AppColors.textDark
                                      : AppColors.textLight,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                step['subtitle'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isCompleted
                                      ? AppColors.textMedium
                                      : AppColors.textLight,
                                ),
                              ),
                              if (isActive)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: LinearProgressIndicator(
                                    color: step['color'],
                                    backgroundColor:
                                        AppColors.border,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Order Items
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
                const Text(
                  'Order Items',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                ...widget.order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${item.name} x${item.quantity}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textMedium,
                          ),
                        ),
                        Text(
                          'Rs. ${item.total.toInt()}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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
                      'Total Paid',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Rs. ${widget.order.total.toInt()}',
                      style: const TextStyle(
                        fontSize: 16,
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

          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
            child: const Text('Back to Home'),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}