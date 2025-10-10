--[[
A chunk of world, level, etc.

probably not actually useful, its functionalisty is covered by Simple Tiled Implementation's 

]]

Tilemap = Class{}

function Tilemap:init(def)
  
  self.width = def.width or 40 --the width and height of the map in Tiles. TILES, NOT PIXELS!
  self.height = def.height or 40
  
  
  self.tiles = def.tiles or {}
  self.entities = def.entities or {}
  
  
  --put a bunch of placeholder tiles in the map
  local counter = 0
 
  for y = 1, self.height do
    self.tiles[y] = {}
    
    for x = 1, self.width do
      local t = Tile{x = x, y = y, name = counter > (self.width * self.height) / 2 and 'grass' or 'water'}
      self.tiles[y][x] = t
      counter = counter + 1
    end
    
    
  end

  
  
end

function Tilemap:update(dt)
  
end

function Tilemap:render()
  
  for y, row in pairs(self.tiles) do
    for x, tile in pairs(row) do
      tile:render()
    end
  end
  
end
