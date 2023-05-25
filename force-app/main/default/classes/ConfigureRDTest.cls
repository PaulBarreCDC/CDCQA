@isTest
public class ConfigureRDTest {
    public static ConfigureRD getConfigRDCntrl() {
        Map<String, String> mapWithRDValues = new Map<String, String>();
        mapWithRDValues.put('BRAND','CDC');
        mapWithRDValues.put('PRODUCT_CODE','RD');
        mapWithRDValues.put('PRODUCT_NAME','Rupture Disc');
        SBQQ__QuoteLine__c quoteLine = TestDataBaseUtility.createQLAndAssociatedRecords(mapWithRDValues);
        TestDataRDUtility.quoteLine = quoteLine;
        TestDataRDUtility.mapWithRDValues = mapWithRDValues;
        TestDataRDUtility.createRDMasterTestRecords();

        PageReference pager = Page.ConfigRD;
        Test.setCurrentPage(pager);

        ApexPages.currentPage().getParameters().put('qid', String.valueOf(quoteLine.Id));
        TestDataRDUtility.createRDTestRecSecAandEwithHPZ();
        Rupture_Disc__c conProd = [SELECT Id FROM Rupture_Disc__c WHERE Quote_Line__c = :quoteLine.Id LIMIT 1];

        ApexPages.StandardController sc = new ApexPages.StandardController(quoteLine);

        return new ConfigureRD(sc);
    }
    @isTest
    public static void getConfigRDCntrlForReORder() {
		Test.startTest();
        ConfigureRD CD= new ConfigureRD(ConfigureRDTest.ConRD1.quoteLineId);
        test.stopTest();

    }
    public static ConfigureRD ConRD1=getConfigRDCntrl();
    @isTest
    public static void testPressureRating() {
         Test.startTest();
        ConfigureRDTest.ConRD1.clearSectFManufacturingRange();
        ConfigureRDTest.ConRD1.clearSectHCleanings();
        ConfigureRDTest.ConRD1.clearSectGComponents();
        ConfigureRDTest.ConRD1.clearManufacturingRange();
        ConfigureRDTest.ConRD1.conProd.Relief_Type__c = 'Pressure Relief';
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Converted_Vac_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting_Units__c = 'Deg F';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Is_there_a_liquid_relief_scenario__c = 'Yes';
        ConfigureRDTest.ConRD1.conProd.Pressure_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Constrain_product_selection__c = 'Pressure & Vacuum';
        ConfigureRDTest.ConRD1.conProd.constrain_product_selection_by_flow__c = 'No';
        ConfigureRDTest.ConRD1.conProd.Product__c = 'HPZ';
        ConfigureRDTest.ConRD1.conProd.Seat__c = 'NA';
        ConfigureRDTest.ConRD1.conProd.Size__c = '108';
        ConfigureRDTest.ConRD1.conProd.Pressure_Range_Type__c = 'Standard';//Zero, Performance Tolerance, Special, Specify Min, Specify Reference Mfg Range, Special - 3/4 Reduced Range, Special - 1/4 Reduced Range,Special - 1/2 Reduced Range, -5% (-2.5 Psig), -5% (-0.3 Psig), -5%, -10% (-5 Psig), -10% (-0.6 Psig), -10%
        ConfigureRDTest.ConRD1.conProd.Pressure_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating, Standard
        //ConfigureRDTest.ConRD1.conProd.Vac_Range_Type__c = 'Standard';//Special, Zero, -75% of Range, -50% of Range, -25% of Range, Specify Reference Mfg Range, Specify Min, Performance Tolerance, Special - 3/4 Reduced Range, Special - 1/2 Reduced Range, Special - 1/4 Reduced Range
        //ConfigureRDTest.ConRD1.conProd.Vac_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating
        //ConfigureRDTest.ConRD1.conProd.Special_Range_Max_Input__c = 100.00;
        //ConfigureRDTest.ConRD1.conProd.Vac_Special_Range_Min_Input__c = 100.00;
       // ConfigureRDTest.ConRD1.conProd.Vac_Special_Range_Max_Input__c = 100.00;
        //ConfigureRDTest.ConRD1.conProd.Material_Girdle__c = '005';
        ConfigureRDTest.ConRD1.conProd.Quantity__c=1;
        ConfigureRDTest.ConRD1.clearDataBasedOnReliefType();
        ConfigureRDTest.ConRD1.saveRatingRange();
         test.stopTest();
    }
     @isTest
    public static void testPressureVaccumRating() {
        Test.startTest();
        ConfigureRDTest.ConRD1.clearSectFManufacturingRange();
        ConfigureRDTest.ConRD1.clearSectHCleanings();
        ConfigureRDTest.ConRD1.clearSectGComponents();
        ConfigureRDTest.ConRD1.clearManufacturingRange();
        ConfigureRDTest.ConRD1.conProd.Relief_Type__c = 'Pressure & Vacuum Relief';
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Converted_Vac_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting_Units__c = 'Deg F';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Is_there_a_liquid_relief_scenario__c = 'Yes';
        ConfigureRDTest.ConRD1.conProd.Pressure_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Constrain_product_selection__c = 'Pressure & Vacuum';
        ConfigureRDTest.ConRD1.conProd.constrain_product_selection_by_flow__c = 'No';
        ConfigureRDTest.ConRD1.conProd.Product__c = 'PAS';
        ConfigureRDTest.ConRD1.conProd.Seat__c = 'FS';
        ConfigureRDTest.ConRD1.conProd.Size__c = '200';
        ConfigureRDTest.ConRD1.conProd.Pressure_Range_Type__c = 'Standard';//Zero, Performance Tolerance, Special, Specify Min, Specify Reference Mfg Range, Special - 3/4 Reduced Range, Special - 1/4 Reduced Range,Special - 1/2 Reduced Range, -5% (-2.5 Psig), -5% (-0.3 Psig), -5%, -10% (-5 Psig), -10% (-0.6 Psig), -10%
        ConfigureRDTest.ConRD1.conProd.Pressure_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating, Standard
        ConfigureRDTest.ConRD1.conProd.Vac_Range_Type__c = 'Standard';//Special, Zero, -75% of Range, -50% of Range, -25% of Range, Specify Reference Mfg Range, Specify Min, Performance Tolerance, Special - 3/4 Reduced Range, Special - 1/2 Reduced Range, Special - 1/4 Reduced Range
        ConfigureRDTest.ConRD1.conProd.Vac_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating
        ConfigureRDTest.ConRD1.conProd.Special_Range_Max_Input__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Special_Range_Min_Input__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Special_Range_Max_Input__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Material_Girdle__c = '005';
        ConfigureRDTest.ConRD1.conProd.Quantity__c=1;

        ConfigureRDTest.ConRD1.clearDataBasedOnReliefType();
        //ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        ConfigureRDTest.ConRD1.saveRatingRange();

      //  saveCleaningsTestsandProcesses

    //     //list<SelectOption> listOptions= ConfigureRDTest.ConRD1.getDiscMaterial();
    //     ConfigureRDTest.ConRD1.saveProductNarrowing();
         test.stopTest();
    }
     @isTest
    public static void testVaccumRating() {
        Test.startTest();
        ConfigureRDTest.ConRD1.clearSectFManufacturingRange();
        ConfigureRDTest.ConRD1.clearSectHCleanings();
        ConfigureRDTest.ConRD1.clearSectGComponents();
        ConfigureRDTest.ConRD1.clearManufacturingRange();
        ConfigureRDTest.ConRD1.conProd.Relief_Type__c = 'Vacuum Relief';
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Converted_Vac_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting_Units__c = 'Deg F';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Is_there_a_liquid_relief_scenario__c = 'Yes';
        ConfigureRDTest.ConRD1.conProd.Pressure_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Constrain_product_selection__c = 'Pressure & Vacuum';
        ConfigureRDTest.ConRD1.conProd.constrain_product_selection_by_flow__c = 'No';
        ConfigureRDTest.ConRD1.conProd.Product__c = 'PAS';
        ConfigureRDTest.ConRD1.conProd.Seat__c = 'FS';
        ConfigureRDTest.ConRD1.conProd.Size__c = '200';
       // ConfigureRDTest.ConRD1.conProd.Pressure_Range_Type__c = 'Standard';//Zero, Performance Tolerance, Special, Specify Min, Specify Reference Mfg Range, Special - 3/4 Reduced Range, Special - 1/4 Reduced Range,Special - 1/2 Reduced Range, -5% (-2.5 Psig), -5% (-0.3 Psig), -5%, -10% (-5 Psig), -10% (-0.6 Psig), -10%
       // ConfigureRDTest.ConRD1.conProd.Pressure_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating, Standard
        ConfigureRDTest.ConRD1.conProd.Vac_Range_Type__c = 'Standard';//Special, Zero, -75% of Range, -50% of Range, -25% of Range, Specify Reference Mfg Range, Specify Min, Performance Tolerance, Special - 3/4 Reduced Range, Special - 1/2 Reduced Range, Special - 1/4 Reduced Range
        ConfigureRDTest.ConRD1.conProd.Vac_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating
       // ConfigureRDTest.ConRD1.conProd.Special_Range_Max_Input__c = 100.00;
        //ConfigureRDTest.ConRD1.conProd.Vac_Special_Range_Min_Input__c = 100.00;
        //ConfigureRDTest.ConRD1.conProd.Vac_Special_Range_Max_Input__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Material_Girdle__c = '005';
        ConfigureRDTest.ConRD1.conProd.Quantity__c=1;
        ConfigureRDTest.ConRD1.clearDataBasedOnReliefType();
        ConfigureRDTest.ConRD1.saveRatingRange();
        ConfigureRDTest.ConRD1.clearOutputObject();
         test.stopTest();
    }
     @isTest
    public static void testVaccumComponents() {
        Test.startTest();
        ConfigureRDTest.ConRD1.clearSectFManufacturingRange();
        ConfigureRDTest.ConRD1.clearSectHCleanings();
        ConfigureRDTest.ConRD1.clearSectGComponents();
        ConfigureRDTest.ConRD1.clearManufacturingRange();
         ConfigureRDTest.ConRD1.conProd.Relief_Type__c = 'Vacuum Relief';
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Converted_Vac_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting_Units__c = 'Deg F';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Is_there_a_liquid_relief_scenario__c = 'Yes';
        ConfigureRDTest.ConRD1.conProd.Pressure_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Constrain_product_selection__c = 'Pressure & Vacuum';
        ConfigureRDTest.ConRD1.conProd.constrain_product_selection_by_flow__c = 'No';
        ConfigureRDTest.ConRD1.conProd.Product__c = 'PAS';
        ConfigureRDTest.ConRD1.conProd.Seat__c = 'FS';
        ConfigureRDTest.ConRD1.conProd.Size__c = '200';
       // ConfigureRDTest.ConRD1.conProd.Pressure_Range_Type__c = 'Standard';//Zero, Performance Tolerance, Special, Specify Min, Specify Reference Mfg Range, Special - 3/4 Reduced Range, Special - 1/4 Reduced Range,Special - 1/2 Reduced Range, -5% (-2.5 Psig), -5% (-0.3 Psig), -5%, -10% (-5 Psig), -10% (-0.6 Psig), -10%
       // ConfigureRDTest.ConRD1.conProd.Pressure_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating, Standard
        ConfigureRDTest.ConRD1.conProd.Vac_Range_Type__c = 'Standard';//Special, Zero, -75% of Range, -50% of Range, -25% of Range, Specify Reference Mfg Range, Specify Min, Performance Tolerance, Special - 3/4 Reduced Range, Special - 1/2 Reduced Range, Special - 1/4 Reduced Range
        ConfigureRDTest.ConRD1.conProd.Vac_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating
       // ConfigureRDTest.ConRD1.conProd.Special_Range_Max_Input__c = 100.00;
        //ConfigureRDTest.ConRD1.conProd.Vac_Special_Range_Min_Input__c = 100.00;
        //ConfigureRDTest.ConRD1.conProd.Vac_Special_Range_Max_Input__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Material_Girdle__c = '005';
        ConfigureRDTest.ConRD1.conProd.Quantity__c=1;
        ConfigureRDTest.ConRD1.clearDataBasedOnReliefType();
          ConfigureRDTest.ConRD1.conProd.Rating_and_Range_Flag__c=true;
        ConfigureRDTest.ConRD1.saveComponents();
         test.stopTest();
    }
     @isTest
    public static void testComponentBothDirection() {
        Test.startTest();
        ConfigureRDTest.ConRD1.clearSectFManufacturingRange();
        ConfigureRDTest.ConRD1.clearSectHCleanings();
        ConfigureRDTest.ConRD1.clearSectGComponents();
        ConfigureRDTest.ConRD1.clearManufacturingRange();
        ConfigureRDTest.ConRD1.conProd.Relief_Type__c = 'Pressure & Vacuum Relief';
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Converted_Vac_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting_Units__c = 'Deg F';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Is_there_a_liquid_relief_scenario__c = 'Yes';
        ConfigureRDTest.ConRD1.conProd.Pressure_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Constrain_product_selection__c = 'Pressure & Vacuum';
        ConfigureRDTest.ConRD1.conProd.constrain_product_selection_by_flow__c = 'No';
        ConfigureRDTest.ConRD1.conProd.Product__c = 'PAS';
        ConfigureRDTest.ConRD1.conProd.Seat__c = 'FS';
        ConfigureRDTest.ConRD1.conProd.Size__c = '200';
        ConfigureRDTest.ConRD1.conProd.Pressure_Range_Type__c = 'Standard';//Zero, Performance Tolerance, Special, Specify Min, Specify Reference Mfg Range, Special - 3/4 Reduced Range, Special - 1/4 Reduced Range,Special - 1/2 Reduced Range, -5% (-2.5 Psig), -5% (-0.3 Psig), -5%, -10% (-5 Psig), -10% (-0.6 Psig), -10%
        ConfigureRDTest.ConRD1.conProd.Pressure_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating, Standard
        ConfigureRDTest.ConRD1.conProd.Vac_Range_Type__c = 'Standard';//Special, Zero, -75% of Range, -50% of Range, -25% of Range, Specify Reference Mfg Range, Specify Min, Performance Tolerance, Special - 3/4 Reduced Range, Special - 1/2 Reduced Range, Special - 1/4 Reduced Range
        ConfigureRDTest.ConRD1.conProd.Vac_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating
        ConfigureRDTest.ConRD1.conProd.Special_Range_Max_Input__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Special_Range_Min_Input__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Special_Range_Max_Input__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Material_Girdle__c = '005';
        ConfigureRDTest.ConRD1.conProd.Quantity__c=1;
        ConfigureRDTest.ConRD1.clearDataBasedOnReliefType();
        ConfigureRDTest.ConRD1.conProd.Rating_and_Range_Flag__c=true;
        //ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        ConfigureRDTest.ConRD1.saveComponents();
         test.stopTest();
    }


