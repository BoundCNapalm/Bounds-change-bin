/datum/surgery/advanced/synthmod
	name = "Synthetic augmentation surgery"
	var/synthmod_target = SYNTHMOD_GENERIC

/datum/surgery/advanced/synthmod/can_start(mob/user, mob/living/carbon/human/target)
	if(!..())
		return FALSE
	if(!istype(target))
		return FALSE
	for(var/datum/synthmod/synthmod as anything in target.synthmod)
		if(synthmod.mod_type == synthmod_target)
			return FALSE
	return TRUE
