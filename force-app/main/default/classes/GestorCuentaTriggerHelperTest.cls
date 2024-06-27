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
        
        //Account RECORD_ACCOUNT = DataFactory.insertAccount();
        Account acc = DataFactory.insertAccount();
        Contact cont = DataFactory.insertContact(acc);
        List<FS_Gestor_Cuenta__c> gs = DataFactory.insertManager(acc);
        
        Account cuenta =  [    SELECT	Id, Name  
                               FROM 	Account 
                               WHERE	Id =: acc.Id    ];
        
        update gs;
        delete gs;
        
	}     
}