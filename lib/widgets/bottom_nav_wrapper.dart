import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'animations.dart';

class BottomNavWrapper extends StatelessWidget {
  final Widget child;

  const BottomNavWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final location = GoRouterState.of(context).uri.toString();
    
    // Hide nav on detail screen
    if (location == '/alert-detail') {
      return child;
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF08121A) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          GradientBackground(child: child),
          
          // Floating Bottom Nav
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    color: (isDark ? const Color(0xFF0F2133) : Colors.white).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFF22C55E).withValues(alpha: isDark ? 0.15 : 0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark ? Colors.black : Colors.grey[400]!).withValues(alpha: isDark ? 0.4 : 0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(context, Icons.home_filled, 'Home', '/', location),
                      _buildNavItem(context, Icons.history, 'History', '/history', location),
                      _buildNavItem(context, Icons.settings_rounded, 'Settings', '/settings', location),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, String route, String currentRoute) {
    final isSelected = currentRoute == route;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isSelected 
      ? const Color(0xFF22C55E) 
      : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B));
    
    return GestureDetector(
      onTap: () => context.go(route),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF22C55E).withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: color,
              size: 26,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
