import { createBrowserRouter } from "react-router";
import { Root } from "./components/Root";
import { Library } from "./components/Library";
import { CoverFlow } from "./components/CoverFlow";
import { AlbumDetail } from "./components/AlbumDetail";
import { NowPlaying } from "./components/NowPlaying";
import { Queue } from "./components/Queue";
import { SongList } from "./components/SongList";
import { Search } from "./components/Search";

export const router = createBrowserRouter([
  {
    path: "/",
    Component: Root,
    children: [
      { index: true, Component: CoverFlow },
      { path: "library", Component: Library },
      { path: "songs", Component: SongList },
      { path: "search", Component: Search },
      { path: "album/:id", Component: AlbumDetail },
      { path: "now-playing", Component: NowPlaying },
      { path: "queue", Component: Queue }
    ],
  },
]);
