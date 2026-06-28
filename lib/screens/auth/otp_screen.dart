import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/providers/auth_provider.dart';
import '../customer/home_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  const OTPScreen({super.key, required this.phone});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  int _resendTimer = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() { _resendTimer = 30; _canResend = false; });
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _resendTimer--);
      if (_resendTimer <= 0) { setState(() => _canResend = true); return false; }
      return true;
    });
  }

  String get _otp => _controllers.map((c) => c.text).join();

  Future<void> _verifyOTP() async {
    if (_otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter complete 6-digit OTP'), backgroundColor: AppColors.error));
      return;
    }
    setState(() => _isLoading = true);

    // For testing: OTP is 123456
    await Future.delayed(const Duration(seconds: 1));

    if (_otp == '123456') {
      final auth = context.read<AuthProvider>();
      await auth.login(widget.phone.replaceAll('+977', ''), '123456');
      if (mounted) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
      }
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid OTP. Use 123456 for testing.'), backgroundColor: AppColors.error));
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top black section
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      ),
                    ),
                    const Spacer(),
                    const Text('Verify\nNumber', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1, letterSpacing: -1)),
                    const SizedBox(height: 10),
                    Text('OTP sent to ${widget.phone}', style: const TextStyle(fontSize: 14, color: Colors.white54)),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // White bottom
            Expanded(
              flex: 7,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Enter OTP', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark, letterSpacing: 0.3)),
                    const SizedBox(height: 8),
                    Text('For testing use: 123456', style: TextStyle(fontSize: 12, color: AppColors.primary.withOpacity(0.8))),
                    const SizedBox(height: 20),
                    // OTP Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) => SizedBox(
                        width: 48, height: 56,
                        child: TextFormField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: const Color(0xFFF7F7F7),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE8E8E8))),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE8E8E8))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
                          ),
                          onChanged: (v) {
                            if (v.isNotEmpty && index < 5) _focusNodes[index + 1].requestFocus();
                            if (v.isEmpty && index > 0) _focusNodes[index - 1].requestFocus();
                            if (index == 5 && v.isNotEmpty) _verifyOTP();
                          },
                        ),
                      )),
                    ),
                    const SizedBox(height: 24),
                    // Resend
                    Center(
                      child: _canResend
                          ? GestureDetector(
                              onTap: () { _startTimer(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP resent!'), backgroundColor: AppColors.success)); },
                              child: const Text('Resend OTP', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14)),
                            )
                          : Text('Resend in ${_resendTimer}s', style: const TextStyle(color: AppColors.textLight, fontSize: 14)),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity, height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _verifyOTP,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : const Text('Verify OTP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                      ),
                    ),
                    const Spacer(),
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
          ],
        ),
      ),
    );
  }
}