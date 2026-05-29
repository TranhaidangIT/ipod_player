class Album {
  final int id;
  final String title;
  final String artist;
  final String image;
  final String duration;

  Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.image,
    required this.duration,
  });
}

class Song {
  final int id;
  final String title;
  final String artist;
  final String album;
  final String image;
  final String duration;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.image,
    required this.duration,
  });
}

// Sample Data
final List<Album> sampleAlbums = [
  Album(
    id: 1,
    title: "Bản Giao Hưởng Số 9",
    artist: "Ludwig van Beethoven",
    image: "https://images.unsplash.com/photo-1672073314527-cd2d83182992?w=400",
    duration: "74:23",
  ),
  Album(
    id: 2,
    title: "Tổ Khúc Cello",
    artist: "Johann Sebastian Bach",
    image: "https://images.unsplash.com/photo-1619468654328-5fefe028d42b?w=400",
    duration: "82:15",
  ),
  Album(
    id: 3,
    title: "Requiem Thứ Điệu",
    artist: "Wolfgang Amadeus Mozart",
    image: "https://images.unsplash.com/photo-1585838017777-5003198884b5?w=400",
    duration: "56:32",
  ),
  Album(
    id: 4,
    title: "Bốn Mùa",
    artist: "Antonio Vivaldi",
    image: "https://images.unsplash.com/photo-1619468654256-1b3be59881df?w=400",
    duration: "42:18",
  ),
  Album(
    id: 5,
    title: "Dạ Khúc",
    artist: "Frédéric Chopin",
    image: "https://images.unsplash.com/photo-1695510864104-242007d8b5b1?w=400",
    duration: "63:45",
  ),
  Album(
    id: 6,
    title: "Giao Hưởng Số 6",
    artist: "Pyotr Ilyich Tchaikovsky",
    image: "https://images.unsplash.com/photo-1559121060-255b8b1adc74?w=400",
    duration: "47:28",
  ),
  Album(
    id: 7,
    title: "Ánh Trăng",
    artist: "Claude Debussy",
    image: "https://images.unsplash.com/photo-1559121060-686a11356a87?w=400",
    duration: "38:52",
  ),
  Album(
    id: 8,
    title: "Concerto Piano Số 2",
    artist: "Sergei Rachmaninoff",
    image: "https://images.unsplash.com/photo-1559120817-9174e40b69a9?w=400",
    duration: "51:14",
  ),
];

final List<Song> sampleSongs = [
  Song(
    id: 1,
    title: "Giao Hưởng Số 9",
    artist: "Ludwig van Beethoven",
    album: "Beethoven Kiệt Tác",
    image: "https://images.unsplash.com/photo-1672073314527-cd2d83182992?w=500",
    duration: "4:23",
  ),
  Song(
    id: 2,
    title: "Tổ Khúc Cello Số 1",
    artist: "Johann Sebastian Bach",
    album: "Tổ Khúc Cello Bach",
    image: "https://images.unsplash.com/photo-1619468654328-5fefe028d42b?w=500",
    duration: "5:15",
  ),
  Song(
    id: 3,
    title: "Requiem Thứ Điệu",
    artist: "Wolfgang Amadeus Mozart",
    album: "Mozart Requiem",
    image: "https://images.unsplash.com/photo-1585838017777-5003198884b5?w=500",
    duration: "3:32",
  ),
  Song(
    id: 4,
    title: "Mùa Xuân - Allegro",
    artist: "Antonio Vivaldi",
    album: "Bốn Mùa",
    image: "https://images.unsplash.com/photo-1619468654256-1b3be59881df?w=500",
    duration: "3:18",
  ),
  Song(
    id: 5,
    title: "Dạ Khúc Op. 9 Số 2",
    artist: "Frédéric Chopin",
    album: "Dạ Khúc Chopin",
    image: "https://images.unsplash.com/photo-1695510864104-242007d8b5b1?w=500",
    duration: "4:45",
  ),
  Song(
    id: 6,
    title: "Giao Hưởng Số 6",
    artist: "Pyotr Ilyich Tchaikovsky",
    album: "Pathétique",
    image: "https://images.unsplash.com/photo-1559121060-255b8b1adc74?w=500",
    duration: "5:28",
  ),
  Song(
    id: 7,
    title: "Ánh Trăng",
    artist: "Claude Debussy",
    album: "Suite Bergamasque",
    image: "https://images.unsplash.com/photo-1559121060-686a11356a87?w=500",
    duration: "4:52",
  ),
  Song(
    id: 8,
    title: "Concerto Piano Số 2",
    artist: "Sergei Rachmaninoff",
    album: "Concerto Rachmaninoff",
    image: "https://images.unsplash.com/photo-1559120817-9174e40b69a9?w=500",
    duration: "6:14",
  ),
];
