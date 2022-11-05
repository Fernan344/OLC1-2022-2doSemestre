import React, { useState } from "react";
import NavBar from "../Components/NavBar";
import Editor from "../Components/Editor";
import Service from "../Services/Service";
import Table from "../Components/Table"

function Index() {
    const [ value, setValue ] = useState("")
    const [ response, setResponse ] = useState("")
    const [ cols, setCols ] = useState(["ID", "ERROR", "MENSAJE"])
    const [ index, setIndex ] = useState(0) 
    const [ tuplas, setTuplas ] = useState([["0", "Semantico", "error semantico"], ["1", "Sintactico", "error sintactico"]])

    const changeText = (valueA) => {
        setValue(valueA)
    }

    const handlerPostParse = () => {
        Service.parse(value)
        .then(({consola}) => {
            setResponse(consola)
        })
    }

    const handlerGetServerInfo = () => {
        Service.ping()
        .then((response) => {
            setResponse(JSON.stringify(response))
        })
    }

    const handlerClear = () => {
        setResponse("")
    }

    const handlerAdd = () => {
        const newTuplas = [...tuplas, [index, `registro ${index}`, `mensaje ${index}`]]
        setTuplas(newTuplas)
        setIndex(index+1)
    }

    const buttonTraducir = <button type="button" class="btn btn-outline-success" onClick={handlerPostParse}>Traducir</button>
    const buttonVivo = <button type="button" class="btn btn-outline-warning" onClick={handlerGetServerInfo}>Traducir</button>
    const buttonLimpiar = <button type="button" class="btn btn-outline-danger" onClick={handlerClear}>Limpiar</button>
    const buttonAdd = <button type="button" class="btn btn-outline-info" onClick={handlerAdd}>Add</button>
    return (
        <>
            <NavBar />
            <h1>HOLA MUNDO</h1>
            <Table columnas={cols} tuplas={tuplas}></Table>
            {
                buttonAdd
            }
            {
                buttonVivo
            }
            <Editor text={"Consola Entrada"} handlerChange={changeText} rows={25} comp = {buttonTraducir}/>
            <Editor text={"Consola Salida"} value={response} rows={10} comp = {buttonLimpiar}/>
        </>
    )
}

export default Index;