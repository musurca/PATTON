--[[
----------------------------------------------
PATTON v1.0 by Nicholas Musurca (nick.musurca@gmail.com)
Licensed under GNU GPLv3. (https://www.gnu.org/licenses/gpl-3.0-standalone.html)

MAKE SURE YOU READ THE INCLUDED MANUAL BEFORE DOING ANYTHING WITH THIS CODE!
----------------------------------------------
]]--

PATTON_InitAPIReplace=function()PATTON_API_PlayerSide_Replace()return PATTON_API_SpecialMessage_Replace()end;PATTON_API_PlayerSide_Replace=function()if not __PATTON_FN_PLAYERSIDE__ then __PATTON_FN_PLAYERSIDE__=ScenEdit_PlayerSide end;ScenEdit_PlayerSide=PATTON_API_PlayerSide end;PATTON_API_PlayerSide_Restore=function()if __PATTON_FN_PLAYERSIDE__ then ScenEdit_PlayerSide=__PATTON_FN_PLAYERSIDE__ end end;PATTON_API_PlayerSide=function()if not PK_Boolean_Exists("PATTON_RUNNING")then PATTON_API_PlayerSide_Restore()return ScenEdit_PlayerSide()end;return PK_String_Eval("PATTON_PLAYER_SIDENAME")end;PATTON_API_SpecialMessage_Replace=function()if not __PATTON_FN_SPECIALMESSAGE__ then __PATTON_FN_SPECIALMESSAGE__=ScenEdit_SpecialMessage end;local ScenEdit_SpecialMessage=PATTON_API_SpecialMessage end;PATTON_API_SpecialMessage_Restore=function()if __PATTON_FN_SPECIALMESSAGE__ then ScenEdit_SpecialMessage=__PATTON_FN_SPECIALMESSAGE__ end end;PATTON_API_SpecialMessage=function(a,b,c)if not PK_Boolean_Exists("PATTON_RUNNING")then PATTON_API_SpecialMessage_Restore()if c then ScenEdit_SpecialMessage(a,b,c)else ScenEdit_SpecialMessage(a,b)end end;local d=PK_String_Eval("PATTON_PLAYER_SIDENAME")local e=OBSERVATION_DUMMY_SIDENAME;if a==d and __PATTON_FN_PLAYERSIDE__()==e then a=e end;if c then return __PATTON_FN_SPECIALMESSAGE__(a,b,c)else return __PATTON_FN_SPECIALMESSAGE__(a,b)end end;Event_Exists=function(f)local g=ScenEdit_GetEvents()for h=1,#g do local i=g[h]if i.details.description==f then return true end end;return false end;Event_Create=function(f,j)local g=ScenEdit_GetEvents()for h=1,#g do local i=g[h]if i.details.description==f then pcall(ScenEdit_SetEvent,f,{mode="remove"})end end;j.mode="add"pcall(ScenEdit_SetEvent,f,j)return f end;Event_AddTrigger=function(k,l)return pcall(ScenEdit_SetEventTrigger,k,{mode='add',name=l})end;Event_RemoveTrigger=function(k,l)return pcall(ScenEdit_SetEventTrigger,k,{mode='remove',name=l})end;Event_AddCondition=function(k,m)return pcall(ScenEdit_SetEventCondition,k,{mode='add',name=m})end;Event_RemoveCondition=function(k,m)return pcall(ScenEdit_SetEventCondition,k,{mode='remove',name=m})end;Event_AddAction=function(k,n)return pcall(ScenEdit_SetEventAction,k,{mode='add',name=n})end;Event_RemoveAction=function(k,n)return pcall(ScenEdit_SetEventAction,k,{mode='remove',name=n})end;Trigger_Create=function(o,j)j.name=o;j.mode="add"pcall(ScenEdit_SetTrigger,j)return o end;Trigger_Delete=function(o)return pcall(ScenEdit_SetTrigger,{name=o,mode="remove"})end;Condition_Create=function(p,j)j.name=p;j.mode="add"pcall(ScenEdit_SetCondition,j)return p end;Condition_Delete=function(p)return pcall(ScenEdit_SetCondition,{name=p,mode="remove"})end;Action_Create=function(q,j)j.name=q;j.mode="add"pcall(ScenEdit_SetAction,j)return q end;Action_Delete=function(q)return pcall(ScenEdit_SetAction,{name=q,mode="remove"})end;Event_Delete=function(f,r)r=r or true;if r then local g=ScenEdit_GetEvents()for h=1,#g do local i=g[h]if i.details.description==f then local s=i.details.triggers;for t=1,#s do local u=s[t]for v,w in pairs(u)do if w.Description then Event_RemoveTrigger(f,w.Description)Trigger_Delete(w.Description)end end end;local x=i.details.conditions;for t=1,#x do local u=x[t]for v,w in pairs(u)do if w.Description then Event_RemoveCondition(f,w.Description)Condition_Delete(w.Description)end end end;local y=i.details.actions;for t=1,#y do local u=y[t]for v,w in pairs(u)do if w.Description then Event_RemoveAction(f,w.Description)Action_Delete(w.Description)end end end;break end end end;return pcall(ScenEdit_SetEvent,f,{mode="remove"})end;WaitFor=function(z,A)local B;B=function()local C='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'local D;D=function(E)local F=E=='x'and math.random(0,0xf)or math.random(8,0xb)return string.format('%x',F)end;return string.gsub(C,'[xy]',D)end;local G=(62135596800+ScenEdit_CurrentTime()+z)*10000000;local H=B()while Event_Exists(H)do H=B()end;local f=""while not Event_Exists(H)do f=Event_Create(H,{IsRepeatable=false,IsShown=false})local I=Trigger_Create(B(),{type='Time',Time=G})Event_AddTrigger(f,I)local J="__waitevt__=function()\r\n"..A.."\r\nend\r\npcall(__waitevt__)\r\npcall(Event_Delete, \""..f.."\")"local q=Action_Create(B(),{type='LuaScript',ScriptText=J})Event_AddAction(f,q)end;return f end;PK_String_Exists=function(K)return ScenEdit_GetKeyValue(K)~=""end;PK_String_Eval=function(K)return ScenEdit_GetKeyValue(K)end;PK_String_Store=function(K,L)return ScenEdit_SetKeyValue(K,tostring(L))end;PK_Number_Exists=function(K)return PK_String_Exists(K)end;PK_Number_Eval=function(K)local w=tonumber(PK_String_Eval(K))if w==nil then return 0 end;return w end;PK_Number_Store=function(K,L)local F=tonumber(L)if F==nil then F=0 end;return PK_String_Store(K,F)end;PK_Boolean_Exists=function(K)return PK_String_Exists(K)end;PK_Boolean_Eval=function(K)local M={["T"]=true,["F"]=false}local w=PK_String_Eval(K)for N,F in pairs(M)do if w==N then return F end end;return false end;PK_Boolean_Store=function(K,L)if L then return PK_String_Store(K,"T")else return PK_String_Store(K,"F")end end;VERSION="1.0"OBSERVATION_DUMMY_SIDENAME="-----------"PATTON_WIZARD_MESSAGE="Welcome to PATTON v"..VERSION.."!\n\nHow many minutes between orders?"PATTON_TURN_MESSAGE="<br/><hr><br/><center><b>ORDER PHASE</b></center><br/><hr><br/>Give orders to your units as needed. When you're ready, <b>start the clock</b> to execute them."PATTON_InitRandom=function()math.randomseed(os.time())for O=1,3 do math.random()end end;PATTON_OnLoad=function()PATTON_InitRandom()return PATTON_InitAPIReplace()end;PATTON_GiveOrders=function()PATTON_TransferRPs()PATTON_RemoveDummyUnit()local d=PK_String_Eval("PATTON_PLAYER_SIDENAME")ScenEdit_SetSideOptions({side=d,switchto=true})WaitFor(1,"PATTON_ObserveOrders()")return ScenEdit_SpecialMessage("playerside",PATTON_TURN_MESSAGE)end;PATTON_ObserveOrders=function()PATTON_MirrorPlayerSide()PATTON_AddDummyUnit()PATTON_WipeRPs()ScenEdit_SetSideOptions({side=OBSERVATION_DUMMY_SIDENAME,switchto=true})local P=PK_Number_Eval("PATTON_ORDER_INTERVAL")return WaitFor(P-1,"PATTON_GiveOrders()")end;PATTON_Setup=function()local P=60*math.floor(Input_Number(PATTON_WIZARD_MESSAGE))PK_Number_Store("PATTON_ORDER_INTERVAL",P)local d=ScenEdit_PlayerSide()PK_String_Store("PATTON_PLAYER_SIDENAME",d)ScenEdit_AddSide({name=OBSERVATION_DUMMY_SIDENAME})local Q=Event_Create("PATTON_Load",{IsRepeatable=true,IsShown=false})Event_AddTrigger(Q,Trigger_Create("PATTON_OnLoad",{type="ScenLoaded"}))Event_AddAction(Q,Action_Create("PATTON_LoadFromString",{type="LuaScript",ScriptText=PATTON_LOADER}))local R=Event_Create("PATTON_Tick",{IsRepeatable=true,IsShown=false})Event_AddTrigger(R,Trigger_Create("PATTON_Tick_Trigger",{type="RegularTime",interval=0}))Event_AddAction(R,Action_Create("PATTON_Tick_Action",{type="LuaScript",ScriptText="PATTON_MirrorContactPostures()"}))PK_Boolean_Store("PATTON_RUNNING",true)PATTON_OnLoad()return PATTON_GiveOrders()end;PATTON_MirrorPlayerSide=function()local d=PK_String_Eval("PATTON_PLAYER_SIDENAME")local e=OBSERVATION_DUMMY_SIDENAME;ScenEdit_SetSidePosture(d,e,"F")ScenEdit_SetSidePosture(e,d,"F")local g=VP_GetSides()for h=1,#g do local a=g[h]local S=a.name;if d~=S then local T=ScenEdit_GetSidePosture(d,S)ScenEdit_SetSidePosture(e,S,T)end end end;PATTON_MirrorContactPostures=function()local U=PK_String_Eval("PATTON_PLAYER_SIDENAME")local e=OBSERVATION_DUMMY_SIDENAME;local V=""local g=VP_GetSides()for h=1,#g do local a=g[h]if a.name==U then V=a.guid;break end end;for N,W in ipairs(ScenEdit_GetContacts(e))do local X=ScenEdit_GetUnit({guid=W.actualunitid})for Y,Z in ipairs(X.ascontact)do if Z.side==V then local _=ScenEdit_GetContact({side=U,guid=Z.guid})if _.posture~=W.posture then W.posture=_.posture end;break end end end end;PATTON_WipeRPs=function()local e=OBSERVATION_DUMMY_SIDENAME;local a0={}local g=VP_GetSides()for h=1,#g do local a=g[h]if a.name==e then do local a1={}local a2=1;for N,F in ipairs(a.rps)do a1[a2]=F.name;a2=a2+1 end;a0=a1 end;if#a0>0 then local a3=ScenEdit_GetReferencePoints({side=e,area=a0})for N,F in ipairs(a3)do ScenEdit_DeleteReferencePoint(F)end end;break end end end;PATTON_TransferRPs=function()local d=PK_String_Eval("PATTON_PLAYER_SIDENAME")local e=OBSERVATION_DUMMY_SIDENAME;local a0={}local g=VP_GetSides()for h=1,#g do local a=g[h]if a.name==e then do local a1={}local a2=1;for N,F in ipairs(a.rps)do a1[a2]=F.name;a2=a2+1 end;a0=a1 end;if#a0>0 then local a3=ScenEdit_GetReferencePoints({side=e,area=a0})for N,F in ipairs(a3)do ScenEdit_AddReferencePoint({side=d,name=F.name,lat=F.latitude,lon=F.longitude,highlighted=true})ScenEdit_DeleteReferencePoint(F)end end;break end end end;PATTON_RemoveDummyUnit=function()if PK_String_Exists("PATTON_DUMMY_GUID")then pcall(ScenEdit_DeleteUnit,{side=OBSERVATION_DUMMY_SIDENAME,guid=PK_String_Eval("PATTON_DUMMY_GUID")})return PK_String_Store("PATTON_DUMMY_GUID","")end end;PATTON_AddDummyUnit=function()if PK_String_Exists("PATTON_DUMMY_GUID")then PATTON_RemoveDummyUnit()end;local a4=ScenEdit_AddUnit({side=OBSERVATION_DUMMY_SIDENAME,name="",type="FACILITY",dbid=174,latitude=-89,longitude=0})return PK_String_Store("PATTON_DUMMY_GUID",a4.guid)end;Input_OK=function(a5)return ScenEdit_MsgBox(a5,0)end;Input_YesNo=function(a5)local a6={Yes=true,No=false}while true do local a7=ScenEdit_MsgBox(a5,4)if a7~='Cancel'then return a6[a7]end end;return false end;Input_Number=function(a5)while true do local w=tonumber(ScenEdit_InputBox(a5))if w then return w end end end;Input_Number_Default=function(a5,a8)local w=tonumber(ScenEdit_InputBox(a5))if w then return w end;return a8 end;Input_String=function(a5)local w=ScenEdit_InputBox(a5)if w then return tostring(w)end;return""end;PATTON_LOADER="PATTON_InitAPIReplace=function()PATTON_API_PlayerSide_Replace()return PATTON_API_SpecialMessage_Replace()end;PATTON_API_PlayerSide_Replace=function()if not __PATTON_FN_PLAYERSIDE__ then __PATTON_FN_PLAYERSIDE__=ScenEdit_PlayerSide end;ScenEdit_PlayerSide=PATTON_API_PlayerSide end;PATTON_API_PlayerSide_Restore=function()if __PATTON_FN_PLAYERSIDE__ then ScenEdit_PlayerSide=__PATTON_FN_PLAYERSIDE__ end end;PATTON_API_PlayerSide=function()if not PK_Boolean_Exists(\"PATTON_RUNNING\")then PATTON_API_PlayerSide_Restore()return ScenEdit_PlayerSide()end;return PK_String_Eval(\"PATTON_PLAYER_SIDENAME\")end;PATTON_API_SpecialMessage_Replace=function()if not __PATTON_FN_SPECIALMESSAGE__ then __PATTON_FN_SPECIALMESSAGE__=ScenEdit_SpecialMessage end;local ScenEdit_SpecialMessage=PATTON_API_SpecialMessage end;PATTON_API_SpecialMessage_Restore=function()if __PATTON_FN_SPECIALMESSAGE__ then ScenEdit_SpecialMessage=__PATTON_FN_SPECIALMESSAGE__ end end;PATTON_API_SpecialMessage=function(a,b,c)if not PK_Boolean_Exists(\"PATTON_RUNNING\")then PATTON_API_SpecialMessage_Restore()if c then ScenEdit_SpecialMessage(a,b,c)else ScenEdit_SpecialMessage(a,b)end end;local d=PK_String_Eval(\"PATTON_PLAYER_SIDENAME\")local e=OBSERVATION_DUMMY_SIDENAME;if a==d and __PATTON_FN_PLAYERSIDE__()==e then a=e end;if c then return __PATTON_FN_SPECIALMESSAGE__(a,b,c)else return __PATTON_FN_SPECIALMESSAGE__(a,b)end end;Event_Exists=function(f)local g=ScenEdit_GetEvents()for h=1,#g do local i=g[h]if i.details.description==f then return true end end;return false end;Event_Create=function(f,j)local g=ScenEdit_GetEvents()for h=1,#g do local i=g[h]if i.details.description==f then pcall(ScenEdit_SetEvent,f,{mode=\"remove\"})end end;j.mode=\"add\"pcall(ScenEdit_SetEvent,f,j)return f end;Event_AddTrigger=function(k,l)return pcall(ScenEdit_SetEventTrigger,k,{mode='add',name=l})end;Event_RemoveTrigger=function(k,l)return pcall(ScenEdit_SetEventTrigger,k,{mode='remove',name=l})end;Event_AddCondition=function(k,m)return pcall(ScenEdit_SetEventCondition,k,{mode='add',name=m})end;Event_RemoveCondition=function(k,m)return pcall(ScenEdit_SetEventCondition,k,{mode='remove',name=m})end;Event_AddAction=function(k,n)return pcall(ScenEdit_SetEventAction,k,{mode='add',name=n})end;Event_RemoveAction=function(k,n)return pcall(ScenEdit_SetEventAction,k,{mode='remove',name=n})end;Trigger_Create=function(o,j)j.name=o;j.mode=\"add\"pcall(ScenEdit_SetTrigger,j)return o end;Trigger_Delete=function(o)return pcall(ScenEdit_SetTrigger,{name=o,mode=\"remove\"})end;Condition_Create=function(p,j)j.name=p;j.mode=\"add\"pcall(ScenEdit_SetCondition,j)return p end;Condition_Delete=function(p)return pcall(ScenEdit_SetCondition,{name=p,mode=\"remove\"})end;Action_Create=function(q,j)j.name=q;j.mode=\"add\"pcall(ScenEdit_SetAction,j)return q end;Action_Delete=function(q)return pcall(ScenEdit_SetAction,{name=q,mode=\"remove\"})end;Event_Delete=function(f,r)r=r or true;if r then local g=ScenEdit_GetEvents()for h=1,#g do local i=g[h]if i.details.description==f then local s=i.details.triggers;for t=1,#s do local u=s[t]for v,w in pairs(u)do if w.Description then Event_RemoveTrigger(f,w.Description)Trigger_Delete(w.Description)end end end;local x=i.details.conditions;for t=1,#x do local u=x[t]for v,w in pairs(u)do if w.Description then Event_RemoveCondition(f,w.Description)Condition_Delete(w.Description)end end end;local y=i.details.actions;for t=1,#y do local u=y[t]for v,w in pairs(u)do if w.Description then Event_RemoveAction(f,w.Description)Action_Delete(w.Description)end end end;break end end end;return pcall(ScenEdit_SetEvent,f,{mode=\"remove\"})end;WaitFor=function(z,A)local B;B=function()local C='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'local D;D=function(E)local F=E=='x'and math.random(0,0xf)or math.random(8,0xb)return string.format('%x',F)end;return string.gsub(C,'[xy]',D)end;local G=(62135596800+ScenEdit_CurrentTime()+z)*10000000;local H=B()while Event_Exists(H)do H=B()end;local f=\"\"while not Event_Exists(H)do f=Event_Create(H,{IsRepeatable=false,IsShown=false})local I=Trigger_Create(B(),{type='Time',Time=G})Event_AddTrigger(f,I)local J=\"__waitevt__=function()\\r\\n\"..A..\"\\r\\nend\\r\\npcall(__waitevt__)\\r\\npcall(Event_Delete, \\\"\"..f..\"\\\")\"local q=Action_Create(B(),{type='LuaScript',ScriptText=J})Event_AddAction(f,q)end;return f end;PK_String_Exists=function(K)return ScenEdit_GetKeyValue(K)~=\"\"end;PK_String_Eval=function(K)return ScenEdit_GetKeyValue(K)end;PK_String_Store=function(K,L)return ScenEdit_SetKeyValue(K,tostring(L))end;PK_Number_Exists=function(K)return PK_String_Exists(K)end;PK_Number_Eval=function(K)local w=tonumber(PK_String_Eval(K))if w==nil then return 0 end;return w end;PK_Number_Store=function(K,L)local F=tonumber(L)if F==nil then F=0 end;return PK_String_Store(K,F)end;PK_Boolean_Exists=function(K)return PK_String_Exists(K)end;PK_Boolean_Eval=function(K)local M={[\"T\"]=true,[\"F\"]=false}local w=PK_String_Eval(K)for N,F in pairs(M)do if w==N then return F end end;return false end;PK_Boolean_Store=function(K,L)if L then return PK_String_Store(K,\"T\")else return PK_String_Store(K,\"F\")end end;VERSION=\"1.0\"OBSERVATION_DUMMY_SIDENAME=\"-----------\"PATTON_WIZARD_MESSAGE=\"Welcome to PATTON v\"..VERSION..\"!\\n\\nHow many minutes between orders?\"PATTON_TURN_MESSAGE=\"<br/><hr><br/><center><b>ORDER PHASE</b></center><br/><hr><br/>Give orders to your units as needed. When you're ready, <b>start the clock</b> to execute them.\"PATTON_InitRandom=function()math.randomseed(os.time())for O=1,3 do math.random()end end;PATTON_OnLoad=function()PATTON_InitRandom()return PATTON_InitAPIReplace()end;PATTON_GiveOrders=function()PATTON_TransferRPs()PATTON_RemoveDummyUnit()local d=PK_String_Eval(\"PATTON_PLAYER_SIDENAME\")ScenEdit_SetSideOptions({side=d,switchto=true})WaitFor(1,\"PATTON_ObserveOrders()\")return ScenEdit_SpecialMessage(\"playerside\",PATTON_TURN_MESSAGE)end;PATTON_ObserveOrders=function()PATTON_MirrorPlayerSide()PATTON_AddDummyUnit()PATTON_WipeRPs()ScenEdit_SetSideOptions({side=OBSERVATION_DUMMY_SIDENAME,switchto=true})local P=PK_Number_Eval(\"PATTON_ORDER_INTERVAL\")return WaitFor(P-1,\"PATTON_GiveOrders()\")end;PATTON_Setup=function()local P=60*math.floor(Input_Number(PATTON_WIZARD_MESSAGE))PK_Number_Store(\"PATTON_ORDER_INTERVAL\",P)local d=ScenEdit_PlayerSide()PK_String_Store(\"PATTON_PLAYER_SIDENAME\",d)ScenEdit_AddSide({name=OBSERVATION_DUMMY_SIDENAME})local Q=Event_Create(\"PATTON_Load\",{IsRepeatable=true,IsShown=false})Event_AddTrigger(Q,Trigger_Create(\"PATTON_OnLoad\",{type=\"ScenLoaded\"}))Event_AddAction(Q,Action_Create(\"PATTON_LoadFromString\",{type=\"LuaScript\",ScriptText=PATTON_LOADER}))local R=Event_Create(\"PATTON_Tick\",{IsRepeatable=true,IsShown=false})Event_AddTrigger(R,Trigger_Create(\"PATTON_Tick_Trigger\",{type=\"RegularTime\",interval=0}))Event_AddAction(R,Action_Create(\"PATTON_Tick_Action\",{type=\"LuaScript\",ScriptText=\"PATTON_MirrorContactPostures()\"}))PK_Boolean_Store(\"PATTON_RUNNING\",true)PATTON_OnLoad()return PATTON_GiveOrders()end;PATTON_MirrorPlayerSide=function()local d=PK_String_Eval(\"PATTON_PLAYER_SIDENAME\")local e=OBSERVATION_DUMMY_SIDENAME;ScenEdit_SetSidePosture(d,e,\"F\")ScenEdit_SetSidePosture(e,d,\"F\")local g=VP_GetSides()for h=1,#g do local a=g[h]local S=a.name;if d~=S then local T=ScenEdit_GetSidePosture(d,S)ScenEdit_SetSidePosture(e,S,T)end end end;PATTON_MirrorContactPostures=function()local U=PK_String_Eval(\"PATTON_PLAYER_SIDENAME\")local e=OBSERVATION_DUMMY_SIDENAME;local V=\"\"local g=VP_GetSides()for h=1,#g do local a=g[h]if a.name==U then V=a.guid;break end end;for N,W in ipairs(ScenEdit_GetContacts(e))do local X=ScenEdit_GetUnit({guid=W.actualunitid})for Y,Z in ipairs(X.ascontact)do if Z.side==V then local _=ScenEdit_GetContact({side=U,guid=Z.guid})if _.posture~=W.posture then W.posture=_.posture end;break end end end end;PATTON_WipeRPs=function()local e=OBSERVATION_DUMMY_SIDENAME;local a0={}local g=VP_GetSides()for h=1,#g do local a=g[h]if a.name==e then do local a1={}local a2=1;for N,F in ipairs(a.rps)do a1[a2]=F.name;a2=a2+1 end;a0=a1 end;if#a0>0 then local a3=ScenEdit_GetReferencePoints({side=e,area=a0})for N,F in ipairs(a3)do ScenEdit_DeleteReferencePoint(F)end end;break end end end;PATTON_TransferRPs=function()local d=PK_String_Eval(\"PATTON_PLAYER_SIDENAME\")local e=OBSERVATION_DUMMY_SIDENAME;local a0={}local g=VP_GetSides()for h=1,#g do local a=g[h]if a.name==e then do local a1={}local a2=1;for N,F in ipairs(a.rps)do a1[a2]=F.name;a2=a2+1 end;a0=a1 end;if#a0>0 then local a3=ScenEdit_GetReferencePoints({side=e,area=a0})for N,F in ipairs(a3)do ScenEdit_AddReferencePoint({side=d,name=F.name,lat=F.latitude,lon=F.longitude,highlighted=true})ScenEdit_DeleteReferencePoint(F)end end;break end end end;PATTON_RemoveDummyUnit=function()if PK_String_Exists(\"PATTON_DUMMY_GUID\")then pcall(ScenEdit_DeleteUnit,{side=OBSERVATION_DUMMY_SIDENAME,guid=PK_String_Eval(\"PATTON_DUMMY_GUID\")})return PK_String_Store(\"PATTON_DUMMY_GUID\",\"\")end end;PATTON_AddDummyUnit=function()if PK_String_Exists(\"PATTON_DUMMY_GUID\")then PATTON_RemoveDummyUnit()end;local a4=ScenEdit_AddUnit({side=OBSERVATION_DUMMY_SIDENAME,name=\"\",type=\"FACILITY\",dbid=174,latitude=-89,longitude=0})return PK_String_Store(\"PATTON_DUMMY_GUID\",a4.guid)end;Input_OK=function(a5)return ScenEdit_MsgBox(a5,0)end;Input_YesNo=function(a5)local a6={Yes=true,No=false}while true do local a7=ScenEdit_MsgBox(a5,4)if a7~='Cancel'then return a6[a7]end end;return false end;Input_Number=function(a5)while true do local w=tonumber(ScenEdit_InputBox(a5))if w then return w end end end;Input_Number_Default=function(a5,a8)local w=tonumber(ScenEdit_InputBox(a5))if w then return w end;return a8 end;Input_String=function(a5)local w=ScenEdit_InputBox(a5)if w then return tostring(w)end;return\"\"end;PATTON_OnLoad()"PATTON_Setup()
