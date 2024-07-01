/**
**************************************************************************************************************
* @author           Intellect Systems href=<info@intellectsystems.net>
* @project          Fisa Ecuador - Implementación CRM
* @name             ContactTrigger
* @description      Trigger to Contact Object.
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2024-05-24   Intellect Systems             Initial version.
**************************************************************************************************************
*/

trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete) {
    if(trigger.isInsert) {
        if(trigger.isBefore) {
            ContactTriggerHandler.beforeInsert(trigger.new);
        }
    }
}