import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomins/core/theme/app_colors.dart';
import 'package:ecomins/providers/notification_providers.dart';

/// Production-quality bottom nav bar with animated indicator, haptic feedback,
/// badge support, and smooth scale animation.
class AppBottomNavBar extends ConsumerStatefulWidget {
  const AppBottomNavBar({super.key});

  @override
  ConsumerState<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends ConsumerState<AppBottomNavBar> {
  int? _pressedIndex;

  static const _tabs = [
    _NavTab(label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home, path: '/home'),
    _NavTab(label: 'Services', icon: Icons.cleaning_services_outlined, activeIcon: Icons.cleaning_services, path: '/services/cleaning'),
    _NavTab(label: 'Orders', icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, path: '/orders'),
    _NavTab(label: 'Eco', icon: Icons.eco_outlined, activeIcon: Icons.eco, path: '/eco'),
    _NavTab(label: 'Profile', icon: Icons.person_outline, activeIcon: Icons.person, path: '/profile'),
  ];

  int _activeIndex(String location) {
    for (int i = _tabs.length - 1; i >= 0; i--) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final activeIndex = _activeIndex(location);
    final unreadCount = ref.watch(unreadCountProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: Color(0x1A3C4A3C))),
        boxShadow: [
          BoxShadow(
            color: Color(0x44000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_tabs.length, (i) {
              final tab = _tabs[i];
              final isActive = i == activeIndex;
              final isPressed = _pressedIndex == i;
              final showBadge = i == 0 && unreadCount > 0;

              return Expanded(
                child: GestureDetector(
                  onTapDown: (_) {
                    setState(() => _pressedIndex = i);
                    HapticFeedback.lightImpact();
                  },
                  onTapUp: (_) {
                    setState(() => _pressedIndex = null);
                    context.go(tab.path);
                  },
                  onTapCancel: () => setState(() => _pressedIndex = null),
                  child: AnimatedScale(
                    scale: isPressed ? 0.88 : 1.0,
                    duration: const Duration(milliseconds: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated pill indicator
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          width: isActive ? 32 : 0,
                          height: 3,
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              isActive ? tab.activeIcon : tab.icon,
                              color: isActive ? AppColors.primary : AppColors.outline,
                              size: 24,
                            ),
                            if (showBadge)
                              Positioned(
                                top: -4,
                                right: -6,
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  decoration: const BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    unreadCount > 9 ? '9+' : '$unreadCount',
                                    style: const TextStyle(
                                      color: AppColors.onError,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tab.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                            color: isActive ? AppColors.primary : AppColors.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavTab {
  const _NavTab({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.path,
  });
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String path;
}
