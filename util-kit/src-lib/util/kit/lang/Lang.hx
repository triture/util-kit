package util.kit.lang;

import haxe.Rest;
import haxe.ds.StringMap;

/**
    A classe `Lang` oferece um sistema de internacionalização simplificado que permite carregar e acessar textos 
    através de chaves em um dicionário.
    
    É recomendado usar esta classe tanto por importação direta quanto como [extensão estática](https://haxe.org/manual/lf-static-extension.html):
    
    ```haxe
    // Importação normal
    import util.kit.lang.Lang;
    
    // Extensão estática (recomendado)
    using util.kit.lang.Lang;
    ```
    
    #### Exemplos de uso:
    
    1. Carregando dados e acessando valores simples:
    ```haxe
    // Dicionário com chaves simples
    var dictionary = {
        GREETING : "Olá mundo!",
        FAREWELL : "Adeus!"
    };
    
    // Carregar dicionário
    Lang.load(dictionary);
    
    // Acessar valores (duas formas equivalentes)
    var texto1 = Lang.lang("GREETING");  // "Olá mundo!"
    var texto2 = "FAREWELL".lang();      // "Adeus!" (usando extensão estática)
    ```
    
    2. Usando placeholders para substituição dinâmica:
    ```haxe
    // Dicionário com placeholders
    var dictionary = {
        WELCOME : "Bem-vindo, $v! Você tem $v mensagens.",
        ERROR : "Erro $v: $v"
    };
    
    Lang.load(dictionary);
    
    // Substituindo os valores
    var msg = "WELCOME".lang("João", "5");  // "Bem-vindo, João! Você tem 5 mensagens."
    var erro = "ERROR".lang("404", "Página não encontrada");  // "Erro 404: Página não encontrada"
    ```
    
    3. Usando estruturas aninhadas e arrays:
    ```haxe
    // Dicionário com estrutura hierárquica
    var dictionary = {
        MESSAGES: {
            SUCCESS: "Operação realizada com sucesso",
            ERRORS: {
                NOT_FOUND: "Registro não encontrado",
                FORBIDDEN: "Acesso negado"
            }
        },
        DAYS: ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
    };
    
    Lang.load(dictionary);
    
    // Acessando valores aninhados
    var sucesso = "MESSAGES_SUCCESS".lang();  // "Operação realizada com sucesso"
    var erro = "MESSAGES_ERRORS_NOT_FOUND".lang();  // "Registro não encontrado"
    
    // Acessando valores de array
    var domingo = "DAYS_0".lang();  // "Domingo"
    var sexta = "DAYS_5".lang();    // "Sexta"
    ```
    
    Note que todas as chaves são tratadas como case-insensitive. Portanto, "welcome", "Welcome" e "WELCOME" são 
    consideradas a mesma chave.
    
    #### Responsabilidades:
    - **Gerenciamento de dicionário de strings**: Armazena e organiza textos associados a chaves específicas
    - **Substituição de placeholders**: Substitui marcadores de texto (`$v`) por valores dinâmicos 
    - **Suporte a estruturas aninhadas**: Permite organizar o dicionário em estruturas hierárquicas e arrays
    - **Normalização de chaves**: Converte todas as chaves para maiúsculas para tornar o sistema case-insensitive
**/
class Lang {

    static private var DICTIONARY:StringMap<String>;

    /**
        Carrega dados no dicionário de internacionalização.
        Os dados podem ser estruturados como objetos aninhados ou arrays.
        Todas as chaves são convertidas para acesso case-insensitive.
        
        @param data:Dynamic Objeto contendo os dados a serem carregados no dicionário
    **/
    static public function load(data:Dynamic):Void {
        DICTIONARY = LangSupport.processDictionary(data);
    }

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
        Carrega um dicionário de idioma a partir de recursos embarcados.
        
        Esta função busca por recursos com o padrão de nome 'lang-XX', onde XX é o código do idioma 
        (por exemplo, PT, EN, ES). Quando encontra o idioma solicitado, carrega automaticamente o 
        dicionário correspondente.
        
        Os arquivos de idioma devem ser JSON válidos e seguir a estrutura de dicionário esperada pela
        função `load()`.
        
        Exemplo de uso:
        ```haxe
        // Carrega o dicionário em português
        Lang.setLanguage("PT");

        // Obtém texto traduzido
        var mensagem = "GREETING".lang(); // Retorna o texto em português

        // Alterna para inglês
        Lang.setLanguage("EN");

        // Agora obtém o mesmo texto em inglês
        var message = "GREETING".lang(); // Retorna o texto em inglês
        ```
        
        #### Como configurar os arquivos de idioma:
        1. Crie arquivos JSON para cada idioma seguindo a estrutura:
        ```json
        {
            "GREETING": "Olá mundo!",
            "FAREWELL": "Adeus!",
            "MESSAGES": {
                "SUCCESS": "Operação realizada com sucesso",
                "ERROR": "Ocorreu um erro"
            }
        }
        ```
        2. Adicione os arquivos como recursos embarcados com nomes como `lang-PT.json`, `lang-EN.json`, etc.
        3. Configure o seu projeto para incluir esses recursos usando a configuração apropriada para o seu compilador Haxe.
        ``` haxe
        // adicionar instrução no arquivo do compilador (ex: build.hxml)
        --resource res/lang-pt.json@lang-pt
        --resource res/lang-en.json@lang-en
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

    inline static public function L(key:LangKey, ...rest:String):String {
        return getValue(key, rest);
    }
}
