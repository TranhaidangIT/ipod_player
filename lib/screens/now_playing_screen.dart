import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:ui';
import '../providers/audio_provider.dart';
import '../utils/audio_feedback.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key, this.song});
  final dynamic song; // kept for backward compat

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with TickerProviderStateMixin {
  bool isFavorite = false;
  double volume = 0.75;

  late AnimationController _breathingController;
  late Animation<double> _breathScale;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _breathScale = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioProvider>();
    final song = audio.currentSong;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgTop = isDark ? const Color(0xFF1C1F26) : const Color(0xFFD8DCE3);
    final bgBottom = isDark ? const Color(0xFF0F1115) : const Color(0xFFC2C6CD);
    final accent = isDark ? const Color(0xFFACB5C0) : const Color(0xFF5A6470);
    final textPrimary = isDark ? const Color(0xFFECEFF4) : const Color(0xFF1A1D23);
    final textSecondary = isDark ? const Color(0xFF8A939E) : const Color(0xFF6E7681);

    final isPlaying = audio.isPlaying;
    final position = audio.position;
    final duration = audio.duration;
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bgBottom,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [bgTop, bgBottom],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // ── Top Bar ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      _GlassButton(
                        isDark: isDark,
                        icon: Icons.keyboard_arrow_down_rounded,
                        onTap: () {
                          AudioFeedback.playClick();
                          context.pop();
                        },
                      ),
                      const Expanded(
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                'ĐANG PHÁT',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2.0,
                                  color: Color(0xFF8A939E),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Nhạc Cổ Điển',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFACB5C0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _GlassButton(
                        isDark: isDark,
                        icon: Icons.more_horiz_rounded,
                        onTap: () => AudioFeedback.playClick(),
                      ),
                    ],
                  ),
                ),

                // ── Album Art ──
                Expanded(
                  flex: 5,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _breathScale,
                      builder: (context, child) => Transform.scale(
                        scale: isPlaying ? _breathScale.value : 0.92,
                        child: child,
                      ),
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.55 : 0.22),
                              blurRadius: 60,
                              offset: const Offset(0, 28),
                              spreadRadius: -8,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: song.image,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(
                                  color: isDark
                                      ? const Color(0xFF2A2D33)
                                      : const Color(0xFFE0E4EA),
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  color: const Color(0xFF2A2D33),
                                  child: const Icon(Icons.music_note_rounded, color: Colors.white38, size: 48),
                                ),
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.18),
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.12),
                                    ],
                                  ),
                                ),
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                              ),
                              // Loading indicator
                              if (audio.isLoading)
                                Container(
                                  color: Colors.black45,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white70,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Song Info + Favourite ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 16, 28, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              song.artist,
                              style: TextStyle(fontSize: 14, color: textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          AudioFeedback.playClick();
                          setState(() => isFavorite = !isFavorite);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isFavorite
                                ? Colors.red.withOpacity(0.15)
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: isFavorite ? Colors.red.shade400 : textSecondary,
                            size: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Progress Bar ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderThemeData(
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                          trackHeight: 4,
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                          activeTrackColor: accent,
                          inactiveTrackColor: accent.withOpacity(0.22),
                          thumbColor: isDark ? const Color(0xFFECEFF4) : Colors.white,
                          overlayColor: accent.withOpacity(0.15),
                        ),
                        child: Slider(
                          value: progress.clamp(0.0, 1.0),
                          onChanged: (v) {
                            final target = duration * v;
                            audio.seek(target);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: TextStyle(fontSize: 11, color: textSecondary),
                            ),
                            Text(
                              _formatDuration(duration),
                              style: TextStyle(fontSize: 11, color: textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Main Controls ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Shuffle
                      _ControlButton(
                        icon: Icons.shuffle_rounded,
                        size: 22,
                        color: audio.isShuffle ? accent : textSecondary.withOpacity(0.5),
                        onTap: () {
                          AudioFeedback.playClick();
                          audio.toggleShuffle();
                        },
                      ),
                      // Previous
                      _ControlButton(
                        icon: Icons.skip_previous_rounded,
                        size: 36,
                        color: accent,
                        onTap: () {
                          AudioFeedback.playClick();
                          audio.previous();
                        },
                      ),
                      // Big Play/Pause
                      GestureDetector(
                        onTap: () {
                          AudioFeedback.playClick();
                          audio.togglePlay();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: isDark
                                  ? [const Color(0xFF7A8490), const Color(0xFF4A545E)]
                                  : [const Color(0xFF6B7580), const Color(0xFF4A545E)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4A545E).withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: audio.isLoading
                              ? const Center(
                                  child: SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                )
                              : Icon(
                                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  size: 38,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                      // Next
                      _ControlButton(
                        icon: Icons.skip_next_rounded,
                        size: 36,
                        color: accent,
                        onTap: () {
                          AudioFeedback.playClick();
                          audio.next();
                        },
                      ),
                      // Loop
                      _ControlButton(
                        icon: audio.loopMode == LoopMode.one
                            ? Icons.repeat_one_rounded
                            : Icons.repeat_rounded,
                        size: 22,
                        color: audio.loopMode != LoopMode.off
                            ? accent
                            : textSecondary.withOpacity(0.5),
                        onTap: () {
                          AudioFeedback.playClick();
                          audio.toggleLoop();
                        },
                      ),
                    ],
                  ),
                ),

                // ── Volume ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Row(
                    children: [
                      Icon(Icons.volume_down_rounded, size: 18, color: textSecondary),
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                            trackHeight: 3,
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                            activeTrackColor: accent.withOpacity(0.7),
                            inactiveTrackColor: accent.withOpacity(0.18),
                            thumbColor: accent,
                          ),
                          child: Slider(
                            value: volume,
                            onChanged: (v) => setState(() => volume = v),
                          ),
                        ),
                      ),
                      Icon(Icons.volume_up_rounded, size: 18, color: textSecondary),
                    ],
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

// ── Reusable components ──

class _GlassButton extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final VoidCallback onTap;

  const _GlassButton({
    required this.isDark,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.12)
                    : Colors.white.withOpacity(0.7),
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isDark ? const Color(0xFFACB5C0) : const Color(0xFF5A6470),
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.size,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: size, color: color),
      ),
    );
  }
}
