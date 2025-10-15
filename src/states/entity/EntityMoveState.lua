--[[

State where the entity is on the move.

]]

EntityMoveState = Class{__includes = BaseState}

function EntityMoveState:init(def)
  self.entity = def.entity
end

function EntityMoveState:enter()
  self.entity:changeAnimation('walk-'..self.entity.direction)
end


function EntityMoveState:update(dt)
  
  self:processControl()
  
 
  
end

function EntityMoveState:render()
  local anim = self.entity.currentAnimation
  
  love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], math.floor(self.entity.x), math.floor(self.entity.y))
end

function EntityMoveState:processControl()
  
  if self.entity.entityType == 'player' then -- entity is controlled by the player
    
    --if the player presses a directional button like left or w, the dx and/or dy will be changed as appropriate
    
    local x, y = 0, 0 
    
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
      
      x = x-1
      self.entity.direction = 'left'
      
    end
    
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
      
      x = x+1
      self.entity.direction = 'right'
      
    end
    
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
    
      y = y - 1
      self.entity.direction = 'up'
    
    end
    
    if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
    
      y = y + 1
      self.entity.direction = 'down'
    
    end
    
    
    
    
    local anim = 'walk-'..self.entity.direction
    self.entity:changeAnimation(anim)
    
    self.entity.dx = self.entity.dx + self.entity.speed * x
    self.entity.dy = self.entity.dy + self.entity.speed * y
    
    --avoid moving faster on diagonals
    if self.entity.dx ~= 0 and self.entity.dy ~= 0 then
      
      self.entity.dx = self.entity.dx / math.sqrt(2)
      self.entity.dy = self.entity.dy / math.sqrt(2)
      
    end
    
    
    if not love.keyboard.isDown('a') and not love.keyboard.isDown('left') and not love.keyboard.isDown('d') and not love.keyboard.isDown('right')
     and not love.keyboard.isDown('w') and not love.keyboard.isDown('up') and not love.keyboard.isDown('s') and not love.keyboard.isDown('down') then
      self.entity:changeState('idle')
    end
    
    

    
    
  else -- entity does not take player input
    
  end
end

