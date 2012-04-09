require "log"
require "nah_ces"

local cmp_2d = nah_ces.newComponent('2d')
cmp_2d.x = 0
cmp_2d.y = 0

local cmp_2d_mouse_target = nah_ces.newComponent('2d.target', cmp_2d)

local cmp_2d_image = nah_ces.newComponent('2d.image', cmp_2d)
cmp_2d_image.image = nil
cmp_2d_image.rotation = 0
cmp_2d_image.scale_x = 1
cmp_2d_image.scale_y = 1

local render_system = nah_ces.newSystem('Render System', cmp_2d_image)
function render_system:draw()
    local entity
    local comp_2d
    local comp_2d_image
    for i = 1, #self.system_entities do
        entity = self.system_entities[i]
        comp_2d = entity.components_by_base[cmp_2d]
        comp_2d_image = entity.components_by_base[cmp_2d_image]
        love.graphics.draw(
            comp_2d_image.image,
            comp_2d.x, comp_2d.y,
            comp_2d_image.rotation,
            comp_2d_image.scale_x, comp_2d_image.scale_y,
            comp_2d_image.image:getWidth() / 2, comp_2d_image.image:getHeight() / 2)
    end
end
nah_ces.activateSystem(render_system)

local cursor_system = nah_ces.newSystem('Cursor System', cmp_2d_mouse_target)
function cursor_system:update()
    local entity
    local comp_2d
    for i = 1, #self.system_entities do
        entity = self.system_entities[i]
        comp_2d = entity.components_by_base[cmp_2d]
        comp_2d.x = love.mouse.getX()
        comp_2d.y = love.mouse.getY()
    end
end
nah_ces.activateSystem(cursor_system)

function love.load()
    cursor = nah_ces.newEntity('cursor', cmp_2d_image, cmp_2d_mouse_target)
    cursor.components_by_base[cmp_2d_image].image = love.graphics.newImage("image/sheep.png")
end

function love.update()
    nah_ces.updateSystems()
end

function love.draw()
    nah_ces.drawSystems()
    love.graphics.print(log.messages(), 0, 0)
end
