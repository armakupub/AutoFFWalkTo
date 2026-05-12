require "TimedActions/ISBaseTimedAction"
require "AutoFFWalkTo_Options"

AutoFFWalkTo = AutoFFWalkTo or {}
AutoFFWalkTo.active = false

local function isSinglePlayer()
    return not isClient() and not isServer()
end

local function activateFF()
    if not isSinglePlayer() then return end
    if getGameSpeed() == 0 then return end -- paused

    local speed, multiplier = AutoFFWalkTo.getTargetSpeed()
    if not speed then return end -- disabled

    AutoFFWalkTo.active = true
    setGameSpeed(speed)
    getGameTime():setMultiplier(multiplier)
end

local function deactivateFF()
    if not AutoFFWalkTo.active then return end

    AutoFFWalkTo.active = false
    setGameSpeed(1)
    getGameTime():setMultiplier(1)
end

local origWalkToIsValid = ISWalkToTimedAction.isValid
function ISWalkToTimedAction:isValid()
    if AutoFFWalkTo.active then
        if self.character:getVehicle() then return false end
        return true
    end
    return origWalkToIsValid(self)
end

local origWalkToFIsValid = ISWalkToTimedActionF.isValid
function ISWalkToTimedActionF:isValid()
    if AutoFFWalkTo.active then
        if self.character:getVehicle() then return false end
        return true
    end
    return origWalkToFIsValid(self)
end

local origWalkToStart = ISWalkToTimedAction.start
function ISWalkToTimedAction:start()
    origWalkToStart(self)
    activateFF()
end

local origWalkToPerform = ISWalkToTimedAction.perform
function ISWalkToTimedAction:perform()
    deactivateFF()
    origWalkToPerform(self)
end

local origWalkToStop = ISWalkToTimedAction.stop
function ISWalkToTimedAction:stop()
    deactivateFF()
    origWalkToStop(self)
end

local origWalkToFStart = ISWalkToTimedActionF.start
function ISWalkToTimedActionF:start()
    origWalkToFStart(self)
    activateFF()
end

local origWalkToFPerform = ISWalkToTimedActionF.perform
function ISWalkToTimedActionF:perform()
    deactivateFF()
    origWalkToFPerform(self)
end

local origWalkToFStop = ISWalkToTimedActionF.stop
function ISWalkToTimedActionF:stop()
    deactivateFF()
    origWalkToFStop(self)
end

-- B42 resets game speed to 1 when the player re-clicks during Walk To.
-- Re-apply the configured speed each tick while Walk To is queued.
local function onTick()
    if not AutoFFWalkTo.active then return end
    if not isSinglePlayer() then return end

    local player = getSpecificPlayer(0)
    if not player then
        deactivateFF()
        return
    end

    local queue = ISTimedActionQueue.getTimedActionQueue(player)
    local current = queue and queue.queue and queue.queue[1]
    local isWalkTo = current and (current.Type == "ISWalkToTimedAction" or current.Type == "ISWalkToTimedActionF")

    if not isWalkTo then
        deactivateFF()
        return
    end

    local speed, multiplier = AutoFFWalkTo.getTargetSpeed()
    if getGameSpeed() ~= 0 and getGameSpeed() < speed then
        setGameSpeed(speed)
        getGameTime():setMultiplier(multiplier)
    end
end

Events.OnTick.Add(onTick)
