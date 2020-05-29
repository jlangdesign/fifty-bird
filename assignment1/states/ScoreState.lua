--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

-- Constants for bronze, silver, and gold scores
-- Color values in 11.0 and above must be between 0 and 1, not 0 and 255
local BRONZE = {
  ['score'] = 5,
  ['name'] = 'BRONZE MEDAL',
  ['rgb'] = { .804, .498, .196 } -- ['rgb'] = { 205, 127, 50 }
}

local SILVER = {
  ['score'] = 10,
  ['name'] = 'SILVER MEDAL',
  ['rgb'] = { .75, .75, .75 } -- ['rgb'] = { 192, 192, 192 }
}

local GOLD = {
  ['score'] = 15,
  ['name'] = 'GOLD MEDAL',
  ['rgb'] = { 1, .84, 0 } -- ['rgb'] = { 255, 215, 0 }
}

local CONGRATS_MSG = 'Congratulations! You earned a '

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

local function renderMedal(medalObj)
  love.graphics.setColor(medalObj['rgb'][1] - .1, medalObj['rgb'][2] - .1, medalObj['rgb'][3] - .1)
  love.graphics.ellipse('fill', VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 10, 10)
  love.graphics.setColor(medalObj['rgb'][1], medalObj['rgb'][2], medalObj['rgb'][3])
  love.graphics.ellipse('fill', VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 8, 8)

  love.graphics.setColor(255, 255, 255)
  love.graphics.printf(CONGRATS_MSG, 0, 160, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(flappyFont)
  love.graphics.printf(medalObj['name'], 0, 180, VIRTUAL_WIDTH, 'center')
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    -- give award if score is high enough
    if self.score >= GOLD['score'] then
      renderMedal(GOLD)
    elseif self.score >= SILVER['score'] then
      renderMedal(SILVER)
    elseif self.score >= BRONZE['score'] then
      renderMedal(BRONZE)
    end

    -- love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Enter to Play Again!', 0, 240, VIRTUAL_WIDTH, 'center')
end
