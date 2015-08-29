import sdl from "./sdl2";
// TODO: import "./sdl2" as sdl;

let mutable g_window: *sdl.SDL_Window = 0 as *sdl.SDL_Window;
let mutable g_renderer: *sdl.SDL_Renderer = 0 as *sdl.SDL_Renderer;

def main() -> int {
  initilize();

  let mutable running = true;
  let evt = sdl.SDL_Event(0, 0, 0, 0, 0, 0, 0, 0);

  while running {
    // Handle events ..
    while sdl.SDL_PollEvent(&evt) != 0 {
      if evt.type_ == 0x100 {  // SDL_Quit
        running = false;
      }
    }

    draw();
  }

  dispose();

  return 0;
}

def initilize() {
  // Just initilize the world and worry about it later.
  sdl.SDL_Init(sdl.SDL_INIT_EVERYTHING);

  // Open a window ..
  g_window = sdl.SDL_CreateWindow(
    "Snake",
    sdl.SDL_WINDOWPOS_CENTERED,
    sdl.SDL_WINDOWPOS_CENTERED,
    640, 480,
    sdl.SDL_WINDOW_SHOWN
  );

  // Create a 2D rendering context ..
  g_renderer = sdl.SDL_CreateRenderer(
    g_window,
    -1,
    sdl.SDL_RENDERER_ACCELERATED
    | sdl.SDL_RENDERER_PRESENTVSYNC
  );
}

def dispose() {
  sdl.SDL_DestroyRenderer(g_renderer);
  sdl.SDL_DestroyWindow(g_window);
  sdl.SDL_Quit();
}

def draw() {
  sdl.SDL_SetRenderDrawColor(g_renderer, 25, 25, 25, 255);
  sdl.SDL_RenderClear(g_renderer);


  sdl.SDL_RenderPresent(g_renderer);
}
