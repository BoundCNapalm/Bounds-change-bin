/datum/deathmatch_lobby
	/// Ckey of the host
	var/host
	/// Assoc list of ckey to list()
	var/list/players = list()
	/// Assoc list of ckey to list()
	var/list/observers = list()
	/// The current chosen map
	var/datum/lazy_template/deathmatch/map
	/// Our turf reservation AKA where the arena is
	var/datum/turf_reservation/location
	/// Whether players hear deadchat and people through walls
	var/global_chat = FALSE
	/// Whether the lobby is currently playing
	var/playing = FALSE
	/// Number of total ready players
	var/ready_count
	/// List of loadouts, either gotten from the deathmatch controller or the map
	var/list/loadouts

/datum/deathmatch_lobby/New(mob/player)
	. = ..()
	if (!player)
		stack_trace("Attempted to create a deathmatch lobby without a host.")
		return qdel(src)
	host = player.ckey
	map = GLOB.deathmatch_game.maps[pick(GLOB.deathmatch_game.maps)]
	log_game("[host] created a deathmatch lobby.")
	if (map.allowed_loadouts)
		loadouts = map.allowed_loadouts
	else
		loadouts = GLOB.deathmatch_game.loadouts
	add_player(player, loadouts[1], TRUE)
	ui_interact(player)

/datum/deathmatch_lobby/Destroy(force, ...)
	. = ..()
	for (var/key in players+observers)
		var/datum/tgui/ui = SStgui.get_open_ui(get_mob_by_ckey(key), src)
		if (ui) ui.close()
		remove_ckey_from_play(key)
	if(playing && !isnull(location))
		clear_reservation()
	players = null
	observers = null
	map = null
	location = null
	loadouts = null

/datum/deathmatch_lobby/proc/start_game()
	if (playing)
		return
	playing = TRUE

	location = map.lazy_load()
	if (!location)
		to_chat(get_mob_by_ckey(host), span_warning("Couldn't reserve/load a map location (all locations used?), try again later, or contact a coder."))
		playing = FALSE
		return FALSE

	if (!length(GLOB.deathmatch_game.spawnpoint_processing))
		clear_reservation()
		playing = FALSE
		return FALSE

	var/list/spawns = GLOB.deathmatch_game.spawnpoint_processing.Copy()
	GLOB.deathmatch_game.spawnpoint_processing.Cut()
	if (!length(spawns) || length(spawns) < length(players))
		stack_trace("Failed to get spawns when loading deathmatch map [map.name] for lobby [host].")
		clear_reservation()
		playing = FALSE
		return FALSE

	for (var/key in players)
		var/mob/dead/observer/observer = players[key]["mob"]
		if (isnull(observer) || !observer.client)
			log_game("Removed player [key] from deathmatch lobby [host], as they couldn't be found.")
			remove_ckey_from_play(key)
			continue

		// pick spawn and remove it.
		var/picked_spawn = pick_n_take(spawns)
		spawn_observer_as_player(key, get_turf(picked_spawn))
		qdel(picked_spawn)

	// Remove rest of spawns.
	for (var/unused_spawn in spawns)
		qdel(unused_spawn)

	for (var/observer_key in observers)
		var/mob/observer = observers[observer_key]["mob"]
		observer.forceMove(pick(location.reserved_turfs))

	addtimer(CALLBACK(src, PROC_REF(game_took_too_long)), initial(map.automatic_gameend_time))
	log_game("Deathmatch game [host] started.")
	announce(span_reallybig("GO!"))
	return TRUE

