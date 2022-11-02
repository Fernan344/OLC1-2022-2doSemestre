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
    const procedureExec = require('./Instructions/ProcedureExec');
    const ifIns = require('./Instructions/IfIns');  
    const procedureDec = require('./Instructions/ProcedureDec');
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
"void"          return 'RESVOID';

">"             return 'MAYOR_QUE';

"||"            return 'OR';

"-"             return 'MENOS';
"="             return 'IGUAL';
"+"             return 'MAS';
":"             return 'DPUNTOS';
","             return 'COMA';
";"             return 'PTCOMA';
"("             return 'PARABRE';
")"             return 'PARCIERRA';
"{"             return 'LLAVIZQ';
"}"             return 'LLAVDER';
"["             return 'CORABRE';
"]"             return 'CORCIERRA';


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
    | INSTRUCCION          {
        $$={
            returnInstruction: [$1.returnInstruction],
            nodeInstruction: (new Nodo("Instrucciones")).generateProduction([$1.nodeInstruction])
        };
    }
;

INSTRUCCION :
    EXECPROCEDURE PTCOMA {
        $$={
            returnInstruction: $1.returnInstruction, 
            nodeInstruction: (new Nodo("INSTRUCCION")).generateProduction([$1.nodeInstruction]) 
        };
    } 
    | IMPRIMIR  PTCOMA              {
        $$={
            returnInstruction: $1.returnInstruction, 
            nodeInstruction: (new Nodo("INSTRUCCION")).generateProduction([$1.nodeInstruction]) 
        };
    } 
    | WHILEINS              {
        $$={
            returnInstruction: $1.returnInstruction, 
            nodeInstruction: (new Nodo("INSTRUCCION")).generateProduction([$1.nodeInstruction]) 
        };
    }
    | ASIGNACION    PTCOMA        {
        $$={
            returnInstruction: $1.returnInstruction, 
            nodeInstruction: (new Nodo("INSTRUCCION")).generateProduction([$1.nodeInstruction]) 
        };
    } 
    | IFINS                 {
        $$={
            returnInstruction: $1.returnInstruction, 
            nodeInstruction: (new Nodo("INSTRUCCION")).generateProduction([$1.nodeInstruction]) 
        };
    }
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
    IDENTIFICADOR IGUAL EXPRESION 
                            {
                                $$ = {
                                    returnInstruction: new asignacion.default($1, $3.returnInstruction,@1.first_line,@1.first_column),
                                    nodeInstruction: (new Nodo("ASIGNACION")).generateProduction([$1, $2, $3.nodeInstruction])
                                }
                            }
;

/* WHILE */ 

WHILEINS:
    RESWHILE PARABRE EXPRESION_LOGICA PARCIERRA LLAVIZQ INSTRUCCIONES LLAVDER {
        $$ = {
            returnInstruction: new mientras.default($3.returnInstruction,$6.returnInstruction,@1.first_line,@1.first_column),
            nodeInstruction: (new Nodo("WHILEINS")).generateProduction([$1, $2, $3.nodeInstruction, $4, $5, $6.nodeInstruction, $7])
        }
    }
;

/*IF INS*/

IFINS:
    SIMPLEIF                {
        $$ = {
            returnInstruction: $1.returnInstruction,
            nodeInstruction: (new Nodo('IFINS')).generateProduction([$1.nodeInstruction])
        }
    }                            
    | RESIF PARABRE EXPRESION_LOGICA PARCIERRA LLAVIZQ INSTRUCCIONES LLAVDER ELSEIFSINS RESELSE LLAVIZQ INSTRUCCIONES LLAVDER 
    {
        $$={
            returnInstruction: new ifIns.default($3,$6,$8,$11,@1.first_line,@1.first_column),
            nodeInstruction: (new Nodo('IFINS')).generateProduction([$1, $2, $3.nodeInstruction, $4, $5, $6.nodeInstruction, $7, $8.nodeInstruction, $9, $10, $11.nodeInstruction,$12])
        };
    } 
;

SIMPLEIF:
    RESIF PARABRE EXPRESION_LOGICA PARCIERRA LLAVIZQ INSTRUCCIONES LLAVDER {
        $$={
            returnInstruction: new ifIns.default($3,$6, undefined, undefined, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('SIMPLEIF')).generateProduction([$1, $2, $3.nodeInstruction, $4, $5, $6.nodeInstruction, $7])
        }
    }
;

ELSEIFSINS :
    ELSEIFSINS RESELSE SIMPLEIF 
                                                {
                                                    $1.returnInstruction.push($3.returnInstruction); 
                                                    $$={
                                                        returnInstruction: $1.returnInstruction,
                                                        nodeInstruction: (new Nodo('ELSEIFSINS')).generateProduction([$1.nodeInstruction, $2, $3.nodeInstruction])
                                                    }
                                                }
  | RESELSE SIMPLEIF  
                                                {
                                                    $$={
                                                        returnInstruction: [$2],
                                                        nodeInstruction: (new Nodo('ELSEIFSINS')).generateProduction([$1, $2.nodeInstruction])
                                                    }
                                                }
;

/* TYPES */

DATATYPES:
    RESINT                                      {
        $$={
            returnInstruction: new Tipo.default(Tipo.DataType.ENTERO),
            nodeInstruction: (new Nodo('DATATYPES')).generateProduction([$1])
        }
    }    
;

