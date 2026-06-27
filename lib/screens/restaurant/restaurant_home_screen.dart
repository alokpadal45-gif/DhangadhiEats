import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/providers/auth_provider.dart';
import '../auth/login_screen.dart';

class RestaurantHomeScreen extends StatefulWidget {
  const RestaurantHomeScreen({super.key});

  @override
  State<RestaurantHomeScreen> createState() => _RestaurantHomeScreenState();
}

class _RestaurantHomeScreenState extends State<RestaurantHomeScreen> {
  int _currentIndex = 0;
  bool _isOpen = true;

  final List<Map<String, dynamic>> _newOrders = [
    {
      'id': 'ORD001',
      'customer': 'Ram Bahadur',
      'items': ['Steam Momo x2', 'Masala Tea x1'],
      'total': 270,
      'address': 'New Road, Dhangadhi',
      'time': '2 min ago',
    },
    {
      'id': 'ORD002',
      'customer': 'Sita Devi',
      'items': ['Veg Thali x1', 'Chicken Chowmein x1'],
      'total': 340,
      'address': 'Golpark, Dhangadhi',
      'time': '5 min ago',
    },
  ];

  final List<Map<String, dynamic>> _menuItems = [
    {
      'name': 'Steam Momo (10 pcs)',
      'price': 120,
      'category': 'Momo',
      'available': true,
    },
    {
      'name': 'Veg Thali',
      'price': 180,
      'category': 'Thali',
      'available': true,
    },
    {
      'name': 'Chicken Chowmein',
      'price': 160,
      'category': 'Noodles',
      'available': true,
    },
    {
      'name': 'Masala Tea',
      'price': 30,
      'category': 'Drinks',
      'available': false,
    },
    {
      'name': 'Fried Momo (10 pcs)',
      'price': 140,
      'category': 'Momo',
      'available': true,
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
                            'Restaurant Dashboard',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Consumer<AuthProvider>(
                            builder: (context, auth, _) => Text(
                              auth.user?.fullName ?? 'Restaurant',
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
                  // Open/Close Toggle
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
                              'Restaurant Status',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _isOpen ? 'Open for Orders' : 'Closed',
                              style: TextStyle(
                                color: _isOpen
                                    ? Colors.greenAccent
                                    : Colors.white54,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: _isOpen,
                          onChanged: (v) => setState(() => _isOpen = v),
                          activeColor: Colors.greenAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Stats
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _statCard("Today's Orders", '24', Icons.receipt, AppColors.primary),
                  const SizedBox(width: 12),
                  _statCard("Revenue", 'Rs. 4,820', Icons.monetization_on, AppColors.success),
                  const SizedBox(width: 12),
                  _statCard("Rating", '4.5', Icons.star, Colors.amber),
                ],
              ),
            ),

            // Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _tabButton('New Orders', 0),
                  _tabButton('Menu', 1),
                  _tabButton('History', 2),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: _currentIndex == 0
                  ? _newOrdersList()
                  : _currentIndex == 1
                      ? _menuList()
                      : _historyList(),
            ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add menu item coming soon!')),
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _newOrdersList() {
    if (_newOrders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 80, color: AppColors.textLight),
            SizedBox(height: 16),
            Text(
              'No new orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _newOrders.length,
      itemBuilder: (context, index) {
        final order = _newOrders[index];
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
                  Text(
                    order['time'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, size: 14, color: AppColors.textLight),
                  const SizedBox(width: 4),
                  Text(
                    order['customer'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: AppColors.error),
                  const SizedBox(width: 4),
                  Text(
                    order['address'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...List<String>.from(order['items']).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.fiber_manual_record,
                          size: 8, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        item,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rs. ${order['total']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() => _newOrders.removeAt(index));
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.error),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: const Text(
                          'Reject',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() => _newOrders.removeAt(index));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order Accepted!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: const Text('Accept'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _menuList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _menuItems.length,
      itemBuilder: (context, index) {
        final item = _menuItems[index];
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
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.fastfood,
                  color: AppColors.primary.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['category'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs. ${item['price']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: item['available'],
                onChanged: (v) {
                  setState(() => _menuItems[index]['available'] = v);
                },
                activeColor: AppColors.success,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _historyList() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: AppColors.textLight),
          SizedBox(height: 16),
          Text(
            'Order history coming soon',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
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
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
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
}