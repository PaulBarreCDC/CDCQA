/**
* @File Name          : WGBOutputUtility.cls
* @Description        :
* @Author             : Vikram Natikar
* @Group              :
* @Last Modified By   : Vikram Natikar
* @Last Modified On   : 04/11/2020
* @Modification Log   :
* Ver       Date            Author                  Modification
* 1.0    03/03/2020      Vikram Natikar           Initial Version
* 1.1    08/03/2021      Rohini Hathi            Support Ticket# 200752, limit chars in desc field
**/ 

public class WGBOutputUtility implements HandlerInterface{
        
        public WGBOutputUtility (Id recordID) {
        currentWGB= (WasteGasBurner__c) wizardBaseDataProcessor.getObjectDataById(recordID).objResultList[0];
         
            
        //TroubleShootingWGBAttr=new Map<String, string>();
        mapWGBAttr=new Map<String, string>();
        mapWGB_Attribute=new Map<String, string>();
        mapWGB_Attribute=getMapAttribute();
       /* if (PTC!=NULL) {
            WGB_PartParameters_StackMaterial__c WCG_PartParameter=[select MCLS__c,MCUS__c from WGB_PartParameters_StackMaterial__c where Model__c=:PTC  order by MCLS__c][0];
        }
        */
       
        //Map<String, String> mapWGB_Attribute = new Map<String, String>();
       // mapWGB_Attribute = getMapAttribute(); 
       List<WGB_Outputs__c> wgbOutputList = new List<WGB_Outputs__c>();
            String fieldsAPIname = FLMutility.getObjectFields('WGB_Outputs__c');    
            String soql = 'SELECT ' + fieldsAPIname +' FROM WGB_Outputs__c ';
            soql += ' WHERE WasteGasBurner__c =\''+String.escapeSingleQuotes(currentWGB.Id)+'\' ';    
            System.debug('@Developer --> soql :' + soql);    
            wgbOutputList = Database.query(soql);
            if(wgbOutputList.size() > 0)
            {
                if(string.isNotBlank(wgbOutputList[0].OA_Override__c))
                {
                    OA = wgbOutputList[0].OA_Override__c;
                }
                else
                {
                    OA = currentWGB.OA__c;
                }
                if(string.isNotBlank(wgbOutputList[0].OB_Override__c))
                {
                    OB = wgbOutputList[0].OB_Override__c;
                }
                else
                {
                    OB = currentWGB.OB__c;
                }
                //OW = wgbOutputList[0].OW_Override__c;
                //PC = bgrOutputList[0].PC_Override__c;
            }
            else
            {
                OA = currentWGB.OA__c;
                OB = currentWGB.OB__c;
                //OW = currentWGB.OW__c;
                //PC = currentRV.PC__c;
            }

        
    } 
        
    public WasteGasBurner__c currentWGB{get; set;}
    public map<string,string> mapWGB_Attribute {get;set;}
    //PUBLIC WGB_PartParameters_StackMaterial__c WCG_PartParameter{set;get;}
    // Map Attributes 
    public Map<string,string> mapWGBAttr{
        get{ 
            Map<String, string> myMap1 = new Map<String, String>(); 
                myMap1.put('GASGROUP',GASGROUP);
                myMap1.put('GASUOM',GASUOM);
               // myMap1.put('GASMIN',String.valueOf(GASMIN));
               // myMap1.put('GASMAX',String.valueOf(GASMAX));
                myMap1.put('GAGES',GAGES);
                myMap1.put('REGULATOR',REGULATOR);
                myMap1.put('REQDFLOW',String.valueOf(REQDFLOW));
                myMap1.put('REQDFLOWUOM',REQDFLOWUOM);
                myMap1.put('RTPRS1',string.valueOf(RTPRS1));
                myMap1.put('RTPRSU',RTPRSU);            
                myMap1.put('CONVERTEDFLOW',string.valueOf(CONVERTEDFLOW));
                myMap1.put('ULCERT',ULCERT);
                myMap1.put('PTC',PTC);
                myMap1.put('SZC',SZC);
                myMap1.put('QTY',string.valueOf(QTY));
                myMap1.put('MCUS',String.valueOf(MCUS));
                myMap1.put('MCLS',string.valueOf(MCLS));
                myMap1.put('OA',OA);
                myMap1.put('OB',OB);
                myMap1.put('PEDCON',PEDCON);
                myMap1.put('FLMSNS',FLMSNS);
                myMap1.put('TCMATERIAL',TCMATERIAL);
                myMap1.put('ENCTYP',ENCTYP);
                myMap1.put('CPALRM',CPALRM);
                myMap1.put('CPHEAT',CPHEAT);
                myMap1.put('STNDCT',STNDCT);
                myMap1.put('SUNCTL',SUNCTL);
                myMap1.put('SPDT',SPDT);
                myMap1.put('BPS',BPS);
                myMap1.put('MODEL',MODEL);           
                myMap1.put('IGNCTL',IGNCTL);
                myMap1.put('SIZECODE',SIZECODE);
                myMap1.put('PilotSupplyPressConverted',string.valueOf(PilotSupplyPressConverted));
                myMap1.put('ASYTYP',ASYTYP);
                myMap1.put('GMODEL',GMODEL);
                myMap1.put('GTAG01',GTAG01);
                myMap1.put('GTAGPN',GTAGPN);
                myMap1.put('BRAND',BRAND);
                myMap1.put('BRANDCODE',BRANDCODE);
                myMap1.put('PRDLIN',PRDLIN);
                return myMap1;
        }
        set{
            this.mapWGBAttr=value;
        }
    }   
    
    

//TroubleShootingWGBAttr=new Map<String, string>();

public Map<string,string> getTroubleShootingWGBAttr(){
            Map<String, string> myMap1 = new Map<String, String>(); 
                myMap1.put('ASSEMBLYWT',ASSEMBLYWT);
                myMap1.put('ASSEMBLYWTUOM',ASSEMBLYWTUOM);
                myMap1.put('ATTRTEMPLATE',ATTRTEMPLATE);
                myMap1.put('BRANDCODE',BRANDCODE);
                myMap1.put('COMPDESCRIPTION',COMPDESCRIPTION);
                myMap1.put('COMPINVSERTRK',COMPINVSERTRK);
                myMap1.put('COMPLOTTRACK',COMPLOTTRACK);
                myMap1.put('COMPPROVIDE',COMPPROVIDE);
                myMap1.put('COMPRESPONID',COMPRESPONID);
                myMap1.put('ConnectionDesc',ConnectionDesc);
                myMap1.put('CUSTOMSTATNO',CUSTOMSTATNO);
                myMap1.put('EnclosureOpt',EnclosureOpt);
                myMap1.put('EnclosureOptDesc',EnclosureOptDesc);
                myMap1.put('FlameSensorOpt',FlameSensorOpt);
                myMap1.put('FlameSensorOptDesc',FlameSensorOptDesc);
                myMap1.put('HSNSACCODE',HSNSACCODE);
                myMap1.put('IgnitorOpt',IgnitorOpt);
                myMap1.put('IgnitorOptDesc',IgnitorOptDesc);
                myMap1.put('LOTTRACKCODE',LOTTRACKCODE);
                myMap1.put('MCEVAL',MCEVAL);
                myMap1.put('MCLSDesc',MCLSDesc);
                myMap1.put('MCUSDesc',MCUSDesc);
                myMap1.put('MW',MW);
                myMap1.put('PARTCLASS',PARTCLASS);
                myMap1.put('PARTUOM',PARTUOM);
                myMap1.put('PLANNER',PLANNER);
                myMap1.put('PROVIDE',PROVIDE);
                myMap1.put('RESPONSIBLE_ID',RESPONSIBLE_ID);
                myMap1.put('SALESGROUP',SALESGROUP);
                myMap1.put('SALESPRICEGROUP',SALESPRICEGROUP);
                myMap1.put('SERIALTRACKCODE',SERIALTRACKCODE);
                myMap1.put('SizeDesc',SizeDesc);
                myMap1.put('SpecialOpt',SpecialOpt);
                myMap1.put('SpecialOpt0',SpecialOpt0);
                myMap1.put('SpecialOpt2',SpecialOpt2);
                myMap1.put('SpecialOpt4',SpecialOpt4);
                myMap1.put('SpecialOpt6',SpecialOpt6);
                myMap1.put('SpecialOpt8',SpecialOpt8);
                myMap1.put('SpecialOptDesc',SpecialOptDesc);  
                string strCONVERTEDFLOW=CONVERTEDFLOW.stripTrailingZeros().toPlainString();
                myMap1.put('CONVERTEDFLOW',strCONVERTEDFLOW);
                myMap1.put('GAGES',GAGES);
              //  myMap1.put('OA01',OA01);
                myMap1.put('PilotSupplyPressConverted',String.Valueof(PilotSupplyPressConverted));
                myMap1.put('REGULATOR',REGULATOR);

            return myMap1;
    }   
    


    
    public string SIZECODE{
        get{
          /*  result FlowRateResult=new result();
            String strSizeCode='';
            //getDocument instead of getProdDoc() method
            FlowRateResult=getFlowRate();
            FlowLRateList=new List<WGB_PartParameters_FlowRateDetail__c>();
            FlowLRateList=FlowRateResult.objResultList;
            
            if(FlowRateResult.bResult)
            {
                for(sObject sobj:FlowRateResult.objResultList) 
                {
                   
                    strSizeCode=(STRING) sobj.get('SizeCode__c');
                }
            }
                return strSizeCode;*/
            
                return currentWGB.Size__c;
            }
        set{
            this.SIZECODE=value;
        }
    }
    /*
    public class SizeWrapper
    {
        public string strsize {set;get;}
    }
        public list<SizeWrapper> getRouter()
        {
        list<SizeWrapper> SizeWrapList=new list<SizeWrapper>();
        result res=new result();
        res=getFlowRate();
        if(res.bResult) 
        {
            for (sObject sobj:res.objResultList) 
            {
                SizeWrapper docWrap=new SizeWrapper();
                docWrap.strsize  = (string) sobj.get('SizeCode__c');
                SizeWrapList.add(docWrap);
             }
        }
        return SizeWrapList;
    }*/
    
    public string MODEL {
        get {
            return currentWGB.Select_Model__c;
        }
        set {
            this.MODEL=value;
        }
    }
    

    //Price Method  Resolved
    Public Result getPricing()
    {
        result WGBPrice = new Result();
        List<String> selectCols = new List<String> {'Price__c','Component__c'}; //,'Price_Override__c'
        WGBPrice=wizardBaseDataProcessor.getSortedDataFromTranslationObj('Component__c','WGB_Price_Translation__c','WGB_Price_Detail__c',mapWGBAttr,selectCols,'Component__c');
     /*   if(WGBPrice.bResult)
        { 
            system.debug('Pricing Result' +WGBPrice.objResultList);
        } */
        return WGBPrice; 
    }
  
   
    //ControlPlan Method Resolved
    Public Result getControlPlan()
    {
        result WGBControlPlan = new Result();
        List<String> selectCols = new List<String> {'TEST_OPERATION_DESC__c','NORM_TYPE__c','Operation_Number__c','DATA_TYPE__c','CATEGORY_ID__c','INSPECTION_CODE__c',
        'SAMPLE_PERCENT__c','Process_Characteristic__c','OUTER_MIN__c','INNER_MIN__c','NOMINAL_VALUE__c','INNER_MAX__c','OUTER_MAX__c','Tool_ID__c','Data_Point__c','Test_OPNO__c'};
        WGBControlPlan=wizardBaseDataProcessor.getSortedDataFromTranslationObj('Test_OPNO__c','WGB_ControlPlan_Translation__c','WGB_ControlPlan_Detail__c',mapWGBAttr,selectCols,'Test_OPNO__c');
     /*   if(WGBControlPlan.bResult)
        { 
            system.debug('ControlPlan Result' +WGBControlPlan.objResultList);
        } */
        return WGBControlPlan;
    }      

    //Document Method   Resolved
    Public Result getDocument()
    {
        result WGBDocument = new Result();
        List<String> selectCols = new List<String> {'Document_ID__c','Revision__c','Document__c'};
        WGBDocument=wizardBaseDataProcessor.getDataFromTranslationObj('Document__c','WGB_Document_Translation__c','WGB_Document_Detail__c',mapWGBAttr,selectCols);
    /*    if(WGBDocument.bResult)
        { 
            system.debug('Document Result' +WGBDocument.objResultList);
        } */
        return WGBDocument;
    }

    
    //Structure Method Resolved
    Public Result getStructure()
    {
        result WGBStructure = new Result();
          /*  decimal GasMin2=0.0,GasMax2=0.0,GASMIN=0.0,GASMAX=0.0;
            System.debug('GASGROUP-------'+GASGROUP);
            if(GASGROUP!=null)
            {
                GasMin2=[select GasMin__c from WGB_Module_Orifice__c where GasGroup__c=:GASGROUP order by GasMin__c ASC][0].GasMin__c;
            } 
          
            if(GASGROUP!=null)
            {
                GasMax2=[select GasMax__c from WGB_Module_Orifice__c where GasGroup__c=:GASGROUP order by GasMax__c DESC][0].GasMax__c;
            } 
        if(GasMin2!=null)
            GASMIN=Gasmin2;
        else
            GASMIN=0.0;
        if(GasMax2!=null)
            GASMAX=GasMax2;
        else
            GASMAX=0.0;
        
        mapWGBAttr.put('GASMIN',String.valueOf(GASMIN));
        mapWGBAttr.put('GASMAX',String.valueOf(GASMAX)); 
        System.debug('GasMin-------' + GASMIN);
        System.debug('GasMax-------' + GASMAX);*/
        List<String> selectCols = new List<String> {'Part_Number__c','Qty_per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Component__c','Line_Item_No__c'};
        WGBStructure=wizardBaseDataProcessor.getDataFromTranslationObj('Component__c','WGB_Structure_ComponentTranslation__c','WGB_Structure_ComponentDetail__c',mapWGBAttr,selectCols);
     /*   if(WGBStructure.bResult)
        { 
            system.debug('Structure Result' +WGBStructure.objResultList);
        } */
        return WGBStructure;
    }
  
    //WorkGuideLines Method Resolved
    Public Result getWorkGuideLines()
    {
        result WGBWorkGuideLines = new Result();
        List<String> selectCols = new List<String> {'Standard_Operation_ID__c','Outside_Operation_Item__c','Guidline_Seq__c','Description__c',
            'Text__c','Type__c','Sign_Off__c','Inspection_Sign_Off_Required__c','Operation__c'};
        WGBWorkGuideLines=wizardBaseDataProcessor.getSortedDataFromTranslationObj('Operation__c','WGB_Workguidelines_Translation__c','WGB_Workguideline_Detail__c',mapWGBAttr,selectCols,'Guidline_Seq__c');
     /*   if(WGBWorkGuideLines.bResult)
        { 
            system.debug('WorkGuideLines Result' +WGBWorkGuideLines.objResultList);
        } */
        return WGBWorkGuideLines;
    }
    
