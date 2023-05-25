@isTest
public class BlanketGasRegulatorControllerTest {
	
    @testSetup
    public static void dataSetup() {
        
        Map<String, String> mapWithBGRValues = new Map<String, String>();
        mapWithBGRValues.put('BRAND','Groth');
        mapWithBGRValues.put('PRODUCT_CODE','BGR');
        mapWithBGRValues.put('PRODUCT_NAME','BlanketGasRegulator'); 
        
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithBGRValues);       
        TestDataBGRUtility.quoteLine = quoteLine;
        TestDataBGRUtility.mapWithBGRValues = mapWithBGRValues;       
        TestDataBGRUtility.createBGRTestRecords();
        TestDataBGRUtility.createBGRMasterTestRecords();               
    }
    
    @isTest
    public static void genericCoverage() {
        
        Test.startTest();
        BGR__c conBGR = [SELECT Assembly_Matetrial_Cost__c,Assembly_Outside_Cost__c,Assembly_Price__c,Assembly_Run_Cost__c,Assembly_Setup_Cost__c,ASSYPARTEXISTING__c,ASSYPARTNOBASE__c,Atex__c,Atmospheric_Pressure_Units__c,Atmospheric_Pressure__c,Body_Material_dynamic__c,Body_Material__c,Brand__c,Build_Cost_Override__c,Bypass__c,Certifications_flag__c,Combo_Orifice_Setting__c,Compressibility_Factor__c,Configuration_Complete__c,Connection_dynamic__c,Connection__c,Converted_Atmospheric_Pressure__c,Converted_Flow_Capacity__c,Converted_Setting__c,Converted_Supply_Gas_Temperature__c,Converted_Supply_Pressure__c,CSA_Markings__c,Customer_Specified_Media__c,Discountable_Price__c,Document_IDs__c,Document_ID__c,Document_Or_Sourcing_flag__c,Engineering_Notes__c,Engineering_Override__c,Final_Assembly_Location_Requirements__c,Flow_Rate_units__c,Flow_Units__c,GOST_CU_Tr_010_2011__c,Id,IsReOrder__c,KD__c,Lead_Time_Adder__c,Lead_Time_Engineer_Override__c,Lead_Time_Site_10__c,Lead_Time_Site_20__c,Lead_Time_Site_30__c,Lead_Time_Site_40__c,List_Price_Each__c,Material_Sourcing_Requirements__c,Minimum_Required_Flow_Capacity__c,Model__c,Molecular_Weight__c,Name,Narrow_selection_on_flow_requirements__c,Non_Discountable_Price__c,OA01__c,OA02__c,OA04__c,OA__c,OB010__c,OB050__c,OB115__c,OB120__c,OB130__c,OB170__c,OB250__c,OB270__c,OB310__c,OB320__c,OB410__c,OB420__c,OB__c,Orifice_backend__c,Orifice_Setting__c,Orifice_value__c,OW210__c,OW220__c,OW310__c,OW410__c,OW610__c,OW620__c,OW630__c,OW710__c,OW720__c,OW910__c,OW920__c,OwnerId,OW__c,PartNumberBase_Checkbox__c,PARTREV__c,Part_Number_Base_Original__c,Part_Number_Base__c,Part_Number__c,Positive_Material_Identification__c,PresRatio__c,Pressure_Units__c,Price_Each__c,Price_Engineer_Override__c,Product_material_options_flag__c,Product_selection_flag__c,Quantity__c,Quote_Description_Engineer_Override__c,Quote_Line__c,Radiography__c,Ratio_of_Specific_Heats__c,Relief_flag__c,RGEUNT__c,Schedule_2__c,Schedule__c,Section_B_flag__c,Service_Type__c,Setting_Units__c,Setting__c,Shell_Test_Valve_Body__c,Shell_test__c,Single_model_based_on_above_input__c,Size_Backend__c,Size__c,Soft_Goods_Material_dynamic__c,Soft_Goods_Material__c,SPRINGCODE__c,Supply_Gas_Temperature_Units__c,Supply_Gas_Temperature__c,Supply_Gas__c,Supply_Pressure_Units__c,Supply_Pressure__c,Temperature_Units__c,Valve_Examination_Flag__c
                         FROM BGR__c LIMIT 1];
        SBQQ__QuoteLine__c ql = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        SBQQ__Quote__c qt = [SELECT Id FROM SBQQ__Quote__c LIMIT 1];
        
        BlanketGasRegulatorController obj = new BlanketGasRegulatorController();
        
        BlanketGasRegulatorController.cleanSecB(conBGR);
        BlanketGasRegulatorController.cleanSecC(conBGR);
        BlanketGasRegulatorController.cleanSecD(conBGR);
        BlanketGasRegulatorController.cleanSecE(conBGR);
        BlanketGasRegulatorController.cleanSecF(conBGR);
        BlanketGasRegulatorController.cleanSecG(conBGR);
        BlanketGasRegulatorController.handleNarrowSelection(conBGR);
        BlanketGasRegulatorController.SupplyGas(conBGR);
        BlanketGasRegulatorController.showSectionB(conBGR);
        
        BlanketGasRegulatorController.fetchFormAccessibility(ql.Id);
        
        BlanketGasRegulatorController.saveRelief(conBGR);
        BlanketGasRegulatorController.saveCertificate(conBGR, ql.Id);
        BlanketGasRegulatorController.saveProductSelection(conBGR);
        BlanketGasRegulatorController.getBodyMaterial(conBGR);
        BlanketGasRegulatorController.saveProductMaterials(conBGR);
        BlanketGasRegulatorController.saveValveExamination(conBGR);
        BlanketGasRegulatorController.saveDocSourcing(conBGR, qt.Id);
        BlanketGasRegulatorController.getPartNum(conBGR);
        BlanketGasRegulatorController.fetchUserInfo();
        
        Map<Double, String> orificeSettingVals = new Map<Double, String>();
        orificeSettingVals.put(1, 'Test');
        BlanketGasRegulatorController.sortOrificeVals(orificeSettingVals);
        
        BlanketGasRegulatorController.getBodyMaterial(conBGR);
        
        BlanketGasRegulatorController.SelectOption opt = new BlanketGasRegulatorController.SelectOption('Test', 'Test');
        
        Test.stopTest();
    }
        
    @isTest
    public static void testSaveCertificate() {
        
        Test.startTest();
        BGR__c conBGR = [SELECT Assembly_Matetrial_Cost__c,Assembly_Outside_Cost__c,Assembly_Price__c,Assembly_Run_Cost__c,Assembly_Setup_Cost__c,ASSYPARTEXISTING__c,ASSYPARTNOBASE__c,Atex__c,Atmospheric_Pressure_Units__c,Atmospheric_Pressure__c,Body_Material_dynamic__c,Body_Material__c,Brand__c,Build_Cost_Override__c,Bypass__c,Certifications_flag__c,Combo_Orifice_Setting__c,Compressibility_Factor__c,Configuration_Complete__c,Connection_dynamic__c,Connection__c,Converted_Atmospheric_Pressure__c,Converted_Flow_Capacity__c,Converted_Setting__c,Converted_Supply_Gas_Temperature__c,Converted_Supply_Pressure__c,CSA_Markings__c,Customer_Specified_Media__c,Discountable_Price__c,Document_IDs__c,Document_ID__c,Document_Or_Sourcing_flag__c,Engineering_Notes__c,Engineering_Override__c,Final_Assembly_Location_Requirements__c,Flow_Rate_units__c,Flow_Units__c,GOST_CU_Tr_010_2011__c,Id,IsReOrder__c,KD__c,Lead_Time_Adder__c,Lead_Time_Engineer_Override__c,Lead_Time_Site_10__c,Lead_Time_Site_20__c,Lead_Time_Site_30__c,Lead_Time_Site_40__c,List_Price_Each__c,Material_Sourcing_Requirements__c,Minimum_Required_Flow_Capacity__c,Model__c,Molecular_Weight__c,Name,Narrow_selection_on_flow_requirements__c,Non_Discountable_Price__c,OA01__c,OA02__c,OA04__c,OA__c,OB010__c,OB050__c,OB115__c,OB120__c,OB130__c,OB170__c,OB250__c,OB270__c,OB310__c,OB320__c,OB410__c,OB420__c,OB__c,Orifice_backend__c,Orifice_Setting__c,Orifice_value__c,OW210__c,OW220__c,OW310__c,OW410__c,OW610__c,OW620__c,OW630__c,OW710__c,OW720__c,OW910__c,OW920__c,OwnerId,OW__c,PartNumberBase_Checkbox__c,PARTREV__c,Part_Number_Base_Original__c,Part_Number_Base__c,Part_Number__c,Positive_Material_Identification__c,PresRatio__c,Pressure_Units__c,Price_Each__c,Price_Engineer_Override__c,Product_material_options_flag__c,Product_selection_flag__c,Quantity__c,Quote_Description_Engineer_Override__c,Quote_Line__c,Radiography__c,Ratio_of_Specific_Heats__c,Relief_flag__c,RGEUNT__c,Schedule_2__c,Schedule__c,Section_B_flag__c,Service_Type__c,Setting_Units__c,Setting__c,Shell_Test_Valve_Body__c,Shell_test__c,Single_model_based_on_above_input__c,Size_Backend__c,Size__c,Soft_Goods_Material_dynamic__c,Soft_Goods_Material__c,SPRINGCODE__c,Supply_Gas_Temperature_Units__c,Supply_Gas_Temperature__c,Supply_Gas__c,Supply_Pressure_Units__c,Supply_Pressure__c,Temperature_Units__c,Valve_Examination_Flag__c
                         FROM BGR__c LIMIT 1];
        
        conBGR.Narrow_selection_on_flow_requirements__c = true;
        conBGR.PresRatio__c = 1;
        conBGR.Ratio_of_Specific_Heats__c = 2;
        conBGR.Converted_Flow_Capacity__c = 1;
        conBGR.Supply_Gas__c = 'Nitrogen';
        update conBGR;
        
        BGR_Media_Properties__c med = new BGR_Media_Properties__c();
        med.Media__c = 'Nitrogen';
        med.MediaPhase__c = 'Gas/Vapor	';
        med.MolecularWeight__c = 28.013;
        med.SpecificHeatRatio__c = 1.41;
        med.Density__c = 50.396;
        med.CompressFactor__c = 1.0;
        insert med;
        
        SBQQ__QuoteLine__c ql = [SELECT Id FROM SBQQ__QuoteLine__c LIMIT 1];
        SBQQ__Quote__c qt = [SELECT Id FROM SBQQ__Quote__c LIMIT 1];
        
        BlanketGasRegulatorController obj = new BlanketGasRegulatorController();
        
        BlanketGasRegulatorController.saveCertificate(conBGR, ql.Id);
        BlanketGasRegulatorController.SupplyGas(conBGR);
        Test.stopTest();
    }
}