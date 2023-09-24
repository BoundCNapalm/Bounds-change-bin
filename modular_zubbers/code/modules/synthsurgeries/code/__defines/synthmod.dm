// Synthetic Modifications
// Little elaboration required.

/datum/synthmod
	var/name = "Generic Synthmod"
	var/mob/living/carbon/human/owner
	var/desc = "Should be invisible; If you are seeing this, something's very wrong."
	var/active = FALSE
	var/can_process = FALSE
	var/mod_type = SYNTHMOD_GENERIC


/datum/synthmod/New(mob/living/carbon/human/new_owner)
	owner = new_owner
	for(var/datum/synthmod/synthmod as anything in owner.synthmod)
		if(synthmod.mod_type == mod_type)
			qdel(src)
			return
	LAZYADD(owner.synthmod, src)
	on_gain()

/datum/synthmod/Destroy()
	if(owner)
		LAZYREMOVE(owner.synthmod, src)
	owner = null
	if(active)
		on_lose()
	return ..()

/datum/synthmod/proc/on_gain()
	active = TRUE
	if(can_process)
		START_PROCESSING(SSobj, src)

/datum/synthmod/proc/on_lose()
	STOP_PROCESSING(SSobj, src)
	return
