import { createBrowserRouter } from "react-router";
import { Root } from "./components/Root";
import { Library } from "./components/Library";
import { CoverFlow } from "./components/CoverFlow";
import { NowPlaying } from "./components/NowPlaying";
import { Queue } from "./components/Queue";
import { LibraryHub } from "./components/LibraryHub";
import { Search } from "./components/Search";

export const router = createBrowserRouter([
  {
    path: "/",
    Component: Root,
    children: [
      { index: true, Component: Library },
      { path: "coverflow", Component: CoverFlow },
      { path: "library-hub", Component: LibraryHub },
      { path: "search", Component: Search },
    ],
  },
  { path: "/now-playing", Component: NowPlaying },
  { path: "/queue", Component: Queue },
]);
