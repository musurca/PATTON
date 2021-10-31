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
