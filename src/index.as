import sdl from "./sdl2";
// TODO: import "./sdl2" as sdl;

import list from "./list";
// TODO: import "./list" as list;

extern def printf(a: str, a: int);

extern def rand() -> int32;
extern def srand(a: uint32);

struct Snake {
  // TODO: This should be a deque not a vector
  position: list.List,

  // NOTE: Enum would be nice here
  // 0 - 'left'
  // 1 - 'top'
  // 2 - 'right'
  // 3 - 'bottom'
  direction: int,
}

let mutable g_apples = list.new();

let box_width = 15;
let box_height = 15;

let grid_width = 40;
let grid_height = 40;

let mutable g_window: *sdl.SDL_Window = 0 as *sdl.SDL_Window;
let mutable g_renderer: *sdl.SDL_Renderer = 0 as *sdl.SDL_Renderer;

let mutable g_snake = Snake(list.new(), 2);

def main() -> int {
  initilize();

  // Create the initial snake
  list.push(g_snake.position, 1 * grid_width + 5);
  list.push(g_snake.position, 2 * grid_width + 5);
  list.push(g_snake.position, 3 * grid_width + 5);
  list.push(g_snake.position, 4 * grid_width + 5);
  list.push(g_snake.position, 5 * grid_width + 5);
  list.push(g_snake.position, 5 * grid_width + 6);
  list.push(g_snake.position, 5 * grid_width + 7);
  list.push(g_snake.position, 5 * grid_width + 8);
  list.push(g_snake.position, 5 * grid_width + 9);
  list.push(g_snake.position, 5 * grid_width + 10);
  list.push(g_snake.position, 5 * grid_width + 11);

  let mutable running = true;
  let evt = sdl.SDL_Event(0, 0, 0, 0, 0, 0, 0, 0);
  let kbd_evt = &evt as *sdl.SDL_KeyboardEvent;

  let mutable sym = 0;

  while running {
    // Handle events ..
    while sdl.SDL_PollEvent(&evt) != 0 {
      if evt.type_ == 0x100 {  // SDL_Quit
        running = false;
      } else if evt.type_ == 0x300 {  // SDL_KEYDOWN
        sym = (*kbd_evt).keysym.scancode;
        // printf("%d\n", sym);
        if sym == 80 and g_snake.direction != 2 {  // <-
            g_snake.direction = 0;
        } else if sym == 79 and g_snake.direction != 0 {  // ->
          g_snake.direction = 2;
        } else if sym == 82 and g_snake.direction != 3 {  // ^
          g_snake.direction = 1;
        } else if sym == 81 and g_snake.direction != 1 {  // v
          g_snake.direction = 3;
        } else if sym == 41 { // esc
          running = false;
        }
      }
    }

    draw();

    // DEBUG: To make it slow for now
    sdl.SDL_Delay(42);

    // TODO: Time stepped update
    update(running);
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
    480, 480,
    sdl.SDL_WINDOW_SHOWN
  );

  // Create a 2D rendering context ..
  g_renderer = sdl.SDL_CreateRenderer(
    g_window,
    -1,
    sdl.SDL_RENDERER_ACCELERATED
    | sdl.SDL_RENDERER_PRESENTVSYNC
  );

  list.push(g_apples, 8 * grid_width + 6);
}

def drawOuter() {
  let topRect = sdl.SDL_Rect(0 as int32, 0 as int32, 480, 15);
  let bottomRect = sdl.SDL_Rect(0 as int32, 465 as int32, 480, 15);
  let leftRect = sdl.SDL_Rect(0 as int32, 0 as int32, 15, 480);
  let rightRect = sdl.SDL_Rect(465 as int32, 0 as int32, 15, 480);

  sdl.SDL_RenderFillRect(g_renderer, &topRect);
  sdl.SDL_RenderFillRect(g_renderer, &bottomRect);
  sdl.SDL_RenderFillRect(g_renderer, &leftRect);
  sdl.SDL_RenderFillRect(g_renderer, &rightRect);
}

def dispose() {
  list.dispose(g_snake.position);

  sdl.SDL_DestroyRenderer(g_renderer);
  sdl.SDL_DestroyWindow(g_window);

  sdl.SDL_Quit();
}

def draw() {
  sdl.SDL_SetRenderDrawColor(g_renderer, 25, 25, 25, 255);
  sdl.SDL_RenderClear(g_renderer);

  sdl.SDL_SetRenderDrawColor(g_renderer, 230, 230, 230, 255);

  let mutable i = 0;
  let mutable x = 0;
  let mutable y = 0;
  let mutable box_index: int;
  let mutable rect = sdl.SDL_Rect(0, 0, 0, 0);

  drawOuter();

  while i < g_snake.position._size {
    box_index = list.at(g_snake.position, i);
    y = box_index / grid_width;
    x = box_index % grid_width;
    rect = sdl.SDL_Rect(x * 15 as int32, y * 15 as int32, 15, 15);

    sdl.SDL_RenderFillRect(g_renderer, &rect);

    i += 1;
  }

  // Apples time.
  i = 0;
  sdl.SDL_SetRenderDrawColor(g_renderer, 245, 15, 15, 255);

  while i < g_apples._size {
    box_index = list.at(g_apples, i);
    y = box_index / grid_width;
    x = box_index % grid_width;
    rect = sdl.SDL_Rect(x * 15 as int32, y * 15 as int32, 15, 15);

    sdl.SDL_RenderFillRect(g_renderer, &rect);

    i += 1;
  }

  sdl.SDL_RenderPresent(g_renderer);
}

def newApple() {
  list.push(g_apples, ((rand() % 13) + 1) * grid_width + ((rand() % 13) + 1));
}

def checkCollision(mutable status: bool, x: int, y: int) {
  // Variables
  let mutable i = 0;
  let mutable cx = 0;
  let mutable cy = 0;
  let mutable box_index: int;

  // Logic

  // Border checks
  if y == 0 or y == 31 or x == 0 or x == 31 {
    status = false;
  }

  // Snake collision
  while (i < g_snake.position._size) & status {
    box_index = list.at(g_snake.position, i);
    cx = box_index % grid_width;
    cy = box_index / grid_width;
    i += 1;

    if x == cx and y == cy {
      status = false;
    }
  }

  i = 0;
  let mutable appleCollision = false;

  // Apple collision
  while i < g_apples._size {
    box_index = list.at(g_apples, i);
    cx = box_index % grid_width;
    cy = box_index / grid_width;

    if cx == x and cy == y {
      appleCollision = true;
      list.erase(g_apples, i);
      newApple();
    }

    i += 1;
  }

  if !appleCollision {
    // Erase the last block
    list.erase(g_snake.position, 0);
  }
}

def update(mutable status: bool) {
  // Push a new block (in the current direction)
  let pos = list.at(g_snake.position, -1);
  let mutable x = pos % grid_width;
  let mutable y = pos / grid_width;

  if g_snake.direction == 0 {
    // left
    x -= 1;
  } else if g_snake.direction == 1 {
    // top
    y -= 1;
  } else if g_snake.direction == 2 {
    // right
    x += 1;
  } else if g_snake.direction == 3 {
    // bottom
    y += 1;
  }

  checkCollision(status, x, y);

  list.push(g_snake.position, y * grid_width + x);
}
