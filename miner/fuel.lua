local fuel = {}
local component = require('component')
local robot = require('robot')

fuel_slot = 1
inventory_size = robot.inventorySize()

function fuel.refuel()
    local counter = 0
    while (not (component.generator.count() > 10)) and (counter < inventory_size) do
        counter = counter + 1
        robot.select(fuel_slot)
        if not component.generator.insert() then
            fuel_slot = (fuel_slot + 1)%inventory_size
        else
            counter = counter - 1
        end
    end
end

return fuel