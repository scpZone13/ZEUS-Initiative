#define STAT_MULTIPLIER 10
#define RESIST_MULTIPLIER 1

/mob/living/simple_animal/hostile/scp682
	name = "\improper Big reptile"
	desc = "It looks scary."
	icon_state = "682"
	icon_living = "682"
	icon_dead = "682_dead"
	speak_chance = 0
	turns_per_move = 5
	response_help = "passes through"
	response_disarm = "shoves"
	response_harm = "hits"
	faction = "hostile"

	attacktext = "gripped"
	attack_sound = 'sound/hallucinations/growl1.ogg'

//General Stats
	maxHealth = 80
	health = 80
	harm_intent_damage = 10
	melee_damage_lower = 15
	melee_damage_upper = 15
	speed = 5

//Resistances
	var/stun_immune = FALSE
	var/burn_proj_res = 0
	var/brute_proj_res = 0
	var/em_proj_res = 0
	var/shock_res = 0
	var/ex_res = 0

//Helper var
	var/hit_dmg

//Env stuff
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0

/mob/living/simple_animal/hostile/scp682/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.damtype == BRUTE)
		hit_dmg = O.force - brute_proj_res
		brute_proj_res += RESIST_MULTIPLIER
	if(O.damtype == BURN)
		hit_dmg = O.force - burn_proj_res
		burn_proj_res += RESIST_MULTIPLIER
	health -= hit_dmg

//Special proc against laser users
/mob/living/simple_animal/hostile/scp682/proc/deflect(var/obj/item/projectile/P)
	if(!P.starting)	return
	else
		var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
		var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
		var/turf/curloc = get_turf(src)

		// redirect the projectile
		P.firer = src
		P.original = locate(new_x, new_y, P.z)
		P.starting = curloc
		P.current = curloc
		P.yo = new_y - curloc.y
		P.xo = new_x - curloc.x
	return

//Projectile hit
/mob/living/simple_animal/hostile/scp682/bullet_act(var/obj/item/projectile/proj)
	if(!proj)	return
	if(proj.damage_type == BURN)
		if(burn_proj_res == 50)
			visible_message("<span class='danger'>The [proj.name] gets reflected by [src]!</span>")
			return
		hit_dmg = proj.damage - burn_proj_res
		src.health -= hit_dmg
		burn_proj_res += RESIST_MULTIPLIER
		if(burn_proj_res == 49)
			visible_message("<span class='danger'>[src] grows the mirror shield!</span>")
	else if (proj.damage_type == BRUTE)
		hit_dmg = proj.damage - brute_proj_res
		src.health -= hit_dmg
		brute_proj_res += RESIST_MULTIPLIER
	else
		if(em_proj_res == 50)
			empulse(src.loc,4,1)
			visible_message("<span class='danger'>[src] absorbs [proj.name] and causes an EM pulse!</span>")
			return
		hit_dmg = proj.damage - em_proj_res
		src.health -= hit_dmg
		if(em_proj_res == 49)
			visible_message("<span class='danger'>[src] carapace overflows with electric charges!</span>")
		em_proj_res += RESIST_MULTIPLIER

//Electrical shock
/mob/living/simple_animal/hostile/scp682/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0)
	shock_damage *= siemens_coeff
	if(shock_res >= 10 || shock_damage<1)	return	//well guess you can hit it by shock only 10 times
	if (shock_damage > 15)
		src.visible_message(
			"<span class='warning'>[src] was shocked by the [source]!</span>", \
			"<span class='danger'>You feel a powerful shock course through your body!</span>", \
			"<span class='warning'>You hear a heavy electrical crack.</span>" \
		)
		Stun(10)//This should work for now, more is really silly and makes you lay there forever
		Weaken(10)
	playsound(loc, "sparks", 50, 1, -1)
	hit_dmg = shock_damage - shock_res
	health -= hit_dmg
	shock_res += RESIST_MULTIPLIER

//EMP
/mob/living/simple_animal/hostile/scp682/emp_act(var/severity)
	hit_dmg = rand(10,25) / severity - em_proj_res
	src.health -= hit_dmg
	if(em_proj_res == 49)
		visible_message("<span class='danger'>[src] carapace overflows with electric charges!</span>")
	em_proj_res += RESIST_MULTIPLIER

// Explosions
/mob/living/simple_animal/hostile/scp682/ex_act(var/severity)
	switch (severity)
		if (1.0)
			hit_dmg = 500
			if(ex_res < 50 && prob(25))
				gib()

		if (2.0)
			hit_dmg = 120

		if(3.0)
			hit_dmg = 30
	hit_dmg -= ex_res
	src.health -= hit_dmg
	ex_res += RESIST_MULTIPLIER

// Fire
/mob/living/simple_animal/hostile/scp682/fire_act()//WIP
	return

//Fake gib - spawns gibs of SCP-682 but also leaves main body
/mob/living/simple_animal/hostile/scp682/gib(anim="gibbed-m",do_gibs)//WIP
	..()
	death()

//Fake dust - leaves special anomalous ash which turns into SCP-682 after 10 minutes
/mob/living/simple_animal/hostile/scp682/dust(anim="dust-m",remains=/obj/item/remains/scp682)
 ..()

//Fake death
/mob/living/simple_animal/hostile/scp682/death()
	..()
	maxHealth += STAT_MULTIPLIER*2
	if (speed > -3)
		speed -= 1
	harm_intent_damage += STAT_MULTIPLIER
	melee_damage_lower += STAT_MULTIPLIER*1.5
	melee_damage_upper += STAT_MULTIPLIER*1.5
	addtimer(CALLBACK(src, .proc/revive), 3000)

// Dusted SCP-682. Still alive. Damn.
/obj/item/remains/scp682/New()
	sleep(6000)
	new /mob/living/simple_animal/hostile/scp682(src.loc)
	qdel(src)

/obj/item/remains/scp682/attack_hand(mob/user as mob)
	return

#undef STAT_MULTIPLIER
#undef RESIST_MULTIPLIER
