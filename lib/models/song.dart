class SongModel {
  final int id;
  final String title;
  final String artist;
  final String album;
  final String image;
  final String uri; // Streaming URL
  final String duration;

  const SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.image,
    required this.uri,
    required this.duration,
  });
}

// Public domain classical music from various sources
// All tracks are royalty-free / public domain
final List<SongModel> songLibrary = [
  SongModel(
    id: 1,
    title: 'Moonlight Sonata (Adagio)',
    artist: 'Ludwig van Beethoven',
    album: 'Piano Sonata No. 14',
    image: 'https://wsrv.nl/?url=images.unsplash.com/photo-1579353977828-2a4eab540b9a?w=500',
    uri: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    duration: '5:51',
  ),
  SongModel(
    id: 2,
    title: 'Cello Suite No. 1',
    artist: 'Johann Sebastian Bach',
    album: 'Six Suites for Cello',
    image: 'https://wsrv.nl/?url=images.unsplash.com/photo-1619468654328-5fefe028d42b?w=500',
    uri: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    duration: '2:20',
  ),
  SongModel(
    id: 3,
    title: 'Requiem in D minor',
    artist: 'Wolfgang Amadeus Mozart',
    album: 'Requiem K. 626',
    image: 'https://wsrv.nl/?url=images.unsplash.com/photo-1585838017777-5003198884b5?w=500',
    uri: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    duration: '4:32',
  ),
  SongModel(
    id: 4,
    title: 'The Four Seasons — Spring',
    artist: 'Antonio Vivaldi',
    album: 'Le Quattro Stagioni',
    image: 'https://wsrv.nl/?url=images.unsplash.com/photo-1619468654256-1b3be59881df?w=500',
    uri: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    duration: '3:41',
  ),
  SongModel(
    id: 5,
    title: 'Nocturne Op. 9 No. 2',
    artist: 'Frédéric Chopin',
    album: 'Nocturnes',
    image: 'https://wsrv.nl/?url=images.unsplash.com/photo-1695510864104-242007d8b5b1?w=500',
    uri: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
    duration: '4:10',
  ),
  SongModel(
    id: 6,
    title: 'Symphony No. 6 — Pathétique',
    artist: 'Pyotr Ilyich Tchaikovsky',
    album: 'Symphony No. 6',
    image: 'https://wsrv.nl/?url=images.unsplash.com/photo-1559121060-255b8b1adc74?w=500',
    uri: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
    duration: '5:28',
  ),
  SongModel(
    id: 7,
    title: 'Clair de Lune',
    artist: 'Claude Debussy',
    album: 'Suite Bergamasque',
    image: 'https://wsrv.nl/?url=images.unsplash.com/photo-1559121060-686a11356a87?w=500',
    uri: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
    duration: '4:52',
  ),
  SongModel(
    id: 8,
    title: 'Piano Concerto No. 2',
    artist: 'Sergei Rachmaninoff',
    album: 'Piano Concerto No. 2',
    image: 'https://wsrv.nl/?url=images.unsplash.com/photo-1559120817-9174e40b69a9?w=500',
    uri: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
    duration: '6:14',
  ),
  SongModel(
    id: 9,
    title: 'Symphony No. 9 — Ode to Joy',
    artist: 'Ludwig van Beethoven',
    album: 'Symphony No. 9',
    image: 'https://wsrv.nl/?url=images.unsplash.com/photo-1672073314527-cd2d83182992?w=500',
    uri: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
    duration: '4:23',
  ),
  SongModel(
    id: 10,
    title: 'Gymnopédie No. 1',
    artist: 'Erik Satie',
    album: 'Trois Gymnopédies',
    image: 'https://wsrv.nl/?url=images.unsplash.com/photo-1462965326201-d02e4f455804?w=500',
    uri: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3',
    duration: '3:00',
  ),
];
