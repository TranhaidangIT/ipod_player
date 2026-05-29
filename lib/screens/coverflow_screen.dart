import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../models/album.dart';
import '../models/song.dart';
import '../providers/audio_provider.dart';
import '../utils/audio_feedback.dart';

class CoverFlowScreen extends StatefulWidget {
  const CoverFlowScreen({super.key});

  @override
  State<CoverFlowScreen> createState() => _CoverFlowScreenState();
}

class _CoverFlowScreenState extends State<CoverFlowScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int currentIndex = 2;
  bool isPlaying = false;
  bool isVertical = false; // Toggle state
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _orientationController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: currentIndex,
      viewportFraction: 0.72,
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _orientationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      value: isVertical ? 1.0 : 0.0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    _orientationController.dispose();
    super.dispose();
  }

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
    final headerBg = isDark
        ? [const Color(0xFF282C35), const Color(0xFF1C1F26)]
        : [const Color(0xFFF0F2F5), const Color(0xFFE4E7ED)];

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
              children: [
                // ── Header ──
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: headerBg,
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? Colors.white.withOpacity(0.07)
                            : Colors.black.withOpacity(0.07),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          AudioFeedback.playClick();
                          setState(() {
                            isVertical = !isVertical;
                            if (isVertical) {
                              _orientationController.animateTo(1.0, curve: Curves.easeOutCubic);
                            } else {
                              _orientationController.animateTo(0.0, curve: Curves.easeOutCubic);
                            }
                            // Recreate controller to apply new scroll direction without jump
                            _pageController.dispose();
                            _pageController = PageController(
                              initialPage: currentIndex,
                              viewportFraction: 0.72,
                            );
                          });
                        },
                        icon: Icon(
                          isVertical ? Icons.view_carousel_rounded : Icons.view_agenda_rounded,
                          color: const Color(0xFF8A939E),
                          size: 22,
                        ),
                      ),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'COVER FLOW',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0,
                                color: Color(0xFF8A939E),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Phát Ngẫu Nhiên',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFECEFF4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const IconButton(
                        onPressed: null,
                        icon: Icon(Icons.shuffle_rounded, color: Color(0xFF8A939E), size: 22),
                      ),
                    ],
                  ),
                ),

                // ── Stacked Cover Flow ──
                Expanded(
                  flex: 6,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. Visual Stack
                      AnimatedBuilder(
                        animation: _orientationController,
                        builder: (context, _) {
                          return AnimatedBuilder(
                            animation: _pageController,
                            builder: (context, child) {
                              double page = 0.0;
                              if (_pageController.hasClients && _pageController.position.haveDimensions) {
                                page = _pageController.page ?? currentIndex.toDouble();
                              } else {
                                page = currentIndex.toDouble();
                              }

                              double oVal = _orientationController.value;
                              double hFactor = 1.0 - oVal; // 1 = ngang, 0 = dọc
                              double vFactor = oVal;       // 1 = dọc, 0 = ngang

                              List<_DeckItem> items = [];
                              for (int i = 0; i < sampleSongs.length; i++) {
                                double offset = i - page;
                                double absOffset = offset.abs();

                                // Toán học tối ưu hiệu năng
                                double scale = (1 - absOffset * 0.12).clamp(0.6, 1.0);
                                double opacity = (1 - absOffset * 0.4).clamp(0.0, 1.0);
                                
                                double translate = offset * 105; 
                                double rotation = offset.clamp(-1.0, 1.0) * -0.15;
                                double z = 100 - absOffset;

                                items.add(_DeckItem(
                                  index: i,
                                  z: z,
                                  scale: scale,
                                  opacity: opacity,
                                  translate: translate,
                                  rotation: rotation,
                                ));
                              }

                              items.sort((a, b) => a.z.compareTo(b.z));

                              // Culling: Chỉ render các item hiển thị
                              var visibleItems = items.where((item) => item.opacity > 0.01).toList();

                              return Stack(
                                alignment: Alignment.center,
                                children: visibleItems.map((item) {
                                  return Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..setEntry(3, 2, 0.001) // perspective
                                      ..translate(
                                        item.translate * hFactor,
                                        item.translate * vFactor,
                                      )
                                      ..rotateX(item.rotation * vFactor)
                                      ..rotateY(item.rotation * hFactor)
                                      ..scale(item.scale),
                                    child: Opacity(
                                      opacity: item.opacity,
                                      child: _buildCard(item.index, isDark),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          );
                        },
                      ),

                      // 2. Invisible PageView for Gesture Physics
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () {
                            AudioFeedback.playClick();
                            final audio = context.read<AudioProvider>();
                            // Map to songLibrary index
                            final songIdx = currentIndex % songLibrary.length;
                            if (audio.currentIndex == songIdx && audio.isPlaying) {
                              audio.togglePlay();
                            } else {
                              audio.playSong(songIdx);
                            }
                            setState(() => isPlaying = !isPlaying);
                          },
                          child: PageView.builder(
                            key: ValueKey(isVertical),
                            scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
                            controller: _pageController,
                            onPageChanged: (index) {
                              AudioFeedback.playScroll();
                              setState(() {
                                currentIndex = index;
                                isPlaying = false;
                              });
                            },
                            itemCount: sampleSongs.length,
                            itemBuilder: (context, index) {
                              return const SizedBox.expand(); // Invisible gesture catcher
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Song Info Card ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.07)
                              : Colors.white.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.11)
                                : Colors.white.withOpacity(0.75),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              songLibrary[currentIndex % songLibrary.length].title,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                                letterSpacing: -0.2,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              songLibrary[currentIndex % songLibrary.length].artist,
                              style: TextStyle(
                                fontSize: 13,
                                color: textSecondary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${songLibrary[currentIndex % songLibrary.length].album}  •  ${songLibrary[currentIndex % songLibrary.length].duration}',
                              style: TextStyle(
                                fontSize: 11,
                                color: textSecondary.withOpacity(0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 14),
                            // Dot indicators
                            SizedBox(
                              height: 6,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(songLibrary.length, (i) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOutCubic,
                                    margin: const EdgeInsets.symmetric(horizontal: 3),
                                    width: i == currentIndex ? 20 : 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: i == currentIndex
                                          ? accent
                                          : accent.withOpacity(0.22),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(int index, bool isDark) {
    final songIdx = index % songLibrary.length;
    return SizedBox(
      width: 280,
      height: 280,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(index == currentIndex ? 0.45 : 0.2),
              blurRadius: index == currentIndex ? 50 : 20,
              offset: const Offset(0, 20),
              spreadRadius: -5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: songLibrary[songIdx].image,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.grey.shade800, Colors.grey.shade900],
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.music_note_rounded, color: Colors.white38, size: 48),
                  ),
                ),
              ),
              // Gloss overlay
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.18),
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
              // Metallic border
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 1.5,
                  ),
                ),
              ),
              // Play overlay for current
              if (index == currentIndex)
                Consumer<AudioProvider>(
                  builder: (ctx, audio, _) {
                    final playing = audio.isPlaying && audio.currentIndex == songIdx;
                    return AnimatedBuilder(
                      animation: playing
                          ? _pulseAnimation
                          : const AlwaysStoppedAnimation(1.0),
                      builder: (ctx2, _) => Container(
                        color: Colors.black.withOpacity(0.15),
                        child: Center(
                          child: Transform.scale(
                            scale: playing ? _pulseAnimation.value : 1.0,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.85),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 24,
                                  ),
                                ],
                              ),
                              child: audio.isLoading
                                  ? const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Color(0xFF4A545E),
                                      ),
                                    )
                                  : Icon(
                                      playing
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                      size: 38,
                                      color: const Color(0xFF4A545E),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeckItem {
  final int index;
  final double z;
  final double scale;
  final double opacity;
  final double translate;
  final double rotation;

  _DeckItem({
    required this.index,
    required this.z,
    required this.scale,
    required this.opacity,
    required this.translate,
    required this.rotation,
  });
}
