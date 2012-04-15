-- Module exports
local M = {}

------------------------------------------------------------------------------
-- Data ----------------------------------------------------------------------
------------------------------------------------------------------------------

-- If true, warnings will cause an error
M.treatWarningsAsErrors = true
M.supressWarningTraceback = false

-- entities: hash (entity, componentInstances)
--   componentInstances: hash (componentName, componentInstance)
local entities = {}

-- systems: hash (group, groupSystems)
--   groupSystems: hash (name, system)
--     processor: function
--     componentNames: hash (componentName, true)
--     entities: array
--     entityMembership: hash (entity, true)
local systems = {}

-- registeredComponentFactories: hash (componentName, factoryFunction)
local registeredComponentFactories = {}

------------------------------------------------------------------------------
-- Debugging and logging -----------------------------------------------------
------------------------------------------------------------------------------
local function warn(message, level)
    if M.treatWarningsAsErrors then
        error(message, level or 3)
    else
        if not M.supressWarningTraceback then
            print(debug.traceback("nah.entityframework WARNING: " .. message, level or 3))
        end
    end
end

------------------------------------------------------------------------------
-- Systems -------------------------------------------------------------------
------------------------------------------------------------------------------

local function entityComponentInstancesMatchSystem(entityComponentInstances, system)
    for systemComponentName, _ in pairs(system.componentNames) do
        if entityComponentInstances[systemComponentName] == nil then
            return false
        end
    end

    return true
end

-- Updates the specified entity in all systems
local function updateSystemsWithEntity(entity)
    local belongs = false
    for group, groupSystems in pairs(systems) do
        for name, system in pairs(groupSystems) do
            belongs = entityComponentInstancesMatchSystem(entities[entity], system)
            if system.entityMembership[entity] ~= nil and belongs == false then
                -- Remove it
                for i, systemEntity in ipairs(system.entities) do
                    if systemEntity == entity then
                        table.remove(system.entities, i)
                        system.entityMembership[entity] = nil
                        break
                    end
                end
            end

            -- Add it if it belongs
            if  belongs then
                table.insert(system.entities, entity)
                system.entityMembership[entity] = true
            end
        end
    end
end

-- Updates the specified system with all entities
local function updateSystemWithEntities(system)
    system.entities = {}
    system.entityMembership = {}
    for entity, componentInstances in pairs(entities) do
        if entityComponentInstancesMatchSystem(componentInstances, system) then
            table.insert(system.entities, entity)
            system.entityMembership[entity] = true
        end
    end
end

-- Adds a new system in the specified group which execute the specified
-- processor function over entities matching the named components listed
-- after the processor function.
function M.addSystem(group, name, processor, ...)
    if group == nil then warn('Cannot add a system with a nil group'); return end
    if name == nil then warn('Cannot add a system with a nil name'); return end
    if processor == nil then warn('Cannot add a system with a nil processor'); return end

    local systemsGroup = systems[group] or {}
    if systemsGroup[name] == nil then
         local system = {
            processor = processor,
            componentNames = {},
            entities = {},
            entityMembership = {}
        }

        for i = 1, arg.n do
            system.componentNames[arg[i]] = true
        end

        systemsGroup[name] = system

        -- Add the system group back in case this was the first
        -- system in the group
        systems[group] = systemsGroup

        updateSystemWithEntities(system)
    else
        -- TODO: Decide if the system should be replaced
        -- with the new one
        warn("Tried to replace a system " .. name .. " in group " .. group .. ". Haven't decided if this is supported yet.")
    end
end

-- Destroys a system if group and name are specified. If
-- only group is specified, destroys all systems in that group
function M.removeSystem(group, name)
    if group ~= nil then
        if name ~= nil then
            systems[group][name] = nil
        else
            systems[group] = nil
        end
    else
        warn("Tried to destroy a system, but group name was nil. You must specify at least the group name.")
    end
end

-- Updates a system if group and name are specified. If
-- only group is specified, updates all systems in that group
function M.updateSystem(group, name)
    local updateSystems = {}
    if group ~= nil  and systems[group] ~= nil then
        if name ~= nil then
            if systems[group][name] ~= nil then
                updateSystems[name] = systems[group][name]
            end
        else
            updateSystems = systems[group]
        end
    end

    for systemName, system in pairs(updateSystems) do
        system.processor(system.entities)
    end
end

