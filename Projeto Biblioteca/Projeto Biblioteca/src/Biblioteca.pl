:- dynamic livro/6.
:- dynamic meusLivros/1.
:- consult('../data/livros.pl').

biblioteca :- repeat, 
                
                nl, write('==== Sistema de Busca de Livros ===='), nl,
                write('          MENU DE OPCOES'), nl,
                write('1 - Exibir todos os livros'), nl,
                write('2 - Escolher um livro'), nl,
                write('3 - Listar meus livros escolhidos'), nl,
                write('4 - Receber indicacoes'), nl,
                write('5 - Remover um livro escolhido'), nl,
                write('6 - Listar livros por genero'), nl,
                write('0 - Sair'), nl,
                write('------------------------------------'), nl,
                write('Selecione uma opcao: '), read(X), nl,
                
                opcao(X).

/* Executa a opção selecionada*/
opcao(1) :- exibirLivros.

opcao(2) :- escolherLivro.

opcao(3) :- listarMeusLivros.

opcao(4) :- indicacao.

opcao(5) :- removerLivroUsuario.

opcao(6) :- listarLivrosPorGenero.

opcao(0) :- write('Obrigado por usar nosso sistema!'),nl,
            write('Ate a proxima!'),nl, !.


/* Função para exibir Livros */
exibirLivros :- 
                write('\tLista de livros'), nl, 
                livro(Nome, Genero, Estilo, NivelLeitura, Paginas, Descricao),
                format('\nNome: ~w\n', [Nome]),
                format('Genero: ~w\n', [Genero]),
                (Estilo \= '' -> format('Estilo: ~w\n', [Estilo]) ; true),  % Mostra o estilo apenas se houver
                format('Paginas: ~d\n', [Paginas]),
                format('Nivel de leitura: ~w\n', [NivelLeitura]),
                format('Descricao: ~w\n', [Descricao]),
                write('------------------------------------'), nl,
                fail.


/* Função para adicionar livros a lista do usuario */
escolherLivro :-
    writeln('Escolha um livro para adicionar a sua lista: '),
    listarLivros, % Lista todos os livros disponiveis
    
    write('\nDigite o numero do livro que deseja adicionar'),
    read(NumeroLivro),
    
    % findall(Nome, livro(Nome, _, _, _, _, _), ListaNomes), % Encontra todos os nomes que satisfazem a condição de ser nome de um livro e armazena em ListaNomes
    findall(livro(Nome, _, _, _, _, Descricao), livro(Nome, _, _, _, _, Descricao), ListaLivros),
    
    % nth1(Índice, Lista, Elemento) o Elemento é o conteudo da Lista no indice(começa contagem no 1)
    nth1(NumeroLivro, ListaLivros, LivroEscolhido), nl, % Identifica o livro escolhido a partir do numero selecionado 
    
    LivroEscolhido = livro(Nome, _, _, _, _, Descricao),
    
    adicionarLivroUsuario(Nome), % Adiciona o nome do livro a lista de livros
    format('Livro \'~w\' foi adicionado a sua lista com sucesso!\n', [Nome]),
    fail. 


/* Função que lista os livros disponiveis com numeracao e descricao*/
listarLivros :-
    findall(livro(Nome, _, _, _, _, Descricao), livro(Nome, _, _, _, _, Descricao), ListaLivros), % Encontra todos os livros com nome e descricao e armazena eles em ListaLivros
    listarLivrosComNumeracao(ListaLivros, 1). % Exibe todos os livros com seu indice de posição

/* Função auxiliar para numerar os livros e exibir nome e descricao*/
listarLivrosComNumeracao([], _).

listarLivrosComNumeracao([livro(Nome, _, _, _, _, Descricao)|Restantes], Numero) :-
    format('~d. ~w\n    [Descricao]: ~w\n', [Numero, Nome, Descricao]),
    NovoNumero is Numero + 1,
    listarLivrosComNumeracao(Restantes, NovoNumero).

/* Função auxiliar para numerar os livros*/
listarNomesLivrosComNumeracao([], _).

listarNomesLivrosComNumeracao([Nome|Restantes], Numero) :- 
    format('~d - ~w~n', [Numero, Nome]),
    NovoNumero is Numero + 1, 
    listarNomesLivrosComNumeracao(Restantes, NovoNumero). % Chamada recursiva da função

/* Função para adicionar o livro escolhido a lista do usuario*/
adicionarLivroUsuario(Livro) :-
    (   meusLivros(Livro) % Verifica se o livro já está na lista do usuário
    ->  writeln('Esse livro ja foi adicionado a sua lista.'), % Caso ja esteja na lista, exibe essa mensagem
        fail
    ;   assertz(meusLivros(Livro)) % Caso contrario, adiciona o livro
    ).


