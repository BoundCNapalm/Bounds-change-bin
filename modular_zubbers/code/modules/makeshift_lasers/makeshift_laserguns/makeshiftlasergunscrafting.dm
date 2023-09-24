/datum/crafting_recipe/makeshiftlasfoci
        name = "makeshift laser focus"
        tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER, TOOL_WELDER)
        result = /obj/item/weaponcrafting/makeshiftlasfoci
        reqs = list(
                /obj/item/stock_parts/capacitor = 2,
                /obj/item/stock_parts/micro_laser = 1,
                /obj/item/stack/cable_coil = 5,
                /obj/item/stack/sheet/iron = 3,
        )
        time = 20 SECONDS
        category = CAT_WEAPON_RANGED

/datum/crafting_recipe/makeshiftlaspistol
        name = "makeshift laser pistol"
        tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
        result = /obj/item/gun/energy/laser/makeshiftlaspistol
        reqs = list(
                /obj/item/weaponcrafting/receiver = 1,
                /obj/item/weaponcrafting/makeshiftlasfoci = 1,
                /obj/item/stock_parts/cell = 1,
                /obj/item/stack/cable_coil = 3,
                /obj/item/stack/sheet/iron = 5,
                /obj/item/stack/sheet/glass = 1,
        )
        time = 30 SECONDS
        category = CAT_WEAPON_RANGED

/datum/crafting_recipe/makeshiftlassmg
        name = "makeshift laser enforcer"
        tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
        result = /obj/item/gun/energy/makeshiftlassmg
        reqs = list(
                /obj/item/weaponcrafting/receiver = 1,
                /obj/item/weaponcrafting/makeshiftlasfoci = 1,
                /obj/item/stack/cable_coil = 3,
                /obj/item/stack/sheet/iron = 7,
                /obj/item/stack/sheet/glass = 2,
                /obj/item/stock_parts/cell = 1,
                /obj/item/stock_parts/capacitor = 2,
				/obj/item/weaponcrafting/stock = 1,
        )
        time = 30 SECONDS
        category = CAT_WEAPON_RANGED

/datum/crafting_recipe/makeshiftlasgun
        name = "makeshift laser gun"
        tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
        result = /obj/item/gun/energy/laser/makeshiftlasgun
        reqs = list(
                /obj/item/weaponcrafting/receiver = 1,
                /obj/item/weaponcrafting/makeshiftlasfoci = 1,
                /obj/item/stack/cable_coil = 3,
                /obj/item/stack/sheet/iron = 7,
                /obj/item/stack/sheet/glass = 2,
                /obj/item/weaponcrafting/stock = 1,
                /obj/item/stock_parts/cell = 1,
                /obj/item/stock_parts/capacitor = 2,
        )
        time = 30 SECONDS
        category = CAT_WEAPON_RANGED
