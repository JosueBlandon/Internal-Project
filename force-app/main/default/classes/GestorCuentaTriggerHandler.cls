public without sharing class GestorCuentaTriggerHandler {
	public static void beforeInsert(List<FS_Gestor_Cuenta__c> records){
		GestorCuentaTriggerHelper.validatePrincipal(records);
    }
    
    public static void afterInsert(List<FS_Gestor_Cuenta__c> records){
        GestorCuentaTriggerHelper.assignManager(records);
    }

	public static void beforeUpdate(List<FS_Gestor_Cuenta__c> records, Map<Id, FS_Gestor_Cuenta__c> oldRecords){
		GestorCuentaTriggerHelper.validatePrincipalUpdate(records, oldRecords);
    }
    
    public static void afterUpdate(List<FS_Gestor_Cuenta__c> records){
        GestorCuentaTriggerHelper.assignManager(records);
    }
    
    public static void afterDelete(List<FS_Gestor_Cuenta__c> oldRecords){
        GestorCuentaTriggerHelper.deleteManager(oldRecords);
    }
}