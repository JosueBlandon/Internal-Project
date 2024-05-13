trigger TrabajoAgenteTrigger on AgentWork (before insert, before update, before delete, after insert, after update, after delete) {
    if(trigger.isInsert){
        if(trigger.isBefore){
            //empty
        }else if(trigger.isAfter){
            TrabajoAgenteHandler.afterInsert(trigger.new);
        }
    }
}