     //LeadTime Method
     public Result getLeadTime() {
        //list<BGMStructureWrapper> BGMStructureList = new list<BGMStructureWrapper>();
        result strcResult=new result();
        if(PTC != null && QTY !=null)
        {
            List<String> selectCols=new List<String>{'Schedule__c','X10__c','X20__c','X30__c','X40__c'}; //,'Lead_Time_10_Override__c','Lead_Time_20_Override__c','Lead_Time_30_Override__c','Lead_Time_40_Override__c'
            system.debug('*****selectCols'+selectCols);
            String strPTC='\''+PTC+'\'';
            String strQTY=String.valueOf(QTY);            
            
            List<String> whereCols=new List<String>{'PTC__c','QtyLL__c','QtyUL__c'};
                List<String> whereVals=new List<String>{strPTC,strQTY,strQTY};
                    List<String> whereComps=new List<String>{'=','<=','>='};
                        List<String> extraChars=new List<String>{'','',''};  
                            strcResult=wizardBaseDataProcessor.getProdOutputDescData1('WGB_LeadTime__c',selectCols,whereCols,whereVals,whereComps,extraChars,'Schedule__c');
        /*    if(strcResult.bResult)
            { 
                system.debug('LeadTime List' +strcResult.objResultList );
                
            }     */     
        }
        return strcResult;
    } 
    
    //Routing Method
     Public Result getRouting()
     {
         result WGBRouting = new Result();
         List<String> selectCols = new List<String> {'Standard_Operation_ID__c','Outside_Operation_Item__c','Descr__c','Operation__c'};
         WGBRouting=wizardBaseDataProcessor.getSortedDataFromTranslationObj('Operation__c','WGB_Routing_Translation__c','WGB_Routing_Detail__c',mapWGBAttr,selectCols,'Operation__c');
     /*    if(WGBRouting.bResult)
         { 
            system.debug('Routing Result' + WGBRouting.objResultList);
         } */
         return WGBRouting;    
      }

    //FlowRate Method
    Public Result getFlowRate()
    {
        result WGBFlowRate = new Result();
        List<String> selectCols = new List<String> {'SizeCode__c'};
        WGBFlowRate=wizardBaseDataProcessor.getDataFromTranslationObj('Type__c','WGB_PartParameters_FlowRateTranslation__c','WGB_PartParameters_FlowRateDetail__c',mapWGBAttr,selectCols);
     /*   if(WGBFlowRate.bResult)
        { 
            system.debug('FlowRate Result' + WGBFlowRate.objResultList);
        } */
        return WGBFlowRate;
    }


    //Lookup Attributes Method Resolved
    Public map<string,string> getMapAttribute()
    {
        Map<String, string> mapWGB_Attribute1 = new Map<String, string>(); 
        result WGBAttributes = new Result();
        List<String> selectCols = new List<String> {'Text__c','Attribute__c','Value__c'};
        WGBAttributes=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','WGB_Attribute_Lookup_Translation__c','WGB_Attribute_Lookup_Detail__c',mapWGBAttr,selectCols);
        if(WGBAttributes.bResult)
        { 
                for(sObject objD : WGBAttributes.objResultList)
            {
                WGB_Attribute_Lookup_Detail__c wgbLookupData = (WGB_Attribute_Lookup_Detail__c)objD;
                if(wgbLookupData.Text__c != null && wgbLookupData.Value__c == null)
                {
                    mapWGB_Attribute1.put(wgbLookupData.Attribute__c, wgbLookupData.Text__c);
                }
                if(wgbLookupData.Text__c == null && wgbLookupData.Value__c != null)
                {
                    mapWGB_Attribute1.put(wgbLookupData.Attribute__c, String.valueOf(wgbLookupData.Value__c));
                }
                if(wgbLookupData.Text__c != null && wgbLookupData.Value__c != null)
                {
                    mapWGB_Attribute1.put(wgbLookupData.Attribute__c, wgbLookupData.Text__c+' '+wgbLookupData.Value__c);
                }
                if(wgbLookupData.Text__c == null && wgbLookupData.Value__c == null)
                {
                    mapWGB_Attribute1.put(wgbLookupData.Attribute__c, '');
                }
              //  System.debug('***** Adding into map as key = '+wgbLookupData.Attribute__c+' and value = '+(wgbLookupData.Text__c+' '+wgbLookupData.Value__c));
            }
        } 
        
        
     //   string SpecialOpt0=mapWGB_Attribute1.get('SpecialOpt0')==null?'': mapWGB_Attribute1.get('SpecialOpt0');
        string SpecialOpt2=mapWGB_Attribute1.get('SpecialOpt2')==null?'': mapWGB_Attribute1.get('SpecialOpt2');
        string SpecialOpt4=mapWGB_Attribute1.get('SpecialOpt4')==null?'': mapWGB_Attribute1.get('SpecialOpt4');
        string SpecialOpt6=mapWGB_Attribute1.get('SpecialOpt6')==null?'': mapWGB_Attribute1.get('SpecialOpt6');
        string SpecialOpt8=mapWGB_Attribute1.get('SpecialOpt8')==null?'': mapWGB_Attribute1.get('SpecialOpt8');
        string strEnclosureOpt=mapWGB_Attribute1.get('EnclosureOpt')==null?'': mapWGB_Attribute1.get('EnclosureOpt');
        string strFlameSensorOpt=mapWGB_Attribute1.get('FlameSensorOpt')==null?'': mapWGB_Attribute1.get('FlameSensorOpt');
        string strIgnitorOpt=mapWGB_Attribute1.get('IgnitorOpt')==null?'': mapWGB_Attribute1.get('IgnitorOpt');
        Map<String, String> mapattr2 = new Map<String, String>();
        mapattr2.putAll(mapWGBAttr);
     //   mapattr2.put('SpecialOpt0',SpecialOpt0); 
        mapattr2.put('SpecialOpt2',SpecialOpt2); 
        mapattr2.put('SpecialOpt4',SpecialOpt4);
        mapattr2.put('SpecialOpt6',SpecialOpt6); 
        mapattr2.put('SpecialOpt8',SpecialOpt8);
        mapattr2.put('EnclosureOpt',strEnclosureOpt); 
        mapattr2.put('FlameSensorOpt',strFlameSensorOpt);
        mapattr2.put('IgnitorOpt',strIgnitorOpt);
        
        Map<String, string> mapWGB_Attribute2 = new Map<String, string>(); 
        result WGBAttributes2 = new Result();
        WGBAttributes2=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','WGB_Attribute_Lookup_Translation__c','WGB_Attribute_Lookup_Detail__c',mapattr2,selectCols);
        if(WGBAttributes2.bResult)
        { 
                for(sObject objD : WGBAttributes2.objResultList)
            {
                WGB_Attribute_Lookup_Detail__c wgbLookupData = (WGB_Attribute_Lookup_Detail__c)objD;
                if(wgbLookupData.Text__c != null && wgbLookupData.Value__c == null)
                {
                    mapWGB_Attribute2.put(wgbLookupData.Attribute__c, wgbLookupData.Text__c);
                }
                if(wgbLookupData.Text__c == null && wgbLookupData.Value__c != null)
                {
                    mapWGB_Attribute2.put(wgbLookupData.Attribute__c, String.valueOf(wgbLookupData.Value__c));
                }
                if(wgbLookupData.Text__c != null && wgbLookupData.Value__c != null)
                {
                    mapWGB_Attribute2.put(wgbLookupData.Attribute__c, wgbLookupData.Text__c+' '+wgbLookupData.Value__c);
                }
                if(wgbLookupData.Text__c == null && wgbLookupData.Value__c == null)
                {
                    mapWGB_Attribute2.put(wgbLookupData.Attribute__c, '');
                }
                System.debug('***** Adding into map22222 as key = '+wgbLookupData.Attribute__c+' and value = '+(wgbLookupData.Text__c+' '+wgbLookupData.Value__c));
            }                         
           // return mapWGB_Attribute2;
        }
       // mapWGB_Attribute1.putAll(mapWGB_Attribute);
       
        string SpecialOpt=mapWGB_Attribute2.get('SpecialOpt')==null?'': mapWGB_Attribute2.get('SpecialOpt');
        Map<String, String> mapattr3 = new Map<String, String>();
        mapattr3.putAll(mapattr2);
        mapattr3.put('SpecialOpt',SpecialOpt); 
        
        Map<String, string> mapWGB_Attribute3 = new Map<String, string>(); 
        result WGBAttributes3 = new Result();
        WGBAttributes3=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','WGB_Attribute_Lookup_Translation__c','WGB_Attribute_Lookup_Detail__c',mapattr3,selectCols);
        if(WGBAttributes3.bResult)
        { 
                for(sObject objD : WGBAttributes3.objResultList)
            {
                WGB_Attribute_Lookup_Detail__c wgbLookupData = (WGB_Attribute_Lookup_Detail__c)objD;
                if(wgbLookupData.Text__c != null && wgbLookupData.Value__c == null)
                {
                    mapWGB_Attribute3.put(wgbLookupData.Attribute__c, wgbLookupData.Text__c);
                }
                if(wgbLookupData.Text__c == null && wgbLookupData.Value__c != null)
                {
                    mapWGB_Attribute3.put(wgbLookupData.Attribute__c, String.valueOf(wgbLookupData.Value__c));
                }
                if(wgbLookupData.Text__c != null && wgbLookupData.Value__c != null)
                {
                    mapWGB_Attribute3.put(wgbLookupData.Attribute__c, wgbLookupData.Text__c+' '+wgbLookupData.Value__c);
                }
                if(wgbLookupData.Text__c == null && wgbLookupData.Value__c == null)
                {
                    mapWGB_Attribute3.put(wgbLookupData.Attribute__c, '');
                }
                System.debug('***** Adding into map22222 as key = '+wgbLookupData.Attribute__c+' and value = '+(wgbLookupData.Text__c+' '+wgbLookupData.Value__c));
            }
                         
            return mapWGB_Attribute3;
        }
        
        return mapWGB_Attribute3;
    }
    
    //Method to get O attributes
     public Map<String, String> GetAttributeMapQuoteDescription()
    {
        Map<String, String> quoteAttriVsDesc = new Map<String, String>();
        Map<String, String> quoteAttriVsDesc2 = new Map<String, String>();
        //added by sunita
        
        quoteAttriVsDesc2=getMapAttribute();
        if(quoteAttriVsDesc2.size() > 0)
        {
            List<String> quoteKey = new List<String>((quoteAttriVsDesc2).Keyset());
            quoteKey.sort();
            for(String mapKey: quoteKey)
            {
                if(mapKey.startsWithIgnoreCase('O'))
                {
                    quoteAttriVsDesc.put(mapKey,quoteAttriVsDesc2.get(mapKey));
                 //   System.debug('O------------>' + quoteAttriVsDesc.get(mapKey));
                }               
            }
        }
        return quoteAttriVsDesc;               
    }
   
/*---------------------changes for UI--added by sunita----------------------------------------*/
//Method to get O attributes
/*     public Map<String, String> GetAttributeMapQuoteDescriptionforOA()
    {
        
        Map<String, String> quoteAttriVsDesc2 = new Map<String, String>();
        //added by sunita
        Map<String, String> quoteAttriVsDescforOA = new Map<String, String>();
        
        quoteAttriVsDesc2=getMapAttribute();
        if(quoteAttriVsDesc2.size() > 0)
        {
            List<String> quoteKey = new List<String>((quoteAttriVsDesc2).Keyset());
            quoteKey.sort();
            for(String mapKey: quoteKey)
            {
               
                if(mapKey.startsWithIgnoreCase('OA'))
                {
                    quoteAttriVsDescforOA .put(mapKey,quoteAttriVsDesc2.get(mapKey));
                 //   System.debug('O------------>' + quoteAttriVsDescforOA .get(mapKey));
                }
               
            }
        }
        
        return quoteAttriVsDescforOA;
       
        
    }
   
 public Map<String, String> GetAttributeMapQuoteDescriptionforOB()
    {
        
        Map<String, String> quoteAttriVsDesc2 = new Map<String, String>();
        //added by sunita
        Map<String, String> quoteAttriVsDescforOB = new Map<String, String>();
        
        quoteAttriVsDesc2=getMapAttribute();
        if(quoteAttriVsDesc2.size() > 0)
        {
            List<String> quoteKey = new List<String>((quoteAttriVsDesc2).Keyset());
            quoteKey.sort();
            for(String mapKey: quoteKey)
            {
               
                if(mapKey.startsWithIgnoreCase('OB'))
                {
                    quoteAttriVsDescforOB .put(mapKey,quoteAttriVsDesc2.get(mapKey));
                 //   System.debug('O------------>' + quoteAttriVsDescforOB.get(mapKey));
                }
               
            }
        }
        
        return quoteAttriVsDescforOB;
       
        
    }*/
/*---------------------------------------------------------------------------------------------------*/
    //Lookup Methods

    public String ATTRTEMPLATE{ 
    get {
    return mapWGB_Attribute.get('ATTRTEMPLATE')==null?'': mapWGB_Attribute.get('ATTRTEMPLATE');  
            }
    set {
            this.ATTRTEMPLATE= value;
        }
    }
    
    public String COMPDESCRIPTION{ 
    get {
    return mapWGB_Attribute.get('COMPDESCRIPTION')==null?'': mapWGB_Attribute.get('COMPDESCRIPTION');  
            }
    set {
            this.COMPDESCRIPTION= value;
        }
    }

    public String COMPINVSERTRK{ 
    get {
    return mapWGB_Attribute.get('COMPINVSERTRK')==null?'': mapWGB_Attribute.get('COMPINVSERTRK');  
        }
    set {
            this.COMPINVSERTRK= value;
        }
    }

    public String COMPLOTTRACK{ 
    get {
    return mapWGB_Attribute.get('COMPLOTTRACK')==null?'': mapWGB_Attribute.get('COMPLOTTRACK');  
        }
    set {
            this.COMPLOTTRACK= value;
        }
    }

    public String COMPPROVIDE{ 
    get {
    return mapWGB_Attribute.get('COMPPROVIDE')==null?'': mapWGB_Attribute.get('COMPPROVIDE');  
            }
    set {
            this.COMPPROVIDE= value;
        }
    }

    public String COMPRESPONID{ 
    get {
    return mapWGB_Attribute.get('COMPRESPONID')==null?'': mapWGB_Attribute.get('COMPRESPONID');  
        }
    set {
            this.COMPRESPONID= value;
        }
    }

    public String CUSTOMSTATNO{ 
    get {
    return mapWGB_Attribute.get('CUSTOMSTATNO')==null?'': mapWGB_Attribute.get('CUSTOMSTATNO');  
            }
    set {
            this.CUSTOMSTATNO= value;
        }
    }
    
    public String HSNSACCODE{ 
    get {
    return mapWGB_Attribute.get('HSNSACCODE')==null?'': mapWGB_Attribute.get('HSNSACCODE');  
        }
    set {
            this.HSNSACCODE= value;
        }
    }
    
    public String LOTTRACKCODE{ 
    get {
    return mapWGB_Attribute.get('LOTTRACKCODE')==null?'': mapWGB_Attribute.get('LOTTRACKCODE');  
        }
    set {
            this.LOTTRACKCODE= value;
        }
    }

