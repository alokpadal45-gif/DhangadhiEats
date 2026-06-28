import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/providers/auth_provider.dart';
import '../customer/home_screen.dart';
import 'register_screen.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedCode = '+977';
  String _selectedFlag = '🇳🇵';
  bool _isLoading = false;

  final List<Map<String, String>> _countries = [
    {'flag': '🇳🇵', 'name': 'Nepal', 'code': '+977'},
    {'flag': '🇮🇳', 'name': 'India', 'code': '+91'},
    {'flag': '🇧🇩', 'name': 'Bangladesh', 'code': '+880'},
    {'flag': '🇨🇳', 'name': 'China', 'code': '+86'},
  ];

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, margin: const EdgeInsets.only(top: 12, bottom: 16), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Align(alignment: Alignment.centerLeft, child: Text('Select Country', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))),
          ),
          ..._countries.map((c) => ListTile(
            leading: Text(c['flag']!, style: const TextStyle(fontSize: 26)),
            title: Text(c['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
            trailing: Text(c['code']!, style: const TextStyle(color: Colors.white54)),
            onTap: () { setState(() { _selectedCode = c['code']!; _selectedFlag = c['flag']!; }); Navigator.pop(context); },
          )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => OTPScreen(phone: '$_selectedCode${_phoneController.text.trim()}'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            child: Column(
              children: [
                // Top black section
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo
                        Row(
                          children: [
                            Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.delivery_dining, color: Colors.white, size: 26),
                            ),
                            const SizedBox(width: 10),
                            RichText(
                              text: const TextSpan(children: [
                                TextSpan(text: 'Alo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                                TextSpan(text: 'Go', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: -0.5)),
                              ]),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Text('Sign in', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1, letterSpacing: -1)),
                        const SizedBox(height: 8),
                        const Text('Order food & rides in Dhangadhi', style: TextStyle(fontSize: 15, color: Colors.white54, height: 1.4)),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // White bottom sheet
                Expanded(
                  flex: 6,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Mobile Number', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark, letterSpacing: 0.3)),
                          const SizedBox(height: 10),
                          // Phone field
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE8E8E8)),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: _showCountryPicker,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                                    decoration: const BoxDecoration(border: Border(right: BorderSide(color: Color(0xFFE8E8E8)))),
                                    child: Row(children: [
                                      Text(_selectedFlag, style: const TextStyle(fontSize: 20)),
                                      const SizedBox(width: 6),
                                      Text(_selectedCode, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                                      const Icon(Icons.expand_more, size: 16, color: AppColors.textLight),
                                    ]),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark),
                                    decoration: const InputDecoration(
                                      hintText: '98XXXXXXXX',
                                      hintStyle: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.normal),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Enter phone number';
                                      if (v.length < 10) return 'Enter valid 10-digit number';
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Send OTP Button
                          SizedBox(
                            width: double.infinity, height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _sendOTP,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                  : const Text('Continue with OTP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.3)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Divider
                          Row(children: const [
                            Expanded(child: Divider(color: Color(0xFFEEEEEE))),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 14), child: Text('or continue with', style: TextStyle(color: AppColors.textLight, fontSize: 12, fontWeight: FontWeight.w500))),
                            Expanded(child: Divider(color: Color(0xFFEEEEEE))),
                          ]),
                          const SizedBox(height: 20),
                          // Facebook Button
                          SizedBox(
                            width: double.infinity, height: 56,
                            child: OutlinedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Facebook login coming soon!'), backgroundColor: Color(0xFF1877F2)),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF1877F2), width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 28, height: 28,
                                    decoration: const BoxDecoration(color: Color(0xFF1877F2), shape: BoxShape.circle),
                                    child: const Center(child: Text('f', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16))),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text('Continue with Facebook', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1877F2))),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Register
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                              child: RichText(
                                text: const TextSpan(children: [
                                  TextSpan(text: "New to AloGo? ", style: TextStyle(color: AppColors.textLight, fontSize: 14)),
                                  TextSpan(text: 'Create account', style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w700)),
                                ]),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: RichText(
                              text: const TextSpan(children: [
                                TextSpan(text: 'Alo', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                                TextSpan(text: 'Go', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                TextSpan(text: ' · Dhangadhi, Sudurpashchim · 2026', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}