     @isTest
    public static void testFinalSaveBoth() {
        Test.startTest();
        ConfigureRDTest.ConRD1.clearSectFManufacturingRange();
        ConfigureRDTest.ConRD1.clearSectHCleanings();
        ConfigureRDTest.ConRD1.clearSectGComponents();
        ConfigureRDTest.ConRD1.clearManufacturingRange();
        ConfigureRDTest.ConRD1.conProd.Relief_Type__c = 'Pressure & Vacuum Relief';
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Converted_Vac_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting_Units__c = 'Deg F';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Is_there_a_liquid_relief_scenario__c = 'Yes';
        ConfigureRDTest.ConRD1.conProd.Pressure_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Constrain_product_selection__c = 'Pressure & Vacuum';
        ConfigureRDTest.ConRD1.conProd.constrain_product_selection_by_flow__c = 'No';
        ConfigureRDTest.ConRD1.conProd.Product__c = 'PAS';
        ConfigureRDTest.ConRD1.conProd.Seat__c = 'FS';
        ConfigureRDTest.ConRD1.conProd.Size__c = '200';
        ConfigureRDTest.ConRD1.conProd.Pressure_Range_Type__c = 'Standard';//Zero, Performance Tolerance, Special, Specify Min, Specify Reference Mfg Range, Special - 3/4 Reduced Range, Special - 1/4 Reduced Range,Special - 1/2 Reduced Range, -5% (-2.5 Psig), -5% (-0.3 Psig), -5%, -10% (-5 Psig), -10% (-0.6 Psig), -10%
        ConfigureRDTest.ConRD1.conProd.Pressure_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating, Standard
        ConfigureRDTest.ConRD1.conProd.Vac_Range_Type__c = 'Standard';//Special, Zero, -75% of Range, -50% of Range, -25% of Range, Specify Reference Mfg Range, Specify Min, Performance Tolerance, Special - 3/4 Reduced Range, Special - 1/2 Reduced Range, Special - 1/4 Reduced Range
        ConfigureRDTest.ConRD1.conProd.Vac_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating
        ConfigureRDTest.ConRD1.conProd.Special_Range_Max_Input__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Special_Range_Min_Input__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Special_Range_Max_Input__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Material_Girdle__c = '005';
        ConfigureRDTest.ConRD1.conProd.Quantity__c=1;
        ConfigureRDTest.ConRD1.clearDataBasedOnReliefType();
        ConfigureRDTest.ConRD1.conProd.Rating_and_Range_Flag__c=true;
        ConfigureRDTest.ConRD1.conProd.Rating_and_Range_Flag__c=true;
        ConfigureRDTest.ConRD1.conProd.Components_Flag__c=true;
        ConfigureRDTest.ConRD1.conProd.Material_Vacuum_Support__c='008';
        ConfigureRDTest.ConRD1.conProd.Material_Disc__c='008';
        ConfigureRDTest.ConRD1.saveCleaningsTestsandProcesses();
       // ConfigureRDTest.ConRD1.saveComponents();
         test.stopTest();
    }
    @isTest
    public static void testClearMethods() {
        //ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        Test.startTest();
        ConfigureRDTest.ConRD1.clearSectFManufacturingRange();
        ConfigureRDTest.ConRD1.clearSectHCleanings();
        ConfigureRDTest.ConRD1.clearSectGComponents();
        ConfigureRDTest.ConRD1.clearManufacturingRange();
        String abc1=ConfigureRDTest.ConRD1.getUserTimeZone();
        abc1=ConfigureRDTest.ConRD1.MCDmaterial;
        abc1=ConfigureRDTest.ConRD1.strquoteDes;
        ConfigureRDTest.ConRD1.goBackToQuote();
        ConfigureRDTest.ConRD1.EnableEditMode();
        boolean b=true;
        b=ConfigureRDTest.ConRD1.showCF;
        b=ConfigureRDTest.ConRD1.showMWROSH;
        b=ConfigureRDTest.ConRD1.showFlowRateAndRelivingPressure;
        b=ConfigureRDTest.ConRD1.showPresTempValUnits;
        b=ConfigureRDTest.ConRD1.showDenSpecificVolSpecficGravity;
        b=ConfigureRDTest.ConRD1.showViscosity;
        b=ConfigureRDTest.ConRD1.showDryWetSteam;
        b=ConfigureRDTest.ConRD1.showSpecificVolInlet;
        b=ConfigureRDTest.ConRD1.showDenInlet;
        b=ConfigureRDTest.ConRD1.showSpecificVol90InletPressure;
        b=ConfigureRDTest.ConRD1.showSatPressureInletTemp;
        b=ConfigureRDTest.ConRD1.showDen90SatPressure;
        b=ConfigureRDTest.ConRD1.showStaGasVaporQual;
        b=ConfigureRDTest.ConRD1.showLiquidDensity;
        b=ConfigureRDTest.ConRD1.showStaVaporDensity;
        b=ConfigureRDTest.ConRD1.showLatHeatVaporLiqSpecificHeat;
        b=ConfigureRDTest.ConRD1.showStaGasPartPressureUnits;
        b=ConfigureRDTest.ConRD1.showVaporPresStaTemp;
        b=ConfigureRDTest.ConRD1.showIsentrophicCoGasVapo;
        b=ConfigureRDTest.ConRD1.showMoleWeightGasVapor;
        b=ConfigureRDTest.ConRD1.showBDI1;
        b=ConfigureRDTest.ConRD1.showSurfaceFinish;
        b=ConfigureRDTest.ConRD1.shwShellTest;
        b=ConfigureRDTest.ConRD1.shwASMETEST;
        b=ConfigureRDTest.ConRD1.HideVacuumRating;
        List<string> abc=ConfigureRDTest.ConRD1.notValidStatusForChng;
        ConfigureRDTest.ConRD1.saveProductNarrowing();
        ConfigureRDTest.ConRD1.getRatingType();
        ConfigureRDTest.ConRD1.getVacRatingType(); list<SelectOption> listOptions=ConfigureRDTest.ConRD1.getStripMatlCode();
        TestDataRDUtility.conProd.Components_Flag__c=true;
        ConfigureRDTest.ConRD1.errOnSaveComp=true;
        listOptions=ConfigureRDTest.ConRD1.getGasket();
        listOptions=ConfigureRDTest.ConRD1.getWireConfigType();
        listOptions=ConfigureRDTest.ConRD1.getWireType();
        listOptions=ConfigureRDTest.ConRD1.getCableLength();
        listOptions=ConfigureRDTest.ConRD1.getEndConnection();
        listOptions=ConfigureRDTest.ConRD1.getInterfaceCable();
        listOptions=ConfigureRDTest.ConRD1.getBDIOptions();
        ConfigureRDTest.ConRD1.conProd.Rating_and_Range_Flag__c=true;
        ConfigureRDTest.ConRD1.conProd.Components_Flag__c=true;
        ConfigureRDTest.ConRD1.conProd.Material_Vacuum_Support__c='008';
        ConfigureRDTest.ConRD1.conProd.Material_Disc__c='008';
        ConfigureRDTest.ConRD1.saveCleaningsTestsandProcesses();
        test.stopTest();

    }
    @isTest
    public static void runRGDRT() {
        Test.startTest();
       // ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        ConfigureRDTest.ConRD1.calculateRG3DRT();
        ConfigureRDTest.ConRD1.rtgRngWrap.addMetalSealCheck=true;
        ConfigureRDTest.ConRD1.calRG3DRT();
        test.stopTest();
    }
    
