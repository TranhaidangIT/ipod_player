import { useParams, useNavigate } from 'react-router';
import { motion } from 'motion/react';
import { Play, ArrowLeft } from 'lucide-react';
import { DUMMY_ALBUMS } from './CoverFlow';
import { useAudioPlayer } from './AudioPlayerContext';
import { Song } from '../types';

// Dummy songs for an album
const getDummySongsForAlbum = (albumTitle: string, artist: string, image: string): Song[] => {
  return Array.from({ length: 12 }).map((_, i) => ({
    id: `song-${albumTitle}-${i}`,
    title: `Track ${i + 1}`,
    artist: artist,
    album: albumTitle,
    image: image,
    duration: '3:45'
  }));
};

export function AlbumDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const { playSong } = useAudioPlayer();
  
  const album = DUMMY_ALBUMS.find(a => a.id === id) || DUMMY_ALBUMS[0];
  const songs = getDummySongsForAlbum(album.title, album.artist, album.image);

  return (
    <div className="size-full flex flex-col bg-[#050505] text-white overflow-hidden relative">
      {/* Blurred Background */}
      <div className="absolute inset-0 z-0 overflow-hidden">
        <div 
          className="absolute inset-0 bg-cover bg-center opacity-20 blur-[80px]"
          style={{ backgroundImage: `url(${album.image})` }}
        />
        <div className="absolute inset-0 bg-gradient-to-t from-[#050505] via-[#050505]/80 to-transparent" />
      </div>

      <div className="relative z-10 p-6 flex items-center justify-between">
        <button onClick={() => navigate(-1)} className="p-2 text-white/70 hover:text-white transition-colors">
          <ArrowLeft className="w-6 h-6" />
        </button>
      </div>

      <div className="relative z-10 flex-1 flex flex-col items-center overflow-y-auto pb-24 px-4 scrollbar-hide">
        {/* Large Cover Art */}
        <motion.div 
          initial={{ opacity: 0, y: 20, scale: 0.9 }}
          animate={{ opacity: 1, y: 0, scale: 1 }}
          className="w-64 h-64 sm:w-80 sm:h-80 rounded-sm shadow-2xl mb-8 flex-shrink-0"
        >
          <img src={album.image} alt={album.title} className="w-full h-full object-cover rounded-sm" />
        </motion.div>

        <motion.h1 
          initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.2 }}
          className="text-2xl font-light tracking-wide mb-1 text-center"
        >
          {album.title}
        </motion.h1>
        <motion.p 
          initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.3 }}
          className="text-white/50 text-sm tracking-widest uppercase mb-8 text-center"
        >
          {album.artist}
        </motion.p>

        {/* Play Button */}
        <motion.button 
          initial={{ opacity: 0, scale: 0.8 }} animate={{ opacity: 1, scale: 1 }} transition={{ delay: 0.4 }}
          onClick={() => {
            playSong(songs[0], songs);
            navigate('/now-playing');
          }}
          className="mb-10 px-8 py-3 rounded-full bg-white text-black font-medium tracking-wide flex items-center gap-2 hover:scale-105 transition-transform"
        >
          <Play className="w-5 h-5 fill-black" /> Phát Album
        </motion.button>

        {/* Song List */}
        <div className="w-full max-w-2xl relative">
          {/* Top and Bottom Fading Edges */}
          <div className="absolute top-0 left-0 right-0 h-8 bg-gradient-to-b from-[#050505] to-transparent z-10 pointer-events-none" />
          <div className="absolute bottom-0 left-0 right-0 h-16 bg-gradient-to-t from-[#050505] to-transparent z-10 pointer-events-none" />

          <div className="flex flex-col gap-1 pb-16">
            {songs.map((song, idx) => (
              <motion.div 
                key={song.id}
                initial={{ opacity: 0, x: -10 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.1 + idx * 0.05 }}
                onClick={() => {
                  playSong(song, songs);
                  navigate('/now-playing');
                }}
                className="group flex items-center justify-between p-4 rounded-md hover:bg-white/10 transition-colors cursor-pointer"
              >
                <div className="flex items-center gap-4">
                  <span className="text-white/30 text-sm w-6 text-right">{idx + 1}</span>
                  <div className="flex flex-col">
                    <span className="text-white/90 font-light tracking-wide group-hover:text-white transition-colors">{song.title}</span>
                  </div>
                </div>
                <span className="text-white/30 text-sm">{song.duration}</span>
              </motion.div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
