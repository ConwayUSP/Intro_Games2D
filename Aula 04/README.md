# Aula 04: Super Mario Bros - O Mundo dos Plataformas

Bem-vindos à Aula 4! Hoje deixamos para trás as trocas de peças estáticas do Match-3 para entrar no gênero mais icônico da história dos videogames: **Jogos de Plataforma**.

E não vamos falar de qualquer plataforma. Vamos recriar a base do **Super Mario Bros. (NES, 1985)**.

### O Que Muda Nesta Aula?

Até agora, nossos jogos cabiam inteiros numa única tela (`Breakout`, `Pong`, `Match-3`) ou tinham um fundo infinito simples (`Flappy Bird`). Hoje, o desafio escala. Vamos construir um **Mundo** que é maior que a janela do jogo.

### Os 4 Pilares da Aula

Para fazer o Mario correr e pular, precisamos dominar quatro conceitos técnicos fundamentais:

1. **Tilemaps (Mapas de Azulejos):** Lembra da matriz do Match-3? Vamos usá-la de novo, mas de forma diferente. Em vez de peças para destruir, cada célula da matriz será um pedaço do cenário: chão, tijolo, cano ou céu. O "Tilemap" é a técnica padrão da indústria para construir mundos 2D gigantes de forma eficiente.
    
2. **Câmera e Scrolling (Rolagem):** Como o mundo é maior que a tela, precisamos de uma "Câmera" virtual. Aprenderemos a usar `love.graphics.translate` para criar a ilusão de movimento, fazendo o cenário andar para a esquerda enquanto o personagem avança para a direita.
    
3. **Geração Procedural de Níveis:** Não vamos desenhar a fase na mão! Vamos escrever um algoritmo que **gera o nível aleatoriamente** toda vez que o jogo começa. O computador decidirá onde colocar buracos, pilares e blocos surpresa, garantindo que o jogo seja sempre jogável, mas nunca igual.
    
4. **Física e Colisão Avançada:** A gravidade do Flappy Bird volta, mas agora o Mario não morre ao tocar no chão; ele _pisa_ nele. Precisamos detectar colisão de todos os lados:
    
    - Pisar em cima de um inimigo = Mata o inimigo.
        
    - Bater de lado no inimigo = Mario morre.
        
    - Pular e bater a cabeça num bloco = Quebra o bloco.

# Tiles 0 - O Mundo em Grade

Antes de fazer o nosso protagonista pular, precisamos de um chão para ele pisar. Em vez de desenhar uma imagem gigante para o cenário inteiro (o que gastaria muita memória), usamos uma técnica inteligente: montamos o cenário como um mosaico, usando pequenos blocos repetidos chamados **Tiles**.

### 1. O Problema da Imagem Única

Imagine carregar 100 imagens separadas: `chao.png`, `ceu.png`, `bloco.png`... Isso deixaria o jogo lento. A solução é usar uma **Sprite Sheet** (Folha de Sprites). Uma única imagem que contém todos os blocos do jogo.

### 2. A Solução: Quads (`Util.lua`)

No arquivo `Util.lua`, temos a função mágica `GenerateQuads`. Ela pega a imagem grande (`tiles.png`) e a "fatia" virtualmente em pedaços de 16x16 pixels.

- **O que é um Quad?** Apenas relembrando, é apenas um retângulo de coordenadas (x, y, largura, altura) que diz ao LÖVE: _"Desta imagem grande, desenhe apenas este pedacinho aqui"_.
    
- **Resultado:** Recebemos uma tabela `quads` onde `quads[1]` é o primeiro bloco, `quads[2]` é o segundo, etc.
    

``` lua
-- Util.lua
function GenerateQuads(atlas, tilewidth, tileheight)
    -- Loop que calcula a posição X e Y de cada pedacinho na imagem original
    -- Retorna uma lista de Quads prontos para uso
end
```

### 3. A Estrutura de Dados: Matriz (`main.lua`)

Como representamos o mundo na memória? Usamos uma **Matriz** (tabela de tabelas). No `love.load`, criamos duas tabelas aninhadas para representar as colunas (x) e linhas (y) da tela.

O código preenche essa matriz com **IDs**:

- As linhas de cima (y < 7) recebem o **ID 4** (Céu).
    
- As linhas de baixo (y >= 7) recebem o **ID 2** (Chão).
    

``` lua
-- main.lua
for y = 1, mapHeight do
    for x = 1, mapWidth do
        -- Define o ID do tile baseando-se na altura (Céu ou Chão)
        table.insert(tiles[y], {
            id = y < 7 and SKY_TILE or GROUND_TILE
        })
    end
end
```

### 4. A Renderização (`love.draw`)

Para desenhar, percorremos essa matriz. O segredo está na matemática de conversão: **Posição na Tela = (Índice da Matriz - 1) * Tamanho do Tile**

