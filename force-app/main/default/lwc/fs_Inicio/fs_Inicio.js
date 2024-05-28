import { LightningElement, track } from 'lwc';

import urlVideo1 from '@salesforce/label/c.FS_UrlVideoDestacado1';
import tituloVideo1 from '@salesforce/label/c.FS_TituloVideoDestacado1';
import urlVideo2 from '@salesforce/label/c.FS_UrlVideoDestacado2';
import tituloVideo2 from '@salesforce/label/c.FS_TituloVideoDestacado2';
import urlVideo3 from '@salesforce/label/c.FS_UrlVideoDestacado3';
import tituloVideo3 from '@salesforce/label/c.FS_TituloVideoDestacado3';
import urlVideo4 from '@salesforce/label/c.FS_UrlVideoDestacado4';
import tituloVideo4 from '@salesforce/label/c.FS_TituloVideoDestacado4';
import urlPaginaNoticias from '@salesforce/label/c.FS_UrlPaginaNoticias';

import gatListaBase from "@salesforce/apex/ControladorBaseConocimientos.gatListaBase";

export default class Fs_Inicio extends LightningElement {
   @track data = {
        urlVideo1 : urlVideo1,
        urlVideo2 : urlVideo2,
        urlVideo3 : urlVideo3,
        urlVideo4 : urlVideo4,
        tituloVideo1: tituloVideo1,
        tituloVideo2: tituloVideo2,
        tituloVideo3: tituloVideo3,
        tituloVideo4: tituloVideo4,
        urlPaginaNoticias: urlPaginaNoticias,
        listBase: [],
        listBaseShow: [],
        listTodosProductos: [],
        listProductos: [],
        productoSelect: '--',
        listModulos: [],
        moduloSelect: '--',
        listSubModulos: [],
        subModuloSelect: '--',
        mostrarBaseCon: false,
        hayResultado: false,
        valorABuscar: '',
        listPickListBase: [],
        knowledgeSelect: '--',
    }
    showSpinner = true;


    connectedCallback() {
        this.showSpinner = true;
        gatListaBase({}).then(response => {
            //console.log("Respuesta: "+JSON.stringify(response))
            this.data.listBase = response.listBaseConocimiento;
            this.data.listTodosProductos = response.listProducto;
            this.data.mostrarBaseCon = this.data.listBase.length > 0;
            this.data.hayResultado = this.data.mostrarBaseCon;
            for(let i=0; i < this.data.listBase.length; i++){
                if(this.data.listBase[i].productoVacio  || this.data.listBaseShow.length < 3){
                    this.data.listBaseShow.push(this.data.listBase[i]);
                }
            }
            let listItems = [];
            this.data.listProductos.push({"value" : "--","label" : "--Ninguno--" });
            for(let i=0; i < this.data.listTodosProductos.length; i++){
                let prod = this.data.listTodosProductos[i].producto;
                if(!listItems.includes(prod) && prod != null){
                    listItems.push(prod);
                    this.data.listProductos.push({"value" : prod,"label" : prod });
                }
            }
            this.showSpinner = false;
        }).catch(error => {
            this.showSpinner = false;
            console.log("Error: "+JSOn.stringify(error));
        });
    }
    
    onchangeProduct(event){
        let value = event.target.value;
        this.data.productoSelect = event.target.value;
        this.data.listModulos = [];
        this.data.listSubModulos = [];
        this.data.listPickListBase = [];
        this.data.moduloSelect = '--';
        this.data.subModuloSelect = '--';
        this.data.knowledgeSelect = '--'; 
        if(this.data.productoSelect == '--'){
            this.onclickAllShow();
        }else{
            let listItems = [];
            this.data.listModulos.push({"value" : "--","label" : "--Ninguno--" });
            for(let i=0; i < this.data.listTodosProductos.length; i++){
                let prod = this.data.listTodosProductos[i].producto;
                let mod = this.data.listTodosProductos[i].modulo;
                if(prod === value && !listItems.includes(mod)){
                    listItems.push(mod);
                    this.data.listModulos.push({"value" : mod,"label" : mod });
                }
            }
            this.searchFilter();
    }
    }

