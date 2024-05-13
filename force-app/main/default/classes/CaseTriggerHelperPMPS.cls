/**
**************************************************************************************************************
* @author           Intellect Systems href=<infor@intellectsystems.net>
* @project          Fisa Ecuador - Implementación CRM
* @name             CaseTriggerHelperPMPS
* @description      Class to manage new process in case called: Requerimiento.
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2024-22-01   Intellect Systems             Initial version.
**************************************************************************************************************
*/
public with sharing class CaseTriggerHelperPMPS {

    public static final String REQUERIMIENTO_TIPO_REGISTRO = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('FS_Requerimiento').getRecordTypeId();
    
    /**
     * @method      preventDeleteRecords
     * @description Method that prevent delete records, except the System Administrator
     * @author      Intellect Systems - 2024-22-01
     * @param 		records - list of cases		
     */
	public static void preventDeleteRecords(List<Case> records) {
        try {
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;  
            if(profileName != 'Administrador del sistema' && profileName != 'System Administrator') {
                for(Case caseList : records) {
                    caseList.addError('Privilegios insuficiente para eliminar el caso');	    
                }	   
            }
        } catch(Exception ex) {
            System.debug('Error en CaseTriggerHelperPMPS: '+ex.getLineNumber()+'---'+ex.getMessage());
        }
    }

    /**
     * @method      preventChangeCaseValues
     * @description Method to prevent a user from changing the case information
     * @author      Intellect Systems - 2024-02-19
     * @param       records
     * @param       oldRecords
     */
    public static void preventChangeCaseValues(List<Case> records, Map<Id, Case> oldRecords) {
        List<Case> casesOld = new List<Case>();
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        if(profileName != 'Administrador del sistema' && profileName != 'System Administrator') {
            for (Case record : records) {
                Case caso = oldRecords.get(record.Id);
                if(record.ContactId != caso.ContactId) {
                    record.addError('Privilegios insuficientes, no puede editar campos del caso ingresados por el cliente.'); 
                }
                if((record.Status == 'Dado de Baja' || record.Status == 'Cerrado') && record.status == caso.Status && record.RecordTypeId == REQUERIMIENTO_TIPO_REGISTRO) {
                    record.addError('Privilegios insuficientes para modificar el caso en el estado actual.');
                }
                if(!record.FS_Calificacion__c && record.FS_Calificacion__c != caso.FS_Calificacion__c && record.RecordTypeId == REQUERIMIENTO_TIPO_REGISTRO) {
                    record.addError('Privilegios insuficientes para modificar la calificación del caso.');    
                }
            }  
        } 
    }
    
    /**
     * @method      assignCases
     * @description Method that assign owner to record case if the recordtype is Requerimiento
     * @author      Intellect Systems - 2024-23-01
     * @param 		records - list of cases	
     */
    public static void assignCases(List<Case> records) {
        set<Id> accountId = new set<id>();
        for(Case lstCase: records) {
            accountId.add(lstCase.AccountId);   
        }

        map<String, FS_Gestor_Cuenta__c> mapRecords = new map<String, FS_Gestor_Cuenta__c>([	SELECT 	Id, FS_Project_Manager__c,FS_Project_Manager__r.Name
                                                                                                FROM 	FS_Gestor_Cuenta__c
                                                                                                WHERE 	FS_Cuenta__c IN : accountId and FS_Principal__c =: true	 ]);        

        for(Case lstCase: records) {
            if(REQUERIMIENTO_TIPO_REGISTRO == lstCase.RecordTypeId && mapRecords.size() > 0) {	
                for(Id key : mapRecords.keySet()) {
                    lstCase.OwnerId = mapRecords.get(key).FS_Project_Manager__c; 
                }
            }    
        }
    }

    /**
     * @method      sendToJiraPMPS
     * @description Method to send case to jira
     * @author      Intellect Systems - 2024-01-30
     * @param       records     - New list of cases
     * @param       oldRecords  - Old map of cases
     */
    public static void sendToJiraPMPS(List<Case> records, Map<Id, Case> oldRecords) {
        List<Case> casesNew = new List<Case>();
        List<Case> casesOld = new List<Case>();
        for (Case record : records) {
            Case caso = oldRecords.get(record.Id);
            if(record.FS_Calificacion__c == true && record.FS_Calificacion__c != caso.FS_Calificacion__c) {
                record.Status = 'En Análisis';
                casesNew.add(record);
                casesOld.add(caso);
                createIssueJira(casesNew, casesOld);
            } 
            if((record.FS_Aplica_Licencia_Recurrente__c == 'Si' && record.FS_Cuando_Aplica_LR__c != null && record.FS_Dias_que_Aplica_LR__c != null && record.FS_Aplica_Licencia_Recurrente__c != caso.FS_Aplica_Licencia_Recurrente__c) || (record.FS_Aplica_Licencia_Recurrente__c	== 'No' && record.FS_Aplica_Licencia_Recurrente__c != caso.FS_Aplica_Licencia_Recurrente__c)) {
                record.Status = 'En Planificación';
                casesNew.add(record);
                casesOld.add(caso);
                updateIssueJira(casesNew, casesOld);
            }
            if(record.FS_Acepta_Propuesta_Economica__c == 'Si' && record.FS_Acepta_Propuesta_Economica__c != caso.FS_Acepta_Propuesta_Economica__c) {
                CaseTriggerHelper.crearHistorialAprobaciones(record);
            }
            if(record.FS_Acepta_Propuesta_Economica__c == 'No' && record.FS_Acepta_Propuesta_Economica__c != caso.FS_Acepta_Propuesta_Economica__c) {
                record.Status = 'Pendiente de Respuesta CSAT';  
                record.FS_EncuestaEnviada__c = true;
                record.FS_FechaEnvioEncuesta__c = System.now();
                CaseTriggerHelper.crearHistorialAprobaciones(record);
                casesNew.add(record);
                casesOld.add(caso); 
                CaseTriggerHelper.crearEncuesta(record);
                updateIssueJira(casesNew, casesOld);
            } System.debug('Datos: '+record.FS_AceptaRespuesta__c+'---'+record.Status+'---'+record.FS_AceptaRespuesta__c+'---'+caso.FS_AceptaRespuesta__c);
            if(record.FS_AceptaRespuesta__c == 'Si' && record.Status == 'Validación de Respuesta (Cliente)' && record.FS_AceptaRespuesta__c != caso.FS_AceptaRespuesta__c) {
                record.Status = 'Certificado';
                CaseTriggerHelper.crearHistorialAprobaciones(record); 
                casesNew.add(record);
                casesOld.add(caso);
                updateIssueJira(casesNew, casesOld); 
            }
            if(record.FS_AceptaRespuesta__c == 'No' && record.Status == 'Validación de Respuesta (Cliente)' && record.FS_AceptaRespuesta__c != caso.FS_AceptaRespuesta__c) {
                record.Status = 'En Desarrollo'; 
                record.FS_AceptaRespuesta__c = ''; 
                CaseTriggerHelper.crearHistorialAprobaciones(record);
                casesNew.add(record);
                casesOld.add(caso);
                updateIssueJira(casesNew, casesOld);
            }
            if(record.FS_Fecha_Puesta_en_Produccion__c != null && record.FS_Fecha_Puesta_en_Produccion__c != caso.FS_Fecha_Puesta_en_Produccion__c) {
                record.Status = 'En Producción';  
                CaseTriggerHelper.crearHistorialAprobaciones(record);
                casesNew.add(record);
                casesOld.add(caso);
                updateIssueJira(casesNew, casesOld);
            }
            if(record.FS_Quiere_Finalizar_la_Atencion_del_Caso__c == true && record.FS_Quiere_Finalizar_la_Atencion_del_Caso__c != caso.FS_Quiere_Finalizar_la_Atencion_del_Caso__c) {
                record.Status = 'Pendiente de Respuesta CSAT';  
                record.FS_EncuestaEnviada__c = true;
                record.FS_FechaEnvioEncuesta__c = System.now();
                CaseTriggerHelper.crearHistorialAprobaciones(record);
                CaseTriggerHelper.crearEncuesta(record);
                casesNew.add(record);
                casesOld.add(caso);
                updateIssueJira(casesNew, casesOld);
                CaseTriggerHelper.envioCorreo(record, 'FS_Encuesta', true);
            } 
            if(record.Status == 'Cerrado' && record.Status != caso.Status) {
                casesNew.add(record);
                casesOld.add(caso);
                updateIssueJira(casesNew, casesOld);
            }
        }    
    }

    /**
     * @method      createIssueJira
     * @description Create case record in Jira proyect
     * @author      Intellect Systems - 2024-01-30
     * @param       records
     * @param       oldRecords
     */
    public static void createIssueJira(List<Case> records, List<Case> oldRecords) { 
        String jiraProjectId = System.Label.FS_IdJiraProject;
        String jiraIssueTypeId = System.Label.FS_IdJiraProjectEpicPM;
        JCFS.API.createJiraIssue(jiraProjectId, jiraIssueTypeId, records, oldRecords);
    }

    /**
     * @method      updateIssueJira
     * @description Update case record in Jira proyect
     * @author      Intellect Systems - 2024-02-05
     * @param       newCaseList
     * @param       oldCaseList
     */
    public static void updateIssueJira(List<Case> newCaseList, List<Case> oldCaseList) {       
        JCFS.API.pushUpdatesToJira(newCaseList, oldCaseList);
    }

    /**
     * @method      sendNotification
     * @description Send notification when Notificaciones fields value change
     * @author      Intellect Systems - 2024-01-31
     * @param       records
     * @param       oldRecord
     */
    public static void sendNotification(List<Case> records, Map<Id, Case> oldRecords) {      
        Case caseNotification;
        String emailTemplateName;
        Boolean esContacto = true;
        for (Case record : records) {
            Case caso = oldRecords.get(record.Id); 
            if(record.FS_Notificaciones__c == 'Estimación Macro' && record.FS_Notificaciones__c != caso.FS_Notificaciones__c) {
                caseNotification = record;
                emailTemplateName = 'FS_AprobacionNotificacion';
            } else if(record.FS_Notificaciones__c == 'Documento de Especificación Funcional' && record.FS_Notificaciones__c != caso.FS_Notificaciones__c) {
                caseNotification = record;
                emailTemplateName = 'FS_AprobacionNotificacion';
            } else if(record.FS_Notificaciones__c == 'En Propuesta Económica' && record.FS_Notificaciones__c != caso.FS_Notificaciones__c) {   
                record.FS_InformacionCompleta__c = 'No';
                caseNotification = record;
                emailTemplateName = 'FS_AprobacionNotificacion';
            } else if(record.FS_Notificaciones__c == 'En Espera de Respuesta del Cliente' && record.FS_Notificaciones__c != caso.FS_Notificaciones__c) { 
                caseNotification = record;
                emailTemplateName = 'FS_AprobacionNotificacion';
                record.Status = 'En Espera de Respuesta del Cliente';
            } else if(record.Status == 'En Propuesta Económica' && record.FS_Notificaciones__c == 'En Propuesta Económica' && record.FS_Acepta_Propuesta_Economica__c == 'Si' && record.FS_Acepta_Propuesta_Economica__c != caso.FS_Acepta_Propuesta_Economica__c) {
                caseNotification = record;
                emailTemplateName = 'FS_Cliente_Acepta_Propuesta_Economica';
                esContacto = false;
            } else if(record.Status == 'Validación de Respuesta (Cliente)' && record.Status != caso.Status) {
                caseNotification = record;
                emailTemplateName = 'FS_Notificacion_Estado_Entregado';
                String descripcion = 'Estimado cliente '+record.FS_NombreContacto__c+'\n\n\nSe ha realizado la entrega de la solución al caso '+record.CaseNumber+', la cual se puede descargar en la herramienta Azure Explorer en el siguiente directorio '+record.FS_URLParcheCliente__c +'\n\nLe recordamos que tiene 15 días para descargar el parche.\n\nGracias\nProfessional Services Team';
                insert new FeedItem(ParentId = record.Id, Body = descripcion, Visibility = 'AllUsers');
            } else if(record.Status == 'Cerrado' && record.FS_FechaContestacionEncuesta__c != null && record.FS_FechaContestacionEncuesta__c != caso.FS_FechaContestacionEncuesta__c) {
                caseNotification = record;
                emailTemplateName = 'FS_Cliente_Contesto_Encuesta';
                esContacto = false;
            }

            if(caseNotification != null) {
                CaseTriggerHelper.envioCorreo(record, emailTemplateName, esContacto);    
            }
        }      
    }

    /**
     * @method      validateChangeRecordType
     * @description Method to assign new case owner if recordtype in changed
     * @author      Intellect Systems - 2024-02-09
     * @param       records
     * @param       oldRecords
     */
    public static void validateChangeRecordType(List<Case> records, Map<Id, Case> oldRecords) {
        //Validate if recordtype is changed
        Boolean validate = false;
        for (Case record : records) {
            Case caso = oldRecords.get(record.Id); 
            if(record.RecordTypeId != caso.RecordTypeId) {
                validate = true;
            }
        }

        if(validate) {
            User usuario = [    SELECT  Contact.Account.FS_Carterizacion__c, Contact.Account.FS_ServicioRemoto__c, Contact.Account.FS_ColaAtencion__c, Contact.Account.FS_CorreosNotificacionesServicios__c, Contact.Account.FS_Correos_Notificaciones_PS__c  
                                FROM    user  
                                WHERE   Id =: userInfo.getUserId()    ];

            for(Case caso : records) {     
                Boolean esCore = CaseTriggerHelper.ProductoCore(caso);
                if(REQUERIMIENTO_TIPO_REGISTRO != caso.RecordTypeId) {
                    caso.FS_Area__c = esCore ? 'N1. CORE' : 'N1. OMNIA';
                } else {
                    caso.FS_Area__c = 'PS';
                }

                caso.FS_SubEstado__c = 'Apertura de caso';
                caso.Status = 'Nuevo	';

                if(REQUERIMIENTO_TIPO_REGISTRO != caso.RecordTypeId) {
                    if(usuario.Contact.Account.FS_ServicioRemoto__c){
                        caso.OwnerId = [Select Id from Group Where DeveloperName = :usuario.Contact.Account.FS_ColaAtencion__c and Type = 'Queue'].Id;
                    }else{
                        caso.OwnerId = [Select Id from Group Where DeveloperName = :(esCore ? CaseTriggerHelper.COLA_ATENCION_N1_CORE : CaseTriggerHelper.COLA_ATENCION_N1_OMNIA) and Type = 'Queue'].Id;
                    }
                } else {                
                    map<String, FS_Gestor_Cuenta__c> mapRecords = new map<String, FS_Gestor_Cuenta__c>([	SELECT 	Id, FS_Project_Manager__c  
                                                                                                            FROM 	FS_Gestor_Cuenta__c
                                                                                                            WHERE 	FS_Cuenta__c =: caso.AccountId and FS_Principal__c =: true	 ]);
                    
                    if(REQUERIMIENTO_TIPO_REGISTRO == caso.RecordTypeId && mapRecords.size() > 0) {	
                        for(Id key : mapRecords.keySet()) {
                            caso.OwnerId = mapRecords.get(key).FS_Project_Manager__c;    
                        }
                    }   
                }
            }
        }
    }

    /**
     * @method      actualizacionDescripcion
     * @description Method to create record in Object Historial Descripción Caso
     * @author      Intellect Systems - 2024-02-16
     * @param       newCaseList
     * @param       oldCaseMap
     */
    public static void actualizacionDescripcion(List<Case> newCaseList, Map<Id, Case> oldCaseMap){
        for(Case item: newCaseList){
            Case caso = oldCaseMap.get(item.Id);
            if(caso.FS_DescripcionCliente__c != item.FS_DescripcionCliente__c){
                CaseTriggerHelper.crearHistorialDescripcion(item, caso.FS_DescripcionCliente__c, item.FS_DescripcionCliente__c);
            }
        }
    }

}