--[[
武器和挖掘用的稿子根据使用次数升级
护甲根据收到的伤害总量升级
]]

require("function")


local ExpTable =
{
    {"small-biter", 0.01, 1},
    {"small-spitter", 0.01, 1},
    {"small-worm-turret", 0.01, 1},
    {"medium-biter", 0.02, 2},
    {"medium-spitter", 0.02, 2},
    {"medium-worm-turret", 0.02, 2},
    {"big-biter", 0.04, 4},
    {"big-spitter", 0.04, 4},
    {"big-worm-turret", 0.04, 4},
    {"behemoth-biter", 0.06, 6},
    {"behemoth-spitter", 0.06, 6},
    {"biter-spawner", 0.06, 6},
    {"spitter-spawner", 0.06, 6}
}

function OnInit()
    if global.rpg == nil then
        global.rpg={}
        global.players={}
        global.rpg.players={}
        for i=1,#game.players do
            CreateGui(i)
        end
    end
end

function OnLoad()
    OnInit()
end

function OnPlayerCreated(event)
    local index = event.player_index
    CreateGui(index)
end

function CreateGui(index)

    -- local index = event.player_index
    local player = game.players[index]
    if player.gui.left.rpg then
        return
    end
    table.insert(global.players, player)
    table.insert(
        global.rpg.players,
        {
            lv=1,
            exp=0,
            mp=100,
            point=0,
            crafting_speed=0,
            mining_speed=0,
            running_speed=0,
            build_distance=0,
            item_drop_distance=0,
            reach_distance=0,
            resource_reach_distance=0,
            item_pickup_distance=0,
            loot_pickup_distance=0,
            quickbar_count=0,
            inventory_slots=0,
            logistic_slot_count=0,
            trash_slot_count=0,
            following_robots=0,
            health=0
        }
    )
    --local global.rpg.players[event.player_index].exp=0
    --/c game.player.gui.left.rpg.layout1.label1_4.caption = "000"    
    local root = player.gui.left.add{
        type = "frame",
        name = "rpg",
        direction = "vertical", --horizontal
        column_count = 1
    }
    root.style.top_padding = 4
    root.style.bottom_padding = 4
    root.style.minimal_width = 230
