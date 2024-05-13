/**
**************************************************************************************************************
* @author           Intellect Systems href=<infor@intellectsystems.net>
* @project          Fisa Ecuador - Implementación CRM
* @name             TaskTrigger
* @description      Trigger to object Task
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2024-02-16   Intellect Systems             Initial version.
**************************************************************************************************************
*/

trigger TaskTrigger on Task (before Update) {
    if(trigger.isUpdate) {
        if(trigger.isBefore) {
            TaskTriggerHandler.beforeUpdate(trigger.new);
        }
    }
}