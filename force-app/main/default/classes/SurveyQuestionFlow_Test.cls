/**
**************************************************************************************************************
* @author           Intellect Systems href=<infor@intellectsystems.net>
* @project          Fisa Ecuador - Implementación CRM
* @name             SurveyQuestionResponseFlow_Test
* @description      Test class to SurveyQuestionResponseFlow class
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2024-06-26   Intellect Systems             Initial version.
**************************************************************************************************************
*/
@IsTest(SeeAllData=true)
public class SurveyQuestionFlow_Test {
    
    @isTest
    static void createRecordSurvey() {       
        List<SurveyQuestion> records = new List<SurveyQuestion>();
        records = [	SELECT	Id 
                   	FROM	SurveyQuestion limit 1	];
        
        List<String> values = new List<String>();
        values.add(records[0].Id);
        
        SurveyQuestionFlow.createClone(values);     
    }

}