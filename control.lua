-- local players = {}

-- ---comment
-- ---@param this_player LuaPlayer
-- function singleplayer_join(this_player)
--     -- for k, v in pairs(this_player.force.technologies) do
--     --     v.enabled = false
--     -- end
-- end

-- function player_join(this_player)
--     log("test")
-- end

-- function player_leave(this_player)
--     log("uhhh")
-- end

-- script.on_event(defines.events.on_singleplayer_init, singleplayer_join)
-- script.on_event(defines.events.on_player_joined_game, player_join)
-- script.on_event(defines.events.on_player_left_game, player_leave)

-- local function disable_research()
--     for k, v in pairs(game.player.force.technologies) do
--         v.enabled = false
--     end

--     for k, v in pairs(game.player.force.technologies) do
--         log(v.enabled)
--     end
-- end

-- script.on_event(defines.events.on_singleplayer_init, disable_research)
-- script.on_event(defines.events.on_multiplayer_init, disable_research)



function entity_placed(event)
    ---@type LuaPlayer | nil
    local player = game.get_player(event.player_index)

    if not player then
        log("no player")
        return
    end

    ---@type LuaEntity
    local entity = event.entity

    if not entity then
        log("no entity")
    end

    player.add_alert(entity, defines.alert_type.entity_destroyed)
end

script.on_event(defines.events.on_built_entity, entity_placed)

local function disco_mode(player)
    local color = player.color
    if not color then return end
    color.r = color.r + 0.01
    if (color.r > 1) then
        color.r = math.random()
    end
    color.g = color.g + 0.01
    if (color.g > 1) then
        color.g = math.random()
    end
    color.b = color.b + 0.01
    if (color.b > 1) then
        color.b = math.random()
    end
    player.color = color
    player.tag   = "<disco>"
end

---comment
---@param player LuaPlayer
local function pollution_mess(player)
    local position = player.position
    if not position then return end
    player.surface.pollute(position, 10)
end

local rotation = 0

---comment
---@param player LuaPlayer
local function the_ring_of_fire(player)
    ---@type LuaSurface
    local surface = player.surface
    if not surface then return end
    local position = player.position
    if not position then return end

    rotation = rotation + 0.2

    if rotation > 6.28 then
        rotation = rotation - 6.28
    end

    local val = rotation

    for i = 1,16 do

        val = val + 0.3925

        position.x = position.x + (math.cos(val) * 1.2)
        position.y = position.y + (math.sin(val) * 1.2)

        local target_position = {
            x = position.x + (math.cos(val) * (30 + (i * 2))),
            y = position.y + (math.sin(val) * (30 + (i * 2)))
        }

        surface.create_entity({
            name = "flamethrower-fire-stream",
            position = position,
            source_position = position,
            target_position = target_position
        })
    end
end

local function on_tick()
    for _, player in pairs(game.connected_players) do
        if not player then goto continue end
        disco_mode(player)
        pollution_mess(player)
        the_ring_of_fire(player)

        ::continue::
    end
end

script.on_nth_tick(1, on_tick)
