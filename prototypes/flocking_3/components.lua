local EF = require 'nah.entityframework'

EF.registerComponentFactory('position', function()
    return {
        x = 0,
        y = 0
    }
end )

EF.registerComponentFactory('renderable', function()
    return {
        image = nil,
        rotation = 0,
        scaleX = 1,
        scaleY = 1,
        originX = 0,
        originY = 0 }
end )
