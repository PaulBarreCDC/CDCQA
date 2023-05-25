/**
* @File Name          : FAOutputUtility.cls
* @Description        :
* @Author             : Vikram Natikar
* @Group              :
* @Last Modified By   : Vikram Natikar
* @Last Modified On   : 04/11/2020
* @Modification Log   :
* Ver       Date            Author      		    Modification
* 1.0    18/06/2020      Vikram Natikar     	  Initial Version
* 1.1    03-Feb-2021     Rohini Hathi             Support Ticket # 161412
**/ 

public class FAOutputUtility {
    
    public Flame_Product__c FLMProd {set; get;}
    
    public FAOutputUtility (Id recordID) {
        FLMProd= (Flame_Product__c) wizardBaseDataProcessor.getObjectDataById(recordID).objResultList[0];
        mapFLMAttr=new Map<String, string>();
        mapFA_Attribute=getMapAttribute(); 
        List<FA_Output__c> flmOutputList = new List<FA_Output__c>();
        String fieldsAPIname = FLMutility.getObjectFields('FA_Output__c');    
        String soql = 'SELECT ' + fieldsAPIname +' FROM FA_Output__c ';
        soql += ' WHERE FA_Output_Relation_Field__c =\''+String.escapeSingleQuotes(FLMProd.Id)+'\' ';    
        System.debug('@Developer --> soql :' + soql);    
        flmOutputList = Database.query(soql);
        if(flmOutputList.size() > 0)
        {
            if(string.isNotBlank(flmOutputList[0].OA_Override__c))
            {
                OA = flmOutputList[0].OA_Override__c;
            }
            else
            {
                OA = FLMProd.OA__c;
            }
            if(string.isNotBlank(flmOutputList[0].OB_Override__c))
            {
                OB = flmOutputList[0].OB_Override__c;
            }
            else
            {
                OB = FLMProd.OB__c;
            }
            if(string.isNotBlank(flmOutputList[0].OW_Override__c))
            {
                OW = flmOutputList[0].OW_Override__c;
            }
            else
            {
                OW = FLMProd.OW__c;
            }
            if(string.isNotBlank(flmOutputList[0].PC_Override__c))
            {
                PC = flmOutputList[0].PC_Override__c;
            }
            else
            {
                PC = FLMProd.PC__c;
            }
        }
        else
        {
            OA = FLMProd.OA__c;
            OB = FLMProd.OB__c;
            OW = FLMProd.OW__c;
            PC = FLMProd.PC__c;
        }
        System.debug('VVVVVVVvstrDescription-----' +DESCRIPTION);
      // mapFA_Attribute2=getMapAttribute2(); 
     //  mapIFSAttr=new Map<String,string>();
    //ASYTYP=[select Text__c from FA_Attributes_Details__c where Attribute__c=:'ASYTYP' and Text1Val__c=:flmprod.PTC__c][0].Text__c;
   // GPFACE=[select Text__c from FA_Attributes_Details__c where Attribute__c=:'GPFACE' and Text1Val__c=:flmprod.Body_Material__c][0].Text__c;
  //  VendorPaint=[select Text__c from FA_Attributes_Details__c where Attribute__c=:'VendorPaint' and Text1Val__c=:flmprod.Painting_Coating_Option__c][0].Text__c;
  //  decimal decGasGroupLevel=0;
   /* System.debug('AAAAAAAAAAflmProd.Gas_Group_Code__cl======' +flmProd.Gas_Group_Code__c);
    if(!Test.isRunningTest())
    	decGasGroupLevel=[SELECT GasGroupLevel__c from FA_MasterBlaster__c where GasGroupLevel__c>=:ReqdGasGroupLevel and PTC__c=:flmprod.PTC__c][0].GasGroupLevel__c;
    
    System.debug('AAAAAAAAAAdecGasGroupLevel======' +decGasGroupLevel);  */
  //  strGasGroupLevel=string.valueOf(decGasGroupLevel);
	//System.debug('AAAAAAAAAAstrGasGroupLevel======' +strGasGroupLevel);

    }
    
  //  public string strGasGroupLevel {get;set;}
  //  public decimal decGasGroupLevel {get;set;}
  //  public string ASYTYP {get;set;}
  //  public string GPFACE {get;set;}
  //  public string VendorPaint {get;set;}
    //public map<string,string> mapFLMAttr {get;set;}    
    public map<string,string> mapFA_Attribute {get;set;} 
  //  public map<string,string> mapFA_Attribute2 {get;set;} 
    public map<string,string> mapIFSAttr {get;set;} 
    public map<string,string> mapTroubleShootAttr {get;set;}
    
 /******** FLM Map of Attributes that is used in Translation methods     *******/   
    
    public Map<string,string> mapFLMAttr{      
        get{ 
                Map<String, string> myMap1 = new Map<String, String>(); 
                    myMap1.put('ASSYPARTNO',ASSYPARTNO);
                    myMap1.put('UOMSystem',UOMSystem);
                    myMap1.put('BRINHARDEXAM',BRINHARDEXAM); 
                    myMap1.put('CHARPYIMPEXAM',CHARPYIMPEXAM);
                    myMap1.put('FWLDP',FWLDP); 
                    myMap1.put('PTC',PTC);
                    myMap1.put('IGCEXAM',IGCEXAM);
                    myMap1.put('LDP',LDP);
                    myMap1.put('MAGPARTEXAM',MAGPARTEXAM);
                    myMap1.put('PMI',PMI);
                    myMap1.put('XRAY',XRAY);
                    myMap1.put('SPRING',SPRING);
                    myMap1.put('USONICEXAM',USONICEXAM);
                    myMap1.put('VISCASTEXAM',VISCASTEXAM);
                    myMap1.put('GOUTOP',GOUTOP);
                    myMap1.put('SHLTSTBDYPSIG',string.valueOf(SHLTSTBDYPSIG));
                    myMap1.put('SHLTSTBDYPSIGMX',string.valueOf(SHLTSTBDYPSIGMX));
                //    myMap1.put('GPFACE',GPFACE);
                    myMap1.put('SETTING',SETTING);
                    myMap1.put('GINLOP',GINLOP);
                    myMap1.put('GasGroupLevel',GasGroupLevel);
                    myMap1.put('SZC',SZC);
                    myMap1.put('GINLOP_OptA',GINLOP_OptA);
                    myMap1.put('GINLOP_OptB',GINLOP_OptB);
                    myMap1.put('GINLOP_OptC',GINLOP_OptC);
                    myMap1.put('ESZC',ESZC);
                    myMap1.put('GOUTOP_OptA',GOUTOP_OptA);
                    myMap1.put('GOUTOP_OptB',GOUTOP_OptB);
                    myMap1.put('GOUTOP_OptC',GOUTOP_OptC);
                    myMap1.put('MCBODY',MCBODY);
                    myMap1.put('GPAINT',GPAINT);
                    myMap1.put('MCELEM',MCELEM);
                    myMap1.put('HCLASS',HCLASS);
                    myMap1.put('GOUTOP_OptB',GOUTOP_OptB);
                    myMap1.put('GOUTOP_OptC',GOUTOP_OptC);
                    myMap1.put('GINLOP_OptC',GINLOP_OptC);
                    myMap1.put('MCHOUS',MCHOUS);
                    myMap1.put('VendorPaint',VendorPaint);
                    myMap1.put('MCELMT',MCELMT);
                    myMap1.put('NACE',NACE);                    
                    myMap1.put('MCPALL',MCPALL);
                    myMap1.put('MCDPHM',MCDPHM);
                    myMap1.put('USCG',USCG);
                    myMap1.put('ATEX',ATEX);
                    myMap1.put('CUTR',CUTR);
                    myMap1.put('SHLTSTMETHBDY',SHLTSTMETHBDY);
                    myMap1.put('ASSYLOCATION',ASSYLOCATION);
                    myMap1.put('MATLSOURCE',MATLSOURCE);
                    myMap1.put('BRAND',BRAND);
                    myMap1.put('Model',Model);
					myMap1.put('PRDLIN',PRDLIN);
            
                return myMap1;
        }
        set{
            this.mapFLMAttr=value;
        }
    	
    }  
    
       
  
  /********  Output Methods *********/
   
    //Price Method  
    
    Public Result getPricing()
    {
        result FAPrice = new Result();
        List<String> selectCols = new List<String> {'Price__c','Pricing_Element__c'};       
        FAPrice=wizardBaseDataProcessor.getSortedDataFromTranslationObj('Pricing_Element__c','FA_Price_Translation__c','FA_Price_Details__c',mapFLMAttr,selectCols,'Pricing_Element__c');
        if(FAPrice.bResult)
        { 
            system.debug('Pricing Result Utility query' +FAPrice.objResultList);
        } 
        return FAPrice; 
    }
    
    //Lead Method
     
    Public Result getLeadTime()
    {
        result FALead = new Result();
        List<String> selectCols = new List<String> {'Lead_Time_Item__c','RunTimeSchedule__c','QueueTimeSchedule__c'};        
        FALead=wizardBaseDataProcessor.getSortedDataFromTranslationObj('Lead_Time_Item__c','FA_Lead_Time_Translation__c','FA_Lead_Time_Details__c',mapFLMAttr,selectCols,'Lead_Time_Item__c');
        return FALead; 
    } 
    

