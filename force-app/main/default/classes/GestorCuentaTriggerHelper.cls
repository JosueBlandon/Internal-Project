public without sharing class GestorCuentaTriggerHelper { 
    
    public static void validatePrincipal(List<FS_Gestor_Cuenta__c> records) {
        Set<Id> listGestorCuenta = new Set<Id>();
        for(FS_Gestor_Cuenta__c newRecord : records) {
            listGestorCuenta.add(newRecord.FS_Cuenta__c);	    
        }    
        
        Map<String, FS_Gestor_Cuenta__c> searchRecords = new Map<String, FS_Gestor_Cuenta__c>([    SELECT  Id, FS_Cuenta__c, FS_Project_Manager__c, FS_Principal__c 
                                                                                                FROM    FS_Gestor_Cuenta__c 
                                                                                                WHERE   FS_Cuenta__c IN : listGestorCuenta and FS_Principal__c = true    ]);

        if(!searchRecords.isEmpty()) {
            for(FS_Gestor_Cuenta__c newRecord : records) {               
                for (Id key : searchRecords.keySet()) {
                    if(searchRecords.get(key).FS_Principal__c == newRecord.FS_Principal__c) {
                        newRecord.addError('Ya existe un registro marcado como el Project Manager principal.');	    
                    }
                }  	    
            }            
        }    
    }
    
    public static void validatePrincipalUpdate(List<FS_Gestor_Cuenta__c> records,  Map<Id, FS_Gestor_Cuenta__c> oldRecords) {
        Set<Id> listGestorCuenta = new Set<Id>();
        for(FS_Gestor_Cuenta__c newRecord : records) {
            listGestorCuenta.add(newRecord.FS_Cuenta__c);	    
        }    
        
        Map<String, FS_Gestor_Cuenta__c> searchRecords = new Map<String, FS_Gestor_Cuenta__c>([    SELECT  Id, FS_Cuenta__c, FS_Project_Manager__c, FS_Principal__c 
                                                                                                FROM    FS_Gestor_Cuenta__c 
                                                                                                WHERE   FS_Cuenta__c IN : listGestorCuenta and FS_Principal__c = true    ]);

        if(!searchRecords.isEmpty()) {
            for(FS_Gestor_Cuenta__c newRecord : records) {               
                for (Id key : searchRecords.keySet()) {
                    if(searchRecords.get(key).FS_Principal__c == newRecord.FS_Principal__c && newRecord.FS_Project_Manager__c == oldRecords.get(newRecord.Id).FS_Project_Manager__c) {
                    	newRecord.addError('Ya existe un registro marcado como el Project Manager principal.');	    
                    }
                }  	    
            }            
        }    
    }
}