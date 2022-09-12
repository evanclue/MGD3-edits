local function TableToString_Recursive(t, name, indent)
	local tableList = {}

	function table_r (t, name, indent, full)
		local id = not full and name or type(name)~="number" and tostring(name) or '['..name..']'
		local tag = indent..id..' = '
		local out = {}

		if type(t) == "table" then
			if tableList[t] ~= nil then
				table.insert(out, tag..'{} -- '..tableList[t]..' (self reference)')
			else
				tableList[t]= full and (full..'.'..id) or id
				if next(t) then
					table.insert(out, tag..'{')
					for key,value in pairs(t) do
						table.insert(out,table_r(value,key,indent..'|  ',tableList[t]))
					end
					table.insert(out,indent..'}')
				else
					table.insert(out,tag..'{}')
				end
			end
		else
			local val = type(t)~="number" and type(t)~="boolean" and '"'..tostring(t)..'"' or tostring(t)
			table.insert(out, tag..val)
		end
		return table.concat(out, '\n')
	end
	return table_r(t,name or 'Value',indent or '')
end

function SM( arg )
	if type( arg ) == "table" then
		local msg = TableToString_Recursive(arg)
		SCREENMAN:SystemMessage( msg )
		Trace( msg )
	else
		SCREENMAN:SystemMessage( tostring(arg) )
	end
end
