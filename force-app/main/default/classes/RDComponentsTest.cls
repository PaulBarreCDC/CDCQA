@isTest
public class RDComponentsTest {
    @testSetup
    public static void dataSetup() {

		TestDataRDUtility.createRDMasterTestRecords();
        //APIDryKs__c[] ls = Test.loadData(APIDryKs__c.sObjectType, 'APIDryKs');
       // ISODryKs__c[] ls1 = Test.loadData(ISODryKs__c.sObjectType, 'ISODryStreamKs');
    }
    @isTest
    public static void testMethod1() {
        //TestDataRDUtility.createRDMasterTestRecords();
        Test.startTest();
        //public RDComponents(String PTC, String SZC,string STC, String DSCVAR,String MCD,decimal BMRCHECK,String WITHSTANDRDCOMP,decimal RTTMDF,decimal pBrustPressure,String isFragmenting,string Atex,string Nace)
        //Service Ticket #205427, parameter added for new field D3ASRV
        RDComponents RDC=new RDComponents('HPZ','0108','NA','A','001',55,55,'Y',72,100,'Y','Yes','Yes',false);
        Map<string,string> mapComponents=RDC.mapComponents;
        Map<string,string> mapComponentsMaterials=RDC.mapComponentsMaterials;
        RDC.checkTypeB('001',55);
        Test.stopTest();

    }
}