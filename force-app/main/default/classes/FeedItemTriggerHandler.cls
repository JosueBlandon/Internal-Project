public class FeedItemTriggerHandler {

    public static void beforeUpdate(List<FeedItem> feedItemList){
        FeedItemTriggerHelper.validacionModificacion(feedItemList);
    }

    public static void beforeDelete(List<FeedItem> feedItemList){
        FeedItemTriggerHelper.validacionModificacion(feedItemList);
    }
    
}