    public String PARTCLASS{ 
    get {
    return mapWGB_Attribute.get('PARTCLASS')==null?'': mapWGB_Attribute.get('PARTCLASS');  
        }
    set {
            this.PARTCLASS= value;
        }
    }

    public String PARTUOM{ 
    get {
    return mapWGB_Attribute.get('PARTUOM')==null?'': mapWGB_Attribute.get('PARTUOM');  
        }
    set {
            this.PARTUOM= value;
        }
    }

    public String SALESGROUP{ 
    get {
    return mapWGB_Attribute.get('SALESGROUP')==null?'': mapWGB_Attribute.get('SALESGROUP');  
        }
    set {
            this.SALESGROUP= value;
        }
    }

    public String SALESPRICEGROUP{ 
    get {
    return mapWGB_Attribute.get('SALESPRICEGROUP')==null?'': mapWGB_Attribute.get('SALESPRICEGROUP');  
        }
    set {
            this.SALESPRICEGROUP= value;
        }
    }

    public String SERIALTRACKCODE{ 
    get {
    return mapWGB_Attribute.get('SERIALTRACKCODE')==null?'': mapWGB_Attribute.get('SERIALTRACKCODE');  
            }
    set {
            this.SERIALTRACKCODE= value;
        }
    }
    
    public String ASSEMBLYWT {
    get {
            return mapWGB_Attribute.get('ASSEMBLYWT')==null?'': mapWGB_Attribute.get('ASSEMBLYWT');  
        }
    set {
            this.ASSEMBLYWT = value;
        }
    }
  
    public String ASSEMBLYWTUOM {
        get {
                return mapWGB_Attribute.get('ASSEMBLYWTUOM')==null?'': mapWGB_Attribute.get('ASSEMBLYWTUOM');  
            }
        set {
                this.ASSEMBLYWTUOM = value;
            }
      }
      
    public String ASYTYP {
        get {
                return mapWGB_Attribute.get('ASYTYP')==null?'': mapWGB_Attribute.get('ASYTYP');  
            }
        set {
                this.ASYTYP = value;
            }
      }
      
    public String CHAR_TEMPLATE {
        get {
                return mapWGB_Attribute.get('ATTRTEMPLATE')==null?'': mapWGB_Attribute.get('ATTRTEMPLATE');  
            }
        set {
                this.CHAR_TEMPLATE = value;
            }
      }
      
    public String BRAND {
        get {
            return currentWGB.Brand__c;            
        }
        set {
            this.BRAND = value;
        }
    } 
    
    public String BRANDCODE {
        get {
                return mapWGB_Attribute.get('BRANDCODE')==null?'': mapWGB_Attribute.get('BRANDCODE');  
            }
        set {
                this.BRANDCODE = value;
            }
      }
      
    public String ENG_DESCRIPTION {
        get {
                return mapWGB_Attribute.get('COMPDESCRIPTION')==null?'': mapWGB_Attribute.get('COMPDESCRIPTION');  
            }
        set {
                this.ENG_DESCRIPTION = value;
            }
      }
      
    public String ENG_INV_SERIAL_TRACKING {
        get {
                return mapWGB_Attribute.get('COMPINVSERTRK')==null?'': mapWGB_Attribute.get('COMPINVSERTRK');  
            }
        set {
                this.ENG_INV_SERIAL_TRACKING = value;
            }
      }
      
    public String ENG_LOTTRACK {
        get {
                return mapWGB_Attribute.get('COMPLOTTRACK')==null?'': mapWGB_Attribute.get('COMPLOTTRACK');  
            }
        set {
                this.ENG_LOTTRACK = value;
            }
      }
    
    public String ENG_PROVIDE {
        get {
                return mapWGB_Attribute.get('COMPPROVIDE')==null?'': mapWGB_Attribute.get('COMPPROVIDE');  
            }
        set {
                this.ENG_PROVIDE = value;
            }
      }
      
    public String ENG_RESPONSIBLE_ID {
        get {
                return mapWGB_Attribute.get('COMPRESPONID')==null?'': mapWGB_Attribute.get('COMPRESPONID');  
            }
        set {
                this.ENG_RESPONSIBLE_ID = value;
            }
      }
      
    public String ConnectionDesc {
        get {
                return mapWGB_Attribute.get('ConnectionDesc')==null?'': mapWGB_Attribute.get('ConnectionDesc');  
            }
        set {
                this.ConnectionDesc = value;
            }
      }
      
    public String CUSTOMS_STAT_NO {
        get {
                return mapWGB_Attribute.get('CUSTOMSTATNO')==null?'': mapWGB_Attribute.get('CUSTOMSTATNO');  
            }
        set {
                this.CUSTOMS_STAT_NO = value;
            }
      }
     
    public String EnclosureOpt {
        get {
                return mapWGB_Attribute.get('EnclosureOpt')==null?'': mapWGB_Attribute.get('EnclosureOpt');  
            }
        set {
                this.EnclosureOpt = value;
            }
      }
      
    public String EnclosureOptDesc {
        get {
                return mapWGB_Attribute.get('EnclosureOptDesc')==null?'': mapWGB_Attribute.get('EnclosureOptDesc');  
            }
        set {
                this.EnclosureOptDesc = value;
            }
      }
      
    public String FlameSensorOpt {
        get {
                return mapWGB_Attribute.get('FlameSensorOpt')==null?'': mapWGB_Attribute.get('FlameSensorOpt');  
            }
        set {
                this.FlameSensorOpt = value;
            }
      }
      
    public String FlameSensorOptDesc {
        get {
                return mapWGB_Attribute.get('FlameSensorOptDesc')==null?'': mapWGB_Attribute.get('FlameSensorOptDesc');  
            }
        set {
                this.FlameSensorOptDesc = value;
            }
      }  
    
    public String GTAG01 {
        get {
                return mapWGB_Attribute.get('GTAG01')==null?'': mapWGB_Attribute.get('GTAG01');  
            }
        set {
                this.GTAG01 = value;
            }
      }
      
    public String GTAGPN {
        get {
                return mapWGB_Attribute.get('GTAGPN')==null?'': mapWGB_Attribute.get('GTAGPN');  
            }
        set {
                this.GTAGPN = value;
            }
      }
      
    public String HSN_SAC_CODE {
        get {
                return mapWGB_Attribute.get('HSNSACCODE')==null?'': mapWGB_Attribute.get('HSNSACCODE');  
            }
        set {
                this.HSN_SAC_CODE = value;
            }
      }
      
    public String IgnitorOpt {
        get {
                return mapWGB_Attribute.get('IgnitorOpt')==null?'': mapWGB_Attribute.get('IgnitorOpt');  
            }
        set {
                this.IgnitorOpt = value;
            }
      }
      
    public String IgnitorOptDesc {
        get {
                return mapWGB_Attribute.get('IgnitorOptDesc')==null?'': mapWGB_Attribute.get('IgnitorOptDesc');  
            }
        set {
                this.IgnitorOptDesc = value;
            }
      }
      
    public String LOT_TRACKING {
        get {
                return mapWGB_Attribute.get('LOTTRACKCODE')==null?'': mapWGB_Attribute.get('LOTTRACKCODE');  
            }
        set {
                this.LOT_TRACKING = value;
            }
      }
      
    public String MCEVAL {
        get {
                return mapWGB_Attribute.get('MCEVAL')==null?'': mapWGB_Attribute.get('MCEVAL');  
            }
        set {
                this.MCEVAL = value;
            }
      }
      
    public String MCLSDesc {
        get {
                return mapWGB_Attribute.get('MCLSDesc')==null?'': mapWGB_Attribute.get('MCLSDesc');  
            }
        set {
                this.MCLSDesc = value;
            }
      }
    
    public String MCUSDesc {
        get {
                return mapWGB_Attribute.get('MCUSDesc')==null?'': mapWGB_Attribute.get('MCUSDesc');  
            }
        set {
                this.MCUSDesc = value;
            }
      }
      
    public String MW {
        get {
                return mapWGB_Attribute.get('MW')==null?'': mapWGB_Attribute.get('MW');  
            }
        set {
                this.MW = value;
            }
      }
    
   
      
    public String OA02 {
        get {
                return mapWGB_Attribute.get('OA02')==null?'': mapWGB_Attribute.get('OA02');  
            }
        set {
                this.OA02 = value;
            }
      }
      
    public String OA03 {
        get {
                return mapWGB_Attribute.get('OA03')==null?'': mapWGB_Attribute.get('OA03');  
            }
        set {
                this.OA03 = value;
            }
      }
      
    public String OA04 {
        get {
                return mapWGB_Attribute.get('OA04')==null?'': mapWGB_Attribute.get('OA04');  
            }
        set {
                this.OA04 = value;
            }
      }
      
    public String OA05 {
        get {
                return mapWGB_Attribute.get('OA05')==null?'': mapWGB_Attribute.get('OA05');  
            }
        set {
                this.OA05 = value;
            }
      }
      
    public String OA06 {
        get {
                return mapWGB_Attribute.get('OA06')==null?'': mapWGB_Attribute.get('OA06');  
            }
        set {
                this.OA06 = value;
            }
      }
      
    public String OB010 {
        get {
                return mapWGB_Attribute.get('OB010')==null?'': mapWGB_Attribute.get('OB010');  
            }
        set {
                this.OB010 = value;
            }
      }
    
    public String OB020 {
        get {
                return mapWGB_Attribute.get('OB020')==null?'': mapWGB_Attribute.get('OB020');  
            }
        set {
                this.OB020 = value;
            }
      }
     
    public String OB030 {
        get {
                return mapWGB_Attribute.get('OB030')==null?'': mapWGB_Attribute.get('OB030');  
            }
        set {
                this.OB030 = value;
            }
      }
    
    public String OB040 {
        get {
                return mapWGB_Attribute.get('OB040')==null?'': mapWGB_Attribute.get('OB040');  
            }
        set {
                this.OB040 = value;
            }
      }
    
    public String OB050 {
        get {
                return mapWGB_Attribute.get('OB050')==null?'': mapWGB_Attribute.get('OB050');  
            }
        set {
                this.OB050 = value;
            }
      }
    
    public String OB060 {
        get {
                return mapWGB_Attribute.get('OB060')==null?'': mapWGB_Attribute.get('OB060');  
            }
        set {
                this.OB060 = value;
            }
      }
    
    public String OB070 {
        get {
                return mapWGB_Attribute.get('OB070')==null?'': mapWGB_Attribute.get('OB070');  
            }
        set {
                this.OB070 = value;
            }
      }  
      
    public String OB080 {
        get {
                return mapWGB_Attribute.get('OB080')==null?'': mapWGB_Attribute.get('OB080');  
            }
        set {
                this.OB080 = value;
            }
      }
    
    public String OB090 {
        get {
                return mapWGB_Attribute.get('OB090')==null?'': mapWGB_Attribute.get('OB090');  
            }
        set {
                this.OB090 = value;
            }
      }
    
    public String OB100 {
        get {
                return mapWGB_Attribute.get('OB100')==null?'': mapWGB_Attribute.get('OB100');  
            }
        set {
                this.OB100 = value;
            }
      }
    
    public String OB110 {
        get {
                return mapWGB_Attribute.get('OB110')==null?'': mapWGB_Attribute.get('OB110');  
            }
        set {
                this.OB110 = value;
            }
      }
    
    public String OB120 {
        get {
                return mapWGB_Attribute.get('OB120')==null?'': mapWGB_Attribute.get('OB120');  
            }
        set {
                this.OB120 = value;
            }
      }
    
    public String OB130 {
        get {
                return mapWGB_Attribute.get('OB130')==null?'': mapWGB_Attribute.get('OB130');  
            }
        set {
                this.OB130 = value;
            }
      }  
    
    public String OB140 {
        get {
                return mapWGB_Attribute.get('OB140')==null?'': mapWGB_Attribute.get('OB140');  
            }
        set {
                this.OB140 = value;
            }
      }
    
    public String OB150 {
        get {
                return mapWGB_Attribute.get('OB150')==null?'': mapWGB_Attribute.get('OB150');  
            }
        set {
                this.OB150 = value;
            }
      }
    
    public String OB160 {
        get {
                return mapWGB_Attribute.get('OB160')==null?'': mapWGB_Attribute.get('OB160');  
            }
        set {
                this.OB160 = value;
            }
      }
    
    public String OB170 {
        get {
                return mapWGB_Attribute.get('OB170')==null?'': mapWGB_Attribute.get('OB170');  
            }
        set {
                this.OB170 = value;
            }
      }
    
    public String OB180 {
        get {
                return mapWGB_Attribute.get('OB180')==null?'': mapWGB_Attribute.get('OB180');  
            }
        set {
                this.OB180 = value;
            }
      }
    
    public String OB190 {
        get {
                return mapWGB_Attribute.get('OB190')==null?'': mapWGB_Attribute.get('OB190');  
            }
        set {
                this.OB190 = value;
            }
      }  
    
    public String OB200 {
        get {
                return mapWGB_Attribute.get('OB200')==null?'': mapWGB_Attribute.get('OB200');  
            }
        set {
                this.OB200 = value;
            }
      }
    
    public String OB210 {
        get {
                return mapWGB_Attribute.get('OB210')==null?'': mapWGB_Attribute.get('OB210');  
            }
        set {
                this.OB210 = value;
            }
      }
    
    public String OB220 {
        get {
                return mapWGB_Attribute.get('OB220')==null?'': mapWGB_Attribute.get('OB220');  
            }
        set {
                this.OB220 = value;
            }
      }
    
    public String OB230 {
        get {
                return mapWGB_Attribute.get('OB230')==null?'': mapWGB_Attribute.get('OB230');  
            }
        set {
                this.OB230 = value;
            }
      }
    
    public String OB240 {
        get {
                return mapWGB_Attribute.get('OB240')==null?'': mapWGB_Attribute.get('OB240');  
            }
        set {
                this.OB240 = value;
            }
      }
    
    public String OB250 {
        get {
                return mapWGB_Attribute.get('OB250')==null?'': mapWGB_Attribute.get('OB250');  
            }
        set {
                this.OB250 = value;
            }
      }  
    
    public String OB450 {
        get {
                return mapWGB_Attribute.get('OB450')==null?'': mapWGB_Attribute.get('OB450');  
            }
        set {
                this.OB450 = value;
            }
      }
    
    public String PART_CLASS {
        get {
                return mapWGB_Attribute.get('PARTCLASS')==null?'': mapWGB_Attribute.get('PARTCLASS');  
            }
        set {
                this.PART_CLASS = value;
            }
      }
    
    public String PART_UOM {
        get {
                return mapWGB_Attribute.get('PARTUOM')==null?'': mapWGB_Attribute.get('PARTUOM');  
            }
        set {
                this.PART_UOM = value;
            }
      }
    
    public String PLANNER {
        get {
                return mapWGB_Attribute.get('PLANNER')==null?'': mapWGB_Attribute.get('PLANNER');  
            }
        set {
                this.PLANNER = value;
            }
      }
    
