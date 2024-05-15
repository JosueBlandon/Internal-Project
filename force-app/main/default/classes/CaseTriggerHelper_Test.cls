/**
**************************************************************************************************************
* @author           Intellect Systems href=<infor@intellectsystems.net>
* @project          Fisa Ecuador - Implementación CRM
* @name             CaseTriggerHelper_Test
* @description      Test class to CaseTriggerHelper
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2023-04-09   Intellect Systems             Initial version.
**************************************************************************************************************
*/

@isTest
public class CaseTriggerHelper_Test {

    @TestSetup
    static void setup(){ 
        Account acc = DataFactory.insertAccount();
        Contact cont = DataFactory.insertContact(acc);
        User user = DataFactory.insertUserCommunity(cont);
        System.runAs(user){
        FS_ProductoAdquirido__c p = DataFactory.insertProduct(acc, 'FISA System', 'Núcleo del Sistema', '');
        test.startTest();
        DataFactory.insertCase(acc, cont, p, 'FS_Consulta');
        DataFactory.insertCase(acc, cont, p, 'FS_Solicitud');
        DataFactory.insertCase(acc, cont, p, 'FS_Incidente');
        DataFactory.insertProduct(acc, 'FISA System', 'Núcleo del Sistema', 'Seguridades (Modulo 90)');
        test.stopTest();
        }
    }
    
    @isTest
    static void CasoConsulta() {
        Case caso =  [Select Id, AccountId, RecordType.DeveloperName from Case Where RecordTypeId = :CaseTriggerHelper.CONSULTA_TIPO_REGISTRO];
        
        Account acc = DataFactory.insertAccount();
        caso.AccountId = acc.Id;
        update caso;

        FS_ProductoAdquirido__c prod = new FS_ProductoAdquirido__c();
        prod.FS_Cuenta__c = acc.Id;
        prod.FS_Producto__c = 'FISA System';
        prod.FS_Modulo__c = 'Núcleo del Sistema';
        prod.FS_SubModulo__c = 'Seguridades (Modulo 90)';
        prod.FS_Esta_activo__c = true;
        Insert prod;

        caso.FS_InformacionCompleta__c = 'No';
        update caso;
        
        caso.FS_DescripcionCliente__c = '<p>Test Test</p>';
        update caso;
        
        caso.FS_InformacionCompleta__c = 'Si';
        actualizarCasoError(caso);
        caso.FS_Proyecto__c = 'FSHD001 - Fisa System Help desk';
        caso.FS_PudeSolventarPregunta__c = 'Si';
        caso.FS_FechaCompromisoEntrega__c = Date.today();
        update caso;
        
        caso.FS_PudeSolventarPregunta__c = 'Si';
        update caso;
        caso.FS_AprobacionSolucion__c = 'Si';
        update caso;
        caso.FS_AprobacionSolucion__c = 'No';
        caso.FS_ComentariosRechazoSolucion__c = 'No';
        update caso;
        actualizarCasoError(caso);
        caso.FS_Producto__c = null;
        actualizarCasoError(caso);
        caso.FS_Producto__c = 'FISA System';
        caso.FS_Modulo__c = 'Núcleo del Sistema';
        caso.FS_SubModulo__c = 'Seguridades (Modulo 90)';
        update caso;
        
        caso.FS_PudeSolventarPregunta__c = 'No';
        update caso;
        
        caso.OwnerId = userInfo.getUserId();
        update caso;
        
        caso.FS_AceptaRespuesta__c = 'No';
        update caso;
        
        caso.FS_Area__c = 'N1. CORE';
        caso.FS_PudeSolventarPregunta__c = 'Si';
        caso.FS_AceptaRespuesta__c = 'Si';
        update caso;
        
        delete caso;
    }
    
    @isTest
    static void CasoSolicitud() {
        Case caso =  [Select Id, RecordType.DeveloperName from Case Where RecordTypeId = :CaseTriggerHelper.SOLICITUD_TIPO_REGISTRO];
        
        caso.FS_InformacionCompleta__c = 'Si';
        actualizarCasoError(caso);
        caso.FS_Proyecto__c = 'FSHD001 - Fisa System Help desk';
        caso.FS_FechaCompromisoEntrega__c = Date.today();
        caso.FS_FechaAprobacion1erCosto__c = Date.today();
        update caso;
        
        caso.FS_Acepta1erCosto__c = 'No';
        update caso;
        
        caso.FS_Acepta1erCosto__c = 'Si';
        update caso;
        
        caso.FS_NumeroHorasSolicitud__c = 12;
        update caso;
        
    }
    
