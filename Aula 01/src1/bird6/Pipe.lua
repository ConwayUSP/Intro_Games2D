--[[
    a classe pipe agora suporta orientacao ('top' ou 'bottom').
    se for 'top', precisamos desenhar a imagem invertida verticalmente.
]]

Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

-- velocidade global dos canos (deve ser igual para todos para nao dessincronizar)
PIPE_SPEED = 60

PIPE_HEIGHT = 288
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

function Pipe:update(dt)
    -- a atualizacao de posicao x agora e controlada pelo pipepair
end

function Pipe:render()
    -- desenha o cano
    -- os parametros extras do love.graphics.draw sao: rotacao, escala x, escala y
    -- se orientation for 'top', usamos escala y = -1 para inverter a imagem
    love.graphics.draw(PIPE_IMAGE, self.x, 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 
        0, 1, self.orientation == 'top' and -1 or 1)
end