/datum/deathmatch_lobby/proc/spawn_observer_as_player(ckey, loc)
	var/mob/dead/observer/observer = players[ckey]["mob"]
	if (isnull(observer) || !observer.client)
		remove_ckey_from_play(ckey)
		return

	// equip player
	var/datum/outfit/deathmatch_loadout/loadout = players[ckey]["loadout"]
	if (!(loadout in loadouts))
		loadout = loadouts[1]

	observer.forceMove(loc)
	var/datum/mind/observer_mind = observer.mind
	var/mob/living/observer_current = observer.mind?.current
	var/mob/living/carbon/human/new_player = observer.change_mob_type(/mob/living/carbon/human, delete_old_mob = TRUE)
	if(!isnull(observer_mind) && observer_current)
		new_player.AddComponent( \
			/datum/component/temporary_body, \
			old_mind = observer_mind, \
			old_body = observer_current, \
		)
	new_player.equipOutfit(loadout) // Loadout
	players[ckey]["mob"] = new_player

	// register death handling.
	RegisterSignals(new_player, list(COMSIG_LIVING_DEATH, COMSIG_MOB_GHOSTIZED, COMSIG_QDELETING), PROC_REF(player_died))
	if (global_chat)
		ADD_TRAIT(new_player, TRAIT_SIXTHSENSE, INNATE_TRAIT)
		ADD_TRAIT(new_player, TRAIT_XRAY_HEARING, INNATE_TRAIT)

/datum/deathmatch_lobby/proc/game_took_too_long()
	if (!location || QDELING(src))
		return
	announce(span_reallybig("The players have took too long! Game ending!"))
	end_game()

/datum/deathmatch_lobby/proc/end_game()
	if (!location)
		CRASH("Reservation of deathmatch game [host] deleted during game.")
	var/mob/winner
	if(players.len)
		var/list/winner_info = players[pick(players)]
		if(!isnull(winner_info["mob"]))
			winner = winner_info["mob"] //only one should remain anyway but incase of a draw 
	
	announce(span_reallybig("THE GAME HAS ENDED.<BR>THE WINNER IS: [winner ? winner.real_name : "no one"]."))
	
	for(var/ckey in players)
		var/mob/loser = players[ckey]["mob"]
		UnregisterSignal(loser, list(COMSIG_MOB_GHOSTIZED, COMSIG_QDELETING))
		players[ckey]["mob"] = null
		loser.ghostize()
		qdel(loser)

	clear_reservation()
	GLOB.deathmatch_game.remove_lobby(host)
	log_game("Deathmatch game [host] ended.")

/datum/deathmatch_lobby/proc/player_died(mob/living/player, gibbed)
	SIGNAL_HANDLER
	if(isnull(player) || QDELING(src))
		return

	var/ckey = player.ckey
	if(!islist(players[ckey])) // potentially the player info could hold a reference to this mob so we can figure the ckey out without worrying about ghosting and suicides n such
		for(var/potential_ckey in players)
			var/list/player_info = players[potential_ckey]
			if(player_info["mob"] && player_info["mob"] == player)
				ckey = potential_ckey
				break
	
	if(!islist(players[ckey])) // if we STILL didnt find a good ckey
		return

	players -= ckey

	var/mob/dead/observer/ghost = !player.client ? player.get_ghost() : player.ghostize() //this doesnt work on those who used the ghost verb
	if(!isnull(ghost))
		add_observer(ghost, (host == ckey))
	
	announce(span_reallybig("[player.real_name] HAS DIED.<br>[players.len] REMAIN."))

	if(!gibbed && !QDELING(player)) // for some reason dusting or deleting in chasm storage messes up tgui bad
		player.dust(TRUE, TRUE, TRUE)
	if (players.len <= 1)
		end_game()

/datum/deathmatch_lobby/proc/add_observer(mob/mob, host = FALSE)
	if (players[mob.ckey])
		CRASH("Tried to add [mob.ckey] as an observer while being a player.")
	observers[mob.ckey] = list("mob" = mob, "host" = host)

/datum/deathmatch_lobby/proc/add_player(mob/mob, loadout, host = FALSE)
	if (observers[mob.ckey])
		CRASH("Tried to add [mob.ckey] as a player while being an observer.")
	players[mob.ckey] = list("mob" = mob, "host" = host, "ready" = FALSE, "loadout" = loadout)

/datum/deathmatch_lobby/proc/remove_ckey_from_play(ckey)
	var/is_likely_player = (ckey in players)
	var/list/main_list = is_likely_player ? players : observers
	var/list/info = main_list[ckey]
	if(is_likely_player && islist(info))
		ready_count -= info["ready"]
	main_list -= ckey

