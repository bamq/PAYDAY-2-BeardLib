MaskPatternModule = MaskPatternModule or class(ItemModuleBase)

MaskPatternModule.type_name = "MaskPattern"

function MaskPatternModule:init(core_mod, config)
    self.clean_table = table.add(clone(self.clean_table), {
        {
            param ="pcs",
            action = "no_number_indexes"
        }
    })
    self.required_params = table.add(clone(self.required_params), {"texture"})
    if not self.super.init(self, core_mod, config) then
        return false
    end

    return true
end

function MaskPatternModule:RegisterHook()
    local default_amount = self._config.default_amount and tonumber(self._config.default_amount) or 1
    Hooks:PostHook(BlackMarketTweakData, "_init_textures", self._config.id .. "AddMaskPatternData", function(bm_self)
        if bm_self.textures[self._config.id] then
            BeardLib:log("[ERROR] Mask Pattern with id '%s' already exists!", self._config.id)
            return
        end
        local data = table.merge({
            name_id = "pattern_" .. self._config.id .. "_title",
            dlc = BeardLib.definitions.module_defaults.item.default_dlc,
            pcs = {},
            value = 0,
            global_value = BeardLib.definitions.module_defaults.item.default_global_value,
            custom = true
        }, self._config)
        bm_self.textures[self._config.id] = data
        if data.dlc == BeardLib.definitions.module_defaults.item.default_dlc then
            table.insert(BeardLib._mod_lootdrop_items, {
                type_items = "textures",
                item_entry = self._config.id,
                amount = default_amount,
                global_value = data.global_value ~= BeardLib.definitions.module_defaults.item.default_global_value and data.global_value or nil
            })

        end
    end)
end

BeardLib:RegisterModule(MaskPatternModule.type_name, MaskPatternModule)
