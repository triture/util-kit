# UTIL-KIT

Uma biblioteca abrangente de utilitários para Haxe que fornece componentes reutilizáveis para acelerar o desenvolvimento de aplicações.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Índice

- [UTIL-KIT](#util-kit)
  - [Índice](#índice)
  - [Sobre](#sobre)
  - [Documentação](#documentação)
  - [Desenvolvimento com Dev Container](#desenvolvimento-com-dev-container)
    - [Pré-requisitos](#pré-requisitos)
    - [Iniciando com Dev Container](#iniciando-com-dev-container)
  - [Principais Recursos](#principais-recursos)
    - [Path (util.kit.path)](#path-utilkitpath)
    - [Nothing (util.kit.nothing.Nothing)](#nothing-utilkitnothingnothing)
    - [Internacionalização (util.kit.lang)](#internacionalização-utilkitlang)
    - [Zip (util.kit.zip)](#zip-utilkitzip)
    - [Kid (util.kit.kid)](#kid-utilkitkid)
  - [Executando Testes](#executando-testes)
  - [Instalação em Seu Projeto](#instalação-em-seu-projeto)
  - [Licença](#licença)
  - [Contribuição](#contribuição)

## Sobre

Util-Kit é uma coleção de ferramentas e utilitários genéricos para Haxe, projetada para simplificar tarefas comuns de programação e fornecer implementações reutilizáveis para funcionalidades frequentemente necessárias. Esta biblioteca visa reduzir a repetição de código e aumentar a produtividade no desenvolvimento com Haxe.

## Documentação

A documentação completa da API está disponível em:
[https://triture.github.io/util-kit](https://triture.github.io/util-kit)

## Desenvolvimento com Dev Container

Este projeto está configurado com Dev Containers, o que facilita o onboarding e experimentação. Você pode começar a trabalhar com a biblioteca imediatamente sem se preocupar com configurações de ambiente.

### Pré-requisitos

- [Docker](https://www.docker.com/products/docker-desktop)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Extensão Remote - Containers para VS Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Iniciando com Dev Container

1. Clone o repositório
2. Abra o projeto no VS Code
3. Quando solicitado, clique em "Reopen in Container" ou use o comando `Remote-Containers: Reopen in Container`
4. O VS Code configurará automaticamente o ambiente de desenvolvimento dentro do container Docker

## Principais Recursos

### Path (util.kit.path)

Uma implementação robusta para manipulação de caminhos (paths) com suporte para:
- Análise de partes do caminho
- Decodificação URL
- Manipulação de parâmetros tipados no caminho
- Correspondência de padrões de caminho

```haxe
// Exemplo básico
var path:Path<Dynamic> = '/some/path';
var parts = path.parts(); // [{part: "some", is_param: false}, {part: "path", is_param: false}]

// Com parâmetros tipados
var pathWithParams:Path<Dynamic> = '/users/{userId:Int}/profile';
```

### Nothing (util.kit.nothing.Nothing)

Implementação para lidar com valores ausentes de forma segura, semelhante ao padrão Option/Maybe de outras linguagens.

### Internacionalização (util.kit.lang)

Suporte para múltiplos idiomas em suas aplicações:
- Carregamento de arquivos de tradução (JSON)
- Acesso fácil às strings traduzidas

### Zip (util.kit.zip)

Funcionalidades para trabalhar com arquivos compactados.

### Kid (util.kit.kid)

Utilitários para manipulação de estruturas de dados hierárquicas.

## Executando Testes

O projeto inclui um conjunto abrangente de testes unitários que você pode executar para verificar a funcionalidade:

```bash
# Dentro do container
cd /util-kit
haxe test-unit.hxml
neko ./build/util/kit/test/unit.n
```

## Instalação em Seu Projeto

Para usar o Util-Kit em seu projeto Haxe:

```bash
haxelib install util-kit
```

Em seguida, adicione a biblioteca ao seu arquivo HXML:

```hxml
-lib util-kit
```

## Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo LICENSE para detalhes.

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests para melhorar esta biblioteca.

---

Desenvolvido por [Triture](https://github.com/triture)