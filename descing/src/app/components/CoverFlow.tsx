import { useState, useRef } from "react";
import { motion, useMotionValue, useTransform, useSpring, PanInfo } from "motion/react";
import { Play, Pause, Shuffle } from "lucide-react";

interface Song {
  id: number;
  title: string;
  artist: string;
  album: string;
  image: string;
  duration: string;
}

const songs: Song[] = [
  {
    id: 1,
    title: "Giao Hưởng Số 9",
    artist: "Ludwig van Beethoven",
    album: "Beethoven Kiệt Tác",
    image: "https://images.unsplash.com/photo-1672073314527-cd2d83182992?w=500",
    duration: "4:23"
  },
  {
    id: 2,
    title: "Tổ Khúc Cello Số 1",
    artist: "Johann Sebastian Bach",
    album: "Tổ Khúc Cello Bach",
    image: "https://images.unsplash.com/photo-1619468654328-5fefe028d42b?w=500",
    duration: "5:15"
  },
  {
    id: 3,
    title: "Requiem Thứ Điệu",
    artist: "Wolfgang Amadeus Mozart",
    album: "Mozart Requiem",
    image: "https://images.unsplash.com/photo-1585838017777-5003198884b5?w=500",
    duration: "3:32"
  },
  {
    id: 4,
    title: "Mùa Xuân - Allegro",
    artist: "Antonio Vivaldi",
    album: "Bốn Mùa",
    image: "https://images.unsplash.com/photo-1619468654256-1b3be59881df?w=500",
    duration: "3:18"
  },
  {
    id: 5,
    title: "Dạ Khúc Op. 9 Số 2",
    artist: "Frédéric Chopin",
    album: "Dạ Khúc Chopin",
    image: "https://images.unsplash.com/photo-1695510864104-242007d8b5b1?w=500",
    duration: "4:45"
  },
  {
    id: 6,
    title: "Giao Hưởng Số 6",
    artist: "Pyotr Ilyich Tchaikovsky",
    album: "Pathétique",
    image: "https://images.unsplash.com/photo-1559121060-255b8b1adc74?w=500",
    duration: "5:28"
  },
  {
    id: 7,
    title: "Ánh Trăng",
    artist: "Claude Debussy",
    album: "Suite Bergamasque",
    image: "https://images.unsplash.com/photo-1559121060-686a11356a87?w=500",
    duration: "4:52"
  },
  {
    id: 8,
    title: "Concerto Piano Số 2",
    artist: "Sergei Rachmaninoff",
    album: "Concerto Rachmaninoff",
    image: "https://images.unsplash.com/photo-1559120817-9174e40b69a9?w=500",
    duration: "6:14"
  }
];

