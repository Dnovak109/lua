local component = require("component")
local me = component.me_controller -- assumes the ME Controller is connected to the OpenComputers network

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

-- Print the total count of each item
for label, count in pairs(itemCounts) do
  print(label .. ": " .. count)
end