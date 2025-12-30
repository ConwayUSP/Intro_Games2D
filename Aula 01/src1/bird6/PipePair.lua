--[[
    usado para representar um par de canos (um em cima e outro embaixo)
    que se movem juntos. isso cria a abertura para o jogador passar.
]]

PipePair = Class{}

-- tamanho da abertura entre os canos em pixels
local GAP_HEIGHT = 90

function PipePair:init(y)
    -- inicializa o par fora da tela, a direita
    -- o +32 e apenas uma margem de seguranca
    self.x = VIRTUAL_WIDTH + 32

    -- y e a posicao do cano de cima. o cano de baixo sera calculado com base nisso
    self.y = y

    -- instanciamos dois canos que pertencem a este par
    self.pipes = {
        ['upper'] = Pipe('top', self.y), -- cano de cima
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT) -- cano de baixo deslocado pelo gap
    }

    -- flag para saber se o par ja saiu da tela e pode ser removido
    self.remove = false
end

function PipePair:update(dt)
    -- se o par ainda esta na tela (considerando a largura do cano)
    if self.x > -PIPE_WIDTH then
        -- move o par para a esquerda
        self.x = self.x - PIPE_SPEED * dt
        
        -- atualiza a posicao x dos dois canos individuais
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        -- marca para remocao se saiu da tela
        self.remove = true
    end
end

function PipePair:render()
    -- desenha os dois canos do par
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end