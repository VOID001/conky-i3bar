require 'cairo'
local i3bar_util = require 'util'

-- show system load as bars
return function (opt)
    local xpos = opt.x
    local ypos = opt.y

    local r, g, b, a
    local bar_width = 160
    local bar_height = 5
    local bar_skewX  = 0.75

    -- fetch system load data
    local cpu_percent = conky_parse('${cpu cpu0}')
    local mem_percent = conky_parse('${memperc}')
    local mem_used = conky_parse('${mem}')
    local mem_total = conky_parse('${memmax}')

    -- draw small text 'sys'
    xpos = xpos + 130
    ypos = ypos + 20
    r, g, b, a = 0.9, 0.9, 0.9, 0.9
    cairo_move_to(opt.cr, xpos, ypos)
    cairo_select_font_face(
        opt.cr,
        opt.primary_font,
        opt.primary_font_slant,
        opt.primary_font_face)
    cairo_set_font_size(opt.cr, 20)
    cairo_set_source_rgba(opt.cr, r, g, b, a)
    cairo_show_text(opt.cr, 'system')
    cairo_stroke(opt.cr)

    xpos = xpos + 80
    ypos = ypos - 16
    i3bar_util.draw_svg({cr = opt.cr,
        x = xpos, y = ypos,
        file = opt.RESOURCE_PATH .. 'cpu-load-frame.svg'})

    -- bars
    xpos = xpos + 9
    ypos = ypos + 7
    r, g, b, a = 0.9, 0.9, 0.9, 0.6
    cairo_move_to(opt.cr, xpos, ypos)
    cairo_set_source_rgba(opt.cr, r, g, b, a)

    i3bar_util.keep_mat(opt.cr, function()
        i3bar_util.skewX(opt.cr, bar_skewX)
        cairo_rectangle(opt.cr, xpos, ypos, bar_width * cpu_percent * 0.01, bar_height)
        cairo_fill(opt.cr)
    end)

    xpos = xpos - 1
    ypos = ypos + 10
    r, g, b, a = 0.9, 0.9, 0.9, 0.6
    cairo_move_to(opt.cr, xpos, ypos)
    cairo_set_source_rgba(opt.cr, r, g, b, a)

    i3bar_util.keep_mat(opt.cr, function()
        i3bar_util.skewX(opt.cr, bar_skewX)
        cairo_rectangle(opt.cr, xpos, ypos, bar_width * mem_percent * 0.01, bar_height)
        cairo_fill(opt.cr)
    end)

    -- bar text
    xpos = xpos + 175
    ypos = ypos - 6
    r, g, b, a = 0.9, 0.9, 0.9, 0.9
    cairo_move_to(opt.cr, xpos, ypos)
    cairo_select_font_face(
        opt.cr,
        opt.primary_font,
        opt.primary_font_slant,
        opt.primary_font_face)
    cairo_set_font_size(opt.cr, 14)
    cairo_set_source_rgba(opt.cr, r, g, b, a)
    cairo_show_text(opt.cr, cpu_percent .. '%')
    cairo_stroke(opt.cr)

    xpos = xpos + 6
    ypos = ypos + 11
    cairo_move_to(opt.cr, xpos, ypos)
    cairo_show_text(opt.cr, mem_used .. '/' .. mem_total)
    cairo_stroke(opt.cr)
end
