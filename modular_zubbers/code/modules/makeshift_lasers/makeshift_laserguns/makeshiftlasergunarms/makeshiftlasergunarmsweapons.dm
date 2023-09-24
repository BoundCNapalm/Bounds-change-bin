/obj/item/gun/energy/laser/mounted/makeshiftlaspistolarm
        name = "makeshift laser armcannon (discrete)"
        desc = "An arm gun made from a jailbroken toolset implant and makeshift laser pistol. Powered by similar means."
        w_class = WEIGHT_CLASS_TINY
        icon = 'modular_skyrat/modules/aesthetics/guns/icons/energy.dmi'
        lefthand_file = 'modular_skyrat/modules/aesthetics/guns/icons/guns_lefthand.dmi'
        righthand_file = 'modular_skyrat/modules/aesthetics/guns/icons/guns_righthand.dmi'
        ammo_type = list(/obj/item/ammo_casing/energy/laser/mspistol)
        ammo_x_offset = 1
        trigger_guard = TRIGGER_GUARD_ALLOW_ALL // Uses synapses to fire. No need for a trigger guard.
        force = 5
        selfcharge = 1

/obj/item/gun/energy/mounted/makeshiftlassmgarm
        name = "makeshift laser armcannon (enforcer)"
        desc = "An arm gun made from a jailbroken toolset implant and laser enforcer. Powered by similar means. Use two hands. Associated with cyber-mafia."
        w_class = WEIGHT_CLASS_BULKY
        icon = 'modular_skyrat/modules/aesthetics/guns/icons/energy.dmi'
        lefthand_file = 'modular_skyrat/modules/aesthetics/guns/icons/guns_lefthand.dmi'
        righthand_file = 'modular_skyrat/modules/aesthetics/guns/icons/guns_righthand.dmi'
        ammo_type = list(/obj/projectile/beam/msenforcer)
        ammo_x_offset = 1
        trigger_guard = TRIGGER_GUARD_ALLOW_ALL // Uses synapses to fire. No need for a trigger guard.
        force = 5
        selfcharge = 1

/obj/item/gun/energy/mounted/makeshiftlassmgarm/Initialize(mapload)
        . = ..()
        AddComponent(/datum/component/automatic_fire, 0.0875 SECONDS)

/obj/item/gun/energy/laser/mounted/makeshiftlasgunarm
        name = "makeshift laser armcannon (heavy)"
        desc = "An arm gun made from a jailbroken toolset implant and laser gun. Powered by similar means. Use two hands."
        icon = 'modular_skyrat/modules/aesthetics/guns/icons/energy.dmi'
        lefthand_file = 'modular_skyrat/modules/aesthetics/guns/icons/guns_lefthand.dmi'
        righthand_file = 'modular_skyrat/modules/aesthetics/guns/icons/guns_righthand.dmi'
        w_class = WEIGHT_CLASS_BULKY
        ammo_type = list(/obj/item/ammo_casing/energy/laser/mslaser)
        ammo_x_offset = 1
        trigger_guard = TRIGGER_GUARD_ALLOW_ALL // Uses synapses to fire. No need for a trigger guard.
        force = 5
        selfcharge = 1