/datum/deathmatch_lobby/proc/announce(message)
	for (var/key in players+observers)
		var/mob/player = get_mob_by_ckey(key)
		if (!player.client)
			remove_ckey_from_play(key)
			continue
		to_chat(player.client, message)

/datum/deathmatch_lobby/proc/leave(ckey)
	if (host == ckey)
		var/total_count = players.len + observers.len
		if (total_count <= 1) // <= just in case.
			GLOB.deathmatch_game.remove_lobby(host)
			return
		else
			if (players[ckey] && players.len <= 1)
				for (var/key in observers)
					if (host == key)
						continue
					host = key
					observers[key]["host"] = TRUE
					break
			else
				for (var/key in players)
					if (host == key)
						continue
					host = key
					players[key]["host"] = TRUE
					break
			GLOB.deathmatch_game.passoff_lobby(ckey, host)
	
	remove_ckey_from_play(ckey)

/datum/deathmatch_lobby/proc/join(mob/player)
	if (playing || !player)
		return
	if(!(player.ckey in players+observers))
		if (players.len >= map.max_players)
			add_observer(player)
		else
			add_player(player, loadouts[1])
	ui_interact(player)

/datum/deathmatch_lobby/proc/spectate(mob/player)
	if (!playing || !location || !player)
		return
	if (!observers[player.ckey])
		add_observer(player)
	player.forceMove(pick(location.reserved_turfs))

/datum/deathmatch_lobby/proc/change_map(new_map)
	if (!new_map || !GLOB.deathmatch_game.maps[new_map])
		return
	map = GLOB.deathmatch_game.maps[new_map]
	var/max_players = map.max_players
	for (var/possible_unlucky_loser in players)
		max_players--
		if (max_players <= 0)
			var/loser_mob = players[possible_unlucky_loser]["mob"]
			remove_ckey_from_play(possible_unlucky_loser)
			add_observer(loser_mob)

	loadouts = map.allowed_loadouts ? map.allowed_loadouts : GLOB.deathmatch_game.loadouts
	for (var/player_key in players)
		if (players[player_key]["loadout"] in loadouts)
			continue
		players[player_key]["loadout"] = loadouts[1]

/datum/deathmatch_lobby/proc/clear_reservation()
	if(isnull(location) || isnull(map))
		return
	for(var/turf/victimized_turf as anything in location.reserved_turfs) //remove this once clearing turf reservations is actually reliable
		victimized_turf.empty()
	map.reservations -= location
	qdel(location)

/datum/deathmatch_lobby/Topic(href, href_list) //This handles the chat Join button href, supposedly
	var/mob/dead/observer/ghost = usr
	if (!istype(ghost))
		return
	if(href_list["join"])
		join(ghost)

/datum/deathmatch_lobby/ui_state(mob/user)
	return GLOB.observer_state

/datum/deathmatch_lobby/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, null)
	if(!ui)
		ui = new(user, src, "DeathmatchLobby")
		ui.open()

/datum/deathmatch_lobby/ui_static_data(mob/user)
	. = list()
	.["maps"] = list()
	for (var/map_key in GLOB.deathmatch_game.maps)
		.["maps"] += map_key

/datum/deathmatch_lobby/ui_data(mob/user)
	. = list()
	.["self"] = user.ckey
	.["host"] = (user.ckey == host)
	.["admin"] = check_rights_for(user.client, R_ADMIN)
	.["global_chat"] = global_chat
	.["loadouts"] = list()
	for (var/datum/outfit/deathmatch_loadout/loadout as anything in loadouts)
		.["loadouts"] += initial(loadout.display_name)
	.["map"] = list()
	.["map"]["name"] = map.name
	.["map"]["desc"] = map.desc
	.["map"]["time"] = map.automatic_gameend_time
	.["map"]["min_players"] = map.min_players
	.["map"]["max_players"] = map.max_players
	if(!isnull(players[user.ckey]) && !isnull(players[user.ckey]["loadout"]))
		var/datum/outfit/deathmatch_loadout/loadout = players[user.ckey]["loadout"]
		.["loadoutdesc"] = initial(loadout.desc)
	else
		.["loadoutdesc"] = "You are an observer! As an observer, you can hear lobby announcements."
	.["players"] = list()
	for (var/player_key in players)
		var/list/player_info = players[player_key]
		var/mob/player_mob = player_info["mob"]
		if (isnull(player_mob) || !player_mob.client)
			leave(player_key)
			continue
		.["players"][player_key] = player_info.Copy()
		var/datum/outfit/deathmatch_loadout/dm_loadout = player_info["loadout"]
		.["players"][player_key]["loadout"] = initial(dm_loadout.display_name)
	.["observers"] = list()
	for (var/observer_key in observers)
		var/mob/observer = observers[observer_key]["mob"]
		if (isnull(observer) || !observer.client)
			leave(observer_key)
			continue
		.["observers"][observer_key] = observers[observer_key]

