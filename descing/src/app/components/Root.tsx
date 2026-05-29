import { Outlet, useLocation, useNavigate } from "react-router";
import { Library, Disc3, Sun, Moon, Grid3x3, Search as SearchIcon } from "lucide-react";
import { motion } from "motion/react";
import { useTheme } from "./ThemeProvider";

export function Root() {
  const location = useLocation();
  const navigate = useNavigate();
  const { theme, toggleTheme } = useTheme();

  return (
    <div className="size-full flex flex-col bg-gradient-to-b from-[#d8dce3] to-[#c5c9d0] dark:from-[#1a1d23] dark:to-[#0f1115]">
      {/* Main Content */}
      <div className="flex-1 overflow-hidden">
        <Outlet />
      </div>

      {/* Bottom Navigation */}
      <div className="h-20 bg-gradient-to-t from-[#e8eaed] to-[#f5f5f7] dark:from-[#2a2d33] dark:to-[#1a1d23] border-t border-black/10 dark:border-white/10 shadow-[0_-4px_16px_rgba(0,0,0,0.08)]">
        <div className="h-full flex items-center justify-around px-4">
          <motion.button
            whileHover={{ scale: 1.1 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => navigate("/")}
            className={`flex flex-col items-center gap-1 p-2 rounded-xl transition-all ${
              location.pathname === "/"
                ? "bg-white/60 dark:bg-white/10 shadow-md"
                : "hover:bg-white/30 dark:hover:bg-white/5"
            }`}
          >
            <Library className={`w-5 h-5 ${location.pathname === "/" ? "text-[#5e6772] dark:text-[#9ba3ad]" : "text-[#8a9199] dark:text-[#5e6772]"}`} />
            <span className={`text-xs ${location.pathname === "/" ? "text-[#5e6772] dark:text-[#9ba3ad]" : "text-[#8a9199] dark:text-[#5e6772]"}`}>
              Album
            </span>
          </motion.button>

          <motion.button
            whileHover={{ scale: 1.1 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => navigate("/coverflow")}
            className={`flex flex-col items-center gap-1 p-2 rounded-xl transition-all ${
              location.pathname === "/coverflow"
                ? "bg-white/60 dark:bg-white/10 shadow-md"
                : "hover:bg-white/30 dark:hover:bg-white/5"
            }`}
          >
            <Disc3 className={`w-5 h-5 ${location.pathname === "/coverflow" ? "text-[#5e6772] dark:text-[#9ba3ad]" : "text-[#8a9199] dark:text-[#5e6772]"}`} />
            <span className={`text-xs ${location.pathname === "/coverflow" ? "text-[#5e6772] dark:text-[#9ba3ad]" : "text-[#8a9199] dark:text-[#5e6772]"}`}>
              Flow
            </span>
          </motion.button>

          <motion.button
            whileHover={{ scale: 1.1 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => navigate("/library-hub")}
            className={`flex flex-col items-center gap-1 p-2 rounded-xl transition-all ${
              location.pathname === "/library-hub"
                ? "bg-white/60 dark:bg-white/10 shadow-md"
                : "hover:bg-white/30 dark:hover:bg-white/5"
            }`}
          >
            <Grid3x3 className={`w-5 h-5 ${location.pathname === "/library-hub" ? "text-[#5e6772] dark:text-[#9ba3ad]" : "text-[#8a9199] dark:text-[#5e6772]"}`} />
            <span className={`text-xs ${location.pathname === "/library-hub" ? "text-[#5e6772] dark:text-[#9ba3ad]" : "text-[#8a9199] dark:text-[#5e6772]"}`}>
              Khám Phá
            </span>
          </motion.button>

          <motion.button
            whileHover={{ scale: 1.1 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => navigate("/search")}
            className={`flex flex-col items-center gap-1 p-2 rounded-xl transition-all ${
              location.pathname === "/search"
                ? "bg-white/60 dark:bg-white/10 shadow-md"
                : "hover:bg-white/30 dark:hover:bg-white/5"
            }`}
          >
            <SearchIcon className={`w-5 h-5 ${location.pathname === "/search" ? "text-[#5e6772] dark:text-[#9ba3ad]" : "text-[#8a9199] dark:text-[#5e6772]"}`} />
            <span className={`text-xs ${location.pathname === "/search" ? "text-[#5e6772] dark:text-[#9ba3ad]" : "text-[#8a9199] dark:text-[#5e6772]"}`}>
              Tìm
            </span>
          </motion.button>

          <motion.button
            whileHover={{ scale: 1.1 }}
            whileTap={{ scale: 0.95 }}
            onClick={toggleTheme}
            className="flex flex-col items-center gap-1 p-2 rounded-xl transition-all hover:bg-white/30 dark:hover:bg-white/5"
          >
            {theme === "light" ? (
              <Moon className="w-5 h-5 text-[#8a9199] dark:text-[#5e6772]" />
            ) : (
              <Sun className="w-5 h-5 text-[#8a9199] dark:text-[#9ba3ad]" />
            )}
            <span className="text-xs text-[#8a9199] dark:text-[#5e6772]">
              {theme === "light" ? "Tối" : "Sáng"}
            </span>
          </motion.button>
        </div>
      </div>
    </div>
  );
}
