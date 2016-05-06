/datum/upgrade/
    var/name = ""
    var/desc = "I am very secure about my pizza. You have obviously never tasted pizza if you think mine look bad, and that is very sad for you. You should get a pizza right away so you will have some knowledge of pizza and not sound like a fool when you speak. Again, I would ask you to prove your own pizza making skills if you think you are capable of judging others so harshly. But that would require something well beyond your capabilities. You really should try pizza, it is quite delicious and you won't sound so stupid when you comment."
    var/id = ""
    var/list/prequisites = list()
    var/list/uncompatible_with = list()
    var/list/children = list() //Rudimentary way of drawing the upgrade tree for now, until I come up with something better

/datum/upgrade/proc/writeDiv()
    . = ""
    . += "<li><a href=\"#\">[id]</a>"
    if(children.len)
        . += "<ul>"
        for(var/datum/upgrade/M in children)
            . += M.writeDiv()
        . += "</ul>"
    . += "</li>"

/datum/upgrade/recharge_station/fast1
    id = "fast1"
    children = list(new/datum/machinery_upgrade/recharge_station/fast2)

/datum/upgrade/recharge_station/fast2
    id = "fast2"
    children = list(new/datum/machinery_upgrade/recharge_station/hard, new/datum/machinery_upgrade/recharge_station/long)

/datum/upgrade/recharge_station/hard
    id = "hard"
    children = list(new/datum/machinery_upgrade/recharge_station/hard1, new/datum/machinery_upgrade/recharge_station/hard2)

/datum/upgrade/recharge_station/hard1
    id = "hard1"
    children = list()

/datum/upgrade/recharge_station/hard2
    id = "hard2"
    children = list()

/datum/upgrade/recharge_station/long
    id = "long"
    children = list()
