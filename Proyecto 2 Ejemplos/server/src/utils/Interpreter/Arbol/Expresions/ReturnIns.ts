import { Instruccion } from '../Abstract/Instruccion';
import Arbol from '../Symbol/Three';
import Simbolo from '../Symbol/Symbol';
import tablaSimbolo from '../Symbol/SymbolTable';
import Tipo, {DataType} from '../Symbol/Type';

export default class ReturnIns extends Instruccion {
    private valor: Instruccion;
    
    constructor(valor: Instruccion, linea: number, columna: number) {
        super(new Tipo(DataType.INDEFINIDO), linea, columna);
        this.valor = valor;
    }

    public interpretar(arbol: Arbol, tabla: tablaSimbolo) {
        const returnValue = this.valor.interpretar(arbol, tabla);
        this.tipoDato = this.valor.tipoDato;
        return returnValue;
    }
}