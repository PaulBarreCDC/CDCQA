@isTest
public class TestDataWGBUtility {
    
    public static SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c(); 
    public static WasteGasBurner__c conWGB = new WasteGasBurner__c();
    public static AssyPartDefinition__c conAssyPart = new AssyPartDefinition__c();
    public static Map<String, String> mapWithWGBValues = new Map<String, String>();
    
    public static void createWGBAssyPartRecords(){
               
     //   conAssyPart.Field1__c = quoteLine.Id;
        conAssyPart.ASSYPARTNO__c='V8391B00040055A009Z00001';
        conAssyPart.BRAND__c='Groth';
        conAssyPart.Configurator__c='WGB';
        conAssyPart.Field1__c='D';
        conAssyPart.Field2__c='10';
        conAssyPart.Field3__c='in. water';
        conAssyPart.Field4__c='10000';
        conAssyPart.Field5__c='SCFH';
        conAssyPart.Field6__c='U';
        conAssyPart.Field7__c='8391B';
        conAssyPart.Field8__c='4';
        conAssyPart.Field9__c='5';
        conAssyPart.Field10__c='5';
        conAssyPart.Field11__c='A';
        conAssyPart.Field12__c='Manual';
        conAssyPart.Field13__c='N';
        conAssyPart.Field14__c='N';
        conAssyPart.Field15__c='9';
        conAssyPart.Field16__c='N';
        conAssyPart.Field17__c='Y';
        conAssyPart.Field18__c='N';
        conAssyPart.Field19__c='N';
        conAssyPart.Field20__c='Y';
        conAssyPart.Field21__c='N';
        conAssyPart.Field22__c='';
        conAssyPart.Field23__c='';
        conAssyPart.LeadTimeSchedule__c='';
        conAssyPart.Managed_In__c='Salesforce';
        conAssyPart.PartRevision__c='1';
        conAssyPart.Product_Ref__c='WGB';

        insert conAssyPart; 
                
    }
    
    public static void createWGBTestRecords(){
               
        conWGB.Quote_Line__c = quoteLine.Id;
        conWGB.Pilot_Gas__c='D';
        conWGB.Pilot_Supply_Pressure__c=5;
        conWGB.Pressure_Setting_Units__c='in. water';
        conWGB.Flow_Rate__c=5;
        conWGB.Flow_Rate_Units__c='SCFH';
        conWGB.Certification__c='U';
        conWGB.Select_Model__c='8392B';
        conWGB.Size__c='02';
        conWGB.Pedestal_Connection__c='A';
        conWGB.Ignitor_Control__c='Automatic';
        conWGB.Flame_Sensor__c='D';
        conWGB.Thermocouple_Material__c='1';
        conWGB.Enclosure_Type__c='4';
        conWGB.Control_Panel_Alarm__c='2';
        conWGB.Control_Panel_Heater__c='Y';
        conWGB.Stand_Control_Material__c='5';
        conWGB.Sunshield_Control__c='Y';
        conWGB.Step_Down_Transformer__c='Y';
        conWGB.Back_up_Power_Supply__c='Y';
        conWGB.Upper_Shroud_Stack_Matl__c='5';
        conWGB.Lower_Stack_Pedestal_Matl__c='5';   
        conWGB.IsConfig__c=true;
        insert conWGB; 
       /*
        conWGB.Quote_Line__c = quoteLine.Id;
        
        conWGB.Pilot_Supply_Pressure__c=5;
        conWGB.Pressure_Setting_Units__c='in. water';
        conWGB.Pilot_Gas__c='D';
        conWGB.Flow_Rate__c=5;
        conWGB.Flow_Rate_Units__c='SCFH';
        conWGB.Certification__c='U';
        conWGB.Select_Model__c='8392B';
        conWGB.Size__c='02';
        conWGB.Pedestal_Connection__c='A';
        conWGB.Ignitor_Control__c='Manual';
        conWGB.Flame_Sensor__c='N';
        conWGB.Thermocouple_Material__c='1';
        conWGB.Enclosure_Type__c='4';
        conWGB.Control_Panel_Alarm__c='N';
        conWGB.Control_Panel_Heater__c='N';
        conWGB.Stand_Control_Material__c='N';
        conWGB.Sunshield_Control__c='N';
        conWGB.Step_Down_Transformer__c='N';
        conWGB.Back_up_Power_Supply__c='N';
        conWGB.Upper_Shroud_Stack_Matl__c='5';
        conWGB.Lower_Stack_Pedestal_Matl__c='5';   
        conWGB.IsConfig__c=true;
        insert conWGB;*/
        
        conWGB=[SELECT id,Select_Model__c,Pilot_Gas__c,Flow_Rate__c,Flow_Rate_Units__c,Pressure_Setting__c,Pressure_Setting_Units__c,
        Quantity__c,Size__c,Certification__c,Upper_Shroud_Stack_Matl__c,Lower_Stack_Pedestal_Matl__c,Pedestal_Connection__c,
        Ignitor_Control__c,Flame_Sensor__c,Thermocouple_Material__c,Enclosure_Type__c,Control_Panel_Alarm__c,Control_Panel_Heater__c,
        Stand_Control_Material__c,Sunshield_Control__c,Step_Down_Transformer__c,Back_up_Power_Supply__c,Converted_Flow_Rate__c,
        Converted_Pilot_Supply_Pressure__c,Pilot_Supply_Pressure__c from WasteGasBurner__c limit 1];
                
    }
    
