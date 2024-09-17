local component = require("component")
local rs = component.redstone -- Redstone component
--local me = component.me_controller -- or component.me_controller depending on setup
local tp = component.transposer
local reactor = component.reactor_chamber
local meExport = component.me_exportbus
--local reactor_inv = component.inventory_controller
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

local fuel = {
  damage = 0,
  hasTag = false,
  label = "Quad Fuel Rod (High Density Plutonium)",
  maxDamage = 100,
  maxSize = 64,
  name = "GoodGenerator:rodCompressedPlutonium4",
  size = 1
}

local coolant = {
  damage = 0,
  hasTag = false,
  label = "360k NaK Coolantcell",
  maxDamage = 100,
  maxSize = 1,
  name = "gregtech:gt.360k_NaK_Coolantcell",
  size = 1
}

function exportFuel(slot)
    transferItem(side.left, side.bot, 1, slot, 1) -- takes item out of slot
    meExport.setExportConfiguration(4, fuel)
    os.sleep(.5)
    meExport.setExportConfiguration(4, nil)

    if reactor_inv.getStackInSlot(1, slot) == nil then
        return false
    end
    return true
end

function exportCoolant(slot)
    transferItem(side.left, side.bot, 1, slot, 1) -- takes item out of slot
    meExport.setExportConfiguration(4, coolant)
    os.sleep(.5)
    meExport.setExportConfiguration(4, nil)

    if reactor_inv.getStackInSlot(1, slot) == nil then
        return false
    end
    return true
end

-- Replace dead cells O(n)
function check_and_replace()
  for i, slot in ipairs(slot_order) do
    print("i:" .. tostring(i) .. ", slot num:" .. tostring(slot))
    local item = reactor_inv.getStackInSlot(1, slot) --  side 1, slot X
    if item then
      if item.name == "GoodGenerator:rodCompressedPlutoniumDepleted4" then
        print("found deplated fuel cell in slot:"  .. tostring(slot))

        if not(exportFuel(slot)) then
            print("ERROR: failed to replace fuel cell in slot:"  .. tostring(slot))
        end
        
      elseif item.name == "gregtech:gt.360k_NaK_Coolantcell" and item.damage/item.maxDamage <= .75 then
        print("found deplated coolantcell in slot:"  .. tostring(slot))
        -- turn off reactor
        rs.setOutput(sides.back, 0) -- Don't Send redstone signal

        if not(exportCoolant(item, 1)) then
            print("ERROR: failed to replace coolantcell in slot:"  .. tostring(slot))
            print("Reactor stays off")
            return false
        end
        -- turn on reactor
        rs.setOutput(sides.back, 15) -- Don't Send redstone signal

      end
    end
  end
end


-- Main loop to continuously check the reactor

while true do
  term.clear()
  check_and_replace()
  os.sleep(1) -- Adjust sleep time as needed
end