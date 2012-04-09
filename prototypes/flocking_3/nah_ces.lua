module(..., package.seeall);

------------------------------------------------------------------------------
-- Private system utilities --------------------------------------------
------------------------------------------------------------------------------
function entityMatchesSystemCriteria(system, entity)
    if system._cached_entity_matches[entity] == nil then
        if #system.system_criteria == 0 then
            -- Potentially want to default to true for no entities added
            -- which would act as a wildcard system
            system._cached_entity_matches[entity] = false
        else
            -- Innocent until proven guilty
            system._cached_entity_matches[entity] = true
            -- Check if the entity matches each criteria the system cares about
            for i = 1, #system.system_criteria do
                if entity.components_by_base[system.system_criteria[i]] == nil then
                    -- Doesn't have this component, so we don't care about it
                    system._cached_entity_matches[entity] = false
                    break
                end
            end
        end
    end
    return system._cached_entity_matches[entity]
end

local function addEntityToSystem(system, entity)
    -- Only add if it matches the criteria
    if not entityMatchesSystemCriteria(system, entity) then
        return
    end

    -- Don't allow entities to be registered more than once
    for i = 1, #system.system_entities do
        if system.system_entities[i] == entity then
            return
        end
    end

    table.insert(system.system_entities, entity)
    system:entityAdded(entity)
end

local allEntities = {}
local allSystems = {}
local function addEntityToAllSystems(entity)
    -- Only add new entities
    if allEntities[entity] == nil then
        allEntities[entity] = entity
        for i = 1, #allSystems do
            addEntityToSystem(allSystems[i], entity)
        end
    end
end

------------------------------------------------------------------------------
-- Component -----------------------------------------------------------------
------------------------------------------------------------------------------
local Component = { _creation_count = 0 }
local Component_mt = { __index = Component }
function Component:create(entity)
    Component._creation_count = Component._creation_count + 1
    local new_component = {
        entity = entity,
        component_uid = Component._creation_count,
        component_base = self }
    setmetatable( new_component, { __index = self } )
    new_component:init()
    return new_component
end
function Component:init()
end
function Component:entityInited(entity)
end
-- Component factory ---------------------------------------------------
function newComponent(id, ...)
    local registered_component = {
        entity = nil,
        _required_components = {},
        component_id = id
    }
    for i = 1, arg.n do
        table.insert(registered_component._required_components, arg[i])
    end
    setmetatable( registered_component, Component_mt )
    return registered_component
end

------------------------------------------------------------------------------
-- Entity --------------------------------------------------------------------
------------------------------------------------------------------------------
local Entity = {}
local Entity_mt = { __index = Entity }
-- Entity factory ------------------------------------------------------
function newEntity(id, ...)
    local new_entity = {
        entity_id = id,
        components_by_base = {}
    }
    setmetatable( new_entity, Entity_mt )

    -- Create the component instances
    for i = 1, arg.n do
        local new_component = arg[i]:create(new_entity)
        new_entity.components_by_base[new_component.component_base] = new_component
    end

    -- Add any missing required components
    for base, instance in pairs(new_entity.components_by_base) do
        local required
        for i = 1, #base._required_components do
            required = base._required_components[i]
            if new_entity.components_by_base[required] == nil then
                log.print('Required component ' .. required.component_id .. ' missing for entity ' .. id .. ' - forcing creation')
                local new_component = required:create(new_entity)
                new_entity.components_by_base[new_component.component_base] = new_component
            end
        end
    end

    -- Tell each of the newly constructed components that they now
    -- belong to a shiny new entity
    for base, instance in pairs(new_entity.components_by_base) do
        instance:entityInited(new_entity)
    end

    -- Add it to any existing systems
    addEntityToAllSystems(new_entity)

    return new_entity
end


------------------------------------------------------------------------------
-- System --------------------------------------------------------------------
------------------------------------------------------------------------------
local System = {}
local System_mt = { __index = System }
function System:entityAdded(entity)
end
function System:draw()
end
function System:update()
end
-- System factory ------------------------------------------------------
function newSystem(id, ...)
    local new_system = {
        system_id = id,
        system_criteria = {},
        system_entities = {},
        _cached_entity_matches = {}
    }

    for i = 1, arg.n do
        table.insert(new_system.system_criteria, arg[i])
    end

    setmetatable( new_system, System_mt )
    return new_system
end
function activateSystem(system)
    for i = 1, #allSystems do
        if allSystems[i] == system then
            -- Ain't no dupes, fool
            return
        end
    end
    table.insert(allSystems, system)
    -- Go through all existing entities and add them to the system
    for entity, _ in pairs(allEntities) do
        addEntityToSystem(system, entity)
    end
end
function updateSystems()
    for i = 1, #allSystems do
        allSystems[i]:update()
    end
end
function drawSystems()
    for i = 1, #allSystems do
        allSystems[i]:draw()
    end
end
