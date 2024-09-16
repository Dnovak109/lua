local component = require("component")
local term = require("term")
local event = require("event")
local me = component.me_controller -- ME Controller component
local rc = component.reactor_chamber -- reactor_chamber
local gpu = component.gpu -- GPU to handle screen drawing

local rs = component.redstone -- Redstone component
local sides = require("sides") -- Sides to specify where to send the redstone signal

-- Configure screen resolution
gpu.setResolution(80, 25) -- Adjust this according to your screen size

-- Function to get and display the item counts
local function displayItemCounts()
  term.clear()

  -- Get all stored items
  local items = me.getItemsInNetwork()

  -- Create a table to hold the count of each item
  local itemCounts = {}

  -- Iterate through the items and count them
  for _, item in ipairs(items) do
    if itemCounts[item.label] then
      itemCounts[item.label] = itemCounts[item.label] + item.size
    else
      itemCounts[item.label] = item.size
    end
  end

  local heat = rc.getHeat()
  print("Reactor Heat: " .. rc.getHeat()/100)
  
  -- Check for "360k NaK Coolantcell" count and stop if it drops below 2
  local nakCount = itemCounts["360k NaK Coolantcell"]
  if nakCount and nakCount < 2 then
    print("360k NaK Coolantcell dropped below 2.\nReactor_chamber: off.")
    rs.setOutput(sides.back, 0) -- Don't Send redstone signal

   elseif rc.getHeat() > 8000 then
    print("TOO HOT!!!\nReactor_chamber: off.")
    rs.setOutput(sides.back, 0) -- Don't Send redstone signal
  else
    print("Reactor_chamber: on.")
    rs.setOutput(sides.back, 15) -- Send redstone signal
  end

end

-- Main loop to update the display every 5 ticks
while true do
  displayItemCounts()
  event.pull(0.25) -- Wait for 5 ticks (1 tick = 0.05 seconds, so 5 ticks = 0.25 seconds)
end