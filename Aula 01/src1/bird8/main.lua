--[[

    nesta atualizacao (bird8), reestruturamos bastante o codigo.
    em vez de ter toda a logica solta no main.lua, implementamos uma
    state machine (maquina de estados). isso permite alternar facilmente
    entre o menu (titlescreen) e o jogo (playstate).
]]

push = require 'push'
Class = require 'class'
require 'Bird'
require 'Pipe'
require 'PipePair'

-- importamos a nossa maquina de estados e os estados individuais
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
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

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Fifty Bird')

    -- inicializa e carrega as fontes que usaremos nos estados
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

    -- inicializamos a maquina de estados global (gStateMachine)
    -- passamos uma tabela onde as chaves sao os nomes dos estados
    -- e os valores sao funcoes que retornam uma nova instancia do estado.
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
    }
    
    -- comecamos o jogo no estado de titulo (menu)
    gStateMachine:change('title')

    -- tabela global de input
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

-- funcao auxiliar para verificar input em qualquer lugar do projeto
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    -- o scroll do fundo e do chao continua aqui no main.lua
    -- porque queremos que o fundo se mova mesmo no menu principal,
    -- dando um efeito visual bonito e continuo entre estados.
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
        % VIRTUAL_WIDTH

    -- aqui esta a magica:
    -- o main.lua nao sabe se estamos jogando ou no menu.
    -- ele apenas diz para a maquina de estados: "atualize o estado atual"
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    
    -- desenha o estado atual (seja menu ou jogo) por cima do fundo
    gStateMachine:render()
    
    -- desenha o chao por cima de tudo
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end