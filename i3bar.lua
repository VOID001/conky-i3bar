-----------------------------------------------------------------------------------------
--            _         _                  _               _                   _       --
--           /\ \     /\ \                / /\            / /\                /\ \     --
--           \ \ \   /  \ \              / /  \          / /  \              /  \ \    --
--           /\ \_\ / /\ \ \            / / /\ \        / / /\ \            / /\ \ \   --
--          / /\/_// / /\ \ \          / / /\ \ \      / / /\ \ \          / / /\ \_\  --
--         / / /   \/_//_\ \ \        / / /\ \_\ \    / / /  \ \ \        / / /_/ / /  --
--        / / /      __\___ \ \      / / /\ \ \___\  / / /___/ /\ \      / / /__\/ /   --
--       / / /      / /\   \ \ \    / / /  \ \ \__/ / / /_____/ /\ \    / / /_____/    --
--   ___/ / /__    / /_/____\ \ \  / / /____\_\ \  / /_________/\ \ \  / / /\ \ \      --
--  /\__\/_/___\  /__________\ \ \/ / /__________\/ / /_       __\ \_\/ / /  \ \ \     --
--  \/_________/  \_____________\/\/_____________/\_\___\     /____/_/\/_/    \_\/     --
-----------------------------------------------------------------------------------------
-- This a Lua script for conky, aims to be a replacement of i3-wm's i3bar
-- It works well with trayer

require 'cairo'

local PROJECT_ROOT = debug.getinfo(1).source:match('@?(.*/)')
package.path = PROJECT_ROOT .. '?.lua;' .. package.path
local RESOURCE_PATH = PROJECT_ROOT .. 'resource/'

local i3bar_arch_logo = require 'components.arch_logo'
local i3bar_i3_workspace_indicator = require 'components.i3_workspace_indicator'
local i3bar_wireless_stat = require 'components.wireless_stat'
local i3bar_sys_load = require 'components.sys_load'
-- local i3bar_gpu_load = require 'components.gpu_load'
local i3bar_date_time = require 'components.date_time'
-- local i3bar_clementine_play = require 'components.clementine_play'
local i3bar_github_alert = require 'components.github_alert'

function conky_i3bar() -- luacheck: ignore conky_i3bar
    if conky_window == nil then
        return
    end

    local cs = cairo_xlib_surface_create(
        conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height)
    local cr = cairo_create(cs)
    local updates = tonumber(conky_parse('${updates}'))


    local primary_font = 'DejaVu Sans Mono'
    local primary_font_size = 20
    local primary_font_slant = CAIRO_FONT_SLANT_NORMAL
    local primary_font_face = CAIRO_FONT_WEIGHT_NORMAL

    local primary_font_options = cairo_font_options_create()
    cairo_font_options_set_antialias(primary_font_options, CAIRO_ANTIALIAS_SUBPIXEL)
    cairo_font_options_set_subpixel_order(primary_font_options, CAIRO_SUBPIXEL_ORDER_RGB)
    cairo_font_options_set_hint_style(primary_font_options, CAIRO_HINT_STYLE_FULL)
    cairo_font_options_set_hint_metrics(primary_font_options, CAIRO_HINT_METRICS_DEFAULT)
    cairo_set_font_options(cr, primary_font_options)

    local function draw_component(component_func, pos)
      -- pass essential variables to component_func
      return component_func{
        -- preset args
        PROJECT_ROOT = PROJECT_ROOT,
        RESOURCE_PATH = RESOURCE_PATH,
        cr = cr,
        cs = cs,
        primary_font = primary_font,
        primary_font_size = primary_font_size,
        primary_font_slant = primary_font_slant,
        primary_font_face = primary_font_face,

        -- position
        x = pos.x,
        y = pos.y
      }
    end -- function draw_component

    local dt = coroutine.create(draw_component) -- make date time align at the screen edge :P
    local al = coroutine.create(draw_component)
    local gh = coroutine.create(draw_component)
    local ws = coroutine.create(draw_component)
    local wi = coroutine.create(draw_component)
    local wi_stat = coroutine.create(draw_component)
    if updates>3 then -- start drawing
        coroutine.resume(al,i3bar_arch_logo, {x = 5, y = -1})
        coroutine.resume(wi, i3bar_i3_workspace_indicator, {x = 54, y = 0})
        coroutine.resume(wi_stat, i3bar_sys_load, {x = 220, y = 0})
        coroutine.resume(ws, i3bar_wireless_stat, {x = 800, y = 0})
        coroutine.resume(gh,i3bar_github_alert, {x = 1200, y = 0})
        coroutine.resume(dt, i3bar_date_time, {x = 2500, y = 0})
    end



    cairo_font_options_destroy(primary_font_options)
    cairo_surface_destroy(cs)
    cairo_destroy(cr)
    primary_font_options = nil
    cs = nil
    cr = nil
end -- function conky_i3bar
