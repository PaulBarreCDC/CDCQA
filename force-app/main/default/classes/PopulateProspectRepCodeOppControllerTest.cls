@isTest
public class PopulateProspectRepCodeOppControllerTest {

    @isTest
    public static void PopulateProspectRepCodeOppController_Test(){
        //Create dummy account for controller
        Opportunity opp = new Opportunity();
        List<Rep_Code__c> repList = new List<Rep_Code__c>();
        for(Integer i=0; i<=1; i++){
            Rep_Code__c rep = new Rep_Code__c();
            rep.Name = 'Test'+i;
            rep.Company_Name__c = 'Test';
            rep.Company_Code__c = '005';
            repList.add(rep);
        }
        insert repList;
        //call the current page for testing
        Test.setCurrentPage(Page.PopulateProspectRepCode);
        
        //create a standard controller and pass the dummy account controller
        ApexPages.StandardController accountController = new ApexPages.StandardController(opp);
        
        //Get the Standard Controller ang pass it to controller extension
        PopulateProspectRepCodeOppController ace = new PopulateProspectRepCodeOppController(accountController);
        try{            
            //Start the Test            
            ace.opp.Name = 'Testing';
            ace.selectedRepCode = 'Test';
            ace.getRepCodeFields();
            ace.updateOpportunity();
            //PageReference redPage = ace.updateAccount();
            //End Test
        }catch(Exception ex){
            
        }        
    }
}