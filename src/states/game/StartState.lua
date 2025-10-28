
--the gamestate where the player is on the main menu

StartState = Class{__includes = BaseState}

function StartState:init()
  
end


function StartState:enter()
  
end

function StartState:update(dt)
  if love.keyboard.wasPressed('space') then 
    
    gStateMachine:change('play')
  
  elseif love.mouse.clicks[1] then
    
    gStateMachine:change('generate-map')
  
  end
  
end

function StartState:render()
  love.graphics.clear(COLORS.yellow)
  
  love.graphics.setColor(COLORS.blue)
  love.graphics.setFont(gFonts.large)
  love.graphics.printf('Let\'s get ready to survive!', 0, VIRTUAL_HEIGHT/2 - love.graphics.getFont():getHeight() / 2, VIRTUAL_WIDTH, 'center')
  love.graphics.setColor(COLORS.white)
end