--    root.style.maximal_width = 230
    local layout1 = root.add{
        type = "table",
        name = "layout1",
        column_count = 3
    }
    local label1_1 = layout1.add{
        type = "label",
        name = "label1_1",
        style = "caption_label",
        caption = player.name
    }
    local label1_2 = layout1.add{
        type = "label",
        name = "label1_2",
        caption = {"property.exp"}
    }
    local label1_3 = layout1.add{
        type = "progressbar",
        name = "label1_3",
        size = 100,
        value = 0
    }
    label1_3.style.color = { r=1, g=0.74, b=0.40 }
    local label1_4 = layout1.add{
        type = "label",
        name = "label1_4",
        caption = {"property.lv", "1"}
    }
    local label1_5 = layout1.add{
        type = "label",
        name = "label1_5",
        caption = {"property.hp"}
    }
    local label1_6 = layout1.add{
        type = "progressbar",
        name = "label1_6",
        size = player.character.prototype.max_health,
        value = player.character.health/player.character.prototype.max_health
    }
    label1_6.style.color = { r=0, g=1, b=0 }
    local button_frame = layout1.add{
        type = "table",
        name = "button_frame",
        column_count = 2
    }
    button_frame.style.minimal_width = 40
    button_frame.style.minimal_height = 17
    button_frame.style.maximal_width = 40
    button_frame.style.maximal_height = 17
    local Rpg_Gui_Hide = button_frame.add{
        type = "button",
        name = "gui_hide",
        parent = "RpgGUI_button_with_icon",
        style = "RpgGUI_hide",
        tooltip = {"property.gui_hide"}
    }
    Rpg_Gui_Hide.style.visible = false
    local Rpg_Gui_Show = button_frame.add{
        type = "button",
        name = "gui_show",
        parent = "RpgGUI_button_with_icon",
        style = "RpgGUI_show",
        tooltip = {"property.gui_show"}
    }
    local Rpg_Option = button_frame.add{
        type = "button",
        name = "gui_settings",
        parent = "RpgGUI_button_with_icon",
        style = "RpgGUI_settings",
        tooltip = {"property.gui_settings"}
    }
    local label1_8 = layout1.add{
        type = "label",
        name = "label1_8",
        caption = {"property.mp"}
    }
    local label1_9 = layout1.add{
        type = "progressbar",
        name = "label1_9",
        size = 100,
        value = 100/100
    }
    label1_9.style.color = { r=0.24, g=0.40, b=0.74 }
    local layout2 = root.add{
        type = "table",
        name = "layout2",
        column_count = 3
    }
    layout2.style.visible = false
    local label2_1 = layout2.add{
        type = "label",
        name = "label2_1",
        style = "large_caption_label",
        caption = {"property.point_label"}
    }
    label2_1.style.font_color = { r=0.7, g=1, b=0.7 }
    local label2_2 = layout2.add{
        type = "label",
        name = "label2_2",
        style = "large_caption_label",
        caption = "0"
    }
    label2_2.style.font_color = { r=1, g=0.7, b=0.7 }
    local label2_3 = layout2.add{
        type = "label",
        name = "label2_3",
        style = "large_caption_label",
        caption = {"property.unit_point"}
    }
    label2_3.style.font_color = { r=1, g=0.7, b=0.7 }
    
    local layout3 = root.add{
        type = "table",
        name = "layout3",
        column_count = 6
    }
    layout3.style.visible = false
    local label3_1_1 = layout3.add{
        type = "label",
        name = "label3_1_1",
        style = "caption_label",
        caption = {"property.crafting_speed_label"}
    }
    local label3_1_2 = layout3.add{
        type = "label",
        name = "label3_1_2",
        caption = "+"
    }
    local label3_1_3 = layout3.add{
        type = "label",
        name = "label3_1_3",
        caption = "0"
    }
    local label3_1_4 = layout3.add{
        type = "label",
        name = "label3_1_4",
        style = "caption_label",
        caption = {"property.unit_percent"}
    }
    local label3_1_5 = layout3.add{
        type = "label",
        name = "label3_1_5",
        style = "caption_label",
        caption = "(1)"
    }
    label3_1_5.style.font_color = { r=1, g=0.6, b=0.6 }
    local upgrade_button1 = layout3.add{
        type = "button",
        name = "crafting_speed",
        parent = "slot_button",
        --align = "right",
        caption = {"property.upgrade_button"}
    }
    
    local label3_2_1 = layout3.add{
        type = "label",
        name = "label3_2_1",
        style = "caption_label",
        caption = {"property.mining_speed_label"}
    }
    local label3_2_2 = layout3.add{
        type = "label",
        name = "label3_2_2",
        caption = "+"
    }
    local label3_2_3 = layout3.add{
        type = "label",
        name = "label3_2_3",
        caption = "0"
    }
    local label3_2_4 = layout3.add{
        type = "label",
        name = "label3_2_4",
        style = "caption_label",
        caption = {"property.unit_percent"}
    }
    local label3_2_5 = layout3.add{
        type = "label",
        name = "label3_2_5",
        style = "caption_label",
        caption = "(1)"
    }
    label3_2_5.style.font_color = { r=1, g=0.6, b=0.6 }
    local upgrade_button2 = layout3.add{
        type = "button",
        name = "mining_speed",
        parent = "slot_button",
        --align = "right",
        caption = {"property.upgrade_button"}
    }
    
    local label3_3_1 = layout3.add{
        type = "label",
        name = "label3_3_1",
        style = "caption_label",
        caption = {"property.running_speed_label"}
    }
    local label3_3_2 = layout3.add{
        type = "label",
        name = "label3_3_2",
        caption = "+"
    }
    local label3_3_3 = layout3.add{
        type = "label",
        name = "label3_3_3",
        caption = "0"
    }
    local label3_3_4 = layout3.add{
        type = "label",
        name = "label3_3_4",
        style = "caption_label",
        caption = {"property.unit_percent"}
    }
    local label3_3_5 = layout3.add{
        type = "label",
        name = "label3_3_5",
        style = "caption_label",
        caption = "(1)"
    }
    label3_3_5.style.font_color = { r=1, g=0.6, b=0.6 }
    local upgrade_button3 = layout3.add{
        type = "button",
        name = "running_speed",
        parent = "slot_button",
        --align = "right",
        caption = {"property.upgrade_button"}
    }
    
    local label3_4_1 = layout3.add{
        type = "label",
        name = "label3_4_1",
        style = "caption_label",
        caption = {"property.build_distance_label"}
    }
    local label3_4_2 = layout3.add{
        type = "label",
        name = "label3_4_2",
        caption = "+"
    }
    local label3_4_3 = layout3.add{
        type = "label",
        name = "label3_4_3",
        caption = "0"
    }
    local label3_4_4 = layout3.add{
        type = "label",
        name = "label3_4_4",
        style = "caption_label",
        caption = {"property.unit_grid"}
    }
    local label3_4_5 = layout3.add{
        type = "label",
        name = "label3_4_5",
        style = "caption_label",
        caption = "(5)"
    }
    label3_4_5.style.font_color = { r=1, g=0.6, b=0.6 }
    local upgrade_button4 = layout3.add{
        type = "button",
        name = "build_distance",
        parent = "slot_button",
        --align = "right",
        caption = {"property.upgrade_button"}
    }
    
    local label3_5_1 = layout3.add{
        type = "label",
        name = "label3_5_1",
        style = "caption_label",
        caption = {"property.item_drop_distance_label"}
    }
    local label3_5_2 = layout3.add{
        type = "label",
        name = "label3_5_2",
        caption = "+"
    }
    local label3_5_3 = layout3.add{
        type = "label",
        name = "label3_5_3",
        caption = "0"
    }
    local label3_5_4 = layout3.add{
        type = "label",
        name = "label3_5_4",
        style = "caption_label",
        caption = {"property.unit_grid"}
    }
    local label3_5_5 = layout3.add{
        type = "label",
        name = "label3_5_5",
        style = "caption_label",
        caption = "(5)"
    }
    label3_5_5.style.font_color = { r=1, g=0.6, b=0.6 }
    local upgrade_button5 = layout3.add{
        type = "button",
        name = "item_drop_distance",
        parent = "slot_button",
        --align = "right",
        caption = {"property.upgrade_button"}
    }
    
     local label3_6_1 = layout3.add{
        type = "label",
        name = "label3_6_1",
        style = "caption_label",
        caption = {"property.reach_distance_label"}
    }
    local label3_6_2 = layout3.add{
        type = "label",
        name = "label3_6_2",
        caption = "+"
    }
    local label3_6_3 = layout3.add{
        type = "label",
        name = "label3_6_3",
        caption = "0"
    }
    local label3_6_4 = layout3.add{
        type = "label",
        name = "label3_6_4",
        style = "caption_label",
        caption = {"property.unit_grid"}
    }
    local label3_6_5 = layout3.add{
        type = "label",
        name = "label3_6_5",
        style = "caption_label",
        caption = "(5)"
    }
    label3_6_5.style.font_color = { r=1, g=0.6, b=0.6 }
    local upgrade_button4 = layout3.add{
        type = "button",
        name = "reach_distance",
        parent = "slot_button",
        --align = "right",
        caption = {"property.upgrade_button"}
    }
    
     local label3_7_1 = layout3.add{
        type = "label",
        name = "label3_7_1",
        style = "caption_label",
        caption = {"property.resource_reach_distance_label"}
    }
    local label3_7_2 = layout3.add{
        type = "label",
        name = "label3_7_2",
        caption = "+"
    }
    local label3_7_3 = layout3.add{
        type = "label",
        name = "label3_7_3",
        caption = "0"
    }
    local label3_7_4 = layout3.add{
        type = "label",
        name = "label3_7_4",
        style = "caption_label",
        caption = {"property.unit_grid"}
    }
    local label3_7_5 = layout3.add{
        type = "label",
        name = "label3_7_5",
        style = "caption_label",
        caption = "(5)"
    }
    label3_7_5.style.font_color = { r=1, g=0.6, b=0.6 }
    local upgrade_button7 = layout3.add{
        type = "button",
        name = "resource_reach_distance",
        parent = "slot_button",
        --align = "right",
        caption = {"property.upgrade_button"}
    }
    
     local label3_8_1 = layout3.add{
        type = "label",
        name = "label3_8_1",
        style = "caption_label",
        caption = {"property.item_pickup_distance_label"}
    }
    local label3_8_2 = layout3.add{
        type = "label",
        name = "label3_8_2",
        caption = "+"
    }
    local label3_8_3 = layout3.add{
        type = "label",
        name = "label3_8_3",
        caption = "0"
    }
    local label3_8_4 = layout3.add{
        type = "label",
        name = "label3_8_4",
        style = "caption_label",
        caption = {"property.unit_grid"}
    }
    local label3_8_5 = layout3.add{
        type = "label",
        name = "label3_8_5",
        style = "caption_label",
        caption = "(5)"
    }
    label3_8_5.style.font_color = { r=1, g=0.6, b=0.6 }
    local upgrade_button8 = layout3.add{
        type = "button",
        name = "item_pickup_distance",
        parent = "slot_button",
        --align = "right",
        caption = {"property.upgrade_button"}
    }
    
     local label3_9_1 = layout3.add{
        type = "label",
        name = "label3_9_1",
        style = "caption_label",
        caption = {"property.loot_pickup_distance_label"}
    }
    local label3_9_2 = layout3.add{
        type = "label",
        name = "label3_9_2",
        caption = "+"
    }
    local label3_9_3 = layout3.add{
        type = "label",
        name = "label3_9_3",
        caption = "0"
    }
    local label3_9_4 = layout3.add{
        type = "label",
        name = "label3_9_4",
        style = "caption_label",
        caption = {"property.unit_grid"}
    }
    local label3_9_5 = layout3.add{
        type = "label",
        name = "label3_9_5",
        style = "caption_label",
        caption = "(5)"
    }
    label3_9_5.style.font_color = { r=1, g=0.6, b=0.6 }
    local upgrade_button9 = layout3.add{
        type = "button",
        name = "loot_pickup_distance",
        parent = "slot_button",
        --align = "right",
        caption = {"property.upgrade_button"}
    }
    
     local label3_10_1 = layout3.add{
        type = "label",
        name = "label3_10_1",
        style = "caption_label",
        caption = {"property.quickbar_count_label"}
    }
    local label3_10_2 = layout3.add{
        type = "label",
        name = "label3_10_2",
        caption = "+"
    }
    local label3_10_3 = layout3.add{
        type = "label",
        name = "label3_10_3",
        caption = "0"
    }
    local label3_10_4 = layout3.add{
        type = "label",
        name = "label3_10_4",
        style = "caption_label",
        caption = {"property.unit_row"}
    }
    local label3_10_5 = layout3.add{
        type = "label",
        name = "label3_10_5",
        style = "caption_label",
        caption = "(80)"
    }
    label3_10_5.style.font_color = { r=1, g=0.6, b=0.6 }
    local upgrade_button10 = layout3.add{
        type = "button",
        name = "quickbar_count",
        parent = "slot_button",
        --align = "right",
        caption = {"property.upgrade_button"}
    }
    
     local label3_11_1 = layout3.add{
        type = "label",
        name = "label3_11_1",
        style = "caption_label",
        caption = {"property.inventory_slots_label"}
    }
    local label3_11_2 = layout3.add{
        type = "label",
        name = "label3_11_2",
        caption = "+"
    }
    local label3_11_3 = layout3.add{
        type = "label",
        name = "label3_11_3",
        caption = "0"
    }
    local label3_11_4 = layout3.add{
        type = "label",
        name = "label3_11_4",
        style = "caption_label",
        caption = {"property.unit_grid"}
    }
    local label3_11_5 = layout3.add{
        type = "label",
        name = "label3_11_5",
        style = "caption_label",
        caption = "(10)"
    }
    label3_11_5.style.font_color = { r=1, g=0.6, b=0.6 }
    local upgrade_button11 = layout3.add{
        type = "button",
        name = "inventory_slots",
        parent = "slot_button",
        --align = "right",
        caption = {"property.upgrade_button"}
    }
    
     local label3_12_1 = layout3.add{
        type = "label",
        name = "label3_12_1",
        style = "caption_label",
        caption = {"property.logistic_slot_count_label"}
    }
    local label3_12_2 = layout3.add{
        type = "label",
        name = "label3_12_2",
        caption = "+"
    }
    local label3_12_3 = layout3.add{
        type = "label",
        name = "label3_12_3",
        caption = "0"
    }
    local label3_12_4 = layout3.add{
        type = "label",
        name = "label3_12_4",
        style = "caption_label",
        caption = {"property.unit_grid"}
    }
    local label3_12_5 = layout3.add{
        type = "label",
        name = "label3_12_5",
        style = "caption_label",
        caption = "(8)"
    }
    label3_12_5.style.font_color = { r=1, g=0.6, b=0.6 }
    local upgrade_button12 = layout3.add{
        type = "button",
        name = "logistic_slot_count",
        parent = "slot_button",
        --align = "right",
        caption = {"property.upgrade_button"}
    }
    
     local label3_13_1 = layout3.add{
        type = "label",
        name = "label3_13_1",
        style = "caption_label",
        caption = {"property.trash_slot_count_label"}
    }
    local label3_13_2 = layout3.add{
        type = "label",
        name = "label3_13_2",
        caption = "+"
    }
    local label3_13_3 = layout3.add{
        type = "label",
        name = "label3_13_3",
        caption = "0"
    }
    local label3_13_4 = layout3.add{
        type = "label",
        name = "label3_13_4",
        style = "caption_label",
        caption = {"property.unit_grid"}
    }
    local label3_13_5 = layout3.add{
        type = "label",
        name = "label3_13_5",
        style = "caption_label",
        caption = "(8)"
    }
    label3_13_5.style.font_color = { r=1, g=0.6, b=0.6 }
    local upgrade_button13 = layout3.add{
        type = "button",
        name = "trash_slot_count",
        parent = "slot_button",
        --align = "right",
        caption = {"property.upgrade_button"}
    }
    
     local label3_14_1 = layout3.add{
        type = "label",
        name = "label3_14_1",
        style = "caption_label",
        caption = {"property.following_robots_label"}
    }
    local label3_14_2 = layout3.add{
        type = "label",
        name = "label3_14_2",
        caption = "+"
    }
    local label3_14_3 = layout3.add{
        type = "label",
        name = "label3_14_3",
        caption = "0"
    }
    local label3_14_4 = layout3.add{
        type = "label",
        name = "label3_14_4",
        style = "caption_label",
        caption = "个"
    }
    local label3_14_5 = layout3.add{
        type = "label",
        name = "label3_14_5",
        style = "caption_label",
        caption = "(20)"
    }
    label3_14_5.style.font_color = { r=1, g=0.6, b=0.6 }
    local upgrade_button14 = layout3.add{
        type = "button",
        name = "following_robots",
        parent = "slot_button",
        --align = "right",
        caption = {"property.upgrade_button"}
    }
    
     local label3_15_1 = layout3.add{
        type = "label",
        name = "label3_15_1",
        style = "caption_label",
        caption = {"property.health_label"}
    }
    local label3_15_2 = layout3.add{
        type = "label",
        name = "label3_15_2",
        caption = "+"
    }
    local label3_15_3 = layout3.add{
        type = "label",
        name = "label3_15_3",
        caption = "0"
    }
    local label3_15_4 = layout3.add{
        type = "label",
        name = "label3_15_4",
        style = "caption_label",
        caption = {"property.mhp"}
    }
    local label3_15_5 = layout3.add{
        type = "label",
        name = "label3_15_5",
        style = "caption_label",
        caption = "(1)"
    }
    label3_15_5.style.font_color = { r=1, g=0.6, b=0.6 }
    local upgrade_button15 = layout3.add{
        type = "button",
        name = "health",
        parent = "slot_button",
        --align = "right",
        caption = {"property.upgrade_button"}
    }
     
