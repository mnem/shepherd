-- Module exports
local M = {}

------------------------------------------------------------------------------
-- Results -------------------------------------------------------------------
------------------------------------------------------------------------------
M.results = {}

local function logResult(event)
    table.insert(M.results, event)
end

function M.printResults()
    for i, result in ipairs(M.results) do
        local pass = result.pass and 'PASS' or 'FAIL'
        print(i, pass, result.message)
    end
end

------------------------------------------------------------------------------
-- Assertions  ---------------------------------------------------------------
------------------------------------------------------------------------------
local function success(message)
    logResult({ pass = true, message = message })
end

local function fail(message)
    logResult({ pass = false, message = message })
    error(message, 3)
end

local function assertEqual(message, expect, actual, failMessage)
    if expect == actual then
        success("PASS: " .. message)
    else
        failMessage = failMessage or ''
        expect = expect or 'nil'
        actual = actual or 'nil'
        fail("FAIL: " .. message .. " - " .. failMessage .. " Found " .. actual .. " expected " .. expect)
    end
end

------------------------------------------------------------------------------
-- Unit Tests ----------------------------------------------------------------
------------------------------------------------------------------------------
local T = {}

function T.testNoIntialSystems(EF)
    assertEqual('checking total systems', 0, EF.systemCount())
end

function T.testAddNilSystem(EF)
    EF.addSystem('testGroup', 'testSystem', nil)
    assertEqual('checking total systems', 0, EF.systemCount())
end

function T.testAddNilNameSystem(EF)
    EF.addSystem('testGroup', nil, function(e) end)
    assertEqual('checking total systems', 0, EF.systemCount())
end

function T.testAddNilGroupSystem(EF)
    EF.addSystem(nil, 'testSystem', function(e) end)
    assertEqual('checking total systems', 0, EF.systemCount())
end

function T.testAddOneSystem(EF)
    EF.addSystem('testGroup', 'testSystem', function(e) end)

    local count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 1, count)
    assertEqual('checking systems in group', 1, groupCount.testGroup)
end

function T.testAddDuplicateSystem(EF)
    EF.addSystem('testGroup', 'testSystem', function(e) end)

    local count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 1, count)
    assertEqual('checking systems in group', 1, groupCount.testGroup)

    EF.addSystem('testGroup', 'testSystem', function(e) end)

    count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 1, count)
    assertEqual('checking systems in group', 1, groupCount.testGroup)
end

function T.testAddTwoSystemsToOneGroup(EF)
    EF.addSystem('testGroup', 'testSystem', function(e) end)
    EF.addSystem('testGroup', 'testSystem2', function(e) end)

    local count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 2, count)
    assertEqual('checking systems in group', 2, groupCount.testGroup)
end

function T.testAddTwoSystemsToTwoGroups(EF)
    EF.addSystem('testGroup', 'testSystem', function(e) end)
    EF.addSystem('testGroup2', 'testSystem', function(e) end)

    local count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 2, count)
    assertEqual('checking systems in group 1', 1, groupCount.testGroup)
    assertEqual('checking systems in group 2', 1, groupCount.testGroup2)
end

function T.testAddThreeSystemsToTwoGroups(EF)
    EF.addSystem('testGroup', 'testSystem', function(e) end)
    EF.addSystem('testGroup2', 'testSystem', function(e) end)
    EF.addSystem('testGroup2', 'testSystem2', function(e) end)

    local count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 3, count)
    assertEqual('checking systems in group 1', 1, groupCount.testGroup)
    assertEqual('checking systems in group 2', 2, groupCount.testGroup2)
end

function T.testUpdateOneSpecificSystem(EF)
    local system1UpdateCount = 0
    local system2UpdateCount = 0
    local system3UpdateCount = 0

    EF.addSystem('testGroup', 'testSystem1', function(e) system1UpdateCount = system1UpdateCount + 1 end)
    EF.addSystem('testGroup', 'testSystem2', function(e) system2UpdateCount = system2UpdateCount + 1 end)
    EF.addSystem('testGroup', 'testSystem3', function(e) system3UpdateCount = system3UpdateCount + 1 end)

    EF.updateSystem('testGroup', 'testSystem1')

    assertEqual('checking system 1 updates', 1, system1UpdateCount)
    assertEqual('checking system 2 updates', 0, system2UpdateCount)
    assertEqual('checking system 3 updates', 0, system3UpdateCount)

    EF.updateSystem('testGroup', 'testSystem1')

    assertEqual('checking system 1 updates', 2, system1UpdateCount)
    assertEqual('checking system 2 updates', 0, system2UpdateCount)
    assertEqual('checking system 3 updates', 0, system3UpdateCount)
