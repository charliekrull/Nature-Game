--[[ A game about surviving and maintaining a base in a fantasy sort of setting

]]


require 'src/Dependencies'


--when the game first opens
function love.load()
  io.stdout:setvbuf("no") --[[ turn off buffering for text so we can see everything we print to console immediately. 
                                turn this to "yes" if performance becomes an issue ]]
      
  math.randomseed(os.time())
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
    {fullscreen = false,
      resizable = true,
      vsync = true})
  
  love.window.setTitle('Innawoods')
  love.keyboard.keysPressed = {}
  love.mouse.clicks = {}
  
  love.graphics.setDefaultFilter('linear', 'linear')
  
  gTextures = {['terrain'] = love.graphics.newImage('graphics/terrain.png'),
                  ['chests'] = love.graphics.newImage('graphics/chests.png'),
                  ['creatures'] = love.graphics.newImage('graphics/alives_other.png'),
                  ['mage'] = love.graphics.newImage('graphics/Soldiers/Ranged/MageTemplate.png'),
                  ['characters'] = love.graphics.newImage('graphics/Characters/sprites/old-style/01-generic.png')}
  
  gFrames = {}
  
  for key, img in pairs(gTextures) do
    gFrames[key] = GenerateQuads(img, TILE_SIZE, TILE_SIZE)  
  end
  
  gFonts = {small = love.graphics.newFont('fonts/PlayFairDisplay-Regular.ttf', 12),
    medium = love.graphics.newFont('fonts/PlayFairDisplay-Regular.ttf', 24),
    large = love.graphics.newFont('fonts/PlayfairDisplay-Regular.ttf', 36)}
  
  gStateMachine = StateMachine{['start'] = function() return StartState() end,
                                ['play'] = function() return PlayState{} end,
                                ['generate-map'] = function() return GenerateMapState{} end}
  gStateMachine:change('start')
  
end


--every frame
function love.update(dt)
  
  
  if love.keyboard.wasPressed('escape') then
    
    love.event.quit()
    
  end
  gStateMachine:update(dt)
  
  love.keyboard.keysPressed = {}
  love.mouse.clicks = {}
  
end


function love.draw()
  push:apply('start')
  gStateMachine:render()
  push:apply('end')
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
  
end

function love.keyboard.wasPressed(key)
  
  return love.keyboard.keysPressed[key]
  
end

function love.mousepressed(x, y, button)
  love.mouse.clicks[button] = {x = x, y = y}
end