end

-------------------------------------------------------------------------
function OnTick(event)
--    surface = game.surfaces[1]
    if game.tick % 20 ~= 0 then
        return
    end
    for i,p in pairs(global.players) do
        if p.character then
            p.gui.left.rpg.layout1.label1_6.value = p.character.health/p.character.prototype.max_health
            global.rpg.players[i].mp = p.gui.left.rpg.layout1.label1_9.value*100
            if game.tick % 60 == 0 then
                if p.gui.left.rpg.layout1.label1_9.value < 1 then
                    p.gui.left.rpg.layout1.label1_9.value = p.gui.left.rpg.layout1.label1_9.value +0.01
                end
            end
            local player = p
        end
    end
end

function OnEntityDied(event)
    if not event.cause then
        return
    end
    if event.cause.type == "player" then
        for i,p in pairs(game.players) do
            if p.name == event.cause.player.name then
                index = i
            end
        end
        for i, n in pairs(ExpTable) do
            if event.entity.name == n[1] then
                AddExp(index, n[2], {"", {"property.killing"}, " ", {"entity-name."..n[1]}, " ", {"property.experience"}, "+", n[2] * 100})
            end
        end
    end
    --玩家死亡扣经验
end

function onPlayerCraftedItem(event)
    local index = event.player_index
    local player = global.rpg.players[index]
    local Ingredient = event.recipe.ingredients
    local tmpExp = 0
    for i,item in pairs(Ingredient) do
        if item.type == "item" then
            tmpExp = tmpExp + (item.amount / (100+player.lv))
        end
        if item.type == "fluid" then
            tmpExp = tmpExp + (item.amount / (1000+player.lv))
        end
    end
    AddExp(index, tmpExp, {"", {"property.crafting"}, " ", event.recipe.localised_name, " ", {"property.experience"}, "+", string.format("%.2f", (tmpExp * 100))})