export function CoverFlow() {
  const [currentIndex, setCurrentIndex] = useState(2);
  const [isPlaying, setIsPlaying] = useState(false);
  const constraintsRef = useRef(null);
  const y = useMotionValue(0);

  const springConfig = { damping: 30, stiffness: 200, mass: 0.8 };

  const handleDragEnd = (_event: MouseEvent | TouchEvent | PointerEvent, info: PanInfo) => {
    const offset = info.offset.y;
    const velocity = info.velocity.y;

    if (Math.abs(velocity) > 500 || Math.abs(offset) > 100) {
      if (offset > 0 && currentIndex > 0) {
        setCurrentIndex(currentIndex - 1);
      } else if (offset < 0 && currentIndex < songs.length - 1) {
        setCurrentIndex(currentIndex + 1);
      }
    }
  };

  const getCardStyle = (index: number) => {
    const distance = index - currentIndex;
    const isActive = distance === 0;

    return {
      scale: isActive ? 1 : 0.85 - Math.abs(distance) * 0.08,
      rotateX: distance * -8,
      y: distance * 120,
      z: isActive ? 0 : -Math.abs(distance) * 150,
      opacity: 1 - Math.abs(distance) * 0.25,
      zIndex: songs.length - Math.abs(distance),
    };
  };

  return (
    <div className="size-full flex flex-col items-center justify-center overflow-hidden">
      <div className="w-full max-w-md h-full flex flex-col bg-gradient-to-b from-[#e8eaed] to-[#d2d6dc] dark:from-[#2a2d33] dark:to-[#1a1d23] shadow-2xl">

        {/* Header */}
        <div className="px-6 py-4 bg-gradient-to-b from-[#f5f5f7] to-[#e8eaed] dark:from-[#353841] dark:to-[#2a2d33] border-b border-black/10 dark:border-white/10 shadow-sm">
          <div className="flex items-center justify-between">
            <h1 className="text-center flex-1 text-[#1a1d23] dark:text-[#e8eaed] tracking-tight opacity-90">
              Phát Ngẫu Nhiên
            </h1>
            <Shuffle className="w-5 h-5 text-[#5e6772] dark:text-[#9ba3ad]" />
          </div>
        </div>

        {/* Cover Flow Container */}
        <div
          ref={constraintsRef}
          className="flex-1 flex items-center justify-center perspective-[1200px] py-12 overflow-hidden"
          style={{ perspective: "1200px" }}
        >
          <div className="relative w-full h-full flex items-center justify-center">
            {songs.map((song, index) => {
              const style = getCardStyle(index);
              const isActive = index === currentIndex;

              return (
                <motion.div
                  key={song.id}
                  drag="y"
                  dragConstraints={constraintsRef}
                  dragElastic={0.1}
                  dragMomentum={true}
                  onDragEnd={handleDragEnd}
                  animate={style}
                  transition={springConfig}
                  className="absolute cursor-grab active:cursor-grabbing"
                  style={{
                    transformStyle: "preserve-3d",
                    pointerEvents: isActive ? "auto" : "none",
                  }}
                  onClick={() => isActive && setIsPlaying(!isPlaying)}
                >
                  <div
                    className={`relative ${isActive ? 'w-72 h-72' : 'w-64 h-64'} transition-all duration-300`}
                  >
                    {/* Album Cover */}
                    <div className="relative w-full h-full rounded-2xl overflow-hidden shadow-[0_20px_60px_rgba(0,0,0,0.3)] border-4 border-white/40">
                      <img
                        src={song.image}
                        alt={song.title}
                        className="w-full h-full object-cover"
                        draggable={false}
                      />

                      {/* Reflection overlay */}
                      <div className="absolute inset-0 bg-gradient-to-br from-white/10 via-transparent to-black/20 pointer-events-none" />

                      {/* Glass reflection effect */}
                      <div className="absolute top-0 left-0 w-full h-1/3 bg-gradient-to-b from-white/20 to-transparent pointer-events-none" />

                      {/* Active indicator */}
                      {isActive && (
                        <motion.div
                          initial={{ opacity: 0 }}
                          animate={{ opacity: 1 }}
                          className="absolute inset-0 flex items-center justify-center bg-black/20 backdrop-blur-[1px]"
                        >
                          <motion.div
                            whileHover={{ scale: 1.1 }}
                            whileTap={{ scale: 0.9 }}
                            className="w-20 h-20 rounded-full bg-gradient-to-b from-white/90 to-white/70 shadow-2xl flex items-center justify-center"
                          >
                            {isPlaying ? (
                              <Pause className="w-10 h-10 text-[#5e6772] fill-[#5e6772] ml-0" />
                            ) : (
                              <Play className="w-10 h-10 text-[#5e6772] fill-[#5e6772] ml-1" />
                            )}
                          </motion.div>
                        </motion.div>
                      )}
                    </div>

                    {/* Shadow beneath card */}
                    <div
                      className="absolute -bottom-4 left-1/2 -translate-x-1/2 w-3/4 h-8 bg-black/20 blur-2xl rounded-full"
                      style={{ transform: `translateX(-50%) translateZ(-50px)` }}
                    />
                  </div>
                </motion.div>
              );
            })}
          </div>
        </div>

        {/* Song Info */}
        <motion.div
          key={currentIndex}
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ type: "spring", damping: 20, stiffness: 200 }}
          className="px-8 pb-8"
        >
          <div className="p-6 bg-gradient-to-br from-[#f5f5f7] to-[#e8eaed] dark:from-[#353841] dark:to-[#2a2d33] rounded-2xl shadow-[0_8px_32px_rgba(0,0,0,0.12),inset_0_1px_0_rgba(255,255,255,0.5)] dark:shadow-[0_8px_32px_rgba(0,0,0,0.4),inset_0_1px_0_rgba(255,255,255,0.05)] border border-white/40 dark:border-white/10">
            <h2 className="text-center text-[#1a1d23] dark:text-[#e8eaed] mb-1 truncate">
              {songs[currentIndex].title}
            </h2>
            <p className="text-center text-sm text-[#5e6772] dark:text-[#9ba3ad] truncate">
              {songs[currentIndex].artist}
            </p>
            <p className="text-center text-xs text-[#8a9199] dark:text-[#6e7681] mt-1">
              {songs[currentIndex].album} • {songs[currentIndex].duration}
            </p>

            {/* Progress indicator */}
            <div className="mt-4 flex items-center justify-center gap-2">
              {songs.map((_, index) => (
                <motion.div
                  key={index}
                  className={`h-1.5 rounded-full transition-all ${
                    index === currentIndex
                      ? 'w-8 bg-[#5e6772] dark:bg-[#9ba3ad]'
                      : 'w-1.5 bg-[#d2d6dc] dark:bg-[#1a1d23]'
                  }`}
                  animate={{
                    scale: index === currentIndex ? 1.1 : 1,
                  }}
                />
              ))}
            </div>
          </div>
        </motion.div>

      </div>
    </div>
  );
}
