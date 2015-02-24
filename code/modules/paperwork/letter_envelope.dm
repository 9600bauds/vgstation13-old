/obj/item/weapon/envelope
	name = "letter envelope"
	desc = "For all your snail mail needs."
	icon = 'icons/obj/paper.dmi'
	icon_state = "envelope_open"
	gender = NEUTER
	throwforce = 0
	w_class = 1.0
	throw_range = 2
	throw_speed = 1
	layer = 3.9
	pressure_resistance = 1
	attack_verb = list("slapped")
	autoignition_temperature = AUTOIGNITION_PAPER
	fire_fuel = 1
	var/obj/item/contains = null
	var/sealed = 0
	var/broken = 0
	var/frominfo = ""
	var/toinfo = ""

/obj/item/weapon/envelope/attackby(obj/item/I,mob/user)
	if(!sealed && !broken && istype(I,/obj/item/weapon/paper))
		if(!I:info)
			user << "<span class='notice'>You should probably write something on the letter first.</span>"
			return
		icon_state = "envelope_closed"
		sealed = 1
		contains = I
		usr.drop_from_inventory(I)
		I.loc = null
		user << "<span class='notice'>You put \the [I.name] in the letter envelope and seal it closed.</span>"
		desc = "A thoughtful sealed letter."
	else if (sealed && !broken && istype(I,/obj/item/weapon/pen))
		if (frominfo)
			user << "<span class='notice'>The envelope is already written on.</span>"
		else
			frominfo = "From: " + copytext(sanitize(input(usr, null, "From?", null)  as text), 1, 30)
			toinfo = "To: " + copytext(sanitize(input(usr, null, "To?", null)  as text), 1, 30)
	else if(istype(I, /obj/item/toy/crayon))
		color = I:colour
	..()

/obj/item/weapon/envelope/attack_self(mob/user)
	if(sealed)
		user.drop_item()
		if(contains)
			user.put_in_hands(contains)
			contains.add_fingerprint(user)
		user.visible_message( \
			"<span class='notice'>[user] cuts open \the [src].</span>", \
			"<span class='notice'>You cut open \the [src] and retrieve the letter inside.</span>")
		icon_state = "envelope_ripped"
		desc = "It's been ripped open, and the letter inside removed."
		broken = 1
		pixel_y = rand(-8, 8)
		pixel_x = rand(-6, 6)

/obj/item/weapon/envelope/examine(mob/user)
	..()
	if (frominfo)
		user << "<span class='info'>The envelope reads:</span>"
		user << "<span class='notice'>[frominfo]</span>"
		user << "<span class='notice'>[toinfo]</span>"