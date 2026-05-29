import { Reorder } from 'motion/react';
import { useAudioPlayer } from './AudioPlayerContext';
import { ArrowLeft, GripVertical } from 'lucide-react';
import { useNavigate } from 'react-router';
import { useState, useEffect } from 'react';
import { Song } from '../types';

export function Queue() {
  const { queue, playSong, currentSong } = useAudioPlayer();
  const navigate = useNavigate();
  const [items, setItems] = useState<Song[]>(queue);

  useEffect(() => {
    setItems(queue);
  }, [queue]);

  const handleReorder = (newOrder: Song[]) => {
    setItems(newOrder);
    // Ideally update context queue here, but context playSong currently overrides queue.
    // We would need a setQueue method in context. For now, this is a visual demo.
  };

  return (
    <div className="size-full flex flex-col bg-[#050505] text-white">
      <div className="p-6 flex items-center justify-between border-b border-white/10">
        <button onClick={() => navigate(-1)} className="p-2 text-white/70 hover:text-white transition-colors">
          <ArrowLeft className="w-6 h-6" />
        </button>
        <h1 className="text-sm font-light tracking-widest uppercase">Danh Sách Phát</h1>
        <div className="w-10" />
      </div>

      <div className="flex-1 overflow-y-auto p-4 scrollbar-hide">
        <Reorder.Group axis="y" values={items} onReorder={handleReorder} className="flex flex-col gap-2">
          {items.map((song) => (
            <Reorder.Item 
              key={song.id} 
              value={song}
              className={`flex items-center justify-between p-4 rounded-xl bg-white/5 backdrop-blur-md border ${
                currentSong?.id === song.id ? 'border-white/40 shadow-[0_0_15px_rgba(255,255,255,0.1)]' : 'border-white/5'
              }`}
            >
              <div 
                className="flex items-center gap-4 flex-1 cursor-pointer"
                onClick={() => playSong(song, items)}
              >
                <div className="w-12 h-12 rounded-md overflow-hidden">
                  <img src={song.image || 'https://images.unsplash.com/photo-1619468654328-5fefe028d42b?w=200'} className="w-full h-full object-cover" alt="" />
                </div>
                <div className="flex flex-col">
                  <span className={`font-light tracking-wide ${currentSong?.id === song.id ? 'text-white' : 'text-white/80'}`}>
                    {song.title}
                  </span>
                  <span className="text-white/40 text-xs tracking-wider">{song.artist}</span>
                </div>
              </div>
              <div className="px-2 text-white/20 cursor-grab active:cursor-grabbing">
                <GripVertical className="w-5 h-5" />
              </div>
            </Reorder.Item>
          ))}
        </Reorder.Group>
      </div>
    </div>
  );
}
