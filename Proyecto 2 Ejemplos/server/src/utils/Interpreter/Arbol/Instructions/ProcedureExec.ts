import { Instruccion } from '../Abstract/Instruccion';
import Arbol from '../Symbol/Three';
import tablaSimbolo from '../Symbol/SymbolTable';
import Tipo, {DataType} from '../Symbol/Type';
import Symbol from '../Symbol/Symbol';
import get from 'lodash/get'
import cloneDeep from 'lodash/cloneDeep';
import ReturnIns from '../Expresions/ReturnIns';

export default class ProcedureExec extends Instruccion {
    private id: String;
    private execParams: Instruccion [];
    
    constructor(id: String, execParams: Instruccion[], linea: number, columna: number) {
        super(new Tipo(DataType.INDEFINIDO), linea, columna);
        this.id = id;
        this.execParams = execParams;
    }

    public getexecParams(): Instruccion [] {
        return this.execParams;
    }

    public getId(): String {
        return this.id;
    }

    public interpretar(arbol: Arbol, tabla: tablaSimbolo) {
        const value = tabla.getValor(this.id)
        this.tipoDato = get(value, 'tipo', new Tipo(DataType.INDEFINIDO));
        const procedure = cloneDeep(value.valor)
        const paramsList: any[] = procedure.getDeclarationParams();
        const insList: Instruccion[] = procedure.getInstrucciones();
        const procType = procedure.tipo;
        if(this.execParams.length !== paramsList.length) arbol.setSemanticError("Listado de parametros incorrectos")
        const procTable = new tablaSimbolo(tabla);        
        paramsList.forEach((param: Symbol, index: number) => {
            const newParamValue = this.execParams[index];
            const value = newParamValue.interpretar(arbol, tabla);
            param.setvalor(value)
            procTable.setValor(param.getidentificador(), param, true);
        })
        console.log(insList)
        for (let i of insList) {
            const valueToReturn = i.interpretar(arbol, procTable)
            if(i instanceof ReturnIns || valueToReturn instanceof ReturnIns){
                if(i.tipoDato === procType){
                    this.tipoDato = procType;
                    return valueToReturn;
                }else{
                    arbol.setSemanticError("Tipo de dato de retorno incorrecto")
                }
            }
            
        }
        //return get(value, 'valor')
        return null;
    }
}