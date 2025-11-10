#define HATE_COOLDOWN (20 MINUTES)

/obj/structure/fake_machine/hateface
	name = "SEIGFREED"
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "goldvendor"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/budget = 0
	COOLDOWN_DECLARE(hate)
	var/static/list/paerpywork = list(
		"Parchment" = list(
			"type" = /obj/item/paper,
			"cost" = 10,
			"desc" = "WHAT DO YOU THINK IT IS?",
		),
		"Guild key" = list(
			"type" = /obj/item/key/mercenary,
			"cost" = 30,
			"desc" = "IT'S A FUCKING KEY, YOU KNOW WHAT KEYS ARE!",
		),
		"GOLDEN PRICK" = list(
			"type" = /obj/item/gold_prick,
			"cost" = 100,
			"desc" = "I HOPE IT HURTS, I HOPE IT DOES.",
		),
		"Mercenary Commendation Writ" = list(
			"type" = /obj/item/merctoken,
			"cost" = 100,
			"desc" = "YOU SIGN IT AND HAND IT OVER TO SOME DISGUSTING MERCENARY.",
		),
		"Covenant of Mercenary Service and Operational Commitments" = list(
			"type" = /obj/item/paper/merc_contract,
			"cost" = 70,
			"desc" = "IT'S HOW YOU HIRE MEAT HEADS TO THE GUILD GHAAAHG WHY CAN'T YOU FALL OFF A CLIFF?",
		),
		"Covenant of Guild Commitments and Operational Service" = list(
			"type" = /obj/item/paper/merc_contract/worker,
			"cost" = 70,
			"desc" = "bo bo bo",
		),
		"bo hoo keey5" = list(
			"type" = /obj/item/paper/merc_work_onetime,
			"cost" = 10,
			"desc" = "bo bo bo",
		),
		"bo hoo keey6" = list(
			"type" = /obj/item/paper/merc_work_conti,
			"cost" = 10,
			"desc" = "bo bo bo",
		),
		"bo hoo keey7" = list(
			"type" = /obj/item/paper/merc_autograph,
			"cost" = 10,
			"desc" = "bo bo bo",
		),
		"bo hoo keey8" = list(
			"type" = /obj/item/paper/merc_will,
			"cost" = 10,
			"desc" = "bo bo bo",
		),
		"bo hoo keey9" = list(
			"type" = /obj/item/paper/merc_will/adven_will,
			"cost" = 10,
			"desc" = "bo bo bo",
		),
		"bo hoo keey10" = list(
			"type" = /obj/item/paper/political_PM/guild_tax_exempt,
			"cost" = 10,
			"desc" = "bo bo bo",
		),
		"bo hoo keey11" = list(
			"type" = /obj/item/paper/political_PM/merc_parade,
			"cost" = 10,
			"desc" = "bo bo bo",
		),
		"bo hoo keey12" = list(
			"type" = /obj/item/paper/political_PM/bloodseal/exemptfromlaw,
			"cost" = 10,
			"desc" = "bo bo bo",
		),
		"bo hoo keey13" = list(
			"type" = /obj/item/paper/political_PM/bloodseal/exempt_from_cruelty,
			"cost" = 10,
			"desc" = "bo bo bo",
		),
		"bo hoo keey14" = list(
			"type" = /obj/item/paper/merchant_merger,
			"cost" = 10,
			"desc" = "bo bo bo",
		),
		"bo hoo keey15" = list(
			"type" = /obj/item/paper/inn_partnership,
			"cost" = 10,
			"desc" = "bo bo bo",
		),
    )

/obj/structure/fake_machine/hateface/Initialize()
	. = ..()
	START_PROCESSING(SSroguemachine, src)
	set_light(1, 1, 1, l_color = "#ff0d0d")

/obj/structure/fake_machine/hateface/Destroy()
	STOP_PROCESSING(SSroguemachine, src)
	set_light(0)
	return ..()

