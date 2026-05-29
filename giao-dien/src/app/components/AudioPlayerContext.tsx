import { createContext, useContext, useState, useRef, useEffect, ReactNode } from 'react';
import { Song } from '../types';

interface AudioPlayerContextType {
  currentSong: Song | null;
  isPlaying: boolean;
  progress: number; // 0 to 100
  currentTime: number;
  duration: number;
  queue: Song[];
  playSong: (song: Song, newQueue?: Song[]) => void;
  togglePlay: () => void;
  next: () => void;
  prev: () => void;
  seek: (percent: number) => void;
  setVolume: (vol: number) => void;
  volume: number;
}

const AudioPlayerContext = createContext<AudioPlayerContextType | undefined>(undefined);

export function AudioPlayerProvider({ children }: { children: ReactNode }) {
  const [currentSong, setCurrentSong] = useState<Song | null>(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [progress, setProgress] = useState(0);
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(0);
  const [queue, setQueue] = useState<Song[]>([]);
  const [volume, setVolumeState] = useState(1);
  const [currentIndex, setCurrentIndex] = useState(-1);

  const audioRef = useRef<HTMLAudioElement | null>(null);

  useEffect(() => {
    audioRef.current = new Audio();
    audioRef.current.volume = volume;

    const audio = audioRef.current;

    const handleTimeUpdate = () => {
      setCurrentTime(audio.currentTime);
      if (audio.duration) {
        setDuration(audio.duration);
        setProgress((audio.currentTime / audio.duration) * 100);
      }
    };

    const handleEnded = () => {
      next();
    };

    audio.addEventListener('timeupdate', handleTimeUpdate);
    audio.addEventListener('ended', handleEnded);

    return () => {
      audio.removeEventListener('timeupdate', handleTimeUpdate);
      audio.removeEventListener('ended', handleEnded);
      audio.pause();
      audio.src = '';
    };
  }, []);

  const playSong = async (song: Song, newQueue?: Song[]) => {
    if (newQueue) {
      setQueue(newQueue);
      setCurrentIndex(newQueue.findIndex(s => s.id === song.id));
    } else {
      const idx = queue.findIndex(s => s.id === song.id);
      if (idx !== -1) setCurrentIndex(idx);
      else {
        setQueue([song]);
        setCurrentIndex(0);
      }
    }

    setCurrentSong(song);
    
    if (audioRef.current) {
      let src = song.audioUrl || '';
      if (song.audioBlob) {
        src = URL.createObjectURL(song.audioBlob);
      }
      
      if (src) {
        audioRef.current.src = src;
        try {
          await audioRef.current.play();
          setIsPlaying(true);
        } catch (e) {
          console.error("Playback failed", e);
          setIsPlaying(false);
        }
      }
    }
  };

  const togglePlay = () => {
    if (!audioRef.current || !currentSong) return;
    
    if (isPlaying) {
      audioRef.current.pause();
    } else {
      audioRef.current.play().catch(e => console.error(e));
    }
    setIsPlaying(!isPlaying);
  };

  const next = () => {
    if (currentIndex < queue.length - 1) {
      playSong(queue[currentIndex + 1]);
    } else {
      // Reached end, stop or loop
      if (queue.length > 0) {
        playSong(queue[0]); // loop to start
      }
    }
  };

  const prev = () => {
    if (audioRef.current && audioRef.current.currentTime > 3) {
      // restart song
      audioRef.current.currentTime = 0;
    } else if (currentIndex > 0) {
      playSong(queue[currentIndex - 1]);
    }
  };

  const seek = (percent: number) => {
    if (audioRef.current && duration) {
      const time = (percent / 100) * duration;
      audioRef.current.currentTime = time;
      setProgress(percent);
    }
  };

  const setVolume = (vol: number) => {
    if (audioRef.current) {
      audioRef.current.volume = vol;
      setVolumeState(vol);
    }
  };

  return (
    <AudioPlayerContext.Provider value={{ currentSong, isPlaying, progress, currentTime, duration, queue, playSong, togglePlay, next, prev, seek, setVolume, volume }}>
      {children}
    </AudioPlayerContext.Provider>
  );
}

export function useAudioPlayer() {
  const context = useContext(AudioPlayerContext);
  if (!context) throw new Error("useAudioPlayer must be used within AudioPlayerProvider");
  return context;
}