- Por que `- 1`? Porque em Lua os índices começam em 1, mas a coordenada da tela começa em 0.
    
- Se `x = 1`, desenhamos em `0`.
    
- Se `x = 2`, desenhamos em `16`.
    

``` lua
-- main.lua
for y = 1, mapHeight do
    for x = 1, mapWidth do
        local tile = tiles[y][x]
        -- Desenha o pedacinho (Quad) correto na posição calculada
        love.graphics.draw(tilesheet, quads[tile.id], 
            (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
    end
end
```


Assim, criamos um mundo estático dividindo-o em uma grade lógica. O computador "vê" uma tabela de números, mas nós vemos um céu azul e um chão marrom. Essa é a base sobre a qual o resto do jogo será construído.

# Tiles 1 - Movendo a Câmera (Scrolling)

Agora que sabemos desenhar um mapa, surge um problema: e se o nível for maior que a tela? O Super Mario não acontece em um único quarto, ele atravessa um reino inteiro. Para isso, precisamos de uma **Câmera Virtual**.

### 1. O Conceito de "Translate"

No LÖVE (e na maioria das engines 2D), não movemos uma "câmera". Na verdade, **movemos o mundo inteiro na direção oposta**.

Pense nisso como olhar por uma janela de trem:

- Se você quer ver o que está à direita, a paisagem precisa se mover para a esquerda.
    
- Se o nosso protagonista corre para a **Direita** (+X), o mundo precisa ser desenhado mais para a **Esquerda** (-X).
    

### 2. A Variável `cameraScroll`

No código, criamos uma variável para rastrear "quanto a câmera andou para a direita".


``` lua
-- main.lua
cameraScroll = 0
```

No `love.update`, detectamos as setas do teclado para alterar esse valor:

``` lua
-- main.lua
if love.keyboard.isDown('left') then
    cameraScroll = cameraScroll - SCROLL_SPEED * dt
elseif love.keyboard.isDown('right') then
    cameraScroll = cameraScroll + SCROLL_SPEED * dt
end
```

### 3. A Mágica do Desenho (`love.graphics.translate`)

É aqui que a ilusão acontece. Antes de desenhar qualquer tile, nós "empurramos" o sistema de coordenadas.

``` lua
-- main.lua
love.graphics.push()
    -- O Pulo do Gato: Note o sinal NEGATIVO (-)
    -- Se a câmera andou 100 pixels pra direita, empurramos o mundo -100 (pra esquerda)
    love.graphics.translate(-math.floor(cameraScroll), 0)
    
    -- Agora desenhamos o mapa normalmente (loops x e y)
    -- ... código de desenho dos tiles ...
love.graphics.pop()
```

**Por que `math.floor`?** Como `dt` (delta time) é um número decimal, `cameraScroll` pode virar algo como `10.453`. Desenhar em "meio pixel" cria um efeito visual feio (borrão ou _shimmering_). O `floor` arredonda para o número inteiro mais próximo, mantendo a pixel art nítida.

### 4. O `push` e `pop`

Note que envolvemos o desenho com `love.graphics.push()` e `love.graphics.pop()`.

- **Push:** Salva o estado atual (sem translação).
    
- **Translate:** Move o mundo.
    
- **Draw:** Desenha o mapa na nova posição.
    
- **Pop:** Restaura o estado original (reseta a translação para zero).
    

Isso é crucial! Se não fizéssemos o `pop`, a tela continuaria se movendo infinitamente a cada frame, somando o movimento anterior.


Assim, criamos um mundo de 20x20 blocos (maior que a tela) e implementamos a lógica de **translação de coordenadas**. Dessa forma, o jogador pode viajar pelo cenário usando as setas, vendo partes do mapa que estavam escondidas. Nosso mundo não é mais estático! ( • ᴗ - ) ✧

# Character 0 - O Nosso Herói Dá as Caras!

Agora que temos um mundo rolando (scrolling), precisamos de alguém para explorá-lo. Nesta etapa, vamos desenhar nosso personagem na tela e fazer a câmera segui-lo automaticamente, criando o efeito clássico de "Side Scroller".

### 1. Desenhando o Herói

Primeiro, carregamos a imagem do personagem (`character.png`) e geramos seus Quads (quadros de animação), mesmo que por enquanto usaremos apenas um quadro estático.

Definimos duas variáveis cruciais para sua posição no **Mundo** (não na tela):


``` lua
-- main.lua
characterX = VIRTUAL_WIDTH / 2 - (CHARACTER_WIDTH / 2)
characterY = VIRTUAL_HEIGHT - (CHARACTER_HEIGHT * 2)
```

_Note:_ Ele começa no meio da largura, mas "pisando" no chão (calculado subtraindo a altura dele da altura da tela).

### 2. A Lógica de Movimento

No `love.update`, mudamos a lógica. As teclas não movem mais a variável `cameraScroll` diretamente. Elas alteram o `characterX`.


