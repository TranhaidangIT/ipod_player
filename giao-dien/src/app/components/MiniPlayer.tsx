import { motion } from 'motion/react';
import { Play, Pause, ListMusic } from 'lucide-react';
import { useAudioPlayer } from './AudioPlayerContext';
import { useNavigate, useLocation } from 'react-router';

export function MiniPlayer() {
  const { currentSong, isPlaying, togglePlay } = useAudioPlayer();
  const navigate = useNavigate();
  const location = useLocation();

  if (!currentSong || location.pathname === '/now-playing') {
    return null; // Don't show if nothing playing or already in Now Playing
  }

  return (
    <motion.div
      initial={{ y: 100, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      exit={{ y: 100, opacity: 0 }}
      transition={{ type: 'spring', damping: 25, stiffness: 200 }}
      className="fixed bottom-6 left-1/2 -translate-x-1/2 w-[90%] max-w-md bg-white/10 backdrop-blur-xl border border-white/20 rounded-2xl shadow-2xl z-50 flex items-center p-3 gap-4"
    >
      <div 
        className="w-12 h-12 rounded-md overflow-hidden cursor-pointer shrink-0"
        onClick={() => navigate('/now-playing')}
      >
        <img src={currentSong.image} alt={currentSong.title} className="w-full h-full object-cover" />
      </div>

      <div 
        className="flex-1 min-w-0 cursor-pointer"
        onClick={() => navigate('/now-playing')}
      >
        <h4 className="text-white font-light tracking-wide truncate text-sm">{currentSong.title}</h4>
        <p className="text-white/50 text-xs tracking-wider truncate">{currentSong.artist}</p>
      </div>

      <div className="flex items-center gap-2 pr-2 shrink-0">
        <button 
          onClick={(e) => { e.stopPropagation(); togglePlay(); }}
          className="p-2 rounded-full hover:bg-white/10 transition-colors"
        >
          {isPlaying ? (
            <Pause className="w-5 h-5 text-white fill-white" />
          ) : (
            <Play className="w-5 h-5 text-white fill-white ml-0.5" />
          )}
        </button>
        <button 
          onClick={(e) => { e.stopPropagation(); navigate('/queue'); }}
          className="p-2 rounded-full hover:bg-white/10 transition-colors"
        >
          <ListMusic className="w-5 h-5 text-white" />
        </button>
      </div>
    </motion.div>
  );
}
