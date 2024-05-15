public without sharing class ControladorBaseConocimientos {

    private static Integer NUMERO_MESES_KNOWLEDGE = 6;
     @AuraEnabled
    public static BaseConocimientoWrapper gatListaBase(){
        BaseConocimientoWrapper respuesta = new BaseConocimientoWrapper();
        ControladorCrearCaso.ContactoWrapper prod = ControladorCrearCaso.getProductosAdquiridos();
        respuesta.listProducto = ControladorCrearCaso.getProductosAdquiridos().listTodosProductos;
        respuesta.listBaseConocimiento = new List<BaseConocimiento>();
        user usuario = [Select ContactId, Contact.AccountId, CreatedDate from User  Where Id = :userInfo.getUserId()];
        for(FS_BaseConocimiento__c item: 
            [Select Name, FS_Contenido__c, FS_Producto__c, FS_Modulo__c, FS_SubModulo__c, FS_ProductoAdquirido__c 
             from FS_BaseConocimiento__c 
             where FS_Activo__c = true  and  
             (FS_ProductoAdquirido__r.FS_Cuenta__c =: usuario.Contact.AccountId or FS_ProductoAdquirido__c = null) Order by FS_ProductoAdquirido__c, CreatedDate desc]){
                 BaseConocimiento base = new BaseConocimiento();
                 base.productoVacio = String.isBlank(item.FS_ProductoAdquirido__c);
                 if(!base.productoVacio || usuario.CreatedDate >= system.now().addMonths(-NUMERO_MESES_KNOWLEDGE) ){
                     item.FS_Contenido__c = String.isNotBlank(item.FS_Contenido__c) ? item.FS_Contenido__c : '';
                     base.contenido = item.FS_Contenido__c;
                     base.contenidoPlano = item.FS_Contenido__c.stripHtmlTags();
                     base.nombre = item.Name;
                     base.producto = item.FS_Producto__c;
                     base.modulo = item.FS_Modulo__c;
                     base.subModulo = item.FS_SubModulo__c;
                     base.id = item.Id;
                     respuesta.listBaseConocimiento.add(base);
                 }
             }
        return respuesta;
    }
    
    public class BaseConocimientoWrapper{
        @AuraEnabled public List<BaseConocimiento> listBaseConocimiento{get;set;}
        @AuraEnabled public List<ControladorCrearCaso.Producto> listProducto{get;set;}
    }
    
    public class BaseConocimiento{
        @AuraEnabled public String contenido {get;set;}
        @AuraEnabled public String contenidoPlano {get;set;}
        @AuraEnabled public String nombre {get;set;}
        @AuraEnabled public String producto {get;set;}
        @AuraEnabled public String modulo {get;set;}
        @AuraEnabled public String subModulo {get;set;}
        @AuraEnabled public Boolean productoVacio {get;set;}
        @AuraEnabled public String id {get;set;}
    }
}