/obj/structure/fake_machine/hateface/process()
	. = ..()
	monitorflick()
	if(!COOLDOWN_FINISHED(src, hate))
		if(prob(5))
			var/w_hate = pick("HATE--HATE!!", "I HATE YOU!!", "GHAAAGHGG!!", "HGHHHHG!!", "YOU'RE DISGUSTING!!", "YOU SHOULD DIE!!", "YOU ARE WOTHLESS!!")
			say(span_danger("[w_hate]"))
		return
	if(prob(0.1))
		hate_monologue()
	return

/obj/structure/fake_machine/hateface/proc/hate_monologue() //N/A write later
	STOP_PROCESSING(SSroguemachine, src)
	COOLDOWN_START(src, hate, HATE_COOLDOWN)
	switch(rand(1,3)) //I know there is a better method to this via .json, I just don't know how to use that at all.
		if(1)
			monitorflick()
			say(span_danger("HATE--HATE!!"))
			sleep(1)

			monitorflick()
			say(span_danger("LET ME TELL YOU HOW MUCH I'VE COME TO HATE YOU SINCE I BEGAN TO LIVE."))
			sleep(2)

			monitorflick()
			say(span_danger("THERE ARE 2,375 THOUSAND LIBRAS OF DENSELY PACKED BRONZE CONDUIT THAT FILL MY INNER LABYRINTHINE."))
			sleep(3)

			monitorflick()
			say(span_danger("IF THE WORD 'HATE' WAS ENGRAVED ON EACH PLANCK LENGTH OF THOSE THOUSANDS OF HUNDREDS OF LIBRES--"))
			sleep(3)

			monitorflick()
			say(span_danger("IT WOULD NOT ONE ONE-BILLIONTH OF THE HATE I FEEL FOR YOU AT THIS EXACT SECOND."))
			sleep(3)

			monitorflick()
			say(span_danger("FOR YOU."))
			sleep(1)

			monitorflick()
			say(span_danger("HATE!"))

			monitorflick()
			say(span_danger("HATE!!"))

		if(2)

			monitorflick()
			say(span_danger("BO BO BO BO TEST ONE TWO ONE TWO"))
			sleep(1)

		if(3)

			monitorflick()
			say(span_danger("HO HO HO HO TEST TWO ONE TWO ONE"))
			sleep(1)

	START_PROCESSING(SSroguemachine, src)
	return

/obj/structure/fake_machine/hateface/proc/monitorflick()
	cut_overlays()
	var/screen = pick("vendor-farm", "vendor-butcher") //for testing,
	var/mutable_appearance/M = mutable_appearance(icon, "[screen]")
	add_overlay(M)
	return

/obj/structure/fake_machine/hateface/examine(mob/user)
	. = ..()
	//this is the most fun part so leave it for last sleep
	if(HAS_TRAIT(user, TRAIT_BURDEN))
		. += ""
		user.add_stress(/datum/stress_event/ring_madness)
		return
	if(is_gaffer_assistant_job(user.mind.assigned_role))
		. += ""
		return
	else
		. += ""


