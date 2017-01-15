/obj/item/weapon/lighter/scp403
	name = "\improper Zippo lighter"
	desc = "The zippo."
	icon_state = "zippo"
	item_state = "zippo"
	var/count = 0

obj/item/weapon/lighter/scp403/ex_act()
	return //This shit makes it FUCKING UNDESTROYABLE IN IT'S OWN FUCKING EXPLOSION. FUCK, I'VE TRIED TO FIGURE THIS OUT FOR SO LONG FUCKING KILL ME ALREADY WHY DO I EVEN EXIST.

/obj/item/weapon/lighter/scp403/attack_self(mob/living/user)
	if(user.is_holding(src))
		if(!lit)
			lit = 1
			playsound(src.loc, 'sound/items/ZippoLight.ogg', 25, 1)
			update_icon()
			force = 5
			damtype = "fire"
			hitsound = 'sound/items/welder.ogg'
			attack_verb = list("burnt", "singed")
			var/turf/open/T = get_turf(src)
			switch(count)
				if(0)
					user.visible_message("<span class='rose'>[user] flips open and lights [src].</span>")
					count ++
					user.AddLuminosity(1)
				if(1)
					user.visible_message("<span class='rose'>[user] flips open and lights [src]. It glows brighter, and the flame is way hotter.</span>")
					count ++
					user.AddLuminosity(8)
					force = 8
				if(2)
					user.visible_message("<span class='rose'>[user] lights the [src] but it suddenly bursts in flame!</span>")
					count ++
					force = 12 //Well, it's... hotter?
					user.AddLuminosity(12)
					explosion(user.loc, 0, 0, 1, 0, flame_range = 3) //Like why is the fucking flame range isn't default var?
					if(istype(T))
						T.atmos_spawn_air("o2=50;plasma=50;TEMP=1000")
				if(3) //DAISAN NO BAKUDAN
					user.visible_message("<span class='rose'>[user] lights the [src] as it violently explodes!</span>")
					explosion(user.loc, 2, 6, 10, 0, flame_range = 12)
					T.atmos_spawn_air("o2=250;plasma=250;TEMP=1000") //Currently uselesss, cause all the plasma distributes in space, created by dev_range
					user.AddLuminosity(24)
					count ++
					force = 20
				if(4)
					user.visible_message("<span class='rose'>[user] lights the [src], spawning enormous blast that destroys everything nearby!</span>")
					explosion(user.loc, 5, 1, 20, 0, flame_range = 20) //Sadly, this is 100 explosion power in dyn_ex scale. But it won't cause much lag.
					T.atmos_spawn_air("o2=500;plasma=500;TEMP=1000")
					user.AddLuminosity(32)
					count ++
					force = 30 //Literally, it's plasma from this point.
				if(5)
					user.visible_message("<span class='rose'>[user] lights up the [src], releasing the power equal to the nuclear charge!") //What? WHAT? WHAT THE FUCK AM I SUPPOSED TO WRITE HERE?
					spawn()
						ticker.station_explosion_cinematic(0,0) //WELL BECAUSE FUCK YOU, THAT'S WHY. In fact, this shit supposed to destroy ENTIRE FUCKING CONTINENT AT 5TH  FLIP.
						world.Reboot("Station destroyed by SCP-403.") //To do: Good cinematic.
		else
			lit = 0
			update_icon()
			playsound(src.loc, 'sound/items/ZippoClose.ogg', 25, 1)
			user.visible_message("<span class='rose'>You hear a quiet click, as [user] shuts off [src].")
			hitsound = "swing_hit"
			user.SetLuminosity(0)
			STOP_PROCESSING(SSobj, src)
