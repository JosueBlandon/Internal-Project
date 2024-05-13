@isTest
public class JobValidacionRespuesta_Test {
    
    
    @TestSetup
    static void setup(){
        Account acc = DataFactory.insertAccount();
        Contact cont = DataFactory.insertContact(acc);
        FS_ProductoAdquirido__c p = DataFactory.insertProduct(acc, 'FISA System', 'Núcleo del Sistema', '');
        DataFactory.insertCase(acc, cont, p, 'FS_Consulta');
        DataFactory.insertCase(acc, cont, p, 'FS_Solicitud');
        DataFactory.insertCase(acc, cont, p, 'FS_Incidente');
        DataFactory.insertProduct(acc, 'FISA System', 'Núcleo del Sistema', '');
    }
    
    @isTest
    static void JobValidacionRespuesta() {
        Case caso =  [Select Id, RecordType.DeveloperName from Case Where RecordTypeId = :CaseTriggerHelper.CONSULTA_TIPO_REGISTRO];
        Test.startTest();
        caso.FS_SubEstado__c = 'Envío de respuesta';
        update caso;
        new JobValidacionRespuesta().execute(null);
        caso.FS_SubEstado__c = 'Respuesta aceptada';
        caso.FS_FechaEnvioEncuesta__c = DateTime.now();
        update caso;
        new JobValidacionRespuesta().execute(null);
        caso =  [Select Id, RecordType.DeveloperName from Case Where RecordTypeId = :CaseTriggerHelper.INCIDENTE_TIPO_REGISTRO];
        caso.FS_SubEstado__c = 'Paso a Producción';
        update caso;
        new JobValidacionRespuesta().execute(null);
        Test.stopTest();
    }

}