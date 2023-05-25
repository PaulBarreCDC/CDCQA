@isTest
public class IFS_TestDataFactory {
    public static void createTestRecords() {
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
        testAcc.Rep_Code_Account__c = testAcc1.Id;
        // Service Ticket #205643 VPand Change Billing City and Street
        testAcc.BillingCity = 'Pune';
        testAcc.BillingStreet = 'Pune New';
        testAcc.BillingCountry = 'India';  
        insert testAcc;
        
        recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        testAcc.RecordtypeId = recordId;        
        Update testAcc;         
            
        Account testAcc2 = new Account();
        testAcc2.Name = 'TEMCO INC TEST2';
        //Service Ticket #205643,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        testAcc2.BillingCity = 'Mumbai';
        testAcc2.BillingStreet = 'ABC Street';
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
        Product2 ProductStandAlone = new Product2(Name = 'Blanket Gas Regulator',ProductCode = 'BGR', IsActive = true);         
        Insert ProductStandAlone;
            
        Opportunity o = new Opportunity(Name = 'Test Opp', PartnerAccountId=testAcc1.Id, OEM__c ='Yes',Market__c    ='  CHEM',Product_Group__c    ='Continental Disc Products',Project_Classification__c='GRN',End_Use_Application__c   ='test',Contact__c  =testCon.Id,End_User__c =testAcc.Id,EPC_Firm_Involved__c='Yes',Brand__c='CDC',StageName = 'Discovery/Identified', CloseDate = Date.today(), AccountId = testAcc.Id);
        insert o;           
            
        Opportunity o1 = new Opportunity(Name = 'Test Opp1', PartnerAccountId=testAcc1.Id, OEM__c   ='Yes',Market__c    ='CHEM',Product_Group__c    ='Continental Disc Products',Project_Classification__c='GRN',End_Use_Application__c   ='test',Contact__c  =testCon.Id,End_User__c =testAcc2.Id,EPC_Firm_Involved__c='Yes',Brand__c='CDC',StageName = 'Discovery/Identified', CloseDate = Date.today(), AccountId = testAcc2.Id);
        insert o1;
            
        SBQQ__Quote__c Quote = new SBQQ__Quote__c
            (
                SBQQ__Opportunity2__c = o.id,
                SBQQ__Account__c = testAcc.id,
                SBQQ__Primary__c = True,
                SBQQ__Status__c = 'Unblock',
                Destination_Rep__c = testAcc1.Id,
                Eng_Rep_1__c = testAcc1.Id,
                SBQQ__SubscriptionTerm__c = 12,
                Eng_Rep_2__c = testAcc1.Id
                    
            );
            
        insert Quote;        
            
        Charge__c charge= new Charge__c();
        charge.Sent_To_IFS__c=true;
        //charge.Sequence__c=1234;
        charge.Type__c='Shipping';
        charge.Amount__c = 100.0;
        charge.Quantity__c=4;
        charge.Parent_Quote__c  = Quote.Id;
        insert charge;      
            
        SBQQ__Quote__c QuoteApproved = new SBQQ__Quote__c
            (
                SBQQ__Opportunity2__c = o1.id,
                SBQQ__Account__c = testAcc2.id,
                SBQQ__Primary__c = True,
                SBQQ__Status__c = 'Approved',
                Destination_Rep__c = testAcc1.Id
                    
            );
            
        insert QuoteApproved;
            
            
        SBQQ__QuoteLine__c QuoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Unblock'                
            );
            
        insert QuoteLine;
            
            
        SBQQ__QuoteLine__c QuoteLineApproved = new SBQQ__QuoteLine__c
        (
                SBQQ__Quote__c = QuoteApproved.Id,              
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Cancel'
        );
            
        insert QuoteLineApproved;      
            
        ContentVersion contentVersion = new ContentVersion(
        Title = 'Penguins',
        PathOnClient = 'Penguins.jpg',
        VersionData = Blob.valueOf('Test Content'),
        IsMajorVersion = true);

        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
                    
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = QuoteLine.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        ContentVersion contentVersion1 = new ContentVersion(
        Title = 'Penguins',
        PathOnClient = 'Penguins.jpg',
        VersionData = Blob.valueOf('Test Content'),
        IsMajorVersion = true);

        insert contentVersion1;    
        List<ContentDocument> documents1 = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
                    
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl1 = New ContentDocumentLink();
        cdl1.LinkedEntityId = Quote.id;
        cdl1.ContentDocumentId = documents1[0].Id;
        cdl1.shareType = 'V';
        insert cdl1;
            
        BGR__c bgrRec = new BGR__c();
        bgrRec.Positive_Material_Identification__c = 'CONFIRM';
        bgrRec.Atex__c = 'Y';
        bgrRec.CSA_Markings__c = 'Y';
        bgrRec.Radiography__c = 'CRITICAL';
        bgrRec.GOST_CU_Tr_010_2011__c = 'Y';
        bgrRec.RGEUNT__c = 'psig';
        bgrRec.Setting_Units__c ='psig';
        bgrRec.Service_Type__c='Pressure';
        bgrRec.Setting__c=123; 
        bgrRec.Supply_Pressure__c=123;
        bgrRec.Supply_Pressure_Units__c ='psig';
        bgrRec.Atmospheric_Pressure_Units__c    ='atmg';
        insert bgrRec;
        bgrRec.Quote_Line__c=QuoteLine.Id;
        Update bgrRec;  
    }
}