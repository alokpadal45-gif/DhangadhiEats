import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants/app_colors.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/restaurant_provider.dart';
import '../../data/providers/cart_provider.dart';
import '../../data/models/restaurant_model.dart';
import '../auth/login_screen.dart';
import 'restaurant_detail_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
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
  int _selectedCategory = 0;
  String _locationText = 'Dhangadhi, Kailali';
  bool _locationLoading = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.restaurant, 'color': Color(0xFF2ECC71)},
    {'name': 'Momo', 'icon': Icons.rice_bowl, 'color': Color(0xFFE74C3C)},
    {'name': 'Thali', 'icon': Icons.dinner_dining, 'color': Color(0xFFF39C12)},
    {'name': 'Cafe', 'icon': Icons.coffee, 'color': Color(0xFF8B4513)},
    {'name': 'Chicken', 'icon': Icons.set_meal, 'color': Color(0xFFE67E22)},
    {'name': 'Sweets', 'icon': Icons.cake, 'color': Color(0xFFE91E63)},
    {'name': 'Drinks', 'icon': Icons.local_drink, 'color': Color(0xFF3498DB)},
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<RestaurantProvider>().fetchRestaurants());
    _getLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    setState(() => _locationLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() { _locationText = 'Dhangadhi, Kailali'; _locationLoading = false; });
        return;
      }
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low).timeout(const Duration(seconds: 5));
      setState(() {
        _locationText = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
        _locationLoading = false;
      });
    } catch (e) {
      setState(() { _locationText = 'Dhangadhi, Kailali'; _locationLoading = false; });
    }
  }

  Widget _homeBody() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _getLocation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, color: AppColors.primary, size: 16),
                              const SizedBox(width: 4),
                              const Text('Delivering to', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                              const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textLight),
                            ],
                          ),
                          _locationLoading
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                              : Text(_locationText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Consumer<CartProvider>(
                          builder: (context, cart, _) => Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textDark, size: 26),
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                              ),
                              if (cart.itemCount > 0)
                                Positioned(
                                  right: 6, top: 6,
                                  child: Container(
                                    width: 16, height: 16,
                                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                    child: Center(child: Text('${cart.itemCount}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: const InputDecoration(
                      hintText: "Search for 'Momo' or 'Thali'",
                      hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: AppColors.textLight),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Promo Banner
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            height: 140,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF2ECC71), Color(0xFF27AE60)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Positioned(right: -30, bottom: -30, child: Container(width: 160, height: 160, decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), shape: BoxShape.circle))),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                        child: const Text('LIMITED OFFER', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      ),
                      const SizedBox(height: 8),
                      const Text('Get 50% Off on\nyour first order!', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.3)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Categories
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Text("What's on your mind?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        Container(
                          width: 64, height: 64,
                          decoration: BoxDecoration(
                            color: isSelected ? cat['color'] : AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? cat['color'] : AppColors.border),
                            boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2))],
                          ),
                          child: Icon(cat['icon'], color: isSelected ? Colors.white : cat['color'], size: 28),
                        ),
                        const SizedBox(height: 8),
                        Text(cat['name'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? cat['color'] : AppColors.textMedium)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Restaurants Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Popular Restaurants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                Text('See All', style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),

        // Restaurant List
        Consumer<RestaurantProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(margin: const EdgeInsets.fromLTRB(20, 0, 20, 16), height: 220, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(20))),
                  childCount: 3,
                ),
              );
            }
            final restaurants = provider.restaurants
                .where((r) => _searchQuery.isEmpty || r.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                .toList();
            if (restaurants.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.restaurant_outlined, size: 60, color: AppColors.textLight),
                        const SizedBox(height: 16),
                        const Text('No restaurants found', style: TextStyle(fontSize: 16, color: AppColors.textLight)),
                      ],
                    ),
                  ),
                ),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _restaurantCard(restaurants[index]),
                childCount: restaurants.length,
              ),
            );
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    if (auth.userRole == 'rider') return const RiderHomeScreen();
    if (auth.userRole == 'restaurant') return const RestaurantHomeScreen();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _homeBody(),
            _searchBody(),
            OrdersScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textLight,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _searchBody() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          color: AppColors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Search', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Search restaurants or food...",
                    hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: AppColors.primary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Consumer<RestaurantProvider>(
            builder: (context, provider, _) {
              final restaurants = _searchQuery.isEmpty
                  ? provider.restaurants
                  : provider.restaurants.where((r) => r.name.toLowerCase().contains(_searchQuery.toLowerCase()) || r.categories.any((c) => c.toLowerCase().contains(_searchQuery.toLowerCase()))).toList();
              if (restaurants.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 60, color: AppColors.textLight),
                      const SizedBox(height: 16),
                      Text(_searchQuery.isEmpty ? 'Search for restaurants or food' : 'No results for "$_searchQuery"', style: const TextStyle(color: AppColors.textLight, fontSize: 16)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: restaurants.length,
                itemBuilder: (context, index) => _restaurantCard(restaurants[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _restaurantCard(RestaurantModel restaurant) {
    return GestureDetector(
      onTap: () {
        context.read<RestaurantProvider>().selectRestaurant(restaurant);
        Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantDetailScreen(restaurant: restaurant)));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  child: restaurant.image != null
                      ? Image.network(restaurant.image!, width: double.infinity, height: 160, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(height: 160, color: AppColors.primaryLight, child: Icon(Icons.restaurant, size: 60, color: AppColors.primary.withOpacity(0.3))),
                          loadingBuilder: (_, child, progress) => progress == null ? child : Container(height: 160, color: AppColors.primaryLight, child: const Center(child: CircularProgressIndicator(color: AppColors.primary))))
                      : Container(height: 160, color: AppColors.primaryLight, child: Icon(Icons.restaurant, size: 60, color: AppColors.primary.withOpacity(0.3))),
                ),
                Positioned(
                  top: 12, right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)]),
                    child: Row(children: [
                      const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(restaurant.rating.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ]),
                  ),
                ),
                if (!restaurant.isOpen)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      child: Container(color: Colors.black54, child: const Center(child: Text('CLOSED', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)))),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(restaurant.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark))),
                      const Icon(Icons.favorite_border, color: AppColors.textLight, size: 20),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(restaurant.categories.join(' • '), style: const TextStyle(fontSize: 13, color: AppColors.textLight)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 14, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text('${restaurant.deliveryTime}-${restaurant.deliveryTime + 10} mins', style: const TextStyle(fontSize: 12, color: AppColors.textMedium)),
                      const SizedBox(width: 16),
                      Icon(Icons.delivery_dining_outlined, size: 14, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text('Rs. ${restaurant.deliveryFee.toInt()}', style: const TextStyle(fontSize: 12, color: AppColors.textMedium)),
                      const SizedBox(width: 16),
                      Icon(Icons.shopping_bag_outlined, size: 14, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text('Min Rs. ${restaurant.minOrder.toInt()}', style: const TextStyle(fontSize: 12, color: AppColors.textMedium)),
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