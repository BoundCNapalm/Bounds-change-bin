/obj/item/organ/internal/subdermalplates
	name = "subdermal plates"
	desc = "State-of-the-art armor technology designed to improve survivability via a layer of special long-lasting non-biodegradable polymer inserted under the skin!"
	visual = FALSE
	organ_flags = ORGAN_ROBOTIC
	icon = 'modular_zubbers/icons/obj/subdermals/subdermals.dmi'
	var/implant_color = "#FFFFFF"
	var/implant_overlay
	var/body_health_bonus = 0
	var/resist_amt = 0.0225
	var/boddam_reduct_mult = 0
	var/power_reduct_mult = 0
	var/tier = 0
	var/protection_level = 0
	var/subp_maxhealth_mult = 1
	var/list/subarmor_slot_to_limb = list(
		ORGAN_SLOT_HEAD_SUBDERMAL = BODY_ZONE_HEAD,
		ORGAN_SLOT_RIGHT_ARM_SUBDERMAL = BODY_ZONE_R_ARM,
		ORGAN_SLOT_LEFT_ARM_SUBDERMAL = BODY_ZONE_L_ARM,
		ORGAN_SLOT_LEFT_LEG_SUBDERMAL = BODY_ZONE_L_LEG,
		ORGAN_SLOT_RIGHT_LEG_SUBDERMAL = BODY_ZONE_R_LEG,
	)
	var/obj/item/bodypart/armored_limb

/obj/item/organ/internal/subdermalplates/on_insert(mob/living/carbon/human/organ_owner, special)
	..()
	armored_limb = organ_owner.get_bodypart(subarmor_slot_to_limb[slot])

	organ_owner.physiology.burn_mod -= round(((resist_amt * boddam_reduct_mult * tier * protection_level)), 0.01)
	organ_owner.physiology.brute_mod -= round(((resist_amt * boddam_reduct_mult * tier * protection_level)), 0.01)
	armored_limb.wound_resistance += 5
	if(protection_level <= 2)
		organ_owner.physiology.heat_mod -= round(((resist_amt * boddam_reduct_mult * tier * protection_level)), 0.01)
		organ_owner.physiology.cold_mod -= round(((resist_amt * boddam_reduct_mult * tier * protection_level)), 0.01)
		organ_owner.maxHealth += round((body_health_bonus * subp_maxhealth_mult * tier * protection_level), 1)
		organ_owner.health += round((body_health_bonus * subp_maxhealth_mult * tier * protection_level), 1)
		armored_limb.brute_modifier -= round(((resist_amt * tier * protection_level)), 0.01)
		armored_limb.burn_modifier -= round(((resist_amt * tier * protection_level)), 0.01)
		armored_limb.wound_resistance += 5

	if(protection_level <= 3)
		organ_owner.physiology.stamina_mod -= round(((resist_amt * boddam_reduct_mult * tier * protection_level) * 0.25), 0.01)
		organ_owner.physiology.stun_mod -= round(((resist_amt * boddam_reduct_mult * tier * protection_level) * 0.125), 0.01)
		organ_owner.physiology.bleed_mod -= round(((resist_amt * boddam_reduct_mult * tier * protection_level) * 0.125), 0.01)
		organ_owner.maxHealth += round((body_health_bonus * subp_maxhealth_mult * tier * protection_level), 1)
		organ_owner.health += round((body_health_bonus * subp_maxhealth_mult * tier * protection_level), 1)
		armored_limb.wound_resistance += 5

