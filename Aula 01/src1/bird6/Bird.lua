--[[
    nesta versao (bird6), o passaro ainda nao colide com nada,
    apenas voa entre os pares de canos que estao sendo gerados.
]]

Bird = Class{}

-- a gravidade que puxa o passaro para baixo a cada frame
local GRAVITY = 20

function Bird:init()
    -- carrega a imagem do passaro do disco
    self.image = love.graphics.newImage('bird.png')
    
    -- guarda a largura e altura para usarmos depois (centralizacao, colisoes futuras)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- posiciona o passaro exatamente no meio da tela
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- velocidade vertical (dy) comeca em 0 (parado)
    self.dy = 0
end

function Bird:update(dt)
    -- aplica a gravidade a velocidade atual
    -- isso faz o passaro cair cada vez mais rapido
    self.dy = self.dy + GRAVITY * dt

    -- se a tecla espaco foi pressionada neste frame (usando nosso input global)
    if love.keyboard.wasPressed('space') then
        -- define a velocidade vertical para cima (valor negativo)
        -- isso cria o efeito de pulo instantaneo
        self.dy = -5
    end

    -- aplica a velocidade atual a posicao y do passaro
    self.y = self.y + self.dy
end

function Bird:render()
    -- desenha a imagem na posicao atual x, y
    love.graphics.draw(self.image, self.x, self.y)
end