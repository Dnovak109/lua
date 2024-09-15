local component = require("component")
local me = component.me_controller -- assumes the ME Controller is connected to the OpenComputers network

-- Get all stored items
local items = me.getItemsInNetwork()

-- Print each item's name and amount
for _, item in ipairs(items) do
  print(item.label .. ": " .. item.size)
end