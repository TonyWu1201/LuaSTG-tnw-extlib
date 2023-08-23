lstg.plugin.RegisterEvent("afterTHlib", "hot_reload ext", 0, function()
    local reload = lstg.DoFile("extlib/hot_reload.lua")
    reload.init()
end)