   //Structure Method   
    Public Result getStructure()
    {
        result FAStructure = new Result();
        List<String> selectCols = new List<String> {'ItemNo__c','Component_Part__c','Qty_per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Structure_Element__c'};
        FAStructure=wizardBaseDataProcessor.getSortedDataFromTranslationObj('Structure_Element__c','FA_Structure_Translation__c','FA_Structure_Details__c',mapFLMAttr,selectCols,'ItemNo__c');
        if(FAStructure.bResult)
        { 
            system.debug('Structure Result Utility query' +FAStructure.objResultList);    
        } 
        return FAStructure; 
    }     
    
   //Routing Method 
    
    Public Result getRouting()
    {
        result FARouting = new Result();
        List<String> selectCols = new List<String> {'Operation__c','Standard_Operation_ID__c','Outside_Operation_Item__c','Descr__c'};
        FARouting=wizardBaseDataProcessor.getSortedDataFromTranslationObj('Operation__c','FA_Routing_Translation__c','FA_Routing_Details__c',mapFLMAttr,selectCols,'Operation__c');
        if(FARouting.bResult)
        { 
            system.debug('Routing Result Utility query' +FARouting.objResultList);
        } 
        return FARouting; 
    }
    
    //ControlPlan Method
    
    Public Result getControlPlan()
    {
        result FAControlPlan = new Result();
        List<String> selectCols = new List<String> {'TEST_OPERATION_DESC__c','NORM_TYPE__c','Operation_Number__c','DATA_TYPE__c','CATEGORY_ID__c','INSPECTION_CODE__c',
        'SAMPLE_PERCENT__c','Process_Characteristic__c','OUTER_MIN__c','INNER_MIN__c','NOMINAL_VALUE__c','INNER_MAX__c','OUTER_MAX__c','Tool_ID__c','Data_Point__c','Test_OPNO__c'};
        //FAControlPlan=wizardBaseDataProcessor.getDataFromTranslationObj('Test_OPNO__c','FA_Valve_ControlPlan_Translation__c','FA_Valve_ControlPlan_Details__c',mapFAAttr,selectCols);
        FAControlPlan=wizardBaseDataProcessor.getSortedDataFromTranslationObj('Test_OPNO__c','FA_ControlPlan_Translation__c','FA_ControlPlan_Details__c',mapFLMAttr,selectCols,'Test_OPNO__c');
        if(FAControlPlan.bResult)
        { 
            system.debug('ControlPlan Result Utility query' +FAControlPlan.objResultList);
        }
        return FAControlPlan; 
    }
    
    //WorkGuideLines Method 
    
    Public Result getWorkGuideLines()
    {
        result FAWorkGuideLines = new Result();
        List<String> selectCols = new List<String> {'Operation__c','Description__c','Text__c','Type__c','Sign_Off__c','Inspection_Sign_Off_Required__c,GuidlineSeq__c'};
        FAWorkGuideLines=wizardBaseDataProcessor.getDataFromTranslationObj('GuidlineSeq__c','FA_Work_Guidelines_Translation__c','FA_Work_Guidelines_Details__c',mapFLMAttr,selectCols);
        if(FAWorkGuideLines.bResult)
        { 
            system.debug('WorkGuideLines Result Utility query' +FAWorkGuideLines.objResultList);
        } 
        return FAWorkGuideLines; 
    }
    
    //Document Method 
    
    Public Result getDocument()
    {
        result FADocument = new Result();
        List<String> selectCols = new List<String> {'Document__c','Document_ID__c','Revision__c'};
        FADocument=wizardBaseDataProcessor.getDataFromTranslationObj('Document__c','FA_Document_Translation__c','FA_Document_Details__c',mapFLMAttr,selectCols);
        if(FADocument.bResult)
        { 
            system.debug('Document Result' +FADocument.objResultList);
        }
        return FADocument; 
    }
    
    //Lookup Attributes Method 
    Public map<string,string> getMapAttribute()
    {
        Map<String, string> mapFLM_Attribute1 = new Map<String, string>(); 
        result FLMAttributes = new Result();
        List<String> selectCols = new List<String> {'Text__c','Attribute__c','Value__c'};   
      /*  Map<String, String> mapattr11 = new Map<String, String>();
        mapattr11.putAll(mapFLMAttr);
        mapattr11.put('GasGroupLevel',flmprod.GasGroupLevel_Backend__c);  */
        
        FLMAttributes=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','FA_Attributes_Translation__c','FA_Attributes_Details__c',mapFLMAttr,selectCols);
        System.debug('AAAAAAAALLLLL-----' +mapFLMAttr.containsKey('GasGroupLevel'));
        if(FLMAttributes.bResult)
        { 
                for(sObject objD : FLMAttributes.objResultList)
            {
                FA_Attributes_Details__c FLMLookupData = (FA_Attributes_Details__c)objD;
                if(FLMLookupData.Text__c != null && FLMLookupData.Value__c == null)
                {
                    mapFLM_Attribute1.put(FLMLookupData.Attribute__c, FLMLookupData.Text__c);
                }
                if(FLMLookupData.Text__c == null && FLMLookupData.Value__c != null)
                {
                    mapFLM_Attribute1.put(FLMLookupData.Attribute__c, String.valueOf(FLMLookupData.Value__c));
                }
                if(FLMLookupData.Text__c != null && FLMLookupData.Value__c != null)
                {
                    mapFLM_Attribute1.put(FLMLookupData.Attribute__c, FLMLookupData.Text__c+' '+FLMLookupData.Value__c);
                }
                if(FLMLookupData.Text__c == null && FLMLookupData.Value__c == null)
                {
                    mapFLM_Attribute1.put(FLMLookupData.Attribute__c, '');
                }
                System.debug('***** Adding into map11111111 as key = '+FLMLookupData.Attribute__c+' and value = '+(FLMLookupData.Text__c+' '+FLMLookupData.Value__c));
            }
        } 
        
        string ASYTYP=mapFLM_Attribute1.get('ASYTYP')==null?'': mapFLM_Attribute1.get('ASYTYP');
        string GPFACE=mapFLM_Attribute1.get('GPFACE')==null?'': mapFLM_Attribute1.get('GPFACE');
        string DesignOutlet=mapFLM_Attribute1.get('DesignOutlet')==null?'': mapFLM_Attribute1.get('DesignOutlet');
        string strVENDORPAINT=mapFLM_Attribute1.get('VENDORPAINT')==null?'': mapFLM_Attribute1.get('VENDORPAINT');
      //  string strASYTYP=mapFLM_Attribute1.get('ASYTYP')==null?'': mapFA_Attribute.get('ASYTYP');VendorPaint 
        System.debug('XXXXXASYTYP' + ASYTYP);
        System.debug('XXXXXGPFACE' + GPFACE);
        System.debug('XXXXXDesignOutlet' + DesignOutlet);
        System.debug('XXXXXVENDORPAINT' + strVENDORPAINT);
        
        
        
        Map<String, String> mapattr2 = new Map<String, String>();
        mapattr2.putAll(mapFLMAttr);
        mapattr2.put('DesignOutlet',DesignOutlet); 
        mapattr2.put('ASYTYP',ASYTYP); 
        mapattr2.put('GPFACE',GPFACE);
        System.debug('mapFLMAttr-------' +mapFLMAttr);
        if(mapattr2.containsKey(ASYTYP))
             System.debug('mapFLMAttr-------ASYTYP-----' +mapattr2.get(ASYTYP));
        if(mapattr2.containsKey(GPFACE))
             System.debug('mapFLMAttr-------GPFACE-----' +mapattr2.get(GPFACE));
        if(mapattr2.containsKey(DesignOutlet))
             System.debug('mapFLMAttr-------DesignOutlet-----' +mapattr2.get(DesignOutlet));
        Map<String, string> mapFLM_Attribute2 = new Map<String, string>(); 
        result FLMAttributes2 = new Result();
        FLMAttributes2=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','FA_Attributes_Translation__c','FA_Attributes_Details__c',mapattr2,selectCols);
        if(FLMAttributes2.bResult)
        { 
                for(sObject objD : FLMAttributes2.objResultList)
            {
                FA_Attributes_Details__c FLMLookupData2 = (FA_Attributes_Details__c)objD;
                if(FLMLookupData2.Text__c != null && FLMLookupData2.Value__c == null)
                {
                    mapFLM_Attribute2.put(FLMLookupData2.Attribute__c, FLMLookupData2.Text__c);
                }
                if(FLMLookupData2.Text__c == null && FLMLookupData2.Value__c != null)
                {
                    mapFLM_Attribute2.put(FLMLookupData2.Attribute__c, String.valueOf(FLMLookupData2.Value__c));
                }
                if(FLMLookupData2.Text__c != null && FLMLookupData2.Value__c != null)
                {
                    mapFLM_Attribute2.put(FLMLookupData2.Attribute__c, FLMLookupData2.Text__c+' '+FLMLookupData2.Value__c);
                }
                if(FLMLookupData2.Text__c == null && FLMLookupData2.Value__c == null)
                {
                    mapFLM_Attribute2.put(FLMLookupData2.Attribute__c, '');
                }
                System.debug('***** Adding into map22222 as key = '+FLMLookupData2.Attribute__c+' and value = '+(FLMLookupData2.Text__c+' '+FLMLookupData2.Value__c));
            }
            
             System.debug('WWWWWWASYTYP-----' +mapFLM_Attribute2.get('ASYTYP'));
             System.debug('WWWWWWGPFACE-----' +mapFLM_Attribute2.get('GPFACE'));
             System.debug('WWWWWWDesignOutlet-----' +mapFLM_Attribute2.get('DesignOutlet'));
             System.debug('WWWWWWVENDORPAINT------' +mapFLM_Attribute2.get('VENDORPAINT'));
             System.debug('WWWWWWGMODEL-3-------' +mapFLM_Attribute2.get('GMODEL-3'));
             System.debug('WWWWWWGMODEL-4------' +mapFLM_Attribute2.get('GMODEL-4'));
             System.debug('WWWWWWGMODEL-5-----' +mapFLM_Attribute2.get('GMODEL-5'));
             System.debug('WWWWWWGMODEL-6-----' +mapFLM_Attribute2.get('GMODEL-6'));
            return mapFLM_Attribute2;
        }
         System.debug('WWWWWWASYTYP' +mapFLM_Attribute2.get('ASYTYP'));
         System.debug('WWWWWWGPFACE' +mapFLM_Attribute2.get('GPFACE'));
         System.debug('WWWWWWDesignOutlet' +mapFLM_Attribute2.get('DesignOutlet'));
         System.debug('WWWWWWVENDORPAINT' +mapFLM_Attribute2.get('VENDORPAINT'));
         System.debug('WWWWWWGMODEL-3' +mapFLM_Attribute2.get('GMODEL-3'));
         System.debug('WWWWWWGMODEL-4' +mapFLM_Attribute2.get('GMODEL-4'));
         System.debug('WWWWWWGMODEL-5' +mapFLM_Attribute2.get('GMODEL-5'));
         System.debug('WWWWWWGMODEL-6' +mapFLM_Attribute2.get('GMODEL-6'));
        
        return mapFLM_Attribute2;
    }
    
