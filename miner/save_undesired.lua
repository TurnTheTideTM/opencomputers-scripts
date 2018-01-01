local database = require('database')
local component = require("component")
local sides = require("sides")

local entries, entries_count = database.get_all_db_entries()
print("Current list of undesired blocks:")
for entry in pairs(entries) do
    print(entry)
end

local new = component.geolyzer.analyze(sides.front)
local answer
repeat
    print("Do you want to add " .. new.name .. "? [y/n]")
    answer = io.read()
until answer=="y" or answer=="n"

if answer=="y" then
    component.geolyzer.store(sides.front, database.dbAdress(), entries_count+1)
    print("New undesired block saved.")
end
