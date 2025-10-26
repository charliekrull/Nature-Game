--[[
    Some Helper functions
]]

function table.slice(tbl, first, last, step)
    local sliced = {}
    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced + 1] = tbl[i]
    end

    return sliced
end

function table.randomChoice(tbl) --returns single random element in tbl
    local choice = tbl[math.random(#tbl)]
    return choice
        
    
end

function table.randomKey(tbl) -- depends on table.randomChoice(tbl) above
  local choices = {}
  
  for key, __ in pairs(tbl) do
    table.insert(choices, key)  
  end
  
  return table.randomChoice(choices)
  
end


--check if a table contains a certain element

function table.contains(tbl, element)
    for k, content in pairs(tbl) do
        if content == element then
            return true
        end
    end

    return false
end

function table.containsKey(tbl, key)
  for k, v in pairs(tbl) do
    if k == key then
      return true
      
    end
    
  end
  
  return false
end

--gets individual images from a spritesheet/tilesheet
function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] = love.graphics.newQuad(x * tilewidth, y * tileheight,
            tilewidth, tileheight, atlas:getDimensions())

            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end  

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

function map(value, inputStart, inputEnd, outputStart, outputEnd)
    return outputStart + ((outputEnd-outputStart)/(inputEnd-inputStart)) * (value - inputStart)   

end


function clamp(value, min, max)
  return math.max(min, math.min(max, value))
end

function tablesMatch(a, b) --[[returns true if all the same keys leading to all the same values are found in both tables with none left over, ie the tables match EXACTLY. If a value is a table then recurse]]
  
  
  for ka, va in pairs(a) do
    if type(va) == 'table' then
      
      if type(b[ka]) == 'table' then
        
        if not tablesMatch(va, b[ka]) then
          return false
          
        end
         
      else
        
        return false
      
      
      end
      
    elseif  va ~= b[ka] then
      
      return false
      
    end
  
  end
  
  for kb, vb in pairs(b) do --if we got here, every key and value of 'a' is the same as in 'b', but we have to check if 'b' has anything that 'a' doesn't have at all
    if not table.containsKey(a, kb) then
      
      return false
      
    end
    
  end
  
  return true
  
end


function shuffle(t) --randomizes the order of a table
    local n = #t
    while n > 1 do
        local k = math.random(n) -- Generate a random index from 1 to n
        -- Swap elements t[n] and t[k]
        t[n], t[k] = t[k], t[n]
        n = n - 1
    end
    return t
end



--function mergeTables(a, b, keepDuplicates) --merge two tables, overwriting duplicates
  
--  local temp = {}
--  if keepDuplicates then
    
    
    
    
    
    
    
--  end
  
  
  
  
  
--end