    public String PROVIDE {
        get {
                return mapWGB_Attribute.get('PROVIDE')==null?'': mapWGB_Attribute.get('PROVIDE');  
            }
        set {
                this.PROVIDE = value;
            }
      }
    
    public String RESPONSIBLE_ID {
        get {
                return mapWGB_Attribute.get('RESPONSIBLE_ID')==null?'': mapWGB_Attribute.get('RESPONSIBLE_ID');  
            }
        set {
                this.RESPONSIBLE_ID = value;
            }
      }  
    
    public String CATALOG_GROUP {
        get {
                return mapWGB_Attribute.get('SALESGROUP')==null?'': mapWGB_Attribute.get('SALESGROUP');  
            }
        set {
                this.CATALOG_GROUP = value;
            }
      }
    
    public String SALES_PRICE_GROUP_ID {
        get {
                return mapWGB_Attribute.get('SALESPRICEGROUP')==null?'': mapWGB_Attribute.get('SALESPRICEGROUP');  
            }
        set {
                this.SALES_PRICE_GROUP_ID = value;
            }
      }
    
    public String INV_SERIAL_TRACKING {
        get {
                return mapWGB_Attribute.get('SERIALTRACKCODE')==null?'': mapWGB_Attribute.get('SERIALTRACKCODE');  
            }
        set {
                this.INV_SERIAL_TRACKING = value;
            }
      }
    
    public String SizeDesc {
        get {
                return mapWGB_Attribute.get('SizeDesc')==null?'': mapWGB_Attribute.get('SizeDesc');  
            }
        set {
                this.SizeDesc = value;
            }
      }
    
    public String SpecialOpt {
        get {
                return mapWGB_Attribute.get('SpecialOpt')==null?'': mapWGB_Attribute.get('SpecialOpt');  
            }
        set {
                this.SpecialOpt = value;
            }
      }
    
    public String SpecialOpt0 {
        get {
                return mapWGB_Attribute.get('SpecialOpt0')==null?'': mapWGB_Attribute.get('SpecialOpt0');  
            }
        set {
                this.SpecialOpt0 = value;
            }
      }  
    
    public String SpecialOpt2 {
        get {
                return mapWGB_Attribute.get('SpecialOpt2')==null?'': mapWGB_Attribute.get('SpecialOpt2');  
            }
        set {
                this.SpecialOpt2 = value;
            }
      }    
    
    public String SpecialOpt4 {
        get {
                return mapWGB_Attribute.get('SpecialOpt4')==null?'': mapWGB_Attribute.get('SpecialOpt4');  
            }
        set {
                this.SpecialOpt4 = value;
            }
      }    
    
    public String SpecialOpt6 {
        get {
                return mapWGB_Attribute.get('SpecialOpt6')==null?'': mapWGB_Attribute.get('SpecialOpt6');  
            }
        set {
                this.SpecialOpt6 = value;
            }
      }    
    
    public String SpecialOpt8 {
        get {
                return mapWGB_Attribute.get('SpecialOpt8')==null?'': mapWGB_Attribute.get('SpecialOpt8');  
            }
        set {
                this.SpecialOpt8 = value;
            }
      }    
    
    public String SpecialOptDesc {
        get {
                return mapWGB_Attribute.get('SpecialOptDesc')==null?'': mapWGB_Attribute.get('SpecialOptDesc');  
            }
        set {
                this.SpecialOptDesc = value;
            }
      }  

    public String PRDLIN{
        get {
                return mapWGB_Attribute.get('PRDLIN')==null?'': mapWGB_Attribute.get('PRDLIN');  
            }
        set {
                this.PRDLIN = value;
            }
      }      
      
    
    public string GAGES{
        get {
            /*
              if(PilotSupplyPressConverted >27.7073)
                 return 'psig';
              else
                 return 'in.water';*/
            return currentWGB.Gage__c;
        }
        set{
            this.GAGES=value;
        }       
    }
    
    public string REGULATOR{
        get {
            /*
              if(PilotSupplyPressConverted >138.536)
                 return 'Y';
              else
                 return 'N'; */
            return currentWGB.Pilot_Gas_Regulator__c;
        }
        set{
            this.REGULATOR=value;
        }       
    }
    
    //This method is Not Completed 
    public string OA01{
        get{
            string strOA01='';
            boolean EnnOverridecheckbox=currentWGB.Quote_Description_Engineer_Override__c;
            if(EnnOverridecheckbox==true)
                return  strOA01='Special Model:' + GMODEL ;
            else
                return strOA01='Model:' + GMODEL;
           // return '';
        }
        set{
            this.OA01=value;
        }
    }
    
     public string OA {
        get;
         /*{
            String OA02 = '';
            String OA03 = '';
            String OA04 = '';
            String OA05 = '';
            String OA06 = '';            

            if(currentWGB.OA02__c != null)
            {
                OA02 = currentWGB.OA02__c;
            }
            if(currentWGB.OA03__c != null)
            {
                OA03 = currentWGB.OA04__c;
            }
            if(currentWGB.OA04__c != null)
            {
                OA04 = currentWGB.OA02__c;
            }
            if(currentWGB.OA05__c != null)
            {
                OA05 = currentWGB.OA04__c;
            }
            if(currentWGB.OA06__c != null)
            {
                OA06 = currentWGB.OA02__c;
            }
            return PTC + OA02 + OA03 + OA04 + OA05 +OA06;
        }*/
        set {
            this.OA = value;
            
        }
    }
    
    public string OB {
        get; 
        /*{
            String OB010 = '', OB020 = '', OB030 = '', OB040 = '', OB050 = '', OB060 = '',OB070 = '', OB080 = '', OB090 = '', OB100 = '', 
            OB110 = '',OB120 = '',OB130 = '', OB140 = '', OB150 = '', OB160 = '', OB170 = '', OB180 = '',OB190 = '', OB200 = '', 
            OB210 = '', OB220 = '', OB230 = '',OB240 = '',OB250 = '', OB450 = '';
            
            if(currentWGB.OB010__c != null)
            {
                OB010 = currentWGB.OB010__c;
            }
            if(currentWGB.OB020__c != null)
            {
                OB020 = currentWGB.OB020__c;
            }
            if(currentWGB.OB030__c != null)
            {
                OB030 = currentWGB.OB030__c;
            }
            if(currentWGB.OB040__c != null)
            {
                OB040 = currentWGB.OB040__c;
            }
            if(currentWGB.OB050__c != null)
            {
                OB050 = currentWGB.OB050__c;
            }
            if(currentWGB.OB060__c != null)
            {
                OB060 = currentWGB.OB060__c;
            }
            if(currentWGB.OB070__c != null)
            {
                OB070 = currentWGB.OB070__c;
            }
            if(currentWGB.OB080__c != null)
            {
                OB080 = currentWGB.OB080__c;
            }
            if(currentWGB.OB090__c != null)
            {
                OB090 = currentWGB.OB090__c;
            }
            if(currentWGB.OB100__c != null)
            {
                OB100 = currentWGB.OB100__c;
            }
            if(currentWGB.OB110__c != null)
            {
                OB110 = currentWGB.OB110__c;
            }
            if(currentWGB.OB120__c != null)
            {
                OB120 = currentWGB.OB120__c;
            }
            if(currentWGB.OB130__c != null)
            {
                OB130 = currentWGB.OB130__c;
            }
            if(currentWGB.OB140__c != null)
            {
                OB140 = currentWGB.OB140__c;
            }
            if(currentWGB.OB150__c != null)
            {
                OB150 = currentWGB.OB150__c;
            }
            if(currentWGB.OB160__c != null)
            {
                OB160 = currentWGB.OB160__c;
            }
            if(currentWGB.OB170__c != null)
            {
                OB170 = currentWGB.OB170__c;
            }
            if(currentWGB.OB180__c != null)
            {
                OB180 = currentWGB.OB180__c;
            }
            if(currentWGB.OB190__c != null)
            {
                OB190 = currentWGB.OB190__c;
            }
            if(currentWGB.OB200__c != null)
            {
                OB200 = currentWGB.OB200__c;
            }
            if(currentWGB.OB210__c != null)
            {
                OB210 = currentWGB.OB210__c;
            }
            if(currentWGB.OB220__c != null)
            {
                OB220 = currentWGB.OB220__c;
            }
            if(currentWGB.OB230__c != null)
            {
                OB230 = currentWGB.OB230__c;
            }
            if(currentWGB.OB240__c != null)
            {
                OB240 = currentWGB.OB240__c;
            }           
            if(currentWGB.OB250__c != null)
            {
                OB250 = currentWGB.OB250__c;
            }           
            if(currentWGB.OB450__c != null)
            {
                OB450 = currentWGB.OB450__c;
            }
            return OB010 + OB020 + OB030 + OB040 + OB050 + OB060 + OB070 + OB080 + OB090 + OB100 + OB110 + OB120 + OB130 + OB140 + 
            OB150 + OB160 + OB170 + OB180 + OB190 + OB200 + OB210 + OB220 + OB230 + OB240 + OB250 + OB450;
        }*/
        set {
            //currentWGB.Ratio_of_Specific_Heats__c = value;
            this.OB = value;
            
        }
    } 
    
    public string GMODEL{
        get{
            return PTC + '-' + SZC + '-' + MCEVAL + '-' + PEDCON + '' + IgnitorOpt + '' + FlameSensorOpt + '' + EnclosureOpt + '' + SpecialOpt;
        }
        set{
            this.GMODEL=value;
        }
    }

    
    //Waste Gas Burner Output Methods
    
    public string GASGROUP{
        get{
            return currentWGB.Pilot_Gas__c;
        }
        set{
            this.GASGROUP=value;
        }
    }
  
     public string GASUOM{
        get{
            return currentWGB.Pressure_Setting_Units__c;
        }
        set{
            this.GASUOM=value;
        }
    }
    
    public decimal RTPRS1{
        get {
             if(currentWGB.Pilot_Supply_Pressure__c!=null)  
                return currentWGB.Pilot_Supply_Pressure__c;
            else
                return 0.0;
        }
        set{
            this.RTPRS1=value;
        }        
    }
    
    public string RTPRSU{
        get {
            return currentWGB.Pressure_Setting_Units__c;
        }
        set{
            this.RTPRSU=value;
        }       
    }
    
    public decimal PilotSupplyPressConverted{
        get {
            decimal conval=0.0;
            if(currentWGB.Converted_Pilot_Supply_Pressure__c!=null)
                conval=currentWGB.Converted_Pilot_Supply_Pressure__c;
            else
                conval=0.0;
            result res=new result();
            res=unitConversions.SignificantDigitsNormal(conval,3,-99);
            decimal convertedpressure=res.dblRetValue;
            if(convertedpressure!=null)
                return convertedpressure;
            else
                return 0.0;            
        }
        set{
            this.PilotSupplyPressConverted=value;
        }        
    }
    
    public decimal REQDFLOW{
        get{
            if(currentWGB.Flow_Rate__c!=null)
                return currentWGB.Flow_Rate__c;
            else
                return 0.0;
        }
        set{
            this.REQDFLOW=value;
        }
    }
    
    public string REQDFLOWUOM{
        get{
            return currentWGB.Flow_Rate_Units__c;
        }
        set{
            this.REQDFLOWUOM=value;
        }
    }
    
    public decimal CONVERTEDFLOW{
        get{
            if(currentWGB.Converted_Flow_Rate__c!=null)
                return currentWGB.Converted_Flow_Rate__c;
            else
                return 0.0;
        }
        set{
            this.CONVERTEDFLOW=value;
        }
    }
    
    public string ULCERT{
        get{
            return currentWGB.Certification__c;
        }
        set{
            this.ULCERT=value;
        }
    }
    
    public string PTC{
        get{
            return currentWGB.Select_Model__c;
        }
        set{
            this.PTC=value;
        }
    }
    
    public string SZC{
        get{
            return currentWGB.Size__c;
        }
        set{
            this.SZC=value;
        }
    }
    
    public decimal QTY{
        get{
                return currentWGB.Quantity__c;
        }
        set{
            this.QTY=value;
        }
    }
    
    public string MCUS{
        get{
            return currentWGB.Upper_Shroud_Stack_Matl__c;
          //  string strMCUS=[select MCUS from ]
        }
        set{
            this.MCUS=value;
        }
    }
    
    public string MCLS{
        get{
            return currentWGB.Lower_Stack_Pedestal_Matl__c;
        }
        set{
            this.MCLS=value;
        }
    }

    /*
    public decimal MCUS{
        get{            
            decimal decMCUS=0.0;
            if(WCG_PartParameter!=null)
                decMCUS=WCG_PartParameter.MCUS__c;
            if(decMCUS!=null)
                return decMCUS;
            else
                return 0.0;
        }
        set{
            this.MCUS=value;
        }
    }
    
    public decimal MCLS{
        get{
            decimal decMCLS=0.0;
            if(WCG_PartParameter!=null)
                decMCLS=WCG_PartParameter.MCLS__c;
            if(decMCLS!=null)
                return decMCLS;
            else
                return 0.0;
        }
        set{
            this.MCLS=value;
        }
    }
   */
    public string PEDCON{
        get{
            return currentWGB.Pedestal_Connection__c;
        }
        set{
            this.PEDCON=value;
        }
    }
    
    public string IGNCTL{
        get{
            return currentWGB.Ignitor_Control__c;
        }
        set{
            this.IGNCTL=value;
        }
    }
    
    public string FLMSNS{
        get{
            return currentWGB.Flame_Sensor__c;
        }
        set{
            this.FLMSNS=value;
        }
    }
    
    public string TCMATERIAL{
        get{
            return currentWGB.Thermocouple_Material__c;
        }
        set{
            this.TCMATERIAL=value;
        }
    }
    
    public string ENCTYP{
        get{
            return currentWGB.Enclosure_Type__c;
        }
        set{
            this.ENCTYP=value;
        }
    }
    
        public string CPALRM{
        get{
            return currentWGB.Control_Panel_Alarm__c;
        }
        set{
            this.CPALRM=value;
        }
    }
    
    public string CPHEAT{
        get{
             return currentWGB.Control_Panel_Heater__c;
        }
        set{
            this.CPHEAT=value;
        }
    } 
    
    public string STNDCT{
        get{
            return currentWGB.Stand_Control_Material__c;
        }
        set{
            this.STNDCT=value;
        }
    }
    
    public string SUNCTL{
        get{
            return currentWGB.Sunshield_Control__c;
        }
        set{
            this.SUNCTL=value;
        }
    }
    
    public string SPDT{
        get{
            return currentWGB.Step_Down_Transformer__c;
        }
        set{
            this.SPDT=value;
        }
    }
    
    public string BPS{
        get{
            return currentWGB.Back_up_Power_Supply__c;
        }
        set{
            this.BPS=value;
        }
    }
    
      
    public string Schedule {
        get {
            return currentWGB.Schedule__c;
        }
        set {
            currentWGB.Schedule__c = value;
            this.Schedule = value;
        }
    }
    
    // ------------OUTPUT GETTER SETTER Methods Over here-------------------------------------
    
