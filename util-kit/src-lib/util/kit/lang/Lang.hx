package util.kit.lang;

import haxe.Rest;
import haxe.ds.StringMap;

/**
    `Lang` oferece um sistema de internacionalização que permite carregar e acessar textos traduzidos
    através de enums gerados dinamicamente a partir de arquivos de recursos.
    
    A abordagem recomendada é usar arquivos JSON embarcados como recursos e acessar as chaves através 
    dos valores de enum gerados automaticamente pela macro.
    
    É recomendado usar esta classe tanto por importação direta quanto como [extensão estática](https://haxe.org/manual/lf-static-extension.html):
    
    ```haxe
    // Importação normal
    import util.kit.lang.Lang;
    
    // Extensão estática
    using util.kit.lang.Lang;
    ```
    
    #### Exemplos de uso com recursos embarcados:
    
    1. Configuração dos recursos no arquivo de compilação (ex: build.hxml):
    ```hxml
    --resource res/lang-pt.json@lang-pt
    --resource res/lang-en.json@lang-en
    ```
    
    2. Carregando um idioma e acessando valores através de enum:
    ```haxe
    // Carrega o dicionário em português
    Lang.setLanguage("PT");
    
    // Acessando valores através de enums gerados automaticamente
    var saudacao = Lang.GREETING; // "Olá mundo!"
    
    // Alternando para inglês
    Lang.setLanguage("EN");
    var greeting = Lang.GREETING; // "Hello world!"
    ```
    
    3. Usando placeholders para substituição dinâmica:
    ```haxe
    // Usando o método params()
    var msg = Lang.WELCOME.params("João", "5");  // "Bem-vindo, João! Você tem 5 mensagens."
    
    // Outra forma seria:
    var msg = "WELCOME".lang("João", "5");  // Usando extensão estática
    ```
    
    4. Acessando valores aninhados:
    ```haxe
    // Os valores aninhados são automaticamente transformados em enums com underscores
    var erro = Lang.MESSAGES_ERRORS_NOT_FOUND;  // "Registro não encontrado"
    
    // Acessando valores de array (também gera enum)
    var domingo = Lang.DAYS_0;  // "Domingo"
    var sexta = Lang.DAYS_5;    // "Sexta"
    ```
    
    #### Estrutura do arquivo de recursos JSON:
    ```json
    {
        "GREETING": "Olá mundo!",
        "WELCOME": "Bem-vindo, $v! Você tem $v mensagens.",
        "MESSAGES": {
            "SUCCESS": "Operação realizada com sucesso",
            "ERRORS": {
                "NOT_FOUND": "Registro não encontrado",
                "FORBIDDEN": "Acesso negado"
            }
        },
        "DAYS": ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
    }
    ```
    
    Note que todas as chaves são tratadas como case-insensitive. Portanto, "welcome", "Welcome" e "WELCOME" são 
    consideradas a mesma chave.
    
    #### Responsabilidades:
    - **Geração automática de enums**: Cria enums a partir da estrutura dos arquivos JSON de idioma
    - **Carregamento de recursos embarcados**: Carrega dicionários a partir de recursos JSON
    - **Gerenciamento de dicionário de strings**: Armazena e organiza textos associados a chaves específicas
    - **Substituição de placeholders**: Substitui marcadores de texto (`$v`) por valores dinâmicos 
    - **Suporte a estruturas aninhadas**: Permite organizar o dicionário em estruturas hierárquicas e arrays
    - **Normalização de chaves**: Converte todas as chaves para maiúsculas para tornar o sistema case-insensitive
    
    #### Forma alternativa (legado):
    Também é possível carregar dicionários diretamente através de objetos:
    
    ```haxe
    // Carregando dicionário manualmente
    var dictionary = {
        GREETING: "Olá mundo!",
        FAREWELL: "Adeus!"
    };
    Lang.load(dictionary);
    
    // Acessando valores
    var texto = Lang.lang("GREETING"); // "Olá mundo!"
    ```
    
    #### Como lidar com o cache do VSCode:
    
    Quando você modifica arquivos de recursos JSON externos, o VSCode não atualiza automaticamente 
    as opções de autocompletar/intellisense devido ao cache do completion server. Isso significa que 
    novas chaves adicionadas aos arquivos JSON não aparecerão no autocompletar até que você reinicie 
    o servidor de compilação.
    
    Para resolver este problema, você deve registrar uma dependência explícita entre seu código e os 
    arquivos JSON no seu arquivo HXML:
    
    ```hxml
    # Registra dependência dos arquivos de idioma para atualizar o cache do completion server
    --macro util.kit.lang.LangMacro.depends("res/lang-pt.json")
    --macro util.kit.lang.LangMacro.depends("res/lang-en.json")
    
    # Registra recursos normalmente
    --resource res/lang-pt.json@lang-pt
    --resource res/lang-en.json@lang-en
    ```
    
    Com essa configuração, sempre que você modificar um dos arquivos JSON listados, o VSCode 
    reconhecerá a necessidade de recompilar e atualizar o cache do completion server, garantindo 
    que as novas chaves apareçam corretamente no autocompletar.
**/
@:build(util.kit.lang.LangMacro.build())
enum abstract Lang(String) {

    static private var DICTIONARY:StringMap<String>;

