WINDOW_WIDTH = 620
WINDOW_HEIGHT = 300

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push'

--[[
  Runs when the game first starts up, only once; used to initialzw the game.
]]
function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
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
  push:apply('start')

    love.graphics.printf("Hello Pong!", 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')

  push:apply('end')
end