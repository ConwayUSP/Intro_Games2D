-- biblioteca para gerenciar a resolucao virtual
push = require 'push'

-- dimensoes fisicas da janela
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- dimensoes da resolucao virtual
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- imagens que carregamos na memoria para desenhar depois
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

function love.load()
    -- inicializa o filtro 'nearest' para manter a pixel art nitida e nao borrada
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- define o titulo da janela
    love.window.setTitle('Fifty Bird')

    -- inicializa a resolucao virtual com as configuracoes desejadas
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function love.resize(w, h)
    -- chama a funcao de redimensionamento do push quando a janela mudar de tamanho
    push:resize(w, h)
end

function love.keypressed(key)
    -- sai do jogo se a tecla esc for pressionada
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    -- inicia o desenho usando o sistema de resolucao virtual
    push:start()
    
    -- desenha o fundo no canto superior esquerdo (0, 0)
    love.graphics.draw(background, 0, 0)

    -- desenha o chao por cima do fundo, na parte de baixo da tela
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)
    
    -- finaliza o desenho
    push:finish()
end