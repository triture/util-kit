package util.kit.path;

import haxe.ds.StringMap;

/**
    A classe `Path<T>` é responsável por manipular padrões de caminhos (URLs ou caminhos de sistema) 
    que podem conter parâmetros tipados.

    #### Responsabilidades:
    - **Análise de padrões**: Processa strings de caminho e extrai seus componentes e parâmetros.
    - **Correspondência de caminhos**: Verifica se um caminho corresponde ao padrão definido.
    - **Extração de dados**: Extrai valores tipados de parâmetros a partir de caminhos.
    - **Construção de caminhos**: Constrói caminhos baseados em objetos de dados.
    
    #### Exemplo de uso:
    ```haxe
    // Definindo um caminho com parâmetros
    var userPath:Path<{id:Int, name:String}> = '/users/{id:Int}/{name:String}';
    
    // Verificando se um caminho corresponde ao padrão
    var matchResult = userPath.match('/users/42/john');
    
    // Extraindo parâmetros de um caminho
    var userData = userPath.extract('/users/42/john'); // {id: 42, name: "john"}
    
    // Construindo um caminho a partir de dados
    var path = userPath.build({id: 42, name: "john"}); // "/users/42/john"
    ```
    
    #### Tipos suportados:
    Os seguintes tipos são suportados para parâmetros em caminhos:
    - **Int**: Valores inteiros (ex: `{id:Int}` aceita "42", "0", "-10")
    - **String**: Valores de texto (ex: `{name:String}` aceita qualquer texto)
    - **Float**: Números decimais (ex: `{price:Float}` aceita "42.99", "0.5")
    - **Bool**: Valores booleanos (ex: `{active:Bool}` aceita "true" ou "false")
    
    Sintaxe para definir um parâmetro: `{nome:Tipo}`
    
**/
abstract Path<T>(String) {

    inline private function new(value:String) {
        this = value;
    }

    @:from
    inline static private function fromString<T>(value:String):Path<T> return new Path(value);

    /**
        Converte a instância de `Path<T>` para uma representação `String`.
        
        Exemplo:
        ```haxe
        var path:Path<Dynamic> = '/users/{id:Int}';
        var str:String = path.toString(); // "/users/{id:Int}"
        ```
        
        @return O caminho como uma string.
    **/
    @:to
    inline public function toString():String return this;

    /**
        Analisa o caminho e retorna uma lista de partes que o compõem.
        As partes podem ser strings literais ou parâmetros tipados.
        
        Exemplo:
        ```haxe
        var path:Path<Dynamic> = '/users/{id:Int}';
        var parts = path.parts(); 
        // [{part: "users", is_param: false}, {part: "{id:Int}", is_param: true, param: "id", type: INT}]
        ```
        
        @return Um array de objetos `PathPartData` representando cada parte do caminho.
    **/
    public function parts():Array<PathPartData> {
        var result:Array<PathPartData> = [];

        var capturedParams:StringMap<Int> = new StringMap<Int>();
        var pathParts:Array<String> = supportBreakParts(this);

        for (part in pathParts) {
            var param:PathParamData = supportGetParam(part);

            if (param == null) {
                result.push({part: part, is_param: false});
                continue;
            }


            if (!capturedParams.exists(param.param)) capturedParams.set(param.param, 1);
            else {
                capturedParams.set(param.param, capturedParams.get(param.param) + 1);
                param.param += '_' + capturedParams.get(param.param);
            }

            result.push({part: part, is_param: true, param: param.param, type: param.type});
        }

        return result;
    }

    private function supportBreakParts(value:String):Array<String> {
        var result:Array<String> = [];
        var parts:Array<String> = value.split('/');

        for (part in parts) if (part != '') result.push(StringTools.urlDecode(part));
        
        return result;
    }

    inline private function supportCreateEReg():EReg {
        return new EReg('^\\{([a-zA-Z_]+[\\w_]?):(Int|String|Float|Bool)\\}$', "");
    }

    /**
        Retorna uma lista de todos os parâmetros definidos no caminho.
        
        Exemplo:
        ```haxe
        var path:Path<Dynamic> = '/users/{id:Int}/{name:String}';
        var parameters = path.params(); 
        // [{param: "id", type: INT}, {param: "name", type: STRING}]
        ```
        
        @return Um array de objetos `PathParamData` representando os parâmetros.
    **/
    public function params():Array<PathParamData> {
        var result:Array<PathParamData> = [];
        var parts:Array<PathPartData> = parts();
        
        for (part in parts) {
            if (part.is_param) result.push({param: part.param, type: part.type});
        }

        return result;
    }

    private function supportGetParam(part:String):PathParamData {
        var r:EReg = supportCreateEReg();
        
        if (r.match(part)) {
            var param:String = r.matched(1);
            var type:PathParamType = r.matched(2);

            return {
                param: param, 
                type: type
            };
        }

        return null;
    }

    /**
        Verifica se uma string de caminho corresponde ao padrão definido nesta instância.
        Se houver correspondência, extrai os valores dos parâmetros no caminho.
        
        Exemplo:
        ```haxe
        // Verificar correspondência com parâmetros
        var path:Path<Dynamic> = '/users/{id:Int}/{name:String}';
        var result = path.match('/users/42/john');
        // {matched: true, params: [{param: "id", value: 42, type: INT}, {param: "name", value: "john", type: STRING}]}
        
        // Verificar uma correspondência inválida
        var invalidResult = path.match('/users/abc/john');
        // {matched: false, params: []} (falha porque "abc" não é um Int válido)
        ```
        
        @param toMatch A string de caminho que será verificada contra o padrão.
        @return Um objeto `PathMatchData` contendo o resultado da correspondência e, se bem-sucedido, os parâmetros extraídos.
    **/
    public function match(toMatch:String):PathMatchData {
        var result:PathMatchData = {matched: true, params: [] };

        var pathParts:Array<PathPartData> = parts();
        var toMatchParts:Array<String> = supportBreakParts(toMatch);
        
        if (pathParts.length != toMatchParts.length) {
            return {matched: false, params: [] };
        }

        for (i in 0 ... pathParts.length) {
            var pathPart:PathPartData = pathParts[i];
            var toMatchPart:String = toMatchParts[i];

            if (!pathPart.is_param && pathPart.part != toMatchPart) return {matched: false, params: [] };
            else if (pathPart.is_param) {

                switch (pathPart.type) {
                    case STRING : {
                        result.params.push({param: pathPart.param, value: toMatchPart, type:STRING});
                    }
                    
                    case PathParamType.INT: {
                        if (!isIntValue(toMatchPart)) return {matched: false, params: [] };
                        result.params.push({param: pathPart.param, value: Std.parseInt(toMatchPart), type: PathParamType.INT});
                    }

                    case PathParamType.FLOAT: {
                        if (!isFloat(toMatchPart)) return {matched: false, params: [] };
                        result.params.push({param: pathPart.param, value: Std.parseFloat(toMatchPart), type: PathParamType.FLOAT});
                    }

                    case PathParamType.BOOL: {
                        if (toMatchPart.toLowerCase() == 'true') {
                            result.params.push({param: pathPart.param, value: true, type: PathParamType.BOOL});
                        } else if (toMatchPart.toLowerCase() == 'false') {
                            result.params.push({param: pathPart.param, value: false, type: PathParamType.BOOL});
                        } else {
                            return {matched: false, params: [] };
                        }
                    }
                }
            }
        }

        return result;
    }

    inline private function isIntValue(value:String):Bool {
        var r:EReg = new EReg('^[-]?[\\d]+$|^[-]?0[xX][0123456789ABCFEFabcdef]+$', "");
        return r.match(value);
    }

    inline private function isFloat(value:String):Bool {
        var r:EReg = new EReg('^[-]?[\\d]+[.]?[\\d]*$', "");
        return r.match(value);
    }

    /**
        Constrói uma string de caminho substituindo os parâmetros pelos valores correspondentes no objeto de dados fornecido.
        
        Exemplo:
        ```haxe
        // Definir um caminho com múltiplos tipos de parâmetros
        var path:Path<{id:Int, name:String, active:Bool}> = '/users/{id:Int}/{name:String}/status/{active:Bool}';
        
        // Construir um caminho a partir de um objeto
        var url = path.build({id: 42, name: "john doe", active: true});
        // "/users/42/john%20doe/status/true"
        
        // Valores não fornecidos recebem valores padrão
        var url2 = path.build({id: 123});
        // "/users/123//status/false"
        ```
        
        @param data Um objeto contendo os valores para os parâmetros definidos no caminho.
        @return Uma string representando o caminho construído com os dados fornecidos.
    **/
    public function build(data:T):String {
        var result:String = '';
        var pathParts:Array<PathPartData> = parts();

        for (part in pathParts) {

            if (!part.is_param) {
                result += '/' + part.part;
                continue;
            }

            var value:Dynamic = Reflect.field(data, part.param);
            
            if (value == null) value = switch (part.type) {
                case PathParamType.INT: value = 0;
                case PathParamType.FLOAT: value = 0.0;
                case PathParamType.BOOL: value = false;
                case PathParamType.STRING: value = '';
            }

            result += '/' + StringTools.urlEncode(Std.string(value));
            
        }

        return result;
    }
    
    /**
        Extrai os valores dos parâmetros de um caminho e os retorna como um objeto tipado.
        
        Exemplo:
        ```haxe
        // Definir um caminho com parâmetros de diferentes tipos
        var path:Path<{id:Int, balance:Float, premium:Bool}> = '/account/{id:Int}/{balance:Float}/type/{premium:Bool}';
        
        // Extrair valores de um caminho real
        var data = path.extract('/account/1001/1250.75/type/true');
        // {id: 1001, balance: 1250.75, premium: true}
        
        // Com um caminho que não corresponde ao padrão
        var invalid = path.extract('/account/abc/1250.75/type/true');
        // null (porque "abc" não é um Int válido)
        ```
        
        @param path A string de caminho da qual os dados serão extraídos.
        @return Um objeto tipado contendo os valores extraídos dos parâmetros, ou null se o caminho não corresponder ao padrão.
    **/
    public function extract(path:String):T {
        var matchResult:PathMatchData = match(path);

        if (!matchResult.matched) return null;

        var result:Dynamic = { };

        for (param in matchResult.params) {
            Reflect.setField(result, param.param, param.value);
        }

        return result;
    }
}