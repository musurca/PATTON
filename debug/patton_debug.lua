--[[
----------------------------------------------
PATTON v1.0 by Nicholas Musurca (nick.musurca@gmail.com)
Licensed under GNU GPLv3. (https://www.gnu.org/licenses/gpl-3.0-standalone.html)

MAKE SURE YOU READ THE INCLUDED MANUAL BEFORE DOING ANYTHING WITH THIS CODE!
----------------------------------------------
]]--

PATTON_InitAPIReplace = function()
  PATTON_API_PlayerSide_Replace()
  return PATTON_API_SpecialMessage_Replace()
end
PATTON_API_PlayerSide_Replace = function()
  if not __PATTON_FN_PLAYERSIDE__ then
    __PATTON_FN_PLAYERSIDE__ = ScenEdit_PlayerSide
  end
  ScenEdit_PlayerSide = PATTON_API_PlayerSide
end
PATTON_API_PlayerSide_Restore = function()
  if __PATTON_FN_PLAYERSIDE__ then
    ScenEdit_PlayerSide = __PATTON_FN_PLAYERSIDE__
  end
end
PATTON_API_PlayerSide = function()
  if not PK_Boolean_Exists("PATTON_RUNNING") then
    PATTON_API_PlayerSide_Restore()
    return ScenEdit_PlayerSide()
  end
  return PK_String_Eval("PATTON_PLAYER_SIDENAME")
end
PATTON_API_SpecialMessage_Replace = function()
  if not __PATTON_FN_SPECIALMESSAGE__ then
    __PATTON_FN_SPECIALMESSAGE__ = ScenEdit_SpecialMessage
  end
  local ScenEdit_SpecialMessage = PATTON_API_SpecialMessage
end
PATTON_API_SpecialMessage_Restore = function()
  if __PATTON_FN_SPECIALMESSAGE__ then
    ScenEdit_SpecialMessage = __PATTON_FN_SPECIALMESSAGE__
  end
end
PATTON_API_SpecialMessage = function(side, message, location)
  if not PK_Boolean_Exists("PATTON_RUNNING") then
    PATTON_API_SpecialMessage_Restore()
    if location then
      ScenEdit_SpecialMessage(side, message, location)
    else
      ScenEdit_SpecialMessage(side, message)
    end
  end
  local player_side = PK_String_Eval("PATTON_PLAYER_SIDENAME")
  local dummy_side = OBSERVATION_DUMMY_SIDENAME
  if side == player_side and __PATTON_FN_PLAYERSIDE__() == dummy_side then
    side = dummy_side
  end
  if location then
    return __PATTON_FN_SPECIALMESSAGE__(side, message, location)
  else
    return __PATTON_FN_SPECIALMESSAGE__(side, message)
  end
end


Event_Create = function(evt_name, args)
  local _list_0 = ScenEdit_GetEvents()
  for _index_0 = 1, #_list_0 do
    local event = _list_0[_index_0]
    if event.details.description == evt_name then
      ScenEdit_SetEvent(evt_name, {
        mode = "remove"
      })
    end
  end
  args.mode = "add"
  ScenEdit_SetEvent(evt_name, args)
  return evt_name
end
Event_AddTrigger = function(evt, trig)
  return ScenEdit_SetEventTrigger(evt, {
    mode = 'add',
    name = trig
  })
end
Event_RemoveTrigger = function(evt, trig)
  return ScenEdit_SetEventTrigger(evt, {
    mode = 'remove',
    name = trig
  })
end
Event_AddCondition = function(evt, cond)
  return ScenEdit_SetEventCondition(evt, {
    mode = 'add',
    name = cond
  })
end
Event_RemoveCondition = function(evt, cond)
  return ScenEdit_SetEventCondition(evt, {
    mode = 'remove',
    name = cond
  })
end
Event_AddAction = function(evt, action)
  return ScenEdit_SetEventAction(evt, {
    mode = 'add',
    name = action
  })
end
Event_RemoveAction = function(evt, action)
  return ScenEdit_SetEventAction(evt, {
    mode = 'remove',
    name = action
  })
end
Trigger_Create = function(trig_name, args)
  args.name = trig_name
  args.mode = "add"
  ScenEdit_SetTrigger(args)
  return trig_name
end
Trigger_Delete = function(trig_name)
  return ScenEdit_SetTrigger({
    name = trig_name,
    mode = "remove"
  })
end
Condition_Create = function(cond_name, args)
  args.name = cond_name
  args.mode = "add"
  ScenEdit_SetCondition(args)
  return cond_name
end
Condition_Delete = function(cond_name)
  return ScenEdit_SetCondition({
    name = cond_name,
    mode = "remove"
  })
end
Action_Create = function(action_name, args)
  args.name = action_name
  args.mode = "add"
  ScenEdit_SetAction(args)
  return action_name
end
Action_Delete = function(action_name)
  return ScenEdit_SetAction({
    name = action_name,
    mode = "remove"
  })
end
Event_Delete = function(evt_name, recurse)
  recurse = recurse or true
  if recurse then
    local _list_0 = ScenEdit_GetEvents()
    for _index_0 = 1, #_list_0 do
      local event = _list_0[_index_0]
      if event.details.description == evt_name then
        local _list_1 = event.details.triggers
        for _index_1 = 1, #_list_1 do
          local e = _list_1[_index_1]
          for key, val in pairs(e) do
            if val.Description then
              Event_RemoveTrigger(evt_name, val.Description)
              Trigger_Delete(val.Description)
            end
          end
        end
        local _list_2 = event.details.conditions
        for _index_1 = 1, #_list_2 do
          local e = _list_2[_index_1]
          for key, val in pairs(e) do
            if val.Description then
              Event_RemoveCondition(evt_name, val.Description)
              Condition_Delete(val.Description)
            end
          end
        end
        local _list_3 = event.details.actions
        for _index_1 = 1, #_list_3 do
          local e = _list_3[_index_1]
          for key, val in pairs(e) do
            if val.Description then
              Event_RemoveAction(evt_name, val.Description)
              Action_Delete(val.Description)
            end
          end
        end
        break
      end
    end
  end
  return ScenEdit_SetEvent(evt_name, {
    mode = "remove"
  })
end
WaitFor = function(seconds, code)
  local uuid
  uuid = function()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    local swap
    swap = function(c)
      local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
      return string.format('%x', v)
    end
    return string.gsub(template, '[xy]', swap)
  end
  local run_epoch = (62135596800 + ScenEdit_CurrentTime() + seconds) * 10000000
  local evt_name = Event_Create(uuid(), {
    IsRepeatable = false,
    IsShown = false
  })
  local trigger_name = Trigger_Create(uuid(), {
    type = 'Time',
    Time = run_epoch
  })
  Event_AddTrigger(evt_name, trigger_name)
  local script = "__waitevt__=function()\r\n" .. code .. "\r\nend\r\npcall(__waitevt__)\r\npcall(Event_Delete, \"" .. evt_name .. "\")"
  local action_name = Action_Create(uuid(), {
    type = 'LuaScript',
    ScriptText = script
  })
  Event_AddAction(evt_name, action_name)
  return evt_name
end


PK_String_Exists = function(key_name)
  return ScenEdit_GetKeyValue(key_name) ~= ""
end
PK_String_Eval = function(key_name)
  return ScenEdit_GetKeyValue(key_name)
end
PK_String_Store = function(key_name, value)
  return ScenEdit_SetKeyValue(key_name, tostring(value))
end
PK_Number_Exists = function(key_name)
  return PK_String_Exists(key_name)
end
PK_Number_Eval = function(key_name)
  local val = tonumber(PK_String_Eval(key_name))
  if val == nil then
    return 0
  end
  return val
end
PK_Number_Store = function(key_name, value)
  local v = tonumber(value)
  if v == nil then
    v = 0
  end
  return PK_String_Store(key_name, v)
end
PK_Boolean_Exists = function(key_name)
  return PK_String_Exists(key_name)
end
PK_Boolean_Eval = function(key_name)
  local key_table = {
    ["T"] = true,
    ["F"] = false
  }
  local val = PK_String_Eval(key_name)
  for k, v in pairs(key_table) do
    if val == k then
      return v
    end
  end
  return false
end
PK_Boolean_Store = function(key_name, value)
  if value then
    return PK_String_Store(key_name, "T")
  else
    return PK_String_Store(key_name, "F")
  end
end


OBSERVATION_DUMMY_SIDENAME = "-----------"
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
  ScenEdit_SpecialMessage("playerside", "Issue your orders as needed. When you're ready to execute them, hit PLAY to begin your turn.")
  local turn_length = PK_Number_Eval("PATTON_ORDER_INTERVAL")
  WaitFor(1, "PATTON_ObserveOrders()")
  return WaitFor(turn_length, "PATTON_GiveOrders()")
end
PATTON_ObserveOrders = function()
  PATTON_MirrorPlayerSide()
  PATTON_AddDummyUnit()
  PATTON_WipeRPs()
  return ScenEdit_SetSideOptions({
    side = OBSERVATION_DUMMY_SIDENAME,
    switchto = true
  })
end
PATTON_Setup = function()
  PATTON_InitRandom()
  local turn_length = 60 * math.floor(Input_Number("How many minutes between orders?"))
  PK_Number_Store("PATTON_ORDER_INTERVAL", turn_length)
  local player_side = ScenEdit_PlayerSide()
  PK_String_Store("PATTON_PLAYER_SIDENAME", player_side)
  ScenEdit_AddSide({
    name = OBSERVATION_DUMMY_SIDENAME
  })
  local evt_load = Event_Create("PATTON_Load")
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
  return PATTON_GiveOrders()
end


PATTON_MirrorPlayerSide = function()
  local player_side = PK_String_Eval("PATTON_PLAYER_SIDENAME")
  local dummy_side = OBSERVATION_DUMMY_SIDENAME
  ScenEdit_SetSidePosture(player_side, dummy_side, "F")
  ScenEdit_SetSidePosture(dummy_side, player_side, "F")
  local _list_0 = VP_GetSides()
  for _index_0 = 1, #_list_0 do
    local side = _list_0[_index_0]
    local side_name = side.name
    if player_side ~= side_name then
      local posture = ScenEdit_GetSidePosture(player_side, side_name)
      ScenEdit_SetSidePosture(dummy_side, side_name, posture)
    end
  end
end
PATTON_MirrorContactPostures = function()
  local mirrorside = PK_String_Eval("PATTON_PLAYER_SIDENAME")
  local dummy_side = OBSERVATION_DUMMY_SIDENAME
  local mirrorside_guid = ""
  local _list_0 = VP_GetSides()
  for _index_0 = 1, #_list_0 do
    local side = _list_0[_index_0]
    if side.name == mirrorside then
      mirrorside_guid = side.guid
      break
    end
  end
  for k, contact in ipairs(ScenEdit_GetContacts(dummy_side)) do
    local unit = ScenEdit_GetUnit({
      guid = contact.actualunitid
    })
    for j, ascon in ipairs(unit.ascontact) do
      if ascon.side == mirrorside_guid then
        local mcontact = ScenEdit_GetContact({
          side = mirrorside,
          guid = ascon.guid
        })
        if mcontact.posture ~= contact.posture then
          contact.posture = mcontact.posture
        end
        break
      end
    end
  end
end
PATTON_WipeRPs = function()
  local dummy_side = OBSERVATION_DUMMY_SIDENAME
  local area = { }
  local _list_0 = VP_GetSides()
  for _index_0 = 1, #_list_0 do
    local side = _list_0[_index_0]
    if side.name == dummy_side then
      do
        local _accum_0 = { }
        local _len_0 = 1
        for k, v in ipairs(side.rps) do
          _accum_0[_len_0] = v.name
          _len_0 = _len_0 + 1
        end
        area = _accum_0
      end
      if #area > 0 then
        local rps = ScenEdit_GetReferencePoints({
          side = dummy_side,
          area = area
        })
        for k, v in ipairs(rps) do
          ScenEdit_DeleteReferencePoint(v)
        end
      end
      break
    end
  end
end
PATTON_TransferRPs = function()
  local player_side = PK_String_Eval("PATTON_PLAYER_SIDENAME")
  local dummy_side = OBSERVATION_DUMMY_SIDENAME
  local area = { }
  local _list_0 = VP_GetSides()
  for _index_0 = 1, #_list_0 do
    local side = _list_0[_index_0]
    if side.name == dummy_side then
      do
        local _accum_0 = { }
        local _len_0 = 1
        for k, v in ipairs(side.rps) do
          _accum_0[_len_0] = v.name
          _len_0 = _len_0 + 1
        end
        area = _accum_0
      end
      if #area > 0 then
        local rps = ScenEdit_GetReferencePoints({
          side = dummy_side,
          area = area
        })
        for k, v in ipairs(rps) do
          ScenEdit_AddReferencePoint({
            side = player_side,
            name = v.name,
            lat = v.latitude,
            lon = v.longitude,
            highlighted = true
          })
          ScenEdit_DeleteReferencePoint(v)
        end
      end
      break
    end
  end
end
PATTON_RemoveDummyUnit = function()
  if PK_String_Exists("PATTON_DUMMY_GUID") then
    pcall(ScenEdit_DeleteUnit, {
      side = OBSERVATION_DUMMY_SIDENAME,
      guid = PK_String_Eval("PATTON_DUMMY_GUID")
    })
    return PK_String_Store("PATTON_DUMMY_GUID", "")
  end
end
PATTON_AddDummyUnit = function()
  if PK_String_Exists("PATTON_DUMMY_GUID") then
    PATTON_RemoveDummyUnit()
  end
  local dummy = ScenEdit_AddUnit({
    side = OBSERVATION_DUMMY_SIDENAME,
    name = "",
    type = "FACILITY",
    dbid = 174,
    latitude = -89,
    longitude = 0
  })
  return PK_String_Store("PATTON_DUMMY_GUID", dummy.guid)
end


Input_OK = function(question)
  return ScenEdit_MsgBox(question, 0)
end
Input_YesNo = function(question)
  local answer_table = {
    Yes = true,
    No = false
  }
  while true do
    local ans = ScenEdit_MsgBox(question, 4)
    if ans ~= 'Cancel' then
      return answer_table[ans]
    end
  end
  return false
end
Input_Number = function(question)
  while true do
    local val = tonumber(ScenEdit_InputBox(question))
    if val then
      return val
    end
  end
end
Input_Number_Default = function(question, default)
  local val = tonumber(ScenEdit_InputBox(question))
  if val then
    return val
  end
  return default
end
Input_String = function(question)
  local val = ScenEdit_InputBox(question)
  if val then
    return tostring(val)
  end
  return ""
end


--[[
----------------------------------------------
PATTON
xx_loader.lua
----------------------------------------------

Header to define the escaped Lua code that will
be injected into the CMO LuaScript action 
executed on scenario load.

----------------------------------------------
DO NOT EDIT THIS SOURCE FILE!
----------------------------------------------
]]--

PATTON_LOADER = "PATTON_InitAPIReplace = function()\r\n  PATTON_API_PlayerSide_Replace()\r\n  return PATTON_API_SpecialMessage_Replace()\r\nend\r\nPATTON_API_PlayerSide_Replace = function()\r\n  if not __PATTON_FN_PLAYERSIDE__ then\r\n    __PATTON_FN_PLAYERSIDE__ = ScenEdit_PlayerSide\r\n  end\r\n  ScenEdit_PlayerSide = PATTON_API_PlayerSide\r\nend\r\nPATTON_API_PlayerSide_Restore = function()\r\n  if __PATTON_FN_PLAYERSIDE__ then\r\n    ScenEdit_PlayerSide = __PATTON_FN_PLAYERSIDE__\r\n  end\r\nend\r\nPATTON_API_PlayerSide = function()\r\n  if not PK_Boolean_Exists(\"PATTON_RUNNING\") then\r\n    PATTON_API_PlayerSide_Restore()\r\n    return ScenEdit_PlayerSide()\r\n  end\r\n  return PK_String_Eval(\"PATTON_PLAYER_SIDENAME\")\r\nend\r\nPATTON_API_SpecialMessage_Replace = function()\r\n  if not __PATTON_FN_SPECIALMESSAGE__ then\r\n    __PATTON_FN_SPECIALMESSAGE__ = ScenEdit_SpecialMessage\r\n  end\r\n  local ScenEdit_SpecialMessage = PATTON_API_SpecialMessage\r\nend\r\nPATTON_API_SpecialMessage_Restore = function()\r\n  if __PATTON_FN_SPECIALMESSAGE__ then\r\n    ScenEdit_SpecialMessage = __PATTON_FN_SPECIALMESSAGE__\r\n  end\r\nend\r\nPATTON_API_SpecialMessage = function(side, message, location)\r\n  if not PK_Boolean_Exists(\"PATTON_RUNNING\") then\r\n    PATTON_API_SpecialMessage_Restore()\r\n    if location then\r\n      ScenEdit_SpecialMessage(side, message, location)\r\n    else\r\n      ScenEdit_SpecialMessage(side, message)\r\n    end\r\n  end\r\n  local player_side = PK_String_Eval(\"PATTON_PLAYER_SIDENAME\")\r\n  local dummy_side = OBSERVATION_DUMMY_SIDENAME\r\n  if side == player_side and __PATTON_FN_PLAYERSIDE__() == dummy_side then\r\n    side = dummy_side\r\n  end\r\n  if location then\r\n    return __PATTON_FN_SPECIALMESSAGE__(side, message, location)\r\n  else\r\n    return __PATTON_FN_SPECIALMESSAGE__(side, message)\r\n  end\r\nend\r\n\r\n\r\nEvent_Create = function(evt_name, args)\r\n  local _list_0 = ScenEdit_GetEvents()\r\n  for _index_0 = 1, #_list_0 do\r\n    local event = _list_0[_index_0]\r\n    if event.details.description == evt_name then\r\n      ScenEdit_SetEvent(evt_name, {\r\n        mode = \"remove\"\r\n      })\r\n    end\r\n  end\r\n  args.mode = \"add\"\r\n  ScenEdit_SetEvent(evt_name, args)\r\n  return evt_name\r\nend\r\nEvent_AddTrigger = function(evt, trig)\r\n  return ScenEdit_SetEventTrigger(evt, {\r\n    mode = 'add',\r\n    name = trig\r\n  })\r\nend\r\nEvent_RemoveTrigger = function(evt, trig)\r\n  return ScenEdit_SetEventTrigger(evt, {\r\n    mode = 'remove',\r\n    name = trig\r\n  })\r\nend\r\nEvent_AddCondition = function(evt, cond)\r\n  return ScenEdit_SetEventCondition(evt, {\r\n    mode = 'add',\r\n    name = cond\r\n  })\r\nend\r\nEvent_RemoveCondition = function(evt, cond)\r\n  return ScenEdit_SetEventCondition(evt, {\r\n    mode = 'remove',\r\n    name = cond\r\n  })\r\nend\r\nEvent_AddAction = function(evt, action)\r\n  return ScenEdit_SetEventAction(evt, {\r\n    mode = 'add',\r\n    name = action\r\n  })\r\nend\r\nEvent_RemoveAction = function(evt, action)\r\n  return ScenEdit_SetEventAction(evt, {\r\n    mode = 'remove',\r\n    name = action\r\n  })\r\nend\r\nTrigger_Create = function(trig_name, args)\r\n  args.name = trig_name\r\n  args.mode = \"add\"\r\n  ScenEdit_SetTrigger(args)\r\n  return trig_name\r\nend\r\nTrigger_Delete = function(trig_name)\r\n  return ScenEdit_SetTrigger({\r\n    name = trig_name,\r\n    mode = \"remove\"\r\n  })\r\nend\r\nCondition_Create = function(cond_name, args)\r\n  args.name = cond_name\r\n  args.mode = \"add\"\r\n  ScenEdit_SetCondition(args)\r\n  return cond_name\r\nend\r\nCondition_Delete = function(cond_name)\r\n  return ScenEdit_SetCondition({\r\n    name = cond_name,\r\n    mode = \"remove\"\r\n  })\r\nend\r\nAction_Create = function(action_name, args)\r\n  args.name = action_name\r\n  args.mode = \"add\"\r\n  ScenEdit_SetAction(args)\r\n  return action_name\r\nend\r\nAction_Delete = function(action_name)\r\n  return ScenEdit_SetAction({\r\n    name = action_name,\r\n    mode = \"remove\"\r\n  })\r\nend\r\nEvent_Delete = function(evt_name, recurse)\r\n  recurse = recurse or true\r\n  if recurse then\r\n    local _list_0 = ScenEdit_GetEvents()\r\n    for _index_0 = 1, #_list_0 do\r\n      local event = _list_0[_index_0]\r\n      if event.details.description == evt_name then\r\n        local _list_1 = event.details.triggers\r\n        for _index_1 = 1, #_list_1 do\r\n          local e = _list_1[_index_1]\r\n          for key, val in pairs(e) do\r\n            if val.Description then\r\n              Event_RemoveTrigger(evt_name, val.Description)\r\n              Trigger_Delete(val.Description)\r\n            end\r\n          end\r\n        end\r\n        local _list_2 = event.details.conditions\r\n        for _index_1 = 1, #_list_2 do\r\n          local e = _list_2[_index_1]\r\n          for key, val in pairs(e) do\r\n            if val.Description then\r\n              Event_RemoveCondition(evt_name, val.Description)\r\n              Condition_Delete(val.Description)\r\n            end\r\n          end\r\n        end\r\n        local _list_3 = event.details.actions\r\n        for _index_1 = 1, #_list_3 do\r\n          local e = _list_3[_index_1]\r\n          for key, val in pairs(e) do\r\n            if val.Description then\r\n              Event_RemoveAction(evt_name, val.Description)\r\n              Action_Delete(val.Description)\r\n            end\r\n          end\r\n        end\r\n        break\r\n      end\r\n    end\r\n  end\r\n  return ScenEdit_SetEvent(evt_name, {\r\n    mode = \"remove\"\r\n  })\r\nend\r\nWaitFor = function(seconds, code)\r\n  local uuid\r\n  uuid = function()\r\n    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'\r\n    local swap\r\n    swap = function(c)\r\n      local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)\r\n      return string.format('%x', v)\r\n    end\r\n    return string.gsub(template, '[xy]', swap)\r\n  end\r\n  local run_epoch = (62135596800 + ScenEdit_CurrentTime() + seconds) * 10000000\r\n  local evt_name = Event_Create(uuid(), {\r\n    IsRepeatable = false,\r\n    IsShown = false\r\n  })\r\n  local trigger_name = Trigger_Create(uuid(), {\r\n    type = 'Time',\r\n    Time = run_epoch\r\n  })\r\n  Event_AddTrigger(evt_name, trigger_name)\r\n  local script = \"__waitevt__=function()\\r\\n\" .. code .. \"\\r\\nend\\r\\npcall(__waitevt__)\\r\\npcall(Event_Delete, \\\"\" .. evt_name .. \"\\\")\"\r\n  local action_name = Action_Create(uuid(), {\r\n    type = 'LuaScript',\r\n    ScriptText = script\r\n  })\r\n  Event_AddAction(evt_name, action_name)\r\n  return evt_name\r\nend\r\n\r\n\r\nPK_String_Exists = function(key_name)\r\n  return ScenEdit_GetKeyValue(key_name) ~= \"\"\r\nend\r\nPK_String_Eval = function(key_name)\r\n  return ScenEdit_GetKeyValue(key_name)\r\nend\r\nPK_String_Store = function(key_name, value)\r\n  return ScenEdit_SetKeyValue(key_name, tostring(value))\r\nend\r\nPK_Number_Exists = function(key_name)\r\n  return PK_String_Exists(key_name)\r\nend\r\nPK_Number_Eval = function(key_name)\r\n  local val = tonumber(PK_String_Eval(key_name))\r\n  if val == nil then\r\n    return 0\r\n  end\r\n  return val\r\nend\r\nPK_Number_Store = function(key_name, value)\r\n  local v = tonumber(value)\r\n  if v == nil then\r\n    v = 0\r\n  end\r\n  return PK_String_Store(key_name, v)\r\nend\r\nPK_Boolean_Exists = function(key_name)\r\n  return PK_String_Exists(key_name)\r\nend\r\nPK_Boolean_Eval = function(key_name)\r\n  local key_table = {\r\n    [\"T\"] = true,\r\n    [\"F\"] = false\r\n  }\r\n  local val = PK_String_Eval(key_name)\r\n  for k, v in pairs(key_table) do\r\n    if val == k then\r\n      return v\r\n    end\r\n  end\r\n  return false\r\nend\r\nPK_Boolean_Store = function(key_name, value)\r\n  if value then\r\n    return PK_String_Store(key_name, \"T\")\r\n  else\r\n    return PK_String_Store(key_name, \"F\")\r\n  end\r\nend\r\n\r\n\r\nOBSERVATION_DUMMY_SIDENAME = \"-----------\"\r\nPATTON_InitRandom = function()\r\n  math.randomseed(os.time())\r\n  for i = 1, 3 do\r\n    math.random()\r\n  end\r\nend\r\nPATTON_OnLoad = function()\r\n  PATTON_InitRandom()\r\n  return PATTON_InitAPIReplace()\r\nend\r\nPATTON_GiveOrders = function()\r\n  PATTON_TransferRPs()\r\n  PATTON_RemoveDummyUnit()\r\n  local player_side = PK_String_Eval(\"PATTON_PLAYER_SIDENAME\")\r\n  ScenEdit_SetSideOptions({\r\n    side = player_side,\r\n    switchto = true\r\n  })\r\n  ScenEdit_SpecialMessage(\"playerside\", \"Issue your orders as needed. When you're ready to execute them, hit PLAY to begin your turn.\")\r\n  local turn_length = PK_Number_Eval(\"PATTON_ORDER_INTERVAL\")\r\n  WaitFor(1, \"PATTON_ObserveOrders()\")\r\n  return WaitFor(turn_length, \"PATTON_GiveOrders()\")\r\nend\r\nPATTON_ObserveOrders = function()\r\n  PATTON_MirrorPlayerSide()\r\n  PATTON_AddDummyUnit()\r\n  PATTON_WipeRPs()\r\n  return ScenEdit_SetSideOptions({\r\n    side = OBSERVATION_DUMMY_SIDENAME,\r\n    switchto = true\r\n  })\r\nend\r\nPATTON_Setup = function()\r\n  PATTON_InitRandom()\r\n  local turn_length = 60 * math.floor(Input_Number(\"How many minutes between orders?\"))\r\n  PK_Number_Store(\"PATTON_ORDER_INTERVAL\", turn_length)\r\n  local player_side = ScenEdit_PlayerSide()\r\n  PK_String_Store(\"PATTON_PLAYER_SIDENAME\", player_side)\r\n  ScenEdit_AddSide({\r\n    name = OBSERVATION_DUMMY_SIDENAME\r\n  })\r\n  local evt_load = Event_Create(\"PATTON_Load\")\r\n  Event_AddAction(evt_load, Action_Create(\"PATTON_LoadFromString\", {\r\n    type = \"LuaScript\",\r\n    ScriptText = PATTON_LOADER\r\n  }))\r\n  local evt_update = Event_Create(\"PATTON_Tick\", {\r\n    IsRepeatable = true,\r\n    IsShown = false\r\n  })\r\n  Event_AddTrigger(evt_update, Trigger_Create(\"PATTON_Tick_Trigger\", {\r\n    type = \"RegularTime\",\r\n    interval = 0\r\n  }))\r\n  Event_AddAction(evt_update, Action_Create(\"PATTON_Tick_Action\", {\r\n    type = \"LuaScript\",\r\n    ScriptText = \"PATTON_MirrorContactPostures()\"\r\n  }))\r\n  PK_Boolean_Store(\"PATTON_RUNNING\", true)\r\n  return PATTON_GiveOrders()\r\nend\r\n\r\n\r\nPATTON_MirrorPlayerSide = function()\r\n  local player_side = PK_String_Eval(\"PATTON_PLAYER_SIDENAME\")\r\n  local dummy_side = OBSERVATION_DUMMY_SIDENAME\r\n  ScenEdit_SetSidePosture(player_side, dummy_side, \"F\")\r\n  ScenEdit_SetSidePosture(dummy_side, player_side, \"F\")\r\n  local _list_0 = VP_GetSides()\r\n  for _index_0 = 1, #_list_0 do\r\n    local side = _list_0[_index_0]\r\n    local side_name = side.name\r\n    if player_side ~= side_name then\r\n      local posture = ScenEdit_GetSidePosture(player_side, side_name)\r\n      ScenEdit_SetSidePosture(dummy_side, side_name, posture)\r\n    end\r\n  end\r\nend\r\nPATTON_MirrorContactPostures = function()\r\n  local mirrorside = PK_String_Eval(\"PATTON_PLAYER_SIDENAME\")\r\n  local dummy_side = OBSERVATION_DUMMY_SIDENAME\r\n  local mirrorside_guid = \"\"\r\n  local _list_0 = VP_GetSides()\r\n  for _index_0 = 1, #_list_0 do\r\n    local side = _list_0[_index_0]\r\n    if side.name == mirrorside then\r\n      mirrorside_guid = side.guid\r\n      break\r\n    end\r\n  end\r\n  for k, contact in ipairs(ScenEdit_GetContacts(dummy_side)) do\r\n    local unit = ScenEdit_GetUnit({\r\n      guid = contact.actualunitid\r\n    })\r\n    for j, ascon in ipairs(unit.ascontact) do\r\n      if ascon.side == mirrorside_guid then\r\n        local mcontact = ScenEdit_GetContact({\r\n          side = mirrorside,\r\n          guid = ascon.guid\r\n        })\r\n        if mcontact.posture ~= contact.posture then\r\n          contact.posture = mcontact.posture\r\n        end\r\n        break\r\n      end\r\n    end\r\n  end\r\nend\r\nPATTON_WipeRPs = function()\r\n  local dummy_side = OBSERVATION_DUMMY_SIDENAME\r\n  local area = { }\r\n  local _list_0 = VP_GetSides()\r\n  for _index_0 = 1, #_list_0 do\r\n    local side = _list_0[_index_0]\r\n    if side.name == dummy_side then\r\n      do\r\n        local _accum_0 = { }\r\n        local _len_0 = 1\r\n        for k, v in ipairs(side.rps) do\r\n          _accum_0[_len_0] = v.name\r\n          _len_0 = _len_0 + 1\r\n        end\r\n        area = _accum_0\r\n      end\r\n      if #area > 0 then\r\n        local rps = ScenEdit_GetReferencePoints({\r\n          side = dummy_side,\r\n          area = area\r\n        })\r\n        for k, v in ipairs(rps) do\r\n          ScenEdit_DeleteReferencePoint(v)\r\n        end\r\n      end\r\n      break\r\n    end\r\n  end\r\nend\r\nPATTON_TransferRPs = function()\r\n  local player_side = PK_String_Eval(\"PATTON_PLAYER_SIDENAME\")\r\n  local dummy_side = OBSERVATION_DUMMY_SIDENAME\r\n  local area = { }\r\n  local _list_0 = VP_GetSides()\r\n  for _index_0 = 1, #_list_0 do\r\n    local side = _list_0[_index_0]\r\n    if side.name == dummy_side then\r\n      do\r\n        local _accum_0 = { }\r\n        local _len_0 = 1\r\n        for k, v in ipairs(side.rps) do\r\n          _accum_0[_len_0] = v.name\r\n          _len_0 = _len_0 + 1\r\n        end\r\n        area = _accum_0\r\n      end\r\n      if #area > 0 then\r\n        local rps = ScenEdit_GetReferencePoints({\r\n          side = dummy_side,\r\n          area = area\r\n        })\r\n        for k, v in ipairs(rps) do\r\n          ScenEdit_AddReferencePoint({\r\n            side = player_side,\r\n            name = v.name,\r\n            lat = v.latitude,\r\n            lon = v.longitude,\r\n            highlighted = true\r\n          })\r\n          ScenEdit_DeleteReferencePoint(v)\r\n        end\r\n      end\r\n      break\r\n    end\r\n  end\r\nend\r\nPATTON_RemoveDummyUnit = function()\r\n  if PK_String_Exists(\"PATTON_DUMMY_GUID\") then\r\n    pcall(ScenEdit_DeleteUnit, {\r\n      side = OBSERVATION_DUMMY_SIDENAME,\r\n      guid = PK_String_Eval(\"PATTON_DUMMY_GUID\")\r\n    })\r\n    return PK_String_Store(\"PATTON_DUMMY_GUID\", \"\")\r\n  end\r\nend\r\nPATTON_AddDummyUnit = function()\r\n  if PK_String_Exists(\"PATTON_DUMMY_GUID\") then\r\n    PATTON_RemoveDummyUnit()\r\n  end\r\n  local dummy = ScenEdit_AddUnit({\r\n    side = OBSERVATION_DUMMY_SIDENAME,\r\n    name = \"\",\r\n    type = \"FACILITY\",\r\n    dbid = 174,\r\n    latitude = -89,\r\n    longitude = 0\r\n  })\r\n  return PK_String_Store(\"PATTON_DUMMY_GUID\", dummy.guid)\r\nend\r\n\r\n\r\nInput_OK = function(question)\r\n  return ScenEdit_MsgBox(question, 0)\r\nend\r\nInput_YesNo = function(question)\r\n  local answer_table = {\r\n    Yes = true,\r\n    No = false\r\n  }\r\n  while true do\r\n    local ans = ScenEdit_MsgBox(question, 4)\r\n    if ans ~= 'Cancel' then\r\n      return answer_table[ans]\r\n    end\r\n  end\r\n  return false\r\nend\r\nInput_Number = function(question)\r\n  while true do\r\n    local val = tonumber(ScenEdit_InputBox(question))\r\n    if val then\r\n      return val\r\n    end\r\n  end\r\nend\r\nInput_Number_Default = function(question, default)\r\n  local val = tonumber(ScenEdit_InputBox(question))\r\n  if val then\r\n    return val\r\n  end\r\n  return default\r\nend\r\nInput_String = function(question)\r\n  local val = ScenEdit_InputBox(question)\r\n  if val then\r\n    return tostring(val)\r\n  end\r\n  return \"\"\r\nend\r\n\r\n\r\n--[[\r\n----------------------------------------------\r\nPATTON\r\nxx_onload.lua\r\n----------------------------------------------\r\n\r\nAdded as a footer to PATTON_LOADER.\r\n\r\n----------------------------------------------\r\nDO NOT EDIT THIS SOURCE FILE!\r\n----------------------------------------------\r\n]]--\r\n\r\nPATTON_OnLoad()"

--[[
----------------------------------------------
PATTON
xx_finalinit.lua
----------------------------------------------

Added as a footer to the final compiled Lua file
to activate the IKE wizard.

----------------------------------------------
DO NOT EDIT THIS SOURCE FILE!
----------------------------------------------
]]--

PATTON_Setup()