/* Função para listar os livros escolhidos pelo usuario (sem parâmetro) */
listarMeusLivros :-
findall(Livro, meusLivros(Livro), LivroEscolhidos), % Procura todos os livros que estao na lista do usuario e armazena em LivroEscolhidos
            mostrarLivrosEscolhidos(LivroEscolhidos), % Exibe a lista dos livros
            fail.


/* Função para mostrar livros escolhidos pelo usuário (com parâmetro) */
mostrarLivrosEscolhidos([]) :-
    writeln('Nenhum livro foi escolhido ainda.'), nl, !.

mostrarLivrosEscolhidos(LivroEscolhidos) :-
    writeln('Livros escolhidos: '),
    listarNomesLivrosComNumeracao(LivroEscolhidos, 1), nl, !.

/* Seleciona os livros de acordo com a preferencia de gosto do usuario */
indicacao :- exibirNiveisLeitura.

/* gravar nivel de leitura*/
nivelLeitura(1, 'Iniciante').
nivelLeitura(2, 'Medio').
nivelLeitura(3, 'Avancado').

/* exibir opcoes de nivel de leitura e passar para escolha da quantidade de paginas*/
exibirNiveisLeitura :- 
                        write('Digite o numero do nivel de leitura que voce procura'), nl,
                        write('1 - Iniciante'),nl,
                        write('2 - Medio'),nl,
                        write('3 - Avancado'),nl,
                        write('Opcao: '), read(N), 
                        nivelLeitura(N, N2), % Grava o nivel de leitura na variavel N2
                        exibirQuantidadePaginas(N2). % Passa a variave N2 para a função exibirQuantidadePaginas

/* gravar quantidade de paginas*/
paginas(1, 200).
paginas(2, 400).
paginas(3, 10000).

/*exibir intervalos de paginas e passa para escolha do genero literario*/
exibirQuantidadePaginas(N) :- 
                            write('\nQual a quantidade de paginas que voce gostaria de ler'), nl,
                            write('1 - Ate 200 paginas'), nl,
                            write('2 - Ate 400 paginas'), nl,
                            write('3 - Podendo passar 400 paginas'), nl,
                            write('Opcao: '), read(P), 
                            paginas(P, P2), % Grava a quantidade de paginas na variavel P2 
                            exibirGeneros(N, P2). % Passa P2 e N para a funcao exibirGeneros

/* Grava o genero*/
genero(1, 'Aventura').
genero(2, 'Romance').
genero(3, 'Ficcao').
genero(4, 'Fantasia').
genero(5, 'Terror').
genero(6, 'Historico').
genero(7, 'Suspense').

/* Exibe os generos disponiveis e passa para escolha do subgenero caso exista*/
exibirGeneros(N, P) :-
                write('\nGeneros'), nl,
                write('1 - Aventura'), nl,
                write('2 - Romance'), nl,
                write('3 - Ficcao'), nl,
                write('4 - Fantasia'), nl,
                write('5 - Terror'), nl,
                write('6 - Historico'), nl,
                write('7 - Suspense'), nl,
                write('Opcao: '), read(Y),
                genero(Y, G), % Caso o genero escolhido seja um dos 4 abaixo ira chamar uma função para a escolha do seu estilo
                
                ( G = 'Ficcao' -> exibirListaEstiloFiccao(N, P, G) ; 
                G = 'Fantasia' -> exibirListaEstiloFantasia(N, P, G) ;
                G = 'Terror' -> exibirListaEstiloTerror(N, P, G) ;
                G = 'Suspense' -> exibirListaEstiloSuspense(N, P, G) ;

                % Caso não for um dos 4 exibira as recomendações
                write('\n\tLivros recomendados de acordo com sua preferencia\n'), nl,
                mostrarRecomendacoesEEscolher(N, P, G) % Exibe os livros de acordo com as preferencias do usuario
                
                ).

/* Grava os estilos de ficcao */
estiloDaFiccao(1, 'Galatica').
estiloDaFiccao(2, 'Distopia').
estiloDaFiccao(3, 'Cientifica').
estiloDaFiccao(4, 'Utopia').
estiloDaFiccao(5, 'Historico Romantica').
estiloDaFiccao(6, 'Contemporaneo Romantica').

/* Grava os estilos de fantasia */
estiloDaFantasia(1, 'Fantasia Urbana').
estiloDaFantasia(2, 'High Fantasy').
estiloDaFantasia(3, 'Low Fantasy').

/* Grava os estilos de terror */
estiloDoTerror(1, 'Gotico').
estiloDoTerror(2, 'Sobrenatural').
estiloDoTerror(3, 'Psicologico').