end

function OnPlayerRespawned(event)
    local index = event.player_index
    Refresh(index)
end

function Refresh(index)
    local player = game.players[index]
    player.character_crafting_speed_modifier = global.rpg.players[index].crafting_speed
    player.character_mining_speed_modifier  = global.rpg.players[index].mining_speed
    player.character_running_speed_modifier  = global.rpg.players[index].running_speed
    player.character_build_distance_bonus  = global.rpg.players[index].build_distance
    player.character_item_drop_distance_bonus  = global.rpg.players[index].item_drop_distance
    player.character_reach_distance_bonus  = global.rpg.players[index].reach_distance
    player.character_resource_reach_distance_bonus  = global.rpg.players[index].resource_reach_distance
    player.character_item_pickup_distance_bonus  = global.rpg.players[index].item_pickup_distance
    player.character_loot_pickup_distance_bonus  = global.rpg.players[index].loot_pickup_distance
    player.quickbar_count_bonus  = global.rpg.players[index].quickbar_count
    player.character_inventory_slots_bonus  = global.rpg.players[index].inventory_slots
    player.character_logistic_slot_count_bonus  = global.rpg.players[index].logistic_slot_count
    player.character_trash_slot_count_bonus  = global.rpg.players[index].trash_slot_count
    player.character_maximum_following_robot_count_bonus  = global.rpg.players[index].following_robots
    player.character_health_bonus  = global.rpg.players[index].health

