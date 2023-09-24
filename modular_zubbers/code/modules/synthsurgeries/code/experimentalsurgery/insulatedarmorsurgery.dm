/datum/surgery/advanced/synthmod/replace_plating_insulated_main
	name = "Replace Main Plating: Insulated Plating"
	desc = "Using metamaterials shaped from plasteel, synths can adopt insulated Plating. Highly resilient to environments, and installed as main plates can prevent flames."
	requires_bodypart_type = BODYTYPE_ROBOTIC
	surgery_flags = SURGERY_SELF_OPERABLE | SURGERY_REQUIRE_LIMB
	possible_locs = list(BODY_ZONE_CHEST)
	target_mobtypes = list(/mob/living/carbon/human)
	steps = list(
        /datum/surgery_step/mechanic_open,
        /datum/surgery_step/open_hatch,
        /datum/surgery_step/mechanic_unwrench,
        /datum/surgery_step/pry_off_plating,
        /datum/surgery_step/cut_wires,
        /datum/surgery_step/remove_wires,
        /datum/surgery_step/prepare_electronics,
        /datum/surgery_step/replace_plates,
        /datum/surgery_step/replace_wires,
        /datum/surgery_step/weld_plating,
        /datum/surgery_step/power_plating_augi,
        /datum/surgery_step/mechanic_wrench,
        /datum/surgery_step/mechanic_close,
    )
	synthmod_target = SYNTHMOD_MAINPLATES

/datum/surgery/advanced/synthmod/replace_plating_insulated_aux
	name = "Replace Auxiliary Plating: Insulated Plating"
	desc = "Using metamaterials shaped from plasteel, synths can adopt Insulated Plating. Highly resilient to environments."
	requires_bodypart_type = BODYTYPE_ROBOTIC
	surgery_flags = SURGERY_SELF_OPERABLE | SURGERY_REQUIRE_LIMB
	possible_locs = list(BODY_ZONE_CHEST)
	target_mobtypes = list(/mob/living/carbon/human)
	steps = list(
		/datum/surgery_step/mechanic_open,
        /datum/surgery_step/open_hatch,
        /datum/surgery_step/mechanic_unwrench,
        /datum/surgery_step/pry_off_plating,
        /datum/surgery_step/cut_wires,
        /datum/surgery_step/remove_wires,
        /datum/surgery_step/prepare_electronics,
        /datum/surgery_step/replace_plates,
        /datum/surgery_step/replace_wires,
        /datum/surgery_step/weld_plating,
        /datum/surgery_step/power_plating_augi_aux,
        /datum/surgery_step/mechanic_wrench,
        /datum/surgery_step/mechanic_close,
    )
	synthmod_target = SYNTHMOD_AUXPLATES


/datum/surgery_step/power_plating_augi
    name = "power-up main plating"
    implements = list(TOOL_MULTITOOL = 100,)
    time = 3.3 SECONDS

/datum/surgery_step/power_plating_augi_aux
    name = "power-up auxiliary plating"
    implements = list(TOOL_MULTITOOL = 100,)
    time = 3.3 SECONDS

/datum/surgery_step/power_plating_augi/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
    display_results(
            user,
            target,
            span_notice("You power up metamaterialized plasteel plates in [target]'s [parse_zone(target_zone)]..."),
            ("[user] powers up metamaterialized plasteel plates in [target]'s [parse_zone(target_zone)]."),
            ("[user] powers up matermaterialized plasteel plates in [target]'s [parse_zone(target_zone)]."),
    )
    display_pain(target, "Your chest throbs with pain as plates are added in.")

/datum/surgery_step/power_plating_augi_aux/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
    display_results(
            user,
            target,
            span_notice("You power up metamaterialized plasteel plates in [target]'s [parse_zone(target_zone)]..."),
            ("[user] powers up metamaterialized plasteel plates in [target]'s [parse_zone(target_zone)]."),
            ("[user] powers up matermaterialized plasteel plates in [target]'s [parse_zone(target_zone)]."),
    )
    display_pain(target, "Your chest throbs with pain as plates are added in.")


/datum/surgery_step/power_plating_augi/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
    display_results(
            user,
            target,
            span_notice("You successfully power metamaterialized plasteel plates in [target]'s [parse_zone(target_zone)]..."),
            ("[user] successfully powers metamaterialized plasteel plates in [target]'s [parse_zone(target_zone)]."),
            ("[user] successfully powers matermaterialized plasteel plates in [target]'s [parse_zone(target_zone)]."),
    )
    new /datum/synthmod/insulated_plating_main(target)
    if(target.ckey)
        SSblackbox.record_feedback("nested tally", "nerve_splicing", 1, list("[target.ckey]", "got"))
    return ..()

/datum/surgery_step/power_plating_augi_aux/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
    display_results(
            user,
            target,
            span_notice("You successfully power metamaterialized plasteel plates in [target]'s [parse_zone(target_zone)]..."),
            ("[user] successfully powers metamaterialized plasteel plates in [target]'s [parse_zone(target_zone)]."),
            ("[user] successfully powers matermaterialized plasteel plates in [target]'s [parse_zone(target_zone)]."),
    )
    new /datum/synthmod/insulated_plating_aux(target)
    if(target.ckey)
        SSblackbox.record_feedback("nested tally", "nerve_splicing", 1, list("[target.ckey]", "got"))
    return ..()

/datum/synthmod/insulated_plating_main
    name = "Main Plating Replacement: Ablative"
    desc = "Metamaterial plasteel plates designed to ablate serious energy. As this is main plating, it provides EMP protection."
    mod_type = SYNTHMOD_MAINPLATES

/datum/synthmod/insulated_plating_aux
    name = "Auxiliary Plating Replacement: Ablative"
    desc = "Metamaterial plasteel plates designed to ablate serious energy. This is auxiliary plating, has no resistance against EMPs."
    mod_type = SYNTHMOD_AUXPLATES

/datum/synthmod/insulated_plating_main/on_gain()
    ..()
    owner.physiology.heat_mod *= 0.40
    owner.physiology.cold_mod *= 0.01

/datum/synthmod/insulated_plating_main/on_lose()
    ..()
    owner.physiology.heat_mod /= 0.40
    owner.physiology.cold_mod /= 0.01

/datum/synthmod/insulated_plating_aux/on_gain()
    ..()
    owner.physiology.heat_mod *= 0.60
    owner.physiology.cold_mod *= 0.35

/datum/synthmod/insulated_plating_aux/on_lose()
    ..()
    owner.physiology.heat_mod /= 0.60
    owner.physiology.cold_mod /= 0.35
