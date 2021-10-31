Event_Exists = function(evt_name)
  local _list_0 = ScenEdit_GetEvents()
  for _index_0 = 1, #_list_0 do
    local event = _list_0[_index_0]
    if event.details.description == evt_name then
      return true
    end
  end
  return false
end
Event_Create = function(evt_name, args)
  local _list_0 = ScenEdit_GetEvents()
  for _index_0 = 1, #_list_0 do
    local event = _list_0[_index_0]
    if event.details.description == evt_name then
      pcall(ScenEdit_SetEvent, evt_name, {
        mode = "remove"
      })
    end
  end
  args.mode = "add"
  pcall(ScenEdit_SetEvent, evt_name, args)
  return evt_name
end
Event_AddTrigger = function(evt, trig)
  return pcall(ScenEdit_SetEventTrigger, evt, {
    mode = 'add',
    name = trig
  })
end
Event_RemoveTrigger = function(evt, trig)
  return pcall(ScenEdit_SetEventTrigger, evt, {
    mode = 'remove',
    name = trig
  })
end
Event_AddCondition = function(evt, cond)
  return pcall(ScenEdit_SetEventCondition, evt, {
    mode = 'add',
    name = cond
  })
end
Event_RemoveCondition = function(evt, cond)
  return pcall(ScenEdit_SetEventCondition, evt, {
    mode = 'remove',
    name = cond
  })
end
Event_AddAction = function(evt, action)
  return pcall(ScenEdit_SetEventAction, evt, {
    mode = 'add',
    name = action
  })
end
Event_RemoveAction = function(evt, action)
  return pcall(ScenEdit_SetEventAction, evt, {
    mode = 'remove',
    name = action
  })
end
Trigger_Create = function(trig_name, args)
  args.name = trig_name
  args.mode = "add"
  pcall(ScenEdit_SetTrigger, args)
  return trig_name
end
Trigger_Delete = function(trig_name)
  return pcall(ScenEdit_SetTrigger, {
    name = trig_name,
    mode = "remove"
  })
end
Condition_Create = function(cond_name, args)
  args.name = cond_name
  args.mode = "add"
  pcall(ScenEdit_SetCondition, args)
  return cond_name
end
Condition_Delete = function(cond_name)
  return pcall(ScenEdit_SetCondition, {
    name = cond_name,
    mode = "remove"
  })
end
Action_Create = function(action_name, args)
  args.name = action_name
  args.mode = "add"
  pcall(ScenEdit_SetAction, args)
  return action_name
end
Action_Delete = function(action_name)
  return pcall(ScenEdit_SetAction, {
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
  return pcall(ScenEdit_SetEvent, evt_name, {
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
  local evt_uuid = uuid()
  while Event_Exists(evt_uuid) do
    evt_uuid = uuid()
  end
  local evt_name = ""
  while not Event_Exists(evt_uuid) do
    evt_name = Event_Create(evt_uuid, {
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
  end
  return evt_name
end