end

function T.testUpdateOneGroup(EF)
    local system1UpdateCount = 0
    local system2UpdateCount = 0
    local system3UpdateCount = 0

    EF.addSystem('testGroup', 'testSystem1', function(e) system1UpdateCount = system1UpdateCount + 1 end)
    EF.addSystem('testGroup', 'testSystem2', function(e) system2UpdateCount = system2UpdateCount + 1 end)
    EF.addSystem('testGroup', 'testSystem3', function(e) system3UpdateCount = system3UpdateCount + 1 end)

    EF.updateSystem('testGroup')

    assertEqual('checking system 1 updates', 1, system1UpdateCount)
    assertEqual('checking system 2 updates', 1, system2UpdateCount)
    assertEqual('checking system 3 updates', 1, system3UpdateCount)

    EF.updateSystem('testGroup')

    assertEqual('checking system 1 updates', 2, system1UpdateCount)
    assertEqual('checking system 2 updates', 2, system2UpdateCount)
    assertEqual('checking system 3 updates', 2, system3UpdateCount)
end

function T.testUpdateOneSpecificGroup(EF)
    local system1UpdateCount = 0
    local system2UpdateCount = 0
    local system3UpdateCount = 0

    EF.addSystem('testGroup', 'testSystem1', function(e) system1UpdateCount = system1UpdateCount + 1 end)
    EF.addSystem('testGroup1', 'testSystem2', function(e) system2UpdateCount = system2UpdateCount + 1 end)
    EF.addSystem('testGroup1', 'testSystem3', function(e) system3UpdateCount = system3UpdateCount + 1 end)

    EF.updateSystem('testGroup1')

    assertEqual('checking system 1 updates', 0, system1UpdateCount)
    assertEqual('checking system 2 updates', 1, system2UpdateCount)
    assertEqual('checking system 3 updates', 1, system3UpdateCount)

    EF.updateSystem('testGroup1')

    assertEqual('checking system 1 updates', 0, system1UpdateCount)
    assertEqual('checking system 2 updates', 2, system2UpdateCount)
    assertEqual('checking system 3 updates', 2, system3UpdateCount)
end

function T.testUpdateNonExistentGroup(EF)
    local system1UpdateCount = 0
    local system2UpdateCount = 0
    local system3UpdateCount = 0

    EF.addSystem('testGroup', 'testSystem1', function(e) system1UpdateCount = system1UpdateCount + 1 end)
    EF.addSystem('testGroup', 'testSystem2', function(e) system2UpdateCount = system2UpdateCount + 1 end)
    EF.addSystem('testGroup', 'testSystem3', function(e) system3UpdateCount = system3UpdateCount + 1 end)

    EF.updateSystem('dont_exist')

    assertEqual('checking system 1 updates', 0, system1UpdateCount)
    assertEqual('checking system 2 updates', 0, system2UpdateCount)
    assertEqual('checking system 3 updates', 0, system3UpdateCount)
end


function T.testUpdateNonExistentSystem(EF)
    local system1UpdateCount = 0
    local system2UpdateCount = 0
    local system3UpdateCount = 0

    EF.addSystem('testGroup', 'testSystem1', function(e) system1UpdateCount = system1UpdateCount + 1 end)
    EF.addSystem('testGroup', 'testSystem2', function(e) system2UpdateCount = system2UpdateCount + 1 end)
    EF.addSystem('testGroup', 'testSystem3', function(e) system3UpdateCount = system3UpdateCount + 1 end)

    EF.updateSystem('testGroup', 'dont_exist')

    assertEqual('checking system 1 updates', 0, system1UpdateCount)
    assertEqual('checking system 2 updates', 0, system2UpdateCount)
    assertEqual('checking system 3 updates', 0, system3UpdateCount)
end

