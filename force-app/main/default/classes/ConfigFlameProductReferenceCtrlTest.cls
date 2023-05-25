@isTest
public class ConfigFlameProductReferenceCtrlTest {
    
    @isTest
    public static configureFLAMEproduct getconfigFACntrl() {

        Test.startTest();
        
        Map<String, String> mapWithFAValues = new Map<String, String>();
        mapWithFAValues.put('BRAND','Groth');
        mapWithFAValues.put('PRODUCT_CODE','FlameProducts');
        mapWithFAValues.put('PRODUCT_NAME','FlameProducts');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithFAValues);
        
        TestDataFAUtility.quoteLine = quoteLine;
        TestDataFAUtility.mapWithFAValues = mapWithFAValues;
        
        system.debug('TestDataFAUtility.quoteLine:'+TestDataFAUtility.quoteLine);
        system.debug('TestDataFAUtility.mapWithFAValues:'+TestDataFAUtility.mapWithFAValues);
        TestDataFAUtility.createFATestRecords2();
        TestDataFAUtility.createFAMasterTestRecords2();
        
        PageReference pager = Page.ConfigFLAME;
        Test.setCurrentPage(pager);
        
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));
        
        Flame_Product__c conFA = [SELECT Id,Quote_Line__c,Drilling__c,Body_Material__c,Housing_Material__c,Element_Material__c,Pallet_Material__c,
            Diaphragm_Material__c,Pressure_Setting__c,Spring_Range__c,Painting_Coating_Option__c,Inlet_Option_A__c,Inlet_Option_B__c,
            Inlet_Option_C__c,Outlet_Option_A__c,Outlet_Option_B__c,Outlet_Option_C__c,Radiography__c,Liquid_Dye_Penetrant__c,
            Positive_Material_Identification__c,Final_Assembly_Location_Requirements__c,Material_Sourcing_Requirements__c,PTC__c,
            Constrain_Product_Selection_by_Flow__c,Mounting__c,Arrester_for_Detonation_or_Deflagration__c,Gas_Group__c,SZC__c,ESZC__c,Element_Size__c,Size__c FROM Flame_Product__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(conFA);
        
        ConfigFlameProductReferenceCtrl conFlame=new ConfigFlameProductReferenceCtrl(sc);
        
        
        boolean Radiography;
        Radiography=conFlame.Radiography;
        conFlame.getUserTimeZone();
        conFlame.Radiography=true;
        string str='';
        str=conFlame.GPAINT;
        str=conFlame.HCLASS;
        str=conFlame.InletA;
        str=conFlame.InletB;
        str=conFlame.InletC;
        str=conFlame.LDP;
        str=conFlame.MATLSOURCE;
        str=conFlame.MCBODY;
        str=conFlame.MCDPHM;
        str=conFlame.MCELMT;
        str=conFlame.MCHOUS;
        str=conFlame.MCPALL;
        str=conFlame.PMI;
    //    str=conFlame.ReqdGasGroupLevel;
        str=conFlame.SETTING;
        str=conFlame.SPRING;
        str=conFlame.SZC;
        str=conFlame.ESZC;
        str=conFlame.XRAY;
        str=conFlame.OutletA;
        str=conFlame.OutletB;
        str=conFlame.OutletC;
        str=conFlame.ASSYLOCATION;
        conFlame.GPAINT='test';
        conFlame.HCLASS='test';
        conFlame.InletA='test';
        conFlame.InletB='test';
        conFlame.InletC='test';
        conFlame.LDP='test';
        conFlame.MATLSOURCE='test';
        conFlame.MCBODY='test';
        conFlame.MCDPHM='test';
        conFlame.MCELMT='test';
        conFlame.MCHOUS='test';
        conFlame.MCPALL='test';
        conFlame.PMI='test';
        conFlame.ReqdGasGroupLevel='test';
        conFlame.SETTING='test';
        conFlame.SPRING='test';
        conFlame.SZC='test';
        conFlame.ESZC='test';
        conFlame.XRAY='test';
        conFlame.OutletA='test';
        conFlame.OutletB='test';
        conFlame.OutletC='test';
        conFlame.ASSYLOCATION='test';
        
        Test.stopTest();
        
        return new configureFLAMEproduct(sc);
    }
  
    @isTest
    public static configureFLAMEproduct getconfigFACntrl2() {

        Test.startTest();
        
        Map<String, String> mapWithFAValues = new Map<String, String>();
        mapWithFAValues.put('BRAND','Groth');
        mapWithFAValues.put('PRODUCT_CODE','FlameProducts');
        mapWithFAValues.put('PRODUCT_NAME','FlameProducts');
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithFAValues);
        
        TestDataFAUtility.quoteLine = quoteLine;
        TestDataFAUtility.mapWithFAValues = mapWithFAValues;
        
        system.debug('TestDataFAUtility.quoteLine:'+TestDataFAUtility.quoteLine);
        system.debug('TestDataFAUtility.mapWithFAValues:'+TestDataFAUtility.mapWithFAValues);
        TestDataFAUtility.createFATestRecords();
        TestDataFAUtility.createFAMasterTestRecords();
        
        PageReference pager = Page.ConfigFLAME;
        Test.setCurrentPage(pager);
        
        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));
        
        Flame_Product__c conFA = [SELECT Id,Quote_Line__c,Drilling__c,Body_Material__c,Housing_Material__c,Element_Material__c,Pallet_Material__c,
            Diaphragm_Material__c,Pressure_Setting__c,Spring_Range__c,Painting_Coating_Option__c,Inlet_Option_A__c,Inlet_Option_B__c,
            Inlet_Option_C__c,Outlet_Option_A__c,Outlet_Option_B__c,Outlet_Option_C__c,Radiography__c,Liquid_Dye_Penetrant__c,
            Positive_Material_Identification__c,Final_Assembly_Location_Requirements__c,Material_Sourcing_Requirements__c,PTC__c,
            Constrain_Product_Selection_by_Flow__c,Mounting__c,Arrester_for_Detonation_or_Deflagration__c,Gas_Group__c,SZC__c,ESZC__c,Element_Size__c,Size__c FROM Flame_Product__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.StandardController(conFA);
        
        ConfigFlameProductReferenceCtrl conFlame=new ConfigFlameProductReferenceCtrl(sc);

        string str='';
       
        str=conFlame.MCDPHM;
        
        str=conFlame.MCPALL;
        str=conFlame.SETTING;
        str=conFlame.SPRING;
        
        Test.stopTest();
        
        return new configureFLAMEproduct(sc);
    }
    
}