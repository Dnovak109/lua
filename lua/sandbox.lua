local component = require("component")
local me_controller = component.me_controller
local items = me_controller.allItems()

if items then
  for i, item in ipairs(items) do
    if item then
      print("Item: " .. item.label .. ", Size: " .. item.size)
    end
  end
else
  print("No items found or issue with ME controller.")
end