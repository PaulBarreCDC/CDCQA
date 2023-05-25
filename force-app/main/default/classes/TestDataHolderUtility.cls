@isTest
public class TestDataHolderUtility {
    
    public static SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c(); 
    public static Holders__c conHolder = new Holders__c();
    public static Map<String, String> mapWithHolderValues = new Map<String, String>();
    
    public static Holders__c createHoldersTestRecords(){
        
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
        conHolder.Drawing_Outside_Config__c = true;
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
        //conHolder.Rupture_Disc_Burst_Temperature_Units__c = 'Deg F';        //conHolder.Rupture_Disc_Burst_Temperature__c = 72;
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
        conHolder.Non_Discountable_Price__c = 99999;
        conHolder.Discountable_Price__c = 10000;
        
        insert conHolder; 
        
        conHolder = [SELECT Id, Holder_Product_Code__c , Brand__c, Quote_Line__c, Brand_Formula__c, Quantity__c, Size__c, Size_Unit__c, Holder_Product__c, Inlet_Material__c, Outlet_Material__c, Size2__c, Price_Engineer_Override__c, 
                     Part_Number_Base__c, ASSYPARTEXISTING__c, Bolting_Class__c, Rupture_Disc_Product__c, Drawing_Outside_Config__c, Material_Sourcing_Requirements__c, ASME_Section_VIII__c, DWGNO__c, Inlet_Connection__c,
                     Inlet_Option__c, Outlet_Connection__c, Outlet_Option2__c, Non_Discountable_Price__c, PMI__c, Seat__c, Rupture_Disc_Burst_Pressure__c, Rupture_Disc_Burst_Temperature_Units__c, Rupture_Disc_Burst_Temperature__c,
                     Mid_Flange_Material__c, Nut_Material__c, Spacer_Ring_Material__c, Holddown_Ring_Material__c, Body_Material__c, Clamp_Material__c, Companion_Flange_Material__c, Gasket_Material__c, Eyebolts_Drilling_Inlet__c, 
                     Studs_and_Nuts__c, Reducing_Bushing__c, Reducing_Bushing_Mid_Flange__c, Jackscrews_Additional__c, Gauge_Selection_Outlet__c, Gauge_Selection_Mid_Flange__c, Nipple2__c, Nipple_Mid_Flange__c, 
                     Tee2__c, Tee_Mid_Flange__c, Excess_Flow_Valve__c, Excess_Flow_Valve_Mid_Flange__c, NEWSPCLPARTNOBASE__c, J_Hook__c, Final_Assembly_Location_Requirements__c
                     FROM Holders__c limit 1];
        System.debug('BRAND...Holder...'+conHolder.Brand_Formula__c);
        return conHolder;    
    }
    