    public static void createWGBMasterTestRecords(){             
        
        List<WGB_Attribute_Lookup_Detail__c> WGBAttributeLookupDetailTable = Test.loadData(WGB_Attribute_Lookup_Detail__c.sObjectType, 'WGBAttributeLookupDetailTestData');
        List<WGB_Attribute_Lookup_Translation__c> WGBAttributeLookupTranslationTable = Test.loadData(WGB_Attribute_Lookup_Translation__c.sObjectType, 'WGBAttributeLookupTranslationTestData');
        
        List<WGB_ControlPlan_Detail__c> WGBControlPlanDetailTable = Test.loadData(WGB_ControlPlan_Detail__c.sObjectType, 'WGBControlPlanDetailsTestData');
        List<WGB_ControlPlan_Translation__c> WGBControlPlanTranslationTable = Test.loadData(WGB_ControlPlan_Translation__c.sObjectType, 'WGBControlPlanTranslationTestData');
        
        List<WGB_Document_Detail__c> WGBDocumentDetailTable = Test.loadData(WGB_Document_Detail__c.sObjectType, 'WGBDocumentDetailsTestData');
        List<WGB_Document_Translation__c> WGBDocumentTranslationTable = Test.loadData(WGB_Document_Translation__c.sObjectType, 'WGBDocumentTranslationTestData');
        
        List<WGB_LeadTime__c> WGBLeadTimeTable = Test.loadData(WGB_LeadTime__c.sObjectType, 'WGBLeadTimeTableTestData');
        
        List<WGB_Price_Detail__c> WGBPriceDetailTable = Test.loadData(WGB_Price_Detail__c.sObjectType, 'WGBPriceDetailsTestData');
        List<WGB_Price_Translation__c> WGBPriceTranslationTable = Test.loadData(WGB_Price_Translation__c.sObjectType, 'WGBPriceTranslationTableTestData');
        
        List<WGB_Routing_Detail__c> WGBRoutingDetailTable = Test.loadData(WGB_Routing_Detail__c.sObjectType, 'WGBRoutingDetailsTestData');
        List<WGB_Routing_Translation__c> WGBRoutingTranslationTable = Test.loadData(WGB_Routing_Translation__c.sObjectType, 'WGBRoutingTranslationTableTestData');
        
        List<WGB_Structure_ComponentDetail__c> WGBStructureComponentDetailTable = Test.loadData(WGB_Structure_ComponentDetail__c.sObjectType, 'WGBStructureComponentDetailsTestData');
        List<WGB_Structure_ComponentTranslation__c> WGBStructureComponentTranslationTable = Test.loadData(WGB_Structure_ComponentTranslation__c.sObjectType, 'WGBStructureComponentTranslationTestData');
        
        List<WGB_Workguideline_Detail__c> WGBWorkGuidelinesDetailTable = Test.loadData(WGB_Workguideline_Detail__c.sObjectType, 'WGBWorkGuidelinesDetailsTestData');
        List<WGB_Workguidelines_Translation__c> WGBWorkGuidelinesTranslationTable = Test.loadData(WGB_Workguidelines_Translation__c.sObjectType, 'WGBWorkGuidelinesTranslationTestData');
        
        List<WGB_LeadTime__c> WGBLTSList = Test.loadData(WGB_LeadTime__c.sObjectType, 'WGBLeadTimeTableTestData');        
        List<Cost__c> costList = Test.loadData(Cost__c.sObjectType, 'Cost_MasterData');
        
        List<WGB_Module_Orifice__c> WGBModuleOrificeTable = Test.loadData(WGB_Module_Orifice__c.sObjectType, 'WGBModuleOrificeTestData');
        List<WGB_Flow_Rate__c> WGBFlowRateTable = Test.loadData(WGB_Flow_Rate__c.sObjectType, 'WGBFlowRateTestData');
        List<WGB_PartParameters_FlowRateDetail__c> WGBPartParametersFlowRateDetail = Test.loadData(WGB_PartParameters_FlowRateDetail__c.sObjectType, 'WGBPartParametersFlowRateDetailTestData');
        
        List<IFS_character_codes__c> WGBIFSCharactersiticsCodeTable = Test.loadData(IFS_character_codes__c.sObjectType, 'WGBIFSCharactersiticsCodeTestData');
        List<Global_Site_Part_Parameters_ISPM__c> GlobalSitePartParametersISPMTable = Test.loadData(Global_Site_Part_Parameters_ISPM__c.sObjectType, 'GlobalSitePartParametersISPMTestData');
        List<Global_Site_Part_Parameters_PPS__c> Global_Site_Part_Parameters_PPSTable = Test.loadData(Global_Site_Part_Parameters_PPS__c.sObjectType, 'GlobalSitePartParametersPPSTestData');
    
        //    List<WGB_Outputs__c> WGBOutputList = Test.loadData(WGB_Outputs__c.sObjectType, 'WGBOutputsTestData');
        List<WGB_Outputs__c> WGBOutputList1 = new List<WGB_Outputs__c>();
        
		WGB_Outputs__c WGBOutputval = new WGB_Outputs__c();   
        
        WGBOutputval.Alarm__c=10;
        WGBOutputval.BackUpPowerSupply__c=10;
        WGBOutputval.Certifications__c=10;
        WGBOutputval.Enclosure__c=10;
        WGBOutputval.FlameSensor__c=10;
        WGBOutputval.Heater__c=10;
        WGBOutputval.Lead_Time_10_Override__c='Test';
        WGBOutputval.Lead_Time_20_Override__c='Test';
        WGBOutputval.Lead_Time_30_Override__c='Test';
        WGBOutputval.Lead_Time_40_Override__c='Test';
        WGBOutputval.OA02__c='Test';
        WGBOutputval.OA03__c='Test';
        WGBOutputval.OA04__c='Test';
        WGBOutputval.OA05__c='Test';
        WGBOutputval.OA06__c='Test';
        WGBOutputval.OA_Override__c='Test';
        WGBOutputval.OB010__c='Test';
        WGBOutputval.OB020__c='Test';
        WGBOutputval.OB030__c='Test';
        WGBOutputval.OB040__c='Test';
        WGBOutputval.OB050__c='Test';
        WGBOutputval.OB060__c='Test';
        WGBOutputval.OB070__c='Test';
        WGBOutputval.OB080__c='Test';
        WGBOutputval.OB090__c='Test';
        WGBOutputval.OB100__c='Test';
        WGBOutputval.OB110__c='Test';                
        WGBOutputval.OB120__c='Test ';
        WGBOutputval.OB130__c='Test ';
        WGBOutputval.OB140__c='Test ';
        WGBOutputval.OB150__c='Test ';
        WGBOutputval.OB160__c='Test ';
        WGBOutputval.OB170__c='Test ';
        WGBOutputval.OB180__c='Test ';
        WGBOutputval.OB190__c='Test ';
        WGBOutputval.OB200__c='Test ';
        WGBOutputval.OB210__c='Test ';
        WGBOutputval.OB220__c='Test ';
        WGBOutputval.OB230__c='Test ';
        WGBOutputval.OB240__c='Test ';
        WGBOutputval.OB250__c='Test ';
        WGBOutputval.OB450__c='Test ';
        WGBOutputval.OB_Override__c='Test ';
        WGBOutputval.WasteGasBurner__c=conWGB.Id;
		insert WGBOutputval;
        
      //  update WGBOutputList1;

        
      /*  for(WGB_Outputs__c WGBOutput: WGBOutputList){
            WGBOutput.ReferenceId__c = conWGB.Id;
           // WGBOutput.WasteGasBurner__c=conWGB.Id;
            WGBOutputList1.add(WGBOutput);
        }
        update WGBOutputList1;*/
        
       /* List<Holder_Price_Output__c> holderPriceOutputList = Test.loadData(Holder_Price_Output__c.sObjectType, 'Holder_Price_Output_MasterData');
        List<Holder_Price_Output__c> holderPriceOutputList1 = new List<Holder_Price_Output__c>();
        
        for(Holder_Price_Output__c holderPriceOutput: holderPriceOutputList){
            holderPriceOutput.Holders__c = conHolder.Id;
            holderPriceOutputList1.add(holderPriceOutput);
        }
        update holderPriceOutputList1;*/
                        

    }
}