import { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Search as SearchIcon, X, ArrowLeft } from 'lucide-react';
import { useNavigate } from 'react-router';
import { DUMMY_ALBUMS } from './CoverFlow';

export function Search() {
  const [query, setQuery] = useState('');
  const navigate = useNavigate();

  const results = query 
    ? DUMMY_ALBUMS.filter(a => 
        a.title.toLowerCase().includes(query.toLowerCase()) || 
        a.artist.toLowerCase().includes(query.toLowerCase())
      )
    : [];

  return (
    <div className="size-full flex flex-col bg-[#050505] text-white">
      <div className="p-6 flex flex-col gap-6">
        <div className="flex items-center gap-4">
          <button onClick={() => navigate(-1)} className="p-2 -ml-2 text-white/70 hover:text-white transition-colors">
            <ArrowLeft className="w-6 h-6" />
          </button>
          
          <div className="flex-1 relative">
            <SearchIcon className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-white/40" />
            <input 
              autoFocus
              type="text" 
              placeholder="Tìm kiếm nghệ sĩ, album..."
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              className="w-full bg-white/10 border border-white/5 rounded-full py-3 pl-12 pr-12 text-white placeholder:text-white/30 focus:outline-none focus:ring-2 focus:ring-white/20 transition-all font-light"
            />
            {query && (
              <button 
                onClick={() => setQuery('')}
                className="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 flex items-center justify-center bg-white/20 rounded-full hover:bg-white/30 transition-colors"
              >
                <X className="w-3 h-3" />
              </button>
            )}
          </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-6 pb-6">
        <AnimatePresence>
          {query && results.length > 0 && (
            <motion.div 
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="flex flex-col gap-4"
            >
              <h3 className="text-white/50 text-sm tracking-widest uppercase font-light mb-2">Kết quả Tìm kiếm</h3>
              {results.map((album, idx) => (
                <motion.div
                  key={album.id}
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: idx * 0.05 }}
                  onClick={() => navigate(`/album/${album.id}`)}
                  className="flex items-center gap-4 p-3 rounded-xl hover:bg-white/5 transition-colors cursor-pointer"
                >
                  <img src={album.image} alt={album.title} className="w-14 h-14 rounded-md object-cover" />
                  <div className="flex flex-col">
                    <span className="text-white/90 font-light tracking-wide">{album.title}</span>
                    <span className="text-white/40 text-sm tracking-wider">{album.artist}</span>
                  </div>
                </motion.div>
              ))}
            </motion.div>
          )}

          {query && results.length === 0 && (
            <motion.div 
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              className="mt-20 flex flex-col items-center justify-center text-white/30 gap-4"
            >
              <SearchIcon className="w-12 h-12 opacity-50" />
              <p className="font-light tracking-wide">Không tìm thấy kết quả</p>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </div>
  );
}