/obj/item/organ/internal/subdermalplates/on_remove(mob/living/carbon/human/organ_owner, special)
	..()
	armored_limb = organ_owner.get_bodypart(subarmor_slot_to_limb[slot])
	organ_owner.physiology.burn_mod += round(((resist_amt * boddam_reduct_mult * tier * protection_level)), 0.01)
	organ_owner.physiology.brute_mod += round(((resist_amt * boddam_reduct_mult * tier * protection_level)), 0.01)
	if(protection_level <= 2)
		organ_owner.physiology.heat_mod += round(((resist_amt * boddam_reduct_mult * tier * protection_level)), 0.01)
		organ_owner.physiology.cold_mod += round(((resist_amt * boddam_reduct_mult * tier * protection_level)), 0.01)
		organ_owner.maxHealth -= round((body_health_bonus * subp_maxhealth_mult * tier * protection_level), 1)
		organ_owner.health -= round((body_health_bonus * subp_maxhealth_mult * tier * protection_level), 1)
		armored_limb.brute_modifier += round(((resist_amt * tier * protection_level)), 0.01)
		armored_limb.burn_modifier += round(((resist_amt * tier * protection_level)), 0.01)

	if(protection_level <= 3)
		organ_owner.physiology.stamina_mod += round(((resist_amt * boddam_reduct_mult * tier * protection_level) * 0.25), 0.01)
		organ_owner.physiology.stun_mod += round(((resist_amt * boddam_reduct_mult * tier * protection_level) * 0.125), 0.01)
		organ_owner.physiology.bleed_mod += round(((resist_amt * boddam_reduct_mult * tier * protection_level) * 0.125), 0.01)
		organ_owner.maxHealth -= round((body_health_bonus * subp_maxhealth_mult * tier * protection_level), 1)
		organ_owner.health -= round((body_health_bonus * subp_maxhealth_mult * tier * protection_level), 1)

/obj/item/organ/internal/subdermalplates/head
	name = "head plating"
	desc = "Real thickheaded guy aren'tcha?"
	zone = BODY_ZONE_HEAD
	boddam_reduct_mult = 0.225
	subp_maxhealth_mult = 1.5
	slot = ORGAN_SLOT_HEAD_SUBDERMAL

/obj/item/organ/internal/subdermalplates/l_arm
	name = "arm plating (left)"
	desc = "Asymmetrical plating is in style these days. Look it up."
	zone = BODY_ZONE_L_ARM
	boddam_reduct_mult = 0.125
	subp_maxhealth_mult = 1
	slot = ORGAN_SLOT_LEFT_ARM_SUBDERMAL

/obj/item/organ/internal/subdermalplates/r_arm
	name = "arm plating (right)"
	desc = "Asymmetrical plating isn't really that in style. Don't look it up, trust me."
	zone = BODY_ZONE_R_ARM
	boddam_reduct_mult = 0.125
	subp_maxhealth_mult = 1
	slot = ORGAN_SLOT_RIGHT_ARM_SUBDERMAL

/obj/item/organ/internal/subdermalplates/l_leg
	name = "leg plating (left)"
	desc = "That is certainly one way to get thighs that feel firm."
	zone = BODY_ZONE_L_LEG
	boddam_reduct_mult = 0.2
	subp_maxhealth_mult = 2
	slot = ORGAN_SLOT_LEFT_LEG_SUBDERMAL


/obj/item/organ/internal/subdermalplates/r_leg
	name = "leg plating (right)"
	desc = "I understand asymmetrical up top, not down there."
	zone = BODY_ZONE_R_LEG
	boddam_reduct_mult = 0.2
	subp_maxhealth_mult = 2
	slot = ORGAN_SLOT_RIGHT_LEG_SUBDERMAL

/obj/item/organ/internal/subdermalplates/torso
	name = "chest plating"
	desc = "One of two things happen. People think you have cancer or people think you take steroids. Unfortunately you lose."
	zone = BODY_ZONE_CHEST
	boddam_reduct_mult = 0.5
	subp_maxhealth_mult = 4
	slot = ORGAN_SLOT_CHEST_SUBDERMAL

/obj/item/organ/internal/subdermalplates/groin
	name = "subdermal codpiece"
	desc = "Now with added balls support to ensure dickie shots never hurt you gain!"
	zone = BODY_ZONE_PRECISE_GROIN
	boddam_reduct_mult = 0.1
	subp_maxhealth_mult = 0.5
