import { Instruccion } from '../Abstract/Instruccion';
import Arbol from '../Symbol/Three';
import Simbolo from '../Symbol/Symbol';
import tablaSimbolo from '../Symbol/SymbolTable';
import Tipo, {DataType} from '../Symbol/Type';

export default class ProcedureDec extends Instruccion {
    private id: String;
    private tipo: Tipo;
    private instrucciones: Instruccion [];
    private declarationParams: Simbolo [];
    
    constructor(id: String, tipo: Tipo, instrucciones: Instruccion [], declarationParams: any[], linea: number, columna: number) {
        super(new Tipo(DataType.INDEFINIDO), linea, columna);
        this.id = id;
        this.tipo = tipo;
        this.instrucciones = instrucciones;
        this.declarationParams = declarationParams.map((param) => new Simbolo(param.type, param.id));
    }

    public getInstrucciones(): Instruccion [] {
        return this.instrucciones;
    }

    public getDeclarationParams(): Simbolo [] {
        return this.declarationParams;
    }

    public interpretar(arbol: Arbol, tabla: tablaSimbolo) {
        tabla.setValor(this.id, new Simbolo(this.tipo, this.id, this));
        return null;
    }
}