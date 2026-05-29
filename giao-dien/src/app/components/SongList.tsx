import { useState, useEffect, useRef } from 'react';
import { motion } from 'motion/react';
import { Upload, Play, ArrowLeft } from 'lucide-react';
import { useNavigate } from 'react-router';
import { getAllSongs, saveSong } from '../utils/indexedDb';
import { Song } from '../types';
import { useAudioPlayer } from './AudioPlayerContext';

export function SongList() {
  const [songs, setSongs] = useState<Song[]>([]);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const navigate = useNavigate();
  const { playSong } = useAudioPlayer();

  useEffect(() => {
    loadSongs();
  }, []);

  const loadSongs = async () => {
    const loadedSongs = await getAllSongs();
    setSongs(loadedSongs.filter(s => s.isLocal));
  };

  const handleFileUpload = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const files = event.target.files;
    if (!files) return;

    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      const newSong: Song = {
        id: `local-${Date.now()}-${i}`,
        title: file.name.replace(/\.[^/.]+$/, ""),
        artist: "Local Artist",
        album: "Local Files",
        image: "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=200",
        duration: "Unknown",
        audioBlob: file,
        isLocal: true,
      };
      await saveSong(newSong);
    }
    loadSongs();
  };

  return (
    <div className="size-full flex flex-col bg-[#050505] text-white">
      <div className="p-6 flex items-center justify-between border-b border-white/10">
        <button onClick={() => navigate(-1)} className="p-2 text-white/70 hover:text-white transition-colors">
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h1 className="text-sm font-light tracking-widest uppercase">Nhạc Cục Bộ</h1>
        <button onClick={() => fileInputRef.current?.click()} className="p-2 text-white hover:scale-110 transition-transform">
          <Upload className="w-6 h-6" />
        </button>
        <input 
          type="file" 
          ref={fileInputRef} 
          className="hidden" 
          multiple 
          accept="audio/*" 
          onChange={handleFileUpload} 
        />
      </div>

      <div className="flex-1 overflow-y-auto p-4 scrollbar-hide">
        {songs.length === 0 ? (
          <div className="h-full flex flex-col items-center justify-center text-white/40 gap-4">
            <Upload className="w-12 h-12 opacity-50" />
            <p className="font-light tracking-wide">Chưa có nhạc cục bộ</p>
            <button 
              onClick={() => fileInputRef.current?.click()}
              className="px-6 py-2 rounded-full border border-white/20 hover:bg-white/10 transition-colors"
            >
              Nhập Nhạc MP3
            </button>
          </div>
        ) : (
          <div className="flex flex-col gap-4">
            {songs.map((song, index) => (
              <motion.div
                key={song.id}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.05 }}
                className="group relative flex items-center gap-4 p-4 rounded-xl bg-white/5 border border-white/10 hover:bg-white/10 hover:border-white/20 transition-all cursor-pointer hover:-translate-y-1 hover:shadow-2xl"
                onClick={() => playSong(song, songs)}
              >
                <div className="w-14 h-14 rounded-md overflow-hidden bg-black/50">
                  <img src={song.image} className="w-full h-full object-cover opacity-80" alt="" />
                </div>
                <div className="flex flex-col flex-1">
                  <span className="text-white/90 font-light tracking-wide truncate">{song.title}</span>
                  <span className="text-white/50 text-sm tracking-wider truncate">{song.artist}</span>
                </div>
                <div className="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                  <Play className="w-4 h-4 fill-white" />
                </div>
              </motion.div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
