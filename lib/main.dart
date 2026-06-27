import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/providers/auth_provider.dart';
import 'data/providers/cart_provider.dart';
import 'data/providers/order_provider.dart';
import 'data/providers/restaurant_provider.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(const DhangadhiEatsApp());
}

class DhangadhiEatsApp extends StatelessWidget {
  const DhangadhiEatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
      ],
      child: MaterialApp(
        title: 'Dhangadhi Eats',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}