/* Grava os estilos de suspense */
estiloDoSuspense(1, 'Psicologico').
estiloDoSuspense(2, 'Policial').
estiloDoSuspense(3, 'Thriller').

/* Exibe as opcoes de estilo de ficcao*/
exibirListaEstiloFiccao(N,P,G) :- 
                write('\nEstilos'),nl,
                write('1 - Galatica'),nl,
                write('2 - Distopia'),nl,
                write('3 - Cientifica'), nl,
                write('4 - Utopia'), nl,
                write('5 - Historico Romantica'), nl,
                write('6 - Contemporaneo Romantica'), nl,
                write('Opcao: '), read(Z), 
                estiloDaFiccao(Z,E), % Grava o estilo na variavel E
                
                write('\n\tLivros recomendados de acordo com sua preferencia\n'), nl,
                mostrarRecomendacoesEEscolher(N, P, G, E). % Exibe os livros de acordo com as preferencias do usuario

/* Exibe as opcoes de estilo de fantasia*/
exibirListaEstiloFantasia(N,P,G) :- 
                write('Estilos'),nl,
                write('1 - Fantasia Urbana'),nl,
                write('2 - High Fantasy'),nl,
                write('3 - Low Fantasy'), nl,
                write('Opcao: '), read(Z), 
                estiloDaFantasia(Z,E), % Grava o estilo na variavel E
                write('\n\tLivros recomendados de acordo com sua preferencia\n'), nl,
                mostrarRecomendacoesEEscolher(N, P, G, E). % Exibe os livros de acordo com as preferencias do usuario

/* Exibe as opcoes de estilo de terror*/
exibirListaEstiloTerror(N,P,G) :- 
                write('Estilos'),nl,
                write('1 - Gotico'),nl,
                write('2 - Sobrenatural'),nl,
                write('3 - Psicologico'), nl,
                write('Opcao: '), read(Z), 
                estiloDoTerror(Z,E), % Grava o estilo na variavel E
                write('\n\tLivros recomendados de acordo com sua preferencia\n'), nl,
                mostrarRecomendacoesEEscolher(N, P, G, E). % Exibe os livros de acordo com as preferencias do usuario

/* Exibe as opcoes de estilo de suspense*/
exibirListaEstiloSuspense(N,P,G) :- 
                write('Estilos'),nl,
                write('1 - Psicologico'),nl,
                write('2 - Policial'),nl,
                write('3 - Thriller'), nl,
                write('Opcao: '), read(Z), 
                estiloDoSuspense(Z,E), % Grava o estilo na variavel E
                write('\n\tLivros recomendados de acordo com sua preferencia\n'), nl,
                mostrarRecomendacoesEEscolher(N, P, G, E). % Exibe os livros de acordo com as preferencias do usuario

/* Exibe as recomendações e pergunta se o usuario quer escolher uma delas, com estilo*/
mostrarRecomendacoesEEscolher(N, P, G, E) :-
    % Encontra todos os livros livros compativeis com as preferencias
    findall(livro(Nome, _, _, _, _, Descricao),
            (   livro(Nome, Genero, Estilo, NivelLeitura, Paginas, Descricao),
                G = Genero,
                E = Estilo,
                N = NivelLeitura,
                Paginas =< P
            ),
            ListaLivros),

    ( ListaLivros = [] ->
        write('\nNao ha livros disponiveis com essas caracteristicas.\n\n'),
        exibirNiveisLeitura ;
        listarLivrosComNumeracao(ListaLivros, 1), % Lista toddos os livros
        % Verifica se o usuario quer escolher um livro ou nao
        writeln('\nDeseja escolher um livro? (1)sim, (0)nao: '),
        read(Escolha),
    
        (Escolha = 1 -> write('\nDigite o numero do livro que deseja escolher: '), % Caso verdadeiro a funcao parte para a escolha
        read(Numero),
        
        % nth1(Índice, Lista, Elemento) o Elemento é o conteúdo da Lista no índice (começa contagem no 1)
        nth1(Numero, ListaLivros, LivroEscolhido), nl,
        
        LivroEscolhido = livro(Nome, _, _, _, _, _), % Desconstrução do livro
    
        % Verifica se o livro já está na lista do usuário
        (meusLivros(Nome) ->
            format('O livro \'~w\' ja esta na sua lista de livros escolhidos!\n', [Nome]) ;
            adicionarLivroUsuario(Nome),
            format('Livro \'~w\' foi adicionado a sua lista com sucesso!\n', [Nome]))
        )),

    % Caso o usuario não queira escolhar o programa volta normalmente para o menu
    fail.

