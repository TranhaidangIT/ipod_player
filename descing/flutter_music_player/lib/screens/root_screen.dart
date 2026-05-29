import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class RootScreen extends StatefulWidget {
  final Widget child;

  const RootScreen({super.key, required this.child});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index, BuildContext context) {
    setState(() {
      _currentIndex = index;
    });

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
      case 4:
        // Toggle theme
        final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        themeProvider.toggleTheme();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1A1D23), const Color(0xFF0F1115)]
                : [const Color(0xFFD8DCE3), const Color(0xFFC5C9D0)],
          ),
        ),
        child: widget.child,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: isDark
                ? [const Color(0xFF2A2D33), const Color(0xFF1A1D23)]
                : [const Color(0xFFE8EAED), const Color(0xFFF5F5F7)],
          ),
          border: Border(
            top: BorderSide(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.library_music_outlined,
                  label: 'Album',
                  index: 0,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.album_outlined,
                  label: 'Flow',
                  index: 1,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.grid_3x3_outlined,
                  label: 'Khám Phá',
                  index: 2,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.search_outlined,
                  label: 'Tìm',
                  index: 3,
                ),
                _buildNavItem(
                  context,
                  icon: isDark ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
                  label: isDark ? 'Sáng' : 'Tối',
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return GestureDetector(
      onTap: () => _onTabTapped(index, context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.6))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? (isDark ? const Color(0xFF9BA3AD) : const Color(0xFF5E6772))
                  : (isDark ? const Color(0xFF5E6772) : const Color(0xFF8A9199)),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? (isDark ? const Color(0xFF9BA3AD) : const Color(0xFF5E6772))
                    : (isDark ? const Color(0xFF5E6772) : const Color(0xFF8A9199)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
