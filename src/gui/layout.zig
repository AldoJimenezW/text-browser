// Import Modules
const std = @import("std");
const c = @cImport({
    @cInclude("SDL2/SDL.h");
});

pub const Rect = struct {
    x: i32,
    y: i32,
    width: i32,
    height: i32,
};

pub const Layout = struct {
    url_bar: Rect,
    content_area: Rect,
    status_bar: Rect,

    pub fn init(window_width: i32, window_height: i32) Layout {
        const url_bar_height = 30;
        const status_bar_height = 25;
        const content_height = window_height - (url_bar_height + status_bar_height);

        return Layout{
            .url_bar = Rect{
                .x = 0,
                .y = 0,
                .width = window_width,
                .height = url_bar_height,
            },
            .content_area = Rect{
                .x = 0,
                .y = url_bar_height,
                .width = window_width,
                .height = content_height,
            },
            .status_bar = Rect{
                .x = 0,
                .y = window_height - status_bar_height,
                .width = window_width,
                .height = status_bar_height,
            },
        };
    }
};
