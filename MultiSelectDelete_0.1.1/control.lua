script.on_init(function ()
    global.players = {}
end)

local function euclidean_distance(x1, y1, x2, y2)
	return math.sqrt((x2-x1)^2 + (y2-y1)^2)
end

local function clear_gui(player)
    local main_frame = player.gui.screen.msd_main_frame

    main_frame.destroy()
end

local function mine_area(player, selection_event)
    clear_gui(player)

    for key, entity in pairs(player.surface.find_entities_filtered{area=selection_event.area}) do
            player.mine_entity(entity, true)
    end
end

local function handle_gui(player, selection_event)
    -- Adding gui frame and title
    local screen_element = player.gui.screen
    local main_frame = screen_element.add{type='frame', name="msd_main_frame", caption={"msd.test_message"}}
    main_frame.style.size = {385, 165}
    main_frame.auto_center = true

    -- Adding content in main frame 
    local content_frame = main_frame.add{type="frame", name="content_frame", direction="vertical", style="msd_content_frame"}
    local mining_alert_message = content_frame.add{type="flow", name="mining_alert_message", direction="horizontal", style="msd_mining_alert_message"}
    local mining_toggle_button = content_frame.add{type="flow", name="mining_toggle_button", direction="horizontal", style="msd_mining_toggle_button"}

    mining_alert_message.add{type="label", name="msd_alert_message", caption={"msd.mine_alert"}}
    mining_toggle_button.add{type="button", name="msd_approve_button", caption={"msd.confirm"}}
    mining_toggle_button.add{type="button", name="msd_deny_button", caption={"msd.deny"}}
    
    script.on_event(defines.events.on_gui_click, function(event)
        if event.element.name == "msd_approve_button" then
            local player_global = global.players[event.player_index]
            player_global.controls_active = not player_global.controls_active

            mine_area(player, selection_event)
            return
        end

        if event.element.name == "msd_deny_button" then
            clear_gui(player)
        end
    end)

end

local function on_player_selected_area(event)
    local player = game.players[event.player_index]
    global.players[player.index] = { controls_active = true }
    local selection_area = event.area

    local distance = euclidean_distance(selection_area.right_bottom.x, selection_area.left_top.x, selection_area.right_bottom.y, selection_area.left_top.y)
    if distance > player.reach_distance then
        player.print{"msd.too_far"}
        return
    else
        handle_gui(player, event)
    return
    end
end

local function handle_shortcut(event)

    -- Get the player who triggered the event
    local player = game.players[event.player_index]
    
    -- Bring tool to cursor
    player.cursor_stack.set_stack({name="multiselect-delete", count=1})

    -- Upon selection, pass to selection handler
    script.on_event(defines.events.on_player_selected_area, on_player_selected_area)
end

-- If shortcut is hit, handle event
script.on_event("shortcut", handle_shortcut)