function T.testAddingAndRemovingOneSystem(EF)
    EF.addSystem('testGroup', 'testSystem', function(e) end)

    local count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 1, count)
    assertEqual('checking total system group count', 1, groupCount.testGroup)

    EF.removeSystem('testGroup', 'testSystem')

    count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 0, count)
    assertEqual('checking total system group count', 0, groupCount.testGroup)
end

function T.testRemovingOneUniqueSystem(EF)
    EF.addSystem('testGroup', 'testSystem1', function(e) end)
    EF.addSystem('testGroup', 'testSystem2', function(e) end)

    local count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 2, count)
    assertEqual('checking total system group count', 2, groupCount.testGroup)

    EF.removeSystem('testGroup', 'testSystem1')

    count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 1, count)
    assertEqual('checking total system group count', 1, groupCount.testGroup)
end

function T.testRemovingSystemGroup(EF)
    EF.addSystem('testGroup', 'testSystem1', function(e) end)
    EF.addSystem('testGroup', 'testSystem2', function(e) end)

    local count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 2, count)
    assertEqual('checking total system group count', 2, groupCount.testGroup)

    EF.removeSystem('testGroup')

    count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 0, count)
    assertEqual('checking total system group count', nil, groupCount.testGroup)
end

function T.testRemovingUniqueSystemGroup(EF)
    EF.addSystem('testGroup1', 'testSystem1', function(e) end)
    EF.addSystem('testGroup1', 'testSystem2', function(e) end)
    EF.addSystem('testGroup2', 'testSystem3', function(e) end)

    local count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 3, count)
    assertEqual('checking total system group 1 count', 2, groupCount.testGroup1)
    assertEqual('checking total system group 2 count', 1, groupCount.testGroup2)

    EF.removeSystem('testGroup1')

    count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 1, count)
    assertEqual('checking total system group 1 count', nil, groupCount.testGroup1)
    assertEqual('checking total system group 2 count', 1, groupCount.testGroup2)
end

function T.testRemovingNonExistantSystem(EF)
    EF.addSystem('testGroup', 'testSystem', function(e) end)

    local count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 1, count)
    assertEqual('checking total system group count', 1, groupCount.testGroup)

    EF.removeSystem('testGroup', 'dont_exist')

    count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 1, count)
    assertEqual('checking total system group count', 1, groupCount.testGroup)
end

function T.testRemovingNonExistantSystemGroup(EF)
    EF.addSystem('testGroup', 'testSystem', function(e) end)

    local count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 1, count)
    assertEqual('checking total system group count', 1, groupCount.testGroup)

    EF.removeSystem('dont_exist')

    count, groupCount = EF.systemCount()
    assertEqual('checking total systems', 1, count)
    assertEqual('checking total system group count', 1, groupCount.testGroup)
end

function T.testNoIntialComponentFactories(EF)
    assertEqual('checking number of component factories', 0, EF.componentFactoryCount())
end

function T.testAddingOneComponentFactory(EF)
    EF.registerComponentFactory('testFactory', function(e) end)
    assertEqual('checking number of component factories', 1, EF.componentFactoryCount())
end

function T.testAddingDuplicatComponentFactory(EF)
    EF.registerComponentFactory('testFactory', function(e) end)
    assertEqual('checking number of component factories', 1, EF.componentFactoryCount())
    EF.registerComponentFactory('testFactory', function(e) end)
    assertEqual('checking number of component factories', 1, EF.componentFactoryCount())
end

function T.testNoIntialEntites(EF)
    assertEqual('checking number of entities', 0, EF.entityCount())
end

function T.testAddingNilEntity(EF)
    EF.addEntityComponents(nil)
    assertEqual('checking number of entities', 0, EF.entityCount())
end

function T.testAddingOneEntity(EF)
    local entity = {}
    EF.addEntityComponents(entity)
    assertEqual('checking number of entities', 1, EF.entityCount())
end

function T.testGetNonExistentEntityComponent(EF)
    local entity = {}
    EF.addEntityComponents(entity)
    local ca = EF.entityComponents(entity, 'CA')
    assertEqual('checking number of entities', 1, EF.entityCount())
    assertEqual('checking component ca', nil, ca)
end

