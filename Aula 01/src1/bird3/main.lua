--[[
    nesta versao (bird3), integramos a logica de atualizacao do passaro
    ao loop principal do jogo. agora que a classe bird tem fisica (gravidade),
    precisamos garantir que o metodo update dela seja chamado a cada frame.
]]

-- biblioteca push para resolucao virtual
push = require 'push'

-- biblioteca class para orientacao a objetos
Class = require 'class'

-- importamos nossa classe bird
require 'Bird'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

-- inicializa o passaro
local bird = Bird()

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Fifty Bird')

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
    -- atualiza o scroll do fundo
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT

    -- atualiza o scroll do chao
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
        % VIRTUAL_WIDTH

    -- novidade do bird3:
    -- chamamos o metodo update do passaro passando o delta time
    -- isso permite que a gravidade afete a posicao y do passaro frame a frame
    bird:update(dt)
end

function love.draw()
    push:start()
    
    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    -- desenha o passaro na sua nova posicao atualizada pela gravidade
    bird:render()
    
    push:finish()
end