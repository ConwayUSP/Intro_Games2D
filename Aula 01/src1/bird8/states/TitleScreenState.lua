--[[
    este e o estado inicial do jogo.
    ele exibe o titulo "fifty bird" e espera o jogador apertar enter.
]]

-- herda de basestate
TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    -- verifica se a tecla enter ou return foi pressionada
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- usa a maquina de estados global para trocar para o estado 'play'
        gStateMachine:change('play')
    end
end

function TitleScreenState:render()
    -- desenha o titulo do jogo com a fonte grande
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Fifty Bird', 0, 64, VIRTUAL_WIDTH, 'center')

    -- desenha a instrucao com a fonte media
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end