@isTest
public class RegenerationWGBTest {
	
    @testSetup
    public static void dataSetup() {
                
        Account testAcc1 = new Account();
        Id recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner & House Account').getRecordTypeId();
        testAcc1.RecordtypeId = recordId;
        testAcc1.Name = 'TEMCO INC PARTNER';
        testAcc1.Rep_Code__c = '1AR3';
        testAcc1.Region__c='D01';
        testAcc1.District__c='AMERICAS';
        testAcc1.External_ID__c ='1AR3-D01-AMERICAS';              
        insert testAcc1;        
        testAcc1.IsPartner = true;      
        Update testAcc1;        
            
        Account testAcc = new Account();
        testAcc.Name = 'TEMCO INC TEST';
        // Service Ticket #205643 VPand Added Billing City and Street FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
 		testAcc.BillingCity = 'Mumbai';
        testAcc.BillingStreet = 'ABC Street';
        testAcc.BillingCountry = 'India';  
        testAcc.Rep_Code_Account__c = testAcc1.Id;  
        insert testAcc;
        
        recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        testAcc.RecordtypeId = recordId;        
        Update testAcc;         
            
        Account testAcc2 = new Account();
        testAcc2.Name = 'TEMCO INC TEST2';
        // Service Ticket #205643 VPand Added Billing City and Street FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
 		testAcc2.BillingCity = 'Pune';
        testAcc2.BillingStreet = 'Pune Street';
        testAcc2.BillingCountry = 'India';  
        insert testAcc2;
        testAcc2.RecordtypeId = recordId;
        testAcc2.Rep_Code_Account__c    = testAcc1.Id;          
        Update testAcc2;        
            
        Contact testCon = new Contact();
        testCon.LastName = 'TEMCO INC TEST Contact';
        testCon.AccountId = testAcc.Id;
        testCon.Default_Communication_Method__c = 'PHONE';
        insert testCon;     
            
        //Create a Product
        list<Product2> lstProducts = new list<Product2>();
        Product2 oProduct5 = new Product2(Name = 'Waste Gas Burner',ProductCode = 'WGB', IsActive = true);         
        lstProducts.add(oProduct5);
        insert lstProducts;
        
        Opportunity o = new Opportunity(Name = 'Test Opp', PartnerAccountId=testAcc1.Id, OEM__c ='Yes',Market__c    ='  CHEM',Product_Group__c    ='Continental Disc Products',Project_Classification__c='GRN',End_Use_Application__c   ='test',Contact__c  =testCon.Id,End_User__c =testAcc.Id,EPC_Firm_Involved__c='Yes',Brand__c='CDC',StageName = 'Discovery/Identified', CloseDate = Date.today(), AccountId = testAcc.Id);
        insert o;           
            
        SBQQ__Quote__c Quote = new SBQQ__Quote__c
            (
                SBQQ__Opportunity2__c = o.id,
                SBQQ__Account__c = testAcc.id,
                SBQQ__Primary__c = True,
                SBQQ__Status__c = 'Pending',
                Destination_Rep__c = testAcc1.Id,
                Eng_Rep_1__c = testAcc1.Id,
                SBQQ__SubscriptionTerm__c = 12,
                Eng_Rep_2__c = testAcc1.Id,
                Sales_Division__c ='40'
                    
            );
            
        insert Quote;        
        Test.StartTest();    
        list<SBQQ__QuoteLine__c> lstQuoteLine = new list<SBQQ__QuoteLine__c>(); 
        
        SBQQ__QuoteLine__c QuoteLine5 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = Quote.Id, SBQQ__Product__c = oProduct5.Id, Line_Status__c ='Primary');
        lstQuoteLine.add(QuoteLine5);
        insert lstQuoteLine;
                               
        
        WasteGasBurner__c wgb = new WasteGasBurner__c(); 
        wgb.Quote_Line__c = QuoteLine5.Id;
        insert wgb;
    }
    
    @isTest
    public static void testRegeneration() {
        
        Test.startTest();
        
        SBQQ__QuoteLine__c quoteLine  = [SELECT Id, SBQQ__Quote__c FROM SBQQ__QuoteLine__c LIMIT 1];

        WasteGasBurner__c wgb  = [SELECT Id, IsConfig__c FROM WasteGasBurner__c LIMIT 1];
        wgb.IsConfig__c = true;
        update wgb;
        
        WGB_Outputs__c output = new WGB_Outputs__c();
        output.WasteGasBurner__c = wgb.Id;
        insert output;
        
        MassConfiguratorUpdateInitiation obj = new MassConfiguratorUpdateInitiation('WGB', quoteLine.SBQQ__Quote__c);
        Id batchJobId = Database.executeBatch(obj); 
        
        Regeneration_Request_Details__c rrd = new Regeneration_Request_Details__c();
        rrd.Product_Name__c  = 'WGB';
        rrd.Product_Code__c = 'WGB';
        rrd.Batch_Job_ID__c = batchJobId;
        rrd.Quote_No__c = null;
        rrd.Requested_By__c = UserInfo.getUserId();
        rrd.Status__c  = 'Pending';
        upsert rrd;
        
        Test.stopTest();
    }
    
    @isTest
    public static void testRegeneration2() {
        
        Test.startTest();
        
        SBQQ__QuoteLine__c quoteLine  = [SELECT Id, SBQQ__Quote__c FROM SBQQ__QuoteLine__c LIMIT 1];

        WasteGasBurner__c wgb  = [SELECT Id, IsConfig__c FROM WasteGasBurner__c LIMIT 1];
        wgb.IsConfig__c = true;
        wgb.Quote_Description_Engineer_Override__c = true;
        update wgb;
        
        WGB_Outputs__c output = new WGB_Outputs__c();
        output.WasteGasBurner__c = wgb.Id;
        output.OA_Override__c = 'Test';
        output.OB_Override__c = 'Test';
        insert output;
        
        MassConfiguratorUpdateInitiation obj = new MassConfiguratorUpdateInitiation('WGB', quoteLine.SBQQ__Quote__c);
        Id batchJobId = Database.executeBatch(obj); 
        
        Regeneration_Request_Details__c rrd = new Regeneration_Request_Details__c();
        rrd.Product_Name__c  = 'WGB';
        rrd.Product_Code__c = 'WGB';
        rrd.Batch_Job_ID__c = batchJobId;
        rrd.Quote_No__c = null;
        rrd.Requested_By__c = UserInfo.getUserId();
        rrd.Status__c  = 'Pending';
        upsert rrd;
        
        Test.stopTest();
    }
}