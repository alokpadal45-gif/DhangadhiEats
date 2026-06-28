import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/providers/auth_provider.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: AppColors.white,
            child: Column(
              children: [
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 3),
                  ),
                  child: Center(
                    child: Text(
                      user?.fullName.isNotEmpty == true ? user!.fullName.substring(0, 1).toUpperCase() : 'A',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(user?.fullName ?? 'User', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(user?.phone ?? '', style: const TextStyle(fontSize: 14, color: AppColors.textLight)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20)),
                  child: Text((user?.role ?? 'customer').toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            color: AppColors.white,
            child: Column(
              children: [
                _menuItem(Icons.person_outline, 'Edit Profile', () {}),
                _divider(),
                _menuItem(Icons.location_on_outlined, 'Saved Addresses', () {}),
                _divider(),
                _menuItem(Icons.payment_outlined, 'Payment Methods', () {}),
                _divider(),
                _menuItem(Icons.notifications_outlined, 'Notifications', () {}),
                _divider(),
                _menuItem(Icons.help_outline, 'Help & Support', () {}),
                _divider(),
                _menuItem(Icons.info_outline, 'About Dhangadhi Eats', () {}),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(16),
            child: const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('App Version', style: TextStyle(color: AppColors.textMedium)),
                    Text('1.0.0', style: TextStyle(color: AppColors.textLight)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Region', style: TextStyle(color: AppColors.textMedium)),
                    Text('Dhangadhi, Sudurpashchim', style: TextStyle(color: AppColors.textLight)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            color: AppColors.white,
            child: ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text('Logout', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      ElevatedButton(
                        onPressed: () {
                          auth.logout();
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, elevation: 0),
                        child: const Text('Logout', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontSize: 15, color: AppColors.textDark)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
      onTap: onTap,
    );
  }

  Widget _divider() => const Divider(height: 1, color: AppColors.border, indent: 56);
}