    public Map<String, String> GetAttributeMapQuoteDescription()
    {
        Map<String, String> quoteAttriVsDesc = new Map<String, String>();
        if(mapFA_Attribute.size() > 0)
        {
            List<String> quoteKey = new List<String>((mapFA_Attribute).Keyset());
            quoteKey.sort();
            for(String mapKey: quoteKey)
            {
              //  System.debug('*** mapKey = '+mapKey+', mapFA_Attribute = '+mapFA_Attribute.get(mapKey));
                if(mapKey.startsWithIgnoreCase('O') || mapKey.startsWithIgnoreCase('PC'))
                {
                    quoteAttriVsDesc.put(mapKey,mapFA_Attribute.get(mapKey));
                }
            }
        }
        return quoteAttriVsDesc;
    }
   
    public string OBs{
        get{
            string OBelements='';
            if(mapFA_Attribute.size() > 0)
            {
                List<String> quoteKey = new List<String>((mapFA_Attribute).Keyset());
                quoteKey.sort();
                for(String mapKey: quoteKey)
                {
                    //System.debug('*** mapKey = '+mapKey+', mapRV_Attribute = '+mapRV_Attribute.get(mapKey));
                    if(mapKey.startsWithIgnoreCase('OB'))
                    {
                        System.debug('Mapppppp' +mapFA_Attribute);
                        if(mapFA_Attribute.get(mapKey)!=null)
                            OBelements += '\n' + mapFA_Attribute.get(mapKey);
                        else
                            OBelements += '\n' +'';
                        System.debug('OBelements' +OBelements);
                    }
                }
            }
            if(OBelements!=null)
                return OBelements;
            else
                return ' ';
        }
        set{
            this.OBs=value;
        }
    }
    
    public string OAs{
        get{
            string OBelements='';
            if(mapFA_Attribute.size() > 0)
            {
                List<String> quoteKey = new List<String>((mapFA_Attribute).Keyset());
                quoteKey.sort();
                for(String mapKey: quoteKey)
                {
                    //System.debug('*** mapKey = '+mapKey+', mapRV_Attribute = '+mapRV_Attribute.get(mapKey));
                    if(mapKey.startsWithIgnoreCase('OA'))
                    {
                        if(mapFA_Attribute.get(mapKey)!=null)
                            OBelements += '\n' + mapFA_Attribute.get(mapKey);
                        else
                            OBelements += '\n' +'';
                        System.debug('OBelements' +OBelements);
                    }
                }
            }
            if(OBelements!=null)
                return OBelements;
            else
                return ' ';
        }
        set{
            this.OAs=value;
        }
    }
    
    public string OWs{
        get{
            string OBelements='';
            if(mapFA_Attribute.size() > 0)
            {
                List<String> quoteKey = new List<String>((mapFA_Attribute).Keyset());
                quoteKey.sort();
                for(String mapKey: quoteKey)
                {
                    //System.debug('*** mapKey = '+mapKey+', mapRV_Attribute = '+mapRV_Attribute.get(mapKey));
                    if(mapKey.startsWithIgnoreCase('OW'))
                    {
                        if(mapFA_Attribute.get(mapKey)!=null)
                            OBelements += '\n' + mapFA_Attribute.get(mapKey);
                        else
                            OBelements += '\n' +'';
                        System.debug('OBelements' +OBelements);
                    }
                }
            }
            if(OBelements!=null)
                return OBelements;
            else
                return ' ';
        }
        set{
            this.OWs=value;
        }
    }
  
  /***** Lookup Attributes start here ******/
  
  public string ASSEMBLYWT{ 
    get {
            return mapFA_Attribute.get('ASSEMBLYWT')==null?'': mapFA_Attribute.get('ASSEMBLYWT');  
        }
    set {
            this.ASSEMBLYWT= value;
        }
    }
    public string ASSEMBLYWTUOM{ 
        get {
                return mapFA_Attribute.get('ASSEMBLYWTUOM')==null?'': mapFA_Attribute.get('ASSEMBLYWTUOM');     
            }
        set {
                this.ASSEMBLYWTUOM= value;
            }
        }
    public string ASYTYP{ 
        get {
                if(mapFA_Attribute!=null)
                return mapFA_Attribute.get('ASYTYP')==null?'': mapFA_Attribute.get('ASYTYP'); 
             else
                 return ' ';     
            }
        set {
                this.ASYTYP= value;
            }
        }
    public string ATTRTEMPLATE{ 
        get {
                return mapFA_Attribute.get('ATTRTEMPLATE')==null?'': mapFA_Attribute.get('ATTRTEMPLATE');      
            }
        set {
                this.ATTRTEMPLATE= value;
            }
        }
    public string COMPDESCRIPTION{ 
        get {
                return mapFA_Attribute.get('COMPDESCRIPTION')==null?'': mapFA_Attribute.get('COMPDESCRIPTION');      
            }
        set {
                this.COMPDESCRIPTION= value;
            }
        }
    public string COMPINVSERTRK{ 
        get {
                return mapFA_Attribute.get('COMPINVSERTRK')==null?'': mapFA_Attribute.get('COMPINVSERTRK');      
            }
        set {
                this.COMPINVSERTRK= value;
            }
        }
    public string COMPLOTTRACK{ 
        get {
                return mapFA_Attribute.get('COMPLOTTRACK')==null?'': mapFA_Attribute.get('COMPLOTTRACK');      
            }
        set {
                this.COMPLOTTRACK= value;
            }
        }
    public string COMPPROVIDE{ 
        get {
                return mapFA_Attribute.get('COMPPROVIDE')==null?'': mapFA_Attribute.get('COMPPROVIDE');      
            }
        set {
                this.COMPPROVIDE= value;
            }
        }
    public string COMPRESPONID{ 
        get {
                return mapFA_Attribute.get('COMPRESPONID')==null?'': mapFA_Attribute.get('COMPRESPONID');      
            }
        set {
                this.COMPRESPONID= value;
            }
        }
    public string CUSTOMSTATNO{ 
        get {
                return mapFA_Attribute.get('CUSTOMSTATNO')==null?'': mapFA_Attribute.get('CUSTOMSTATNO');      
            }
        set {
                this.CUSTOMSTATNO= value;
            }
        }
    public string DesignOutlet{ 
        get {
                return mapFA_Attribute.get('DesignOutlet')==null?'': mapFA_Attribute.get('DesignOutlet');      
            }
        set {
                this.DesignOutlet= value;
            }
        }
    public string FBASSY{ 
        get {
                return mapFA_Attribute.get('FBASSY')==null?'': mapFA_Attribute.get('FBASSY');  
    
            }
        set {
                this.FBASSY= value;
            }
        }
    public string GMODEL1{ 
        get {
                return mapFA_Attribute.get('GMODEL-1')==null?'': mapFA_Attribute.get('GMODEL-1');     
            }
        set {
                this.GMODEL1= value;
            }
        }
    public string GMODEL2{ 
        get {
                return mapFA_Attribute.get('GMODEL-2')==null?'': mapFA_Attribute.get('GMODEL-2');      
            }
        set {
                this.GMODEL2= value;
            }
        }
    public string GMODEL3{ 
        get {
                return mapFA_Attribute.get('GMODEL-3')==null?'': mapFA_Attribute.get('GMODEL-3');      
            }
        set {
                this.GMODEL3= value;
            }
        }
    public string GMODEL4{ 
        get {
                return mapFA_Attribute.get('GMODEL-4')==null?'': mapFA_Attribute.get('GMODEL-4');      
            }
        set {
                this.GMODEL4= value;
            }
        }
    public string GMODEL5{ 
        get {
                return mapFA_Attribute.get('GMODEL-5')==null?'': mapFA_Attribute.get('GMODEL-5');      
            }
        set {
                this.GMODEL5= value;
            }
        }
    public string GMODEL6{ 
        get {
                return mapFA_Attribute.get('GMODEL-6')==null?'': mapFA_Attribute.get('GMODEL-6');      
            }
        set {
                this.GMODEL6= value;
            }
        }
    public string GPFACE{ 
        get {
            if(mapFA_Attribute!=null)
                return mapFA_Attribute.get('GPFACE')==null?'': mapFA_Attribute.get('GPFACE'); 
             else
                 return ' ';     
            }
        set {
                this.GPFACE= value;
            }
        }
    public string GTAG01{ 
        get {
                return mapFA_Attribute.get('GTAG01')==null?'': mapFA_Attribute.get('GTAG01');      
            }
        set {
                this.GTAG01= value;
            }
        }
    public string GTAG04{ 
        get {
                return mapFA_Attribute.get('GTAG04')==null?'': mapFA_Attribute.get('GTAG04');      
            }
        set {
                this.GTAG04= value;
            }
        }
    public string GTAG05{ 
        get {
                return mapFA_Attribute.get('GTAG05')==null?'': mapFA_Attribute.get('GTAG05');      
            }
        set {
                this.GTAG05= value;
            }
        }
    public string GTAG06{ 
        get {
                return mapFA_Attribute.get('GTAG06')==null?'': mapFA_Attribute.get('GTAG06');      
            }
        set {
                this.GTAG06= value;
            }
        }
    public string GTAG14{ 
        get {
                return mapFA_Attribute.get('GTAG14')==null?'': mapFA_Attribute.get('GTAG14');      
            }
        set {
                this.GTAG14= value;
            }
        }
    public string GTAG15{ 
        get {
                return mapFA_Attribute.get('GTAG15')==null?'': mapFA_Attribute.get('GTAG15');      
            }
        set {
                this.GTAG15= value;
            }
        }
    public string GTAG16{ 
        get {
                return mapFA_Attribute.get('GTAG16')==null?'': mapFA_Attribute.get('GTAG16');      
            }
        set {
                this.GTAG16= value;
            }
        }
    public string GTAG17{ 
        get {
                return mapFA_Attribute.get('GTAG17')==null?'': mapFA_Attribute.get('GTAG17');      
            }
        set {
                this.GTAG17= value;
            }
        }
    public string GTAGPN{ 
        get {
                return mapFA_Attribute.get('GTAGPN')==null?'': mapFA_Attribute.get('GTAGPN');      
            }
        set {
                this.GTAGPN= value;
            }
        }
    // Support Ticket# 161412 for lookup attribute RTPRS1 and RTPRSU, 03-FEB-2021
    public string RTPRS1{ 
            get {
                    return mapFA_Attribute.get('RTPRS1')==null?'': mapFA_Attribute.get('RTPRS1');      
                }
            set {
                    this.RTPRS1= value;
                }
    }

