/obj/item/towel
	name = "towel"
	desc = "A towel, never forget this"
	icon = 'icons/obj/towel.dmi'
	icon_state = "towel"
	var/damp = FALSE
	var/oldname

/obj/item/towel/attack(mob/living/M, mob/user, def_zone)
	if(damp)
		if(M == user)
			M.visible_message(span_notice("[user] attempts to dry \himself off with \the [src]"), span_notice("You attempt to dry yourself off with \the [src]"))
			return
		M.visible_message(span_notice("[user] attempts to dry [M] with \the [src]"), span_userdanger("[user] awkwardly rubs you with \the [src]"))
		return
	isSwimming = !!M.GetGetComponent(/datum/component/swimming)
	if(M == user)
		if(isSwimming)
			M.visible_message(span_notice("[user] attempts to dry \himself while swimming. It is not very effective"), span_notice("You attempt to dry yourself while swimming. It is not very effective."))
			dampen()
			return
		M.visible_message(span_notice("[user] begins to dry \himself off with \the [src]"), span_notice("You begin to dry yourself off with \the [src]"))
		if(do_after(user, 2 SECONDS))
			M.visible_message(span_notice("[user] dries \himself off with \the [src]"), span_notice("You dry yourself off with \the [src]"))
			dry(M)
		return
	
	if(isSwimming)
		M.visible_message(span_danger("[user] attempts to dry [M] while [M] is swimming. It is not very effective."), span_userdanger("[user] attempts to dry you while you are swimming. It is not very effective."))
		return
	
	M.visible_message(span_danger("[user] begins to dry [M] with \the [src]"), span_userdanger("[user] begins do dry you with \the [src]"))
	if(do_after(user, 5 SECONDS, target=M))
		M.visible_message(span_danger("[user] dries off [M] with \the [src]"), span_userdanger("[user] dries you off with \the [src]"))
		dry(M)


/obj/item/towel/proc/dampen()
	if(damp) return
	oldname = name
	name = "damp [name]"
	damp = TRUE

/obj/item/towel/proc/undampen()
	if(!damp) return
	name = oldname
	damp = FALSE

/obj/item/towel/proc/dry(mob/living/M)
	SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, /datum/mood_event/poolwet)
	dampen()

