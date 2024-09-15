local component = require("component")
local term = require("term")
local event = require("event")
local me = component.me_controller -- ME Controller component
local gpu = component.gpu -- GPU to handle screen drawing

-- Configure screen resolution
gpu.setResolution(80, 25) -- Adjust this according to your screen size

-- Function to get and display the item counts
local function displayItemCounts()
  term.clear()
  print("Item Counts in AE2 Network:")

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