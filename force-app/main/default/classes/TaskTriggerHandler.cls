/**
**************************************************************************************************************
* @author           Intellect Systems href=<infor@intellectsystems.net>
* @project          Fisa Ecuador - Implementación CRM
* @name             TaskTriggerHandler
* @description      Class handler to trigger called TaskTrigger
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2024-02-16   Intellect Systems             Initial version.
**************************************************************************************************************
*/

public with sharing class TaskTriggerHandler {

    /**
     * @method      beforeUpdate
     * @description Method to execute before update actions in record
     * @author      Intellect Systems - 2024-02-16
     * @param       records
     */
    public static void beforeUpdate(List<Task> records) {
        TaskTriggerHelper.preventEditRecords(records);      
    }
}