import { useState } from "react";
import { motion } from "motion/react";
import { Play, Pause, SkipBack, SkipForward, Volume2, Heart, Repeat, Shuffle, List, X } from "lucide-react";
import { useNavigate } from "react-router";

interface Song {
  title: string;
  artist: string;
  album: string;
  image: string;
  duration: string;
}

const currentSong: Song = {
  title: "Giao Hưởng Số 9",
  artist: "Ludwig van Beethoven",
  album: "Beethoven Kiệt Tác",
  image: "https://images.unsplash.com/photo-1672073314527-cd2d83182992?w=600",
  duration: "4:23"
};

export function NowPlaying() {
  const navigate = useNavigate();
  const [isPlaying, setIsPlaying] = useState(true);
  const [isFavorite, setIsFavorite] = useState(false);
  const [isRepeat, setIsRepeat] = useState(false);
  const [isShuffle, setIsShuffle] = useState(false);
  const [volume, setVolume] = useState(75);
  const [progress, setProgress] = useState(45);

  return (
    <div className="size-full flex items-center justify-center overflow-hidden">
      <div className="w-full max-w-md h-full flex flex-col bg-gradient-to-b from-[#e8eaed] to-[#d2d6dc] dark:from-[#2a2d33] dark:to-[#1a1d23] shadow-2xl relative">

        {/* Close Button */}
        <div className="absolute top-6 right-6 z-10">
          <motion.button
            whileHover={{ scale: 1.1 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => navigate(-1)}
            className="p-2 rounded-full bg-white/40 dark:bg-black/30 backdrop-blur-sm shadow-lg hover:bg-white/60 dark:hover:bg-black/50 transition-colors"
          >
            <X className="w-5 h-5 text-[#5e6772] dark:text-[#9ba3ad]" />
          </motion.button>
        </div>

        {/* Main Content */}
        <div className="flex-1 flex flex-col items-center justify-center px-8 py-12">

          {/* Album Artwork */}
          <motion.div
            initial={{ opacity: 0, scale: 0.9, y: 20 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            transition={{ type: "spring", damping: 20, stiffness: 200 }}
            className="relative mb-8"
          >
            <motion.div
              animate={{
                rotateY: isPlaying ? [0, 2, 0, -2, 0] : 0,
                rotateX: isPlaying ? [0, -1, 0, 1, 0] : 0,
              }}
              transition={{
                duration: 4,
                repeat: Infinity,
                ease: "easeInOut"
              }}
              className="w-72 h-72 rounded-3xl overflow-hidden shadow-[0_32px_64px_rgba(0,0,0,0.25)] border-8 border-white/50 dark:border-white/10"
              style={{ transformStyle: "preserve-3d" }}
            >
              <img
                src={currentSong.image}
                alt={currentSong.title}
                className="w-full h-full object-cover"
              />

              {/* Glass reflection effect */}
              <div className="absolute inset-0 bg-gradient-to-br from-white/20 via-transparent to-black/20 pointer-events-none" />
              <div className="absolute top-0 left-0 w-full h-1/3 bg-gradient-to-b from-white/30 to-transparent pointer-events-none" />
            </motion.div>

            {/* Reflection underneath */}
            <div className="absolute -bottom-8 left-1/2 -translate-x-1/2 w-full h-16 bg-gradient-to-b from-black/10 to-transparent dark:from-white/5 blur-2xl rounded-full" />
          </motion.div>

          {/* Song Info */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2, type: "spring", damping: 20, stiffness: 200 }}
            className="text-center mb-6 w-full"
          >
            <h1 className="text-[#1a1d23] dark:text-[#e8eaed] mb-2 truncate px-4">
              {currentSong.title}
            </h1>
            <p className="text-[#5e6772] dark:text-[#9ba3ad] truncate px-4">
              {currentSong.artist}
            </p>
            <p className="text-sm text-[#8a9199] dark:text-[#6e7681] mt-1">
              {currentSong.album}
            </p>
          </motion.div>

          {/* Progress Bar */}
          <div className="w-full mb-2">
            <div className="relative h-2 bg-[#d2d6dc] dark:bg-[#1a1d23] rounded-full overflow-hidden shadow-inner">
              <motion.div
                className="absolute top-0 left-0 h-full bg-gradient-to-r from-[#5e6772] to-[#8a9199] dark:from-[#7a8490] dark:to-[#9ba3ad] rounded-full"
                style={{ width: `${progress}%` }}
              />
              <motion.div
                className="absolute top-1/2 -translate-y-1/2 w-4 h-4 bg-white dark:bg-[#e8eaed] rounded-full shadow-lg border-2 border-[#5e6772] dark:border-[#9ba3ad]"
                style={{ left: `${progress}%`, x: "-50%" }}
                whileHover={{ scale: 1.3 }}
                whileTap={{ scale: 0.9 }}
              />
            </div>
            <div className="flex justify-between mt-2 px-1">
              <span className="text-xs text-[#8a9199] dark:text-[#6e7681]">1:58</span>
              <span className="text-xs text-[#8a9199] dark:text-[#6e7681]">{currentSong.duration}</span>
            </div>
          </div>

          {/* Main Controls */}
          <div className="flex items-center justify-center gap-6 mb-6 mt-4">
            <motion.button
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.95 }}
              className="p-3 rounded-full hover:bg-white/40 dark:hover:bg-white/10 transition-colors"
            >
              <SkipBack className="w-7 h-7 text-[#5e6772] dark:text-[#9ba3ad]" fill="currentColor" />
            </motion.button>

            <motion.button
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              onClick={() => setIsPlaying(!isPlaying)}
              className="p-5 rounded-full bg-gradient-to-b from-[#5e6772] to-[#4a545e] dark:from-[#7a8490] dark:to-[#5e6772] shadow-2xl hover:shadow-3xl transition-all"
            >
              {isPlaying ? (
                <Pause className="w-10 h-10 text-white fill-white" />
              ) : (
                <Play className="w-10 h-10 text-white fill-white ml-1" />
              )}
            </motion.button>

            <motion.button
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.95 }}
              className="p-3 rounded-full hover:bg-white/40 dark:hover:bg-white/10 transition-colors"
            >
              <SkipForward className="w-7 h-7 text-[#5e6772] dark:text-[#9ba3ad]" fill="currentColor" />
            </motion.button>
          </div>

          {/* Secondary Controls */}
          <div className="flex items-center justify-between w-full px-4">
            <div className="flex items-center gap-4">
              <motion.button
                whileHover={{ scale: 1.1 }}
                whileTap={{ scale: 0.95 }}
                onClick={() => setIsShuffle(!isShuffle)}
                className={`p-2 rounded-full transition-all ${
                  isShuffle ? 'bg-[#5e6772]/20 dark:bg-[#9ba3ad]/20' : 'hover:bg-white/40 dark:hover:bg-white/10'
                }`}
              >
                <Shuffle className={`w-5 h-5 ${isShuffle ? 'text-[#5e6772] dark:text-[#9ba3ad]' : 'text-[#8a9199] dark:text-[#6e7681]'}`} />
              </motion.button>

              <motion.button
                whileHover={{ scale: 1.1 }}
                whileTap={{ scale: 0.95 }}
                onClick={() => setIsRepeat(!isRepeat)}
                className={`p-2 rounded-full transition-all ${
                  isRepeat ? 'bg-[#5e6772]/20 dark:bg-[#9ba3ad]/20' : 'hover:bg-white/40 dark:hover:bg-white/10'
                }`}
              >
                <Repeat className={`w-5 h-5 ${isRepeat ? 'text-[#5e6772] dark:text-[#9ba3ad]' : 'text-[#8a9199] dark:text-[#6e7681]'}`} />
              </motion.button>
            </div>

            <div className="flex items-center gap-4">
              <motion.button
                whileHover={{ scale: 1.1 }}
                whileTap={{ scale: 0.95 }}
                onClick={() => setIsFavorite(!isFavorite)}
                className="p-2 rounded-full hover:bg-white/40 dark:hover:bg-white/10 transition-colors"
              >
                <Heart
                  className={`w-5 h-5 transition-colors ${
                    isFavorite
                      ? 'text-red-500 fill-red-500'
                      : 'text-[#8a9199] dark:text-[#6e7681]'
                  }`}
                />
              </motion.button>

              <motion.button
                whileHover={{ scale: 1.1 }}
                whileTap={{ scale: 0.95 }}
                onClick={() => navigate('/queue')}
                className="p-2 rounded-full hover:bg-white/40 dark:hover:bg-white/10 transition-colors"
              >
                <List className="w-5 h-5 text-[#8a9199] dark:text-[#6e7681]" />
              </motion.button>
            </div>
          </div>

          {/* Volume Control */}
          <div className="flex items-center gap-3 w-full px-4 mt-6">
            <Volume2 className="w-5 h-5 text-[#8a9199] dark:text-[#6e7681]" />
            <div className="flex-1 relative h-2 bg-[#d2d6dc] dark:bg-[#1a1d23] rounded-full overflow-hidden shadow-inner">
              <div
                className="absolute top-0 left-0 h-full bg-gradient-to-r from-[#5e6772] to-[#8a9199] dark:from-[#7a8490] dark:to-[#9ba3ad] rounded-full"
                style={{ width: `${volume}%` }}
              />
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
