public class UtilityHelper {
    public User oCurrentUser;
    //public List<AccountContactRelation> lstACR;
    public map<String,Schema.RecordTypeInfo> mapAccountRecordTypeNameWiseId;
    public List<ProductAccessibilityConfig__mdt> lstProductAccessibilityConfigs;
        
    public static UtilityHelper self {get; private set;}
    static {
        self = new UtilityHelper();
    }
    
    public boolean isInternalUser() {
        System.debug('@Developer -->isInternalUser:' );
        
        if(oCurrentUser.ContactId == null){
            System.debug('@Developer -->Internal User - true:' );
            return true;
        }
        return false;
    }
    
    public Boolean isPartnerUser() {
        System.debug('@Developer -->isPartnerUser:' );
        
        if(oCurrentUser.Contact.Account.isPartner){
            System.debug('@Developer -->Partner User - true:' );
            return true;
        }
        return false;
    }
    
    public Boolean isPartnerUser(String userId) {
        System.debug('@Developer -->isPartnerUser:' );
        System.debug('@Developer --> userId :' + userId);
        for(User usr : [Select Id,ContactId,Contact.Name,Contact.AccountId,Contact.Account.Name,Contact.Account.IsPartner
                      From User 
                      Where Id =:userId])
        {
            if(usr.Contact.Account.isPartner){
                System.debug('@Developer -->User : Partner User' );
                return true;
            }    
        } 
        return false;
    }
    
    public map<Id,Boolean> isPartnerUser(set<Id> setUserId) {
        System.debug('@Developer -->isPartnerUser:' );
        System.debug('@Developer --> setUserId :' + setUserId);
        map<Id,Boolean> mapUserWiseIsPartner = new map<Id,Boolean>();
        for(User usr : [Select Id,ContactId,Contact.Name,Contact.AccountId,Contact.Account.Name,Contact.Account.IsPartner
                      From User 
                      Where Id IN:setUserId])
        {
            if(usr.Contact.Account.isPartner){
            	 mapUserWiseIsPartner.put(usr.Id,true);
            }    
            else{
                mapUserWiseIsPartner.put(usr.Id,false);
            }
        } 
        System.debug('@Developer --> mapUserWiseIsPartner :' + mapUserWiseIsPartner);
        return mapUserWiseIsPartner;
    }
    
    public Id getPartnerAccountId(){
        System.debug('@Developer -->getPartnerAccountId:');
        Id partnerAccountId = null;
        
        /*
        Id salesRepPartnerAccountId = null;
        Id directPartnerAccountId = null;
        
        Integer nDirectAcc = 0;
        Integer nSalesRepsAcc = 0;
        
        for(AccountContactRelation acr: lstACR){
            if(acr.isDirect){
                directPartnerAccountId = acr.AccountId;
                nDirectAcc++;
            }
            else if(acr.Roles == 'Sales Rep'){
                salesRepPartnerAccountId = acr.AccountId;
                nSalesRepsAcc++;
            }
        }
        
        if(isPartnerUser()){
            if(nSalesRepsAcc == 1){
                partnerAccountId = salesRepPartnerAccountId;
            }
            else if(nSalesRepsAcc == 0 && nDirectAcc == 1){
                partnerAccountId = directPartnerAccountId;
            }
        }
        System.debug('@Developer --> partnerAccountId :' + partnerAccountId);
        return partnerAccountId;
		*/
        
        System.debug('@Developer --> oCurrentUser.Contact.Account.RecordType.Name :' + oCurrentUser.Contact.Account.RecordType.Name);
        System.debug('@Developer --> oCurrentUser.Contact.Account.External_ID__c :' + oCurrentUser.Contact.Account.External_ID__c);
        if(oCurrentUser.Contact.Account.RecordType.Name == 'Partner & House Account' && 
           oCurrentUser.Contact.Account.External_ID__c != null)
        {
            partnerAccountId = oCurrentUser.Contact.AccountId; 
        }
        System.debug('@Developer --> partnerAccountId :' + partnerAccountId);
        return partnerAccountId;
    }
    
    public Map<Id,list<AccountTeamMember>> getAccountTeamMembers(set<Id> setAccId){
        System.debug('@Developer -->getAccountTeamMembers:');
        list<AccountTeamMember> lstATM ;
        Map<Id,list<AccountTeamMember>> mapAccIdWiseAccountTeamMembers = new Map<Id,list<AccountTeamMember>>();
        for(AccountTeamMember atm: [Select Id,AccountId,AccountAccessLevel,TeamMemberRole,UserId 
                                          From AccountTeamMember 
                                    Where AccountId In :setAccId])
        {
            if(mapAccIdWiseAccountTeamMembers.containsKey(atm.AccountId)){
                lstATM = mapAccIdWiseAccountTeamMembers.get(atm.AccountId);
            }
            else{
            	lstATM = new list<AccountTeamMember>();    
            }
            
            lstATM.add(atm);
            mapAccIdWiseAccountTeamMembers.put(atm.AccountId,lstATM);
        }
        System.debug('@Developer --> mapAccIdWiseAccountTeamMembers :' + mapAccIdWiseAccountTeamMembers);
        
        return mapAccIdWiseAccountTeamMembers;
    }
    
    private UtilityHelper() {
        mapAccountRecordTypeNameWiseId = Schema.SObjectType.Account.getRecordTypeInfosByName();
            
        for(User u : [Select Id,Profile.Name,ContactId,Contact.Email,Contact.AccountId,Contact.Account.Name,Contact.Account.IsPartner,
                      Contact.Account.RecordType.Name,Contact.Account.External_ID__c
                      From User 
                      Where Id =:userInfo.getUserId()])
        {
            oCurrentUser = u;
        }          
        
        /*if(!isInternalUser()){
            lstACR = [Select Id, ContactId, AccountId, Account.Name, Roles, IsDirect 
                      From AccountContactRelation 
                      Where ContactId = :oCurrentUser.ContactId];
        }*/
        
        lstProductAccessibilityConfigs =  fetchProductAccessibilityConfigs();
    }

    public List<ProductAccessibilityConfig__mdt> fetchProductAccessibilityConfigs(){

        List<ProductAccessibilityConfig__mdt> lstProductAccessibilityConfigs = new List<ProductAccessibilityConfig__mdt>();

        for(ProductAccessibilityConfig__mdt pac : [Select Id,Config_Status__c,Default_View__c,Profile_Name__c,
        Quote_Status__c,View__c
                                                    From ProductAccessibilityConfig__mdt
                                                     WHERE Active__c = true 
                                                     AND Profile_Name__c =: oCurrentUser.Profile.Name  ]){
           
                                                        lstProductAccessibilityConfigs.add(pac);
        }

        return lstProductAccessibilityConfigs;


    } 
}