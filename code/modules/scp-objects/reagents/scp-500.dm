//TODO:
//*Pill bottle sprite
/datum/reagent/medicine/panacea
	name = "SCP-500"
	id = "scp500"
	description = "Effectively cures the subject of all diseases."
	color = "#DD0000"
	can_synth = 0

/datum/reagent/medicine/panacea/on_mob_life(mob/living/carbon/M)
	spawn(2000) //Healing is not instant!
		M.revive(full_heal = 1, admin_revive = 1)
		for(var/datum/disease/D in M.viruses) //don't know, if neccesary.
			D.cure()

/obj/item/weapon/reagent_containers/pill/scp500
	name = "SCP-500 pill"
	desc = "This little thing can revive dead person, and heal extreme injuries."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "pill12" //Red pills.
	list_reagents = list("scp500" = 1) //Important.
	roundstart = 1

/obj/item/weapon/storage/pill_bottle/scp500
	name = "SCP-500 pill bottle"
	desc = "This pill bottle contains Panacea pills."
	max_combined_w_class = 100
	storage_slots = 50 //So we could put pills back.

/obj/item/weapon/storage/pill_bottle/scp500/New()
	..()
	for(var/i in 1 to 47) //YEP.
		new /obj/item/weapon/reagent_containers/pill/scp500(src)