``` lua
-- main.lua
if love.keyboard.isDown('left') then
    characterX = characterX - CHARACTER_MOVE_SPEED * dt
elseif love.keyboard.isDown('right') then
    characterX = characterX + CHARACTER_MOVE_SPEED * dt
end
```

Isso é física básica: `Posição = Posição + Velocidade * Tempo`.

### 3. A Câmera "Cameraman"

Aqui está o segredo dos jogos de plataforma. Não queremos que o Mario saia da tela enquanto o cenário fica parado. Queremos que ele fique (mais ou menos) no centro enquanto o mundo passa.

Para isso, **amarramos** a posição da câmera à posição do personagem:


``` lua
-- main.lua
cameraScroll = characterX - (VIRTUAL_WIDTH / 2) + (CHARACTER_WIDTH / 2)
```

**Entendendo a Fórmula:**

1. Pegue a posição do personagem (`characterX`).
    
2. Subtraia metade da largura da tela (`VIRTUAL_WIDTH / 2`).
    
3. Isso faz com que o ponto `0` da câmera (canto esquerdo) fique exatamente meia tela atrás do personagem.
    
4. Resultado: O personagem fica centralizado visualmente.
    

### 4. Renderização Relativa

No `love.draw`, continuamos usando o truque do `translate` que aprendemos no `tiles1`.


``` lua
love.graphics.translate(-math.floor(cameraScroll), 0)
    -- Desenha o mapa...
    
    -- Desenha o personagem na posição DO MUNDO
    love.graphics.draw(characterSprite, characterQuads[1], 
        math.floor(characterX), math.floor(characterY))
```

É importante notar que desenhamos o personagem em `characterX`.

- Se o personagem andou 1000 pixels para a direita, desenhamos ele no pixel 1000.
    
- Mas como a câmera também se moveu para o pixel ~850 (por causa do translate), ele aparece no meio da tela para o jogador.
    
Temos agora um avatar que se move pelo mundo. Porém, ele é um "fantasma":

1. Ele não tem animação (desliza estático).
    
2. Ele ignora a gravidade (flutua).
    
3. Ele atravessa paredes (sem colisão).
    

Esses são os problemas que resolveremos nos próximos passos.

# Character 1 - Física e Vida

No `character0`, nosso herói deslizava como um fantasma: sem mover as pernas e flutuando no ar. No **character1**, implementamos três pilares fundamentais de um jogo de plataforma: **Gravidade**, **Pulo** e **Animação**.

### 1. A Volta da Gravidade (Lembra do Flappy Bird?)

A física aqui usa exatamente a mesma lógica que aprendemos na Aula 1. Introduzimos a variável `characterDY` (Delta Y / Velocidade Vertical).

- **Gravidade:** A cada frame, aumentamos a velocidade de queda.
    
- **Pulo:** Ao apertar espaço, definimos a velocidade negativa instantânea (impulso para cima).
    

``` lua
-- main.lua
-- Aplica a gravidade constantemente
characterDY = characterDY + GRAVITY * dt
characterY = characterY + characterDY * dt

-- Input de Pulo
if love.keyboard.wasPressed('space') and characterDY == 0 then
    characterDY = -JUMP_VELOCITY
    currentAnimation = jumpingAnimation -- Muda a pose para "pulo"
end
```

**O "Chão Provisório":** Como ainda não temos colisão com os blocos (Tiles), definimos o chão matematicamente: _"Se o Y do personagem passar da altura do mapa - altura dele, pare."_


``` lua
if characterY > mapHeight - CHARACTER_HEIGHT then
    characterY = mapHeight - CHARACTER_HEIGHT
    characterDY = 0 -- Zera a velocidade ao tocar o chão
    currentAnimation = idleAnimation -- Volta a ficar parado
end
```

### 2. O Sistema de Animação

Para o Mario correr, não basta mover o X. Precisamos ciclar entre diferentes imagens (sprites). Criamos objetos de animação (usando a classe auxiliar `Animation`) para cada estado:

- **Idle (Parado):** Mostra apenas o quadro 1.
    
- **Moving (Andando):** Alterna entre os quadros 9 e 10 a cada 0.2 segundos.
    
- **Jumping (Pulando):** Mostra o quadro 3 (físico estático no ar).
    

No `love.update`, alternamos qual animação está ativa baseada no input:


``` lua
if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
    currentAnimation = movingAnimation
else
    currentAnimation = idleAnimation
end
currentAnimation:update(dt) -- Avança os frames da animação atual
```

### 3. O Truque do Espelhamento (Direction)

Nós não desenhamos sprites virados para a esquerda. Desenhamos tudo para a direita e usamos matemática para inverter. A variável `direction` guarda `'left'` ou `'right'`.

No `love.draw`, usamos o parâmetro de escala (sx) negativo:

- `1`: Escala normal (olha para a direita).
    