    onchangeModulo(event){
        let value = event.target.value;
        this.data.moduloSelect = event.target.value;
        
        this.data.listSubModulos = [];
        this.data.listPickListBase = [];
        this.data.knowledgeSelect = '--'; 
        this.data.subModuloSelect = '--';

        let listItems = [];
        this.data.listSubModulos.push({"value" : "--","label" : "--Ninguno--" });
        for(let i=0; i < this.data.listTodosProductos.length; i++){
            let prod = this.data.listTodosProductos[i].producto;
            let mod = this.data.listTodosProductos[i].modulo;
            let subMod = this.data.listTodosProductos[i].subModulo;
            if(prod === this.data.productoSelect &&  mod === value && !listItems.includes(subMod) && subMod != null){
                listItems.push(subMod);
                this.data.listSubModulos.push({"value" : subMod,"label" : subMod });
            }
        }
        this.searchFilter();
    }

    onchangeSubModulo(event){
        let value = event.target.value;
        this.data.listPickListBase = [];
        this.data.knowledgeSelect = '--'; 
        this.data.subModuloSelect = value;
        this.searchFilter();
    }
    onchangeKnowledge(event){
        this.data.knowledgeSelect = event.target.value;
        if(this.data.knowledgeSelect != '--'){
            this.data.listBaseShow = this.data.listBase.filter(item => item.id === this.data.knowledgeSelect);
        }else{
            this.searchFilter();
        }
    }

    searchFilter(){
        this.data.listBaseShow = this.data.listBase.filter(item => item.producto === this.data.productoSelect && (this.data.moduloSelect === '--' || item.modulo === this.data.moduloSelect) &&
        (this.data.subModuloSelect === '--' || item.subModulo === this.data.subModuloSelect));
        this.data.hayResultado = this.data.listBaseShow.length > 0;
        this.data.listPickListBase = [];
        this.data.listPickListBase.push({"value" : "--","label" : "--Ninguno--" });
        for(let i=0; i < this.data.listBaseShow.length; i++){
            this.data.listPickListBase.push({"value" : this.data.listBaseShow[i].id,"label" : this.data.listBaseShow[i].nombre });
        }
    }

    onchangeSearch(event){
        let value = event.target.value;
        this.data.valorABuscar = value;
        if(value.length > 2){
            this.data.listBaseShow = this.data.listBase.filter(item => !item.productoVacio && (item.contenidoPlano.toUpperCase().includes(value.toUpperCase() ) || item.nombre.toUpperCase().includes(value.toUpperCase()) ||
            item.producto.toUpperCase().includes(value.toUpperCase()) || item.modulo.toUpperCase().includes(value.toUpperCase()) ||
            (item.subModulo != null && item.subModulo.toUpperCase().includes(value.toUpperCase()))));
        }else if(value.length === 0){
            this.data.listBaseShow = [];
            for(let i=0; i < this.data.listBase.length; i++){
                if(this.data.listBase[i].productoVacio || this.data.listBaseShow.length < 3){
                    this.data.listBaseShow.push(this.data.listBase[i]);
                }
            }
        }
        this.data.hayResultado = this.data.listBaseShow.length > 0;
        this.clearList();
    }

    onclickAllShow(){
        this.data.valorABuscar = null;
        this.data.listBaseShow = this.data.listBase;
        this.data.hayResultado = this.data.listBaseShow.length > 0;
        this.clearList();
    }
    clearList(){
        this.data.listModulos = [];
        this.data.listSubModulos = [];
        this.data.listPickListBase = [];
        this.data.moduloSelect = '--';
        this.data.subModuloSelect = '--';
        this.data.productoSelect = '--';
        this.data.knowledgeSelect = '--';
    }
}