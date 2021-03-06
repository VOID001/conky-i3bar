-- require Arch Package extra/lua-luajson

conky.config = {
  out_to_x = true,
  out_to_console = false,
  own_window = true,
  own_window_type = 'panel',
  own_window_class = 'Conky',
  own_window_hints = 'below,sticky,skip_taskbar,skip_pager',
  own_window_transparent = false,
  own_window_argb_visual = true,
  own_window_argb_value = 80, -- 80
  own_window_colour = nil,
  background = false, -- for debug
  double_buffer = true,
  use_xft = true,
  max_text_width = 50,
  draw_borders = true,
  draw_graph_borders = true,
  draw_outline = true,
  draw_shades = true,

  minimum_height = 35,

  -- trayer as panel, conky floats on it
  -- conky problem: panel not using complete screen width
  -- https://bbs.archlinux.org/viewtopic.php?id=102598
  minimum_width = 4000,
  -- maximum_width = ,
  border_inner_margin = 0,
  border_outer_margin = 0,
  border_width = 0,
  alignment = 'bl',
  gap_x = 0,
  gap_y = 0,

-- Update interval in seconds
  update_interval = 0.3,

-- This is the number of times Conky will update before quitting.
-- Set to zero to run forever.
  total_run_times = 0,

-- Shortens units to a single character (kiB->k, GiB->G, etc.). Default is off.
  short_units = false,

-- How strict should if_up be when testing an interface for being up?
-- The value is one of up, link or address, to check for the interface
-- being solely up, being up and having link or being up, having link
-- and an assigned IP address.
  if_up_strictness = 'address',

-- Add spaces to keep things from moving about?  This only affects certain objects.
-- use_spacer should have an argument of left, right, or none
  use_spacer = 'none',

-- Force UTF8? note that UTF8 support required XFT
  override_utf8_locale = true,

-- number of cpu samples to average
-- set to 1 to disable averaging
  cpu_avg_samples = 2,

  lua_load = '~/.config/conky/conky-i3bar/i3bar.lua',
  lua_draw_hook_post = 'i3bar',
  format_human_readable = true,
  -- font = "-misc-dejavu sans mono-bold-r-normal-*-17-120-0-100-m-0-iso10646-1"
};

conky.text = [[]]
