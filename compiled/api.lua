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
