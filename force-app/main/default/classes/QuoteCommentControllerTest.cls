/**
 * @description       : 
 * @author            : ApexIT - SFDC Dev Team
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : ApexIT - SFDC Dev Team
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   11-02-2020   ApexIT - SFDC Dev Team   Initial Versio
 * 1.1   16-06-2021   Vivek Pandey              Service Ticket #205643 - Testcases are failing with Duplicate account getting created in testsetup.
**/
@isTest
public class QuoteCommentControllerTest {
   
    static testMethod void unitTest(){
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
        Product2 oProduct1 = new Product2(Name = 'Blanket Gas Regulator',ProductCode = 'BGR', IsActive = true);         
        lstProducts.add(oProduct1);
        /*Product2 oProduct2 = new Product2(Name = 'Rupture Disc',ProductCode = 'RD', IsActive = true);         
        lstProducts.add(oProduct2);
        Product2 oProduct3 = new Product2(Name = 'Relief Valves',ProductCode = 'RLFVLV', IsActive = true);         
        lstProducts.add(oProduct3);
        Product2 oProduct4 = new Product2(Name = 'Flame Products',ProductCode = 'FlameProducts', IsActive = true);         
        lstProducts.add(oProduct4);
        Product2 oProduct5 = new Product2(Name = 'Waste Gas Burner',ProductCode = 'WGB', IsActive = true);         
        lstProducts.add(oProduct5);
        Product2 oProduct6 = new Product2(Name = 'Holders',ProductCode = 'HLD', IsActive = true);         
        lstProducts.add(oProduct6);*/
        insert lstProducts;
        date dtCloseDate =system.today().adddays(15);
        Opportunity o = new Opportunity(Name = 'Test Opp', PartnerAccountId=testAcc1.Id, OEM__c ='Yes',Market__c    ='  CHEM',Product_Group__c    ='Continental Disc Products',Project_Classification__c='GRN',End_Use_Application__c   ='test',Contact__c  =testCon.Id,End_User__c =testAcc.Id,EPC_Firm_Involved__c='Yes',Brand__c='LaMot',StageName = 'Discovery/Identified', CloseDate = dtCloseDate, AccountId = testAcc.Id);
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
                Eng_Rep_2__c = testAcc1.Id,
                Engineering_Approver__c = UserInfo.getUserId()              
            );
            
        insert Quote;        
            
        list<SBQQ__QuoteLine__c> lstQuoteLine = new list<SBQQ__QuoteLine__c>(); 
        SBQQ__QuoteLine__c QuoteLine1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = Quote.Id,SBQQ__Product__c = oProduct1.Id,Line_Status__c ='Primary',Engineering_Status__c = 'Yes', SBQQ__Number__c =1);
        lstQuoteLine.add(QuoteLine1);
        /*SBQQ__QuoteLine__c QuoteLine2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = Quote.Id,SBQQ__Product__c = oProduct2.Id,Line_Status__c ='Cancel');
        lstQuoteLine.add(QuoteLine2);
        SBQQ__QuoteLine__c QuoteLine3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = Quote.Id,SBQQ__Product__c = oProduct3.Id,Line_Status__c ='Cancel');
        lstQuoteLine.add(QuoteLine3);
        SBQQ__QuoteLine__c QuoteLine4 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = Quote.Id,SBQQ__Product__c = oProduct4.Id,Line_Status__c ='Cancel');
        lstQuoteLine.add(QuoteLine4);
        SBQQ__QuoteLine__c QuoteLine5 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = Quote.Id,SBQQ__Product__c = oProduct5.Id,Line_Status__c ='Cancel');
        lstQuoteLine.add(QuoteLine5);
        SBQQ__QuoteLine__c QuoteLine6 = new SBQQ__QuoteLine__c(SBQQ__Quote__c = Quote.Id,SBQQ__Product__c = oProduct6.Id,Line_Status__c ='Cancel');
        lstQuoteLine.add(QuoteLine6);*/
        insert lstQuoteLine;
                               //Creating BGR record
        BGR__c bgrRec = new BGR__c();
        bgrRec.Positive_Material_Identification__c = 'CONFIRM';
        bgrRec.Atex__c = 'Y';
        bgrRec.CSA_Markings__c = 'Y';
        bgrRec.Radiography__c = 'CRITICAL';
        bgrRec.GOST_CU_Tr_010_2011__c = 'Y';
        bgrRec.RGEUNT__c = 'psig';
        bgrRec.Quote_Line__c = QuoteLine1.Id;
        insert bgrRec;

        /*Rupture_Disc__c RD = new Rupture_Disc__c();
        RD.Quote_Line__c = QuoteLine2.Id;
        insert RD;
        
        Relief_Valve__c RV = new Relief_Valve__c();
        RV.Quote_Line__c = QuoteLine3.Id;
        insert RV;
        
        Flame_Product__c FP = new Flame_Product__c();
        FP.Quote_Line__c = QuoteLine4.Id;
        insert FP;
        
        WasteGasBurner__c wgb = new WasteGasBurner__c(); 
        wgb.Quote_Line__c = QuoteLine5.Id;
        insert wgb;
        
        Holders__c h = new Holders__c(); 
        h.Quote_Line__c = QuoteLine6.Id;
        insert h;*/
        
        Comment_Log__c oComment = new Comment_Log__c();
        oComment.Quote__c=Quote.Id;
        oComment.Type__c='Eng Review';
        insert oComment;
        
        Charge__c charge= new Charge__c();
        charge.Sent_To_IFS__c=true;
        //charge.Sequence__c=1234;
        charge.Type__c='Shipping';
        charge.Amount__c = 100.0;
        charge.Quantity__c=4;
        charge.Parent_Quote__c  = Quote.Id;
        insert charge;
        
        list<Goals_Performance__c> lstGoalsPerformance = new list<Goals_Performance__c>();
            
        Goals_Performance__c oGoalsPerformance = new Goals_Performance__c();
        oGoalsPerformance.Partner_Org__c = testAcc1.Id;
        oGoalsPerformance.Brands__c = 'LaMot';
        oGoalsPerformance.Fiscal_Year__c = string.valueOf(dtCloseDate.Year());
        oGoalsPerformance.Fiscal_Month__c = string.valueOf(dtCloseDate.Month());
        oGoalsPerformance.Goal__c=4900;
        lstGoalsPerformance.add(oGoalsPerformance);
        
        insert lstGoalsPerformance;
        
        Credits_and_Booking__c oCreditsandBooking = new Credits_and_Booking__c();
        oCreditsandBooking.Type__c='Booking';
        oCreditsandBooking.Quote__c=Quote.Id;
        oCreditsandBooking.Goals_Performance__c=oGoalsPerformance.Id;
        oCreditsandBooking.Created_Date__c=system.today();
        insert oCreditsandBooking;
        
        system.debug('after inserting comment');
        QuoteCommentController.getInfo(Quote.Id,'Eng Review');
        system.debug('after getInfo');
        QuoteCommentController.getComments(Quote.Id,'Eng Review');
        system.debug('after getComments');
        Test.StartTest();
        QuoteCommentController.callPageReference(Quote.Id);
        QuoteCommentController.cloneQuoteLine(lstQuoteLine[0].Id);
        Test.StopTest();
        system.debug('after callPageReference');
        QuoteCommentController.CheckEngApproverUser(Quote.Id);
        system.debug('after CheckEngApproverUser');
        
    }

}