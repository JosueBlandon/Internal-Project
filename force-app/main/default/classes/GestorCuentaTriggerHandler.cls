public without sharing class GestorCuentaTriggerHandler {
	public static void beforeInsert(List<FS_Gestor_Cuenta__c> records){
		GestorCuentaTriggerHelper.validatePrincipal(records);
    }

	public static void beforeUpdate(List<FS_Gestor_Cuenta__c> records, Map<Id, FS_Gestor_Cuenta__c> oldRecords){
		GestorCuentaTriggerHelper.validatePrincipalUpdate(records, oldRecords);
    }
}