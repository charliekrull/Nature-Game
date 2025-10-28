--[[

Procedurally generates multi-layered Tilemaps for use with STI and Tiled.

Uses Model Synthesis (Wave Function Collapse (wfc))

]]

GenerateMapState = Class{__includes = BaseState}

function GenerateMapState:init(def)
  
  self.inputMap = def.inputMap or sti('graphics/Tilemaps/simpleInput.lua')
  self.outputMap = def.outputMap or sti('graphics/Tilemaps/BlankTilemap.lua') --[[May be provided a map with certain formatting or fixed locations or what have you, default option has the basic terrain tileset associated, measures 50 x 50 tiles, all blank tiles to start]]
  
  --set up the "wave function", ie the table that contains all the cells and tracks all their possible states
  
  self.wave = {}
  self.wave.cells = {} --a cell of the grid, only really tracks x, y and the options for each cell
  self.wave.affectedCells = {} --cells adjacent to a cell whose options have changed
  
  
  self.wave.support = {}
  self.wave.invalidTiles = {}
  
  
 
end

function GenerateMapState:enter()
  self.startShots = love.timer.getTime()
  self.shots = self:takeSnapshots(self.inputMap, 3, 3)
  self.shotTime = love.timer.getTime() - self.startShots
  
  
  self.startSetup = love.timer.getTime()
  self:setUpMap()
  self.setupTime = love.timer.getTime() - self.startSetup
  
  print('Shot Time:', tostring(self.shotTime))
  print('Map Setup Time:', tostring(self.setupTime))
end

function GenerateMapState:update(dt)
 
end

function GenerateMapState:render()
  love.graphics.clear(COLORS.white)
  
end


function GenerateMapState:isValid(opt1, opt2, direction) --direction is the direction from opt1 to opt2
  return table.contains(self.shots[opt1]['neighbors'][direction], opt2)
end

function GenerateMapState:collapseCell(x, y)
  
  
  
  

end

function GenerateMapState:getEntropy(x, y)
  local entropy = 0
  
  for _, opt in pairs(self.wave.cells[y][x].options) do
    
    entropy = entropy + (self.shots[opt].frequency * math.log(self.shots[opt].frequency))
    
  end
  
  entropy = -entropy
  
  return entropy
end


function GenerateMapState:getMinEntropyCells() -- the cells with the fewest potential options, accouting for the weights/frequencies of each option
  
  local currentMin = 99999
  local minEntropyCells = {}
  
  for y, row in pairs(self.wave.cells) do
    
    for x, cell in pairs(row) do
      
      if not cell.collapsed then
        if cell.entropy < currentMin then
          minEntropyCells = {}
          currentMin = cell.entropy
          table.insert(minEntropyCells, {x = x, y = y})
          
        elseif cell.entropy == currentMin then
          
          table.insert(minEntropyCells, {x = x, y = y})
        end
        
      end
      
      
    end
    
  end
  
  return minEntropyCells
end

function GenerateMapState:calculateSupport(x, y, option, direction) 
  --[[support of a certain option X is the number of options for the adjacent cells that will be valid if X is chosen in its cell. if support in any direction is 0, that means X is not a valid option for its cell and needs to be removed from the options table]]
  
  local xmod, ymod = 0, 0
  if direction == 'north' then
    ymod = -1
  elseif direction == 'east' then
    xmod = 1
  elseif direction == 'south' then
    ymod = 1
  elseif direction == 'west' then
    xmod = -1
  end
  
  local supportTotal = 0
  if self.wave.cells[y+ymod] and self.wave.cells[y+ymod][x+xmod] then
    for k, opt2 in pairs(self.wave.cells[y + ymod][x+xmod].options) do
      if self:isValid(option, opt2, direction) then
        
        supportTotal = supportTotal + 1
        
      end
      
    end  
    return supportTotal
    
  else
    return 1
  end
  
  
  
end

function GenerateMapState:sumFrequencies(tbl)
  local sum = 0
  for _, shot in pairs(tbl) do
    sum = sum + shot.frequency  
  end
  
  return sum
end

function GenerateMapState:getWeightedRandomShot(opts)
  
  local r = math.random(self:sumFrequencies(opts))
  
  for _, opt in pairs(shuffle(opts)) do
    r = r - opt.frequency
    
    if r <= 0 then
      
      return opt
      
    end
    
  end
  
  
end

