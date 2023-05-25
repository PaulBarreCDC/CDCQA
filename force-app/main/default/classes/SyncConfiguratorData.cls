global class SyncConfiguratorData {
    public static sObject sObj {get;set;}
    public static decimal LEADTIMEFORSITE10 {get;set;}
    public static decimal LEADTIMEFORSITE20 {get;set;}
    public static decimal LEADTIMEFORSITE30 {get;set;}
    public static decimal LEADTIMEFORSITE40 {get;set;}
    public static decimal COSTINSIDESITE10 {get;set;}
    public static decimal COSTINSIDESITE20 {get;set;}
    public static decimal COSTINSIDESITE30 {get;set;}
    public static decimal COSTOUTSIDESITE10 {get;set;}
    public static decimal COSTOUTSIDESITE20 {get;set;}
    public static decimal COSTOUTSIDESITE30 {get;set;}
    public static boolean isLeadTimeOverridden {get;set;}
    public static boolean isPriceOverridden {get;set;}
    public static boolean isCostOverridden {get;set;}
    public static decimal LISTPRICE {get;set;}
    public static string PARTNUMBER {get;set;}
    public static decimal NONDISCOUNTABLELISTPRICE {get;set;}
    public static decimal DISCOUNTABLELISTPRICE {get;set;}
    public static decimal TOTALPRICE {get;set;}
    public static decimal QTY {get;set;}
    public static string  ENG_NOTES {get; set;}
    public static Map<string,string> mapBGROutputElements {
        get {
            return new Map<String, String>{
                'AssyLocation'=>'Price_AssyLocation__c',
                'ATEX'=>'Price_ATEX__c',
                'Base'=>'Price_Base__c',
                'Connection'=>'Price_Connection__c',
                'CSA'=>'Price_CSA__c',
                'CUTR'=>'Price_CUTR__c',
                'MatlSource'=>'Price_MatlSource__c',
                'PMI'=>'Price_PMI__c',
                'ShellTest'=>'Price_ShellTest__c',
                'SoftGoods'=>'Price_SoftGoods__c',
                'XRAY'=>'Price_XRAY__c'
            };
        } set;
    }
    public static Map<string,string> mapWGBOutputElements {
        get {
                return new Map<String, String>{
                'Alarm'=>'Alarm__c',
                'BackUpPowerSupply'=>'BackUpPowerSupply__c',
                'Certifications'=>'Certifications__c',
                'Enclosure'=>'Enclosure__c',
                'FlameSensor'=>'FlameSensor__c',
                'Heater'=>'Heater__c',
                'PilotGasRegulator'=>'PilotGasRegulator__c',
                'StackOrifice'=>'StackOrifice__c',
                'StandControl'=>'StandControl__c',
                'StepDownTransfer'=>'StepDownTransfer__c',
                'Sunshield'=>'Sunshield__c'
            };
        } set;
    }
    //public list<RV_Valve_Price_Details__c > RVPricingList{set;get;}
   // public list<priceWrapper > RVPriceWrapperList{set;get;}
    public static Integer computeTotal(Integer totalField, Integer fieldValue)
    {
        if(fieldValue != 7777 && fieldValue != 4995 && totalField != 7777 && totalField != 4495)
        {
            totalField += fieldValue;
        }
        else if(totalField != 7777)
        {
            totalField = fieldValue;
        }
        return totalField;
    }
    public class LeadTimeWrapper
    {
        public GlobalLeadTime__c leadTimeRec{get;set;}
        public String item{get;set;}
        public Integer x10{get;set;}
        public Integer x20{get;set;}
        public Integer x30{get;set;}
        public Integer x40{get;set;}
        public Integer x10Override{get;set;}
        public Integer x20Override{get;set;}
        public Integer x30Override{get;set;}
        public Integer x40Override{get;set;}
        public Id queue10Id{get;set;}
        public Id queue20Id{get;set;}
        public Id queue30Id{get;set;}
        public Id queue40Id{get;set;}
    }
    
    public class priceWrapper
    {
        public RV_Valve_Price_Details__c rvPrice{get; set;}
        public Decimal rvPriceOverride{get; set;}
        priceWrapper()
        {
            rvPrice = new RV_Valve_Price_Details__c();
            rvPriceOverride = 0.00;
        }
    }
    public static list<LeadTimeWrapper> RVLeadTimeList{set;get;}
    public static list<priceWrapper > RVPriceWrapperList{set;get;}
    //FA related method
    public class fapriceWrapper
    {
        public FA_Price_Details__c faPrice{get; set;}
        public Decimal faPriceOverride{get; set;}
        fapriceWrapper()
        {
            faPrice = new FA_Price_Details__c();
            faPriceOverride = 0.00;
        }
    }
    public static list<LeadTimeWrapper> FALeadTimeList{set;get;}
    public static list<fapriceWrapper > FAPriceWrapperList{set;get;}
    public static result runRulesForConfigData(Id recordId){
        result sObjRes=wizardBaseDataProcessor.getObjectDataById(recordId);
        if(sObjRes.bResult)
            sObj=sObjRes.objResultList[0];
        else {
            System.debug('No Record Found for this ID');
        }
        String sObjName=wizardBaseDataProcessor.getObjectNameById(sObj.Id);
        Map<String,Object> sObjFields = sObj.getPopulatedFieldsAsMap();
        System.debug('sObjName: ' + sObjName);
        if(sObjName!=null)
        {
            String prdCode=wizardBaseDataProcessor.mapObjectwithProductCode.get(sObjName);
            System.debug('prdCode: ' + prdCode);
            string strPARTNUMBER=(String) sObj.get('Part_Number__c');
            if(strPARTNUMBER!=null)
                PARTNUMBER=strPARTNUMBER;
            else
                PARTNUMBER='';
            if (prdCode=='BGR') {
                List<String> listBaseSchedule = new List<String>();
                List<String> listAdderSchedule = new List<String>();
                listBaseSchedule.add('BGRA');
                listBaseSchedule.add('BGRB');
                listBaseSchedule.add('BGRC');
                listBaseSchedule.add('BGRD');
                listAdderSchedule.add('BGREST');
                listAdderSchedule.add('BGRHYDRO');
                listAdderSchedule.add('BGRZERO');
                BGROutputUtility bgr = new BGROutputUtility(sObj.Id);
                isLeadTimeOverridden=(boolean) sObjFields.get('Lead_Time_Engineer_Override__c');
                isPriceOverridden=(boolean) sObjFields.get('Price_Engineer_Override__c');
                isCostOverridden=(boolean) sObjFields.get('Price_Engineer_Override__c');
                QTY = (decimal) sObjFields.get('Quantity__c');
                ENG_NOTES = sObjFields.containsKey('Engineering_Notes__c') ? (string) sObjFields.get('Engineering_Notes__c') : '';
                BGR_Outputs__c bgrOutputIntance=configureBGRProduct.getBGROutputRecord(sObj.Id);
                //boolean isCostOverridden=(boolean) sObj.get('Lead_Time_Engineer_Override__c');
                System.debug('isLeadTimeOverridden: ' + isLeadTimeOverridden);
                if (isLeadTimeOverridden) {
                    LEADTIMEFORSITE10=(decimal) sObj.get('Lead_Time_Site_10__c');
                    LEADTIMEFORSITE20=(decimal) sObj.get('Lead_Time_Site_20__c');
                    LEADTIMEFORSITE30=(decimal) sObj.get('Lead_Time_Site_30__c');
                    LEADTIMEFORSITE40=(decimal) sObj.get('Lead_Time_Site_40__c');
                } else {
                    BGR_lead_time__c[] BGRLeadTimeList = bgr.GetLeadTimeRec();
                    List<BGR_lead_time__c> updateBGRLeadTime=new List<BGR_lead_time__c>();
                    LEADTIMEFORSITE10=0.0;
                    LEADTIMEFORSITE20=0.0;
                    LEADTIMEFORSITE30=0.0;
                    LEADTIMEFORSITE40=0.0;
                    for(BGR_lead_time__c bgl : BGRLeadTimeList)
                    {
                        bgl.Lead_Time_10_Override__c = bgl.Site_10__c;
                        bgl.Lead_Time_20_Override__c = bgl.Site_20__c;
                        bgl.Lead_Time_30_Override__c = bgl.Site_30__c;
                        bgl.Lead_Time_40_Override__c = bgl.Site_40__c;
                        if(bgl.Site_10__c != 7777 && bgl.Site_10__c != 4995 )
                        {
                            LEADTIMEFORSITE10 += bgl.Site_10__c;
                        }
                        if(bgl.Site_20__c != 7777 && bgl.Site_20__c != 4995 )
                        {
                            LEADTIMEFORSITE20 += bgl.Site_20__c;
                        }
                        if(bgl.Site_30__c != 7777 && bgl.Site_30__c != 4995 )
                        {
                            LEADTIMEFORSITE30 += bgl.Site_30__c;
                        }
                        if(bgl.Site_40__c != 7777 && bgl.Site_40__c != 4995 )
                        {
                            LEADTIMEFORSITE40 += bgl.Site_40__c;
                        }
                        if (listBaseSchedule.contains(bgl.Schedule__c)) {
                            bgrOutputIntance.Base_Lead_Time_10__c = bgl.Lead_Time_10_Override__c+'';
                            bgrOutputIntance.Base_Lead_Time_20__c = bgl.Lead_Time_20_Override__c+'';
                            bgrOutputIntance.Base_Lead_Time_30__c = bgl.Lead_Time_30_Override__c+'';
                            bgrOutputIntance.Base_Lead_Time_40__c = bgl.Lead_Time_40_Override__c+'';
                        }
                        if (listAdderSchedule.contains(bgl.Schedule__c)) {
                            bgrOutputIntance.Adder_Lead_Time_10__c = bgl.Lead_Time_10_Override__c+'';
                            bgrOutputIntance.Adder_Lead_Time_20__c = bgl.Lead_Time_20_Override__c+'';
                            bgrOutputIntance.Adder_Lead_Time_30__c = bgl.Lead_Time_30_Override__c+'';
                            bgrOutputIntance.Adder_Lead_Time_40__c = bgl.Lead_Time_40_Override__c+'';
                        }
                        updateBGRLeadTime.add(bgl);
                    }
                    upsert updateBGRLeadTime;
                    sObj.put('Lead_Time_Site_10__c',LEADTIMEFORSITE10);
                    sObj.put('Lead_Time_Site_20__c',LEADTIMEFORSITE20);
                    sObj.put('Lead_Time_Site_30__c',LEADTIMEFORSITE30);
                    sObj.put('Lead_Time_Site_40__c',LEADTIMEFORSITE40);
                    update sObj;
                }
                if (isPriceOverridden && !Test.isRunningTest()) {
                    //conBGR.List_Price_Each__c = ListPriceEach;
                    LISTPRICE=(decimal) sObj.get('List_Price_Each__c');
                    integer intQTY=(integer) sObj.get('Quantity__c');
                    if(intQTY == null) {
                        intQTY = 0;
                    }
                    if(LISTPRICE == null) {
                        LISTPRICE = 0;
                    }
                    TOTALPRICE=intQTY*LISTPRICE;
                } else {
                    result prncgResult=bgr.getPricing();
                    List<BGR_Price_Details__c> updateBGRPrice=new List<BGR_Price_Details__c>();
                    decimal decPriceTotal=0.0;

                    if(prncgResult.bResult)
                    {
                        for (sObject sOb:prncgResult.objResultList) {
                            BGR_Price_Details__c  BGRPricingRecord = new BGR_Price_Details__c ();
                            BGRPricingRecord.Price_Override__c = BGRPricingRecord.Price__c;
                            BGRPricingRecord = (BGR_Price_Details__c ) sOb;
                            if(BGRPricingRecord.Price__c != 9999999)
                                decPriceTotal+=BGRPricingRecord.Price__c;
                            updateBGRPrice.add(BGRPricingRecord);
                            
                            if(!Test.isRunningTest())
                            	bgrOutputIntance.put(mapBGROutputElements.get(BGRPricingRecord.Pricing_Element__c),BGRPricingRecord.Price__c);
                        }
                        LISTPRICE=decPriceTotal;
                        integer intQTY=Integer.ValueOf((decimal) sObj.get('Quantity__c'));
                        if(intQTY==null) {
                            intQTY = 0;
                        }
                        TOTALPRICE=intQTY*LISTPRICE;
                        sObj.put('List_Price_Each__c',decPriceTotal);
                        upsert updateBGRPrice;
                        upsert bgrOutputIntance;
                        update sObj;
                    }
                }
                if (isCostOverridden) {
                    List<Cost__c> cstLstHidden=new List<Cost__c>();
                    cstLstHidden=[Select id,Cost_Method__c,Part_Number__c,Cost_Sub_Type__c,Inside_Cost_10__c,Outside_Cost_10__c,Inside_Cost_20__c,Outside_Cost_30__c,Inside_Cost_30__c,Outside_Cost_20__c from Cost__c where Ref_Id__c=:String.valueOf(sObj.Id) and Product__c='BGR' and Cost_Method__c='Overriden'];
                    if (cstLstHidden.size()>0) {
                        COSTINSIDESITE10=double.ValueOf(cstLstHidden[0].Inside_Cost_10__c);
                        COSTINSIDESITE20=double.ValueOf(cstLstHidden[0].Inside_Cost_20__c);
                        COSTINSIDESITE30=double.ValueOf(cstLstHidden[0].Inside_Cost_30__c);
                       // COSTINSIDESITE40=cstLstHidden[0].Inside_Cost_40__c;
                        COSTOUTSIDESITE10=double.ValueOf(cstLstHidden[0].Outside_Cost_10__c);
                        COSTOUTSIDESITE20=double.ValueOf(cstLstHidden[0].Outside_Cost_20__c);
                        COSTOUTSIDESITE30=double.ValueOf(cstLstHidden[0].Outside_Cost_30__c);
                        //COSTOUTSIDESITE40=cstLstHidden[0].Outside_Cost_40__c;
                    }

                } else {
                    WizardCostProcessor wCProc=new WizardCostProcessor(sObj.Id);
                    result resCost=wCProc.addBGRCostData();
                    if (resCost.bResult) {
                        List<Cost__c> cstLstOverriden=new List<Cost__c>();
                        cstLstOverriden=[Select id,Cost_Method__c,Part_Number__c,Cost_Sub_Type__c,Inside_Cost_10__c,Outside_Cost_10__c,Inside_Cost_20__c,Outside_Cost_30__c,Inside_Cost_30__c,Outside_Cost_20__c from Cost__c where Ref_Id__c=:String.valueOf(sObj.Id) and Product__c='BGR' and Cost_Method__c='Overriden'];
                        System.debug('cstLstOverriden'+cstLstOverriden);
                        if (cstLstOverriden.size()>0) {
                            if (cstLstOverriden[0].Inside_Cost_10__c!=null)
                                COSTINSIDESITE10=double.ValueOf(cstLstOverriden[0].Inside_Cost_10__c);
                            if (cstLstOverriden[0].Inside_Cost_20__c!=null)
                                COSTINSIDESITE20=double.ValueOf(cstLstOverriden[0].Inside_Cost_20__c);
                            if (cstLstOverriden[0].Inside_Cost_30__c!=null)
                            COSTINSIDESITE30=double.ValueOf(cstLstOverriden[0].Inside_Cost_30__c);
                            //COSTINSIDESITE40=cstLstOverriden[0].Inside_Cost_40__c;
                            if (cstLstOverriden[0].Outside_Cost_10__c!=null)
                                COSTOUTSIDESITE10=double.ValueOf(cstLstOverriden[0].Outside_Cost_10__c);
                            if (cstLstOverriden[0].Outside_Cost_20__c!=null)
                                COSTOUTSIDESITE20=double.ValueOf(cstLstOverriden[0].Outside_Cost_20__c);
                            if (cstLstOverriden[0].Outside_Cost_30__c!=null)
                                COSTOUTSIDESITE30=double.ValueOf(cstLstOverriden[0].Outside_Cost_30__c);
                            //COSTOUTSIDESITE40=cstLstOverriden[0].Outside_Cost_40__c;
                        }
                    }
                }
            } else if (prdCode=='RD') {
                RdOutputBaseUtility RDOU = new RdOutputBaseUtility(sObj.Id);
                isLeadTimeOverridden=(boolean) sObjFields.get('Lead_Time_Override__c');
                isPriceOverridden=(boolean) sObjFields.get('Price_Override__c');
                isCostOverridden=(boolean) sObjFields.get('Build_Cost_Override__c');
                QTY = (decimal) sObjFields.get('Quantity__c');
                ENG_NOTES = sObjFields.containsKey('Engineering_Notes__c') ? (string) sObjFields.get('Engineering_Notes__c') : '';
                if(!isLeadTimeOverridden) {
                    List<RdOutputBaseUtility.RDStructureWrapper> RDOBUStructWrapper=RDOU.getConsolidatedStructureDetails();
                    result re1s=RDOU.getRDLeadTime();
                }
                RD_Outputs__c[] rdOutputList=[Select Base_Lead_Time_GP__c,Base_Lead_Time_GCI__c,Base_Lead_Time_CDC__c,Base_Lead_Time_40__c,Adder_Lead_Time_GP__c,Adder_Lead_Time_GCI__c,Adder_Lead_Time_CDC__c,Adder_Lead_Time_40__c,Comp_Lead_Time_GP__c,Comp_Lead_Time_GCI__c,Comp_Lead_Time_CDC__c,Comp_Lead_Time_40__c,Total_Lead_Time_CDC__c,Total_Lead_Time_GP__c,Total_Lead_Time_GCI__c,Total_Lead_Time_GP_ORD__c,Total_Lead_Time_40__c,OW__c,OW_Override__c,OA__c,OA_Override__c,OB__c,OB_Override__c,ORP__c,ORP_Override__c,ORV__c,ORV_Override__c,Total_Lead_Time_CDC_ORD__c,Total_Lead_Time_GCI_ORD__c,LABMAT__c,Total_Lead_Time_40_ORD__c,LABDSC__c FROM RD_Outputs__c WHERE RD_Outputs_Relation_Field__c=:String.valueOf(sObj.Id)];
                RD_Outputs__c rdOutput=new RD_Outputs__c();
                if(rdOutputList.size()>0)
                    rdOutput=rdOutputList[0];
                LEADTIMEFORSITE10=(decimal) rdOutput.get('Total_Lead_Time_GP_ORD__c');
                LEADTIMEFORSITE20=(decimal) rdOutput.get('Total_Lead_Time_GCI_ORD__c');
                LEADTIMEFORSITE30=(decimal) rdOutput.get('Total_Lead_Time_CDC_ORD__c');
                LEADTIMEFORSITE40=(decimal) rdOutput.get('Total_Lead_Time_40_ORD__c');
                if (!isPriceOverridden) {
                    Result rupPrzRecord=wizardBaseDataProcessor.getRDPricingByProdId(sObj.Id);
                }
                //Result rupPrzRecord=wizardBaseDataProcessor.getRDPricingByProdId(sObj.Id);
                
                if(sObj.get('Discountable_Price__c') != null && sObj.get('Non_Discountable_Price__c') != null ) {
                	
                    LISTPRICE=(decimal) sObj.get('Discountable_Price__c')+(decimal) sObj.get('Non_Discountable_Price__c');
                	TOTALPRICE=(decimal) sObj.get('Discountable_Price__c')+(decimal) sObj.get('Non_Discountable_Price__c');
                }

                if (!isCostOverridden) {
                    WizardCostProcessor wcp = new WizardCostProcessor(sObj.Id);
                    List<Cost__c> getCst = new List<Cost__c>();
                    if(!Test.isRunningTest()) {
                        getCst = wcp.getRDCostData();
                    }
                }
                List<Cost__c> cstLstHidden=new List<Cost__c>();
                
                if(!Test.isRunningTest())
                	cstLstHidden=[Select id,Cost_Method__c,Part_Number__c,Cost_Sub_Type__c,Inside_Cost_10__c,Outside_Cost_10__c,Inside_Cost_20__c,Outside_Cost_30__c,Inside_Cost_30__c,Outside_Cost_20__c from Cost__c where Ref_Id__c=:String.valueOf(sObj.Id) and Product__c='RD' and Cost_Method__c='Overriden'];
                if (cstLstHidden.size()>0) {
                //     COSTINSIDESITE10=double.ValueOf(cstLstHidden[0].Inside_Cost_10__c);
                //     COSTINSIDESITE20=double.ValueOf(cstLstHidden[0].Inside_Cost_20__c);
                //     COSTINSIDESITE30=double.ValueOf(cstLstHidden[0].Inside_Cost_30__c);
                //    // COSTINSIDESITE40=cstLstHidden[0].Inside_Cost_40__c;
                //     COSTOUTSIDESITE10=double.ValueOf(cstLstHidden[0].Outside_Cost_10__c);
                //     COSTOUTSIDESITE20=double.ValueOf(cstLstHidden[0].Outside_Cost_20__c);
                //     COSTOUTSIDESITE30=double.ValueOf(cstLstHidden[0].Outside_Cost_30__c);
                    //COSTOUTSIDESITE40=cstLstHidden[0].Outside_Cost_40__c;
                }
            } else if (prdCode=='RLFVLV') {
                isLeadTimeOverridden=(boolean) sObjFields.get('Lead_Time_Override__c');
                isPriceOverridden=(boolean) sObjFields.get('Price_Engineer_Override__c');
                isCostOverridden=(boolean) sObjFields.get('Build_Cost_Override__c');
                QTY = (decimal) sObjFields.get('Quantity__c');
                List<RV_Outputs__c> rvOutputList = new List<RV_Outputs__c>();
                String fieldsAPIname = FLMutility.getObjectFields('RV_Outputs__c');
                String soql = 'SELECT '+fieldsAPIname+' FROM RV_Outputs__c where RV_Outputs_Relation_Field__c =\''+String.escapeSingleQuotes(sObj.Id)+'\'';
                rvOutputList = Database.query(soql);
                RV_Outputs__c rvOutput=new RV_Outputs__c();
                RVOutputUtility RVOU=new RVOutputUtility(sObj.Id);
                if(rvOutputList.size() > 0)
                    rvOutput=rvOutputList[0];
                if(isLeadTimeOverridden) {
                    LEADTIMEFORSITE10=(decimal) sObj.get('Lead_Time_Site_10__c');
                    LEADTIMEFORSITE20=(decimal) sObj.get('Lead_Time_Site_20__c');
                    LEADTIMEFORSITE30=(decimal) sObj.get('Lead_Time_Site_30__c');
                    LEADTIMEFORSITE40=(decimal) sObj.get('Lead_Time_Site_40__c');
                } else {
                   // RVLeadTimeList.clear();
                    integer Total10 = 0;
                    integer Total20 = 0;
                    integer Total30 = 0;
                    integer Total40 = 0;
                    integer Total10Override = 0;
                    integer Total20Override = 0;
                    integer Total30Override = 0;
                    integer Total40Override = 0;
                    Set<integer> site10=new Set<integer>();
                    Set<integer> site20=new Set<integer>();
                    Set<integer> site30=new Set<integer>();
                    Set<integer> site40=new Set<integer>();
                    Result leadResult = RVOU.getLeadTime();
                    Set<String> runTimeSchedule = new Set<String>();
                    Set<String> queueTimeSchedule = new Set<String>();
                    Map<String,String> scheduleVsItem = new Map<String, String>();
                    Map<String, LeadTimeWrapper> queueTimeItemMap = new Map<String, LeadTimeWrapper>();
                    LeadTimeWrapper queueTimeItem = new LeadTimeWrapper();
                    queueTimeItem.item = 'Queue Time';
                    queueTimeItem.x10 = 0;
                    queueTimeItem.x20 = 0;
                    queueTimeItem.x30 = 0;
                    queueTimeItem.x40 = 0;
                    queueTimeItem.x10Override = 0;
                    queueTimeItem.x20Override = 0;
                    queueTimeItem.x30Override = 0;
                    queueTimeItem.x40Override = 0;
                    queueTimeItemMap.put('QueueTimeItem', queueTimeItem);
                    if(leadResult.bResult)
                    {
                        for(sObject sobj : leadResult.objResultList)
                        {
                            RV_Valve_Lead_Time_Details__c leadtimeDetail = (RV_Valve_Lead_Time_Details__c)sobj;
                            //system.debug('leadtimeDetail'+leadtimeDetail);
                            if(String.isNotBlank(leadtimeDetail.RunTimeSchedule__c))
                            {
                                runTimeSchedule.add(leadtimeDetail.RunTimeSchedule__c);
                                scheduleVsItem.put(leadtimeDetail.RunTimeSchedule__c, leadtimeDetail.Lead_Time_Item_No__c);
                            }
                            if(String.isNotBlank(leadtimeDetail.QueueTimeSchedule__c))
                            {
                                queueTimeSchedule.add(leadtimeDetail.QueueTimeSchedule__c);
                                scheduleVsItem.put(leadtimeDetail.QueueTimeSchedule__c, leadtimeDetail.Lead_Time_Item_No__c);
                            }
                        }
                        System.debug('**** queueTimeSchedule = '+queueTimeSchedule+', runTimeSchedule = '+runTimeSchedule);
                        if(QTY != null &&(runTimeSchedule.size() > 0 || queueTimeSchedule.size() > 0))
                        {
                            for(GlobalLeadTime__c leadValue: [SELECT Id,Schedule__c,X10__c,X20__c,X30__c,X40__c
                                                            FROM GlobalLeadTime__c
                                                            WHERE (Schedule__c IN:runTimeSchedule OR Schedule__c IN: queueTimeSchedule)
                                                            AND QtyLL__c <=: QTY AND QtyUL__c >: QTY])
                    {
                        System.debug('**** leadValue = '+leadValue);
                        
                        String fieldAPI = scheduleVsItem.get(leadValue.Schedule__c);
                        if(fieldAPI.contains(' '))
                        {
                            fieldAPI = fieldAPI.replace(' ', '_');
                        }
                        
                        String x10API = fieldAPI+'_10_Override__c';
                        String x20API = fieldAPI+'_20_Override__c';
                        String x30API = fieldAPI+'_30_Override__c';
                        String x40API = fieldAPI+'_40_Override__c';
                        
                        if(!Test.isRunningTest()) {
                            
                            
                            //System.debug('@@@ x10API = '+x10API+', X10__c = '+leadValue.X10__c+', override = '+rvOutput.get(x10API));
                            if(rvOutput.get(x10API) == null)
                            {
                                rvOutput.put(x10API, leadValue.X10__c);
                            }
                            
                            if(rvOutput.get(x20API) == null)
                            {
                                rvOutput.put(x20API, leadValue.X20__c);
                            }
                            
                            if(rvOutput.get(x30API) == null)
                            {
                                rvOutput.put(x30API, leadValue.X30__c);
                            }
                            
                            if(rvOutput.get(x40API) == null)
                            {
                                rvOutput.put(x40API, leadValue.X40__c);
                            }
                            System.debug('@@@ X10__c = '+leadValue.X10__c+', override = '+rvOutput.get(x10API));
                        }
                        
                        if(queueTimeSchedule.contains(leadValue.Schedule__c))
                        {
                            Decimal xValue = leadValue.X10__c;
                            if(xValue != null && xValue >= queueTimeItemMap.get('QueueTimeItem').x10)
                            {
                                queueTimeItemMap.get('QueueTimeItem').x10 = Integer.valueOf(xValue);
                                if(!Test.isRunningTest()) {
                                	
                                    queueTimeItemMap.get('QueueTimeItem').x10Override = Integer.valueOf(rvOutput.get(x10API));
                                }
                                queueTimeItemMap.get('QueueTimeItem').queue10Id = leadValue.Id;
                            }
                            xValue = leadValue.X20__c;
                            if(xValue != null && xValue >= queueTimeItemMap.get('QueueTimeItem').x20)
                            {
                                if(!Test.isRunningTest()) {
                                    queueTimeItemMap.get('QueueTimeItem').x20 = Integer.valueOf(xValue);
                                    queueTimeItemMap.get('QueueTimeItem').x20Override = Integer.valueOf(rvOutput.get(x20API));
                                    queueTimeItemMap.get('QueueTimeItem').queue20Id = leadValue.Id;
                                }
                            }
                            xValue = leadValue.X30__c;
                            if(xValue != null && xValue >= queueTimeItemMap.get('QueueTimeItem').x30)
                            {
                                if(!Test.isRunningTest()) {
                                    queueTimeItemMap.get('QueueTimeItem').x30 = Integer.valueOf(xValue);
                                    queueTimeItemMap.get('QueueTimeItem').x30Override = Integer.valueOf(rvOutput.get(x30API));
                                    queueTimeItemMap.get('QueueTimeItem').queue30Id = leadValue.Id;
                                }
                            }
                            xValue = leadValue.X40__c;
                            if(xValue != null && xValue >= queueTimeItemMap.get('QueueTimeItem').x40)
                            {
                                if(!Test.isRunningTest()) {
                                    queueTimeItemMap.get('QueueTimeItem').x40 = Integer.valueOf(xValue);
                                    queueTimeItemMap.get('QueueTimeItem').x40Override = Integer.valueOf(rvOutput.get(x40API));
                                    queueTimeItemMap.get('QueueTimeItem').queue40Id = leadValue.Id;
                                }
                            }
                        } 
                        else
                        {
                            LeadTimeWrapper runTimeItem = new LeadTimeWrapper();
                            runTimeItem.leadTimeRec = leadValue;
                            runTimeItem.item = scheduleVsItem.get(leadValue.Schedule__c);
                            runTimeItem.x10 = Integer.valueOf(leadValue.X10__c);
                            runTimeItem.x20 = Integer.valueOf(leadValue.X20__c);
                            runTimeItem.x30 = Integer.valueOf(leadValue.X30__c);
                            runTimeItem.x40 = Integer.valueOf(leadValue.X40__c);
                            runTimeItem.x10Override = Integer.valueOf(rvOutput.get(x10API));
                            runTimeItem.x20Override = Integer.valueOf(rvOutput.get(x20API));
                            runTimeItem.x30Override = Integer.valueOf(rvOutput.get(x30API));
                            runTimeItem.x40Override = Integer.valueOf(rvOutput.get(x40API));
                            
                            Total10 = computeTotal(Total10, runTimeItem.x10);
                            Total20 = computeTotal(Total20, runTimeItem.x20);
                            Total30 = computeTotal(Total30, runTimeItem.x30);
                            Total40 = computeTotal(Total40, runTimeItem.x40);
                            Total10Override = computeTotal(Total10Override, runTimeItem.x10Override);
                            Total20Override = computeTotal(Total20Override, runTimeItem.x20Override);
                            Total30Override = computeTotal(Total30Override, runTimeItem.x30Override);
                            Total40Override = computeTotal(Total40Override, runTimeItem.x40Override);
                            site10.add(Total10Override);
                            site20.add(Total20Override);
                            site30.add(Total30Override);
                            site40.add(Total40Override);
                            RVLeadTimeList.add(runTimeItem);
                        }
                    }
                            System.debug('**** Queue time = '+queueTimeItemMap.get('QueueTimeItem'));
                            //RVLeadTimeList.add(queueTimeItemMap.get('QueueTimeItem'));
                            Total10 = computeTotal(Total10, queueTimeItem.x10);
                            Total20 = computeTotal(Total20, queueTimeItem.x20);
                            Total30 = computeTotal(Total30, queueTimeItem.x30);
                            Total40 = computeTotal(Total40, queueTimeItem.x40);
                            Total10Override = computeTotal(Total10Override, queueTimeItem.x10Override);
                            sObj.put('Lead_Time_Site_10__c', Total10Override);
                            Total20Override = computeTotal(Total20Override, queueTimeItem.x20Override);
                            sObj.put('Lead_Time_Site_20__c',Total20Override);
                            Total30Override = computeTotal(Total30Override, queueTimeItem.x30Override);
                            sObj.put('Lead_Time_Site_30__c',Total30Override);
                            Total40Override = computeTotal(Total40Override, queueTimeItem.x40Override);
                            sObj.put('Lead_Time_Site_40__c',Total40Override);
                        }
                    }
                    LEADTIMEFORSITE10=Total10Override;
                    LEADTIMEFORSITE20=Total20Override;
                    LEADTIMEFORSITE30=Total30Override;
                    LEADTIMEFORSITE40=Total40Override;
                    update sObj;
                }
                if(isPriceOverridden) {
                    LISTPRICE=(decimal) sObj.get('Discountable_Price__c')+(decimal) sObj.get('Non_Discountable_Price__c')/QTY;
                    TOTALPRICE=(decimal) sObj.get('Discountable_Price__c')+(decimal) sObj.get('Non_Discountable_Price__c');
                    DISCOUNTABLELISTPRICE=(decimal) sObj.get('Discountable_Price__c');
                    NONDISCOUNTABLELISTPRICE=(decimal) sObj.get('Non_Discountable_Price__c');
                } else {
                    result prncgResult=RVOU.getPricing();
                    decimal TotalRVPrice = 0.0;
                    if(RVPriceWrapperList == null) {
                        
                        RVPriceWrapperList = new list<priceWrapper>();
                    }
                    RVPriceWrapperList.clear();
                    decimal TotalRVPriceOverride = 0.0;
                    decimal NonDiscountablePriceEach = 0.0;
                    decimal ListPriceEach = 0.0;
                    list<RV_Valve_Price_Details__c> RVPricingList=new list<RV_Valve_Price_Details__c >();
                    if(prncgResult.bResult)
            {
                boolean has9999999 = false;
                boolean has8888888 = false;
                
                Set<String> weightElements = new Set<String>{'SettingMinPressure','SettingMinVacuum','WeightSettingPressure','WeightSettingVacuum','WeightPressure','WeightVacuum'};
                Map<String, RV_Valve_Price_Details__c> WeightMap = new Map<String, RV_Valve_Price_Details__c>();                               
                
                /***********************************************/
                //Method to find missing price elements
                List<String> uniqueListSZC=new List<String>();
                list<RV_Valve_Price_Details__c> pricelementss=new list<RV_Valve_Price_Details__c>();
                for(RV_Valve_Price_Details__c eachFAMB : [SELECT Price__c,Pricing_Element__c FROM RV_Valve_Price_Details__c 
                                                                                                                 order by Pricing_Element__c]){
                        if(!uniqueListSZC.contains(eachFAMB.Pricing_Element__c))
                        {    
                            pricelementss.add(eachFAMB);
                            uniqueListSZC.add(eachFAMB.Pricing_Element__c);
                       }
                }
                /***************************/
				list<string> priceelements=new list<string>();
                
                for (sObject sobj:prncgResult.objResultList)
                {
                    RV_Valve_Price_Details__c  RVPricingRecord = new RV_Valve_Price_Details__c ();
                    RVPricingRecord = (RV_Valve_Price_Details__c )sobj;
                    String fieldAPI;
                    System.debug('*** utility Element = '+RVPricingRecord.Pricing_Element__c+', Price = '+RVPricingRecord.Price__c);
                    if(weightElements.contains(RVPricingRecord.Pricing_Element__c))
                    {
                        WeightMap.put(RVPricingRecord.Pricing_Element__c,RVPricingRecord);
                    }
                    else
                    {
                        //rvOutput
                       /* if(RVPricingRecord.Pricing_Element__c!='SettingMinPressure' && RVPricingRecord.Pricing_Element__c!='WeightSettingPressure' 
                           && RVPricingRecord.Pricing_Element__c!='SettingMinVacuum' && RVPricingRecord.Pricing_Element__c!='WeightSettingVacuum')*/
                        fieldAPI = RVPricingRecord.Pricing_Element__c;
                        if(RVPricingRecord.Pricing_Element__c.contains(' '))
                        {
                            fieldAPI = fieldAPI.replace(' ', '_');
                        }
                        fieldAPI = fieldAPI+'__c';
                        Decimal priceOverride = 0.00;
                        if(rvOutput.get(fieldAPI) == null)
                        {
                            //RVPricingRecord.Price_Override__c = RVPricingRecord.Price__c;
                            rvOutput.put(fieldAPI, RVPricingRecord.Price__c);
                            priceOverride = RVPricingRecord.Price__c;               
                        }
                        else
                        {
                            priceOverride = (Decimal)rvOutput.get(fieldAPI);
                        }
                        TotalRVPrice += RVPricingRecord.Price__c;
                      /*******  if(priceOverride == 9999999)
                        {
                            has9999999 = true;
                            TotalRVPriceOverride = 9999999;
                        }
                        if(has9999999 == false)
                        {
                            TotalRVPriceOverride += priceOverride;
                        } *********/
                        
                        if(priceOverride == 9999999)
                      {
                            has9999999 = true;
                            TotalRVPriceOverride = 9999999.00;
                      }
                    if(priceOverride == 8888888 && has9999999==false)
                      {
                            has8888888 = true;
                            TotalRVPriceOverride = 8888888.00;
                      }
                    if(has8888888 == false && has9999999==false )
                      {
                            TotalRVPriceOverride += priceOverride;
                      }
                    
                    priceelements.add(RVPricingRecord.Pricing_Element__c);
                        
                        priceWrapper priceWrapperInstance = new priceWrapper();
                    	priceWrapperInstance.rvPrice = RVPricingRecord;
                        priceWrapperInstance.rvPriceOverride = priceOverride.setScale(2);
                        RVPriceWrapperList.add(priceWrapperInstance);
                        //RVPricingList.add(RVPricingRecord);
                    }
                }
                if(WeightMap.containsKey('WeightPressure') && (decimal) sObj.get('PosSetPresOSIG__c')!= null)
                {
                    System.debug('*** utility Element weight = '+WeightMap.get('WeightPressure').Pricing_Element__c+', Price = '+WeightMap.get('WeightPressure').Price__c);
                    Decimal SettingMinPressure = 0.0, WeightSettingPressure = 0.0;
                    if(WeightMap.containsKey('SettingMinPressure'))
                    {
                        SettingMinPressure = WeightMap.get('SettingMinPressure').Price__c;
                    }
                    if(WeightMap.containsKey('WeightSettingPressure'))
                    {
                        WeightSettingPressure = WeightMap.get('WeightSettingPressure').Price__c;
                    }
                    WeightMap.get('WeightPressure').Price__c = (Math.max((((decimal) sObj.get('PosSetPresOSIG__c')  - SettingMinPressure) * WeightSettingPressure), 0)).setScale(2);
                    //System.debug('--> conRV.PosSetPresOSIG__c = '+conRV.PosSetPresOSIG__c+', SettingMinPressure = '+SettingMinPressure+', WeightSettingPressure = '+WeightSettingPressure+', Price = '+WeightMap.get('WeightPressure').Price__c);
					String fieldAPI = 'WeightPressure__c';
                    Decimal priceOverride = 0.00;
                    System.debug('&--> '+rvOutput);
                    System.debug('&--> '+rvOutput.get(fieldAPI));
                    if(rvOutput.get(fieldAPI) == null)
                    {
                        //RVPricingRecord.Price_Override__c = RVPricingRecord.Price__c;
                        rvOutput.put(fieldAPI, WeightMap.get('WeightPressure').Price__c);
                        priceOverride = WeightMap.get('WeightPressure').Price__c;
                    }
                    else
                    {
                        priceOverride = (Decimal)rvOutput.get(fieldAPI);
                    }
                    
                    //WeightMap.get('WeightPressure').Price_Override__c = WeightMap.get('WeightPressure').Price__c;

                  /***  if(priceOverride == 9999999)
                    {
                        has9999999 = true;
                        TotalRVPriceOverride = 9999999;
                    }
                    if(has9999999 == false)
                    {
                        TotalRVPriceOverride += priceOverride;
                    } ********/
                    
                    if(priceOverride == 9999999)
                      {
                            has9999999 = true;
                            TotalRVPriceOverride = 9999999.00;
                      }
                    if(priceOverride == 8888888 && has9999999==false)
                      {
                            has8888888 = true;
                            TotalRVPriceOverride = 8888888.00;
                      }
                    if(has8888888 == false && has9999999==false )
                      {
                            TotalRVPriceOverride += priceOverride;
                      }
                    
                 //   priceelements.add(RVPricingRecord.Pricing_Element__c);
                    
                    priceWrapper priceWrapperInstance = new priceWrapper();
                    priceWrapperInstance.rvPrice = WeightMap.get('WeightPressure');
                    priceWrapperInstance.rvPriceOverride = priceOverride.setScale(2);
                    RVPriceWrapperList.add(priceWrapperInstance);
                    //RVPricingList.add(WeightMap.get('WeightPressure'));
                }
                if(WeightMap.containsKey('WeightVacuum') && (decimal) sObj.get('VacSetPresOSIG__c')  != null)
                {
                    Decimal SettingMinVacuum = 0.0, WeightSettingVacuum = 0.0;
                    if(WeightMap.containsKey('SettingMinVacuum'))
                    {
                        SettingMinVacuum = WeightMap.get('SettingMinVacuum').Price__c;
                    }
                    if(WeightMap.containsKey('WeightSettingVacuum'))
                    {
                        WeightSettingVacuum = WeightMap.get('WeightSettingVacuum').Price__c;
                    }
                    WeightMap.get('WeightVacuum').Price__c = (Math.max((((decimal) sObj.get('VacSetPresOSIG__c')   - SettingMinVacuum) * WeightSettingVacuum), 0)).setScale(2);

                    //System.debug('--> conRV.VacSetPresOSIG__c = '+conRV.VacSetPresOSIG__c+', SettingMinVacuum = '+SettingMinVacuum+', WeightSettingVacuum = '+WeightSettingVacuum+', Price = '+WeightMap.get('WeightVacuum').Price__c);

                    String fieldAPI = 'WeightVacuum__c';
                    Decimal priceOverride = 0.00;
                    if(rvOutput.get(fieldAPI) == null)
                    {
                        //RVPricingRecord.Price_Override__c = RVPricingRecord.Price__c;
                        rvOutput.put(fieldAPI, WeightMap.get('WeightVacuum').Price__c);
                        priceOverride = WeightMap.get('WeightVacuum').Price__c;
                    }
                    else
                    {
                        priceOverride = (Decimal)rvOutput.get(fieldAPI);
                    }
                   // WeightMap.get('WeightVacuum').Price_Override__c = WeightMap.get('WeightVacuum').Price__c;

                  /*********  if(priceOverride == 9999999)
                    {
                        has9999999 = true;
                        TotalRVPriceOverride = 9999999;
                    }
                    if(has9999999 == false)
                    {
                        TotalRVPriceOverride += priceOverride;
                    }************/
                    
             		if(priceOverride == 9999999)
                      {
                            has9999999 = true;
                            TotalRVPriceOverride = 9999999.00;
                      }
                    if(priceOverride == 8888888 && has9999999==false)
                      {
                            has8888888 = true;
                            TotalRVPriceOverride = 8888888.00;
                      }
                    if(has8888888 == false && has9999999==false )
                      {
                            TotalRVPriceOverride += priceOverride;
                      }
                    
                 //   priceelements.add(RVPricingRecord.Pricing_Element__c);
                    
                    priceWrapper priceWrapperInstance = new priceWrapper();
                    priceWrapperInstance.rvPrice = WeightMap.get('WeightVacuum');
                    priceWrapperInstance.rvPriceOverride = priceOverride.setScale(2);
                    RVPriceWrapperList.add(priceWrapperInstance);
                    //RVPricingList.add(WeightMap.get('WeightVacuum'));
                }

                // Adding price for missing Pricing elements with 8888888 as a dummy price
            	for (sObject sobj1:pricelementss)
                {
                    RV_Valve_Price_Details__c  RVPricingRecord2 = new RV_Valve_Price_Details__c ();
                    RVPricingRecord2 = (RV_Valve_Price_Details__c )sobj1;      
                    string fieldAPI;
                    if(RVPricingRecord2.Pricing_Element__c!='SettingMinPressure' && RVPricingRecord2.Pricing_Element__c!='WeightSettingPressure' 
                           && RVPricingRecord2.Pricing_Element__c!='SettingMinVacuum' && RVPricingRecord2.Pricing_Element__c!='WeightSettingVacuum' 
                      && RVPricingRecord2.Pricing_Element__c!='WeightPressure' && RVPricingRecord2.Pricing_Element__c!='WeightVacuum')
                    {
                        fieldAPI = RVPricingRecord2.Pricing_Element__c;
                      if(!priceelements.contains(RVPricingRecord2.Pricing_Element__c))
                        {                            
                                if(RVPricingRecord2.Pricing_Element__c.contains(' '))
                            {
                                fieldAPI = fieldAPI.replace(' ', '_');
                            }
                       
                            fieldAPI = fieldAPI+'__c';
                            Decimal priceOverride;
                            if(rvOutput.get(fieldAPI) == null)
                            {
                                //RVPricingRecord.Price_Override__c = RVPricingRecord.Price__c;
                                rvOutput.put(fieldAPI, 8888888.00); //RVPricingRecord2.Price__c
                                priceOverride = 8888888.00;
                            }
                            else
                            {
                                priceOverride = (Decimal)rvOutput.get(fieldAPI);
                            }

                            if(has9999999==false && priceOverride==8888888)
                            {
                                has8888888 = true;
                                TotalRVPriceOverride = 8888888.00;                          
                            }
                            if(has8888888 == false && has9999999==false )
                            {
                                TotalRVPriceOverride += priceOverride;
                            }
                            RVPricingRecord2.Price__c=8888888.00;
                            priceWrapper priceWrapperInstance = new priceWrapper();
                            priceWrapperInstance.rvPrice =RVPricingRecord2;
                            priceWrapperInstance.rvPriceOverride =priceOverride.setScale(2); //priceOverride.setScale(2);
                            RVPriceWrapperList.add(priceWrapperInstance);
                           
                           /* if(has9999999 == false) //RVPricingRecord2.Price_Override__c == 8888888 &&
                            {
                                has8888888 = true;    
                                TotalFAPriceOverride = 8888888.00;
                            }  */                        
                          //  uniqueListprice.add(RVPricingRecord2.Pricing_Element__c);
                        }                     
                    }
                    
                   }             
                
                if((decimal) sObj.get('Quantity__c') != null && (decimal) sObj.get('Quantity__c') != 0)
                {
                    if(has9999999==false && has8888888==false){
                        	ListPriceEach=TotalRVPriceOverride + ( NonDiscountablePriceEach / (decimal) sObj.get('Quantity__c'));
                            sObj.put('List_Price_Each__c',ListPriceEach);
                        //System.debug('Price List Each---Normal' +conRV.List_Price_Each__c);
                           sObj.put('Discountable_Price__c',TotalRVPriceOverride);
                    	}      
                     if(has9999999==true)
                    {
                        ListPriceEach = TotalRVPriceOverride;
                        sObj.put('List_Price_Each__c',ListPriceEach);
                        //System.debug('Price List Each---999999999' +conRV.List_Price_Each__c);
                        sObj.put('Discountable_Price__c',TotalRVPriceOverride);
                    } 
                    else if(has8888888==true){
                        ListPriceEach = TotalRVPriceOverride;
                        sObj.put('List_Price_Each__c',ListPriceEach);
                        sObj.put('Discountable_Price__c',TotalRVPriceOverride);
                    }
                    sObj.put('Non_Discountable_Price__c',NonDiscountablePriceEach);
                }

            }
                    LISTPRICE=ListPriceEach;
                    TOTALPRICE=TotalRVPriceOverride+NonDiscountablePriceEach;
                    update sObj;
                    //update wgbOutput;
                }
                if(isCostOverridden) {
                    List<Cost__c> cstLstHidden=new List<Cost__c>();
                    cstLstHidden=[Select id,Cost_Method__c,Part_Number__c,Cost_Sub_Type__c,Inside_Cost_10__c,Outside_Cost_10__c,Inside_Cost_20__c,Outside_Cost_30__c,Inside_Cost_30__c,Outside_Cost_20__c from Cost__c where Ref_Id__c=:String.valueOf(sObj.Id) and Product__c='RLFVLV' and Cost_Method__c='Overriden'];
                    if (cstLstHidden.size()>0) {
                        COSTINSIDESITE10=double.ValueOf(cstLstHidden[0].Inside_Cost_10__c);
                        COSTINSIDESITE20=double.ValueOf(cstLstHidden[0].Inside_Cost_20__c);
                        COSTINSIDESITE30=double.ValueOf(cstLstHidden[0].Inside_Cost_30__c);
                       // COSTINSIDESITE40=cstLstHidden[0].Inside_Cost_40__c;
                        COSTOUTSIDESITE10=double.ValueOf(cstLstHidden[0].Outside_Cost_10__c);
                        COSTOUTSIDESITE20=double.ValueOf(cstLstHidden[0].Outside_Cost_20__c);
                        COSTOUTSIDESITE30=double.ValueOf(cstLstHidden[0].Outside_Cost_30__c);
                        //COSTOUTSIDESITE40=cstLstHidden[0].Outside_Cost_40__c;
                    }
                } else {
                    
                    result resCost = new Result();
                    if(!Test.isRunningTest()) {
                        WizardCostProcessor wCProc=new WizardCostProcessor(sObj.Id);
                        resCost = wCProc.addBGRCostData();
                    }
                    if (resCost.bResult) {
                        List<Cost__c> cstLstOverriden=new List<Cost__c>();
                        cstLstOverriden=[Select id,Cost_Method__c,Part_Number__c,Cost_Sub_Type__c,Inside_Cost_10__c,Outside_Cost_10__c,Inside_Cost_20__c,Outside_Cost_30__c,Inside_Cost_30__c,Outside_Cost_20__c from Cost__c where Ref_Id__c=:String.valueOf(sObj.Id) and Product__c='RLFVLV' and Cost_Method__c='Overriden'];
                        System.debug('cstLstOverriden'+cstLstOverriden);
                        if (cstLstOverriden.size()>0) {
                            if (cstLstOverriden[0].Inside_Cost_10__c!=null)
                                COSTINSIDESITE10=double.ValueOf(cstLstOverriden[0].Inside_Cost_10__c);
                            if (cstLstOverriden[0].Inside_Cost_20__c!=null)
                                COSTINSIDESITE20=double.ValueOf(cstLstOverriden[0].Inside_Cost_20__c);
                            if (cstLstOverriden[0].Inside_Cost_30__c!=null)
                            COSTINSIDESITE30=double.ValueOf(cstLstOverriden[0].Inside_Cost_30__c);
                            //COSTINSIDESITE40=cstLstOverriden[0].Inside_Cost_40__c;
                            if (cstLstOverriden[0].Outside_Cost_10__c!=null)
                                COSTOUTSIDESITE10=double.ValueOf(cstLstOverriden[0].Outside_Cost_10__c);
                            if (cstLstOverriden[0].Outside_Cost_20__c!=null)
                                COSTOUTSIDESITE20=double.ValueOf(cstLstOverriden[0].Outside_Cost_20__c);
                            if (cstLstOverriden[0].Outside_Cost_30__c!=null)
                                COSTOUTSIDESITE30=double.ValueOf(cstLstOverriden[0].Outside_Cost_30__c);
                            //COSTOUTSIDESITE40=cstLstOverriden[0].Outside_Cost_40__c;
                        }
                    }
                }
            } else if (prdCode=='HLD') {
					
                isLeadTimeOverridden = (boolean) sObjFields.get('Lead_Time_Override__c');
                isPriceOverridden = (boolean) sObjFields.get('Price_Engineer_Override__c');
                
                //check if price overridden then retrieve the overridden values else calculate it based on the config
                ConfigHoldersOutputController obj = new ConfigHoldersOutputController();
                Map<String, Object> res = obj.getPricingListCust(recordId, true);
        		Holders__c conHolderDet = (Holders__c) res.get('RES');
                Map<String,String> holderInputsCust = ConfigHolderUtility.holderInputs(conHolderDet);
                
                List<Holder_Outputs__c> hldOutputs = [SELECT Id, Lead_Time_Override__c, Lead_Time__c  
                                                      FROM Holder_Outputs__c 
                                                      WHERE ReferenceId__c = :conHolderDet.Id];
                
                LISTPRICE 					= conHolderDet.List_Price_Each__c;
                DISCOUNTABLELISTPRICE 		= conHolderDet.Discountable_Price__c;
                NONDISCOUNTABLELISTPRICE 	= conHolderDet.Non_Discountable_Price__c;
                TOTALPRICE 					= DISCOUNTABLELISTPRICE + NONDISCOUNTABLELISTPRICE;
                
                System.debug('....LISTPRICE..'+LISTPRICE);
                System.debug('....DISCOUNTABLELISTPRICE..'+DISCOUNTABLELISTPRICE);
                System.debug('....NONDISCOUNTABLELISTPRICE..'+NONDISCOUNTABLELISTPRICE);
                System.debug('....TOTALPRICE..'+TOTALPRICE);
                system.debug('Quantity__c:'+sObjFields.get('Quantity__c'));
                system.debug('Quantity__c:'+(Decimal)sObjFields.get('Quantity__c'));
                
                //check if lead-time overridden then retrieve the overridden values else calculate it based on the config
                list<HLDRStructureWrapper> structureList = obj.getStructuresCust(holderInputsCust);
                List<HLDRLeadWrapper> resLeadTime = obj.getLeadTimeCust(structureList, (Decimal) sObjFields.get('Quantity__c'), (String) sObjFields.get('Id') );
                
                HLDRLeadWrapper leadWrp;
                if(isLeadTimeOverridden) {
                    
                    leadWrp = new HLDRLeadWrapper();
                    LEADTIMEFORSITE10 = hldOutputs[0].Lead_Time_Override__c;
                    
                } else {
                    
                    leadWrp = resLeadTime[resLeadTime.size()-1];
                    LEADTIMEFORSITE10 = leadWrp.leadtime;
                    
                    hldOutputs[0].Lead_Time_Override__c = LEADTIMEFORSITE10;
                    hldOutputs[0].Lead_Time__c = LEADTIMEFORSITE10;
                    System.debug('....LEADTIMEFORSITE10..'+LEADTIMEFORSITE10);
                    System.debug('....LEADTIMEFORSITE10..'+LEADTIMEFORSITE10);
                    
                    update hldOutputs;
                }
                
                //Lead Time for 20, 30 & 40 is not applicable for Holders, so the default value is being configured
                LEADTIMEFORSITE20 = 7777;
                LEADTIMEFORSITE30 = 7777;
                LEADTIMEFORSITE40 = 7777;
                
                update conHolderDet;
                
            } 
            else if (prdCode=='FlameProducts') {
                isLeadTimeOverridden=(boolean) sObjFields.get('Lead_Time_Override__c');
                isPriceOverridden=(boolean) sObjFields.get('Price_Engineer_Override__c');
                isCostOverridden=(boolean) sObjFields.get('Build_Cost_Override__c');
                QTY = (decimal) sObjFields.get('Quantity__c');
                List<FA_Output__c> faOutputList = new List<FA_Output__c>();
                String fieldsAPIname = FLMutility.getObjectFields('FA_Output__c');
                String soql = 'SELECT '+fieldsAPIname+' FROM FA_Output__c where FA_Output_Relation_Field__c =\''+String.escapeSingleQuotes(sObj.Id)+'\'';
                faOutputList = Database.query(soql);
                FA_Output__c FAOUtput=new FA_Output__c();
                FAOutputUtility FAOU=new FAOutputUtility(sObj.Id);
                if(faOutputList.size() > 0)
                    FAOUtput=faOutputList[0];
                if(isLeadTimeOverridden) {
                    LEADTIMEFORSITE10=(decimal) sObj.get('Lead_Time_Site_10__c');
                    LEADTIMEFORSITE20=(decimal) sObj.get('Lead_Time_Site_20__c');
                    LEADTIMEFORSITE30=(decimal) sObj.get('Lead_Time_Site_30__c');
                    LEADTIMEFORSITE40=(decimal) sObj.get('Lead_Time_Site_40__c');
                } else {
                   // RVLeadTimeList.clear();
                    integer Total10 = 0;
                    integer Total20 = 0;
                    integer Total30 = 0;
                    integer Total40 = 0;
                    integer Total10Override = 0;
                    integer Total20Override = 0;
                    integer Total30Override = 0;
                    integer Total40Override = 0;
                    Set<integer> site10=new Set<integer>();
                    Set<integer> site20=new Set<integer>();
                    Set<integer> site30=new Set<integer>();
                    Set<integer> site40=new Set<integer>();
                    list<integer> Normalsite10=new list<integer>();
                    list<integer> Normalsite20=new list<integer>();
                    list<integer> Normalsite30=new list<integer>();
                    list<integer> Normalsite40=new list<integer>();
                    Result leadResult = FAOU.getLeadTime();
                    Set<String> runTimeSchedule = new Set<String>();
                    Set<String> queueTimeSchedule = new Set<String>();
                    Map<String,String> scheduleVsItem = new Map<String, String>();
                    Map<String, LeadTimeWrapper> queueTimeItemMap = new Map<String, LeadTimeWrapper>();
                    LeadTimeWrapper queueTimeItem = new LeadTimeWrapper();
                    queueTimeItem.item = 'Queue Time';
                    queueTimeItem.x10 = 0;
                    queueTimeItem.x20 = 0;
                    queueTimeItem.x30 = 0;
                    queueTimeItem.x40 = 0;
                    queueTimeItem.x10Override = 0;
                    queueTimeItem.x20Override = 0;
                    queueTimeItem.x30Override = 0;
                    queueTimeItem.x40Override = 0;
                    queueTimeItemMap.put('QueueTimeItem', queueTimeItem);
                    if(leadResult.bResult)
                    {
                        for(sObject sobj : leadResult.objResultList)
                        {
                            FA_Lead_Time_Details__c leadtimeDetail = (FA_Lead_Time_Details__c)sobj;
                            //system.debug('leadtimeDetail'+leadtimeDetail);
                            if(String.isNotBlank(leadtimeDetail.RunTimeSchedule__c))
                            {
                                runTimeSchedule.add(leadtimeDetail.RunTimeSchedule__c);
                                scheduleVsItem.put(leadtimeDetail.RunTimeSchedule__c, leadtimeDetail.Lead_Time_Item__c);
                            }
                            if(String.isNotBlank(leadtimeDetail.QueueTimeSchedule__c))
                            {
                                queueTimeSchedule.add(leadtimeDetail.QueueTimeSchedule__c);
                                scheduleVsItem.put(leadtimeDetail.QueueTimeSchedule__c, leadtimeDetail.Lead_Time_Item__c);
                            }
                        }
                        System.debug('**** queueTimeSchedule = '+queueTimeSchedule+', runTimeSchedule = '+runTimeSchedule);
                        if(QTY != null &&(runTimeSchedule.size() > 0 || queueTimeSchedule.size() > 0))
                        {
                            for(GlobalLeadTime__c leadValue: [SELECT Id,Schedule__c,X10__c,X20__c,X30__c,X40__c
                                                            FROM GlobalLeadTime__c
                                                            WHERE (Schedule__c IN:runTimeSchedule OR Schedule__c IN: queueTimeSchedule)
                                                            AND QtyLL__c <=: QTY AND QtyUL__c >: QTY])
                    {
                        System.debug('**** leadValue = '+leadValue);
                        
                        String fieldAPI = scheduleVsItem.get(leadValue.Schedule__c);
                        if(fieldAPI.contains(' '))
                        {
                            fieldAPI = fieldAPI.replace(' ', '_');
                        }
                        
                        String x10API = fieldAPI+'_10__c';
                        System.debug('@@@ x10API = '+x10API+', X10__c = '+leadValue.X10__c+', override = '+FAOUtput.get(x10API));
                        if(FAOUtput.get(x10API) == null)
                        {
                            FAOUtput.put(x10API, leadValue.X10__c);
                        }
                        String x20API = fieldAPI+'_20__c';
                        if(FAOUtput.get(x20API) == null)
                        {
                            FAOUtput.put(x20API, leadValue.X20__c);
                        }
                        String x30API = fieldAPI+'_30__c';
                        if(FAOUtput.get(x30API) == null)
                        {
                            FAOUtput.put(x30API, leadValue.X30__c);
                        }
                        String x40API = fieldAPI+'_40__c';
                        if(FAOUtput.get(x40API) == null)
                        {
                            FAOUtput.put(x40API, leadValue.X40__c);
                        }
                        System.debug('@@@ X10__c = '+leadValue.X10__c+', override = '+FAOUtput.get(x10API));
                        if(queueTimeSchedule.contains(leadValue.Schedule__c))
                        {
                            Decimal xValue = leadValue.X10__c;
                            if(xValue != null && xValue >= queueTimeItemMap.get('QueueTimeItem').x10)
                            {
                                queueTimeItemMap.get('QueueTimeItem').x10 = Integer.valueOf(xValue);
                                queueTimeItemMap.get('QueueTimeItem').x10Override = Integer.valueOf(FAOUtput.get(x10API));
                                queueTimeItemMap.get('QueueTimeItem').queue10Id = leadValue.Id;
                            }
                            xValue = leadValue.X20__c;
                            if(xValue != null && xValue >= queueTimeItemMap.get('QueueTimeItem').x20)
                            {
                                queueTimeItemMap.get('QueueTimeItem').x20 = Integer.valueOf(xValue);
                                queueTimeItemMap.get('QueueTimeItem').x20Override = Integer.valueOf(FAOUtput.get(x20API));
                                queueTimeItemMap.get('QueueTimeItem').queue20Id = leadValue.Id;
                            }
                            xValue = leadValue.X30__c;
                            if(xValue != null && xValue >= queueTimeItemMap.get('QueueTimeItem').x30)
                            {
                                queueTimeItemMap.get('QueueTimeItem').x30 = Integer.valueOf(xValue);
                                queueTimeItemMap.get('QueueTimeItem').x30Override = Integer.valueOf(FAOUtput.get(x30API));
                                queueTimeItemMap.get('QueueTimeItem').queue30Id = leadValue.Id;
                            }
                            xValue = leadValue.X40__c;
                            if(xValue != null && xValue >= queueTimeItemMap.get('QueueTimeItem').x40)
                            {
                                queueTimeItemMap.get('QueueTimeItem').x40 = Integer.valueOf(xValue);
                                queueTimeItemMap.get('QueueTimeItem').x40Override = Integer.valueOf(FAOUtput.get(x40API));
                                queueTimeItemMap.get('QueueTimeItem').queue40Id = leadValue.Id;
                            }
                        } 
                        else
                        {
                            LeadTimeWrapper runTimeItem = new LeadTimeWrapper();
                            runTimeItem.leadTimeRec = leadValue;
                            runTimeItem.item = scheduleVsItem.get(leadValue.Schedule__c);
                            runTimeItem.x10 = Integer.valueOf(leadValue.X10__c);
                            runTimeItem.x20 = Integer.valueOf(leadValue.X20__c);
                            runTimeItem.x30 = Integer.valueOf(leadValue.X30__c);
                            runTimeItem.x40 = Integer.valueOf(leadValue.X40__c);
                            runTimeItem.x10Override = Integer.valueOf(FAOUtput.get(x10API));
                            runTimeItem.x20Override = Integer.valueOf(FAOUtput.get(x20API));
                            runTimeItem.x30Override = Integer.valueOf(FAOUtput.get(x30API));
                            runTimeItem.x40Override = Integer.valueOf(FAOUtput.get(x40API));
                            
                            Total10 = computeTotal(Total10, runTimeItem.x10);
                            Total20 = computeTotal(Total20, runTimeItem.x20);
                            Total30 = computeTotal(Total30, runTimeItem.x30);
                            Total40 = computeTotal(Total40, runTimeItem.x40);
                            Total10Override = computeTotal(Total10Override, runTimeItem.x10Override);
                            Total20Override = computeTotal(Total20Override, runTimeItem.x20Override);
                            Total30Override = computeTotal(Total30Override, runTimeItem.x30Override);
                            Total40Override = computeTotal(Total40Override, runTimeItem.x40Override);
                            Normalsite10.add(Total10);
                            Normalsite20.add(Total20);
                            Normalsite30.add(Total30);
                            Normalsite40.add(Total40);
                            site10.add(Total10Override);
                            site20.add(Total20Override);
                            site30.add(Total30Override);
                            site40.add(Total40Override);
                            RVLeadTimeList.add(runTimeItem);
                        }
                    }
                            System.debug('**** Queue time = '+queueTimeItemMap.get('QueueTimeItem'));
                            //RVLeadTimeList.add(queueTimeItemMap.get('QueueTimeItem'));
                            Total10 = computeTotal(Total10, queueTimeItem.x10);
                            Total20 = computeTotal(Total20, queueTimeItem.x20);
                            Total30 = computeTotal(Total30, queueTimeItem.x30);
                            Total40 = computeTotal(Total40, queueTimeItem.x40);
                            Total10Override = computeTotal(Total10Override, queueTimeItem.x10Override);
                            sObj.put('Lead_Time_Site_10__c', Total10Override);
                            Total20Override = computeTotal(Total20Override, queueTimeItem.x20Override);
                            sObj.put('Lead_Time_Site_20__c',Total20Override);
                            Total30Override = computeTotal(Total30Override, queueTimeItem.x30Override);
                            sObj.put('Lead_Time_Site_30__c',Total30Override);
                            Total40Override = computeTotal(Total40Override, queueTimeItem.x40Override);
                            sObj.put('Lead_Time_Site_40__c',Total40Override);
                        }
                    }
                    LEADTIMEFORSITE10=Total10Override;
                    LEADTIMEFORSITE20=Total20Override;
                    LEADTIMEFORSITE30=Total30Override;
                    LEADTIMEFORSITE40=Total40Override;
                    update sObj;
                }
				
                if(isPriceOverridden) 
				{
                    LISTPRICE=(decimal) sObj.get('Discountable_Price__c')+(decimal) sObj.get('Non_Discountable_Price__c')/QTY;
                    TOTALPRICE=(decimal) sObj.get('Discountable_Price__c')+(decimal) sObj.get('Non_Discountable_Price__c');
                    DISCOUNTABLELISTPRICE=(decimal) sObj.get('Discountable_Price__c');
                    NONDISCOUNTABLELISTPRICE=(decimal) sObj.get('Non_Discountable_Price__c');
                } 
				else 
				{
                    result prncgResult=FAOU.getPricing();
                    decimal TotalFAPrice = 0.0;
                    if(FAPriceWrapperList != null && FAPriceWrapperList.size() > 0) {
                    	
                        FAPriceWrapperList.clear();
                    }
                    decimal TotalFAPriceOverride = 0.0;
                    decimal NonDiscountablePriceEach = 0.0;
                    decimal ListPriceEach = 0.0;
                    list<FA_Price_Details__c> FAPricingList=new list<FA_Price_Details__c >();
                if(prncgResult.bResult)
				{
					boolean has9999999 = false;
					boolean has8888888 = false;
					
					Map<String, FA_Price_Details__c> WeightMap = new Map<String, FA_Price_Details__c>();                               
					
					/***********************************************/
					//Method to find missing price elements
					List<String> uniqueListSZC=new List<String>();
					list<FA_Price_Details__c> pricelementss=new list<FA_Price_Details__c>();
					for(FA_Price_Details__c eachFAMB : [SELECT Price__c,Pricing_Element__c FROM FA_Price_Details__c 
																													 order by Pricing_Element__c])
					{
						if(!uniqueListSZC.contains(eachFAMB.Pricing_Element__c))
						{    
							pricelementss.add(eachFAMB);
							uniqueListSZC.add(eachFAMB.Pricing_Element__c);
		   			    }
					}
                /***************************/
				list<string> priceelements=new list<string>();
             //   FA_Output__c faOutput = getFAOutputRecord(sObj.Id);
                for (sObject sobj:prncgResult.objResultList)
                {
                    FA_Price_Details__c  FAPricingRecord = new FA_Price_Details__c ();
                    FAPricingRecord = (FA_Price_Details__c )sobj;   
                    String fieldAPI;
                    fieldAPI = FAPricingRecord.Pricing_Element__c;
                        if(FAPricingRecord.Pricing_Element__c.contains(' '))
                        {
                            fieldAPI = fieldAPI.replace(' ', '_');
                        }
                    
                        fieldAPI = fieldAPI+'__c';
                        Decimal priceOverride = 0.00;
                        if(faOutput.get(fieldAPI) == null)
                        {
                            //RVPricingRecord.Price_Override__c = RVPricingRecord.Price__c;
                            faOutput.put(fieldAPI, FAPricingRecord.Price__c);
                            priceOverride = FAPricingRecord.Price__c;
                        }
                        else
                        {
                            priceOverride = (Decimal)faOutput.get(fieldAPI);
                        }
                        TotalFAPrice += FAPricingRecord.Price__c;
                        if(priceOverride == 9999999)
                        {
                            has9999999 = true;
                            TotalFAPriceOverride = 9999999.00;
                        }
                    	if(priceOverride == 8888888 && has9999999==false)
                        {
                            has8888888 = true;
                            TotalFAPriceOverride = 8888888.00;
                        }
                        if(has8888888 == false && has9999999==false )
                        {
                            TotalFAPriceOverride += priceOverride;
                        }
                    	
                    	priceelements.add(FAPricingRecord.Pricing_Element__c);
                    
                        fapriceWrapper priceWrapperInstance = new fapriceWrapper();
                    	priceWrapperInstance.faPrice = FAPricingRecord;
                        priceWrapperInstance.faPriceOverride = priceOverride.setScale(2);
                        if(FAPriceWrapperList == null) {
                            
                            FAPriceWrapperList = new list<fapriceWrapper>();
                        }
                        FAPriceWrapperList.add(priceWrapperInstance);
                        //RVPricingList.add(RVPricingRecord);   
                }

                // Adding price for missing Pricing elements with 8888888 as a dummy price
            	for (sObject sobj1:pricelementss)
                {
                    FA_Price_Details__c  FAPricingRecord2 = new FA_Price_Details__c ();
                    FAPricingRecord2 = (FA_Price_Details__c )sobj1;      
                    string fieldAPI;
                    fieldAPI = FAPricingRecord2.Pricing_Element__c;
                      if(!priceelements.contains(FAPricingRecord2.Pricing_Element__c))
                        {                            
                                if(FAPricingRecord2.Pricing_Element__c.contains(' '))
                            {
                                fieldAPI = fieldAPI.replace(' ', '_');
                            }
                       
                            fieldAPI = fieldAPI+'__c';
                            Decimal priceOverride;
                            if(faOutput.get(fieldAPI) == null)
                            {
                                //RVPricingRecord.Price_Override__c = RVPricingRecord.Price__c;
                                faOutput.put(fieldAPI, 8888888.00);
                                priceOverride = 8888888.00;
                            }
                            else
                            {                                
                                	priceOverride = (Decimal)faOutput.get(fieldAPI);   //8888888;                     
                            }
                         //   TotalFAPrice += FAPricingRecord2.Price__c;                           
                            if(has9999999==false && priceOverride==8888888)
                            {
                                has8888888 = true;
                                TotalFAPriceOverride = 8888888.00;                          
                            }
                            if(has8888888 == false && has9999999==false )
                            {
                                TotalFAPriceOverride += priceOverride;
                            }
                            
                            FAPricingRecord2.Price__c=8888888.00;   
                            fapriceWrapper priceWrapperInstance = new fapriceWrapper();
                            priceWrapperInstance.faPrice = FAPricingRecord2;
                            priceWrapperInstance.faPriceOverride =priceOverride.setScale(2);  // priceOverride.setScale(2);
                            if(FAPriceWrapperList == null) {
                            
                            	FAPriceWrapperList = new list<fapriceWrapper>();
                        	}
                            FAPriceWrapperList.add(priceWrapperInstance);
                           
                           /* if(has9999999 == false) //FAPricingRecord2.Price_Override__c == 8888888 &&
                            {
                                has8888888 = true;    
                                TotalFAPriceOverride = 8888888.00;
                            }  */                        
                          //  uniqueListprice.add(FAPricingRecord2.Pricing_Element__c);
                        }                     
                   }             
                
                if((decimal) sObj.get('Quantity__c') != null && (decimal) sObj.get('Quantity__c') != 0)
                {
                    if(has9999999==false && has8888888==false){
                        	ListPriceEach=TotalFAPriceOverride + ( NonDiscountablePriceEach / (decimal) sObj.get('Quantity__c'));
                            sObj.put('List_Price_Each__c',ListPriceEach);
                        //System.debug('Price List Each---Normal' +conRV.List_Price_Each__c);
                           sObj.put('Discountable_Price__c',TotalFAPriceOverride);
                    	}      
                     if(has9999999==true)
                    {
                        ListPriceEach = TotalFAPriceOverride;
                        sObj.put('List_Price_Each__c',ListPriceEach);
                        //System.debug('Price List Each---999999999' +conRV.List_Price_Each__c);
                        sObj.put('Discountable_Price__c',TotalFAPriceOverride);
                    } 
                    else if(has8888888==true){
                        ListPriceEach = TotalFAPriceOverride;
                        sObj.put('List_Price_Each__c',ListPriceEach);
                        sObj.put('Discountable_Price__c',TotalFAPriceOverride);
                    }
                    sObj.put('Non_Discountable_Price__c',NonDiscountablePriceEach);
                }

            }
                    LISTPRICE=ListPriceEach;
                    TOTALPRICE=TotalFAPriceOverride+NonDiscountablePriceEach;
                    update sObj;
                    //update wgbOutput;
                }
                if(isCostOverridden) {
                    List<Cost__c> cstLstHidden=new List<Cost__c>();
                    cstLstHidden=[Select id,Cost_Method__c,Part_Number__c,Cost_Sub_Type__c,Inside_Cost_10__c,Outside_Cost_10__c,Inside_Cost_20__c,Outside_Cost_30__c,Inside_Cost_30__c,Outside_Cost_20__c from Cost__c where Ref_Id__c=:String.valueOf(sObj.Id) and Product__c='FlameProducts' and Cost_Method__c='Overriden'];
                    if (cstLstHidden.size()>0) {
                        COSTINSIDESITE10=double.ValueOf(cstLstHidden[0].Inside_Cost_10__c);
                        COSTINSIDESITE20=double.ValueOf(cstLstHidden[0].Inside_Cost_20__c);
                        COSTINSIDESITE30=double.ValueOf(cstLstHidden[0].Inside_Cost_30__c);
                       // COSTINSIDESITE40=cstLstHidden[0].Inside_Cost_40__c;
                        COSTOUTSIDESITE10=double.ValueOf(cstLstHidden[0].Outside_Cost_10__c);
                        COSTOUTSIDESITE20=double.ValueOf(cstLstHidden[0].Outside_Cost_20__c);
                        COSTOUTSIDESITE30=double.ValueOf(cstLstHidden[0].Outside_Cost_30__c);
                        //COSTOUTSIDESITE40=cstLstHidden[0].Outside_Cost_40__c;
                    }
                } else {
                    WizardCostProcessor wCProc=new WizardCostProcessor(sObj.Id);
                    result resCost=wCProc.addBGRCostData();
                    if (resCost.bResult) {
                        List<Cost__c> cstLstOverriden=new List<Cost__c>();
                        cstLstOverriden=[Select id,Cost_Method__c,Part_Number__c,Cost_Sub_Type__c,Inside_Cost_10__c,Outside_Cost_10__c,Inside_Cost_20__c,Outside_Cost_30__c,Inside_Cost_30__c,Outside_Cost_20__c from Cost__c where Ref_Id__c=:String.valueOf(sObj.Id) and Product__c='FlameProducts' and Cost_Method__c='Overriden'];
                        System.debug('cstLstOverriden'+cstLstOverriden);
                        if (cstLstOverriden.size()>0) {
                            if (cstLstOverriden[0].Inside_Cost_10__c!=null)
                                COSTINSIDESITE10=double.ValueOf(cstLstOverriden[0].Inside_Cost_10__c);
                            if (cstLstOverriden[0].Inside_Cost_20__c!=null)
                                COSTINSIDESITE20=double.ValueOf(cstLstOverriden[0].Inside_Cost_20__c);
                            if (cstLstOverriden[0].Inside_Cost_30__c!=null)
                            COSTINSIDESITE30=double.ValueOf(cstLstOverriden[0].Inside_Cost_30__c);
                            //COSTINSIDESITE40=cstLstOverriden[0].Inside_Cost_40__c;
                            if (cstLstOverriden[0].Outside_Cost_10__c!=null)
                                COSTOUTSIDESITE10=double.ValueOf(cstLstOverriden[0].Outside_Cost_10__c);
                            if (cstLstOverriden[0].Outside_Cost_20__c!=null)
                                COSTOUTSIDESITE20=double.ValueOf(cstLstOverriden[0].Outside_Cost_20__c);
                            if (cstLstOverriden[0].Outside_Cost_30__c!=null)
                                COSTOUTSIDESITE30=double.ValueOf(cstLstOverriden[0].Outside_Cost_30__c);
                            //COSTOUTSIDESITE40=cstLstOverriden[0].Outside_Cost_40__c;
                        }
                    }
                }
            }
            else if (prdCode=='WGB') {
                WGBOutputUtility WGBOU =new WGBOutputUtility(sObj.Id);
                isLeadTimeOverridden=(boolean) sObjFields.get('Lead_Time_Engineer_Override__c');
                isPriceOverridden=(boolean) sObjFields.get('Price_Engineer_Override__c');
                isCostOverridden=(boolean) sObjFields.get('Cost_Override__c');
                List<WGB_Outputs__c> wgbOutputList = new List<WGB_Outputs__c>();
                String fieldsAPIname = FLMutility.getObjectFields('WGB_Outputs__c');
                String soql = 'SELECT '+fieldsAPIname+' FROM WGB_Outputs__c where WasteGasBurner__c =\''+String.escapeSingleQuotes(sObj.Id)+'\'';
                wgbOutputList = Database.query(soql);
                WGB_Outputs__c wgbOutput=new WGB_Outputs__c();
                if(wgbOutputList.size()>0)
                    wgbOutput=wgbOutputList[0];
                if(isLeadTimeOverridden) {
                    LEADTIMEFORSITE10=(decimal) wgbOutput.get('X10__c');
                    LEADTIMEFORSITE20=(decimal) wgbOutput.get('X20__c');
                    LEADTIMEFORSITE30=(decimal) wgbOutput.get('X30__c');
                    LEADTIMEFORSITE40=(decimal) wgbOutput.get('X40__c');
                } else {
                    result res=new result();
                    res = WGBOU.getLeadTime();
                    LEADTIMEFORSITE10=0.0;
                    LEADTIMEFORSITE20=0.0;
                    LEADTIMEFORSITE30=0.0;
                    LEADTIMEFORSITE40=0.0;
                    for(sObject wgbLT:res.objResultList)
                    {
                        WGB_LeadTime__c WGBLeadTimeRec = (WGB_LeadTime__c) wgbLT;
                        wgbOutput.X10__c = (WGBLeadTimeRec.X10__c);
                        wgbOutput.X20__c = (WGBLeadTimeRec.X20__c);
                        wgbOutput.X30__c = (WGBLeadTimeRec.X30__c);
                        wgbOutput.X40__c = (WGBLeadTimeRec.X40__c);
                        if(WGBLeadTimeRec.X10__c!=null) {
                          //  if(WGBLeadTimeRec.X10__c != 7777 && WGBLeadTimeRec.X10__c != 4995 )
                          //  {
                                LEADTIMEFORSITE10 += WGBLeadTimeRec.X10__c;
                         //   } else {

                          //  }
                        }
                        if(WGBLeadTimeRec.X20__c!=null) {
                        //    if(WGBLeadTimeRec.X20__c != 7777 && WGBLeadTimeRec.X20__c != 4995 )
                        //    {
                                LEADTIMEFORSITE20 += WGBLeadTimeRec.X20__c;
                        //    } else {
                          //      LEADTIMEFORSITE20=WGBLeadTimeRec.X20__c;
                        //    }
                        }
                        if(WGBLeadTimeRec.X30__c!=null) {
                          //  if(WGBLeadTimeRec.X30__c != 7777 && WGBLeadTimeRec.X30__c != 4995 )
                          //  {
                                LEADTIMEFORSITE30 += WGBLeadTimeRec.X30__c;
                          //  } else {
                          //      LEADTIMEFORSITE30=WGBLeadTimeRec.X30__c;
                         //   }
                        }
                        if(WGBLeadTimeRec.X40__c!=null) {
                          //  if(WGBLeadTimeRec.X40__c != 7777 && WGBLeadTimeRec.X40__c != 4995 )
                         //   {
                                LEADTIMEFORSITE40 += WGBLeadTimeRec.X40__c;
                        //    } else {
                         //       LEADTIMEFORSITE40=WGBLeadTimeRec.X40__c;
                          //  }
                        }
                    }
                    update wgbOutput;
                }
                if (isPriceOverridden) {
                    QTY=(decimal) sObj.get('Quantity__c');
                    LISTPRICE=(decimal) sObj.get('List_Price_Each__c');
                    DISCOUNTABLELISTPRICE=(decimal) sObj.get('Discountable_Price__c');
                    NONDISCOUNTABLELISTPRICE=(decimal) sObj.get('Non_Discountable_Price__c');
                } else  {
                    result prncgResult=WGBOU.getPricing();
                    List<WGB_Price_Detail__c> updateBGRPrice=new List<WGB_Price_Detail__c>();
                    decimal decPriceTotal=0.0;
                    if(prncgResult.bResult)
                    {
                        for (sObject sobj:prncgResult.objResultList)
                        {
                            WGB_Price_Detail__c  WGBPricingRecord = new WGB_Price_Detail__c ();
                            WGBPricingRecord = (WGB_Price_Detail__c ) sobj;
                            if(WGBPricingRecord.Price__c != 9999999)
                                decPriceTotal+=WGBPricingRecord.Price__c;
                            //updateBGRPrice.add(WGBPricingRecord);
                            wgbOutput.put(mapWGBOutputElements.get(WGBPricingRecord.Component__c),WGBPricingRecord.Price__c);
                        }
                        QTY=(decimal) sObj.get('Quantity__c');
                        decimal ListPriceEach = (decPriceTotal) / QTY;
                        sObj.put('List_Price_Each__c',ListPriceEach);
                        sObj.put('Discountable_Price__c',0.0);
                        sObj.put('Non_Discountable_Price__c',decPriceTotal);
                        LISTPRICE=decPriceTotal;
                        TOTALPRICE=decPriceTotal;
                        update sObj;
                        update wgbOutput;
                    }
                }
                if(isCostOverridden) {
                    List<Cost__c> cstLstHidden=new List<Cost__c>();
                    cstLstHidden=[Select id,Cost_Method__c,Part_Number__c,Cost_Sub_Type__c,Inside_Cost_10__c,Outside_Cost_10__c,Inside_Cost_20__c,Outside_Cost_30__c,Inside_Cost_30__c,Outside_Cost_20__c from Cost__c where Ref_Id__c=:String.valueOf(sObj.Id) and Product__c='WGB' and Cost_Method__c='Overriden'];
                    if (cstLstHidden.size()>0) {
                        COSTINSIDESITE10=double.ValueOf(cstLstHidden[0].Inside_Cost_10__c);
                        COSTINSIDESITE20=double.ValueOf(cstLstHidden[0].Inside_Cost_20__c);
                        COSTINSIDESITE30=double.ValueOf(cstLstHidden[0].Inside_Cost_30__c);
                       // COSTINSIDESITE40=cstLstHidden[0].Inside_Cost_40__c;
                        COSTOUTSIDESITE10=double.ValueOf(cstLstHidden[0].Outside_Cost_10__c);
                        COSTOUTSIDESITE20=double.ValueOf(cstLstHidden[0].Outside_Cost_20__c);
                        COSTOUTSIDESITE30=double.ValueOf(cstLstHidden[0].Outside_Cost_30__c);
                        //COSTOUTSIDESITE40=cstLstHidden[0].Outside_Cost_40__c;
                    }
                } else {
                    WizardCostProcessor wCProc=new WizardCostProcessor(sObj.Id);
                    result resCost=wCProc.addBGRCostData();
                    if (resCost.bResult) {
                        List<Cost__c> cstLstOverriden=new List<Cost__c>();
                        cstLstOverriden=[Select id,Cost_Method__c,Part_Number__c,Cost_Sub_Type__c,Inside_Cost_10__c,Outside_Cost_10__c,Inside_Cost_20__c,Outside_Cost_30__c,Inside_Cost_30__c,Outside_Cost_20__c from Cost__c where Ref_Id__c=:String.valueOf(sObj.Id) and Product__c='WGB' and Cost_Method__c='Overriden'];
                        System.debug('cstLstOverriden'+cstLstOverriden);
                        if (cstLstOverriden.size()>0) {
                            if (cstLstOverriden[0].Inside_Cost_10__c!=null)
                                COSTINSIDESITE10=double.ValueOf(cstLstOverriden[0].Inside_Cost_10__c);
                            if (cstLstOverriden[0].Inside_Cost_20__c!=null)
                                COSTINSIDESITE20=double.ValueOf(cstLstOverriden[0].Inside_Cost_20__c);
                            if (cstLstOverriden[0].Inside_Cost_30__c!=null)
                            COSTINSIDESITE30=double.ValueOf(cstLstOverriden[0].Inside_Cost_30__c);
                            //COSTINSIDESITE40=cstLstOverriden[0].Inside_Cost_40__c;
                            if (cstLstOverriden[0].Outside_Cost_10__c!=null)
                                COSTOUTSIDESITE10=double.ValueOf(cstLstOverriden[0].Outside_Cost_10__c);
                            if (cstLstOverriden[0].Outside_Cost_20__c!=null)
                                COSTOUTSIDESITE20=double.ValueOf(cstLstOverriden[0].Outside_Cost_20__c);
                            if (cstLstOverriden[0].Outside_Cost_30__c!=null)
                                COSTOUTSIDESITE30=double.ValueOf(cstLstOverriden[0].Outside_Cost_30__c);
                            //COSTOUTSIDESITE40=cstLstOverriden[0].Outside_Cost_40__c;
                        }
                    }
                }
            }
            System.debug('LEADTIMEFORSITE10: ' + LEADTIMEFORSITE10);
            System.debug('LEADTIMEFORSITE20: ' + LEADTIMEFORSITE20);
            System.debug('LEADTIMEFORSITE30: ' + LEADTIMEFORSITE30);
            System.debug('LEADTIMEFORSITE40: ' + LEADTIMEFORSITE40);
            System.debug('COSTINSIDESITE10: ' + COSTINSIDESITE10);
            System.debug('COSTINSIDESITE20: ' + COSTINSIDESITE20);
            System.debug('COSTINSIDESITE30: ' + COSTINSIDESITE30);
           // System.debug('COSTINSIDESITE40: ' + COSTINSIDESITE40);
            System.debug('COSTOUTSIDESITE10: ' + COSTOUTSIDESITE10);
            System.debug('COSTOUTSIDESITE20: ' + COSTOUTSIDESITE20);
            System.debug('COSTOUTSIDESITE30: ' + COSTOUTSIDESITE30);
            System.debug('PARTNUMBER: ' + PARTNUMBER);
            System.debug('LISTPRICE: ' + LISTPRICE);
            System.debug('TOTALPRICE: ' + TOTALPRICE);
            // System.debug('NONDISCOUNTABLELISTPRICE: ' + NONDISCOUNTABLELISTPRICE);
        }
        result resConfig=new result();
        return resConfig;
        //Lead-time
    }
}