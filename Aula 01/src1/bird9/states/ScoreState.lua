--[[
    um estado simples usado para mostrar a pontuacao do jogador antes
    de transitar de volta para o playstate (reiniciar).
]]

ScoreState = Class{__includes = BaseState}

--[[
    quando entramos no scorestate, esperamos receber a pontuacao (score)
    do playstate. essa funcao 'enter' e chamada automaticamente pela statemachine
    e recebe os parametros passados no segundo argumento do 'change'.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- volta para o jogo se apertar enter
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
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