--[[
    esta atualizacao introduz a classe bird.
    agora temos um objeto separado para o jogador, em vez de desenhar
    coisas aleatorias no main.lua.
]]

-- biblioteca push para resolucao virtual
push = require 'push'

-- biblioteca class para permitir orientacao a objetos em lua
Class = require 'class'

-- importamos a nossa classe bird
require 'Bird'

-- dimensoes fisicas
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- dimensoes virtuais
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

-- criamos uma nova instancia da classe bird
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
    
    -- nota: ainda nao chamamos bird:update(dt) porque o passaro nao tem fisica
    -- ele apenas fica parado no centro enquanto o mundo se move
end

function love.draw()
    push:start()
    
    -- desenha o fundo
    love.graphics.draw(background, -backgroundScroll, 0)

    -- desenha o chao por cima do fundo
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    -- renderiza o passaro na tela
    bird:render()
    
    push:finish()
end