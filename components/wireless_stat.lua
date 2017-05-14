require 'cairo'

local i3bar_util = require 'util'

return function(opt)
    local xpos = opt.x
    local ypos = opt.y

    -- text color
    local r, g, b, a
    local stat

    local iface = conky_parse('${gw_iface}')
    local essid = conky_parse('${wireless_essid '.. iface ..'}')
    local quality = conky_parse('${wireless_link_qual_perc '.. iface ..'}')
    local qn = tonumber(quality)

    local wireless_stat = {
        zero= "wireless_zero.svg";
        low="wireless_low.svg";
        mid= "wireless_mid.svg";
        full= "wireless_full.svg"
    }

    if (qn < 20) then
        stat = "zero"
    elseif (qn < 50) then
        stat = "low"
    elseif (qn < 80) then
        stat = "mid"
    else
        stat = "full"
    end

    i3bar_util.draw_svg({cr = opt.cr,
    x = xpos + 0, y = opt.y ,
    file = opt.RESOURCE_PATH .. wireless_stat[stat]})


    xpos = xpos + 80
    ypos = ypos + 25
    r, g, b, a = 0.9, 0.4, 0.4, 0.9
    cairo_move_to(opt.cr, xpos, ypos)
    cairo_select_font_face(
        opt.cr,
        opt.primary_font,
        opt.primary_font_slant,
        opt.primary_font_face)
    cairo_set_font_size(opt.cr, 20)
    cairo_set_source_rgba(opt.cr, r, g, b, a)
    cairo_show_text(opt.cr, iface.."("..essid..")")
    cairo_stroke(opt.cr)

    -- get the signal and display
    --
end
