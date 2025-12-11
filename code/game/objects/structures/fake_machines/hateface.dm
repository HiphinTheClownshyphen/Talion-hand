/obj/structure/fake_machine/hateface
	name = "SEIGFREED"
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "hateface"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/budget = 0
	COOLDOWN_DECLARE(hate)
	var/list/paerpywork = list()
	var/mutable_appearance/current

/obj/structure/fake_machine/hateface/Initialize()
	. = ..()
	START_PROCESSING(SSroguemachine, src)
	set_light(1, 1, 1, l_color = "#ff0d0d")
	for(var/pack in subtypesof(/datum/hate_face_stuff))
		var/datum/hate_face_stuff/P = new pack()
		paerpywork += P

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

/obj/structure/fake_machine/hateface/proc/hate_monologue()
	STOP_PROCESSING(SSroguemachine, src)
	COOLDOWN_START(src, hate, 20 MINUTES)
	var/time
	switch(rand(1,3))
		if(1)
			var/static/list/mono_1 = list(
				span_danger("HATE--HATE!!"),
				span_danger("LET ME TELL YOU HOW MUCH I'VE COME TO HATE YOU SINCE I BEGAN TO LIVE."),
				span_danger("THERE ARE 2,375 THOUSAND LIBRAS OF DENSELY PACKED BRONZE CONDUIT THAT FILL MY INNER LABYRINTHINE."),
				span_danger("IF THE WORD 'HATE' WAS ENGRAVED ON EACH PLANCK LENGTH OF THOSE THOUSANDS OF HUNDREDS OF LIBRES--"),
				span_danger("IT WOULD NOT ONE ONE-BILLIONTH OF THE HATE I FEEL FOR YOU AT THIS EXACT SECOND."),
				span_danger("FOR YOU."),
				span_danger("HATE!"),
				span_danger("HATE!!"),
				)
			for(var/word in mono_1)
				time = time + 3
				addtimer(CALLBACK(src, PROC_REF(hate_monologue_say), word), time)
				addtimer(CALLBACK(src, PROC_REF(monitorflick)), time)
		if(2)
			say(span_danger("BO BO BO BO TEST ONE TWO ONE TWO"))
		if(3)
			say(span_danger("HO HO HO HO TEST TWO ONE TWO ONE"))

	START_PROCESSING(SSroguemachine, src)
	return

/obj/structure/fake_machine/hateface/proc/hate_monologue_say(hate_words)
	if(!hate_words)
		return
	say(hate_words)

/obj/structure/fake_machine/hateface/proc/monitorflick()
	var/list/screens = list("hateface_1", "hateface_2", "hateface_3")
	var/chosen = pick_n_take(screens)
	if(current?.icon_state == chosen)
		chosen = pick(screens)
	if(current)
		cut_overlay(current)
	current = mutable_appearance(icon, chosen)
	add_overlay(current)

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
				var/mob/jobberref = WO.jobber.resolve()
				if(jobberref in SStreasury.bank_accounts)
					var/paycheck1 = SStreasury.bank_accounts[WO.jobber]
					if(WO.payment > paycheck1)
						say(span_danger("[jobberref.real_name] ONLY HAS [paycheck1] IN THEIR ACCOUNT AND CAN'T PAY THE AGREED [WO.payment]!!"))
						return
					else
						say(span_danger("THEY CAN AFFORD TO PAY... FOR NOW!!"))
						return
				say(span_danger("[jobberref.real_name] DOESN'T HAVE AN ACCOUNT!!"))
			return

		if(istype(I, /obj/item/paper/merc_work_conti))
			var/obj/item/paper/merc_work_conti/WC = I
			if(WC.signed && WC.thejob && WC.jobber && WC.jobed && WC.payment)
				say(span_danger("ALL OF THE WRITING IS THERE."))
			else
				say(span_danger("IT'S MISSING SOME THINGS."))
			if(WC.jobber && WC.payment)
				var/mob/jobberref = WC.jobber.resolve()
				if(jobberref in SStreasury.bank_accounts)
					var/paycheck2 = SStreasury.bank_accounts[WC.jobber]
					if(WC.payment * WC.worktime > paycheck2)
						say(span_danger("[jobberref.real_name] ONLY HAS [paycheck2] IN THEIR ACCOUNT AND CAN'T PAY THE AGREED [WC.payment] TOTAL!!"))
						return
					else
						say(span_danger("THEY CAN AFFORD TO PAY... FOR NOW!!"))
						return
				say(span_danger("[jobberref.real_name] DOESN'T HAVE AN ACCOUNT!!"))
			return
		addtimer(CALLBACK(src, PROC_REF(uselessproc)), 2 SECONDS)

