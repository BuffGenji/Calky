# Calky
Small lua  library to make calculations more readable and simple during class


# Example
This file is in the **src** directory if you wan to copy it 

```lua
local create = require("calky")

-- GéNéRALITéS TDs -------------------------------------------------------------------------------------------------------------------------------------

--[[ --------------------------------------------------------------------------------------------------------------------------------------------------
    EXERCISE 1 - Quantity - How many bytes can something be represented by? -> depends on resolution of capturing device

    Quantity in programming and sofware is measured in bits since it is a smalla nd standardizd value everyone can work with, and if not directly with
    it is easy to then relate to other units of measure.

    To find the quantity of information present on a sheet of paper that a supposed photocopier will copy
    we can find the dimensions off this paper and say that all points will be represented as bits.
    We can find the resolution in the units points/inch^2

    Data given
        - A4 sheet; Dimensions are 210 millimeters by 297 millimeters
        - Resolution of the photocopier is 600 points/inch^2

    This means that the photocopier can only absorb - and thus represent a certain number of bits.
    Each bit represents a point, be it black or white - on or off - 0 or 1.
    And to find the number of points we just need to convert our existing surface mm^2 into inches^2 and multiply by the resolution
]] ----------------------------------------------------------------------------------------------------------------------------------------------------
--Converting to inches squared
local width_in_inches = create.value(210, MILLIMETER).getUnit(INCH)
local height_in_inches = create.value(297, MILLIMETER).getUnit(INCH)
local surface_area = create.value(width_in_inches * height_in_inches, INCH)

--Multiplying by current resolution
local resoltuion_units = POINT.name .. OVER .. INCH.name .. OPERATOR_SQUARE_ROOT
local resolution = create.value(600, resoltuion_units)
local number_of_bits = create.value(resolution * surface_area, POINT)

-- Resolution/Result
number_of_bits.setDescription(
    "The number of bits is the number of points, there are " .. tostring(number_of_bits) .. " and so" ..
    " we will need " .. number_of_bits["number"] / KBIT.value .. " " .. KB.name .. " to store it"
)
-- add ".showDescription()" to fill values

--[[ --------------------------------------------------------------------------------------------------------------------------------------------------
    EXERCISE 2 Transfer speed - When is it better to just send a guy to do it? (Never nowadays)

    Landscape - Distances

    A ----->---- 20 km ---->----- B

    Problem
        - A man on a scooter holding 10 "disquettes" - CDs - drives at 30 km/h, and each "disquette" can store 1.4 MB
        - A telephone line has a transfer speed of 56 Kbit/s

        Which is better over a distance of 20 Km?

        We need to find the "transfer speed" of the man on the scooter. And we will do so by calculating the total information
        he can carry 1.4 MB * 10 = 14 MB over the distance he has to go, 20 Km. Then we compare to find which one has a higher ratio
]] ----------------------------------------------------------------------------------------------------------------------------------------------------

-- Our desired units ( needs to be a table to work nicely with the metamethods, but not a requirement for funtionality )
local KILOBYTES_PER_SECOND = {
    name = KBIT.name .. OVER .. SECOND.name
}

-- TELEPHONE LINE
local transfer_speed_of_telephone_line = create.value(56000, KBIT)

-- DRIVER
local number_of_disquettes = 10
local quantity_per_disquette = 1.4 * MB.value
local total_disquette_storage = create.value(quantity_per_disquette * number_of_disquettes, MB).getUnit(KBIT)
local total_time_for_driver = create.value(20 / 30, HOUR).getUnit(SECOND)
local transfer_speed_of_driver = create.value(total_disquette_storage / total_time_for_driver, KILOBYTES_PER_SECOND)

-- Since the values are in the same units we can check to see which one is bigger ( larger ratio ) and then find the best "mode of transport"
local answer = ""
if (transfer_speed_of_driver["number"] > transfer_speed_of_telephone_line["number"]) then
    answer = "Driver wins!"
else
    if (transfer_speed_of_driver["number"] == transfer_speed_of_telephone_line["number"]) then
        answer = "Wow! A tie!"
    else
        answer = "Telephone line wins!"
    end
end
-- print(answer) -- uncomment to see
--[[

    EXERCISE 3 Theoretical data rate vs Practical data rate

    Finding the practical data rate of a network is done only by actual measuring. There is no mathematical proof for it
    given that it is reliant on hardware and ( if affected ) extreme conditions in the surrounding environment.

    So to find a practical data rate we will take as a precaution 90%

    Problem
        - For a telephone line connection running at a debit of 8000 ech/s of 8 bits/ech which is it's debit theorique.

        Extra information
            - The limit for such a connection - in the interest of keeping it easily reconstructable, which means that we can read the signal
              once we get it - is 4000 Hz. The rule of thumb being that it is to be around half.
]]

-- Once again we need special units not found in the table, so we will create our own
local SAMPLES_PER_SECOND = {
    name = "éch" .. OVER .. SECOND.name -- éch / s
}
local BITS_PER_SAMPLE = {
    name = BIT.name .. OVER .. "éch" -- bit / éch
}
-- the mutiplication of them will give us our desired unit : bit/s
local BIT_PER_SECOND = {
    name = BIT.name .. OVER .. SECOND.name -- bit / s
}

-- We will represent the data rate in bit/s
local samples_per_second = create.value(8000, SAMPLES_PER_SECOND)
local bits_per_sample = create.value(8, BITS_PER_SAMPLE)
local theoretical_transfer_speed = create.value(samples_per_second * bits_per_sample, BIT_PER_SECOND)
local practical_transfer_speed = create.value(theoretical_transfer_speed * 0.9, BIT_PER_SECOND)


-- GéNéRALITéS : SECOND SHEET -------------------------------------------------------------------------------------------------------------------------


--[[---------------------------------------------------------------------------------------------------------------------------------------------------
    EXERCISE 1 - Encoding numbers

    How many bits would it take to encode 10 digits, from 0...9 ?
    Answer -> With 3 bits you get 2^3 = 9 meaning you would need one more bit -> 4 bits
    And, how many if it was a 3-state system? If we encoded in base 3? -> Only 2 -> 3^2 = 9
]] -----------------------------------------------------------------------------------------------------------------------------------------------------

--[[---------------------------------------------------------------------------------------------------------------------------------------------------
    EXERCISE 2 - Sending data

    What is the delay in sending a number of bits accross a network that passes through multiple devices (stations) ?

    To find this we would need to know that there is a transmission time -> number of bits to send / the data rate
    and there is a propagation delay ->   total length of the ring / speed of light (in a medium such as a copper wire or fiber optic cable)

    Let's try an example :
        - Data rate of the network is : 10 Mbit / s
        - Q (Quantity) : 1000 bits
        - Data integrity : 16 bits -- these are bits that ensure that the actual data got sent through correctly -> DLE,ETX,STX...

    Problem 1
        - How many messages would you have to send to get a file of 4 Mbits from one station to another?
]] -----------------------------------------------------------------------------------------------------------------------------------------------------
local network_data_rate = create.value(10 * MBIT.value, MBIT).getUnit(BIT)
local quantity_on_network = create.value(1000, BIT)
local network_data_integrity = create.value(16, BIT)

-- We calculate the amount of bits the file is and we divide by the quantity we can send minus the bits reserved for the data integrity
local file_bits = create.value(4 * MBIT.value, MBIT).getUnit(BIT)
local data_per_message = create.value(quantity_on_network - network_data_integrity, BIT)
local number_of_messages = create.value(file_bits / data_per_message, { name = "Messages" })
local transmission_time = create.value(data_per_message / network_data_rate, BIT_PER_SECOND)

--[[---------------------------------------------------------------------------------------------------------------------------------------------------
    ADDING CONDITIONS

    Now we will will check that we can only send the next message once we have verified that the message has been sent correctly,
    and doing so means we need to wait for the packet of information ( actual data + bits to verify ), which adds time for every go.

    Now for each message we need to add propagation delay, going and comin gback (x2)
    In this example the length of the ring is 1 Km and the speed in the medium is 200000 Km/s

]] -----------------------------------------------------------------------------------------------------------------------------------------------------

-- We need to create our Km/s unit
local KILOMETER_PER_SECOND = {
    name = KILOMETER.name .. OVER .. SECOND.name
}
local distance_between_stations = 1 -- Km
local propagation_speed = 200000 -- Km/s

-- Calculating propagation delay for the sending and recieving of the messages
local ring_length = create.value(distance_between_stations, KILOMETER)
local speed_of_data_in_network = create.value(propagation_speed, KILOMETER_PER_SECOND)
local there_and_back_delay = create.value(2 * (ring_length / speed_of_data_in_network), SECOND)
-- there_and_back_delay.show("Minimum duration needed before sending next message")
local total_time_to_send_no_propagation_delay = create.value(file_bits / network_data_rate, SECOND)
-- total_time_to_send_no_propagation_delay.show("Time to send full file without propagation delay")
local efficiency_of_system = create.value(data_per_message/quantity_on_network, PERCENT)
-- efficiency_of_system.show("Efficiency of the network")

```