  /*  @isTest
    public static void saveRatingRange2() {
        Test.startTest();
     //   messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Quantity: Please Enter a Value'));
        ConfigureRDTest.ConRD1.calculateRG3DRT();
		List<ApexPages.Message> messages = new List<ApexPages.Message>();        
        messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Quantity: Please Enter a Value'));
        ConfigureRDTest.ConRD1.rtgRngWrap.runConstraints(messages);
        ConfigureRDTest.ConRD1.saveRatingRange();
        test.stopTest();
    }*/
    
    @isTest
    public static void runOutPuts() {
        Test.startTest();
        //ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        ConfigureRDTest.ConRD1.selectedTab = 'ProductReview';
        ConfigureRDTest.ConRD1.getTabData();
        ConfigureRDTest.ConRD1.selectedTab = 'Pricing';
        ConfigureRDTest.ConRD1.getTabData();
        ConfigureRDTest.ConRD1.selectedTab = 'Diagram';
        ConfigureRDTest.ConRD1.getTabData();
        ConfigureRDTest.ConRD1.selectedTab = 'EngineeringSpl';
        ConfigureRDTest.ConRD1.getTabData();
        
        test.stopTest();
    }
    @isTest
    public static void runOutPuts2() {
        Test.startTest();

        ConfigureRDTest.ConRD1.goBack();
        ConfigureRDTest.ConRD1.selectedTab = 'MfgOutputs';
        ConfigureRDTest.ConRD1.getTabData();
        ConfigureRDTest.ConRD1.selectedTab = 'TroubleShooting';
        ConfigureRDTest.ConRD1.getTabData();
        test.stopTest();
    }
  
