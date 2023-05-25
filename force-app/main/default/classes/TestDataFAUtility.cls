@isTest
public class TestDataFAUtility {
    
    public static SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c(); 
    public static Flame_Product__c conProd = new Flame_Product__c();
    public static Map<String, String> mapWithFAValues = new Map<String, String>();
    public static Flame_Product__c conProd2 = new Flame_Product__c();
    
   public static void createFATestRecords(){
               
        conProd2.Quote_Line__c = quoteLine.Id;
        
        //Section A
		conProd2.Mounting__c='In-Line Straight Pipe';
        conProd2.Pipe_Design__c='Open End';
        conProd2.Gas_Group_Code__c=0;
        conProd2.GasGroupDynamic__c='0';
        conProd2.Gas_Group__c='Methane (MESG ≥ 1.14)';
        conProd2.Constrain_Product_Selection_by_Flow__c=true;
       //conProd2.Constraint_Product_Selection_By_Flow__c=true;
        //Section B
        
		conProd2.Max_Allowable_Pressure_Drop__c=4;
        conProd2.Max_Allowable_Pressure_Drop_Units__c='psig';
        conProd2.Required_Flow_Rate__c=1000;
        conProd2.Required_Flow_Rate_Units__c='lb/h';
        conProd2.Flowing_Media__c='Methane';
        conProd2.Ratio_of_Specific_Heats__c=1.32;
        conProd2.Molecular_Weight__c=16.043;
        conProd2.Compressibility_Factor__c=1;
        conProd2.Atmospheric_Pressure__c=14.6959;
        conProd2.Atmospheric_Pressure_Units__c='psia';
        conProd2.Pressure_Units__c='psig';
        conProd2.Temperature_of_flowing_Vapor__c=60;
        conProd2.Temperature_of_flowing_Vapor_Units__c='Deg F';
        conProd2.Pressure_of_flowing_Vapor__c=8;
        conProd2.Pressure_of_flowing_Vapor_Units__c='psig';
        conProd2.Location_of_Flowing_Pressure_Specificati__c='Inlet';
        conProd2.Pressure_Units__c='psig';
        //Section C
     //   conProd2.Certfication_Requirement__c='';
        conProd2.Atex_Certificate_2014_34_EU__c='N';
        conProd2.CU_TR__c='N';
        conProd2.US_Coast_guard__c='N';
        conProd2.NACE__c=false;
        
        //Section D
		conProd2.Operational_Pressure__c=14.7;
        conProd2.Operational_Pressure_Units__c='psia';
        conProd2.Operational_Temperature__c='-4°F to 140°F (-20°C to 60°C)';
      //  conProd2.Operational_Temperature_Units__c='Deflagration';
        conProd2.Arrester_for_Detonation_or_Deflagration__c='Deflagration';
      //  conProd2.Do_you_need_Offset_Bases__c='Both';
        conProd2.Offset_or_Concentric_Bases__c='BothOffCon';
        
        conProd2.Run_Up_Length_A_Input__c=0;
        conProd2.Run_Up_Length_A_Input_Units__c='in';
        conProd2.Run_Up_Length_A_Input__c=0;
        conProd2.Run_Up_Length_A_Input_Units__c='in';
		//Section E        
        conProd2.Connection_Size__c='06';
        conProd2.Element_Size__c='12';
       	conProd2.ESZC__c='12';
      //  string strmodel='';
       // strmodel=[select Description__c from FA_MasterBlaster__c where PTC__c=:'8400A' and SZC__c=:'06'
      //                and ESZC__c=:'12'][0].Description__c;
        conProd2.Model__c='Model: 8400A  6" x 12"';
        conProd2.Size__c='06';
        conProd2.SZC__c='06';
        conProd2.PTC__c='8400A';

        //VF Page Fields
        conProd2.Quantity__c=1;
        conProd2.Drilling__c='W';
        conProd2.Body_Material__c='1';
        conProd2.Housing_Material__c='1';
        conProd2.Element_Material__c='5';
        conProd2.Pallet_Material__c='1';
        conProd2.Diaphragm_Material__c='B';
        conProd2.Pressure_Setting__c='08';
        conProd2.Spring_Range__c='1';
        conProd2.Painting_Coating_Option__c='COAT4';
        conProd2.Inlet_Option_A__c='0';
        conProd2.Inlet_Option_B__c='0';
        conProd2.Inlet_Option_C__c='0';
        conProd2.Outlet_Option_A__c='X';
        conProd2.Outlet_Option_B__c='4';
        conProd2.Outlet_Option_C__c='0';
        conProd2.Radiography__c='All';
        conProd2.Fillet_Weld_Liquid_Dye_Penetrant__c=false;
        conProd2.Positive_Material_Identification__c='N';
        conProd2.Liquid_Dye_Penetrant__c='N';
        conProd2.Ultrasonic_Examination__c=true;
        conProd2.Magnetic_Particle_Examination__c=false;
        conProd2.Brinell_Hardness_Examination__c=false;
        conProd2.Charpy_Impact_Testing__c=false;
        conProd2.Visual_Casting_Examination__c=false;
        conProd2.Intergranular_Corossion_Test__c=false;
        conProd2.Final_Assembly_Location_Requirements__c='00';        
        conProd2.Material_Sourcing_Requirements__c='00';
        conProd2.Part_Number_Base__c='V7658A0312335ARTT00002';
       	conProd2.Part_Number__c='V7658A0312335ARTT00002';
        conProd2.IsConfig__c=true;
        insert conProd2; 
   
        
        conProd2=[SELECT Application_Parameters_flag__c,GasGroupDynamic__c,Arrester_for_Detonation_or_Deflagration__c,ASSYPARTEXISTING__c,ASSYPARTNO__c,
                Atex_Certificate_2014_34_EU__c,Atmospheric_Pressure_Units__c,Atmospheric_Pressure__c,Body_Material__c,Brand__c,
				Brinell_hardness_examination_Backend__c,Brinell_Hardness_Examination__c,Build_Cost_Override__c,Bypass__c,Certfication_Requirement__c,
				Certificate_and_sourcing_flag__c,Certifications_flag__c,Charpy_Impact_Testing_Backend__c,Charpy_Impact_Testing__c,Compressibility_Factor__c,
                Connection_Size__c,Constrain_Product_Selection_by_Flow__c,Converted_Atmospheric_Pressure__c,Converted_Max_Allowable_Pressure_Drop__c,
				Converted_Operational_Pressure__c,Converted_Pressure_of_flowing_Vapor__c,Converted_Required_Flow_Rate__c,Converted_Run_up_Length_A__c,
				Converted_Run_up_Length_B__c,Converted_Temprature_of_flowing_Vapor__c,CriticalPresRatio__c,CU_TR__c,Diaphragm_Material__c,Discountable_Price__c,
				Document_IDs__c,Do_you_have_a_closed_or_open_end_pipe__c,Do_you_need_Offset_Bases__c,Drilling__c,Element_Material__c,Element_Size__c,
				Engineering_Notes__c,ESZC__c,Examination_Option_flag__c,Fillet_Weld_Liquid_Dye_Penetrant_Backend__c,Fillet_Weld_Liquid_Dye_Penetrant__c,
                Final_Assembly_Location_Requirements__c,Flowing_Media__c,Flow_Rate_Units__c,Flow_Rate__c,Gas_Group_Code__c,Gas_Group__c,Housing_Material__c,
				InletFlowPresPSIA__c,Inlet_Option_A__c,Inlet_Option_B__c,Inlet_Option_C__c,Intergranular_Corossion_Test_Backend__c,
                Intergranular_Corossion_Test__c,IsConfig__c,KD__c,LDP_Display_Flag__c,Lead_Time_Override__c,Lead_Time_Site_10__c,Lead_Time_Site_20__c,
				Lead_Time_Site_30__c,Lead_Time_Site_40__c,Liquid_Dye_Penetrant__c,List_Price_Each__c,Location_of_Flowing_Pressure_Specificati__c,
				Magnetic_Particle_Examination_Backend__c,Magnetic_Particle_Examination__c,Material_Sourcing_Requirements__c,Max_Allowable_Pressure_Drop_Units__c,
				Max_Allowable_Pressure_Drop__c,Media_Name__c,MinReqdFlowRateSCFH__c,Model__c,Molecular_Weight__c,Mounting__c,Nace_Backend__c,NACE__c,
				Non_Discountable_Price__c,OA01__c,OA02__c,OA04__c,OA05__c,OA06__c,OA__c,OB010__c,OB020__c,OB030__c,OB040__c,OB050__c,OB110__c,OB120__c,OB210__c,
				OB220__c,OB230__c,OB240__c,OB250__c,OB260__c,OB310__c,OB311__c,OB312__c,OB410__c,OB411__c,OB420__c,OB421__c,OB430__c,OB431__c,OB440__c,OB441__c,
				OB510__c,OB520__c,OB530__c,OB540__c,OB550__c,OB__c,Offset_or_Concentric_Bases__c,Operational_Pressure_Units__c,Operational_Pressure__c,
				Operational_Temperature_Units__c,Operational_Temperature__c,Outlet_Option_A__c,Outlet_Option_B__c,Outlet_Option_C__c,OW110__c,OW120__c,OW130__c,
				OW140__c,OW150__c,OW160__c,OW170__c,OW180__c,OW190__c,OW200__c,OW210__c,OW220__c,OW230__c,OW240__c,OW250__c,OW260__c,OW270__c,OW280__c,OW290__c,
				OW300__c,OW310__c,OW320__c,OW330__c,OW340__c,OW910__c,OW920__c,OW__c,Painting_Coating_Option__c,Pallet_Material__c,PartNumberBase_Flag__c,
				PARTREV__c,Part_Number_Base_Original__c,Part_Number_Base__c,Part_Number__c,PC410__c,PC411__c,PC420__c,PC421__c,PC430__c,PC431__c,PC440__c,
				PC441__c,PC__c,Pipe_Design__c,PMI_Display_Flag__c,Positive_Material_Identification__c,PresRatio__c,Pressure_of_flowing_Vapor_Units__c,
				Pressure_of_flowing_Vapor__c,Pressure_Setting__c,Pressure_Units__c,Price_Engineer_Override__c,Product_Material_and_Options_flag__c,
				Product_Narrowing_flag__c,Product_selection_flag__c,PTC__c,Quantity__c,Quote_Description_Engineer_Override__c,Quote_Line__c,
                Radiography_Display_Flag__c,Radiography__c,Ratio_of_Specific_Heats__c,Required_Flow_Rate_Units__c,Required_Flow_Rate__c,
                Run_Up_Length_A_Input_Units__c,Run_Up_Length_A_Input__c,Run_Up_Length_B_Input_Units__c,Run_Up_Length_B_Input__c,Schedule_BaseLead__c,
				Side_of_FA_whr_flwng_prssur_is_indicated__c,Size__c,Sizing_Flow_Area_flag__c,Spring_Range__c,SystemModstamp,SZC__c,
                Temperature_of_flowing_Vapor_Units__c,Temperature_of_flowing_Vapor__c,Temperature_Units__c,Ultrasonic_Examination_Backend__c,
				Ultrasonic_Examination__c,US_Coast_guard__c,Visual_Casting_Examination_Backend__c,Visual_Casting_Examination__c FROM Flame_Product__c limit 1];
                
    }

   
    public static void createFATestRecords2(){
               
        conProd.Quote_Line__c = quoteLine.Id;
        
        //Section A
		conProd.Mounting__c='End-of-Line';
        conProd.Pipe_Design__c='Open End';
        conProd.Gas_Group_Code__c=2;
        conProd.GasGroupDynamic__c='2';
        conProd.Gas_Group__c='NEC D (MESG > 0.75)';
        conProd.Constrain_Product_Selection_by_Flow__c=false;
      //  conProd.Gas_Group_Code__c=0;
      //  conProd.Gas_Group__c='Methane (MESG ≥ 1.14)';

        //Section B
		/*conProd.Max_Allowable_Pressure_Drop__c=4;
        conProd.Max_Allowable_Pressure_Drop_Units__c='in. water';
        conProd.Required_Flow_Rate__c=1000;
        conProd.Required_Flow_Rate_Units__c='lb/h';
        conProd.Flowing_Media__c='Methane';
        conProd.Ratio_of_Specific_Heats__c=1.32;
        conProd.Molecular_Weight__c=16.043;
        conProd.Compressibility_Factor__c=1;
        conProd.Atmospheric_Pressure__c=14.6959;
        conProd.Atmospheric_Pressure_Units__c='psia';
        conProd.Temperature_of_flowing_Vapor__c=60;
        conProd.Temperature_of_flowing_Vapor_Units__c='Deg F';
        conProd.Pressure_of_flowing_Vapor__c=8;
        conProd.Pressure_of_flowing_Vapor_Units__c='in. water';
        conProd.Location_of_Flowing_Pressure_Specificati__c='Inlet';*/
        //Section C
     //   conProd.Certfication_Requirement__c='';
        conProd.Atex_Certificate_2014_34_EU__c='N';
        conProd.CU_TR__c='N';
        conProd.US_Coast_guard__c='N';
        conProd.NACE__c=false;
        
        //Section D
		conProd.Operational_Pressure__c=14.7;
        conProd.Operational_Pressure_Units__c='psia';
        conProd.Operational_Temperature__c='-4°F to 140°F (-20°C to 60°C)';
      //  conProd.Operational_Temperature_Units__c='Deflagration';
        conProd.Arrester_for_Detonation_or_Deflagration__c='Detonation';
      //  conProd.Do_you_need_Offset_Bases__c='Both';
      //  conProd.Offset_or_Concentric_Bases__c='BothOffCon';
        
      /*  conProd.Run_Up_Length_A_Input__c=0;
        conProd.Run_Up_Length_A_Input_Units__c='in';
        conProd.Run_Up_Length_A_Input__c=0;
        conProd.Run_Up_Length_A_Input_Units__c='in';*/
		//Section E        
        conProd.Connection_Size__c='03';
        conProd.Element_Size__c='12';
        conProd.Model__c='7658A';
        conProd.Size__c='03';
        conProd.PTC__c='7658A';

        //VF Page Fields
        conProd.Quantity__c=1;
        conProd.Drilling__c='A';
        conProd.Body_Material__c='3';
        conProd.Housing_Material__c='3';
        conProd.Element_Material__c='5';
      /*  conProd.Pallet_Material__c='1';
        conProd.Diaphragm_Material__c='B';
        conProd.Pressure_Setting__c='08';
        conProd.Spring_Range__c='1';*/
        conProd.Painting_Coating_Option__c='0';
        conProd.Inlet_Option_A__c='4';
        conProd.Inlet_Option_B__c='4';
        conProd.Inlet_Option_C__c='0';
        conProd.Outlet_Option_A__c='T';
        conProd.Outlet_Option_B__c='2';
        conProd.Outlet_Option_C__c='0';
        conProd.Radiography__c='N';
        conProd.Fillet_Weld_Liquid_Dye_Penetrant__c=false;
        conProd.Positive_Material_Identification__c='N';
        conProd.Liquid_Dye_Penetrant__c='N';
        conProd.Ultrasonic_Examination__c=true;
        conProd.Magnetic_Particle_Examination__c=false;
        conProd.Brinell_Hardness_Examination__c=false;
        conProd.Charpy_Impact_Testing__c=false;
        conProd.Visual_Casting_Examination__c=false;
        conProd.Intergranular_Corossion_Test__c=false;
        conProd.Final_Assembly_Location_Requirements__c='00';        
        conProd.Material_Sourcing_Requirements__c='00';
        conProd.Lead_Time_Site_10__c=10;
        conProd.Lead_Time_Site_20__c=10;
        conProd.Lead_Time_Site_30__c=10;
        conProd.Lead_Time_Site_40__c=10;
        conProd.IsConfig__c=true;
        conProd2.Part_Number_Base__c='V7658A0312335ARTT00002';
       	conProd2.Part_Number__c='V7658A0312335ARTT00002';
        insert conProd; 
   
        
        conProd=[SELECT Application_Parameters_flag__c,GasGroupDynamic__c,Arrester_for_Detonation_or_Deflagration__c,ASSYPARTEXISTING__c,ASSYPARTNO__c,
                Atex_Certificate_2014_34_EU__c,Atmospheric_Pressure_Units__c,Atmospheric_Pressure__c,Body_Material__c,Brand__c,
				Brinell_hardness_examination_Backend__c,Brinell_Hardness_Examination__c,Build_Cost_Override__c,Bypass__c,Certfication_Requirement__c,
				Certificate_and_sourcing_flag__c,Certifications_flag__c,Charpy_Impact_Testing_Backend__c,Charpy_Impact_Testing__c,Compressibility_Factor__c,
                Connection_Size__c,Constrain_Product_Selection_by_Flow__c,Converted_Atmospheric_Pressure__c,Converted_Max_Allowable_Pressure_Drop__c,
				Converted_Operational_Pressure__c,Converted_Pressure_of_flowing_Vapor__c,Converted_Required_Flow_Rate__c,Converted_Run_up_Length_A__c,
				Converted_Run_up_Length_B__c,Converted_Temprature_of_flowing_Vapor__c,CriticalPresRatio__c,CU_TR__c,Diaphragm_Material__c,Discountable_Price__c,
				Document_IDs__c,Do_you_have_a_closed_or_open_end_pipe__c,Do_you_need_Offset_Bases__c,Drilling__c,Element_Material__c,Element_Size__c,
				Engineering_Notes__c,ESZC__c,Examination_Option_flag__c,Fillet_Weld_Liquid_Dye_Penetrant_Backend__c,Fillet_Weld_Liquid_Dye_Penetrant__c,
                Final_Assembly_Location_Requirements__c,Flowing_Media__c,Flow_Rate_Units__c,Flow_Rate__c,Gas_Group_Code__c,Gas_Group__c,Housing_Material__c,
				InletFlowPresPSIA__c,Inlet_Option_A__c,Inlet_Option_B__c,Inlet_Option_C__c,Intergranular_Corossion_Test_Backend__c,
                Intergranular_Corossion_Test__c,IsConfig__c,KD__c,LDP_Display_Flag__c,Lead_Time_Override__c,Lead_Time_Site_10__c,Lead_Time_Site_20__c,
				Lead_Time_Site_30__c,Lead_Time_Site_40__c,Liquid_Dye_Penetrant__c,List_Price_Each__c,Location_of_Flowing_Pressure_Specificati__c,
				Magnetic_Particle_Examination_Backend__c,Magnetic_Particle_Examination__c,Material_Sourcing_Requirements__c,Max_Allowable_Pressure_Drop_Units__c,
				Max_Allowable_Pressure_Drop__c,Media_Name__c,MinReqdFlowRateSCFH__c,Model__c,Molecular_Weight__c,Mounting__c,Nace_Backend__c,NACE__c,
				Non_Discountable_Price__c,OA01__c,OA02__c,OA04__c,OA05__c,OA06__c,OA__c,OB010__c,OB020__c,OB030__c,OB040__c,OB050__c,OB110__c,OB120__c,OB210__c,
				OB220__c,OB230__c,OB240__c,OB250__c,OB260__c,OB310__c,OB311__c,OB312__c,OB410__c,OB411__c,OB420__c,OB421__c,OB430__c,OB431__c,OB440__c,OB441__c,
				OB510__c,OB520__c,OB530__c,OB540__c,OB550__c,OB__c,Offset_or_Concentric_Bases__c,Operational_Pressure_Units__c,Operational_Pressure__c,
				Operational_Temperature_Units__c,Operational_Temperature__c,Outlet_Option_A__c,Outlet_Option_B__c,Outlet_Option_C__c,OW110__c,OW120__c,OW130__c,
				OW140__c,OW150__c,OW160__c,OW170__c,OW180__c,OW190__c,OW200__c,OW210__c,OW220__c,OW230__c,OW240__c,OW250__c,OW260__c,OW270__c,OW280__c,OW290__c,
				OW300__c,OW310__c,OW320__c,OW330__c,OW340__c,OW910__c,OW920__c,OW__c,Painting_Coating_Option__c,Pallet_Material__c,PartNumberBase_Flag__c,
				PARTREV__c,Part_Number_Base_Original__c,Part_Number_Base__c,Part_Number__c,PC410__c,PC411__c,PC420__c,PC421__c,PC430__c,PC431__c,PC440__c,
				PC441__c,PC__c,Pipe_Design__c,PMI_Display_Flag__c,Positive_Material_Identification__c,PresRatio__c,Pressure_of_flowing_Vapor_Units__c,
				Pressure_of_flowing_Vapor__c,Pressure_Setting__c,Pressure_Units__c,Price_Engineer_Override__c,Product_Material_and_Options_flag__c,
				Product_Narrowing_flag__c,Product_selection_flag__c,PTC__c,Quantity__c,Quote_Description_Engineer_Override__c,Quote_Line__c,
                Radiography_Display_Flag__c,Radiography__c,Ratio_of_Specific_Heats__c,Required_Flow_Rate_Units__c,Required_Flow_Rate__c,
                Run_Up_Length_A_Input_Units__c,Run_Up_Length_A_Input__c,Run_Up_Length_B_Input_Units__c,Run_Up_Length_B_Input__c,Schedule_BaseLead__c,
				Side_of_FA_whr_flwng_prssur_is_indicated__c,Size__c,Sizing_Flow_Area_flag__c,Spring_Range__c,SystemModstamp,SZC__c,
                Temperature_of_flowing_Vapor_Units__c,Temperature_of_flowing_Vapor__c,Temperature_Units__c,Ultrasonic_Examination_Backend__c,
				Ultrasonic_Examination__c,US_Coast_guard__c,Visual_Casting_Examination_Backend__c,Visual_Casting_Examination__c FROM Flame_Product__c limit 1];
                
    }
    