/* Exibe as recomendações e pergunta se o usuario quer escolher uma delas, sem estilo*/
mostrarRecomendacoesEEscolher(N, P, G) :- 
    % Encontra todos os livros livros compativeis com as preferencias
    findall(livro(Nome, _, _, _, _, Descricao),
            (   livro(Nome, Genero, _, NivelLeitura, Paginas, Descricao),
                G = Genero,
                N = NivelLeitura,
                Paginas =< P
            ),
            ListaLivros),

    ( ListaLivros = [] -> 
        write('\nNao ha livros disponveis com essas caracteristicas.\n\n'), 
        exibirNiveisLeitura ;  % Volta para o menu inicial
        listarLivrosComNumeracao(ListaLivros, 1), % Lista todos os livros
        % Verifica se o usuario quer escolher um livro ou não
        writeln('\nDeseja escolher um livro recomendado? (1)sim, (0) nao:'), 
        read(Escolha),

        (Escolha = 1 -> write('Digite o numero do livro: '),  % Caso verdadeiro a função parte para a escolha
        read(Numero),

        % nth1(Índice, Lista, Elemento) o Elemento é o conteudo da Lista no indice(começa contagem no 1)
        nth1(Numero, ListaLivros, LivroEscolhido), nl,
        
        LivroEscolhido = livro(Nome, _, _, _, _, _), % Desconstrução do livro

        % Verifica se o livro já está na lista do usuário
        (meusLivros(Nome) ->
            format('O livro \'~w\' ja esta na sua lista de livros escolhidos!\n', [Nome]) ;
            adicionarLivroUsuario(Nome),
            format('Livro \'~w\' foi adicionado a sua lista com sucesso!\n', [Nome]))
        )),

    % Caso o usuario não queira escolhar o programa volta normalmente para o menu
    fail.


/* Função para remover livro da lista do usuario */
removerLivroUsuario :-

    findall(Livro, meusLivros(Livro), LivrosEscolhidos), % Encontrar todos os livros que foram selecionados pelo usuario e armazena na variavel LivrosEscolhidos
    
    (   LivrosEscolhidos \== [] -> mostrarLivrosEscolhidos(LivrosEscolhidos), % Verifica há livros na lista caso contrario exibe uma mensagem e volta para o menu
        writeln('Digite o numero do livro que deseja remover: '),
        read(NumeroLivro),
        
        % nth1(Índice, Lista, Elemento) o Elemento é o conteudo da Lista no indice(começa contagem no 1)
        nth1(NumeroLivro, LivrosEscolhidos, LivroARemover), % Identifica o livro escolhido a partir do numero selecionado
        
        retractall(meusLivros(LivroARemover)), % A cláusula remove todas as ocorrências do livro escolhido da base de fatos
        writeln('\nLivro removido com sucesso!') ;

        writeln('Sua lista de livros esta vazia.')  

    ), fail.


/* Função para listar livros por gênero */
listarLivrosPorGenero :-
    write('Generos disponiveis:'), nl,
    write('1 - Aventura'), nl,
    write('2 - Romance'), nl,
    write('3 - Ficcao'), nl,
    write('4 - Fantasia'), nl,
    write('5 - Terror'), nl,
    write('6 - Historico'), nl,
    write('7 - Suspense'), nl,
    write('Digite o numero do genero que deseja escolher: '), read(G),
    (   genero(G, Genero) -> % Verifica se o gênero existe
        format('\nLivros do genero ~w:', [Genero]), nl,
        findall(livro(Nome, Genero, Estilo, NivelLeitura, Paginas, Descricao),
                livro(Nome, Genero, Estilo, NivelLeitura, Paginas, Descricao),
                LivrosGenero), % Obtém todos os livros do gênero escolhido
        (   LivrosGenero = [] -> % Verifica se a lista de livros é vazia
            writeln('Nenhum livro encontrado para este genero.'), nl
        ;   listarLivrosPorGeneroAux(LivrosGenero) % Chama a função auxiliar apenas se houver livros
        )
    ;   writeln('Gênero inválido. Por favor, escolha um número de 1 a 7.'), nl
    ),
    biblioteca.

listarLivrosPorGeneroAux([livro(Nome, Genero, Estilo, NivelLeitura, Paginas, Descricao)|Restantes]) :-
    format('\nNome: ~w\n', [Nome]),
    format('Genero: ~w\n', [Genero]),
    (Estilo \= '' -> format('Estilo: ~w\n', [Estilo]) ; true), % Mostra o estilo apenas se houver
    format('Paginas: ~d\n', [Paginas]),
    format('Nivel de leitura: ~w\n', [NivelLeitura]),
    format('Descricao: ~w\n', [Descricao]),
    write('------------------------------------'), nl,
    listarLivrosPorGeneroAux(Restantes).