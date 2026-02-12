--[[
    agora o nosso passaro pode bravamente desafiar a gravidade!
    adicionamos a verificacao de input no metodo update.
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

function Bird:update(dt)
    -- aplica a gravidade a velocidade atual
    self.dy = self.dy + GRAVITY * dt

    -- se a tecla espaco foi pressionada, aplicamos um impulso negativo (para cima)
    -- isso muda instantaneamente a velocidade, criando o efeito de pulo
    if love.keyboard.wasPressed('space') then
        self.dy = -5
    end

    -- aplica a velocidade atual a posicao y
    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end