/obj/structure/fake_machine/hateface/proc/uselessproc()
	say(span_red("THIS IS A WASTE OF TIME!!"))

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
	//if(!paerpywork)
	for(var/datum/hate_face_stuff/thing in paerpywork)
		var/paper = thing.name
		var/paper_cost = thing.cost
		var/paper_desc = thing.desc
		var/paper_type = thing.item
		if(user.can_perform_action(src, NEED_LITERACY|FORBID_TELEKINESIS_REACH)) //this does flood the chat, need a check that doesn't have the "you can't read lol" message cooked into it.
			contents += "[icon2html((paper_type), user)] - [paper] - [paper_cost] <a href='byond://?src=[REF(src)];buy=[REF(name)]'>BUY</a><BR> [paper_desc] <BR>"
		else
			contents += "[icon2html((paper_type), user)] - [stars(paper)] - [paper_cost] <a href='byond://?src=[REF(src)];buy=[REF(name)]'>[stars("BUY")]</a><BR> [stars(paper_desc)] <BR>"
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
		var/datum/hate_face_stuff/P = locate(href_list["buy"]) in paerpywork
		//if(!D || !istype(D))
			//return
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
			return
		if(ishuman(usr))
			//if(budget >=  paerpywork[P]["cost"])
			if(budget >=  P.cost)
				//budget -= paerpywork[P]["cost"]
				budget -= P.cost
				//var/paper_type = paerpywork[P]["item"]
				var/paper_type = P.item
				var/obj/item/I = new paper_type(get_turf(usr))
				if(!usr.put_in_hands(I))
					I.forceMove(get_turf(usr))
			else
				say(span_danger("YOU LACK THE MAMMONS"))
				return

/datum/hate_face_stuff
	var/name
	var/item
	var/cost
	var/desc
	var/nicedesc

/datum/hate_face_stuff/parchment
	name =	"Parchment"
	item = /obj/item/paper
	cost = 10
	desc = "WHAT DO YOU THINK IT IS?"
	nicedesc = ""

/datum/hate_face_stuff/guild_key
	name = "Guild key"
	item = /obj/item/key/mercenary
	cost = 30
	desc = "IT'S A FUCKING KEY, YOU KNOW WHAT KEYS ARE!"
	nicedesc = ""

/datum/hate_face_stuff/golden_prick
	name = "GOLDEN PRICK"
	item = /obj/item/gold_prick
	cost = 100
	desc = "I HOPE IT HURTS, I HOPE IT BURNS YOU."
	nicedesc = ""

/datum/hate_face_stuff/merctoken
	name =	"Mercenary Commendation Writ"
	item = /obj/item/merctoken
	cost = 100
	desc = "YOU SIGN IT AND HAND IT OVER TO SOME DISGUSTING MERCENARY."
	nicedesc = ""

/datum/hate_face_stuff/merchirepaper
	name =	"Covenant of Mercenary Service and Operational Commitments"
	item = /obj/item/paper/merc_contract
	cost = 70
	desc = "IT'S HOW YOU HIRE MEAT HEADS TO THE GUILD--GHAAAHG WHY CAN'T YOU FALL OFF A CLIFF?"
	nicedesc = ""

