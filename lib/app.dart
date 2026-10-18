import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/widgets/offline_banner.dart';

/// Root application widget wired with go_router and AppTheme.
class EcominsApp extends ConsumerWidget {
  const EcominsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Ecomins',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
      builder: (context, child) {
        // Override error widget for production
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Container(
            color: const Color(0xFF111411),
            alignment: Alignment.center,
            child: const Text(
              'Something went wrong.\nPlease restart the app.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          );
        };

        // Clamp text scale factor to prevent huge text on accessibility settings
        final mediaQuery = MediaQuery.of(context);
        final clampedTextScaler = mediaQuery.textScaler.clamp(
          minScaleFactor: 0.8,
          maxScaleFactor: 1.2,
        );

        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: clampedTextScaler),
          child: ScrollConfiguration(
            // Remove overscroll glow on Android
            behavior: _NoGlowScrollBehavior(),
            child: Column(
              children: [
                const SafeArea(bottom: false, child: OfflineBanner()),
                Expanded(child: child ?? const SizedBox()),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Removes the overscroll glow effect on Android.
class _NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
