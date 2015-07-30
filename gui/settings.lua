--- Show the settings GUI
function showSettings(player, index)
    local guiPos = glob.settings[index].guiPos
    if glob.guiVisible[index] == 0 and player.gui[guiPos].logisticsFrame ~= nil then
        
        -- add settings frame 
        if player.gui[guiPos].settingsFrame ~= nil then
            player.gui[guiPos].settingsFrame.destroy()
        end        
        
        local settingsFrame = player.gui[guiPos].add({type = "frame", name = "settingsFrame", direction = "vertical", style = "frame_style"})
        settingsFrame.add({type = "label", name = "generalSettings", caption = {"settings.title"}, style = "lv_info_label"})
        -- add settings table
        if player.gui[guiPos].settingsFrame.settingsTable ~= nil then
            player.gui[guiPos].settingsFrame.settingsTable.destroy()
        end    
        
        local settingsTable = settingsFrame.add({type ="table", name = "settingsTable", colspan = 3, style = "lv_settings_table"})
        
        settingsTable.add({type = "label", name = "settingsOptionLabel", caption = {"settings.option"}, style = "label_style"})
        settingsTable.add({type = "label", name = "settingsValueLabel", caption = {"settings.value"}, style = "label_style"})
        settingsTable.add({type = "label", name = "settingsInfoLabel", caption = {"settings.info"}, style = "label_style"})
        
        --- add settings options
        -- gui position
        local guiPosSettings = glob.settings[index].guiPos
        settingsTable.add({type = "label", name = "guiPosLabel", caption = {"settings.gui-pos"}, style = "lv_info_label"})
        local settingFlow = settingsTable.add({type = "flow", name = "guiPosFlow", direction = "horizontal"})
        settingFlow.add({type = "checkbox", name = "guiPos_left", style = "checkbox_style", caption = "Left", state = guiPosSettings == "left"})        
        settingFlow.add({type = "checkbox", name = "guiPos_top", style = "checkbox_style", caption = "Top", state = guiPosSettings == "top"})        
        settingFlow.add({type = "checkbox", name = "guiPos_center", style = "checkbox_style", caption = "Center", state = guiPosSettings == "center"})        
        settingsTable.add({type = "label", name = "guiPosHelp", caption = {"settings.gui-pos-help"}, style = "lv_settings_info_label"})
        
        -- refresh interval
        local refreshInterval = glob.settings[index].refreshInterval
        settingsTable.add({type = "label", name = "refreshIntervalLabel", caption = {"settings.refresh-interval"}, style = "lv_info_label"})
        local settingFlow = settingsTable.add({type = "flow", name = "refreshIntervalFlow", direction = "horizontal"})
        local settingsField = settingFlow.add({type = "textfield", name = "refreshIntervalValue", text = refreshInterval })
        settingsField.text = refreshInterval
        settingFlow.add({type = "label", name = "refreshIntervalSecLabel", caption = "secs", style = "lv_info_label"})
        settingsTable.add({type = "label", name = "refreshIntervalHelp", caption = {"settings.refresh-interval-help"}, style = "lv_settings_info_label"})
        
        
        -- items per page
        local itemsPerPage = glob.settings[index].itemsPerPage
        settingsTable.add({type = "label", name = "itemsPerPageLabel", caption = {"settings.items-per-page"}, style = "lv_info_label"})
        local settingsField = settingsTable.add({type = "textfield", name = "itemsPerPageValue", text = itemsPerPage })
        settingsField.text = itemsPerPage
        settingsTable.add({type = "label", name = "itemsPerPageHelp", caption = {"settings.items-per-page-help"}, style = "lv_settings_info_label"})
        
        -- experimental tools
        local exToolsSettings = glob.settings[index].exTools
        settingsTable.add({type = "label", name = "exToolsLabel", caption = {"settings.ex-tools"}, style = "lv_info_label"})
        local settingFlow = settingsTable.add({type = "flow", name = "exToolsFlow", direction = "horizontal"})
        settingFlow.add({type = "checkbox", name = "exToolsValue", style = "checkbox_style", caption = {"settings.enable"}, state = exToolsSettings})          
        settingsTable.add({type = "label", name = "exToolsHelp", caption = {"settings.ex-tools-help"}, style = "lv_settings_info_label"}) 
        
        -- Save settings
        settingsFrame.add({type = "button", name = "cancelSettingsBtn", caption = {"settings.cancel"}, style = "lv_button"})
        settingsFrame.add({type = "button", name = "saveSettingsBtn", caption = {"settings.save-settings"}, style = "lv_button"})
    end
end

--- Hide the settings GUI
function hideSettings(player, index)
    local guiPos = glob.settings[index].guiPos
    if player.gui[guiPos].settingsFrame ~= nil then
        player.gui[guiPos].settingsFrame.style = "lv_frame_hidden"
    end
end

--- Save settings
function saveSettings(player, index)
    local guiPos = glob.settings[index].guiPos
    local settingsFrame = player.gui[guiPos].settingsFrame
    local settingsTable = settingsFrame.settingsTable
    
    if settingsTable ~= nil then
        -- guiPos
        local guiPosSettings = glob.settings[index].guiPos
        local guiPosFlow = settingsTable["guiPosFlow"]
        for _,childName in pairs(guiPosFlow.childrennames) do
            if guiPosFlow[childName] ~= nil then
                local state = guiPosFlow[childName].state                
                if state then 
                    local value = string.gsub(childName, "guiPos_", "")
                    guiPosSettings = value
                end
            end
        end   

        -- refreshInterval
        local refreshIntervalSettings = glob.settings[index].refreshInterval
        local refreshIntervalValue = tonumber(settingsTable["refreshIntervalFlow"]["refreshIntervalValue"].text)
        if refreshIntervalValue > 0 then
            refreshIntervalSettings = refreshIntervalValue
        end
        
        -- itemsPerPage
        local itemsPerPageSettings = glob.settings[index].itemsPerPage
        local itemsPerPageValue = tonumber(settingsTable["itemsPerPageValue"].text)
        if itemsPerPageValue > 0 then
            itemsPerPageSettings = itemsPerPageValue
        end    

        -- exTools
        local exToolsSettings = settingsTable["exToolsFlow"]["exToolsValue"].state   

        -- save settings and close settings gui
        glob.settings[index] = {
                guiPos = guiPosSettings,
                itemsPerPage = itemsPerPageSettings,
                refreshInterval = refreshIntervalSettings,
                exTools = exToolsSettings,        
        }
        
        settingsFrame.destroy()
        showGUI(player, index)
    end

end