    /**
        Obtém um texto do dicionário a partir de uma chave e substitui os marcadores de 
        posição (`$v`) pelos parâmetros fornecidos.
        
        Os marcadores `$v` no texto serão substituídos sequencialmente pelos valores fornecidos.
        Se um valor for `null`, ele será substituído por uma string vazia.
        
        @param key:String A chave que identifica o texto no dicionário
        @param rest:String Valores que serão usados para substituir os marcadores `$v` no texto
        @return String O texto processado com as substituições ou uma string vazia se a chave não existir
    **/
    inline static public function lang(key:String, ...rest:String):String {
        return getValue(key, rest);
    }

    static private function getValue(key:String, params:Array<String>):String {
        if (key == null) return '';
        
        if (DICTIONARY == null) DICTIONARY = new StringMap<String>();

        var value:String = DICTIONARY.get(key.toUpperCase());

        if (value == null) return '';
        if (params == null || params.length == 0) return value;
        
        var result:String = '';
        
        var ereg:EReg = ~/\$v/m;
        var count:Int = 0;

        while (ereg.match(value)) {
            result += ereg.matchedLeft();
            
            var restValue:String = params[count];
            if (restValue == null) restValue = '';

            result += restValue;
            value = ereg.matchedRight();

            count++;
            if (count > params.length) break;            
        }

        return result + value;
    }

    /**
        Carrega dados no dicionário de internacionalização.
        Os dados podem ser estruturados como objetos aninhados ou arrays.
        Todas as chaves são convertidas para acesso case-insensitive.
        
        Esta função é principalmente usada internamente pelo método `setLanguage()`,
        mas também pode ser utilizada para carregar dicionários manualmente quando
        necessário.
        
        @param data:Dynamic Objeto contendo os dados a serem carregados no dicionário
    **/
    static public function load(data:Dynamic):Void {
        DICTIONARY = LangSupport.processDictionary(data);
    }

    /**
        Carrega um dicionário de idioma a partir de recursos embarcados.
        
        Esta é a forma recomendada de usar a classe Lang. Os arquivos de idioma são
        carregados a partir de recursos embarcados e as chaves são acessadas através
        dos valores de enum gerados automaticamente pela macro.
        
        Esta função busca por recursos com o padrão de nome 'lang-XX', onde XX é o código do idioma 
        (por exemplo, PT, EN, ES). Quando encontra o idioma solicitado, carrega automaticamente o 
        dicionário correspondente.
        
        #### Como configurar os arquivos de idioma:
        1. Crie arquivos JSON para cada idioma seguindo a estrutura:
        ```json
        {
            "GREETING": "Olá mundo!",
            "WELCOME": "Bem-vindo, $v!",
            "MESSAGES": {
                "SUCCESS": "Operação realizada com sucesso",
                "ERROR": "Ocorreu um erro"
            }
        }
        ```
        
        2. Adicione os arquivos como recursos embarcados no seu arquivo de compilação:
        ```hxml
        --resource res/lang-pt.json@lang-pt
        --resource res/lang-en.json@lang-en
        ```
        
        3. Use os enums gerados para acessar os textos:
        ```haxe
        // Carrega o idioma
        Lang.setLanguage("PT");
        
        // Acessa textos via enum
        trace(Lang.GREETING);                   // "Olá mundo!"
        trace(Lang.WELCOME.params("João"));     // "Bem-vindo, João!"
        trace(Lang.MESSAGES_SUCCESS);           // "Operação realizada com sucesso"
        ```
        
        Se o idioma solicitado não for encontrado, a função emitirá um aviso no console e o dicionário atual não será alterado.

        @param language:String Código do idioma a ser carregado (ex: "PT", "EN", "ES")
    **/
    static public function setLanguage(language:String):Void {
        try {
            for (name in haxe.Resource.listNames()) {
                if (StringTools.startsWith(name, 'lang-')) {
                    var lang:String = name.split('-')[1].toUpperCase();
                    if (lang == language.toUpperCase()) {
                        var data = haxe.Json.parse(haxe.Resource.getString(name));
                        load(data);
                        return;
                    }
                }
            }

            haxe.Log.trace('WARNING: Language not found: ' + language, null);

        } catch(e:Dynamic) {
            haxe.Log.trace('WARNING: Error loading language data - ${Std.string(e)}', null);
        }
    }

    /**
        Converte automaticamente o valor do enum para a string correspondente no dicionário.
        
        Este método é chamado implicitamente quando um valor de enum é usado em um contexto de string.
        
        @return String O texto associado à chave atual no dicionário atual
    **/
    @:to
    private function toString():String return getValue(this, []);
    
    /**
        Retorna a chave do enum como uma string.
        
        Útil para casos em que você precisa da chave literal em vez do valor traduzido.
        
        @return String A chave de enum como string
    **/
    public function key():String return this;

    /**
        Aplica parâmetros a um texto que contém placeholders.
        
        Este método é usado principalmente com os valores de enum para substituir 
        os marcadores `$v` por valores dinâmicos.
        
        Exemplo:
        ```haxe
        // Com o texto "Olá, $v! Você tem $v mensagens."
        var msg = Lang.WELCOME.params("João", "5");
        // Resultado: "Olá, João! Você tem 5 mensagens."
        ```
        
        @param rest:String Valores que serão usados para substituir os marcadores `$v`
        @return String O texto com os placeholders substituídos pelos valores fornecidos
    **/
    public function params(...rest:String):String return getValue(this, rest);
    
}