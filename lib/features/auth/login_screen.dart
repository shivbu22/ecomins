import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/router/route_names.dart';
import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/core/utils/app_text_styles.dart';
import 'package:ecomins/core/utils/extensions.dart';
import 'package:ecomins/core/utils/validators.dart';
import 'package:ecomins/shared/widgets/gradient_button.dart';

/// Production login screen with phone validation, loading state, and keyboard awareness.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _loading = false);
    context.go(
      '${RouteNames.loginOtp}?phone=${_phoneController.text.trim()}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background glow blobs
          Positioned(
            top: -80,
            left: -80,
            child: _GlowBlob(color: AppColors.primary.withValues(alpha: 0.12)),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: _GlowBlob(color: const Color(0xFF69F0AE).withValues(alpha: 0.08)),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Logo row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.eco, color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 10),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF3FE56C), Color(0xFF69F0AE)],
                          ).createShader(bounds),
                          child: const Text(
                            'ECOMINS',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    // Hero icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.eco, size: 44, color: AppColors.primary),
                    ),
                    const SizedBox(height: 20),

                    Text('Welcome back', style: AppTextStyles.bodySmall),
                    const SizedBox(height: 6),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF3FE56C), Color(0xFF69F0AE)],
                      ).createShader(bounds),
                      child: const Text(
                        'ECOMINS',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Eco services delivered in 10 minutes',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 40),

                    // Phone input row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '+91',
                            style: AppTextStyles.h4,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            style: AppTextStyles.body.copyWith(color: AppColors.onSurface),
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: 'Phone number',
                              hintStyle: const TextStyle(color: AppColors.outline),
                              filled: true,
                              fillColor: AppColors.surfaceContainerLow,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.error,
                                  width: 1.5,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.error,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            validator: Validators.phone,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    GradientButton(
                      label: 'Send OTP',
                      onTap: _sendOtp,
                      isLoading: _loading,
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppColors.outline)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('OR', style: AppTextStyles.label),
                        ),
                        const Expanded(child: Divider(color: AppColors.outline)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Google button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () => context.showSnack('Google sign-in coming soon'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.outline),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.g_mobiledata,
                            color: AppColors.onSurface, size: 28),
                        label: Text(
                          'Continue with Google',
                          style: AppTextStyles.body,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    Text(
                      'By continuing, you agree to our Terms of Service\nand Privacy Policy',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(height: 1.6),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