    public list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPM()
    {
        Boolean isFlag = false;
        list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = new list<Global_Site_Part_Parameters_ISPM__c>();
        String SOQL = 'Select InventorySite__c,InventoryPartType__c,InventoryPartTemplate_ID__c,SalesSite__c,Sourcing_Option__c,PurchaseSite__c,PurchasePartTemplate_ID__c,MfgSite__c';
        SOQL += ' From Global_Site_Part_Parameters_ISPM__c ';
        if(currentWGB.Lead_Time_Site_10__c != null)
        {
            isFlag = true;
            SOQL += ' where (Site__c= \'10\' and LeadTimeLL__c <='+currentWGB.Lead_Time_Site_10__c+' and LeadTimeUL__c >='+currentWGB.Lead_Time_Site_10__c+' and SERIALTRACKCODE__c =\''+INV_SERIAL_TRACKING+'\')';
        }
        if(currentWGB.Lead_Time_Site_20__c != null)
        {
            if(isFlag == true)
            {
                SOQL += ' or ';
            }
            else
            {
                SOQL += ' where ';
                isFlag =true;
            }
            SOQL += ' (Site__c= \'20\' and LeadTimeLL__c <='+currentWGB.Lead_Time_Site_20__c+' and LeadTimeUL__c >='+currentWGB.Lead_Time_Site_20__c+' and SERIALTRACKCODE__c =\''+INV_SERIAL_TRACKING+'\')';
        }
        if(currentWGB.Lead_Time_Site_30__c != null)
        {
            if(isFlag == true)
            {
                SOQL += ' or ';
            }
            else
            {
                SOQL += ' where ';
                isFlag =true;
            }
            SOQL += ' (Site__c = \'30\' and LeadTimeLL__c <='+currentWGB.Lead_Time_Site_30__c+' and LeadTimeUL__c >='+currentWGB.Lead_Time_Site_30__c+' and SERIALTRACKCODE__c =\''+INV_SERIAL_TRACKING+'\')';
        }
        if(currentWGB.Lead_Time_Site_40__c != null)
        {
            if(isFlag == true)
            {
                SOQL += ' or ';
            }
            else
            {
                SOQL += ' where ';
                isFlag =true;
            }
            SOQL += ' (Site__c = \'40\' and LeadTimeLL__c <='+currentWGB.Lead_Time_Site_40__c+' and LeadTimeUL__c >='+currentWGB.Lead_Time_Site_40__c+' and SERIALTRACKCODE__c =\''+INV_SERIAL_TRACKING+'\')';
        }
        system.debug('The Query is: '+SOQL);
        GlobalSiteParametersISPMList = database.query(SOQL);
        system.debug('The ISPM list is:'+GlobalSiteParametersISPMList);
        
        return GlobalSiteParametersISPMList; 
    }
    
    
    public List<Global_Site_Part_Parameters_PPS__c> getGlobalSitePPS()
    {
        Boolean isFlag = false;
        list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = new list<Global_Site_Part_Parameters_ISPM__c>();
        String SOQL = 'Select InventorySite__c,InventoryPartType__c,InventoryPartTemplate_ID__c,SalesSite__c,Sourcing_Option__c,PurchaseSite__c,PurchasePartTemplate_ID__c,MfgSite__c';
        SOQL += ' From Global_Site_Part_Parameters_ISPM__c ';
        if(currentWGB.Lead_Time_Site_10__c != null)
        {
            isFlag = true;
            SOQL += ' where (Site__c = \'10\' and LeadTimeLL__c <='+currentWGB.Lead_Time_Site_10__c+' and LeadTimeUL__c >='+currentWGB.Lead_Time_Site_10__c+' and SERIALTRACKCODE__c =\''+INV_SERIAL_TRACKING+'\')';
        }
        if(currentWGB.Lead_Time_Site_20__c != null)
        {
            if(isFlag == true)
            {
                SOQL += ' or ';
            }
            else
            {
                SOQL += ' where ';
                isFlag =true;
            }
            SOQL += ' (Site__c = \'20\' and LeadTimeLL__c <='+currentWGB.Lead_Time_Site_20__c+' and LeadTimeUL__c >='+currentWGB.Lead_Time_Site_20__c+' and SERIALTRACKCODE__c =\''+INV_SERIAL_TRACKING+'\')';
        }
        if(currentWGB.Lead_Time_Site_30__c != null)
        {
            if(isFlag == true)
            {
                SOQL += ' or ';
            }
            else
            {
                SOQL += ' where ';
                isFlag =true;
            }
            SOQL += ' (Site__c = \'30\' and LeadTimeLL__c <='+currentWGB.Lead_Time_Site_30__c+' and LeadTimeUL__c >='+currentWGB.Lead_Time_Site_30__c+' and SERIALTRACKCODE__c =\''+INV_SERIAL_TRACKING+'\')';
        }
        if(currentWGB.Lead_Time_Site_40__c != null)
        {
            if(isFlag == true)
            {
                SOQL += ' or ';
            }
            else
            {
                SOQL += ' where ';
                isFlag =true;
            }
            SOQL += ' (Site__c = \'40\' and LeadTimeLL__c <='+currentWGB.Lead_Time_Site_40__c+' and LeadTimeUL__c >='+currentWGB.Lead_Time_Site_40__c+' and SERIALTRACKCODE__c =\''+INV_SERIAL_TRACKING+'\')';
        }
        GlobalSiteParametersISPMList = database.query(SOQL);
        Set<String> purchasedInventorySites = new Set<String>();
        if(GlobalSiteParametersISPMList.size() > 0)
        {
            for(Global_Site_Part_Parameters_ISPM__c globalISPM : GlobalSiteParametersISPMList)
            {
            //    System.debug('***** inventory type = '+globalISPM.InventoryPartType__c);
                if(globalISPM.InventoryPartType__c == 'Purchased')
                {
                    purchasedInventorySites.add(globalISPM.InventorySite__c);
                }
            }
        }
        List<Global_Site_Part_Parameters_PPS__c> globalSitePPSList = new List<Global_Site_Part_Parameters_PPS__c>();
        if(purchasedInventorySites.size() > 0)
        {
          //  SYstem.debug('Inside1------');
            for(Global_Site_Part_Parameters_PPS__c ppsRecord: [SELECT Id,Name,Site__c,VendorSite__c,VendorLTLL__c,VendorLTUL__c,Primary_Vendor__c,PPS_VendoNo__c,PurchaseSite__c from Global_Site_Part_Parameters_PPS__c WHERE Site__c IN:purchasedInventorySites order by Site__c])
            {
               // SYstem.debug('Inside2------');
                // 10 => 20 & 30
                if(ppsRecord.Site__c == '10') 
                {
                    SYstem.debug('Inside3------');
                    System.debug('VendorSite__c-----20'+ppsRecord.VendorSite__c);
                    System.debug('VendorLTLL__c-----0'+ppsRecord.VendorLTLL__c);
                    System.debug('VendorLTUL__c-----5000'+ppsRecord.VendorLTUL__c);
                    System.debug('Lead_Time_Site_20__c-----null'+currentWGB.Lead_Time_Site_20__c);
                    System.debug('Lead_Time_Site_30__c-----null'+currentWGB.Lead_Time_Site_30__c);
                    System.debug('Lead_Time_Site_40__c-----null'+currentWGB.Lead_Time_Site_40__c);
                    if(ppsRecord.VendorSite__c == '20' && 
                       ppsRecord.VendorLTLL__c <= currentWGB.Lead_Time_Site_20__c && 
                       ppsRecord.VendorLTUL__c > currentWGB.Lead_Time_Site_20__c)
                    {
                      //  SYstem.debug('Inside4------');
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '30' && 
                            ppsRecord.VendorLTLL__c <= currentWGB.Lead_Time_Site_30__c && 
                            ppsRecord.VendorLTUL__c > currentWGB.Lead_Time_Site_30__c)
                    {
                     //   SYstem.debug('Inside5------');
                        globalSitePPSList.add(ppsRecord);
                    }      
                }
                // 20 => 10 & 30
                if(ppsRecord.Site__c == '20')
                {
                    if(ppsRecord.VendorSite__c == '10' && 
                       ppsRecord.VendorLTLL__c <= currentWGB.Lead_Time_Site_10__c && 
                       ppsRecord.VendorLTUL__c > currentWGB.Lead_Time_Site_10__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '30' && 
                            ppsRecord.VendorLTLL__c <= currentWGB.Lead_Time_Site_30__c && 
                            ppsRecord.VendorLTUL__c > currentWGB.Lead_Time_Site_30__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }       
                }
                // 30 => 10 & 20
                if(ppsRecord.Site__c == '30')
                {
                    if(ppsRecord.VendorSite__c == '10' && 
                       ppsRecord.VendorLTLL__c <= currentWGB.Lead_Time_Site_10__c && 
                       ppsRecord.VendorLTUL__c > currentWGB.Lead_Time_Site_10__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '20' && 
                            ppsRecord.VendorLTLL__c <= currentWGB.Lead_Time_Site_20__c && 
                            ppsRecord.VendorLTUL__c > currentWGB.Lead_Time_Site_20__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }       
                }
                
                // 40 => 10, 20 & 30
                if(ppsRecord.Site__c == '40')
                {
                    if(ppsRecord.VendorSite__c == '10' && 
                       ppsRecord.VendorLTLL__c <= currentWGB.Lead_Time_Site_10__c && 
                       ppsRecord.VendorLTUL__c > currentWGB.Lead_Time_Site_10__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '20' && 
                            ppsRecord.VendorLTLL__c <= currentWGB.Lead_Time_Site_20__c && 
                            ppsRecord.VendorLTUL__c > currentWGB.Lead_Time_Site_20__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }  
                    else if(ppsRecord.VendorSite__c == '30' && 
                            ppsRecord.VendorLTLL__c <= currentWGB.Lead_Time_Site_30__c && 
                            ppsRecord.VendorLTUL__c > currentWGB.Lead_Time_Site_30__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }  
                }
            }
        }
      //  System.debug('***** globalSitePPSList = '+globalSitePPSList);
        return globalSitePPSList;
    }
    
    
     public string DocumentID {
        get{
            if(currentWGB.Document_IDs__c != null)
            {
                return currentWGB.Document_IDs__c;
            }
            else{
                return '';
            }
        }
        set{
            this.DocumentID=value;
        }
    }
    
    public String PARTMANAGEDIN {
        get {
            //System.debug('CheckBox1' + currentWGB.Quote_Description_Engineer_Override__c);
            if(currentWGB.Quote_Description_Engineer_Override__c == false)
            {
              //  System.debug('CheckBox2' + currentWGB.Quote_Description_Engineer_Override__c);
                return 'Salesforce';
            }
            else 
            {
                //System.debug('CheckBox3' + currentWGB.Quote_Description_Engineer_Override__c);
                return 'IFS';
            }            
        }
        set {
            this.PARTMANAGEDIN = value;
        }
    }

    //Method to get PARTNUMBER value
    public result getPartNumber(){
        result res=new result();
        string partno=PARTNUMBER;
        if(partno!=null) {
            res.bResult=true;
            res.strRetValue=PARTNUMBER;
        }
        return res;
    }
    
    public string PARTNUMBER {
        get 
        {
            if(currentWGB.Part_Number__c != null)
                return currentWGB.Part_Number__c;
            else
                return '';
        }
        set 
        {
            this.PARTNUMBER = value;
        }
    }
    
        public string PARTREV {
        get 
        {
            if(currentWGB.PARTREV__c != null)
                return currentWGB.PARTREV__c;
            else
                return '1';
        }
        set 
        {
            this.PARTREV = value;
        }
    }
    public string NOTE {
        get {
            if(currentWGB.Engineering_Notes__c != null)
                return currentWGB.Engineering_Notes__c;
            else
                return '';  
        }
        set {
            this.NOTE = value;
        }
    }
    
    public string DESCRIPTION{
        get{
            if(currentWGB.Quote_Description_Engineer_Override__c == true)
            {
                return 'Special'+' '+BRANDCODE+' '+'Model:'+' '+PTC+' '+SZC+' '+'with'+' '+MCUSDesc+' '+'Upper Shroud'+' '+MCLSDesc+' '+'Lower Stack'+' '
                +'with'+' '+ConnectionDesc+' '+'Connection'+' '+IgnitorOptDesc+' '+FlameSensorOptDesc+' '+'and'+' '+EnclosureOptDesc;
            }
            else
            {
                return BRANDCODE +' '+'Model:'+' '+PTC+' '+SZC+' '+'with'+' '+MCUSDesc+' '+'Upper Shroud'+' '+MCLSDesc+' '+'Lower Stack'+' '
                +'with'+' '+ConnectionDesc+' '+'Connection'+' '+IgnitorOptDesc+' '+FlameSensorOptDesc+' '+'and'+' '+EnclosureOptDesc;
            }            
        }
        set{
            this.DESCRIPTION=value;
        }
    }
  
    
    //Belowe are XML methods for WGB..............................................
    
    
    //DESCRIPTION Method is incomplete
    
