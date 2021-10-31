export ^

VERSION = "1.0"

MODULE_PREFIX = "PATTON_"

OBSERVATION_DUMMY_SIDENAME = "-----------"

PATTON_WIZARD_MESSAGE = "Welcome to PATTON v"..VERSION.."!\n\nHow many minutes between orders?"
PATTON_TURN_MESSAGE = "<br/><hr><br/><center><b>ORDER PHASE</b></center><br/><hr><br/>Give orders to your units as needed. When you're ready, <b>start the clock</b> to execute them."

PATTON_InitRandom = ->
	math.randomseed(os.time())
	for i=1,3
		math.random!

PATTON_OnLoad = ->
	PATTON_InitRandom!
	PATTON_InitAPIReplace!

PATTON_OnTick = ->
	PATTON_MirrorScore!
	PATTON_MirrorContactPostures!

PATTON_GiveOrders = ->
	PATTON_TransferRPs!
	PATTON_RemoveDummyUnit!

	player_side = PK_String_Eval("PATTON_PLAYER_SIDENAME")
	Side_SwitchTo(player_side)

	WaitFor(1, "PATTON_ObserveOrders()")
	ScenEdit_SpecialMessage("playerside", PATTON_TURN_MESSAGE)

PATTON_ObserveOrders = ->
	PATTON_MirrorPlayerSide!
	PATTON_AddDummyUnit!
	PATTON_WipeRPs!

	Side_SwitchTo(OBSERVATION_DUMMY_SIDENAME)

	turn_length = PK_Number_Eval("PATTON_ORDER_INTERVAL")
	WaitFor(turn_length-1, "PATTON_GiveOrders()")

PATTON_Remove = ->
	-- restore player to original side
	player_side = PK_String_Eval("PATTON_PLAYER_SIDENAME")
	Side_SwitchTo(player_side)
	Side_Remove(OBSERVATION_DUMMY_SIDENAME)

	-- remove API replacements
	PATTON_InitAPIRestore!
	
	-- destroy all PATTON-based events
	events = List_Select(
		ScenEdit_GetEvents(),
		(e) -> string.find(e.details.description, MODULE_PREFIX)	
	)
	for event in *events
		Event_Delete(event.details.description)

PATTON_Setup = ->
	if PK_Boolean_Exists("PATTON_RUNNING")
		PATTON_Remove!
	
	turn_length = math.floor(60*Input_Number(PATTON_WIZARD_MESSAGE))
	PK_Number_Store("PATTON_ORDER_INTERVAL", turn_length)
	player_side = ScenEdit_PlayerSide()
	PK_String_Store("PATTON_PLAYER_SIDENAME", player_side)

	Side_Add(OBSERVATION_DUMMY_SIDENAME)

	-- Initialize PATTON upon load from save
	evt_load = Event_Create("PATTON_Load", {
		IsRepeatable:true,
		IsShown:false
	})
	Event_AddTrigger(
		evt_load,
		Trigger_Create("PATTON_OnLoad", {
			type:"ScenLoaded"
		})
	)
	Event_AddAction(
		evt_load,
		Action_Create("PATTON_LoadFromString", {
			type:"LuaScript",
			ScriptText:PATTON_LOADER
		})
	)

	-- initialize contact posture mirroring
	evt_update = Event_Create("PATTON_Tick", {
		IsRepeatable:true,
		IsShown:false
	})
	Event_AddTrigger(
		evt_update,
		Trigger_Create("PATTON_Tick_Trigger", {
			type:"RegularTime",
			interval:0
		})
	)
    Event_AddAction(
		evt_update,
		Action_Create("PATTON_Tick_Action", {
        	type:"LuaScript", 
        	ScriptText:"PATTON_OnTick()"
		})
	)

	PK_Boolean_Store("PATTON_RUNNING", true)

	PATTON_OnLoad!
	PATTON_GiveOrders!