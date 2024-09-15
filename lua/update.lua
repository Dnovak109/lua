local component = require("component")
local internet = component.internet
local filesystem = require("filesystem")
local shell = require("shell")

-- Define the GitHub URL for raw files (replace USERNAME/REPO and branch/file path)
local baseUrl = "https://raw.githubusercontent.com/Dnovak109/lua/master/lua/"

-- List of files you want to pull from GitHub
local files = {
  "update.lua",
--  "script2.lua"
}

-- Function to download a file from GitHub
local function downloadFile(file)
  local url = baseUrl .. file
  local response = internet.request(url)

  -- Check if the response is valid
  if not response then
    print("Failed to fetch:", url)
    return
  end

  -- Create or overwrite the file on OpenComputers
  local f = io.open("/home/" .. file, "w")

  for chunk in response do
    f:write(chunk)
  end

  f:close()
  print("Downloaded:", file)
end

-- Download all files
for _, file in ipairs(files) do
  downloadFile(file)
end