import { Outlet, useLocation, useNavigate } from "react-router";
import { Library, Disc3, Search, FolderMusic } from "lucide-react";
import { motion, AnimatePresence } from "motion/react";
import { useState } from "react";
import { AudioPlayerProvider } from "./AudioPlayerContext";
import { Splash } from "./Splash";
import { MiniPlayer } from "./MiniPlayer";

export function Root() {
  const location = useLocation();
  const navigate = useNavigate();
  const [showSplash, setShowSplash] = useState(true);

  return (
    <AudioPlayerProvider>
      <div className="size-full flex flex-col bg-[#050505] text-white overflow-hidden relative">
        <AnimatePresence>
          {showSplash && <Splash key="splash" onFinish={() => setShowSplash(false)} />}
        </AnimatePresence>

        {/* Main Content */}
        <div className="flex-1 overflow-hidden relative z-10">
          <Outlet />
        </div>

        {/* Mini Player */}
        <div className="relative z-40">
          <MiniPlayer />
        </div>

        {/* Bottom Navigation */}
        {!location.pathname.includes('/now-playing') && (
          <motion.div 
            initial={{ y: 100 }} animate={{ y: 0 }}
            className="h-20 bg-[#0a0a0c]/80 backdrop-blur-2xl border-t border-white/5 z-20"
          >
            <div className="h-full flex items-center justify-around px-8 max-w-md mx-auto">
              <NavItem 
                icon={<Disc3 />} 
                label="Không Gian" 
                path="/" 
                isActive={location.pathname === "/"} 
                onClick={() => navigate("/")} 
              />
              <NavItem 
                icon={<Library />} 
                label="Thư Viện" 
                path="/library" 
                isActive={location.pathname === "/library"} 
                onClick={() => navigate("/library")} 
              />
              <NavItem 
                icon={<FolderMusic />} 
                label="Cục Bộ" 
                path="/songs" 
                isActive={location.pathname === "/songs"} 
                onClick={() => navigate("/songs")} 
              />
              <NavItem 
                icon={<Search />} 
                label="Tìm Kiếm" 
                path="/search" 
                isActive={location.pathname === "/search"} 
                onClick={() => navigate("/search")} 
              />
            </div>
          </motion.div>
        )}
      </div>
    </AudioPlayerProvider>
  );
}

function NavItem({ icon, label, path, isActive, onClick }: any) {
  return (
    <motion.button
      whileHover={{ scale: 1.1 }}
      whileTap={{ scale: 0.95 }}
      onClick={onClick}
      className="flex flex-col items-center gap-1 p-2 rounded-xl transition-all"
    >
      <div className={`w-6 h-6 ${isActive ? 'text-white' : 'text-white/40'}`}>
        {icon}
      </div>
      <span className={`text-[10px] uppercase tracking-wider font-light ${isActive ? 'text-white' : 'text-white/40'}`}>
        {label}
      </span>
    </motion.button>
  );
}