end

function OnGuiClick(event)
    local index = event.player_index
    local player = game.players[index]
    
    if event.element.name == "gui_hide" then
        gui_hide(event)
    elseif event.element.name == "gui_show" then
        gui_show(event)
    elseif event.element.name == "gui_settings" then
        ClearPoint(event)
    elseif event.element.name == "tips_ok" then
        gui_settings(event)
        player.gui.center["tips"].destroy()
        return
    elseif event.element.name == "tips_cancel" then
        player.gui.center["tips"].destroy()
        return
    end
    
    if event.element.name == "crafting_speed" then
        if global.rpg.players[index].point >=1 then
            global.rpg.players[index].point = global.rpg.players[index].point - 1
            global.rpg.players[index].crafting_speed = global.rpg.players[index].crafting_speed + 0.01
            player.gui.left.rpg.layout2.label2_2.caption = global.rpg.players[index].point
            player.character_crafting_speed_modifier = player.character_crafting_speed_modifier + 0.01
            player.gui.left.rpg.layout3.label3_1_3.caption = string.format("%d", player.character_crafting_speed_modifier*100)
        else
            NoPoint(player)
        end
    elseif event.element.name == "mining_speed" then
        if global.rpg.players[index].point >=1 then
            global.rpg.players[index].point = global.rpg.players[index].point - 1
            global.rpg.players[index].mining_speed = global.rpg.players[index].mining_speed + 0.01
            player.gui.left.rpg.layout2.label2_2.caption = global.rpg.players[index].point
            player.character_mining_speed_modifier = player.character_mining_speed_modifier + 0.01
            player.gui.left.rpg.layout3.label3_2_3.caption = string.format("%d", player.character_mining_speed_modifier*100)
        else
            NoPoint(player)
        end
    elseif event.element.name == "running_speed" then
        if global.rpg.players[index].point >=1 then
            global.rpg.players[index].point = global.rpg.players[index].point - 1
            global.rpg.players[index].running_speed = global.rpg.players[index].running_speed + 0.01
            player.gui.left.rpg.layout2.label2_2.caption = global.rpg.players[index].point
            player.character_running_speed_modifier = player.character_running_speed_modifier + 0.01
            player.gui.left.rpg.layout3.label3_3_3.caption = string.format("%d", player.character_running_speed_modifier*100)
        else
            NoPoint(player)
        end
    elseif event.element.name == "build_distance" then
        if global.rpg.players[index].point >=5 then
            global.rpg.players[index].point = global.rpg.players[index].point - 5
            global.rpg.players[index].build_distance = global.rpg.players[index].build_distance + 1
            player.gui.left.rpg.layout2.label2_2.caption = global.rpg.players[index].point
            player.character_build_distance_bonus = player.character_build_distance_bonus + 1
            player.gui.left.rpg.layout3.label3_4_3.caption = player.character_build_distance_bonus
        else
            NoPoint(player)
        end
    elseif event.element.name == "item_drop_distance" then
        if global.rpg.players[index].point >=5 then
            global.rpg.players[index].point = global.rpg.players[index].point - 5
            global.rpg.players[index].item_drop_distance = global.rpg.players[index].item_drop_distance + 1
            player.gui.left.rpg.layout2.label2_2.caption = global.rpg.players[index].point
            player.character_item_drop_distance_bonus = player.character_item_drop_distance_bonus + 1
            player.gui.left.rpg.layout3.label3_5_3.caption = player.character_item_drop_distance_bonus
        else
            NoPoint(player)
        end
    elseif event.element.name == "reach_distance" then
        if global.rpg.players[index].point >=5 then
            global.rpg.players[index].point = global.rpg.players[index].point - 5
            global.rpg.players[index].reach_distance = global.rpg.players[index].reach_distance + 1
            player.gui.left.rpg.layout2.label2_2.caption = global.rpg.players[index].point
            player.character_reach_distance_bonus = player.character_reach_distance_bonus + 1
            player.gui.left.rpg.layout3.label3_6_3.caption = player.character_reach_distance_bonus
        else
            NoPoint(player)
        end
    elseif event.element.name == "resource_reach_distance" then
        if global.rpg.players[index].point >=5 then
            global.rpg.players[index].point = global.rpg.players[index].point - 5
            global.rpg.players[index].resource_reach_distance = global.rpg.players[index].resource_reach_distance + 1
            player.gui.left.rpg.layout2.label2_2.caption = global.rpg.players[index].point
            player.character_resource_reach_distance_bonus = player.character_resource_reach_distance_bonus + 1
            player.gui.left.rpg.layout3.label3_7_3.caption = player.character_resource_reach_distance_bonus
        else
            NoPoint(player)
        end
    elseif event.element.name == "item_pickup_distance" then
        if global.rpg.players[index].point >=5 then
            global.rpg.players[index].point = global.rpg.players[index].point - 5
            global.rpg.players[index].item_pickup_distance = global.rpg.players[index].item_pickup_distance + 1
            player.gui.left.rpg.layout2.label2_2.caption = global.rpg.players[index].point
            player.character_item_pickup_distance_bonus = player.character_item_pickup_distance_bonus + 1
            player.gui.left.rpg.layout3.label3_8_3.caption = player.character_item_pickup_distance_bonus
        else
            NoPoint(player)
        end
    elseif event.element.name == "loot_pickup_distance" then
        if global.rpg.players[index].point >=5 then
            global.rpg.players[index].point = global.rpg.players[index].point - 5
            global.rpg.players[index].loot_pickup_distance = global.rpg.players[index].loot_pickup_distance + 1
            player.gui.left.rpg.layout2.label2_2.caption = global.rpg.players[index].point
            player.character_loot_pickup_distance_bonus = player.character_loot_pickup_distance_bonus + 1
            player.gui.left.rpg.layout3.label3_9_3.caption = player.character_loot_pickup_distance_bonus
        else
            NoPoint(player)
        end
    elseif event.element.name == "quickbar_count" then
        if global.rpg.players[index].point >=80 then
            global.rpg.players[index].point = global.rpg.players[index].point - 80
            global.rpg.players[index].quickbar_count = global.rpg.players[index].quickbar_count + 1
            player.gui.left.rpg.layout2.label2_2.caption = global.rpg.players[index].point
            player.quickbar_count_bonus = player.quickbar_count_bonus + 1
            player.gui.left.rpg.layout3.label3_10_3.caption = player.quickbar_count_bonus
        else
            NoPoint(player)
        end
    elseif event.element.name == "inventory_slots" then
        if global.rpg.players[index].point >=10 then
            global.rpg.players[index].point = global.rpg.players[index].point - 10
            global.rpg.players[index].inventory_slots = global.rpg.players[index].inventory_slots + 1
            player.gui.left.rpg.layout2.label2_2.caption = global.rpg.players[index].point
            player.character_inventory_slots_bonus = player.character_inventory_slots_bonus + 1
            player.gui.left.rpg.layout3.label3_11_3.caption = player.character_inventory_slots_bonus
        else
            NoPoint(player)
        end
    elseif event.element.name == "logistic_slot_count" then
        if global.rpg.players[index].point >=8 then
            global.rpg.players[index].point = global.rpg.players[index].point - 8
            global.rpg.players[index].logistic_slot_count = global.rpg.players[index].logistic_slot_count + 1
            player.gui.left.rpg.layout2.label2_2.caption = global.rpg.players[index].point
            player.character_logistic_slot_count_bonus = player.character_logistic_slot_count_bonus + 1
            player.gui.left.rpg.layout3.label3_12_3.caption = player.character_logistic_slot_count_bonus
        else
            NoPoint(player)
        end
    elseif event.element.name == "trash_slot_count" then
        if global.rpg.players[index].point >=8 then
            global.rpg.players[index].point = global.rpg.players[index].point - 8
            global.rpg.players[index].trash_slot_count = global.rpg.players[index].trash_slot_count + 1
            player.gui.left.rpg.layout2.label2_2.caption = global.rpg.players[index].point
            player.character_trash_slot_count_bonus = player.character_trash_slot_count_bonus + 1
            player.gui.left.rpg.layout3.label3_13_3.caption = player.character_trash_slot_count_bonus
        else
            NoPoint(player)
        end
    elseif event.element.name == "following_robots" then
        if global.rpg.players[index].point >=20 then
            global.rpg.players[index].point = global.rpg.players[index].point - 20
            global.rpg.players[index].following_robots = global.rpg.players[index].following_robots + 1
            player.gui.left.rpg.layout2.label2_2.caption = global.rpg.players[index].point
            player.character_maximum_following_robot_count_bonus = player.character_maximum_following_robot_count_bonus + 1
            player.gui.left.rpg.layout3.label3_14_3.caption = player.character_maximum_following_robot_count_bonus
        else
            NoPoint(player)
        end
    elseif event.element.name == "health" then
        if global.rpg.players[index].point >=1 then
            global.rpg.players[index].point = global.rpg.players[index].point - 1
            global.rpg.players[index].health = global.rpg.players[index].health + 1
            player.gui.left.rpg.layout2.label2_2.caption = global.rpg.players[index].point
            player.character_health_bonus = player.character_health_bonus + 1
            player.gui.left.rpg.layout3.label3_15_3.caption = player.character_health_bonus
        else
            NoPoint(player)
        end
    end
