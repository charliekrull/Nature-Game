
--the gamestate where the player is on the main menu

StartState = Class{__includes = BaseState}

function StartState:init()
  
end


function StartState:enter()
  
end

function StartState:update(dt)
  if love.keyboard.wasPressed('space') then 
    
    gStateMachine:change('play')
  end
  
end

function StartState:render()
  love.graphics.clear(COLORS.yellow)
  
end
