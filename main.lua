--[[
  This is CS50 2019.
  Game Track
  Pong

  pong-1
  "The Low-Res Update"
]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide a more retro aesthetic
-- https://github.com/Ulydev/push

Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

WINDOW_WIDTH = 620
WINDOW_HEIGHT = 300

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

--[[
  Runs when the game first starts up, only once; used to initialzw the game.
]]
function love.load()
  math.randomseed(os.time())

  love.graphics.setDefaultFilter('nearest', 'nearest')

  smallFont = love.graphics.newFont('font.ttf', 8)

  scoreFont = love.graphics.newFont('font.ttf', 32)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
  })

  paddle1 = Paddle(5, 20, 5, 20)
  paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

  gameState = 'start'
end

function love.update(dt)

  paddle1:update(dt)
  paddle2:update(dt)

  -- player 1 movement
  if love.keyboard.isDown('w') then
    paddle1.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then
    paddle1.dy = PADDLE_SPEED
  else
    paddle1.dy = 0
  end

  -- player 2 movement
  if love.keyboard.isDown('up') then
    paddle2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then
    paddle2.dy = PADDLE_SPEED
  else
    paddle2.dy = 0
  end

  if gameState == 'play' then
    ball:update(dt)
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'play'
    elseif gameState == 'play' then
      gameState = 'strat'
      ball:reset()
    end
  end
end
--[[
  Called after update by LOVE, used to draw anything to the screen, update or otherwise.
]]

function love.draw()

  -- begin rendering at virtual resolution
  push:apply('start')

  love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

  love.graphics.setFont(smallFont)
  if gameState == 'start' then
    love.graphics.printf('Hello Start State!', 0, 20, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'play' then
    love.graphics.printf('Hello play State!', 0, 20, VIRTUAL_WIDTH, 'center')
  end

  paddle1:render()
  paddle2:render()
  
  ball:render()

  -- end rendering at virtual resolution
  push:apply('end')
end