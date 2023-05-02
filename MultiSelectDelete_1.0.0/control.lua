local function on_player_selected_area(event)
    local player = game.players[event.player_index]
    for key, entity in pairs(player.surface.find_entities_filtered{area=event.area,}) do
        player.mine_entity(entity, true)
    end
end

local function handle_shortcut(event)

    local player = game.players[event.player_index]
    
    -- Bring tool to cursor
    player.cursor_stack.set_stack({name="multiselect-delete", count=1})

    -- Upon selection, pass to selection handler
    script.on_event(defines.events.on_player_selected_area, on_player_selected_area)
end

    

script.on_event("shortcut", handle_shortcut)