- `-1`: Inverte horizontalmente (olha para a esquerda).
    

**O Problema do Ponto de Origem:** Quando você inverte uma imagem (`scale -1`), ela é desenhada "para trás" do ponto X. Para corrigir isso, precisamos somar a largura do personagem ao X quando ele olha para a esquerda.


``` lua
-- main.lua
love.graphics.draw(characterSprite, currentAnimation:getCurrentFrame(), 
    -- Se olhar para a esquerda, soma a largura para compensar o flip
    math.floor(characterX) + (direction == 'left' and CHARACTER_WIDTH or 0),
    math.floor(characterY), 
    0, -- Rotação
    direction == 'left' and -1 or 1, -- Escala X (Flip)
    1 -- Escala Y
)
```


Temos agora um personagem completo em termos de controle:

1. Ele obedece à física (sobe e desce com gravidade).
    
2. Ele reage visualmente (corre, para, pula).
    
3. Ele olha para onde anda.

# Character 2 - O Mundo Sólido

Agora que nosso herói tem física, precisamos dar a ele um playground de verdade. Um chão plano é entediante. Nesta etapa, vamos:

1. Gerar um terreno irregular (buracos e pilares) aleatoriamente.
    
2. Impedir que o personagem atravesse paredes (Colisão Horizontal).
    

### 1. Geração Procedural de Nível

Adeus ao chão reto! No `love.load`, agora temos um algoritmo que decide como o mundo será construído, coluna por coluna.

O código percorre a largura do mapa e rola um dado (math.random) para decidir o que colocar:

- **Chão Padrão:** A maioria das vezes.
    
- **Abismo (Chasm):** 1 em 10 chances. Não desenha chão, criando um buraco onde o jogador pode cair.
    
- **Pilar:** 1 em 10 chances. Desenha uma coluna de blocos, criando um obstáculo físico.
    

``` lua
-- main.lua
if math.random(10) == 1 then
    -- Cria um buraco (não coloca tiles de chão)
    -- ...
elseif math.random(10) == 1 then
    -- Cria um pilar (coloca tiles empilhados)
    for y = mapHeight / 2 - 2, mapHeight do
        table.insert(tiles[y], {id = TILE_BRICK})
    end
end
```

Isso garante que cada vez que você der Play, a fase será diferente.

### 2. Matemática de Colisão: Pixel vs Grid

Aqui está o conceito mais importante de jogos baseados em Grid.

- O Personagem vive no mundo dos **Pixels** (ex: X = 154.5).
    
- O Mapa vive no mundo dos **Tiles** (ex: Coluna 5, Linha 7).
    

Para saber se colidimos, precisamos converter Pixel -> Tile. A fórmula mágica é: `math.floor(Pixel / TILE_SIZE) + 1`.

No código, criamos uma função auxiliar `map:tileAt(x, y)` que recebe uma coordenada de pixel e devolve o objeto Tile que está lá.

### 3. Colisão Horizontal (Parando na Parede)

No `love.update`, logo após mover o personagem, verificamos se ele entrou em uma parede. Usamos a técnica de **"Whiskers" (Bigodes) ou Pontos de Verificação**:

Não checamos o corpo todo do protagonista. Checamos dois pontos cruciais:

1. O canto superior direito/esquerdo (Cabeça).
    
2. O canto inferior direito/esquerdo (Pé).
    

**O Algoritmo de Resolução:** Se movermos para a direita e os pontos da direita tocarem em um tile sólido (`id ~= TILE_EMPTY`):

1. Detectamos a colisão.
    
2. **Teleportamos** o personagem para fora da parede imediatamente.
    
3. `characterX` é forçado a ficar exatamente encostado na esquerda do tile.
    

``` lua
-- main.lua (Lógica simplificada)
if love.keyboard.isDown('right') then
    -- 1. Move
    characterX = characterX + SPEED * dt
    
    -- 2. Verifica se o lado direito entrou num bloco sólido
    if map:collides(map:tileAt(characterX + WIDTH, characterY)) then
        -- 3. Empurra para fora (Resolução)
        characterX = (tile.x - 1) * TILE_SIZE - WIDTH
    end
end
```

### 4. O Que Falta? 

Se você rodar este código, vai notar algo estranho:

- Você bate nas paredes laterais (Nice!).
    
- Mas... você não consegue **pular em cima** dos pilares. Você atravessa o topo deles ou fica preso dentro.
    
- Se cair no buraco, você cai para sempre (não morre).
    

Isso acontece porque resolvemos apenas a colisão X (Horizontal). No `character3`, implementaremos a colisão Y (Vertical) para permitir pousar em plataformas.

# Character 3 - Colisão Vertical & Gravidade Real

O objetivo desta etapa é transformar o chão infinito matemático que usávamos antes em uma **interação física real com os blocos**. O personagem não para mais no `Y = 200`, e sim ele para onde houver um bloco sólido embaixo dele.

