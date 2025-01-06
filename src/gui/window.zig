// Import modules
const std = @import("std");
const c = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("SDL2/SDL_ttf.h");
});

// Adding rendering on ./renderer.zig and ./layout.zig
const TextRenderer = @import("renderer.zig").TextRenderer;
const Layout = @import("layout.zig").Layout;

// Building thw windows GUI
pub const Window = struct {
    window: *c.SDL_Window,
    renderer: *c.SDL_Renderer,
    text_renderer: TextRenderer,
    layout: Layout,
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

        var width: c_int = undefined;
        var height: c_int = undefined;
        c.SDL_GetWindowSize(window, &width, &height);
        const layout = Layout.init(width, height);

        return Window{
            .window = window,
            .renderer = renderer,
            .text_renderer = text_renderer,
            .layout = layout,
            .running = true,
        };
    }

    pub fn deinit(self: *Window) void {
        self.text_renderer.deinit();
        c.SDL_DestroyRenderer(self.renderer);
        c.SDL_DestroyWindow(self.window);
        c.SDL_Quit();
    }

    fn drawUrlBar(self: *Window) !void {
        const rect = c.SDL_Rect{
            .x = self.layout.url_bar.x,
            .y = self.layout.url_bar.y,
            .w = self.layout.url_bar.width,
            .h = self.layout.url_bar.height,
        };
        _ = c.SDL_SetRenderDrawColor(self.renderer, 240, 240, 240, 255);
        _ = c.SDL_RenderFillRect(self.renderer, &rect);
        try self.text_renderer.renderText("https://", 10, 5);
    }

    fn drawContentArea(self: *Window) !void {
        const rect = c.SDL_Rect{
            .x = self.layout.content_area.x,
            .y = self.layout.content_area.y,
            .w = self.layout.content_area.width,
            .h = self.layout.content_area.height,
        };
        _ = c.SDL_SetRenderDrawColor(self.renderer, 255, 255, 255, 255);
        _ = c.SDL_RenderFillRect(self.renderer, &rect);
    }

    fn drawStatusBar(self: *Window) !void {
        const rect = c.SDL_Rect{
            .x = self.layout.status_bar.x,
            .y = self.layout.status_bar.y,
            .w = self.layout.status_bar.width,
            .h = self.layout.status_bar.height,
        };
        _ = c.SDL_SetRenderDrawColor(self.renderer, 245, 245, 245, 255);
        _ = c.SDL_RenderFillRect(self.renderer, &rect);
        try self.text_renderer.renderText("Ready", 10, self.layout.status_bar.y + 5);
    }

    pub fn run(self: *Window) !void {
        while (self.running) {
            var event: c.SDL_Event = undefined;
            while (c.SDL_PollEvent(&event) != 0) {
                switch (event.type) {
                    c.SDL_QUIT => {
                        self.running = false;
                    },
                    c.SDL_WINDOWEVENT => {
                        if (event.window.event == c.SDL_WINDOWEVENT_RESIZED) {
                            self.layout = Layout.init(event.window.data1, event.window.data2);
                        }
                    },
                    else => {},
                }
            }

            _ = c.SDL_SetRenderDrawColor(self.renderer, 255, 255, 255, 255);
            _ = c.SDL_RenderClear(self.renderer);

            try self.drawUrlBar();
            try self.drawContentArea();
            try self.drawStatusBar();

            c.SDL_RenderPresent(self.renderer);
        }
    }
};
