local component = require("component")
local me = component.me_controller -- or component.me_controller depending on setup
local reactor = component.reactor_chamber
--local reactor_inv = component.inventory_controller
local sides = require("sides")
local term = require("term")

function load_addresses()
    local addresses = {}
    for line in io.lines("/home/memory_config.txt") do
        local key, value = line:match("([^=]+)=([^=]+)")
        addresses[key] = value
    end
    return addresses
end

-- Load the addresses from the file
local addresses = load_addresses()

-- Use the loaded addresses
local me_inv = component.proxy(addresses["ME_CONTROLLER_ADDRESS"])
local reactor_inv = component.proxy(addresses["REACTOR_CONTROLLER_ADDRESS"])


-- Order of slots to fill (customize as per your reactor layout)
local slot_order = {
  1, 2, 3, 4, 5, 6, 
  7, 8, 9, 10, 11, 12, 
  13, 14, 15, 16, 17, 18, 
  19, 20, 21, 22, 23, 24, 
  25, 26, 27, 28, 29, 30, 
  31, 32, 33, 34, 35, 36
}

function is_reactor_empty()
    for slot = 1, total_slots do
        local item = inventory.getStackInSlot(1, slot)
        if item then
            return false -- If any slot has an item, reactor is not empty
        end
    end
    return true -- If no items were found, reactor is empty
end

function fill_reactor()

end


function put_item_in_me(slot)
    -- Check if there's an item in the specified slot
    local item = inventory.getStackInSlot(1, slot)

    if item then
        -- Attempt to store the item from the specified slot into the ME system
        local success = me.store(nil, nil, slot, item.size) -- nil filter and database address, stores the entire stack
        
        if success then
            return true
        else
            return false
        end
    else
        return false
    end
end


-- Function to request items from the ME system
function request_item(item, amount)
--  local me = component.me_interface -- this will be connected to the main network
  local items = me.getItemsInNetwork({name = item.name})
  local craftables = me.getCraftables({name = item.name})
  if amount == -1 then
          local crafting_job = craftables[1].request(1)

  if #items > 0 and items[1].size >= amount then
    if #items < 1 or items[1].size < 1 then -- lets just make a spare
        local crafting_job = craftables[1].request(1)
    end

    me.exportItem(items[1], sides.bottom, amount)  -- Adjust side as needed
    return true
  else
  --make the item
    if not(#craftables > 0) then -- this way if i get false on request coolantcell nothing needs to blow up
        return false
    end

    local crafting_job = craftables[1].request(2)
    while not(crafting_job.isDone()) do -- this is a busy wait
    end
    --export the item
    me.exportItem(items[1], sides.bottom, amount)  -- Adjust side as needed
    return true

  end
end

-- Replace dead cells O(n)
function check_and_replace()
  for i, slot in ipairs(slot_order) do
    print("i:" .. tostring(i) .. ", slot num:" .. tostring(slot))
    local item = reactor_inv.getStackInSlot(1, slot) --  side 1, slot X
    if item then
      if item.name == "GoodGenerator:rodCompressedPlutoniumDepleted4" then
        print("found deplated fuel cell in slot:"  .. tostring(slot))
        put_item_in_me(slot)
        if not(request_item(item, 1)) then
            print("ERROR: failed to replace fuel cell in slot:"  .. tostring(slot))
        end

      elseif item.name == "gregtech:gt.360k_NaK_Coolantcell" and item.damage == item.maxDamage then
        print("found deplated coolantcell in slot:"  .. tostring(slot))
        -- turn off reactor
        put_item_in_me(slot)
        if not(request_item(item, 1)) then
            print("ERROR: failed to replace coolantcell in slot:"  .. tostring(slot))
            print("Reactor stays off")
            return false
        end
        -- turn on reactor
      end
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
if is_reactor_empty() then
    fill_reactor()
end

while true do
  --term.clear()
  check_and_replace()
  os.sleep(1) -- Adjust sleep time as needed
end