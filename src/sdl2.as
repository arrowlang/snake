
// SDL.h
// =============================================================================

/// These are the flags which may be passed to SDL_Init(). You should
/// specify the subsystems which you will be using in your application.
export let SDL_INIT_TIMER: uint32          = 0x00000001;
export let SDL_INIT_AUDIO: uint32          = 0x00000010;
export let SDL_INIT_VIDEO: uint32          = 0x00000020;
export let SDL_INIT_JOYSTICK: uint32       = 0x00000200;
export let SDL_INIT_HAPTIC: uint32         = 0x00001000;
export let SDL_INIT_GAMECONTROLLER: uint32 = 0x00002000;
export let SDL_INIT_EVENTS: uint32         = 0x00004000;
export let SDL_INIT_NOPARACHUTE: uint32    = 0x00100000;
export let SDL_INIT_EVERYTHING: uint32     = (
  SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_EVENTS |
  SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | SDL_INIT_GAMECONTROLLER
);

/// This function initializes the subsystems specified by flags.
// TODO: export extern def SDL_Init(flags: uint32) -> c_int;
export extern def SDL_Init(flags: uint32) -> int32;

/// This function initializes specific SDL subsystems
// TODO: export extern def SDL_InitSubSystem(flags: uint32) -> c_int;
export extern def SDL_InitSubSystem(flags: uint32) -> int32;

/// This function cleans up specific SDL subsystems.
export extern def SDL_QuitSubSystem(flags: uint32);

/// This function returns a mask of the specified subsystems which have
/// previously been initialized.
export extern def SDL_WasInit(flags: uint32 = 0) -> uint32;

/// This function cleans up all initialized subsystems. You should
/// call it upon all exit conditions.
export extern def SDL_Quit();

// TODO: SDL_video.h
// =============================================================================

/// The type used to identify a window.
export struct SDL_Window {
  // Opaque [...]
}

/// Used to indicate that you don't care what the window position is.
// TODO: export let SDL_WINDOWPOS_UNDEFINED: c_int = 0x1FFF0000;
export let SDL_WINDOWPOS_UNDEFINED: int32 = 0x1FFF0000;

/// Used to indicate that the window position should be centered.
// TODO: export let SDL_WINDOWPOS_CENTERED: c_int = 0x2FFF0000;
export let SDL_WINDOWPOS_CENTERED: int32 = 0x2FFF0000;

/// The flags on a window.
export let SDL_WINDOW_FULLSCREEN: uint32         = 0x00000001;
export let SDL_WINDOW_OPENGL: uint32             = 0x00000002;
export let SDL_WINDOW_SHOWN: uint32              = 0x00000004;
export let SDL_WINDOW_HIDDEN: uint32             = 0x00000008;
export let SDL_WINDOW_BORDERLESS: uint32         = 0x00000010;
export let SDL_WINDOW_RESIZABLE: uint32          = 0x00000020;
export let SDL_WINDOW_MINIMIZED: uint32          = 0x00000040;
export let SDL_WINDOW_MAXIMIZED: uint32          = 0x00000080;
export let SDL_WINDOW_INPUT_GRABBED: uint32      = 0x00000100;
export let SDL_WINDOW_INPUT_FOCUS: uint32        = 0x00000200;
export let SDL_WINDOW_MOUSE_FOCUS: uint32        = 0x00000400;
export let SDL_WINDOW_FOREIGN: uint32            = 0x00000800;
export let SDL_WINDOW_ALLOW_HIGHDPI: uint32      = 0x00002000;
export let SDL_WINDOW_FULLSCREEN_DESKTOP: uint32 = (
  SDL_WINDOW_FULLSCREEN | 0x00001000
);

/// Create a window with the specified position, dimensions, and flags.
// TODO: export extern def SDL_CreateWindow(
//   title: str,
//   x: c_int,
//   y: c_int,
//   w: c_int,
//   h: c_int,
//   flags: uint32
// ) -> *SDL_Window;
export extern def SDL_CreateWindow(
  title: str,
  x: int32,
  y: int32,
  w: int32,
  h: int32,
  flags: uint32
) -> *SDL_Window;

/// Destroy a window.
export extern def SDL_DestroyWindow(window: *SDL_Window);

// TODO: SDL_render.h
// =============================================================================

/// A structure representing rendering state.
export struct SDL_Renderer {
  // Opaque [...]
}

/// Flags used when creating a rendering context.
export let SDL_RENDERER_SOFTWARE: uint32      = 0x00000001;
export let SDL_RENDERER_ACCELERATED: uint32   = 0x00000002;
export let SDL_RENDERER_PRESENTVSYNC: uint32  = 0x00000004;
export let SDL_RENDERER_TARGETTEXTURE: uint32 = 0x00000008;

/// Create a 2D rendering context for a window.
// TODO: export extern def SDL_CreateRenderer(
//   window: *SDL_Window,
//   index: c_int,
//   flags: uint32
// ) -> SDL_Renderer;
export extern def SDL_CreateRenderer(
  window: *SDL_Window,
  index: int32,
  flags: uint32
) -> *SDL_Renderer;

/// Set the color used for drawing operations (Rect, Line and Clear).
// TODO: export extern def SDL_SetRenderDrawColor(
//   renderer: *SDL_Renderer,
//   r: uint8,
//   g: uint8,
//   b: uint8,
//   a: uint8
// ) -> c_int;
export extern def SDL_SetRenderDrawColor(
  renderer: *SDL_Renderer,
  r: uint8,
  g: uint8,
  b: uint8,
  a: uint8
) -> int32;

/// Clear the current rendering target with the drawing color.
// TODO: export extern def SDL_RenderClear(renderer: *SDL_Renderer) -> c_int;
export extern def SDL_RenderClear(renderer: *SDL_Renderer) -> int32;

/// Update the screen with rendering performed.
export extern def SDL_RenderPresent(renderer: *SDL_Renderer);

/// Destroy the rendering context for a window and free associated textures.
export extern def SDL_DestroyRenderer(renderer: *SDL_Renderer);

// TODO: SDL_timer.h
// =============================================================================

/// Wait a specified number of milliseconds before returning.
export extern def SDL_Delay(ms: uint32);

// TODO: SDL_events.h
// =============================================================================

/// General event structure.
export struct SDL_Event {
  type_: uint32,

  // TODO: _: byte[56]
  a1: uint64,
  a2: uint64,
  a3: uint64,
  a4: uint64,
  a5: uint64,
  a6: uint64,
  a7: uint64,
}

/// Polls for currently pending events.
// TODO: export extern def SDL_PollEvent(event: *SDL_Event) -> c_int;
export extern def SDL_PollEvent(event: *SDL_Event) -> int32;
