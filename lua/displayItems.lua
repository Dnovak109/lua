local component = require("component")
local term = require("term")
local event = require("event")
local inv = component.inventory_controller -- ME Controller component
local rc = component.reactor_chamber -- reactor_chamber
local gpu = component.gpu -- GPU to handle screen drawing

local rs = component.redstone -- Redstone component
local sides = require("sides") -- Sides to specify where to send the redstone signal

-- Configure screen resolution
gpu.setResolution(80, 25) -- Adjust this according to your screen size

-- Function to get and display the item counts
local function displayItemCounts()
  term.clear()
  print("Item Counts in AE2 Network:")

  -- Get all stored items
  local items = me.getItemsInNetwork()

  -- Create a table to hold the count of each item
  -- Iterate through the items and count them
  local itemCounts = {}
  for i = 1, inv.getInventorySize(4) do
    item = inv.getStackInSlot(4, 1)
    if itemCounts[item.label] then
      itemCounts[item.label] = itemCounts[item.label] + item.size
    else
      itemCounts[item.label] = item.size
    end
  end

  
  -- Check for "360k NaK Coolantcell" count and stop if it drops below 2
  local nakCount = itemCounts["360k NaK Coolantcell"]
  if nakCount and nakCount < 2 then
    print("360k NaK Coolantcell dropped below 2.\n Reactor_chamber: off.")
    rs.setOutput(sides.back, 0) -- Don't Send redstone signal
  else
    print("Reactor_chamber: on.")
    rs.setOutput(sides.back, 15) -- Send redstone signal
  end


  -- Print the total count of each item on the display
  for label, count in pairs(itemCounts) do
    print(label .. ": " .. count)
  end
end

-- Main loop to update the display every 5 ticks
while true do
  displayItemCounts()
  event.pull(0.25) -- Wait for 5 ticks (1 tick = 0.05 seconds, so 5 ticks = 0.25 seconds)
end