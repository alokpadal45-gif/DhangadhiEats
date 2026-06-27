import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/providers/auth_provider.dart';
import '../auth/login_screen.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({super.key});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  bool _isAvailable = true;
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _availableOrders = [
    {
      'id': 'ORD001',
      'restaurant': 'Himalayan Kitchen',
      'restaurantAddress': 'Golpark, Dhangadhi',
      'customerAddress': 'New Road, Dhangadhi',
      'amount': 340,
      'items': 3,
      'distance': '1.2 km',
      'earning': 30,
    },
    {
      'id': 'ORD002',
      'restaurant': 'Tandoori House',
      'restaurantAddress': 'Pipalchowk, Dhangadhi',
      'customerAddress': 'Airport Road, Dhangadhi',
      'amount': 520,
      'items': 2,
      'distance': '2.5 km',
      'earning': 35,
    },
    {
      'id': 'ORD003',
      'restaurant': 'Momo Palace',
      'restaurantAddress': 'Airport Road, Dhangadhi',
      'customerAddress': 'Sarkari Tole, Dhangadhi',
      'amount': 180,
      'items': 1,
      'distance': '0.8 km',
      'earning': 25,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rider Dashboard',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Consumer<AuthProvider>(
                            builder: (context, auth, _) => Text(
                              auth.user?.fullName ?? 'Rider',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () {
                          context.read<AuthProvider>().logout();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Availability Toggle
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Availability Status',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _isAvailable ? 'Online' : 'Offline',
                              style: TextStyle(
                                color: _isAvailable
                                    ? Colors.greenAccent
                                    : Colors.white54,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: _isAvailable,
                          onChanged: (v) =>
                              setState(() => _isAvailable = v),
                          activeColor: Colors.greenAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Stats Row
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _statCard('Today\'s Earnings', 'Rs. 450', Icons.monetization_on, AppColors.success),
                  const SizedBox(width: 12),
                  _statCard('Deliveries', '15', Icons.delivery_dining, AppColors.primary),
                  const SizedBox(width: 12),
                  _statCard('Rating', '4.8', Icons.star, Colors.amber),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _tabButton('Available', 0),
                  _tabButton('My Deliveries', 1),
                  _tabButton('Earnings', 2),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Content
            Expanded(
              child: _currentIndex == 0
                  ? _availableOrdersList()
                  : _currentIndex == 1
                      ? _myDeliveriesList()
                      : _earningsView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _availableOrdersList() {
    if (!_isAvailable) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.offline_bolt, size: 80, color: AppColors.textLight),
            SizedBox(height: 16),
            Text(
              'You are offline',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Toggle online to see available orders',
              style: TextStyle(color: AppColors.textMedium),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _availableOrders.length,
      itemBuilder: (context, index) {
        final order = _availableOrders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order['id']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Rs. ${order['earning']} earning',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.restaurant,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${order['restaurant']} • ${order['restaurantAddress']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMedium,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: AppColors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order['customerAddress'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMedium,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _orderChip(Icons.shopping_bag,
                      '${order['items']} items', AppColors.primary),
                  const SizedBox(width: 8),
                  _orderChip(Icons.near_me,
                      order['distance'], AppColors.secondary),
                  const SizedBox(width: 8),
                  _orderChip(Icons.money,
                      'Rs. ${order['amount']}', AppColors.success),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                      ),
                      child: const Text(
                        'Reject',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Order Accepted!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _myDeliveriesList() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delivery_dining, size: 80, color: AppColors.textLight),
          SizedBox(height: 16),
          Text(
            'No active deliveries',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Accept an order to start delivering',
            style: TextStyle(color: AppColors.textMedium),
          ),
        ],
      ),
    );
  }

  Widget _earningsView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            children: [
              Text(
                'Total Earnings',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                'Rs. 12,450',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '415 total deliveries',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _earningRow('Today', 'Rs. 450', '15 deliveries'),
        _earningRow('Yesterday', 'Rs. 630', '21 deliveries'),
        _earningRow('This Week', 'Rs. 2,940', '98 deliveries'),
        _earningRow('This Month', 'Rs. 12,450', '415 deliveries'),
      ],
    );
  }

  Widget _earningRow(String period, String amount, String deliveries) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            period,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
              Text(
                deliveries,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textMedium,
            ),
          ),
        ),
      ),
    );
  }

  Widget _orderChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}