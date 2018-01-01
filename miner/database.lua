local database = {}

local component = require("component")

function database.add_to_set(set, key)
    set[key] = true
end

function database.remove_from_set(set, key)
    set[key] = nil
end

function database.set_contains(set, key)
    return set[key] ~= nil
end

function database.get_all_db_entries()
    local results = {['minecraft:air']=true}
    local counter = 1
    local next = component.database.get(counter)
    while next do
        database.add_to_set(results, next.name)
        counter = counter + 1
        next = component.database.get(counter)
    end
    return results, counter-1
end

function database.dbAdress()
    return component.database.address
end

return database

