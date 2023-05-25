@isTest
public class ConfigPartSelectorReferenceCtrlTest {
    
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
        //Service Ticket #205643,29 APR 2021 FOR VALIDATION OF BILLING ADDR ON CUSTOMER ACCOUNT
        testAcc.BillingCity = 'Mumbai';
        testAcc.BillingStreet = 'ABC Street';
        testAcc.BillingCountry = 'India'; 
        insert testAcc;
        
        recordId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        testAcc.RecordtypeId = recordId;        
        Update testAcc;         
        
        Contact testCon = new Contact();
        testCon.LastName = 'TEMCO INC TEST Contact';
        testCon.AccountId = testAcc.Id;
        testCon.Default_Communication_Method__c = 'PHONE';
        insert testCon;     
        
        //Create a Product
        Product2 ProductStandAlone = new Product2(Name = 'Blanket Gas Regulator',ProductCode = 'PS', IsActive = true);         
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
        Part_Selector__c h = new Part_Selector__c(); 
        h.Quote_Line__c = QuoteLine.Id;
        h.ProductGroup__c = 'Replacement Parts';
        h.SubGroup__c = 'Soft Goods';
        h.Product_Attribute_Data__c = '[{"sValue":"6100","sAttributeCode":"PTC"}]';
        insert h;
        
        List<PS_Input_Attr_Value_Desc__c> PSInputAttrValueDescrecords = Test.loadData(PS_Input_Attr_Value_Desc__c.sObjectType, 'PSInputAttrValueDesc');
        
        ApexPages.StandardController sc = new ApexPages.StandardController(h);
        ConfigPartSelectorReferenceCtrl oConfigPartSelectorReferenceCtrl = new ConfigPartSelectorReferenceCtrl(sc);
        
        PageReference pageRef = Page.configPartSelector;
        Test.setCurrentPage(pageRef);
        oConfigPartSelectorReferenceCtrl.getUserTimeZone();
        ConfigPartSelectorReferenceCtrl.ProductAttribueData obj = new ConfigPartSelectorReferenceCtrl.ProductAttribueData();
        ConfigPartSelectorReferenceCtrl.ProductAttribueData obj2 = new ConfigPartSelectorReferenceCtrl.ProductAttribueData('6100' , 'PTC');
        
        //Test.stopTest(); 
        
        
    }
    
}