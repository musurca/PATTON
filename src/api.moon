export ^

PATTON_InitAPIReplace = ->
	PATTON_API_PlayerSide_Replace!
	PATTON_API_SpecialMessage_Replace!

PATTON_API_PlayerSide_Replace = ->
	if not __PATTON_FN_PLAYERSIDE__
		export __PATTON_FN_PLAYERSIDE__
		__PATTON_FN_PLAYERSIDE__ = ScenEdit_PlayerSide
	export ScenEdit_PlayerSide
	ScenEdit_PlayerSide = PATTON_API_PlayerSide

PATTON_API_PlayerSide_Restore = ->
	if __PATTON_FN_PLAYERSIDE__
		export ScenEdit_PlayerSide
		ScenEdit_PlayerSide = __PATTON_FN_PLAYERSIDE__

PATTON_API_PlayerSide = ->
	if not PK_Boolean_Exists("PATTON_RUNNING")
		PATTON_API_PlayerSide_Restore!
		return ScenEdit_PlayerSide()
	PK_String_Eval("PATTON_PLAYER_SIDENAME")

PATTON_API_SpecialMessage_Replace = ->
	if not __PATTON_FN_SPECIALMESSAGE__
		export __PATTON_FN_SPECIALMESSAGE__
		__PATTON_FN_SPECIALMESSAGE__ = ScenEdit_SpecialMessage
	ScenEdit_SpecialMessage = PATTON_API_SpecialMessage

PATTON_API_SpecialMessage_Restore = ->
	if __PATTON_FN_SPECIALMESSAGE__
		export ScenEdit_SpecialMessage
		ScenEdit_SpecialMessage = __PATTON_FN_SPECIALMESSAGE__

PATTON_API_SpecialMessage = (side, message, location) ->
	if not PK_Boolean_Exists("PATTON_RUNNING")
		PATTON_API_SpecialMessage_Restore!
		if location
			ScenEdit_SpecialMessage(side, message, location)
		else
			ScenEdit_SpecialMessage(side, message)

	player_side = PK_String_Eval("PATTON_PLAYER_SIDENAME")
	dummy_side = OBSERVATION_DUMMY_SIDENAME
	if side == player_side and __PATTON_FN_PLAYERSIDE__() == dummy_side
		side = dummy_side
	
	if location
		__PATTON_FN_SPECIALMESSAGE__(side, message, location)
	else
		__PATTON_FN_SPECIALMESSAGE__(side, message)