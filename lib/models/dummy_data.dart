class DummyData {
  static const List<Map<String, String>> albums = [
    {
      "id": "1",
      "title": "Beethoven Kiệt Tác",
      "artist": "Ludwig van Beethoven",
      "image": "https://images.unsplash.com/photo-1672073314527-cd2d83182992?w=500"
    },
    {
      "id": "2",
      "title": "Tổ Khúc Cello Bach",
      "artist": "Johann Sebastian Bach",
      "image": "https://images.unsplash.com/photo-1619468654328-5fefe028d42b?w=500"
    },
    {
      "id": "3",
      "title": "Mozart Requiem",
      "artist": "Wolfgang Amadeus Mozart",
      "image": "https://images.unsplash.com/photo-1585838017777-5003198884b5?w=500"
    },
    {
      "id": "4",
      "title": "Bốn Mùa",
      "artist": "Antonio Vivaldi",
      "image": "https://images.unsplash.com/photo-1619468654256-1b3be59881df?w=500"
    },
    {
      "id": "5",
      "title": "Dạ Khúc Chopin",
      "artist": "Frédéric Chopin",
      "image": "https://images.unsplash.com/photo-1695510864104-242007d8b5b1?w=500"
    },
    {
      "id": "6",
      "title": "Pathétique",
      "artist": "Pyotr Ilyich Tchaikovsky",
      "image": "https://images.unsplash.com/photo-1559121060-255b8b1adc74?w=500"
    }
  ];

  static List<Map<String, String>> getSongsForAlbum(String albumName, String artist, String image) {
    return List.generate(12, (index) {
      return {
        "id": "song-$albumName-$index",
        "title": "Track ${index + 1} - $albumName",
        "artist": artist,
        "album": albumName,
        "image": image,
        "duration": "${3 + (index % 3)}:${(15 + index * 7) % 60}".padRight(4, '0').substring(0, 4),
      };
    });
  }
}
