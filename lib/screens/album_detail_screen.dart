import 'package:flutter/material.dart';
import '../models/dummy_data.dart';
import 'now_playing_screen.dart';

class AlbumDetailScreen extends StatelessWidget {
  final int albumId;
  final String albumName;
  final String artistName;
  final String imageUrl;

  const AlbumDetailScreen({
    Key? key,
    required this.albumId,
    required this.albumName,
    required this.artistName,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final albumSongs = DummyData.getSongsForAlbum(albumName, artistName, imageUrl);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(albumName, style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                          Colors.black,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        albumName,
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        artistName,
                        style: const TextStyle(color: Colors.white54, fontSize: 14, letterSpacing: 1.5),
                      ),
                    ],
                  ),
                  const Spacer(),
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => NowPlayingScreen(song: albumSongs.first)));
                    },
                    child: const Icon(Icons.play_arrow, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = albumSongs[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  leading: Text(
                    "\${index + 1}",
                    style: const TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                  title: Text(
                    song['title']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                  ),
                  trailing: Text(
                    song['duration']!,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => NowPlayingScreen(song: song)));
                  },
                );
              },
              childCount: albumSongs.length,
            ),
          ),
        ],
      ),
    );
  }
}
