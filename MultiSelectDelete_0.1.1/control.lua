script.on_init(function ()
    global.players = {}
end)

local function euclidean_distance(x1, y1, x2, y2)
	return math.sqrt((x2-x1)^2 + (y2-y1)^2)
end

local function handle_gui(player, screen_element, isMineable)
    -- Adding gui frame and title
    local main_frame = screen_element.add{type='frame', name="msd_main_frame", caption={"msd.test_message"}}
    main_frame.style.size = {385, 165}
    main_frame.auto_center = true

    -- Adding content in main frame 
    local content_frame = main_frame.add{type="frame", name="content_frame", direction="vertical", style="msd_content_frame"}
    local mining_alert_message = content_frame.add{type="flow", name="mining_alert_message", direction="horizontal", style="msd_mining_alert_message"}
    local mining_toggle_button = content_frame.add{type="flow", name="mining_toggle_button", direction="horizontal", style="msd_mining_toggle_button"}

    mining_alert_message.add{type="label", name="msd_alert_message", caption={"msd.mine_alert"}}
    mining_toggle_button.add{type="button", name="msd_controls_toggle", caption={"msd.confirm"}}

    -- TODO: Add approve and deny button for mining
    script.on_event(defines.events.on_gui_click, function(event)
        if event.element.name == "msd_controls_toggle" then
            local player_global = global.players[event.player_index]
            player_global.controls_active = not player_global.controls_active
    
            local control_toggle = event.element
            control_toggle.caption = (player_global.controls_active) and {"msd.deny"} or {"msd.confirm"}

            if isMineable then
                player.print("YOU CAN MINE")
            -- player.mine_entity(entity, true)
            end
        end
    end)
end

local function on_player_selected_area(event)
    local isMineable = false
    local isTooFar = false

    local player = game.players[event.player_index]
    global.players[player.index] = { controls_active = true }
    local screen_element = player.gui.screen

    for key, entity in pairs(player.surface.find_entities_filtered{area=event.area}) do
        -- Get euclidean distance from player to entity
        d = euclidean_distance(entity.position.x, entity.position.y, player.position.x, player.position.y)

        -- If entity is outside of player reach, raise error
        if d > player.reach_distance then
            player.print{"msd.too_far"} -- Need a way for this to access localization file isntead of harcoded
            isTooFar = true
        -- Otherwise mine it (force mining, even if inventory full)
        else
            isMineable = true
        end
    end

    if not isTooFar then
        handle_gui(player, screen_element, isMineable)
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