import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final phone = _phoneController.text.trim();
    final pin = _pinController.text.trim();

    if (phone.isEmpty || pin.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Veuillez remplir tous les champs.";
      });
      return;
    }

    // Attempt actual login via provider
    try {
      await ref.read(authNotifierProvider.notifier).login(phone, pin);
      // Logic for role based routing after successful auth is handled by Router
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Identifiants incorrects.";
      });
    }
  }

  void _fillDemo(String phone, String pin) {
    _phoneController.text = phone;
    _pinController.text = pin;
    setState(() => _errorMessage = null);
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth success
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.value != null) {
        final role = next.value!.role.toLowerCase();
        context.go('/dashboard/$role');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tractor Icon matching screenshot
              const Icon(Icons.agriculture, size: 80, color: AppColors.primary),
              const SizedBox(height: 16),
              const Text(
                'Agri-TG',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 48),

              // Phone Field
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Numéro de téléphone',
                ),
              ),
              const SizedBox(height: 16),

              // PIN Field
              TextField(
                controller: _pinController,
                obscureText: true,
                maxLength: 6,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Code PIN',
                  counterStyle: TextStyle(color: Colors.white70),
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
              ],

              const SizedBox(height: 32),

              // Login Button matching screenshot
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D9E75),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Se connecter',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const SizedBox(height: 48),

              // Demo Accounts Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text("Mode Démo (MIABE 2026)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70)),
                    const SizedBox(height: 12),
                    _buildDemoTile("Membre", "123456789", "1234", AppColors.roleMembre),
                    _buildDemoTile("Trésorier", "987654321", "2026", AppColors.roleTresorier),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemoTile(String label, String phone, String pin, Color color) {
    return ListTile(
      dense: true,
      title: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      subtitle: Text("$phone / $pin", style: const TextStyle(color: Colors.white38)),
      trailing: const Icon(Icons.touch_app, size: 16, color: Colors.white24),
      onTap: () => _fillDemo(phone, pin),
    );
  }
}
