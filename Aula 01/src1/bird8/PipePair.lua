PipePair = Class{}

-- tamanho da abertura entre os canos
local GAP_HEIGHT = 90

function PipePair:init(y)
    -- inicializa os canos alem do final da tela a direita
    self.x = VIRTUAL_WIDTH + 32

    -- o valor y e para o cano de cima; o gap e um deslocamento vertical para o cano de baixo
    self.y = y

    -- instancia dois canos que pertencem a este par
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- flag para saber se este par de canos esta pronto para ser removido da cena
    self.remove = false
end

function PipePair:update(dt)
    -- remove o cano da cena se ele estiver alem da borda esquerda da tela,
    -- caso contrario, move-o da direita para a esquerda
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    -- desenha cada cano do par
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end