    public string RTPRSU{ 
        get {
                return mapFA_Attribute.get('RTPRSU')==null?'': mapFA_Attribute.get('RTPRSU');      
            }
        set {
                this.RTPRSU= value;
            }
    }

    public string HSNSACCODE{ 
        get {
                return mapFA_Attribute.get('HSNSACCODE')==null?'': mapFA_Attribute.get('HSNSACCODE');      
            }
        set {
                this.HSNSACCODE= value;
            }
        }
    public string IINO{ 
        get {
                return mapFA_Attribute.get('IINO')==null?'': mapFA_Attribute.get('IINO');      
            }
        set {
                this.IINO= value;
            }
        }
    public string INHOUSEPAINT{ 
        get {
                return mapFA_Attribute.get('INHOUSEPAINT')==null?'': mapFA_Attribute.get('INHOUSEPAINT');      
            }
        set {
                this.INHOUSEPAINT= value;
            }
        }
    public string LOTTRACKCODE{ 
        get {
                return mapFA_Attribute.get('LOTTRACKCODE')==null?'': mapFA_Attribute.get('LOTTRACKCODE');      
            }
        set {
                this.LOTTRACKCODE= value;
            }
        }
    public string PARTCLASS{ 
        get {
                return mapFA_Attribute.get('PARTCLASS')==null?'': mapFA_Attribute.get('PARTCLASS');      
            }
        set {
                this.PARTCLASS= value;
            }
        }
    public string PARTUOM{ 
        get {
                return mapFA_Attribute.get('PARTUOM')==null?'': mapFA_Attribute.get('PARTUOM');      
            }
        set {
                this.PARTUOM= value;
            }
        }
    public string PLANNER{ 
        get {
                return mapFA_Attribute.get('PLANNER')==null?'': mapFA_Attribute.get('PLANNER');      
            }
        set {
                this.PLANNER= value;
            }
        }
    public string PNGPFACE{ 
        get {
                return mapFA_Attribute.get('PNGPFACE')==null?'': mapFA_Attribute.get('PNGPFACE');      
            }
        set {
                this.PNGPFACE= value;
            }
        }
    public string PNMODEL{ 
        get {
                return mapFA_Attribute.get('PNMODEL')==null?'': mapFA_Attribute.get('PNMODEL');      
            }
        set {
                this.PNMODEL= value;
            }
        }
    public string PROVIDE{ 
        get {
                return mapFA_Attribute.get('PROVIDE')==null?'': mapFA_Attribute.get('PROVIDE');      
            }
        set {
                this.PROVIDE= value;
            }
        }
    public string RESPONSIBLE_ID{ 
        get {
                return mapFA_Attribute.get('RESPONSIBLE_ID')==null?'': mapFA_Attribute.get('RESPONSIBLE_ID');      
            }
        set {
                this.RESPONSIBLE_ID= value;
            }
        }
    public string SALESGROUP{ 
        get {
                return mapFA_Attribute.get('SALESGROUP')==null?'': mapFA_Attribute.get('SALESGROUP');      
            }
        set {
                this.SALESGROUP= value;
            }
        }
    public string SALESPRICEGROUP{ 
        get {
                return mapFA_Attribute.get('SALESPRICEGROUP')==null?'': mapFA_Attribute.get('SALESPRICEGROUP');     
            }
        set {
                this.SALESPRICEGROUP= value;
            }
        }
    public string SERIALTRACKCODE{ 
        get {
                return mapFA_Attribute.get('SERIALTRACKCODE')==null?'': mapFA_Attribute.get('SERIALTRACKCODE');      
            }
        set {
                this.SERIALTRACKCODE= value;
            }
        }
    public decimal SHLTSTBDYPSIG{ 
        get {
                string strSHLTSTBDYPSIG='';
                if(mapFA_Attribute!=null)
                {
                    decimal decSHLTSTBDYPSIG=0.0;
                    strSHLTSTBDYPSIG=mapFA_Attribute.get('SHLTSTBDYPSIG')==null?'': mapFA_Attribute.get('SHLTSTBDYPSIG'); 
                    System.debug('strSHLTSTBDYPSIG' +strSHLTSTBDYPSIG);
                    if(String.isNotBlank(strSHLTSTBDYPSIG))
                    	decSHLTSTBDYPSIG=decimal.valueOf(strSHLTSTBDYPSIG);
                    else
                        decSHLTSTBDYPSIG=0.0;
                    if(decSHLTSTBDYPSIG!=null)
                        return decSHLTSTBDYPSIG;
                    else
                        return 0.0;
                }
                else
                    return 0.0;
            }
        set {
                this.SHLTSTBDYPSIG= value;
            }
        }
    public string SOURCINGOPT{ 
        get {
                return mapFA_Attribute.get('SOURCINGOPT')==null?'': mapFA_Attribute.get('SOURCINGOPT');                 
            }
        set {
                this.SOURCINGOPT= value;
            }
        }

    public string VendorPaint{ 
        get {    
              if(mapFA_Attribute!=null)
                  return  mapFA_Attribute.get('VENDORPAINT')==null?'': mapFA_Attribute.get('VENDORPAINT');  
              else
                  return ' ';
            }
        set {
                this.VendorPaint= value;
            }
        }
    
    public string PRDLIN{ 
        get {    
              if(mapFA_Attribute!=null)
                  return  mapFA_Attribute.get('PRDLIN')==null?'': mapFA_Attribute.get('PRDLIN');  
              else
                  return ' ';
            }
        set {
                this.PRDLIN= value;
            }
        }
    
          
  /********Lookup Attributes  end here *******/

   //ASSYPARTNO
    public string ASSYPARTNO{
        get{
            if(flmprod.Part_Number__c!=null)
                return flmprod.Part_Number__c;
            else if(flmprod.ASSYPARTEXISTING__c!=null)
                return flmprod.ASSYPARTEXISTING__c;
          //  else if(flmprod.ASSYPARTNO__c!=null)
          //      return flmprod.ASSYPARTNO__c;
            else if(flmprod.Part_Number_Base__c!=null)
                return flmprod.Part_Number_Base__c + '_____';
            else
                return '';                
        }
        set{
            this.ASSYPARTNO=value;
        }
    }  
    
    
   // PC Elements 
    public string PC410{ 
        get {
                return mapFA_Attribute.get('PC410')==null?'': mapFA_Attribute.get('PC410');      
            }
        set {
                this.PC410= value;
            }
        }
    
    public string PC411{ 
        get {
                return mapFA_Attribute.get('PC411')==null?'': mapFA_Attribute.get('PC411');      
            }
        set {
                this.PC411= value;
            }
        }
    
    public string PC420{ 
        get {
                return mapFA_Attribute.get('PC420')==null?'': mapFA_Attribute.get('PC420');      
            }
        set {
                this.PC420= value;
            }
        }
    
    public string PC421{ 
        get {
                return mapFA_Attribute.get('PC421')==null?'': mapFA_Attribute.get('PC421');      
            }
        set {
                this.PC421= value;
            }
        }
    