function T.testAddingOneEntityComponent(EF)
    local entity = {}
    EF.addEntityComponents(entity, 'CA')
    local ca, cb = EF.entityComponents(entity, 'CA', 'CB')
    assertEqual('checking number of entities', 1, EF.entityCount())
    assertEqual('checking component ca', '__placeholder "CA"', ca)
    assertEqual('checking component cb', nil, cb)
end

function T.testAddingDuplicateEntity(EF)
    local entity = {}
    EF.addEntityComponents(entity)
    assertEqual('checking number of entities', 1, EF.entityCount())

    EF.addEntityComponents(entity)
    assertEqual('checking number of entities', 1, EF.entityCount())
end

function T.testAddingTwoEntities(EF)
    local entityA = {}
    local entityB = {}
    EF.addEntityComponents(entityA)
    EF.addEntityComponents(entityB)
    assertEqual('checking number of entities', 2, EF.entityCount())
end

function T.testRemovingOneEntity(EF)
    local entity = {}
    EF.addEntityComponents(entity)
    assertEqual('checking number of entities', 1, EF.entityCount())

    EF.destroyEntity(entity)
    assertEqual('checking number of entities', 0, EF.entityCount())
end

function T.testRemovingOneEntityFromTwo(EF)
    local entityA = {}
    local entityB = {}
    EF.addEntityComponents(entityA, 'CA')
    EF.addEntityComponents(entityB, 'CB')
    assertEqual('checking number of entities', 2, EF.entityCount())

    EF.destroyEntity(entityA)
    assertEqual('checking number of entities', 1, EF.entityCount())

    EF.destroyEntity(entityA)
    assertEqual('checking number of entities', 1, EF.entityCount())
end


local function countComponentFactory()
    return { count = 0 }
end

function T.testOneEntityAddedToSystem(EF)
    -- Setup
    local entity = {}
    local function updateCountIncrementerSystem(entities)
        for i, entity in ipairs(entities) do
            local countComponent = EF.entityComponents(entity, 'countComponent')
            countComponent.count = countComponent.count + 1
        end
    end
    EF.addSystem('testGroup', 'testSystem', updateCountIncrementerSystem, 'countComponent')
    EF.registerComponentFactory('countComponent', countComponentFactory)
    EF.addEntityComponents(entity, 'countComponent')
    assertEqual('checking number of entities', 1, EF.entityCount())
    local cc = EF.entityComponents(entity, 'countComponent')
    assertEqual('checking update count', 0, cc.count)

    -- Tell the system to update
    EF.updateSystem('testGroup', 'testSystem')
    cc = EF.entityComponents(entity, 'countComponent')
    assertEqual('checking update count', 1, cc.count)
end

function T.testTwoEntitiesAddedToSystemOnlyOneUpdates(EF)
    -- Setup
    local entityA = {}
    local entityB = {}
    local function updateCountIncrementerSystem(entities)
        for i, entity in ipairs(entities) do
            local countComponent = EF.entityComponents(entity, 'countComponent')
            countComponent.count = countComponent.count + 1
        end
    end
    EF.addSystem('testGroup', 'testSystem', updateCountIncrementerSystem, 'countComponent')
    EF.registerComponentFactory('countComponent', countComponentFactory)
    EF.addEntityComponents(entityA, 'countComponent')
    EF.addEntityComponents(entityB)
    assertEqual('checking number of entities', 2, EF.entityCount())
    local ccA = EF.entityComponents(entityA, 'countComponent')
    local ccB = EF.entityComponents(entityB, 'countComponent')
    assertEqual('checking update count A', 0, ccA.count)
    assertEqual('checking update count B', nil, ccB)

    -- Tell the system to update
    EF.updateSystem('testGroup', 'testSystem')

    ccA = EF.entityComponents(entityA, 'countComponent')
    ccB = EF.entityComponents(entityB, 'countComponent')
    assertEqual('checking update count A', 1, ccA.count)
    assertEqual('checking update count B', nil, ccB)
end