/datum/deathmatch_lobby/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || !isobserver(usr))
		return
	switch(action)
		if ("start_game")
			if (usr.ckey != host)
				return FALSE
			if (map.min_players > players.len)
				to_chat(usr, span_warning("Not enough players to start yet."))
				return FALSE
			start_game()
			return TRUE
		if ("leave_game")
			if (playing)
				return FALSE
			leave(usr.ckey)
			ui.close()
			GLOB.deathmatch_game.ui_interact(usr)
			return TRUE
		if ("change_loadout")
			if (playing)
				return FALSE
			if (params["player"] != usr.ckey && host != usr.ckey)
				return FALSE
			for (var/datum/outfit/deathmatch_loadout/possible_loadout as anything in loadouts)
				if (params["loadout"] != initial(possible_loadout.display_name))
					continue
				players[params["player"]]["loadout"] = possible_loadout
				break
			return TRUE
		if ("observe")
			if (playing)
				return FALSE
			if (players[usr.ckey])
				remove_ckey_from_play(usr.ckey)
				add_observer(usr, host == usr.ckey)
				return TRUE
			else if (observers[usr.ckey] && players.len < map.max_players)
				remove_ckey_from_play(usr.ckey)
				add_player(usr, loadouts[1], host == usr.ckey)
				return TRUE
		if ("ready")
			players[usr.ckey]["ready"] ^= 1 // Toggle.
			ready_count += (players[usr.ckey]["ready"] * 2) - 1 // scared?
			if (ready_count >= players.len && players.len >= map.min_players)
				start_game()
			return TRUE
		if ("host") // Host functions
			if (playing || (usr.ckey != host && !check_rights(R_ADMIN)))
				return FALSE
			var/uckey = params["id"]
			switch (params["func"])
				if ("Kick")
					leave(uckey)
					var/umob = get_mob_by_ckey(uckey)
					var/datum/tgui/uui = SStgui.get_open_ui(umob, src)
					uui?.close()
					GLOB.deathmatch_game.ui_interact(umob)
					return TRUE
				if ("Transfer host")
					if (host == uckey)
						return FALSE
					GLOB.deathmatch_game.passoff_lobby(host, uckey)
					host = uckey
					return TRUE
				if ("Toggle observe")
					var/umob = get_mob_by_ckey(uckey)
					if (players[uckey])
						remove_ckey_from_play(uckey)
						add_observer(umob, host == uckey)
					else if (observers[uckey] && players.len < map.max_players)
						remove_ckey_from_play(uckey)
						add_player(umob, loadouts[1], host == uckey)
					return TRUE
				if ("change_map")
					if (!(params["map"] in GLOB.deathmatch_game.maps))
						return FALSE
					change_map(params["map"])
					return TRUE
				if ("global_chat")
					global_chat = !global_chat
					return TRUE
		if ("admin") // Admin functions
			if (!check_rights(R_ADMIN))
				message_admins("[usr.key] has attempted to use admin functions in a deathmatch lobby!")
				log_admin("[key_name(usr)] tried to use the deathmatch lobby admin functions without authorization.")
				return
			switch (params["func"])
				if ("Force start")
					log_admin("[key_name(usr)] force started deathmatch lobby [host].")
					start_game()


