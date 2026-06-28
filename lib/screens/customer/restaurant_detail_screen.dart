import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/restaurant_model.dart';
import '../../data/models/food_item_model.dart';
import '../../data/providers/restaurant_provider.dart';
import '../../data/providers/cart_provider.dart';
import 'cart_screen.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final RestaurantModel restaurant;
  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() => context
        .read<RestaurantProvider>()
        .fetchMenuItems(widget.restaurant.id));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero Image AppBar
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)],
                ),
                child: const Icon(Icons.arrow_back, color: AppColors.textDark),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)],
                ),
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, color: AppColors.textDark),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: widget.restaurant.image != null
                  ? Image.network(
                      widget.restaurant.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.primaryLight,
                        child: Icon(Icons.restaurant, size: 80, color: AppColors.primary.withOpacity(0.3)),
                      ),
                    )
                  : Container(
                      color: AppColors.primaryLight,
                      child: Icon(Icons.restaurant, size: 80, color: AppColors.primary.withOpacity(0.3)),
                    ),
            ),
          ),

          // Restaurant Info Card
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.restaurant.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.restaurant.isOpen ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: widget.restaurant.isOpen ? AppColors.success : AppColors.error),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(
                                color: widget.restaurant.isOpen ? AppColors.success : AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.restaurant.isOpen ? 'Open' : 'Closed',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: widget.restaurant.isOpen ? AppColors.success : AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.restaurant.categories.join(' • '),
                    style: const TextStyle(fontSize: 14, color: AppColors.textLight),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.restaurant.description,
                    style: const TextStyle(fontSize: 14, color: AppColors.textMedium, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  // Stats Row
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        _statItem(Icons.star_rounded, '${widget.restaurant.rating}', 'Rating', Colors.amber),
                        _divider(),
                        _statItem(Icons.access_time_rounded, '${widget.restaurant.deliveryTime}-${widget.restaurant.deliveryTime + 10}', 'Mins', AppColors.primary),
                        _divider(),
                        _statItem(Icons.delivery_dining_outlined, 'Rs.${widget.restaurant.deliveryFee.toInt()}', 'Delivery', AppColors.info),
                        _divider(),
                        _statItem(Icons.shopping_bag_outlined, 'Rs.${widget.restaurant.minOrder.toInt()}', 'Min Order', AppColors.secondary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Section
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.white,
              margin: const EdgeInsets.only(top: 8),
              child: Consumer<RestaurantProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    );
                  }

                  final allItems = provider.menuItems;
                  final categories = ['All', ...allItems.map((e) => e.category).toSet().toList()];
                  final filtered = _selectedCategory == 'All'
                      ? allItems
                      : allItems.where((e) => e.category == _selectedCategory).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Filter
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: const Text('Menu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      ),
                      SizedBox(
                        height: 44,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final cat = categories[index];
                            final isSelected = _selectedCategory == cat;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedCategory = cat),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : AppColors.background,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                                ),
                                child: Text(
                                  cat,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : AppColors.textMedium,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Menu Items
                      ...filtered.map((item) => _menuItemCard(item)).toList(),
                      const SizedBox(height: 100),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // Bottom Cart Button
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.isEmpty) return const SizedBox.shrink();
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 20, offset: const Offset(0, -5))],
            ),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('${cart.itemCount} items', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    const Text('View Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Rs. ${cart.subtotal.toInt()}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 40, color: AppColors.border);
  }

  Widget _menuItemCard(FoodItemModel item) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final quantity = cart.getItemQuantity(item.id);
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              // Food Image
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.fastfood_rounded, color: AppColors.primary.withOpacity(0.4), size: 40),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Veg/Non-veg indicator
                    Row(
                      children: [
                        Container(
                          width: 14, height: 14,
                          decoration: BoxDecoration(
                            border: Border.all(color: item.isVeg ? AppColors.success : AppColors.error, width: 1.5),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            child: Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(
                                color: item.isVeg ? AppColors.success : AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (item.isFeatured)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Bestseller', style: TextStyle(fontSize: 10, color: Colors.amber, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(item.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 4),
                    Text(item.description, style: const TextStyle(fontSize: 12, color: AppColors.textLight, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Rs. ${item.price.toInt()}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        quantity == 0
                            ? GestureDetector(
                                onTap: () => cart.addItem(item, widget.restaurant.id, widget.restaurant.name),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.primary, width: 1.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('ADD', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => cart.removeItem(item.id),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        child: Icon(Icons.remove, color: Colors.white, size: 16),
                                      ),
                                    ),
                                    Text('$quantity', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                    GestureDetector(
                                      onTap: () => cart.addItem(item, widget.restaurant.id, widget.restaurant.name),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        child: Icon(Icons.add, color: Colors.white, size: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}