--[[
    nesta atualizacao (bird9), adicionamos o objetivo do jogo: pontuacao!
    quando o jogador perde, agora transitamos para um 'scorestate' que mostra
    quantos pontos ele fez.
]]

push = require 'push'
Class = require 'class'
require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'

-- importamos o novo estado de pontuacao
require 'states/ScoreState'
require 'states/TitleScreenState'

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

-- variavel de controle de scroll (nao esta sendo usada diretamente aqui no update
-- mas e bom manter para logica futura se quisermos pausar o fundo)
local scrolling = true

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Fifty Bird')

    -- carregamos as fontes retro para usar no jogo.
    -- smallfont para detalhes, flappyfont para titulos e hugefont para contagens futuras.
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- inicializamos a maquina de estados.
    -- agora adicionamos a entrada ['score'] que retorna nosso scorestate.
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    
    -- comecamos no menu inicial
    gStateMachine:change('title')

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
    -- atualiza o scroll do fundo e do chao (paralaxe)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % 
        BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

    -- atualiza a maquina de estados, que vai chamar o update do estado atual
    -- (seja ele o jogo rodando ou a tela de game over)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- desenha o fundo
    love.graphics.draw(background, -backgroundScroll, 0)
    
    -- renderiza o estado atual.
    -- note que o scorestate desenha o texto de "game over" por cima deste fundo.
    gStateMachine:render()
    
    -- desenha o chao por cima de tudo
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end