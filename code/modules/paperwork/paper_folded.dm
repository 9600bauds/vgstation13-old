/*
 * Folded paper
 *
 * this basicaly a modified copy/paste of paper.dm
 */

/obj/item/weapon/p_folded
	name = "paper"
	gender = NEUTER
	icon = 'icons/obj/paper.dmi'
	icon_state = "paper"
	throwforce = 0
	w_class = 1.0
	throw_range = 1
	throw_speed = 1
	layer = 3.9
	pressure_resistance = 1
	attack_verb = list("slapped")
	autoignition_temperature = AUTOIGNITION_PAPER
	fire_fuel = 1
	var/obj/item/unfolded = /obj/item/weapon/paper
	var/nano = 0
	var/emagged = 0

/obj/item/weapon/p_folded/attack_self(mob/user as mob)
	if (!canunfold(src, usr)) return
	processunfolding(src, usr)
	return

/obj/item/weapon/p_folded/attackby(obj/item/I, mob/user)
	if(istype(I,/obj/item/weapon/pen))
		src.name = copytext(sanitize(input(usr, "What would you like to name [src]?", "Paper Labelling", null)  as text), 1, MAX_NAME_LEN) //shameless copypaste
	else if(istype(I, /obj/item/toy/crayon))
		src.color = I:colour //doesn't work with paper hats but I haven't found a way to fix it, who will even notice anyways
	..()

/obj/item/weapon/p_folded/throw_at(var/atom/A, throw_range, throw_speed)
	pixel_y = rand(-7, 7)
	pixel_x = rand(-8, 8)
	..()

/obj/item/weapon/p_folded/verb/unfold()
	set category = "Object"
	set name = "Unfold"
	set src in usr
	if (!canunfold(src, usr)) return
	processunfolding(src, usr)
	return

/obj/item/proc/processunfolding(var/obj/item/weapon/p_folded/P, mob/user) //Making this a proc so I don't have to copypaste everything for the verbs
	if(P.nano && P.emagged)
		user << "<span class='notice'>The nanopaper's display is ruined, there'd be no use in unfolding it now.</span>"
		return 0

	user.drop_item() //drop the item first to free our hand, but don't delete it yet because it contains the unfolding result.
	if(P.unfolded) //ideally there'd always be an unfolded var but you can never be too sure
		user.put_in_hands(P.unfolded)
		if (P.color && P.color!="#9a9a9a") //because "#9A9A9A" doesn't work, thanks byond!
			user.visible_message( \
				"<span class='notice'>[user] unfolds \the [src].</span>", \
				"<span class='notice'>You wipe off the crayon coloring and unfold \the [src].</span>") //colored formal paper is a no-no and we don't have actual eraser items
		else
			user.visible_message( \
				"<span class='notice'>[user] unfolds \the [src].</span>", \
				"<span class='notice'>You unfold \the [src].</span>")
		P.unfolded.add_fingerprint(user)
	qdel(P) //now we can delete it
	return 1

/obj/item/proc/canunfold(var/obj/item/weapon/p_folded/P, mob/user)
	if(!user || (user.stat || user.restrained()) )
		user << "<span class='notice'>You can't do that while restrained.</span>"
		return 0
	if(user.l_hand != P && user.r_hand != P)
		user << "<span class='notice'>You'll need \the [src] in your hands to do that.</span>"
		return 0
	return 1

/obj/item/weapon/p_folded/crane
	name = "paper crane"
	desc = "They say if you fold one thousand cranes, the gods will grant you a wish!" //good fucking luck folding 1000 cranes in one shift
	icon_state = "crane_1"
	var/frame = 0
/obj/item/weapon/p_folded/crane/attack_self(mob/user)
	if(!canunfold(src, usr)) return //we're not unfolding it, but we're calling this for the sanitycheck
	frame = !frame
	icon_state = (frame ? "crane_2" : "crane_1")

/obj/item/weapon/p_folded/plane
	name = "paper airplane"
	icon_state = "plane_east"
	attack_verb = list("stabbed", "jabbed")
	desc = "Not terribly intimidating, but just might put someone's eye out."
	throw_range = 20
	throw_speed = 1