     public static void createFAMasterTestRecords(){             
        
        List<FA_Attributes_Details__c> FAAttributeLookupDetailTable = Test.loadData(FA_Attributes_Details__c.sObjectType, 'FAAttributesDetailsTestData');
        List<FA_Attributes_Translation__c> FAAttributeLookupTranslationTable = Test.loadData(FA_Attributes_Translation__c.sObjectType, 'FAAttributesTranslationTestData');
        
        List<FA_ControlPlan_Details__c> FAControlPlanDetailTable = Test.loadData(FA_ControlPlan_Details__c.sObjectType, 'FAControlPlanDetailsTestData');
        List<FA_ControlPlan_Translation__c> FAControlPlanTranslationTable = Test.loadData(FA_ControlPlan_Translation__c.sObjectType, 'FAControlPlanTranslationTestData');
        
        List<FA_Document_Details__c> FADocumentDetailTable = Test.loadData(FA_Document_Details__c.sObjectType, 'FADocumentDetailsTestData');
        List<FA_Document_Translation__c> FADocumentTranslationTable = Test.loadData(FA_Document_Translation__c.sObjectType, 'FADocumentTranslationTestData');
        
        List<GlobalLeadTime__c> FAGlobalLeadTimeTable = Test.loadData(GlobalLeadTime__c.sObjectType, 'FAGlobalLeadTimeTestData');
        List<FA_Lead_Time_Details__c> FALeadDetailTable = Test.loadData(FA_Lead_Time_Details__c.sObjectType, 'FALeadTimeDetailsTestData');
        List<FA_Lead_Time_Translation__c> FALeadTranslationTable = Test.loadData(FA_Lead_Time_Translation__c.sObjectType, 'FALeadTimeTranslationTestData');
         
        List<FA_Price_Details__c> FAPriceDetailTable = Test.loadData(FA_Price_Details__c.sObjectType, 'FAPriceDetailsTestData');
        List<FA_Price_Translation__c> FAPriceTranslationTable = Test.loadData(FA_Price_Translation__c.sObjectType, 'FAPriceTranslationTestData');
        
        List<FA_Routing_Details__c> FARoutingDetailTable = Test.loadData(FA_Routing_Details__c.sObjectType, 'FARoutingDetailsTestData');
        List<FA_Routing_Translation__c> FARoutingTranslationTable = Test.loadData(FA_Routing_Translation__c.sObjectType, 'FARoutingTranslationTestData');
        
        List<FA_Structure_Details__c> FAStructureComponentDetailTable = Test.loadData(FA_Structure_Details__c.sObjectType, 'FAStructureDetailsTestData');
        List<FA_Structure_Translation__c> FAStructureComponentTranslationTable = Test.loadData(FA_Structure_Translation__c.sObjectType, 'FAStructureTranslationTestData');
        
        List<FA_Work_Guidelines_Details__c> FAWorkGuidelinesDetailTable = Test.loadData(FA_Work_Guidelines_Details__c.sObjectType, 'FAWorkGuidelinesDetailsTestData');
        List<FA_Work_Guidelines_Translation__c> FAWorkGuidelinesTranslationTable = Test.loadData(FA_Work_Guidelines_Translation__c.sObjectType, 'FAWorkGuidelinesTranslationTestData');
        
      //  List<Cost__c> costList = Test.loadData(Cost__c.sObjectType, 'Cost_MasterData');
    //    List<Cost__c> costList2 = Test.loadData(Cost__c.sObjectType, 'Cost_TestData');
        Cost__c cost1 = new Cost__c();
        cost1.Cost_Method__c='Assembly';
        cost1.Cost_Sub_Type__c='Router';
        cost1.Inside_Cost_10__c='10';
        cost1.Inside_Cost_20__c='10';
        cost1.Inside_Cost_30__c='10';
        cost1.Inside_Cost_Override_10__c='10';
        cost1.Inside_Cost_Override_20__c='10';
        cost1.Inside_Cost_Override_30__c='10';
        cost1.Outside_Cost_10__c='10';
        cost1.Outside_Cost_20__c='10';
        cost1.Outside_Cost_30__c='10';
        cost1.Outside_Cost_Override_10__c='10';
        cost1.Outside_Cost_Override_20__c='10';
        cost1.Outside_Cost_Override_30__c='10';
        cost1.Part_Number__c='V7658A0312335ARTT00002';
        cost1.Product__c='WGB';
		insert cost1;
        
        Cost__c cost2 = new Cost__c();
        cost2.Cost_Method__c='Assembly';
        cost2.Cost_Sub_Type__c='Router';
        cost2.Inside_Cost_10__c='10';
        cost2.Inside_Cost_20__c='10';
        cost2.Inside_Cost_30__c='10';
        cost2.Inside_Cost_Override_10__c='10';
        cost2.Inside_Cost_Override_20__c='10';
        cost2.Inside_Cost_Override_30__c='10';
        cost2.Outside_Cost_10__c='10';
        cost2.Outside_Cost_20__c='10';
        cost2.Outside_Cost_30__c='10';
        cost2.Outside_Cost_Override_10__c='10';
        cost2.Outside_Cost_Override_20__c='10';
        cost2.Outside_Cost_Override_30__c='10';
        cost2.Part_Number__c='V7658A0312335ARTT00002';
        cost2.Product__c='WGB';
		insert cost2;
        
        Cost__c cost3 = new Cost__c();
        cost3.Cost_Method__c='Assembly';
        cost3.Cost_Sub_Type__c='Router';
        cost3.Inside_Cost_10__c='10';
        cost3.Inside_Cost_20__c='10';
        cost3.Inside_Cost_30__c='10';
        cost3.Inside_Cost_Override_10__c='10';
        cost3.Inside_Cost_Override_20__c='10';
        cost3.Inside_Cost_Override_30__c='10';
        cost3.Outside_Cost_10__c='10';
        cost3.Outside_Cost_20__c='10';
        cost3.Outside_Cost_30__c='10';
        cost3.Outside_Cost_Override_10__c='10';
        cost3.Outside_Cost_Override_20__c='10';
        cost3.Outside_Cost_Override_30__c='10';
        cost3.Part_Number__c='V7658A0312335ARTT00002';
        cost3.Product__c='WGB';
		insert cost3;
         
		List<RD_Cost__c> costRDCost = Test.loadData(RD_Cost__c.sObjectType, 'Cost_RDCost'); 
        List<Cost_Part_Number__c> costPartNumber = Test.loadData(Cost_Part_Number__c.sObjectType, 'Cost_CostPartNumber'); 
        List<Cost_Routing_Outside__c> costRoutingOutside = Test.loadData(Cost_Routing_Outside__c.sObjectType, 'Cost_Cost_Routing_Outside'); 
        List<Cost_Routing_Inside__c> costRoutingInside = Test.loadData(Cost_Routing_Inside__c.sObjectType, 'Cost_Cost_Routing_Inside'); 
         
        List<FA_Input_Attr_Value_Desc__c> FA_Input_Attr_Value_DescTable = Test.loadData(FA_Input_Attr_Value_Desc__c.sObjectType, 'FA_Input_Attr_Value_DescTestData');
        List<FA_HCLASS_Cons__c> FA_HCLASS_ConsTable = Test.loadData(FA_HCLASS_Cons__c.sObjectType, 'FA_HCLASS_ConsTestData');
        List<FA_MATL_Cons__c> FA_MATL_ConsTable = Test.loadData(FA_MATL_Cons__c.sObjectType, 'FA_MATL_ConsTestData');
        List<FA_PORTS_Cons__c> FA_PORTS_ConsTable = Test.loadData(FA_PORTS_Cons__c.sObjectType, 'FA_PORTS_ConsTestData');
        List<FA_SPRING_Cons__c> FA_SPRING_ConsTable = Test.loadData(FA_SPRING_Cons__c.sObjectType, 'FA_SPRING_ConsTestData');
        List<FA_EXMOMC_Cons__c> FA_EXMOMC_ConsTable = Test.loadData(FA_EXMOMC_Cons__c.sObjectType, 'FA_EXMOMC_ConsTestData');
        List<FA_EXMOPTC_Cons__c> FA_EXMOPTC_ConsTable = Test.loadData(FA_EXMOPTC_Cons__c.sObjectType, 'FA_EXMOPTC_ConsTestData');
        
        List<IFS_character_codes__c> FAIFSCharactersiticsCodeTable = Test.loadData(IFS_character_codes__c.sObjectType, 'FAIFSCharactersiticsCodeTestData');
        List<Global_Site_Part_Parameters_ISPM__c> GlobalSitePartParametersISPMTable = Test.loadData(Global_Site_Part_Parameters_ISPM__c.sObjectType, 'GlobalSitePartParametersISPMTestData');
        List<Global_Site_Part_Parameters_PPS__c> Global_Site_Part_Parameters_PPSTable = Test.loadData(Global_Site_Part_Parameters_PPS__c.sObjectType, 'GlobalSitePartParametersPPSTestData');
    
        List<Pressure__c> data8 = Test.loadData(Pressure__c.sObjectType, 'TestData_PressureTable');
        List<Temparature__c> data9 = Test.loadData(Temparature__c.sObjectType, 'TestData_TemperatureTable');
        List<Distance__c> data4 = Test.loadData(Distance__c.sObjectType, 'TestData_DistanceTable');
      	List<GasFlowRate__c> data10 = Test.loadData(GasFlowRate__c.sObjectType, 'TestData_GasFlowRateTable');
        List<Media_Property__c> MediaPropertyTable = Test.loadData(Media_Property__c.sObjectType, 'MediaPropertyTestData'); 
        List<FA_MasterBlaster__c> FAMasterBlasterTable = Test.loadData(FA_MasterBlaster__c.sObjectType, 'FAMasterBlasterTestData');   
        List<FA_KD__c> FAKDTable = Test.loadData(FA_KD__c.sObjectType, 'FAKDTestData');   
         
        
        //    List<FA_Outputs__c> FAOutputList = Test.loadData(FA_Outputs__c.sObjectType, 'FAOutputsTestData');
        List<FA_Output__c> FAOutputList1 = new List<FA_Output__c>();
        
		FA_Output__c FAOutputval = new FA_Output__c();        
        FAOutputval.Base_10__c=10;
        FAOutputval.Base_20__c=10;
        FAOutputval.Base_30__c=10;
        FAOutputval.Base_40__c=10;
        FAOutputval.BrinnelHardnessExam_10__c=10;
        FAOutputval.BrinnelHardnessExam_20__c=10;
        FAOutputval.BrinnelHardnessExam_30__c=10;
        FAOutputval.BrinnelHardnessExam_40__c=10;
        FAOutputval.BrinnellHardnessExamination__c=10;
        FAOutputval.CharpyImpactTesting__c=10;
        FAOutputval.CharpyImpactTest_10__c=10;
        FAOutputval.CharpyImpactTest_20__c=10;
        FAOutputval.CharpyImpactTest_30__c=10;
        FAOutputval.CharpyImpactTest_40__c=10;
        FAOutputval.FilletWeldLiquidDyePenetrantExamination__c=10;
        FAOutputval.FilWeldLiqDyePenExam_10__c=10;
        FAOutputval.FilWeldLiqDyePenExam_20__c=10;
        FAOutputval.FilWeldLiqDyePenExam_30__c=10;
        FAOutputval.FilWeldLiqDyePenExam_40__c=10;
        FAOutputval.InletOptionPriceAdder__c=10;
        FAOutputval.InletTWellTCouplePriceAdder__c=10;
        FAOutputval.IntergranularCorrosionTesting_10__c=10;
        FAOutputval.IntergranularCorrosionTesting_20__c=10;
        FAOutputval.IntergranularCorrosionTesting_30__c=10;
        FAOutputval.IntergranularCorrosionTesting_40__c=10;
        FAOutputval.IntergranularCorrosionTesting__c=10;
        FAOutputval.LiquidDyePenetrantExamination_10__c=10;
        FAOutputval.LiquidDyePenetrantExamination_20__c=10;
        FAOutputval.LiquidDyePenetrantExamination_30__c=10;
        FAOutputval.LiquidDyePenetrantExamination_40__c=10;
        FAOutputval.LiquidDyePenetrantExamination__c=10;
        FAOutputval.MagneticParticleExamination__c=10;
        FAOutputval.MagParticleExam_10__c=10;
        FAOutputval.MagParticleExam_20__c=10;
        FAOutputval.MagParticleExam_30__c=10;
        FAOutputval.MagParticleExam_40__c=10;
        FAOutputval.MaterialSourceRestrictions_10__c=10;
        FAOutputval.MaterialSourceRestrictions_20__c=10;
        FAOutputval.MaterialSourceRestrictions_30__c=10;
        FAOutputval.MaterialSourceRestrictions_40__c=10;
        FAOutputval.MaterialSourcing__c=10;
        FAOutputval.ModelBase__c=10;
        FAOutputval.OA01__c='Test';
        FAOutputval.OA02__c='Test';
        FAOutputval.OA04__c='Test';
        FAOutputval.OA05__c='Test';
        FAOutputval.OA06__c='Test';
        FAOutputval.OA_Override__c='Test';
        FAOutputval.OB010__c='Test';
        FAOutputval.OB020__c='Test';
        FAOutputval.OB030__c='Test';
        FAOutputval.OB040__c='Test';
        FAOutputval.OB050__c='Test';
        FAOutputval.OB110__c='Test';
        FAOutputval.OB120__c='Test';
        FAOutputval.OB210__c='Test';
        FAOutputval.OB220__c='Test';
        FAOutputval.OB230__c='Test';
        FAOutputval.OB240__c='Test';
        FAOutputval.OB250__c='Test';
        FAOutputval.OB260__c='Test';
        FAOutputval.OB310__c='Test';
        FAOutputval.OB311__c='Test';
        FAOutputval.OB312__c='Test';
        FAOutputval.OB410__c='Test';
        FAOutputval.OB411__c='Test';
        FAOutputval.OB420__c='Test';
        FAOutputval.OB421__c='Test';
        FAOutputval.OB430__c='Test';
        FAOutputval.OB431__c='Test';
        FAOutputval.OB440__c='Test';
        FAOutputval.OB441__c='Test';
        FAOutputval.OB510__c='Test';
        FAOutputval.OB520__c='Test';
        FAOutputval.OB530__c='Test';
        FAOutputval.OB540__c='Test';
        FAOutputval.OB550__c='Test';
        FAOutputval.OB_Override__c='Test';
        FAOutputval.OutletOptionPriceAdder__c=10;
        FAOutputval.OutletTWellTCouplePriceAdder__c=10;
       	FAOutputval.OW110__c='Test';
        FAOutputval.OW120__c='Test';
        FAOutputval.OW130__c='Test';
        FAOutputval.OW140__c='Test';
        FAOutputval.OW150__c='Test';
        FAOutputval.OW160__c='Test';
        FAOutputval.OW170__c='Test';
        FAOutputval.OW180__c='Test';
        FAOutputval.OW190__c='Test';
        FAOutputval.OW200__c='Test';
        FAOutputval.OW210__c='Test';
        FAOutputval.OW220__c='Test';
        FAOutputval.OW230__c='Test';
        FAOutputval.OW240__c='Test';
        FAOutputval.OW250__c='Test';
        FAOutputval.OW260__c='Test';
        FAOutputval.OW270__c='Test';
        FAOutputval.OW280__c='Test';
        FAOutputval.OW290__c='Test';
        FAOutputval.OW300__c='Test';
        FAOutputval.OW310__c='Test';
        FAOutputval.OW320__c='Test';
        FAOutputval.OW330__c='Test';
        FAOutputval.OW340__c='Test';
        FAOutputval.OW910__c='Test';
        FAOutputval.OW920__c='Test';
        FAOutputval.OW_Override__c='Test';
        FAOutputval.PaintingCoating__c=10;
        FAOutputval.Painting_10__c=10;
        FAOutputval.Painting_20__c=10;
        FAOutputval.Painting_30__c=10;
        FAOutputval.Painting_40__c=10;
        FAOutputval.PaintOptions__c=10;
        FAOutputval.PC_Override__c='Test';
        FAOutputval.PositiveMaterialIdentification_10__c=10;
        FAOutputval.PositiveMaterialIdentification_20__c=10;
        FAOutputval.PositiveMaterialIdentification_30__c=10;
        FAOutputval.PositiveMaterialIdentification_40__c=10;
        FAOutputval.PositiveMaterialIdentification__c=10;
        FAOutputval.Price_Total__c=10;
        FAOutputval.Queue_Time_10__c=10;
        FAOutputval.Queue_Time_20__c=10;
        FAOutputval.Queue_Time_30__c=10;
        FAOutputval.Queue_Time_40__c=10;
        FAOutputval.RadiographicExamination__c=10;
        FAOutputval.Radiography_10__c=10;
        FAOutputval.Radiography_20__c=10;
        FAOutputval.Radiography_30__c=10;
        FAOutputval.Radiography_40__c=10;
        FAOutputval.Spring__c=10;
        FAOutputval.UltrasonicExamination__c=10;
        FAOutputval.UltrasonicExam_10__c=10;
        FAOutputval.UltrasonicExam_20__c=10;
        FAOutputval.UltrasonicExam_30__c=10;
        FAOutputval.UltrasonicExam_40__c=10;
        FAOutputval.VisualCastingExamination_10__c=10;
        FAOutputval.VisualCastingExamination_20__c=10;
        FAOutputval.VisualCastingExamination_30__c=10;
        FAOutputval.VisualCastingExamination_40__c=10;
        FAOutputval.VisualCastingExamination__c=10;

		FAOutputval.FA_Output_Relation_Field__c=conProd2.Id;
		insert FAOutputval;
        
      //  update FAOutputList1;                        
    }
    
