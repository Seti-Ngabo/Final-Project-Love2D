--[[
  This is CS50 2019.
  Game Track
  Pong

  pong-1
  "The Low-Res Update"
]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide a more retro asethetic
-- https://github.com/Ulydev/push

push = require 'push'

WINDOW_WIDTH = 620
WINDOW_HEIGHT = 300

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--[[
  Runs when the game first starts up, only once; used to initialzw the game.
]]
function love.load()

  -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text
  -- and graphics; try removing this function to see the difference!
  love.graphics.setDefaultFilter('nearest', 'nearest')

  smallFont = love.graphics.newFont('font.ttf', 8)
  love.graphics.setFont(smallFont)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
  })
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
--[[
  Called after update by LOVE, used to draw anything to the screen, update or otherwise.
]]

function love.draw()

  -- begin rendering at virtual resolution
  push:apply('start')

  love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

  love.graphics.rectangle('fill', 5, 20, 5, 20)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40, 5, 20)

  love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

  push:apply('end')
end