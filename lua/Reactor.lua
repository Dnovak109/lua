local component = require("component")
local me = component.me_controller  -- Access the ME controller
--local inventory = component.inventory_controller -- For storing items in a nearby chest or internal inventory

-- The item name from the ME network
local itemName = "Quad Fuel Rod (High Density Plutonium)"
local amount = 10 -- Number of items to extract

-- Create a descriptor to search for the specific item
local itemDescriptor = {label = itemName}  -- Note: using 'label' for exact match

-- Try to extract the item from the ME network
local success, reason = me.extractItem(itemDescriptor, amount)

if success then
    print("Successfully extracted " .. amount .. " of " .. itemName)
    -- Optional: Insert into the first slot of an attached chest or internal inventory
    --inventory.store(amount, 1)
else
    print("Error: Could not extract item. Reason: " .. (reason or "Item not found in ME network."))
end