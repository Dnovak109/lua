local shell = require("shell")
local computer = require("computer")


-- Update by downloading new files from your repository
print("Updating")
-- shell.execute("wget -f https://raw.githubusercontent.com/Dnovak109/lua/master/lua/")
   shell.execute("wget -f https://raw.githubusercontent.com/Dnovak109/lua/master/lua/update.lua")
   shell.execute("wget -f https://raw.githubusercontent.com/Dnovak109/lua/master/lua/Reactor.lua")
   shell.execute("wget -f https://raw.githubusercontent.com/Dnovak109/lua/master/lua/sandbox.lua")
   shell.execute("wget -f https://raw.githubusercontent.com/Dnovak109/lua/master/lua/displayItems.lua")
   shell.execute("wget -f https://raw.githubusercontent.com/Dnovak109/lua/master/lua/controller.lua")
   shell.execute("wget -f https://raw.githubusercontent.com/Dnovak109/lua/master/lua/setup.lua")


--[[
print("Would you like to reboot? (Y/n)")

local answer = io.read()

if answer == "Y" or answer == "y" then
    print("Rebooting...")
    local computer = require("computer")
    computer.shutdown(true) -- Reboots the system
else
    print("No reboot.")
end
]]