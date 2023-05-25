/**
 * @description       : 
 * @author            : ApexIT - SFDC Dev Team
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : ApexIT - SFDC Dev Team
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   08-09-2020   ApexIT - SFDC Dev Team   Initial Version
**/
public with sharing class MappingUtil {
    public static Map<String,String> quoteOpptyLookupFieldMap = new Map<String,String> {
        'SBQQ__Opportunity2__r.AccountId' => 'SBQQ__Account__c',
        'SBQQ__Opportunity2__r.Account.BillingCity' => 'SBQQ__BillingCity__c',
        'SBQQ__Opportunity2__r.Account.BillingCountry' => 'SBQQ__BillingCountry__c',
        'SBQQ__Opportunity2__r.Account.BillingPostalCode' => 'SBQQ__BillingPostalCode__c',
        'SBQQ__Opportunity2__r.Account.BillingState' => 'SBQQ__BillingState__c',
        'SBQQ__Opportunity2__r.Account.BillingStreet' => 'SBQQ__BillingStreet__c',
        'SBQQ__Opportunity2__r.Account.External_ID__c' => 'Billing_Address_Id__c',
        'SBQQ__Opportunity2__r.Account.Credit_Limit__c' => 'Credit_Limit__c',
        'SBQQ__Opportunity2__r.Account.Name' => 'SBQQ__BillingName__c',
        'SBQQ__Opportunity2__r.Account.Payment_Terms__c' => 'SBQQ__PaymentTerms__c',
        'SBQQ__Opportunity2__r.Account.RecordType.Name' => 'Customer_Stat_Group__c',
        'SBQQ__Opportunity2__r.End_Use__c' => 'End_Use__c',
        'SBQQ__Opportunity2__r.End_User__c' => 'End_User__c',
        'SBQQ__Opportunity2__r.End_User__r.BillingCity' => 'End_User_City__c',
        'SBQQ__Opportunity2__r.End_User__r.BillingCountry' => 'End_User_Country__c',
        'SBQQ__Opportunity2__r.End_User__r.BillingPostalCode' => 'End_User_PostalCode__c',
        'SBQQ__Opportunity2__r.End_User__r.BillingState' => 'End_User_State__c',
        'SBQQ__Opportunity2__r.End_User__r.BillingStreet' => 'End_User_Street__c',
        'SBQQ__Opportunity2__r.End_User__r.Name' => 'End_User_Name__c',
        'SBQQ__Opportunity2__r.Shipping_Account__c' => 'Shipping_Account__c',
        'SBQQ__Opportunity2__r.Shipping_Account__r.BillingCity' => 'SBQQ__ShippingCity__c',
        'SBQQ__Opportunity2__r.Shipping_Account__r.BillingCountry' => 'SBQQ__ShippingCountry__c',
        'SBQQ__Opportunity2__r.Shipping_Account__r.BillingPostalCode' => 'SBQQ__ShippingPostalCode__c',
        'SBQQ__Opportunity2__r.Shipping_Account__r.BillingState' => 'SBQQ__ShippingState__c',
        'SBQQ__Opportunity2__r.Shipping_Account__r.BillingStreet' => 'SBQQ__ShippingStreet__c',
        'SBQQ__Opportunity2__r.Shipping_Account__r.Name' => 'SBQQ__ShippingName__c',
        'SBQQ__Opportunity2__r.Shipping_Account__r.District__c' => 'Delivery_District__c',
        'SBQQ__Opportunity2__r.Shipping_Account__r.Market__c' => 'Delivery_Market__c',
        'SBQQ__Opportunity2__r.Shipping_Account__r.Region__c' => 'Delivery_Region__c',
        'SBQQ__Opportunity2__r.Contact__c' => 'Customer_Contact__c',
        'SBQQ__Opportunity2__r.Customer_Currency__c' => 'Currency__c',
        'SBQQ__Opportunity2__r.Partner_Rep_Code__c' => 'Rep_Code__c',
        'SBQQ__Opportunity2__r.Rep_Code_District__c' => 'Ordering_District__c',
        'SBQQ__Opportunity2__r.Rep_Code_Region__c' => 'Ordering_Region__c',
        'SBQQ__Opportunity2__r.Sales_Division__c' => 'Sales_Division__c',
        'SBQQ__Opportunity2__r.Salesperson__c' => 'SBQQ__SalesRep__c',
        'SBQQ__Opportunity2__r.Salesperson__c' => 'Project_Coordinator__c',
        'SBQQ__Opportunity2__r.Sourcing_Entity__c' => 'Sourcing_Entity__c',
        'SBQQ__Opportunity2__r.PartnerAccountId' => 'Sold_By_Rep__c',
        'SBQQ__Opportunity2__r.End_User__r.Rep_Code_Account__c' => 'Destination_Rep__c'
    };
    public static void ForValidationPurposesUponFieldChangeOnly(){
        SBQQ__Quote__c dnu = [
            SELECT SBQQ__Account__c,SBQQ__BillingCity__c,SBQQ__BillingCountry__c,SBQQ__BillingPostalCode__c,
                SBQQ__BillingState__c,SBQQ__BillingStreet__c,Billing_Address_Id__c,Credit_Limit__c,SBQQ__BillingName__c,
                SBQQ__PaymentTerms__c,Customer_Stat_Group__c,End_Use__c,End_User__c,End_User_City__c,End_User_Country__c,
                End_User_PostalCode__c,End_User_State__c,End_User_Street__c,End_User_Name__c,Shipping_Account__c,
                SBQQ__ShippingCity__c,SBQQ__ShippingCountry__c,SBQQ__ShippingPostalCode__c,SBQQ__ShippingState__c,
                SBQQ__ShippingStreet__c,SBQQ__ShippingName__c,Delivery_District__c,Delivery_Market__c,Delivery_Region__c,
                Customer_Contact__c,Currency__c,Rep_Code__c,Ordering_District__c,Ordering_Region__c,Sales_Division__c,
                SBQQ__SalesRep__c,Project_Coordinator__c,Sourcing_Entity__c
            FROM SBQQ__Quote__c];
    }
    public static Map<String,String> quoteFieldMap {
        get {
            Map<String,String> quoteFieldMap = new Map<String,String>();
            quoteFieldMap.putAll(quoteOpptyLookupFieldMap);
            return quoteFieldMap;
        }
        set;
    }

    public static Set<String> houseRepCodes = new Set<String> {
        'DOE1',
        'DOE2',
        'DDH1',
        'DNIH',
        'LOE1',
        'DOE3'        
    };
    
    // String[Quote Line Product Code Field Value] => Map<String[Config Field Name],String[Quote Line Field Name]
    public static Map<String,Map<String,String>> engApproverFields = new Map<String,Map<String,String>>{
        'WGB' => new Map<String,String>{
            'Price_Engineer_Override__c' => 'Price_Overridden__c',
            'Cost_Override__c' => 'Cost_Overridden__c',
            'Engineering_Override__c' => 'Engineering_Overridden__c',
            'Quote_Description_Engineer_Override__c' => 'Description_Overridden__c'
        },
        'BGR' => new Map<String,String>{
            'Price_Engineer_Override__c' => 'Price_Overridden__c',
            'Build_Cost_Override__c' => 'Cost_Overridden__c',
            'Engineering_Override__c' => 'Engineering_Overridden__c',
            'Quote_Description_Engineer_Override__c' => 'Description_Overridden__c'
        } 
    };
    public static void mapFieldsToObj(sObject src, sObject trg, Map<String,String> fieldMap) {
        for(String fld : fieldMap.keySet()) {
            try {
                trg.put(fieldMap.get(fld), src.get(fld));
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
        }
    }
    
    public static Map<String,String> brandDefaultSourcingEntityMap = new Map<String,String> {
      'CDC' => '10',
      'LAMOT' => '10',
      'GROTH' => '20',
      'LVA' => '20'
    };
    /**
    *  Product Code To sObject Name
    **/
    public static Map<String,String> productCodeSObjNameMap = new Map<String,String> {
        'BGR' => 'BGR__c',
        'RD' => 'Rupture_Disc__c',
        'RLFVLV' => 'Relief_Valve__c',
        'FlameProducts' => 'Flame_Product__c',
        'HLD' => 'Holders__c',
        'WGB' => 'WasteGasBurner__c'
    };
    public static Id getConfigSObjectIDFromQuoteLine(SBQQ__QuoteLine__c quoteLine) {
        try {       
            if(NULL != productCodeSObjNameMap.get(quoteLine.SBQQ__ProductCode__c)) {   
                List<sObject> configItem = Database.query(
                    'SELECT Id FROM ' + productCodeSObjNameMap.get(quoteLine.SBQQ__ProductCode__c) + ' WHERE Quote_Line__c=\'' + quoteLine.Id + '\' LIMIT 1'
                );
                if(NULL != configItem && configItem.size() > 0 )
                    return configItem.get(0).Id;
            }
        } catch(DMLException dme) {
            System.debug(dme.getMessage());
        }
        return null;
    }
    public static DiscThresholds getThresholds(String brand, String repCode) {
      if(brandRepCodeDiscThresholds.containsKey(brand + repCode)) {
        return brandRepCodeDiscThresholds.get(brand + repCode);
      } else if(brandRepCodeDiscThresholds.containsKey(brand)) {
        return brandRepCodeDiscThresholds.get(brand);
      } else {
        return brandRepCodeDiscThresholds.get('DEFAULT');
      }
    }
  
    //  Selects Based Off Of Brand + RepCode
    public static Map<String, DiscThresholds> brandRepCodeDiscThresholds = new Map<String, DiscThresholds> {
      'DEFAULT' => new DiscThresholds(20,40,50),// Default value
      'CDCD01' => new DiscThresholds(20,40,50), // Example value of brand + repCode as key
      'CDC' => new DiscThresholds(20,40,50)     // Example value of brand as key
    };
  
    public class DiscThresholds {
      public Decimal insideSales {get;set;}
      public Decimal director {get;set;}
      public Decimal salesExec {get;set;}
  
      public DiscThresholds(
        Decimal insideSales,  
        Decimal director,
        Decimal salesExec) {
          this.insideSales = insideSales;
          this.director = director;
          this.salesExec = salesExec;
      }
    }
}