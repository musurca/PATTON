VERSION = "1.0"
OBSERVATION_DUMMY_SIDENAME = "-----------"
PATTON_WIZARD_MESSAGE = "Welcome to PATTON v" .. VERSION .. "!\n\nHow many minutes between orders?"
PATTON_TURN_MESSAGE = "<br/><hr><br/><center><b>ORDER PHASE</b></center><br/><hr><br/>Give orders to your units as needed. When you're ready, <b>start the clock</b> to execute them."
PATTON_InitRandom = function()
  math.randomseed(os.time())
  for i = 1, 3 do
    math.random()
  end
end
PATTON_OnLoad = function()
  PATTON_InitRandom()
  return PATTON_InitAPIReplace()
end
PATTON_GiveOrders = function()
  PATTON_TransferRPs()
  PATTON_RemoveDummyUnit()
  local player_side = PK_String_Eval("PATTON_PLAYER_SIDENAME")
  ScenEdit_SetSideOptions({
    side = player_side,
    switchto = true
  })
  WaitFor(1, "PATTON_ObserveOrders()")
  return ScenEdit_SpecialMessage("playerside", PATTON_TURN_MESSAGE)
end
PATTON_ObserveOrders = function()
  PATTON_MirrorPlayerSide()
  PATTON_AddDummyUnit()
  PATTON_WipeRPs()
  ScenEdit_SetSideOptions({
    side = OBSERVATION_DUMMY_SIDENAME,
    switchto = true
  })
  local turn_length = PK_Number_Eval("PATTON_ORDER_INTERVAL")
  return WaitFor(turn_length - 1, "PATTON_GiveOrders()")
end
PATTON_Setup = function()
  local turn_length = 60 * math.floor(Input_Number(PATTON_WIZARD_MESSAGE))
  PK_Number_Store("PATTON_ORDER_INTERVAL", turn_length)
  local player_side = ScenEdit_PlayerSide()
  PK_String_Store("PATTON_PLAYER_SIDENAME", player_side)
  ScenEdit_AddSide({
    name = OBSERVATION_DUMMY_SIDENAME
  })
  local evt_load = Event_Create("PATTON_Load", {
    IsRepeatable = true,
    IsShown = false
  })
  Event_AddTrigger(evt_load, Trigger_Create("PATTON_OnLoad", {
    type = "ScenLoaded"
  }))
  Event_AddAction(evt_load, Action_Create("PATTON_LoadFromString", {
    type = "LuaScript",
    ScriptText = PATTON_LOADER
  }))
  local evt_update = Event_Create("PATTON_Tick", {
    IsRepeatable = true,
    IsShown = false
  })
  Event_AddTrigger(evt_update, Trigger_Create("PATTON_Tick_Trigger", {
    type = "RegularTime",
    interval = 0
  }))
  Event_AddAction(evt_update, Action_Create("PATTON_Tick_Action", {
    type = "LuaScript",
    ScriptText = "PATTON_MirrorContactPostures()"
  }))
  PK_Boolean_Store("PATTON_RUNNING", true)
  PATTON_OnLoad()
  return PATTON_GiveOrders()
end
