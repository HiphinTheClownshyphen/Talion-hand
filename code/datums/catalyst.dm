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
	stuff += "<center>DISCLAIMER: everything in the catalyst menu is IC information that you can use after spawning in should you want to.<br>"
	stuff += "<center>You can change the method of you acquiring this information outside of the granted prompt.<br>"
	stuff += "buh buyh buh promt prompt<br>"
	stuff += "buh buyh buh promt prompt<br>"
	stuff += "buh buyh buh promt prompt<br>"
	if(!length(GLOB.laws_of_the_land))
		stuff += "no laws oh nooo"
	for(var/i in 1 to length(GLOB.laws_of_the_land))
		stuff += "[i]. [GLOB.laws_of_the_land[i]]<br>"
	//could probably have a merctakeover segment too, but not gonna.
	if(SStreasury.herovoucher == TRUE)
		stuff += "<center>babababbabababababa, bab? bababa<br>"
		stuff += "<center><br>"
		stuff += "<center><br>"
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
	var/datum/browser/popup = new(client.mob, "catalyst", "<center>Define the story</center>", 650, 500, src)
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