    public string PC430{ 
        get {
                return mapFA_Attribute.get('PC430')==null?'': mapFA_Attribute.get('PC430');      
            }
        set {
                this.PC430= value;
            }
        }
    
    public string PC431{ 
        get {
                return mapFA_Attribute.get('PC431')==null?'': mapFA_Attribute.get('PC431');      
            }
        set {
                this.PC431= value;
            }
        }
   
    public string PC440{ 
        get {
                return mapFA_Attribute.get('PC440')==null?'': mapFA_Attribute.get('PC440');      
            }
        set {
                this.PC440= value;
            }
        }
    
    public string PC441{ 
        get {
                return mapFA_Attribute.get('PC441')==null?'': mapFA_Attribute.get('PC441');      
            }
        set {
                this.PC441= value;
            }
        }
     
    
  /***********  Equation Methods start here*********/
    
    public decimal AtmPresPSIA{ 
        get {
            //ConvertPressure (AtmPres, AtmPresUOM, "psia")
            if(flmprod.Converted_Atmospheric_Pressure__c!=null)          
                return flmprod.Converted_Atmospheric_Pressure__c;
            else
                return 0.0;
            }
        set {
                this.AtmPresPSIA= value;
            }
        }
    
    public decimal CriticalPresRatio{ 
        get {
            //( 2 / (K + 1) ) ^ (K / (K - 1) )
                if(K!=null)
                {
                     decimal decbase=(2/(K+1));
                     decimal decexp=(K/(K-1));
                     decimal decCriticalPresRatio=0.0;
                     decCriticalPresRatio=math.pow(double.valueOf(decbase),double.valueOf(decexp));
                     if(decCriticalPresRatio!=null)
                         return decCriticalPresRatio;
                     else
                         return 0.0;
                 }                 
                     return 0.0;
            }
        set {
                this.CriticalPresRatio= value;
            }
        }
    
    public decimal FlowPresPSIG{ 
        get {
            //ConvertPressure (FlowPres, FlowPresUOM, "psig")
              if(flmprod.Converted_Pressure_of_flowing_Vapor__c!=null)          
                    return flmprod.Converted_Pressure_of_flowing_Vapor__c;
              else
                    return 0.0;
            }
        set {
                this.FlowPresPSIG= value;
            }
        }
    
    public decimal FlowTempDEGR{ 
        get {
            //ConvertTemperature (FlowTemp, FlowTempUOM, "Deg R")
                if(flmprod.Converted_Temprature_of_flowing_Vapor__c!=null)          
                    return flmprod.Converted_Temprature_of_flowing_Vapor__c;
                else
                    return 0.0;
            }
        set {
                this.FlowTempDEGR= value;
            }
        }
    
    public string GINLOP{ 
        get {
               return GINLOP_OptA + GINLOP_OptB + GINLOP_OptC;
            }
        set {
                this.GINLOP= value;
            }
        }
    
    public string GMODEL{ 
        get {
              return GMODEL1 + GMODEL2 + GMODEL3 + GMODEL4 + GMODEL5 + GMODEL6 + GMODEL7;
            }
        set {
                this.GMODEL= value;
            }
        }
    
    public string GMODEL7{ 
        get {
                if ( ATEX =='N' && CUTR =='N' && USCG =='N' && NACE =='N' && GPAINT =='0' && XRAY =='N' && FWLDP =='N' && 
                                PMI =='N' && LDP =='N' && USONICEXAM =='N' && MAGPARTEXAM =='N' && BRINHARDEXAM =='N' && CHARPYIMPEXAM =='N' && 
                                VISCASTEXAM =='N' && IGCEXAM =='N' && ASSYLOCATION =='00' && MATLSOURCE =='00' )
                    return '0';
                else
                    return 'Z';                 
            }
        set {
                this.GMODEL7= value;
            }
        }
    
    public string GOUTOP{ 
        get {
                return GOUTOP_OptA + GOUTOP_OptB + GOUTOP_OptC;
            }
        set {
                this.GOUTOP= value;
            }
        }
    
    public decimal InletFlowPresPSIA{ 
        get {
            //FlowPresPSIG + AtmPresPSIA + IF ( PressureSide = "Inlet", 0, MaxAlowdPresDropPSIG )
                decimal decInletFlowPresPSIA=0.0;
                decimal val=0.0;
                if(PressureSide=='Inlet')
                    val=0.0;
                else
                    val=MaxAlowdPresDropPSIG;
                
                decInletFlowPresPSIA=FlowPresPSIG + AtmPresPSIA + val;
                if(decInletFlowPresPSIA!=null)
                    return decInletFlowPresPSIA;
                else
                    return 0.0;
            
          //          return 0.0;
            }
        set {
                this.InletFlowPresPSIA= value;
            }
        }
    
    public decimal MaxAlowdPresDropPSIG{ 
        get {
            //ConvertPressure ( MaxAlowdPresDrop, MaxAlowdPresDropUOM, "psig" )
                if(flmprod.Converted_Max_Allowable_Pressure_Drop__c!=null)          
                    return flmprod.Converted_Max_Allowable_Pressure_Drop__c;
                else
                    return 0.0;
            }
        set {
                this.MaxAlowdPresDropPSIG= value;
            }
        }

    public decimal MinReqdFlowRateSCFH{ 
        get {
            //ConvertGasFlowRate ( MinReqdFlowRate, MinReqdFlowRateUOM, "SCFH", (FlowPresPSIG + AtmPresPSIA), MW, FlowTempDEGR, Z )
                     return 0.0;
            }
        set {
                this.MinReqdFlowRateSCFH= value;
            }
        }
    
    public string OA{ 
        get; 
        /*{
                if(flmprod.OA__c!=null)
                    return flmprod.OA__c;
                else
                    return ' ';
            }*/
        set {
                this.OA= value;
            }
        }
    
    public string OA01{ 
        get {
            //"Model: " & GMODEL
            if(GMODEL!=null)
                return 'Model:' + GMODEL;
            else
                return ' ' ;

        }
        set {
                this.OA01= value;
            }
        }
    
    public string OB{ 
        get; 
        /*{
                 if(flmprod.OB__c!=null)
                    return flmprod.OB__c;
                else
                    return ' ';
            }*/
        set {
                this.OB= value;
            }
        }
    
    public string OnEngrHoldFlag{ 
        get {
            //IF (List Price = 9999999, or List Price = 0, or LeadTime (for any Site) = 0 )  THEN "TRUE"
                     return ' ';
            }
        set {
                this.OnEngrHoldFlag= value;
            }
        }
    
    public decimal OpPresPSIA{ 
        get {
            //ConvertPressure (OpPres, OpPresUOM, "psia")
                if(flmprod.Converted_Operational_Pressure__c!=null)          
                    return flmprod.Converted_Operational_Pressure__c;
                else
                    return 0.0;
            }
        set {
                this.OpPresPSIA= value;
            }
        }
    
    public string OW{ 
        get; 
        /*{
                if(flmprod.OW__c!=null)
                    return flmprod.OW__c;
                else
                    return ' ';
            }*/
        set {
                this.OW= value;
            }
        }
    
    public string PC{ 
        get;
        /*{
                if(flmprod.PC__c!=null)
                    return flmprod.PC__c;
                else
                    return ' ';
            }*/
        set {
                this.PC= value;
            }
        }
    
    public decimal PresRatio{ 
        get {
            //( InletFlowPresPSIA - MaxAlowdPresDropPSIG ) / InletFlowPresPSIA
                decimal decPresRatio=0.0;
                if(InletFlowPresPSIA!=0.0)
                    decPresRatio=( InletFlowPresPSIA - MaxAlowdPresDropPSIG ) / InletFlowPresPSIA;
                if(decPresRatio!=null)
                    return decPresRatio;
                else
                    return 0.0; 
            //  return 0.0;
            }
        set {
                this.PresRatio= value;
            }
        }
    
    public decimal RunUpLengthAIn{ 
        get {
            //ConvertDistance ( RunUpLengthA, RunUpLengthAUOM, "in" )
                if(flmprod.Converted_Run_up_Length_A__c!=null)          
                    return flmprod.Converted_Run_up_Length_A__c;
                else
                    return 0.0;
            }
        set {
                this.RunUpLengthAIn= value;
            }
        }
    
    public decimal RunUpLengthBIn{ 
        get {
            //ConvertDistance ( RunUpLengthB, RunUpLengthBUOM, "in" )
                if(flmprod.Converted_Run_up_Length_B__c!=null)          
                    return flmprod.Converted_Run_up_Length_B__c;
                else
                    return 0.0;
            }
        set {
                this.RunUpLengthBIn= value;
            }
        }
    
    public decimal ShlTstBdyPSIGMx{ 
        get {
                //SignificantDigitsDown ( ShlTstBdyPSIG * 1.1, 1, -99)
            	decimal decShlTstBdyPSIGMx=0.0;
                decimal res2=0.0;
                res2=unitConversions.RoundDown(ShlTstBdyPSIG * 1.1,0);   //SignificantDigitsDown(SHLTSTBDYPSIG * 1.1,1,-99);
                decShlTstBdyPSIGMx=res2;
            	if(decShlTstBdyPSIGMx!=null)
                    return decShlTstBdyPSIGMx;
            	else
                    return 0.0;
            }
        set {
                this.ShlTstBdyPSIGMx= value;
            }
        }
    
    public string UOMSystem{ 
        get {
            //IF (OR (ATEX="Y", CUTR="Y", HCLASS="B", HCLASS="C" ), "SI", "USC" )
             if(ATEX=='Y' || CUTR=='Y'|| HCLASS=='B' || HCLASS=='C')
                    return 'SI';
             else
                    return 'USC';
            }
        set {
                this.UOMSystem= value;
            }
        }

