import { motion } from "motion/react";
import { useNavigate } from "react-router";
import { Disc3, Music, User, ListMusic, Heart, Clock } from "lucide-react";

interface Category {
  id: string;
  title: string;
  icon: typeof Disc3;
  count: string;
  path: string;
}

const categories: Category[] = [
  {
    id: "albums",
    title: "Album",
    icon: Disc3,
    count: "24 album",
    path: "/"
  },
  {
    id: "artists",
    title: "Nghệ Sĩ",
    icon: User,
    count: "18 nghệ sĩ",
    path: "/artists"
  },
  {
    id: "songs",
    title: "Bài Hát",
    icon: Music,
    count: "156 bài",
    path: "/songs"
  },
  {
    id: "playlists",
    title: "Danh Sách Phát",
    icon: ListMusic,
    count: "8 danh sách",
    path: "/playlists"
  },
  {
    id: "favorites",
    title: "Yêu Thích",
    icon: Heart,
    count: "42 bài",
    path: "/favorites"
  },
  {
    id: "recent",
    title: "Nghe Gần Đây",
    icon: Clock,
    count: "20 bài",
    path: "/recent"
  }
];

export function LibraryHub() {
  const navigate = useNavigate();

  return (
    <div className="size-full flex items-center justify-center overflow-hidden">
      <div className="w-full max-w-md h-full flex flex-col bg-gradient-to-b from-[#e8eaed] to-[#d2d6dc] dark:from-[#2a2d33] dark:to-[#1a1d23] shadow-2xl">

        {/* Header */}
        <div className="px-6 py-4 bg-gradient-to-b from-[#f5f5f7] to-[#e8eaed] dark:from-[#353841] dark:to-[#2a2d33] border-b border-black/10 dark:border-white/10 shadow-sm">
          <h1 className="text-center text-[#1a1d23] dark:text-[#e8eaed] tracking-tight opacity-90">
            Thư Viện
          </h1>
        </div>

        {/* Categories Grid */}
        <div className="flex-1 overflow-y-auto px-6 py-8">
          <div className="space-y-3">
            {categories.map((category, index) => {
              const Icon = category.icon;
              return (
                <motion.button
                  key={category.id}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{
                    delay: index * 0.08,
                    type: "spring",
                    damping: 20,
                    stiffness: 200
                  }}
                  whileHover={{ scale: 1.02, x: 4 }}
                  whileTap={{ scale: 0.98 }}
                  onClick={() => navigate(category.path)}
                  className="w-full flex items-center gap-4 p-5 bg-gradient-to-br from-[#f5f5f7] to-[#e8eaed] dark:from-[#353841] dark:to-[#2a2d33] rounded-2xl shadow-[0_4px_16px_rgba(0,0,0,0.08),inset_0_1px_0_rgba(255,255,255,0.5)] dark:shadow-[0_4px_16px_rgba(0,0,0,0.3),inset_0_1px_0_rgba(255,255,255,0.05)] border border-white/40 dark:border-white/10 transition-all"
                >
                  <div className="w-14 h-14 rounded-xl bg-gradient-to-br from-[#5e6772] to-[#4a545e] dark:from-[#7a8490] dark:to-[#5e6772] flex items-center justify-center shadow-lg">
                    <Icon className="w-7 h-7 text-white" />
                  </div>

                  <div className="flex-1 text-left">
                    <h3 className="text-[#1a1d23] dark:text-[#e8eaed] mb-1">
                      {category.title}
                    </h3>
                    <p className="text-sm text-[#8a9199] dark:text-[#6e7681]">
                      {category.count}
                    </p>
                  </div>

                  <div className="w-8 h-8 rounded-full bg-white/40 dark:bg-white/10 flex items-center justify-center">
                    <svg
                      className="w-4 h-4 text-[#5e6772] dark:text-[#9ba3ad]"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M9 5l7 7-7 7"
                      />
                    </svg>
                  </div>
                </motion.button>
              );
            })}
          </div>
        </div>

      </div>
    </div>
  );
}