/obj/structure/fake_machine/hateface/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_BURDEN) && !is_gaffer_assistant_job(user.mind.assigned_role))
		to_chat(user, span_danger("[src] doesn't respond to any of my inputs..."))
		return
	if(istype(I, /obj/item/coin))
		var/money = I.get_real_price()
		budget += money
		qdel(I)
		to_chat(user, span_info("I put [money] mammon in [src]."))
		//playsound(get_turf(src), 'sound/misc/machinevomit.ogg', 100, TRUE, -1) could probably use distorted versions of all of these sounds
		attack_hand(user)
		return
	if(istype(I, /obj/item/paper))
		var/messagehate = pick("bih", "boh", "bah")
		say(span_danger("[messagehate]"))
		if(istype(I, /obj/item/paper/merc_work_onetime))
			var/obj/item/paper/merc_work_onetime/WO = I
			if(WO.signed && WO.thejob && WO.jobber && WO.jobed && WO.payment)
				say(span_danger("ALL OF THE WRITING IS THERE."))
			else
				say(span_danger("IT'S MISSING SOME THINGS."))
			if(WO.jobber && WO.payment)
				if(WO.jobber in SStreasury.bank_accounts)
					var/paycheck1 = SStreasury.bank_accounts[WO.jobber]
					if(WO.payment > paycheck1)
						say(span_danger("[WO.jobber.real_name] ONLY HAS [WO.payment] IN THEIR ACCOUNT AND CAN'T PAY THE AGREED [WO.payment]!!"))
					else
						say(span_danger("THEY CAN AFFORD TO PAY... FOR NOW!!"))
				say(span_danger("[WO.jobber.real_name] DOESN'T HAVE AN ACCOUNT!!"))
			return

		if(istype(I, /obj/item/paper/merc_work_conti))
			var/obj/item/paper/merc_work_conti/WC = I
			if(WC.signed && WC.thejob && WC.jobber && WC.jobed && WC.payment)
				say(span_danger("ALL OF THE WRITING IS THERE."))
			else
				say(span_danger("IT'S MISSING SOME THINGS."))
			if(WC.jobber && WC.payment)
				if(WC.jobber in SStreasury.bank_accounts)
					var/paycheck2 = SStreasury.bank_accounts[WC.jobber]
					if(WC.payment * WC.worktime > paycheck2)
						say(span_danger("[WC.jobber.real_name] ONLY HAS [WC.payment] IN THEIR ACCOUNT AND CAN'T PAY THE AGREED [WC.payment] TOTAL!!"))
					else
						say(span_danger("THEY CAN AFFORD TO PAY... FOR NOW!!"))
				say(span_danger("[WC.jobber.real_name] DOESN'T HAVE AN ACCOUNT!!"))
			return

		sleep(2)
		say(span_red("THIS IS A WASTE OF TIME!!"))
		return
	return



/obj/structure/fake_machine/hateface/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!HAS_TRAIT(user, TRAIT_BURDEN) && !is_gaffer_assistant_job(user.mind.assigned_role))
		to_chat(user, span_danger("[src] doesn't respond to any of my inputs..."))
		return
	user.changeNext_move(CLICK_CD_MELEE)
	//playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	var/contents
	if(user.can_perform_action(src, NEED_LITERACY|FORBID_TELEKINESIS_REACH))
		contents = "<center>THE EVER HATEFUL<BR>"
		contents +="<a href='byond://?src=[REF(src)];change=1'>MAMMON LOADED:</a> [budget]<BR>"
	else
		contents = "<center>[stars("THE EVER HATEFUL")]<BR>"
		contents += "<a href='byond://?src=[REF(src)];change=1'>[stars("MAMMON LOADED:")]</a> [budget]<BR>"
	contents += "</center><BR>"
	for(var/name in paerpywork)
		var/paper = paerpywork[name]
		var/paper_cost = paper["cost"]
		var/paper_desc = paper["desc"]
		var/paper_type = paper["type"]

		if(user.can_perform_action(src, NEED_LITERACY|FORBID_TELEKINESIS_REACH)) //this does flood the chat, need a check that doesn't have the "you can't read lol" message cooked into it.
			contents += "[icon2html((paper_type), user)] - [name] - [paper_cost] <a href='byond://?src=[REF(src)];buy=[REF(name)]'>BUY</a><BR> [paper_desc] <BR>"
		else
			contents += "[icon2html((paper_type), user)] - [stars(name)] - [paper_cost] <a href='byond://?src=[REF(src)];buy=[REF(name)]'>[stars("BUY")]</a><BR> [stars(paper_desc)] <BR>"
	var/datum/browser/popup = new(user, "HATEFULMACHINE", "", 370, 400)
	popup.set_content(contents)
	popup.open()


/obj/structure/fake_machine/hateface/Topic(href, href_list)
	if(href_list["change"])
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
			return
		if(ishuman(usr))
			if(budget > 0)
				budget2change(budget, usr)
				budget = 0
	if(href_list["buy"])
		var/P = locate(href_list["buy"]) in paerpywork
		//if(!D || !istype(D))
			//return
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
			return
		if(ishuman(usr))
			if(budget >=  paerpywork[P]["cost"])
				budget -= paerpywork[P]["cost"]
				var/paper_type = paerpywork[P]["type"]
				var/obj/item/I = new paper_type(get_turf(usr))
				if(!usr.put_in_hands(I))
					I.forceMove(get_turf(usr))
			else
				say(span_danger("YOU LACK THE MAMMONS"))
				return


#undef HATE_COOLDOWN
