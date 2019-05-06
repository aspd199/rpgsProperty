function FlyingText(text, position, color)
    color = color or {r = 1, g = 1, b = 1}

    -- local surface = game.surfaces.nauvis
    return game.surfaces.nauvis.create_entity {
        name = 'tutorial-flying-text',
        text = text,
        position = {x = position.x, y = position.y - 1},
        color = color
    }
end
