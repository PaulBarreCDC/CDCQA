@isTest
private class SizingsCtrlTest {
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
        //Service Ticket #205643, SET BILLING ADDRESS
        testAcc.BillingCountry ='United States';
        testAcc.BillingStreet ='Albama';
        testAcc.BillingCity ='test city';
        testAcc.BillingState ='Florida';
        testAcc.BillingPostalCode ='123';
        insert testAcc;
        
        recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        testAcc.RecordtypeId = recordId;        
        Update testAcc;         
        
        Account testAcc2 = new Account();
        testAcc2.Name = 'TEMCO INC TEST2';
        insert testAcc2;
        testAcc2.RecordtypeId = recordId;
        testAcc2.Rep_Code_Account__c    = testAcc1.Id; 
        //Service Ticket #205643, SET BILLING ADDRESS
        testAcc2.BillingCountry ='United States';
        testAcc2.BillingStreet ='Albama';
        testAcc2.BillingCity ='test city';
        testAcc2.BillingState ='Florida';
        testAcc2.BillingPostalCode ='123';
        Update testAcc2;        
        
        Contact testCon = new Contact();
        testCon.LastName = 'TEMCO INC TEST Contact';
        testCon.AccountId = testAcc.Id;
        testCon.Default_Communication_Method__c = 'PHONE';
        insert testCon;     
        
        //Create a Product
        Product2 ProductStandAlone = new Product2(Name = 'Rupture Disc',ProductCode = 'RD', IsActive = true);         
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
        
