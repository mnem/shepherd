local EF = require 'nah.entityframework'

EF.addSystem('render', 'draw images', function(entities)
    local position, renderable
    for i, entity in ipairs(entities) do
        position, renderable = EF.entityComponents(entity, 'position', 'renderable')
        love.graphics.draw(
            renderable.image,
            position.x, position.y,
            renderable.rotation,
            renderable.scaleX, renderable.scaleY,
            renderable.originX, renderable.originY)
    end
end, 'position', 'renderable')

EF.addSystem('logic', 'follow mouse', function(entities)
    local position
    for i, entity in ipairs(entities) do
        position = EF.entityComponents(entity, 'position')
        position.x = love.mouse.getX()
        position.y = love.mouse.getY()
    end
end, 'position', 'active cursor')
