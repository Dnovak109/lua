local component = require("component")
local me = component.me_controller -- or component.me_controller depending on setup
local reactor = component.reactor_chamber
local sides = require("sides")
local term = require("term")

-- Order of slots to fill (customize as per your reactor layout)
local slot_order = {
  1, 2, 3, 4, 5, 6, 
  7, 8, 9, 10, 11, 12, 
  13, 14, 15, 16, 17, 18, 
  19, 20, 21, 22, 23, 24, 
  25, 26, 27, 28, 29, 30, 
  31, 32, 33, 34, 35, 36
}
-- Function to request items from the ME system
function request_item(item_name, amount)
--  local me = component.me_interface -- this will be connected to the main network
  local items = me.getItemsInNetwork({name = item_name})
  if #items > 0 and items[1].size >= amount then
    me.exportItem(items[1], sides.bottom, amount)  -- Adjust side as needed
    return true
  else
    return false
  end
end

-- Replace dead cells
function check_and_replace()
  for i, slot in ipairs(slot_order) do
    print("i:" .. tostring(i) .. ", slot num:" .. tostring(slot))
    local item = reactor.getStackInSlot(slot)
    if item then
      print("found item:" .. item.name)

    --[[
      if item.name == "ic2:reactorQuadFuelRodDepleted" then
        print("found deplated cell")
      end
      ]]
    end
  end
end

      --[[ Check if it's a fuel/coolant cell and if it's dead
      if item.name == "ic2:reactorFuelRod" or item.name == "ic2:reactorCoolantCell" then
        if item.damage == item.maxDamage then
          -- Remove dead cell from reactor
          reactor.pushItem(sides.bottom, slot, 1)
          -- Request a fresh cell from ME network
          if item.name == "ic2:reactorFuelRod" then
            request_item("ic2:reactorFuelRod", 1)
          elseif item.name == "ic2:reactorCoolantCell" then
            request_item("ic2:reactorCoolantCell", 1)
          end
          -- Insert new cell into reactor
          reactor.pullItem(sides.top, slot)
          
        end
      end
      ]]


-- Main loop to continuously check the reactor
while true do
  term.clear()
  check_and_replace()
  os.sleep(1) -- Adjust sleep time as needed
end