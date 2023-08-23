local M = {}

local var = {}
local default = {}
local fallback = {}

local search_path = "hot_reload/"
local var_path = "variable.lua"
local default_var_path = "variable_default.lua"

local enable_fallback = false
local set_fallback_once = true

function M.init()
    if search_path and search_path ~= "" then
        if not lstg.FileManager.DirectoryExist(search_path) then
            lstg.FileManager.CreateDirectory(search_path)
        end
        lstg.FileManager.AddSearchPath(search_path)
    end
    local res, info
    res, info = pcall(DoFile, default_var_path)
    if res and type(info) == "table" then
        default = info
    end
    if enable_fallback then
        for k, v in pairs(default) do
            fallback[k] = v
        end
    end
    M.update()
    if not enable_fallback and set_fallback_once then
        for k, v in pairs(default) do
            fallback[k] = v
        end
        for k, v in pairs(var) do
            fallback[k] = v
        end
    end
end

function M.update()
    local res, info
    res, info = pcall(DoFile, var_path)
    if res and type(info) == "table" then
        var = info
        if enable_fallback then
            for k, v in pairs(var) do
                fallback[k] = v
            end
        end
    else
        var = {}
    end
end

function M.get(key)
    if var[key] then
        return var[key]
    elseif default[key] then
        return default[key]
    elseif (enable_fallback or set_fallback_once) and fallback[key] then
        return fallback[key]
    else
        error("InValid key : " .. key)
    end
end

return M