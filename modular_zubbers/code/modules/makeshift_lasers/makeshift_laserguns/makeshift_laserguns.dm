/obj/item/weaponcrafting/makeshiftlasfoci
		name = "makeshift laser foci"
		desc = "A makeshift laser focus that serves as the basis of makeshift laser weapons. If you have the option for a real laser gun, take that instead."
		icon = 'icons/obj/weapons/improvised.dmi'
		icon_state = "receiver"

/obj/item/gun/energy/laser/makeshiftlaspistol
		name = "makeshift laser pistol"
		desc = "A bad replication of a miniature energy gun designed to shoot lasers instead. Surprisingly effective, if a bit weak."
		w_class = WEIGHT_CLASS_SMALL
		icon = 'modular_skyrat/modules/aesthetics/guns/icons/energy.dmi'
		icon_state = "laser"
		spread = 2
		cell_type = /obj/item/stock_parts/cell
		ammo_type = list(/obj/item/ammo_casing/energy/laser/mspistol)
		ammo_x_offset = 1

/obj/item/gun/energy/makeshiftdiscolaser
		name = "makeshift disco laser"
		desc = "Makeshift Disco Laser. Party tools like these were banned when someone accidentally turned the practice lasers to 'kill'. Available now in the palm of your hand."
		w_class = WEIGHT_CLASS_BULKY
		icon = 'modular_skyrat/modules/aesthetics/guns/icons/energy.dmi'
		lefthand_file = 'modular_skyrat/modules/aesthetics/guns/icons/guns_lefthand.dmi'
		righthand_file = 'modular_skyrat/modules/aesthetics/guns/icons/guns_righthand.dmi'
		icon_state = "laser"
		can_suppress = TRIGGER_GUARD_ALLOW_ALL
		cell_type = /obj/item/stock_parts/cell
		ammo_type = list(/obj/item/ammo_casing/energy/laser/msdisco)
		ammo_x_offset = 1
		spread = 60

/obj/item/gun/energy/makeshiftdiscolaser/Initialize(mapload)
		. = ..()
		AddComponent(/datum/component/automatic_fire, 0.00625 SECONDS)

/obj/item/gun/energy/makeshiftlassmg
		name = "makeshift laser enforcer"
		desc = "Makeshift Laser SMG. Ones like these have a history on crime-filled worlds. Don't expect security to let you keep this."
		w_class = WEIGHT_CLASS_BULKY
		icon = 'modular_skyrat/modules/aesthetics/guns/icons/energy.dmi'
		lefthand_file = 'modular_skyrat/modules/aesthetics/guns/icons/guns_lefthand.dmi'
		righthand_file = 'modular_skyrat/modules/aesthetics/guns/icons/guns_righthand.dmi'
		icon_state = "laser"
		can_suppress = TRIGGER_GUARD_ALLOW_ALL
		cell_type = /obj/item/stock_parts/cell
		ammo_type = list(/obj/item/ammo_casing/energy/laser/msenforcer)
		ammo_x_offset = 1
		spread = 18

/obj/item/gun/energy/makeshiftlassmg/Initialize(mapload)
		. = ..()
		AddComponent(/datum/component/automatic_fire, 0.1675 SECONDS)


/obj/item/gun/energy/laser/makeshiftlasgun
		name = "makeshift laser gun"
		desc = "Handmade replication of the superior stock produced weapons. It'd do in a pinch but ideally one'd simply get a stronger weapon."
		w_class = WEIGHT_CLASS_BULKY
		icon = 'modular_skyrat/modules/aesthetics/guns/icons/energy.dmi'
		icon_state = "laser"
		cell_type = /obj/item/stock_parts/cell
		ammo_type = list(/obj/item/ammo_casing/energy/laser/mslaser)
		ammo_x_offset = 1
