import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/theme_provider.dart';
import '../utils/audio_feedback.dart';

class RootScreen extends StatefulWidget {
  final Widget child;
  const RootScreen({super.key, required this.child});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _indicatorController;

  @override
  void initState() {
    super.initState();
    _indicatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _indicatorController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index, BuildContext context) {
    if (index == 4) {
      // Theme toggle — no nav change
      AudioFeedback.playClick();
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      themeProvider.toggleTheme();
      return;
    }

    if (index == _currentIndex) return;

    AudioFeedback.playClick();
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/coverflow');
        break;
      case 2:
        context.go('/library-hub');
        break;
      case 3:
        context.go('/search');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F1115) : const Color(0xFFC8CDD6),
        body: widget.child,
        bottomNavigationBar: _buildBottomNav(isDark, context),
      ),
    );
  }

  Widget _buildBottomNav(bool isDark, BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final navItems = [
      _NavItem(icon: Icons.library_music_rounded, label: 'Album'),
      _NavItem(icon: Icons.view_carousel_rounded, label: 'Flow'),
      _NavItem(icon: Icons.grid_view_rounded, label: 'Khám Phá'),
      _NavItem(icon: Icons.search_rounded, label: 'Tìm'),
      _NavItem(
        icon: themeProvider.isDarkMode
            ? Icons.wb_sunny_rounded
            : Icons.nights_stay_rounded,
        label: themeProvider.isDarkMode ? 'Sáng' : 'Tối',
      ),
    ];

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: isDark
                  ? [
                      const Color(0xFF1C1F26).withOpacity(0.95),
                      const Color(0xFF1C1F26).withOpacity(0.85),
                    ]
                  : [
                      const Color(0xFFE8EAED).withOpacity(0.95),
                      const Color(0xFFEEF0F3).withOpacity(0.85),
                    ],
            ),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.08),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(navItems.length, (index) {
                  return _buildNavItem(
                    context: context,
                    item: navItems[index],
                    index: index,
                    isDark: isDark,
                    isToggle: index == 4,
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required _NavItem item,
    required int index,
    required bool isDark,
    bool isToggle = false,
  }) {
    final isSelected = !isToggle && _currentIndex == index;
    final accent = isDark ? const Color(0xFFACB5C0) : const Color(0xFF5A6470);
    final inactive = isDark ? const Color(0xFF4A525E) : const Color(0xFF9BA5B0);

    return GestureDetector(
      onTap: () => _onTabTapped(index, context),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? Colors.white.withOpacity(0.10)
                  : Colors.black.withOpacity(0.07))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                item.icon,
                size: 22,
                color: isSelected ? accent : inactive,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? accent : inactive,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 2),
            // Active dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isSelected ? 4 : 0,
              height: isSelected ? 4 : 0,
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  _NavItem({required this.icon, required this.label});
}
