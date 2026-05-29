import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../models/album.dart';
import '../models/song.dart';
import '../providers/audio_provider.dart';
import '../utils/audio_feedback.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  Album? selectedAlbum;
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    selectedAlbum = sampleAlbums.first;
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgGrad = isDark
        ? [const Color(0xFF1C1F26), const Color(0xFF0F1115)]
        : [const Color(0xFFDEE1E8), const Color(0xFFC8CDD6)];
    final cardBg = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.white.withOpacity(0.6);
    final cardBorder = isDark
        ? Colors.white.withOpacity(0.10)
        : Colors.white.withOpacity(0.75);
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
                      Icon(Icons.library_music_rounded, size: 18, color: accent),
                      const SizedBox(width: 10),
                      Text(
                        'Nhạc Cổ Điển',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.search_rounded, size: 22, color: textSecondary),
                    ],
                  ),
                ),

                // ── Now Playing Glass Card ──
                Consumer<AudioProvider>(
                  builder: (context, audio, _) {
                    final song = audio.currentSong;
                    final dur = audio.duration;
                    final pos = audio.position;
                    final progVal = dur.inMilliseconds > 0
                        ? pos.inMilliseconds / dur.inMilliseconds
                        : 0.0;

                    return GestureDetector(
                      onTap: () {
                        AudioFeedback.playClick();
                        context.push('/now-playing');
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: cardBorder, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(isDark ? 0.35 : 0.10),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: CachedNetworkImage(
                                            imageUrl: song.image,
                                            width: 72,
                                            height: 72,
                                            fit: BoxFit.cover,
                                            errorWidget: (_, __, ___) => Container(
                                              width: 72,
                                              height: 72,
                                              color: const Color(0xFF2A2D33),
                                              child: const Icon(Icons.music_note_rounded, color: Colors.white38),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              song.title,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: textPrimary,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              song.artist,
                                              style: TextStyle(fontSize: 13, color: textSecondary),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Play/Pause button
                                      GestureDetector(
                                        onTap: () {
                                          AudioFeedback.playClick();
                                          audio.togglePlay();
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 180),
                                          width: 46,
                                          height: 46,
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
                                                color: const Color(0xFF4A545E).withOpacity(0.35),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            audio.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  // Real progress bar
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: progVal.clamp(0.0, 1.0),
                                      backgroundColor: accent.withOpacity(0.15),
                                      valueColor: AlwaysStoppedAnimation<Color>(accent),
                                      minHeight: 3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () => audio.previous(),
                                        child: Icon(Icons.skip_previous_rounded, size: 20, color: textSecondary),
                                      ),
                                      GestureDetector(
                                        onTap: () => audio.next(),
                                        child: Icon(Icons.skip_next_rounded, size: 20, color: textSecondary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // ── Library label ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
                  child: Row(
                    children: [
                      Text(
                        'THƯ VIỆN',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                          color: textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${songLibrary.length} bài',
                        style: TextStyle(
                          fontSize: 11,
                          color: textSecondary.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Song List ──
                Expanded(
                  child: Consumer<AudioProvider>(
                    builder: (context, audio, _) {
                      return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                    itemCount: songLibrary.length,
                    itemBuilder: (context, index) {
                      final song = songLibrary[index];
                      final isSelected = audio.currentIndex == index && audio.isPlaying;

                      return GestureDetector(
                        onTap: () {
                          AudioFeedback.playClick();
                          audio.playSong(index);
                          setState(() => selectedAlbum = sampleAlbums[index % sampleAlbums.length]);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark
                                    ? Colors.white.withOpacity(0.10)
                                    : Colors.white.withOpacity(0.75))
                                : (isDark
                                    ? Colors.white.withOpacity(0.04)
                                    : Colors.white.withOpacity(0.45)),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? accent.withOpacity(0.5)
                                  : (isDark
                                      ? Colors.white.withOpacity(0.08)
                                      : Colors.white.withOpacity(0.6)),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.10),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            children: [
                              // Rank indicator
                              SizedBox(
                                width: 20,
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isSelected ? accent : textSecondary.withOpacity(0.4),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Art
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                   borderRadius: BorderRadius.circular(10),
                                   child: CachedNetworkImage(
                                     imageUrl: song.image,
                                     width: 56,
                                     height: 56,
                                     fit: BoxFit.cover,
                                     errorWidget: (_, __, ___) => Container(
                                       width: 56, height: 56,
                                       color: const Color(0xFF2A2D33),
                                       child: const Icon(Icons.music_note_rounded, color: Colors.white38, size: 22),
                                     ),
                                   ),
                                 ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      song.title,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected ? textPrimary : textPrimary.withOpacity(0.85),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      song.artist,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: textSecondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (isSelected)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: accent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  const SizedBox(height: 4),
                                   Text(
                                     song.duration,
                                     style: TextStyle(
                                       fontSize: 11,
                                       color: textSecondary.withOpacity(0.6),
                                     ),
                                   ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
