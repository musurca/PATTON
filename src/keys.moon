export ^

PK_String_Exists = (key_name) ->
	ScenEdit_GetKeyValue(key_name) != ""

PK_String_Eval = (key_name) ->
	ScenEdit_GetKeyValue(key_name)

PK_String_Store = (key_name, value) ->
	ScenEdit_SetKeyValue(key_name, tostring(value))

PK_Number_Exists = (key_name) ->
	PK_String_Exists(key_name)

PK_Number_Eval = (key_name) ->
	val = tonumber(PK_String_Eval(key_name))
	return 0 if val == nil
	val

PK_Number_Store = (key_name, value) ->
	v = tonumber(value)
	v = 0 if v == nil
	PK_String_Store(key_name, v)

PK_Boolean_Exists = (key_name) ->
	PK_String_Exists(key_name)

PK_Boolean_Eval = (key_name) ->
	key_table = {
		["T"]: true,
		["F"]: false
	}
	val = PK_String_Eval(key_name)
	for k, v in pairs(key_table)
		if val == k
			return v
	false

PK_Boolean_Store = (key_name, value) ->
	if value
		PK_String_Store(key_name, "T")
	else
		PK_String_Store(key_name, "F")