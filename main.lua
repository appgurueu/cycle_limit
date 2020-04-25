config = modlib.conf.import("cycle_limit", {
    type = "table",
    children = {
        name = {type = "string"},
        duration = {type = "number", range = {0}},
        color = {type = "string", func = function(num)
            if not tonumber(num, 16) then
                return "Expected hex color"
            end
        end}
    }
})

if config.duration == 0 then
    return
end

local players = {}

minetest.register_on_joinplayer(function(player)
    players[player:get_player_name()] = {
        index = player:get_wield_index()
    }
    local meta = player:get_meta()
    local taken = meta:get("cycle_limit_taken")
    if taken then
        taken = minetest.parse_json(taken)
        player:get_inventory():set_stack(player:get_wield_list(), taken[1], ItemStack(taken[2]))
        meta:set_string("cycle_limit_taken", "")
    end
end)

minetest.register_globalstep(function()
    for _, player in pairs(minetest.get_connected_players()) do
        local switching = players[player:get_player_name()]
        local index = player:get_wield_index()
        if index ~= switching.index and index ~= switching.target_index then
            if switching.item then
                local inv = player:get_inventory()
                inv:set_stack(player:get_wield_list(), switching.target_index, switching.item)
            end
            switching.item = player:get_wielded_item()
            if switching.timer then
                hud_timers.remove_timer_by_reference(player:get_player_name(), switching.timer)
            end
            switching.timer = hud_timers.add_timer(
                player:get_player_name(),
                {
                    name = config.name,
                    duration = config.duration,
                    color = config.color,
                    on_complete = function()
                        player:get_inventory():set_stack(player:get_wield_list(), switching.target_index, switching.item)
                        switching.item = nil
                        switching.timer = nil
                        switching.index = switching.target_index
                        switching.target_index = nil
                        player:get_meta():set_string("cycle_limit_taken", "")
                        player:hud_set_flags{wielditem = true}
                    end
                }
            )
            player:get_meta():set_string("cycle_limit_taken", minetest.write_json{index, switching.item:to_string()})
            player:set_wielded_item("")
            player:hud_set_flags{wielditem = false}
            switching.target_index = index
        end
    end
end)