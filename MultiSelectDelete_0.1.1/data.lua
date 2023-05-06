local multiselector_tool = {
    type = "selection-tool",
    name = "multiselect-delete",
    subgroup = "tool",
    icons = {
      {
        icon = "__MultiSelectDelete__/graphics/icons/selection.png",
        icon_size = 32,
      }
    },
    flags = {"only-in-cursor", "hidden"}, -- Makes sure that not added to inventory
    stack_size = 1,
    stackable = false,
    selection_color = {r = 1, g = 0, b = 0, a = 1},
    alt_selection_color = {r = 1, g = 0, b = 0, a = 1},
    selection_mode = {"items"},
    alt_selection_mode = {"items"},
    selection_cursor_box_type = "not-allowed",
    alt_selection_cursor_box_type = "not-allowed",
  }

  -- TODO: I think we need to add this to settings
local tool_shortcut = {
  type = "custom-input",
  name = "shortcut", -- this is the name of the event raised
  key_sequence = "CONTROL + E",
  action = "lua" 
}

data:extend({multiselector_tool, tool_shortcut})

local styles = data.raw["gui-style"].default

styles["msd_content_frame"] = {
  type = "frame_style",
  parent = "inside_shallow_frame_with_padding",
  vertically_stretchable = "on"
}

styles["msd_mining_alert_message"] = {
  type = "horizontal_flow_style",
  vertical_align = "center",
  horizontal_spacing = 16
}

styles["msd_mining_toggle_button"] = {
  type = "horizontal_flow_style",
  vertical_align = "center",
  horizontal_spacing = 16
}
