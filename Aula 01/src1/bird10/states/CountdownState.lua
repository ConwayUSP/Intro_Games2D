--[[
    este e um novo estado que serve de transicao entre o menu/gameover e o jogo.
    ele faz uma contagem regressiva de 3 a 1 antes de liberar o controle para o jogador.
]]

CountdownState = Class{__includes = BaseState}

-- define quanto tempo leva cada numero da contagem (0.75 segundos)
COUNTDOWN_TIME = 0.75

function CountdownState:init()
    -- comeca a contagem no 3
    self.count = 3
    -- inicializa o temporizador
    self.timer = 0
end

--[[
    acompanha quanto tempo passou e diminui a contagem se o
    temporizador exceder o nosso tempo definido. se chegar a 0,
    devemos transitar para o playstate.
]]
function CountdownState:update(dt)
    self.timer = self.timer + dt

    -- se passou o tempo de um numero (0.75s)
    if self.timer > COUNTDOWN_TIME then
        -- reseta o timer mantendo o excedente (modulo) para precisao
        self.timer = self.timer % COUNTDOWN_TIME
        
        -- diminui a contagem
        self.count = self.count - 1

        -- se a contagem terminou (chegou a 0), inicia o jogo
        if self.count == 0 then
            gStateMachine:change('play')
        end
    end
end

function CountdownState:render()
    -- desenha o numero atual da contagem bem grande no centro da tela
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end