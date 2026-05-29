import { useRef, useState } from "react";
import { motion, useSpring } from "motion/react";
import { Play, Pause, SkipBack, SkipForward, Volume2 } from "lucide-react";
import { useNavigate } from "react-router";

interface Album {
  id: number;
  title: string;
  artist: string;
  image: string;
  duration: string;
}

const albums: Album[] = [
  {
    id: 1,
    title: "Bản Giao Hưởng Số 9",
    artist: "Ludwig van Beethoven",
    image: "https://images.unsplash.com/photo-1672073314527-cd2d83182992?w=400",
    duration: "74:23"
  },
  {
    id: 2,
    title: "Tổ Khúc Cello",
    artist: "Johann Sebastian Bach",
    image: "https://images.unsplash.com/photo-1619468654328-5fefe028d42b?w=400",
    duration: "82:15"
  },
  {
    id: 3,
    title: "Requiem Thứ Điệu",
    artist: "Wolfgang Amadeus Mozart",
    image: "https://images.unsplash.com/photo-1585838017777-5003198884b5?w=400",
    duration: "56:32"
  },
  {
    id: 4,
    title: "Bốn Mùa",
    artist: "Antonio Vivaldi",
    image: "https://images.unsplash.com/photo-1619468654256-1b3be59881df?w=400",
    duration: "42:18"
  },
  {
    id: 5,
    title: "Dạ Khúc",
    artist: "Frédéric Chopin",
    image: "https://images.unsplash.com/photo-1695510864104-242007d8b5b1?w=400",
    duration: "63:45"
  },
  {
    id: 6,
    title: "Giao Hưởng Số 6",
    artist: "Pyotr Ilyich Tchaikovsky",
    image: "https://images.unsplash.com/photo-1559121060-255b8b1adc74?w=400",
    duration: "47:28"
  },
  {
    id: 7,
    title: "Ánh Trăng",
    artist: "Claude Debussy",
    image: "https://images.unsplash.com/photo-1559121060-686a11356a87?w=400",
    duration: "38:52"
  },
  {
    id: 8,
    title: "Concerto Piano Số 2",
    artist: "Sergei Rachmaninoff",
    image: "https://images.unsplash.com/photo-1559120817-9174e40b69a9?w=400",
    duration: "51:14"
  },
  {
    id: 9,
    title: "Âm Thanh Âm Nhạc",
    artist: "Rodgers & Hammerstein",
    image: "https://images.unsplash.com/photo-1570872469391-6ca8c89c61e7?w=400",
    duration: "55:33"
  },
  {
    id: 10,
    title: "Concerto Violin",
    artist: "Johannes Brahms",
    image: "https://images.unsplash.com/photo-1550634912-40b4a12c75ae?w=400",
    duration: "41:07"
  }
];

