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
