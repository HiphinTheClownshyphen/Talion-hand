//N/A lamerd version of the headeater until I make it not suck

/obj/item/natural/head
	var/headprice = 0
	var/headpricemin
	var/headpricemax

/obj/item/natural/head/Initialize()
	. = ..()
	if(headpricemax)
		headprice = rand(headpricemin, headpricemax)

/obj/item/natural/head/examine(mob/user)
	. = ..()
	if(headprice > 0 && (HAS_TRAIT(user, TRAIT_BURDEN) || is_gaffer_assistant_job(user.mind.assigned_role)))
		. += "<span class='info'>HEADEATER value: [headprice]</span>"

/obj/item/bodypart/head
	var/headprice = 0
	var/headpricemin
	var/headpricemax

/obj/item/bodypart/head/Initialize()
	. = ..()
	if(headpricemax)
		headprice = rand(headpricemin, headpricemax)

/obj/item/bodypart/head/examine(mob/user)
	. = ..()
	if(headprice > 0 && (HAS_TRAIT(user, TRAIT_BURDEN) || is_gaffer_assistant_job(user.mind.assigned_role)))
		. += "<span class='info'>HEADEATER value: [headprice]</span>"

/obj/item/painting/lorehead
	var/headprice = 0
	var/headpricemin
	var/headpricemax

/obj/item/painting/lorehead/Initialize()
	. = ..()
	if(headpricemax)
		headprice = rand(headpricemin, headpricemax)


/obj/item/painting/lorehead/examine(mob/user)
	. = ..()
	if(headprice > 0 && (HAS_TRAIT(user, TRAIT_BURDEN) || is_gaffer_assistant_job(user.mind.assigned_role)))
		. += "<span class='info'>HEADEATER value: [headprice]</span>"

/obj/structure/fake_machine/headeater
	name = "HEAD EATER"
	desc = "Feeds on certain heads for coin, despite all this time... this iteration still seems unfinished, what a sell out"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "headeater"
	density = FALSE
	blade_dulling = DULLING_BASH
	SET_BASE_PIXEL(0, 32)

/obj/structure/fake_machine/headeater/Initialize()
	SSroguemachine.headeater = src
	. = ..()

/obj/structure/fake_machine/headeater/Destroy()
	SSroguemachine.headeater = null
	. = ..()

/obj/structure/fake_machine/headeater/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_BURDEN))
		. += ""
		user.add_stress(/datum/stress_event/ring_madness)
		return
	if(is_gaffer_assistant_job(user.mind.assigned_role))
		. += ""
		return
	else
		. += ""

/obj/structure/fake_machine/headeater/r
	SET_BASE_PIXEL(32, 0)

/obj/structure/fake_machine/headeater/l
	SET_BASE_PIXEL(-32, 0)

/obj/structure/fake_machine/headeater/attackby(obj/item/H, mob/user, params)
	. = ..()
	if(!istype(H, /obj/item/natural/head) && !istype(H, /obj/item/bodypart/head) && !istype(H, /obj/item/painting/lorehead))
		to_chat(user, span_danger("It seems uninterested by the [H]"))
		return

	if(!HAS_TRAIT(user, TRAIT_BURDEN) && !is_gaffer_assistant_job(user.mind.assigned_role))
		to_chat(user, span_danger("you can't feed the [src] without carrying it's burden"))
		return

	if(istype(H, /obj/item/bodypart/head))
		var/obj/item/bodypart/head/E = H
		if(E.headprice > 0)
			to_chat(user, span_danger("the [src] consumes the [E] spitting out coins in its place!"))
			budget2change(E.headprice, user)
			playsound(src, 'sound/misc/godweapons/gorefeast3.ogg', 70, FALSE, ignore_walls = TRUE)
			record_round_statistic(STATS_HEADEATER_EXPORTS, E.headprice)
			qdel(E)
			return

	if(istype(H, /obj/item/natural/head))
		var/obj/item/natural/head/A = H
		if(A.headprice > 0)
			to_chat(user, span_danger("the [src] consumes the [A] spitting out coins in its place!"))
			budget2change(A.headprice, user)
			playsound(src, 'sound/misc/godweapons/gorefeast3.ogg', 70, FALSE, ignore_walls = TRUE)
			record_round_statistic(STATS_HEADEATER_EXPORTS, A.headprice)
			qdel(A)
			return

	if(istype(H, /obj/item/painting/lorehead) && is_gaffer_job(user.mind.assigned_role)) //this will hopefully be more thematic when the HEAD EATER is in its real form
		var/obj/item/painting/lorehead/D = H
		if(D.headprice > 0)
			to_chat(user, span_danger("as the [src] consumes [D] without a trace, you are hit with a wistful feeling, your past...gone in an instant."))
			user.add_stress(/datum/stress_event/destroyed_past)
			playsound(src, 'sound/misc/godweapons/gorefeast3.ogg', 70, FALSE, ignore_walls = TRUE)
			budget2change(D.headprice, user)
			record_round_statistic(STATS_HEADEATER_EXPORTS, D.headprice)
			qdel(D)
			return

	if(istype(H, /obj/item/painting/lorehead))
		var/obj/item/painting/lorehead/Y = H
		if(Y.headprice > 0)
			to_chat(user, span_danger("the [src] consumes the [Y] spitting out coins in its place!"))
			playsound(src, 'sound/misc/godweapons/gorefeast3.ogg', 70, FALSE, ignore_walls = TRUE)
			budget2change(Y.headprice, user)
			record_round_statistic(STATS_HEADEATER_EXPORTS, Y.headprice)
			qdel(Y)

	if(istype(H, /obj/item/paper/inn_partnership))
		var/obj/item/paper/inn_partnership/inn = H
		if(!inn.gaffsigned && inn.used && !inn.inkeep)
			return
		var/obj/item/hailer_core/core = new /obj/item/hailer_core(get_turf(user))
		if(!user.put_in_hands(core))
			core.forceMove(get_turf(user))
		inn.used = TRUE
		inn.tiedobject = WEAKREF(core)
		core.tiedpaper =  WEAKREF(inn)
		//N/A sound and message
		return
	if(istype(H, /obj/item/paper/merchant_merger))
		var/obj/item/paper/merchant_merger/guild = H
		if(!guild.gaffsigned && guild.used && !guild.merchant)
			return
		var/obj/item/headeater_spawn/hspawn = new /obj/item/headeater_spawn(get_turf(user))
		if(!user.put_in_hands(hspawn))
			hspawn.forceMove(get_turf(user))
		guild.used = TRUE
		guild.tiedobject = WEAKREF(hspawn)
		hspawn.tiedpaper = WEAKREF(guild)
		//N/A sound and message
		return

