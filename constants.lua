
-- UNITS OF DATA SIZE
KB = { name = "Kilobyte(s)", value = 1024 }
MB = { name = "Megabyte(s)", value = 1024 * KB.value }
GB = { name = "Gigabyte(s)", value = 1024 * MB.value }
TB = { name = "Terabyte(s)", value = 1024 * GB.value }

BIT = { name = "Bit(s)", value = 1 }
KBIT = { name = "Kilobit(s)", value = 1000 }
MBIT = { name = "Megabit(s)", value = 1000 * KBIT.value }
GBIT = { name = "Gigabit(s)", value = 1000 * MBIT.value }
TBIT = { name = "Terabit(s)", value = 1000 * GBIT.value }

-- UNITS OF DISTANCE
METER = { name = "Meter(s)", value = 1 }
MILLIMETER = { name = "Millimeter(s)", value = 0.001 * METER.value }
CENTIMETER = { name = "Centimeter(s)", value = 0.01 * METER.value }
DECIMETER = { name = "Decimeter(s)", value = 0.1 * METER.value }
KILOMETER = { name = "Kilometer(s)", value = 1000 * METER.value }
-- Extras
INCH = { name = "Inch(es)", value = 0.0254 * METER.value }
POINT = { name = "Point(s)", value = 1 }

-- UNITS OF TIME
SECOND = { name = "Second(s)", value = 1 }
MINUTE = { name = "Minute(s)", value = 60 * 60 }
HOUR = { name = "Hour(s)", value = 60 * MINUTE.value }
DAY = { name = "Day(s)", value = 24 * HOUR.value }
WEEK = { name = "Week(s)", value = 7 * DAY.value }
MONTH = { name = "Month(s)", value = 30 * DAY.value } -- Approximation
YEAR = { name = "Year(s)", value = 365 * DAY.value }  -- Approximation

-- OPERATORS
OPERATOR_SQUARED = "^2"
OPERATOR_CUBED = "^3"
OPERATOR_SQUARE_ROOT = "^(1/2)"
PERCENT = { name = "%" }

-- NATURAL LANGUAGE
OVER = " / "
