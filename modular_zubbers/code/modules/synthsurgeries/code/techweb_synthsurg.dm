/datum/techweb_node/exp_surgery_synth
	id = "exp_surgery_synth"
	display_name = "Experimental Synthetic Surgeries"
	description = "'Artificial intelligence is growing up fast, as are robots whose facial expressions can elicit empathy and make your mirror neurons quiver.'"
	prereq_ids = list("adv_surgery")
	design_ids = list(
		"surgery_oci_optimization",
		"surgery_robo_brain_optimization",
		"surgery_replace_plating_augi_main",
		"surgery_replace_plating_augi_aux",
		"surgery_replace_plating_auga_main",
		"surgery_replace_plating_auga_aux",
		"surgery_replace_plating_augr_main",
		"surgery_replace_plating_augr_aux",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 7500)
	discount_experiments = list(/datum/experiment/scanning/random/plants/traits = 4500)
