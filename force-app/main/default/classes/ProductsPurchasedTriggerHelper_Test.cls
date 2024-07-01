@isTest
public class ProductsPurchasedTriggerHelper_Test {   
	@TestSetup
    static void setup(){ 
        Account acc = DataFactory.insertAccount();
        Contact cont = DataFactory.insertContact(acc);
        DataFactory.insertProduct(acc, 'FISA System', 'Núcleo del Sistema', 'Seguridades (Modulo 90)');
        DataFactory.insertProduct(acc, 'FISA CreditCard', '', '');
        DataFactory.insertProduct(acc, 'OMNIA', '', '');
        DataFactory.insertProduct(acc, 'FISA FISS', '', '');
        
    }
    
    @isTest
    static void updateProduct() {
        Account accRecord = [Select Id, Name From Account Where Name = 'Account Test'];
    	FS_ProductoAdquirido__c product =  [	SELECT	Id, Name, FS_Esta_activo__c 
                                            	FROM	FS_ProductoAdquirido__c 
                                            	WHERE	FS_Cuenta__c =: accRecord.Id
                                           		LIMIT	1]; 
        
        product.FS_Esta_activo__c = false;
        product.FS_Esta_activo__c = true;
        update product;
        delete product;
    }
}