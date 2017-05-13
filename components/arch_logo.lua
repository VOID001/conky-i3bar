local util = require 'util'

-- an Arch Linux logo <(=*/ω＼*=)>
return function (opt)
    util.draw_svg({cr = opt.cr,
              x = opt.x + 5, y = opt.y + 5,
              h = 30, w = 30,
              file = opt.RESOURCE_PATH .. 'arch-logo.svg'})
end
