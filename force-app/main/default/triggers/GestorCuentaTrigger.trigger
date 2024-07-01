trigger GestorCuentaTrigger on FS_Gestor_Cuenta__c (before insert, before update, after insert, after update, after delete) {
	if(trigger.isInsert) {
        if(trigger.isBefore) {
            GestorCuentaTriggerHandler.beforeInsert(trigger.new); 
        }
        if(trigger.isAfter){
            GestorCuentaTriggerHandler.afterInsert(trigger.new);
        }
    }

    if(trigger.isUpdate) {
        if(trigger.isBefore) {
            GestorCuentaTriggerHandler.beforeUpdate(trigger.new, trigger.oldMap); 
        }
        if(trigger.isAfter){
            GestorCuentaTriggerHandler.afterUpdate(trigger.new);
        }
    }
    
    if(trigger.isDelete) {
        if(trigger.isAfter){
            GestorCuentaTriggerHandler.afterDelete(trigger.old);
        }
    }
    
}