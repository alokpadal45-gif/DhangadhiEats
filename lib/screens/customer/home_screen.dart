import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/restaurant_provider.dart';
import '../../data/models/restaurant_model.dart';
import '../../data/providers/cart_provider.dart';
import '../auth/login_screen.dart';
import 'restaurant_detail_screen.dart';
import 'cart_screen.dart';
import '../rider/rider_home_screen.dart';
import '../restaurant/restaurant_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<RestaurantProvider>().fetchRestaurants());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    // Redirect rider and restaurant to their screens
    if (auth.userRole == 'rider') return const RiderHomeScreen();
    if (auth.userRole == 'restaurant') return const RestaurantHomeScreen();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Deliver to',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Dhangadhi, Kailali',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Consumer<CartProvider>(
                              builder: (context, cart, _) {
                                return Stack(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.shopping_cart,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const CartScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    if (cart.itemCount > 0)
                                      Positioned(
                                        right: 6,
                                        top: 6,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${cart.itemCount}',
                                              style: const TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                context.read<AuthProvider>().logout();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        decoration: const InputDecoration(
                          hintText: 'Search restaurants or food...',
                          prefixIcon: Icon(Icons.search, color: AppColors.textLight),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Categories
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 90,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _categoryItem('Momo', Icons.restaurant_menu, AppColors.primary),
                          _categoryItem('Thali', Icons.rice_bowl, Colors.orange),
                          _categoryItem('Cafe', Icons.coffee, Colors.brown),
                          _categoryItem('Chicken', Icons.set_meal, Colors.red),
                          _categoryItem('Sweets', Icons.cake, Colors.pink),
                          _categoryItem('Drinks', Icons.local_drink, Colors.blue),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Restaurants
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: const Text(
                  'Restaurants Near You',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),

            Consumer<RestaurantProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                }

                final restaurants = provider.restaurants
                    .where((r) => _searchQuery.isEmpty ||
                        r.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                    .toList();

                if (restaurants.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text('No restaurants found'),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _restaurantCard(restaurants[index]);
                    },
                    childCount: restaurants.length,
                  ),
                );
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _categoryItem(String label, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _restaurantCard(RestaurantModel restaurant) {
    return GestureDetector(
      onTap: () {
        context.read<RestaurantProvider>().selectRestaurant(restaurant);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantDetailScreen(restaurant: restaurant),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
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
            // Image placeholder
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.restaurant,
                      size: 60,
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  if (!restaurant.isOpen)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'CLOSED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              restaurant.rating.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.address,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMedium,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant.deliveryTime} min',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMedium,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.delivery_dining,
                        size: 14,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Rs. ${restaurant.deliveryFee.toInt()}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMedium,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.shopping_bag,
                        size: 14,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Min Rs. ${restaurant.minOrder.toInt()}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}