    public static void createHoldersMasterTestRecords(){
        
        List<Holder_Price_Translation__c> holderPriceTransList = Test.loadData(Holder_Price_Translation__c.sObjectType, 'Holder_Price_Translation_MasterData');
        
        //throwing error
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
        
        
        Test.loadData(Holder_Price_Details__c.sObjectType, 'Holder_Price_Details_MasterData');
        Test.loadData(Holder_Leadtime_Schedule__c.sObjectType, 'Holder_Leadtime_Schedule_MasterData');
        Test.loadData(Cost__c.sObjectType, 'Cost_MasterData');
        Test.loadData(Holders_Product_Narrowing__c.sObjectType, 'Holders_Product_Narrowing_MasterData');
        Test.loadData(Holder_Product_Detail__c.sObjectType, 'Holder_Product_Detail_MasterData');
        Test.loadData(Holder_Description_Translation__c.sObjectType, 'Holder_Description_Translation_MasterData');
        Test.loadData(Holder_Description_Detail__c.sObjectType, 'Holder_Description_Detail_MasterData');
        Test.loadData(Holder_Drawings_Translation__c.sObjectType, 'Holder_Drawings_Translation_MasterData');
        Test.loadData(Holder_Drawings_Detail__c.sObjectType, 'Holder_Drawings_Detail_MasterData');
        //Test.loadData(Holder_Drawings__c.sObjectType, 'Holder_Drawings_MasterData'); //throwing error
        Test.loadData(Holder_Option__c.sObjectType, 'Holder_Option_MasterData');
        Test.loadData(Holder_Testing_Translation__c.sObjectType, 'Holder_Testing_Translation_MasterData');
        Test.loadData(Holder_Testing_Details__c.sObjectType, 'Holder_Testing_Details_MasterData');
        
        //List<Holder_Structure__c> holderStructureList = Test.loadData(Holder_Structure__c.sObjectType, 'Holder_Structure_MasterData');
        List<Holder_Structure__c> hldStructList = new List<Holder_Structure__c>();
        
        //List<Holder_Routing_Detail__c> hldRoutingList = Test.loadData(Holder_Routing_Detail__c.sObjectType, 'Holder_Routing_Detail_MasterData');
        List<Holder_Routing_Translation__c> hldRoutingTranslation = Test.loadData(Holder_Routing_Translation__c.sObjectType, 'Holder_Routing_Translation_Data');
        
        List<Holder_Structure__c> hldStructures = new List<Holder_Structure__c>();
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
        hldStructures.add(hldStructure);
        
        hldStructure = new Holder_Structure__c();
        hldStructure.INLETCOMPPTC__c = 'STI';
        hldStructure.InletSC__c = '00';
        hldStructure.Source_Code__c = '00';
        hldStructure.OptionCode__c = '043';
        hldStructure.HCLASS__c = 'A1';
        hldStructure.Testing_Code__c = '000';
        hldStructure.MCHI__c = '005';
        hldStructure.Additional_Code__c = '0';
        hldStructure.Holder_Structure_Type__c = 'SourceCode';
        hldStructure.Material_Sourcing_Requirements__c = '00';
        hldStructures.add(hldStructure);
        
        hldStructure = new Holder_Structure__c();
        hldStructure.INLETCOMPPTC__c = 'STI';
        hldStructure.SZC__c = '1000';
        hldStructure.MCHI__c = '005';
        hldStructure.Source_Code__c = '00';
        hldStructure.HCLASS__c = 'A1';
        hldStructure.OptionCode__c = '043';
        hldStructure.Testing_Code__c = '000';
        hldStructure.Additional_Code__c = '0';
        hldStructure.Holder_Structure_Type__c = 'Inlet';
        
        hldStructure.Component_Part_Number__c = 'GKU010008000A1X20000000';
        hldStructure.MCKBLD__c = 'GKU010008000A1X20000000';
        hldStructure.ROP__c = 75;
        hldStructure.Qty_Per_Assembly__c = 1;
        hldStructure.Scrap_Factor__c = 0;
        hldStructure.LeadtimeSchedule__c = 'MR';
        hldStructure.Component_Scrap__c = '0';
        hldStructure.Holder_Structure_Type__c = 'Inlet';
        hldStructures.add(hldStructure);
        
        insert hldStructures;
        System.debug('hldStructure..'+hldStructure);
        
        update hldStructList;
        
        Test.loadData(Holder_Additional_Acc_Translation__c.sObjectType, 'Holder_Additional_Acc_Translation_MasterData');
        Test.loadData(Holder_Additional_Acc_Details__c.sObjectType, 'Holder_Additional_Acc_Details_MasterData');
        Test.loadData(Holder_Lookup_Translation__c.sObjectType, 'Holder_Lookup_Translation_MasterData');
        Test.loadData(Holder_Lookup_Detail__c.sObjectType, 'Holder_Lookup_Detail_MasterData');
        Test.loadData(IFS_character_codes__c.sObjectType, 'IFS_character_codes_MasterData');
        Test.loadData(Holder_Additional_Codes_Detail__c.sObjectType, 'Holder_Additional_Codes_Detail_MasterData');
        Test.loadData(Holder_Additional_Code_Translation__c.sObjectType, 'Holder_Additional_Code_Translation_MasterData');
        Test.loadData(Holders_Required_Component__c.sObjectType, 'Holders_Required_Component_MasterData');
        
        Holder_Additional_Acc_Details__c hldAAC = new Holder_Additional_Acc_Details__c();
        hldAAC.Text1Val__c = 'HXI';
        hldAAC.Accessory__c = 'Accessory1';
        hldAAC.Accessory_Part_Number__c = 'TEST12345';
        hldAAC.Qty_Per_Assembly__c = '1';
        hldAAC.Scrap_Factor__c = '1';
        hldAAC.Component_Scrap__c = '1';
        hldAAC.Scrap_Factor__c = '0';
        insert hldAAC;
        
        List<Holder_Leadtime_Schedule__c> hldLTSList = new List<Holder_Leadtime_Schedule__c>();
        Holder_Leadtime_Schedule__c hldLTS = new Holder_Leadtime_Schedule__c();
        hldLTS.Entity__c = 'CDC';
        hldLTS.Leadtime__c = 20;
        hldLTS.QtyLL__c = 2;
        hldLTS.QtyUL__c = 2;
        hldLTS.Schedule__c = 'test';
        hldLTSList.add(hldLTS);
        insert hldLTSList;
        
        Holder_Drawings_Detail__c hldDrawingDet = new Holder_Drawings_Detail__c();
        hldDrawingDet.DrawingID__c = 'GEP-6400';
        hldDrawingDet.Drawing_Type__c = 'Submittal Drawing' ;
        hldDrawingDet.text1val__c = 'HXI'; 
        hldDrawingDet.text2val__c = '10" (250mm)';
        hldDrawingDet.text3val__c = 'A1';
        hldDrawingDet.text4val__c = 'N';
        hldDrawingDet.text5val__c = 'N';
        hldDrawingDet.text6val__c = '043';
        hldDrawingDet.text7val__c = '042';            
        insert hldDrawingDet;
        
        Holder_Routing_Detail__c hrd = new Holder_Routing_Detail__c();
        hrd.Standard_Operation_ID__c = 'Id';
        hrd.Outside_Operation_Item__c = 'Item';
        hrd.Descr__c = 'Desc';
        hrd.OPERATION__c = '0005';
        insert hrd;
        
        Holder_ControlPlan_Detail__c hcpd = new Holder_ControlPlan_Detail__c();
        hcpd.Test_OPNO__c = 'OPNO';
        hcpd.TEST_OPERATION_DESC__c = 'DESC';
        hcpd.NORM_TYPE__c = 'TYPE';
        hcpd.Operation_Number__c = '1111';
        hcpd.DATA_TYPE__c = 'STR';
        hcpd.CATEGORY_ID__c = '111';
        hcpd.INSPECTION_CODE__c = '1D';
        hcpd.SAMPLE_PERCENT__c = '20';
        hcpd.Process_Characteristic__c = 'C1';
        hcpd.Special_Characteristic_Classification__c = 'S1';
        hcpd.OUTER_MIN__c = '1';
        hcpd.INNER_MIN__c = '1';
        hcpd.NOMINAL_VALUE__c = '1';
        hcpd.INNER_MAX__c = '10';
        hcpd.OUTER_MAX__c = '10';
        hcpd.Tool_ID__c = 'Id';
        hcpd.Data_Point__c = 'Test';
        hcpd.Test_OPNO_1__c = '1';
        insert hcpd;
        
        Holder_WorkGuidelines_Detail__c wgd = new Holder_WorkGuidelines_Detail__c();
        wgd.Operation__c = 'OPR';
        wgd.Test__c = 'Test';
        wgd.Standard_Operation_ID__c = 'Test ID';
        wgd.Outside_Operation_Item__c = 'Item';
        wgd.Guideline_Seq__c = '1';
        wgd.Description__c = 'DESC';
        wgd.Text__c = 'Text';
        wgd.Type__c = 'Type';
        wgd.Sign_Off__c = 'Sign';
        wgd.Inspection_Sign_Off_Required__c = 'No';
        insert wgd;
    }
    
    
}