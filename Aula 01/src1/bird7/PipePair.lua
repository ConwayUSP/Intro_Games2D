--[[
    classe para gerenciar o par de canos (cima e baixo).
    ela e fundamental para manter os canos sincronizados e criar o 'gap'
    por onde o passaro deve passar.
]]

PipePair = Class{}

-- tamanho da abertura entre os canos
local GAP_HEIGHT = 90

function PipePair:init(y)
    -- inicia fora da tela a direita
    self.x = VIRTUAL_WIDTH + 32

    -- y do cano superior. o inferior sera calculado com base neste + gap
    self.y = y

    -- cria os dois objetos pipe
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- flag para remocao quando sair da tela
    self.remove = false
end

function PipePair:update(dt)
    -- se o par ainda esta visivel na tela
    if self.x > -PIPE_WIDTH then
        -- move o par para a esquerda
        self.x = self.x - PIPE_SPEED * dt
        
        -- atualiza a posicao x dos canos individuais para acompanhar o par
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        -- marca para remocao se ja passou totalmente pela esquerda
        self.remove = true
    end
end

function PipePair:render()
    -- desenha os dois canos
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end