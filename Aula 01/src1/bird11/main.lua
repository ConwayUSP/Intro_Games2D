--[[
    nesta atualizacao (bird11), o jogo ganha vida com audio! (agora sim, eba pra valer!)
    carregamos arquivos de som (wav e mp3) para efeitos e musica de fundo.
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

-- dimensoes da resolucao virtual
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

-- variavel global para controlar a rolagem do mapa
scrolling = true

function love.load()
    -- inicializa filtro nearest-neighbor para pixel art
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- inicializa a semente de aleatoriedade
    math.randomseed(os.time())

    -- titulo da janela
    love.window.setTitle('Fifty Bird')

    -- inicializa as fontes de texto
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- inicializa nossa tabela de sons
    -- 'static' significa que o arquivo inteiro e carregado na memoria (bom para efeitos curtos)
    -- 'stream' (geralmente usado para musica) carrega sob demanda, mas aqui o exemplo usou static
    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),

        -- musica de fundo
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }

    -- inicia a musica
    sounds['music']:setLooping(true) -- configura para repetir quando acabar
    sounds['music']:play() -- da o play inicial

    -- inicializa a resolucao virtual
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- inicializa a maquina de estados
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    -- inicializa tabela de input
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- adiciona a tecla a tabela de pressionadas
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
    -- so faz o scroll do fundo se a variavel scrolling for true
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    
    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end