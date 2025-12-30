Bird = Class{}

-- a gravidade e uma constante que acelera o passaro para baixo a cada frame
local GRAVITY = 20

function Bird:init()
    -- carrega a imagem e define dimensoes
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- posiciona no centro da tela
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- inicializa a velocidade vertical (delta y) como 0
    -- isso significa que ele comeca o jogo parado no ar antes de cair
    self.dy = 0
end

function Bird:update(dt)
    -- aplica a gravidade a nossa velocidade atual
    -- isso faz com que a velocidade de queda aumente constantemente
    self.dy = self.dy + GRAVITY * dt

    -- aplica a velocidade atual a posicao y
    -- lembre-se: no love2d, y aumenta para baixo
    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end