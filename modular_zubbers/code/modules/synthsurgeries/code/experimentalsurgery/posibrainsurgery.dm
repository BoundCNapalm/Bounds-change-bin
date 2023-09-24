/datum/surgery/advanced/synthmod/robo_brain_optimization
	name = "Procedural Algorithm Optimization"
	desc = "A procedural algorithm optimization program for upload into a synthetic consciousness, which achieves the theoretical logical solving output of the positronic brain."
	requires_bodypart_type = BODYTYPE_ROBOTIC
	surgery_flags = SURGERY_SELF_OPERABLE | SURGERY_REQUIRE_LIMB
	possible_locs = list(BODY_ZONE_HEAD)
	target_mobtypes = list(/mob/living/carbon/human)
	steps = list(
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/open_hatch,
        /datum/surgery_step/mechanic_unwrench,
		/datum/surgery_step/prepare_electronics,
		/datum/surgery_step/prepare_electronics,
        /datum/surgery_step/robo_brain_optimization,
        /datum/surgery_step/mechanic_wrench,
        /datum/surgery_step/mechanic_close,
    )
	synthmod_target = SYNTHMOD_MIND

/datum/surgery/advanced/synthmod/oci_optimization
	name = "OCI Optimization Program"
	desc = "A program for upload into the OCI of a synthetic humanoid, which optimizes interactions to reduce heat, ergo allowing a 20% increase in output with no adverse heat stress"
	requires_bodypart_type = BODYTYPE_ROBOTIC
	surgery_flags = SURGERY_SELF_OPERABLE | SURGERY_REQUIRE_LIMB
	possible_locs = list(BODY_ZONE_HEAD)
	target_mobtypes = list(/mob/living/carbon/human)
	steps = list(
        /datum/surgery_step/mechanic_open,
        /datum/surgery_step/open_hatch,
        /datum/surgery_step/mechanic_unwrench,
		/datum/surgery_step/prepare_electronics,
		/datum/surgery_step/prepare_electronics,
        /datum/surgery_step/oci_optimization,
        /datum/surgery_step/mechanic_wrench,
        /datum/surgery_step/mechanic_close,
    )
	synthmod_target = SYNTHMOD_MIND

/datum/surgery_step/robo_brain_optimization
    name = "optimize procedurals"
    implements = list(TOOL_MULTITOOL = 100)
    time = 12 SECONDS

/datum/surgery_step/oci_optimization
    name = "optimize hydraulic omni-control interface"
    implements = list(TOOL_MULTITOOL = 100)
    time = 12 SECONDS

/datum/surgery_step/robo_brain_optimization/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
    display_results(
            user,
            target,
            span_notice("You begin substituting the algorithms in [target]'s posibrain with experimental ones..."),
            "[user] begins to replace algorithms in [target]'s posibrain with experimental ones.",
            "[user] begins to perform surgery on [target]'s posibrain.",
    )

/datum/surgery_step/oci_optimization/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
    display_results(
            user,
            target,
            span_notice("You begin substituting the algorithms in [target]'s OCI with experimental ones..."),
            "[user] begins to replace algorithms in [target]'s OCI with experimental ones.",
            "[user] begins to perform surgery on [target]'s posibrain.",
    )

/datum/surgery_step/robo_brain_optimization/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
    display_results(
            user,
            target,
            span_notice("You successfully substitute the algorithms in [target]'s posibrain with experimental ones..."),
            "[user] successfully substitutes algorithms in [target]'s posibrain with experimental ones.",
            "[user] successfully performs surgery on [target]'s posibrain.",
    )
    new /datum/synthmod/procedural_algorithm_optimization(target)
    if(target.ckey)
        SSblackbox.record_feedback("nested tally", "nerve_splicing", 1, list("[target.ckey]", "got"))
    return ..()

/datum/surgery_step/oci_optimization/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
    display_results(
            user,
            target,
            span_notice("You successfully substitute the algorithms in [target]'s OCI with experimental ones..."),
            "[user] successfully replaces algorithms in [target]'s OCI with experimental ones.",
            "[user] successfully performs surgery on [target]'s posibrain.",
    )
    new /datum/synthmod/oci_optimization(target)
    if(target.ckey)
        SSblackbox.record_feedback("nested tally", "nerve_splicing", 1, list("[target.ckey]", "got"))
    return ..()

/datum/synthmod/procedural_algorithm_optimization
    name = "Procedural Algorithm Optimization"
    desc = "Algorithms inside of this posibrain have been optimized with a new experimental algorithm, reducing thought lag drastically."
    mod_type = SYNTHMOD_MIND

/datum/synthmod/procedural_algorithm_optimization/on_gain(mob/living/carbon/human/acquirer)
    .=..()
    acquirer.next_move_modifier *= 0.2

/datum/synthmod/procedural_algorithm_optimization/on_lose(mob/living/carbon/human/owner)
    .=..()
    owner.next_move_modifier /= 0.2



/datum/synthmod/oci_optimization
    name = "Optimized OCI"
    desc = "A universal Omni-Control Interface that most synths under Nanotrasen use. This one has been heavily optimized, allowing it to use approximately 10% more power than the standard."
    mod_type = SYNTHMOD_MIND

/datum/movespeed_modifier/oci_speedup
    multiplicative_slowdown = -0.2

/datum/synthmod/oci_optimization/on_gain(mob/living/carbon/human/acquirer)
    acquirer.add_movespeed_modifier(/datum/movespeed_modifier/oci_speedup)

/datum/synthmod/oci_optimization/on_lose(mob/living/carbon/human/owner)
    owner.remove_movespeed_modifier(/datum/movespeed_modifier/oci_speedup)
