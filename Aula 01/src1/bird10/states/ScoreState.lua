--[[
    a tela de game over tambem foi atualizada para reiniciar o jogo
    passando pela contagem regressiva.
]]

ScoreState = Class{__includes = BaseState}

--[[
    quando entramos no score state, esperamos receber a pontuacao
    do play state para saber o que renderizar.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- volta para o jogo (via countdown) se apertar enter
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simplesmente renderiza a pontuacao no meio da tela
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end