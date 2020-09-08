sqlier = {}
sqlier.Database = {}

function sqlier.Initialize(database, driver, options)
    local db = require("sqlier/drivers/" .. driver .. ".lua")
    db.__index = db

    db:initialize(options)
    db.Driver = driver

    sqlier.Database[database] = db
end

require("sqlier/constants.lua")
require("sqlier/model.lua")

do
    local files, _ = file.Find("sqlier/database/*.json", "DATA")

    for _, name in pairs(files) do
        local databaseConfigJson = file.Read("sqlier/database/" .. name)
        local databaseConfig = util.JSONToTable(databaseConfigJson)
        local database = string.gsub(string.lower(name), ".lua", "")

        sqlier.Initialize(database, databaseConfig.driver, databaseConfig)
    end
end