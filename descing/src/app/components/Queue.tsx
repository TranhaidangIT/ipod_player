import { useState } from "react";
import { motion } from "motion/react";
import { X, Play, GripVertical } from "lucide-react";
import { useNavigate } from "react-router";

interface QueueSong {
  id: number;
  title: string;
  artist: string;
  duration: string;
  image: string;
}

const queueSongs: QueueSong[] = [
  {
    id: 1,
    title: "Giao Hưởng Số 9",
    artist: "Ludwig van Beethoven",
    duration: "4:23",
    image: "https://images.unsplash.com/photo-1672073314527-cd2d83182992?w=100"
  },
  {
    id: 2,
    title: "Tổ Khúc Cello Số 1",
    artist: "Johann Sebastian Bach",
    duration: "5:15",
    image: "https://images.unsplash.com/photo-1619468654328-5fefe028d42b?w=100"
  },
  {
    id: 3,
    title: "Requiem Thứ Điệu",
    artist: "Wolfgang Amadeus Mozart",
    duration: "3:32",
    image: "https://images.unsplash.com/photo-1585838017777-5003198884b5?w=100"
  },
  {
    id: 4,
    title: "Mùa Xuân - Allegro",
    artist: "Antonio Vivaldi",
    duration: "3:18",
    image: "https://images.unsplash.com/photo-1619468654256-1b3be59881df?w=100"
  },
  {
    id: 5,
    title: "Dạ Khúc Op. 9 Số 2",
    artist: "Frédéric Chopin",
    duration: "4:45",
    image: "https://images.unsplash.com/photo-1695510864104-242007d8b5b1?w=100"
  },
  {
    id: 6,
    title: "Giao Hưởng Số 6",
    artist: "Pyotr Ilyich Tchaikovsky",
    duration: "5:28",
    image: "https://images.unsplash.com/photo-1559121060-255b8b1adc74?w=100"
  },
  {
    id: 7,
    title: "Ánh Trăng",
    artist: "Claude Debussy",
    duration: "4:52",
    image: "https://images.unsplash.com/photo-1559121060-686a11356a87?w=100"
  }
];

export function Queue() {
  const navigate = useNavigate();
  const [currentSongId, setCurrentSongId] = useState(1);

  return (
    <div className="size-full flex items-center justify-center overflow-hidden">
      <div className="w-full max-w-md h-full flex flex-col bg-gradient-to-b from-[#e8eaed] to-[#d2d6dc] dark:from-[#2a2d33] dark:to-[#1a1d23] shadow-2xl">

        {/* Header */}
        <div className="px-6 py-4 bg-gradient-to-b from-[#f5f5f7] to-[#e8eaed] dark:from-[#353841] dark:to-[#2a2d33] border-b border-black/10 dark:border-white/10 shadow-sm flex items-center justify-between">
          <h1 className="text-center flex-1 text-[#1a1d23] dark:text-[#e8eaed] tracking-tight opacity-90">
            Danh Sách Phát
          </h1>
          <motion.button
            whileHover={{ scale: 1.1 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => navigate(-1)}
            className="p-2 rounded-full hover:bg-white/40 dark:hover:bg-white/10 transition-colors"
          >
            <X className="w-5 h-5 text-[#5e6772] dark:text-[#9ba3ad]" />
          </motion.button>
        </div>

        {/* Now Playing Section */}
        <div className="px-6 py-4 bg-gradient-to-b from-[#f5f5f7] to-[#e8eaed] dark:from-[#353841] dark:to-[#2a2d33] border-b border-black/10 dark:border-white/10">
          <p className="text-xs text-[#8a9199] dark:text-[#6e7681] mb-2 uppercase tracking-wider">
            Đang phát
          </p>
          <div className="flex items-center gap-3">
            <div className="relative w-12 h-12 rounded-lg overflow-hidden shadow-md flex-shrink-0">
              <img
                src={queueSongs[0].image}
                alt={queueSongs[0].title}
                className="w-full h-full object-cover"
              />
            </div>
            <div className="flex-1 min-w-0">
              <h4 className="truncate text-[#1a1d23] dark:text-[#e8eaed]">{queueSongs[0].title}</h4>
              <p className="text-sm text-[#5e6772] dark:text-[#9ba3ad] truncate">{queueSongs[0].artist}</p>
            </div>
            <Play className="w-5 h-5 text-[#5e6772] dark:text-[#9ba3ad] fill-current" />
          </div>
        </div>

        {/* Queue List */}
        <div className="flex-1 overflow-hidden px-6 py-4">
          <p className="text-xs text-[#8a9199] dark:text-[#6e7681] mb-3 uppercase tracking-wider">
            Tiếp theo
          </p>

          <motion.div
            className="space-y-2 overflow-y-auto h-full pb-20"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.1 }}
          >
            {queueSongs.slice(1).map((song, index) => (
              <motion.div
                key={song.id}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: index * 0.05, type: "spring", damping: 20, stiffness: 200 }}
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                onClick={() => setCurrentSongId(song.id)}
                className={`flex items-center gap-3 p-3 rounded-xl bg-white/40 dark:bg-white/5 backdrop-blur-sm border border-white/60 dark:border-white/10 transition-all cursor-pointer hover:bg-white/60 dark:hover:bg-white/10 ${
                  currentSongId === song.id ? 'ring-2 ring-[#5e6772]/50 dark:ring-[#9ba3ad]/50' : ''
                }`}
              >
                <GripVertical className="w-4 h-4 text-[#8a9199] dark:text-[#6e7681] flex-shrink-0" />

                <div className="relative w-12 h-12 rounded-lg overflow-hidden shadow-md flex-shrink-0">
                  <img
                    src={song.image}
                    alt={song.title}
                    className="w-full h-full object-cover"
                    draggable={false}
                  />
                </div>

                <div className="flex-1 min-w-0">
                  <h4 className="truncate text-[#1a1d23] dark:text-[#e8eaed]">{song.title}</h4>
                  <p className="text-sm text-[#5e6772] dark:text-[#9ba3ad] truncate">{song.artist}</p>
                </div>

                <span className="text-sm text-[#8a9199] dark:text-[#6e7681]">{song.duration}</span>
              </motion.div>
            ))}
          </motion.div>
        </div>

      </div>
    </div>
  );
}
