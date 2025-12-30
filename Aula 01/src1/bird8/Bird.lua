--[[
    a classe bird nao muda muito nesta versao.
    ela continua responsavel pela fisica, renderizacao e colisao do passaro.
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

-- funcao de colisao aabb com "leeway" (folga)
function Bird:collides(pipe)
    local left = self.x + 2
    local right = (self.x + 2) + (self.width - 4)
    local top = self.y + 2
    local bottom = (self.y + 2) + (self.height - 4)

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