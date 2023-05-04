function euclidean_distance(x1, y1, x2, y2)
	return math.sqrt((x2-x1)^2 + (y2-y1)^2)
end

local function on_player_selected_area(event)
    local player = game.players[event.player_index]

    for key, entity in pairs(player.surface.find_entities_filtered{area=event.area}) do
        -- initializing screen in the start of the loop so it resets every iteration
        local screen_element = player.gui.screen
        
        -- Get euclidean distance from player to entity
        d = euclidean_distance(entity.position.x, entity.position.y, player.position.x, player.position.y)

        -- If entity is outside of player reach, raise error
        if d > player.reach_distance then
            player.print("Item is too far!") -- Need a way for this to access localization file isntead of harcoded
        -- Otherwise mine it (force mining, even if inventory full)
        else
            local main_frame = screen_element.add{type='frame', name="msd_main_frame", caption={msd.test_message}}
            main_frame.style.size = {385, 165}
            main_grame.auto_center = true

            local content_frame = main_frame.add{type="frame", name="content_frame", direction="vertical", style="msd_content_frame"}
            local controls_flow = content_frame.add{type="flow", name="controls_flow", direction="horizontal", style="msd_controls_flow"}
            controls_flow.add{type="button", name="ugg_controls_toggle", caption={"msd.deactivate"}}


            script.on_event(defines.events.on_gui_click, function(event)
                if event.element.name == "msd_controls_toggle" then
                    local player_global = global.players[event.player_index]
                    player_global.controls_active = not player_global.controls_active
            
                    local control_toggle = event.element
                    control_toggle.caption = (player_global.controls_active) and {"msd.deactivate"} or {"msd.activate"}
                end
            end)
            -- player.mine_entity(entity, true)
        end
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

script.on_event("shortcut", handle_shortcut)