    /********** Equation Methods End here ******/
    
    /******** Getters setters start here*******/
    
    public string PTC{
        get{
            if(FLMProd.PTC__c!=null)
                return FLMProd.PTC__c;
            else
                return ' ';            
        }
        set{
            this.PTC=value;
        }
    }
   
    public string SZC{
        get{
            if(FLMProd.Size__c!=null)
                return FLMProd.Size__c;
            else
                return ' ';              
        }
        set{
            this.SZC=value;
        }
    }
    
    public string ESZC{
        get{
            if(FLMProd.ESZC__c!=null)
                return FLMProd.ESZC__c;
            else
                return ' ';                 
        }
        set{
            this.ESZC=value;
        }
    }
    
    public string MCELEM{
        get{
            return flmprod.Element_Material__c;            
        }
        set{
            this.MCELEM=value;
        }
    }
    
/*    public string VendorPaint{
        get{
            return ' ';            
        }
        set{
            this.VendorPaint=value;
        }
    }*/
    
    public string SHLTSTMETHBDY{
        get{
            return ' ';            
        }
        set{
            this.SHLTSTMETHBDY=value;
        }
    }
    
    public string Model{
        get{
            return flmprod.PTC__c;            
        }
        set{
            this.Model=value;
        }
    }
    /******** Getters setters end here*******/
    
   
    
    /******* Input Getters and Setters starts here ********/

    public string ASSYLOCATION{ 
        get {
                if(FLMProd.Final_Assembly_Location_Requirements__c!=null)
                    return FLMProd.Final_Assembly_Location_Requirements__c;
                else
                    return ' ';
            }
        set {
                this.ASSYLOCATION= value;
            }
        }
    public string ATEX{ 
        get {
                if(FLMProd.Atex_Certificate_2014_34_EU__c!=null)
                    return FLMProd.Atex_Certificate_2014_34_EU__c;
                else
                    return ' ';
            }
        set {
                this.ATEX= value;
            }
        }
    public decimal AtmPres{ 
        get {
                if(FLMProd.Atmospheric_Pressure__c!=null)
                    return FLMProd.Atmospheric_Pressure__c;
                else
                    return 0.0;
            }
        set {
                this.AtmPres= value;
            }
        }
    public string AtmPresUOM{ 
        get {
                if(FLMProd.Atmospheric_Pressure_Units__c!=null)
                    return FLMProd.Atmospheric_Pressure_Units__c;
                else
                    return ' ';
            }
        set {
                this.AtmPresUOM= value;
            }
        }
    public string BRAND{ 
        get {
                if(FLMProd.Brand__c!=null)
                    return FLMProd.Brand__c;
                else
                    return ' ';
            }
        set {
                this.BRAND= value;
            }
        }
    public string BRINHARDEXAM{ 
        get {
                if(FLMProd.Brinell_hardness_examination__c!=null)
                    return FLMProd.Brinell_hardness_examination_Backend__c;
                else
                    return ' ';
            }
        set {
                this.BRINHARDEXAM= value;
            }
        }
    public string CHARPYIMPEXAM{ 
        get {
                if(FLMProd.Charpy_Impact_Testing__c!=null)
                    return FLMProd.Charpy_Impact_Testing_Backend__c;
                else
                    return ' ';
            }
        set {
                this.CHARPYIMPEXAM= value;
            }
        }
    public string CUTR{ 
        get {
                if(FLMProd.CU_TR__c!=null)
                    return FLMProd.CU_TR__c;
                else
                    return ' ';
            }
        set {
                this.CUTR= value;
            }
        }
    public string DPM{ 
        get {
                if(FLMProd.Flowing_Media__c!=null)
                    return FLMProd.Flowing_Media__c;
                else
                    return ' ';
            }
        set {
                this.DPM= value;
            }
        }
    public string EndCondition{ 
        get {
                if(FLMProd.Pipe_Design__c!=null)
                    return FLMProd.Pipe_Design__c;
                else
                    return ' ';
            }
        set {
                this.EndCondition= value;
            }
        }
    public string FlameType{ 
        get {
                if(FLMProd.Arrester_for_Detonation_or_Deflagration__c!=null)
                    return FLMProd.Arrester_for_Detonation_or_Deflagration__c;
                else
                    return ' ';
            }
        set {
                this.FlameType= value;
            }
        }
    public decimal FlowPres{ 
        get {
                if(FLMProd.Pressure_of_flowing_Vapor__c!=null)
                    return FLMProd.Pressure_of_flowing_Vapor__c;
                else
                    return 0.0;
            }
        set {
                this.FlowPres= value;
            }
        }
    public string FlowPresUOM{ 
        get {
                if(FLMProd.Pressure_of_flowing_Vapor_Units__c!=null)
                    return FLMProd.Pressure_of_flowing_Vapor_Units__c;
                else
                    return ' ';
            }
        set {
                this.FlowPresUOM= value;
            }
        }
    public decimal FlowTemp{ 
        get {
                if(FLMProd.Temperature_of_flowing_Vapor__c!=null)
                    return FLMProd.Temperature_of_flowing_Vapor__c;
                else
                    return 0.0;
            }
        set {
                this.FlowTemp= value;
            }
        }
    public string FlowTempUOM{ 
        get {
                if(FLMProd.Temperature_of_flowing_Vapor_Units__c!=null)
                    return FLMProd.Temperature_of_flowing_Vapor_Units__c;
                else
                    return ' ';
            }
        set {
                this.FlowTempUOM= value;
            }
        }
    public string FWLDP{ 
        get {
                if(FLMProd.Fillet_Weld_Liquid_Dye_Penetrant__c!=null)
                    return FLMProd.Fillet_Weld_Liquid_Dye_Penetrant_Backend__c;
                else
                    return ' ';
            }
        set {
                this.FWLDP= value;
            }
        }
    public string GINLOP_OptA{ 
        get {
                if(FLMProd.Inlet_Option_A__c!=null)
                    return FLMProd.Inlet_Option_A__c;
                else
                    return ' ';
            }
        set {
                this.GINLOP_OptA= value;
            }
        }
    public string GINLOP_OptB{ 
        get {
                if(FLMProd.Inlet_Option_B__c!=null)
                    return FLMProd.Inlet_Option_B__c;
                else
                    return ' ';
            }
        set {
                this.GINLOP_OptB= value;
            }
        }
    public string GINLOP_OptC{ 
        get {
                if(FLMProd.Inlet_Option_C__c!=null)
                    return FLMProd.Inlet_Option_C__c;
                else
                    return ' ';
            }
        set {
                this.GINLOP_OptC= value;
            }
        }
    public string GOUTOP_OptA{ 
        get {
                if(FLMProd.Outlet_Option_A__c!=null)
                    return FLMProd.Outlet_Option_A__c;
                else
                    return ' ';
            }
        set {
                this.GOUTOP_OptA= value;
            }
        }
    public string GOUTOP_OptB{ 
        get {
                if(FLMProd.Outlet_Option_B__c!=null)
                    return FLMProd.Outlet_Option_B__c;
                else
                    return ' ';
            }
        set {
                this.GOUTOP_OptB= value;
            }
        }
    public string GOUTOP_OptC{ 
        get {
                if(FLMProd.Outlet_Option_C__c!=null)
                    return FLMProd.Outlet_Option_C__c;
                else
                    return ' ';
            }
        set {
                this.GOUTOP_OptC= value;
            }
        }
    public string GPAINT{ 
        get {
                if(FLMProd.Painting_Coating_Option__c!=null)
                    return FLMProd.Painting_Coating_Option__c;
                else
                    return ' ';
            }
        set {
                this.GPAINT= value;
            }
        }
    public string HCLASS{ 
        get {
                if(FLMProd.Drilling__c!=null)
                    return FLMProd.Drilling__c;
                else
                    return ' ';
            }
        set {
                this.HCLASS= value;
            }
        }
    public string IGCEXAM{ 
        get {
                if(FLMProd.Intergranular_Corossion_Test__c!=null)
                    return FLMProd.Intergranular_Corossion_Test_Backend__c;
                else
                    return ' ';
            }
        set {
                this.IGCEXAM= value;
            }
        }
    public decimal K{ 
        get {
                if(FLMProd.Ratio_of_Specific_Heats__c!=null)
                    return FLMProd.Ratio_of_Specific_Heats__c;
                else
                    return 0.0;
            }
        set {
                this.K= value;
            }
        }
    public string LDP{ 
        get {
                if(FLMProd.Liquid_Dye_Penetrant__c!=null)
                    return FLMProd.Liquid_Dye_Penetrant__c;
                else
                    return ' ';
            }
        set {
                this.LDP= value;
            }
        }
    public string MAGPARTEXAM{ 
        get {
                if(FLMProd.Magnetic_Particle_Examination__c!=null)
                    return FLMProd.Magnetic_Particle_Examination_Backend__c;
                else
                    return ' ';
            }
        set {
                this.MAGPARTEXAM= value;
            }
        }
    public string MATLSOURCE{ 
        get {
                if(FLMProd.Material_Sourcing_Requirements__c!=null)
                    return FLMProd.Material_Sourcing_Requirements__c;
                else
                    return ' ';
            }
        set {
                this.MATLSOURCE= value;
            }
        }
    public decimal MaxAlowdPresDrop{ 
        get {
                if(FLMProd.Max_Allowable_Pressure_Drop__c!=null)
                    return FLMProd.Max_Allowable_Pressure_Drop__c;
                else
                    return 0.0;
            }
        set {
                this.MaxAlowdPresDrop= value;
            }
        }
    public string MaxAlowdPresDropUOM{ 
        get {
                if(FLMProd.Max_Allowable_Pressure_Drop_Units__c!=null)
                    return FLMProd.Max_Allowable_Pressure_Drop_Units__c;
                else
                    return ' ';
            }
        set {
                this.MaxAlowdPresDropUOM= value;
            }
        }
    public string MCBODY{ 
        get {
                if(FLMProd.Body_Material__c!=null)
                    return FLMProd.Body_Material__c;
                else
                    return ' ';
            }
        set {
                this.MCBODY= value;
            }
        }
    public string MCDPHM{ 
        get {
                if(FLMProd.Diaphragm_Material__c!=null)
                    return FLMProd.Diaphragm_Material__c;
                else
                    return ' ';
            }
        set {
                this.MCDPHM= value;
            }
        }
    public string MCELMT{ 
        get {
                if(FLMProd.Element_Material__c!=null)
                    return FLMProd.Element_Material__c;
                else
                    return ' ';
            }
        set {
                this.MCELMT= value;
            }
        }
    public string MCHOUS{ 
        get {
                if(FLMProd.Housing_Material__c!=null)
                    return FLMProd.Housing_Material__c;
                else
                    return ' ';
            }
        set {
                this.MCHOUS= value;
            }
        }
    public string MCPALL{ 
        get {
                if(FLMProd.Pallet_Material__c!=null)
                    return FLMProd.Pallet_Material__c;
                else
                    return ' ';
            }
        set {
                this.MCPALL= value;
            }
        }
    public string MediaName{ 
        get {
                if(FLMProd.Media_Name__c!=null)
                    return FLMProd.Media_Name__c;
                else
                    return ' ';
            }
        set {
                this.MediaName= value;
            }
        }
    public decimal MinReqdFlowRate{ 
        get {
                if(FLMProd.Required_Flow_Rate__c!=null)
                    return FLMProd.Required_Flow_Rate__c;
                else
                    return 0.0;
            }
        set {
                this.MinReqdFlowRate= value;
            }
        }
    public string MinReqdFlowRateUOM{ 
        get {
                if(FLMProd.Required_Flow_Rate_Units__c!=null)
                    return FLMProd.Required_Flow_Rate_Units__c;
                else
                    return ' ';
            }
        set {
                this.MinReqdFlowRateUOM= value;
            }
        }
    public string Mounting{ 
        get {
                if(FLMProd.Mounting__c!=null)
                    return FLMProd.Mounting__c;
                else
                    return ' ';
            }
        set {
                this.Mounting= value;
            }
        }
    public decimal MW{ 
        get {
                if(FLMProd.Molecular_Weight__c!=null)
                    return FLMProd.Molecular_Weight__c;
                else
                    return 0.0;
            }
        set {
                this.MW= value;
            }
        }
    public string NACE{ 
        get {
                if(FLMProd.NACE__c!=null)
                    return FLMProd.Nace_Backend__c;
                else
                    return ' ';
            }
        set {
                this.NACE= value;
            }
        }
    public string OffsetBases{ 
        get {
                if(FLMProd.Offset_or_Concentric_Bases__c!=null)
                    return FLMProd.Offset_or_Concentric_Bases__c;
                else
                    return ' ';
            }
        set {
                this.OffsetBases= value;
            }
        }
    public decimal OpPres{ 
        get {
                if(FLMProd.Operational_Pressure__c!=null)
                    return FLMProd.Operational_Pressure__c;
                else
                    return 0.0;
            }
        set {
                this.OpPres= value;
            }
        }
    public string OpPresUOM{ 
        get {
                if(FLMProd.Operational_Pressure_Units__c!=null)
                    return FLMProd.Operational_Pressure_Units__c;
                else
                    return ' ';
            }
        set {
                this.OpPresUOM= value;
            }
        }
    public string OpTemp{ 
        get {
                if(FLMProd.Operational_Temperature__c!=null)
                    return FLMProd.Operational_Temperature__c;
                else
                    return ' ';
            }
        set {
                this.OpTemp= value;
            }
        }
    public string PMI{ 
        get {
                if(FLMProd.Positive_Material_Identification__c!=null)
                    return FLMProd.Positive_Material_Identification__c;
                else
                    return ' ';
            }
        set {
                this.PMI= value;
            }
        }
    public string PressureSide{ 
        get {
                if(FLMProd.Location_of_Flowing_Pressure_Specificati__c!=null)
                    return FLMProd.Location_of_Flowing_Pressure_Specificati__c;
                else
                    return ' ';
            }
        set {
                this.PressureSide= value;
            }
        }
    public decimal ReqdGasGroupLevel{ 
        get {
                if(FLMProd.Gas_Group_Code__c!=null)
                    return FLMProd.Gas_Group_Code__c;
                else
                    return 0.0;
            }
        set {
                this.ReqdGasGroupLevel= value;
            }
        }
    
