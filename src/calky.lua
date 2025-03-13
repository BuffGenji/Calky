require("constants")
local create = {}
-----------------------------------------------------------------------------------------------------------------------
--[[
    CREATE FUNCTION
]]

function create.value(number, units)
    local element = {}
    element["number"] = number
    element["units"] = units
    setmetatable(element, {
        __tostring = function() return tostring(element["number"]) .. " " .. element["units"].name end,
        __len = function() return string.len(element["number"] .. " : " .. element["units"].name) end,
        __mul = function(_, othervalue)
            if type(othervalue) == "number" then
                return element["number"] * othervalue
            else
                return element["number"] * othervalue["number"]
            end
        end,
        __div = function(_, othervalue)
            if type(othervalue) == "number" then
                return element["number"] / othervalue
            else
                return element["number"] / othervalue["number"]
            end
        end,
        __add = function(_, othervalue)
            if type(othervalue) == "number" then
                return element["number"] + othervalue
            else
                return element["number"] + othervalue["number"]
            end
        end,
        __sub = function(_, othervalue)
            if type(othervalue) == "number" then
                return element["number"] - othervalue
            else
                return element["number"] - othervalue["number"]
            end
        end
    })
    local history_of_descripitons = {}
    local description = ""
    function element.setDescription(des)
        description = des
        local current_value = element
        table.insert(history_of_descripitons, { des = des, value = current_value })
        return element -- only returns value so that it can be chained with showDescription
    end

    function element.getDescription()
        return description
    end

    function element.showDescription()
        print(element.getDescription())
    end

    function element.getHistory()
        for _, p in ipairs(history_of_descripitons) do
            print("Description : " .. p.des)
            print("State of value : " .. tostring(p.value))
        end
    end

    function element.getUnit(unit)
        if (element["units"].value == nil) then
            element["number"] = element["number"] / unit.value
        else
            element["number"] = (element["number"] * element["units"].value) / unit.value
        end
        element["units"] = unit
        return element
    end

    function element.show(variable_to_show)
        if (element["units"].name == nil) then
            print(variable_to_show .. " : " .. element["number"])
        end
        if (element["units"] == PERCENT) then
            print(variable_to_show .. " : " .. element["number"] * 100 .. " " .. element["units"].name)
        else
            print(variable_to_show .. " : " .. element["number"] .. " " .. element["units"].name)
        end
        return element
    end

    return element
end

return create
