--[[
A tile doing in a tilemap, generally terrain or objects like trees, buildings, etc.

Probably not useful anymore since Simple Tiled Implementation. Might delete later, idk. ;P
]]

Tile = Class{}

function Tile:init(def)
  self.x = def.x
  self.y = def.y
  self.name = def.name
  
  self.texture = TILE_DEFS[self.name]['texture']
  self.id = TILE_DEFS[self.name]['id']
  
  
end

function Tile:update(dt) -- may be used for tiles with animated images or that the player can change somehow
  
end


function Tile:render()
  love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.id], math.floor((self.x - 1) * TILE_SIZE), math.floor((self.y - 1) * TILE_SIZE))
end