-- Returns the total number of systems and the number of systems
-- in each group.
--
-- return totalCount, {groupName:groupSystemCount}
function M.systemCount()
    local totalCount = 0
    local groupCount = {}

    for groupName, groupSystems in pairs(systems) do
        groupCount[groupName] = 0
        for systemName, system in pairs(groupSystems) do
            totalCount = totalCount + 1
            groupCount[groupName] = groupCount[groupName] + 1
        end
    end

    return totalCount, groupCount
end

-- Returns the total number of entities in each system
--
-- return { group: { name: count } }
function M.systemEntityCount()
    local counts = {}

    for groupName, groupSystems in pairs(systems) do
        counts[groupName] = {}
        for systemName, system in pairs(groupSystems) do
            counts[groupName][systemName] = #system.entities
        end
    end

    return counts
end

------------------------------------------------------------------------------
-- Components ----------------------------------------------------------------
------------------------------------------------------------------------------

-- Registers a new component factory under the given name. Names must be
-- unique.
--
-- Currently, there is no way to unregister a factory. This is because I'm
-- totally avoiding the issue where a new factory with the same name could
-- be then added which would produce a different component from that attached
-- to existing entities
function M.registerComponentFactory(name, factory)
    if registeredComponentFactories[name] == nil then
        registeredComponentFactories[name] = factory

        -- If any existing entities have a placeholder for this component,
        -- create them now
        for entity, componentInstances in pairs(entities) do
            if componentInstances[name] ~= nil then
                componentInstances[name] = factory()
            end
        end
    else
        if factory ~= registeredComponentFactories[name] then
            -- TODO: Decide if the factory should be replaced
            -- with the new one
            warn("Tried to replace a component factory. Haven't decided if this is supported yet.")
        end
    end
end

-- Returns the total number of component factories
--
-- return totalCount
function M.componentFactoryCount()
    local totalCount = 0

    for componentName, factoryFunction in pairs(registeredComponentFactories) do
        totalCount = totalCount + 1
    end

    return totalCount
end

------------------------------------------------------------------------------
-- Entity manipulation -------------------------------------------------------
------------------------------------------------------------------------------

-- Adds the specified components to the entity. The entity may be any object.
-- If it already has components, any new components that are specified
-- will be added to it.
--
-- returns the component instances specified for the entity.
function M.addEntityComponents(entity, ...)
    if entity == nil then
        warn('Cannot add components to nil entity.')
        return
    end

    local entityComponents = entities[entity] or {}
    local addedArray = {}
    local instance = nil
    local factory = nil
    local component = nil

    for i = 1, arg.n do
        component = arg[i]
        if entityComponents[component] == nil then
            factory = registeredComponentFactories[component] or function() return '__placeholder "' .. component .. '"' end
            instance = factory()
            entityComponents[component] = instance
        else
            instance = entityComponents[component]
        end
        table.insert(addedArray, instance)
    end

    -- add the components here so that the entity reference is
    -- actually created if it was a new one
    entities[entity] = entityComponents

    updateSystemsWithEntity(entity)

    return unpack(addedArray)
end

function M.entityComponents(entity, ...)
    local entityComponents = entities[entity] or {}
    local components = {}

    for i = 1, arg.n do
        table.insert(components, entityComponents[arg[i]])
    end

    return unpack(components)
end

function M.removeEntityComponents(entity, ...)
    local entityComponents = entities[entity] or {}
    local removedArray = {}

    for i = 1, arg.n do
        -- nil values can be inserted here, but that's OK so that
        -- the return values are in the expected order
        -- for the caller
        table.insert(removedArray, entityComponents[arg[i]])
        entityComponents[arg[i]] = nil
    end

    updateSystemsWithEntity(entity)

    return unpack(removedArray)
end

function M.destroyEntity(entity)
    -- Wonder if we should teardown it's components?
    -- local entityComponents = entities[entity] or {}
    entities[entity] = nil

    for group, groupSystems in pairs(systems) do
        for i, groupSystem in ipairs(groupSystems) do
            for j, systemEntity in ipairs(groupSystem.entities) do
                if entity == systemEntity then
                    table.remove(groupSystem.entities, j)
                    groupSystem.entityMembership[entity] = nil
                    break
                end
            end
        end
    end
end

-- Returns the total number of component factories
--
-- return totalCount
function M.entityCount()
    local totalCount = 0

    for entity, componentInstances in pairs(entities) do
        totalCount = totalCount + 1
    end

    return totalCount
end

return M
