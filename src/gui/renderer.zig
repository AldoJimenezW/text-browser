const std = @import("std");
const c = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("SDL2/SDL_ttf.h");
});

pub const TextRenderer = struct {
    font: *c.TTF_Font,
    renderer: *c.SDL_Renderer,

    pub fn init(renderer: *c.SDL_Renderer, font_size: i32) !TextRenderer {
        if (c.TTF_Init() < 0) {
            return error.TTFInitFailed;
        }

        const font = c.TTF_OpenFont("/usr/share/fonts/TTF/DejaVuSansMono.ttf", font_size) orelse {
            const err = c.TTF_GetError();
            const stderr = std.io.getStdErr().writer();
            try stderr.print("Font load failed: {s}\n", .{err});
            return error.FontLoadFailed;
        };

        return TextRenderer{
            .font = font,
            .renderer = renderer,
        };
    }
    pub fn deinit(self: *TextRenderer) void {
        c.TTF_CloseFont(self.font);
        c.TTF_Quit();
    }

    pub fn renderText(self: *TextRenderer, text: [*:0]const u8, x: i32, y: i32) !void {
        const color = c.SDL_Color{ .r = 0, .g = 0, .b = 0, .a = 255 };
        const surface = c.TTF_RenderText_Solid(self.font, text, color) orelse {
            return error.RenderFailed;
        };
        defer c.SDL_FreeSurface(surface);

        const texture = c.SDL_CreateTextureFromSurface(self.renderer, surface) orelse {
            return error.TextureCreationFailed;
        };
        defer c.SDL_DestroyTexture(texture);

        var rect = c.SDL_Rect{
            .x = x,
            .y = y,
            .w = surface.*.w,
            .h = surface.*.h,
        };

        _ = c.SDL_RenderCopy(self.renderer, texture, null, &rect);
    }
};
