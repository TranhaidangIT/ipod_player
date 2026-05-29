import { useState, useRef } from "react";
import { motion, PanInfo } from "motion/react";
import { useNavigate } from "react-router";
import { playWheelTick } from "../utils/audioClick";

export interface Album {
  id: string;
  title: string;
  artist: string;
  image: string;
  year?: string;
}

export const DUMMY_ALBUMS: Album[] = [
  { id: "1", title: "Beethoven Kiệt Tác", artist: "Ludwig van Beethoven", image: "https://images.unsplash.com/photo-1672073314527-cd2d83182992?w=500" },
  { id: "2", title: "Tổ Khúc Cello Bach", artist: "Johann Sebastian Bach", image: "https://images.unsplash.com/photo-1619468654328-5fefe028d42b?w=500" },
  { id: "3", title: "Mozart Requiem", artist: "Wolfgang Amadeus Mozart", image: "https://images.unsplash.com/photo-1585838017777-5003198884b5?w=500" },
  { id: "4", title: "Bốn Mùa", artist: "Antonio Vivaldi", image: "https://images.unsplash.com/photo-1619468654256-1b3be59881df?w=500" },
  { id: "5", title: "Dạ Khúc Chopin", artist: "Frédéric Chopin", image: "https://images.unsplash.com/photo-1695510864104-242007d8b5b1?w=500" },
  { id: "6", title: "Pathétique", artist: "Pyotr Ilyich Tchaikovsky", image: "https://images.unsplash.com/photo-1559121060-255b8b1adc74?w=500" }
];

export function CoverFlow() {
  const [currentIndex, setCurrentIndex] = useState(2);
  const constraintsRef = useRef(null);
  const navigate = useNavigate();

  const springConfig = { damping: 30, stiffness: 200, mass: 0.8 };

  const handleDragEnd = (_event: MouseEvent | TouchEvent | PointerEvent, info: PanInfo) => {
    const offset = info.offset.y;
    const velocity = info.velocity.y;

    if (Math.abs(velocity) > 200 || Math.abs(offset) > 50) {
      if (offset > 0 && currentIndex > 0) {
        setCurrentIndex(currentIndex - 1);
        playWheelTick();
      } else if (offset < 0 && currentIndex < DUMMY_ALBUMS.length - 1) {
        setCurrentIndex(currentIndex + 1);
        playWheelTick();
      }
    }
  };

  const getCardStyle = (index: number) => {
    const distance = index - currentIndex;
    const isActive = distance === 0;

    return {
      scale: isActive ? 1.05 : 0.85 - Math.abs(distance) * 0.08,
      rotateX: distance * -15, // Cylinder curve
      y: distance * 140, // Spacing
      z: isActive ? 50 : -Math.abs(distance) * 150,
      opacity: 1 - Math.abs(distance) * 0.3,
      zIndex: DUMMY_ALBUMS.length - Math.abs(distance),
    };
  };

  const bgImage = DUMMY_ALBUMS[currentIndex]?.image;

  return (
    <div className="size-full flex flex-col items-center justify-center overflow-hidden bg-[#0a0a0c] relative">
      {/* Blurred dynamic background */}
      <div className="absolute inset-0 z-0 overflow-hidden">
        <motion.div 
          key={bgImage}
          initial={{ opacity: 0 }}
          animate={{ opacity: 0.15 }}
          className="absolute inset-0 bg-cover bg-center blur-[80px] scale-125"
          style={{ backgroundImage: `url(${bgImage})` }}
        />
        <div className="absolute inset-0 bg-gradient-to-b from-transparent to-[#050505]" />
      </div>

      <div className="z-10 w-full max-w-md h-full flex flex-col pt-12">
        <h1 className="text-center text-white/50 tracking-[0.2em] uppercase font-light text-sm mb-4">
          Vòng quay Không Gian
        </h1>

        {/* Cover Flow Container */}
        <div
          ref={constraintsRef}
          className="flex-1 flex items-center justify-center perspective-[1000px] py-12 overflow-hidden"
          style={{ perspective: "1000px", perspectiveOrigin: "50% 50%" }}
        >
          <div className="relative w-full h-full flex items-center justify-center" style={{ transform: "rotateY(-5deg) rotateX(5deg)" }}>
            {DUMMY_ALBUMS.map((album, index) => {
              const style = getCardStyle(index);
              const isActive = index === currentIndex;

              return (
                <motion.div
                  key={album.id}
                  drag="y"
                  dragConstraints={constraintsRef}
                  dragElastic={0.2}
                  dragMomentum={true}
                  onDragEnd={handleDragEnd}
                  animate={style}
                  transition={springConfig}
                  className="absolute cursor-grab active:cursor-grabbing"
                  style={{ transformStyle: "preserve-3d" }}
                  onClick={() => {
                    if (isActive) {
                      playWheelTick();
                      navigate(`/album/${album.id}`);
                    } else {
                      setCurrentIndex(index);
                      playWheelTick();
                    }
                  }}
                >
                  <div className={`relative ${isActive ? 'w-64 h-64 sm:w-72 sm:h-72' : 'w-56 h-56'} transition-all duration-300`}>
                    <div className={`relative w-full h-full rounded-md overflow-hidden shadow-2xl transition-all ${isActive ? 'border border-white/20 shadow-[0_20px_50px_rgba(0,0,0,0.5)]' : ''}`}>
                      <img
                        src={album.image}
                        alt={album.title}
                        className="w-full h-full object-cover"
                        draggable={false}
                      />
                      <div className="absolute inset-0 bg-gradient-to-br from-white/10 to-transparent pointer-events-none" />
                    </div>
                  </div>
                </motion.div>
              );
            })}
          </div>
        </div>

        {/* Album Info */}
        <motion.div
          key={currentIndex}
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          className="pb-24 px-8 text-center z-10"
        >
          <h2 className="text-xl text-white/90 font-light tracking-wide truncate mb-1">
            {DUMMY_ALBUMS[currentIndex].title}
          </h2>
          <p className="text-sm text-white/40 tracking-wider truncate uppercase">
            {DUMMY_ALBUMS[currentIndex].artist}
          </p>
        </motion.div>
      </div>
    </div>
  );
}
