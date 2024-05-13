global without sharing class JobValidacionRespuesta implements Schedulable { 
    
    global void execute(SchedulableContext ctx) {
        recordatorioRespuesta();
        recordatorioEncuesta();
        recordatorioPaseProdccion();
    }
    
    public static void recordatorioRespuesta(){
        DateTime fecha = DateTime.now().addDays(-Integer.valueOf(Label.FS_DiasEnvioEncuesta));
        String nombrePlantilla = 'FS_ValidacionInformacion';
        String subEstado = 'Envío de respuesta';
        List<Messaging.SingleEmailMessage> MessageList = new List<Messaging.SingleEmailMessage>();
        EmailTemplate plantilla = [Select Id, Subject, HTMLValue from EmailTemplate Where DeveloperName = :nombrePlantilla limit 1];
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :Label.FS_CorreoElectronicoServicio];
        String query = camposCaso();
        List<Case> listCasos = new List<Case>();
        query += ' Where FS_SubEstado__c = :subEstado and IsClosed = false';
        for(Case item: Database.query(query)){
            try{
                if(item.FS_AceptaRespuesta__c == null && item.LastModifiedDate >= fecha){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String asunnto = CaseTriggerHelper.reemplazarCampos(item, plantilla.Subject, 'Case');
                    String html = CaseTriggerHelper.reemplazarCampos(item, plantilla.HTMLValue, 'Case');
                    String urlLogo = CaseTriggerHelper.getLogoImagen();
                    html = CaseTriggerHelper.getLogoImagen() + html.replace('{urlSiteServicios}', Label.FS_UrlPortalServicios);
                    html =html.replace('{urlSiteEncuestas}', Label.FS_UrlPortalEncuestas);
                    html = html.replace(']]>', '') + '</td><td style="width: 25%;" /></table></body></html>';
                    html = html.replace('<![CDATA[', '');
                    mail.setSubject(asunnto);
                    mail.setHtmlBody(html);
                    mail.saveAsActivity = true;
                    mail.setWhatId(item.Id);
                    mail.setTargetObjectId(item.ContactId);
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    if(String.isNotBlank(item.FS_CorreosNotificacionesServicios__c)){
                        mail.setCcAddresses(item.FS_CorreosNotificacionesServicios__c.split(','));
                    }
                    MessageList.add(mail);
                }else{
                    listCasos.add(new Case (Id = item.Id, Status = 'Cerrado'));
                }
            }catch(exception ex){
                System.debug('Error: '+ex.getMessage() + ' Línea: ' + ex.getLineNumber());
            }
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(MessageList);
        DataBase.update(listCasos, false);
    }
    
    public static void recordatorioEncuesta(){
        DateTime fecha = DateTime.now().addDays(-Integer.valueOf(Label.FS_DiasEnvioEncuesta));
        String nombrePlantilla = 'FS_Encuesta';
        String subEstado = 'Respuesta aceptada';
        List<Messaging.SingleEmailMessage> MessageList = new List<Messaging.SingleEmailMessage>();
        EmailTemplate plantilla = [Select Id, Subject, HTMLValue from EmailTemplate Where DeveloperName = :nombrePlantilla limit 1];
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :Label.FS_CorreoElectronicoServicio];
        String query = camposCaso();
        List<Case> listCasos = new List<Case>();
        query += ' Where FS_SubEstado__c = :subEstado and IsClosed = false';
        for(Case item: Database.query(query)){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            try{
                if(item.FS_FechaEnvioEncuesta__c >= fecha){
                    
                    String asunnto = CaseTriggerHelper.reemplazarCampos(item, plantilla.Subject, 'Case');
                    String html = CaseTriggerHelper.reemplazarCampos(item, plantilla.HTMLValue, 'Case');
                    String urlLogo = CaseTriggerHelper.getLogoImagen();
                    html = CaseTriggerHelper.getLogoImagen() + html.replace('{urlSiteServicios}', Label.FS_UrlPortalServicios);
                    html =html.replace('{urlSiteEncuestas}', Label.FS_UrlPortalEncuestas);
                    html = html.replace(']]>', '') + '</td><td style="width: 25%;" /></table></body></html>';
                    html = html.replace('<![CDATA[', '');
                    mail.setSubject(asunnto);
                    mail.setHtmlBody(html);
                    mail.saveAsActivity = true;
                    mail.setWhatId(item.Id);
                    mail.setTargetObjectId(item.ContactId);
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    if(String.isNotBlank(item.FS_CorreosNotificacionesServicios__c)){
                        mail.setCcAddresses(item.FS_CorreosNotificacionesServicios__c.split(','));
                    }
                    MessageList.add(mail);
                    
                }else{
                    listCasos.add(new Case (Id = item.Id, Status = 'Cerrado'));
                }
            }catch(exception ex){
                System.debug('Error: '+ex.getMessage() + ' Línea: ' + ex.getLineNumber());
            }
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(MessageList);
        DataBase.update(listCasos, false);
    }
    
      public static void recordatorioPaseProdccion(){
        DateTime fecha = DateTime.now().addDays(-Integer.valueOf(Label.FS_DiasEnvioEncuesta));
        String nombrePlantilla = 'FS_PaseProduccion';
        String subEstado = 'Paso a Producción';
        List<Messaging.SingleEmailMessage> MessageList = new List<Messaging.SingleEmailMessage>();
        EmailTemplate plantilla = [Select Id, Subject, HTMLValue from EmailTemplate Where DeveloperName = :nombrePlantilla limit 1];
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :Label.FS_CorreoElectronicoServicio];
        String query = camposCaso();
        List<Case> listCasos = new List<Case>();
        query += ' Where FS_SubEstado__c = :subEstado and IsClosed = false';
        for(Case item: Database.query(query)){
            try{
                if(item.LastModifiedDate >= fecha){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String asunnto = CaseTriggerHelper.reemplazarCampos(item, plantilla.Subject, 'Case');
                    String html = CaseTriggerHelper.reemplazarCampos(item, plantilla.HTMLValue, 'Case');
                    String urlLogo = CaseTriggerHelper.getLogoImagen();
                    html = CaseTriggerHelper.getLogoImagen() + html.replace('{urlSiteServicios}', Label.FS_UrlPortalServicios);
                    html =html.replace('{urlSiteEncuestas}', Label.FS_UrlPortalEncuestas);
                    html = html.replace(']]>', '') + '</td><td style="width: 25%;" /></table></body></html>';
                    html = html.replace('<![CDATA[', '');
                    mail.setSubject(asunnto);
                    mail.setHtmlBody(html);
                    mail.saveAsActivity = true;
                    mail.setWhatId(item.Id);
                    mail.setTargetObjectId(item.ContactId);
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    if(String.isNotBlank(item.FS_CorreosNotificacionesServicios__c)){
                        mail.setCcAddresses(item.FS_CorreosNotificacionesServicios__c.split(','));
                    }
                    MessageList.add(mail);
                }else{
                    listCasos.add(new Case (Id = item.Id, Status = 'Cerrado'));
                }
            }catch(exception ex){
                System.debug('Error: '+ex.getMessage() + ' Línea: ' + ex.getLineNumber());
            }
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(MessageList);
        DataBase.update(listCasos, false);
    }
  
    
    public static String camposCaso(){
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Case').getDescribe().fields.getMap();
        String query = 'Select ';
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult dfield = sfield.getDescribe();
            query += dfield.getname() + ',';
        }
        query =  query.substring(0, query.length() - 1) + ' From Case ';
        return query;
    }
    
}