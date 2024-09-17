-- Memory setup script to store addresses in a file (memory_setup.lua)
local component = require("component")
local fs = require("filesystem")

-- Get addresses of inventory controllers
local controllers = {}
for address, name in component.list("inventory_controller") do
    table.insert(controllers, address)
end

function is_me_system(controller)
    return not(controller.getSlotMazStackSize(1,1) == 1)
end

function is_reactor(controller)
    return controller.getSlotMazStackSize(1,1) == 1
end

local file = io.open("/home/config.txt", "w")

-- Save the addresses in a configuration file
if is_me_system(component.proxy(controllers[1])) then
    file:write("ME_CONTROLLER_ADDRESS=" .. controllers[1] .. "\n") 
    file:write("REACTOR_CONTROLLER_ADDRESS=" .. controllers[2] .. "\n")
else
    file:write("ME_CONTROLLER_ADDRESS=" .. controllers[2] .. "\n") 
    file:write("REACTOR_CONTROLLER_ADDRESS=" .. controllers[1] .. "\n")
end
file:close()



print("Memory setup complete and saved to file.")