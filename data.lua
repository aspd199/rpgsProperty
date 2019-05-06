local gui_style = data.raw["gui-style"].default

local function button_png(xpos, ypos)
    return {
        type = "monolith",

        top_monolith_border = 0,
        right_monolith_border = 0,
        bottom_monolith_border = 0,
        left_monolith_border = 0,

        monolith_image = {
            filename = "__rpgsProperty__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 16,
            height = 16,
            x = xpos,
            y = ypos,
        },
    }
end

gui_style.RpgGUI_button_with_icon = {
    type = "button_style",
    parent = "slot_button",

    scalable = true,

    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,

    width = 17,
    height = 17,

    default_graphical_set = button_png( 0,  0),
    hovered_graphical_set = button_png(16,  0),
    clicked_graphical_set = button_png(32,  0),
}

gui_style.RpgGUI_show = {
    type = "button_style",
    parent = "RpgGUI_button_with_icon",

    default_graphical_set = button_png( 0, 16),
    hovered_graphical_set = button_png(16, 16),
    clicked_graphical_set = button_png(32, 16),
}

gui_style.RpgGUI_hide = {
    type = "button_style",
    parent = "RpgGUI_button_with_icon",

    default_graphical_set = button_png( 0, 32),
    hovered_graphical_set = button_png(16, 32),
    clicked_graphical_set = button_png(32, 32),
}

gui_style.RpgGUI_settings = {
    type = "button_style",
    parent = "RpgGUI_button_with_icon",

    default_graphical_set = button_png( 0, 48),
    hovered_graphical_set = button_png(16, 48),
    clicked_graphical_set = button_png(32, 48),
}
