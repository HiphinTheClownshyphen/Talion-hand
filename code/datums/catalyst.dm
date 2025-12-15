//quite useless for now, but essentially it's meant for shit that happened in the round that can be alerted to people before they join IC, and also unforced event type roles that do not belong to a migrant spawn. Can be either timed or not.
//listen I just need this for merc parade and maybe sentient mobs right now so its crude as fuck. It would be good for setting actors for the quest generation stuff but thats not gonna exist for a while.

/datum/catalyst_datum
	var/datum/preferences/prefs
	var/mob/dead/new_player/new_player
	var/mercparade = FALSE
	var/merc
	var/advs
	var/bards
	var/physickers

/datum/catalyst_datum/New(datum/preferences/passed_prefs)
	. = ..()
	prefs = passed_prefs

/datum/catalyst_datum/Destroy(force, ...)
	prefs = null
	new_player = null
	. = ..()

/datum/catalyst_datum/proc/show_ui()
	var/client/client = prefs.parent
	if(!client)
		return
	new_player = client
	var/stuff
	stuff += "<center>DISCLAIMER: everything in the catalyst menu is information that your character has/can learn(t) about the ongoing round prior to their late-join debut in the game session.<br>"
	stuff += "<center>You may choose to use all or none of the information granted.<br>"
	stuff += "<center>You can diverge from the granted prompt to establish how you have gotten hold of this information.<br>"
	stuff += "<br>"
	stuff += "<center>__________________________________For: all characters__________________________________<br>"
	//the contents
	stuff += "Long before ledgers tracked gold, they tracked knowledge. No less a commodity then those obtained through strenuous labor and physical hardship,"
	stuff += "it is guarded and exchanged as carefully as fine linen or costly jewels. You too have trifled in this addling trade, as you gather what tidbits you can of your upcoming destination,"
	stuff += "though your lowly pecking has only rewarded you with the basics; laws of the land. Dredged through deep, established networks of town criers, tatty notices on morsels of oak and those traveling with loose lips, you have gathered the following:<br>"
	stuff += "<br>"
	stuff += "<br>"
	if(!length(GLOB.laws_of_the_land))
		stuff += "...That your inquest was a fruitless endeavor, as despite your systematic search for dim enlightenment, you have chased nothing but lingering shadow."
		stuff += "None, alive nor dead speak of the laws, decalogues or canons of this disarranged land, madness! The easily convinced may think that there are no rules,"
		stuff += "and chaos reigns, or that the laws are being reformed, but surely that would reach your ear all the same... Perhaps you should probe again?<br>"
	for(var/i in 1 to length(GLOB.laws_of_the_land))
		stuff += "[i]. [GLOB.laws_of_the_land[i]]<br>"
	//could probably have a merctakeover segment too, but not gonna.
	if(SStreasury.herovoucher)
		stuff += "<br>"
		stuff += "<br>"
		stuff += "<center>__________________________________For: Mercenary and Adventurers__________________________________<br>"
		stuff += "...The sun crested horizon and the morning light gave birth to quiet murmurs and hushed tattle among townsfolk, as if an overnight squall came and blew all the notice boards with fresh parchment."
		stuff += "Across every board, was a different, hastily tacked-up sheet, similar in sentiments but diverging in contents;"
		stuff += "'Hail the fulsome crown, and laud the Guild's patron! To all who wander or venture, find sanctum in our lands, and take claim of a privileged sum; [SStreasury.herovoucher]. See our watchman for your voucher.'"
		stuff += "With a footnote of all those who qualified, differed not by name, but with outstanding descriptions, of physique, age and looks."
		stuff += "You were among the aggregate described, perhaps flannelly, but undoubtedly you. No one had seen anyone post them, and yet, they were there.<br>"
		stuff += "<br>"
		stuff += "<br>"
		stuff += "Soon you found this watchman, though not of your accord. Whisked away to parts less traveled with wheezing sounds of labored breath enriched soon by tuneless whistling. A stranger stood still, draped in cimmerian dark, masked with interlinked chains of bronze"
		stuff += "They silently offered the voucher, and went back to whistling. Not a second you spent to ponder this encounter. It is best to not question trickery of the light."
		/*
	if(mercparade)
		stuff += "<center>babababbabababababa, bab? bababa<br>"
		stuff += "<center><br>"
		stuff += "<center><br>"
		if(merc)
			stuff += "<center><a href='byond://?src=[REF(src)];mercspawn='>dough</a><br>"
		if(advs)
			stuff += "<center><a href='byond://?src=[REF(src)];advsspawn='>dough</a><br>"
		if(bards)
			stuff += "<center><a href='byond://?src=[REF(src)];bardsspawn='>dough</a><br>"
		if(physickers)
			stuff += "<center><a href='byond://?src=[REF(src)];physickers='>dough</a><br>"
		stuff += "</fieldset><br>"
	if(has_world_trait(/datum/world_trait/sentient_mob))
		stuff += ""
	*/
	var/datum/browser/popup = new(client.mob, "catalyst", "<center>The narrative.</center>", 650, 500, src)
	popup.set_content(stuff)
	popup.open()

/datum/catalyst_datum/proc/flash_button() //no idea how to do this yet, so.
	return

/datum/catalyst_datum/Topic(href, href_list[]) //this whole thing is fucking hopeless, man.
	. = ..()
	/*
	var/selectedjob
	if(href_list["mercspawn"])
		selectedjob = /datum/job/advclass/mercenary
	if(href_list["advsspawn"])
		selectedjob = /datum/job/advclass/adventurer
	if(href_list["bardsspawn"])
		selectedjob = /datum/job/bard
	*/
	//if(href_list["physickers"]) this is not gonna fucking work with a migrant_role
	//new_player.AttemptLateSpawn(selectedjob)
