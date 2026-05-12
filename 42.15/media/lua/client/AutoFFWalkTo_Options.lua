AutoFFWalkTo = AutoFFWalkTo or {}

local modOptions = PZAPI.ModOptions:create("AutoFFWalkTo", getText("UI_AFFW_ModName"))

local speedOption = modOptions:addComboBox("speed", getText("UI_AFFW_SpeedLabel"), getText("UI_AFFW_SpeedTooltip"))
speedOption:addItem("UI_AFFW_Disabled", false)
speedOption:addItem(">>", true)
speedOption:addItem(">>>", false)
speedOption:addItem(">>>>", false)

function AutoFFWalkTo.getTargetSpeed()
    local opt = PZAPI.ModOptions:getOptions("AutoFFWalkTo")
    local sel = opt:getOption("speed"):getValue()
    if sel == 1 then
        return nil, nil  -- disabled
    elseif sel == 2 then
        return 2, 5      -- FFwd1
    elseif sel == 3 then
        return 3, 20     -- FFwd2
    end
    return 4, 40         -- Wait (Clock)
end
