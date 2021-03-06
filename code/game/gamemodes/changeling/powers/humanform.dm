/obj/effect/proc_holder/changeling/humanform
	name = "Human form"
	desc = "We change into a human."
	chemical_cost = 5
	genetic_damage = 3
	req_dna = 1
	max_genetic_damage = 3


//Transform into a human.
/obj/effect/proc_holder/changeling/humanform/sting_action(mob/living/carbon/user)
	var/datum/changeling/changeling = user.mind.changeling
	var/list/names = list()
	for(var/datum/changelingprofile/prof in changeling.stored_profiles)
		names += "[prof.name]"

	var/chosen_name = input("Select the target DNA: ", "Target DNA", null) as null|anything in names
	if(!chosen_name)
		return

	var/datum/changelingprofile/chosen_prof = changeling.get_dna(chosen_name)
	if(!chosen_prof)
		return
	if(!user || user.notransform)
		return 0
	user << "<span class='notice'>We transform our appearance.</span>"

	changeling.purchasedpowers -= src

	var/newmob = user.humanize(TR_KEEPITEMS | TR_KEEPIMPLANTS | TR_KEEPORGANS | TR_KEEPDAMAGE | TR_KEEPVIRUS)

	changeling_transform(newmob, chosen_prof)
	feedback_add_details("changeling_powers","LFT")
	return 1
