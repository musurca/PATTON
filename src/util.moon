export ^

List_Query = (list, query_func) ->
	for item in *list
		if query_func(item)
			return item
	nil

List_Select = (list, query_func) ->
	selection = {}
	for item in *list
		if query_func(item)
			selection[#selection+1] = item
	selection

List_Execute = (list, query_func, exec_func) ->
	for item in *list
		if query_func(item)
			exec_func(item)