end

function NoPoint(player)
    FlyingText({"property.nopoint"}, player.position, { r = 255, g = 100, b = 100})
end

function gui_hide(event)
    local index = event.player_index
    local player = global.players[index]
    local RpgGUI = player.gui.left.rpg
    RpgGUI.layout1.button_frame.gui_show.style.visible = true
    RpgGUI.layout1.button_frame.gui_hide.style.visible = false
    RpgGUI.layout2.style.visible = false
    RpgGUI.layout3.style.visible = false
end

function gui_show(event)
    local index = event.player_index
    local player = global.players[index]
    local RpgGUI = player.gui.left.rpg
    RpgGUI.layout1.button_frame.gui_show.style.visible = false
    RpgGUI.layout1.button_frame.gui_hide.style.visible = true
    RpgGUI.layout2.style.visible = true
    RpgGUI.layout3.style.visible = true
end

function ClearPoint(event)
    local index = event.player_index
    local player = global.players[index]

    ----tips----
    if player.gui.center["tips"] then
        return
    end
    local tips = player.gui.center.add{
        type = "frame",
        name = "tips",
        direction = "vertical"
        
    }
    tips.style.minimal_width = 200
    local tips_table = tips.add{
        type = "table",
        name = "tips_table",
        column_count = 1
    }
    local tips_title = tips_table.add{
        type = "label",
        name = "tips_title",
        style = "caption_label",
        caption = {"property.tips_title"}
    }
    tips_title.style.font_color = {r=0.94, g=0.89, b=0.69}
    tips_title.style.font = "default-frame"
    tips_title.style.minimal_width = 200
    local tips_caption = tips_table.add{
        type = "label",
        name = "tips_caption",
        style = "caption_label",
        caption = {"property.tips_caption"}
    }
    tips_caption.style.font_color = {r=1, g=0.3, b=0.3}

    local tips_table2 = tips.add{
        type = "table",
        name = "tips_table2",
        column_count = 2
    }
    local tips_ok = tips_table2.add{
        type = "button",
        name = "tips_ok",
        style = "menu_button",
        caption = {"property.tips_ok"}
    }
    tips_ok.style.minimal_width = 150
    local tips_cancel = tips_table2.add{
        type = "button",
        name = "tips_cancel",
        style = "menu_button",
        caption = {"property.tips_cancel"}
    }
    tips_cancel.style.minimal_width = 150