    public static void createFAMasterTestRecords2(){             
        
        List<FA_Attributes_Details__c> FAAttributeLookupDetailTable = Test.loadData(FA_Attributes_Details__c.sObjectType, 'FAAttributesDetailsTestData');
        List<FA_Attributes_Translation__c> FAAttributeLookupTranslationTable = Test.loadData(FA_Attributes_Translation__c.sObjectType, 'FAAttributesTranslationTestData');
        
        List<FA_ControlPlan_Details__c> FAControlPlanDetailTable = Test.loadData(FA_ControlPlan_Details__c.sObjectType, 'FAControlPlanDetailsTestData');
        List<FA_ControlPlan_Translation__c> FAControlPlanTranslationTable = Test.loadData(FA_ControlPlan_Translation__c.sObjectType, 'FAControlPlanTranslationTestData');
        
        List<FA_Document_Details__c> FADocumentDetailTable = Test.loadData(FA_Document_Details__c.sObjectType, 'FADocumentDetailsTestData');
        List<FA_Document_Translation__c> FADocumentTranslationTable = Test.loadData(FA_Document_Translation__c.sObjectType, 'FADocumentTranslationTestData');
        
        List<GlobalLeadTime__c> FAGlobalLeadTimeTable = Test.loadData(GlobalLeadTime__c.sObjectType, 'FAGlobalLeadTimeTestData2');
        List<FA_Lead_Time_Details__c> FALeadDetailTable = Test.loadData(FA_Lead_Time_Details__c.sObjectType, 'FALeadTimeDetailsTestData2');
        List<FA_Lead_Time_Translation__c> FALeadTranslationTable = Test.loadData(FA_Lead_Time_Translation__c.sObjectType, 'FALeadTimeTranslationTestData');
         
        List<FA_Price_Details__c> FAPriceDetailTable = Test.loadData(FA_Price_Details__c.sObjectType, 'FAPriceDetailsTestData');
        List<FA_Price_Translation__c> FAPriceTranslationTable = Test.loadData(FA_Price_Translation__c.sObjectType, 'FAPriceTranslationTestData');
        
        List<FA_Routing_Details__c> FARoutingDetailTable = Test.loadData(FA_Routing_Details__c.sObjectType, 'FARoutingDetailsTestData');
        List<FA_Routing_Translation__c> FARoutingTranslationTable = Test.loadData(FA_Routing_Translation__c.sObjectType, 'FARoutingTranslationTestData');
        
        List<FA_Structure_Details__c> FAStructureComponentDetailTable = Test.loadData(FA_Structure_Details__c.sObjectType, 'FAStructureDetailsTestData');
        List<FA_Structure_Translation__c> FAStructureComponentTranslationTable = Test.loadData(FA_Structure_Translation__c.sObjectType, 'FAStructureTranslationTestData');
        
        List<FA_Work_Guidelines_Details__c> FAWorkGuidelinesDetailTable = Test.loadData(FA_Work_Guidelines_Details__c.sObjectType, 'FAWorkGuidelinesDetailsTestData');
        List<FA_Work_Guidelines_Translation__c> FAWorkGuidelinesTranslationTable = Test.loadData(FA_Work_Guidelines_Translation__c.sObjectType, 'FAWorkGuidelinesTranslationTestData');
        
     //   List<Cost__c> costList = Test.loadData(Cost__c.sObjectType, 'Cost_MasterData');
     //   List<Cost__c> costList2 = Test.loadData(Cost__c.sObjectType, 'Cost_TestData');
        Cost__c cost1 = new Cost__c();
        cost1.Cost_Method__c='Assembly';
        cost1.Cost_Sub_Type__c='Router';
        cost1.Inside_Cost_10__c='10';
        cost1.Inside_Cost_20__c='10';
        cost1.Inside_Cost_30__c='10';
        cost1.Inside_Cost_Override_10__c='10';
        cost1.Inside_Cost_Override_20__c='10';
        cost1.Inside_Cost_Override_30__c='10';
        cost1.Outside_Cost_10__c='10';
        cost1.Outside_Cost_20__c='10';
        cost1.Outside_Cost_30__c='10';
        cost1.Outside_Cost_Override_10__c='10';
        cost1.Outside_Cost_Override_20__c='10';
        cost1.Outside_Cost_Override_30__c='10';
        cost1.Part_Number__c='V7658A0312335ARTT00002';
        cost1.Product__c='WGB';
		insert cost1;
        
        Cost__c cost2 = new Cost__c();
        cost2.Cost_Method__c='Assembly';
        cost2.Cost_Sub_Type__c='Router';
        cost2.Inside_Cost_10__c='10';
        cost2.Inside_Cost_20__c='10';
        cost2.Inside_Cost_30__c='10';
        cost2.Inside_Cost_Override_10__c='10';
        cost2.Inside_Cost_Override_20__c='10';
        cost2.Inside_Cost_Override_30__c='10';
        cost2.Outside_Cost_10__c='10';
        cost2.Outside_Cost_20__c='10';
        cost2.Outside_Cost_30__c='10';
        cost2.Outside_Cost_Override_10__c='10';
        cost2.Outside_Cost_Override_20__c='10';
        cost2.Outside_Cost_Override_30__c='10';
        cost2.Part_Number__c='V7658A0312335ARTT00002';
        cost2.Product__c='WGB';
		insert cost2;
        
        Cost__c cost3 = new Cost__c();
        cost3.Cost_Method__c='Assembly';
        cost3.Cost_Sub_Type__c='Router';
        cost3.Inside_Cost_10__c='10';
        cost3.Inside_Cost_20__c='10';
        cost3.Inside_Cost_30__c='10';
        cost3.Inside_Cost_Override_10__c='10';
        cost3.Inside_Cost_Override_20__c='10';
        cost3.Inside_Cost_Override_30__c='10';
        cost3.Outside_Cost_10__c='10';
        cost3.Outside_Cost_20__c='10';
        cost3.Outside_Cost_30__c='10';
        cost3.Outside_Cost_Override_10__c='10';
        cost3.Outside_Cost_Override_20__c='10';
        cost3.Outside_Cost_Override_30__c='10';
        cost3.Part_Number__c='V7658A0312335ARTT00002';
        cost3.Product__c='WGB';
		insert cost3;
        
		List<RD_Cost__c> costRDCost = Test.loadData(RD_Cost__c.sObjectType, 'Cost_RDCost'); 
        List<Cost_Part_Number__c> costPartNumber = Test.loadData(Cost_Part_Number__c.sObjectType, 'Cost_CostPartNumber'); 
        List<Cost_Routing_Outside__c> costRoutingOutside = Test.loadData(Cost_Routing_Outside__c.sObjectType, 'Cost_Cost_Routing_Outside'); 
        List<Cost_Routing_Inside__c> costRoutingInside = Test.loadData(Cost_Routing_Inside__c.sObjectType, 'Cost_Cost_Routing_Inside'); 
        
        List<FA_Input_Attr_Value_Desc__c> FA_Input_Attr_Value_DescTable = Test.loadData(FA_Input_Attr_Value_Desc__c.sObjectType, 'FA_Input_Attr_Value_DescTestData');
        List<FA_HCLASS_Cons__c> FA_HCLASS_ConsTable = Test.loadData(FA_HCLASS_Cons__c.sObjectType, 'FA_HCLASS_ConsTestData');
        List<FA_MATL_Cons__c> FA_MATL_ConsTable = Test.loadData(FA_MATL_Cons__c.sObjectType, 'FA_MATL_ConsTestData');
        List<FA_PORTS_Cons__c> FA_PORTS_ConsTable = Test.loadData(FA_PORTS_Cons__c.sObjectType, 'FA_PORTS_ConsTestData');
        List<FA_SPRING_Cons__c> FA_SPRING_ConsTable = Test.loadData(FA_SPRING_Cons__c.sObjectType, 'FA_SPRING_ConsTestData');
        List<FA_EXMOMC_Cons__c> FA_EXMOMC_ConsTable = Test.loadData(FA_EXMOMC_Cons__c.sObjectType, 'FA_EXMOMC_ConsTestData');
        List<FA_EXMOPTC_Cons__c> FA_EXMOPTC_ConsTable = Test.loadData(FA_EXMOPTC_Cons__c.sObjectType, 'FA_EXMOPTC_ConsTestData');
        
        List<IFS_character_codes__c> FAIFSCharactersiticsCodeTable = Test.loadData(IFS_character_codes__c.sObjectType, 'FAIFSCharactersiticsCodeTestData');
        List<Global_Site_Part_Parameters_ISPM__c> GlobalSitePartParametersISPMTable = Test.loadData(Global_Site_Part_Parameters_ISPM__c.sObjectType, 'GlobalSitePartParametersISPMTestData');
        List<Global_Site_Part_Parameters_PPS__c> Global_Site_Part_Parameters_PPSTable = Test.loadData(Global_Site_Part_Parameters_PPS__c.sObjectType, 'GlobalSitePartParametersPPSTestData');
    
        List<Pressure__c> data8 = Test.loadData(Pressure__c.sObjectType, 'TestData_PressureTable');
        List<Temparature__c> data9 = Test.loadData(Temparature__c.sObjectType, 'TestData_TemperatureTable');
        List<Distance__c> data4 = Test.loadData(Distance__c.sObjectType, 'TestData_DistanceTable');
      	List<GasFlowRate__c> data10 = Test.loadData(GasFlowRate__c.sObjectType, 'TestData_GasFlowRateTable');
        List<Media_Property__c> MediaPropertyTable = Test.loadData(Media_Property__c.sObjectType, 'MediaPropertyTestData');        

        //    List<FA_Outputs__c> FAOutputList = Test.loadData(FA_Outputs__c.sObjectType, 'FAOutputsTestData');
        List<FA_Output__c> FAOutputList1 = new List<FA_Output__c>();
        
		FA_Output__c FAOutputval = new FA_Output__c();        
        FAOutputval.Base_10__c=10;
        FAOutputval.Base_20__c=10;
        FAOutputval.Base_30__c=10;
        FAOutputval.Base_40__c=10;
        FAOutputval.BrinnelHardnessExam_10__c=10;
        FAOutputval.BrinnelHardnessExam_20__c=10;
        FAOutputval.BrinnelHardnessExam_30__c=10;
        FAOutputval.BrinnelHardnessExam_40__c=10;
        FAOutputval.BrinnellHardnessExamination__c=10;
        FAOutputval.CharpyImpactTesting__c=10;
        FAOutputval.CharpyImpactTest_10__c=10;
        FAOutputval.CharpyImpactTest_20__c=10;
        FAOutputval.CharpyImpactTest_30__c=10;
        FAOutputval.CharpyImpactTest_40__c=10;
        FAOutputval.FilletWeldLiquidDyePenetrantExamination__c=10;
        FAOutputval.FilWeldLiqDyePenExam_10__c=10;
        FAOutputval.FilWeldLiqDyePenExam_20__c=10;
        FAOutputval.FilWeldLiqDyePenExam_30__c=10;
        FAOutputval.FilWeldLiqDyePenExam_40__c=10;
        FAOutputval.InletOptionPriceAdder__c=10;
        FAOutputval.InletTWellTCouplePriceAdder__c=10;
        FAOutputval.IntergranularCorrosionTesting_10__c=10;
        FAOutputval.IntergranularCorrosionTesting_20__c=10;
        FAOutputval.IntergranularCorrosionTesting_30__c=10;
        FAOutputval.IntergranularCorrosionTesting_40__c=10;
        FAOutputval.IntergranularCorrosionTesting__c=10;
        FAOutputval.LiquidDyePenetrantExamination_10__c=10;
        FAOutputval.LiquidDyePenetrantExamination_20__c=10;
        FAOutputval.LiquidDyePenetrantExamination_30__c=10;
        FAOutputval.LiquidDyePenetrantExamination_40__c=10;
        FAOutputval.LiquidDyePenetrantExamination__c=10;
        FAOutputval.MagneticParticleExamination__c=10;
        FAOutputval.MagParticleExam_10__c=10;
        FAOutputval.MagParticleExam_20__c=10;
        FAOutputval.MagParticleExam_30__c=10;
        FAOutputval.MagParticleExam_40__c=10;
        FAOutputval.MaterialSourceRestrictions_10__c=10;
        FAOutputval.MaterialSourceRestrictions_20__c=10;
        FAOutputval.MaterialSourceRestrictions_30__c=10;
        FAOutputval.MaterialSourceRestrictions_40__c=10;
        FAOutputval.MaterialSourcing__c=10;
        FAOutputval.ModelBase__c=10;
        FAOutputval.OA01__c='Test';
        FAOutputval.OA02__c='Test';
        FAOutputval.OA04__c='Test';
        FAOutputval.OA05__c='Test';
        FAOutputval.OA06__c='Test';
        FAOutputval.OA_Override__c='Test';
        FAOutputval.OB010__c='Test';
        FAOutputval.OB020__c='Test';
        FAOutputval.OB030__c='Test';
        FAOutputval.OB040__c='Test';
        FAOutputval.OB050__c='Test';
        FAOutputval.OB110__c='Test';
        FAOutputval.OB120__c='Test';
        FAOutputval.OB210__c='Test';
        FAOutputval.OB220__c='Test';
        FAOutputval.OB230__c='Test';
        FAOutputval.OB240__c='Test';
        FAOutputval.OB250__c='Test';
        FAOutputval.OB260__c='Test';
        FAOutputval.OB310__c='Test';
        FAOutputval.OB311__c='Test';
        FAOutputval.OB312__c='Test';
        FAOutputval.OB410__c='Test';
        FAOutputval.OB411__c='Test';
        FAOutputval.OB420__c='Test';
        FAOutputval.OB421__c='Test';
        FAOutputval.OB430__c='Test';
        FAOutputval.OB431__c='Test';
        FAOutputval.OB440__c='Test';
        FAOutputval.OB441__c='Test';
        FAOutputval.OB510__c='Test';
        FAOutputval.OB520__c='Test';
        FAOutputval.OB530__c='Test';
        FAOutputval.OB540__c='Test';
        FAOutputval.OB550__c='Test';
        FAOutputval.OB_Override__c='Test';
        FAOutputval.OutletOptionPriceAdder__c=10;
        FAOutputval.OutletTWellTCouplePriceAdder__c=10;
       	FAOutputval.OW110__c='Test';
        FAOutputval.OW120__c='Test';
        FAOutputval.OW130__c='Test';
        FAOutputval.OW140__c='Test';
        FAOutputval.OW150__c='Test';
        FAOutputval.OW160__c='Test';
        FAOutputval.OW170__c='Test';
        FAOutputval.OW180__c='Test';
        FAOutputval.OW190__c='Test';
        FAOutputval.OW200__c='Test';
        FAOutputval.OW210__c='Test';
        FAOutputval.OW220__c='Test';
        FAOutputval.OW230__c='Test';
        FAOutputval.OW240__c='Test';
        FAOutputval.OW250__c='Test';
        FAOutputval.OW260__c='Test';
        FAOutputval.OW270__c='Test';
        FAOutputval.OW280__c='Test';
        FAOutputval.OW290__c='Test';
        FAOutputval.OW300__c='Test';
        FAOutputval.OW310__c='Test';
        FAOutputval.OW320__c='Test';
        FAOutputval.OW330__c='Test';
        FAOutputval.OW340__c='Test';
        FAOutputval.OW910__c='Test';
        FAOutputval.OW920__c='Test';
        FAOutputval.OW_Override__c='Test';
        FAOutputval.PaintingCoating__c=10;
        FAOutputval.Painting_10__c=10;
        FAOutputval.Painting_20__c=10;
        FAOutputval.Painting_30__c=10;
        FAOutputval.Painting_40__c=10;
        FAOutputval.PaintOptions__c=10;
        FAOutputval.PC_Override__c='Test';
        FAOutputval.PositiveMaterialIdentification_10__c=10;
        FAOutputval.PositiveMaterialIdentification_20__c=10;
        FAOutputval.PositiveMaterialIdentification_30__c=10;
        FAOutputval.PositiveMaterialIdentification_40__c=10;
        FAOutputval.PositiveMaterialIdentification__c=10;
        FAOutputval.Price_Total__c=10;
        FAOutputval.Queue_Time_10__c=10;
        FAOutputval.Queue_Time_20__c=10;
        FAOutputval.Queue_Time_30__c=10;
        FAOutputval.Queue_Time_40__c=10;
        FAOutputval.RadiographicExamination__c=10;
        FAOutputval.Radiography_10__c=10;
        FAOutputval.Radiography_20__c=10;
        FAOutputval.Radiography_30__c=10;
        FAOutputval.Radiography_40__c=10;
        FAOutputval.Spring__c=10;
        FAOutputval.UltrasonicExamination__c=10;
        FAOutputval.UltrasonicExam_10__c=10;
        FAOutputval.UltrasonicExam_20__c=10;
        FAOutputval.UltrasonicExam_30__c=10;
        FAOutputval.UltrasonicExam_40__c=10;
        FAOutputval.VisualCastingExamination_10__c=10;
        FAOutputval.VisualCastingExamination_20__c=10;
        FAOutputval.VisualCastingExamination_30__c=10;
        FAOutputval.VisualCastingExamination_40__c=10;
        FAOutputval.VisualCastingExamination__c=10;

		FAOutputval.FA_Output_Relation_Field__c=conProd.Id;
		insert FAOutputval;
        
      //  update FAOutputList1;                        
    }

}