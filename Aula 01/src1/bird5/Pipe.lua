--[[
    a classe pipe representa os canos que geramos aleatoriamente.
    eles atuam como obstaculos. quando saem da tela, devem ser removidos.
]]

Pipe = Class{}

-- carregamos a imagem fora da classe para nao carregar a mesma imagem
-- toda vez que criamos um novo cano (economiza memoria)
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

-- velocidade de rolagem horizontal dos canos
-- deve ser igual a do chao para manter a ilusao de movimento consistente
local PIPE_SCROLL = -60

function Pipe:init()
    -- comeca fora da tela, a direita
    self.x = VIRTUAL_WIDTH

    -- define o y aleatoriamente
    -- math.random retorna um valor entre os parametros passados
    self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 10)

    self.width = PIPE_IMAGE:getWidth()
end

function Pipe:update(dt)
    -- move o cano para a esquerda multiplicando pela velocidade e delta time
    self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end