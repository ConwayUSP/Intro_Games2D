--[[
    na versao final (bird12), atualizamos o metodo update para aceitar
    cliques do mouse como comando de pulo.
]]

Bird = Class{}

local GRAVITY = 20

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.x = VIRTUAL_WIDTH / 2 - 8
    self.y = VIRTUAL_HEIGHT / 2 - 8

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.dy = 0
end

--[[
    colisao aabb que espera um cano como parametro.
    usa offsets (margens) para diminuir a caixa de colisao e ser mais generoso
    com o jogador.
]]
function Bird:collides(pipe)
    -- os 2 sao offsets para esquerda e topo
    -- os 4 sao offsets para direita e base
    -- ambos usados para encolher a bounding box
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    -- novidade do bird12:
    -- agora verificamos se a tecla espaco foi pressionada OU se o botao do mouse (1 = esquerdo) foi clicado
    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        self.dy = -5
        sounds['jump']:play()
    end

    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end