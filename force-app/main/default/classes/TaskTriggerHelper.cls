/**
**************************************************************************************************************
* @author           Intellect Systems href=<infor@intellectsystems.net>
* @project          Fisa Ecuador - Implementación CRM
* @name             TaskTriggerHelper
* @description      Class hhelper to handler called TaskTriggerHandler
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2024-02-16   Intellect Systems             Initial version.
**************************************************************************************************************
*/

public with sharing class TaskTriggerHelper {

    /**
     * @method      preventEditRecords
     * @description Method to prevent edit the tasks
     * @author      Intellect Systems - 2024-02-16
     * @param       records
     */
    public static void preventEditRecords(List<Task> records) {
        try {
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;  
            if(profileName != 'Administrador del sistema' && profileName != 'System Administrator') {
                for(Task record : records) {
                    if(record.TaskSubtype == 'Email') {
                        record.addError('Privilegios insuficientes para modificar la actividad.');	
                    }    
                }	   
            }
        } catch(Exception ex) {
            System.debug('Error en TaskTriggerHelper: '+ex.getLineNumber()+'---'+ex.getMessage());
        }
    }
}