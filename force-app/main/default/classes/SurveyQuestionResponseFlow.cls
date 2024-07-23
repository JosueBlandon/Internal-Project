/**
**************************************************************************************************************
* @author           Intellect Systems href=<info@intellectsystems.net>
* @project          Fisa Ecuador - Implementación CRM
* @name             SurveyQuestionResponseFlowTriggerHelper
* @description      Invocable class to create a duplicate record of SurveyQuestionResponse standard object in Respuestas_a_la_preguntas_de_encuestas__c custom object.
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2024-06-26   Intellect Systems             Initial version.
**************************************************************************************************************
*/

public without sharing class SurveyQuestionResponseFlow {
        
    /**
     * @method      createClone
     * @description Method to create a clone from SurveyQuestionResponse to Respuestas_a_la_preguntas_de_encuestas__c object 
     * @author      Intellect Systems - 2024-06-11
     * @param       records - SurveyQuestionResponse List 
     */
    @InvocableMethod
    public static void createClone(List<String> values) {
        
        List<SurveyQuestionResponse> records = new List<SurveyQuestionResponse>();
        records = [	SELECT	Id, QuestionId, ResponseId, ResponseValue, Response.SubmitterId, SurveyVersionId
                   	FROM	SurveyQuestionResponse
                  	WHERE Id In: values];
        
        //Start - Get related contact records
        Set<Id> contactId = new Set<Id>();
        for(SurveyQuestionResponse record : records) {
        	contactId.add(record.Response.SubmitterId);    
        }
        
        List<Contact> contactList = new List<Contact>(); 
        contactList = [	SELECT	Id, AccountId
                        FROM	Contact	
                        WHERE	Id IN: contactId	];
        
        Map<Id, Contact> contactMap = new Map<Id, Contact>(contactList);
        //End - Get related contact records
        
        List<Respuestas_a_la_preguntas_de_encuestas__c> responseList = new List<Respuestas_a_la_preguntas_de_encuestas__c>();
        for(SurveyQuestionResponse record : records) {
        	Respuestas_a_la_preguntas_de_encuestas__c response = new Respuestas_a_la_preguntas_de_encuestas__c();
            response.Respuesta_Pregunta__c = record.ResponseId;
            
            for(Id key : contactMap.keySet()) {
                if(contactMap.get(key).Id == record.Response.SubmitterId) {
            		response.Nombre_de_la_Cuenta__c = contactMap.get(key).AccountId;
                    response.Contacto__c = contactMap.get(key).Id;
                }    
            }
            
            response.Respuesta__c = record.ResponseValue;
            response.FS_Preguntas_Encuesta__c = record.QuestionId;
            response.FS_Version_Encuesta__c = record.SurveyVersionId;

            responseList.add(response);
        }
        
        if(!responseList.isEmpty()) {
        	insert responseList;
        }
    }
}