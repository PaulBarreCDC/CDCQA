@isTest
public class FLMutilityTest {
    
    @isTest
    static void testmethod1() {

        Test.startTest();
        
      //  FLMutility.FLMutility();
        map<string,string> myMap1 =new map<string,string>();
        string str='BGR__c';
        myMap1.put('key',str);
     //   FLMutility.getAllPicklistOptions(myMap1);
        FLMutility.getInstance();
        FLMutility.getObjectFields(str);
        Map<String, Schema.SObjectField> FLMFieldMap;
        FLMFieldMap=FLMutility.getSobjectFieldsMap(Flame_Product__c.SObjectType);
       
        Map<String,String> FLMMasterBMPicklists;
        
        FLMMasterBMPicklists=FLMutility.getPicklistLabelByValue(Flame_Product__c.SObjectType,'Body_Material__c');
            
            
        Test.stopTest();
   }
}