Pipe = Class{}

-- como so queremos carregar a imagem uma vez, e nao a cada instanciacao,
-- definimos ela externamente.
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

-- velocidade que o cano deve rolar da direita para a esquerda
PIPE_SPEED = 60

-- altura da imagem do cano, acessivel globalmente
PIPE_HEIGHT = 430
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

function Pipe:update(dt)
    -- vazio, pois a posicao x agora e controlada pelo pipepair
end

function Pipe:render()
    -- desenha a imagem do cano
    -- verifica se a orientacao e 'top' (topo) para inverter a imagem verticalmente
    love.graphics.draw(PIPE_IMAGE, self.x, 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 
        0, 1, self.orientation == 'top' and -1 or 1)
end