/obj/structure/fake_machine/headeater/proc/aggresive_income(income)
	if(income)
		budget2change(income)

/obj/structure/fake_machine/falseheadeater
	name = "ANKLE BITER"
	desc = "Feeds on certain heads for coin, despite all this time... this itteration still seems unfinished, what a sell out"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "infestation_1"
	density = FALSE
	blade_dulling = DULLING_BASH
	var/headeaterspread

/obj/structure/fake_machine/falseheadeater/process()
	. = ..()
	SSroguemachine.falseheadeater = src
	addtimer(CALLBACK(src, PROC_REF(infection)), 15 MINUTES)

/obj/structure/fake_machine/falseheadeater/Destroy()
	. = ..()
	if(SSroguemachine.falseheadeater == src)
		SSroguemachine.falseheadeater = null

/obj/structure/fake_machine/falseheadeater/attackby(obj/item/I, mob/user, params)
	if(!iscarbon(user))
		return ..()
	var/mob/living/carbon/merchant = user
	var/obj/item/clothing/ring/weepers_boon/the_ring = locate() in merchant.get_all_gear()
	if(!the_ring)
		to_chat(merchant, span_danger("you can't feed the [src] without the ring."))
		return
	if(istype(I, /obj/item/natural/head))
		var/obj/item/natural/head/A = I
		if(A.headprice > 0)
			var/hardcoldsweetdelicousfuckingmammons = A.headprice * 0.10
			hardcoldsweetdelicousfuckingmammons = round(hardcoldsweetdelicousfuckingmammons)
			A.headprice -= hardcoldsweetdelicousfuckingmammons
			SSroguemachine.headeater.aggresive_income(hardcoldsweetdelicousfuckingmammons)
			to_chat(merchant, span_danger("the [src] consumes the [A] spitting out coins in its place!"))
			playsound(src, 'sound/misc/godweapons/gorefeast3.ogg', 70, FALSE, ignore_walls = TRUE)
			budget2change(A.headprice, merchant)
			qdel(A)
			return
	if(istype(I, /obj/item/bodypart/head))
		var/obj/item/bodypart/head/E = I
		if(E.headprice > 0)
			var/hardcoldsweetdelicousfuckingmammonss = E.headprice * 0.10
			hardcoldsweetdelicousfuckingmammonss = round(hardcoldsweetdelicousfuckingmammonss)
			E.headprice -= hardcoldsweetdelicousfuckingmammonss
			SSroguemachine.headeater.aggresive_income(hardcoldsweetdelicousfuckingmammonss)
			to_chat(merchant, span_danger("the [src] consumes the [E] spitting out coins in its place!"))
			playsound(src, 'sound/misc/godweapons/gorefeast3.ogg', 70, FALSE, ignore_walls = TRUE)
			budget2change(E.headprice, merchant)
			qdel(E)
			return
	return ..()

/obj/structure/fake_machine/falseheadeater/proc/infection()
	if(!headeaterspread)
		headeaterspread = 1
	if(headeaterspread == 1)
		update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
		headeaterspread++
		playsound(src, 'sound/gore/flesh_eat_03.ogg', 70, FALSE, ignore_walls = TRUE)
		addtimer(CALLBACK(src, PROC_REF(infection)), 20 MINUTES)
		set_light(1, 1, 1, l_color =  "#b40909")
		return
	if(headeaterspread == 2)
		update_appearance(UPDATE_ICON_STATE | UPDATE_NAME)
		headeaterspread++
		playsound(src, 'sound/gore/flesh_eat_03.ogg', 70, FALSE, ignore_walls = TRUE)
		return

/obj/structure/fake_machine/falseheadeater/update_name()
	. = ..()
	if(headeaterspread == 1)
		name = "CHEST BURSTER"
		return
	if(headeaterspread == 2)
		name = "FACE EATER"

/obj/structure/fake_machine/falseheadeater/update_icon_state()
	. = ..()
	if(headeaterspread == 1)
		icon_state = "infestation_2"
		return
	if(headeaterspread == 2)
		icon_state = "infestation_3"

/obj/structure/fake_machine/falseheadeater/proc/infestation_death()
	playsound(src, 'sound/combat/gib (1).ogg', 70, FALSE, ignore_walls = TRUE)
	//N/A needs the butchering effect of speweing blood and guts everywhere
	qdel(src)
