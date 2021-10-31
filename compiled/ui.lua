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
