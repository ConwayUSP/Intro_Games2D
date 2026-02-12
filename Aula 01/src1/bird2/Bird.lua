--[[
    a classe bird define o nosso "personagem" no jogo.
    nesta versao inicial (bird2), ele apenas carrega a imagem
    e aparece no centro da tela, sem fisica ou movimento.
]]

Bird = Class{}

function Bird:init()
    -- carrega a imagem do passaro do disco para a memoria
    self.image = love.graphics.newImage('bird.png')
    
    -- define a largura e altura do passaro usando as dimensoes da imagem
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- posiciona o passaro exatamente no meio da tela
    -- subtraimos metade da largura/altura dele para centralizar o ponto de origem
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
end

function Bird:render()
    -- desenha a imagem do passaro nas coordenadas x e y definidas no init
    love.graphics.draw(self.image, self.x, self.y)
end