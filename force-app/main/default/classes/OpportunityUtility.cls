/*
Author Name   : Akhilesh Soni
Class Name    : OpportunityUtility
Created Date  : 16 Apr, 2020
Description   : helper class for opportunity trigger
*/
public class OpportunityUtility {
    
    //fetch Selling Entity and Sourcing Entity based on Brand and User Record for internal user
    public static map<String,map<String,String>> fetchBrandAndUserWiseEntities(set<String> setBrand){
        System.debug('@Developer -->fetchBrandAndUserWiseEntities:');
        System.debug('@Developer --> setBrand :' + setBrand);
        
        map<String,map<String,String>> mapBrandAndUserWiseEnities = new map<String,map<String,String>>();
        for(User usr : [Select Id,Name,
                        CDC_Selling_Entity__c,CDC_Source_Entity__c,
                        Groth_Selling_Entity__c,Groth_Source_Entity__c,
                        LaMot_Selling_Entity__c,LaMot_Source_Entity__c,
                        LVA_Selling_Entity__c,LVA_Source_Entity__c
                        From User 
                        Where Id = :userinfo.getUserId()])
        {
            System.debug('@Developer --> usr :' + usr);
            
            for(String brand : setBrand){
                String key = brand + '-' + usr.Id;
                System.debug('@Developer --> key :' + key);
                
                map<String,String> mapEntityFieldDetail = new map<String,String>();
                
                String sellingEntityKey = brand + '_selling_entity__c';
                System.debug('@Developer --> sellingEntityKey :' + sellingEntityKey);                
                mapEntityFieldDetail.put(sellingEntityKey,(String)usr.get(sellingEntityKey));
                
                String sourceEntityKey = brand + '_source_entity__c';
                System.debug('@Developer --> sourceEntityKey :' + sourceEntityKey);                
                mapEntityFieldDetail.put(sourceEntityKey,(String)usr.get(sourceEntityKey));
                
                System.debug('@Developer --> mapEntityFieldDetail :' + mapEntityFieldDetail);
                mapBrandAndUserWiseEnities.put(key,mapEntityFieldDetail);    
            }
        }
        System.debug('@Developer --> mapBrandAndUserWiseEnities :' + mapBrandAndUserWiseEnities);
        
        return mapBrandAndUserWiseEnities;
    }
    
    //fetch Selling Entity and Sourcing Entity based on Brand and Partner Account for partner user
    public static map<String,map<String,string>> fetchBrandAndPartnerAccountWiseEntities(set<String> setBrand, set<String>setPartnerAccount){
        System.debug('@Developer -->fetchBrandAndPartnerAccountWiseEntities:');
        
        System.debug('@Developer --> setBrand :' + setBrand);
        System.debug('@Developer --> setPartnerAccount :' + setPartnerAccount);
        
        map<String,map<String,String>> mapBrandAndPartnerAccountWiseEntities = new map<String,map<String,String>>();
        
        for(Account acc : [Select Id,Name,
                           CDC_Selling_Entity__c,CDC_Source_Entity__c,
                           Groth_Selling_Entity__c,Groth_Source_Entity__c,
                           LaMot_Selling_Entity__c,LaMot_Source_Entity__c,
                           LVA_Selling_Entity__c,LVA_Source_Entity__c
                           From Account 
                           Where Id In :setPartnerAccount])
        {
			System.debug('@Developer --> acc :' + acc);
            
            for(String brand : setBrand){
            	String key = brand + '-' + acc.Id;
                System.debug('@Developer --> key :' + key);

                map<String,String> mapEntityFieldDetail = new map<String,String>();
                
                String sellingEntityKey = brand + '_selling_entity__c';
                System.debug('@Developer --> sellingEntityKey :' + sellingEntityKey);                
                mapEntityFieldDetail.put(sellingEntityKey,(String)acc.get(sellingEntityKey));
                
                String sourceEntityKey = brand + '_source_entity__c';
                System.debug('@Developer --> sourceEntityKey :' + sourceEntityKey);                
                mapEntityFieldDetail.put(sourceEntityKey,(String)acc.get(sourceEntityKey));
                
                System.debug('@Developer --> mapEntityFieldDetail :' + mapEntityFieldDetail);
            	mapBrandAndPartnerAccountWiseEntities.put(key,mapEntityFieldDetail);    
            }
        }
        System.debug('@Developer --> mapBrandAndPartnerAccountWiseEntities :' + mapBrandAndPartnerAccountWiseEntities);
        
        return mapBrandAndPartnerAccountWiseEntities;        
    }
    
}