--[[
    nesta atualizacao (bird10), adicionamos um estado de contagem regressiva
    para que o jogador tenha tempo de se preparar antes de o jogo comecar.
]]

-- biblioteca de resolucao virtual
push = require 'push'

-- biblioteca classica de oop (orientacao a objetos)
Class = require 'class'

-- classe do passaro que escrevemos
require 'Bird'

-- classe do cano
require 'Pipe'

-- classe que representa o par de canos
require 'PipePair'

-- todo o codigo relacionado a gerenciamento de estados
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

-- novidade do bird10: importamos o estado de contagem regressiva
require 'states/CountdownState'

-- dimensoes fisicas da janela
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- dimensoes da resolucao virtual
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- imagem de fundo e localizacao inicial de rolagem (eixo x)
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

-- imagem do chao e localizacao inicial de rolagem
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

-- velocidade na qual devemos rolar nossas imagens, escalada pelo dt
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- ponto em que devemos fazer o loop do fundo voltar para x 0
local BACKGROUND_LOOPING_POINT = 413

-- ponto em que devemos fazer o loop do chao voltar para x 0
local GROUND_LOOPING_POINT = 514

-- variavel de rolagem para pausar o jogo quando colidirmos com um cano
local scrolling = true

function love.load()
    -- inicializa nosso filtro nearest-neighbor (pixel art nitida)
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- titulo da janela do aplicativo
    love.window.setTitle('Fifty Bird')

    -- inicializa nossas fontes de texto retro
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- inicializa nossa resolucao virtual
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- inicializa a maquina de estados com todas as funcoes que retornam estados
    -- agora incluimos o 'countdown' na lista
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    
    -- comecamos pela tela de titulo
    gStateMachine:change('title')

    -- inicializa a tabela de input
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- adiciona a nossa tabela de teclas pressionadas neste frame
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    nova funcao usada para verificar nossa tabela global de input por teclas
    que ativamos durante este frame, buscadas pelo seu valor em string.
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    -- atualiza os deslocamentos de rolagem do fundo e do chao
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % 
        BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

    -- agora, apenas atualizamos a maquina de estados, que delega
    -- para o estado correto (title, countdown, play ou score)
    gStateMachine:update(dt)

    -- reseta a tabela de input
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- desenha a maquina de estados entre o fundo e o chao.
    -- isso delega a logica de renderizacao para o estado ativo.
    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end