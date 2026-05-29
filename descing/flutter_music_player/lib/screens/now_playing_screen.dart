import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../models/album.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with SingleTickerProviderStateMixin {
  bool isPlaying = true;
  bool isFavorite = false;
  bool isRepeat = false;
  bool isShuffle = false;
  double volume = 0.75;
  double progress = 0.45;
  late AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentSong = sampleSongs.first;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1D23) : const Color(0xFFD8DCE3),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF2A2D33), const Color(0xFF1A1D23)]
                : [const Color(0xFFE8EAED), const Color(0xFFD2D6DC)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Close button
              Positioned(
                top: 24,
                right: 24,
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.white.withOpacity(0.4),
                    foregroundColor: isDark ? const Color(0xFF9BA3AD) : const Color(0xFF5E6772),
                  ),
                ),
              ),

              // Main content
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Album Artwork with breathing animation
                      AnimatedBuilder(
                        animation: _breathingController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + (_breathingController.value * 0.02),
                            child: child,
                          );
                        },
                        child: Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.white.withOpacity(0.5),
                              width: 8,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 64,
                                offset: const Offset(0, 32),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: currentSong.image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withOpacity(0.2),
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.2),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Song Info
                      Text(
                        currentSong.title,
                        style: theme.textTheme.displayMedium,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentSong.artist,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentSong.album,
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // Progress Bar
                      Column(
                        children: [
                          SliderTheme(
                            data: SliderThemeData(
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                              trackHeight: 8,
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                              activeTrackColor: isDark ? const Color(0xFF9BA3AD) : const Color(0xFF5E6772),
                              inactiveTrackColor: isDark ? const Color(0xFF1A1D23) : const Color(0xFFD2D6DC),
                              thumbColor: isDark ? const Color(0xFFE8EAED) : Colors.white,
                            ),
                            child: Slider(
                              value: progress,
                              onChanged: (value) {
                                setState(() {
                                  progress = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('1:58', style: theme.textTheme.bodySmall),
                                Text(currentSong.duration, style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Main Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.skip_previous),
                            iconSize: 36,
                            color: isDark ? const Color(0xFF9BA3AD) : const Color(0xFF5E6772),
                          ),
                          const SizedBox(width: 24),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: isDark
                                    ? [const Color(0xFF7A8490), const Color(0xFF5E6772)]
                                    : [const Color(0xFF5E6772), const Color(0xFF4A545E)],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPlaying = !isPlaying;
                                });
                              },
                              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                              iconSize: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 24),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.skip_next),
                            iconSize: 36,
                            color: isDark ? const Color(0xFF9BA3AD) : const Color(0xFF5E6772),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Secondary Controls
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isShuffle = !isShuffle;
                                    });
                                  },
                                  icon: const Icon(Icons.shuffle),
                                  color: isShuffle
                                      ? (isDark ? const Color(0xFF9BA3AD) : const Color(0xFF5E6772))
                                      : (isDark ? const Color(0xFF6E7681) : const Color(0xFF8A9199)),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isRepeat = !isRepeat;
                                    });
                                  },
                                  icon: const Icon(Icons.repeat),
                                  color: isRepeat
                                      ? (isDark ? const Color(0xFF9BA3AD) : const Color(0xFF5E6772))
                                      : (isDark ? const Color(0xFF6E7681) : const Color(0xFF8A9199)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isFavorite = !isFavorite;
                                    });
                                  },
                                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                                  color: isFavorite ? Colors.red : (isDark ? const Color(0xFF6E7681) : const Color(0xFF8A9199)),
                                ),
                                IconButton(
                                  onPressed: () => context.push('/queue'),
                                  icon: const Icon(Icons.queue_music),
                                  color: isDark ? const Color(0xFF6E7681) : const Color(0xFF8A9199),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Volume Control
                      Row(
                        children: [
                          Icon(
                            Icons.volume_up,
                            color: isDark ? const Color(0xFF6E7681) : const Color(0xFF8A9199),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                trackHeight: 6,
                                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                                activeTrackColor: isDark ? const Color(0xFF9BA3AD) : const Color(0xFF5E6772),
                                inactiveTrackColor: isDark ? const Color(0xFF1A1D23) : const Color(0xFFD2D6DC),
                                thumbColor: isDark ? const Color(0xFFE8EAED) : Colors.white,
                              ),
                              child: Slider(
                                value: volume,
                                onChanged: (value) {
                                  setState(() {
                                    volume = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
