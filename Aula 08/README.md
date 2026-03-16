# Aula 08: Helicopter Game 3D

Olá, novamente, querido aluno! Você retornou mais uma vez para seguir para a próxima etapa deste curso. Espero que tenha aprendido sobre todos os fundamentos e dominado o LÖVE, porque agora vamos começar uma nova jornada no desenvolvimento de jogos: a criação de **Jogos 3D**!

Jogos 3D são provavelmente tão populares (senão mais) que os jogos 2D, eles trazem uma mudança de paradigmas e apresentam diversos outros desafios, por isso, o resto desse curso vai desbravar a terceira dimensão enquanto te torna um programador mais qualificado.

Dito isso, na aula de hoje vamos aprender sobre:
- O Godot Game Engine
- A Linguagem GDScript
- Mundo e Câmeras
- Modelos 3D
- Partículas
- Efeitos Sonoros

## O Godot Game Engine

Uma pedra no meio do nosso caminho é que o framework LÖVE **não** possui ferramentas para criar jogos 3D :cry:. Então para continuar nosso aprendizado vamos ter que migrar para uma outra ferramenta, caso você tenha lido a introdução desse curso você já sabe qual: o **Godot Game Engine**.

> ℹ️
> **O que é um *Game Engine***?
> Uma *Engine* é um conjunto de ferramentas que atua como base para a criação de jogos, oferecendo funcionalidades pré-construídas que agilizam o trabalho do desenvolvedor, geralmente acompanham um software de teste e visualização.

O [Godot](https://godotengine.org/) é uma *Engine* criada em 2006, de código-aberto e gratuita[^1], que evoluiu para ser um dos *Big Three* das *Engines* de jogos (opinião baseada totalmente em 
opiniões do Reddit). Ele inclui ferramentas para criação de jogos 2D e 3D, efeitos sonoros, animações e outros recursos visuais. Inclusive, oferece suporte para desktop, mobile e web!

![](assets/the-big-three-game-engines.png)

Vamos primeiro entender como o Godot funciona e como usá-lo para depois partir para o jogo em si.

### Instalação

