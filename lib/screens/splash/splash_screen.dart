import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../customer/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            auth.isLoggedIn ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.delivery_dining,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Dhangadhi Eats',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Food delivery in Dhangadhi',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 60),
            const CircularProgressIndicator(
              color: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}