end

function gui_settings(event)
    local index = event.player_index
    local player = global.players[index]

    global.rpg.players[index].point = math.ceil((global.rpg.players[index].lv - 1) * 0.8)
    player.gui.left.rpg.layout2.label2_2.caption = global.rpg.players[index].point

    player.character_crafting_speed_modifier = 0
    player.character_mining_speed_modifier = 0
    player.character_running_speed_modifier = 0
    player.character_build_distance_bonus = 0
    player.character_item_drop_distance_bonus = 0
    player.character_reach_distance_bonus = 0
    player.character_item_pickup_distance_bonus = 0
    player.character_loot_pickup_distance_bonus = 0
    player.quickbar_count_bonus = 0
    player.character_inventory_slots_bonus = 0
    player.character_logistic_slot_count_bonus = 0
    player.character_trash_slot_count_bonus = 0
    player.character_maximum_following_robot_count_bonus = 0
    player.character_health_bonus = 0

    player.gui.left.rpg.layout3.label3_1_3.caption = 0
    player.gui.left.rpg.layout3.label3_2_3.caption = 0
    player.gui.left.rpg.layout3.label3_3_3.caption = 0
    player.gui.left.rpg.layout3.label3_4_3.caption = 0
    player.gui.left.rpg.layout3.label3_5_3.caption = 0
    player.gui.left.rpg.layout3.label3_6_3.caption = 0
    player.gui.left.rpg.layout3.label3_7_3.caption = 0
    player.gui.left.rpg.layout3.label3_8_3.caption = 0
    player.gui.left.rpg.layout3.label3_9_3.caption = 0
    player.gui.left.rpg.layout3.label3_10_3.caption = 0
    player.gui.left.rpg.layout3.label3_11_3.caption = 0
    player.gui.left.rpg.layout3.label3_12_3.caption = 0
    player.gui.left.rpg.layout3.label3_13_3.caption = 0
    player.gui.left.rpg.layout3.label3_14_3.caption = 0
    player.gui.left.rpg.layout3.label3_15_3.caption = 0
