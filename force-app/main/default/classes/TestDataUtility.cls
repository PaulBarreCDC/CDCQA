@isTest
public class TestDataUtility {
    
    public static SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();
    public static Holders__c conHolder = new Holders__c();
    public static Map<String, String> mapWithHolderValues = new Map<String, String>();
    
    public static void createHoldersTestRecords(){
        mapWithHolderValues.put('BOLTING_CLASS', 'A3');
        mapWithHolderValues.put('BRAND','CDC');
        mapWithHolderValues.put('PRODUCT_CODE','HLD');
        mapWithHolderValues.put('PRODUCT_NAME','Holder');
        mapWithHolderValues.put('HOLDER_PRODUCT','7I Insert (LL) Double Disc Holder');
        mapWithHolderValues.put('INLET_MATERIAL','002');
        mapWithHolderValues.put('OUTLET_MATERIAL','002');
        mapWithHolderValues.put('SIZE','1/2" (13mm)');
        mapWithHolderValues.put('SIZE_UNITS', 'US Units');
        
        quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithHolderValues);
        System.debug('TestDataHolderUtility..QuoteId...'+quoteLine.Id);
        //Holders        
        conHolder.Holder_Product_Code__c = 'HXI';
        conHolder.Brand__c = 'CDC';
        conHolder.Quote_Line__c = quoteLine.Id;
        conHolder.Quantity__c = 1;
        conHolder.Size__c = '1000';
        conHolder.Size_Unit__c = 'US Units';
        conHolder.Holder_Product__c = 'HPX Insert'	;
        conHolder.Inlet_Material__c = '005';
        conHolder.Outlet_Material__c = '005';
        conHolder.Size2__c = '10" (250mm)';
        conHolder.Price_Engineer_Override__c = false;
        conHolder.Part_Number_Base__c = 'DHXI1000A1';
        conHolder.ASSYPARTEXISTING__c = 'DL7I0300A100001';
        conHolder.Bolting_Class__c = 'A1';
        //conHolder.Rupture_Disc_Product__c = 'CDC';
        conHolder.Drawing_Outside_Config__c = false;
        conHolder.Material_Sourcing_Requirements__c = '00';
        conHolder.ASME_Section_VIII__c = true;
        conHolder.DWGNO__c = '1000002';
        conHolder.Inlet_Connection__c = 'N';
        conHolder.Inlet_Option__c = '043';
        conHolder.Outlet_Connection__c = 'N';
        conHolder.Outlet_Option2__c = '042';
        conHolder.PMI__c = 'CONFIRM';        //conHolder.Non_Discountable_Price__c = 9999;
        conHolder.Seat__c = 'FS';
        conHolder.Rupture_Disc_Burst_Pressure__c = 0;
        conHolder.Rupture_Disc_Burst_Temperature_Units__c = 'Deg F';
        conHolder.Rupture_Disc_Burst_Pressure_Units__c = 'barg';
        conHolder.Rupture_Disc_Burst_Temperature__c = 0;
        conHolder.Mid_Flange_Material__c = 'test';
        conHolder.Nut_Material__c = 'test';
        conHolder.Spacer_Ring_Material__c = 'test';
        conHolder.Holddown_Ring_Material__c = 'test';
        conHolder.Body_Material__c = 'test';
        conHolder.Clamp_Material__c = 'test';
        conHolder.Companion_Flange_Material__c = 'test';
        conHolder.Gasket_Material__c = 'test';
        conHolder.Eyebolts_Drilling_Inlet__c = 'test';
        conHolder.Studs_and_Nuts__c = 'test';
        conHolder.Reducing_Bushing__c = 'test';
        conHolder.Reducing_Bushing_Mid_Flange__c = 'test';
        conHolder.Jackscrews_Additional__c = 'test';
        conHolder.Gauge_Selection_Outlet__c = 'test';
        conHolder.Gauge_Selection_Mid_Flange__c = 'test';
        conHolder.Nipple2__c = 'test';
        conHolder.Nipple_Mid_Flange__c = 'test';
        conHolder.Tee2__c = 'test';
        conHolder.Tee_Mid_Flange__c = 'test';
        conHolder.Excess_Flow_Valve__c = 'test';
        conHolder.Excess_Flow_Valve_Mid_Flange__c = 'test';
        conHolder.NEWSPCLPARTNOBASE__c = 'CD50000';
        conHolder.J_Hook__c = 'J-Hook';
        conHolder.Final_Assembly_Location_Requirements__c = '00';
        //==================
        conHolder.CSA_Markings__c = true;
        conHolder.ATEX_Certificate__c = true;
        conHolder.GOST_CUTR_Compliance__c = true;
        conHolder.CE_PED_Compliance__c = true;
        conHolder.KOSHA_Compliance__c = true;
        conHolder.NACE_Compliance__c = 'MR0175';
		conHolder.X3A_Sanitary_Standards__c = true;
        conHolder.Gas_Group__c = 'IIA';
        conHolder.Zone_0_2__c = '2';
        conHolder.China_Manufacturing_License__c = 'WSI';
        conHolder.Holder_Max_Pressure_Units__c = 'atmg';//1184
        conHolder.Holder_Max_Pressure__c = 20;
        conHolder.Finish_Configuration__c = true;
        conHolder.Quote_Descriptions_Override__c = false;
        insert conHolder; 
        
        
        
