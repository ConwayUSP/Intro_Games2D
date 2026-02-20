--[[
    esta versao (bird1) adiciona a ilusao de movimento ao jogo.
    usamos uma tecnica chamada "parallax scrolling" (rolagem de paralaxe),
    onde o fundo se move mais devagar que o chao para criar profundidade.
    alem disso, usamos o operador modulo (%) para fazer as imagens se repetirem
    infinitamente, criando um mundo sem fim.
]]

-- biblioteca para gerenciar a resolucao virtual
push = require 'push'

-- dimensoes fisicas da janela
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- dimensoes da resolucao virtual
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- carrega a imagem do fundo e define a posicao inicial de rolagem em x
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

-- carrega a imagem do chao e define a posicao inicial de rolagem em x
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

-- velocidade de rolagem (pixels por segundo)
-- o chao se move mais rapido que o fundo para criar o efeito 3d (paralaxe)
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- ponto onde a imagem do fundo deve "resetar" para criar o loop
-- 413 e a largura da imagem background.png
local BACKGROUND_LOOPING_POINT = 413

function love.load()
    -- usa filtro nearest para manter a arte pixelada nitida
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- titulo da janela
    love.window.setTitle('Fifty Bird')

    -- configura a resolucao virtual
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    -- atualiza a posicao do fundo usando velocidade * delta time
    -- o operador modulo (%) garante que o valor volte a 0 quando atingir o ponto de loop
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT

    -- faz o mesmo para o chao, mas usando a largura da tela como ponto de loop
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
        % VIRTUAL_WIDTH
end

function love.draw()
    push:start()
    
    -- desenha o fundo deslocado para a esquerda (valor negativo do scroll)
    -- isso cria a ilusao de que o mundo esta se movendo para a direita
    love.graphics.draw(background, -backgroundScroll, 0)

    -- desenha o chao por cima do fundo
    -- tambem deslocado pelo seu proprio valor de scroll (mais rapido)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end