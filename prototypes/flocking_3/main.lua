local EF = require 'nah.entityframework'
require 'components'
require 'systems'

function love.update()
    EF.updateSystem('logic')
end

function love.draw()
    EF.updateSystem('render')
end

-- Load an image to test the render and cursor system
function love.load()
    local renderable = EF.addEntityComponents('cursor', 'renderable', 'active cursor', 'position')
    renderable.image = love.graphics.newImage('image/sheep.png')
    renderable.originX = renderable.image:getWidth() / 2
    renderable.originY = renderable.image:getHeight() / 2
end