        list<SBQQ__QuoteLine__c> lstQL = new list<SBQQ__QuoteLine__c>();
        SBQQ__QuoteLine__c quoteLine;
        quoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Primary',
                DrawingID__c ='abc',
                SBQQ__Description__c='test <br>description'
            );
        lstQL.add(quoteLine);
        
        quoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Primary',
                DrawingID__c ='abc',
                SBQQ__Description__c='test <br>description'
            );
        lstQL.add(quoteLine);
        
        quoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Primary',
                DrawingID__c ='abc',
                SBQQ__Description__c='test <br>description'
            );
        lstQL.add(quoteLine);
        
        quoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Primary',
                DrawingID__c ='abc',
                SBQQ__Description__c='test <br>description'
            );
        lstQL.add(quoteLine);
        
        quoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Primary',
                DrawingID__c ='abc',
                SBQQ__Description__c='test <br>description'
            );
        lstQL.add(quoteLine);
        
        quoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Primary',
                DrawingID__c ='abc',
                SBQQ__Description__c='test <br>description'
            );
        lstQL.add(quoteLine);
        
                quoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Primary',
                DrawingID__c ='abc',
                SBQQ__Description__c='test <br>description'
            );
        lstQL.add(quoteLine);
        
        quoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Primary',
                DrawingID__c ='abc',
                SBQQ__Description__c='test <br>description'
            );
        lstQL.add(quoteLine);
        
        quoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Primary',
                DrawingID__c ='abc',
                SBQQ__Description__c='test <br>description'
            );
        lstQL.add(quoteLine);
        
        quoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Primary',
                DrawingID__c ='abc',
                SBQQ__Description__c='test <br>description'
            );
        lstQL.add(quoteLine);
        
        quoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Primary',
                DrawingID__c ='abc',
                SBQQ__Description__c='test <br>description'
            );
        lstQL.add(quoteLine);
        
        quoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Primary',
                DrawingID__c ='abc',
                SBQQ__Description__c='test <br>description'
            );
        lstQL.add(quoteLine);
        quoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Primary',
                DrawingID__c ='abc',
                SBQQ__Description__c='test <br>description'
            );
        lstQL.add(quoteLine);
        quoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Primary',
                DrawingID__c ='abc',
                SBQQ__Description__c='test <br>description'
            );
        lstQL.add(quoteLine);
        quoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Primary',
                DrawingID__c ='abc',
                SBQQ__Description__c='test <br>description'
            );
        lstQL.add(quoteLine);
        
        insert lstQL;
        
        list<Rupture_Disc__c> lstRD = new list<Rupture_Disc__c>();
        Rupture_Disc__c RD;
        
        RD= new Rupture_Disc__c();
        RD.Quote_Line__c = lstQL[0].Id;
        RD.constrain_product_selection_by_flow__c='yes';
        RD.Evaluation_Type__c = 'Capacity';
        RD.Evaluation_Per__c = 'ASME Water';
        lstRD.add(RD);
        
        RD= new Rupture_Disc__c();
        RD.Quote_Line__c = lstQL[1].Id;
        RD.constrain_product_selection_by_flow__c='yes';
        RD.Evaluation_Type__c = 'Sizing & Capacity';
        RD.Evaluation_Per__c = 'ISO Wet Steam';
        lstRD.add(RD);
        
        RD= new Rupture_Disc__c();
        RD.Quote_Line__c = lstQL[2].Id;
        RD.constrain_product_selection_by_flow__c='yes';
        RD.Evaluation_Type__c = 'Capacity';
        RD.Evaluation_Per__c = 'ASME Steam';
        lstRD.add(RD);
        
        RD= new Rupture_Disc__c();
        RD.Quote_Line__c = lstQL[3].Id;
        RD.constrain_product_selection_by_flow__c='yes';
        RD.Evaluation_Type__c = 'Capacity';
        RD.Evaluation_Per__c = 'API Steam';
        lstRD.add(RD);
        
        RD= new Rupture_Disc__c();
        RD.Quote_Line__c = lstQL[4].Id;
        RD.constrain_product_selection_by_flow__c='yes';
        RD.Evaluation_Type__c = 'Capacity';
        RD.Evaluation_Per__c = 'API Liquid';
        lstRD.add(RD);
        
        RD= new Rupture_Disc__c();
        RD.Quote_Line__c = lstQL[5].Id;
        RD.constrain_product_selection_by_flow__c='yes';
        RD.Evaluation_Type__c = 'Capacity';
        RD.Evaluation_Per__c = 'ISO Dry Steam';
        lstRD.add(RD);
        
        RD= new Rupture_Disc__c();
        RD.Quote_Line__c = lstQL[6].Id;
        RD.constrain_product_selection_by_flow__c='yes';
        RD.Evaluation_Type__c = 'Capacity';
        RD.Evaluation_Per__c = 'ISO Wet Steam';
        lstRD.add(RD);
        
        RD= new Rupture_Disc__c();
        RD.Quote_Line__c = lstQL[7].Id;
        RD.constrain_product_selection_by_flow__c='yes';
        RD.Evaluation_Type__c = 'Sizing & Capacity';
        RD.Evaluation_Per__c = 'ASME Steam';
        lstRD.add(RD);
        
        RD= new Rupture_Disc__c();
        RD.Quote_Line__c = lstQL[8].Id;
        RD.constrain_product_selection_by_flow__c='yes';
        RD.Evaluation_Type__c = 'Sizing & Capacity';
        RD.Evaluation_Per__c = 'API Steam';
        lstRD.add(RD);
        
        RD= new Rupture_Disc__c();
        RD.Quote_Line__c = lstQL[9].Id;
        RD.constrain_product_selection_by_flow__c='yes';
        RD.Evaluation_Type__c = 'Sizing & Capacity';
        RD.Evaluation_Per__c = 'API Liquid';
        lstRD.add(RD);
        
        RD= new Rupture_Disc__c();
        RD.Quote_Line__c = lstQL[10].Id;
        RD.constrain_product_selection_by_flow__c='yes';
        RD.Evaluation_Type__c = 'Sizing & Capacity';
        RD.Evaluation_Per__c = 'ISO Dry Steam';
        lstRD.add(RD);
        
        RD= new Rupture_Disc__c();
        RD.Quote_Line__c = lstQL[11].Id;
        RD.constrain_product_selection_by_flow__c='yes';
        RD.Evaluation_Type__c = 'Sizing & Capacity';
        RD.Evaluation_Per__c = 'ISO Wet Steam';
        lstRD.add(RD);
        
        RD= new Rupture_Disc__c();
        RD.Quote_Line__c = lstQL[12].Id;
        RD.constrain_product_selection_by_flow__c='yes';
        RD.Evaluation_Type__c = 'Sizing & Capacity';
        RD.Evaluation_Per__c = 'ASME Water';
        lstRD.add(RD);
        
        RD= new Rupture_Disc__c();
        RD.Quote_Line__c = lstQL[13].Id;
        RD.constrain_product_selection_by_flow__c='yes';
        RD.Evaluation_Type__c = 'Capacity';
        RD.Evaluation_Per__c = 'ISO Liquid';
        lstRD.add(RD);
        
        RD= new Rupture_Disc__c();
        RD.Quote_Line__c = lstQL[14].Id;
        RD.constrain_product_selection_by_flow__c='yes';
        RD.Evaluation_Type__c = 'Sizing & Capacity';
        RD.Evaluation_Per__c = 'ISO Liquid';
        lstRD.add(RD);
        
        insert lstRD;
        
        list<Document> lstDocument = new list<Document>();
        Document oDocument;
        Folder oFolder;
        for(Folder fld :[Select Id From Folder Where Name = 'Drawings' limit 1]){
            oFolder= fld;
        }
        
        oDocument = new Document();
        oDocument.Body = Blob.valueOf('Test Drawing');
        oDocument.ContentType = 'image/png';
        oDocument.DeveloperName = 'AsmeLiquidCapacity';
        oDocument.IsPublic = true;
        oDocument.Name = 'AsmeLiquidCapacitys';
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
        
        PageReference pageRef = Page.Sizings;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('qid', Quote.Id);
        SizingsCtrl oController = new SizingsCtrl();
        oController.init();
    }
}