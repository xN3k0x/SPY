-- Written By WW.#3179 (Discord) | xN3k0x (GitHub)
return function (settings)
    local FileName = os.date("GETFENV-LOG %Y.%m.%d.%H.%M.%S.txt")
    writefile(FileName, "")

    rconsoleclear()
    rconsoleprint("@@LIGHT_BLUE@@")
    rconsoleprint('GETFENV() SPY BY WW.#3179 (Discord) | xN3k0x (GitHub) \n')
    rconsoleprint('FILE WILL SAVE AS NAME "'..FileName..'"\n')
    rconsoleprint('=============================================================\n')
    rconsoleprint("@@WHITE@@")

    local function table2string(t, indent) --Credit: CHATGPT (i just copy & paste so don't care abt it)
        indent = indent or 0
        local strTable = {"{"}
        for k, v in pairs(t) do
            local key = type(k) == "number" and ("["..k.."]") or ('["'..k..'"]')
            local value = type(v) == "table" and table2string(v, indent+1) or (type(v) == "string" and '"'..v..'"' or tostring(v))
            table.insert(strTable, string.format("%s%s = %s%s", string.rep("", indent), key, value, next(t, k) ~= nil and ", " or ""))
        end
        table.insert(strTable, "}")
        return table.concat(strTable)
    end
        
    local function on_call(args,func,f1,f2)
        if not table.find(settings.Blacklist_Function, func) then
            local args_text = (function()
                local t = {}
                for i,arg in pairs(args) do
                    if type(arg) == "string" then
                        table.insert(t, '"'..arg..'"')
                    elseif type(arg) == "table" then
                        table.insert(t, table2string(arg))
                    else
                        table.insert(t, tostring(arg))
                    end
                end
                return table.concat(t,", ")
            end)()
            local func_text = (function()
                local t = {"getfenv()"}
                if f1 then
                    table.insert(t, '["'..f1..'"]')
                end
                if f2 then
                    table.insert(t, '["'..f2..'"]')
                end
                return table.concat(t)
            end)()
            if settings.DisablePrint ~= true then
                if settings.Highlighting == true then
                    rconsoleprint("@@LIGHT_BLUE@@")
                    rconsoleprint(func_text.."(")
                    rconsoleprint("@@LIGHT_CYAN@@")
                    rconsoleprint(args_text)
                    rconsoleprint("@@LIGHT_BLUE@@")
                    rconsoleprint(")\n")
                else
                    rconsoleprint(table.concat({func_text,"(",args_text,")\n"}))
                end
            end
            appendfile(FileName, table.concat({func_text,"(",args_text,")\n"}))
        end
    end
    
    local oldfenv = getfenv()
    local h 
    h = hookfunc(getfenv, function()
        return setmetatable({}, {
            __index = function(self,i1)
                if type(oldfenv[i1]) == "function" then
                    local f1 = function(...)
                        on_call({...},oldfenv[i1],i1)
                        return oldfenv[i1](...)
                    end
                    return f1
                else
                    return setmetatable({}, {
                        __index = function(self,i2)
                             local f2 = function(...)
                                on_call({...},oldfenv[i1][i2],i1,i2)
                                return oldfenv[i1][i2](...)
                            end
                            return f2
                        end
                    })
                end
            end
        })
    end)
end