O Godot pode ser baixado através do seu site oficial, na [página de downloads](https://godotengine.org/download/linux/), tanto para Linux, Windows e Mac. Baixe em seu computador. Curiosamente, ele também está disponível na *Steam*!

### Blocos básicos do Godot

Com o Godot instalado vamos explicar um pouco da sua teoria. O Godot é fundamentalmente construído em cima de dois componentes: **Nós** (Nodes), **Cenas** (Scenes) e **Sinais** (Signals).

#### Nós/Nodes

Eles são blocos de LEGO para formar o seu jogo. Existem dezenas e dezenas de tipos diferentes, cada um representando um elemento do jogo, ex.: uma imagem, um som, câmera, objeto. Você pode combinar essas peças colocando uma dentro da outra formando uma espécie de árvore.

![](assets/exemplos-de-nos.png)

Exemplo de nós do Godot. Fonte: https://docs.godotengine.org/pt-br/4.x/getting_started/step_by_step/nodes_and_scenes.html

Os nós possuem algumas características &mdash; como o nome &mdash; que você pode editar através da interface gráfica (UI) ou por meio de código. Nós vamos explicar o que cada tipo de nó faz, como utilizá-los e mais durante o curso, o mais importante é que você entenda o conceito!

#### Cenas e Árvore de Nós

Uma Cena é nada mais que essa árvore de nós que você viu na imagem acima, chamamos o nó mais externo de **raiz** e os outros são **filhos** (que também possuem **filhos**). A Cena também pode ser vista como um *arquivo*, marcado com a extensão `.tscn`, esse arquivo descreve os nós contidos nele, as alterações feitas em cada um e a hierarquia entre os mesmos. Através desse arquivo de cena podemos **instanciar** uma cena para dentro de outra. Isso é semelhante a importar um arquivo no Lua. Com isso, podemos reutilizar código através do nosso projeto &mdash; e de outros jogos &mdash; bem como algumas coisas a mais que farão sentindo em aulas futuras.

Se você quer beber direto da fonte do conhecimento, [aqui](https://docs.godotengine.org/pt-br/4.x/getting_started/step_by_step/nodes_and_scenes.html) vai a explicação oficial do Godot sobre o assunto.

#### Signals/Sinais

Por último, temos os **Signals**. Um nó emite um **signal** ou **sinal** quando algum evento ocorre, o que permite nós se comunicarem entre si. Vários nós possuem sinais padrão os quais você pode se "cadastrar" para ouvir com uma função, você também pode criar os seus próprios com a palavra reservada `signal`.

### Apresentando o GDScript

Todo *Game Engine* tem uma linguagem de programação nativa para estender as funcionalidades dos componentes. O Godot suporta uma variedade de linguagens, porém nesse curso vamos dar atenção a sua linguagem nativa: **GDScript**. O GDScript é uma linguagem de programação criada para prototipação e rápido desenvolvimento de jogos feitos em Godot. Isso dito, ela é uma linguagem orientada-a-objetos, de tipagem gradual e se assemelha muito a sintaxe do Python.

#### Sintaxe do GDScript

Todo arquivo do GDScript é marcado pela extensão `.gd`. Vamos passar rapidamente por cima da sintaxe do GDScript, adaptado diretamente da [documentação](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html) oficial do Godot.

```gdscript
# 1º Isso é um comentário
# No GDScript TODO arquivo é uma CLASSE

class_name MinhaClasse # Opcional

# Herdamos as propriedades de outra class (geralmente outros nodes)
extends BaseClass

# Tipos e variáveis
var a = 5
var string = "Olá, mundo"
var b = true
var arr = [1, 2, 3] # umas lista
var dict = {"key": "value", 2: 3} # dicionário
var vec = Vector3(1, 2, 3) # criando um vetor
var num: int = 5 # marcando o tipo da variável

# constantes (não podem ser alteradas)
const ANSWER = 42
# um tipo enumerado, util para máquinas de estado!
enum Cores {VERMELHO, AZUL, AMARELO}

func funcao(arg1, arg2, arg3, arg4):
	# condicionais
	if arg1 < arg2:
		print(arg1)
	elif arg1 == arg2:
		print(arg2)
	else:
		print(arg3)

	# loops
	for a in arr:
		print(a)
	
	while arg2 > 0:
		arg2 = arg2 - 1
	
	# Match (parece um if mas é mais bonito)
	match arg4:
		Cores.VERMELHO: print("a")
		Cores.AZUL: print("b")
		Cores.AMARELO: print("c")
	
	print(add(1, 2))

func add(a: int, b: int) -> int:
	return a + b
```

Essa foi apenas uma revisão rápida da linguagem, vamos ensinar mais durante as aulas, mas se você quer dominá-la por completo veja esse [artigo](https://docs.godotengine.org/pt-br/4.x/tutorials/scripting/gdscript/gdscript_advanced.html).

### Navegando pelo Editor

Uma última coisa antes de começar a trabalhar é falar um pouco sobre o **Editor** do Godot. Considerando que você vai passar algumas boas horas da sua vida olhando para ele é ideal conhecê-lo bem.

![godot-editor-markup](assets/godot-editor-markup.png)

A imagem acima mostra a tela principal do editor e os componentes principais foram marcados e enumerados de vermelho, segue uma explicação de cada um:

1. **Troca de Área de Trabalho**: permite você mudar de área de trabalho, para um aba 2D, 3D, scripts e para rodar o seu jogo. Bem como uma página de plugins
2. **Barra de Ferramentas**: permite você mover, rotacionar e ajustar componentes na área de visualização
3. **Árvore de Nós**: te dá uma visão da hierarquia de nós da sua cena, bem como permite adicionar mais nós, movê-los e instanciar cenas
4. **Arquivo do Sistema**: uma visão da pasta do projeto, permite adicionar arquivos e pastas, é assim que o projeto aparece no seu computador
5. **Cena**: permite ver a cena, posicionar objetos e entre outros
6. **Inspetor**: permite editar as propriedades de um nó/cena, você vai usar ela muito nesse curso.

Uma menção honrosa ao canto superior direito que permite rodar e gravar o seu jogo, e ao esquerdo que contém as configurações do projeto, que vamos usar mais a frente. Caso queira ler sobre esse assunto por completo, clique [aqui](https://docs.godotengine.org/pt-br/4.x/getting_started/introduction/first_look_at_the_editor.html).

## Helicóptero 3D: o jogo

A melhor forma de aprender é botando a mão na massa. O jogo que iremos implementar se chama **Helicóptero 3D**, um jogo de navegador e precursor do *Flappy Bird*. Na verdade, ele está mais para 2.5D, isso é porque ainda vamos nos movimentar em apenas duas dimensões (cima, baixo, direita, esquerda), mas os modelos ainda vão ser em 3D.

Antes de começar o projeto, dê uma olhada na pasta `src8` com o código dessa aula, abra-o com o Godot e veja como tudo foi feito. Em seguida, pegue os *assests*  (todas as pastas) e leve para a sua implementação.

### Criando o projeto

Primeiro de tudo, vamos iniciar o projeto. Abra o aplicativo do Godot, você verá o **Gerenciador de Projetos** com tela, clique em `Create +`. Dê um nome ao projeto, como "helicopter" e defina em qual pasta do seu computador ele vai estar. Depois disso, clique em `Create`. Você verá o Editor como uma tela em branco, pronto para começar a pintar!

### Cena Principal

Vamos começar com a tela principal, ela será uma imagem de fundo que se move para a esquerda infinitamente. Bem como, haverá um componente de UI mostrando quantas moedas o jogador adquiriu. Como na imagem abaixo:

![](assets/background-wth-coin.png)

Plano de fundo. Fonte: Autoral.

#### Za Waruudoo (O Mundo)

![](assets/dio-brando.png)

Za Warudoo. Fonte: https://www.pxfuel.com/en/desktop-wallpaper-ppvct

Vamos criar a **cena principal**, onde todos os componentes do jogo vão interagir entre si. A primeira coisa que vamos precisar é de um *Mundo*, no Godot, um mundo é um ambiente em que podemos definir um conjunto de propriedades, ex.: pós-processamento de efeitos, iluminação e como renderizar o plano de fundo. Precisamos disso para combinar o plano de fundo 2D e objetos 3D. 

Após essa explicação, você verá um conjunto de opções para criar sua primeira cena, escolha `Other nodes`, e pesquise por [WorldEnvironment](https://docs.godotengine.org/en/stable/classes/class_worldenvironment.html#worldenvironment). Renomeie-o &mdash; usando `F2` ou clicando duas vezes no nó &mdash; para *Main*. Em seguida, clique em *Main*, vá para o *Inspetor*, procure pela propriedade `Environment`, clique no valor `<empty>` e no dropdown selecione `Environment` para criar um novo ambiente.

![](assets/world-environment.png)

Criando um *Environment*. Fonte: Autoral

Isso vai gerar um novo conjunto de propriedades, que pode ser aberto ao clicar em `Environment`, dentro da aba `Background`, procure por `Mode` e selecione a opção `Canvas`. Essa opção permite mostrar um nó do tipo `CanvasLayer` como plano de fundo do espaço 3D.

![](assets/environment-options.png)

Configurando o modo de plano de fundo. Fonte: Autoral.

#### Plano de Fundo

Crie um novo nó do tipo `CanvasLayer` (aperte `Ctrl-A` ou no `+` na árvore de nós) e renomeie para `Background`, a seguir vá nas propriedades, modifique `Layer` para `-1`. Desse modo, o plano de fundo vai estar realmente atrás de todos os objetos do jogo.

Feito isso, selecione esse nó e adicione como filho dele um nó do tipo `TextureRect`. Nas propriedades, procure por `Texture`, selecione e clique na opção `Load`, isso vai abrir um popup com uma visão da pasta do projeto, escolha a imagem na pasta `textures` de nome `City1.png`. Em seguida, vá na propriedade `Stretch Mode` e selecione `Tile` (vai servir para animação), após isso, procure nas propriedades de `Layout`, o nome `Anchors Preset` e selecione `Full Rect`. A imagem deve agora estar centralizada na tela, mesmo que transbordando do quadrado central.

Em outras palavras, o que fizemos aqui foi:
- Criar uma tela 2D para desenharmos sobre ([CanvasLayer](https://docs.godotengine.org/en/4.3/classes/class_canvaslayer.html));
- Adicionar uma imagem rectangular ([TextureRect](https://docs.godotengine.org/en/stable/classes/class_texturerect.html)); e
- Ajustar a imagem para preencher a tela por completo.

> [!info]
> `CanvasLayer`faz o que o nome sugere, é uma tela que permite "desenhar" ou colocar componentes sobre. Permitindo posicioná-los uns sobre os outros através da propriedade `Layer`.

Se você salvar a cena com o nome `main.tscn` e apertar `F5` (ou `F6`), você verá justamente a nossa imagem como plano de fundo.

![](assets/City1.png)

Plano de fundo do jogo. Fonte: CS50G Games

Agora para o efeito de movimentação, vá nas propriedades de *TextureRect* e procure por `Material` (encontra-se na aba de mesmo nome), clique e selecione `ShaderMaterial`, isso vai abrir uma nova sub-lista de propriedades (caso contrário, clique na bola branca ao lado de *Material*), procure por `Shader` e clique em `Quick Load` &mdash; para mostrar apenas arquivos aceitos por essa propriedade &mdash; e selecione `background.gdshader`. Imediatamente após fazer isso, o plano de fundo vai começar a se mover.

O que acabamos de fazer? Para não entrar em detalhes do que vai ser **explicado nas próximas aulas**. Alteramos as propriedades da nossa imagem com um script especial (uma *Shader*), que vai fazer ela (a imagem) se mover infinitamente para a esquerda, e como ativamos a propriedade `Tile` anteriormente, ela entra em *loop* de repetição.

> [!Tip]
> Se você não aguenta esperar e está morrendo de curiosidade, recomendo olhar a aula 10 deste curso. Onde explicamos melhor o que são e como funcionam as shaders.

![](assets/shadermaterial.png)

Criando um novo `ShaderMaterial`  no Godot. Fonte: Autoral.

#### HUD

Com nosso plano de fundo girando, partiremos para a *HUD* (Heads Up Display) que vai informar sobre o número de moedas adquiridos pelo jogador, bem como mostrar uma mensagem no centro da tela, durante o começo e final do jogo.

![](assets/start-menu.png)

HUD inicial. Fonte: Autoral

Para fazer isso, crie outro `CanvasLayer` e nomeio-o de `HUD`, dessa vez coloque a propriedade `Layer` para `1` (para ele estar a frente de todos os objetos). Crie um nó filho do tipo `Control` (serve para posicionar elementos de [GUI](https://pt.wikipedia.org/wiki/Interface_gr%C3%A1fica_do_utilizador)), dentro dele, coloque dois nós filhos, ambos do tipo `Label` &mdash; esse tipo é uma caixa de texto. Nomeie-os `StartMessage` e `RestartMessage`, então inclua na propriedade `Text` as respectivas sentenças: `Press [Enter]\nto Start` e `Game Over!\nPress [Enter] to Restart.` (entenda o `\n` como quebra de linha).

Selecione novamente `Control`, na barra de ferramentas procure pelo seguinte ícone verde: ![](assets/anchormenu.png). Clique nele para abrir os *Presets de Âncora*, ou seja posições padrão da tela (centro, esquerda, canto superior direito, etc), selecione `Full Rect`, faça o mesmo para os dois *labels*, de forma a centralizá-los na tela.

Agora para a configuração de texto. Nas propriedades de cada *label*:
- Marque `Horizontal Alignment` e `Vertical Alignment` para `Center`;
- Abra a aba `Theme Overrides`;
- Dentro de `Colors`, configure `Font Color` para preto (`#000000`);
- Em `Fonts`, clique no indicador para baixo, selecione `Quick Load` e use a fonte que está na pasta `fonts`; e
- Em `Font Sizes`, modifique `Font Size` para `48px`.

Agora temos ambos os textos no tamanho e fonte corretos, centralizados na tela. Porém, um texto está em cima do outro. Para resolver isso, vá na Árvore de Nós e clique no ícone de *olho* de um dos *labels* para ocultá-lo.

A próxima coisa é a pontuação de moedas. Em `Control`, crie um nó-filho, `MarginContainer` (ele é um caixa que tem margens modificáveis), coloque o seu *Anchor Preset* para `Top-Right`. Modifique, dentro de `Theme Overrides`, as propriedades `Margin Right` e `Margin Top`, ambas para `20` unidades. Depois, dentro desse container, crie outro container, agora do tipo `HBoxContainer` (um container cujos elementos são ordenados horizontalmente), e coloque dois novos `Label`s, o `CoinLabel` e `CoinCount`. O primeiro deve ter em `Text`: `COINTS:`, o segundo: `0`. Em seguida, faça as mesmas alterações de fonte, cor e tamanho.

Caso tudo tenha dado certo, sua tela se parecerá com algo assim:

![](assets/start-menu-again.png)

HUD completa. Fonte: Autoral.

E sua Árvore de Nós terá o seguinte formato:

![](assets/ui-tree.png)

Árvore de Nós da Cena Principal. Fonte: Autoral

#### Câmera 3D

Para enxergar alguma coisa em um mundo 3D precisamos de um *ponto de vista*, uma **câmera** que vai nos mostrar um canto do mundo. No Godot, esse nó é chamado de `Camera3D`, adicione-o como filho de *Main*. Depois vá no *Inspetor*, procure pela propriedade `Position` e modifique o componente `z` para `10`. Isso colocará a câmera na posição `(0, 0, 10)`. Já que nosso helicóptero estará no centro do mundo, precisamos tirar a câmera da frente.

Antes de continuar, lembra quando eu disse que esse jogo é mais um **2.5D**? Então para manter o aspecto bidimensional temos que mudar a **projeção** da nossa câmera. A projeção define o *espaço de visão* da tela, ou seja o que fica dentro ou fora da câmera, em um mundo 3D objetos mais distantes aparecem menores e os mais próximos, muito maiores. O problema é que não queremos essa *perspectiva*, queremos que os objetos mantenham seu tamanho relativo independente da sua distância do campo de visão, evitando efeitos estranhos quando os objetos passarem muito perto da câmera. Essa projeção possui nome: ela é chamada de projeção **Ortogonal**. 

![](assets/perspective-vs-orthogonal.png)

Diferença entre projeção ortogonal e de perspectiva. Fonte: LearnOpenGL.

Se quer saber mais sobre o assunto clique [aqui](https://learnopengl.com/Getting-started/Coordinate-Systems).

Para mudar a forma como nossa câmera projeta o espaço, vá nas propriedades e procure por `Projection`, em suas opções, selecione `Orthogonal`. Isso mudará as propriedades seguintes, altere `Size` para `30.0`, para mudar a largura que nossa câmera enxerga.

### Helicóptero

Vamos para a próxima etapa, montar o nosso jogador, o **helicóptero**. Para fazer isso, criaremos outra cena, aperte `Ctrl-N`, selecione `Other Node` na Árvore de Cenas e busque por `CharacterBody3D`. Esse tipo representa entidades ou personagens, ele &mdash; por padrão &mdash; não é afetado pela física do mundo, mas afeta outros corpos. Renomeie-o para `Player`.

#### Modelo 3D

Elementos de um jogo 3D costumam também ser 3D. Para isso precisamos de um *Modelo 3D*. Esses modelos são feitos através de ferramentas especializadas como o *Blender*. Desenhar modelos 3D é um assunto totalmente a parte ao qual não iremos abordar nesse curso, mas vamos lhe mostrar como utilizá-los.

Com isso, temos um modelo 3D pronto do helicóptero, feito no Blender e pronto para ser usado, tudo que precisamos é carregá-lo na nossa cena. No *File System*, abra a pasta `models`, procure por `lameheli.glb` e arraste o arquivo para nossa cena. Assim, `Player` deve ter ganhado um novo filho e o modelo deve estar no centro da cena.

> [!info]
> O Godot aceita diversos tipos de arquivos como modelo 3D, o formato *GLB* é nativo e possui melhor suporte. mas também usaremos o tipo *FBX* que precisa das imagens de textura incluidas no projeto. O Godot também aceita o formato `.blend` caso você tenha o Blender instalado.

![](assets/helicopter-model.png)

Cena do modelo do helicóptero. Fonte: Autoral.

Perfeito, temos um modelo 3D, que inclusive conta com uma animação na hélice! Mostraremos como rodá-la mais tarde.

#### Caixas de Colisão

Nosso trabalho não acabou, precisamos detectar caso um objeto colida com nosso helicóptero e para fazer isso no Godot, temos que criar uma **Caixa de Colisão**. No Godot, essas caixas podem ser criadas com o nó `CollisionShape3D`. Adicione um como filho de `Player`. Vá no Inspetor e escolha dentro da propriedade `Shape` a forma `BoxShape3D` (um cubo), depois clique nesse valor para abrir mais propriedades. Configure `Size` para os seguintes valores `x: 2, y: 2, z: 5`. Em seguida, volte para as propriedades do nó e procure por `Transform`, abra essa aba e modifique o componente `z` de `Position` para `-0.8`, para arrastar a caixa um pouco para trás, de forma que ela cubra a maior parte do modelo.

![](assets/helicopert-box.png)

Caixa de colisão inferior. Fonte: Autoral.

Assim temos nossa primeira caixa de colisão &mdash; não se preocupe, esse contorno azul não aparece quando o jogo roda. A próxima será ao redor da hélice. Crie um novo nó de colisão, mas dessa vez escolha o *shape* do tipo `CylinderShape3D`, modifique `Height` para `0.2` e `Radius` para `5.0`. Também mude `Position` para `y: 2.3` e `z: -1`. Desse jeito, criamos um disco ao redor da nossa hélice que também vai detectar colisões.

![](assets/helicopter-helice.png)

Caixa de colisão da hélice. Fonte: Autoral.

#### Criando o Script

Como última modificação da nossa cena, vamos adicionar um *script* que permita controlar o jogador e rodar a animação. Com o botão direito, clique sobre o nó `Player`, depois selecione `Attach Script`, ou aperte no ícone de Script do lado da barra de pesquisa escrito `Filter Nodes`. Desmarque a opção `Template` pois dessa vez não usaremos o template padrão que acompanha `CharacterBody3D`, use o nome `player.gd` e clique em `Create`.

![](assets/creating-player-script.png)

Popup de criação de script. Fonte: Autoral

Feito isso, o Godot abrirá o editor de scripts com nosso script aberto e pronto para editar. Você verá uma única linha dizendo:

```gdscript
extends CharacterBody3D
```

Ou seja, esse script herda os atributos e propriedades do nó `CharacterBody3D`, veremos alguns desses atributos daqui a pouco. A primeira coisa que faremos será incluir duas variáveis para nosso script.

```gdscript
const SPEED: float = 10.0
@onready var animation: AnimationPlayer = $lameheli/AnimationPlayer
```

`SPEED` é uma constante que representa a velocidade em que o helicóptero se mexe, já `animation` é um pouco mais complexo. Ela é uma variável do tipo `AnimationPlayer` (um nó que executa uma animação) e não só isso, `$` é uma abreviação para a função `get_node()` que recebe o caminho de um nó e devolve esse nó (caso ele exista). Então o que estamos fazendo é "pegue o nó *AnimationPlayer* dentro do nó *lameheli* (nosso modelo)". Acontece que o Godot só tem acesso a árvore de nós quando uma cena é carregada. É aí que entra o `@onready`, ele é uma **anotação** que modifica como o Godot vai tratar esse script, nesse caso, estamos dizendo "carregue essa variável quando a cena estiver pronta/ativada na memória".

```gdscript
func _ready():
	animation.play("Cube_001Action")
```

A próxima coisa que faremos será declarar a função `_ready()`, ela é equivalente a função `love.load()`, mas que só funciona dentro do escopo do nó que a chama. Dentro dela estamos usando nossa variável `animation` e iniciando a animação da hélice &mdash; de nome `Cube_001Action` &mdash; com o método `play()`. Voltando novamente à anotação `@onready`, o que ela faz é carregar o valor da variável no mesmo momento que `_ready`.

```gdscript
func _physics_process(delta: float) -> void:
	var direction = Vector3(0, 0, 0)
	
	if Input.is_action_pressed("move_up"):
		direction.y += 1
	if Input.is_action_pressed("move_down"):
		direction.y -= 1

	velocity = direction * SPEED

	move_and_slide()	
	clamp_position()
```

A próxima função que vamos declarar no script é `_physics_process()`, ela é equivalente à `love.update()`, mas, novamente, ela só tem acesso aos atributos do nó que a chamou. O que fazemos é bem simples, checamos se as ações `move_up` ou `move_down` estão sendo pressionadas. Caso sim, adicionamos um valor no componente `y` da variável `direction` para indicar que aquela é a direção que vamos tomar. Depois modificamos `velocity`, que é um dos atributos de `CharacterBody3D` que herdamos, para ser nossa direção vezes a velocidade (`SPEED`). Em seguida, chamamos `move_and_slide()` que é uma função do Godot que utiliza `velocity` e multiplica por `delta` para atualizar a posição do objeto, levando em conta possíveis colisões ou um terreno inclinado por exemplo. 

```gdscript
func clamp_position():
	var camera = get_viewport().get_camera_3d()
	
	var position_relative_to_camera = camera.global_transform.inverse() * global_position
	var z_depth = -position_relative_to_camera.z
	
	var upper_left = camera.project_position(Vector2(0, 0), z_depth)
	var bottom_right = camera.project_position(get_viewport().get_visible_rect().size, z_depth)
	
	position.y = clamp(position.y, bottom_right.y, upper_left.y)
```

Ao final da função também chamamos `clamp_position()`, essa é uma função definida por nós que restringe o movimento do jogador para que ele fique dentro da tela. Essa operação deveria ser fácil para jogos 2D, só precisaríamos pegar os limites da tela. Contudo, estamos lidando com um mundo 3D que não tem noção da existência das bordas da tela, então precisamos fazer algumas operações com matrizes utilizando nossa câmera, para então restringir a posição com base nos valores calculados.

#### Configurando Eventos de Entrada (InputEvents)

No script acima, não usamos uma função que identifica o tipo de tecla pressionada. Isso é porque o Godot busca abstrair esse conceito para que você possa criar um código que funcione para diferentes dispositivos, ex.: teclado,*joystick*, etc. Ele faz isso através de uma classe chamada `InputEvent` e uma `Action` é um grupo de zero ou mais eventos marcados com um título, por exemplo: `move_up` ou `move_down`. O que temos que fazer agora é criar essa ação nas configurações do nosso projeto.

Para fazer isso, vá no canto superior esquerdo e clique em `Project` e depois em `Project Settings`. No popup que se abrir, busque pela aba `Input Map` onde você pode criar suas próprias ações. Crie um chamado `move_up` e outro `move_down`, ambos vão aparecer na lista de ações. Clique no ícone de `+` em cada uma das ações. Um novo popup vai abrir onde você pode selecionar uma tecla ou evento ou digitar uma tecla para ser detectada automaticamente. Adicione as teclas `W`, `Up` (seta para cima) e `S` e `Down` (seta para baixo) para os seus respectivos eventos.

![](assets/set-input-mapping.png)

Input Map. Fonte: Autoral.

Você pode ver todas as ações que o Godot define por padrão, movendo o *slider* de `Show Built-in Actions`. Caso queira saber mais sobre como o Godot gerencia *inputs* clique [aqui](https://docs.godotengine.org/pt-br/4.x/tutorials/inputs/inputevent.html).
#### Adicionando à Cena Principal

Agora que tudo está pronto, vamos instanciar nossa cena do jogador para a cena principal. Clique no ícone de cadeado na cena principal ![](assets/scenes-and-instances.png), e selecione `player.tscn` (espero que você tenha salvado-a assim). Então rode a cena &mdash; não esqueça de desabilitar ambos os labels do meio da cena &mdash; e veja a magia acontecer!

![](assets/black-helicopter.png)

Cena principal, modelo escuro. Fonte: Autoral

Só que não :cry: . Acontece que cenas 3D precisam de algo a mais para serem visíveis: **Luz**. Para ver os nossos modelos precisamos de uma fonte de luz que ilumine o ambiente. Para conseguir isso, adicione à `Main` um nó do tipo `DirectionalLight3D`. Esse tipo é como um *sol*, ele emite infinitos feixes de luz em paralelo. Vamos posicioná-lo a cima do modelo, experimente movimentá-lo dentro do editor de cenas, com ajuda da barra de ferramentas: ![](assets/tools.png). Dica o ícone de imã te ajuda a movimentar em números inteiros. Posicionei a minha fonte de luz na posição: `(0, 12, 0)` e rotacionei ela em 90º no eixo y.

![](assets/semi-lighted-heli.png)

Cena parcialmente iluminada. Fonte: Autoral.

*Hmmm*, acontece que a iluminação vindo inteiramente de cima não cobre todos os pontos do modelo. Para adiantar o processo de tentativa e erro vamos direto a solução. Adicione mais **três** fontes de luz direcionais. Uma a direita do modelo, ou a esquerda e um último atrás da nossa câmera, todos apontando para o centro do mundo. Desse modo iluminaremos os objetos de todos (pelos menos os principais) os ângulos.

![](assets/lighted-helicopter.png)

Cena Principal Totalmente Iluminada. Fonte: Autoral

Feito esses ajustes, tudo está pronto para as próximas etapas.

> [!Warning]+ Troubleshooting
> Caso a animação esteja rodando só uma vez ou nenhuma vez, o problema está no arquivo do modelo. 
> 
> Abra o File System e clique duas vezes no arquivo `lameheli.glb`. Isso abrirá uma nova tela com uma árvore de nós à esquerda, procure e clique em `Cube_001Action`. Isso deve mostrar as configurações da animação à direita. Procure por `Loop Mode` e garanta que o modo está em `Linear`. Caso tenha feito, qualquer alteração, clique no botão `Reimport` para salvar as alterações.

### Outros Modelos

Agora vamos adicionar outras entidades do jogo: *moedas*, *aviões* e *prédios*.

#### Moedas

Crie uma nova cena de raiz `Area3D`, nomeie a cena `Coin`, adicione o modelo `Coin.fbx`. Em seguida, adicione um nó do tipo `CollisionShape3D` e escolha o formato `CilinderShape3D`. Com o editor, modifique o formato para encobrir a moeda. Ou use esses valores:

| Propriedade  | Valor |
| ------------ | ----- |
| Height       | 0.32  |
| Position (y) | 0.5   |
| Rotation (x) | -90º  |

> [!info]
> O tipo `Area3D` representa um area que possui um formato, definido através de um `CollisionShape3D`, que não é afetado pela física e emite **sinais** quando objetos entram e saem de seu escopo.

![](assets/coin.png)

Modelo da moeda de ouro. Fonte: Autoral

Depois crie um script atrelado a essa cena, chamado `coin.gd`. Vamos fazer a moeda girar através da função `_process()` e se mover para a direita usando a função `_physics_process()`.

```gdscript
extends Area3D

@export var rotation_speed: float = 3.0
@export var movement_speed: float = 10.0

func _process(delta: float) -> void:
	rotate_y(delta * rotation_speed)

func _physics_process(delta: float) -> void:
	global_position.x -= movement_speed * delta
```

O decorador `export` expõe a variável no inspetor de propriedades da cena (salve o script e confira de novo as propriedades). O resto do script é bem simples, a cada frame, rotacionamos nosso objeto no eixo y usando `rotate_y` e movemos para a direita decrementando nossa posição usando nossa velocidade de movimento.

> [!info]
> Nesse caso usamos duas funções que parecem muito similares `_process()` e `_physics_process()`, mas qual a diferença entre elas? Enquanto `_physics_process()` geralmente é reservado para lidar com atualizações físicas no seu mundo, enquanto `_process()` é mais usado para executar animações.

Agora precisamos incrementar a contagem caso o jogador pegue uma das moedas, para fazer isso vamos nos cadastrar para ouvir um **sinal**. Vamos utilizar um dos sinais que `Area3D` fornece por padrão, o `body_entered()`. Para ouvir um sinal, selecione o nó raiz da cena e vá na coluna da direita onde fica o Inspetor, você verá 3 abas em seu topo: `Inspector`, `Signals` e `Groups`, clique na aba *Signals* para ver todos os sinais da sua cena, dentro de *Area3D* busque por `body_entered` e clique nele. Isso abrirá um popup para você definir a função que vai ser ativada sempre que o sinal for emitido, apenas selecione o nó raiz e confirme.

![283](assets/area3d-signals.png)

Lista de sinais. Fonte: Autoral

Uma nova função chamada `_on_body_entered()` será criada no seu script, preencha com os seguintes conteúdos:

```gdscript
func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		var coinCounter = get_node("/root/Main/HUD/Control/MarginContainer/HBoxContainer/CoinCount")
		coinCounter.text = str(coinCounter.text.to_int() + 1)
		queue_free()
```

Essa função aceita um parâmetro `body` que é o objeto que entrou na área, caso o nome desse corpo seja `Player` (nosso jogador), pegamos o *label* `CoinCounter` usando a função `get_node()` e seu caminho absoluto dentro da cena principal (detalhe, isso só funciona se coin estiver instanciada na cena principal). Em seguida, pegamos a contagem, incrementamos em um, guardamos novamente no texto e deletamos a moeda usando a função `queue_free()`, que apaga o nó que a chama. Experimente incluir umas moedas na cena principal e tente pegá-las.

Por fim, o que acontece se uma moeda sai da tela? Nossa intuição diz que ela deve ser apagada, porém isso não ocorre por padrão. É muito similar a nossa implementação anterior de *Flappy* *Bird*, temos que dizer ao nó para ser deletado caso ele saia da tela. Mas ao invés de resolver isso com matemática, vamos usar outro nó do Godot.

Inclua, como filho de *Coin*, o nó `VisibleOnScreenNotifier3D`, esse nó cria uma caixa e emite sinais quando a mesma entra e sai da tela. Ajuste da caixa para encobrir a moeda, usando os pontos vermelhos para mudar o tamanho e as setas para mudar a posição.

![](assets/coin-model.png)

Caixa de detecção de espaço da moeda. Fonte: autoral

Depois volte para a aba de sinais selecionando este novo filho. Procure pelo sinal `screen_exited()` e selecione o nó raiz para incluir uma nova função no script. O corpo da função é bem simples, apenas delete o nó caso ele saia da tela.

```gdscript
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
```

Com isso, podemos partir para os outros modelos.
#### Aviões

Para os aviões inimigos, crie uma nova cena chamada: `enemy.tscn` do tipo `CharacterBody3D`, inclua o modelo `airplane.glb` e um novo `CollisionShape3D`, do tipo `BoxShape3D`, ajuste o formato para cobrir a maior parte do corpo do avião. 

Depois, crie um script associado à raiz, chamado `enemy.gd` &mdash; ignore o preset de `CharacterBody3D` &mdash; esse script vai ser ainda mais fácil, vamos só mover nosso avião para direita.

```gdscript
extends CharacterBody3D

@export var movement_speed: float = 20.0

func _ready() -> void:
	rotate_y(-90.0)

func _physics_process(delta: float) -> void:
	global_position.x -= delta * movement_speed
```

A velocidade do nosso avião será o dobro dos outros objetos para deixar o jogo mais dinâmico, incluímos na função `_ready()` &mdash; que constrói a cena &mdash; uma rotação de 90º para que a frente do avião aponte para a direita.

Dito isso, volte a aba direita, ao lado de *Signals*, existe uma aba chamada *Groups*, que permite **categorizar** cenas e nós. Clique no `+` para criar um novo grupo, nomeie-o "*obstacles*" e marque a opção `Global`. Em outras palavras, estamos categorizando nosso inimigo como um obstáculo, isso será útil para filtrar colisões no lado do player.

Para finalizar, repita o mesmo processo da moeda, com o `VisibleOnScreenNotifier3D`, ajuste a caixa e conecte o sinal a uma função que deleta a cena.

![](assets/airplane-model.png)

Cena do Avião. Fonte: Autoral

#### Prédios

Para os prédios, crie uma nova cena do tipo `StaticBody3D` &mdash; representa um objeto imóvel &mdash; nomeado de  `Skyscrapper`. Execute os seguintes passos:
- Gire o modelo em 180º para que sua frente aponte o Z+ (nosso norte)
- Aumente o tamanho do modelo em 7 vezes, na propriedade `Scale` in `Transform`.
- Inclua um `CollisionShape3D` do tipo `BoxShape3D` que envolva o prédio
- Adicione um `VisibleOnScreenNotifier3D` com um sinal atrelado ao script
- Crie um script que mova o objeto com velocidade `10.0`.
- Inclua o prédio no grupo `obstacles` marcando a opção, dentro da aba `Groups`, em `Global Groups`.

```gdscript
extends StaticBody3D

@export var movement_speed: float = 10.0

func _physics_process(delta: float) -> void:
	global_position.x -= delta * movement_speed

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
```

![](assets/skyscraper-model.png)

Arranha-céu. Fonte: Autoral

### Spawners

Com nossos modelos prontos, temos que criá-los pela cena. Faremos isso através de um script. Dentro de *Main*, crie um nó do tipo `Node3D` chamado *Spawner*, todos os objetos vão ser criados onde o nó estiver, mova-o para logo depois do foco da câmera a direita, ex.: `x: 26`, depois adicione a ele um script com o mesmo nome.

![](assets/minecraft-spawners.png)

Spawner do Minecraft. Fonte: Youtube

Antes de editar o script, adicione a `Spawner` três nós do tipo `Timer`, cada um nomeado: `CoinSpawner`, `SkyscraperTimer`, `AirplaneTimer`. Esse tipo, é literalmente um relógio que pode ser configurado como quisermos. Então faça as seguintes configurações:
- Ative `Autostart` para que ele ative automaticamente.
- Associe o sinal `timeout()` de cada timer a uma função respectiva dentro do script `spawner.gd` (para isso selecione o nó *Spawner* no popup).

Com isso feito, vamos programar o script, para incluir os três itens no jogo, através do tipo `PackedScene`, que representa um arquivo de cena.

```gdscript
extends Node3D

@export var skycraper: PackedScene
@export var coin: PackedScene
@export var airplane: PackedScene


func spawn_object(scene: PackedScene, base_range_y: float, end_range_y: float):
	var instance = scene.instantiate()
	
	var random_y = randf_range(base_range_y, end_range_y)
	instance.position = Vector3(position.x, random_y, position.z)
	add_child(instance)

func _on_skyscraper_timer_timeout() -> void:
	var i = randi() % 10
	
	if i < 3:
		spawn_object(skycraper, -50, -40)


func _on_coin_timer_timeout() -> void:
	var i = randi() % 10
	
	if i < 5:
		spawn_object(coin, -20, 10)

func _on_airplane_timer_timeout() -> void:
	var i = randi() % 10
	
	if i < 3:
		spawn_object(airplane, 7, 10)
```

Em seguida, usaremos uma função auxiliar chamada `spawn_object()`, para instanciar nossa cena na mesma posição do *spawner*, com um intervalo do eixo y aleatorizado usando a função `randf_range()`. Já as funções de *timeout* são simples, damos uma chance aleatória para criar o objeto.

Por último, vá no Inspetor do Spawner e configure as propriedades com as suas respectivas cenas.

![](assets/spawner-scenes.png)

Cenas do Spawner. Fonte: Autoral

### Juntando tudo

Com o spawner pronto, vamos juntar tudo no jogo. Caso ainda não haja, coloque uma instância do jogador na cena principal. Mantenha o label `StartMessage` visível e oculte o outro, bem como, oculte o jogador. Além disso, vamos desativar o nó do jogador e do spawner para que eles só funcionem quando o jogo começar. Para fazer isso, vá nas propriedades de ambos, procure por `Process` e dentro dessa aba, modifique `Mode` para `Disabled`.

Para ativar os nós, crie um script associado à cena principal, chamado de `main.gd`.

```gdscript
extends WorldEnvironment

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if $HUD/Control/StartMessage.visible:
			start_game()
		elif $HUD/Control/RestartMessage.visible:
			get_tree().reload_current_scene()

func start_game():
	$HUD/Control/StartMessage.hide()
	
	$Player.show()
	$Player.process_mode = Node.PROCESS_MODE_INHERIT
	$Spawner.process_mode = Node.PROCESS_MODE_INHERIT
```

No script, usamos a função `_input()`, chamada sempre que um evento ocorre, para detectar se a tecla `Enter` (que emite a ação `ui_accept`) foi pressionada. Então, verificamos se estamos na tela de inicio ou de fim. A de início apenas começa o jogo, revelando o jogador e iniciando ele e o spawner. Já a de fim, re-começa o jogo usando o método `reload_current_scene` na nossa árvore de nós.

Por fim, para encerrar o jogo, o player precisa detectar se colidiu com um obstáculo, adicione as seguintes linhas para o final de `_physics_process()` no script do jogador.

```gdscript
for i in get_slide_collision_count():
	var collision = get_slide_collision(i)
	var bumped_object = collision.get_collider()
	
	if bumped_object.is_in_group("obstacles"):
		die()
```

Esse laço, pega todos os objetos que o player colidiu naquele frame e caso um deles for do grupo `obstacles` (definido anteriormente), o player morre com a função `die()`, que é definida como:

```gdscript
func die():	
	hide()
	$CollisionShape3D.set_deferred("disabled", true)
	$CollisionShape3D2.set_deferred("disabled", true)
	$/root/Main/HUD/Control/RestartMessage.show()
```

Nessa função, apenas escondemos o player, desativamos as caixas de colisão e mostramos a tela de saída. Com isso, o jogo está minimamente funcional, vamos dar os toques finais agora!

### Extras: Efeitos Sonoros

As mecânicas do jogo em si estão completas, mas vamos adicionar algumas coisas para deixá-lo ainda mais legal. A primeira é **efeitos sonoros**, isso pode ser feito com o nó `AudioStreamPlayer3D`. Adicione um dele na `Main`, na propriedade `Stream` selecione o áudio na pasta `musics` e marque a propriedade `Autoplay` para que ela já inicie tocando.

Faça algo semelhante para `Coin`, adicione o nó `AudioStreamPlayer3D` e escolha o som `coin.wav` na pasta `sounds`. Mas ao invés de habilitar o autoplay, vamos tocar o áudio sempre que a moeda for obtida, portanto, no script da moeda inclua os seguintes trechos:

```gdscript
@onready var sound = $AudioStreamPlayer3D # NOVO

func _on_body_entered(body):
	var coinCounter = get_node("/root/Main/HUD/Control/MarginContainer/HBoxContainer/CoinCount")
	coinCounter.text = str(coinCounter.text.to_int() + 1)
	
	# NOVO
	sound.play()
	await sound.finished
	# FIM
	
	queue_free()
```

O método `.play()` executa o som e `await sound.finished` espera até que a faixa de som termine, do contrário a faixa executa separadamente do código que a chamou.

### Extras: Explodindo o Jogador

 A segunda coisa que vamos adicionar é **explosões**! Criaremos um efeito de explosão para quando o jogador colidir com alguma coisa. Para isso, crie uma cena do tipo `Node3D` e chame de `Explosion`. 

Adicione um `AudioStreamPlayer`, selecione a faixa `explosion.wav` com `Stream`.  Tocaremos o som com um script na próxima etapa.
 
Feito isso, adicione um nó-filho do tipo `GPUParticles3D` que serve para criar partículas 3D. Em seguida faça:
- Desative a propriedade `Emitting`
- Mude `Amount` para `50`
- Em `Time`, ative `One shot`
- Ainda em `Time`, mude `Explosiveness` para `1.0`
- Em `Process Material`, escolha nas opções `ParticleProcessMaterial` e abra suas sub-propriedades
- Em `Particle Flags`,  ative `Align Y`
- Em `Spawn` > `Position`, procure por `Emission` e selecione a opção `Sphere`
- Ainda em `Spawn`, procure por `Velocity` e `Spread`, mude-o para `180.0`
- Ainda em `Velocity` procure por dois *sliders* chamados de `Initial Velocity`, coloque `min.` para `5.0` e `max.` para `10.0`
- Saindo de `Process Material` e indo para `Draw Passes`, vá para `Passes` e em `Pass 1`, selecione `BoxMesh` para escolher a forma das nossas partículas. Nesse caso cubos.
- Clique no cubo, e depois em `Material` para criar um novo `StandardMaterial`
- Dentro de `StandardMAterial` vá para `Albedo` e `Color`, escolha a cor que preferir como um tom de laranja, por exemplo.

Ufa isso foi difícil, isso tudo foi só para criar um efeito de partículas em cubos laranjas que explodam em todas as direções. Mas ainda não acabou! Crie um script chamado `explosion.gd`:

```gdscript
extends Node3D

@onready var particles = $GPUParticles3D
@onready var sound = $AudioStreamPlayer3D

func _ready():
	particles.emitting = true
	sound.play()

func _process(delta: float) -> void:
	if not particles.emitting:
		queue_free()

```

No script com a função `_ready()`, vamos iniciar as partículas ativando a propriedade `emitting` e também tocar a faixa de som. Depois em `_process()`, caso as partículas tenha terminado de ser emitidas (definido em `Explosiveness`), deletamos a explosão. "Simples" assim, temos nosso efeito explosivo.

Com isso feito, vamos incluir a explosão no jogador, abra o `player.gd` e adicione a seguinte linha na função `die()`:

```gdscript
@export var explosion_scene: PackedScene # NOVO

...

func die():
	# NOVO
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	# FIM
	
	...
```

> ℹ️ **Detalhe**:
> Não esqueça de adicionar a cena de explosão nas propriedades do jogador, senão você terá um erro sempre que morrer!

E com isso terminamos o nosso jogo. Depois de tanto trabalho está na hora de colher os frutos, então aperte `F5` para jogar!

![](assets/player-exploding.png)

Explosão do jogador. Fonte: Autoral.

## Conclusão

Nosso trabalho aqui está concluído. Rode o projeto e divirta-se! Caso queira exportar seu jogo para compartilhar com amigos, vá em `Projects` > `Export`, adicione um modo de exportação (Web, Mac, Windows, Linux, etc) e clique em exportar.

De qualquer forma, você está evoluindo cada vez mais. Continue aprendendo sobre Godot e jogos 3D seguindo para a próxima aula. Te vejo lá!

[^1]: https://pt.wikipedia.org/wiki/Godot
