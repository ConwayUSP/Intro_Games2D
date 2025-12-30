--[[
    agora spawnamos pares de canos em vez de canos individuais.
    a logica de geracao aleatoria ficou mais inteligente para garantir
    que a abertura (gap) esteja sempre num lugar alcancavel.
]]

push = require 'push'
Class = require 'class'
require 'Bird'
require 'Pipe'

-- importamos a nova classe pipepair
require 'PipePair'

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
local GROUND_LOOPING_POINT = 514

local bird = Bird()

-- tabela para armazenar os pares de canos
local pipePairs = {}

local spawnTimer = 0

-- variavel para guardar a ultima posicao y gerada
-- isso serve para evitar que o proximo cano apareca muito longe do anterior
-- comecamos com um valor aleatorio
local lastY = -PIPE_HEIGHT + math.random(80) + 20

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Fifty Bird')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        love.event.quit()
    end
end

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
        % GROUND_LOOPING_POINT

    spawnTimer = spawnTimer + dt

    if spawnTimer > 2 then
        -- logica matematica para determinar a altura do proximo par de canos
        -- math.max e math.min garantem que o gap nao fique nem muito alto (fora da tela)
        -- nem muito baixo (no chao), e nem muito longe do ultimo par (lastY + random)
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        
        lastY = y
        
        -- adiciona o novo par a tabela
        table.insert(pipePairs, PipePair(y))
        spawnTimer = 0
    end

    bird:update(dt)

    -- atualiza cada par de canos
    for k, pair in pairs(pipePairs) do
        pair:update(dt)
    end

    -- remove pares que sairam da tela
    for k, pair in pairs(pipePairs) do
        if pair.remove then
            table.remove(pipePairs, k)
        end
    end

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)

    -- desenha todos os pares
    for k, pair in pairs(pipePairs) do
        pair:render()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()
    
    push:finish()
end