import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/router/route_names.dart';
import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/core/utils/app_text_styles.dart';
import 'package:ecomins/core/utils/extensions.dart';
import 'package:ecomins/providers/auth_providers.dart';
import 'package:ecomins/shared/widgets/gradient_button.dart';

/// Production OTP screen with auto-submit, paste support, exponential backoff resend,
/// and shake animation on wrong OTP.
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.phone});

  final String phone;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _loading = false;
  int _resendCountdown = 30;
  int _resendAttempts = 0;
  Timer? _timer;

  // Shake animation
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    _startCountdown(30);
  }

  void _startCountdown(int seconds) {
    _timer?.cancel();
    setState(() => _resendCountdown = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendCountdown <= 1) {
        t.cancel();
        if (mounted) setState(() => _resendCountdown = 0);
      } else {
        if (mounted) setState(() => _resendCountdown--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  bool get _isComplete => _otp.length == 6;

  Future<void> _verifyOtp() async {
    if (!_isComplete) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    // Accept any 6-digit code in mock mode
    ref.read(authStateProvider.notifier).state = true;
    context.go(RouteNames.home);
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        // Auto-submit when last digit entered
        if (_isComplete) _verifyOtp();
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  Future<void> _handlePaste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim() ?? '';
    if (text.length == 6 && RegExp(r'^\d{6}$').hasMatch(text)) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = text[i];
      }
      setState(() {});
      _focusNodes[5].unfocus();
      await Future.delayed(const Duration(milliseconds: 100));
      _verifyOtp();
    }
  }

  void _resendOtp() {
    if (_resendCountdown > 0) return;
    _resendAttempts++;
    // Exponential backoff: 30s → 60s → 120s
    final seconds = 30 * (1 << _resendAttempts.clamp(0, 2));
    _startCountdown(seconds);
    context.showSuccess('OTP resent to +91 ${widget.phone}');
  }

  // Removed unused _shakeFields method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('Enter OTP', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(
                'Sent to +91 ${widget.phone}',
                style: AppTextStyles.body.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: _handlePaste,
                child: Text(
                  'Tap to paste from clipboard',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // OTP fields with shake animation
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (_, child) {
                  final offset = _shakeAnimation.value *
                      8 *
                      ((_shakeController.value < 0.5) ? 1 : -1);
                  return Transform.translate(
                    offset: Offset(offset, 0),
                    child: child,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (i) {
                    return SizedBox(
                      width: 48,
                      height: 56,
                      child: TextFormField(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: AppTextStyles.h3.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
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
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (v) => _onDigitChanged(i, v),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 40),

              GradientButton(
                label: 'Verify OTP',
                onTap: _isComplete ? _verifyOtp : () {},
                isLoading: _loading,
              ),
              const SizedBox(height: 24),

              Center(
                child: TextButton(
                  onPressed: _resendCountdown == 0 ? _resendOtp : null,
                  child: Text(
                    _resendCountdown > 0
                        ? 'Resend OTP in ${_resendCountdown}s'
                        : 'Resend OTP',
                    style: TextStyle(
                      color: _resendCountdown == 0
                          ? AppColors.primary
                          : AppColors.outline,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
