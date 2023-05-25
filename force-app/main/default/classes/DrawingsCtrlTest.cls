@isTest
private class DrawingsCtrlTest {
    @isTest private static void unitTest(){
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
        //Service Ticket #205643,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        testAcc.BillingCity = 'Mumbai';
        testAcc.BillingStreet = 'ABC Street';
        testAcc.BillingCountry = 'India';  
        insert testAcc;
        
        recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        testAcc.RecordtypeId = recordId;        
        Update testAcc;         
        
        Account testAcc2 = new Account();
        //Service Ticket #205643,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        testAcc2.Name = 'TEMCO Test';
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
        
        SBQQ__QuoteLine__c QuoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Primary',
				DrawingID__c ='abc',
                SBQQ__Description__c='test <br>description'
            );
        
        insert QuoteLine;
		list<Document> lstDocument = new list<Document>();
        Document oDocument;
        Folder oFolder;
        for(Folder fld :[Select Id From Folder Where Name = 'Drawings' limit 1]){
            oFolder= fld;
        }
        
        oDocument = new Document();
        oDocument.Body = Blob.valueOf('Test Drawing');
        oDocument.ContentType = 'image/png';
        oDocument.DeveloperName = 'abc';
        oDocument.IsPublic = true;
        oDocument.Name = 'abc';
        oDocument.FolderId = oFolder.Id;    
        lstDocument.add(oDocument);
        
        oDocument = new Document();
        oDocument.Body = Blob.valueOf('Test LOGO');
        oDocument.ContentType = 'image/png';
        oDocument.DeveloperName = 'CDCLogoNew';
        oDocument.IsPublic = true;
        oDocument.Name = 'CDC Logo New';
        oDocument.FolderId = oFolder.Id;    
        lstDocument.add(oDocument);
        
        insert lstDocument;
        
        PageReference pageRef = Page.Drawings;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('qid', Quote.Id);
        DrawingsCtrl oController = new DrawingsCtrl();
        oController.init();
    }
}