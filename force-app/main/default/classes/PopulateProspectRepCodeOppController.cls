public class PopulateProspectRepCodeOppController {

    //added an instance varaible for the standard controller
    @TestVisible private ApexPages.StandardController controller {get; set;}
    // the actual account    
    @TestVisible private Opportunity opp;
    
    public string selectedRepCode{get;set;}
    public PopulateProspectRepCodeOppController(ApexPages.StandardController controller) {
        //initialize the stanrdard controller
        this.controller = controller;
        this.opp = (Opportunity)controller.getRecord();
    }
    public List<Selectoption> getRepCodeFields(){        
        Map<String, List<String>> accountWithRepCode = new Map<String, List<String>>();
        Map<String, Rep_Code__c> repCodeMap = Rep_Code__c.getAll();
        for(Rep_Code__c repCode: repCodeMap.values()){
            if(accountWithRepCode.containsKey(repCode.Company_Name__c)){
                (accountWithRepCode.get(repCode.Company_Name__c)).add(repCode.Company_Code__c);
            }else{
                accountWithRepCode.put(repCode.Company_Name__c, new List<String>{repCode.Company_Code__c});
            }
        }
        User usr = [SELECT Id, Contact.AccountId, Contact.Account.Name FROM User WHERE Id = : UserInfo.getUserId() ];
        
        List<Selectoption> repCodeLst = new List<selectoption>();
        repCodeLst.add(new selectOption('', '- None -'));
        if(accountWithRepCode.containsKey(usr.Contact.Account.Name)){
            for(String strVal : accountWithRepCode.get(usr.Contact.Account.Name)){
                repCodeLst.add(new selectoption(strVal,strVal));
            }
        }
        
        return repCodeLst; 
    }
    
    public void updateOpportunity(){
        try{
            System.debug('***selectedRepCode*** '+selectedRepCode);
            Opportunity op = [select Id, Rep_Code__c from Opportunity where ID =: opp.Id];
            System.debug('***op111*** '+op);
            op.Opp_Rep_Code__c = selectedRepCode;
            update op;
            System.debug('***op*** '+op);
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Opportunity Rep Code Updated Successfully.Thank you!'));
        }catch(Exception ex){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Record Update Failed.Following exception occured '+ex.getMessage()));
        }
    }
}