# Aula 09: Dreadhalls

![](assets/dreadhalls-title-scene.png)
Fonte: autoral

Na nossa última aula, apresentamos o *Godot Game Engine*, como criar jogos 3D (tava mais para 2.5D) e a linguagem GDScript. Na aula de hoje vamos realmente entrar no mundo 3D utilizando todas as coordenadas disponíveis (x, y, z). Para fazer isso vamos implementar o jogo **Dreadhalls**.

[Dreadhalls](https://www.dreadhalls.com/) é um *VR Game* (Jogo de Realidade Virtual), infelizmente não vamos explorar o aspecto da realidade virtual do jogo, ~~já que não eu não tenho um óculos VR~~, mas o jogo ainda pode ser jogado normalmente. Para nosso azar somos protagonistas de um jogo de terror, vamos explorar masmorras escuras e nojentas (~~como o quarto de um adolescente~~) enquanto somos perseguidos por criaturas sinistras. Por fim, se você tem arritmia cardíaca (assim como eu) então **cuidado** nesta aula!

Com esta aula, buscamos aprender os seguintes conceitos: criar uma **First Person Camera** (câmera em primeira pessoa); adicionar **Texturas** no Godot (chega de blocos coloridos); implementar um **Gerar um Labirinto 3D** (3D Maze); usar múltiplas cenas, como a máquina de estados do LÖVE; incluir uma **névoa** para deixar o jogo bem *trevoso*; e, **Componentes de UI** do Godot.

## Demo e Código de Exemplo

O projeto desta aula está implementado na pasta `src9`. Rode-o, jogue um pouco e pense como você implementaria essas funcionalidades antes de olhar o código-fonte. Seguiremos um passo a passo de como chegar no mesmo resultado. 

Caso fique com dúvida, não exite em dar uma espiada no resultado final.

## Iniciando o Projeto

Abra o seu editor do Godot, crie um novo projeto chamado `Dreadhalls`.

![](assets/criando-projeto.png)
Fonte: autoral.

Para os próximos capítulos, consideraremos que você tem conhecimento sobre a UI do Godot, Cenas, Nós e como criar seus scripts.

## Tela de Entrada

Começaremos pelo mais fácil, criar a tela de apresentação do jogo. Ela terá o título 'Dreadhalls' e um subtítulo escrito '*Press Enter*' que irá iniciar o jogo. Desse modo, apresentamos os seguintes tipos de *Node* (Nó):

- `Control`: Class base para todos os nó relacionados a interface de usuário (UI). Define um retângulo delimitador e permite posicionar os nós filhos em posições relativas como *center*, *top-left*, *bottom-right*, etc. S
- `Panel`: Componente GUI que possui um `StyleBox` (uma classe abstrata para customizar componentes, ex.: cor, borda, etc).
- `GridContainer`: Container para organizar elementos em uma grade. Por padrão, cria uma grade com uma coluna e cada nó-filho é uma linha.

### Cor de fundo

No ambiente de criação de cenas. Crie um nó raiz do tipo `Control`. Acrescente dois nós filhos. Um do tipo `Panel` outro do tipo `GridContainer`. Feito isso, vamos colorir o nosso fundo. Acesse as propriedades de `Panel` e vá para `Theme Overrides > Styles > Panel`, clique na seta para baixo e selecione `StyleBoxFlat`. Com isso, clique na propriedade `BG Color` e configure para `#202020` (ou `32, 32, 32` no RGB).

Seguindo, em `GridContainer` crie dois novos nós do tipo `Label`. Apertando `F2` ou clicando duas vezes no nó, renomeie um para 'Title' e o outro para 'Subtitle'. Sua árvore de nós deve estar da seguinte forma:

![](assets/node-tree-title-scene.png)
Fonte: autoral

### Título e Subtítulo

Algo que torna cada jogo único é a fonte que eles utilizam a fonte que eles usam, você quer ser conhecido como o cara que faz jogos com a fonte *Arial 12* (experiência própria). Portanto gue do nosso projeto a pasta `fonts` e inclua no seu, a pasta contém dois arquivos de fontes que usaremos daqui para frente `Horrormaster` e `Horrorfind`. 

Agora, adicione para o título o texto 'Dreadhalls' em suas propriedades. Então em `Theme Overrides` configure a cor da fonte para vermelho (`255, 0, 0` em RGB ou `#ff0000` em hexa). O tamanho da fonte para `120 px`. Por fim, defina a fonte para o arquivo `Horrormaster.ttf`.

Repita o processo para o subtítulo, porém altere o texto para 'Press Enter', a fonte para `64 px` e dessa vez use o arquivo `Horrorfind.ttf`.

Temos nosso texto, agora temos que centralizá-lo na tela. Selecione `GridContainer`, na barra de ferramentas clique no botão `Anchor preset` e selecione a opção `Center`. Desse modo, nosso container está centralizado na tela. Para adicionar um espaçamento entre as linhas da coluna vá para `Theme Overrides > Constants > V Separation`, ajuste para `100`.

![](assets/achor-preset-selection.png)
Fonte: autoral

Com isso, finalizamos nossa primeira cena, salve-a com o nome de `title`. Rode a cena atual e veja aparecer na tela.

![](assets/dreadhalls-title-scene.png)
Fonte: autoral

Já estou me borrando de medo...

## Materiais, Texturas e Iluminação

Antes de mais nada, aqui vai um pouco da teoria. Na aula passada aplicamos uma **Textura** (imagem) para o fundo do nosso jogo. Agora, iremos aplicar texturas em objetos 3D, é como embrulhar uma caixa com um papel de presente. Contudo, isto traz algumas ressalvas, por exemplo, o que acontece quando um objeto 3D é maior que a nossa imagem? Ou colocar uma imagem muito grande em um objeto pequeno. 

Resolver esses problemas envolve diversas técnicas, como repetir a imagem varias vezes, esticá-las, mapear os pixels da imagem para o objeto 'mesclando' as cores e aplicando filtros para melhorar a qualidade. 

![](assets/texture-wrapping-examples.png)
Fonte: Texturas. *LearnOpenGl*. https://learnopengl.com/Getting-started/Textures

![](assets/texture-filtering-examples.png)
Fonte: Texturas. *LearnOpenGl*. https://learnopengl.com/Getting-started/Textures

Ademais, para formas mais complicadas temos técnicas como *UV Mapping*, em que decompomos o objeto 3D em uma superfície e aplicamos a textura. Como se estivéssemos montando um *origami*.

![](assets/skin-herobrine.png)
Fonte: Textura desmontada do ~~Steve~~ do Minecraft. https://www.pinterest.fr/pin/672514156827988563/

Felizmente, o Godot cuida da maioria destes casos e das técnicas, tudo que precisamos saber é como configurar a cena para termos o resultado desejado. 

> Se quiser saber mais sobre Texturas a um nível mais afundo, recomendo ver essa aula do curso *LearnOpenGL*. https://learnopengl.com/Getting-started/Textures.

### Materiais

Enquanto texturas são apenas imagens 2D, **Materiais** possuem mais informações atreladas. P

### Criando o chão e as paredes

Nosso labirinto é um grande caixote, composto de paredes que formam entradas e corredores de modo aleatório, gerando uma estrutura um tanto quanto complicada para se pensar. Porém podemos simplificar a sua representação, dizendo que o labirinto é composto de paredes, um chão e um teto (que nada mais é que uma superfície acima do jogador). Dessa forma, criaremos esses componentes que serão gerados dinamicamente ao iniciar o jogo.

Crie uma nova cena, seu nó raiz é um `StaticBody3D`, suas instâncias não são afetadas por forças externas, apenas código pode movê-las. Renomeie este nó para `Floor` (chão, mas também vai funcionar como telhado). Acrescente como filho, um nó do tipo `MeshInstance3D`

## Jogador em Primeira Pessoa

## Gerando um Labirinto

## Toques Finais

## Conclusão