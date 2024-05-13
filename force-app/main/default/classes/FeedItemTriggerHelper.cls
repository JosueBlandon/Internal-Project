public class FeedItemTriggerHelper {

    public static void validacionModificacion(List<FeedItem> newFeedItemList){
        if(validacionUser() || System.isFuture()){
            return;
        }
        for(FeedItem item: newFeedItemList){
            item.addError('Privilegios insuficiente');
        } 
    }
    
    public static Boolean validacionUser(){
        User u = [Select Name, Profile.Name, UserRole.Name From User where Id = :UserInfo.getUserId()];
        Boolean flagPerfil = u.Profile.Name == 'Administrador del sistema' || u.Profile.Name == 'System Administrator';
        flagPerfil = flagPerfil || (u.UserRole.Name != null && u.UserRole.Name.contains('FS_Jefe'));
        flagPerfil = flagPerfil || u.Name.contains('invitado al sitio Web');
        return flagPerfil;
    }
    
}