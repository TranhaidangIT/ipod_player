import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/dummy_data.dart';
import '../theme/app_theme.dart';
import 'now_playing_screen.dart';

class CoverWheelScreen extends StatefulWidget {
  final void Function(Map<String, String> song)? onSongSelected;
  const CoverWheelScreen({Key? key, this.onSongSelected}) : super(key: key);

  @override
  State<CoverWheelScreen> createState() => _CoverWheelScreenState();
}

class _CoverWheelScreenState extends State<CoverWheelScreen> {
  final PageController _pageController = PageController(initialPage: 2, viewportFraction: 0.55);
  double _currentPage = 2.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() => _currentPage = _pageController.page ?? 2.0);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final albums = DummyData.albums;
    final int currentIndex = _currentPage.round().clamp(0, albums.length - 1);
    final currentAlbum = albums[currentIndex];

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // Dynamic blurred background
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: Container(
                key: ValueKey(currentAlbum['image']),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(currentAlbum['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? [
                            AppColors.darkBg.withOpacity(0.6),
                            AppColors.darkBg.withOpacity(0.85),
                            AppColors.darkBg,
                          ]
                        : [
                            AppColors.lightBg.withOpacity(0.5),
                            AppColors.lightBg.withOpacity(0.8),
                            AppColors.lightBg,
                          ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Text(
                  'Phát Ngẫu Nhiên',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),

                // 3D Wheel
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemCount: albums.length,
                    itemBuilder: (context, index) {
                      final album = albums[index];
                      final distance = index - _currentPage;
                      final absDistance = distance.abs().clamp(0.0, 3.0);
                      final isActive = absDistance < 0.5;

                      final scale = isActive ? 1.05 : (0.85 - absDistance * 0.08).clamp(0.3, 1.0);
                      final opacity = (1.0 - absDistance * 0.3).clamp(0.0, 1.0);
                      final rotX = distance * -0.25;
                      final zTranslation = isActive ? 50.0 : -absDistance * 120.0;

                      return GestureDetector(
                        onTap: () {
                          if (isActive) {
                            final song = {
                              'title': album['title']!,
                              'artist': album['artist']!,
                              'image': album['image']!,
                            };
                            widget.onSongSelected?.call(song);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => NowPlayingScreen(song: song),
                            ));
                          } else {
                            _pageController.animateToPage(index,
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeOut,
                            );
                          }
                        },
                        child: Center(
                          child: Opacity(
                            opacity: opacity,
                            child: Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..translate(0.0, 0.0, zTranslation)
                                ..rotateX(rotX)
                                ..scale(scale),
                              alignment: Alignment.center,
                              child: Container(
                                width: 260,
                                height: 260,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: isActive
                                      ? [
                                          BoxShadow(
                                            color: isDark
                                                ? AppColors.darkShadow
                                                : AppColors.lightShadow,
                                            blurRadius: 30,
                                            offset: const Offset(0, 15),
                                          ),
                                        ]
                                      : [],
                                  image: DecorationImage(
                                    image: NetworkImage(album['image']!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: isActive
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: isDark
                                                ? Colors.white.withOpacity(0.2)
                                                : Colors.white.withOpacity(0.6),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.white.withOpacity(isDark ? 0.08 : 0.25),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                        // Play button ở giữa
                                        child: Center(
                                          child: Container(
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white.withOpacity(0.9),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.3),
                                                  blurRadius: 12,
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.black.withOpacity(0.7),
                                              size: 32,
                                            ),
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Album info + dots
                Padding(
                  padding: const EdgeInsets.only(bottom: 140),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface.withOpacity(0.8)
                          : AppColors.lightSurface.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? AppColors.darkShadow : AppColors.lightShadow,
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          currentAlbum['title']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentAlbum['artist']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: subColor, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${currentAlbum['title']} • 3:32',
                          style: TextStyle(color: subColor.withOpacity(0.6), fontSize: 11),
                        ),
                        const SizedBox(height: 10),
                        // Dots indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(albums.length, (i) {
                            final isActiveDot = i == currentIndex;
                            return Container(
                              width: isActiveDot ? 20 : 6,
                              height: 6,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: isActiveDot
                                    ? (isDark ? Colors.white : AppColors.lightPlayBtn)
                                    : subColor.withOpacity(0.3),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
