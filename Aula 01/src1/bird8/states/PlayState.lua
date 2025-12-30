--[[
    o playstate e onde o jogo realmente acontece.
    toda a logica de movimento do passaro, geracao de canos e colisao
    foi movida do main.lua para ca.
]]

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    -- inicializa o passaro
    self.bird = Bird()
    
    -- inicializa a tabela de canos vazia
    self.pipePairs = {}
    
    -- temporizador para spawnar canos
    self.timer = 0

    -- controla a posicao y do ultimo cano para garantir que o proximo seja alcancavel
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    -- atualiza o temporizador
    self.timer = self.timer + dt

    -- a cada 2 segundos, gera um novo par de canos
    if self.timer > 2 then
        -- logica matematica para garantir que o gap (abertura) nao fique fora da tela
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        -- adiciona o novo par na tabela
        table.insert(self.pipePairs, PipePair(y))

        -- reseta o timer
        self.timer = 0
    end

    -- percorre todos os pares de canos para atualizar suas posicoes
    for k, pair in pairs(self.pipePairs) do
        pair:update(dt)
    end

    -- remove os canos que ja sairam da tela para liberar memoria
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- atualiza a fisica do passaro (gravidade e input)
    self.bird:update(dt)

    -- verificacao de colisao com os canos
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                -- se bater, volta para o menu inicial (title)
                gStateMachine:change('title')
            end
        end
    end

    -- verificacao de colisao com o chao
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gStateMachine:change('title')
    end
end

function PlayState:render()
    -- desenha todos os canos
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    -- desenha o passaro
    self.bird:render()
end