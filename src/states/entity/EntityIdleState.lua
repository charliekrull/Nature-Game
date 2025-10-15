--[[

Entity state when not moving or doing something

]]

EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(def)
  self.entity = def.entity
 
  
  
end

function EntityIdleState:enter()
  self.entity:changeAnimation('idle-'..self.entity.direction)
end


function EntityIdleState:update(dt)
  
  self:processControl()
  
  
  
end

function EntityIdleState:render()
  local anim = self.entity.currentAnimation
  
  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.entity.x), math.floor(self.entity.y))
end

function EntityIdleState:processControl()
  
  if self.entity.entityType == 'player' then
    
    if love.keyboard.isDown('a') or love.keyboard.isDown('left')
      or love.keyboard.isDown('d') or love.keyboard.isDown('right') 
      or love.keyboard.isDown('w') or love.keyboard.isDown('up') 
      or love.keyboard.isDown('s') or love.keyboard.isDown('down') then
      
      self.entity:changeState('move')
      
    end
    
  else
    
    
  end
  
  
  
  
end
