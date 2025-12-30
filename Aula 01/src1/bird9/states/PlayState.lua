--[[
    o playstate agora rastreia a pontuacao (score) e detecta quando
    o passaro ultrapassa um cano.
]]

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    -- inicializa a pontuacao com 0
    self.score = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    self.timer = self.timer + dt

    -- gera canos a cada 2 segundos (aproximadamente)
    if self.timer > 2 then
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        table.insert(self.pipePairs, PipePair(y))
        self.timer = 0
    end

    -- para cada par de canos...
    for k, pair in pairs(self.pipePairs) do
        -- se o par ainda nao foi pontuado (scored e falso)
        if not pair.scored then
            -- verifica se o cano ja passou totalmente pelo passaro
            -- (posicao x do cano + largura < posicao x do passaro)
            if pair.x + PIPE_WIDTH < self.bird.x then
                -- incrementa a pontuacao
                self.score = self.score + 1
                -- marca o par como pontuado para nao somar infinitamente
                pair.scored = true
            end
        end

        pair:update(dt)
    end

    -- remove canos que sairam da tela
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    self.bird:update(dt)

    -- verifica colisao com canos
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                -- se bater, muda para o estado 'score' e passa a pontuacao atual
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    -- verifica colisao com o chao
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change('score', {
            score = self.score
        })
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    -- desenha a pontuacao no canto superior esquerdo durante o jogo
    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end