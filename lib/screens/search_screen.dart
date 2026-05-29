import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../models/album.dart';
import '../utils/audio_feedback.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  List<Song> _results = [];

  @override
  void initState() {
    super.initState();
    _results = sampleSongs;
  }

  void _onSearch(String q) {
    setState(() {
      _query = q;
      if (q.isEmpty) {
        _results = sampleSongs;
      } else {
        _results = sampleSongs
            .where((s) =>
                s.title.toLowerCase().contains(q.toLowerCase()) ||
                s.artist.toLowerCase().contains(q.toLowerCase()) ||
                s.album.toLowerCase().contains(q.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
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
    final inputBg = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.white.withOpacity(0.65);

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
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                  child: Text(
                    'Tìm Kiếm',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),

                // ── Search bar ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.10)
                                : Colors.white.withOpacity(0.75),
                          ),
                        ),
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: _onSearch,
                          style: TextStyle(color: textPrimary, fontSize: 15),
                          cursorColor: accent,
                          decoration: InputDecoration(
                            hintText: 'Tên bài, nghệ sĩ, album...',
                            hintStyle: TextStyle(
                                color: textSecondary.withOpacity(0.6),
                                fontSize: 15),
                            prefixIcon:
                                Icon(Icons.search_rounded, color: textSecondary),
                            suffixIcon: _query.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      _searchCtrl.clear();
                                      _onSearch('');
                                    },
                                    child: Icon(Icons.close_rounded,
                                        color: textSecondary),
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Label ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Text(
                    _query.isEmpty ? 'TẤT CẢ BÀI HÁT' : 'KẾT QUẢ (${_results.length})',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: textSecondary,
                    ),
                  ),
                ),

                // ── Results ──
                Expanded(
                  child: _results.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.music_off_rounded,
                                  size: 48, color: textSecondary.withOpacity(0.4)),
                              const SizedBox(height: 12),
                              Text(
                                'Không tìm thấy kết quả',
                                style: TextStyle(
                                    color: textSecondary, fontSize: 15),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                          itemCount: _results.length,
                          itemBuilder: (ctx, i) {
                            final song = _results[i];
                            return GestureDetector(
                              onTap: () {
                                AudioFeedback.playClick();
                                context.push('/now-playing');
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white.withOpacity(0.08)
                                        : Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: song.image,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            song.title,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: textPrimary,
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
                                    Text(
                                      song.duration,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: textSecondary.withOpacity(0.6),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Icons.play_arrow_rounded,
                                        size: 20, color: accent.withOpacity(0.7)),
                                  ],
                                ),
                              ),
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