    @isTest
    static void CasoIncidentePuntual() {
        Case caso =  [Select Id, RecordType.DeveloperName from Case Where RecordTypeId = :CaseTriggerHelper.INCIDENTE_TIPO_REGISTRO];
        
        caso.FS_InformacionCompleta__c = 'Si';
        actualizarCasoError(caso);
        caso.FS_Proyecto__c = 'FSHD001 - Fisa System Help desk';
        caso.FS_FechaCompromisoEntrega__c = Date.today();
        update caso;
        
        caso.FS_URLResultadoAnalasis__c = 'https://fisagrp.com';
        update caso;
        actualizarCasoError(caso);
        
        caso.FS_AprobacionSolucionIPN2__c = 'No';
        caso.FS_MotivosRechazoAprobacionIPN2__c = 'Desarrollo incompleto';
        caso.FS_UsuarioAprobadorSolucionIPN2__c = userInfo.getUserId();
        update caso;
        
        caso.FS_URLResultadoAnalasis__c = 'https://fisagrp.com';
        caso.FS_EnviarAprobacionSolucionIPN2__c = true;
        update caso;
        caso.FS_AprobacionSolucionIPN2__c = 'Si';
        caso.FS_MotivosRechazoAprobacionIPN2__c = null;
        update caso;
        
        actualizarCasoError(caso);
        caso.FS_UsuarioAprobacionSolucionRelease__c = 'Test';
        caso.FS_AprobacionSolucionIPRelease__c = 'No';
        caso.FS_MotivoRechazoAprobacionIPRealease__c = 'Desarrollo incompleto';
        update caso;
        
        caso.FS_AprobacionSolucionIPRelease__c = 'Si';
        update caso;
        
        caso.FS_TipoIncidente__c = 'Definitivo';
        update caso;
        
        /*caso.FS_SolucionCortoPlazo__c = 'Si';
        actualizarCasoError(caso);
        caso.FS_PropietarioCasoSolucionCortoPlazo__c = userInfo.getUserId();
        caso.OwnerId = userInfo.getUserId();
        update caso;
        actualizarCasoError(caso);*/
        
        /*caso.FS_URLDisenioTecnico__c = 'https://fisagrp.com';
        caso.FS_EnviarAprobacionDisenioTecnico__c = true;
        update caso;
        actualizarCasoError(caso);*/
        
        caso.FS_AprobacionDisenioTecnico__c = 'No';
        caso.FS_MotivosRechazoDT__c = 'Desarrollo incompleto';
        caso.FS_UsuarioAprobadorDT__c = userInfo.getUserId();
        update caso;
        
        caso.FS_AprobacionDisenioTecnico__c = 'Si';
        caso.FS_MotivosRechazoDT__c = null;
        update caso;
        
        caso.FS_URLCodigoFuente__c = 'https://fisagrp.com';
        caso.FS_URLSolucionDefinitiva__c = 'https://fisagrp.com';
        caso.FS_EnviarAprobacionSolucionDN2__c = true;
        update caso;
        
        caso.FS_AprobacionSolucionDefinitivaN2__c = 'No';
        caso.FS_MotivoRechazoSDN2__c = 'Desarrollo incompleto';
        update caso;     
    }
    
    @isTest
    static void CasoIncidentePuntualOtrosEscenarios() {
        Case caso =  [Select Id, RecordType.DeveloperName from Case Where RecordTypeId = :CaseTriggerHelper.INCIDENTE_TIPO_REGISTRO];
        
        caso.FS_InformacionCompleta__c = 'Si';
        caso.FS_Proyecto__c = 'FSHD001 - Fisa System Help desk';
        caso.FS_FechaCompromisoEntrega__c = Date.today();
        update caso;
        caso.FS_AprobacionSolucionDefinitivaRelease__c = 'No';
        caso.FS_MotivoRechazoSDRelease__c = 'Inconsistencia en parche';
        update caso;
        
        caso.FS_AprobacionSolucionDefinitivaRelease__c = 'Si';
        update caso;
        
        caso.FS_URLPlanPruebas__c = 'https://fisagrp.com';
        update caso;
        
        caso.FS_UsuarioAprobadorPlanPruebas__c = userInfo.getUserId();
        caso.FS_AprobacionPlanPruebas__c = 'No';
        caso.FS_MotivoRechazoPlanPruebas__c = 'Incosistencia en plan de pruebas';
        update caso;
        
        caso.FS_AprobacionPlanPruebas__c = 'Si';
        caso.FS_MotivoRechazoPlanPruebas__c = null;
        update caso;
        
        caso.FS_UrlAmbientePruebas__c = 'https://fisagrp.com';
        update caso;
        actualizarCasoError(caso);
        
        caso.FS_UsuarioAprobadorInstalacionParcheRele__c = userInfo.getUserId();
        caso.FS_AprobacionInstalacionParcheRelease__c = 'No';
        caso.FS_MotivosRechazoInstalacionParche__c = 'Error en scripts';
        update caso;
        
        caso.FS_AprobacionPlanPruebas__c = 'Si';
        update caso;
        
        caso.FS_UrlEvidenciaPruebas__c = 'https://fisagrp.com';
        update caso;
        caso.FS_AprobacionCertificacionParcheQA__c = 'No';
        caso.FS_MotivoRechazoEntregaParche__c = 'Release plan';
        update caso;
        caso.FS_MotivoRechazoEntregaParche__c = null;
        caso.FS_AprobacionCertificacionParcheQA__c = 'Si';
        update caso;
        
    }
    
    
    @isTest
    static void CasoIncidenteDefinitivo() {
        Case caso =  [Select Id, RecordType.DeveloperName from Case Where RecordTypeId = :CaseTriggerHelper.INCIDENTE_TIPO_REGISTRO];
        
        caso.FS_InformacionCompleta__c = 'Si';
        caso.FS_Proyecto__c = 'FSHD001 - Fisa System Help desk';
        caso.FS_FechaCompromisoEntrega__c = Date.today();
        update caso;
        
        caso.FS_URLParcheCliente__c = 'https://fisagrp.com';
        update caso;
        caso.FS_AceptaInstalacionParche__c = 'No';
        caso.FS_MotivosRechazoInstalacionParche__c = 'Error en scripts';
        update caso;
        caso.FS_AceptaInstalacionParche__c = 'Si';
        update caso;
        
        caso.FS_AceptaPaseProducion__c = 'No';
        update caso;
        caso.FS_AceptaPaseProducion__c = 'Si';
        update caso;
        
    }
    
    @isTest
    static void preventChangeCaseValues() {
        CaseTriggerHelper.entitlementCaseId(CaseTriggerHelper.CONSULTA_TIPO_REGISTRO); 
    }
    
    public static case actualizarCasoError(Case caso){
        try{
            update caso;
        }catch(exception ex){
            return caso;
        }
        return caso;
    }
}