function T.testTwoEntitiesAddedToSystemBothUpdate(EF)
    -- Setup
    local entityA = {}
    local entityB = {}
    local function updateCountIncrementerSystem(entities)
        for i, entity in ipairs(entities) do
            local countComponent = EF.entityComponents(entity, 'countComponent')
            countComponent.count = countComponent.count + 1
        end
    end
    EF.addSystem('testGroup', 'testSystem', updateCountIncrementerSystem, 'countComponent')
    EF.registerComponentFactory('countComponent', countComponentFactory)
    EF.addEntityComponents(entityA, 'countComponent')
    EF.addEntityComponents(entityB, 'countComponent')
    assertEqual('checking number of entities', 2, EF.entityCount())
    local ccA = EF.entityComponents(entityA, 'countComponent')
    local ccB = EF.entityComponents(entityB, 'countComponent')
    assertEqual('checking update count A', 0, ccA.count)
    assertEqual('checking update count B', 0, ccB.count)

    -- Tell the system to update
    EF.updateSystem('testGroup', 'testSystem')

    ccA = EF.entityComponents(entityA, 'countComponent')
    ccB = EF.entityComponents(entityB, 'countComponent')
    assertEqual('checking update count A', 1, ccA.count)
    assertEqual('checking update count B', 1, ccB.count)
end

function T.testEntityAddedToSystemAfterInitialAdd(EF)
    -- Setup
    local entityA = {}
    EF.addSystem('testGroup', 'testSystem', function() end, 'C')
    EF.addEntityComponents(entityA)
    assertEqual('checking number of entities', 1, EF.entityCount())

    local c = EF.entityComponents(entityA, 'C')
    assertEqual('checking component', nil, c)
    local entitiesCount = EF.systemEntityCount()
    assertEqual('checking system entities', 0, entitiesCount.testGroup.testSystem)

    -- Add the component to the entity
    EF.addEntityComponents(entityA, 'C')
    c = EF.entityComponents(entityA, 'C')
    assertEqual('checking component', '__placeholder "C"', c)
    entitiesCount = EF.systemEntityCount()
    assertEqual('checking system entities', 1, entitiesCount.testGroup.testSystem)
end

function T.testEntityAddedToNewSystem(EF)
    -- Setup
    local entityA = {}
    EF.addEntityComponents(entityA, 'C')
    assertEqual('checking number of entities', 1, EF.entityCount())

    EF.addSystem('testGroup', 'testSystem', function() end, 'C')

    local entitiesCount = EF.systemEntityCount()
    assertEqual('checking system entities', 1, entitiesCount.testGroup.testSystem)
end

function T.testEntityRemovedFromSystemAfterInitialAdd(EF)
    -- Setup
    local entityA = {}
    EF.addSystem('testGroup', 'testSystem', function() end, 'C')
    EF.addEntityComponents(entityA, 'C')
    assertEqual('checking number of entities', 1, EF.entityCount())

    local c = EF.entityComponents(entityA, 'C')
    assertEqual('checking component', '__placeholder "C"', c)
    local entitiesCount = EF.systemEntityCount()
    assertEqual('checking system entities', 1, entitiesCount.testGroup.testSystem)

    -- Add the component to the entity
    EF.removeEntityComponents(entityA, 'C')
    c = EF.entityComponents(entityA, 'C')
    assertEqual('checking component', nil, c)
    entitiesCount = EF.systemEntityCount()
    assertEqual('checking system entities', 0, entitiesCount.testGroup.testSystem)
end

function T.testEntityPlaceholderComponentUpdatedWithReal(EF)
    -- Setup
    local entityA = {}
    EF.addEntityComponents(entityA, 'C')
    assertEqual('checking number of entities', 1, EF.entityCount())

    local c = EF.entityComponents(entityA, 'C')
    assertEqual('checking component', '__placeholder "C"', c)

    EF.registerComponentFactory('C', countComponentFactory)

    c = EF.entityComponents(entityA, 'C')
    assertEqual('checking component', 0, c.count)
end

------------------------------------------------------------------------------
-- Runner --------------------------------------------------------------------
------------------------------------------------------------------------------
function M.runAll()
    print('Running tests...')
    for name, test in pairs(T) do
        -- Force load/reload of package
        package.loaded['nah.entityframework'] = nil
        -- Ignore errors as testing will exercise some of them
        local EF = require 'nah.entityframework'
        EF.treatWarningsAsErrors = false
        EF.supressWarningTraceback = true
        print('  ' .. name)
        test(EF)
    end
    return results
end

return M