### 1. O Segredo da Movimentação: Separação de Eixos

Esta é a regra de ouro dos jogos de plataforma 2D: **Nunca mova X e Y ao mesmo tempo.**

Se você mover na diagonal e colidir, o código não sabe se você bateu no chão ou na parede. Por isso, dividimos o `update` em dois passos claros:

1. **Passo X:** Move horizontalmente -> Checa colisão lateral -> Corrige posição.
    
2. **Passo Y:** Aplica gravidade/pulo -> Checa colisão vertical -> Corrige posição.
    

### 2. Caindo (Colisão com o Chão)

No `love.update`, aplicamos a gravidade (`characterDY`) e movemos o personagem para baixo. Imediatamente depois, checamos: **"Meus pés tocaram em algo sólido?"**

Verificamos dois pontos: o canto inferior esquerdo e o canto inferior direito do personagem.

``` lua
-- main.lua (Lógica simplificada)
if characterDY > 0 then -- Se estou caindo
    -- Checa se tem bloco sólido embaixo dos pés
    if map:collides(tileBottomLeft) or map:collides(tileBottomRight) then
        
        -- 1. Pouso: Para a velocidade vertical
        characterDY = 0
        characterY = (tile.y - 1) * TILE_SIZE - CHARACTER_HEIGHT
        
        -- 2. Estado: Permite pular de novo
        jumping = false 
    end
end
```

**Por que checar dois pontos?** Imagine que o personagem está na beirada de um pilar, com apenas metade do corpo apoiada. Se checássemos apenas o centro, ele cairia através do bloco. Checando as duas pontas, ele consegue se equilibrar nas bordas.

### 3. Batendo a Cabeça (Colisão com o Teto)

A mesma lógica se aplica quando estamos subindo (`characterDY < 0`). Se o topo da cabeça bater em um bloco sólido:

1. **Zera a velocidade:** `characterDY = 0`. O pulo é cancelado instantaneamente.
    
2. **Empurra para baixo:** Move o personagem para logo abaixo do bloco.
    

Isso cria aquela sensação física de bater e cair (o famoso "Bonk").

### 4. A Lógica dos Buracos (Chasms)

Agora que a colisão é real, o que acontece se _não_ houver bloco embaixo? Simples: A gravidade continua agindo.

O código verifica:

- Se `characterY > mapHeight` (caiu para fora da tela), reiniciamos o jogo.

``` lua
-- main.lua
if characterY > mapHeight * TILE_SIZE then
    -- Morreu! Reseta posição e câmera.
    characterX = 0
    characterY = 0
    cameraScroll = 0
    -- Gera um novo mapa
    map = generateLevel()
end
```

### 5. Resolução de Conflitos (O "Snap")

Um detalhe técnico importante: Quando detectamos uma colisão, nós **teleportamos** (Snap) o personagem para a superfície do bloco.

- **No chão:** `y = (tile.y - 1) * TILE_SIZE - HEIGHT`
    
- **No teto:** `y = tile.y * TILE_SIZE`
    

Isso evita que o personagem fique "enterrado" ou vibrando dentro do bloco, garantindo uma física sólida e precisa.

E agora temos um jogo de plataforma funcional!

- Podemos andar e pular.
    
- Paredes nos barram.
    
- Podemos subir em plataformas.
    
- Podemos cair em buracos e "morrer" (resetar).

# Character 4 - Inimigos 

Chegamos ao ponto onde o protótipo vira um jogo de verdade. O **character4** resolve adicionando o elemento que faltava: **Perigo**.

### 1. Introduzindo Inimigos (Entities)

Agora o protagnosita não está mais sozinho. O código introduz o conceito de **Entidades**. Uma entidade (como o caracol/snail) funciona quase igual ao jogador:

- Tem X e Y.
    
- Tem velocidade (dx, dy).
    
- Tem animações.
    
- Sofre gravidade.
    
- Colide com o mapa.
    

A diferença é a "IA": O inimigo apenas anda para a esquerda até bater em uma parede, e então vira para a direita.

### 2. Colisão Jogador vs Inimigo (AABB)

Aqui entra a lógica clássica do Super Mario. Como saber quem ganhou a briga?

O código verifica a sobreposição dos retângulos (Hitboxes) do Jogador e do Inimigo. Se houver toque, analisamos a **Posição Vertical (Y)**:

- **Cenário A (Stomp):** O pé do Jogador está _acima_ da cabeça do Inimigo.
    
    - **Resultado:** O Jogador ganha um pequeno impulso para cima (pulo) e o Inimigo morre (toca som, some da tela).
        
- **Cenário B (Dano):** O Jogador toca o Inimigo pelos lados ou por baixo.
    
    - **Resultado:** O Jogador morre (reinicia o nível ou perde vida).

