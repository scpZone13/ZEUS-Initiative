/mob/living/simple_animal/pet/cat/scp529
	name = "Josie"
	desc = "This is SCP-529, also known as Josie. She's a half-cat."
	icon_state = "josie"
	icon_living = "josie"
	icon_dead = "josie_dead" //I'll fucking kill anyone who'll harm her.
	gender = FEMALE
	gold_core_spawnable = 0

/mob/living/simple_animal/pet/cat/scp529/Life()
	if(!stat && !buckled && !client)
		if(prob(1))
			emote("me", 1, pick("stretches out for a belly rub.", "lies down.")) //Basically, removed "tail wagging". We can't see her tail.
			icon_state = "[icon_living]_rest"
			resting = 1
			update_canmove()
		else if (prob(1))
			emote("me", 1, pick("sits down.", "crouches on its invisible legs.", "looks alert."))
			icon_state = "[icon_living]_sit"
			resting = 1
			update_canmove()
		else if (prob(1))
			if (resting)
				emote("me", 1, pick("gets up and meows.", "walks around.", "stops resting."))
				icon_state = "[icon_living]"
				resting = 0
				update_canmove()
			else
				emote("me", 1, pick("grooms its fur.", "twitches its whiskers.", "shakes out its coat."))
	//Cheese!			Apparently, Josie loves cheese.
	if((src.loc) && isturf(src.loc))
		if(!stat && !resting && !buckled)
			for(var/obj/item/weapon/reagent_containers/food/snacks/cheesewedge/C in view(1,src))
				if(Adjacent(C))
					emote("me", 1, "eats \the [C]!")
					playsound(src, 'sound/items/eatfood.ogg', 40, 1)
					qdel(C) //It's dumb. But in game... it's surprisingly good.
					movement_target = null
					stop_automated_movement = 0
					break
			for(var/obj/item/toy/cattoy/T in view(1,src))
				if (T.cooldown < (world.time - 400))
					emote("me", 1, "bats \the [T] around with its paw!")
					T.cooldown = world.time
	..()
	//Here goes movement.
	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			walk_to(src,0)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				stop_automated_movement = 0
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				stop_automated_movement = 0
				for(var/obj/item/weapon/reagent_containers/food/snacks/cheesewedge/C in oview(src,6))
					if(isturf(C.loc))
						emote("me", 1, "mrowls loudly, as she notices the cheese!")
						movement_target = C //CHEESE!!!!
						break
			if(movement_target)
				stop_automated_movement = 1
				walk_to(src,movement_target,0,3)