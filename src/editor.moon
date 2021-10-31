export ^

Side_Add = (side_name) ->
	pcall(ScenEdit_AddSide, {
		name:side_name
	})

Side_SwitchTo = (side_name) ->
	pcall(ScenEdit_SetSideOptions, {
		side:side_name,
		switchto:true
	})

Side_Remove = (side_name) ->
	pcall(ScenEdit_RemoveSide, {
		side:side_name
	})

Event_Exists = (evt_name) ->
    -- clear any existing events with that name
	if List_Query(
			ScenEdit_GetEvents(), 
			(e) -> e.details.description == evt_name
		)
		return true
	return false

Event_Create = (evt_name, args) ->
    -- clear any existing events with that name
	if Event_Exists(evt_name)
		pcall(ScenEdit_SetEvent, evt_name, {mode:"remove"})   

    -- add our event
    args.mode="add"
    pcall(ScenEdit_SetEvent, evt_name, args)
    evt_name

Event_AddTrigger = (evt, trig) ->
    pcall(ScenEdit_SetEventTrigger, evt, {mode:'add', name:trig})

Event_RemoveTrigger = (evt, trig) ->
    pcall(ScenEdit_SetEventTrigger, evt, {mode:'remove', name:trig})

Event_AddCondition = (evt, cond) ->
    pcall(ScenEdit_SetEventCondition, evt, {mode:'add', name:cond})

Event_RemoveCondition = (evt, cond) ->
    pcall(ScenEdit_SetEventCondition, evt, {mode:'remove', name:cond})

Event_AddAction = (evt, action) ->
    pcall(ScenEdit_SetEventAction, evt, {mode:'add', name:action})

Event_RemoveAction = (evt, action) ->
    pcall(ScenEdit_SetEventAction, evt, {mode:'remove', name:action})

Trigger_Create = (trig_name, args) ->
    args.name=trig_name
    args.mode="add"
    pcall(ScenEdit_SetTrigger, args)
    trig_name

Trigger_Delete = (trig_name) ->
    pcall(ScenEdit_SetTrigger, {name:trig_name, mode:"remove"})

Condition_Create = (cond_name, args) ->
    args.name=cond_name
    args.mode="add"
    pcall(ScenEdit_SetCondition, args)
    cond_name

Condition_Delete = (cond_name) ->
    pcall(ScenEdit_SetCondition, {
        name:cond_name, 
        mode:"remove"
    })

Action_Create = (action_name, args) ->
    args.name=action_name
    args.mode="add"
    pcall(ScenEdit_SetAction, args)
    action_name

Action_Delete = (action_name) ->
    pcall(ScenEdit_SetAction, {
        name:action_name, 
        mode:"remove"
    })

Event_Delete = (evt_name, recurse=true) ->
	event = List_Query(
		ScenEdit_GetEvents(),
		(e) -> e.details.description == evt_name
	)
	if not event
		return

	if recurse
		for e in *event.details.triggers
			for key, val in pairs(e)
				if val.Description
					Event_RemoveTrigger(evt_name, val.Description)
					Trigger_Delete(val.Description)
		
		for e in *event.details.conditions
			for key, val in pairs(e)
				if val.Description
					Event_RemoveCondition(evt_name, val.Description)
					Condition_Delete(val.Description)
		
		for e in *event.details.actions
			for key, val in pairs(e)
				if val.Description
					Event_RemoveAction(evt_name, val.Description)
					Action_Delete(val.Description)
	
	pcall(ScenEdit_SetEvent, evt_name, {mode:"remove"})

WaitFor = (seconds, code) ->
	-- generate unique UUID
	uuid = ->
		template = MODULE_PREFIX..'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
		swap = (c) ->
			v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
			string.format('%x', v)

		string.gsub(template, '[xy]', swap)

	-- convert ScenEdit time to .NET time
	run_epoch = (62135596800 + ScenEdit_CurrentTime() + seconds) * 10000000
	
	evt_uuid = uuid!
	while Event_Exists(evt_uuid)
		evt_uuid = uuid!

	evt_name = ""
	while not Event_Exists(evt_uuid)
		-- create the event that will trigger the code
		evt_name = Event_Create(evt_uuid, {
			IsRepeatable:false,
			IsShown:false
		})

		-- set the trigger time
		trigger_name = Trigger_Create(uuid!, {
			type:'Time',
			Time:run_epoch
		})
		Event_AddTrigger(evt_name, trigger_name)

		-- initialize the callback within a safety pcall()
		-- then destroy its own event
		script="__waitevt__=function()\r\n"..code.."\r\nend\r\npcall(__waitevt__)\r\npcall(Event_Delete, \""..evt_name.."\")"
		action_name = Action_Create(uuid!, {
			type:'LuaScript',
			ScriptText:script
		})
		Event_AddAction(evt_name, action_name)

	-- return the event name
	evt_name