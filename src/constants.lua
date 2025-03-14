-- UNITS OF DATA SIZE
KB = { name = "Kilobyte(s)", value = 1024 }
MB = { name = "Megabyte(s)", value = 1024 ^ 2 }
GB = { name = "Gigabyte(s)", value = 1024 ^ 3 }
TB = { name = "Terabyte(s)", value = 1024 ^ 4 }

BIT = { name = "Bit(s)", value = 1 }
KBIT = { name = "Kilobit(s)", value = 1000 }
MBIT = { name = "Megabit(s)", value = 1000 ^ 2 }
GBIT = { name = "Gigabit(s)", value = 1000 ^ 3 }
TBIT = { name = "Terabit(s)", value = 1000 ^ 4 }

-- UNITS OF DISTANCE
METER = { name = "Meter(s)", value = 1 }
MILLIMETER = { name = "Millimeter(s)", value = 0.001 }
CENTIMETER = { name = "Centimeter(s)", value = 0.01 ^ 2 }
DECIMETER = { name = "Decimeter(s)", value = 0.1 ^ 3 }
KILOMETER = { name = "Kilometer(s)", value = 1000 }
-- Extras
INCH = { name = "Inch(es)", value = 0.0254 }
POINT = { name = "Point(s)", value = 1 }

-- UNITS OF TIME
SECOND = { name = "Second(s)", value = 1 }
MINUTE = { name = "Minute(s)", value = 60 * 1 }
HOUR = { name = "Hour(s)", value = 60 ^ 2 }
DAY = { name = "Day(s)", value = 24 * 60 ^ 2 }
WEEK = { name = "Week(s)", value = 7 * 24 * 60 ^ 2 }
MONTH = { name = "Month(s)", value = 30 * 7 * 24 * 60 ^ 2 }       -- Approximation
YEAR = { name = "Year(s)", value = 365 * 30 * 7 * 24 * 60 ^ 2 }   -- Approximation

-- OPERATORS
OPERATOR_SQUARED = { name = "^2" }
OPERATOR_CUBED = { name = "^3" }
OPERATOR_SQUARE_ROOT = { name = "^(1/2)" }
PERCENT = { name = "%" }

-- NATURAL LANGUAGE
OVER = { name = " / " }


--[[
    This is to give the units more functionality to then be able to be put into
    functions so that it can keep the textual representation
]]

local constants_behaviour_table = {
    __tostring = function(unit)
        return tostring(unit.name) 
    end,
    __concat = function(a, b, c)
        local string_a = (type(a) == "table" and a.name) or tostring(a or "")
        local string_b = (type(b) == "table" and b.name) or tostring(b or "")
        return string_a .. " "..string_b
    end
}

for _, value in pairs(_G) do
    if type(value) == "table" and value.name then
        setmetatable(value, constants_behaviour_table)
    end
end