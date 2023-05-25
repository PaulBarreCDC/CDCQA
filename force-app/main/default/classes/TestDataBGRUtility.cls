public class TestDataBGRUtility 
{
	 public static SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c(); 
     public static BGR__c conBGR = new BGR__c();
    public static BGR__c conBGRQ = new BGR__c();
     public static Map<String, String> mapWithBGRValues = new Map<String, String>(); 
    
    public static void createBGRTestRecords(){
               
        conBGR.Quote_Line__c = quoteLine.Id;
        conBGR.Service_Type__c  = 'pressure';
        conBGR.Setting__c  = 0.5;
        conBGR.Setting_Units__c  = 'in. water';
        conBGR.Supply_Pressure__c  = 150;
        conBGR.Supply_Gas_Temperature__c =20;
        conBGR.Supply_Pressure_Units__c  = 'psig';
        conBGR.Atex__c  = 'Y';
        conBGR.GOST_CU_Tr_010_2011__c  = 'N';
        conBGR.CSA_Markings__c  = 'N';
        conBGR.Combo_Orifice_Setting__c  = '3020A 1inch : Orifice 75%'; 
        conBGR.Model__c  = '3020A';
        conBGR.Size__c  = '01';
        conBGR.Size_Backend__c = '5';
        conBGR.Body_Material_dynamic__c  = '5';
        conBGR.Soft_Goods_Material_dynamic__c = 'B' ;
        conBGR.Connection_dynamic__c = 'T';
        conBGR.Radiography__c = 'N' ;
        conBGR.Positive_Material_Identification__c ='N';
        conBGR.Shell_test__c = 'AIR';
        conBGR.Shell_Test_Valve_Body__c = 'AIR';
        conBGR.Final_Assembly_Location_Requirements__c = '00';
        conBGR.Material_Sourcing_Requirements__c = '00';
        conBGR.Atmospheric_Pressure_Units__c='psig';
        conBGR.Supply_Gas_Temperature_Units__c='Deg F';
        conBGR.Flow_Units__c='ACFH';
        conBGR.Minimum_Required_Flow_Capacity__c=12;
        conBGRQ.PresRatio__c=1.0660000000;
        conBGRQ.Schedule__c	= 'BGRC';
        conBGRQ.Lead_Time_Engineer_Override__c=false;
       
        
        insert conBGR; 
        
        conBGR=[select id, Body_Material_dynamic__c, Schedule__c, Flow_Units__c, Supply_Gas_Temperature_Units__c, Atmospheric_Pressure_Units__c, Soft_Goods_Material_dynamic__c,Connection_dynamic__c,Radiography__c,
		           Positive_Material_Identification__c,Quote_Description_Engineer_Override__c,Shell_test__c,Shell_Test_Valve_Body__c,
                Final_Assembly_Location_Requirements__c, Material_Sourcing_Requirements__c,ASSYPARTNOBASE__c, Body_Material__c, 
                Price_Engineer_Override__c,Lead_Time_Engineer_Override__c,Build_Cost_Override__c,Converted_Supply_Gas_Temperature__c,
                Converted_Setting__c , Atmospheric_Pressure__c ,PresRatio__c ,Minimum_Required_Flow_Capacity__c,Converted_Flow_Capacity__c,
                Model__c,Size__c,Product_material_options_flag__c,Configuration_Complete__c,Quantity__c,Document_Or_Sourcing_flag__c,
                Section_B_flag__c,Certifications_flag__c,Product_selection_flag__c,Valve_Examination_Flag__c,Part_Number_Base_Original__c,
                ASSYPARTEXISTING__c from  BGR__c  limit 1];
                
    }
    
    public static void createBGRTestRecordss(){
               
        conBGRQ.Quote_Line__c = quoteLine.Id;
        conBGRQ.Service_Type__c  = 'pressure';
        conBGRQ.Setting__c  = 0.5;
        conBGRQ.Setting_Units__c  = 'in. water';
        conBGRQ.Supply_Pressure__c  = 150;
        conBGRQ.Supply_Gas_Temperature__c =20;
        conBGRQ.Supply_Pressure_Units__c  = 'psig';
        conBGRQ.Atex__c  = 'Y';
        conBGRQ.GOST_CU_Tr_010_2011__c  = 'N';
        conBGRQ.CSA_Markings__c  = 'N';
        conBGRQ.Combo_Orifice_Setting__c  = '3020A 1inch : Orifice 75%'; 
        conBGRQ.Model__c  = '3020A';
        conBGRQ.Size__c  = '01';
        conBGRQ.Size_Backend__c = '5';
        conBGRQ.Body_Material_dynamic__c  = '5';
        conBGRQ.Soft_Goods_Material_dynamic__c = 'B' ;
        conBGRQ.Connection_dynamic__c = 'T';
        conBGRQ.Radiography__c = 'N' ;
        conBGRQ.Positive_Material_Identification__c ='N';
        conBGRQ.Shell_test__c = 'AIR';
        conBGRQ.Shell_Test_Valve_Body__c = 'AIR';
        conBGRQ.Final_Assembly_Location_Requirements__c = '00';
        conBGRQ.Material_Sourcing_Requirements__c = '00';
        conBGRQ.Atmospheric_Pressure_Units__c='psig';
        conBGRQ.Supply_Gas_Temperature_Units__c='Deg F';
        conBGRQ.Flow_Units__c='ACFH';
        conBGRQ.Minimum_Required_Flow_Capacity__c=12;
        conBGRQ.Quantity__c=1;
        conBGRQ.Narrow_selection_on_flow_requirements__c=True;
        conBGRQ.PresRatio__c=0.0660000000;
        conBGRQ.Ratio_of_Specific_Heats__c=0;
        conBGRQ.Converted_Flow_Capacity__c=1;
        conBGRQ.Body_Material_dynamic__c='5';
        conBGRQ.Price_Engineer_Override__c=true;
        conBGRQ.Lead_Time_Engineer_Override__c=True;
        conBGRQ.Schedule__c	= 'BGRC';
        insert conBGRQ; 
        
        conBGRQ=[select id, Body_Material_dynamic__c, Schedule__c,Flow_Units__c, Supply_Gas_Temperature_Units__c, Atmospheric_Pressure_Units__c, Soft_Goods_Material_dynamic__c,Connection_dynamic__c,Radiography__c,
		           Positive_Material_Identification__c,Quote_Description_Engineer_Override__c,Shell_test__c,Shell_Test_Valve_Body__c,
                Final_Assembly_Location_Requirements__c, Material_Sourcing_Requirements__c,ASSYPARTNOBASE__c, Body_Material__c, 
                Price_Engineer_Override__c,Lead_Time_Engineer_Override__c,Build_Cost_Override__c,Converted_Supply_Gas_Temperature__c,
                Converted_Setting__c , Atmospheric_Pressure__c ,PresRatio__c ,Minimum_Required_Flow_Capacity__c,Converted_Flow_Capacity__c,
                Model__c,Size__c,Product_material_options_flag__c,Configuration_Complete__c,Quantity__c,Document_Or_Sourcing_flag__c,
                Section_B_flag__c,Certifications_flag__c,Product_selection_flag__c,Valve_Examination_Flag__c,Part_Number_Base_Original__c,
                ASSYPARTEXISTING__c from  BGR__c  limit 1];
                
    }
    
    public static void createBGRMasterTestRecords(){             
        
        List<BGR_Attribute_lookup_Details__c> BGRAttributeLookupDetailTable = Test.loadData(BGR_Attribute_lookup_Details__c.sObjectType, 'BGRAttributelookupDetailsMasterData');
        List<BGR_Attribute_lookup_Translation__c> BGRAttributeLookupTranslationTable = Test.loadData(BGR_Attribute_lookup_Translation__c.sObjectType, 'BGRAttributelookupTranslationMasterData');
        
        List<BGR_Attribute_lookup_Details__c> bgrAttributes = new List<BGR_Attribute_lookup_Details__c>();
        BGR_Attribute_lookup_Details__c bgrAttribute = new BGR_Attribute_lookup_Details__c();
        bgrAttribute.Attribute__c = 'RGEUNT';
        bgrAttribute.Text__c = 'in. water';
        bgrAttribute.numval1__c = 0.0;
        bgrAttribute.numval2__c = 22.49;
        bgrAttributes.add(bgrAttribute);
        
        bgrAttribute = new BGR_Attribute_lookup_Details__c();
        bgrAttribute.Attribute__c = 'RGEUNT';
        bgrAttribute.Text__c = 'psig';
        bgrAttribute.numval1__c = 22.49; 
        bgrAttribute.numval2__c = 9999;
        bgrAttributes.add(bgrAttribute);
        
        insert bgrAttributes;
        
        List<BGR_Control_Plan__c> BGRControlPlanDetailTable = Test.loadData(BGR_Control_Plan__c.sObjectType, 'BGRControlPlanMasterData');       
        
        List<BGR_IFS_Translation_Details__c> BGRIFSTranslationDetailTable = Test.loadData(BGR_IFS_Translation_Details__c.sObjectType, 'BGRIFSTranslationDetailsMasterData');
		List<BGR_KD__c> BGRKDMasterTable = Test.loadData(BGR_KD__c.sObjectType, 'BGRKDMasterData');
		
		List<BGR_lead_time__c> BGRleadtimeTable = Test.loadData(BGR_lead_time__c.sObjectType, 'BGRleadtimeMasterData'); 
        List<BGR_Lead_time_schedule__c> BGRLeadtimescheduleTable = Test.loadData(BGR_Lead_time_schedule__c.sObjectType, 'BGRLeadtimescheduleMasterData'); 

        List<BGR_Masterblaster__c> BGRMasterblasterTable = Test.loadData(BGR_Masterblaster__c.sObjectType, 'BGRMasterblasterMasterData');
        List<BGR_Matlist__c> BGRMatlistTable = Test.loadData(BGR_Matlist__c.sObjectType, 'BGRMatlistMasterData');       		
        
        List<BGR_Price_Details__c> BGRPriceDetailTable = Test.loadData(BGR_Price_Details__c.sObjectType, 'BGRPriceDetailsMasterData');
		List<BGR_Price_Translation__c> BGRPriceTranslationTable = Test.loadData(BGR_Price_Translation__c.sObjectType, 'BGRPriceTranslationMasterData');
        
		List<BGR_Product_document__c> BGRProductdocumentTable = Test.loadData(BGR_Product_document__c.sObjectType, 'BGRProductdocumentMasterData');
        
        //List<BGR_Routing__c> BGRRoutingDetailTable = Test.loadData(BGR_Routing__c.sObjectType, 'WGBRoutingDetailsTestData1');        
        //List<BGR_Structures__c> BGRStructuresTable = Test.loadData(BGR_Structures__c.sObjectType, 'BGRStructuresMasterData');
        
        
        List<BGR_WorkGuide_Details__c> BGRWorkGuideDetailsMasterData = Test.loadData(BGR_WorkGuide_Details__c.sObjectType, 'BGRWorkGuideDetailsMasterData');
        List<BGR_WorkGuide_Translation__c> BGRWorkGuidelinesTranslationTable = Test.loadData(BGR_WorkGuide_Translation__c.sObjectType, 'BGRWorkGuideTranslationMasterData');
        
        List<BGR_lead_time__c> BGRLTSList = Test.loadData(BGR_lead_time__c.sObjectType, 'BGRleadtimeMasterData');        
        List<Cost__c> costList = Test.loadData(Cost__c.sObjectType, 'Cost_MasterData'); 
        
        
        List<BGR_Lead_time_schedule__c> BGRLTSLst = new List<BGR_Lead_time_schedule__c>();
        BGR_Lead_time_schedule__c BGRLTS = new BGR_Lead_time_schedule__c();
        BGRLTS.SHLTSTMETHACT__c = 'Test';
        BGRLTS.SHLTSTMETHBDY__c = 'Test';
        //BGRLTS.QtyLL__c = 2;
       // BGRLTS.QtyUL__c = 2;
        BGRLTS.Schedule__c = 'test';
        BGRLTSLst.add(BGRLTS);
        insert BGRLTSLst;
        
       BGR_Routing__c Brd = new BGR_Routing__c();
        Brd.Standard_Operation_Id__c = 'Id';
        Brd.Outside_Operation_Item__c = 'Item';
        Brd.Descr__c = 'Desc';
        Brd.Operation_Number__c = '0005';
		insert Brd;
        
        List<BGR_Outputs__c> BGROutputList1 = new List<BGR_Outputs__c>();
        
		BGR_Outputs__c BGROutputval = new BGR_Outputs__c();        
        BGROutputval.ATEX__c=10;
        BGROutputval.Base__c=10;
        BGROutputval.Base_Lead_Time_10__c= 'Test';
        BGROutputval.Base_Lead_Time_20__c='Test';
        BGROutputval.Base_Lead_Time_30__c='Test';
		BGROutputval.Base_Lead_Time_40__c='Test';
        BGROutputval.MatlSource__c=9999999; 
        BGROutputval.Connection__c = 0.0;
        BGROutputval.CSA__c  = 0.1;
        BGROutputval.OA_Override__c='Test';
        BGROutputval.OA01__c='Test';
		BGROutputval.OA02__c='Test ';
        BGROutputval.OA04__c='Test ';
		BGROutputval.OB_Override__c='Test';
        BGROutputval.OB010__c='Test';
        BGROutputval.OB050__c='Test';
        BGROutputval.OB310__c='Test';
        BGROutputval.OB320__c='Test';
        BGROutputval.OB410__c='Test';
        BGROutputval.OB420__c='Test';
		BGROutputval.OW_Override__c='Test';
        BGROutputval.OW210__c='Test';
        BGROutputval.OW220__c='Test';
        BGROutputval.OW310__c='Test';
        BGROutputval.OW410__c='Test';
        BGROutputval.OW610__c='Test';
        BGROutputval.OW620__c='Test';
        BGROutputval.OW630__c='Test';
        BGROutputval.OW710__c='Test';
        BGROutputval.OW720__c='Test';
        BGROutputval.OW910__c='Test';                
        BGROutputval.OW920__c='Test ';
        BGROutputval.Price_Total__c= 5993;       
        BGROutputval.ShellTest__c= 9999999;
        BGROutputval.SoftGoods__c= 1160;        
        BGROutputval.BGR_Outputs_Relation_Field__c = conBGR.Id;
		insert BGROutputval;
        
        BGR_Structures__c BGS = new BGR_Structures__c();
        BGS.Name='Test BGR';
        BGS.CDC_Ext_ID__c='554646655';
        BGS.Component_part__c='MODG3011HXASY015B000';
        //BGS.CurrencyIsoCode='CurrencyIsoCode';
        BGS.Component_Scrap__c='0';
        BGS.ConnectionCode__c='-';
        BGS.Flag__c='';
        BGS.Item__c=2;
        BGS.KITUPREQD__c='';
        BGS.Line_Item_No__c='10';
        BGS.MCBODY__c='5';
        BGS.Model__c='3011H';
        BGS.ModulePN__c='';
        BGS.Phantom__c='';
        //BGS.Qty__c=1;
        BGS.Qty_per_Assembly__c='1';
        BGS.Radiography__c='N';
        BGS.Scrap_Factor__c='0';
        BGS.SettingLL__c=0;
        BGS.SettingUL__c=9999;
        BGS.SoftGoods__c='B';
        BGS.Sourcing__c='00';
        BGS.SpringCode__c='N';
        BGS.SZC__c='01';
        insert BGS;
        
        Test.loadData(Global_Site_Part_Parameters_ISPM__c.sObjectType, 'Global_Site_Part_Parameters_ISPM_Data');
        Test.loadData(Global_Site_Part_Parameters_PPS__c.sObjectType, 'Global_Site_Part_Parameters_PPS_Data');
        Test.loadData(BGR_Documents_Translation__c.sObjectType, 'BGR_Documents_Translation_Data');
        Test.loadData(BGR_Documents_Details__c.sObjectType, 'BGR_Documents_Details_Data');
        
        
        IFS_character_codes__c ifs = new IFS_character_codes__c();
        ifs.Element__c = 'Text';
        ifs.Attribute_Code__c = 'PRDLIN';
        ifs.Interface_to_IFS_Attributes__c = true;
        ifs.Product__c = 'BGR';        
        insert ifs;
        
		BGR_Control_Plan__c bcp = new BGR_Control_Plan__c ();
        bcp.Reciept_Not_Allowed__c = 'Test';
        bcp.Cus_Test_OPNO__c = 'Test';
        bcp.Test_Operation_Desc__c = 'Test';
        bcp.Norm_Type__c = 'Test';
        bcp.Cus_Operation_Number__c = 'Test';
        bcp.Data_Type__c = 'Test';
        bcp.Category_ID__c = 'Test';
        bcp.Outer_Min__c = 'Test';
        bcp.Inner_Min__c = 'Test';
        bcp.Nominal_Value__c = 'Test';
        bcp.Process_Characteristic__c = 'Test';
        bcp.Test_OPNO__c = 1.0;
        bcp.Special_Characteristic_Classification__c = 'Test';
        bcp.Outer_Max__c = 'Test';
        bcp.Inner_Max__c = 'Test';
        bcp.Inspection_Code__c = 'Test';
        bcp.Tool_ID__c = 'Test';
        bcp.Data_Point__c = 'Test';
        bcp.Connected_To_Trigger__c = 'Test';
        bcp.Simplified_Revision_Handling__c = 'Test';
        bcp.Connected_To_Tools__c = 'Test';
        bcp.Mandatory__c = 'Test';
        bcp.Operation_Number__c = 1.0;
        bcp.RGEUNT__c = 'in. water';
        insert bcp;
      
        BGR_Structures__c bgr = new BGR_Structures__c ();
        bgr.Component_part__c = 'MODG3011HXASY015B000';
        bgr.SpringCode__c = 'N';
        bgr.Qty_per_Assembly__c = '1';
        bgr.Scrap_Factor__c = '0';
        bgr.Component_Scrap__c = '0';
        bgr.Line_Item_No__c = '10';
        bgr.Model__c = '-';
        bgr.SZC__c = '-';
        bgr.MCBODY__c = '-';
        bgr.SoftGoods__c = '-';
        bgr.Radiography__c = '-';
        bgr.Sourcing__c = '-';
        bgr.ConnectionCode__c = '-';
        bgr.SettingLL__c = 0.0;
        bgr.SettingUL__c = 1.0;
        insert bgr;
        
        BGR_Routing__c br = new BGR_Routing__c();
        br.Standard_Operation_Id__c = 'Test';
        br.Operation_Number__c = 'Test';
        br.Outside_Operation_Item__c = 'Test';
        br.Positive_Material_Identification__c = '-';
        insert br;
    } 
    
    public static void createBGRMasterTestRecordsQ(){ 
        
        List<BGR_Attribute_lookup_Details__c> BGRAttributeLookupDetailTable = Test.loadData(BGR_Attribute_lookup_Details__c.sObjectType, 'BGRAttributelookupDetailsMasterData');
        List<BGR_Attribute_lookup_Translation__c> BGRAttributeLookupTranslationTable = Test.loadData(BGR_Attribute_lookup_Translation__c.sObjectType, 'BGRAttributelookupTranslationMasterData');
        
        List<BGR_Control_Plan__c> BGRControlPlanDetailTable = Test.loadData(BGR_Control_Plan__c.sObjectType, 'BGRControlPlanMasterData');       
        
        List<BGR_IFS_Translation_Details__c> BGRIFSTranslationDetailTable = Test.loadData(BGR_IFS_Translation_Details__c.sObjectType, 'BGRIFSTranslationDetailsMasterData');
		List<BGR_KD__c> BGRKDMasterTable = Test.loadData(BGR_KD__c.sObjectType, 'BGRKDMasterData');
		
		List<BGR_lead_time__c> BGRleadtimeTable = Test.loadData(BGR_lead_time__c.sObjectType, 'BGRleadtimeMasterData'); 
        List<BGR_Lead_time_schedule__c> BGRLeadtimescheduleTable = Test.loadData(BGR_Lead_time_schedule__c.sObjectType, 'BGRLeadtimescheduleMasterData'); 

        List<BGR_Masterblaster__c> BGRMasterblasterTable = Test.loadData(BGR_Masterblaster__c.sObjectType, 'BGRMasterblasterMasterData');
        List<BGR_Matlist__c> BGRMatlistTable = Test.loadData(BGR_Matlist__c.sObjectType, 'BGRMatlistMasterData');       		
        
        List<BGR_Price_Details__c> BGRPriceDetailTable = Test.loadData(BGR_Price_Details__c.sObjectType, 'BGRPriceDetailsMasterData');
		List<BGR_Price_Translation__c> BGRPriceTranslationTable = Test.loadData(BGR_Price_Translation__c.sObjectType, 'BGRPriceTranslationMasterData');
        
		List<BGR_Product_document__c> BGRProductdocumentTable = Test.loadData(BGR_Product_document__c.sObjectType, 'BGRProductdocumentMasterData');
        
        //List<BGR_Routing__c> BGRRoutingDetailTable = Test.loadData(BGR_Routing__c.sObjectType, 'WGBRoutingDetailsTestData1');        
        List<BGR_Structures__c> BGRStructuresTable = Test.loadData(BGR_Structures__c.sObjectType, 'BGRStructuresMasterData');
        
        
        List<BGR_WorkGuide_Details__c> BGRWorkGuideDetailsMasterData = Test.loadData(BGR_WorkGuide_Details__c.sObjectType, 'BGRWorkGuideDetailsMasterData');
        List<BGR_WorkGuide_Translation__c> BGRWorkGuidelinesTranslationTable = Test.loadData(BGR_WorkGuide_Translation__c.sObjectType, 'BGRWorkGuideTranslationMasterData');
        
        List<BGR_lead_time__c> BGRLTSList = Test.loadData(BGR_lead_time__c.sObjectType, 'BGRleadtimeMasterData');        
        List<Cost__c> costList = Test.loadData(Cost__c.sObjectType, 'Cost_MasterData'); 
        
        
        List<BGR_Lead_time_schedule__c> BGRLTSLst = new List<BGR_Lead_time_schedule__c>();
        BGR_Lead_time_schedule__c BGRLTS = new BGR_Lead_time_schedule__c();
        BGRLTS.SHLTSTMETHACT__c = 'Test';
        BGRLTS.SHLTSTMETHBDY__c = 'Test';
        //BGRLTS.QtyLL__c = 2;
       // BGRLTS.QtyUL__c = 2;
        BGRLTS.Schedule__c = 'test';
        BGRLTSLst.add(BGRLTS);
        insert BGRLTSLst;
        
       BGR_Routing__c Brd = new BGR_Routing__c();
        Brd.Standard_Operation_Id__c = 'Id';
        Brd.Outside_Operation_Item__c = 'Item';
        Brd.Descr__c = 'Desc';
        Brd.Operation_Number__c = '0005';
		insert Brd;
        
        List<BGR_Outputs__c> BGROutputList1 = new List<BGR_Outputs__c>();
        BGR_Outputs__c BGROutputval = new BGR_Outputs__c();        
        BGROutputval.ATEX__c=10;
        BGROutputval.BGR_Outputs_Relation_Field__c = conBGRQ.Id;
		insert BGROutputval;
        
        
    }
    
   
}