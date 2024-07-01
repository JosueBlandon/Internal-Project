/**
**************************************************************************************************************
* @author           Intellect Systems href=<info@intellectsystems.net>
* @project          Fisa Ecuador - Implementación CRM
* @name             ContactTriggerHandler
* @description      Handler to ContactTrigger trigger.
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2024-05-24   Intellect Systems             Initial version.
**************************************************************************************************************
*/

public without sharing class ContactTriggerHandler {
	public static void beforeInsert(List<Contact> records){
        ContactTriggerHelper.assignProducts(records);
    }
}