function euclidean_distance(x1, y1, x2, y2)
	return math.sqrt((x2-x1)^2 + (y2-y1)^2)
end

local function on_player_selected_area(event)
    local player = game.players[event.player_index]

    for key, entity in pairs(player.surface.find_entities_filtered{area=event.area}) do
        
        -- Get euclidean distance from player to entity
        d = euclidean_distance(entity.position.x, entity.position.y, player.position.x, player.position.y)

        -- If entity is more than 2 * reach away, raise error
        if d >= 2*player.reach_distance then
            player.print("Item is too far!") -- Need a way for this to access localization file isntead of harcoded
        -- Otherwise mine it
        else
            player.mine_entity(entity, true)
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