``` lua
-- Exemplo da lógica (simplificada)
if player:collides(enemy) then
    if player.y + player.height < enemy.y + 5 then
        -- O jogador está caindo EM CIMA do inimigo
        enemy:die()
        player:jump() -- Pulo extra
    else
        -- O jogador bateu de frente
        player:die()
    end
end
```

### 3. A Câmera Inteligente (Scroll Suave)

No `character3`, a câmera seguia o jogador rigidamente. Agora, usamos a classe `Camera` para criar um comportamento mais polido.

Note que usamos `math.floor` em todas as coordenadas de desenho (`love.graphics.translate`). Isso evita o **Pixel Shimmering** (aquela tremedeira estranha nos sprites quando a câmera se move devagar), garantindo que os pixels do jogo estejam sempre alinhados com os pixels do monitor.

# Level 0 - Geração Procedural Básica (Flat)

A partir daqui, não vamos mais carregar mapas prontos ou fixos. Vamos usar algoritmos para preencher a tabela `tiles` dinamicamente quando o jogo começa (`love.load`). Isso é a base para criar fases infinitas ou jogos roguelike.

### 1. A Lógica da Grade (Loops Aninhados)

Para criar o mapa, precisamos preencher nossa matriz 2D. O código percorre cada posição possível do mapa (Altura e Largura) e toma uma decisão sobre qual bloco colocar lá.


``` lua
-- main.lua
for y = 1, mapHeight do
    table.insert(tiles, {}) -- Cria uma nova linha
    
    for x = 1, mapWidth do
        -- O algoritmo decide o que colocar na posição [y][x]
    end
end
```

### 2. A Regra do Mundo Plano

Neste primeiro nível, a regra de geração é estática: "Tudo o que estiver acima da linha 7 é Céu. Tudo o que estiver na linha 7 ou abaixo é Chão".

Usamos um operador ternário (uma condição simplificada) para definir o ID do bloco:

``` lua
-- main.lua
table.insert(tiles[y], {
    -- Se y < 7 (parte de cima), usa o ID SKY. Senão, usa GROUND.
    id = y < 7 and SKY or GROUND
})
```

- **SKY (ID 2):** Bloco azul claro vazio (no nosso tileset).
    
- **GROUND (ID 1):** Bloco de tijolos marrons.
    

### 3. Renderização e Otimização (`math.floor`)

Um detalhe importante que reaparece aqui é o cuidado com a renderização da câmera. Como estamos gerando o mapa matematicamente e movendo a câmera com `dt` (números decimais), precisamos garantir que o desenho final esteja alinhado aos pixels do monitor para evitar distorções visuais (artefatos ou "tremeliques").


``` lua
-- main.lua
love.graphics.translate(-math.floor(cameraScroll), 0)
```

O uso de `math.floor` na translação da câmera é essencial para manter a _Pixel Art_ nítida.

### 4. O Sistema de Animação do Personagem (Refinado)

Embora o foco seja o mapa, o código traz um sistema de desenho do personagem bastante polido. Note como ele lida com a direção (olhar para esquerda/direita):

``` lua
-- main.lua
love.graphics.draw(characterSheet, characterQuads[currentAnimation:getCurrentFrame()], 
    math.floor(characterX) + CHARACTER_WIDTH / 2, -- X: deslocado pelo pivô
    math.floor(characterY) + CHARACTER_HEIGHT / 2, -- Y: deslocado pelo pivô
    0, -- Rotação
    direction == 'left' and -1 or 1, -- Escala X: -1 inverte a imagem (Espelho)
    1, -- Escala Y
    CHARACTER_WIDTH / 2, -- Pivô X (Centro da imagem)
    CHARACTER_HEIGHT / 2 -- Pivô Y (Centro da imagem)
)
```

**O Truque do Pivô:** Ao definir a origem (ox, oy) no centro do sprite (`WIDTH/2`), podemos inverter a escala X (`-1`) sem que o personagem "pule" de posição na tela. Ele gira em torno do próprio umbigo.


Conseguimos criar a folha em branco do nosso gerador de mundos. Temos um algoritmo que preenche o mapa automaticamente, mas ele ainda é "burro": ele faz sempre a mesma coisa (chão reto). Nos próximos passos (`level1` e `level2`), vamos inserir o ingrediente mágico: **Aleatoriedade (`math.random`)** para criar pilares e buracos.

# Level 1 - Pilares e Aleatoriedade

No `level0`, nosso gerador era previsível: "Chão na linha 7, Céu no resto". Agora, vamos introduzir a **Geração Procedural de Colunas**. Em vez de decidir o mapa inteiro de uma vez, vamos decidir coluna por coluna (X por X) se haverá um obstáculo ali.

### 1. A Estratégia de "Pintar por Cima"

Diferente do nível anterior, aqui começamos preenchendo **todo** o mapa com Céu (`SKY`).


