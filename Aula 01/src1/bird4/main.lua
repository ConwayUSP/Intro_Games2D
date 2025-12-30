--[[
    nesta versao (bird4), adicionamos a mecanica de "bater asas" (pular).
    para fazer isso de forma limpa, implementamos um sistema de input global
    que permite que qualquer classe (como a bird) verifique se uma tecla
    foi pressionada no frame atual.
]]

push = require 'push'
Class = require 'class'
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

local bird = Bird()

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Fifty Bird')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- inicializa uma tabela vazia para guardar as teclas pressionadas
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- adiciona a tecla a nossa tabela de teclas pressionadas neste frame
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    funcao personalizada para verificar se uma tecla foi pressionada
    consultando a nossa tabela global keysPressed.
    isso facilita o acesso ao input de qualquer lugar do codigo.
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
        % VIRTUAL_WIDTH

    bird:update(dt)

    -- reseta a tabela de teclas pressionadas para o proximo frame
    -- isso garante que o pulo so aconteça no frame em que apertamos o botao
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    bird:render()
    
    push:finish()
end