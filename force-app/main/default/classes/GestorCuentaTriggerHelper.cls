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
        
        Map<String, FS_Gestor_Cuenta__c> searchRecords = new Map<String, FS_Gestor_Cuenta__c>([	SELECT  Id, FS_Cuenta__c, FS_Project_Manager__c, FS_Principal__c 
                                                                                                FROM    FS_Gestor_Cuenta__c 
                                                                                                WHERE   FS_Cuenta__c IN : listGestorCuenta and FS_Principal__c = true    ]);

        if(!searchRecords.isEmpty()) {
            for(FS_Gestor_Cuenta__c newRecord : records) {               
                for (Id key : searchRecords.keySet()) {
                    if(searchRecords.get(key).FS_Principal__c == newRecord.FS_Principal__c && newRecord.FS_Project_Manager__c == oldRecords.get(newRecord.Id).FS_Project_Manager__c) {
                    	//newRecord.addError('Ya existe un registro marcado como el Project Manager principal.');	    
                    }
                }  	    
            }            
        }    
    }
    
    public static void assignManager(List<FS_Gestor_Cuenta__c> records) {
        
        Set<Id> accountsIds = new Set<Id>();
    	//Get AccountId
        for(FS_Gestor_Cuenta__c record : records) {
        	accountsIds.add(record.FS_Cuenta__c);
        }
        
        //Search related Contacts
        Map<Id, Contact> contactsList = new Map<Id, Contact>([	SELECT	Id, Name, AccountId, FS_Productos__c, FS_PMPSPrincipal__c,
                                                                FS_PMPSSecundario__c, FS_PMCore__c, FS_PMOmnia__c, FS_KAM__c
                                               					FROM	Contact
                                               					WHERE	AccountId IN: accountsIds	]);
        
        //Search related Manager
        Map<Id, FS_Gestor_Cuenta__c> managerList = new Map<Id, FS_Gestor_Cuenta__c>([	SELECT	Id, FS_Cuenta__c, FS_Principal__c, FS_Area__c, FS_Project_Manager__r.name
                                               													FROM	FS_Gestor_Cuenta__c
                                               													WHERE	FS_Cuenta__c IN: accountsIds	]);
        
        //Assign all active related Manager to Contact
        Set<String> listAllArea = new Set<String>();
        for(Id keyManager : managerList.keySet()) { 
            Id accountId = managerList.get(keyManager).FS_Cuenta__c;
            
            if(accountId == managerList.get(keyManager).FS_Cuenta__c) {
                listAllArea.add(managerList.get(keyManager).FS_Area__c);
                for(Id keyContact : contactsList.keySet()) {
                    if(contactsList.get(keyContact).AccountId == managerList.get(keyManager).FS_Cuenta__c) {

                        //valida si el gestor es el pm-ps principal.
                        if(managerList.get(keyManager).FS_Principal__c == true && managerList.get(keyManager).FS_Area__c == 'PM-PS'){
                            contactsList.get(keyContact).FS_PMPSPrincipal__c = managerList.get(keyManager).FS_Project_Manager__r.name;
                        }
                        //valida si el gestor es el pm-ps.
                        if(managerList.get(keyManager).FS_Principal__c == false && managerList.get(keyManager).FS_Area__c == 'PM-PS'){
                            contactsList.get(keyContact).FS_PMPSSecundario__c = managerList.get(keyManager).FS_Project_Manager__r.name;
                        }
                        //valida si el gestor es el PM-Core.
                        if(managerList.get(keyManager).FS_Principal__c == false && managerList.get(keyManager).FS_Area__c == 'Core'){
                            contactsList.get(keyContact).FS_PMCore__c = managerList.get(keyManager).FS_Project_Manager__r.name;
                        }
                        //valida si el gestor es el PM-Omnia.
                        if(managerList.get(keyManager).FS_Principal__c == false && managerList.get(keyManager).FS_Area__c == 'Omnia'){
                            contactsList.get(keyContact).FS_PMOmnia__c = managerList.get(keyManager).FS_Project_Manager__r.name;
                        }
                        //valida si el gestor es el PM-KAM.
                        if(managerList.get(keyManager).FS_Principal__c == false && managerList.get(keyManager).FS_Area__c == 'KAM'){
                            contactsList.get(keyContact).FS_KAM__c = managerList.get(keyManager).FS_Project_Manager__r.name;
                        }
                    }    
                }
            }   
        }//fin FOR
        
        if(contactsList.size() > 0) {
        	update contactsList.values();
        }
        
    }//fin metodo assignManager
    
    public static void deleteManager(List<FS_Gestor_Cuenta__c> oldRecords) {
        
        Set<Id> accountsIds = new Set<Id>();
        Set<Id> managerRecordId = new Set<Id>();
    	//Get AccountId
        for(FS_Gestor_Cuenta__c record : oldRecords) {
        	accountsIds.add(record.FS_Cuenta__c);
            managerRecordId.add(record.Id);
        }
        
        //Search related Contacts
        Map<Id, Contact> contactsList = new Map<Id, Contact>([	SELECT	Id, Name, AccountId, FS_Productos__c, FS_PMPSPrincipal__c,
                                                                FS_PMPSSecundario__c, FS_PMCore__c, FS_PMOmnia__c, FS_KAM__c
                                               					FROM	Contact
                                               					WHERE	AccountId IN: accountsIds	]);
        
        //Search related Manager
        Map<Id, FS_Gestor_Cuenta__c> managerList = new Map<Id, FS_Gestor_Cuenta__c>([	SELECT	Id, FS_Cuenta__c, FS_Principal__c, FS_Area__c, FS_Project_Manager__r.name
                                               													FROM	FS_Gestor_Cuenta__c
                                               													WHERE	FS_Cuenta__c IN: accountsIds AND Id IN: oldRecords ALL ROWS]);
        
        //Assign all active related Manager to Contact
        for(Id keyManager : managerList.keySet()) { 
            Id accountId = managerList.get(keyManager).FS_Cuenta__c;
            
            if(accountId == managerList.get(keyManager).FS_Cuenta__c) {
                for(Id keyContact : contactsList.keySet()) {
                    if(contactsList.get(keyContact).AccountId == managerList.get(keyManager).FS_Cuenta__c) {

                        //valida si el gestor es el pm-ps principal.
                        if(managerList.get(keyManager).FS_Principal__c == true && managerList.get(keyManager).FS_Area__c == 'PM-PS'){
                            contactsList.get(keyContact).FS_PMPSPrincipal__c = '';
                        }
                        //valida si el gestor es el pm-ps.
                        if(managerList.get(keyManager).FS_Principal__c == false && managerList.get(keyManager).FS_Area__c == 'PM-PS'){
                            contactsList.get(keyContact).FS_PMPSSecundario__c = '';
                        }
                        //valida si el gestor es el PM-Core.
                        if(managerList.get(keyManager).FS_Principal__c == false && managerList.get(keyManager).FS_Area__c == 'Core'){
                            contactsList.get(keyContact).FS_PMCore__c = '';
                        }
                        //valida si el gestor es el PM-Omnia.
                        if(managerList.get(keyManager).FS_Principal__c == false && managerList.get(keyManager).FS_Area__c == 'Omnia'){
                            contactsList.get(keyContact).FS_PMOmnia__c = '';
                        }
                        //valida si el gestor es el PM-KAM.
                        if(managerList.get(keyManager).FS_Principal__c == false && managerList.get(keyManager).FS_Area__c == 'KAM'){
                            contactsList.get(keyContact).FS_KAM__c = '';
                        }
                    }    
                }
            }   
        }//fin FOR
        
        if(contactsList.size() > 0) {
        	update contactsList.values();
        }
        
    }//fin metodo delete
        
}