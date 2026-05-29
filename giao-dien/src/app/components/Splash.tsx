import { useEffect } from 'react';
import { motion } from 'motion/react';
import { playSystemClick } from '../utils/audioClick';
import { Disc3 } from 'lucide-react';

interface SplashProps {
  onFinish: () => void;
}

export function Splash({ onFinish }: SplashProps) {
  useEffect(() => {
    const timer = setTimeout(() => {
      playSystemClick();
      onFinish();
    }, 2500);

    return () => clearTimeout(timer);
  }, [onFinish]);

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0, transition: { duration: 0.8, ease: 'easeOut' } }}
      className="fixed inset-0 z-50 flex items-center justify-center bg-[#050505] overflow-hidden"
    >
      {/* Subtle Volumetric Glow */}
      <motion.div
        initial={{ opacity: 0, scale: 0.8 }}
        animate={{ opacity: [0.2, 0.4, 0.2], scale: [0.9, 1.1, 0.9] }}
        transition={{ duration: 3, repeat: Infinity, ease: 'easeInOut' }}
        className="absolute w-96 h-96 bg-white/5 rounded-full blur-[100px]"
      />

      {/* Center Logo */}
      <motion.div
        initial={{ opacity: 0, y: 10, scale: 0.95 }}
        animate={{ opacity: 1, y: 0, scale: 1 }}
        transition={{ duration: 1.5, ease: 'easeOut' }}
        className="relative flex flex-col items-center gap-4 text-white/90"
      >
        <Disc3 className="w-16 h-16 opacity-80" strokeWidth={1} />
        <h1 className="text-xl font-light tracking-[0.2em] uppercase text-white/70">
          Không Gian
        </h1>
      </motion.div>
    </motion.div>
  );
}
