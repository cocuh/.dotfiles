local common = require("myconfig.tag.common")
local awful = require("awful")

function get_tag_names(num_display)
  if num_display == 1 then
    local tag_names = awful.util.table.clone(common.tag_names_main)
    awful.util.table.merge(tag_names, common.tag_names_secondary)
    return {
      center = {
        names = tag_names,
        home = tag_names[1], -- "1"
        -- layout = awful.layout.suit.tile,
      },
    }
  elseif num_display == 2 then
    return {
      center = {
        names = common.tag_names_main,
        home  = common.tag_names_main[1],  -- "1"
        -- layout = awful.layout.suit.tile,
      },
      right = {
        names = common.tag_names_secondary,
        home  = common.tag_names_secondary[#common.tag_names_secondary], -- "="
      }
    }
  else
    return {
      center = {
        names = common.tag_names_main,
        home  = common.tag_names_main[1],  -- "1"
        -- layout = awful.layout.suit.tile,
      },
      right = {
        names = common.tag_names_secondary,
        home  = common.tag_names_secondary[#common.tag_names_secondary], -- "="
      }
    }
  end
end

return {
  get_tag_names = get_tag_names,
}