    @isTest
    public static void testDescriptionSection() {

        Test.startTest();
        // ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        list<ConfigureRD.QuoteDescriptionWrapper> test2=ConfigureRDTest.ConRD1.getQuoteDescriptionRec();
        ConfigureRDTest.ConRD1.ApplyDefaultQuoteDescription();
        // ConfigureRDTest.ConRD1.saveQuoteDescription();
        Test.stopTest();
    }
     @isTest
    public static void testDescriptionSection2() {

        Test.startTest();
        // ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        //list<ConfigureRD.QuoteDescriptionWrapper> test2=ConfigureRDTest.ConRD1.getQuoteDescriptionRec();
       // ConfigureRDTest.ConRD1.ApplyDefaultQuoteDescription();
        ConfigureRDTest.ConRD1.saveQuoteDescription();
        Test.stopTest();
    }
    @isTest
    public static void testPricing() {


        // ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        // ConfigureRDTest.ConRD1.notValidStatusForChng.clear();
        // ConfigureRDTest.ConRD1.notValidStatusForChng.add(ConfigureRDTest.ConRD1.strQuoteStatus);
        Test.startTest();
      //  ConfigureRDTest.ConRD1.notValidStatusForChng.add(ConfigureRDTest.ConRD1.strQuoteStatus);
        // System.debug('ConRD notValidStatusForChng'+ConfigureRDTest.ConRD1.notValidStatusForChng);
        // System.debug('ConRD notValidStatusForChng'+ConfigureRDTest.ConRD1.strQuoteStatus);
        ConfigureRDTest.ConRD1.applyDefalutsPricing();

        // ConfigureRDTest.ConRD1.clearCalculatedValues();
        Test.stopTest();
    }
    @isTest
    public static void testPricing1() {

        Test.startTest();
    //     ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
    //     ConfigureRDTest.ConRD1.notValidStatusForChng.clear();
    //     ConfigureRDTest.ConRD1.notValidStatusForChng.add(ConfigureRDTest.ConRD1.strQuoteStatus);

    //   //  ConfigureRDTest.ConRD1.notValidStatusForChng.add(ConfigureRDTest.ConRD1.strQuoteStatus);
    //     System.debug('ConRD notValidStatusForChng'+ConfigureRDTest.ConRD1.notValidStatusForChng);
    //     System.debug('ConRD notValidStatusForChng'+ConfigureRDTest.ConRD1.strQuoteStatus);
        //ConfigureRDTest.ConRD1.applyDefalutsPricing();
        ConfigureRDTest.ConRD1.savePricing();
        ConfigureRDTest.ConRD1.clearCalculatedValues();
        Test.stopTest();
    }
    @isTest
    public static void testLeadtimeSection() {

        Test.startTest();
        //ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        //list<QuoteDescriptionWrapper> test=ConfigureRDTest.ConRD1.ApplyDefaultLT();
       // ConfigureRDTest.ConRD1.saveLeadTime();
        ConfigureRDTest.ConRD1.ApplyDefaultLT();
        Test.stopTest();
    }
    @isTest
    public static void testSaveLeadtimeSection() {

        Test.startTest();
        //ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        //list<QuoteDescriptionWrapper> test=ConfigureRDTest.ConRD1.ApplyDefaultLT();
         ConfigureRDTest.ConRD1.saveLeadTime();
        //ConfigureRDTest.ConRD1.ApplyDefaultLT();
        Test.stopTest();
    }
    @isTest
    public static void testComponentSection() {

        Test.startTest();
        // ConRD = ConfigureRDTest.getConfigRDCntrl();
        ConfigureRDTest.ConRD1.conProd.Size__c = '0108';
        ConfigureRDTest.ConRD1.conProd.DSCVAR__c = 'A';
        ConfigureRDTest.ConRD1.MCD='001';
        ConfigureRDTest.ConRD1.saveComponents();
        Test.stopTest();
    }
    @isTest
    public static void testRouting() {

        Test.startTest();
       // ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        ConfigureRDTest.ConRD1.showProductMnfOutputs=true;
        list<ConfigureRD.RouterWrapper> rout=ConfigureRDTest.ConRD1.getRouter();
        Test.stopTest();
    }
    @isTest
    public static void testWorkGuideLines() {

        Test.startTest();
       // ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        ConfigureRDTest.ConRD1.showProductMnfOutputs=true;
        list<ConfigureRD.WorkGuideLineWrapper> wrkGuide=ConfigureRDTest.ConRD1.getWorkGuideLines();
        Test.stopTest();
    }

