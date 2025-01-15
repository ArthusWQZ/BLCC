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

-- Repo config
local repo = "ArthusWQZ/BLCC"
local branch = "main"

-- Retrieving the files from the configuration
local file_list_url = "https://raw.githubusercontent.com/" .. repo .. "/" .. branch .. "/" .. "installation/" .. tostring(os.getComputerID()) .. ".json"
local response = http.get(file_list_url)
local file_list_serialized = response.readAll()
response.close()
local files = textutils.unserialiseJSON(file_list_serialized)

-- Download each file
for _, file in ipairs(files) do
    local url = "https://raw.githubusercontent.com/" .. repo .. "/" .. branch .. "/" .. file
    downloadFile(url, file)
end
