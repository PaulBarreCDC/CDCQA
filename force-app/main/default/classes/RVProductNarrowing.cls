/**
 * @File Name          : RVProductNarrowing.cls
 * @Description        :
 * @Author             : ApexIT
 * @Group              :
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0        -              ApexIT                 Initial Version
 * 1.1      21-Feb-2021      Rohini Hathi           Support Ticket# 161771
 **/
public with sharing class RVProductNarrowing{

    public static Decimal getEFFMop(Relief_Valve__c RvRec){
        Decimal EFFMop = 0.0;
        Decimal convertedRelievingPressure = 0.0;
        Decimal convertedMaxProcessPressure = 0.0;
        if(RVRec.Constraint_Product_Selection_By_Flow__c )
        {
            if((RvRec.Relief_Type__c == 'Pressure' || RvRec.Relief_Type__c == 'Pressure & Vacuum') && RvRec.Converted_Relieving_Pressure_Value__c != null)
            {
                convertedRelievingPressure =  RvRec.Converted_Relieving_Pressure_Value__c;

            }        
        }else{
            if((RvRec.Relief_Type__c == 'Pressure' || RvRec.Relief_Type__c == 'Pressure & Vacuum') && RvRec.Converted_Relieving_Pressure_Value__c != null){ //Service Ticket 161771 
                convertedRelievingPressure =  RvRec.Converted_Relieving_Pressure_Value__c; //Service Ticket 161771            
            }
        }

        if((RvRec.Relief_Type__c == 'Vacuum' || RvRec.Relief_Type__c == 'Pressure & Vacuum') && RvRec.Converted_Max_Process_Pressure__c != null )
        {        
            convertedMaxProcessPressure = RvRec.Converted_Max_Process_Pressure__c;               
        }    
        
        System.debug('chkkk effMOP PARAM1 and PARAM2  '+ convertedMaxProcessPressure + ' :: ' +convertedRelievingPressure);
           
        EFFMop = Math.Max(convertedMaxProcessPressure, convertedRelievingPressure);

        return EFFMop;
    }

    Public static boolean checkForNullAndZero(decimal Val)
    {
        Boolean checkflag = false;
        if(Val == null || Val == 0)
        {
            checkflag = true;
        }
        //system.debug('@@CheckFlag: '+checkflag);
        return checkflag;
    } 

    public static Decimal getEffMBP(Relief_Valve__c RvRec){

        Decimal EffMBP = 0.0;
		//system.debug('@@CheckFlag: '+checkflag);
        system.debug('V_Converted_Relieving_Vacuum_Value__c '+ RvRec.V_Converted_Relieving_Vacuum_Value__c+'Bollean =: '+checkForNullAndZero(RvRec.V_Converted_Relieving_Vacuum_Value__c ));
        system.debug('Converted_Back_Pressure__c '+ RvRec.Converted_Back_Pressure__c +'Bollean =: '+checkForNullAndZero(RvRec.Converted_Back_Pressure__c ));
        
            if(checkForNullAndZero(RvRec.V_Converted_Relieving_Vacuum_Value__c) == false && checkForNullAndZero(RvRec.Converted_Back_Pressure__c ) == false)
            {
                EffMBP = Math.Max(RvRec.V_Converted_Relieving_Vacuum_Value__c, RvRec.Converted_Back_Pressure__c);
            }
            if(checkForNullAndZero(RvRec.V_Converted_Relieving_Vacuum_Value__c) == false && checkForNullAndZero(RvRec.Converted_Back_Pressure__c) == true) 
            {
                EffMBP = Math.Max(RvRec.V_Converted_Relieving_Vacuum_Value__c, 0);
            }
            if(checkForNullAndZero(RvRec.V_Converted_Relieving_Vacuum_Value__c) == true && checkForNullAndZero(RvRec.Converted_Back_Pressure__c ) == false) 
            {
                
                EffMBP = Math.Max(0, RvRec.Converted_Back_Pressure__c);           
            }
        
        return EffMBP;
    }

    
    public static Decimal getPosSetPresOSIG(Relief_Valve__c RvRec){

        Decimal posSetPresOSIG = 0.0;
        if(RvRec.Converted_Pressure_Setting__c != null)
        {
            posSetPresOSIG = RvRec.Converted_Pressure_Setting__c * 16;
        }
        return posSetPresOSIG;
    }

    
    public static Decimal getVacSetPresOSIG(Relief_Valve__c RvRec){

        Decimal vacSetPresOSIG = 0.0;
        if(RvRec.Converted_Vacuum_Setting__c != null)
        {
            vacSetPresOSIG = RvRec.Converted_Vacuum_Setting__c * 16;
         
        }
        return vacSetPresOSIG;
    }

    public static Set<String> getInitialNarrowingRecords(Relief_Valve__c RvRec)
    {
        Set<String> InitialPTCAndSZC = new Set<String>();
        List<RV_Master_Blaster__c> RVMasterBlasterRecords = new List<RV_Master_Blaster__c>();
        Boolean hasClause = false;
        string InitialQuery = 'Select Id, PTC__c, SZC__c from RV_Master_Blaster__c where ';
        //Step1: Filtering of Master Blaster records based on BRAND
        if(String.isNotBlank(RvRec.Brand__c))
        {
            InitialQuery += 'Brand__c = \''+RvRec.Brand__c+ '\'';
            hasClause = true;
        }
        system.debug('RvRec.Brand__c'+RvRec.Brand__c);
        //Step2: Filtering of Master Blaster records based on Relief Type
        if(String.isNotBlank(RvRec.Relief_Type__c))
        {
            if(hasClause)
            {
                InitialQuery += ' and ';
            }
            if(RvRec.Relief_Type__c == 'Pressure')
            {
                InitialQuery += '  PosDir__c = \'Y\' and VacDir__c = \'N\' ';
                hasClause = true;
            }
            if(RvRec.Relief_Type__c == 'Vacuum')
            {
                InitialQuery += '  PosDir__c = \'N\' and VacDir__c = \'Y\' ';
                hasClause = true;
            }
            if(RvRec.Relief_Type__c == 'Pressure & Vacuum')
            {
                InitialQuery += '  PosDir__c = \'Y\' and VacDir__c = \'Y\' ';
                hasClause = true;
                system.debug('InitialQuery'+InitialQuery);
                system.debug('RvRec.Relief_Type__c'+RvRec.Relief_Type__c);
            }
        }
        system.debug('RvRec.Relief_Type__c'+RvRec.Relief_Type__c);
        //Step3: Filtering of Master Blaster records based on Attribute EFFMOP
        /* Commented By Abhishek because EFFMOP calculated in ReliefValveController
        Decimal EFFMop = 0.0;
        Decimal convertedRelievingPressure = 0.0;
        Decimal convertedMaxProcessPressure = 0.0;
        if(RVRec.Constraint_Product_Selection_By_Flow__c )
        {
            if((RvRec.Relief_Type__c == 'Pressure' || RvRec.Relief_Type__c == 'Pressure & Vacuum') && RvRec.Converted_Relieving_Pressure_Value__c != null)
            {
                convertedRelievingPressure =  RvRec.Converted_Relieving_Pressure_Value__c;

            }        
        }  

        if((RvRec.Relief_Type__c == 'Vacuum' || RvRec.Relief_Type__c == 'Pressure & Vacuum') && RvRec.Converted_Max_Process_Pressure__c != null )
        {        
            convertedMaxProcessPressure = RvRec.Converted_Max_Process_Pressure__c;               
        }    
            
        EFFMop = Math.Max(convertedMaxProcessPressure, convertedRelievingPressure);         
        */
        if(hasClause)
        {
            InitialQuery += ' and ';
        }
        InitialQuery += ' MaxMAWP__c >='+ RvRec.EFFMop__c ;
        system.debug('EFFMop'+RvRec.EFFMop__c);
        //Step4: Filtering of Master Blaster records based on Venting
        if(String.isNotBlank(RvRec.Type_of_model__c) && RvRec.Type_of_model__c != 'None')
        {
            
            InitialQuery += ' and Venting__c = \''+ RvRec.Type_of_model__c+ '\'';
        }
        system.debug('RvRec.Type_of_model__c'+RvRec.Type_of_model__c);
        //Step5: Filtering of Master Blaster records based on FA Compliant
        if(String.isNotBlank(RvRec.Is_flame_arrester_needed_with_your_valve__c) && RvRec.Is_flame_arrester_needed_with_your_valve__c != 'None')
        {
            InitialQuery += ' and FA_Combo__c = \''+ RvRec.Is_flame_arrester_needed_with_your_valve__c+ '\'';
        }
        system.debug('RvRec.Is_flame_arrester_needed_with_your_valve__c'+RvRec.Is_flame_arrester_needed_with_your_valve__c);
        //Step6: Filtering of Master Blaster records based on Over Pressure %
        if(String.isNotBlank(RvRec.Type_of_overpressure_valve__c) && RvRec.Type_of_overpressure_valve__c != 'None')
        {
            InitialQuery += ' and OP_Percent__c = '+ decimal.valueOf(RvRec.Type_of_overpressure_valve__c);
        }
        system.debug('RvRec.Type_of_overpressure_valve__c'+RvRec.Type_of_overpressure_valve__c);
        //Step7: Filtering of Master Blaster records based on PED certificate
        system.debug('RvRec.PED_2014_68_EU_CE_mark__c'+RvRec.PED_2014_68_EU_CE_mark__c);
        system.debug('RvRec.Atex_Certificate__c'+RvRec.Atex_Certificate__c);
        system.debug('RvRec.NACE__c'+RvRec.NACE__c);
        if(RvRec.PED_2014_68_EU_CE_mark__c == true)
        {
            system.debug('inside ped');
            InitialQuery += ' and PED__c = \'Y\'';
        }
        //Step8: Filtering of Master Blaster records based on ATEX certificate abd Gas Group
        if(RvRec.Atex_Certificate__c == true)
        {
            InitialQuery += ' and ATEX__c = \'Y\'';
            if(String.isNotBlank(RvRec.Gas_Group__c))
            {
                InitialQuery += ' and GasGroup__c >= '+decimal.valueOf(RvRec.Gas_Group__c);
            }
        }
        //Step9: Filtering of Master Blaster records based on NACE certificate
        if(RvRec.NACE__c == true)
        {
            system.debug('inside nace');
            InitialQuery += ' and NACE__c = \'Y\'';
        }
        //Step10: Filtering of Master Blaster records based on NACE certificate
        if(RvRec.CU_TR__c == true)
        {
            InitialQuery += ' and CUTR__c = \'Y\'';
        }
        system.debug('@@Initial Query'+InitialQuery);
        RVMasterBlasterRecords = database.query(InitialQuery);
        for(RV_Master_Blaster__c rvm : RVMasterBlasterRecords)
        {
            String modelAndSize = 'PTC = '+rvm.PTC__c+', SZC = '+rvm.SZC__c;
            InitialPTCAndSZC.add(modelAndSize);
        }
        System.debug('@@ Passing parameters to getSettingNarrowingSubProcess with ptc szc size = '+InitialPTCAndSZC.size());
        return getSettingNarrowingSubProcess(RvRec , InitialPTCAndSZC);
    }

    //Stage 2: Setting Narrowing Sub process
    //The above narrowed down Model and Size records from Initial Narrowing is further processed down
    public static Set<String> getSettingNarrowingSubProcess(Relief_Valve__c RvRec, Set<String> initialNarrowedSet)
    {
        System.debug('Started Narrow sub process with below values');
        System.debug('@@ RvRec = '+RvRec);
        /*for(String narrowSetValue : initialNarrowedSet)
        {
            System.debug('@@ '+narrowSetValue);
        }*/
        Set<String> subNarrowedPTCAndSZC = new Set<String>();
        Set<String> PTCSet = new Set<String>();
        Set<String> SZCSet = new Set<String>();
        if(initialNarrowedSet.size() > 0)
        {
            Map<String, Set<String>> initalNarrowedValues = getPTCSZCSet(initialNarrowedSet);
            PTCSet.addAll(initalNarrowedValues.get('PTC'));
            SZCSet.addAll(initalNarrowedValues.get('SZC'));
        }

        system.debug('PTCSet.size()***'+PTCSet);
        system.debug('SZCSet.size()***'+SZCSet);
        system.debug('RvRec.Relief_Type__c***'+RvRec.Relief_Type__c);

        if((RvRec.Relief_Type__c == 'Pressure' || RvRec.Relief_Type__c == 'Pressure & Vacuum') && PTCSet.size() > 0 && SZCSet.size() > 0)
        {
            Decimal PosSetPresOSIG = 0.0;
            /* Commented By Abhishek because EFFMBP calculated in ReliefValveController
            Decimal EffMBP = 0.0;
            if(RvRec.V_Converted_Relieving_Vacuum_Value__c != null && RvRec.Converted_Back_Pressure__c != null)
            {
                EffMBP = Math.Max(RvRec.V_Converted_Relieving_Vacuum_Value__c, RvRec.Converted_Back_Pressure__c);
            }
            if(RvRec.V_Converted_Relieving_Vacuum_Value__c	!= null && RvRec.Converted_Back_Pressure__c == null) 
            {
                EffMBP = Math.Max(RvRec.V_Converted_Relieving_Vacuum_Value__c, 0);
            }
            if(RvRec.V_Converted_Relieving_Vacuum_Value__c	== null && RvRec.Converted_Back_Pressure__c != null) 
            {
                
                EffMBP = Math.Max(0, RvRec.Converted_Back_Pressure__c);
                
                system.debug('PosSetPresOSIG*****'+PosSetPresOSIG);
            }*/
            if(RvRec.Converted_Pressure_Setting__c != null)
            {
                PosSetPresOSIG = RvRec.Converted_Pressure_Setting__c * 16;
            }
            system.debug('EffMBP*****'+RvRec.EffMBP__c);
            system.debug('RvRec.Converted_Pressure_Setting__c*****'+RvRec.Converted_Pressure_Setting__c);
            system.debug('PosSetPresOSIG*****'+PosSetPresOSIG);
			system.debug('PosSetting PTC :' +PTCSet);
            system.debug('PosSetting SZC :' +SZCSet);
            List<RV_PosSettingLimits__c> posSettingLimitList = new List<RV_PosSettingLimits__c>();
            posSettingLimitList = [SELECT PTC__c, SZC__c FROM RV_PosSettingLimits__c 
                                   WHERE PTC__c IN: PTCSet AND SZC__c IN: SZCSet AND
                                  BackpressureLL__c <: RvRec.EffMBP__c AND BackpressureUL__c >=: RvRec.EffMBP__c AND
                                  SettingLL__c <: PosSetPresOSIG AND SettingUL__c >=: PosSetPresOSIG];
            system.debug('posSettingLimitList.size()**** '+posSettingLimitList.size());
            system.debug('posSettingLimitList**** '+posSettingLimitList);
            if(posSettingLimitList.size() > 0)
            {
                PTCSet.clear();
                SZCSet.clear();
                for(RV_PosSettingLimits__c rvp: posSettingLimitList)
                {
                    if(String.isNotBlank(rvp.PTC__c))
                    {
                        PTCSet.add(rvp.PTC__c);
                        //system.debug('PosSetting PTC :' +PTCSet);
                    }
                    if(String.isNotBlank(rvp.SZC__c))
                    {
                        SZCSet.add(rvp.SZC__c);
                        //system.debug('PosSetting SZC :' +SZCSet);
                    }
                    String modelAndSize = 'PTC = '+rvp.PTC__c+', SZC = '+rvp.SZC__c;
                    system.debug('PosSetting modelAndSize :' +modelAndSize);
            		subNarrowedPTCAndSZC.add(modelAndSize);
                }
            }
            else
            {
                PTCSet.clear();
                SZCSet.clear();
                subNarrowedPTCAndSZC.clear();
            }
            system.debug('chkk ticket# 161771 posSettingLimitList for p and p&v '+ posSettingLimitList.size());
        }        
        system.debug('subNarrowedPTCAndSZC size '+subNarrowedPTCAndSZC.size());
        system.debug('PTCSet final** '+PTCSet);
        system.debug('SZCSet final** '+ SZCSet);
        system.debug('subNarrowedPTCAndSZC** '+subNarrowedPTCAndSZC);
        if((RvRec.Relief_Type__c == 'Vacuum' || RvRec.Relief_Type__c == 'Pressure & Vacuum' ) && PTCSet.size() > 0 && SZCSet.size() > 0)
        {
            //Decimal EffMop = 0.0;
            Decimal VacSetPresOSIG = 0.0;
            VacSetPresOSIG = RvRec.Converted_Vacuum_Setting__c * 16;
            system.debug('VacSetPresOSIG'+VacSetPresOSIG);
            List<RV_VacSettingLimits__c> vacSettingLimitList = new List<RV_VacSettingLimits__c>();
            vacSettingLimitList = [SELECT Id, PTC__c, SZC__c FROM RV_VacSettingLimits__c
                                  WHERE PTC__c IN: PTCSet AND SZC__c IN:SZCSet
                                  AND BackpressureLL__c <: RvRec.EFFMop__c AND BackpressureUL__c >=: RvRec.EFFMop__c
                                  AND SettingLL__c <: VacSetPresOSIG AND SettingUL__c >=: VacSetPresOSIG];
            system.debug('vacSettingLimitList'+VacSetPresOSIG);
            system.debug('vacSettingLimitList.size()'+vacSettingLimitList.size());
            if(vacSettingLimitList.size() > 0)
            {
                Set<String> subNarrowedPTCAndSZCVac = new Set<String>();
                if(!subNarrowedPTCAndSZC.isEmpty() && subNarrowedPTCAndSZC.size() > 0)
                {
                    subNarrowedPTCAndSZCVac.addall(subNarrowedPTCAndSZC);
                }
                subNarrowedPTCAndSZC.clear();
                for(RV_VacSettingLimits__c rvc : vacSettingLimitList)
                {
                    String modelAndSize = 'PTC = '+rvc.PTC__c+', SZC = '+rvc.SZC__c;
                    if(subNarrowedPTCAndSZCVac.isEmpty() || subNarrowedPTCAndSZCVac.contains(modelAndSize))
                    {
                        subNarrowedPTCAndSZC.add(modelAndSize);
                        system.debug('@@ subNarrowedPTCAndSZC insode for '+modelAndSize);
                    }
                    /*else if(subNarrowedPTCAndSZCVac.isEmpty())
                    {
                        //String modelAndSize = 'PTC = '+rvc.PTC__c+', SZC = '+rvc.SZC__c;
                        subNarrowedPTCAndSZC.add(modelAndSize);
                    }*/
                }
            }else {
                //Support Ticket# 161771 
                //if P&V  And vacSettingLimitList =0, simply reset /clear,
                subNarrowedPTCAndSZC.clear();
                PTCSet.clear();
                SZCSet.clear();
            }
        }
        system.debug('@@ subNarrowedPTCAndSZC'+subNarrowedPTCAndSZC);
        if(RvRec.Constraint_Product_Selection_By_Flow__c)
        {
            return getFlowNarrowingSubProcess(RvRec,subNarrowedPTCAndSZC);
        }
        System.debug('chkkk subNarrowedPTCAndSZC size '+subNarrowedPTCAndSZC.size());
        return subNarrowedPTCAndSZC;
    }
    

    public class FlowNarrowingProcessWrapper{
        @AuraEnabled
        public RV_Master_Blaster__c masterBlasterRecord{get;set;}
        @AuraEnabled
        public Decimal EffPosP1{get;set;}
        @AuraEnabled
        public Decimal EffPosPresRatio{get;set;}
        @AuraEnabled
        public Decimal EffPosOP{get;set;}
        @AuraEnabled
        public Decimal EffVacP2{get;set;}
        @AuraEnabled
        public Decimal EffVacPresRatio{get;set;}
        @AuraEnabled
        public Decimal EffVacOP{get;set;}

        public FlowNarrowingProcessWrapper(RV_Master_Blaster__c masterBlasterRecord, Decimal EffPosP1, Decimal EffPosPresRatio, Decimal EffPosOP, Decimal EffVacP2, Decimal EffVacPresRatio, Decimal EffVacOP) 
        {
            this.masterBlasterRecord = masterBlasterRecord;
            this.EffPosP1 = EffPosP1;
            this.EffPosPresRatio = EffPosPresRatio;
            this.EffPosOP = EffPosOP;
            this.EffVacP2 = EffVacP2;
            this.EffVacPresRatio = EffVacPresRatio;
            this.EffVacOP = EffVacOP;
        }
    }

    // Flow Check Steps
    public static Set<String> getFlowNarrowingSubProcess(Relief_Valve__c RvRec, Set<String> initialNarrowedSet)
    {
        system.debug(' @@ inside getFlowNarrowingSubProcess');
        System.debug('@@ RvRec = '+RvRec);
        for(String settingnarrow: initialNarrowedSet)
        {
            System.debug('@@ '+settingnarrow);
        }
        
        Decimal PosP1 = 0.0, PosP2 = 0.0, VacP1 = 0.0, VacP2 = 0.0;
        // Separate initialNarrowedSet into PTC and SZC 
        Set<String> flowNarrowedPTCAndSZC = new Set<String>();
        Set<String> PTCSet = new Set<String>();
        Set<String> SZCSet = new Set<String>();       
        if(initialNarrowedSet.size() > 0)
        {
            Map<String, Set<String>> initalNarrowedValues = getPTCSZCSet(initialNarrowedSet);
            PTCSet.addAll(initalNarrowedValues.get('PTC'));
            SZCSet.addAll(initalNarrowedValues.get('SZC'));
        }
        if(RvRec.Relief_Type__c == 'Pressure' || RvRec.Relief_Type__c == 'Pressure & Vacuum'){
            Posp1 = RvRec.Converted_Atmospheric_Pressure__c + RvRec.Converted_Relieving_Pressure_Value__c;
            PosP2 = RvRec.Converted_Atmospheric_Pressure__c + RvRec.Converted_Back_Pressure__c;
            system.debug(' Posp1 ***'+Posp1);                
            system.debug(' PosP2 ***'+PosP2);
        }
        
        if(RvRec.Relief_Type__c == 'Vacuum' || RvRec.Relief_Type__c == 'Pressure & Vacuum'){
            VacP2 = RvRec.Converted_Atmospheric_Pressure__c - RvRec.V_Converted_Relieving_Vacuum_Value__c;
            VacP1 = RvRec.Converted_Atmospheric_Pressure__c;
            
            system.debug(' VacP2 ***'+VacP2);
            system.debug(' VacP1 ***'+VacP1);
        }
        

        // query Master Blaster and insert in respective Maps rvMasterBlasterMap and masterBlasterCMethod
        Map<String, FlowNarrowingProcessWrapper> rvMasterBlasterMap = new Map<String, FlowNarrowingProcessWrapper>();
        Set<String> masterBlasterCMethod = new Set<String>();
        for(RV_Master_Blaster__c rvMaster: [SELECT Id,PTC__c,SZC__c,PosCMethod__c,VacCMethod__c,PosIntMethod__c,VacIntMethod__c,VacFullOP__c,PosFullOP__c,PosEffDia__c,VacEffDia__c
                                            FROM RV_Master_Blaster__c 
                                            WHERE PTC__c IN:PTCSet AND SZC__c IN:SZCSet])
        {
            system.debug(' rvMaster'+rvMaster);
            if(String.isNotBlank(rvMaster.SZC__c) && String.isNotBlank(rvMaster.PTC__c))
            {

                Decimal EffPosP1 = 0.0, EffPosPresRatio = 0.0, EffPosOP = 0.0;
                Decimal EffVacP2 = 0.0, EffVacPresRatio = 0.0, EffVacOP = 0.0;

                //Step1,2,3 Pressure      
                if(RvRec.Relief_Type__c == 'Pressure' || RvRec.Relief_Type__c == 'Pressure & Vacuum') {
                    EffPosP1 = math.max(Posp1,RvRec.Converted_Atmospheric_Pressure__c + RvRec.Converted_Back_Pressure__c + RvRec.Converted_Pressure_Setting__c * (1+rvMaster.PosFullOP__c/100));
                    system.debug(' EffPosP1 ***'+EffPosP1);
                    
                    if(null != EffPosP1  && EffPosP1 != 0 )
                    {
                        EffPosPresRatio = PosP2/EffPosP1;
                    }        
                    EffPosOP = math.min(rvMaster.PosFullOP__c, (((RvRec.Converted_Relieving_Pressure_Value__c - RvRec.Converted_Back_Pressure__c)/RvRec.Converted_Pressure_Setting__c * 100)-100).setScale(6));
                    system.debug(' EffPosPresRatio ***'+EffPosPresRatio);
                    system.debug(' EffPosOP ***'+EffPosOP);
                }        
                

                //Step 1,2,3 Vacuum
                if(RvRec.Relief_Type__c == 'Vacuum' || RvRec.Relief_Type__c == 'Pressure & Vacuum'){
                    EffVacP2 = math.min(VacP2, (RvRec.Converted_Atmospheric_Pressure__c - (RvRec.Converted_Vacuum_Setting__c)* (1 + rvMaster.VacFullOP__c / 100 )));
                    system.debug(' EffVacP2 ***'+EffVacP2);
    
                    if( null != VacP1 && VacP1 != 0 ){
                        EffVacPresRatio = EffVacP2 / VacP1 ;
                    }
                    EffVacOP = math.min(rvMaster.VacFullOP__c,( RvRec.V_Converted_Relieving_Vacuum_Value__c / RvRec.Converted_Vacuum_Setting__c * 100 - 100 ).setScale(6));
                    system.debug(' EffVacOP ***'+EffVacOP);
                    system.debug(' EffVacPresRatio ***'+EffVacPresRatio);
                }
                


                String keyValue = 'PTC = '+rvMaster.PTC__c+', SZC = '+rvMaster.SZC__c; 
               /* if(!rvMasterBlasterMap.containsKey(keyValue))
                {
                    rvMasterBlasterMap.put(keyValue, new FlowNarrowingProcessWrapper(rvMaster, EffPosP1, EffPosPresRatio, EffPosOP, EffVacP2, EffVacPresRatio,EffVacOP ));
                }
                rvMasterBlasterMap.get(keyValue).add(flowNarrowingWrapper);*/
                rvMasterBlasterMap.put(keyValue, new FlowNarrowingProcessWrapper(rvMaster, EffPosP1, EffPosPresRatio, EffPosOP, EffVacP2, EffVacPresRatio,EffVacOP ));
                if(String.isNotBlank(rvMaster.PosCMethod__c))
                {
                    masterBlasterCMethod.add(rvMaster.PosCMethod__c);
                }
                if(String.isNotBlank(rvMaster.VacCMethod__c))
                {
                    masterBlasterCMethod.add(rvMaster.VacCMethod__c);
                } 
            }
        }

        // query C Factor and Model Size and insert in respective Maps rvCFactorMap and (ModelSizeFlowMapPOS & ModelSizeFlowMapVAC)
        Map<String, list<RV_ModelSizeFlow__c>> ModelSizeFlowMapPOS = new Map<String, list<RV_ModelSizeFlow__c>>();
        Map<String, list<RV_ModelSizeFlow__c>> ModelSizeFlowMapVAC = new Map<String, list<RV_ModelSizeFlow__c>>();
        Map<String, list<RV_CFactor__c>> rvCFactorMap = new Map<String, list<RV_CFactor__c>>();
        for(RV_CFactor__c cfactor: [SELECT Id,OP__c,CFactor__c,CMethod__c
                                   FROM RV_CFactor__c
                                   WHERE CMethod__c IN: masterBlasterCMethod])
        {
            if(String.isNotBlank(cfactor.CMethod__c))
            {
                if(!rvCFactorMap.containsKey(cfactor.CMethod__c))
                {
                    rvCFactorMap.put(cfactor.CMethod__c, new List<RV_CFactor__c>());
                }
                rvCFactorMap.get(cfactor.CMethod__c).add(cfactor);
            }
        }

        system.debug(' rvCFactorMap ***'+rvCFactorMap);

        // Model Size Flow
        for(RV_ModelSizeFlow__c rvModel: [SELECT PTC__c,SZC__c,Direction__c,KD__c,PressureRatio__c
                                          FROM RV_ModelSizeFlow__c 
                                          WHERE PTC__c IN:PTCSet AND SZC__c IN:SZCSet AND
                                          ((Direction__c = 'Pos' ) OR 
                                         (Direction__c = 'Vac' ))])
                                         //AND PressureRatio__c >: EffPosPresRatio AND PressureRatio__c >: EffVacPresRatio
        {
            system.debug(' rvModel ***'+rvModel);
            if(String.isNotBlank(rvModel.SZC__c) && String.isNotBlank(rvModel.PTC__c))
            {
                String keyValue = 'PTC = '+rvModel.PTC__c+', SZC = '+rvModel.SZC__c; 
                if(rvModel.Direction__c == 'Pos')
                {
                    if(!ModelSizeFlowMapPOS.containsKey(keyValue))
                    {
                        ModelSizeFlowMapPOS.put(keyValue, new List<RV_ModelSizeFlow__c>());
                    }
                    ModelSizeFlowMapPOS.get(keyValue).add(rvModel);
                }
                else if(rvModel.Direction__c == 'Vac')
                {
                    if(!ModelSizeFlowMapVAC.containsKey(keyValue))
                    {
                        ModelSizeFlowMapVAC.put(keyValue, new List<RV_ModelSizeFlow__c>());
                    }
                    ModelSizeFlowMapVAC.get(keyValue).add(rvModel);
                }
            }
        }
       
        system.debug(' ModelSizeFlowMapPOS ***'+ModelSizeFlowMapPOS.size());
        system.debug(' ModelSizeFlowMapVAC ***'+ModelSizeFlowMapVAC.size());
  
        // Call method getFlowNarrowingSubPosProcess on the basis of Pressure and Vacuum
        if(RvRec.Relief_Type__c == 'Pressure')
        {
            Map<String,Object> parametersPosMap = new Map<String,Object>();
           // parametersPosMap.put('EffPosPresRatio',EffPosPresRatio);
           // parametersPosMap.put('EffPosOP',EffPosOP);
            //parametersPosMap.put('EffPosP1',EffPosP1);
            parametersPosMap.put('rvMasterBlasterMap',rvMasterBlasterMap);
            parametersPosMap.put('ModelSizeFlowMapPOS',ModelSizeFlowMapPOS);
            parametersPosMap.put('rvCFactorMap',rvCFactorMap);
            flowNarrowedPTCAndSZC.addAll(getFlowNarrowingSubPosProcess(RvRec, parametersPosMap));
        }
        else if(RvRec.Relief_Type__c == 'Vacuum')
        {
            Map<String,Object> parametersVacMap = new Map<String,Object>();
           // parametersVacMap.put('EffVacPresRatio',EffVacPresRatio);
            //parametersVacMap.put('EffVacOP',EffVacOP);
            //parametersVacMap.put('EffVacP1',EffVacP1);
            parametersVacMap.put('rvMasterBlasterMap',rvMasterBlasterMap);
            parametersVacMap.put('ModelSizeFlowMapVAC',ModelSizeFlowMapVAC);
            parametersVacMap.put('rvCFactorMap',rvCFactorMap);
            flowNarrowedPTCAndSZC.addAll(getFlowNarrowingSubVacProcess(RvRec, parametersVacMap));
        }
        else if(RvRec.Relief_Type__c == 'Pressure & Vacuum')
        {
            Map<String,Object> parametersMap = new Map<String,Object>();
            //parametersMap.put('EffPosPresRatio',EffPosPresRatio);
            //parametersMap.put('EffPosOP',EffPosOP);
            //parametersMap.put('EffPosP1',EffPosP1);
            parametersMap.put('rvMasterBlasterMap',rvMasterBlasterMap);
            parametersMap.put('ModelSizeFlowMapPOS',ModelSizeFlowMapPOS);
            parametersMap.put('rvCFactorMap',rvCFactorMap);
            Set<String> flowNarrowPosPTCSZC = new Set<String>();
            flowNarrowPosPTCSZC.addAll(getFlowNarrowingSubPosProcess(RvRec, parametersMap));
            //parametersMap.put('EffVacPresRatio',EffVacPresRatio);
            //parametersMap.put('EffVacOP',EffVacOP);
            //parametersMap.put('EffVacP1',EffVacP1);
            parametersMap.put('ModelSizeFlowMapVAC',ModelSizeFlowMapVAC);
            parametersMap.put('flowNarrowPosPTCSZC',flowNarrowPosPTCSZC);
            parametersMap.put('rvCFactorMap',rvCFactorMap);
            Set<String> flowNarrowVacPTCSZC = new Set<String>();
            flowNarrowVacPTCSZC = getFlowNarrowingSubVacProcess(RvRec, parametersMap);
            for(String VacPTCSZC: flowNarrowVacPTCSZC)
            {
                if(flowNarrowPosPTCSZC.contains(VacPTCSZC))
                {
                    flowNarrowedPTCAndSZC.add(VacPTCSZC);
                }
            }
            //flowNarrowedPTCAndSZC.addAll(getFlowNarrowingSubVacProcess(RvRec, parametersMap));
            
        }
        system.debug(' flowNarrowedPTCAndSZC ***'+flowNarrowedPTCAndSZC);
        return flowNarrowedPTCAndSZC;
    }
    
    public static Set<String> getFlowNarrowingSubPosProcess(Relief_Valve__c RvRec, Map<String,Object> parametersMap)
    {
        Set<String> flowNarrowedPOSPTCAndSZC = new Set<String>();
        system.debug(' Inside getFlowNarrowingSubPosProcess');
        //store the parametersMap in seperate variables
        //Decimal EffPosPresRatio = (Decimal)parametersMap.get('EffPosPresRatio');
        //Decimal EffPosOP = (Decimal)parametersMap.get('EffPosOP');
        //Decimal EffPosP1 = (Decimal)parametersMap.get('EffPosP1');
        Map<String, FlowNarrowingProcessWrapper> rvMasterBlasterMap = (Map<String, FlowNarrowingProcessWrapper>)parametersMap.get('rvMasterBlasterMap');
       // Map<String, list<RV_Master_Blaster__c>> rvMasterBlasterMap = (Map<String, list<RV_Master_Blaster__c>>)parametersMap.get('rvMasterBlasterMap');
        Map<String, list<RV_ModelSizeFlow__c>> ModelSizeFlowMapPOS = (Map<String, list<RV_ModelSizeFlow__c>>)parametersMap.get('ModelSizeFlowMapPOS');
        Map<String, list<RV_CFactor__c>> rvCFactorMap = (Map<String, list<RV_CFactor__c>>)parametersMap.get('rvCFactorMap');

        Decimal PosCritical = math.exp((RvRec.Ratio_of_Specific_Heats__c / (RvRec.Ratio_of_Specific_Heats__c - 1) )*math.log(( 2 / (RvRec.Ratio_of_Specific_Heats__c + 1) )));
        system.debug(' PosCritical*** '+PosCritical);
        // Process all the records in the Master Blaster table under rvMasterBlasterMap with reference to (PTC and SZC) key
        for(String mapKey: rvMasterBlasterMap.Keyset())
        {

            FlowNarrowingProcessWrapper flowNarrowingWrapper = rvMasterBlasterMap.get(mapKey);
            
            Decimal presRatioLow = 0.0, KDLow = 0.0, presRatioHigh = 0.0, KDHigh = 0.0, posKD = 0.0;

            Decimal opLow = 0.0, cFactorLow = 0.0, opHigh = 0.0, cFactorHigh = 0.0, posCFactor = 0.0, PosFlowRateValve = 0.0;
            //PosEffDia = 0.0;
            Decimal Part1posflw = 0.0, Part2posflw = 0.0, Part3posflw = 0.0, Part4posflw = 0.0;
            //Check if the key (PTC and SZC) is present in ModelSizeFlowMapPOS 
            if(ModelSizeFlowMapPOS.containsKey(mapKey))
            {
                /*
                "Select the Minimum ModelSizeFlow.PresRatio where
                MasterBlaster.PTC = ModelSizeFlow.PTC and
                MasterBlaster.SZC = ModelSizeFlow.SZC and
                ModelSizeFlow.Direction = ""Pos""
                ModelSizeFlow.PresRatio > EffPosPresRatio
                This may return no records"
                Select ModelSizeFlow.KD corresponding to PRESRATIOLOW
                "Select the Maximum ModelSizeFlow.PresRatio where
                MasterBlaster.PTC = ModelSizeFlow.PTC and
                MasterBlaster.SZC = ModelSizeFlow.SZC and
                ModelSizeFlow.Direction = ""Pos""
                ModelSizeFlow.PresRatio <= EffPosPresRatio
                This may return no records"

                */
                List<RV_ModelSizeFlow__c> modelSizeFlowList = new List<RV_ModelSizeFlow__c>();
                modelSizeFlowList.addAll(ModelSizeFlowMapPOS.get(mapKey));
                decimal lowDiff;
                decimal highDiff;

                /*Initialize presRatioLow, KDLow, presRatioHigh, KDHigh and calculate
                presRatioLow = modelSizeFlowList[0].PressureRatio__c;
                KDLow = modelSizeFlowList[0].KD__c;
                presRatioHigh = modelSizeFlowList[modelSizeFlowList.size()-1].PressureRatio__c;
                KDHigh = modelSizeFlowList[modelSizeFlowList.size()-1].KD__c;*/

                for(RV_ModelSizeFlow__c rvModelFlow : modelSizeFlowList)
                {
                    decimal diff = rvModelFlow.PressureRatio__c - flowNarrowingWrapper.EffPosPresRatio;
                    if(diff > 0 && (highDiff > diff || highDiff == null)){
                        highDiff = diff;
                        presRatioLow = rvModelFlow.PressureRatio__c;
                        KDLow = rvModelFlow.KD__c;
                    }

                    if(diff <= 0 && (lowDiff <= diff || lowDiff == null)){
                        lowDiff = diff;
                        
                        presRatioHigh = rvModelFlow.PressureRatio__c;
                        KDHigh = rvModelFlow.KD__c;
                    }

                    /*if(presRatioHigh >= rvModelFlow.PressureRatio__c &&  rvModelFlow.PressureRatio__c <= flowNarrowingWrapper.EffPosPresRatio)
                    {
                       
                       presRatioHigh = rvModelFlow.PressureRatio__c;
                       KDHigh = rvModelFlow.KD__c;       
                    }
                    else if(rvModelFlow.PressureRatio__c > flowNarrowingWrapper.EffPosPresRatio)
                    {
                       
                       presRatioLow = rvModelFlow.PressureRatio__c;
                       KDLow = rvModelFlow.KD__c;
                       break;
                    }*/
                }
            }

            //Calculate posKD
            if(presRatioLow != 0.0 && presRatioHigh != 0.0 && ((presRatioLow - presRatioHigh) != 0.0 || ( math.log(presRatioLow) -  math.log(presRatioHigh)) != 0.0))
            {
                if(flowNarrowingWrapper.masterBlasterRecord.PosIntMethod__c == 'Linear')
                {
                    posKD = (flowNarrowingWrapper.EffPosPresRatio - presRatioHigh) * (KDLow - KDHigh ) / (presRatioLow - presRatioHigh) + KDHigh;
                }
                else if(flowNarrowingWrapper.masterBlasterRecord.PosIntMethod__c == 'Power')
                {
                    //posKD = math.exp((math.log(EffPosPresRatio) - math.log(presRatioHigh)) * (math.log(KDLow) - math.log(KDHigh)) / (Denominator) + math.log(KDHigh));
                   posKD = math.exp((math.log(flowNarrowingWrapper.EffPosPresRatio) - math.log(presRatioHigh)) * (math.log(KDLow) - math.log(KDHigh)) / ( math.log(presRatioLow) -  math.log(presRatioHigh)) + math.log(KDHigh));
                }
            }
            /*"Select the Minimum CFactor.OP where
            MasterBlaster.PosCMethod = CFactor.CMethod and
            CFactor.OP > EffPosOP"
            Select the CFactor corresponding to OPLOW
            "Select the Maximum CFactor.OP where
            MasterBlaster.PosCMethod = CFactor.CMethod and
            CFactor.OP <= EffPosOP"
            Select the CFactor corresponding to OPHIGH

            */
            decimal highDiff;
            decimal lowDiff;
            // Did not check the code from here   START
            String cmethod = flowNarrowingWrapper.masterBlasterRecord.PosCMethod__c;
            if(String.isNotBlank(cmethod) && rvCFactorMap.containsKey(cmethod))
            {
                /*opLow = rvCFactorMap.get(cmethod)[0].OP__c;
                cFactorLow = rvCFactorMap.get(cmethod)[0].CFactor__c;
                opHigh = rvCFactorMap.get(cmethod)[rvCFactorMap.get(cmethod).size()-1].OP__c;
                cFactorHigh = rvCFactorMap.get(cmethod)[rvCFactorMap.get(cmethod).size()-1].CFactor__c;*/
                for(RV_CFactor__c rvFactor : rvCFactorMap.get(cmethod))
                {

                    decimal diff = rvFactor.OP__c - flowNarrowingWrapper.EffPosOP;
                    if(diff > 0 && (highDiff > diff || highDiff == null)){
                        highDiff = diff;
                        opLow = rvFactor.OP__c;
                        cFactorLow = rvFactor.CFactor__c;
                         
                    }

                    if(diff <= 0 && (lowDiff <= diff || lowDiff == null)){
                        lowDiff = diff;
                        opHigh = rvFactor.OP__c;
                        cFactorHigh = rvFactor.CFactor__c;
                        
                    }
                    
                  /* if(opHigh >= rvFactor.OP__c &&  rvFactor.OP__c <= flowNarrowingWrapper.EffPosOP)
                   {
                        //Code commented By Abhishek wrt Test Scenario 3
						opHigh = rvFactor.OP__c;
                        cFactorHigh = rvFactor.CFactor__c; 
                              
                      
                   }
                   else if(rvFactor.OP__c > flowNarrowingWrapper.EffPosOP)
                   {
                        //Code commented By Abhishek wrt Test Scenario 3
                        opLow = rvFactor.OP__c;
                        cFactorLow = rvFactor.CFactor__c; 
                        break;
                   }*/
                }
            }
            Decimal a = 0.0, b = 0.0, c = 0.0, d = 0.0;
            a = (flowNarrowingWrapper.EffPosOP - OPHIGH);
            b = (CFactorLOW - CFactorHIGH);
            c = (OPLOW - OPHIGH);
            d = CFactorHIGH;
            if(c == 0)
            {
                posCFactor = d;
            }
            else
            {
                posCFactor = (a*b/c)+d;
            }
            System.debug('%%% EffPosPresRatio = '+flowNarrowingWrapper.EffPosPresRatio+', PosCritical = '+PosCritical);
            if(flowNarrowingWrapper.EffPosPresRatio >= PosCritical)
            {
                if(flowNarrowingWrapper.masterBlasterRecord.PosEffDia__c != 0){
                    Part1posflw = posCFactor * 278700 * posKD * flowNarrowingWrapper.EffPosP1 * math.exp(2 * math.log(flowNarrowingWrapper.masterBlasterRecord.PosEffDia__c)) * math.atan(1);
                    system.debug('@@posCFactor: '+ posCFactor + ' posKD: ' +posKD + ' EffPosP1: ' +flowNarrowingWrapper.EffPosP1);
                }
                else{
                    Part1posflw = 0.0;  
                }
                
                Part2posflw = (RvRec.Ratio_of_Specific_Heats__c/(RvRec.Molecular_Weight__c * RvRec.Converted_Pressure_Relieving_Temperature__c * RvRec.Compressibility_Factor__c * (RvRec.Ratio_of_Specific_Heats__c -1)));
                system.debug('@@Part 1: '+Part1posflw);
                system.debug('@@Part 2: '+Part2posflw);
                Part3posflw = math.exp((2/RvRec.Ratio_of_Specific_Heats__c) * math.log(flowNarrowingWrapper.EffPosPresRatio));
                system.debug('@@Part 3: '+Part3posflw);
                Part4posflw = math.exp(((RvRec.Ratio_of_Specific_Heats__c + 1)/RvRec.Ratio_of_Specific_Heats__c) * math.log(flowNarrowingWrapper.EffPosPresRatio));
                system.debug('@@Part 4: '+Part4posflw);
                PosFlowRateValve = Part1posflw * math.exp(0.5 * math.log(Part2posflw * (Part3posflw - Part4posflw)));
                system.debug('@@ PosFlowRateValve: '+PosFlowRateValve);
            }
            else
            {
                if(flowNarrowingWrapper.masterBlasterRecord.PosEffDia__c != 0){
                    Part1posflw = posCFactor * 60 * 6.32 * 520 * posKD * flowNarrowingWrapper.EffPosP1 * math.exp(2 * math.log(flowNarrowingWrapper.masterBlasterRecord.PosEffDia__c)) * math.atan(1);
                }
                else{
                    Part1posflw = 0.0;  
                }
               
                Part2posflw = (RvRec.Molecular_Weight__c * RvRec.Converted_Pressure_Relieving_Temperature__c * RvRec.Compressibility_Factor__c);
                Part3posflw = (2 / (RvRec.Ratio_of_Specific_Heats__c + 1));
                Part4posflw = ((RvRec.Ratio_of_Specific_Heats__c + 1) / (RvRec.Ratio_of_Specific_Heats__c - 1));
                PosFlowRateValve = Part1posflw * math.exp(0.5 * math.log((RvRec.Ratio_of_Specific_Heats__c / (Part2posflw) * math.exp(Part4posflw * math.log(Part3posflw)))));
            }

            system.debug('PRESRATIOLOW ** '+PRESRATIOLOW+'KDLOW ** '+KDLOW+'PRESRATIOHIGH '+PRESRATIOHIGH+'KDHIGH '+KDHIGH+'POSKD'+POSKD);
            system.debug('OPLOW ** '+OPLOW+'CFactorLOW ** '+CFactorLOW+'OPHIGH '+OPHIGH+'CFactorHIGH '+CFactorHIGH+'PosCFactor'+PosCFactor);
            system.debug('PTC and Size ** '+mapKey+'PosFlowRateValve ** '+PosFlowRateValve);
            
            if(PosFlowRateValve >= RvRec.Converted_Pressure_Relief_Req_Flow__c)
            {

                String modelAndSize = 'PTC = '+flowNarrowingWrapper.masterBlasterRecord.PTC__c+', SZC = '+flowNarrowingWrapper.masterBlasterRecord.SZC__c;
                flowNarrowedPOSPTCAndSZC.add(modelAndSize);
                system.debug('flowNarrowedPOSPTCAndSZC.size()** '+flowNarrowedPOSPTCAndSZC.size());
            }
            // Did not check the code from here   END
        }
        return flowNarrowedPOSPTCAndSZC;
    }
    
   	public static Set<String> getFlowNarrowingSubVacProcess(Relief_Valve__c RvRec, Map<String,Object> parametersMap)
    {
        Set<String> flowNarrowedVACPTCAndSZC = new Set<String>();
        system.debug(' Inside getFlowNarrowingSubVacProcess');
        //store the parametersMap in seperate variables
        //Decimal EffVacPresRatio = (Decimal)parametersMap.get('EffVacPresRatio');
        //Decimal EffVacOP = (Decimal)parametersMap.get('EffVacOP');
        Map<String, FlowNarrowingProcessWrapper> rvMasterBlasterMap = (Map<String, FlowNarrowingProcessWrapper>)parametersMap.get('rvMasterBlasterMap');
        Map<String, list<RV_ModelSizeFlow__c>> ModelSizeFlowMapVAC = (Map<String, list<RV_ModelSizeFlow__c>>)parametersMap.get('ModelSizeFlowMapVAC');
        Map<String, list<RV_CFactor__c>> rvCFactorMap = (Map<String, list<RV_CFactor__c>>)parametersMap.get('rvCFactorMap');
        Decimal VacCritical = math.exp((RvRec.V_Ratio_of_Specific_Heats__c / (RvRec.V_Ratio_of_Specific_Heats__c - 1) )*math.log(( 2 / (RvRec.V_Ratio_of_Specific_Heats__c + 1) )));
        system.debug(' VacCritical*** '+VacCritical);
        // Filter the master blaster records based on relief Type
        Set<String> iterateMasterBlasterMapKeys = new Set<String>();
        if(RvRec.Relief_Type__c == 'Pressure & Vacuum')
        {
            if(parametersMap.containsKey('flowNarrowPosPTCSZC'))
            {
                iterateMasterBlasterMapKeys = (Set<String>)parametersMap.get('flowNarrowPosPTCSZC');
            }
        }
        else
        {
            iterateMasterBlasterMapKeys = rvMasterBlasterMap.keySet();
        }

        // Process all the records in the Master Blaster table under iterateMasterBlasterMapKeys with reference to (PTC and SZC) key
        if(iterateMasterBlasterMapKeys.size() > 0)
        {
            for(String mapKey: iterateMasterBlasterMapKeys)
            {

                FlowNarrowingProcessWrapper flowNarrowingWrapper = rvMasterBlasterMap.get(mapKey);
                Decimal Part1vacflw = 0.0, Part2vacflw = 0.0, Part3vacflw = 0.0, Part4vacflw = 0.0;
                Decimal presRatioLow = 0.0, KDLow = 0.0, presRatioHigh = 0.0, KDHigh = 0.0, vacKD = 0.0;

                Decimal opLow = 0.0, cFactorLow = 0.0, opHigh = 0.0, cFactorHigh = 0.0, VacCFactor = 0.0, VacFlowRateValve = 0.0;
                //VacEffDia = 0.0;

                //Check if the key (PTC and SZC) is present in ModelSizeFlowMapVAC 
                if(ModelSizeFlowMapVAC.containsKey(mapKey))
                {
                    List<RV_ModelSizeFlow__c> modelSizeFlowList = new List<RV_ModelSizeFlow__c>();
                    modelSizeFlowList.addAll(ModelSizeFlowMapVAC.get(mapKey));

                    //Initialize presRatioLow, KDLow, presRatioHigh, KDHigh and calculate
                    /*presRatioLow = modelSizeFlowList[0].PressureRatio__c;
                    KDLow = modelSizeFlowList[0].KD__c;
                    presRatioHigh = modelSizeFlowList[modelSizeFlowList.size()-1].PressureRatio__c;
                    KDHigh = modelSizeFlowList[modelSizeFlowList.size()-1].KD__c;*/
                    decimal lowDiff;
                    decimal highDiff;
                    for(RV_ModelSizeFlow__c rvModelFlow : modelSizeFlowList)
                    {
                        decimal diff = rvModelFlow.PressureRatio__c - flowNarrowingWrapper.EffVacPresRatio;
                        if(diff > 0 && (highDiff > diff || highDiff == null)){
                            highDiff = diff;
                            presRatioLow = rvModelFlow.PressureRatio__c;
                            KDLow = rvModelFlow.KD__c;
                            
                        }
    
                        if(diff <= 0 && (lowDiff <= diff || lowDiff == null)){
                            lowDiff = diff;
                            presRatioHigh = rvModelFlow.PressureRatio__c;
                            KDHigh = rvModelFlow.KD__c;
                        }

                       /* if(presRatioHigh >= rvModelFlow.PressureRatio__c &&  rvModelFlow.PressureRatio__c <= flowNarrowingWrapper.EffVacPresRatio)
                        {
                        
                        presRatioHigh = rvModelFlow.PressureRatio__c;
                        KDHigh = rvModelFlow.KD__c;       
                        }
                        else if(rvModelFlow.PressureRatio__c > flowNarrowingWrapper.EffVacPresRatio)
                        {
                        
                        presRatioLow = rvModelFlow.PressureRatio__c;
                        KDLow = rvModelFlow.KD__c;
                        break;
                        }*/
                    }
                }

                //Calculate vacKD
                if(presRatioLow != 0.0 && presRatioHigh != 0.0 && ((presRatioLow - presRatioHigh) != 0.0 || ( math.log(presRatioLow) -  math.log(presRatioHigh)) != 0.0))
                if(presRatioLow != 0.0 && presRatioHigh != 0.0)
                {
                    if(flowNarrowingWrapper.masterBlasterRecord.VacIntMethod__c == 'Linear')
                    {
                        
                        vacKD = (flowNarrowingWrapper.EffVacPresRatio - presRatioHigh) * (KDLow - KDHigh ) / (presRatioLow - presRatioHigh) + KDHigh;
                    }
                    else if(flowNarrowingWrapper.masterBlasterRecord.VacIntMethod__c == 'Power')
                    {
                        vacKD = math.exp((math.log(flowNarrowingWrapper.EffVacPresRatio) - math.log(presRatioHigh)) * (math.log(KDLow) - math.log(KDHigh)) / ( math.log(presRatioLow) -  math.log(presRatioHigh)) + math.log(KDHigh));
                    }
                }

                // Did not check the code from here   START
                String cmethod = flowNarrowingWrapper.masterBlasterRecord.VacCMethod__c;
                if(String.isNotBlank(cmethod) && rvCFactorMap.containsKey(cmethod))
                {
                    /*opLow = rvCFactorMap.get(cmethod)[0].OP__c;
                    cFactorLow = rvCFactorMap.get(cmethod)[0].CFactor__c;
                    opHigh = rvCFactorMap.get(cmethod)[rvCFactorMap.get(cmethod).size()-1].OP__c;
                    cFactorHigh = rvCFactorMap.get(cmethod)[rvCFactorMap.get(cmethod).size()-1].CFactor__c;*/
                    decimal lowDiff;
                    decimal highDiff;
                    for(RV_CFactor__c rvFactor : rvCFactorMap.get(cmethod))
                    {
                        decimal diff = rvFactor.OP__c - flowNarrowingWrapper.EffVacOP;
                        if(diff > 0 && (highDiff > diff || highDiff == null)){
                            highDiff = diff;
                            opLow = rvFactor.OP__c;
                            cFactorLow = rvFactor.CFactor__c;
                             
                        }

                        if(diff <= 0 && (lowDiff <= diff || lowDiff == null)){
                            lowDiff = diff;
                            opHigh = rvFactor.OP__c;
                            cFactorHigh = rvFactor.CFactor__c;
                            
                        }
                       /* if(opHigh >= rvFactor.OP__c &&  rvFactor.OP__c <= flowNarrowingWrapper.EffVacOP)
                       {

                        opHigh = rvFactor.OP__c;
                        cFactorHigh = rvFactor.CFactor__c; 
                         
                       else if(rvFactor.OP__c > flowNarrowingWrapper.EffVacOP)
                       {
                         
                           opLow = rvFactor.OP__c;
                           cFactorLow = rvFactor.CFactor__c;   
                           break;
                       }*/
                    }
                }
                Decimal a = 0.0, b = 0.0, c = 0.0, d = 0.0;
                a = (flowNarrowingWrapper.EffVacOP - OPHIGH);
                b = (CFactorLOW - CFactorHIGH);
                c = (OPLOW - OPHIGH);
                d = CFactorHIGH;
                if(c == 0)
                {
                    VacCFactor = d;
                }
                else
                {
                    VacCFactor = a*b/c+d;
                }
                if(flowNarrowingWrapper.EffVacPresRatio >= VacCritical)
                {
                   /* Part1vacflw = VacCFactor * 278700 * vacKD * RvRec.Converted_Atmospheric_Pressure__c * math.exp(2 * math.log(flowNarrowingWrapper.masterBlasterRecord.VacEffDia__c)) * math.atan(1);
                    Part2vacflw = (RvRec.V_Ratio_of_Specific_Heats__c/(RvRec.V_Molecular_Weight__c * RvRec.V_Converted_Vacuum_Relieving_Temperature__c * RvRec.V_Compressibility_Factor__c * (RvRec.V_Ratio_of_Specific_Heats__c -1)));
                    Part3vacflw = (math.exp(2/RvRec.V_Ratio_of_Specific_Heats__c) * math.log(flowNarrowingWrapper.EffVacPresRatio));
                    Part4vacflw = (math.exp((RvRec.V_Ratio_of_Specific_Heats__c + 1)/(RvRec.V_Ratio_of_Specific_Heats__c)) * math.log(flowNarrowingWrapper.EffVacPresRatio));
                    vacFlowRateValve = Part1vacflw * math.exp(0.5 * math.log(Part2vacflw * (Part3vacflw - Part4vacflw)));*/
                    vacFlowRateValve = VacCFactor * 278700 * vacKD * RvRec.Converted_Atmospheric_Pressure__c * math.exp(2 * math.log(flowNarrowingWrapper.masterBlasterRecord.VacEffDia__c)) * math.atan(1)*
                    math.exp(0.5*math.log(RvRec.V_Ratio_of_Specific_Heats__c/(RvRec.V_Molecular_Weight__c * RvRec.V_Converted_Vacuum_Relieving_Temperature__c * RvRec.V_Compressibility_Factor__c * (RvRec.V_Ratio_of_Specific_Heats__c -1))*
                    (math.exp((2/RvRec.V_Ratio_of_Specific_Heats__c) * math.log(flowNarrowingWrapper.EffVacPresRatio)) - math.exp((RvRec.V_Ratio_of_Specific_Heats__c + 1)/(RvRec.V_Ratio_of_Specific_Heats__c)*math.log(flowNarrowingWrapper.EffVacPresRatio)))));
                }
                else
                {
                   /* Part1vacflw = VacCFactor * 60 * 6.32 * 520 * vacKD * RvRec.Converted_Atmospheric_Pressure__c * math.exp(2 * math.log(flowNarrowingWrapper.masterBlasterRecord.VacEffDia__c)) * math.atan(1);
                    Part2vacflw = (RvRec.V_Molecular_Weight__c * RvRec.V_Converted_Vacuum_Relieving_Temperature__c * RvRec.V_Compressibility_Factor__c);
                    Part3vacflw = (2 / (RvRec.V_Ratio_of_Specific_Heats__c + 1));
                    Part4vacflw = ((RvRec.V_Ratio_of_Specific_Heats__c + 1) / (RvRec.V_Ratio_of_Specific_Heats__c - 1));
                    vacFlowRateValve = Part1vacflw * math.exp(0.5 * math.log(((RvRec.V_Ratio_of_Specific_Heats__c / Part2vacflw) * math.exp(Part4vacflw * math.log(Part3vacflw)))));*/
                    VacFlowRateValve = VacCFactor * 60 * 6.32 * 520 * vacKD * RvRec.Converted_Atmospheric_Pressure__c * math.exp(2 * math.log(flowNarrowingWrapper.masterBlasterRecord.VacEffDia__c)) * math.atan(1)*
                    math.exp(0.5 * math.log(RvRec.V_Ratio_of_Specific_Heats__c / (RvRec.V_Molecular_Weight__c * RvRec.V_Converted_Vacuum_Relieving_Temperature__c * RvRec.V_Compressibility_Factor__c)*
                    math.exp(((RvRec.V_Ratio_of_Specific_Heats__c + 1) / (RvRec.V_Ratio_of_Specific_Heats__c - 1)) * math.log(2 / (RvRec.V_Ratio_of_Specific_Heats__c + 1)))
                    ));
                
                }

                system.debug('PRESRATIOLOW ** '+PRESRATIOLOW+', KDLOW ** '+KDLOW+', PRESRATIOHIGH '+PRESRATIOHIGH+'KDHIGH '+KDHIGH+'VACKD'+VACKD);
                system.debug('OPLOW ** '+OPLOW+', CFactorLOW ** '+CFactorLOW+', OPHIGH '+OPHIGH+', CFactorHIGH '+CFactorHIGH+'VacCFactor'+VacCFactor);
                system.debug('PTC and Size ** '+mapKey+', vacFlowRateValve ** '+vacFlowRateValve+', Converted_Vacuum_Relief_Req_Flow__c = '+RvRec.Converted_Vacuum_Relief_Req_Flow__c);
                if(vacFlowRateValve >= RvRec.Converted_Vacuum_Relief_Req_Flow__c)
                {
                    String modelAndSize = 'PTC = '+flowNarrowingWrapper.masterBlasterRecord.PTC__c+', SZC = '+flowNarrowingWrapper.masterBlasterRecord.SZC__c;
                    flowNarrowedVACPTCAndSZC.add(modelAndSize);
                    System.debug('%%% modelAndSize = '+modelAndSize);
                    system.debug('flowNarrowedVACPTCAndSZC.size()** '+flowNarrowedVACPTCAndSZC.size());
                }
                // Did not check the code from here   END
            }
        }
        return flowNarrowedVACPTCAndSZC;
    }
    
    public static Map<String, Set<String>> getPTCSZCSet(Set<String> PTCAndSZCSet)
    {
        Map<String, Set<String>> PTCSZCMap = new Map<String, Set<String>>();
        PTCSZCMap.put('PTC', new Set<String>());
        PTCSZCMap.put('SZC', new Set<String>());
        if(PTCAndSZCSet.size() > 0)
        {
    		for(String inPTCSZC : PTCAndSZCSet)
            {
                //inPTCSZC = PTC = 1200A, SZC = 02
                String str = inPTCSZC.subStringAfter('PTC = ');
                String PTCValue = str.substringBefore(', SZC =');
                String SZCValue = str.substringAfter(', SZC = ');
                //System.debug('@@@@ PTC = '+PTCValue+', SZC = '+SZCValue);
                if(String.isNotBlank(PTCValue))
                {
                    PTCSZCMap.get('PTC').add(PTCValue);
                }
                if(String.isNotBlank(SZCValue))
                {
                    PTCSZCMap.get('SZC').add(SZCValue);
                }
            }        
        }
        return PTCSZCMap;
    }
    
    //Added By Abhishek 21st May
    public static Relief_Valve__c getStandardValues(Relief_Valve__c conRV){
        
        Decimal StdPosFullOP = 0.0, StdPosEffDia = 0.0, StdPosPresRatio = 0.0, PosPresRatioHigh=0.0, PosPresRatioLow = 0.0, PosKdLow = 0.0, PosKdHigh = 0.0, StdPosKd =0.0, StdPosAirFlowSCFH = 0.0;
        String PosIntMethod;
        Decimal StdVacFullOP = 0.0, StdVacEffDia = 0.0, StdVacPresRatio = 0.0, VacPresRatioHigh=0.0, VacPresRatioLow = 0.0, VacKdLow = 0.0, VacKdHigh = 0.0, StdVacKd =0.0, StdVacAirFlowSCFH = 0.0;
        String VacIntMethod;
        RV_Master_Blaster__c rvMaster =  [SELECT Id,PTC__c,SZC__c,PosCMethod__c,VacCMethod__c,PosIntMethod__c,VacIntMethod__c,VacFullOP__c,PosFullOP__c,PosEffDia__c,VacEffDia__c,PosDir__c,VacDir__c
                                        FROM RV_Master_Blaster__c 
                                        WHERE PTC__c  = :conRV.Model_name__c AND SZC__c = :conRV.Size__c AND Brand__c = :conRV.Brand__c LIMIT 1];
        Set<RV_ModelSizeFlow__c> modelSizeFlowListPos = new Set<RV_ModelSizeFlow__c>();
        Set<RV_ModelSizeFlow__c> modelSizeFlowListVac = new Set<RV_ModelSizeFlow__c>();

        for(RV_ModelSizeFlow__c rvModel :[SELECT PTC__c,SZC__c,Direction__c,KD__c,PressureRatio__c FROM RV_ModelSizeFlow__c 
                                                WHERE PTC__c  =:conRV.Model_name__c AND SZC__c =:conRV.Size__c AND
                                                ((Direction__c = 'Pos' ) OR 
                                                (Direction__c = 'Vac' ))] ){
            if(String.isNotBlank(rvModel.SZC__c) && String.isNotBlank(rvModel.PTC__c))
            {
                if(rvModel.Direction__c == 'Pos')
                {
                    modelSizeFlowListPos.add(rvModel);
                }
                else if(rvModel.Direction__c == 'Vac')
                {
                    modelSizeFlowListVac.add(rvModel);
                }
            }

        }
        if(rvMaster.PosDir__c == 'Y'){

            if(rvMaster.PosFullOP__c != null){
                StdPosFullOP = rvMaster.PosFullOP__c;
            }
            if(rvMaster.PosIntMethod__c != null){
                PosIntMethod = rvMaster.PosIntMethod__c;
            }   
            if(rvMaster.PosEffDia__c != null){
                StdPosEffDia = rvMaster.PosEffDia__c;
            }
            
            StdPosPresRatio = 14.6959 / ( conRV.Converted_Pressure_Setting__c * (1 + StdPosFullOP / 100) + 14.6959 );
            conRV.StdPosPresRatio__c = StdPosPresRatio;
    
            //PosIntMethod
            PosIntMethod = rvMaster.PosIntMethod__c;
    
            decimal lowDiff;
            decimal highDiff;
            for(RV_ModelSizeFlow__c rvModelFlow : modelSizeFlowListPos)
            {
                decimal diff = rvModelFlow.PressureRatio__c - StdPosPresRatio;
                if(diff > 0 && (highDiff > diff || highDiff == null)){
                    highDiff = diff;
                    PosPresRatioLow = rvModelFlow.PressureRatio__c;
                    PosKdLow = rvModelFlow.KD__c;
                }
    
                if(diff <= 0 && (lowDiff <= diff || lowDiff == null)){
                    lowDiff = diff;
                    
                    PosPresRatioHigh = rvModelFlow.PressureRatio__c;
                    PosKdHigh = rvModelFlow.KD__c;
                }
            }
    
    
            //Calculate StdPosKD
            //NOTE: If either PosPresRatioLow or PosPresRatioHigh return no record, Then Set StdPosKd = 0
            /*IF (PosIntMethod = ""Linear"") THEN  (( StdPosPresRatio - PosPresRatioHigh ) * ( PosKdLow - PosKdHigh ) / ( PosPresRatioLow - PosPresRatioHigh ) + PosKdHigh)
            ELSE IF (PosIntMethod = ""Power"") THEN  (EXP ( ( LN(StdPosPresRatio) - LN(PosPresRatioHigh) ) * ( LN(PosKdLow) - LN(PosKdHigh) ) / ( LN(PosPresRatioLow) - LN(PosPresRatioHigh) ) + LN(PosKdHigh) ))*/
            if(PosPresRatioLow != 0.0 && PosPresRatioHigh != 0.0 && ((PosPresRatioLow - PosPresRatioHigh) != 0.0 || ( math.log(PosPresRatioLow) -  math.log(PosPresRatioHigh)) != 0.0))
            {
                if(PosIntMethod == 'Linear')
                {
                    StdPosKd = (StdPosPresRatio - PosPresRatioHigh) * (PosKDLow - PosKDHigh ) / (PosPresRatioLow - PosPresRatioHigh) + PosKDHigh;
                }
                else if(PosIntMethod == 'Power')
                {
                    StdPosKd = math.exp((math.log(StdPosPresRatio) - math.log(PosPresRatioHigh)) * (math.log(PosKDLow) - math.log(PosKDHigh)) / ( math.log(PosPresRatioLow) -  math.log(PosPresRatioHigh)) + math.log(PosKDHigh));
                }
            }
            conRV.StdPosKd__c = StdPosKd;
            /*
            "IF(StdPosPresRatio>=0.52828,
            278700*StdPosKd*( 14.6959 + Converted_Pressure_Setting__c * (1 + StdPosFullOP / 100) )*
            StdPosEffDia^2/4*PI()*(1.4/(28.964*519.67*1*(1.4-1))*
            ((StdPosPresRatio)^(2/1.4)- (StdPosPresRatio)^((1.4+1)/1.4)))^0.5,
            60*6.32*520*StdPosKd*( 14.6959 + Converted_Pressure_Setting__c * (1 + StdPosFullOP / 100) )*StdPosEffDia^2/4*PI()*(1.4/(28.964*519.67*1)*(2/(1.4+1))^((1.4+1)/(1.4-1)))^0.5)"
             */
            if(StdPosPresRatio>=0.52828){
                StdPosAirFlowSCFH = 278700*StdPosKd*( 14.6959 + conRV.Converted_Pressure_Setting__c * (1 + StdPosFullOP / 100) )* math.exp(2 * math.log(StdPosEffDia))/4*3.14159265358979*
                math.exp(0.5 * math.log(1.4/(28.964*519.67*1*(1.4-1))*
                (math.exp((2/1.4) * math.log(StdPosPresRatio)) - math.exp(((1.4+1)/1.4) * math.log(StdPosPresRatio)))));
                
            }
            else{
                
                StdPosAirFlowSCFH=60*6.32*520*StdPosKd*( 14.6959 + conRV.Converted_Pressure_Setting__c *(1 + StdPosFullOP / 100) )*math.exp(2 * math.log(StdPosEffDia))/4*3.14159265358979*
                math.exp(0.5*math.log(1.4/(28.964*519.67*1)*(math.exp(((1.4+1)/(1.4-1))*math.log(2/(1.4+1))))));
            }
            
            conRV.StdPosAirFlowSCFH__c = StdPosAirFlowSCFH;
            conRV.PosPresRatioHigh__c = PosPresRatioHigh;
            conRV.PosKDHigh__c = PosKDHigh;
            conRV.PosPresRatioLow__c = PosPresRatioLow;
            conRV.PosKDLow__c = PosKDLow;
        }
        if(rvMaster.VacDir__c == 'Y'){

            if(rvMaster.VacFullOP__c != null){
                StdVacFullOP = rvMaster.VacFullOP__c;
            }
            if(rvMaster.VacIntMethod__c != null){
                VacIntMethod = rvMaster.VacIntMethod__c;
            }   
            if(rvMaster.VacEffDia__c != null){
                StdVacEffDia = rvMaster.VacEffDia__c;
            }

            StdVacPresRatio = ( 14.6959 - conRV.Converted_Vacuum_Setting__c * (1 + StdVacFullOP / 100) ) / 14.6959;
            conRV.StdVacPresRatio__c = StdVacPresRatio;
            decimal lowDiff;
            decimal highDiff;
            for(RV_ModelSizeFlow__c rvModelFlow : modelSizeFlowListVac)
            {
                decimal diff = rvModelFlow.PressureRatio__c - StdVacPresRatio;
                if(diff > 0 && (highDiff > diff || highDiff == null)){
                    highDiff = diff;
                    VacPresRatioLow = rvModelFlow.PressureRatio__c;
                    VacKdLow = rvModelFlow.KD__c;
                    
                }

                if(diff <= 0 && (lowDiff <= diff || lowDiff == null)){
                    lowDiff = diff;
                    VacPresRatioHigh = rvModelFlow.PressureRatio__c;
                    VacKdHigh = rvModelFlow.KD__c;
                }
            }

            /*
            "NOTE: If either VacPresRatioLow or VacPresRatioHigh return no record, Then Set StdVacKd = 0
            IF VacIntMethod = ""Linear"" Then  ( StdVacPresRatio - VacPresRatioHigh ) * ( VacKdLow - VacKdHigh ) / ( VacPresRatioLow - VacPresRatioHigh ) + VacKdHigh
            ELSE IF VacIntMethod = ""Power"" Then  EXP ( ( LN(StdVacPresRatio) - LN(VacPresRatioHigh) ) * ( LN(VacKdLow) - LN(VacKdHigh) ) / ( LN(VacPresRatioLow) - LN(VacPresRatioHigh) ) + LN(VacKdHigh) )"
            */
            if(VacPresRatioLow != 0.0 && VacPresRatioHigh != 0.0 && ((VacPresRatioLow - VacPresRatioHigh) != 0.0 || ( math.log(VacPresRatioLow) -  math.log(VacPresRatioHigh)) != 0.0))
            {
                if(VacIntMethod == 'Linear')
                {
                    StdVacKd = (StdVacPresRatio - VacPresRatioHigh) * (VacKDLow - VacKDHigh ) / (VacPresRatioLow - VacPresRatioHigh) + VacKDHigh;
                }
                else if(VacIntMethod == 'Power')
                {
                    StdVacKd = math.exp((math.log(StdVacPresRatio) - math.log(VacPresRatioHigh)) * (math.log(VacKDLow) - math.log(VacKDHigh)) / ( math.log(VacPresRatioLow) -  math.log(VacPresRatioHigh)) + math.log(VacKDHigh));
                }
            }

            conRV.StdVacKd__c = StdVacKd;
            /*
            IF(StdVacPresRatio>=0.52828,
            278700*StdVacKd* 14.6959 *StdVacEffDia^2/4*PI()*(1.4/(28.964*519.67*1*(1.4-1))*((StdVacPresRatio)^(2/1.4)-(StdVacPresRatio)^((1.4+1)/1.4)))^0.5,
            60*6.32*520*StdVacKd* 14.6959 *StdVacEffDia^2/4*PI()*(1.4/(28.964*519.67*1)*(2/(1.4+1))^((1.4+1)/(1.4-1)))^0.5)
            */
            if(StdVacPresRatio>=0.52828){
                StdVacAirFlowSCFH = 278700*StdVacKd*14.6959* math.exp(2 * math.log(StdVacEffDia))/4*3.14159265358979*
                math.exp(0.5 * math.log(1.4/(28.964*519.67*1*(1.4-1))*
                (math.exp((2/1.4) * math.log(StdVacPresRatio)) - math.exp(((1.4+1)/1.4) * math.log(StdVacPresRatio)))));
                
            }
			else{
                
                StdVacAirFlowSCFH=60*6.32*520*StdVacKd*14.6959*math.exp(2 * math.log(StdVacEffDia))/4*3.14159265358979*
                math.exp(0.5*math.log(1.4/(28.964*519.67*1)*(math.exp(((1.4+1)/(1.4-1))*math.log(2/(1.4+1))))));
            }
            conRV.StdVacAirFlowSCFH__c = StdVacAirFlowSCFH;
            conRV.VacPresRatioHigh__c = VacPresRatioHigh;
            conRV.VacKDHigh__c = VacKDHigh;
            conRV.VacPresRatioLow__c = VacPresRatioLow;
            conRV.VacKDLow__c = VacKDLow;
        }
        
        

        return conRV;
    }
    
}