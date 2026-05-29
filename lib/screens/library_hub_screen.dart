import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../utils/audio_feedback.dart';

class LibraryHubScreen extends StatelessWidget {
  const LibraryHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgGrad = isDark
        ? [const Color(0xFF1C1F26), const Color(0xFF0F1115)]
        : [const Color(0xFFDEE1E8), const Color(0xFFC4C8D0)];
    final accent = isDark ? const Color(0xFFACB5C0) : const Color(0xFF5A6470);
    final textPrimary = isDark ? const Color(0xFFECEFF4) : const Color(0xFF1A1D23);
    final textSecondary = isDark ? const Color(0xFF8A939E) : const Color(0xFF6E7681);

    final categories = [
      _Category(
        title: 'Album',
        subtitle: '8 album',
        icon: Icons.album_rounded,
        gradientStart: const Color(0xFF6E7681),
        gradientEnd: const Color(0xFF4A535E),
      ),
      _Category(
        title: 'Nghệ Sĩ',
        subtitle: '8 nghệ sĩ',
        icon: Icons.person_rounded,
        gradientStart: const Color(0xFF7A8490),
        gradientEnd: const Color(0xFF545E6A),
      ),
      _Category(
        title: 'Bài Hát',
        subtitle: '8 bài hát',
        icon: Icons.music_note_rounded,
        gradientStart: const Color(0xFF6A747E),
        gradientEnd: const Color(0xFF404A55),
      ),
      _Category(
        title: 'Danh Sách Phát',
        subtitle: '3 danh sách',
        icon: Icons.queue_music_rounded,
        gradientStart: const Color(0xFF808A94),
        gradientEnd: const Color(0xFF5A646E),
      ),
      _Category(
        title: 'Yêu Thích',
        subtitle: 'Bài hát đã thích',
        icon: Icons.favorite_rounded,
        gradientStart: const Color(0xFF9A6A6A),
        gradientEnd: const Color(0xFF6A4040),
      ),
      _Category(
        title: 'Nghe Gần Đây',
        subtitle: 'Lịch sử phát',
        icon: Icons.access_time_rounded,
        gradientStart: const Color(0xFF6E7A8A),
        gradientEnd: const Color(0xFF445060),
      ),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: bgGrad,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Khám Phá',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Thư viện nhạc cổ điển',
                        style: TextStyle(
                          fontSize: 13,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Grid layout ──
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return _CategoryCard(
                        category: cat,
                        isDark: isDark,
                        accent: accent,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      );
                    },
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

class _CategoryCard extends StatefulWidget {
  final _Category category;
  final bool isDark;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;

  const _CategoryCard({
    required this.category,
    required this.isDark,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        AudioFeedback.playClick();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: widget.isDark
                    ? Colors.white.withOpacity(0.07)
                    : Colors.white.withOpacity(0.55),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isDark
                      ? Colors.white.withOpacity(0.10)
                      : Colors.white.withOpacity(0.75),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(widget.isDark ? 0.3 : 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon badge
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            widget.category.gradientStart,
                            widget.category.gradientEnd,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: widget.category.gradientEnd.withOpacity(0.45),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.category.icon,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    // Text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: widget.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.category.subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: widget.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Category {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color gradientStart;
  final Color gradientEnd;

  const _Category({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientStart,
    required this.gradientEnd,
  });
}
