export ^

PATTON_MirrorPlayerSide = ->
	player_side = PK_String_Eval("PATTON_PLAYER_SIDENAME")
	dummy_side = OBSERVATION_DUMMY_SIDENAME
	ScenEdit_SetSidePosture(
		player_side,
		dummy_side,
		"F"
	)
	ScenEdit_SetSidePosture(
		dummy_side,
		player_side,
		"F"
	)
	for side in *VP_GetSides!
		side_name = side.name
		if player_side != side_name
			posture = ScenEdit_GetSidePosture(player_side, side_name)
			ScenEdit_SetSidePosture(dummy_side, side_name, posture)

PATTON_MirrorScore = ->
	player_side = PK_String_Eval("PATTON_PLAYER_SIDENAME")
	dummy_side = OBSERVATION_DUMMY_SIDENAME
    sidescore = ScenEdit_GetScore(player_side)
    if ScenEdit_GetScore(dummy_side) != sidescore
        ScenEdit_SetScore(dummy_side, sidescore, player_side)

PATTON_MirrorContactPostures = ->
	mirrorside = PK_String_Eval("PATTON_PLAYER_SIDENAME")
	dummy_side = OBSERVATION_DUMMY_SIDENAME
	-- find the GUID of the player's side
	side = List_Query(VP_GetSides(), (s) -> s.name == mirrorside)
	mirrorside_guid = ""
	if side
		mirrorside_guid = side.guid

	--now mirror contact postures
	for contact in *ScenEdit_GetContacts(dummy_side)
        unit = ScenEdit_GetUnit({
			guid:contact.actualunitid
		})
		as_con = List_Query(
			unit.ascontact,
			(c) -> c.side == mirrorside_guid
		)
		if as_con
			mcontact = ScenEdit_GetContact({
				side:mirrorside, 
				guid:as_con.guid
			})
			if mcontact.posture != contact.posture
				contact.posture = mcontact.posture

PATTON_WipeRPs = ->
	dummy_side = OBSERVATION_DUMMY_SIDENAME
	area = {}
	side = List_Query(
		VP_GetSides(), 
		(s) -> s.name == dummy_side
	)
	if side
		area = [v.name for v in *side.rps]
		if #area > 0
			rps = ScenEdit_GetReferencePoints({
				side:dummy_side,
				area:area
			})
			for v in *rps
				ScenEdit_DeleteReferencePoint(v)

PATTON_TransferRPs = ->
	player_side = PK_String_Eval("PATTON_PLAYER_SIDENAME")
	dummy_side = OBSERVATION_DUMMY_SIDENAME
	area = {}
	side = List_Query(
		VP_GetSides(), 
		(s) -> s.name == dummy_side
	)
	if side
		area = [v.name for v in *side.rps]
		if #area > 0
			rps = ScenEdit_GetReferencePoints({
				side:dummy_side,
				area:area
			})
			for v in *rps
				ScenEdit_AddReferencePoint({
					side:player_side,
					name:v.name,
					lat:v.latitude,
					lon:v.longitude,
					highlighted:true
				})
				ScenEdit_DeleteReferencePoint(v)

PATTON_RemoveDummyUnit = ->
	if PK_String_Exists("PATTON_DUMMY_GUID")
		--remove it
		pcall(ScenEdit_DeleteUnit, {
            side:OBSERVATION_DUMMY_SIDENAME, 
            guid:PK_String_Eval("PATTON_DUMMY_GUID")
        })
		PK_String_Store("PATTON_DUMMY_GUID", "")

PATTON_AddDummyUnit = ->
	if PK_String_Exists("PATTON_DUMMY_GUID")
		PATTON_RemoveDummyUnit!

    --adds a dummy unit so allies transmit contacts
    dummy = ScenEdit_AddUnit({
        side:OBSERVATION_DUMMY_SIDENAME, 
        name:"",
        type:"FACILITY",
        dbid:174, 
        latitude:-89,
        longitude:0,
    })
	-- store its GUID
	PK_String_Store("PATTON_DUMMY_GUID", dummy.guid)