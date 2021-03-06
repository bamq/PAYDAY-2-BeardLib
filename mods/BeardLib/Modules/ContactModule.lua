ContactModule = ContactModule or class(ModuleBase)

ContactModule.type_name = "contact"
ContactModule._loose = true

function ContactModule:init(core_mod, config)
    if not self.super.init(self, core_mod, config) then
        return false
    end

    if not self._config.id then
        BeardLib:log("[ERROR] The ID must be specified for a contact")
        return false
    end

    return true
end

function ContactModule:RegisterHook()
    if not self._config.id then
        self:log("[ERROR] Contact does not contain a definition for id!")
        return
    end

    Hooks:PostHook(NarrativeTweakData, "init", self._config.id .. "AddContactData", function(narr_self)
        local data = {
            name_id = self._config.name_id,
            description_id = self._config.desc_id,
            package = self._config.package,
            assets_gui = self._config.assets_gui and self._config.assets_gui:id()
        }
        if self._config.merge_data then
            table.merge(data, BeardLib.Utils:RemoveMetas(self._config.merge_data, true))
        end
        narr_self.contacts[self._config.id] = data
    end)
end

BeardLib:RegisterModule(ContactModule.type_name, ContactModule)
