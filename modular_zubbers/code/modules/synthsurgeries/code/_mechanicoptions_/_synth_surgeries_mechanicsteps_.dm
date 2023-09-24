/datum/surgery_step/remove_wires
    name = "remove wires"
    accept_hand = TRUE
    time = 4

/datum/surgery_step/remove_wires/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
    display_results(
            user,
            target,
            span_notice("You begin to remove the portions of wire you cut free from [target]'s [parse_zone(target_zone)]..."),
            ("[user] begins to remove the portions of wires cut from [target]'s [parse_zone(target_zone)]'."),
            ("[user] begins to remove the portions of wires cut from [target]'s [parse_zone(target_zone)]'."),
    )
    display_pain(target, "You feel threads of wire being pulled out, like nerves beng pulled!")

/datum/surgery_step/replace_plates
    name = "replace plating"
    implements = list(/obj/item/stack/sheet/plasteel = 100)
    time = 3.3 SECONDS
    var/plasteelamount = 10

/datum/surgery_step/replace_plates/tool_check(mob/user, obj/item/tool)
    var/obj/item/stack/sheet/plasteel/repplat = tool
    if(repplat.get_amount() < plasteelamount)
        to_chat(user, span_warning("Not enough plasteel!"))
        return FALSE
    return TRUE

/datum/surgery_step/replace_plates/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
    display_results(
            user,
            target,
            span_notice("You add appropriately metamaterialized plasteel plates in [target]'s [parse_zone(target_zone)]..."),
            ("[user] begins to add appropriately metamaterialized plasteel plates in [target]'s [parse_zone(target_zone)]."),
            ("[user] begins to add appropriately matermaterialized plasteel plates in [target]'s [parse_zone(target_zone)]."),
    )
    display_pain(target, "Your chest throbs with pain as plates are added in.")

/datum/surgery_step/replace_plates/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
    var/obj/item/stack/sheet/plasteel/repplat = tool
    return repplat?.use(plasteelamount)
