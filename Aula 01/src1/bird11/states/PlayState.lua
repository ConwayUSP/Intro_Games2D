--[[
    o playstate e o coracao do jogo. nesta versao (bird11),
    adicionamos efeitos sonoros para pontuacao e colisoes.
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
    self.score = 0

    -- inicializa nosso ultimo valor y gravado para basear o proximo gap
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    -- atualiza o timer para spawnar canos
    self.timer = self.timer + dt

    -- spawna um novo par de canos a cada 2 segundos (aproximadamente)
    if self.timer > 2 then
        -- modifica a ultima coordenada y para que os gaps nao fiquem muito distantes
        -- nao mais alto que 10 pixels do topo e nao mais baixo que 90 pixels do fundo
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        -- adiciona um novo par de canos no fim da tela
        table.insert(self.pipePairs, PipePair(y))

        -- reseta o timer
        self.timer = 0
    end

    -- para cada par de canos..
    for k, pair in pairs(self.pipePairs) do
        -- marca ponto se o cano passou pelo passaro totalmente para a esquerda
        -- ignora se ja tiver sido pontuado
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                
                -- novidade do bird11: toca o som de pontuacao
                sounds['score']:play()
            end
        end

        -- atualiza a posicao do par
        pair:update(dt)
    end

    -- precisamos deste segundo loop para remover canos
    -- remover itens de uma tabela enquanto iteramos sobre ela pode causar bugs de pular itens
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- colisao simples entre passaro e todos os canos nos pares
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                -- novidade do bird11: toca sons de explosao e machucado ao bater
                sounds['explosion']:play()
                sounds['hurt']:play()

                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    -- atualiza o passaro baseado na gravidade e input
    self.bird:update(dt)

    -- reseta se batermos no chao
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        -- toca sons de colisao tambem ao bater no chao
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score', {
            score = self.score
        })
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end

--[[
    chamado quando transita para este estado vindo de outro.
]]
function PlayState:enter()
    -- se estamos vindo da morte, reinicia o scrolling do fundo
    scrolling = true
end

--[[
    chamado quando este estado muda para outro.
]]
function PlayState:exit()
    -- para o scrolling para a tela de morte/score
    scrolling = false
end