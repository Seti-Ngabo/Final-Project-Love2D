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

  love.window.setTitle('Pong')

  smallFont = love.graphics.newFont('font.ttf', 8)

  scoreFont = love.graphics.newFont('font.ttf', 32)

  victoryFont = love.graphics.newFont('font.ttf', 24)

  love.graphics.setFont(smallFont)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
  })

  player1Score = 0
  player2Score = 0

  servingPlayer = 1
  winningPlayer = 0

  player1 = Paddle(10, 30, 5, 20)
  player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

  if servingPlayer == 1 then
    ball.dx = 100
  else
    ball.dx = -100
  end

  gameState = 'start'
end

function love.update(dt)
  if gameState == 'play' then

    if ball:collides(player1) then
      -- deflect the ball to the right
      ball.dx = -ball.dx * 1.03
      ball.x = player1.x + 5

      if ball.dy < 0 then
        -- deflect the ball down
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end
    end

    if ball:collides(player2) then
      -- deflect the ball to the left
      ball.dx = -ball.dx * 1.03
      ball.x = player2.x - 4

      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end
    end

    if ball.y <= 0 then
      ball.y = 0
      ball.dy = -ball.dy
    end

    if ball.y >= VIRTUAL_HEIGHT - 4 then
      ball.y = VIRTUAL_HEIGHT - 4
      ball.dy = -ball.dy
    end
  end

  if ball.x < 0 then
    player2Score = player2Score + 1
    servingPlayer = 1
    ball:reset()

    if player2Score >= 3 then 
      gameState = 'victory'
      winningPlayer = 2
    else
      gameState = 'serve'
    end
  end

  if ball.x > VIRTUAL_WIDTH then
    player1Score = player1Score + 1
    servingPlayer = 2
    ball:reset()

    if player1Score >= 3 then 
      gameState = 'victory'
      winningPlayer = 1
    else
      gameState = 'serve'
    end
  end

  -- player 1 movement
  if love.keyboard.isDown('w') then
    player1.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then
    player1.dy = PADDLE_SPEED
  else
    player1.dy = 0
  end

  -- player 2 movement
  if love.keyboard.isDown('up') then
    player2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then
    player2.dy = PADDLE_SPEED
  else
    player2.dy = 0
  end

  if gameState == 'play' then
    ball:update(dt)
  end


  player1:update(dt)
  player2:update(dt)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'serve'
    elseif gameState == 'victory' then
      gameState = 'start'
      player1Score = 0
      player2Score = 0
    elseif gameState == 'serve' then
      gameState = 'play'
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
    love.graphics.setFont(smallFont)
    love.graphics.printf("Welcome to Pong", 0,20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press Enter to Play!", 0, 32, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'serve' then
    love.graphics.printf("Player" .. tostring(servingPlayer) .. "'s turn!", 0,20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press Enter to Serve!", 0, 20, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'victory' then
    -- draw a victory massage
    love.graphics.setFont(victoryFont)
    love.graphics.printf("Player" .. tostring(winningPlayer) .. "wins", 0,20, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf("Press Enter to Serve!", 0, 42, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'play' then
    -- no UI message to display in play
  end

  love.graphics.setFont(scoreFont)
  love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

  player1:render()
  player2:render()
  
  ball:render()

  displayFPS()

  -- end rendering at virtual resolution
  push:apply('end')
end

function displayFPS()
  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.setFont(smallFont)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20)
  love.graphics.setColor(1, 1, 1, 1)
end

function displayScore()
  love.graphics.setFont(scoreFont)
  love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
end