``` lua
-- main.lua
-- Primeiro, cria uma matriz cheia de ar (SKY)
for y = 1, mapHeight do
    table.insert(tiles, {})
    for x = 1, mapWidth do
        table.insert(tiles[y], { id = SKY, topper = false })
    end
end
```

Isso facilita a lógica: não precisamos nos preocupar onde é céu, apenas onde _não_ é céu.

### 2. Iterando por Colunas (O Loop Principal)

A mágica acontece quando percorremos a largura do mapa (`mapWidth`). Para cada coluna `x`, nós "rolamos um dado":

``` lua
-- main.lua
for x = 1, mapWidth do
    -- 20% de chance (1 em 5) de gerar um pilar nesta coluna
    local spawnPillar = math.random(5) == 1
    
    -- ... lógica de construção ...
end
```

### 3. Construindo o Pilar

Se o dado cair no número certo (`spawnPillar` for true), nós desenhamos blocos extras acima do chão (das linhas 4 a 6).

``` lua
if spawnPillar then
    for pillar = 4, 6 do
        tiles[pillar][x] = {
            id = GROUND,
            -- Só coloca o "topo" (grama) se for o bloco mais alto (linha 4)
            topper = pillar == 4 and true or false
        }
    end
end
```

Isso cria barreiras verticais que o jogador terá que pular.

### 4. O Chão e a Lógica do "Topper" (Grama)

Independente de ter pilar ou não, sempre precisamos desenhar o chão base (linha 7 para baixo). Porém, temos um detalhe visual importante: a **Grama (Topper)**.

- Se **NÃO** tem pilar: O chão da linha 7 precisa de grama.
    
- Se **TEM** pilar: O chão da linha 7 é "terra batida" (sem grama), pois tem um pilar em cima dele.
    
``` lua
for ground = 7, mapHeight do
    tiles[ground][x] = {
        id = GROUND,
        -- Lógica Booleana: Só tem grama se NÃO tiver pilar E for a superfície (linha 7)
        topper = (not spawnPillar and ground == 7) and true or false 
    }
end
```

### 5. Renderização em Camadas

No `love.draw`, agora fazemos duas passagens de desenho por tile.

1. Desenhamos o Bloco Base (`tilesheet`).
    
2. Se `tile.topper` for true, desenhamos a Grama/Decoração (`topperSheet`) por cima.
    

``` lua
-- love.draw
love.graphics.draw(tilesheet, tilesets[tileset][tile.id], ...)

if tile.topper then
    love.graphics.draw(topperSheet, toppersets[topperset][tile.id], ...)
end
```


Agora temos um mapa que muda toda vez que apertamos 'R' (Reload). O algoritmo percorre o eixo X e decide aleatoriamente se levanta uma parede (Pilar) ou deixa o caminho livre, ajustando os gráficos (grama) automaticamente para que a transição visual faça sentido.


# Level 2 - O Abismo (Chasms)

A complexidade do nosso gerador de níveis aumentou. Agora temos três possibilidades para cada coluna do mapa:

1. **Chão Normal:** Caminho seguro.
    
2. **Pilar:** Um obstáculo para pular.
    
3. **Abismo:** Um buraco vazio (morte se cair).
    

### 1. A Lógica da Ausência

Como programamos um "buraco"? Simples: **Não fazemos nada.** Lembre-se que no início da função `generateLevel`, nós preenchemos a tabela inteira com `SKY` (Céu).

Para criar um buraco, basta "pular" a etapa de desenhar o chão naquela coluna específica. O código usa uma estrutura de controle chamada `goto` (que é rara, mas útil aqui) para pular para a próxima iteração do loop.

### 2. O Algoritmo de Geração (`generateLevel`)

Dentro do loop principal `for x = 1, mapWidth`, a primeira coisa que fazemos agora é checar se devemos criar um buraco.

``` lua
-- main.lua
-- 1 em 7 chances (aprox 14%) de ser um buraco
if math.random(7) == 1 then
    goto continue 
end
```

**O que o `goto continue` faz?** Ele diz ao computador: _"Pare tudo o que está fazendo nesta coluna AGORA e pule direto para a etiqueta `::continue::` lá no final do loop"_.

Isso faz com que o código **pule** as linhas que desenham o Pilar e o Chão. A coluna fica vazia (apenas Céu), criando visualmente o abismo.

### 3. A Estrutura Final do Loop

O fluxo de decisão para cada coluna X agora é:

1. **Rolar Dado do Abismo:** Caiu 1? -> `goto continue` (Vira buraco).
    
2. **Se não for buraco:**
    
    - Rolar Dado do Pilar: Caiu 1? -> Desenha Pilar.
        
    - Sempre desenha o Chão base (linhas 7 a 10).
        
3. **Etiqueta `::continue::`:** O ponto de encontro onde o loop termina e vai para o próximo X.
    

``` lua
    -- ... código do chão e pilar ...

    ::continue:: -- O 'goto' aterrissa aqui
end
```

