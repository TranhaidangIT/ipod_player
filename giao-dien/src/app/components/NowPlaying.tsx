import { useState, useRef } from 'react';
import { motion } from 'motion/react';
import { Play, Pause, SkipBack, SkipForward, Menu } from 'lucide-react';
import { useAudioPlayer } from './AudioPlayerContext';
import { useNavigate } from 'react-router';

export function NowPlaying() {
  const { currentSong, isPlaying, togglePlay, next, prev, progress, currentTime, duration, seek } = useAudioPlayer();
  const navigate = useNavigate();
  const containerRef = useRef<HTMLDivElement>(null);
  const [mousePos, setMousePos] = useState({ x: 0, y: 0 });

  const formatTime = (time: number) => {
    if (!time || isNaN(time)) return "0:00";
    const mins = Math.floor(time / 60);
    const secs = Math.floor(time % 60);
    return `${mins}:${secs < 10 ? '0' : ''}${secs}`;
  };

  const handleMouseMove = (e: React.MouseEvent) => {
    if (!containerRef.current) return;
    const rect = containerRef.current.getBoundingClientRect();
    const x = (e.clientX - rect.left) / rect.width - 0.5;
    const y = (e.clientY - rect.top) / rect.height - 0.5;
    setMousePos({ x, y });
  };

  if (!currentSong) {
    return (
      <div className="size-full flex flex-col items-center justify-center bg-[#050505] text-white/50">
        <p>No song playing</p>
        <button onClick={() => navigate(-1)} className="mt-4 px-4 py-2 bg-white/10 rounded-full">Back</button>
      </div>
    );
  }

  const imageUrl = currentSong.image || 'https://images.unsplash.com/photo-1619468654328-5fefe028d42b?w=500';

  return (
    <div 
      className="size-full flex flex-col items-center justify-center overflow-hidden bg-[#050505] relative"
      onMouseMove={handleMouseMove}
      ref={containerRef}
    >
      {/* Dynamic blurred background */}
      <div className="absolute inset-0 z-0 overflow-hidden">
        <div 
          className="absolute inset-0 bg-cover bg-center opacity-30 blur-[100px] scale-150 transition-all duration-1000"
          style={{ backgroundImage: `url(${imageUrl})` }}
        />
        <div className="absolute inset-0 bg-black/40" />
      </div>

      {/* Top Bar */}
      <div className="absolute top-0 left-0 right-0 p-6 flex justify-between z-20">
        <button onClick={() => navigate(-1)} className="p-2 rounded-full hover:bg-white/10 transition-colors">
          <Menu className="w-6 h-6 text-white/70" />
        </button>
      </div>

      {/* Album Art with Parallax */}
      <motion.div 
        className="relative z-10 w-72 h-72 sm:w-96 sm:h-96 rounded-xl overflow-hidden shadow-2xl"
        animate={{
          rotateX: -mousePos.y * 20,
          rotateY: mousePos.x * 20,
          scale: isPlaying ? 1.05 : 1,
        }}
        transition={{ type: 'spring', damping: 30, stiffness: 200, mass: 0.5 }}
        style={{ perspective: 1000 }}
      >
        <img src={imageUrl} alt={currentSong.title} className="w-full h-full object-cover" />
        
        {/* Soft reflection overlay */}
        <div className="absolute inset-0 bg-gradient-to-tr from-white/5 to-transparent pointer-events-none" />
      </motion.div>

      {/* Info & Controls */}
      <motion.div 
        className="relative z-10 mt-12 w-full max-w-md px-8 flex flex-col items-center"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
      >
        <h2 className="text-3xl font-light text-white tracking-widest text-center mb-2 truncate w-full" style={{ fontFamily: '"Helvetica Neue", Helvetica, sans-serif' }}>
          {currentSong.title}
        </h2>
        <p className="text-sm font-light text-white/50 tracking-wider text-center uppercase mb-8">
          {currentSong.artist}
        </p>

        {/* Minimal Progress Bar */}
        <div className="w-full flex flex-col gap-2">
          <div 
            className="h-1 bg-white/10 rounded-full cursor-pointer relative overflow-hidden group"
            onClick={(e) => {
              const rect = e.currentTarget.getBoundingClientRect();
              const percent = ((e.clientX - rect.left) / rect.width) * 100;
              seek(percent);
            }}
          >
            <motion.div 
              className="absolute top-0 left-0 h-full bg-white/80 shadow-[0_0_10px_rgba(255,255,255,0.5)]"
              style={{ width: `${progress}%` }}
            />
          </div>
          <div className="flex justify-between text-xs text-white/40 tracking-wider">
            <span>{formatTime(currentTime)}</span>
            <span>-{formatTime(duration - currentTime)}</span>
          </div>
        </div>

        {/* Controls */}
        <div className="mt-8 flex items-center justify-center gap-10">
          <button onClick={prev} className="p-2 hover:opacity-70 transition-opacity">
            <SkipBack className="w-8 h-8 text-white" strokeWidth={1.5} />
          </button>
          
          <button onClick={togglePlay} className="p-4 rounded-full bg-white/10 hover:bg-white/20 transition-colors">
            {isPlaying ? (
              <Pause className="w-10 h-10 text-white fill-white" />
            ) : (
              <Play className="w-10 h-10 text-white fill-white ml-1" />
            )}
          </button>
          
          <button onClick={next} className="p-2 hover:opacity-70 transition-opacity">
            <SkipForward className="w-8 h-8 text-white" strokeWidth={1.5} />
          </button>
        </div>
      </motion.div>
    </div>
  );
}