PROCEDURESDATATYPES:
    DATATYPES {
        $$={
            returnInstruction: $1.returnInstruction,
            nodeInstruction: (new Nodo('PROCEDURESDATATYPES')).generateProduction([$1.nodeInstruction])
        }
    }    
    | RESVOID {
        $$ = {
            returnInstruction: new Tipo.default(Tipo.DataType.VOID),
            nodeInstruction: (new Nodo('PROCEDURESDATATYPES')).generateProduction([$1])
        }
    }
;

/* DECLACION */

DECLARACION:
    DATATYPES IDENTIFICADOR IGUAL EXPRESION PTCOMA {
        $$={
            returnInstruction: new declaracion.default($2, $1.returnInstruction, $4.returnInstruction, @1.first_line, @1.first_column), 
            nodeInstruction: (new Nodo('Declaracion')).generateProduction([$1.nodeInstruction, 'identificador', 'igual', $4.nodeInstruction])
        }
    } 
    | IDENTIFICADOR PARABRE DECLARATIONPARAMS PARCIERRA DPUNTOS PROCEDURESDATATYPES LLAVIZQ INSTRUCCIONES LLAVDER {
        $$={
            returnInstruction: new procedureDec.default($1, $6.returnInstruction, $8.returnInstruction, $3.returnInstruction, @1.first_line, @1.first_column), 
            nodeInstruction: (new Nodo('Declaracion')).generateProduction([$1, $2, $3.nodeInstruction, $4, $5, $6.nodeInstruction, $7, $8.nodeInstruction, $9])
        }
    }
;

/* PROCEDURES */

DECLARATIONPARAMS:
    DECLARATIONPARAMS COMA DECLARATIONPARAM {
        $1.returnInstruction.push($3.returnInstruction); 
        $$={
            returnInstruction: $1.returnInstruction,
            nodeInstruction: (new Nodo('DECLARATIONPARAMS')).generateProduction([$1.nodeInstruction, $2, $3.nodeInstruction])
        }
    }
    | DECLARATIONPARAM {
        $$={
            returnInstruction: [$1.returnInstruction],
            nodeInstruction: (new Nodo('DECLARATIONPARAMS')).generateProduction([$1.nodeInstruction])
        }
    }
    | {
        $$={
            returnInstruction: [],
            nodeInstruction: (new Nodo('DECLARATIONPARAMS')).generateProduction(["VACIO"])
        }
    }
;

DECLARATIONPARAM:
    DATATYPES IDENTIFICADOR {
        $$={
            returnInstruction: { id: $2, type: $1.returnInstruction },
            nodeInstruction: (new Nodo('DECLARATIONPARAMS')).generateProduction([$1.nodeInstruction, $2])
        }
    }
;

EXECPROCEDURE:
    IDENTIFICADOR CORABRE EXECPARAMS CORCIERRA {
        $$={
            returnInstruction: new procedureExec.default($1, $3.returnInstruction, @1.first_line, @1.first_column), 
            nodeInstruction: (new Nodo('EXECPROCEDURE')).generateProduction([$1, $2, $3.nodeInstruction, $4])
        }
    }
;

EXECPARAMS:
    EXECPARAMS COMA IMPRIMIBLE {
        $1.returnInstruction.push($3.returnInstruction); 
        $$={
            returnInstruction: $1.returnInstruction,
            nodeInstruction: (new Nodo('EXECPARAMS')).generateProduction([$1.nodeInstruction, $2, $3.nodeInstruction])
        }
    }
    | IMPRIMIBLE {
        $$={
            returnInstruction: [$1.returnInstruction],
            nodeInstruction: (new Nodo('EXECPARAMS')).generateProduction([$1.nodeInstruction])
        }
    }
    | {
        $$={
            returnInstruction: [],
            nodeInstruction: (new Nodo('EXECPARAMS')).generateProduction(["VACIO"])
        }
    }
;

/* IMPRIMIR */

IMPRIMIBLE:
    EXPRESION {
        $$ = {
            returnInstruction: $1.returnInstruction,
            nodeInstruction: (new Nodo('IMPRIMIBLE')).generateProduction([$1.nodeInstruction])
        }
    }  
    | EXPRESION_LOGICA {
        $$ = {
            returnInstruction: $1.returnInstruction,
            nodeInstruction: (new Nodo('IMPRIMIBLE')).generateProduction([$1.nodeInstruction])
        }
    }  
;

IMPRIMIR : 
    RESPRINT PARABRE IMPRIMIBLE PARCIERRA {
        $$= {
            returnInstruction: new impresion.default($3.returnInstruction,@1.first_line,@1.first_column),
            nodeInstruction: (new Nodo('IMPRIMIR')).generateProduction([$1, $2, $3.nodeInstruction, $4])
        }
    }
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
    EXPRESION MAYOR_QUE EXPRESION {
        $$ = {
            returnInstruction: new relacional.default(relacional.tipoOp.MAYOR, $1.returnInstruction, $3.returnInstruction, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION_RELACIONAL')).generateProduction([$1.nodeInstruction, $2, $3.nodeInstruction])
        }
    }
;

EXPRESION_LOGICA :
    EXPRESION_LOGICA OR EXPRESION_RELACIONAL {
        $$ = {
            returnInstruction: new logica.default(logica.tipoOp.OR, $1.returnInstruction, $3.returnInstruction, @1.first_line, @1.first_column),
            nodeInstruction: (new Nodo('EXPRESION_LOGICA')).generateProduction([$1.nodeInstruction, $2, $3.nodeInstruction])
        }
    }
    | EXPRESION_RELACIONAL                   {
        $$ = {
            returnInstruction: $1.returnInstruction,
            nodeInstruction: (new Nodo('EXPRESION_RELACIONAL')).generateProduction([$1.nodeInstruction])
        }
    }
;