### 4. Nota sobre Física (Importante!)

Se você rodar este código, verá os buracos gerados perfeitamente. Porém, se você tentar pular neles... **o Mario ainda flutua!**

Isso acontece porque, no `love.update` deste arquivo, a colisão ainda é "matemática simples":


``` lua
-- main.lua
if characterY > ((7 - 1) * TILE_SIZE) - CHARACTER_HEIGHT then
    characterY = ... -- Para o personagem numa linha imaginária
end
```

# Mario (Final) - Objetos e Interação

Se você abriu a pasta e se assustou com a quantidade de arquivos, pode ficar tranquilo kkkkkkk. Isso é um bom sinal. O código do `main.lua` estava ficando insustentável. O que fizemos foi arrumar a casa ( a famosa Refatoração) e separar as responsabilidades. Para não ficar muito extenso nem maçante, iremos dar uma olhada apenas nos arquivos mais "importantes" por assim dizer dessa parte final.

### 1. O Novo Gerente: `GameLevel.lua`

O `main.lua` não deve saber se tem um arbusto na posição (10, 5). Quem deve saber isso é o **Nível**. A classe `GameLevel` foi criada para ser um container que agrupa tudo o que existe em uma fase:

1. **`entities`**: Coisas vivas (Inimigos, Player).
    
2. **`objects`**: Coisas inanimadas (Arbustos, Blocos de Pulo, Gemas).
    
3. **`tileMap`**: O cenário estático (Chão, Paredes).
    
``` lua
-- GameLevel.lua
function GameLevel:update(dt)
    self.tileMap:update(dt)
    
    -- Atualiza todos os objetos (animações de blocos, gemas flutuando)
    for k, object in pairs(self.objects) do
        object:update(dt)
    end

    -- Atualiza todas as entidades (movimento do inimigo, física do player)
    for k, entity in pairs(self.entities) do
        entity:update(dt)
    end
end
```

### 2. O Arquiteto: `LevelMaker.lua`

Este é o cérebro da geração procedural. Ele ficou muito mais sofisticado do que apenas "colocar chão e buraco". Agora, enquanto ele percorre as colunas, ele decide onde instanciar **Game Objects**.

**O Poder das Callbacks (Funções dentro de Objetos):** O destaque aqui é como criamos os blocos de interrogação/pulo. Nós definimos o comportamento deles _no momento da criação_.

Veja o bloco de pulo (Jump Block) no código:

``` lua
-- LevelMaker.lua (Resumo)
GameObject {
    texture = 'jump-blocks',
    -- ...
    onCollide = function(obj) -- Callback: O que acontece se alguém bater aqui?
        if not obj.hit then
            -- Gera uma Gema (Gem) dinamicamente
            local gem = GameObject { ... }
            
            -- Toca som
            gSounds['powerup-reveal']:play()
            
            -- Adiciona a gema na lista de objetos do nível
            table.insert(objects, gem)
        end
        obj.hit = true
    end
}
```

Isso é incrivelmente poderoso. O objeto "sabe" como ele deve reagir, tirando essa lógica complexa de dentro do Player.

### 3. O Jogador Interativo: `Player.lua`

O Player agora precisa lidar com dois tipos de colisão:

1. **Contra o Mapa (Tiles):** Paredes e chão estáticos (como vimos no `character3`).
    
2. **Contra Objetos (GameObjects):** Arbustos, Blocos e Gemas.
    

No método `checkObjectCollisions`, o Player verifica a lista de objetos do nível e age de acordo com as "flags" (propriedades) do objeto:

- **`object.solid`:** Se for sólido (ex: Bloco de Pulo), o Player trata como uma parede e para o movimento.
    
- **`object.consumable`:** Se for consumível (ex: Gema), o Player "come" o objeto.
    

``` lua
-- Player.lua
function Player:checkObjectCollisions()
    for k, object in pairs(self.level.objects) do
        if object:collides(self) then
            -- Caso 1: Parede (Bloco)
            if object.solid then
                table.insert(collidedObjects, object)
            
            -- Caso 2: Item (Gema)
            elseif object.consumable then
                object.onConsume(self) -- Chama a função de ganhar pontos
                table.remove(self.level.objects, k) -- Remove a gema do mundo
            end
        end
    end
end
```

### 4. Resumo da Obra

O que construímos na Aula 4 não foi apenas um clone de Mario, foi uma **Engine de Plataforma**.

- **Tiles e Mapas:** Aprendemos a desenhar e colidir com um grid eficiente.
    
- **Câmera:** Aprendemos a criar o efeito de _scrolling_ e paralaxe.
    
- **Máquina de Estados:** Controlamos animações e comportamentos (Andando, Pulando, Caindo).
    
- **Geração Procedural:** Criamos mundos infinitos com lógica de preenchimento.
    
- **Sistema de Entidades:** Criamos classes bases para inimigos e objetos interativos.