        conHolder = [SELECT Id, Holder_Product_Code__c , Rupture_Disc_Burst_Pressure_Units__c, Brand__c, Quote_Line__c, Brand_Formula__c, Quantity__c, Size__c, Size_Unit__c, Holder_Product__c, Inlet_Material__c, Outlet_Material__c, Size2__c, Price_Engineer_Override__c, 
                     Part_Number_Base__c, ASSYPARTEXISTING__c, Bolting_Class__c, Rupture_Disc_Product__c, Drawing_Outside_Config__c, Material_Sourcing_Requirements__c, ASME_Section_VIII__c, DWGNO__c, Inlet_Connection__c,
                     Inlet_Option__c, Outlet_Connection__c, Outlet_Option2__c, Non_Discountable_Price__c, PMI__c, Seat__c, Rupture_Disc_Burst_Pressure__c, Rupture_Disc_Burst_Temperature_Units__c, Rupture_Disc_Burst_Temperature__c,
                     Mid_Flange_Material__c, Nut_Material__c, Spacer_Ring_Material__c, Holddown_Ring_Material__c, Body_Material__c, Clamp_Material__c, Companion_Flange_Material__c, Gasket_Material__c, Eyebolts_Drilling_Inlet__c, 
                     Studs_and_Nuts__c, Reducing_Bushing__c, Reducing_Bushing_Mid_Flange__c, Jackscrews_Additional__c, Gauge_Selection_Outlet__c, Gauge_Selection_Mid_Flange__c, Nipple2__c, Nipple_Mid_Flange__c, 
                     Tee2__c, Tee_Mid_Flange__c, Excess_Flow_Valve__c, Excess_Flow_Valve_Mid_Flange__c, NEWSPCLPARTNOBASE__c, J_Hook__c, Final_Assembly_Location_Requirements__c,
                     China_Manufacturing_License__c, Holder_Max_Pressure_Units__c, Holder_Max_Pressure__c FROM Holders__c limit 1];
        System.debug('BRAND...Holder...'+conHolder.Brand_Formula__c);
        System.debug('QL Id....'+conHolder.Quote_Line__c);
        
    }
    
    public static void createHoldersMasterTestRecords(){
        
        List<Holder_Price_Translation__c> holderPriceTransList = Test.loadData(Holder_Price_Translation__c.sObjectType, 'Holder_Price_Translation_MasterData');
        
        List<Holder_Outputs__c> holderOutputList = Test.loadData(Holder_Outputs__c.sObjectType, 'Holder_Outputs_MasterData');
        List<Holder_Outputs__c> holderOutputList1 = new List<Holder_Outputs__c>();
        
        for(Holder_Outputs__c holderOutput: holderOutputList){
            holderOutput.ReferenceId__c = conHolder.Id;
            holderOutputList1.add(holderOutput);
        }
        update holderOutputList1;
        
        Holder_Drawings__c hldDrawings = new Holder_Drawings__c();
        hldDrawings.CDC_Ext_ID__c = '2';
        hldDrawings.Dim_A_Override__c = '6.75 [171.5]';
        hldDrawings.Dim_A__c = '6.75 [171.5]';
        hldDrawings.Dim_B_Override__c = '4.56 [115.8]';
        hldDrawings.Dim_B__c = '4.56 [115.8]';
        hldDrawings.Dim_C_Override__c = '4.56 [115.8]';
        hldDrawings.Dim_C__c = '4.56 [115.8]';
        hldDrawings.Dim_D_Override__c = '4.56 [115.8]';
        hldDrawings.Dim_D__c = '';
        hldDrawings.Dim_E_Override__c = '';
        hldDrawings.Dim_E__c = '';
        hldDrawings.Dim_F_Override__c = '';
        hldDrawings.Dim_F__c = '';
        hldDrawings.Drawing_ID_Override__c = '1118';
        hldDrawings.Drawing_ID__c = '1118';
        hldDrawings.Drawing_Info_Override__c = '';
        hldDrawings.Drawing_Info__c = '';
        hldDrawings.Drawing_Number_Override__c = '';
        hldDrawings.Drawing_Number__c = '';
        hldDrawings.Flag__c = '';
        hldDrawings.HIC__c = '';
        hldDrawings.HOC__c = '';
        hldDrawings.Holders__c = conHolder.Id;
        hldDrawings.IINO_DWGNO__c = '1000002';
        hldDrawings.IINO__c = 'GEP-6400';
        hldDrawings.JHOOK_IINO_DWGNO__c = '1000002';
        hldDrawings.J_Hook_IINO__c = 'GEP-6100';
        hldDrawings.Name = '';
        hldDrawings.Revision__c = '';
        hldDrawings.SizeClassDesc__c = '4" (100 mm) 150# ASME';
        hldDrawings.Submittal_Drawing_DWGNO__c = '1000002';
        insert hldDrawings;
        
        List<Holder_Price_Output__c> holderPriceOutputList = Test.loadData(Holder_Price_Output__c.sObjectType, 'Holder_Price_Output_MasterData');
        List<Holder_Price_Output__c> holderPriceOutputList1 = new List<Holder_Price_Output__c>();
        
        for(Holder_Price_Output__c holderPriceOutput: holderPriceOutputList){
            holderPriceOutput.Holders__c = conHolder.Id;
            holderPriceOutputList1.add(holderPriceOutput);
        }
        update holderPriceOutputList1;
        
        
        List<Holder_Price_Details__c> holderPriceDetList = Test.loadData(Holder_Price_Details__c.sObjectType, 'Holder_Price_Details_MasterData');
        
        List<Holder_Leadtime_Schedule__c> holderLTSList = Test.loadData(Holder_Leadtime_Schedule__c.sObjectType, 'Holder_Leadtime_Schedule_MasterData');
        
        List<Cost__c> costList = Test.loadData(Cost__c.sObjectType, 'Cost_MasterData');
        
        List<Holders_Product_Narrowing__c> holderProdNarrowList = Test.loadData(Holders_Product_Narrowing__c.sObjectType, 'Holders_Product_Narrowing_MasterData');
        
        List<Holder_Product_Detail__c> holderProdDetList = Test.loadData(Holder_Product_Detail__c.sObjectType, 'Holder_Product_Detail_MasterData');
        
        List<Holder_Description_Translation__c> holderDescTrancList = Test.loadData(Holder_Description_Translation__c.sObjectType, 'Holder_Description_Translation_MasterData');
        
        List<Holder_Description_Detail__c> holderDescDetList = Test.loadData(Holder_Description_Detail__c.sObjectType, 'Holder_Description_Detail_MasterData');
        
      List<Holder_Drawings_Translation__c> holderDrawingTransList = Test.loadData(Holder_Drawings_Translation__c.sObjectType, 'Holder_Drawings_Translation_MasterData');
        
        List<Holder_Drawings_Detail__c> holderDrawingDetList = Test.loadData(Holder_Drawings_Detail__c.sObjectType, 'Holder_Drawings_Detail_MasterData');
        
      //  List<Holder_Drawings__c> holderDrawingList = Test.loadData(Holder_Drawings__c.sObjectType, 'Holder_Drawings_MasterData');
        
        List<Holder_Option__c> holderOptionList = Test.loadData(Holder_Option__c.sObjectType, 'Holder_Option_MasterData');
        
        List<Holder_Structure__c> holderStructureList = Test.loadData(Holder_Structure__c.sObjectType, 'Holder_Structure_MasterData');
        List<Holder_Structure__c> hldStructList = new List<Holder_Structure__c>();
        List<Holder_Structure__c> hldStructList1 = Test.loadData(Holder_Structure__c.sObjectType, 'Holder_Structure_MasterData2');
       
        //List<Holder_Routing_Detail__c> hldRoutingList = Test.loadData(Holder_Routing_Detail__c.sObjectType, 'Holder_Routing_Detail_MasterData');
        //List<Holder_Routing_Translation__c> hldRoutingTranslation = Test.loadData(Holder_Routing_Translation__c.sObjectType, 'Holder_Routing_Translation_Data');
        
        List<Temparature__c > temparatureList = Test.loadData(Temparature__c.sObjectType, 'Temparature_MasterData');
        List<Pressure__c> pressureList = Test.loadData(Pressure__c.sObjectType, 'Pressure_MasterData');
        
       // List<Holders_Required_Component__c> hldRequiredList = Test.loadData(Holders_Required_Component__c.sObjectType, 'Holders_Required_Component_MasterData');
        
        Holder_Structure__c hldStructure = new Holder_Structure__c();
        hldStructure.INLETCOMPPTC__c = 'STI';
        hldStructure.InletSC__c = '00';
        hldStructure.Holder_Structure_Type__c = 'Inlet';
        hldStructure.Source_Code__c = '00';
        hldStructure.OptionCode__c = '043';
        hldStructure.HCLASS__c = 'A1';
        hldStructure.Testing_Code__c = '000';
        hldStructure.MCHI__c = '005';
        hldStructure.Additional_Code__c = '0';
        insert hldStructure;
        System.debug('hldStructure..'+hldStructure);
        
        update hldStructList;
        
        List<Holder_Additional_Acc_Translation__c> holderAddAccTransList = Test.loadData(Holder_Additional_Acc_Translation__c.sObjectType, 'Holder_Additional_Acc_Translation_MasterData');
        
        List<Holder_Additional_Acc_Details__c> holderAddAccDetList = Test.loadData(Holder_Additional_Acc_Details__c.sObjectType, 'Holder_Additional_Acc_Details_MasterData');
        
        List<Holder_Lookup_Translation__c> holderLookupTransList = Test.loadData(Holder_Lookup_Translation__c.sObjectType, 'Holder_Lookup_Translation_MasterData');
        
        List<Holder_Lookup_Detail__c> holderLookupDetList = Test.loadData(Holder_Lookup_Detail__c.sObjectType, 'Holder_Lookup_Detail_MasterData');
        
        List<IFS_character_codes__c> IFSCharCodeList = Test.loadData(IFS_character_codes__c.sObjectType, 'IFS_character_codes_MasterData');
        
        List<Holder_Additional_Codes_Detail__c> hlsAddCodeDet = Test.loadData(Holder_Additional_Codes_Detail__c.sObjectType, 'Holder_Additional_Codes_Detail_MasterData');
        
        List<Holder_Additional_Code_Translation__c> hldAssCodeTrans = Test.loadData(Holder_Additional_Code_Translation__c.sObjectType, 'Holder_Additional_Code_Translation_MasterData');        
    }
    
    
}