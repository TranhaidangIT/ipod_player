export interface Song {
  id: string;
  title: string;
  artist: string;
  album: string;
  image: string;
  duration: string;
  audioBlob?: Blob; // For local files or downloaded online songs
  audioUrl?: string; // For streaming online songs (if not downloaded)
  isLocal?: boolean;
}
