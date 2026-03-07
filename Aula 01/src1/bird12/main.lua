--[[
    a atualizacao final do nosso jogo! (Parabéns por ter aguentado chegar até aqui kkkkk!)
    agora implementamos suporte completo ao mouse, permitindo jogar apenas com cliques.
    isso envolve capturar o input do mouse no love.load, love.update e criar funcoes auxiliares.
]]

push = require 'push'
Class = require 'class'
require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'
require 'Bird'
require 'Pipe'
require 'PipePair'

-- dimensoes fisicas da tela
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

-- variavel global de scroll
scrolling = true

function love.load()
    -- filtro nearest para pixel art
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- semente de aleatoriedade
    math.randomseed(os.time())

    -- titulo da janela
    love.window.setTitle('Fifty Bird')

    -- inicializa fontes
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- inicializa tabela de sons
    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),

        -- musica de fundo
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }

    -- inicia musica em loop
    sounds['music']:setLooping(true)
    sounds['music']:play()

    -- configura resolucao virtual
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- inicializa maquina de estados
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    -- inicializa tabela de input do teclado
    love.keyboard.keysPressed = {}

    -- novidade do bird12: inicializa tabela de input do mouse
    love.mouse.buttonsPressed = {}
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

--[[
    callback do love2d disparado quando um botao do mouse e pressionado.
    nos da o x, y e o numero do botao (1 = esquerdo, 2 = direito, etc).
]]
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--[[
    equivalente a nossa funcao do teclado, mas para botoes do mouse.
]]
function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    end

    gStateMachine:update(dt)

    -- reseta as tabelas de input no final do frame
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()
    
    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end