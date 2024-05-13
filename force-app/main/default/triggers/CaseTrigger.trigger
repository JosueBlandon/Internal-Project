trigger CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete) {
    if(trigger.isInsert) {
        if(trigger.isBefore) {
            CaseTriggerHandler.beforeInsert(trigger.new);
        } else if(trigger.isAfter) {
            CaseTriggerHandler.afterInsert(trigger.new, trigger.oldMap);
        }
    } else if(trigger.isUpdate) {
        if(trigger.isBefore) {
            CaseTriggerHandler.beforeUpdate(trigger.new, trigger.oldMap);
        } else if(trigger.isAfter) {
            CaseTriggerHandler.afterUpdate(trigger.new, trigger.oldMap);
        }
    } else if(trigger.isDelete) {
        if(trigger.isBefore) {
            CaseTriggerHandler.afterDelete(trigger.old);
        } 
    } 
}