export function Library() {
  const navigate = useNavigate();
  const [selectedAlbum, setSelectedAlbum] = useState<Album>(albums[0]);
  const [isPlaying, setIsPlaying] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);
  const [isDragging, setIsDragging] = useState(false);

  const springY = useSpring(0, {
    damping: 30,
    stiffness: 200,
    mass: 0.8
  });

  return (
    <div className="size-full flex items-center justify-center overflow-hidden">
      <div className="w-full max-w-md h-full flex flex-col bg-gradient-to-b from-[#e8eaed] to-[#d2d6dc] dark:from-[#2a2d33] dark:to-[#1a1d23] shadow-2xl">

        {/* Header */}
        <div className="px-6 py-4 bg-gradient-to-b from-[#f5f5f7] to-[#e8eaed] dark:from-[#353841] dark:to-[#2a2d33] border-b border-black/10 dark:border-white/10 shadow-sm">
          <h1 className="text-center text-[#1a1d23] dark:text-[#e8eaed] tracking-tight opacity-90">
            Nhạc Cổ Điển
          </h1>
        </div>

        {/* Now Playing Card */}
        <motion.div
          onClick={() => navigate("/now-playing")}
          className="mx-6 mt-6 mb-4 p-6 bg-gradient-to-br from-[#f5f5f7] to-[#e8eaed] dark:from-[#353841] dark:to-[#2a2d33] rounded-2xl shadow-[0_8px_32px_rgba(0,0,0,0.12),inset_0_1px_0_rgba(255,255,255,0.5)] dark:shadow-[0_8px_32px_rgba(0,0,0,0.4),inset_0_1px_0_rgba(255,255,255,0.05)] border border-white/40 dark:border-white/10 cursor-pointer"
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ type: "spring", damping: 20, stiffness: 200 }}
          whileHover={{ scale: 1.01 }}
          whileTap={{ scale: 0.99 }}
        >
          <div className="flex items-center gap-4">
            <div className="relative w-20 h-20 rounded-xl overflow-hidden shadow-lg">
              <img
                src={selectedAlbum.image}
                alt={selectedAlbum.title}
                className="w-full h-full object-cover"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent pointer-events-none" />
            </div>
            <div className="flex-1 min-w-0">
              <h3 className="truncate text-[#1a1d23] dark:text-[#e8eaed] mb-1">{selectedAlbum.title}</h3>
              <p className="text-sm text-[#5e6772] dark:text-[#9ba3ad] truncate">{selectedAlbum.artist}</p>
              <p className="text-xs text-[#8a9199] dark:text-[#6e7681] mt-1">{selectedAlbum.duration}</p>
            </div>
          </div>

          {/* Progress Bar */}
          <div className="mt-4 h-1.5 bg-[#d2d6dc] dark:bg-[#1a1d23] rounded-full overflow-hidden shadow-inner">
            <motion.div
              className="h-full bg-gradient-to-r from-[#5e6772] to-[#8a9199] dark:from-[#7a8490] dark:to-[#9ba3ad] rounded-full"
              initial={{ width: "0%" }}
              animate={{ width: isPlaying ? "45%" : "0%" }}
              transition={{ duration: 2, ease: "linear" }}
            />
          </div>

          {/* Controls */}
          <div className="flex items-center justify-center gap-4 mt-4">
            <motion.button
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.95 }}
              className="p-2 rounded-full hover:bg-white/40 dark:hover:bg-white/10 transition-colors"
            >
              <SkipBack className="w-5 h-5 text-[#5e6772] dark:text-[#9ba3ad]" />
            </motion.button>

            <motion.button
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.95 }}
              onClick={() => setIsPlaying(!isPlaying)}
              className="p-3 rounded-full bg-gradient-to-b from-[#5e6772] to-[#4a545e] dark:from-[#7a8490] dark:to-[#5e6772] shadow-lg hover:shadow-xl transition-shadow"
            >
              {isPlaying ? (
                <Pause className="w-6 h-6 text-white fill-white" />
              ) : (
                <Play className="w-6 h-6 text-white fill-white ml-0.5" />
              )}
            </motion.button>

            <motion.button
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.95 }}
              className="p-2 rounded-full hover:bg-white/40 dark:hover:bg-white/10 transition-colors"
            >
              <SkipForward className="w-5 h-5 text-[#5e6772] dark:text-[#9ba3ad]" />
            </motion.button>

            <div className="ml-2 flex items-center gap-2">
              <Volume2 className="w-4 h-4 text-[#8a9199] dark:text-[#6e7681]" />
              <div className="w-16 h-1.5 bg-[#d2d6dc] dark:bg-[#1a1d23] rounded-full overflow-hidden shadow-inner">
                <div className="h-full w-3/4 bg-gradient-to-r from-[#5e6772] to-[#8a9199] dark:from-[#7a8490] dark:to-[#9ba3ad] rounded-full" />
              </div>
            </div>
          </div>
        </motion.div>

        {/* Album List Title */}
        <div className="px-6 py-2">
          <h2 className="text-[#5e6772] dark:text-[#9ba3ad]">Thư Viện</h2>
        </div>

        {/* Scrollable Album List */}
        <div className="flex-1 overflow-hidden px-6 pb-6">
          <motion.div
            ref={scrollRef}
            drag="y"
            dragConstraints={{
              top: -(albums.length * 100 - 400),
              bottom: 0
            }}
            dragElastic={0.1}
            dragMomentum={true}
            onDragStart={() => setIsDragging(true)}
            onDragEnd={() => setIsDragging(false)}
            style={{ y: springY }}
            className="space-y-3 cursor-grab active:cursor-grabbing"
          >
            {albums.map((album, index) => (
              <motion.div
                key={album.id}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{
                  delay: index * 0.05,
                  type: "spring",
                  damping: 20,
                  stiffness: 200
                }}
                whileHover={{ scale: isDragging ? 1 : 1.02 }}
                whileTap={{ scale: 0.98 }}
                onClick={() => !isDragging && setSelectedAlbum(album)}
                className={`flex items-center gap-4 p-4 bg-gradient-to-br from-[#f5f5f7] to-[#e8eaed] dark:from-[#353841] dark:to-[#2a2d33] rounded-xl shadow-[0_4px_16px_rgba(0,0,0,0.08),inset_0_1px_0_rgba(255,255,255,0.5)] dark:shadow-[0_4px_16px_rgba(0,0,0,0.3),inset_0_1px_0_rgba(255,255,255,0.05)] border border-white/40 dark:border-white/10 transition-all cursor-pointer ${
                  selectedAlbum.id === album.id ? 'ring-2 ring-[#5e6772]/50 dark:ring-[#9ba3ad]/50 shadow-lg' : ''
                }`}
              >
                <div className="relative w-16 h-16 rounded-lg overflow-hidden shadow-md flex-shrink-0">
                  <img
                    src={album.image}
                    alt={album.title}
                    className="w-full h-full object-cover"
                    draggable={false}
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-black/10 to-transparent pointer-events-none" />
                  <div className="absolute inset-0 shadow-[inset_0_1px_2px_rgba(0,0,0,0.1)] pointer-events-none rounded-lg" />
                </div>

                <div className="flex-1 min-w-0">
                  <h4 className="truncate text-[#1a1d23] dark:text-[#e8eaed]">{album.title}</h4>
                  <p className="text-sm text-[#5e6772] dark:text-[#9ba3ad] truncate">{album.artist}</p>
                  <p className="text-xs text-[#8a9199] dark:text-[#6e7681] mt-0.5">{album.duration}</p>
                </div>

                {selectedAlbum.id === album.id && (
                  <motion.div
                    initial={{ scale: 0 }}
                    animate={{ scale: 1 }}
                    className="w-2 h-2 rounded-full bg-[#5e6772] dark:bg-[#9ba3ad] shadow-lg"
                  />
                )}
              </motion.div>
            ))}
          </motion.div>
        </div>

      </div>
    </div>
  );
}
