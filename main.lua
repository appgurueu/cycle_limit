config = modlib.conf.import("cycle_limit", {
    type = "table",
    children = {
        name = {type = "string"},
        duration = {type = "number", range = {0}},
        color = {type = "string", func = function(num)
            if not tonumber(num, 16) then
                return "Expected hex color"
            end
        end},
        interact = {type = "boolean"}
    }
})

minetest.register_privilege("cycle_limit", {
    description = "Not affected by cycle limit",
    give_to_singleplayer = false,
    give_to_admin = true
})

local interact = config.interact

if interact then
    minetest.registered_privileges.interact.give_to_singleplayer = false
    minetest.register_privilege("interact_mods", {
        description = "Can be granted interact by mods",
        give_to_singleplayer = true,
        give_to_admin = true
    })
    function set_interact(player, value)
        if not minetest.check_player_privs(player, {interact_mods=true}) then
            return
        end
        local name = player:get_player_name()
        local privs = minetest.get_player_privs(name)
        privs.interact = value or nil
        minetest.set_player_privs(name, privs)
    end
end

if config.duration == 0 then
    return
end

local players = {}

minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    players[name] = {
        index = player:get_wield_index()
    }
    local meta = player:get_meta()
    local taken = meta:get("cycle_limit_taken")
    if taken then
        taken = minetest.parse_json(taken)
        player:get_inventory():set_stack(player:get_wield_list(), taken[1], ItemStack(taken[2]))
        meta:set_string("cycle_limit_taken", "")
    end
    if interact then
        local privs = minetest.get_player_privs(name)
        if privs.interact or privs.interact_mods then
            if not privs.interact_mods then
                privs.interact_mods = true
            elseif not privs.interact then
                privs.interact = true
            end
            minetest.set_player_privs(name, privs)
        end
    end
end)

minetest.register_on_leaveplayer(function(player)
    players[player:get_player_name()] = nil
end)

minetest.register_globalstep(function()
    for _, player in pairs(minetest.get_connected_players()) do

    if not minetest.check_player_privs(player, {cycle_limit=true}) then
        local name = player:get_player_name()
        local switching = players[name]
        local index = player:get_wield_index()
        if index ~= switching.index and index ~= switching.target_index then
            if switching.item then
                local inv = player:get_inventory()
                if not interact then
                    inv:set_stack(player:get_wield_list(), switching.target_index, switching.item)
                end
            end
            switching.item = player:get_wielded_item()
            if switching.timer then
                hud_timers.remove_timer_by_reference(name, switching.timer)
            end
            switching.timer = hud_timers.add_timer(
                player:get_player_name(),
                {
                    name = config.name,
                    duration = config.duration,
                    color = config.color,
                    on_complete = function()
                        -- player might have left in the meantime
                        if not players[name] then
                            return
                        end
                        if interact then
                            set_interact(player, true)
                        else
                            player:get_inventory():set_stack(player:get_wield_list(), switching.target_index, switching.item)
                        end
                        switching.item = nil
                        switching.timer = nil
                        switching.index = switching.target_index
                        switching.target_index = nil
                        player:get_meta():set_string("cycle_limit_taken", "")
                        player:hud_set_flags{wielditem = true}
                    end
                }
            )
            if interact then
                set_interact(player)
            else
                player:get_meta():set_string("cycle_limit_taken", minetest.write_json{index, switching.item:to_string()})
                player:set_wielded_item("")
            end
            player:hud_set_flags{wielditem = false}
            switching.target_index = index
        end
    end

    end
end)