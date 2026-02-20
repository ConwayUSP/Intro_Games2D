--[[
    representa um par de canos (cima e baixo) que se movem juntos.
    agora no bird9, o par de canos tambem sabe se ja foi "pontuado" pelo jogador.
]]

PipePair = Class{}

-- tamanho da abertura entre os canos
local GAP_HEIGHT = 90

function PipePair:init(y)
    -- inicializa o par fora da tela a direita
    self.x = VIRTUAL_WIDTH + 32

    -- y do cano superior
    self.y = y

    -- instancia os dois canos (topo e base)
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- flag para saber se o par saiu da tela e deve ser removido
    self.remove = false

    -- flag nova: indica se este par ja contou ponto para o jogador
    -- comeca como false, vira true assim que o passaro passa por ele
    self.scored = false
end

function PipePair:update(dt)
    -- se o par ainda esta na tela, move para a esquerda
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        -- marca para remover se saiu da tela
        self.remove = true
    end
end

function PipePair:render()
    -- desenha os canos do par
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end