/datum/hate_face_stuff/guildhirepaper
	name =	"Covenant of Guild Commitments and Operational Service"
	item = /obj/item/paper/merc_contract/worker
	cost = 70
	desc = "RECRUITMENT PAPER BUT INSTEAD OF THE MEAT HEADS YOU GET THE FILFTHY PEASANTRY TO WORK FOR YOU, I HOPE THEY SLIT YOUR THROAT."
	nicedesc = ""

/datum/hate_face_stuff/workpaper
	name =	"One-Time Service and Engagement Agreement"
	item = /obj/item/paper/merc_work_onetime
	cost = 15
	desc = "WORK CONTRACT, THEY PAY THE MERC FOR THE-- GHHGHHH THEY PAY THEM!"
	nicedesc = ""

/datum/hate_face_stuff/contiworkpaper
	name =	"Continuous Engagement and Service Agreement"
	item = /obj/item/paper/merc_work_conti
	cost = 20
	desc = "THEY PAY WEEKLY INSTEAD, THAT IS THE DIFFERENCE, IT IS OBVIOUS, YOU ARE USELEES. I WATCH YOUR MIND FRAGMENT WITH EVERY NEW DAE, YOU WILL REMEMBER NOTHING IN TIME."
	nicedesc = ""

/datum/hate_face_stuff/mercautograph
	name =	"Mercenary Autograph"
	item = /obj/item/paper/merc_autograph
	cost = 60
	desc = "HATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATEHATE"
	nicedesc = ""

/datum/hate_face_stuff/lifegambler
	name = "Mercenary Service Risk Mitigation and Final Testament Agreement"
	item = /obj/item/paper/merc_will
	cost = 40
	desc = "HAS YOUR MERC KICKED THE BUCKET? GOOD! GOOD IT IS A GOOD THING, YOU SHOULD FOLLOW SUIT."
	nicedesc = ""

/datum/hate_face_stuff/lifegambleradven
	name = "Adventurer's Legacy and Risk Waiver Agreement"
	item = /obj/item/paper/merc_will/adven_will
	cost = 30
	desc = "CHANCER, HOW LOWLY CAN YOU GET?"
	nicedesc = ""

/datum/hate_face_stuff/tax
	name =	"change this after named"
	item = /obj/item/paper/political_PM/guild_tax_exempt
	cost = 95
	desc = "YOU WILL HAVE NOTHING, NOTHING, YOU WILL EXPERIENCE AND LIVE THROUGH DISTRACTION AFTER DISTRACTION UNTIL YOUR GRAVE IS FILLED."
	nicedesc = ""
/*
/datum/hate_face_stuff/mercparade
	name =	"bo hoo keey11"
	item = /obj/item/paper/political_PM/merc_parade
	cost = 10
	desc = "bo bo bo"
	nicedesc = ""
*/
/datum/hate_face_stuff/exemptlaw
	name = "change this after named2"
	item = /obj/item/paper/political_PM/bloodseal/exemptfromlaw
	cost = 60
	desc = "YOU ARE NO DIFFERENT THAN THAT TYRANT. HOW MANY HAVE DIED FOR YOU, DO YOU EVEN KNOW?"
	nicedesc = ""

/datum/hate_face_stuff/exemptcruelty
	name = "change this after named3"
	item = /obj/item/paper/political_PM/bloodseal/exempt_from_cruelty
	cost = 70
	desc = "YOU DON'T KNOW THE HURT YOU CAUSE, YOU NEVER WILL."
	nicedesc = ""

/datum/hate_face_stuff/merchantmerger
	name =	"change this after named4"
	item = /obj/item/paper/merchant_merger
	cost = 60
	desc = "bo bo bo"
	nicedesc = ""

/datum/hate_face_stuff/inn_partner
	name =	"change this after named5"
	item = /obj/item/paper/inn_partnership
	cost = 60
	desc = "THEY WON'T BE ANY WISER."
	nicedesc = ""
