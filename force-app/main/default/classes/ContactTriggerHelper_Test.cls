@isTest
public class ContactTriggerHelper_Test {
	@isTest
    static void setup(){ 
        Account acc = DataFactory.insertAccount();
        DataFactory.insertProduct(acc, 'FISA System', 'Núcleo del Sistema', 'Seguridades (Modulo 90)');
        List<FS_Gestor_Cuenta__c> gs = DataFactory.insertManager(acc);
        Contact cont = DataFactory.insertContact(acc);
        update cont;
    }
}