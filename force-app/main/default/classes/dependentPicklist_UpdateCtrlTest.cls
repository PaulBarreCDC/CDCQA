@isTest
public class dependentPicklist_UpdateCtrlTest {
    
    @isTest
    public static void testMethoddependentPicklist_UpdateCtrl() {
        Test.StartTest();   
        dependentPicklist_UpdateCtrl.getDependentMap(new SBQQ__Quote__c(), 'Document_Class__c' , 'Document_Class_Description__c');
        test.stopTest();
    }
}