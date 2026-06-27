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

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<RestaurantProvider>()
        .fetchMenuItems(widget.restaurant.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.restaurant.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                color: AppColors.primary.withOpacity(0.3),
                child: const Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 80,
                    color: Colors.white30,
                  ),
                ),
              ),
            ),
          ),

          // Restaurant Info
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
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
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.restaurant.isOpen
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.restaurant.isOpen ? 'OPEN' : 'CLOSED',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: widget.restaurant.isOpen
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.restaurant.rating} (${widget.restaurant.totalReviews} reviews)',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.restaurant.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textMedium,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _infoChip(Icons.access_time,
                          '${widget.restaurant.deliveryTime} min'),
                      const SizedBox(width: 12),
                      _infoChip(Icons.delivery_dining,
                          'Rs. ${widget.restaurant.deliveryFee.toInt()}'),
                      const SizedBox(width: 12),
                      _infoChip(Icons.shopping_bag,
                          'Min Rs. ${widget.restaurant.minOrder.toInt()}'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Menu Title
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),

          // Menu Items
          Consumer<RestaurantProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _menuItemCard(provider.menuItems[index]);
                  },
                  childCount: provider.menuItems.length,
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      // Cart Button
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.isEmpty) return const SizedBox.shrink();
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${cart.itemCount} items',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    'View Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Rs. ${cart.subtotal.toInt()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textLight),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMedium,
          ),
        ),
      ],
    );
  }

  Widget _menuItemCard(FoodItemModel item) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final quantity = cart.getItemQuantity(item.id);
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.fastfood,
                  color: AppColors.primary.withOpacity(0.5),
                  size: 36,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: item.isVeg
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: item.isVeg
                                    ? AppColors.success
                                    : AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMedium,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rs. ${item.price.toInt()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        quantity == 0
                            ? GestureDetector(
                                onTap: () {
                                  cart.addItem(
                                    item,
                                    widget.restaurant.id,
                                    widget.restaurant.name,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'ADD',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              )
                            : Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => cart.removeItem(item.id),
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text(
                                      '$quantity',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => cart.addItem(
                                      item,
                                      widget.restaurant.id,
                                      widget.restaurant.name,
                                    ),
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
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