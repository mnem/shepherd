EF = require 'nah.entityframework'

function love.update()
    EF.updateSystem('logic')
end

function love.draw()
    EF.updateSystem('render')
end

-- Load an image to test the render and cursor system
function love.load()
    local renderable = EF.addEntityComponents('cursor', 'renderable', 'active cursor', 'position')
    renderable.image = love.graphics.newImage("image/sheep.png")
end

-- Component Factories -------------------------------------------------------
EF.registerComponentFactory('position', function() return { x = 0, y = 0 } end )
EF.registerComponentFactory('renderable', function() return { image = nil, rotation = 0, scaleX = 1, scaleY = 1 } end )

-- Systems -------------------------------------------------------------------
local function renderSystem(entities)
    local position, renderable
    for i, entity in ipairs(entities) do
        position, renderable = EF.entityComponents(entity, 'position', 'renderable')
        love.graphics.draw(
            renderable.image,
            position.x, position.y,
            renderable.rotation,
            renderable.scale_x, renderable.scale_y,
            renderable.image:getWidth() / 2, renderable.image:getHeight() / 2)
    end
end

local function followMouseSystem(entities)
    local position
    for i, entity in ipairs(entities) do
        position = EF.entityComponents(entity, 'position')
        position.x = love.mouse.getX()
        position.y = love.mouse.getY()
    end
end

EF.addSystem('render', 'draw images', renderSystem, 'position', 'renderable')
EF.addSystem('logic', 'follow mouse', followMouseSystem, 'position', 'active cursor')
