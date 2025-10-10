--[[

The main class of things that inhabit the game world

]]

Entity = Class{}

function Entity:init(def)
  self.x = def.x
  self.y = def.y
  
  self.dx = 0
  self.dy = 0
  
  self.direction = 'down'
    
  self.entityType = def.entityType
  
  self.animations = {}
   
  self:getTraits(ENTITY_DEFS[self.entityType]) -- read in the data from the ENTITY_DEFS table 
  
  if self.collidable == nil then
    self.collidable = false  
  end
  
  
 
  
  self.currentAnimation = self.animations[self.startingAnimation] -- nil if using a texture and ID with no animation
  
  
  if self.animated then
    self.stateMachine = StateMachine{idle = function() return EntityIdleState(self) end,
                                      move = function() return EntityMoveState(self) end}
  
  end
  
end

function Entity:update(dt)
  
  if self.stateMachine then 
    
    self.stateMachine:update(dt) 
    
    
  end
  
  --check collisions in the tilemap, not here
  self.x = self.x + self.dx * dt
  
  self.y = self.y + self.dy * dt

  
  
end

function Entity:render()
  
  love.graphics.setColor(COLORS.white)
  
  
  if self.animated then
    
    
    love.graphics.draw(gTextures[self.currentAnimation.texture], gFrames[self.currentAnimation.texture][self.currentAnimation:getCurrentFrame()], 
      math.floor(self.x), math.floor(self.y))

  elseif self.texture then
  
    
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.id], math.floor(self.x), math.floor(self.y))
    
  
  else
    
    love.graphics.setColor(COLORS.magenta)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    
  end
  

end

function Entity:collides(target) --Axis-Aligned Bounding Boxes, ie we assume everything is a rectangle that doesn't rotate
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Entity:getTraits(tbl) 
  for key, val in pairs(tbl) do
    
    if key == 'animations' then
      
      
      for k, v in pairs(val) do -- for each key k ("walk-down" or" "idle-left"), assign an animation with the table v 
        self.animations[k] = Animation{
                            frames = v.frames,
                            interval = v.interval,
                            texture = v.texture or ENTITY_DEFS[self.entityType]['texture']
                            }
      end
      
      
    else
      
      self[key] = val  
      
    end
    
  end
  
end

function Entity:changeState(name)
  self.stateMachine:change(name)
  
end


function Entity:changeAnimation(animation --[[string]])
  
  self.currentAnimation = self.animations[animation]
  
end

