import { useState } from "react";
import { motion } from "motion/react";
import { Search as SearchIcon, X, Music, Disc3, User } from "lucide-react";
import { useNavigate } from "react-router";

interface SearchResult {
  id: number;
  type: "song" | "album" | "artist";
  title: string;
  subtitle: string;
  image: string;
}

const allResults: SearchResult[] = [
  {
    id: 1,
    type: "song",
    title: "Giao Hưởng Số 9",
    subtitle: "Ludwig van Beethoven",
    image: "https://images.unsplash.com/photo-1672073314527-cd2d83182992?w=100"
  },
  {
    id: 2,
    type: "album",
    title: "Bốn Mùa",
    subtitle: "Antonio Vivaldi",
    image: "https://images.unsplash.com/photo-1619468654256-1b3be59881df?w=100"
  },
  {
    id: 3,
    type: "artist",
    title: "Frédéric Chopin",
    subtitle: "24 bài hát",
    image: "https://images.unsplash.com/photo-1695510864104-242007d8b5b1?w=100"
  },
  {
    id: 4,
    type: "song",
    title: "Ánh Trăng",
    subtitle: "Claude Debussy",
    image: "https://images.unsplash.com/photo-1559121060-686a11356a87?w=100"
  },
  {
    id: 5,
    type: "album",
    title: "Requiem Thứ Điệu",
    subtitle: "Wolfgang Amadeus Mozart",
    image: "https://images.unsplash.com/photo-1585838017777-5003198884b5?w=100"
  }
];

export function Search() {
  const navigate = useNavigate();
  const [searchQuery, setSearchQuery] = useState("");
  const [results, setResults] = useState<SearchResult[]>([]);

  const handleSearch = (query: string) => {
    setSearchQuery(query);
    if (query.trim()) {
      const filtered = allResults.filter(
        item =>
          item.title.toLowerCase().includes(query.toLowerCase()) ||
          item.subtitle.toLowerCase().includes(query.toLowerCase())
      );
      setResults(filtered);
    } else {
      setResults([]);
    }
  };

  const getTypeIcon = (type: string) => {
    switch (type) {
      case "song":
        return Music;
      case "album":
        return Disc3;
      case "artist":
        return User;
      default:
        return Music;
    }
  };

  const getTypeLabel = (type: string) => {
    switch (type) {
      case "song":
        return "Bài hát";
      case "album":
        return "Album";
      case "artist":
        return "Nghệ sĩ";
      default:
        return "";
    }
  };

  return (
    <div className="size-full flex items-center justify-center overflow-hidden">
      <div className="w-full max-w-md h-full flex flex-col bg-gradient-to-b from-[#e8eaed] to-[#d2d6dc] dark:from-[#2a2d33] dark:to-[#1a1d23] shadow-2xl">

        {/* Header */}
        <div className="px-6 py-4 bg-gradient-to-b from-[#f5f5f7] to-[#e8eaed] dark:from-[#353841] dark:to-[#2a2d33] border-b border-black/10 dark:border-white/10 shadow-sm">
          <h1 className="text-center text-[#1a1d23] dark:text-[#e8eaed] tracking-tight opacity-90">
            Tìm Kiếm
          </h1>
        </div>

        {/* Search Input */}
        <div className="px-6 py-4">
          <motion.div
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            className="relative"
          >
            <SearchIcon className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-[#8a9199] dark:text-[#6e7681]" />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => handleSearch(e.target.value)}
              placeholder="Tìm bài hát, album, nghệ sĩ..."
              className="w-full pl-12 pr-12 py-3 bg-white/60 dark:bg-white/10 backdrop-blur-sm border border-white/60 dark:border-white/20 rounded-xl text-[#1a1d23] dark:text-[#e8eaed] placeholder-[#8a9199] dark:placeholder-[#6e7681] focus:outline-none focus:ring-2 focus:ring-[#5e6772]/50 dark:focus:ring-[#9ba3ad]/50 transition-all shadow-sm"
            />
            {searchQuery && (
              <motion.button
                initial={{ opacity: 0, scale: 0.8 }}
                animate={{ opacity: 1, scale: 1 }}
                onClick={() => handleSearch("")}
                className="absolute right-4 top-1/2 -translate-y-1/2 p-1 rounded-full hover:bg-white/40 dark:hover:bg-white/20 transition-colors"
              >
                <X className="w-4 h-4 text-[#8a9199] dark:text-[#6e7681]" />
              </motion.button>
            )}
          </motion.div>
        </div>

        {/* Results */}
        <div className="flex-1 overflow-y-auto px-6 pb-6">
          {!searchQuery ? (
            <div className="flex flex-col items-center justify-center h-full text-center">
              <SearchIcon className="w-16 h-16 text-[#d2d6dc] dark:text-[#353841] mb-4" />
              <p className="text-[#8a9199] dark:text-[#6e7681]">
                Tìm kiếm nhạc yêu thích của bạn
              </p>
            </div>
          ) : results.length === 0 ? (
            <div className="flex flex-col items-center justify-center h-full text-center">
              <SearchIcon className="w-16 h-16 text-[#d2d6dc] dark:text-[#353841] mb-4" />
              <p className="text-[#8a9199] dark:text-[#6e7681]">
                Không tìm thấy kết quả
              </p>
            </div>
          ) : (
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              className="space-y-2"
            >
              {results.map((result, index) => {
                const Icon = getTypeIcon(result.type);
                return (
                  <motion.div
                    key={result.id}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: index * 0.05, type: "spring", damping: 20, stiffness: 200 }}
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                    className="flex items-center gap-3 p-3 bg-white/40 dark:bg-white/5 backdrop-blur-sm border border-white/60 dark:border-white/10 rounded-xl cursor-pointer hover:bg-white/60 dark:hover:bg-white/10 transition-all"
                  >
                    <div className="relative w-14 h-14 rounded-lg overflow-hidden shadow-md flex-shrink-0">
                      <img
                        src={result.image}
                        alt={result.title}
                        className="w-full h-full object-cover"
                      />
                    </div>

                    <div className="flex-1 min-w-0">
                      <h4 className="truncate text-[#1a1d23] dark:text-[#e8eaed]">
                        {result.title}
                      </h4>
                      <div className="flex items-center gap-2 mt-0.5">
                        <Icon className="w-3 h-3 text-[#8a9199] dark:text-[#6e7681]" />
                        <p className="text-sm text-[#8a9199] dark:text-[#6e7681] truncate">
                          {getTypeLabel(result.type)} • {result.subtitle}
                        </p>
                      </div>
                    </div>
                  </motion.div>
                );
              })}
            </motion.div>
          )}
        </div>

      </div>
    </div>
  );
}