    public result getEngineeringParts()     {
        result resultEngineer=new result();
        Dom.Document doc = new Dom.Document();
        
        //string PARTNUMBER1=getPartNum();
        //System.debug('PArtNumber'+PARTNUMBER);
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'ENG_PART_REC', null); 
        w.writeStartElement(null, 'ENG_PART', null); 
        w.writeStartElement(null, 'ENG_PART_NO', null);  
        w.writeCharacters(PARTNUMBER.toUpperCase());
        w.writeEndElement();
        w.writeStartElement(null, 'ENG_PART_REV', null);  
        w.writeCharacters(PARTREV);
        w.writeEndElement();
        w.writeStartElement(null, 'DESCRIPTION', null);
        //Service Ticket #200752   
        w.writeCharacters(String.isNotBlank(DESCRIPTION)?DESCRIPTION.length()<200?DESCRIPTION:DESCRIPTION.substring(0,200):'');
        w.writeEndElement();
        w.writeStartElement(null, 'LOT_TRACKING_CODE', null);  
        w.writeCharacters(LOT_TRACKING);
        w.writeEndElement();
        w.writeStartElement(null, 'PROVIDE', null);  
        w.writeCharacters(PROVIDE);
        w.writeEndElement();
        w.writeStartElement(null, 'INV_SERIAL_TRACKING', null);  
        w.writeCharacters(INV_SERIAL_TRACKING);
        w.writeEndElement();
        w.writeStartElement(null, 'PART_CLASS', null);  
        w.writeCharacters(PART_CLASS);
        w.writeEndElement();
        w.writeStartElement(null, 'RESPONSIBLE_ID', null);  
        w.writeCharacters(RESPONSIBLE_ID);
        w.writeEndElement();
        w.writeStartElement(null, 'NOTE', null);  
        w.writeCharacters(NOTE);
        w.writeEndElement();
        w.writeStartElement(null, 'PARTMANAGEDIN', null);  
        w.writeCharacters(PARTMANAGEDIN);
        w.writeEndElement();
        //Geting Engineering PArt Structure
        Result EngPartStrucResult=getEngPartStructureXML();
        String xmlEngPartResult=EngPartStrucResult.xmlStringResult;
        Dom.Document doc2 = new Dom.Document();
        doc2.load(xmlEngPartResult);
        w.writeStartElement(null,'ENG_PART_STRUCTURE_LIST' , null); 
        for (Dom.XmlNode child : doc2.getRootElement().getChildren()) {
            Dom.XmlNode chl=Child;
            w.writeStartElement(null,Child.getName() , null);
            for (Dom.XmlNode child1 : child.getChildren()) {
                //system.debug('bcjkadsfhjksr'+chl);
                w.writeStartElement(null,child1.getName(), null);
                w.writeCharacters(child1.getText());
                w.writeEndElement();
            }
            w.writeEndElement();
        }
        w.writeEndElement();
        Result DocResult=getProdDoc();
        String xmlDocResult=DocResult.xmlStringResult;
        System.debug('xmlDocResult'+xmlDocResult);
        Dom.Document doc1 = new Dom.Document();
        doc1.load(xmlDocResult);
        w.writeStartElement(null,'DOCUMENT_LIST' , null); 
        for (Dom.XmlNode child : doc1.getRootElement().getChildren()) {
            Dom.XmlNode chl=Child;
            w.writeStartElement(null,Child.getName() , null);
            for (Dom.XmlNode child1 : child.getChildren()) {
                //system.debug('bcjkadsfhjksr'+chl);
                w.writeStartElement(null,child1.getName(), null);
                w.writeCharacters(child1.getText());
                w.writeEndElement();
            }
            w.writeEndElement();
           // w.writeEndElement();
        }
        w.writeEndElement();
        Result CharResult=getEngPartCharacterXML();
        String xmlCharResult=CharResult.xmlStringResult;
        Dom.Document doc3 = new Dom.Document();
        doc3.load(xmlCharResult);
        w.writeStartElement(null,'ENG_PART_CHAR_LIST' , null); 
        for (Dom.XmlNode child : doc3.getRootElement().getChildren()) {
            Dom.XmlNode chl=Child;
            w.writeStartElement(null,Child.getName() , null);
            for (Dom.XmlNode child1 : child.getChildren()) {
                //system.debug('bcjkadsfhjksr'+chl);
                w.writeStartElement(null,child1.getName(), null);
                w.writeCharacters(child1.getText());
                w.writeEndElement();
            }
            w.writeEndElement();
            
        }
        w.writeEndElement();
        w.writeEndElement();
        w.writeEndDocument();
        string xmlOutput = w.getXmlString();
        //system.debug('XML is xmlOutput  '+xmlOutput ); 
        w.close();
        string xmldata = doc.toXmlString();
        //system.debug('XML is '+xmldata);
        resultEngineer.xmlStringResult=xmlOutput;
        return resultEngineer;
    } 
  
    public Result getEngPartStructureXML( )
    {
        result BGREngPartStructureResult=new result();
        result EngstrucResult=getStructure();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'ENG_PART_STRUCTURE_LIST', null); 
        string xmlOutput1 = w.getXmlString();
        Result doc1=getProdDoc();        
        string xmlOutput2=xmlOutput1+doc1.xmlStringResult;
        //System.debug('sub result'+xmlOutput2);
        if(EngstrucResult.bResult)
        {
            for(sObject sobj:EngstrucResult.objResultList) {
                w.writeStartElement(null, 'ENG_PART_STRUCTURE', null);
                w.writeStartElement(null, 'PART_NO', null);  
              //  w.writeCharacters(((STRING) sobj.get('Component__c')).toUpperCase());
                w.writeCharacters(((STRING) sobj.get('Part_Number__c')).toUpperCase());
                w.writeEndElement();
                w.writeStartElement(null, 'DESCRIPTION', null);  
                w.writeCharacters(ENG_DESCRIPTION);
                w.writeEndElement();
                w.writeStartElement(null, 'LOT_TRACKING_CODE', null);  
                w.writeCharacters(ENG_LOTTRACK);
                w.writeEndElement();
                w.writeStartElement(null, 'PROVIDE', null);  
                w.writeCharacters(ENG_PROVIDE);
                w.writeEndElement();
                w.writeStartElement(null, 'INV_SERIAL_TRACKING', null);  
                w.writeCharacters(ENG_INV_SERIAL_TRACKING);
                w.writeEndElement();
                w.writeStartElement(null, 'RESPONSIBLE_ID', null);  
                w.writeCharacters(ENG_RESPONSIBLE_ID);
                w.writeEndElement();
                w.writeStartElement(null, 'NOTE', null);  
                w.writeCharacters(NOTE);
                w.writeEndElement();
                w.writeStartElement(null, 'DRAW_POS_NO', null);  
                w.writeCharacters((STRING) sobj.get('Line_Item_No__c'));
                w.writeEndElement();
                w.writeStartElement(null, 'QTY_PER_ASSEMBLY', null);  
                w.writeCharacters((STRING) sobj.get('Qty_per_Assembly__c'));
                w.writeEndElement();
                w.writeStartElement(null, 'SORT_CODE', null);  
                w.writeCharacters((STRING) sobj.get('Line_Item_No__c'));
                w.writeEndElement();
                w.writeEndElement(); 
            }
        }        
        w.writeEndElement();
        w.writeEndDocument(); 
        string xmlOutput = w.getXmlString();
        //system.debug('XML is xmlOutput  '+xmlOutput );
        w.close();
        string xmldata = doc.toXmlString();
        //system.debug('XML is '+xmldata);
        BGREngPartStructureResult.xmlStringResult=xmlOutput;
        return BGREngPartStructureResult;   
    }
    
    
    //Document__c field is not there in Document Details file
    public Result getProdDoc( )
    {
        result BGRDocResult=new result();
        //getDocument instead of getProdDoc() method
        result DocResult=getDocument();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        // w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'DOCUMENT_LIST', null); 
        
        if(DocResult.bResult)
        {
            for(sObject sobj:DocResult.objResultList) {
                //Added below if condition for the redmine 34657
                if(sobj.get('Document_ID__c') != null && ((STRING) sobj.get('Document_ID__c')) !=''){
                    w.writeStartElement(null, 'DOCUMENT', null); 
                    w.writeStartElement(null, 'DOC_NO', null);  
                    //Document_ID__c    
                    w.writeCharacters((STRING) sobj.get('Document_ID__c'));
                    w.writeEndElement();
                    w.writeStartElement(null, 'DOC_REV', null);  
                    //w.writeCharacters(' ');
                    w.writeEndElement();
                    w.writeStartElement(null, 'DOC_TITLE', null);  
                    //w.writeCharacters(' ');
                    w.writeEndElement();
                    w.writeStartElement(null, 'DOC_CLASS', null);  
                    //w.writeCharacters(' ');
                    w.writeEndElement();
                    w.writeStartElement(null, 'DOC_SHEET', null);  
                    //w.writeCharacters(' ');
                    w.writeEndElement();
                    w.writeStartElement(null, 'FILE_TYPE', null);  
                    //w.writeCharacters(' ');
                    w.writeEndElement();
                    w.writeStartElement(null, 'FILE_NAME', null);  
                  //  w.writeCharacters((STRING) sobj.get('Document_ID__c'));
                    w.writeEndElement();
                    w.writeStartElement(null, 'FILE_DATA', null);  
                    //w.writeCharacters(' ');
                    w.writeEndElement();
                    w.writeStartElement(null, 'DOC_RESP_SIGN', null);  
                    //w.writeCharacters(' ');
                    w.writeEndElement();
                   // w.writeStartElement(null, 'DOCUMENT_ID', null);  
                   // w.writeCharacters(DocumentID);
                   // w.writeEndElement(); 
                    w.writeEndElement(); 
                }
            }
        }
        w.writeEndElement();
        // w.writeEndDocument(); 
        string xmlOutput = w.getXmlString();
        //system.debug('XML is xmlOutput  '+xmlOutput );
        w.close();
        string xmldata = doc.toXmlString();
        //system.debug('XML is '+xmldata);
        BGRDocResult.xmlStringResult=xmlOutput;
        return BGRDocResult;        
    }
    
    public Result getEngPartCharacterXML( )
    {
        result BGRCharResult=new result();
        // result CharResult=getEngPartCharacterXML();
        IFS_character_codes__c[] IFS_Attr=[select Element__c,Attribute_Code__c from IFS_character_codes__c where Interface_to_IFS_Attributes__c=true and Product__c='WGB' order by Attribute_Code__c];
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartElement(null, 'ENG_PART_CHAR_LIST', null);
        for(IFS_character_codes__c ifsAtt:IFS_Attr) {
            String strInfo=' ';
            String strVal=' ';
            String strCode;
            if (mapWGBAttr.containsKey(ifsAtt.Attribute_Code__c)) 
            {
                if (ifsAtt.Element__c=='Info')
                {
                    strInfo=mapWGBAttr.get(ifsAtt.Attribute_Code__c);
                }
                else
                {
                    strVal=mapWGBAttr.get(ifsAtt.Attribute_Code__c);
                }
                strCode=ifsAtt.Attribute_Code__c;
                w.writeStartElement(null, 'ENG_PART_CHAR', null);
                w.writeStartElement(null, 'CHAR_TEMPLATE', null);  
                w.writeCharacters(CHAR_TEMPLATE);
                w.writeEndElement();
                w.writeStartElement(null, 'CHARACTERISTIC_CODE', null);  
                w.writeCharacters(strCode);
                system.debug('Char code is:'+strCode);
                w.writeEndElement();
                if(strVal.length() > 20 || (string.isNotBlank(strInfo))){
                    w.writeStartElement(null, 'VALUE', null);
                    w.writeCharacters('See Info');
                    w.writeEndElement();
                }else{
                    w.writeStartElement(null, 'VALUE', null);
                    w.writeCharacters(strVal);
                    w.writeEndElement();
                }
                system.debug('Value is:'+strVal);
                w.writeStartElement(null, 'INFO', null);
                if(strVal.length() > 20)
                {
                     w.writeCharacters(strVal);
                }
                else
                {
                    if(strInfo != null && string.isNotBlank(strInfo))
                    {
                        w.writeCharacters(strInfo);
                    }
                    else
                    {
                        w.writeCharacters(' ');
                    }
                }
                w.writeEndElement();    
                w.writeEndElement();
            }
        }
        // if(CharResult.bResult)
        //{
        //for(sObject sobj:CharResult.objResultList) 
        //{
        
        // }
        //  }
        w.writeEndElement();
        //w.writeEndDocument(); 
        string xmlOutput = w.getXmlString();
        system.debug('XML is xmlOutput  '+xmlOutput );
        w.close();
        string xmldata = doc.toXmlString();
        system.debug('XML is '+xmldata);
        BGRCharResult.xmlStringResult=xmlOutput;
        return BGRCharResult;   
    }
    
       public result getProductCatalog() {
        result resultCatalog=new result();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'PART_CATALOG_REC', null); 
        w.writeStartElement(null, 'PART_CATALOG', null); 
        w.writeStartElement(null, 'WEIGHT_NET', null);  
        //w.writeCharacters(' ');
        w.writeCharacters(ASSEMBLYWT);
        w.writeEndElement();
        w.writeStartElement(null, 'UOM', null);  
        //w.writeCharacters(' ');
        w.writeCharacters(ASSEMBLYWTUOM);
        w.writeEndElement();
        w.writeEndElement();
        w.writeEndElement();
        w.writeEndDocument();
        string xmlOutput = w.getXmlString();
        //system.debug('XML is xmlOutput  '+xmlOutput );
        w.close();
        string xmldata = doc.toXmlString();
        //system.debug('XML is '+xmldata);
        resultCatalog.xmlStringResult=xmlOutput;
        return resultCatalog;
    } 
    
    public Result GetInventoryPartDetails( )
    {
        result BGRInventoryPartsResult=new result();
        //list<BGR_lead_time__c> bgrLeadTimeList = GetLeadTimeRec();
        list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = GlobalSiteParametersISPM();
        //result resBGRLeadTime=getLeadTime();
        //string PARTNUMBER1=getPartNum();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'INVENTORY_PART_LIST', null); 
        //if(resBGRLeadTime.bResult)
        if(GlobalSiteParametersISPMList.size() > 0)
        {
            //for(sObject sobj:resBGRLeadTime.objResultList) {
            for(Global_Site_Part_Parameters_ISPM__c bgrLead : GlobalSiteParametersISPMList){
               
                w.writeStartElement(null, 'INVENTORY_PART', null);
                w.writeStartElement(null, 'CONTRACT', null);  
                w.writeCharacters(bgrLead.InventorySite__c);
                w.writeEndElement();
                w.writeStartElement(null, 'PART_NO', null);  
                w.writeCharacters(PARTNUMBER.toUpperCase());
                w.writeEndElement();
                w.writeStartElement(null, 'TEMPLATE_ID', null);  
                w.writeCharacters(bgrLead.InventoryPartTemplate_ID__c);
                w.writeEndElement();
                
                w.writeStartElement(null, 'PART_TYPE', null);  
                w.writeCharacters(bgrLead.InventoryPartType__c);
                w.writeEndElement();
                w.writeStartElement(null, 'PLANNER', null);  
                w.writeCharacters(PLANNER);
                w.writeEndElement();
                w.writeStartElement(null, 'CUSTOMS_STAT_NO', null);  
                w.writeCharacters(CUSTOMS_STAT_NO);
                w.writeEndElement();
                w.writeStartElement(null, 'ENG_REVISION', null);  
                w.writeCharacters(PARTREV);
                w.writeEndElement();
                w.writeEndElement();
            }
        }
        //  w.writeEndElement();
        w.writeEndElement();
        w.writeEndDocument();
        string xmlOutput = w.getXmlString();
        system.debug('XML is xmlOutput  '+xmlOutput );
        w.close();
        string xmldata = doc.toXmlString();
        system.debug('XML is '+xmldata);
        BGRInventoryPartsResult.xmlStringResult=xmlOutput;
        return BGRInventoryPartsResult;
    }
    
      //Dummy method for Purchase parts
    public result getPurchasePart() {
        result resultPurchase=new result();
        list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = GlobalSiteParametersISPM();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        //string PARTNUMBER1=getPartNum();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'PURCHASE_PART_LIST', null); 
        if(GlobalSiteParametersISPMList.size() > 0)
        {
            for(Global_Site_Part_Parameters_ISPM__c bgrLead : GlobalSiteParametersISPMList){
                if(bgrLead.PurchaseSite__c != '{null}') 
                {
                    w.writeStartElement(null, 'PURCHASE_PART', null);
                    w.writeStartElement(null, 'CONTRACT', null);
                    w.writeCharacters(bgrLead.PurchaseSite__c);
                    w.writeEndElement();
                    w.writeStartElement(null, 'PART_NO', null);  
                    w.writeCharacters(PARTNUMBER.toUpperCase());
                    w.writeEndElement();
                    w.writeStartElement(null, 'DESCRIPTION', null);
                    //Service Ticket #200752  
                    w.writeCharacters(String.isNotBlank(DESCRIPTION)?DESCRIPTION.length()<200?DESCRIPTION:DESCRIPTION.substring(0,200):'');
                    w.writeEndElement();
                    w.writeStartElement(null, 'TEMPLATE_ID', null);  
                    w.writeCharacters(bgrLead.PurchasePartTemplate_ID__c);
                    w.writeEndElement();
                    w.writeStartElement(null, 'UOM', null);  
                    w.writeCharacters(PART_UOM);
                    w.writeEndElement();
                    w.writeEndElement();
            }
        }
        }
        w.writeEndElement();
        w.writeEndDocument();
        string xmlOutput = w.getXmlString();
        system.debug('XML is xmlOutput  '+xmlOutput );
        w.close();
        string xmldata = doc.toXmlString();
        system.debug('XML is '+xmldata);
        resultPurchase.xmlStringResult=xmlOutput;
        return resultPurchase;
    } 

    
    public result getPurchasePartSuppliers() {
        result resultSuppliers=new result();
        list<Global_Site_Part_Parameters_PPS__c> GlobalSiteParametersPPSList = getGlobalSitePPS();
        Dom.Document doc = new Dom.Document();
        //string PARTNUMBER1=getPartNum();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'PURCHASE_PART_SUPPLIER_LIST', null); 
        System.debug('Vikram outside------' +GlobalSiteParametersPPSList.size());
        if(GlobalSiteParametersPPSList.size() > 0)
        {
            System.debug('Vikram inside------');
            for(Global_Site_Part_Parameters_PPS__c globalSitePPS : GlobalSiteParametersPPSList){
                w.writeStartElement(null, 'PURCHASE_PART_SUPPLIER', null); 
                w.writeStartElement(null, 'CONTRACT', null);  
                w.writeCharacters(globalSitePPS.PurchaseSite__c);
                w.writeEndElement();
                w.writeStartElement(null, 'PART_NO', null);  
                w.writeCharacters(PARTNUMBER.toUpperCase());
                w.writeEndElement();
                w.writeStartElement(null, 'VENDOR_NO', null);  
                w.writeCharacters(globalSitePPS.PPS_VendoNo__c);
                w.writeEndElement();
                w.writeStartElement(null, 'BUY_UNIT_MEAS', null);  
                w.writeCharacters(PART_UOM);
                w.writeEndElement();
                w.writeStartElement(null, 'PRIMARY_VENDOR_DB', null);  
                w.writeCharacters(globalSitePPS.Primary_Vendor__c != null ? globalSitePPS.Primary_Vendor__c : '');
                w.writeEndElement();
                w.writeStartElement(null, 'HSN_SAC_CODE', null);  
                if(globalSitePPS.PurchaseSite__c == '30')
                {
                    w.writeCharacters(HSN_SAC_CODE);
                }
                else
                {
                    w.writeCharacters('');
                }
                w.writeEndElement();
                w.writeStartElement(null, 'LIST_PRICE', null);  
                System.debug('*** currentWGB = '+currentWGB.List_Price_Each__c);
                w.writeCharacters(currentWGB.List_Price_Each__c != null ? currentWGB.List_Price_Each__c+'' : '');
                w.writeEndElement();
                w.writeEndElement();
            }
        }
        w.writeEndElement();
        w.writeEndDocument();
        string xmlOutput = w.getXmlString();
        system.debug('XML is xmlOutput  '+xmlOutput );
        w.close();
        string xmldata = doc.toXmlString();
        system.debug('XML is '+xmldata);
        resultSuppliers.xmlStringResult=xmlOutput;
        return resultSuppliers;
    } 
    
     public Result getStructureXML()
    {
        result BGRStructureResult=new result();
        result strucResult=getStructure();
        list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = GlobalSiteParametersISPM();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'PRODUCT_STRUCTURE_LIST', null); 
        // w.writeStartElement(null, 'PRODUCT_STRUCTURE_HEAD', null);
        //string PARTNUMBER1=getPartNum();
        if(strucResult.bResult && GlobalSiteParametersISPMList.size() > 0)
        {
            for(Global_Site_Part_Parameters_ISPM__c bgrLead : GlobalSiteParametersISPMList)
            {
                if(bgrLead.MfgSite__c != '{null}')
                {                
                    w.writeStartElement(null, 'PRODUCT_STRUCTURE_HEAD', null);
                    w.writeStartElement(null, 'CONTRACT', null);  
                    w.writeCharacters(bgrLead.MfgSite__c);
                    w.writeEndElement();
                    w.writeStartElement(null, 'PART_NO', null);  
                    w.writeCharacters(PARTNUMBER.toUpperCase());
                    w.writeEndElement();
                    w.writeStartElement(null, 'PROD_STRUCTURE_LIST', null); 
                    for(sObject sobj:strucResult.objResultList) 
                    {
                        // w.writeStartElement(null, 'PRODUCT_STRUCTURE_HEAD', null);
                        // w.writeStartElement(null, 'CONTRACT', null);  
                        // w.writeCharacters(bgrLead.PurchaseSite__c);
                        // w.writeEndElement();
                        // w.writeStartElement(null, 'PART_NO', null);  
                        // w.writeCharacters(PARTNUMBER.toUpperCase());
                        // w.writeEndElement();
                        // if(bgrLead.MfgSite__c == (STRING) sobj.get('Line_Item_No__c'))
                        // {     
                        // w.writeStartElement(null, 'LINE_ITEM_NO', null);  
                        // w.writeCharacters((STRING) sobj.get('Line_Item_No__c'));
                        // w.writeEndElement();
                        // w.writeStartElement(null, 'PROD_STRUCTURE_LIST', null); 
                        w.writeStartElement(null, 'PRODUCT_STRUCTURE', null);
                        w.writeStartElement(null, 'LINE_ITEM_NO', null);  
                        w.writeCharacters((STRING) sobj.get('Line_Item_No__c'));
                        w.writeEndElement(); 
                        w.writeStartElement(null, 'COMPONENT_PART', null);  
                        w.writeCharacters((STRING) sobj.get('Part_Number__c'));
                        w.writeEndElement();
                        w.writeStartElement(null, 'QTY_PER_ASSEMBLY', null);  
                        w.writeCharacters((STRING) sobj.get('Qty_per_Assembly__c'));
                        w.writeEndElement();
                        w.writeStartElement(null, 'COMPONENT_SCRAP', null);  
                        w.writeCharacters((STRING) sobj.get('Component_Scrap__c'));
                        w.writeEndElement();
                        w.writeStartElement(null, 'SHRINKAGE_FACTOR', null);  
                        w.writeCharacters((STRING) sobj.get('Scrap_Factor__c'));
                        w.writeEndElement();
                        w.writeEndElement(); 
                        //w.writeEndElement(); 
                        // w.writeEndElement();                        
                    }
                    w.writeEndElement();
                    w.writeEndElement();
                }
                
            }
        }
        //w.writeEndElement();      
        w.writeEndElement();
        w.writeEndDocument(); 
        string xmlOutput = w.getXmlString();
        system.debug('XML is xmlOutput  '+xmlOutput );
        w.close();
        string xmldata = doc.toXmlString();
        system.debug('XML is '+xmldata);
        BGRStructureResult.xmlStringResult=xmlOutput;
        return BGRStructureResult;
    }
    
     public result getSalesParts() {
        result resultSales=new result();
        //string PARTNUMBER1=getPartNum();
        list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = GlobalSiteParametersISPM();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'SALES_PART_LIST', null);
        if(GlobalSiteParametersISPMList.size() > 0)
        {
            for(Global_Site_Part_Parameters_ISPM__c bgrLead : GlobalSiteParametersISPMList){
                w.writeStartElement(null, 'SALES_PART', null);
                w.writeStartElement(null, 'CONTRACT', null);  
                w.writeCharacters(bgrLead.SalesSite__c);
                w.writeEndElement();
                w.writeStartElement(null, 'CATALOG_NO', null);  
                w.writeCharacters(PARTNUMBER.toUpperCase());
                w.writeEndElement();
                w.writeStartElement(null, 'CATALOG_GROUP', null);  
                w.writeCharacters(CATALOG_GROUP);
                w.writeEndElement();
                w.writeStartElement(null, 'SALES_PRICE_GROUP', null);  
                w.writeCharacters(SALES_PRICE_GROUP_ID);
                w.writeEndElement();
                w.writeStartElement(null, 'SOURCING_OPTION', null);  
                w.writeCharacters(bgrLead.Sourcing_Option__c);
                w.writeEndElement();
                w.writeStartElement(null, 'HSN_SAC_CODE', null);
                if(bgrLead.SalesSite__c == '30')
                {
                    w.writeCharacters(HSN_SAC_CODE);
                }
                else
                {
                    w.writeCharacters('');
                }
                w.writeEndElement();
                w.writeEndElement();
            }
        }
        w.writeEndElement();
        w.writeEndDocument();
        string xmlOutput = w.getXmlString();
        system.debug('XML is xmlOutput  '+xmlOutput );
        w.close();
        string xmldata = doc.toXmlString();
        system.debug('XML is '+xmldata);
        resultSales.xmlStringResult=xmlOutput;
        return resultSales;
    } 
   
    public Result GetControlPlanDetails()
    {
        result BGRControlPlangResult=new result();
        Dom.Document doc = new Dom.Document();
        string OuterMinValue = '';
        string InnerMinValue = '';
        string NominalValue = '';
        string InnerMaxValue = '';
        string OuterMaxValue = '';
        
        BGRControlPlangResult = getControlPlan();
        if(BGRControlPlangResult.bResult)
        { 
            list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = GlobalSiteParametersISPM(); 
            Xmlstreamwriter xmlW = new Xmlstreamwriter();
            xmlW.writeStartDocument('utf-8','1.0');
            
            xmlW.writeStartElement(null,'CONTROL_PLAN_MANUF_LIST', null);
            Set<String> toolIdSet = new Set<String>();
            Set<String> dataPointSet = new Set<String>();
            List<WGB_ControlPlan_Detail__c> connectionList = new List<WGB_ControlPlan_Detail__c>();
            for(sObject sRec: BGRControlPlangResult.objResultList)
            {
                WGB_ControlPlan_Detail__c brRec = (WGB_ControlPlan_Detail__c)sRec;
                if(String.isNotBlank(brRec.Tool_ID__c))
                {
                    toolIdSet.add(brRec.Tool_ID__c);
                }
                if(String.isNotBlank(brRec.Data_Point__c) && dataPointSet.add(brRec.Data_Point__c))
                {
                    connectionList.add(brRec);
                }
            }
            if(GlobalSiteParametersISPMList.size() > 0)
            {
                for(Global_Site_Part_Parameters_ISPM__c bgrLead : GlobalSiteParametersISPMList)
                {
                    if(bgrLead.MfgSite__c !='{null}')
                    {
                        xmlW.writeStartElement(null,'CONTROL_PLAN_MANUFACTURING',null);
                        xmlW.writeStartElement(null,'PART_NO',null);
                        xmlW.writeCharacters(PARTNUMBER.toUpperCase());
                        xmlW.writeEndElement(); 
                        
                        xmlW.writeStartElement(null,'CONTRACT',null);
                        xmlW.writeCharacters(bgrLead.MfgSite__c);
                        xmlW.writeEndElement(); 
                        
                        xmlW.writeStartElement(null,'RECEIPT_NOT_ALLOWED',null); 
                        xmlW.writeCharacters('TRUE');                  
                        xmlW.writeEndElement();
                        
                        xmlW.writeStartElement(null,'CONTROL_PLAN_LINE_LIST',null);
                        for(sObject sRec: BGRControlPlangResult.objResultList)
                        {
                            WGB_ControlPlan_Detail__c brRec = (WGB_ControlPlan_Detail__c)sRec;
                            xmlW.writeStartElement(null,'CONTROL_PLAN_LINE',null); // CONTROL_PLAN_LINE start
                            
                            xmlW.writeStartElement(null,'TEST_OPERATION_NO',null); 
                            //xmlW.writeCharacters(String.valueOf(brRec.Test_OPNO__c));
                            xmlW.writeCharacters(String.valueOf(brRec.Test_OPNO__c));
                            xmlW.writeEndElement();
                            
                            xmlW.writeStartElement(null,'TEST_OPERATION_DESC',null); 
                            xmlW.writeCharacters(String.valueOf(brRec.Test_Operation_Desc__c));
                            xmlW.writeEndElement();
                            
                            xmlW.writeStartElement(null,'NORM_TYPE',null); 
                            xmlW.writeCharacters(String.valueOf(brRec.Norm_Type__c));
                            xmlW.writeEndElement();
                            
                            xmlW.writeStartElement(null,'ROUTING_OPERATION_NO',null);
                            if(brRec.Operation_Number__c != null)
                            {
                                xmlW.writeCharacters(String.valueOf(brRec.Operation_Number__c));
                            }                   
                            xmlW.writeEndElement();
                            
                            xmlW.writeStartElement(null,'DATA_TYPE',null);
                            if(brRec.Data_Type__c != null)
                            {
                                xmlW.writeCharacters(brRec.Data_Type__c);
                            }                   
                            xmlW.writeEndElement();
                            
                            xmlW.writeStartElement(null,'CATEGORY_ID',null);
                            if(brRec.Category_ID__c != null)
                            {
                                xmlW.writeCharacters(brRec.Category_ID__c);
                            }                   
                            xmlW.writeEndElement();
                            
                            xmlW.writeStartElement(null,'OUTER_MIN',null);
                           // OuterMinValue = String.valueOf(brRec.OUTER_MIN__c);
                            //System.debug('AAAAAa-----'+OuterMinValue);
                           // OuterMinValue = OuterMinValue.substringBetween('[',']');
                          //  if(string.isBlank(OuterMinValue))
                         //   {
                                if(brRec.Outer_Min__c != null)
                                      xmlW.writeCharacters(String.valueOf(brRec.Outer_Min__c));
                                else
                                      xmlW.writeCharacters('');
                            
                            
                        //    }
                        //    else
                         //   {
                         //       if(brRec.Outer_Min__c != null)
                         //       {
                            //        xmlW.writeCharacters(mapWGBAttr.get(OuterMinValue));
                         //       }
                        //    }
                            xmlW.writeEndElement();
                            xmlW.writeStartElement(null,'INNER_MIN',null);
                            InnerMinValue = String.valueOf(brRec.Inner_Min__c);
                            if(InnerMinValue!=null)
                            {
                                InnerMinValue = InnerMinValue.substringBetween('[',']');
                            }
                            if(string.isBlank(InnerMinValue) || InnerMinValue == null)
                            {
                                if(InnerMinValue!=null)
                                {
                                    xmlW.writeCharacters(String.valueOf(brRec.Inner_Min__c));
                                }
                            }
                            else
                            {
                                xmlW.writeCharacters(mapWGBAttr.get(InnerMinValue));
                            }          
                            xmlW.writeEndElement();
                            xmlW.writeStartElement(null,'NOMINAL_VALUE',null);
                          //  NominalValue = String.valueOf(brRec.Nominal_Value__c);
                         //   NominalValue = NominalValue.substringBetween('[',']');
                         //   if(string.isBlank(NominalValue))
                         //   {
                                if(brRec.Nominal_Value__c != null)                                
                                    xmlW.writeCharacters(String.valueOf(brRec.Nominal_Value__c));
                                else
                                    xmlW.writeCharacters('');
                         //   }
                        //    else
                       //     {
                        //        if(brRec.Nominal_Value__c != null)
                        //        {
                        //            xmlW.writeCharacters(mapWGBAttr.get(NominalValue));
                        //        }
                       //     }          
                            xmlW.writeEndElement();
                            
                            xmlW.writeStartElement(null,'PROCESS_CHARACTERISTICS',null);
                            if(brRec.Process_Characteristic__c != null)
                            {
                                xmlW.writeCharacters(brRec.Process_Characteristic__c);
                            }                   
                            xmlW.writeEndElement();
                            
                            xmlW.writeStartElement(null,'SPECIAL_CHAR_CLASS',null);
                            if(brRec.Process_Characteristic__c != null)
                            {                 
                                xmlW.writeCharacters(brRec.Process_Characteristic__c);
                            }                   
                            xmlW.writeEndElement();
                            
                            xmlW.writeStartElement(null,'OUTER_MAX',null);
                           // OuterMaxValue = String.valueOf(brRec.Outer_Max__c);
                          //  OuterMaxValue = OuterMaxValue.substringBetween('[',']');
                          //  if(string.isBlank(OuterMaxValue))
                           // {
                                if(brRec.Outer_Max__c != null)                           
                                    xmlW.writeCharacters(String.valueOf(brRec.Outer_Max__c));
                                else
                                     xmlW.writeCharacters('');
                        //    }
                        //    else
                          // {
                        //        if(brRec.Outer_Max__c != null && mapWGBAttr.get(OuterMaxValue) != null)
                         //       {
                        //            xmlW.writeCharacters(mapWGBAttr.get(OuterMaxValue));
                        //        }
                        //    }                        
                            xmlW.writeEndElement();
                            
                            xmlW.writeStartElement(null,'INNER_MAX',null);
                            InnerMaxValue = String.valueOf(brRec.Inner_Max__c);
                            if(InnerMaxValue != null)
                            {
                                InnerMaxValue = InnerMaxValue.substringBetween('[',']');
                            }
                            else
                            {
                                InnerMaxValue='';
                            }
                            if(string.isBlank(InnerMaxValue))
                            {
                                if(brRec.Inner_Max__c != null)
                                {
                                    xmlW.writeCharacters(String.valueOf(brRec.Inner_Max__c));
                                }
                            }
                            else
                            {
                                if(brRec.Inner_Max__c != null)
                                {
                                    xmlW.writeCharacters(mapWGBAttr.get(InnerMaxValue));
                                }
                            }                           
                            xmlW.writeEndElement();
                            xmlW.writeStartElement(null,'INSPECTION_CODE',null); 
                            xmlW.writeCharacters(brRec.Inspection_Code__c);
                            xmlW.writeEndElement();
                            
                            xmlW.writeEndElement(); // CONTROL_PLAN_LINE end
                            
                        }
                        xmlW.writeEndElement(); // CONTROL_PLAN_LINE_LIST
                        
                        if(toolIdSet.size() > 0)
                        {
                            for(String toolId : toolIdSet)
                            {
                                xmlW.writeStartElement(null,'TOOL_LIST',null); // TOOL_LIST start
                                xmlW.writeStartElement(null,'TOOL',null); // TOOL start
                                xmlW.writeStartElement(null,'TOOL_ID',null);
                                xmlW.writeCharacters(toolId);
                                xmlW.writeEndElement();
                                xmlW.writeEndElement(); // TOOL end                    
                                xmlW.writeEndElement(); // TOOL_LIST end
                            }
                        }
                        if(connectionList.size() > 0)
                        {
                            xmlW.writeStartElement(null,'CONNECT_LIST',null); // CONNECT_LIST start
                            for(WGB_ControlPlan_Detail__c brRec : connectionList)
                            {
                                if(brRec.Tool_ID__c != null)
                                {
                                    xmlW.writeStartElement(null,'TOOL_CONNECT',null); // TOOL_CONNECT start
                                    xmlW.writeStartElement(null,'DATA_POINT',null); 
                                    xmlW.writeCharacters(brRec.Data_Point__c);
                                    xmlW.writeEndElement();
                                    
                                    xmlW.writeStartElement(null,'TOOL_ID',null); 
                                    if(brRec.Tool_ID__c != null)
                                    {
                                        xmlW.writeCharacters(brRec.Tool_ID__c);
                                    }
                                    else
                                    {
                                        xmlW.writeCharacters('');
                                    }
                                    xmlW.writeEndElement(); // TOOL_ID end
                                    xmlW.writeEndElement(); // TOOL_CONNECT
                                }
                            }
                            xmlW.writeEndElement(); // CONNECT_LIST end
                        }
                    /*    for(sObject sRec: BGRControlPlangResult.objResultList)
                        {
                            WGB_ControlPlan_Detail__c brRec = (WGB_ControlPlan_Detail__c)sRec;
                            xmlW.writeStartElement(null,'TOOL_LIST',null); // TOOL_LIST start
                            
                            xmlW.writeStartElement(null,'TOOL',null); // TOOL start
                            
                            xmlW.writeStartElement(null,'TOOL_ID',null); 
                            if(brRec.Tool_ID__c != null)
                            {
                                xmlW.writeCharacters(brRec.Tool_ID__c);
                            }
                            else
                            {
                                xmlW.writeCharacters('');
                            }
                            xmlW.writeEndElement();
                            
                            xmlW.writeEndElement(); // TOOL end                    
                            xmlW.writeEndElement(); // TOOL_LIST end
                            
                            xmlW.writeStartElement(null,'CONNECT_LIST',null); // CONNECT_LIST start
                            xmlW.writeStartElement(null,'TOOL_CONNECT',null); // TOOL_CONNECT start
                            
                            xmlW.writeStartElement(null,'DATA_POINT',null); 
                            xmlW.writeCharacters(brRec.Data_Point__c);
                            xmlW.writeEndElement();
                            
                            xmlW.writeStartElement(null,'TOOL_ID',null); 
                            if(brRec.Tool_ID__c != null)
                            {
                                xmlW.writeCharacters(brRec.Tool_ID__c);
                            }
                            else{
                                xmlW.writeCharacters('');
                            }
                            
                            xmlW.writeEndElement(); // TOOL_ID end
                            xmlW.writeEndElement(); // TOOL_CONNECT
                            xmlW.writeEndElement(); // CONNECT_LIST end
                        }*/
                        xmlW.writeEndElement();
                    }
                }
            }
            xmlW.writeEndElement(); 
            xmlW.writeEndDocument(); 
            String xmlStringxmlRes = xmlW.getXmlString();
            System.debug('XML is xmlOutput :'+xmlW.getXmlString());     
            xmlW.close();
            string xmldata = doc.toXmlString();
            system.debug('XML is '+xmldata);
            BGRControlPlangResult.xmlStringResult=xmlStringxmlRes;
        }
    
    return BGRControlPlangResult;
}
    
    public Result GetRoutingDetails()
    {
        result BGRRoutingResult=new result();
        Dom.Document doc = new Dom.Document();
     //   List<WGB_Routing_Detail__c> lstBR = [Select Standard_Operation_Id__c,Operation__c,Outside_Operation_Item__c
     //                                 FROM WGB_Routing_Detail__c ];
        
        List<WGB_Routing_Detail__c> lstBR = new List<WGB_Routing_Detail__c>();
        
        Result bgrGuideLineResult2 = getRouting();
        if(bgrGuideLineResult2.bResult && bgrGuideLineResult2.objResultList.size() > 0)
        {
            System.debug('Inside5----------');
            for(sObject objResult: bgrGuideLineResult2.objResultList)
            {
                WGB_Routing_Detail__c bgrGuideLine2 = (WGB_Routing_Detail__c)objResult;
              //  System.debug('Inside4----------' +bgrGuideLine.Operation__c);                //
              //  if(bgrGuideLine.Operation__c == '30')
            //    {
                    System.debug('Inside3----------');
                    lstBR.add(bgrGuideLine2);
              // }
            }
        }
        
        List<WGB_Workguideline_Detail__c> lstGL = new List<WGB_Workguideline_Detail__c>();
        /*[Select Guideline_Type__c,Sign_Off_Required__c,Inspection_Sign_Off_Required__c,Guideline_Text__c,Guideline_Sequence__c,
                                       Guideline_Description__c  
                                       from BGR_Guideline__c  
                                       Where (Atex__c =:ATEX or Atex__c = '-') and 
                                       (CUTR__c =:CUTR or CUTR__c = '-') and 
                                       (CSA__c =:CSA or CSA__c = '-') and 
                                       (XRAY__c =:XRAY or XRAY__c = '-') and 
                                       (Positive_Material_Identification__c =:PMI or Positive_Material_Identification__c = '-') and 
                                       (Operation_Number__c = '30')];*/
        Result bgrGuideLineResult = getWorkGuideLines();
        if(bgrGuideLineResult.bResult && bgrGuideLineResult.objResultList.size() > 0)
        {
            System.debug('Inside5----------');
            for(sObject objResult: bgrGuideLineResult.objResultList)
            {
                WGB_Workguideline_Detail__c bgrGuideLine = (WGB_Workguideline_Detail__c)objResult;
              //  System.debug('Inside4----------' +bgrGuideLine.Operation__c);                //
              //  if(bgrGuideLine.Operation__c == '30')
            //    {
                System.debug('Inside4----------' +bgrGuideLine.Operation__c);  
                    System.debug('Inside3----------');
                    lstGL.add(bgrGuideLine);
              // }
            }
        }
        
        if(lstBR.size()>0)
        { 
            //system.debug('BGR Routing Result list' +lstBR );
            //string PARTNUMBER1=getPartNum();
            list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = GlobalSiteParametersISPM();
            Xmlstreamwriter xmlW = new Xmlstreamwriter();
            xmlW.writeStartDocument('utf-8','1.0');
            xmlW.writeStartElement(null,'ROUTING_HEAD_LIST', null);
            //xmlW.writeStartElement(null,'ROUTING_HEAD', null);
            if(GlobalSiteParametersISPMList.size() > 0)
            {
                for(Global_Site_Part_Parameters_ISPM__c bgrLead : GlobalSiteParametersISPMList)
                {
                    if(bgrLead.MfgSite__c != '{null}')
                    {
                        xmlW.writeStartElement(null,'ROUTING_HEAD', null);            
                        xmlW.writeStartElement(null,'CONTRACT',null);
                        xmlW.writeCharacters(bgrLead.MfgSite__c);
                        xmlW.writeEndElement();            
                        xmlW.writeStartElement(null,'PART_NO',null);
                        xmlW.writeCharacters(PARTNUMBER.toUpperCase());
                        xmlW.writeEndElement();           
                        xmlW.writeStartElement(null,'ROUTING_OPERATION_LIST',null);
                        for(WGB_Routing_Detail__c brRec: lstBR)
                        {
                            //BGR_Routing__c brRec = (BGR_Routing__c)sRec;
                            xmlW.writeStartElement(null,'ROUTING_OPERATION',null);                
                            xmlW.writeStartElement(null,'OPERATION_NO',null);
                            xmlW.writeCharacters(brRec.Operation__c);
                            xmlW.writeEndElement();                 
                            xmlW.writeStartElement(null,'STD_OP_ID',null);
                            xmlW.writeCharacters(brRec.Standard_Operation_Id__c);
                            xmlW.writeEndElement();               
                            xmlW.writeStartElement(null,'OUTSIDE_OP_ITEM',null);
                            if(brRec.Outside_Operation_Item__c != null)
                            {
                                xmlW.writeCharacters(brRec.Outside_Operation_Item__c);
                            }
                            else{
                                xmlW.writeCharacters('');
                            }
                            xmlW.writeEndElement(); 
                            //Guideline Iteration
                            //if(brRec.Operation__c == '30')
                           if(brRec.Operation__c == '0070' || brRec.Operation__c == '70')
                            {
                                if(lstGL.size()>0)
                            {
                                System.debug('Inside1----------');
                                xmlW.writeStartElement(null,'ROUTING_OPER_WORK_GUIDE_LIST',null);
                                for(WGB_Workguideline_Detail__c bgRec: lstGL)
                                {
                                    System.debug('Inside2----------');

                                    xmlW.writeStartElement(null,'ROUTING_OPER_WORK_GUIDE',null);
                                    xmlW.writeStartElement(null,'GUIDELINE_SEQ',null);
                                    xmlW.writeCharacters(bgRec.Guidline_Seq__c);
                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement(null,'GUIDELINE_DESC',null);
                                    xmlW.writeCharacters(bgRec.Description__c);
                                    xmlW.writeEndElement(); 
                                    xmlW.writeStartElement(null,'GUIDELINE_TEXT',null);
                                    xmlW.writeCharacters(bgRec.Text__c);
                                    xmlW.writeEndElement();                       
                                    xmlW.writeStartElement(null,'OPER_WORK_GUIDE_TYPE',null);
                                    xmlW.writeCharacters(bgRec.Type__c);
                                    xmlW.writeEndElement();                        
                                    xmlW.writeStartElement(null,'SIGN_OFF_REQ',null);
                                    xmlW.writeCharacters(bgRec.Sign_Off__c); 
                                    xmlW.writeEndElement();   
                                    xmlW.writeStartElement(null,'INSPECT_SIGN_OFF_REQ',null);
                                    xmlW.writeCharacters(bgRec.Inspection_Sign_Off_Required__c);
                                    xmlW.writeEndElement();
                                    xmlW.writeEndElement();//ROUTING_OPER_WORK_GUIDE end 
                                }
                                xmlW.writeEndElement(); //ROUTING_OPER_WORK_GUIDE_LIST end
                            }
                        }
                            //Guideline Iteration Complete
                            xmlW.writeEndElement(); //ROUTING_OPERATION end
                            //xmlW.writeEndElement();
                        }
                        xmlW.writeEndElement(); //ROUTING_OPERATION_LIST end
                        xmlW.writeStartElement(null,'ROUTING_CHAR_LIST',null);
                        xmlW.writeStartElement(null,'ROUTING_CHAR',null);
                        xmlW.writeStartElement(null,'CHAR_TEMPLATE',null);
                        xmlW.writeEndElement(); // CHAR_TEMPLATE end  
                        xmlW.writeEndElement(); // ROUTING_CHAR end
                        xmlW.writeEndElement(); // ROUTING_CHAR_LIST end
                        xmlW.writeEndElement(); // ROUTING_HEAD end
                    }
                }
            }         
            xmlW.writeEndElement(); // ROUTING_HEAD_LIST end
            xmlW.writeEndDocument(); 
            String xmlStringxmlRes = xmlW.getXmlString();
            System.debug('XML is xmlOutput :'+xmlW.getXmlString());     
            xmlW.close();
            string xmldata = doc.toXmlString();
            system.debug('XML is '+xmldata);
            BGRRoutingResult.xmlStringResult=xmlStringxmlRes;
        } 
        return BGRRoutingResult;
    }
    
    
    
 
}