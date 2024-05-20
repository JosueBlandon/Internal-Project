public class DataFactory {
    
    private static final String USER_FIRST_NAME = 'TestUser';
    private static final String USER_LAST_NAME = 'TestLastName';
    private static final String USER_EMAIL = 'user.email@test.com';
    
    public static User createUser(String profileName, Boolean doInsert) {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;

        UserRole userrole = [   SELECT  Id, DeveloperName 
                                FROM    UserRole 
                                WHERE   DeveloperName = 'Presidente' Limit 1   ];

        Profile profile = [ SELECT  Id 
                            FROM    Profile 
                            WHERE   Name =: profileName 
                            LIMIT 1 ];

        User user = new User(
            firstName = USER_FIRST_NAME,
            lastName = USER_LAST_NAME,
            UserRoleId = userRole.Id,
            profileId = profile.id,
            username = USER_EMAIL,
            email = USER_EMAIL,
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );

        if(doInsert) {
            insert user;
        }
        return user;
    }
    
    public static Account insertAccount(){
        User adminUser = [  SELECT  Id, UserRoleId 
                            FROM    User 
                            WHERE   (Profile.Name='Administrador del sistema' or  Profile.Name='System Administrator') and IsActive = true
                            LIMIT 1 ];

        Account acc = new Account();
        acc.Name = 'Account Test';
        acc.OwnerId = adminUser.Id;
        insert acc;
        return acc;
    }
    
    public static Contact insertContact(Account acc){
        Contact contc = new Contact();
        contc.FirstName = 'FistName Test';
        contc.LastName = 'LastName Test';
        contc.AccountId = acc.Id;
        contc.Email = 'test@test.com';
        insert contc;
        return contc;
    }
    
    public static FS_ProductoAdquirido__c insertProduct(Account acc, String prod, String mod, String subM){
        FS_ProductoAdquirido__c p = new FS_ProductoAdquirido__c();
        p.FS_Cuenta__c = acc.Id;
        p.FS_Producto__c = prod;
        p.FS_Modulo__c = mod;
        p.FS_SubModulo__c = subM;
        p.FS_Esta_activo__c = true;
        insert p;
        return p;
    }
    
    public static Case insertCase(Account acc, Contact cont, FS_ProductoAdquirido__c p, String tipoRegistro){
        Case caso = new Case();
        caso.AccountId = acc.Id;
        caso.ContactId = cont.Id;
        caso.FS_Producto__c = p.FS_Producto__c;
        caso.FS_Modulo__c = p.FS_Modulo__c;
        caso.FS_SubModulo__c = p.FS_SubModulo__c;
        caso.FS_DescripcionCliente__c = '<p>Test</p>';
        caso.FS_TipoIncidente__c = 'Puntual';
        caso.FS_AgenteQA__c = userInfo.getUserId();
        caso.FS_AgenteN2__c = userInfo.getUserId();
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(tipoRegistro).getRecordTypeId();
        insert caso;
        return caso;
    }
    
    public static User insertUserCommunity(Contact cont){

        UserRole userrole = [   SELECT  Id, DeveloperName 
                                FROM    UserRole 
                                WHERE   DeveloperName = 'Presidente' Limit 1   ];

        User adminUser = [  SELECT  Id, UserRoleId 
                            FROM    User 
                            WHERE   (Profile.Name='Administrador del sistema' or  Profile.Name='System Administrator') and IsActive = true
                            LIMIT 1 ];

        adminUser.UserRoleId = userRole.Id;
        
        try {
        update adminUser;
        } catch (Exception e) {
           System.debug('An error occurred');
        }     

        User u = new User();

        System.runAs(adminUser) {
            u.Alias = 'tes'; 
            u.Email='test@myorg.com'; 
            u.EmailEncodingKey='UTF-8'; 
            u.LastName='Testing'; 
            u.LanguageLocaleKey='en_US'; 
            u.ContactId = cont.Id;
            u.LocaleSidKey='en_US'; 
            u.ProfileId = [Select Id from Profile Where Name = 'Customer Community User' or Name = 'Customer Community Plus User' limit 1].Id;
            u.TimeZoneSidKey='America/New_York';
            u.UserName= 'test@myorg.com';
            insert u;
        }
        return u;
    }
    
}