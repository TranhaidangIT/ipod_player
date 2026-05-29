import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> results = [];

  final List<Map<String, dynamic>> allResults = [
    {
      'type': 'song',
      'title': 'Giao Hưởng Số 9',
      'subtitle': 'Ludwig van Beethoven',
      'image': 'https://images.unsplash.com/photo-1672073314527-cd2d83182992?w=100',
    },
    {
      'type': 'album',
      'title': 'Bốn Mùa',
      'subtitle': 'Antonio Vivaldi',
      'image': 'https://images.unsplash.com/photo-1619468654256-1b3be59881df?w=100',
    },
    {
      'type': 'artist',
      'title': 'Frédéric Chopin',
      'subtitle': '24 bài hát',
      'image': 'https://images.unsplash.com/photo-1695510864104-242007d8b5b1?w=100',
    },
    {
      'type': 'song',
      'title': 'Ánh Trăng',
      'subtitle': 'Claude Debussy',
      'image': 'https://images.unsplash.com/photo-1559121060-686a11356a87?w=100',
    },
  ];

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        results = [];
      } else {
        results = allResults.where((item) {
          final title = (item['title'] as String).toLowerCase();
          final subtitle = (item['subtitle'] as String).toLowerCase();
          final searchLower = query.toLowerCase();
          return title.contains(searchLower) || subtitle.contains(searchLower);
        }).toList();
      }
    });
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'song':
        return Icons.music_note_outlined;
      case 'album':
        return Icons.album_outlined;
      case 'artist':
        return Icons.person_outline;
      default:
        return Icons.music_note_outlined;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'song':
        return 'Bài hát';
      case 'album':
        return 'Album';
      case 'artist':
        return 'Nghệ sĩ';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [const Color(0xFF353841), const Color(0xFF2A2D33)]
                      : [const Color(0xFFF5F5F7), const Color(0xFFE8EAED)],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1),
                  ),
                ),
              ),
              child: Text(
                'Tìm Kiếm',
                style: theme.textTheme.displayMedium?.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),

            // Search Input
            Padding(
              padding: const EdgeInsets.all(24),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Tìm bài hát, album, nghệ sĩ...',
                  hintStyle: theme.textTheme.bodyMedium,
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? const Color(0xFF6E7681) : const Color(0xFF8A9199),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                          color: isDark ? const Color(0xFF6E7681) : const Color(0xFF8A9199),
                        )
                      : null,
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white.withOpacity(0.6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white.withOpacity(0.6),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white.withOpacity(0.6),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? const Color(0xFF9BA3AD) : const Color(0xFF5E6772),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),

            // Results
            Expanded(
              child: _searchController.text.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 64,
                            color: isDark ? const Color(0xFF353841) : const Color(0xFFD2D6DC),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tìm kiếm nhạc yêu thích của bạn',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : results.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: isDark ? const Color(0xFF353841) : const Color(0xFFD2D6DC),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Không tìm thấy kết quả',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final result = results[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(0.05)
                                    : Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.white.withOpacity(0.6),
                                ),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: result['image'],
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          result['title'],
                                          style: theme.textTheme.bodyLarge,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              _getTypeIcon(result['type']),
                                              size: 14,
                                              color: isDark ? const Color(0xFF6E7681) : const Color(0xFF8A9199),
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                '${_getTypeLabel(result['type'])} • ${result['subtitle']}',
                                                style: theme.textTheme.bodySmall,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
