local json = require 'json'

local i3bar_util = require 'util'

-- i3-wm workspace indicator
-- for i3 wm configured with 10 total workspaces (i3's default)
return function (opt)
    local xpos = opt.x
    local ypos = opt.y
    local hostpos

    -- text color
    local r, g, b, a

    -- fetch i3 wm workspace information
    local workspacesData = conky_parse('${exec i3-msg -t get_workspaces}')
    local new_workspaces = json.decode(workspacesData) or {}
    local workspaces = {}
    local present_workspace_number = 0

    for i = 1, 10 do
        workspaces[i] = nil
    end

    for _, w in ipairs(new_workspaces) do
        workspaces[w['num']] = {
            ['num'] = w['num'],
            ['visible'] = w['visible'],
            ['urgent'] = w['urgent']
        }
    end

    -- draw small text 'workspace'
    hostpos = ypos + 27
    ypos = ypos + 24
    r, g, b, a = 0.9, 0.9, 0.9, 0.9
    cairo_move_to(opt.cr, xpos, hostpos)
    cairo_select_font_face(
        opt.cr,
        opt.primary_font,
        opt.primary_font_slant,
        opt.primary_font_face)
    cairo_set_font_size(opt.cr, 20)
    cairo_set_source_rgba(opt.cr, r, g, b, a)
    cairo_show_text(opt.cr, 'ShakuganNoArch')
    cairo_stroke(opt.cr)

    xpos = xpos + 190
    ypos = ypos - 15
    i3bar_util.draw_svg({cr = opt.cr,
        x = xpos, y = ypos,
        file = opt.RESOURCE_PATH .. 'workspace-frame.svg'})

    xpos = xpos + 36
    -- upper indicator
    for i = 1,5 do
        -- shift right
        xpos = xpos + 10
        if workspaces[i] == nil then
            -- empty workspace
            i3bar_util.draw_svg({cr = opt.cr,
            x = xpos, y = ypos,
            file = opt.RESOURCE_PATH .. 'workspace-upper_empty.svg'})
        else
            if workspaces[i]['urgent'] == true then
                -- urgent
                i3bar_util.draw_svg({cr = opt.cr,
                x = xpos, y = ypos,
                file = opt.RESOURCE_PATH .. 'workspace-upper_urgent.svg'})
            elseif workspaces[i]['visible'] == true then
                -- present
                present_workspace_number = i
                i3bar_util.draw_svg({cr = opt.cr,
                x = xpos, y = ypos,
                file = opt.RESOURCE_PATH .. 'workspace-upper_present.svg'})
            else
                -- normal
                i3bar_util.draw_svg({cr = opt.cr,
                x = xpos, y = ypos,
                file = opt.RESOURCE_PATH .. 'workspace-upper_normal.svg'})
            end
        end
    end

    xpos = xpos - 50
    ypos = ypos + 14
    -- lower indicator
    for i = 6,10 do
        xpos = xpos + 9
        if workspaces[i] == nil then
            -- empty workspace
            i3bar_util.draw_svg({cr = opt.cr,
            x = xpos, y = ypos,
            file = opt.RESOURCE_PATH .. 'workspace-lower_empty.svg'})
        else
            if workspaces[i]['urgent'] == true then
                -- urgent
                i3bar_util.draw_svg({cr = opt.cr,
                x = xpos, y = ypos,
                file = opt.RESOURCE_PATH .. 'workspace-lower_urgent.svg'})
            elseif workspaces[i]['visible'] == true then
                -- present
                present_workspace_number = i
                i3bar_util.draw_svg({cr = opt.cr,
                x = xpos, y = ypos,
                file = opt.RESOURCE_PATH .. 'workspace-lower_present.svg'})
            else
                -- normal
                i3bar_util.draw_svg({cr = opt.cr,
                x = xpos, y = ypos,
                file = opt.RESOURCE_PATH .. 'workspace-lower_normal.svg'})
            end
        end
    end

    xpos = xpos - 58
    ypos = ypos + 4

    -- display workspace 10 as workspace 0
    -- if present_workspace_number == 10 then
    --   present_workspace_number = 10
    -- end

    local number_map = {"", "", "", "4", "5", "6", "7", "8", "9", "X"}

    r, g, b, a = 1, 1, 1, 1
    cairo_move_to(opt.cr, xpos - 3, ypos)
    cairo_select_font_face(
        opt.cr,
        -- opt.primary_font,
        "FontAwesome",
        opt.primary_font_slant,
        opt.primary_font_face)
    cairo_set_font_size(opt.cr, opt.primary_font_size)
    cairo_set_source_rgba(opt.cr, r, g, b, a)
    if present_workspace_number < 4 then
        cairo_show_text(opt.cr, number_map[present_workspace_number])
    else
    cairo_move_to(opt.cr, xpos - 1, ypos)
    cairo_select_font_face(
        opt.cr,
        opt.primary_font,
        opt.primary_font_slant,
        opt.primary_font_face)
        cairo_show_text(opt.cr, number_map[present_workspace_number])
    end


    cairo_stroke(opt.cr)

end
