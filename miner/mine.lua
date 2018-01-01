local database = require("database")
local sides = require("sides")
local component = require("component")
local robot = require("robot")
local fuel = require("fuel")

undesired, _ = database.get_all_db_entries()

function detect(direction)
    local block = component.geolyzer.analyze(direction)
    return not database.set_contains(undesired, block.name)
end

function detect_all_directions()
    if detect(sides.left) then
        return sides.left
    elseif detect(sides.right) then
        return sides.right
    elseif detect(sides.up) then
        return sides.up
    elseif detect(sides.down) then
        return sides.down
    elseif detect(sides.front) then
        return sides.front
    else
        return nil
    end
end

function detect_all_and_mine()
    local direction = detect_all_directions()
    while direction do
        if direction == sides.left then
            robot.turnLeft()
            if mine_and_move_forward(1) then
                robot.back()
            end
            robot.turnRight()
        elseif direction == sides.right then
            robot.turnRight()
            if mine_and_move_forward(1) then
                robot.back()
            end
            robot.turnLeft()
        elseif direction == sides.up then
            if mine_and_move_up() then
                robot.down()
            end
        elseif direction == sides.down then
            if mine_and_move_down() then
                robot.up()
            end
        elseif direction == sides.front then
            if mine_and_move_forward(1) then
                robot.back()
            end
        end
        direction = detect_all_directions()
    end
end

function mine_and_move_forward(length)
    if robot.detect() then
        robot.swing(sides.front)
    end
    if robot.forward() then
        detect_all_and_mine()
        if length > 1 then
            return mine_and_move_forward(length-1)
        else
            return true
        end
    else
        return false
    end
end

function mine_and_move_up()
    if robot.detectUp() then
        robot.swingUp(sides.up)
    end
    if robot.up() then
        detect_all_and_mine()
        return true
    else
        return false
    end
end

function mine_and_move_down()
    if robot.detectDown() then
        robot.swingDown(sides.down)
    end
    if robot.down() then
        detect_all_and_mine()
        return true
    else
        return false
    end
end

function dig_tunnel(length)
    mine_and_move_forward(length)
    robot.turnAround()
    mine_and_move_forward(length)
end

function dig_mine(length, width)
    for i=1,length,3 do
        fuel.refuel()
        mine_and_move_forward(3)
        robot.turnLeft()
        dig_tunnel(width)
        dig_tunnel(width)
        robot.turnRight()
    end
    robot.turnAround()
    for i=1,length,3 do
        mine_and_move_forward(3)
    end
    robot.turnAround()
end