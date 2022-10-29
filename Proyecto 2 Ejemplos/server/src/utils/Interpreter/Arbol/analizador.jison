%{
    //codigo js
    const controller = require('../../../controller/parser/parser');
    const errores = require('./Exceptions/Error');
    const nativo = require('./Expresions/Native');
    const aritmetico = require('./Expresions/Aritmetica');
    const relacional = require('./Expresions/Relacional');
    const logica = require('./Expresions/Logica');
    const Tipo = require('./Symbol/Type');
    const impresion = require('./Instructions/Imprimir');   
    const ifIns = require('./Instructions/IfIns');  
    const declaracion = require('./Instructions/Declaracion');
    const mientras = require('./Instructions/Mientras');
    const asignacion = require('./Instructions/Asignacion');
    const { Nodo } = require('./Symbol/Three');
%}
%lex 


%options case-insensitive 
//inicio analisis lexico
%%
"imprimir"      return 'RESPRINT';
"entero"        return 'RESINT';
"if"            return 'RESIF';
"else"          return 'RESELSE';
"mientras"      return 'RESWHILE';

">"             return 'MAYOR_QUE';

"||"            return 'OR';

"-"             return 'MENOS';
"="             return 'IGUAL';
"+"             return 'MAS';
";"             return 'PTCOMA';
"("             return 'PARABRE';
")"             return 'PARCIERRA';
"{"             return 'LLAVIZQ';
"}"             return 'LLAVDER';


[ \r\t]+ { }
\n {}
\"[^\"]*\"                  { yytext=yytext.substr(1,yyleng-2); return 'CADENA'; }
[0-9]+                      return 'ENTERO';
[A-Za-z]+["_"0-9A-Za-z]*    return 'IDENTIFICADOR';

<<EOF>>                     return 'EOF';
.                           return 'INVALID'

/lex

%left 'MAS' 'MENOS'
%left 'MAYOR_QUE'
%left 'OR'

%start INIT
//Inicio
//Definicion de gramatica
%%

INIT: INSTRUCCIONES EOF     {
        return {
            returnInstruction: $1.returnInstruction, 
            nodeInstruction: (new Nodo("INIT")).generateProduction([$1.nodeInstruction, 'EOF'])            
        };
    }
;

INSTRUCCIONES : 
    INSTRUCCIONES INSTRUCCION   {        
        $$={
            returnInstruction: [...$1.returnInstruction, $2.returnInstruction], 
            nodeInstruction: (new Nodo("Instrucciones")).generateProduction([$1.nodeInstruction,  $2.nodeInstruction]) 
        };
    }
    | INSTRUCCION               {
        $$={
            returnInstruction: [$1.returnInstruction],
            nodeInstruction: (new Nodo("Instrucciones")).generateProduction([$1.nodeInstruction])
        };
    }
;

INSTRUCCION :
    IMPRIMIR                {$$=$1;} 
    | WHILEINS              {$$=$1;}
    | ASIGNACION            {$$=$1;} 
    | IFINS                 {$$=$1;}
    | DECLARACION           {
        $$={
            returnInstruction: $1.returnInstruction, 
            nodeInstruction: (new Nodo("INSTRUCCION")).generateProduction([$1.nodeInstruction]) 
        };
    }
    | INVALID               {controller.listaErrores.push(new errores.default('ERROR LEXICO',$1,@1.first_line,@1.first_column));}
    | error  PTCOMA         {controller.listaErrores.push(new errores.default(`ERROR SINTACTICO`,"Se esperaba token",@1.first_line,@1.first_column));}
;

/* ASIGNACION */ 

ASIGNACION :
    IDENTIFICADOR IGUAL EXPRESION PTCOMA 
                            {$$ = new asignacion.default($1, $3,@1.first_line,@1.first_column);}
;

/* WHILE */ 

WHILEINS:
    RESWHILE PARABRE EXPRESION_LOGICA PARCIERRA LLAVIZQ INSTRUCCIONES LLAVDER
                            {$$ = new mientras.default($3,$6,@1.first_line,@1.first_column)}
;

/*IF INS*/

IFINS:
    SIMPLEIF                {$$ = $1;}                            
    | RESIF PARABRE EXPRESION_LOGICA PARCIERRA LLAVIZQ INSTRUCCIONES LLAVDER ELSEIFSINS RESELSE LLAVIZQ INSTRUCCIONES LLAVDER 
                            {$$=new ifIns.default($3,$6,$8,$11,@1.first_line,@1.first_column);} 
;

SIMPLEIF:
    RESIF PARABRE EXPRESION_LOGICA PARCIERRA LLAVIZQ INSTRUCCIONES LLAVDER 
                            {$$=new ifIns.default($3,$6, undefined, undefined, @1.first_line, @1.first_column);}
;

ELSEIFSINS :
    ELSEIFSINS RESELSE SIMPLEIF 
                                                {$1.push($3); $$=$1;}
  | RESELSE SIMPLEIF  
                                                {$$=[$2];;}
;

/* DECLACION */

DECLARACION:
    RESINT IDENTIFICADOR IGUAL EXPRESION PTCOMA {
        $$={
            returnInstruction: new declaracion.default($2, new Tipo.default(Tipo.DataType.ENTERO), $4.returnInstruction, @1.first_line, @1.first_column), 
            nodeInstruction: (new Nodo('Declaracion')).generateProduction(['entero', 'identificador', 'igual', $4.nodeInstruction, 'ptcoma'])
        }
    }
;

/* IMPRIMIR */

IMPRIMIBLE:
    EXPRESION {$$=$1;}  
    | EXPRESION_LOGICA {$$=$1;}  
;

IMPRIMIR : 
    RESPRINT PARABRE IMPRIMIBLE PARCIERRA PTCOMA {$$=new impresion.default($3,@1.first_line,@1.first_column);}
;

/* EXPRESIONES */

EXPRESION : 
    EXPRESION MAS EXPRESION {
        $$={
            returnInstruction: new aritmetico.default(aritmetico.tipoOp.SUMA, $1.returnInstruction, $3.returnInstruction, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION')).generateProduction([$1.nodeInstruction, 'SUMA', $3.nodeInstruction])
        }
    }
    | EXPRESION MENOS EXPRESION {
        $$={
            returnInstruction: new aritmetico.default(aritmetico.tipoOp.RESTA, $1.returnInstruction, $3.returnInstruction, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION')).generateProduction([$1.nodeInstruction, 'MENOS', $3.nodeInstruction])
        }
    }
    | IDENTIFICADOR {
        $$={
            returnInstruction: new nativo.default(new Tipo.default(Tipo.DataType.IDENTIFICADOR), $1, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION')).generateProduction(['IDENTIFICADOR'])
        }
    }
    | ENTERO {
        $$={
            returnInstruction: new nativo.default(new Tipo.default(Tipo.DataType.ENTERO),$1, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION')).generateProduction(['ENTERO'])
        }
    }
    | CADENA {
        $$={
            returnInstruction: new nativo.default(new Tipo.default(Tipo.DataType.CADENA),$1, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION')).generateProduction(['CADENA'])
        }
    }
;

EXPRESION_RELACIONAL :
    EXPRESION MAYOR_QUE EXPRESION {$$ = new relacional.default(relacional.tipoOp.MAYOR, $1, $3, @1.first_line, @1.first_column);}
;

EXPRESION_LOGICA :
    EXPRESION_LOGICA OR EXPRESION_RELACIONAL {$$ = new logica.default(logica.tipoOp.OR, $1, $3, @1.first_line, @1.first_column);}
    | EXPRESION_RELACIONAL                   {$$ = $1;}
;