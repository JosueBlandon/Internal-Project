/**
**************************************************************************************************************
* @author           Intellect Systems href=<infor@intellectsystems.net>
* @project          Fisa Ecuador - Implementación CRM
* @name             MilestoneCalculatorTest
* @description      Test class to MilestoneCalculator
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2024-05-23   Intellect Systems             Initial version.
**************************************************************************************************************
*/

@isTest
public class MilestoneCalculatorTest {
    
    @isTest
    static void Test1(){ 
        Account acc = DataFactory.insertAccount();
        Contact cont = DataFactory.insertContact(acc);
        User user = DataFactory.insertUserCommunity(cont);
        System.runAs(user){
            FS_ProductoAdquirido__c p = DataFactory.insertProduct(acc, 'FISA System', 'Colocaciones (Módulo 6)', 'Crédito Hipotecario');
            test.startTest();
                case CasoConsulta = DataFactory.insertCase(acc, cont, p, 'FS_Consulta');
                DataFactory.insertCase(acc, cont, p, 'FS_Solicitud');
                DataFactory.insertCase(acc, cont, p, 'FS_Incidente');
                DataFactory.insertProduct(acc, 'FISA System', 'Núcleo del Sistema', 'Seguridades (Modulo 90)');
            	String CaseId = '' + CasoConsulta.Id;
            	String case2 = '';
            	String milestoneTypeId = '';
            	MilestoneCalculator calculator = new MilestoneCalculator();
        		Integer actualTriggerTime = calculator.calculateMilestoneTriggerTime(CaseId, milestoneTypeId);
            	//MilestoneCalculator.calculateMilestoneTriggerTime(caseId, milestoneTypeId);
            test.stopTest();	
        }
    }

}