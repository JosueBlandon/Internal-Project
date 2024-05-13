public class FeedCommentTriggerHandler {

    public static void afterInsert(List<FeedComment> newFeedCommentList){
        FeedCommentTriggerHelper.validacionComentario(newFeedCommentList);
        FeedCommentTriggerHelper.sendNotification(newFeedCommentList);
    }

    public static void beforeUpdate(List<FeedComment> newFeedCommentList){
        FeedCommentTriggerHelper.validacionModificacion(newFeedCommentList);
    }
    
    public static void beforeDelete(List<FeedComment> newFeedCommentList){
        FeedCommentTriggerHelper.validacionModificacion(newFeedCommentList);
    }
}