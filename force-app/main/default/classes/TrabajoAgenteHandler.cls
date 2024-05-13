public class TrabajoAgenteHandler {

    public static void afterInsert(List<AgentWork> newAgentWork){
        TrabajoAgenteHelper.verificacionCaso(newAgentWork);
    }

}