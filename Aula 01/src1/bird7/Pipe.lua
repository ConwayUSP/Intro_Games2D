Pipe = Class{}

-- carregamos a imagem externamente para nao pesar a memoria
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

-- velocidade de scroll global
PIPE_SPEED = 60

-- dimensoes globais do cano
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

function Pipe:update(dt)
    -- a logica de movimento x agora e controlada pelo pipepair
end

function Pipe:render()
    -- desenha o cano invertido (top) ou normal (bottom)
    love.graphics.draw(PIPE_IMAGE, self.x, 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 
        0, 1, self.orientation == 'top' and -1 or 1)
end