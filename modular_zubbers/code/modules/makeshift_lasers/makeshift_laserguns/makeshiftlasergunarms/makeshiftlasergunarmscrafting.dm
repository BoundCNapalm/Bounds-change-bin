/datum/crafting_recipe/makeshiftlaspistolarm
        name = "makeshift laser armcannon (discrete)"
        tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
        result = /obj/item/organ/internal/cyberimp/arm/gun/makeshiftlaspistolarm
        reqs = list(
                /obj/item/gun/energy/laser/makeshiftlaspistol = 1,
                /obj/item/organ/internal/cyberimp/arm/toolset = 1,
        )
        time = 30 SECONDS
        category = CAT_WEAPON_RANGED

/datum/crafting_recipe/makeshiftlassmgarm
        name = "makeshift laser armcannon (enforcer)"
        tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
        result = /obj/item/organ/internal/cyberimp/arm/gun/laser/makeshiftlassmgarm
        reqs = list(
                /obj/item/gun/energy/makeshiftlassmg = 1,
                /obj/item/organ/internal/cyberimp/arm/toolset = 1,
        )
        time = 30 SECONDS
        category = CAT_WEAPON_RANGED

/datum/crafting_recipe/makeshiftlasgunarm
        name = "makeshift laser armcannon (heavy)"
        tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
        result = /obj/item/organ/internal/cyberimp/arm/gun/makeshiftlasgunarm
        reqs = list(
                /obj/item/gun/energy/laser/makeshiftlasgun = 1,
                /obj/item/organ/internal/cyberimp/arm/toolset = 1,
        )
        time = 30 SECONDS
        category = CAT_WEAPON_RANGED
