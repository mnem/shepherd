-- Require the library
require "nah_ces"

-- Hook up the update and draw functions for the systems
function love.update()
    nah_ces.updateSystems()
end

function love.draw()
    nah_ces.drawSystems()
end

-- Load an image to test the render and cursor system
function love.load()
    -- Create our one and only entity - a rendered images that follows the cursor
    cursor = nah_ces.newEntity('cursor', cmp_2d_image, cmp_2d_mouse_tracker)
    cursor.components_by_base[cmp_2d_image].image = love.graphics.newImage("image/sheep.png")
end

----------------------------------------
 -- Create some components
----------------------------------------

-- Component storing a position in space
cmp_2d = nah_ces.newComponent('2d')
cmp_2d.x = 0
cmp_2d.y = 0

-- Component used to indicated the current mouse cursor
cmp_2d_mouse_tracker = nah_ces.newComponent('2d.target', cmp_2d)

-- Component which can be rendered to screen from an image
cmp_2d_image = nah_ces.newComponent('2d.image', cmp_2d)
cmp_2d_image.image = nil
cmp_2d_image.rotation = 0
cmp_2d_image.scale_x = 1
cmp_2d_image.scale_y = 1

----------------------------------------
 -- Create systems
----------------------------------------

-- Simple render system - just loops through anything that is renderable
-- and draws it with the standard love.graphics.draw function
render_system = nah_ces.newSystem('Render System', cmp_2d_image)
function render_system:draw()
    local entity
    local comp_2d
    local comp_2d_image
    for i = 1, #self.system_entities do
        -- Grab a reference to the current entity and it's components
        entity = self.system_entities[i]
        comp_2d = entity.components_by_base[cmp_2d]
        comp_2d_image = entity.components_by_base[cmp_2d_image]

        -- Do stuff to them
        love.graphics.draw(
            comp_2d_image.image,
            comp_2d.x, comp_2d.y,
            comp_2d_image.rotation,
            comp_2d_image.scale_x, comp_2d_image.scale_y,
            comp_2d_image.image:getWidth() / 2, comp_2d_image.image:getHeight() / 2)
    end
end
-- Don't forget to activate it
nah_ces.activateSystem(render_system)

-- System that snaps entites to the current position of the mouse. A
-- mouse cursor, one might say
cursor_system = nah_ces.newSystem('Cursor System', cmp_2d_mouse_tracker)
function cursor_system:update()
    local entity
    local comp_2d
    for i = 1, #self.system_entities do
        -- Grab a reference to the current entity and it's components
        entity = self.system_entities[i]
        comp_2d = entity.components_by_base[cmp_2d]

        -- Do stuff to them
        comp_2d.x = love.mouse.getX()
        comp_2d.y = love.mouse.getY()
    end
end
-- Don't forget to activate it
nah_ces.activateSystem(cursor_system)
