trigger GestorCuentaTrigger on FS_Gestor_Cuenta__c (before insert, before update) {
	if(trigger.isInsert) {
        if(trigger.isBefore) {
            GestorCuentaTriggerHandler.beforeInsert(trigger.new); 
        }
    }

    if(trigger.isUpdate) {
        if(trigger.isBefore) {
            GestorCuentaTriggerHandler.beforeUpdate(trigger.new, trigger.oldMap); 
        }
    }
}