end

function AddExp(index, Exp, Tips)
    local player = global.players[index]
    global.rpg.players[index].exp = global.rpg.players[index].exp + Exp
    
    local lvup = false
    while global.rpg.players[index].exp >= 1 do
        lvup = true
        global.rpg.players[index].lv = global.rpg.players[index].lv + 1
        global.rpg.players[index].exp = global.rpg.players[index].exp - 1
        -- lv up sound
        FlyingText("升级！", player.position, { r = 255, g = 255, b = 100})
        player.play_sound{path="utility/new_objective"}
        player.gui.left.rpg.layout1.label1_4.caption = {"property.lv", global.rpg.players[index].lv}
        global.rpg.players[index].point = global.rpg.players[index].point + 1
        player.gui.left.rpg.layout2.label2_2.caption =  global.rpg.players[index].point
        if global.rpg.players[index].mp < 100 then 
            global.rpg.players[index].mp = 100
        end
    end
    player.gui.left.rpg.layout1.label1_3.value = global.rpg.players[index].exp
    -- player.print(Tips)
    if not lvup then
        FlyingText(Tips, player.position, { r = 50, g = 200, b = 50})
    end

end

script.on_init(OnInit)
script.on_load(OnLoad)
script.on_event(defines.events.on_tick, OnTick)
script.on_event(defines.events.on_built_entity, OnBuiltEntity)
script.on_event(defines.events.on_robot_built_entity, OnBuiltEntity)
script.on_event(defines.events.on_entity_died, OnEntityDied)
script.on_event(defines.events.on_player_created, OnPlayerCreated)
script.on_event(defines.events.on_player_crafted_item, onPlayerCraftedItem)
-- script.on_event(defines.events.on_player_died, OnPlayerDied)
script.on_event(defines.events.on_player_respawned, OnPlayerRespawned)
script.on_event(defines.events.on_marked_for_deconstruction, OnMarkedForDeconstruction)
script.on_event(defines.events.on_gui_click, OnGuiClick)
