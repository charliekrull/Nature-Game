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
  self.wave.cells = {}
  
  self.shots = self:takeSnapshots(self.inputMap, 3, 3)
  
  
  
  
end

function GenerateMapState:enter()
  --intialize the wave with empty cells
  for y = 1, self.outputMap.height do
    self.wave.cells[y] = {}
    
    for x = 1, self.outputMap.width do
      
      self.wave.cells[y][x] = {x = x, y = y, options = {}}
      
    end
    
  end
  
  
  
end

function GenerateMapState:update(dt)
  
end

function GenerateMapState:render()
  love.graphics.setColor(COLORS.white)
  
end

function GenerateMapState:takeSnapshots(tilemap, shotWidth, shotHeight)
  
  local snapshots = {} -- where all the snapshots we take will get put
  local returnedSnapshots = {} -- a list of each unique snapshot and its frequency in the input map and its allowable neighbors
  
  for y = 1, tilemap.height do
    snapshots[y] = {}
    for x = 1, tilemap.width do
      
      
      local shot = {}
      for shotY = 1, shotHeight do
        
        shot[shotY ] = {}
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
      
      for dir, tiles in pairs(currentShot.neighbors) do
        
        if dir == 'north' then
        
          table.insert(tiles, snapshots[((y - 1 - 1) % tilemap.height) + 1][x])
          
        elseif dir == 'east' then
          
          table.insert(tiles, snapshots[y][((x + 1 - 1) % tilemap.width) + 1])
          
        elseif dir == 'south' then
          
          table.insert(tiles, snapshots[((y + 1 - 1) % tilemap.height) + 1][x])
          
          
        elseif dir == 'west' then
          
          table.insert(tiles, snapshots[y][((x - 1 - 1) % tilemap.width) + 1])
          
        else
          
          print("couldn't tell what direction")
          
        end
        
        
      end
      
      
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
  
  
  return returnedSnapshots
  
  
  
end

