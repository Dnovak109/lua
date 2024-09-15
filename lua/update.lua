local shell = require("shell")
local computer = require("computer")

-- Set the working directory where the updates will be applied
shell.setWorkingDirectory("/home/reactorSetup/")

-- Remove old files
--shell.execute("rm file.lua")

-- Update by downloading new files from your repository
print("Updating")
-- shell.execute("wget https://raw.githubusercontent.com/Dnovak109/lua/master/lua/")
-- shell.execute("wget https://raw.githubusercontent.com/Dnovak109/lua/master/lua/update.lua")

-- Return to the home directory
shell.setWorkingDirectory("/home/")
print("Would you like to reboot? (Y/n)")

local answer = io.read()

if answer == "Y" or answer == "y" then
    print("Rebooting...")
    local computer = require("computer")
    computer.shutdown(true) -- Reboots the system
else
    print("No reboot.")
end
print("Rebooting")

-- Reboot the computer
computer.shutdown(true)