    @isTest
    public static void testdocumentWrapper() {

        Test.startTest();
        //ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        ConfigureRDTest.ConRD1.showProductMnfOutputs=true;
        list<ConfigureRD.documentWrapper> wrkGuide=ConfigureRDTest.ConRD1.getDocWrapper();
        Test.stopTest();
    }
    @isTest
    public static void testControlPlanWrapper() {

        Test.startTest();
        //ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        ConfigureRDTest.ConRD1.showProductMnfOutputs=true;
        list<ConfigureRD.ControlPlanWrapper> wrkGuide=ConfigureRDTest.ConRD1.getControlPlan();
        Test.stopTest();
    }
    @isTest
    public static void testDiagram() {

        Test.startTest();
        //ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        result res=ConfigureRDTest.ConRD1.loadDiagramData();
        ConfigureRDTest.ConRD1.saveDiagrams();
       // list<ConfigureRD.ControlPlanWrapper> wrkGuide=ConfigureRDTest.ConRD1.getControlPlan();
        Test.stopTest();
    }
    @isTest
    public static void testDiagram2() {

        Test.startTest();
        ConfigureRDTest.ConRD1.conProd.Product__c = 'HPZ';
        ConfigureRDTest.ConRD1.conProd.Seat__c = 'FS';
        ConfigureRDTest.ConRD1.conProd.Size__c = '0108';
        ConfigureRDTest.ConRD1.conProd.CU_TR__c=false;
        result res=ConfigureRDTest.ConRD1.loadDiagramData();
        ConfigureRDTest.ConRD1.getDiaData();
        ConfigureRDTest.ConRD1.saveDiagrams();
       // list<ConfigureRD.ControlPlanWrapper> wrkGuide=ConfigureRDTest.ConRD1.getControlPlan();
        Test.stopTest();
    }

