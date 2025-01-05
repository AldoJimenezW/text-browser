const std = @import("std");
const c = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("SDL2/SDL_ttf.h");
});
const TextRenderer = @import("renderer.zig").TextRenderer;

pub const Window = struct {
    window: *c.SDL_Window,
    renderer: *c.SDL_Renderer,
    text_renderer: TextRenderer,
    running: bool,

    pub fn init() !Window {
        if (c.SDL_Init(c.SDL_INIT_VIDEO) < 0) {
            return error.SDLInitializationFailed;
        }

        const window = c.SDL_CreateWindow(
            "Text Browser",
            c.SDL_WINDOWPOS_UNDEFINED,
            c.SDL_WINDOWPOS_UNDEFINED,
            1024,
            768,
            c.SDL_WINDOW_SHOWN | c.SDL_WINDOW_RESIZABLE
        ) orelse {
            return error.WindowCreationFailed;
        };

        const renderer = c.SDL_CreateRenderer(
            window,
            -1,
            c.SDL_RENDERER_ACCELERATED
        ) orelse {
            return error.RendererCreationFailed;
        };

        const text_renderer = try TextRenderer.init(renderer, 16);

        return Window{
            .window = window,
            .renderer = renderer,
            .text_renderer = text_renderer,
            .running = true,
        };
    }

    pub fn deinit(self: *Window) void {
        self.text_renderer.deinit();
        c.SDL_DestroyRenderer(self.renderer);
        c.SDL_DestroyWindow(self.window);
        c.SDL_Quit();
    }

    pub fn run(self: *Window) !void {
        while (self.running) {
            var event: c.SDL_Event = undefined;
            while (c.SDL_PollEvent(&event) != 0) {
                switch (event.type) {
                    c.SDL_QUIT => {
                        self.running = false;
                    },
                    else => {},
                }
            }

            _ = c.SDL_SetRenderDrawColor(self.renderer, 255, 255, 255, 255);
            _ = c.SDL_RenderClear(self.renderer);

            try self.text_renderer.renderText("Text Browser - Press Ctrl+Q to quit", 10, 10);

            c.SDL_RenderPresent(self.renderer);
        }
    }
};
