/**
 * @description       : 
 * @author            : ApexIT - SFDC Dev Team
 * @group             : 
 * @last modified on  : 12-07-2020
 * @last modified by  : ApexIT - SFDC Dev Team
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   08-09-2020   ApexIT - SFDC Dev Team            Initial Version
 * 1.1   23-02-2021   Rohini Hathi                      Service Ticket# 163022
**/
public without sharing class CustomQuoteLineItemsLwcController {     
    
    @AuraEnabled
    public static quoteLineResult getQuoteLineData(String quoteId) {
        User userinf = [Select ContactId, Profile.Name,IsPortalEnabled,ProfileId from user where Id=: UserInfo.getUserId()];
        string profileName = userinf.Profile.Name;
        set<string> profilesetstr = new set<string>();
        profilesetstr.add('System Administrator');
        profilesetstr.add('CDC Engineering');
       // profilesetstr.add('CPQ Commerce');
        quoteLineResult oQuoteLineResult = new quoteLineResult();
        List<quoteLineWrapper> quoteLineList = new list<quoteLineWrapper>();
        for (SBQQ__QuoteLine__c q: [SELECT Id,Name,SBQQ__Number__c,Line_Status__c,Product_Name__c,SBQQ__ProductCode__c ,Engineering_Status__c,Product_Planning_Status__c, Requires_Technical_Review__c,
	   Drawings_Status__c, Expiration_Date__c,Customer_Leadtime__c, Leadtime__c, Discount_Amount__c, Discount__c,Non_Discountable_List_Price__c, Production_Planning_Leadtime__c,
       Discountable_List_Price__c, SBQQ__Quantity__c, Total_List_Price_Cust_Curr__c, Customer_Currency__c, Regular_Total_Price_Cust_Curr__c, Net_Price_Each_Cust_Curr__c, Change_Order_Status__c, //Service Ticket # 163022
	   (SELECT Id,Name,Discountable_Price__c,Non_Discountable_Price__c,Size__c,Part_Number__c,Quote_Description_Engineer_Override__c From BGR__r),
	   (SELECT Id,Name,Discountable_Price__c,Non_Discountable_Price__c,Size__c,Part_Number__c,Quote_Descriptions_Override__c From Rupture_Discs__r),
	   (SELECT Id,Name,Discountable_Price__c,Non_Discountable_Price__c,Size__c,Part_Number__c,Quote_Description_Engineer_Override__c From Relief_Valves__r),
	   (SELECT Id,Name,Discountable_Price__c,Non_Discountable_Price__c,Size__c,Part_Number__c,Quote_Description_Engineer_Override__c From Flame_Products__r),
	   (SELECT Id,Name,Discountable_Price__c,Non_Discountable_Price__c,Size__c,Part_Number__c,Quote_Descriptions_Override__c From Holders__r),
	   (SELECT Id,Name,Discountable_Price__c,Non_Discountable_Price__c,Size__c,Part_Number__c,Quote_Description_Engineer_Override__c From WasteGasBurners__r),
	   (SELECT Id,Name,Discountable_Price__c,Non_Discountable_Price__c,Size__c,Part_Number__c,Quote_Description_Engineer_Override__c From Part_Selectors__r) 
       FROM SBQQ__QuoteLine__c  
       WHERE SBQQ__Quote__c = :quoteId order by SBQQ__Number__c ASC]) {
           //list<SObject> pdRec = Database.query(query);
		   
		    if(q.SBQQ__ProductCode__c=='BGR'){
               if(q.BGR__r != null && q.BGR__r.size() > 0){
                 quoteLineWrapper ab = new quoteLineWrapper (q,q.BGR__r[0],userinf);
                 ab.disableLineItem = true;
                 if(profilesetstr.contains(profileName)){
                    ab.disableLineItem = false;
                 }else{
                    if(!(q.BGR__r[0].Quote_Description_Engineer_Override__c))
                    ab.disableLineItem = false;
                 }
                 quoteLineList.add(ab);
               } 
            }
            else if (q.SBQQ__ProductCode__c=='RD'){
               if(q.Rupture_Discs__r != null && q.Rupture_Discs__r.size() > 0){
                 quoteLineWrapper ab = new quoteLineWrapper (q,q.Rupture_Discs__r[0],userinf);
                 ab.disableLineItem = true;
                 if(profilesetstr.contains(profileName)){
                    ab.disableLineItem = false;
                 }else{
                    if(!(q.Rupture_Discs__r[0].Quote_Descriptions_Override__c))
                    ab.disableLineItem = false;
                 }
                 quoteLineList.add(ab);
               }
            }
            else if(q.SBQQ__ProductCode__c=='RLFVLV'){
               if(q.Relief_Valves__r != null && q.Relief_Valves__r.size() > 0){
                 quoteLineWrapper ab = new quoteLineWrapper (q,q.Relief_Valves__r[0],userinf);
                 ab.disableLineItem = true;
                 if(profilesetstr.contains(profileName)){
                    ab.disableLineItem = false;
                 }else{
                    if(!(q.Relief_Valves__r[0].Quote_Description_Engineer_Override__c))
                    ab.disableLineItem = false;
                 }
                 quoteLineList.add(ab);
               }
            }
            else if(q.SBQQ__ProductCode__c=='FlameProducts'){
                if(q.Flame_Products__r != null && q.Flame_Products__r.size() > 0){
                 quoteLineWrapper ab = new quoteLineWrapper (q,q.Flame_Products__r[0],userinf);
                 ab.disableLineItem = true;
                 if(profilesetstr.contains(profileName)){
                    ab.disableLineItem = false;
                 }else{
                    if(!(q.Flame_Products__r[0].Quote_Description_Engineer_Override__c))
                    ab.disableLineItem = false;
                 }
                 quoteLineList.add(ab);
               }
            }
            else if(q.SBQQ__ProductCode__c=='HLD'){
              if(q.Holders__r != null && q.Holders__r.size() > 0){
                 quoteLineWrapper ab = new quoteLineWrapper (q,q.Holders__r[0],userinf);
                 ab.disableLineItem = true;
                 if(profilesetstr.contains(profileName)){
                    ab.disableLineItem = false;
                 }else{
                    if(!(q.Holders__r[0].Quote_Descriptions_Override__c))
                    ab.disableLineItem = false;
                 }
                 quoteLineList.add(ab);
               } 
            }
            else if(q.SBQQ__ProductCode__c=='WGB'){
                if(q.WasteGasBurners__r != null && q.WasteGasBurners__r.size() > 0){
                 quoteLineWrapper ab = new quoteLineWrapper (q,q.WasteGasBurners__r[0],userinf);
                 ab.disableLineItem = true;
                 if(profilesetstr.contains(profileName)){
                    ab.disableLineItem = false;
                 }else{
                    if(!(q.WasteGasBurners__r[0].Quote_Description_Engineer_Override__c))
                    ab.disableLineItem = false;
                 }
                 quoteLineList.add(ab);
               } 
            }
            else if(q.SBQQ__ProductCode__c=='PS'){
                  if(q.Part_Selectors__r != null && q.Part_Selectors__r.size() > 0){
                 quoteLineWrapper ab = new quoteLineWrapper (q,q.Part_Selectors__r[0],userinf);
                 ab.disableLineItem = true;
                 if(profilesetstr.contains(profileName)){
                    ab.disableLineItem = false;
                 }else{
                    if(!(q.Part_Selectors__r[0].Quote_Description_Engineer_Override__c))
                    ab.disableLineItem = false;
                 }
                 quoteLineList.add(ab);
               }    
            }    
                
          }
       
        
        List<Quote_Line_Action__mdt> lstQLAMetaData =  new List<Quote_Line_Action__mdt>();
       
        Profile oProfile = [Select Id,Name From Profile WHERE ID =: userinf.ProfileId];

        for(Quote_Line_Action__mdt qla : [SELECT Id, Label, Action_Name__c, Order__c, Active__c,
                                         (Select Id,Quote_Line_Action__c,Field_API__c,Active__c,readOnly__c,Order__c From Quote_Line_Action_Details__r WHERE Active__c = true),
                                         (Select Id,Quote_Line_Action__c,Profile__c,Active__c From Quote_Line_Action_Permissions__r WHERE Active__c = true AND Profile__c IN ('All' , :oProfile.Name))
                                         FROM Quote_Line_Action__mdt WHERE Active__c = true Order by Order__c ASC]){
            system.debug('qla===> ' + qla.Quote_Line_Action_Permissions__r);
            system.debug('oProfile.Name===> ' + oProfile.Name);
            for(Quote_Line_Action_Permission__mdt qlap : qla.Quote_Line_Action_Permissions__r){
               
                lstQLAMetaData.add(qla);
               
            }
        }
        oQuoteLineResult.qlLineList = quoteLineList;
        oQuoteLineResult.lstQlaMDT = lstQLAMetaData;
        return oQuoteLineResult;
    }
    
    public class quoteLineResult{
        @AuraEnabled public List<quoteLineWrapper> qlLineList{get;set;}
        @AuraEnabled public List<Quote_Line_Action__mdt> lstQlaMDT{get;set;}
    }

    public class quoteLineWrapper {
        
        @AuraEnabled public SBQQ__QuoteLine__c ql {set;get;}
        @AuraEnabled public SObject rD {set;get;}
        @AuraEnabled public String productName {set;get;}
        @AuraEnabled public String productRefName {set;get;}
        @AuraEnabled public String Outputname {set;get;}
        @AuraEnabled public String quoteName {set;get;}
        @AuraEnabled public String quoteURL {set;get;}
        @AuraEnabled public String productURL {set;get;}
        @AuraEnabled public String productRefURL {set;get;}
        @AuraEnabled public String OutputURL {set;get;}
        @AuraEnabled public String ProdCode {set;get;}
        @AuraEnabled public String quoteLineURL {set;get;}
        @AuraEnabled public String engStatus {set;get;}
        @AuraEnabled public String ppStatus {set;get;}
        @AuraEnabled public Boolean disableLineItem {set;get;}

        
        public quoteLineWrapper(SBQQ__QuoteLine__c p,SObject rD, User userinf) {
            this.ql = p;
            this.rD=rD;    
           

            if(userinf.IsPortalEnabled){
                if(ql.SBQQ__ProductCode__c=='BGR'){
                    String url = '/apex/ConfigBGR?qid='+ql.Id;
                    String encoded = '/s/sfdcpage/' + EncodingUtil.urlEncode(url, 'UTF-8');
                    this.OutputURL = encoded;
                }
                else if (ql.SBQQ__ProductCode__c=='WGB'){
                    String url = '/apex/ConfigWGBProduct?qid='+ql.Id;
                    String encoded = '/s/sfdcpage/' + EncodingUtil.urlEncode(url, 'UTF-8');
                    this.OutputURL = encoded;
                }
                else if (ql.SBQQ__ProductCode__c=='RD'){
                    String url = '/apex/ConfigRD?qid='+ql.Id;
                    String encoded = '/s/sfdcpage/' + EncodingUtil.urlEncode(url, 'UTF-8');
                    this.OutputURL = encoded;
                }
                else if (ql.SBQQ__ProductCode__c=='PS'){
                    String url = '/apex/ConfigPartSelector?id='+rD.Id;
                    String encoded = '/s/sfdcpage/' + EncodingUtil.urlEncode(url, 'UTF-8');
                    this.OutputURL = encoded;
                } 
                else if (ql.SBQQ__ProductCode__c=='FlameProducts'){
                    String url = '/apex/ConfigFLAME?qid='+ql.Id;
                    String encoded = '/s/sfdcpage/' + EncodingUtil.urlEncode(url, 'UTF-8');
                    this.OutputURL = encoded;
                }
                else if (ql.SBQQ__ProductCode__c=='HLD'){
                    String url = '/apex/ConfigHoldersOutputs?qid='+ql.Id;
                    String encoded = '/s/sfdcpage/' + EncodingUtil.urlEncode(url, 'UTF-8');
                    this.OutputURL = encoded;
                }
                else if(ql.SBQQ__ProductCode__c=='RLFVLV'){
                    String url = '/apex/RVConfig?qid='+ql.Id;
                    String encoded = '/s/sfdcpage/' + EncodingUtil.urlEncode(url, 'UTF-8');
                    this.OutputURL = encoded;
                }
                else{
                    this.OutputURL = quoteURL;
                } 
            }
            else{
                if(ql.SBQQ__ProductCode__c=='BGR')
                    this.OutputURL = '/apex/ConfigBGR?qid='+ql.Id;
                else if (ql.SBQQ__ProductCode__c=='WGB')
                    this.OutputURL = '/apex/ConfigWGBProduct?qid='+ql.Id;
                else if (ql.SBQQ__ProductCode__c=='RD')
                    this.OutputURL = '/apex/ConfigRD?qid='+ql.Id;
                else if (ql.SBQQ__ProductCode__c=='PS')
                    this.OutputURL = '/apex/ConfigPartSelector?id='+rD.Id;
                else if(ql.SBQQ__ProductCode__c=='FlameProducts')
                    this.OutputURL = '/apex/ConfigFLAME?qid='+ql.Id;
                else if(ql.SBQQ__ProductCode__c=='HLD')
                        this.OutputURL = '/apex/ConfigHoldersOutputs?qid='+ql.Id;
                else if(ql.SBQQ__ProductCode__c=='RLFVLV')
                    this.OutputURL = '/apex/RVConfig?qid='+ql.Id;
                else 
                    this.OutputURL = quoteURL;
            }
            
        }
    }

    /* @AuraEnabled
     public static List<SBQQ__QuoteLine__c> getQuoteLineData(String quoteId) {
         return [SELECT Id,Product_Name__c,SBQQ__ProductCode__c ,Engineering_Status__c, Requires_Technical_Review__c, Drawings_Status__c, Expiration_Date__c, 
                Customer_Leadtime__c, Leadtime__c, Discount_Amount__c, Discount__c, Non_Discountable_List_Price__c,
                 Discountable_List_Price__c, SBQQ__Quantity__c 
                 FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :quoteId];
     }*/

     @AuraEnabled
     public static void saveQuoteLine(SBQQ__QuoteLine__c ql) {
         try{
            update ql;
         }
         catch(DmlException ex ){
            throw new AuraHandledException(ex.getDmlMessage(0));
         }
          
     }



     
}