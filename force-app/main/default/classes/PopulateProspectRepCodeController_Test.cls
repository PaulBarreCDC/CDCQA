@isTest(SeeAllData=true)
public class PopulateProspectRepCodeController_Test {
    
    @isTest
    public static void updateSalesDivisonOnAccount_Test(){
        //Create dummy account for controller
        Account acc = new Account();
        
        //call the current page for testing
        Test.setCurrentPage(Page.PopulateProspectRepCode);
        
        //create a standard controller and pass the dummy account controller
        ApexPages.StandardController accountController = new ApexPages.StandardController(acc);
        
        //Get the Standard Controller ang pass it to controller extension
        PopulateProspectRepCodeController ace = new PopulateProspectRepCodeController(accountController);
        try{            
            //Start the Test            
            ace.a.Name = 'Testing';
            ace.selectedRepCode = 'Test';
            ace.getRepCodeFields();
            ace.updateAccount();
            //PageReference redPage = ace.updateAccount();
            //End Test
        }catch(Exception ex){
            
        }        
    }
}