/obj/item/weapon/p_folded/plane/throw_impact(var/atom/target)
	..()
	if( ishuman(target) && prob(30+(src.emagged*40)) ) //30% chance to hit, 70% if emagged (hard to aim a paper plane!)
		var/mob/living/carbon/human/H = target
		if (H.check_body_part_coverage(EYES))
			H << "<span class='notice'>\The [src] flies right into your eyes! Luckily your eyewear protects you.</span>"
		else
			if (src.emagged)
				H << "<span class='warning'>OW! Something sharp stabs your [pick("right","left")] eye!</span>"
				H.eye_blurry = max(H.eye_blurry, rand(10,15))
				H.eye_blind = max(H.eye_blind, 3)
				var/datum/organ/internal/eyes/eyes = H.internal_organs_by_name["eyes"]
				eyes.damage += 6
			else
				H << "<span class='warning'>\The [src] flies right into your [pick("right","left")] eye!</span>"
				H.eye_blurry = max(H.eye_blurry, rand(4,6))
				H.eye_blind = max(H.eye_blind, src.nano) //very short blind if the plane is made of nanopaper
/obj/item/weapon/p_folded/plane/attackby(obj/item/W, mob/user)
	if(istype(W,  /obj/item/weapon/card/emag) && nano == 1 && emagged == 0) //because someone in the IRC said I should
		emagged = 1
		user << "<span class='notice'>\The [src] shorts out quietly.</span>"
		src.color = "#6A6A6A"
		src.desc += " This one in particular looks like it might just..."
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread //spark lightshow!
		s.set_up(1, 1, src)
		s.start()
//at last, my block at a rest, bereft of all mortal doubts, I have been enlightened, touched by the sage wisdom, my undying gratitude goes to Comic in this emotional moment
/obj/item/weapon/p_folded/plane/throw_at(var/atom/A, throw_range, throw_speed)
	if (A.x > src.x)
		src.icon_state = "plane_east"
	else
		src.icon_state = "plane_west"
	..()

/obj/item/weapon/p_folded/ball
	name = "ball of paper"
	icon_state = "paperball"
	throw_range = 6
	throw_speed = 3

/obj/item/weapon/p_folded/hat
	name = "paper hat"
	desc = "What looks like an ordinary paper hat, IS actually an ordinary paper hat, in no way collectible. Wow!"
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "paper"
	slot_flags = SLOT_HEAD
	body_parts_covered = HEAD

/obj/item/weapon/p_folded/note_small
	name = "folded note"
	icon_state = "note_small"
	desc = "Open me!"
	throw_range = 2

/obj/item/weapon/p_folded/folded_heart
	name = "origami heart"
	icon_state = "folded_heart"
	desc = "Is it for you?"

/obj/item/weapon/p_folded/boat
	name = "origami boat"
	desc = "Probably wouldn't sail too well, but at least it floats."
	icon_state = "folded_boat" //it's shit
/*
/obj/item/weapon/p_folded/fortune	//Sadly after a hastily-made test I realized this really, really wouldn't work
	name = "fortune teller"			//RIP fortuneteller you were never meant to be
	desc = "Like a paper 8-ball."
	var/list/colors = list("red", "blue", "green", "yellow")
	var/list/numbers = list("one", "two", "three", "four", "five", "six", "seven", "eight")
	var/list/fortunes = list(\
		"Get out of there.",\
		"The Syndicate will soon collect a favor from you.",\
		"Don't leave your department today.",\
		"Be wary of [pick("silicons","clowns","doctors","Vox")].",\
		"[pick("R&D","Cargo","The Chemist")] will leave you a gift.",\
		"You will soon find yourself in [pick("Medbay","Brig","outer space","the Morgue")].",\
		"Don't count in the escape shuttle.",\
		"The [pick("Clown","Head of Security","Chaplain","Janitor")] is after you.")
	var/flop = 0
	icon_state = "fortuneteller_closed"
/obj/item/weapon/p_folded/fortune/attack_self(mob/user)
	flop = rand(0,1)
	for (var/i = 1 to length(input("Pick a color!") in colors))
		icon_state = "fortuneteller_closed"
		sleep(1)
		icon_state = (flop ? "fortuneteller_flop" : "fortuneteller_flip")
		flop = !flop
		sleep(4)
	var/list/available_numbers = (flop? list(1, 2, 6, 5) : list(8, 3, 7, 4))
	for (var/o = 1 to input("Pick a number!") in available_numbers)
		icon_state = "fortuneteller_closed"
		sleep(1)
		icon_state = (flop ? "fortuneteller_flop" : "fortuneteller_flip")
		flop = !flop
		sleep(4)
	available_numbers = (flop? list(1, 2, 6, 5) : list(8, 3, 7, 4))
	alert("[fortunes[input("What's your fortune?") in available_numbers]]", "Your fortune is...", "OK")
	icon_state = "fortuneteller_closed"*/