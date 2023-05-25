/**
 * @description       : 
 * @author            : ApexIT - SFDC Dev Team
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : ApexIT - SFDC Dev Team
 * Modifications Log 
 * Ver   Date         Author                         Modification
 * 1.0   11-02-2020   ApexIT - SFDC Dev Team         Initial Version
 * 1.1    19-07-2021   Sonam Meshram                  Service Ticket #205643 - Testcases are failing with Duplicate account getting created in testsetup. 
**/
@isTest 
private class TagTriggerTest{
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
        testAcc.Rep_Code_Account__c = testAcc1.Id;  
        insert testAcc;
        
        recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        testAcc.RecordtypeId = recordId; 
        //Service Ticket #205643, SET BILLING ADDRESS
        testAcc.BillingCountryCode ='US';
        testAcc.BillingStreet ='Albama';
        testAcc.BillingCity ='test city';
        testAcc.BillingStateCode ='FL';
        testAcc.BillingPostalCode ='32137';
        Update testAcc;         
            
        Account testAcc2 = new Account();
        testAcc2.Name = 'TEMCO INC TEST2';
        insert testAcc2;
        testAcc2.RecordtypeId = recordId;
        testAcc2.Rep_Code_Account__c    = testAcc1.Id; 
        //Service Ticket #205643, SET BILLING ADDRESS
        testAcc2.BillingCountryCode ='US';
        testAcc2.BillingStreet ='Albama';
        testAcc2.BillingCity ='test city';
        testAcc2.BillingStateCode ='FL';
        testAcc2.BillingPostalCode ='32137';
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
            
        SBQQ__QuoteLine__c QuoteLine = new SBQQ__QuoteLine__c
            (
                SBQQ__Quote__c = Quote.Id,
                SBQQ__Product__c = ProductStandAlone.Id,
                Line_Status__c ='Cancel'                
            );
            
        insert QuoteLine;
        string sRecordTypeId;
        for(RecordType oRecType:[select id,name,developername from recordtype where sobjecttype='tag__c' and developername='Tag_All']){
            sRecordTypeId = oRecType.Id;
        }           
        Tag__c oTag = new Tag__c();    
        oTag.RecordtypeId = sRecordTypeId;
        oTag.Misc_Tagging_Instructions__c = 'DISC TAG TO BE PLASTIC COATED PER MP-1201';
        oTag.Box_Label__c = 'MADE IN USA';
        oTag.Tag_Number_01__c = '50222463, PSE70001';
        oTag.Tag_Number_02__c = '50225688, PSE7111';
        oTag.Quote_Line__c = QuoteLine.Id;
        insert oTag;
        
        delete oTag;
        System.assert([SELECT Id, Tag_Number__c FROM SBQQ__QuoteLine__c WHERE Id = :QuoteLine.Id][0].Tag_Number__c == null);
               
    }
    
    
    
}