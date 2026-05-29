import { motion } from 'motion/react';
import { useNavigate } from 'react-router';
import { Disc3, Mic2, Music, ListMusic, Heart } from 'lucide-react';

export function Library() {
  const navigate = useNavigate();

  const menuItems = [
    { title: 'Albums', icon: <Disc3 className="w-5 h-5" />, path: '/' },
    { title: 'Nghệ Sĩ', icon: <Mic2 className="w-5 h-5" />, path: '/library' },
    { title: 'Bài Hát', icon: <Music className="w-5 h-5" />, path: '/songs' },
    { title: 'Danh Sách Phát', icon: <ListMusic className="w-5 h-5" />, path: '/library' },
    { title: 'Yêu Thích', icon: <Heart className="w-5 h-5" />, path: '/library' },
  ];

  return (
    <div className="size-full flex flex-col bg-[#050505] text-white overflow-y-auto px-6 pt-12 pb-24">
      <h1 className="text-2xl font-light tracking-wide mb-8">Thư Viện</h1>
      
      <div className="flex flex-col gap-2">
        {menuItems.map((item, idx) => (
          <motion.div
            key={item.title}
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: idx * 0.05 }}
            onClick={() => navigate(item.path)}
            className="flex items-center gap-4 p-4 rounded-xl hover:bg-white/5 border border-transparent hover:border-white/10 transition-all cursor-pointer group"
          >
            <div className="w-10 h-10 rounded-full bg-white/5 flex items-center justify-center text-white/50 group-hover:text-white transition-colors">
              {item.icon}
            </div>
            <span className="text-white/80 font-light tracking-wider text-lg group-hover:text-white transition-colors">
              {item.title}
            </span>
          </motion.div>
        ))}
      </div>
    </div>
  );
}
