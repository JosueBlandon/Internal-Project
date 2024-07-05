/**
**************************************************************************************************************
* @author           Intellect Systems href=<info@intellectsystems.net>
* @project          Fisa Ecuador - Implementación CRM
* @name             SurveyQuestionFlow
* @description       Invocable class to create a duplicate record of SurveyQuestion standard object in preguntas_de_encuestas__c custom object.
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2024-06-26   Intellect Systems             Initial version.
**************************************************************************************************************
*/
public class SurveyQuestionFlow {
    
    /**
     * @method      createClone
     * @description Method to create a clone from SurveyQuestion to Preguntas_de_Encuesta__c object 
     * @author      Intellect Systems - 2024-06-26
     * @param       records - SurveyQuestion List 
     */
    @InvocableMethod
    public static void createClone(List<String> values) {
        
        List<SurveyQuestion> records = new List<SurveyQuestion>();
        records = [	SELECT	Id, SurveyVersionId 
                   	FROM	SurveyQuestion
                  	WHERE Id In: values];
        
        List<Preguntas_de_Encuesta__c> questionsList = new List<Preguntas_de_Encuesta__c>();
        for(SurveyQuestion record : records) {
        	Preguntas_de_Encuesta__c question = new Preguntas_de_Encuesta__c();
            question.Pregunta_de_encuestra__c = record.Id;
            question.Version_de_Encuesta__c = record.SurveyVersionId;
            questionsList.add(question);
        }
        
        if(!questionsList.isEmpty()) {
        	insert questionsList;
        }
    }

}