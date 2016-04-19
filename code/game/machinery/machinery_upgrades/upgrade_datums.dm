/datum/machinery_upgrade/
    var/id = ""
    var/prequisite = ""
    var/list/children = list()

/datum/machinery_upgrade/proc/writeDiv()
    . = ""
    . += "<li><a href=\"#\">[id]</a>"
    if(children.len)
        . += "<ul>"
        for(var/datum/machinery_upgrade/M in children)
            . += M.writeDiv()
        . += "</ul>"
    . += "</li>"

/datum/machinery_upgrade/recharge_station
    id = "aaaa"

/datum/machinery_upgrade/recharge_station/fast1
    id = "fast1"
    prequisite = ""
    children = list(new/datum/machinery_upgrade/recharge_station/fast2)

/datum/machinery_upgrade/recharge_station/fast2
    id = "fast2"
    prequisite = ""
    children = list(new/datum/machinery_upgrade/recharge_station/hard, new/datum/machinery_upgrade/recharge_station/long)

/datum/machinery_upgrade/recharge_station/hard
    id = "hard"
    prequisite = ""
    children = list(new/datum/machinery_upgrade/recharge_station/hard1, new/datum/machinery_upgrade/recharge_station/hard2)

/datum/machinery_upgrade/recharge_station/hard1
    id = "hard1"
    prequisite = ""
    children = list()

/datum/machinery_upgrade/recharge_station/hard2
    id = "hard2"
    prequisite = ""
    children = list()

/datum/machinery_upgrade/recharge_station/long
    id = "long"
    prequisite = ""
    children = list()
