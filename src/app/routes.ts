import { createBrowserRouter } from "react-router";
import { Root } from "./components/Root";
import { Library } from "./components/Library";
import { CoverFlow } from "./components/CoverFlow";

export const router = createBrowserRouter([
  {
    path: "/",
    Component: Root,
    children: [
      { index: true, Component: Library },
      { path: "coverflow", Component: CoverFlow },
    ],
  },
]);
