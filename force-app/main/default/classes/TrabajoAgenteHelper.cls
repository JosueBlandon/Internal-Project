/**
**************************************************************************************************************
* @author           Intellect Systems href=<infor@intellectsystems.net>
* @project          Fisa Ecuador - Implementación CRM
* @name             TrabajoAgenteHelper
* @description      Assign cases to service queue
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2023-07-20   Intellect Systems             Initial version.
* 2024-24-03   Intellect Systems             Call Method removed: CaseTriggerHelper.borrarChatter, after reviewing that they are unnecessary.
**************************************************************************************************************
*/

public without sharing class TrabajoAgenteHelper {

    public static void verificacionCaso(List<AgentWork> newAgentWork){
        List<String> recordIds = new List<String>();
        List<String> listUserId = new  List<String>();
        List<String> listUser = new  List<String>();
        List<Case> listCasosActualizar = new List<Case>();
        
        for(AgentWork item: newAgentWork){
            recordIds.add(item.WorkItemId);
            listUserId.add(item.UserId);
        }
        String query = 'Select ';
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Case').getDescribe().fields.getMap();
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult dfield = sfield.getDescribe();
            query += dfield.getname() + ',';
        }
        query = query.substring(0, query.length() - 1) + ' from Case Where Id in :recordIds';
        List<Case> listCasos = DataBase.query(query);
        for(User item :[Select Id from User Where Id in :listUserId ]){
            listUser.add(item.Id);
        }
        List<String> colasAtencion = new List<String>();
        for(Group item: [Select Id,Developername from Group Where DeveloperName Like '%FS_%' and Type = 'Queue']){
            colasAtencion.add(item.Id);
        }
        for(Case item: listCasos){
            for(AgentWork aw: newAgentWork){
                System.debug(colasAtencion.contains(aw.OriginalQueueId));
                System.debug(colasAtencion + ' ---- ' +aw.OriginalQueueId);
                if(item.Id == aw.WorkItemId && listUser.contains(aw.UserId) && colasAtencion.contains(aw.OriginalQueueId)){
                    listCasosActualizar.add(asignarcaso(item));
                }
            }
        }
        update listCasosActualizar;
    }
    
    public static Case asignarCaso(Case item){
        if(item.FS_SubEstado__c == 'Apertura de caso'){
            item.FS_SubEstado__c = 'Entrega 1a respuesta';
            CaseTriggerHelper.envioCorreo(item, 'FS_AsignacionCaso', true);
        }else if(item.FS_SubEstado__c == 'Escalado a N2'){
            item.FS_SubEstado__c = item.FS_NombreTipoRegistro__c == 'Incidente' ? 'Revisión Documentación N2' : 'Análisis N2';
            item.FS_AgenteN2__c = userInfo.getUserId();
            item.IsEscalated = true;
        }else if(item.FS_SubEstado__c == 'Escalado a QA'){
            item.FS_SubEstado__c = 'Elaboración Plan de Pruebas';
            item.FS_AgenteQA__c = userInfo.getUserId();
        } 
        return item;
    }
}