function GenerateMapState:setUpMap()
  --intialize the wave with empty cells
  
  for y = 1, self.outputMap.height do
    self.wave.cells[y] = {}
    
    for x = 1, self.outputMap.width do
      
      self.wave.cells[y][x] = {x = x, y = y, options = {}, collapsed = false}
      
      for i = 1, #self.shots do
        table.insert(self.wave.cells[y][x]['options'], i)
      end
      
      self.wave.cells[y][x].entropy = self:getEntropy(x, y)
      
    end
    
  end
  
  for y = 1, #self.wave.cells do             
    self.wave.support[y] = {}
    self.wave.invalidTiles[y] = {}
    
    for x = 1, #self.wave.cells[y] do
      self.wave.support[y][x] = {}
      self.wave.invalidTiles[y][x] = {}
      
      for k, opt in pairs(self.wave.cells[y][x].options) do
        self.wave.support[y][x][opt] = {north = self:calculateSupport(x, y, opt, 'north'), 
                                        east = self:calculateSupport(x, y, opt, 'east'),
                                        south = self:calculateSupport(x, y, opt, 'south'),
                                        west = self:calculateSupport(x, y, opt, 'west')}
        
        if self.wave.support[y][x][opt]['north'] == 0 or self.wave.support[y][x][opt]['east'] == 0 or
         self.wave.support[y][x][opt]['south'] == 0 or self.wave.support[y][x][opt]['west'] == 0 then
           
          table.insert(self.wave.invalidTiles[y][x], opt)
          
        end
        
      end
      
    end
    
  end
  
  
  for y = 1, #self.wave.invalidTiles do 
    for x = 1, #self.wave.invalidTiles[y] do
      local index = 0
      
      for k, opt in pairs(self.wave.cells[y][x].options) do
        if self.wave.invalidTiles[y][x] == opt then
          
          index = k
          break
        end
        
      end
      
      table.remove(self.wave.cells[y][x].options, index)
      self.wave.cells[y][x].entropy = self:getEntropy(x, y)
    end
    
  end
  
  self.minEntropyCells = self:getMinEntropyCells()
  
end


function GenerateMapState:takeSnapshots(tilemap, shotWidth, shotHeight)
  
  local snapshots = {} -- where all the snapshots we take will get put
  local returnedSnapshots = {} -- a list of each unique snapshot and its frequency in the input map and its allowable neighbors
  local function getShotIndex(snapshot)
          for i = 1, #returnedSnapshots do
            if tablesMatch(returnedSnapshots[i].contents, snapshot.contents) then
              
              return i 
              
            end
            
            
          end
          return 0
        end
  
  for y = 1, tilemap.height do
    snapshots[y] = {}
    for x = 1, tilemap.width do
      
      
      local shot = {}
      for shotY = 1, shotHeight do
        
        shot[shotY] = {}
        for shotX = 1, shotWidth do
          
          shot[shotY][shotX] = tilemap.layers[1].data[((y - 1 + shotY - 1) % tilemap.height) + 1][((x-1 + shotX - 1) % tilemap.width) + 1].gid
          
        end
      end
      
      snapshots[y][x] = {contents = shot, frequency = 1,
        neighbors = {north = {},
                      east = {},
                      south = {},
                      west = {}}
                    }
      
      
    end
    
  end
  
  --now that all the snapshots are recorded, fill out the neighbors, put every unique snapshot into returnedSnapshots
  --if a snapshot matches one already in the table, increase its frequency and update the neighbors
  
  
  for y = 1, tilemap.height do
    
    for x = 1, tilemap.width do
      
      local currentShot = snapshots[y][x]
  
      
      if #returnedSnapshots == 0 then
        table.insert(returnedSnapshots, currentShot)
        
      else
        
        local matchFound = false
        
        for _, shot in pairs(returnedSnapshots) do
          
          if tablesMatch(currentShot.contents, shot.contents) then
            shot.frequency = shot.frequency + 1
            matchFound = true
            
            
          end
          
        end
        if not matchFound then
          table.insert(returnedSnapshots, currentShot)  
        end
        
      end
      
    end
    
  end
  
  
  for y = 1, tilemap.height do
    for x = 1, tilemap.width do
      
      local refShot = snapshots[y][x] -- reference shot, the snapshot we are currently considering
      local refInd = getShotIndex(refShot) -- its index in returnedSnapshots
      
      
      for _, dir in pairs(DIRECTIONS) do
        local xmod, ymod = 0, 0
        
        if dir == 'north' then
          ymod = -1
          
        elseif dir == 'east' then
          xmod = 1
          
        elseif dir == 'south' then
          ymod = 1
          
        elseif dir == 'west' then
          xmod = -1
          
        end
        
        local compShot = snapshots[(((y + ymod) - 1) % tilemap.height) + 1][(((x + xmod) - 1) % tilemap.width) + 1]
        local compInd = getShotIndex(compShot)
        
        if not table.contains(returnedSnapshots[refInd].neighbors[dir], compInd) then
          table.insert(returnedSnapshots[refInd].neighbors[dir], compInd)
          
        end
        
        
      end
      
    
    end
    
  end
  
  
  return returnedSnapshots
  
  
end


