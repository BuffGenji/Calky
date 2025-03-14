require("constants")
local create = {}
-----------------------------------------------------------------------------------------------------------------------

-- HELPER FUNCTIONS

local function convert_to_string(value)
    if type(value) == "table" and value["quantity"] and value["units"] and value["units"].name then
        return tostring(value["quantity"]) .. " " .. value["units"].name
    elseif type(value) == "string" or type(value) == "number" then
        return tostring(value)
    else
        return "Invalid"
    end
end

local operation_constants = {
    ADD = "addition", SUBTRACT = "subtraction", MULTIPLY = "mutliplication", DIVIDE = "division"
}
local function do_operation(current_table, other_table_or_number, operation)
    if operation == operation_constants.ADD then
        return current_table["quantity"] + other_table_or_number["quantity"]
    end
    if operation == operation_constants.SUBTRACT then
        return current_table["quantity"] - other_table_or_number["quantity"]
    end
    if operation == operation_constants.MULTIPLY then
        return current_table["quantity"] * other_table_or_number["quantity"]
    end
    if operation == operation_constants.DIVIDE then
        return current_table["quantity"] / other_table_or_number["quantity"]
    end
end

local function isNumber(element_to_check)
    return type(element_to_check) == "number"
end
local function getConstant(type)
    for _, value in pairs(operation_constants) do
        if (type == value) then
            return value
        end
    end
    return nil
end

local function do_arithmetic(table, other_table, type)
    assert(getConstant(type) ~= nil, "Type not found in operation constants table")
    type = getConstant(type)
    if isNumber(other_table) then
        return do_operation(table["quantity"], other_table, type)
    end
    return do_operation(table, other_table, type)
end


MODULES = {
    math, string -- user-defined modules can go here too and will be loaded in any case loaded
}

--[[
    The create function is the biggest so far and I will make another "big" one which will be the creat.unit one
    to make it more easy to make custom types
]]
function create.value(quantity, units)
    assert(type(quantity) == "number", "The quantity input field does not have a number in it")
    assert(type(units) == "table",
        "The units input field does not have a valid unit, create a table with a name value to make your own unit")
    local element = {}
    element["quantity"] = quantity
    element["units"] = units
    setmetatable(element, {
        __tostring = function() return tostring(element["quantity"]) .. " " .. element["units"].name end,
        __concat = function(t1, t2) return convert_to_string(t1) .. " " .. convert_to_string(t2) end,
        __add = function(self, othervalue) return do_arithmetic(self, othervalue, operation_constants.ADD) end,
        __sub = function(self, othervalue) return do_arithmetic(self, othervalue, operation_constants.SUBTRACT) end,
        __mul = function(self, othervalue) return do_arithmetic(self, othervalue, operation_constants.MULTIPLY) end,
        __div = function(self, othervalue) return do_arithmetic(self, othervalue, operation_constants.DIVIDE) end,
    })
    local history_of_descripitons = {}
    local description = ""
    function element.setDescription(des)
        description = des
        local current_value = element
        table.insert(history_of_descripitons, { des = des, value = current_value })
        return element -- only returns value so that it can be chained with showDescription
    end

    function element.showDescription()
        print(element.getDescription())
    end

    function element.getDescription()
        return description
    end

    function element.getHistory()
        for _, p in ipairs(history_of_descripitons) do
            print("Description : " .. p.des)
            print("State of value : " .. tostring(p.value))
        end
    end

    function element.convertTo(unit)
        if (element["units"].value == nil) then
            element["quantity"] = element["quantity"] / unit.value
        else
            element["quantity"] = (element["quantity"] * element["units"].value) / unit.value
        end
        element["units"] = unit
        return element
    end

    function element.show(...)
        local args = { ... }             
        local number_of_elements = #args

        if number_of_elements == 0 then
            print(element)
            return element
        elseif number_of_elements == 1 then
            print(tostring(tostring(args[1]) .. " -> " .. element.getQuantity() .. element.getUnits()))
            return element
        else
            warn("Multiple arguments will just be concatenated")
            local result = ""
            for i = 1, number_of_elements do
                local arg = tostring(args[i]) 
                if i == 1 then
                    result = arg
                else
                    result = result .. " " .. arg
                end
            end
            print(result)
            return element
        end
    end

    function element.getQuantity()
        if (element["quantity"] == nil) then
            print("Numberfield is empty")
            return nil
        else
            return element["quantity"]
        end
    end

    function element.getUnits()
        if (element["units"] == nil) then
            print("Units field is empty")
            return nil
        else
            return element["units"]
        end
    end

    for _, mod in ipairs(MODULES) do
        for k, v in pairs(mod) do
            if type(v) == "function" then
                element[k] = function(self)
                    local current = self or element -- to keep "." notation
                    if current["quantity"] == nil then
                        error("The 'quantity' field is not initialized in the table.")
                    end
                    current["quantity"] = v(current["quantity"])
                    return current
                end
            end
        end
    end
    return element
end

--[[
    This function serves to create units not found in the table
]]
function create.simpleUnit(unit_name)
    local unit = {
        name = tostring(unit_name)
    }
    setmetatable(unit, {
        __tostring = function()
            return unit.name
        end
    })

    function unit.over(given_unit)
        return create.simpleUnit(unit.name .. "/" .. given_unit.name)
    end

    function unit.by()
        return create.simpleUnit(unit.name .. "*")
    end

    function unit.parenthesis(...)
        local args = { ... }             
        local number_of_elements = #args 

        if number_of_elements == 0 then
            return create.simpleUnit("(" .. unit.name .. ")")
        elseif number_of_elements == 1 then
            return unit
        else
            local result = ""
            for i = 1, number_of_elements do
                local arg = tostring(args[i])
                if i == 1 then
                    result = arg.name
                else
                    result = result .. " " .. arg.name
                end
            end
            return create.simpleUnit(unit.name .. "(" .. result .. ")")
        end
    end

    function unit.simpleUnit(unit_name)
        return create.simpleUnit(unit.name .. unit_name)
    end

    function unit.show()
        print(unit.name)
        return unit
    end

    return unit
end

function create.unit()

end

-- This serves as a way to not bloat the code wiht all the extra references to the "create" table
value = {}
setmetatable(value, {
    __call = function(_, quantity, units)
        return create.value(quantity, units)
    end
})

unit = {}
setmetatable(unit, {
    __call = function(_, units)
        return create.simpleUnit(units)
    end
})

return create