    @istest
    public static void testCost1() {
        TestDataRDUtility.createCost();
        ConfigureRDTest.ConRD1.getCost();
        ConfigureRDTest.ConRD1.ApplyDefaultCost();
        ConfigureRDTest.ConRD1.saveCosting();
    }

    @isTest
    public static void testDiagram1() {

        Test.startTest();
        //ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        //result res=ConfigureRDTest.ConRD1.loadDiagramData();
        ConfigureRDTest.ConRD1.getDiaData();
        ConfigureRDTest.ConRD1.applyDefalutsDiagrams();
        ConfigureRDTest.ConRD1.conProd.Quote_Descriptions_Override__c=true;
        ConfigureRDTest.ConRD1.savePartNumber();
        String abc=ConRD1.disabledCSS3;
        abc=ConRD1.disabledCSS2;
        abc=ConRD1.disabledCSS;
        abc=ConRD1.stlCSS2;
        abc=ConRD1.stlCSS21;
        abc=ConRD1.stlCSS3;
       // list<ConfigureRD.ControlPlanWrapper> wrkGuide=ConfigureRDTest.ConRD1.getControlPlan();
        Test.stopTest();
    }
    @isTest
    public static void testDiagram13() {

        Test.startTest();
        //ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        //result res=ConfigureRDTest.ConRD1.loadDiagramData();
        ConfigureRDTest.ConRD1.getDiaData();
        ConfigureRDTest.ConRD1.conProd.Drawing_Outside_Config__c=true;
        ConfigureRDTest.ConRD1.applyDefalutsDiagrams();
       // ConfigureRDTest.ConRD1.savePartNumber();
        String abc=ConRD1.disabledCSS3;
        abc=ConRD1.disabledCSS2;
        abc=ConRD1.disabledCSS;
        abc=ConRD1.stlCSS2;
        abc=ConRD1.stlCSS21;
        abc=ConRD1.stlCSS3;
       // list<ConfigureRD.ControlPlanWrapper> wrkGuide=ConfigureRDTest.ConRD1.getControlPlan();
        Test.stopTest();
    }
    @isTest
    public static void testgeneralSave() {

        Test.startTest();
        //ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        //result res=ConfigureRDTest.ConRD1.loadDiagramData();
        ConfigureRDTest.ConRD1.generalSave();
        ConfigureRDTest.ConRD1.getPart();
        list<ConfigureRD.OWWrapper> bac=new list<ConfigureRD.OWWrapper>();
        bac=ConfigureRDTest.ConRD1.getOW();
        string str='test';
        str=ConfigureRDTest.ConRD1.strSZC;
        Decimal dec=0;
        dec=ConfigureRDTest.ConRD1.RTTMDF;
        ConfigureRDTest.ConRD1.reld();
        ConfigureRDTest.ConRD1.RTTMDF=10;
        ConfigureRDTest.ConRD1.strSZC='0108';
        ConfigureRDTest.ConRD1.showVacuum=true;
        ConfigureRDTest.ConRD1.showPressure=true;
        ConfigureRDTest.ConRD1.showSecB=true;
        ConfigureRDTest.ConRD1.showPressureVacuum=true;

       // ConfigureRDTest.ConRD1.savePartNumber();
       // list<ConfigureRD.ControlPlanWrapper> wrkGuide=ConfigureRDTest.ConRD1.getControlPlan();
        Test.stopTest();
    }
    @isTest
    public static void testoutputCalculation() {

        Test.startTest();
        //ConfigureRD ConRD = ConfigureRDTest.getConfigRDCntrl();
        //result res=ConfigureRDTest.ConRD1.loadDiagramData();
        ConfigureRDTest.ConRD1.calculateOutputs();
       // ConfigureRDTest.ConRD1.savePartNumber();
       // list<ConfigureRD.ControlPlanWrapper> wrkGuide=ConfigureRDTest.ConRD1.getControlPlan();
        Test.stopTest();
    }
    
