-- Memory setup script to store addresses in a file (memory_setup.lua)
local component = require("component")
local fs = require("filesystem")

-- Get addresses of inventory controllers
local controllers = {}
for address, name in component.list("inventory_controller") do
    table.insert(controllers, address)
end


function is_me_system(address)
    local proxy = component.proxy(address)
    print(proxy.getInventoryName(1))
    return proxy.getInventoryName(1) == "tile.fluid_interface" or proxy.getInventoryName(1) == "tile.appliedenergistics2.BlockController" or proxy.getInventoryName(1) == "tile.BlockInterface"
end

-- Save the addresses in a configuration file
local file = io.open("/home/config.txt", "w")

if is_me_system(controllers[1]) then
    file:write("ME_CONTROLLER_ADDRESS=" .. controllers[1] .. "\n") 
    file:write("REACTOR_CONTROLLER_ADDRESS=" .. controllers[2] .. "\n")
    print("ME_CONTROLLER_ADDRESS=" .. controllers[1] .. "\n") 
    print("REACTOR_CONTROLLER_ADDRESS=" .. controllers[2] .. "\n")
else
    file:write("ME_CONTROLLER_ADDRESS=" .. controllers[2] .. "\n") 
    file:write("REACTOR_CONTROLLER_ADDRESS=" .. controllers[1] .. "\n")
    print("ME_CONTROLLER_ADDRESS=" .. controllers[2] .. "\n") 
    print("REACTOR_CONTROLLER_ADDRESS=" .. controllers[1] .. "\n")
end
file:close()

print("Memory setup complete and saved to file.")