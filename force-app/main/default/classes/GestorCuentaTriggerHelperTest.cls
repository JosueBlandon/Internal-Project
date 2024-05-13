/**
**************************************************************************************************************
* @author           Intellect Systems href=<infor@intellectsystems.net>
* @project          Fisa Ecuador - Implementación CRM
* @name             GestorCuentaTriggerHelperTest
* @description      Test class to GestorCuentaTrigger, GestorCuentaTriggerHandler and GestorCuentaTriggerHelper
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2024-02-20   Intellect Systems             Initial version.
**************************************************************************************************************
*/

@isTest
public class GestorCuentaTriggerHelperTest {

    /**
     * @method      createRecordGestor
     * @description Method to generate record in object called: Gestor Cuenta, related to account.
     * @author      Intellect Systems - 2024-02-20
     */
    @isTest
    static void createRecordGestor() {
        
        Account RECORD_ACCOUNT = DataFactory.insertAccount();
        
        Account cuenta =  [    SELECT	Id, Name  
                               FROM 	Account 
                               WHERE	Id =: RECORD_ACCOUNT.Id    ];
        
        FS_Gestor_Cuenta__c gestor = new FS_Gestor_Cuenta__c();
        gestor.FS_Cuenta__c = cuenta.Id;
        gestor.FS_Project_Manager__c = userInfo.getUserId();
        gestor.FS_Principal__c = true;
                
        insert gestor;
        
        gestor.FS_Principal__c = false;
        update gestor;
	}     
}