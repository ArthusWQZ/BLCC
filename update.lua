-- This program installs the common files on the computer. It then runs the update script, that will download the files provided in the configuration.

local REPO = "ArthusWQZ/BLCC"
local BRANCH = "main"
local COMMON_FILES_LIST_PATH = "config-updates/common.json"

local GHRAW_URL = "https://raw.githubusercontent.com/" .. REPO .. "/" .. BRANCH .. "/"

local function downloadFile(url, path)
    -- Replicating the downloaded structure
    local folderPath = fs.getDir(path)
    if not fs.exists(folderPath) and folderPath ~= "" then
        fs.makeDir(folderPath)
    end

    -- Downloading the file
    local response = http.get(url)
    if response then
        local file = fs.open(path, "w")
        file.write(response.readAll())
        file.close()
        response.close()
        print("Downloaded: " .. path)
    else
        print("Failed to download: " .. url)
    end
end

-- THIS DOES NOT CHECK IF THE URL INDEED POINTS TO A JSON FILE
local function getTableFromJSONUrl(url)
    print("Accessing ".. url)
    local response = http.get(url)
    if response == nil then return {} end
    local serialized = response.readAll()
    response.close()
    local table = textutils.unserialiseJSON(serialized)
    return table
end


-- For simplicity, when the computer boots, all files get updated.

if fs.exists("common") then fs.delete("common") end
if fs.exists("modules") then fs.delete("modules") end
if fs.exists("startup.lua") then fs.delete("startup.lua") end

local common_files = getTableFromJSONUrl(GHRAW_URL .. COMMON_FILES_LIST_PATH)
for _, file in ipairs(common_files) do
    local url = GHRAW_URL .. file
    downloadFile(url, file)
end

-- We then download the individual files
local individual_files = getTableFromJSONUrl (GHRAW_URL .. tostring(os.getComputerID()) .. ".json")
for _, file in ipairs(common_files) do
    local url = GHRAW_URL .. file
    downloadFile(url, file)
end
