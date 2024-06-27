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
public class SurveyQuestionResponseFlow_Test {
	@isTest
    static void createRecordSurvey() {       
        List<SurveyQuestionResponse> records = new List<SurveyQuestionResponse>();
        records = [	SELECT	Id 
                   	FROM	SurveyQuestionResponse limit 1	];
        
        List<String> values = new List<String>();
        values.add(records[0].Id);
        
        SurveyQuestionResponseFlow.createClone(values);     
    }
}