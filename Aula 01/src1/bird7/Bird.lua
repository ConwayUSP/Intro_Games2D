--[[
    a classe bird controla o personagem.
    no bird7, adicionamos a funcao collides para detectar colisoes
    com os canos usando logica aabb (axis-aligned bounding box).
]]

Bird = Class{}

local GRAVITY = 20

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

--[[
    funcao de colisao aabb que espera receber um cano como parametro.
    retorna true se houver colisao, false caso contrario.
]]
function Bird:collides(pipe)
    -- definimos offsets (margens) para a nossa caixa de colisao.
    -- o '+2' e '-4' servem para encolher a caixa de colisao do passaro.
    -- isso da uma "folga" (leeway) ao jogador, para nao morrer se passar
    -- raspando nos pixels transparentes ou na borda do sprite.
    local left = self.x + 2
    local right = (self.x + 2) + (self.width - 4)
    local top = self.y + 2
    local bottom = (self.y + 2) + (self.height - 4)

    -- logica padrao de colisao de retangulos:
    -- verifica se as bordas do passaro e do cano se sobrepoem
    if right >= pipe.x and left <= pipe.x + PIPE_WIDTH then
        if bottom >= pipe.y and top <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = -5
    end

    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end