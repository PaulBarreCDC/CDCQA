@isTest
public class GenericUtilityForXMLTest {
    static testMethod void getUtilityInstance(){
         Test.startTest();     
        GenericUtilityForXML gUtil=new GenericUtilityForXML();
        configureBGRProduct cBGRProd=ConfigureBGRControllerTest.getConfigBGRCntrlQ();
        BGR__c conBGR=cBGRProd.conBGR;
        string[] shapeTypes=new List<String>();
        shapeTypes.add('BGR');
        shapeTypes.add('WGB');
        shapeTypes.add('RLFVLV');
        shapeTypes.add('RD');
        shapeTypes.add('HLD');
        shapeTypes.add('PS');
        shapeTypes.add('FlameProducts');
        shapeTypes.add('others');
        for (Integer i = 0; i<shapeTypes.size(); i++) {
            try{
                gUtil.getUtilityInstance(shapeTypes[i],conBGR.Id);
            }catch(Exception e){}
        }       
        Test.stopTest();
    }
}