--the main game state

PlayState = Class{__includes = BaseState}

function PlayState:init(def)
  self.color = def.color or COLORS.magenta
  
  self:setUpMap(def)
 
  
  self.camX = 0
  self.camY = 0

  
  
end


function PlayState:enter()
  
end


function PlayState:update(dt)
  
  if love.keyboard.wasPressed('space') then
    self.color = COLORS[table.randomKey(COLORS)]
    
    
  end
  

  
  self.map:update(dt)
  
  self:updateCamera(self.player)
end

function PlayState:render()
  --love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
  if self.map then
    self.map:draw(-math.floor(self.camX), -math.floor(self.camY))
  else
    love.graphics.clear(self.color)
  end
  
 
  
  
end

function PlayState:setUpMap(def)
  self.map = sti('graphics/Tilemaps/Testing.lua')
  
  local layer = self.map:addCustomLayer('Entities', 3)
   
  self.player = def.player or Entity{x = VIRTUAL_WIDTH/2, y = VIRTUAL_HEIGHT/2, entityType = 'player'}
    
  layer.entities =  { self.player, Entity{x = VIRTUAL_WIDTH/4, y = VIRTUAL_HEIGHT/4,  entityType = 'chest'}}
  
  for _, ent in pairs(layer.entities) do
    ent.map = self.map
  end
  
  layer['update'] = function(self, dt) 
                for _, ent in pairs(self.entities) do
                  
                  ent:update(dt)
                  
                  if ent.collidable then
                    
                    for _, ent2 in pairs(self.entities) do
                    
                      if ent ~= ent2 and ent2.collidable and ent:collides(ent2) then
                        ent.x = ent.x - ent.dx * dt
                        ent.y = ent.y - ent.dy * dt
                      
                      end
                    
                    end
                  end
                  
                  ent.x = clamp(ent.x, 0, ent.map.layers['Tile Layer 1'].width * TILE_SIZE - ent.width)
                  ent.y = clamp(ent.y, 0, ent.map.layers['Tile Layer 1'].height * TILE_SIZE - ent.height)
                  
                end
              end
              
          
  layer['draw'] = function(self, dt)
    
                for _, ent in pairs(self.entities) do
                  
                  ent:render()
                  
                end
                
              end
              
              
  
end


function PlayState:updateCamera(target)
  
  self.camX = math.max(0, math.min(target.x - (VIRTUAL_WIDTH/2 - TILE_SIZE/2), self.map.width * TILE_SIZE - VIRTUAL_WIDTH))
  self.camY = math.max(0, math.min(target.y - (VIRTUAL_HEIGHT/2 - TILE_SIZE/2), self.map.height * TILE_SIZE - VIRTUAL_HEIGHT))
  
end