    public decimal RunUpLengthA{ 
        get {
                if(FLMProd.Run_Up_Length_A_Input__c!=null)
                    return FLMProd.Run_Up_Length_A_Input__c;
                else
                    return 0.0;
            }
        set {
                this.RunUpLengthA= value;
            }
        }
    public string RunUpLengthAUOM{ 
        get {
                if(FLMProd.Run_Up_Length_A_Input_Units__c!=null)
                    return FLMProd.Run_Up_Length_A_Input_Units__c;
                else
                    return ' ';
            }
        set {
                this.RunUpLengthAUOM= value;
            }
        }
    public decimal RunUpLengthB{ 
        get {
                if(FLMProd.Run_Up_Length_B_Input__c!=null)
                    return FLMProd.Run_Up_Length_B_Input__c;
                else
                    return 0.0;
            }
        set {
                this.RunUpLengthB= value;
            }
        }
    public string RunUpLengthBUOM{ 
        get {
                if(FLMProd.Run_Up_Length_B_Input_Units__c!=null)
                    return FLMProd.Run_Up_Length_B_Input_Units__c;
                else
                    return ' ';
            }
        set {
                this.RunUpLengthBUOM= value;
            }
        }
    public string SETTING{ 
        get {
                if(FLMProd.Pressure_Setting__c!=null)
                    return FLMProd.Pressure_Setting__c;
                else
                    return ' ';
            }
        set {
                this.SETTING= value;
            }
        }
    public string SPRING{ 
        get {
                if(FLMProd.Spring_Range__c!=null)
                    return FLMProd.Spring_Range__c;
                else
                    return ' ';
            }
        set {
                this.SPRING= value;
            }
        }
    public string USCG{ 
        get {
                if(FLMProd.US_Coast_guard__c!=null)
                    return FLMProd.US_Coast_guard__c;
                else
                    return ' ';
            }
        set {
                this.USCG= value;
            }
        }
    public string USONICEXAM{ 
        get {
                if(FLMProd.Ultrasonic_Examination__c!=null)
                    return FLMProd.Ultrasonic_Examination_Backend__c;
                else
                    return ' ';
            }
        set {
                this.USONICEXAM= value;
            }
        }
    public string VISCASTEXAM{ 
        get {
                if(FLMProd.Visual_Casting_Examination__c!=null)
                    return FLMProd.Visual_Casting_Examination_Backend__c;
                else
                    return ' ';
            }
        set {
                this.VISCASTEXAM= value;
            }
        }
    public string XRAY{ 
        get {
                if(FLMProd.Radiography__c!=null)
                    return FLMProd.Radiography__c;
                else
                    return ' ';
            }
        set {
                this.XRAY= value;
            }
        }
    public decimal Z{ 
        get {
                if(FLMProd.Compressibility_Factor__c!=null)
                    return FLMProd.Compressibility_Factor__c;
                else
                    return 0.0;
            }
        set {
                this.Z= value;
            }
        }

    
    /******* Input Getters and Setters ends here ********/
    
    // Master Blaster Attributes 
    public string GasGroupLevel{
        get{
            if(flmprod.GasGroupLevel_Backend__c!=null)
                return flmprod.GasGroupLevel_Backend__c;
            else
                return '';
        }
        set{
            this.GasGroupLevel=value;
        }
    }
    
    // XML Attribues
    public string PARTREV{
        get{
            if(flmprod.PARTREV__c!=null)
                return flmprod.PARTREV__c;
            else
                return '1';
        }
        set{
            this.PARTREV=value;
        }
    }
    
