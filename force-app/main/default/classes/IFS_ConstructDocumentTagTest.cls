@isTest
private class IFS_ConstructDocumentTagTest{     
   static testMethod void generateReq(){
        Test.startTest();
        IFS_TestDataFactory.createTestRecords();    
        ContentVersion contentVersion = [Select Id,Title,FileExtension,Document_Class__c ,FileType FROM contentVersion WHERE Title = 'Penguins' limit 1]; 
        IFS_ConstructDocumentTag.generateReq(new XmlStreamWriter(),contentVersion,'public link');
        Test.stopTest();
    }
}