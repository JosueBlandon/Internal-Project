/**
**************************************************************************************************************
* @author           Intellect Systems href=<info@intellectsystems.net>
* @project          Fisa Ecuador - Implementación CRM
* @name             ProductsPurchasedTrigger
* @description      Trigger to FS_ProductoAdquirido__c Object.
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2024-05-27   Intellect Systems             Initial version.
**************************************************************************************************************
*/

trigger ProductsPurchasedTrigger on FS_ProductoAdquirido__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(trigger.isInsert) {
        if(trigger.isAfter) {
            ProductsPurchasedTriggerHandler.afterUpdate(trigger.new);
        }
    }
    if(trigger.isUpdate) {
        if(trigger.isAfter) {
            ProductsPurchasedTriggerHandler.afterUpdate(trigger.new);
        }
    }
    
    if(trigger.isDelete){
        if(trigger.isAfter){
            ProductsPurchasedTriggerHandler.afterDelete(trigger.old);
        }
    }
}