    public string DESCRIPTION{
        get{
            //IF the checkbox “Eng Override” on Quote description is checked THEN "Special" ELSE "" & BRAND & "Model: " & PTC & " " &
            // OA04 & ", " & OA05 & ", " & OB010 & ", " & OB020 & ", " & OB030 & ", " & OB040 & ", " & OB050 & ", " & OB110 & ", " 
            // & OB120 & ", " & OB210 & ", " & OB240
            string strDescription='';
            if(flmprod.Quote_Description_Engineer_Override__c==true)
                return 'Special';
            else
                { 
                    	strDescription='Model:';
                        strDescription=strDescription+' '+PTC+' ';
                        if(mapFA_Attribute.get('OA04')==null)
                            strDescription=strDescription+' ';
                        else
                            strDescription=strDescription+mapFA_Attribute.get('OA04')+' ';
                        
                        if(mapFA_Attribute.get('OA05')==null)
                            strDescription=strDescription+' ';
                        else
                            strDescription=strDescription+mapFA_Attribute.get('OA05')+' ';
                        
                        if(mapFA_Attribute.get('OB010')==null)
                            strDescription=strDescription+' ';
                        else
                            strDescription=strDescription+mapFA_Attribute.get('OB010')+' ';
                        
                        if(mapFA_Attribute.get('OB020')==null)
                            strDescription=strDescription+' ';
                        else
                            strDescription=strDescription+mapFA_Attribute.get('OB020')+' ';
                        
                        if(mapFA_Attribute.get('OB030')==null)
                            strDescription=strDescription+' ';
                        else
                            strDescription=strDescription+mapFA_Attribute.get('OB030')+' ';
                        
                        if(mapFA_Attribute.get('OB040')==null)
                            strDescription=strDescription+' ';
                        else
                            strDescription=strDescription+mapFA_Attribute.get('OB040')+' ';
                        
                        if(mapFA_Attribute.get('OB110')==null)
                            strDescription=strDescription+' ';
                        else
                            strDescription=strDescription+mapFA_Attribute.get('OB110')+' ';
                        
                        if(mapFA_Attribute.get('OB120')==null)
                            strDescription=strDescription+' ';
                        else
                            strDescription=strDescription+mapFA_Attribute.get('OB120')+' ';
                        
                        if(mapFA_Attribute.get('OB210')==null)
                            strDescription=strDescription+' ';
                        else
                            strDescription=strDescription+mapFA_Attribute.get('OB210')+' ';
                        
                        if(mapFA_Attribute.get('OB240')==null)
                            strDescription=strDescription+' ';
                        else
                            strDescription=strDescription+mapFA_Attribute.get('OB240');                    
                    if(strDescription!=null)
                        return strDescription;
                    else
                        return ' ';
                }
            } 
            set{
                this.DESCRIPTION=value;
            }
        }
    
    
   /******* Interface to IFS Attributes map  **********/
   
    public Map<string,string> getmapIFSAttr(){
        
                Map<String, string> myMap1 = new Map<String, String>();     
                    myMap1.put('ASSYLOCATION',ASSYLOCATION);
                    myMap1.put('ASYTYP',ASYTYP);
                    myMap1.put('ATEX',ATEX);
                    myMap1.put('BRINHARDEXAM',BRINHARDEXAM);
                    myMap1.put('CHARPYIMPEXAM',CHARPYIMPEXAM);
                    myMap1.put('CUTR',CUTR);
                    myMap1.put('ESZC',ESZC);
                    myMap1.put('FBASSY',FBASSY);
                    myMap1.put('FWLDP',FWLDP);
                    myMap1.put('GINLOP',GINLOP);
                    myMap1.put('GMODEL',GMODEL);
                    myMap1.put('GOUTOP',GOUTOP);
                    myMap1.put('GPAINT',GPAINT);
                    myMap1.put('GPFACE',GPFACE);
                    myMap1.put('GTAG01',GTAG01);
                    myMap1.put('GTAG04',GTAG04);
                    myMap1.put('GTAG05',GTAG05);
                    myMap1.put('GTAG06',GTAG06);
                    myMap1.put('GTAG14',GTAG14);
                    myMap1.put('GTAG15',GTAG15);
                    myMap1.put('GTAG16',GTAG16);
                    myMap1.put('GTAG17',GTAG17);
                    myMap1.put('GTAGPN',GTAGPN);
                    myMap1.put('HCLASS',HCLASS);
                    myMap1.put('IGCEXAM',IGCEXAM);
                    myMap1.put('IINO',IINO);
                    myMap1.put('LDP',LDP);
                    myMap1.put('MAGPARTEXAM',MAGPARTEXAM);
                    myMap1.put('MATLSOURCE',MATLSOURCE);
                    myMap1.put('MCBODY',MCBODY);
                    myMap1.put('MCDPHM',MCDPHM);
                    myMap1.put('MCELMT',MCELMT);
                    myMap1.put('MCHOUS',MCHOUS);
                    myMap1.put('MCPALL',MCPALL);
                    myMap1.put('NACE',NACE);
                    myMap1.put('OA',OA);
                    myMap1.put('OB',OB);
                    myMap1.put('OW',OW);
                    myMap1.put('PC',PC);
                    myMap1.put('PMI',PMI);
                    myMap1.put('PTC',PTC);
        			myMap1.put('PRDLIN',PRDLIN);
                    myMap1.put('SETTING',SETTING);
                    myMap1.put('SHLTSTBDYPSIG',string.valueOf(SHLTSTBDYPSIG));
                    myMap1.put('SHLTSTBDYPSIGMX',string.valueOf(SHLTSTBDYPSIGMX));
                    myMap1.put('SOURCINGOPT',SOURCINGOPT);
                    myMap1.put('SPRING',SPRING);
                    myMap1.put('SZC',SZC);
                    myMap1.put('USCG',USCG);
                    myMap1.put('USONICEXAM',USONICEXAM);
                    myMap1.put('VISCASTEXAM',VISCASTEXAM);
                    myMap1.put('XRAY',XRAY);
                  //  myMap1.put('PRDLIN',PRDLIN);
                    myMap1.put('RTPRS1',RTPRS1); // Support Ticket# 161412 for lookup attribute RTPRS1 , 03-FEB-2021
                    myMap1.put('RTPRSU',RTPRSU); // Support Ticket# 161412 for lookup attribute RTPRSU, 03-FEB-2021
                return myMap1;
    }   

    
 /********** Troubeshooting Attributes Map  **********/

        public Map<string,string> getmapTroubleShootAttr(){

                Map<String, string> myMap1 = new Map<String, String>(); 
                    myMap1.put('ASSEMBLYWT',ASSEMBLYWT);
                    myMap1.put('ASSEMBLYWTUOM',ASSEMBLYWTUOM);
                    myMap1.put('AtmPresPSIA',string.valueOf(AtmPresPSIA));
                    myMap1.put('ATTRTEMPLATE',ATTRTEMPLATE);
                    myMap1.put('COMPDESCRIPTION',COMPDESCRIPTION);
                    myMap1.put('COMPINVSERTRK',COMPINVSERTRK);
                    myMap1.put('COMPLOTTRACK',COMPLOTTRACK);
                    myMap1.put('COMPPROVIDE',COMPPROVIDE);
                    myMap1.put('COMPRESPONID',COMPRESPONID);
                    myMap1.put('CriticalPresRatio',string.valueOf(CriticalPresRatio));
                    myMap1.put('CUSTOMSTATNO',CUSTOMSTATNO);
                    myMap1.put('DesignOutlet',DesignOutlet);
                    myMap1.put('FlowPresPSIG',string.valueOf(FlowPresPSIG));
                    myMap1.put('FlowTempDEGR',string.valueOf(FlowTempDEGR));
                 //   myMap1.put('GasGroupLevel',string.valueOf(strGasGroupLevel)); 
                    myMap1.put('GasGroupLevel',GasGroupLevel);                                  
                    myMap1.put('GMODEL1',GMODEL1);
                    myMap1.put('GMODEL2',GMODEL2);
                    myMap1.put('GMODEL3',GMODEL3);
                    myMap1.put('GMODEL4',GMODEL4);
                    myMap1.put('GMODEL5',GMODEL5);
                    myMap1.put('GMODEL6',GMODEL6);
                    myMap1.put('GMODEL7',GMODEL7);
                    myMap1.put('HSNSACCODE',HSNSACCODE);
                    myMap1.put('INHOUSEPAINT',INHOUSEPAINT);
                    myMap1.put('InletFlowPresPSIA',string.valueOf(InletFlowPresPSIA));
                    myMap1.put('LOTTRACKCODE',LOTTRACKCODE);
                    myMap1.put('MaxAlowdPresDropPSIG',string.valueOf(MaxAlowdPresDropPSIG));
                    myMap1.put('MinReqdFlowRateSCFH',string.valueOf(MinReqdFlowRateSCFH));
                    myMap1.put('OnEngrHoldFlag',OnEngrHoldFlag);
                    myMap1.put('OpPresPSIA',string.valueOf(OpPresPSIA));
                    myMap1.put('PARTCLASS',PARTCLASS);
                    myMap1.put('PARTUOM',PARTUOM);
                    myMap1.put('PC410',PC410);
                    myMap1.put('PC411',PC411);
                    myMap1.put('PC420',PC420);
                    myMap1.put('PC421',PC421);
                    myMap1.put('PC430',PC430);
                    myMap1.put('PC431',PC431);
                    myMap1.put('PC440',PC440);
                    myMap1.put('PC441',PC441);  
                    myMap1.put('PLANNER',PLANNER);
                    myMap1.put('PNGPFACE',PNGPFACE);
                    myMap1.put('PNMODEL',PNMODEL);
                    myMap1.put('PresRatio',string.valueOf(PresRatio));
                    myMap1.put('PROVIDE',PROVIDE);
                    myMap1.put('RESPONSIBLE_ID',RESPONSIBLE_ID);
                    myMap1.put('RunUpLengthAIn',string.valueOf(RunUpLengthAIn));
                    myMap1.put('RunUpLengthBIn',string.valueOf(RunUpLengthBIn));
                    myMap1.put('SALESGROUP',SALESGROUP);
                    myMap1.put('SALESPRICEGROUP',SALESPRICEGROUP);
                    myMap1.put('SERIALTRACKCODE',SERIALTRACKCODE);
                    myMap1.put('UOMSystem',UOMSystem);
                    myMap1.put('VENDORPAINT',VendorPaint);
                    
                return myMap1;
    }   
   
    
    
}