    @isTest
    public static void RDGetters() {

        Test.startTest();
        
		String str;
		str=conRD1.strWSTD;
		
		decimal decvar=0;
		decvar=conRD1.decBackPressConv;
		decvar=conRD1.RG2MIN;
        
		Boolean Bvar;
		Bvar=conRD1.blShellTest;
        Bvar=conRD1.showPressure;
        Bvar=conRD1.showSecB;
        Bvar=conRD1.showVacuum;
        Bvar=conRD1.showPressureVacuum;
		
		ConRD1.SZC='test';
		ConRD1.MCDmaterial='test';
		ConRD1.strquoteDes='test';
		
        ConRD1.decPBrustConvertedValue=5;
		ConRD1.decVBrustConvertedValue=5;
		ConRD1.decBackPressConv=5;	
        ConRD1.RGEMIN=5;
        ConRD1.VG2MIN=5;
        ConRD1.RG2MIN=5;
        ConRD1.VGSMIN=5;
        ConRD1.RGSMIN=5;
		
		ConRD1.showCF=true;
		ConRD1.showMWROSH=true;
		ConRD1.showFlowRateAndRelivingPressure=true;
		ConRD1.showPresTempValUnits=true;
		ConRD1.showDenSpecificVolSpecficGravity=true;
		ConRD1.showViscosity=true;
		ConRD1.showDryWetSteam=true;
		ConRD1.showSpecificVolInlet=true;
		ConRD1.showDenInlet=true;
		ConRD1.showSpecificVol90InletPressure=true;
		ConRD1.showSatPressureInletTemp=true;
		ConRD1.showDen90SatPressure=true;
		ConRD1.showStaGasVaporQual=true;
		ConRD1.showLiquidDensity=true;
		ConRD1.showStaVaporDensity=true;
		ConRD1.showLatHeatVaporLiqSpecificHeat=true;
		ConRD1.showStaGasPartPressureUnits=true;
		ConRD1.showVaporPresStaTemp=true;
		ConRD1.showIsentrophicCoGasVapo=true;
		ConRD1.showMoleWeightGasVapor=true;
		ConRD1.showBDI1=true;
		ConRD1.showBDI=true;
		ConRD1.showSurfaceFinish=true;
		ConRD1.shwShellTest=true;
		ConRD1.shwASMETEST=true;
		ConRD1.blShellTest=true;
		
        Test.stopTest();
    }
    
    @isTest
    public static void testPressureRating2() {
         Test.startTest();
        ConfigureRDTest.ConRD1.clearSectFManufacturingRange();
        ConfigureRDTest.ConRD1.clearSectHCleanings();
        ConfigureRDTest.ConRD1.clearSectGComponents();
        ConfigureRDTest.ConRD1.clearManufacturingRange();
        ConfigureRDTest.ConRD1.conProd.Relief_Type__c = 'Pressure Relief';
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Converted_Vac_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting_Units__c = 'Deg F';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Is_there_a_liquid_relief_scenario__c = 'Yes';
        ConfigureRDTest.ConRD1.conProd.Pressure_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Constrain_product_selection__c = 'Pressure & Vacuum';
        ConfigureRDTest.ConRD1.conProd.constrain_product_selection_by_flow__c = 'No';
        ConfigureRDTest.ConRD1.conProd.Product__c = 'HPZ';
        ConfigureRDTest.ConRD1.conProd.Seat__c = 'NA';
        ConfigureRDTest.ConRD1.conProd.Size__c = '108';
        ConfigureRDTest.ConRD1.conProd.Pressure_Range_Type__c = 'Standard';//Zero, Performance Tolerance, Special, Specify Min, Specify Reference Mfg Range, Special - 3/4 Reduced Range, Special - 1/4 Reduced Range,Special - 1/2 Reduced Range, -5% (-2.5 Psig), -5% (-0.3 Psig), -5%, -10% (-5 Psig), -10% (-0.6 Psig), -10%
        ConfigureRDTest.ConRD1.rtgRngWrap.RGRAT1 = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating, Standard      
        
        List<selectOption> RGTYP1options= new List<selectOption>();
        RGTYP1options.add(new selectOption('Rated','Rated'));
        ConfigureRDTest.ConRD1.rtgRngWrap.mapRGTYP1.put('Rated',RGTYP1options);
        
        ConfigureRDTest.ConRD1.conProd.Quantity__c=1;
        ConfigureRDTest.ConRD1.getRatingType();
        
        ConfigureRDTest.ConRD1.rtgRngWrap.VGRAT1 = 'Rated';
        ConfigureRDTest.ConRD1.rtgRngWrap.mapVGTYP1.put('Rated',RGTYP1options);
        ConfigureRDTest.ConRD1.getVacRatingType();
        ConfigureRDTest.ConRD1.getStructureData();
         test.stopTest();
    }
    
