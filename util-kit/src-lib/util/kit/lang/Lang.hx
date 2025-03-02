package util.kit.lang;

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
    var sucesso = "MESSAGES.SUCCESS".lang();  // "Operação realizada com sucesso"
    var erro = "MESSAGES.ERRORS.NOT_FOUND".lang();  // "Registro não encontrado"
    
    // Acessando valores de array
    var domingo = "DAYS.0".lang();  // "Domingo"
    var sexta = "DAYS.5".lang();    // "Sexta"
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
        DICTIONARY = processData(data);
    }

    static private function processData(data:Dynamic, ?field:String, ?result:StringMap<String>):StringMap<String> {
        if (result == null) result = new StringMap<String>();
        if (data == null) return result;
        
        if (field == null) field = '';
        else field = field.toUpperCase() + '.';

        for (key in Reflect.fields(data)) {
            var value:Dynamic = Reflect.field(data, key);
            
            if (Std.isOfType(value, Array)) {
                var arr:Array<Dynamic> = value;
                
                for (i in 0...arr.length) {
                    var item:Dynamic = arr[i];
                    result.set(field + key.toUpperCase() + '.${i}', Std.string(item));
                }
            }
            else if (Std.isOfType(value, String)) result.set(field + key.toUpperCase(), value);
            else if (Std.isOfType(value, Bool) || Std.isOfType(value, Int) || Std.isOfType(value, Float)) result.set(field + key.toUpperCase(), Std.string(value));
            else processData(value, field + key, result);

        }

        return result;
    }

    /**
        Obtém um texto do dicionário a partir de uma chave e substitui os marcadores de 
        posição (`$v`) pelos parâmetros fornecidos.
        
        Os marcadores `$v` no texto serão substituídos sequencialmente pelos valores fornecidos.
        Se um valor for `null`, ele será substituído por uma string vazia.
        
        @param value:String A chave que identifica o texto no dicionário
        @param rest:String Valores que serão usados para substituir os marcadores `$v` no texto
        @return String O texto processado com as substituições ou uma string vazia se a chave não existir
    **/
    static public function lang(value:String, ...rest:String):String {
        if (DICTIONARY == null) DICTIONARY = new StringMap<String>();

        var value:String = DICTIONARY.get(value.toUpperCase());

        if (value == null) return '';
        if (rest == null || rest.length == 0) return value;
        
        var result:String = '';
        
        var ereg:EReg = ~/\$v/m;
        var count:Int = 0;

        while (ereg.match(value)) {
            result += ereg.matchedLeft();
            
            var restValue:String = rest[count];
            if (restValue == null) restValue = '';

            result += restValue;
            value = ereg.matchedRight();

            count++;
            if (count > rest.length) break;            
        }

        return result + value;
    }

}