/**
**************************************************************************************************************
* @author           Intellect Systems href=<info@intellectsystems.net>
* @project          Fisa Ecuador - Implementación CRM
* @name             ProductsPurchasedTriggerHandler
* @description      Handler to ProductsPurchasedTrigger trigger.
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2024-05-27   Intellect Systems             Initial version.
**************************************************************************************************************
*/

public without sharing class ProductsPurchasedTriggerHandler {
	public static void afterUpdate(List<FS_ProductoAdquirido__c> records){
        ProductsPurchasedTriggerHelper.assignProducts(records);
    }
    
    public static void afterDelete(List<FS_ProductoAdquirido__c> oldRecords){
        ProductsPurchasedTriggerHelper.deleteProducts(oldRecords);
    }
}