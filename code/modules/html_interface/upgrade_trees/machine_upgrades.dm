/*
	RCD UI style.
	N3X15 wrote the stylesheet (originally RPD stylesheet)
	Made into a htmli datum by PJB3005
*/

/datum/html_interface/machine_upgrades
	default_html_file = 'html_interface_no_bootstrap.html'

/datum/html_interface/machine_upgrades/New()
	. = ..()
	head += "<link rel='stylesheet' type='text/css' href='machine_upgrades.css'>"

/datum/html_interface/machine_upgrades/registerResources()
	register_asset("machine_upgrades.css", 'machine_upgrades.css')

	/*//Send the icons.
	for(var/path in typesof(/datum/rcd_schematic) - /datum/rcd_schematic)
		var/datum/rcd_schematic/C = new path()
		C.register_assets()*/

/datum/html_interface/machine_upgrades/sendAssets(var/client/client)
	. = send_asset(client, "machine_upgrades.css")
