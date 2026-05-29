import { openDB, DBSchema, IDBPDatabase } from 'idb';
import { Song } from '../types'; // We will create this

interface IpodDB extends DBSchema {
  songs: {
    key: string; // id
    value: Song;
  };
  settings: {
    key: string;
    value: any;
  };
}

let dbPromise: Promise<IDBPDatabase<IpodDB>> | null = null;

export async function getDB() {
  if (!dbPromise) {
    dbPromise = openDB<IpodDB>('SpatialMusicPlayerDB', 1, {
      upgrade(db) {
        if (!db.objectStoreNames.contains('songs')) {
          db.createObjectStore('songs', { keyPath: 'id' });
        }
        if (!db.objectStoreNames.contains('settings')) {
          db.createObjectStore('settings');
        }
      },
    });
  }
  return dbPromise;
}

export async function saveSong(song: Song) {
  const db = await getDB();
  await db.put('songs', song);
}

export async function getAllSongs(): Promise<Song[]> {
  const db = await getDB();
  return db.getAll('songs');
}

export async function deleteSong(id: string) {
  const db = await getDB();
  await db.delete('songs', id);
}

export async function saveSetting(key: string, value: any) {
  const db = await getDB();
  await db.put('settings', value, key);
}

export async function getSetting(key: string) {
  const db = await getDB();
  return db.get('settings', key);
}
