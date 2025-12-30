--[[
    nesta versao (bird5), introduzimos a geracao infinita de canos.
    usamos uma tabela para armazenar multiplos canos e um temporizador
    para saber quando criar um novo.
]]

push = require 'push'
Class = require 'class'
require 'Bird'
require 'Pipe'

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

-- tabela para armazenar os canos que estao em cena
local pipes = {}

-- temporizador para controlar a criacao de novos canos
local spawnTimer = 0

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
        % VIRTUAL_WIDTH

    -- incrementa o temporizador
    spawnTimer = spawnTimer + dt

    -- se o temporizador passou de 2 segundos, cria um novo cano
    if spawnTimer > 2 then
        table.insert(pipes, Pipe())
        print('Added new pipe!')
        spawnTimer = 0
    end

    bird:update(dt)

    -- percorre a tabela de canos para atualizar a posicao de cada um
    for k, pipe in pairs(pipes) do
        pipe:update(dt)

        -- se o cano saiu totalmente da tela pela esquerda
        if pipe.x < -pipe.width then
            -- remove o cano da tabela
            -- isso e crucial para nao encher a memoria do computador com canos invisiveis
            table.remove(pipes, k)
        end
    end

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)

    -- desenha todos os canos que estao na tabela
    for k, pipe in pairs(pipes) do
        pipe:render()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()
    
    push:finish()
end