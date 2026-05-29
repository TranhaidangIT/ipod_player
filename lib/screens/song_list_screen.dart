import 'package:flutter/material.dart';
import '../models/dummy_data.dart';
import '../theme/app_theme.dart';
import 'now_playing_screen.dart';

class SongListScreen extends StatelessWidget {
  const SongListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final allSongs = DummyData.albums.expand((album) {
      return DummyData.getSongsForAlbum(album['title']!, album['artist']!, album['image']!);
    }).toList();

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverSafeArea(
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Text(
                  'Cục Bộ',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 160),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final song = allSongs[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(song['image']!, width: 48, height: 48, fit: BoxFit.cover),
                    ),
                    title: Text(
                      song['title']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    subtitle: Text(
                      song['artist']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: subColor, fontSize: 12),
                    ),
                    trailing: Text(
                      song['duration']!,
                      style: TextStyle(color: subColor, fontSize: 12),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => NowPlayingScreen(song: song)));
                    },
                  );
                },
                childCount: allSongs.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
