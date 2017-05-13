local util = require 'util'
local json = require 'json'
local http_request = require 'http.request'
local os = require 'os'
local io = require 'io'
commit = false
commit_of_day = 0

require 'cairo'

-- an component to remind your github little green dot :P
local gh_endpoint = "https://api.github.com"

return function (opt)
    local xpos = opt.x
    local ypos = opt.y + 27
    local r, g, b, a

    local f = assert(io.open(opt.RESOURCE_PATH.."/../.config.json", "r"))
    gh_cfg = json.decode(f:read("*all"))
    f:close()

    -- here we check github for repo stat
    -- only do it once a minute
    --
    -- github use UTC + 0 So I need to set offset 8 hours behind (I am UTC+8) to get the correct day
    today = os.date("%Y-%m-%d", os.time() - 8 * 60 * 60)
    tick = tonumber(conky_parse("${updates}"))

    if tick % 10 == 0 then -- do not make request too frequently
        commit_of_day = 0
        headers, stream = assert(http_request.new_from_uri(gh_endpoint .. "/users/".. gh_cfg["gh_user"] .. "/events?access_token=" .. gh_cfg["gh_token"]):go())
        body = stream:get_body_as_string()
        repos = json.decode(body)
        -- update the results
        for i, v in ipairs(repos) do
            print(v["type"])
            if v["type"] == "PushEvent" then 
                date = v["created_at"]
                idx = string.find(date, "T")
                date = string.sub(date, 0, idx - 1)
                -- today we have commits
                print(date)
                if date == today then
                    commit = true
                    commit_of_day = commit_of_day + tonumber(v["payload"]["size"])
                end
            end
        end
    end
    print(commit)


    if commit == false then
        -- Very big warning
        logo = ""
        text = "No commit!"
        r, g, b, a = 1, 1, 0, 1
    else
        logo = ""
        text = "Well done [" .. commit_of_day .. "] commit(s)."
        r, g, b, a = 0.9, 0.9, 0.9, 0.9
    end
    cairo_move_to(opt.cr, xpos, ypos)
    cairo_select_font_face(
    opt.cr,
    -- opt.primary_font,
    "FontAwesome",
    opt.primary_font_slant,
    opt.primary_font_face)
    cairo_set_font_size(opt.cr, 27)
    cairo_set_source_rgba(opt.cr, r, g, b, a)
    cairo_show_text(opt.cr, logo)
    cairo_stroke(opt.cr)

    cairo_move_to(opt.cr, xpos + 55, ypos)
    cairo_select_font_face(
    opt.cr,
    opt.primary_font,
    opt.primary_font_slant,
    opt.primary_font_face)
    cairo_set_source_rgba(opt.cr, r, g, b, a)
    cairo_show_text(opt.cr, text)
    cairo_stroke(opt.cr)
end