    @isTest
    public static void testPressureVaccumRating2() {
        Test.startTest();
        ConfigureRDTest.ConRD1.conProd.Relief_Type__c = 'Pressure Relief';
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Converted_Vac_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting_Units__c = 'Deg F';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Is_there_a_liquid_relief_scenario__c = 'Yes';
        ConfigureRDTest.ConRD1.conProd.Pressure_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Constrain_product_selection__c = 'Pressure & Vacuum';
        ConfigureRDTest.ConRD1.conProd.constrain_product_selection_by_flow__c = 'No';
        ConfigureRDTest.ConRD1.conProd.Product__c = 'PAS';
        ConfigureRDTest.ConRD1.conProd.Seat__c = 'FS';
        ConfigureRDTest.ConRD1.conProd.Size__c = '200';
        ConfigureRDTest.ConRD1.conProd.Pressure_Range_Type__c = 'Standard';//Zero, Performance Tolerance, Special, Specify Min, Specify Reference Mfg Range, Special - 3/4 Reduced Range, Special - 1/4 Reduced Range,Special - 1/2 Reduced Range, -5% (-2.5 Psig), -5% (-0.3 Psig), -5%, -10% (-5 Psig), -10% (-0.6 Psig), -10%
        ConfigureRDTest.ConRD1.conProd.Pressure_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating, Standard
        ConfigureRDTest.ConRD1.conProd.Vac_Range_Type__c = 'Standard';//Special, Zero, -75% of Range, -50% of Range, -25% of Range, Specify Reference Mfg Range, Specify Min, Performance Tolerance, Special - 3/4 Reduced Range, Special - 1/2 Reduced Range, Special - 1/4 Reduced Range
        ConfigureRDTest.ConRD1.conProd.Vac_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating
        ConfigureRDTest.ConRD1.conProd.Special_Range_Max_Input__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Special_Range_Min_Input__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Special_Range_Max_Input__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Material_Girdle__c = '005';
        ConfigureRDTest.ConRD1.conProd.Quantity__c=1;

        ConfigureRDTest.ConRD1.saveRatingRange();
         test.stopTest();
    }
    
    @isTest
    public static void testPressureVaccumRating3() {
        Test.startTest();
        ConfigureRDTest.ConRD1.conProd.Relief_Type__c = 'Vacuum Relief';
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Vacuum_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Converted_Vac_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Pressure_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Temperature_Setting__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Back_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Converted_Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Value__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Pressure_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Temperature_Setting_Units__c = 'Deg F';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Setting_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Back_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Positive_Pressure_Units__c = 'psig';
        ConfigureRDTest.ConRD1.conProd.Is_there_a_liquid_relief_scenario__c = 'Yes';
        ConfigureRDTest.ConRD1.conProd.Pressure_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Vacuum_Withstand__c = 'No Requirements';
        ConfigureRDTest.ConRD1.conProd.Constrain_product_selection__c = 'Pressure & Vacuum';
        ConfigureRDTest.ConRD1.conProd.constrain_product_selection_by_flow__c = 'No';
        ConfigureRDTest.ConRD1.conProd.Product__c = 'CAL';
        ConfigureRDTest.ConRD1.conProd.Seat__c = 'FS';
        ConfigureRDTest.ConRD1.conProd.Size__c = '200';
        ConfigureRDTest.ConRD1.conProd.Pressure_Range_Type__c = 'Standard';//Zero, Performance Tolerance, Special, Specify Min, Specify Reference Mfg Range, Special - 3/4 Reduced Range, Special - 1/4 Reduced Range,Special - 1/2 Reduced Range, -5% (-2.5 Psig), -5% (-0.3 Psig), -5%, -10% (-5 Psig), -10% (-0.6 Psig), -10%
        ConfigureRDTest.ConRD1.conProd.Pressure_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating, Standard
        ConfigureRDTest.ConRD1.conProd.Vac_Range_Type__c = 'Standard';//Special, Zero, -75% of Range, -50% of Range, -25% of Range, Specify Reference Mfg Range, Specify Min, Performance Tolerance, Special - 3/4 Reduced Range, Special - 1/2 Reduced Range, Special - 1/4 Reduced Range
        ConfigureRDTest.ConRD1.conProd.Vac_Rating_Type__c = 'Rated';//Burst Pressure Min/Max., Specified, Start/Full Relief (Min/Max), No Rating But Must Withstand, No Rating
        ConfigureRDTest.ConRD1.conProd.Special_Range_Max_Input__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Special_Range_Min_Input__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Vac_Special_Range_Max_Input__c = 100.00;
        ConfigureRDTest.ConRD1.conProd.Material_Girdle__c = '005';
        ConfigureRDTest.ConRD1.conProd.Quantity__c=1;

        ConfigureRDTest.ConRD1.saveRatingRange();
         test.stopTest();
    }
    
}