export ^

--Presents the user with a simple message box that requires
--no input.
Input_OK = (question) -> ScenEdit_MsgBox(question, 0)

--Presents the user with an input box that expects a Yes
--or No answer. Returns true if Yes, false if No.		
--The box persists until the user answers the question 
--(in other words, clicking the 'X' to close the window 
--will simply bring the window back up).
Input_YesNo = (question) ->
	answer_table = {
		Yes:true,
		No:false
	}
	while true
		ans = ScenEdit_MsgBox(question, 4)
		if ans != 'Cancel'
			return answer_table[ans]
	return false

--Presents the user with an input box that expects a 
--numeric input. The box persists until the user provides a 
--valid number.
Input_Number = (question) ->
	while true
		val = tonumber(ScenEdit_InputBox(question))
		if val then
			return val

--Presents the user with an input box that expects a numeric
--input. If the user enters nothing, the default value is 
--used.
Input_Number_Default = (question, default) ->
	val = tonumber(ScenEdit_InputBox(question))
	if val
		return val
	default

--Presents the user with an input box that expects a string.
Input_String = (question) ->
	val = ScenEdit_InputBox(question)
	if val
		return tostring(val)
	""

