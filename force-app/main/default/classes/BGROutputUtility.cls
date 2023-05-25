/************************************************************************
* Class Name: BGROutputUtility
* This class handles BGR Output
* This class provide details on BGR routing/Lead Time/Engg Part Details/
* Pricing details/Inventory Part Details/Sales Part Details etc.
* @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0        -              ApexIT                 Initial Version
 * 1.1      08-Mar-2021      Rohini Hathi           Support Ticket# 200454 
 * 1.2      08-Apr-2021      Rohini Hathi           Support Ticket# 200752, limit chars in desc field
************************************************************************/
public class BGROutputUtility implements HandlerInterface {
    /* Constructor which will take BGR ID as the Parameter and fetch all the fields which are used for OUTPUTS*/
    public BGROutputUtility (Id recordID) {
        system.debug('record id$$$'+recordID);
        currentBGR= (BGR__c) wizardBaseDataProcessor.getObjectDataById(recordID).objResultList[0];
        mapBGRAttr=new Map<String, string>(); 
        mapBGR_Attribute = new Map<String, String>();
        mapBGR_Attribute = getMapAttribute(); 
        
        string strRGEUNT;
        List<BGR_Attribute_lookup_Details__c> bgrAttributeDetails = [select Text__c from BGR_Attribute_lookup_Details__c 
        where Attribute__c=:'RGEUNT' and numval1__c<=:SETINWC and numval2__c>:SETINWC limit 1];
        if(bgrAttributeDetails.size() > 0) {
            
            strRGEUNT = bgrAttributeDetails[0].Text__c;
        }
        
        if(Test.isRunningTest() && strRGEUNT == null) {
             
            strRGEUNT = 'psig';
        }
        system.debug('strRGEUNT' +strRGEUNT);
        Result res1=new result();        
        res1=unitConversions.convertPressure(RTPRSU,strRGEUNT,currentBGR.Setting__c);
        conpressure=res1.dblRetValue;
        System.debug('conpressure inside constructor'+conpressure);
        
        List<BGR_Outputs__c> bgrOutputList = new List<BGR_Outputs__c>();
        String fieldsAPIname = FLMutility.getObjectFields('BGR_Outputs__c');    
        String soql = 'SELECT ' + fieldsAPIname +' FROM BGR_Outputs__c ';
        soql += ' WHERE BGR_Outputs_Relation_Field__c =\''+String.escapeSingleQuotes(currentBGR.Id)+'\' ';    
        System.debug('@Developer --> soql :' + soql);    
        bgrOutputList = Database.query(soql);
        if(bgrOutputList.size() > 0)
        {
            if(string.isNotBlank(bgrOutputList[0].OA_Override__c))
            {
                OA = bgrOutputList[0].OA_Override__c;
            }
            else
            {
               OA = currentBGR.OA__c; 
            }
            if(string.isNotBlank(bgrOutputList[0].OB_Override__c))
            {
                OB = bgrOutputList[0].OB_Override__c;
            }
            else
            {
                OB = currentBGR.OB__c;
            }
            if(string.isNotBlank(bgrOutputList[0].OW_Override__c))
            {
                OW = bgrOutputList[0].OW_Override__c;
            }
            else
            {
                OW = currentBGR.OW__c;
            }
            //PC = bgrOutputList[0].PC_Override__c;
        }
        else
        {
            OA = currentBGR.OA__c;
            OB = currentBGR.OB__c;
            OW = currentBGR.OW__c;
            //PC = currentRV.PC__c;
        }

        
       /* result res2;
        res2=unitConversions.convertPressure(RTPRSU,'in water',currentBGR.Setting__c);
        SETINWCformula=res2.dblRetValue;*/
        
        /*for(String keyValue: mapBGR_Attribute.keySet())
{
System.debug('***** key = '+keyValue+', value = '+mapBGR_Attribute.get(keyValue));
}*/
        //currentBGROutput = (BGR_Outputs__c) wizardBaseDataProcessor.getObjectDataById(recordID).objResultList[0];
    }
    // currentBGR : current BGR record
    public BGR__c currentBGR  {get; set;}
   public decimal conpressure{get;set;}
 //  public decimal SETINWCformula{get;set;}
   
    // public BGR_Outputs__c currentBGROutput {get; set;}
    public Map<string,string> mapBGRAttr{
        get{
            Map<String, string> myMap1 = new Map<String, string>(); 
            myMap1.put('PMI',PMI);
            myMap1.put('RGEUNT',RGEUNT);
            myMap1.put('RTPRS1',RTPRS1);
            myMap1.put('RTPRSU',RTPRSU);
            myMap1.put('SUPRS1',SUPRS1);
            myMap1.put('SUPRSU',SUPRSU);
            myMap1.put('GORIFC',GORIFC);
            myMap1.put('SERVICE',SERVICE);
            myMap1.put('DPM',DPM);
            myMap1.put('MediaName',MediaName);
            myMap1.put('K',K);
            myMap1.put('MW',MW);
            myMap1.put('Z',Z);
            myMap1.put('RTTMSP',RTTMSP);
            myMap1.put('RTTMUN',RTTMUN);
            myMap1.put('REQDFLOW',REQDFLOW);
            myMap1.put('REQDFLOWUOM',REQDFLOWUOM);
          //  decimal decGPRSC1=decimal.valueOf(GPRSC1);
            string strGPRSC1=GPRSC1.stripTrailingZeros().toPlainString();
            myMap1.put('GPRSC1',strGPRSC1);
            myMap1.put('OA',OA);
            myMap1.put('OB250',OB250);
            myMap1.put('OB',OB);
            myMap1.put('OW',OW);
            myMap1.put('ASSYLOCATION',ASSYLOCATION);
            myMap1.put('ASYTYP',ASYTYP);
            myMap1.put('ATEX',ATEX);
            myMap1.put('CSA',CSA);
            myMap1.put('NACE',NACE);
            myMap1.put('CUTR',CUTR);
            myMap1.put('GMODEL',GMODEL);
            myMap1.put('GMODEL1',GMODEL1);
			myMap1.put('GMODEL2',GMODEL2);
			myMap1.put('GMODEL3',GMODEL3);
			myMap1.put('GMODEL4',GMODEL4);
			myMap1.put('GMODEL5',GMODEL5);
			myMap1.put('GMODEL6',GMODEL6);
			myMap1.put('GMODEL7',GMODEL7);
            myMap1.put('GTAGPN',GTAGPN);
            myMap1.put('HCLASS',HCLASS);
            myMap1.put('IINO',IINO);
            myMap1.put('MATLSOURCE',MATLSOURCE);
            myMap1.put('MCBODY',MCBODY);
            myMap1.put('MCDPHM',MCDPHM);
            myMap1.put('PC',PC);
            myMap1.put('PTC',PTC);
            myMap1.put('Model',Model);
            myMap1.put('BRAND',BRAND);
            myMap1.put('PNMODEL',PNMODEL);
            myMap1.put('PNSIZE',PNSIZE);
            myMap1.put('SETTINGMAXFACT',SETTINGMAXFACT);
           
            
          //  decimal decSETTINGMAX=decimal.valueOf(SETTINGMAX);
            string strSETTINGMAX=SETTINGMAX.stripTrailingZeros().toPlainString();
            myMap1.put('SETTINGMAX',strSETTINGMAX);
            
          //  decimal decSETTINGMIN=decimal.valueOf(SETTINGMIN);
            string strSETTINGMIN=SETTINGMIN.stripTrailingZeros().toPlainString();
            myMap1.put('SETTINGMIN',strSETTINGMIN);
            
         //   decimal decSHUTOFFMAX=decimal.valueOf(SHUTOFFMAX);
            string strSHUTOFFMAX=SHUTOFFMAX.stripTrailingZeros().toPlainString();
            myMap1.put('SHUTOFFMAX',strSHUTOFFMAX);
            
          //  decimal decSHUTOFFMIN=decimal.valueOf(SHUTOFFMIN);
            string strSHUTOFFMIN=SHUTOFFMIN.stripTrailingZeros().toPlainString();
            myMap1.put('SHUTOFFMIN',strSHUTOFFMIN);
            
            myMap1.put('SHLTSTBDYPSIG',SHLTSTBDYPSIG);            
            myMap1.put('SHLTSTBDYPSIGMX',SHLTSTBDYPSIGMX);            
            myMap1.put('SETTINGMINFACT',SETTINGMINFACT);
            myMap1.put('SHLTSTACTPSIG',SHLTSTACTPSIG);
            myMap1.put('SHLTSTACTPSIGMX',SHLTSTACTPSIGMX);                        
            myMap1.put('SHLTSTMETHACT',SHLTSTMETHACT);
            myMap1.put('SHLTSTMETHBDY',SHLTSTMETHBDY);            
            myMap1.put('SHUTOFFMAXFACT',SHUTOFFMAXFACT);            
            myMap1.put('SHUTOFFMINFACT',SHUTOFFMINFACT);
            myMap1.put('SPRINGCODE',SPRINGCODE);
            myMap1.put('SZC',SZC);
            myMap1.put('SizeCode',SizeCode);
            myMap1.put('TAGMAXACTPRES',TAGMAXACTPRES);
            myMap1.put('TAGMAXSUPPRES',TAGMAXSUPPRES);
            myMap1.put('TAGSPRGRANGE',TAGSPRGRANGE);
            myMap1.put('XRAY',XRAY);
            myMap1.put('SETINWC',SETINWC+'');
            myMap1.put('ASSEMBLYWT',ASSEMBLYWT);
            myMap1.put('ASSEMBLYWTUOM',ASSEMBLYWTUOM);
            myMap1.put('ATMPRESPSIA',ATMPRESPSIA);
            myMap1.put('ATTRTEMPLATE',ATTRTEMPLATE);
            myMap1.put('BRANDCODE',BRANDCODE);
            myMap1.put('COMPDESCRIPTION',COMPDESCRIPTION);
            myMap1.put('COMPINVSERTRK',COMPINVSERTRK);
            myMap1.put('PARTNUMBER',PARTNUMBER);
            myMap1.put('PRDLIN',PRDLIN);
            return myMap1;
        }
        set{
            this.mapBGRAttr=value;
        }
    }
    public Map<string,string> mapBGR_Attribute {get;set;}
    /* public Map<string,string> mapBGR_Attribute {
get {

return getMapAttribute();
}
set;
}*/
    public String PMI {
        get {
            if(currentBGR.Positive_Material_Identification__c != null)
            {
                return currentBGR.Positive_Material_Identification__c;
            }
            else{
                return '';
            }
        }
        set {
            currentBGR.Positive_Material_Identification__c = value;
            this.PMI = value;
            
        }
    }
  /*  public string PARTNUMBER {
        get 
        {
            if(string.isNotBlank(currentBGR.ASSYPARTEXISTING__c))
            {
                return currentBGR.ASSYPARTEXISTING__c;
            }
            else{
                return '';
            }   
            
        }
        set 
        {
            this.PARTNUMBER = value;
        }
    }*/
    
     public string PARTNUMBER {
        get 
        {
            if(currentBGR.Part_Number__c != null)
                return currentBGR.Part_Number__c;
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
            if(currentBGR.PARTREV__c != null)
                return currentBGR.PARTREV__c;
            else
                return '1';
        }
        set 
        {
            this.PARTREV = value;
        }
    }
    
    //public string PARTNUMBER;
    public string DESCRIPTION {
        get {
            if(currentBGR.Quote_Description_Engineer_Override__c == true)
            {
                return 'Special'+' '+BRAND+' '+'Model:'+' '+PTC+' '+SZC+'"'+' '+MCBODY+' '+'Body'+' '+MCDPHM+' '+'With'+' '+HCLASS+' '+'Connection and'+' '+SETINWC+' '+'in. Water Setting';
            }
            else
            {
                return BRAND+' '+'Model:'+' '+PTC+' '+SZC+'"'+' '+MCBODY+' '+'Body'+' '+MCDPHM+' '+'With'+' '+HCLASS+' '+'Connection and'+' '+SETINWC+' '+'in. Water Setting';               
            }
        }
        set {
            this.DESCRIPTION = value;
        }
    }
    
    public string LOT_TRACKING {
        get {
            return mapBGR_Attribute.get('LOTTRACKCODE') ==null?'':mapBGR_Attribute.get('LOTTRACKCODE');
        }
        set {
            this.LOT_TRACKING = value;
        }
    }

    public string PNMODEL {
        get {
            return mapBGR_Attribute.get('PNMODEL') ==null?'':mapBGR_Attribute.get('PNMODEL');
        }
        set {
            this.PNMODEL = value;
        }
    }

    public string PNSIZE {
        get {
            return mapBGR_Attribute.get('PNSIZE') ==null?'':mapBGR_Attribute.get('PNSIZE');
        }
        set {
            this.PNSIZE = value;
        }
    }
    
    public string BRANDCODE {
        get {
            return mapBGR_Attribute.get('BRANDCODE') ==null?'':mapBGR_Attribute.get('BRANDCODE');
        }
        set {
            this.BRANDCODE = value;
        }
    }
    
    public string PROVIDE {
        get {
            return mapBGR_Attribute.get('PROVIDE')==null?'': mapBGR_Attribute.get('PROVIDE');
        }
        set {
            this.PROVIDE = value;
        }
    }
    
    public string INV_SERIAL_TRACKING {
        get {
            return mapBGR_Attribute.get('SERIALTRACKCODE')==null?'': mapBGR_Attribute.get('SERIALTRACKCODE');
            
        }
        set {
            this.INV_SERIAL_TRACKING = value;
        }
    }
    
    public string PART_CLASS {
        get {
            return mapBGR_Attribute.get('PARTCLASS')==null?'': mapBGR_Attribute.get('PARTCLASS');
        }
        set {
            this.PART_CLASS = value;
        }
    }
    
    public string RESPONSIBLE_ID {
        get {
            return mapBGR_Attribute.get('RESPONSIBLE_ID')==null?'': mapBGR_Attribute.get('RESPONSIBLE_ID');
        }
        set {
            this.RESPONSIBLE_ID = value;
        }
    }
    
    public string NOTE {
        get {
            if(currentBGR.Engineering_Notes__c != null)
            {
                return currentBGR.Engineering_Notes__c;
            }
            else{
                return '';
            }   
        }
        set {
            this.NOTE = value;
        }
    }
    
    public ID QuoteLine {
        get {
            return currentBGR.Quote_Line__c;
        }
        set {
            this.QuoteLine = value;
        }
    }
    
    public String PARTMANAGEDIN {
        get {
            if(currentBGR.Quote_Description_Engineer_Override__c == false)
            {
                return 'Salesforce';
            }
            else{
                return 'IFS';
            }
        }
        set {
            this.PARTMANAGEDIN = value;
        }
    }
    public String CONTRACT {
        get {
            return currentBGR.Brand__c;
        }
        set {
            this.CONTRACT = value;
        }
    } 
    
    public String BRAND {
        get {
            return currentBGR.Brand__c;
        }
        set {
            this.BRAND = value;
        }
    } 
    
    
    public String CATALOG_GROUP {
        get {
            return mapBGR_Attribute.get('SALESGROUP')==null?'': mapBGR_Attribute.get('SALESGROUP');
        }
        set {
            this.CATALOG_GROUP = value;
        }
    }
    
    public String SALES_PRICE_GROUP_ID {
        get {
            return mapBGR_Attribute.get('SALESPRICEGROUP')==null?'': mapBGR_Attribute.get('SALESPRICEGROUP');
        }
        set {
            this.SALES_PRICE_GROUP_ID = value;
        }
    }
    
    public String SOURCING_OPTION {
        get {
            return mapBGR_Attribute.get('SOURCINGOPT')==null?'': mapBGR_Attribute.get('SOURCINGOPT');
        }
        set {
            this.SOURCING_OPTION = value;
        }
    }
    
    public String HSN_SAC_CODE {
        get {
            return mapBGR_Attribute.get('HSNSACCODE')==null?'': mapBGR_Attribute.get('HSNSACCODE');
        }
        set {
            this.HSN_SAC_CODE = value;
        }
    }
    
    public String PLANNER {
        get {
            return mapBGR_Attribute.get('PLANNER')==null?'': mapBGR_Attribute.get('PLANNER');
            
        }
        set {
            this.PLANNER = value;
        }
    }
    
    public String CUSTOMS_STAT_NO {
        get {
            return mapBGR_Attribute.get('CUSTOMSTATNO')==null?'': mapBGR_Attribute.get('CUSTOMSTATNO');
        }
        set {
            this.CUSTOMS_STAT_NO = value;
        }
    }
    
    public String ENG_DESCRIPTION {
        get {
            return mapBGR_Attribute.get('COMPDESCRIPTION')==null?'': mapBGR_Attribute.get('COMPDESCRIPTION');
        }
        set {
            this.ENG_DESCRIPTION = value;
        }
    }
    
    public String ENG_LOTTRACK {
        get {
            return mapBGR_Attribute.get('COMPLOTTRACK')==null?'': mapBGR_Attribute.get('COMPLOTTRACK');
            
        }
        set {
            this.ENG_LOTTRACK = value;
        }
    }
    
    public String ENG_PROVIDE {
        get {
            return mapBGR_Attribute.get('COMPPROVIDE')==null?'': mapBGR_Attribute.get('COMPPROVIDE');  
        }
        set {
            this.ENG_PROVIDE = value;
        }
    }
    
    public String ENG_INV_SERIAL_TRACKING {
        get {
            return mapBGR_Attribute.get('COMPINVSERTRK')==null?'': mapBGR_Attribute.get('COMPINVSERTRK');  
            
        }
        set {
            this.ENG_INV_SERIAL_TRACKING = value;
        }
    }
    
    public String ENG_RESPONSIBLE_ID {
        get {
            return mapBGR_Attribute.get('COMPRESPONID')==null?'': mapBGR_Attribute.get('COMPRESPONID');
        }
        set {
            this.ENG_RESPONSIBLE_ID = value;
        }
    } 
    
    public String CHAR_TEMPLATE {
        get {
            return mapBGR_Attribute.get('ATTRTEMPLATE')==null?'': mapBGR_Attribute.get('ATTRTEMPLATE');
        }
        set {
            this.CHAR_TEMPLATE = value;
        }
    }
    
      public String ASSEMBLYWT {
        get {
            return mapBGR_Attribute.get('ASSEMBLYWT')==null?'': mapBGR_Attribute.get('ASSEMBLYWT');
        }
        set {
            this.ASSEMBLYWT = value;
        }
    }
    
     public String ASSEMBLYWTUOM {
        get {
            return mapBGR_Attribute.get('ASSEMBLYWTUOM')==null?'': mapBGR_Attribute.get('ASSEMBLYWTUOM');
        }
        set {
            this.ASSEMBLYWTUOM = value;
        }
    }
    
    public String PART_UOM {
        get {
            return mapBGR_Attribute.get('PARTUOM')==null?'': mapBGR_Attribute.get('PARTUOM');
        }
        set {
            this.PART_UOM = value;
        }
    }
    
    public String PRDLIN{
        get {
            return mapBGR_Attribute.get('PRDLIN')==null?'': mapBGR_Attribute.get('PRDLIN');
        }
        set {
            this.PRDLIN = value;
        }
    }
    
    public String PTC {
        get {
            if(currentBGR.Model__c != null)
            {
                return currentBGR.Model__c;
            }
            else{
                return '';
            }   
        }
        set {
            currentBGR.Model__c = value;
            this.PTC = value;
        }
    }
    
    public String Model {
        get {
            if(currentBGR.Model__c != null)
            {
                return currentBGR.Model__c;
            }
            else{
                return '';
            }   
        }
        set {
            currentBGR.Model__c = value;
            this.Model = value;
        }
    }
    public String OrificeSetting {
        get {
            if(currentBGR.Combo_Orifice_Setting__c != null)
            {
                return currentBGR.Combo_Orifice_Setting__c;
            }
            else{
                return '';
            }   
        }
        set {
            currentBGR.Combo_Orifice_Setting__c = value;
            this.OrificeSetting = value;
        }
    }
    public String SZC {
        get {
            if(currentBGR.Size__c != null)
            {
                return currentBGR.Size__c;
            }
            else{
                return '';
            }   
        }
        set {
            currentBGR.Size__c = value;
            this.SZC = value;
        }
    }
    public String SizeCode {
        get {
            if(currentBGR.Size_Backend__c != null)
            {
                return currentBGR.Size_Backend__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentBGR.Size_Backend__c = value;
            this.SizeCode = value;
        }
    }
    public String MCBODY {
        get {
            if(currentBGR.Body_Material_dynamic__c != null)
            {
                return currentBGR.Body_Material_dynamic__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentBGR.Body_Material_dynamic__c = value;
            this.MCBODY = value;
        }
    }
    public String MCDPHM {
        get {
            if(string.isNotBlank(currentBGR.Soft_Goods_Material_dynamic__c))
            {
                return currentBGR.Soft_Goods_Material_dynamic__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentBGR.Soft_Goods_Material_dynamic__c = value;
            this.MCDPHM = value;
        }
    }
    public String XRAY {
        get {
            if(currentBGR.Radiography__c != null)
            {
                return currentBGR.Radiography__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentBGR.Radiography__c = value;
            this.XRAY = value;
        }
    }
    public String MATLSOURCE {
        get {
            if(currentBGR.Material_Sourcing_Requirements__c != null)
            {
                return currentBGR.Material_Sourcing_Requirements__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentBGR.Material_Sourcing_Requirements__c = value;
            this.MATLSOURCE = value;
        }
    }
    public String HCLASS {
        get {
            if(currentBGR.Connection_dynamic__c != null)
            {
                return currentBGR.Connection_dynamic__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentBGR.Connection_dynamic__c = value;
            this.HCLASS = value;
        }
    }
    
    public decimal SETINWC {
        get {
                decimal decSETINWC=0.0;
                decSETINWC=currentBGR.Converted_Setting__c;
                if(decSETINWC!=null)
                    return decSETINWC;
                else
                    return 0.0;
           /* if(currentBGR.Converted_Setting__c != null)
            {
                return currentBGR.Converted_Setting__c;
            }
            else{
                return 0;
            } */
        }
        set {
            currentBGR.Converted_Setting__c = value;
            this.SETINWC = value;
        }
    }
    public String SETINUOM {
        get {
            if(currentBGR.Setting_Units__c != null)
            {
                return currentBGR.Setting_Units__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentBGR.Setting_Units__c = value;
            this.SETINUOM = value;
        }
    }
    public string SHLTSTMETHACT {
        get {
            if(currentBGR.Shell_test__c != null)
            {
                return currentBGR.Shell_test__c;
            }
            else{
                return '';
            }
        }
        set {
            currentBGR.Shell_test__c = value;
            this.SHLTSTMETHACT = value;
        }
    }
    public string SHLTSTMETHBDY {
        get {
            if(currentBGR.Shell_Test_Valve_Body__c != null)
            {
                return currentBGR.Shell_Test_Valve_Body__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentBGR.Shell_Test_Valve_Body__c = value;
            this.SHLTSTMETHBDY = value;
        }
    }
    public string ASSYLOCATION {
        get {
            if(currentBGR.Final_Assembly_Location_Requirements__c != null)
            {
                return currentBGR.Final_Assembly_Location_Requirements__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentBGR.Final_Assembly_Location_Requirements__c = value;
            this.ASSYLOCATION = value;
        }
    }
    public string ATEX {
        get {
            if(currentBGR.Atex__c != null)
            {
                return currentBGR.Atex__c;
            }
            else{
                return 'N';
            } 
        }
         set {
            currentBGR.Atex__c = value;
            this.ATEX = value;
        } 
    } 
    public string CUTR {
        get {
            if(currentBGR.GOST_CU_Tr_010_2011__c != null)
            {
                return currentBGR.GOST_CU_Tr_010_2011__c;
            }
            else{
                return 'N';
            } 
        }
        set {
            currentBGR.GOST_CU_Tr_010_2011__c = value;
            this.CUTR = value;
        }
    }
    public string CSA {
        get {
            if(currentBGR.CSA_Markings__c != null)
            {
                return currentBGR.CSA_Markings__c;
            }
            else{
                return 'N';
            } 
        }
        set {
            currentBGR.CSA_Markings__c = value;
            this.CSA = value;
        }
    }
    public string NACE {
        get {
            if(currentBGR.CSA_Markings__c != null)
            {
                return currentBGR.CSA_Markings__c;
            }
            else{
                return 'N';
            } 
        }
        set {
            currentBGR.CSA_Markings__c = value;
            this.NACE = value;
        }
    }
    public string Schedule {
        get {
            if(currentBGR.Schedule__c != null)
            {
                return currentBGR.Schedule__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentBGR.Schedule__c = value;
            this.Schedule = value;
        }
    }
    public string Schedule2 {
        get {
            if(currentBGR.Schedule_2__c != null)
            {
                return currentBGR.Schedule_2__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentBGR.Schedule_2__c = value;
            this.Schedule2 = value;
        }
    }
    public decimal QTY {
        get {
            if(currentBGR.Quantity__c != null)
            {
                return currentBGR.Quantity__c;
            }
            else{
                return 0;
            } 
        }
        set {
            currentBGR.Quantity__c = value;
            this.QTY = value;
        }
    }
    public String RGEUNT {
        get {
            //System.debug('kjvfgf'+mapBGR_Attribute);
            return mapBGR_Attribute.get('RGEUNT')==null?'': mapBGR_Attribute.get('RGEUNT');  
            
        }
        set {
            this.RGEUNT = value;
        }
    }
    
    public String ATMPRESPSIA {
        get {
            //System.debug('kjvfgf'+mapBGR_Attribute);
            return mapBGR_Attribute.get('ATMPRESPSIA')==null?'': mapBGR_Attribute.get('ATMPRESPSIA');  
            
        }
        set {
            this.ATMPRESPSIA = value;
        }
    }
    public String ATTRTEMPLATE{
        get {
            //System.debug('kjvfgf'+mapBGR_Attribute);
            return mapBGR_Attribute.get('ATTRTEMPLATE')==null?'': mapBGR_Attribute.get('ATTRTEMPLATE');  
            
        }
        set {
            this.ATTRTEMPLATE= value;
        }
    }
    
    
    
    public String COMPDESCRIPTION{
        get {
            //System.debug('kjvfgf'+mapBGR_Attribute);
            return mapBGR_Attribute.get('COMPDESCRIPTION')==null?'': mapBGR_Attribute.get('COMPDESCRIPTION');  
            
        }
        set {
            this.COMPDESCRIPTION= value;
        }
    }
    public String COMPINVSERTRK{
        get {
            //System.debug('kjvfgf'+mapBGR_Attribute);
            return mapBGR_Attribute.get('COMPINVSERTRK')==null?'': mapBGR_Attribute.get('COMPINVSERTRK');  
            
        }
        set {
            this.COMPINVSERTRK= value;
        }
    }
    /*  get {
return currentBGR.RGEUNT__c;
}
set {
currentBGR.RGEUNT__c = value;
this.RGEUNT = value;

}
} */
    
    public string RTPRS1 {
        get {
            if(string.valueOf(currentBGR.Setting__c) != null)
            {
                return string.valueOf(currentBGR.Setting__c);
            }
            else{
                return '';
            } 
        }
        set {
            //settingvalue = value;
            this.RTPRS1 = value;
            
        }
    } 
    
    public string RTPRSU {
        get {
            if(currentBGR.Setting_Units__c != null)
            {
                return currentBGR.Setting_Units__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentBGR.Setting_Units__c = value;
            this.RTPRSU = value;
            
        }
    }
    
    public string SUPRS1 {
        get {
            if(string.valueOf(currentBGR.Supply_Pressure__c) != null)
            {
                return string.valueOf(currentBGR.Supply_Pressure__c);
            }
            else{
                return '';
            } 
        }
        set {
            // SupplyPressure = value;
            this.SUPRS1 = value;
            
        }
    } 
    
    public string SUPRSU {
        get {
            if(currentBGR.Supply_Pressure_Units__c != null)
            {
                return currentBGR.Supply_Pressure_Units__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentBGR.Supply_Pressure_Units__c = value;
            this.SUPRSU = value;
            
        }
    }
    
    public string GORIFC {
        get {
            if(currentBGR.Orifice_value__c != null)
            {
                return currentBGR.Orifice_value__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentBGR.Orifice_value__c = value;
            this.GORIFC = value;
            
        }
    }
    
    public string SERVICE {
        get {
            if(currentBGR.Service_Type__c != null)
            {
                return currentBGR.Service_Type__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentBGR.Service_Type__c = value;
            this.SERVICE = value;
            
        }
    }
    
    public string DPM {
        get {
            if(currentBGR.Supply_Gas__c != null)
            {
                return currentBGR.Supply_Gas__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentBGR.Supply_Gas__c = value;
            this.DPM = value;
            
        }
    }
    
    public string MediaName {
        get {
            if(currentBGR.Customer_Specified_Media__c != null)
            {
                return currentBGR.Customer_Specified_Media__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentBGR.Customer_Specified_Media__c = value;
            this.MediaName = value;
            
        }
    }
    
    public string K {
        get {
            if(string.valueOf(currentBGR.Ratio_of_Specific_Heats__c) != null)
            {
                return string.valueOf(currentBGR.Ratio_of_Specific_Heats__c);
            }
            else{
                return '';
            } 
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.K = value;
            
        }
    }
    
    public string MW {
        get {
            if(string.valueOf(currentBGR.Molecular_Weight__c) != null)
            {
                return string.valueOf(currentBGR.Molecular_Weight__c);
            }
            else{
                return '';
            } 
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.MW = value;
            
        }
    }
    
    public string Z {
        get {
            if(string.valueOf(currentBGR.Compressibility_Factor__c) != null)
            {
                return string.valueOf(currentBGR.Compressibility_Factor__c);
            }
            else{
                return '';
            } 
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.Z = value;
            
        }
    }
    
    public string RTTMSP {
        get {
            if(string.valueOf(currentBGR.Supply_Gas_Temperature__c) != null)
            {
                return string.valueOf(currentBGR.Supply_Gas_Temperature__c);
            }
            else{
                return '';
            } 
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.RTTMSP = value;
            
        }
    }
    
    public string RTTMUN {
        get {
            if(currentBGR.Supply_Gas_Temperature_Units__c != null)
            {
                return currentBGR.Supply_Gas_Temperature_Units__c;
            }
            else{
                return '';
            } 
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.RTTMUN = value;
            
        }
    }
    
    public string REQDFLOW {
        get {
            if(string.valueOf(currentBGR.Minimum_Required_Flow_Capacity__c) != null)
            {
                return string.valueOf(currentBGR.Minimum_Required_Flow_Capacity__c);
            }
            else{
                return '';
            } 
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.REQDFLOW = value;
            
        }
    }
    
    public string REQDFLOWUOM {
        get {
            if(currentBGR.Flow_Units__c != null)
            {
                return currentBGR.Flow_Units__c;
            }
            else{
                return '';
            } 
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.REQDFLOWUOM = value;
            
        }
    }
    
    public decimal GPRSC1 {
        get {
            if(RTPRS1!=null)
            {
                result res1;               
                res1=unitConversions.SignificantDigitsNormal(conpressure,3,-99);
                decimal decGPRSC1=res1.dblRetValue;
                if(decGPRSC1!=null)
                    return decGPRSC1;
                else
                    return 0.0;
            }
            else
                return 0.0;
            
           /* if(string.valueOf(currentBGR.Converted_Setting__c) != null)
            {
                return string.valueOf(currentBGR.Converted_Setting__c);
            }
            else{
                return '';
            } */
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.GPRSC1 = value;
            
        }
    }
    
    public string ASYTYP {
        get {
            return mapBGR_Attribute.get('ASYTYP')==null?'': mapBGR_Attribute.get('ASYTYP');
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.ASYTYP = value;
            
        }
    }
    
    public string SPRINGCODE{
        get{
            if(string.isNotBlank(currentBGR.SPRINGCODE__c))
            {
                return currentBGR.SPRINGCODE__c;
            }
            else if(String.isNotBlank(SPRINGCODE))
            {
                return SPRINGCODE;
            }
            else
            {
                return '';
            }
        }
        set{
            this.SPRINGCODE = value;
        }
    }
    
    public void setScode(String scode)
    {
        System.debug('utility assigning SPRINGCODE = '+scode);
        this.SPRINGCODE = scode;
        System.debug('utility assigned SPRINGCODE = '+this.SPRINGCODE+' and GMODEL = '+GMODEL);
    }
    
    public string OPTIONCODE{
        get{
            string OC =' ';
            //Service Ticket# 200454
            if(ATEX == 'N' && CSA == 'N' && CUTR == 'N' && XRAY == 'N' && PMI == 'N' && ASSYLOCATION == '00' && MATLSOURCE == '00')
           
            {
                OC = '0';
            }
            else{
                OC = 'Z';
            }
            return OC;
        }
        set{
            this.OPTIONCODE = value;
        }
    }
    
    public string GMODEL {
        get {
            System.debug('utility GMODEL SPRINGCODE = '+SPRINGCODE);
            //return PTC + '-' + HCLASS + '-' + MCBODY + '-' + MCDPHM + '-' + GORIFC + '-' + SPRINGCODE + '-' + OPTIONCODE;
            return  GMODEL1+GMODEL2+GMODEL3+GMODEL4+GMODEL5+GMODEL6+GMODEL7+OPTIONCODE;
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.GMODEL = value;
            
        }
    }
    
     public string GMODEL1 {
        get {
             return mapBGR_Attribute.get('GMODEL-1')==null?'': mapBGR_Attribute.get('GMODEL-1');
        }
        set {
            this.GMODEL1 = value;
        }
    }  
        public string GMODEL2 {
        get {
             return mapBGR_Attribute.get('GMODEL-2')==null?'': mapBGR_Attribute.get('GMODEL-2');
        }
        set {
            this.GMODEL2 = value;
        }
    }
    
    public string GMODEL3 {
        get {
             return mapBGR_Attribute.get('GMODEL-3')==null?'': mapBGR_Attribute.get('GMODEL-3');
        }
        set {
            this.GMODEL3 = value;
        }
    }
      
    public string GMODEL4 {
        get {
             return mapBGR_Attribute.get('GMODEL-4')==null?'': mapBGR_Attribute.get('GMODEL-4');
        }
        set {
            this.GMODEL4 = value;
        }
    }
      
     public string GMODEL5 {
        get {
             return mapBGR_Attribute.get('GMODEL-5')==null?'': mapBGR_Attribute.get('GMODEL-5');
        }
        set {
            this.GMODEL5 = value;
        }
    }
    
     public string GMODEL6 {
        get {
             return mapBGR_Attribute.get('GMODEL-6')==null?'': mapBGR_Attribute.get('GMODEL-6');
        }
        set {
            this.GMODEL6 = value;
        }
     }   
         
        public string GMODEL7 {
        get {
             return mapBGR_Attribute.get('GMODEL-7')==null?'': mapBGR_Attribute.get('GMODEL-7');
        }
        set {
            this.GMODEL7 = value;
        } 
    }
    
    
    public string COMPPROVIDE {
        get {
             return mapBGR_Attribute.get('COMPPROVIDE')==null?'': mapBGR_Attribute.get('COMPPROVIDE');
        }
        set {
            this.COMPPROVIDE = value;
        }
    }
    
    public string HSNSACCODE {
        get {
             return mapBGR_Attribute.get('HSNSACCODE')==null?'': mapBGR_Attribute.get('HSNSACCODE');
        }
        set {
            this.HSNSACCODE = value;
        }
    }
    
    public string CUSTOMSTATNO {
        get {
             return mapBGR_Attribute.get('CUSTOMSTATNO')==null?'': mapBGR_Attribute.get('CUSTOMSTATNO');
        }
        set {
            this.CUSTOMSTATNO = value;
        }
    }
    
    public string PARTUOM {
        get {
             return mapBGR_Attribute.get('PARTUOM')==null?'': mapBGR_Attribute.get('PARTUOM');
        }
        set {
            this.PARTUOM = value;
        }
    }
    
    public string PC220 {
        get {
             return mapBGR_Attribute.get('PC220')==null?'': mapBGR_Attribute.get('PC220');
        }
        set {
            this.PC220 = value;
        }
    }
    
     public string PC320 {
        get {
             return mapBGR_Attribute.get('PC320')==null?'': mapBGR_Attribute.get('PC320');
        }
        set {
            this.PC320 = value;
        }
    }
    
     public string PC420 {
        get {
             return mapBGR_Attribute.get('PC420')==null?'': mapBGR_Attribute.get('PC420');
        }
        set {
            this.PC420 = value;
        }
    }
    
    public string SALESPRICEGROUP {
        get {
             return mapBGR_Attribute.get('SALESPRICEGROUP')==null?'': mapBGR_Attribute.get('SALESPRICEGROUP');
        }
        set {
            this.SALESPRICEGROUP = value;
        }
    }
    
    public string SOURCINGOPT {
        get {
             return mapBGR_Attribute.get('SOURCINGOPT')==null?'': mapBGR_Attribute.get('SOURCINGOPT');
        }
        set {
            this.SOURCINGOPT = value;
        }
    }
    
    public string COMPLOTTRACK {
        get {
             return mapBGR_Attribute.get('COMPLOTTRACK')==null?'': mapBGR_Attribute.get('COMPLOTTRACK');
        }
        set {
            this.SOURCINGOPT = value;
        }
    }
    
    public string PC210 {
        get {
             return mapBGR_Attribute.get('PC210')==null?'': mapBGR_Attribute.get('PC210');
        }
        set {
            this.PC210 = value;
        }
    }
    
    public string PC310 {
        get {
             return mapBGR_Attribute.get('PC310')==null?'': mapBGR_Attribute.get('PC310');
        }
        set {
            this.PC310 = value;
        }
    }
    
    public string PC410 {
        get {
             return mapBGR_Attribute.get('PC410')==null?'': mapBGR_Attribute.get('PC410');
        }
        set {
            this.PC410 = value;
        }
    }
    
    public decimal GSPRSC {
        get {
                if(currentBGR.Converted_Supply_Pressure__c != null)
            {
                return currentBGR.Converted_Supply_Pressure__c;
            }
            else
            {
                return 0.0;
            }
            /*if(string.valueOf(currentBGR.Converted_Supply_Pressure__c) != null)
            {
                return string.valueOf(currentBGR.Converted_Supply_Pressure__c);
            }
            else
            {
                return '';
            }*/
        }
        set {
            this.GSPRSC = value;
        }
    }
    
    public string LOTTRACKCODE {
        get {
             return mapBGR_Attribute.get('LOTTRACKCODE')==null?'': mapBGR_Attribute.get('LOTTRACKCODE');
        }
        set {
            this.LOTTRACKCODE = value;
        }
    }
    
    public string SALESGROUP {
        get {
             return mapBGR_Attribute.get('SALESGROUP')==null?'': mapBGR_Attribute.get('SALESGROUP');
        }
        set {
            this.SALESGROUP = value;
        }
    }
    
     public string PARTCLASS {
        get {
             return mapBGR_Attribute.get('PARTCLASS')==null?'': mapBGR_Attribute.get('PARTCLASS');
        }
        set {
            this.PARTCLASS = value;
        }
    }
    
    public string SERIALTRACKCODE {
        get {
             return mapBGR_Attribute.get('SERIALTRACKCODE')==null?'': mapBGR_Attribute.get('SERIALTRACKCODE');
        }
        set {
            this.SERIALTRACKCODE = value;
        }
    }
    
     public string TEMPDEGR {
        get {
            if(string.valueOf(currentBGR.Converted_Supply_Gas_Temperature__c) != null)
            {
                return string.valueOf(currentBGR.Converted_Supply_Gas_Temperature__c);
            }
            else
            {
                return '';
            }
        }
        set {
            this.TEMPDEGR = value;
        }
    }
    
    public string PRESRATIO {
        get {
            if(string.valueOf(currentBGR.PresRatio__c) != null)
            {
                return string.valueOf(currentBGR.PresRatio__c);
            }
            else
            {
                return '';
            }
        }
        set {
            this.PRESRATIO = value;
        }
    }
    
    public string GTAGPN {
        get {
            return mapBGR_Attribute.get('GTAGPN')==null?'': mapBGR_Attribute.get('GTAGPN');
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.GTAGPN = value;
        }
    }
    
    public string IINO {
        get {
            return mapBGR_Attribute.get('IINO')==null?'': mapBGR_Attribute.get('IINO');
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.IINO = value;
        }
    }
    
    public string PC{
        get{
            return '';
        }
        set{
            this.PC = value;
        }
    }
    
    public string SETTING {
        get {
            if(string.valueOf(currentBGR.Converted_Setting__c) != null)
            {
                return string.valueOf(currentBGR.Converted_Setting__c);
            }
            else{
                return '';
            } 
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.SETTING = value;
            
        }
    }
    
    
    public decimal SETTINGMAX {
        get {
            if(conpressure!= null)
            {
                System.debug('conpressure' +conpressure);
                result res1;
                res1=unitConversions.SignificantDigitsDown(conpressure*decimal.valueOf(SETTINGMAXFACT),3, -99);
                decimal decSETTINGMAX=res1.dblRetValue;
                if(decSETTINGMAX!=null) 
                    return decSETTINGMAX;
                else
                    return 0.0;
              /*  decimal s1 = currentBGR.Converted_Setting__c*decimal.valueOf(SETTINGMAXFACT);
                s1.setScale(4);
                return string.valueOf(s1);*/
            }
            else{
                return 0.0;
            } 
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.SETTINGMAX = value;
            
        }
    }
    
    public string SETTINGMAXFACT {
        get {
            return mapBGR_Attribute.get('SETTINGMAXFACT')==null?'0.0': mapBGR_Attribute.get('SETTINGMAXFACT');
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            if(Test.isRunningTest()) {
                this.SETTINGMAXFACT = '1';
            } else {
                
                this.SETTINGMAXFACT = value;
            }
        }
    }
    
    public decimal SETTINGMIN {
        get {
                if(conpressure!= null)
                {
                    System.debug('conpressure' +conpressure);
                    result res1;
                    res1=unitConversions.SignificantDigitsUp(conpressure*decimal.valueOf(SETTINGMINFACT),3, -99);
                    decimal decSETTINGMIN=res1.dblRetValue;
                    if(decSETTINGMIN!=null) 
                        return decSETTINGMIN;
                    else
                        return 0.0;
                  /*  decimal s1 = currentBGR.Converted_Setting__c*decimal.valueOf(SETTINGMAXFACT);
                    s1.setScale(4);
                    return string.valueOf(s1);*/
                }
                else{
                    return 0.0;
                }   
           /* if(string.valueOf(currentBGR.Converted_Setting__c) != null)
            {
                result res1;
                res1=unitConversions.SignificantDigitsUp(conpressure*decimal.valueOf(SETTINGMINFACT),3, -99);
                string strSETTINGMIN=string.valueOf(res1.dblRetValue);
                return strSETTINGMIN;
                decimal s1 = currentBGR.Converted_Setting__c*decimal.valueOf(SETTINGMINFACT);
                s1.setScale(4);
                return s1;
            }
            else{
                return 0.0;
            } */
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.SETTINGMIN = value;
        }
    }
    
    public string SETTINGMINFACT {
        get {
            return mapBGR_Attribute.get('SETTINGMINFACT')==null?'0.0': mapBGR_Attribute.get('SETTINGMINFACT');
        }
        
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.SETTINGMINFACT = value;
        }
    }
    
    public string SHLTSTACTPSIG {
        get {
            return mapBGR_Attribute.get('SHLTSTACTPSIG')==null?'': mapBGR_Attribute.get('SHLTSTACTPSIG');
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.SHLTSTACTPSIG = value;
        }
    }
    
    public string SHLTSTACTPSIGMX {
        get {
            return mapBGR_Attribute.get('SHLTSTACTPSIGMX')==null?'': mapBGR_Attribute.get('SHLTSTACTPSIGMX');
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.SHLTSTACTPSIGMX = value;
        }
    }
    
    public string SHLTSTBDYPSIG {
        get {
            return mapBGR_Attribute.get('SHLTSTBDYPSIG')==null?'': mapBGR_Attribute.get('SHLTSTBDYPSIG');
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.SHLTSTBDYPSIG = value;
        }
    }
    
    public string SHLTSTBDYPSIGMX {
        get {
            return mapBGR_Attribute.get('SHLTSTBDYPSIGMX')==null?'': mapBGR_Attribute.get('SHLTSTBDYPSIGMX');
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.SHLTSTBDYPSIGMX = value;
        }
    }
    
    public decimal SHUTOFFMAX {
        get {
                if(conpressure!= null)
                {
                    System.debug('conpressure' +conpressure);
                    result res1;
                    res1=unitConversions.SignificantDigitsDown(conpressure*decimal.valueOf(SHUTOFFMAXFACT),3, -99);
                    decimal decSHUTOFFMAX=res1.dblRetValue;
                    if(decSHUTOFFMAX!=null) 
                        return decSHUTOFFMAX;
                    else
                        return 0.0;
                  /*  decimal s1 = currentBGR.Converted_Setting__c*decimal.valueOf(SETTINGMAXFACT);
                    s1.setScale(4);
                    return string.valueOf(s1);*/
                }
                else{
                    return 0.0;
                }   
            
           /* if(string.valueOf(currentBGR.Converted_Setting__c) != null)
            {
                result res1;
                res1=unitConversions.SignificantDigitsDown(conpressure*decimal.valueOf(SHUTOFFMAXFACT),3, -99);
                string strSHUTOFFMAX=string.valueOf(res1.dblRetValue);
                return strSHUTOFFMAX;
                decimal s1 = currentBGR.Converted_Setting__c*decimal.valueOf(SHUTOFFMAXFACT);
                s1.setScale(4);
                return string.valueOf(s1);
            }
            else{
                return '';
            } */
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.SHUTOFFMAX = value;
        }
    }
    
    public string SHUTOFFMAXFACT {
        get {
            return mapBGR_Attribute.get('SHUTOFFMAXFACT')==null?'0.0': mapBGR_Attribute.get('SHUTOFFMAXFACT');
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.SHUTOFFMAXFACT = value;
        }
    }
    
    public decimal SHUTOFFMIN {
        get {
            if(conpressure!= null)
                {
                    System.debug('conpressure' +conpressure);
                    result res1;
                    res1=unitConversions.SignificantDigitsUp(conpressure*decimal.valueOf(SHUTOFFMINFACT),3, -99);
                    decimal decSHUTOFFMAX=res1.dblRetValue;
                    if(decSHUTOFFMAX!=null) 
                        return decSHUTOFFMAX;
                    else
                        return 0.0;
                  /*  decimal s1 = currentBGR.Converted_Setting__c*decimal.valueOf(SETTINGMAXFACT);
                    s1.setScale(4);
                    return string.valueOf(s1);*/
                //}
                //else{
                    //return 0.0;
                //}   
            /*if(string.valueOf(currentBGR.Converted_Setting__c) != null)
            {
                result res1;
                res1=unitConversions.SignificantDigitsUp(conpressure*decimal.valueOf(SHUTOFFMINFACT),3, -99);
                string strSHUTOFFMIN=string.valueOf(res1.dblRetValue);
                return strSHUTOFFMIN;
                decimal s1 = currentBGR.Converted_Setting__c*decimal.valueOf(SHUTOFFMINFACT);
                s1.setScale(4);
                return string.valueOf(s1);
            }
            else{
                return '';
            } */
        }
            else return 0.0;
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.SHUTOFFMIN = value;
        }
    }
    
    public string SHUTOFFMINFACT {
        get {
            return mapBGR_Attribute.get('SHUTOFFMINFACT')==null?'0.0': mapBGR_Attribute.get('SHUTOFFMINFACT');
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.SHUTOFFMINFACT = value;
        }
    }
    
    public string TAGMAXACTPRES {
        get {
            return mapBGR_Attribute.get('TAGMAXACTPRES')==null?'': mapBGR_Attribute.get('TAGMAXACTPRES');
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.TAGMAXACTPRES = value;
        }
    }
    
    public string TAGMAXSUPPRES {
        get {
            return mapBGR_Attribute.get('TAGMAXSUPPRES')==null?'': mapBGR_Attribute.get('TAGMAXSUPPRES');
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.TAGMAXSUPPRES = value;
        }
    }
    
    public string CONSTACTTST {
        get{
            return mapBGR_Attribute.get('CONSTACTTST')==null?'': mapBGR_Attribute.get('CONSTACTTST');
        }
        set{
            this.CONSTACTTST=value;
        }
    }
    
    public string CONSTBDYTST {
        get{
            return mapBGR_Attribute.get('CONSTBDYTST')==null?'': mapBGR_Attribute.get('CONSTBDYTST');
        }
        set{
            this.CONSTBDYTST=value;
        }
    }
    
    public string TAGSPRGRANGE {
        get {
            return mapBGR_Attribute.get('TAGSPRGRANGE')==null?'': mapBGR_Attribute.get('TAGSPRGRANGE');
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.TAGSPRGRANGE = value;
        }
    }
    
    public string OA {
        get; 
        //{
           /* String OA02 = '';
            String OA04 = '';
            if(currentBGR.OA02__c != null)
            {
                OA02 = currentBGR.OA02__c;
            }
            if(currentBGR.OA04__c != null)
            {
                OA04 = currentBGR.OA04__c;
            }
            return PTC + OA02 + OA04;*/
            //return currentBGR.OA__c;
        //}
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.OA = value;
            
        }
    }
    
    public string OB250{
        get{
            string OB250;
            string OB250p1;
            string OB250p2;
            if(SERVICE == 'Pressure')
            {
                OB250p1 = 'Pressure Setting: ';
            }
            else
            {
                OB250p1 = 'Vacuum Setting: ';
            }
            if(RTPRSU == RGEUNT)
            {
                OB250p2 = '';
            }
            else
            {
                OB250p2 = GPRSC1 +' ' + RGEUNT;
            }
            return OB250p1+RTPRS1+' '+RTPRSU+'('+OB250p2+')';
        }
        set{
            this.OB250 = value;
            
        }
    }
    
    public string OB {
        get; 
        //{
           /* String OB010 = '', OB050 = '', OB310 = '', OB320 = '', OB410 = '', OB420 = '';
            if(currentBGR.OB010__c != null)
            {
                OB010 = currentBGR.OB010__c;
            }
            if(currentBGR.OB050__c != null)
            {
                OB050 = currentBGR.OB050__c;
            }
            if(currentBGR.OB310__c != null)
            {
                OB310 = currentBGR.OB310__c;
            }
            if(currentBGR.OB320__c != null)
            {
                OB320 = currentBGR.OB320__c;
            }
            if(currentBGR.OB410__c != null)
            {
                OB410 = currentBGR.OB410__c;
            }
            if(currentBGR.OB420__c != null)
            {
                OB420 = currentBGR.OB420__c;
            }
            return OB010 + OB050 + OB250 + OB310 + OB320 + OB410 + OB420;*/
            //return currentBGR.OB__c;
        //}
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.OB = value;
             
        }
    } 
    
    public string OW {
        get; 
        /*{
            if(currentBGR.OW__c != null && string.isNotBlank(currentBGR.OW__c))
            {
                return currentBGR.OW__c;
            }
            else
            {
                return ' ';
            }
        }*/
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.OW = value;
            
        }
    } 
    
    // public decimal ListPriceEach
    // {
    //     get{
    //         if(currentBGR.List_Price_Each__c != null)
    //         {
    //             return currentBGR.List_Price_Each__c;
    //         }
    //         else{
    //             return 0.0;
    //         }
    //     }
    // }
    
    public string DocumentID {
        get{
            if(currentBGR.Document_ID__c != null)
            {
                return currentBGR.Document_ID__c;
            }
            else{
                return '';
            }
        }
        set{
            this.DocumentID=value;
        }
    }
    
    /*
* To fecth the Part Number Globally across all the BGR ouputs
* * Created by Vinayak Singh
*/
    decimal PartNumberCounter = 00000;
    // String PartNumber = '';
    
    //*********************
    /*
* To fecth the Part Number Description Globally across all the BGR ouputs
* * Created by Vinayak Singh
*/
    String PartNumberDesc = '';
    
    //*********************
    public map<string,string> getMapAttribute() 
    {
        Map<String, string> mapBGR_Attribute1 = new Map<String, string>(); 
        result BGRAttributes = new Result();
        List<String> selectCols = new List<String> {'Text__c','Value__c','Attribute__c'};
        System.debug('@@PTC is '+mapBGRAttr.get('PTC'));
        System.debug('@@SZC is '+mapBGRAttr.get('SZC'));
        System.debug('@@HCLASS is '+mapBGRAttr.get('HCLASS'));
        BGRAttributes=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','BGR_Attribute_lookup_Translation__c','BGR_Attribute_lookup_Details__c',mapBGRAttr,selectCols);
        if(BGRAttributes.bResult)
        { 
            for(sObject objD : BGRAttributes.objResultList)
            {
                BGR_Attribute_lookup_Details__c bgrLookupData = (BGR_Attribute_lookup_Details__c)objD;
                if(bgrLookupData.Text__c != null && bgrLookupData.Value__c == null)
                {
                    mapBGR_Attribute1.put(bgrLookupData.Attribute__c, bgrLookupData.Text__c);
                }
                if(bgrLookupData.Text__c == null && bgrLookupData.Value__c != null)
                {
                    mapBGR_Attribute1.put(bgrLookupData.Attribute__c, bgrLookupData.Value__c);
                }
                if(bgrLookupData.Text__c != null && bgrLookupData.Value__c != null)
                {
                    mapBGR_Attribute1.put(bgrLookupData.Attribute__c, bgrLookupData.Text__c+' '+bgrLookupData.Value__c);
                }
                if(bgrLookupData.Text__c == null && bgrLookupData.Value__c == null)
                {
                    mapBGR_Attribute1.put(bgrLookupData.Attribute__c, '');
                }
                mapBGRAttr.put(bgrLookupData.Attribute__c,mapBGR_Attribute1.get(bgrLookupData.Attribute__c));
                System.debug('***** Adding into map as key = '+bgrLookupData.Attribute__c+' and value = '+(bgrLookupData.Text__c+' '+bgrLookupData.Value__c));
            }
        }
       
        return mapBGR_Attribute1;
    }
    public String getSerializedDataFromList (sObject[] listObject) {
        String strJSON='';
        try {
            strJSON=JSON.serialize(listObject);
        } catch (Exception e) { 
            //System.debug('The following exception has occurred: wizardBaseDataProcessor:getSerializedDataFromList()' + e.getMessage());
        }
        return strJSON;
    } 

    public Map<string,string> getTroubleShootingBGRAttr(){
        Map<String, string> myMap1 = new Map<String, String>(); 
        myMap1.put('ASSEMBLYWT',ASSEMBLYWT);
        myMap1.put('BRANDCODE',BRANDCODE);
        myMap1.put('COMPINVSERTRK',COMPINVSERTRK);
        myMap1.put('COMPPROVIDE',COMPPROVIDE);
        myMap1.put('CONSTBDYTST',CONSTBDYTST);
        myMap1.put('CUSTOMSTATNO',CUSTOMSTATNO);
        myMap1.put('HSNSACCODE',HSNSACCODE);
        myMap1.put('OPTIONCODE',OPTIONCODE);
        myMap1.put('PARTUOM',PARTUOM);
        myMap1.put('PC220',PC220);
        myMap1.put('PC320',PC320);
        myMap1.put('PC420',PC420);
        myMap1.put('PNMODEL',PNMODEL);
        myMap1.put('PRESRATIO',PRESRATIO);
        myMap1.put('RESPONSIBLE_ID',RESPONSIBLE_ID);
        myMap1.put('SALESPRICEGROUP',SALESPRICEGROUP);
        myMap1.put('SETTINGMAXFACT',SETTINGMAXFACT);
        myMap1.put('SHUTOFFMAXFACT',SHUTOFFMAXFACT);
        myMap1.put('SOURCINGOPT',SOURCINGOPT);
        myMap1.put('ASSEMBLYWTUOM',ASSEMBLYWTUOM);
        myMap1.put('ATTRTEMPLATE',ATTRTEMPLATE);
        myMap1.put('COMPDESCRIPTION',COMPDESCRIPTION);
        myMap1.put('COMPLOTTRACK',COMPLOTTRACK);
        myMap1.put('CONSTACTTST',CONSTACTTST); 
        //decimal decGSPRSC=decimal.valueOf(GSPRSC);
        string strGSPRSC=GSPRSC.stripTrailingZeros().toPlainString();
        myMap1.put('GSPRSC',strGSPRSC);
        myMap1.put('LOTTRACKCODE',LOTTRACKCODE);
        myMap1.put('PARTCLASS',PARTCLASS);
        myMap1.put('PC210',PC210);
        myMap1.put('PC310',PC310);
        myMap1.put('PC410',PC410);
        myMap1.put('PLANNER',PLANNER);
        myMap1.put('PNSIZE',PNSIZE);
        myMap1.put('PROVIDE',PROVIDE);
        myMap1.put('SALESGROUP',SALESGROUP);
        myMap1.put('SERIALTRACKCODE',SERIALTRACKCODE);
        myMap1.put('SETTINGMINFACT',SETTINGMINFACT);
        myMap1.put('SHUTOFFMINFACT',SHUTOFFMINFACT);
       // decimal decTEMPDEGR=decimal.valueOf(TEMPDEGR);
      //  string strTEMPDEGR=decTEMPDEGR.stripTrailingZeros().toPlainString();
        myMap1.put('TEMPDEGR',TEMPDEGR);
        return myMap1;
    }       
    // Public Result getMapAttribute()
    // {
    //     result BGRAttributes = new Result();
    //     List<String> selectCols = new List<String> {'Text__c','Value__c','Attribute__c'};
    //     BGRAttributes=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','BGR_Attribute_lookup_Translation__c','BGR_Attribute_lookup_Details__c',mapBGRAttr,selectCols);
    //     if(BGRAttributes.bResult)
    //     { 
    //         system.debug('***Attribute Result' +BGRAttributes.objResultList);
    //         String BGRAttributeText = (String)BGRAttributes.objResultList[0].Text__c;
    //         String BGRAttributeValue = (String)BGRAttributes.objResultList[0].Text__c;
    //         mapBGRAttr.put('Attribute', BGRAttributeText+' '+BGRAttributeValue);
    //     }
    //     return BGRAttributes;
    // }
    
    //Method to get PARTNUMBER value
    public result getPartNumber(){
        result res=new result();
        string prtnu=PARTNUMBER;
        if(prtnu!=null) {
            res.bResult=true;
            res.strRetValue=PARTNUMBER;
        }
        return res;
    }
    
    //list<BGMStructureWrapper>
    public Result getStructure() {
        //list<BGMStructureWrapper> BGMStructureList = new list<BGMStructureWrapper>();
        result strcResult=new result();
        if(PTC != null && SZC !=null && MCBODY !=null && MCDPHM !=null && XRAY !=null && MATLSOURCE !=null && HCLASS !=null && SETINWC!=null )
        {
            List<String> selectCols=new List<String>{'Component_part__c','SpringCode__c','Qty_per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Line_Item_No__c'};
                system.debug('*****selectCols'+selectCols);
                String strPTC='\''+PTC+'\'';
            String strSZC='\''+SZC+'\'';
            String strMCBODY='\''+MCBODY+'\'';
            String strMCDPHM='\''+MCDPHM+'\'';
            String strXRAY='\''+XRAY+'\'';
            String strMATLSOURCE='\''+MATLSOURCE+'\'';
            String strHCLASS='\''+HCLASS+'\'';
            String strSETINWC=''+SETINWC+'';
            System.debug('SETINWC--------' +SETINWC);
            List<String> whereCols=new List<String>{'Model__c','SZC__c','MCBODY__c','SoftGoods__c','Radiography__c','Sourcing__c','ConnectionCode__c','SettingLL__c','SettingUL__c'};
                List<String> whereVals=new List<String>{strPTC,strSZC,strMCBODY,strMCDPHM,strXRAY,strMATLSOURCE,strHCLASS,strSETINWC,strSETINWC};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','=','=','<=','>'};
                        List<String> extraChars=new List<String>{'-','-','-','-','-','-','-','',''};  
                            strcResult=wizardBaseDataProcessor.getProdOutputDescData1('BGR_Structures__c',selectCols,whereCols,whereVals,whereComps,extraChars,'Line_Item_No__c');
            if(strcResult.bResult)
            { 
                system.debug('Final List' +strcResult.objResultList );
                
            }          
        }
        return strcResult;
    }   
    //*********************************************
    //BGR Output for Pricing
    /* public Result getPricing() {
// list<BGRPricingwrapper> BGRPricingList = new list<BGRPricingwrapper>();
result prncgResult=new result();
if(PTC != null && SZC != null && MCBODY != null && MCDPHM != null && XRAY != null && MATLSOURCE != null && HCLASS != null && PMI != null && SHLTSTMETHACT != null && SHLTSTMETHBDY != null && ASSYLOCATION != null)
{
List<String> selectCols=new List<String>{'ID','Price__c','PricingElement__c', 'Price_Override__c'};
String strPTC='\''+PTC+'\'';
String strSZC='\''+integer.valueOf(SZC)+'\'';
String strMCBODY='\''+integer.valueOf(MCBODY)+'\'';
String strMCDPHM='\''+MCDPHM+'\'';
String strHCLASS='\''+HCLASS+'\'';
String strATEX='\''+ATEX+'\'';
String strCUTR='\''+CUTR+'\'';
String strCSA='\''+CSA+'\'';
String strXRAY='\''+XRAY+'\'';
String strPMI='\''+PMI+'\'';
String strSHLTSTMETHACT='\''+SHLTSTMETHACT+'\'';
String strSHLTSTMETHBDY='\''+SHLTSTMETHBDY+'\'';
String strASSYLOCATION='\''+ASSYLOCATION+'\'';
String strMATLSOURCE='\''+MATLSOURCE+'\'';
List<String> whereCols=new List<String>{'Model__c','SizeCode__c','BodyMatlCode__c','SoftGoodsMatlCode__c','ConnectionCode__c','ATEX__c','CUTR__c','CSA__c','XRAY__c','PMI__c','SHLTSTMETHACT__c','SHLTSTMETHBDY__c','ASSYLOCATION__c','MATLSOURCE__c'};
List<String> whereVals=new List<String>{strPTC,strSZC,strMCBODY,strMCDPHM,strHCLASS,strATEX,strCUTR,strCSA,strXRAY,strPMI,strSHLTSTMETHACT,strSHLTSTMETHBDY,strASSYLOCATION,strMATLSOURCE};
List<String> whereComps=new List<String>{'=','=','=','=','=','=','=','=','=','=','=','=','=','='};
List<String> extraChars=new List<String>{'-','-','-','-','-','-','-','-','-','-','-','-','-','-'};  
prncgResult=wizardBaseDataProcessor.getProdOutputDescData('BGR_Pricing__c',selectCols,whereCols,whereVals,whereComps,extraChars);
if(prncgResult.bResult)
{ 
system.debug('Pricing list' +prncgResult.objResultList );

} 
}
return prncgResult;
} */
    Public Result getPricing()
    {
        result BGRPrice = new Result();
        List<String> selectCols = new List<String> {'Price__c','Pricing_Element__c'};
            BGRPrice=wizardBaseDataProcessor.getSortedDataFromTranslationObj('Pricing_Element__c','BGR_Price_Translation__c','BGR_Price_Details__c',mapBGRAttr,selectCols,'Pricing_Element__c');
        if(BGRPrice.bResult)
        { 
            system.debug('***Pricing Result' +BGRPrice.objResultList);
            
        } 
        return BGRPrice;
    }
    //**********************************************
    //BGR output for Lead time
    //** The Lead time method below is commented as this does not support the dynamic OR condition
    //** A new Method is created just below the commented code
    //@ Commented by: Vinayak Singh
    /*public Result getLeadTime() {
result LDTResult=new result();
if(Schedule != null && QTY != null)
{
List<String> selectCols=new List<String>{'Site_10__c','Site_20__c','Site_30__c','Site_40__c'};
String strSchedule='\''+Schedule+'\'';
String strQTY=''+QTY+'';
List<String> whereCols=new List<String>{'Schedule__c','QtyLL__c','QtyUL__c'};
List<String> whereVals=new List<String>{strSchedule,strQTY,strQTY};
List<String> whereComps=new List<String>{'=','<=','>='};
List<String> extraChars=new List<String>{'-','',''};  
LDTResult=wizardBaseDataProcessor.getProdOutputDescData('BGR_lead_time__c',selectCols,whereCols,whereVals,whereComps,extraChars);
if(LDTResult.bResult)
{ 
//system.debug('Lead Time list' +LDTResult.objResultList );

} 
}
return LDTResult;
} */
    
    // ** The New Lead time ouput method
    // ** This method supports the OR condition required for Base Lead time and Lead time Adder
    // @ Created by Vinayak Singh
    public list<BGR_lead_time__c> GetLeadTimeRec()
    {
        list<BGR_lead_time__c> BGRLT = new list<BGR_lead_time__c>();
        String SOQL = 'select ID, Schedule__c, Site_10__c, Site_20__c,Site_30__c,Site_40__c,Lead_Time_10_Override__c,Lead_Time_20_Override__c,Lead_Time_30_Override__c,Lead_Time_40_Override__c';
        SOQL += ' From BGR_lead_time__c ';
        SOQL += ' where (Schedule__c=: Schedule OR Schedule__c=: Schedule2) and QtyLL__c <: QTY and QtyUL__c >=: QTY';
        System.debug('@@**Lead list oupt :'+SOQL);
        BGRLT = database.query(SOQL);
        System.debug('@@**Lead list Schedule :'+Schedule2 +'Schedule' +Schedule + 'QTY'+QTY);
        return BGRLT;
    }
    public list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPM()
    {
        Boolean isFlag = false;
        list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = new list<Global_Site_Part_Parameters_ISPM__c>();
        String SOQL = 'Select InventorySite__c,InventoryPartType__c,InventoryPartTemplate_ID__c,SalesSite__c,Sourcing_Option__c,PurchaseSite__c,PurchasePartTemplate_ID__c,MfgSite__c';
        SOQL += ' From Global_Site_Part_Parameters_ISPM__c ';
        if(currentBGR.Lead_Time_Site_10__c != null)
        {
            isFlag = true;
            SOQL += ' where (SITE__c = \'10\' and LeadTimeLL__c <='+currentBGR.Lead_Time_Site_10__c+' and LeadTimeUL__c >'+currentBGR.Lead_Time_Site_10__c+' and SERIALTRACKCODE__c =\''+INV_SERIAL_TRACKING+'\')';
        }
        if(currentBGR.Lead_Time_Site_20__c != null)
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
            SOQL += ' (SITE__c = \'20\' and LeadTimeLL__c <='+currentBGR.Lead_Time_Site_20__c+' and LeadTimeUL__c >'+currentBGR.Lead_Time_Site_20__c+' and SERIALTRACKCODE__c =\''+INV_SERIAL_TRACKING+'\')';
        }
        if(currentBGR.Lead_Time_Site_30__c != null)
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
            SOQL += ' (SITE__c = \'30\' and LeadTimeLL__c <='+currentBGR.Lead_Time_Site_30__c+' and LeadTimeUL__c >'+currentBGR.Lead_Time_Site_30__c+' and SERIALTRACKCODE__c =\''+INV_SERIAL_TRACKING+'\')';
        }
        if(currentBGR.Lead_Time_Site_40__c != null)
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
            SOQL += ' (SITE__c = \'40\' and LeadTimeLL__c <='+currentBGR.Lead_Time_Site_40__c+' and LeadTimeUL__c >'+currentBGR.Lead_Time_Site_40__c+' and SERIALTRACKCODE__c =\''+INV_SERIAL_TRACKING+'\')';
        }
        system.debug('The Query is: '+SOQL);
        GlobalSiteParametersISPMList = database.query(SOQL);
        system.debug('The ISPM list is:'+GlobalSiteParametersISPMList);
        
        return GlobalSiteParametersISPMList; 
    }
    //** Quote Description ouput method
    //** TO retrive various parts of Quote outputs
    // public list<BGR_Attribute_table_lookup__c> GetQuoteDescriptionRec()
    // {
    //     list<BGR_Attribute_table_lookup__c> BGRQD = new list<BGR_Attribute_table_lookup__c>();
    //     BGRQD = [select ID, Attribute__c, Text__c,Description_Override__c 
    //              From BGR_Attribute_table_lookup__c 
    //              where (Attribute__c like 'O%')          
    //              and (Brand__c =: BRAND OR Brand__c =: '-') and (Model__c =: PTC OR Model__c = '-') and (SZC__c =: SZC  OR SZC__c = '-') and (MCBODY__c =: MCBODY OR MCBODY__c = '-') and (MCDPHM__c =: MCDPHM OR MCDPHM__c = '-')
    //              and (HCLASS__c =: currentBGR.Connection__c OR HCLASS__c = '-') and (SETTINGLL__c <=: SETINWC) and (SETTINGUL__c >=: SETINWC) and (PRESSUOM__c =: SETINUOM OR PRESSUOM__c = '-') and (ATEX__c =: ATEX OR ATEX__c = '-') 
    //              and (CUTR__c =: CUTR OR CUTR__c = '-') and (CSA__c =: CSA OR CSA__c = '-') and (SHLTSTMETHBDY__c =: SHLTSTMETHBDY OR SHLTSTMETHBDY__c = '-') and (SHLTSTMETHACT__c =: SHLTSTMETHACT OR SHLTSTMETHACT__c = '-')             
    //              and (XRAY__c =: XRAY OR XRAY__c = '-') and (PMI__c =: PMI OR PMI__c = '-') and (ASSYLOCATION__c =: ASSYLOCATION OR ASSYLOCATION__c = '-') and (MATLSOURCE__c =: MATLSOURCE OR MATLSOURCE__c = '-')];
    //     //system.debug('***query result'+BGRQD);
    //     return BGRQD;
    // }
    
    public Map<String, String> GetAttributeMapQuoteDescription()
    {
        Map<String, String> quoteAttriVsDesc = new Map<String, String>();
        if(mapBGR_Attribute.size() > 0)
        {
            List<String> quoteKey = new List<String>((mapBGR_Attribute).Keyset());
            quoteKey.sort();
            for(String mapKey: quoteKey)
            {
                if(mapKey.startsWithIgnoreCase('O'))
                {
                    quoteAttriVsDesc.put(mapKey,mapBGR_Attribute.get(mapKey));
                }
            }
        }
        return quoteAttriVsDesc;
    }
    // * Method for BGR Product Documents
    /* public Result getProDoc() {
result PDResult=new result();
if(PTC != null && SZC != null && HCLASS != null)
{
List<String> selectCols=new List<String>{'AssemblyDrawing__c','FileName__c'};
String strPTC='\''+PTC+'\'';
String strSZC='\''+integer.valueOf(SZC)+'\'';
String strHCLASS='\''+HCLASS+'\'';
List<String> whereCols=new List<String>{'Model__c','SZC__c','ConnectionCode__c'};
List<String> whereVals=new List<String>{strPTC,strSZC,strHCLASS};
List<String> whereComps=new List<String>{'=','=','='};
List<String> extraChars=new List<String>{'-','-','-'};  
PDResult=wizardBaseDataProcessor.getProdOutputDescData('BGR_Product_document__c',selectCols,whereCols,whereVals,whereComps,extraChars);
if(PDResult.bResult)
{ 
system.debug('Product Document list' +PDResult.objResultList );

} 
} 
return PDResult;
} */
    
    Public Result getProDoc()
    {
        result BGRDoc = new Result();
        List<String> selectCols = new List<String> {'Document__c','Document_ID__c'};
            BGRDoc=wizardBaseDataProcessor.getDataFromTranslationObj('Document__c','BGR_Documents_Translation__c','BGR_Documents_Details__c',mapBGRAttr,selectCols);
        if(BGRDoc.bResult)
        { 
            // system.debug('***Product Document Result' +BGRDoc.objResultList);
            
        } 
        return BGRDoc;
    }
    // BGR outputs for Working Guidelines
    Public Result getGuildeline()
    {
        result BGRWG = new Result();
        List<String> selectCols = new List<String> {'Operation__c','GuidlineSeq__c','Description__c','Text__c','Type__c','Sign_Off__c','Inspection_Sign_Off_Required__c'};
            BGRWG=wizardBaseDataProcessor.getDataFromTranslationObj('GuidlineSeq__c','BGR_WorkGuide_Translation__c','BGR_WorkGuide_Details__c',mapBGRAttr,selectCols);
       // if(BGRWG.bResult)
       // { 
            //system.debug('***Work Guidelines Result' +BGRWG.objResultList);
            
       // } 
        return BGRWG;
    }
    /*public Result getGuildeline() {
result WGResult=new result();
if(XRAY != null && PMI != null)
{
List<String> selectCols=new List<String>{'Operation__c','Description__c','Text__c'};
String strATEX='\''+ATEX+'\'';
String strCUTR='\''+CUTR+'\'';
String strCSA='\''+CSA+'\'';
String strXRAY='\''+XRAY+'\'';
String strPMI='\''+PMI+'\'';
List<String> whereCols=new List<String>{'ATEX__c','CUTR__c','CSA__c','XRAY__c','PMI__c'};
List<String> whereVals=new List<String>{strATEX,strCUTR,strCSA,strXRAY,strPMI};
List<String> whereComps=new List<String>{'=','=','=','=','='};
List<String> extraChars=new List<String>{'-','-','-','-','-'};  
WGResult=wizardBaseDataProcessor.getProdOutputDescData('BGR_Work_Guidelines__c',selectCols,whereCols,whereVals,whereComps,extraChars);
if(WGResult.bResult)
{ 
system.debug('Work Guidelines list' +WGResult.objResultList );

} 
} 
return WGResult;
} */
    // BGR outputs for Routing Guidelines  
    public Result getRouting() {
        result RResult=new result();
        if(PMI != null)
        {
            List<String> selectCols=new List<String>{'Standard_Operation_Id__c,Operation_Number__c,Outside_Operation_Item__c,Descr__c'};
                String strPMI='\''+PMI+'\'';
            List<String> whereCols=new List<String>{'Positive_Material_Identification__c'};
                List<String> whereVals=new List<String>{strPMI};
                    List<String> whereComps=new List<String>{'='};
                        List<String> extraChars=new List<String>{'-'};  
                            RResult=wizardBaseDataProcessor.getProdOutputDescData1('BGR_Routing__c',selectCols,whereCols,whereVals,whereComps,extraChars,'Operation_Number__c');
            if(RResult.bResult)
            { 
                //system.debug('*@*Routing Guidelines list' +RResult.objResultList );
                
            } 
        } 
        return RResult;
    }
    // BGR outputs for Control Plan
    /* public Result GetControlPlan()
{
result BGRControlPlangResult=new result();
Dom.Document doc = new Dom.Document();
if(RGEUNT != null)
{
List<String> selectCols=new List<String>{'Reciept_Not_Allowed__c', 'Test_OPNO__c', 'Cus_Test_OPNO__c', 'Test_Operation_Desc__c', 'Norm_Type__c', 'Cus_Operation_Number__c', 'Data_Type__c', 'Category_ID__c', 'Outer_Min__c', 'Inner_Min__c', 'Nominal_Value__c', 'Process_Characteristic__c', 'Special_Characteristic_Classification__c', 'Outer_Max__c', 'Inner_Max__c', 'Inspection_Code__c', 'Tool_ID__c', 'Data_Point__c,Connected_To_Trigger__c,Simplified_Revision_Handling__c,Connected_To_Tools__c,Mandatory__c'};
String strRGEUNT='\''+RGEUNT+'\'';
List<String> whereCols=new List<String>{'RGEUNT__c'};
List<String> whereVals=new List<String>{strRGEUNT};
List<String> whereComps=new List<String>{'='};
List<String> extraChars=new List<String>{'-'};  
BGRControlPlangResult=wizardBaseDataProcessor.getProdOutputDescData('BGR_Control_Plan__c',selectCols,whereCols,whereVals,whereComps,extraChars);
if(BGRControlPlangResult.bResult)
{
//system.debug('*@*Control plan list' +BGRControlPlangResult.objResultList );
}
} 
return BGRControlPlangResult;
} */
    
    /*
* Method to set the part number and call the XML methods
*/
    /* public void callXMLMethods(String quoteLineId)
{
if(String.isNotBlank(quoteLineId))
{
//V3011H1X500c0t00001
////'V'+PTC+SZC+'X'+MCBODY+'00'+MCDPHM+'0'+HCLASS+'00001';
BGR_Part_Number__c bgrNewRecord = new BGR_Part_Number__c();
List<BGR_Part_Number__c> bgrPartNumberRecord = new List<BGR_Part_Number__c>();
bgrPartNumberRecord = [Select id, PartNumber__c,Part_Number_Sequence__c from BGR_Part_Number__c where Quote_Line__c =:quoteLineId];
if(bgrPartNumberRecord.size() > 0)
{
bgrNewRecord = bgrPartNumberRecord[0];
PARTNUMBER = 'V'+PTC+SZC+'X'+MCBODY+'00'+MCDPHM+'0'+HCLASS+bgrNewRecord.Part_Number_Sequence__c;
bgrNewRecord.PartNumber__c = PARTNUMBER;
}
/* else
{
AggregateResult[] bgrPartNumberAggregateResult = [SELECT MAX(Part_Number_Sequence__c)partNumberSequence FROM BGR_Part_Number__c];
if(bgrPartNumberAggregateResult.size() > 0)
{
System.debug('***** part sequence number = '+bgrPartNumberAggregateResult[0].get('partNumberSequence'));
Integer partSequenceNumber = Integer.valueOf(bgrPartNumberAggregateResult[0].get('partNumberSequence')) + 1;
String formattedPartSequenceNumber = partSequenceNumber+'';
formattedPartSequenceNumber = formattedPartSequenceNumber.leftPad(5, '0');
PARTNUMBER = 'V'+PTC+SZC+'X'+MCBODY+'00'+MCDPHM+'0'+HCLASS+''+formattedPartSequenceNumber;
}
}*/
    /* bgrNewRecord.Quote_Line__c = quoteLineId;
bgrNewRecord.ASSYLOCATION__c = ASSYLOCATION;
bgrNewRecord.ATEX__c = ATEX;
bgrNewRecord.CSA__c = CSA;
bgrNewRecord.CUTR__c = CUTR;
bgrNewRecord.Orifice_Setting__c = OrificeSetting;
bgrNewRecord.GORIFC__c = GORIFC;
bgrNewRecord.HCLASS__c = HCLASS;
bgrNewRecord.MATLSOURCE__c = MATLSOURCE;
bgrNewRecord.MCBODY__c = MCBODY;
bgrNewRecord.MCDPHM__c = MCDPHM;

//bgrNewRecord.PartRevision__c = ;
bgrNewRecord.PMI__c = PMI;
bgrNewRecord.PTC__c = PTC;
bgrNewRecord.RTPRS1__c = RTPRS1;
bgrNewRecord.RTPRSU__c = RTPRSU;
bgrNewRecord.SERVICE__c = SERVICE;
bgrNewRecord.SHLTSTMETHACT__c = SHLTSTMETHACT;
bgrNewRecord.SHLTSTMETHBDY__c = SHLTSTMETHBDY;
bgrNewRecord.SZC__c = SZC;
bgrNewRecord.XRAY__c = XRAY;

if(bgrPartNumberRecord.size() > 0)
{
update bgrNewRecord;
}
else
{
insert bgrNewRecord;
BGR_Part_Number__c bgrPartSequence = [SELECT id,Part_Number_Sequence__c from BGR_Part_Number__c where id =:bgrNewRecord.id];
PARTNUMBER = 'V'+PTC+SZC+'X'+MCBODY+'00'+MCDPHM+'0'+HCLASS+bgrPartSequence.Part_Number_Sequence__c;
bgrPartSequence.PartNumber__c = PARTNUMBER;
update bgrPartSequence;
}
//Result engineeringParts = getEngineeringParts();
//Result salesParts = getSalesParts();
//Result purchasePartParts = getPurchasePartSuppliers();
//Result productCatalog = getProductCatalog();

}
} */
    /*public string getPartNum() {
//BGROutputUtility prtNum = new BGROutputUtility(conBGR.Id);
String rstPartNumber='';
if(String.isNotBlank(QuoteLine))
{
BGR_Part_Number__c bgrNewRecord = new BGR_Part_Number__c();
List<BGR_Part_Number__c> bgrPartNumberRecord = new List<BGR_Part_Number__c>();
bgrPartNumberRecord = [Select id, PartNumber__c,Part_Number_Sequence__c from BGR_Part_Number__c where Quote_Line__c =:QuoteLine];
if(bgrPartNumberRecord.size() > 0)
{
bgrNewRecord = bgrPartNumberRecord[0];
rstPartNumber = 'V'+PTC+SZC+'X'+MCBODY+'00'+MCDPHM+'0'+HCLASS+bgrNewRecord.Part_Number_Sequence__c;
bgrNewRecord.PartNumber__c = rstPartNumber;
}
bgrNewRecord.Quote_Line__c = QuoteLine;
bgrNewRecord.ASSYLOCATION__c = ASSYLOCATION;
bgrNewRecord.ATEX__c = ATEX;
bgrNewRecord.CSA__c = CSA;
bgrNewRecord.CUTR__c = CUTR;
//bgrNewRecord.GORIFC__c = GORIFC;
bgrNewRecord.HCLASS__c = HCLASS;
bgrNewRecord.MATLSOURCE__c = MATLSOURCE;
bgrNewRecord.MCBODY__c = MCBODY;
bgrNewRecord.MCDPHM__c = MCDPHM;
//bgrNewRecord.PartRevision__c = ;
bgrNewRecord.PMI__c = PMI;
bgrNewRecord.PTC__c = PTC;
//bgrNewRecord.RTPRS1__c = ;
//bgrNewRecord.RTPRSU__c = ;
//bgrNewRecord.SERVICE__c = ;
bgrNewRecord.SHLTSTMETHACT__c = SHLTSTMETHACT;
bgrNewRecord.SHLTSTMETHBDY__c = SHLTSTMETHBDY;
bgrNewRecord.SZC__c = SZC;
bgrNewRecord.XRAY__c = XRAY;       
if(bgrPartNumberRecord.size() > 0)
{
update bgrNewRecord;
}
else
{
insert bgrNewRecord;
BGR_Part_Number__c bgrPartSequence = [SELECT id,Part_Number_Sequence__c from BGR_Part_Number__c where id =:bgrNewRecord.id];
rstPartNumber = 'V'+PTC+SZC+'X'+MCBODY+'00'+MCDPHM+'0'+HCLASS+bgrPartSequence.Part_Number_Sequence__c;
bgrPartSequence.PartNumber__c = rstPartNumber;
update bgrPartSequence;
}
}
return rstPartNumber;
}*/
    /*
* Method to fetch the Engineering parts
* The ouput to be converted to XML
*/
    public result getEngineeringParts() {
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
    /*
* Method to fetch the Sales parts
* The ouput to be converted to XML
*/  
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
    /*
* Method to fetch the Purchase parts Supplier
* The ouput to be converted to XML
*/  
    public result getPurchasePartSuppliers() {
        result resultSuppliers=new result();
        list<Global_Site_Part_Parameters_PPS__c> GlobalSiteParametersPPSList = getGlobalSitePPS();
        Dom.Document doc = new Dom.Document();
        //string PARTNUMBER1=getPartNum();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'PURCHASE_PART_SUPPLIER_LIST', null); 
        if(GlobalSiteParametersPPSList.size() > 0)
        {
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
                System.debug('*** currentBGR = '+currentBGR.List_Price_Each__c);
                w.writeCharacters(currentBGR.List_Price_Each__c != null ? currentBGR.List_Price_Each__c+'' : '');
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
    
    public result getProductCatalog() {
        result resultCatalog=new result();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'PART_CATALOG_REC', null); 
        w.writeStartElement(null, 'PART_CATALOG', null); 
        w.writeStartElement(null, 'WEIGHT_NET', null);  
        w.writeCharacters(ASSEMBLYWT);
        w.writeEndElement();
        w.writeStartElement(null, 'UOM', null);  
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
    
    /*
* Method to fetch the Purchase parts
* The ouput to be converted to XML
*/  
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
    
    
    
    // ****************************************
    /*
* Method: GetRoutingDetails
* Description: Return BGR routing details
* @Param1: PMI => Positive Material Identification  
* @Written By: Susheel
*/ 
    public Result GetRoutingDetails()
    {
        result BGRRoutingResult=new result();
        Dom.Document doc = new Dom.Document();
        List<BGR_Routing__c> lstBR = [Select Standard_Operation_Id__c,Operation_Number__c,Outside_Operation_Item__c
                                      FROM BGR_Routing__c 
                                      Where (Positive_Material_Identification__c =: PMI or  Positive_Material_Identification__c = '-')];
        
        List<BGR_WorkGuide_Details__c> lstGL = new List<BGR_WorkGuide_Details__c>();
        /*[Select Guideline_Type__c,Sign_Off_Required__c,Inspection_Sign_Off_Required__c,Guideline_Text__c,Guideline_Sequence__c,
                                       Guideline_Description__c  
                                       from BGR_Guideline__c  
                                       Where (Atex__c =:ATEX or Atex__c = '-') and 
                                       (CUTR__c =:CUTR or CUTR__c = '-') and 
                                       (CSA__c =:CSA or CSA__c = '-') and 
                                       (XRAY__c =:XRAY or XRAY__c = '-') and 
                                       (Positive_Material_Identification__c =:PMI or Positive_Material_Identification__c = '-') and 
                                       (Operation_Number__c = '30')];*/
        Result bgrGuideLineResult = getGuildeline();
        if(bgrGuideLineResult.bResult && bgrGuideLineResult.objResultList.size() > 0)
        {
            for(sObject objResult: bgrGuideLineResult.objResultList)
            {
                BGR_WorkGuide_Details__c bgrGuideLine = (BGR_WorkGuide_Details__c)objResult;
                System.debug('Operation number@@'+bgrGuideLine.Operation__c);
                if(bgrGuideLine.Operation__c == '30')
                {
                    lstGL.add(bgrGuideLine);
                }
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
                        for(BGR_Routing__c brRec: lstBR)
                        {
                            //BGR_Routing__c brRec = (BGR_Routing__c)sRec;
                            xmlW.writeStartElement(null,'ROUTING_OPERATION',null);                
                            xmlW.writeStartElement(null,'OPERATION_NO',null);
                            xmlW.writeCharacters(brRec.Operation_Number__c);
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
                            // system.debug('Operation number guide@@@'+brRec.Operation__c);
                            if(brRec.Operation_Number__c == '30'){
                                if(lstGL.size()>0)
                                {
                                    xmlW.writeStartElement(null,'ROUTING_OPER_WORK_GUIDE_LIST',null);
                                    for(BGR_WorkGuide_Details__c bgRec: lstGL)
                                    {
                                        xmlW.writeStartElement(null,'ROUTING_OPER_WORK_GUIDE',null);
                                        xmlW.writeStartElement(null,'GUIDELINE_SEQ',null);
                                        xmlW.writeCharacters(bgRec.GuidlineSeq__c);
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
           /* xmlW.writeEndElement(); //ROUTING_OPERATION_LIST end
            xmlW.writeStartElement(null,'ROUTING_CHAR_LIST',null);
            xmlW.writeStartElement(null,'ROUTING_CHAR',null);
            xmlW.writeStartElement(null,'CHAR_TEMPLATE',null);
            xmlW.writeEndElement(); // CHAR_TEMPLATE end  
            //xmlW.writeEndElement(); // ROUTING_CHAR end      
            xmlW.writeEndElement(); // ROUTING_CHAR end
            xmlW.writeEndElement(); // ROUTING_CHAR_LIST end*/
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
    /*
* Method: GetControlPlanDetails
* Description: Return BGR Control Plan details
*/ 
public Result GetControlPlanDetails()
{
    result BGRControlPlangResult=new result();
    Dom.Document doc = new Dom.Document();
    string OuterMinValue = '';
    string InnerMinValue = '';
    string NominalValue = '';
    string InnerMaxValue = '';
    string OuterMaxValue = '';
    if(RGEUNT != null)
    {
        List<String> selectCols=new List<String>{'Reciept_Not_Allowed__c', 'Cus_Test_OPNO__c', 'Test_Operation_Desc__c', 'Norm_Type__c', 'Cus_Operation_Number__c', 'Data_Type__c', 'Category_ID__c', 'Outer_Min__c', 'Inner_Min__c', 'Nominal_Value__c', 'Process_Characteristic__c','Test_OPNO__c', 'Special_Characteristic_Classification__c', 'Outer_Max__c', 'Inner_Max__c', 'Inspection_Code__c', 'Tool_ID__c', 'Data_Point__c,Connected_To_Trigger__c,Simplified_Revision_Handling__c,Connected_To_Tools__c,Mandatory__c','Operation_Number__c'};
            String strRGEUNT='\''+RGEUNT+'\'';
        List<String> whereCols=new List<String>{'RGEUNT__c'};
        List<String> whereVals=new List<String>{strRGEUNT};
        List<String> whereComps=new List<String>{'='};
        List<String> extraChars=new List<String>{'-'};  
        BGRControlPlangResult = wizardBaseDataProcessor.getProdOutputDescData1('BGR_Control_Plan__c',selectCols,whereCols,whereVals,whereComps,extraChars,'Cus_Test_OPNO__c');
        system.debug('Control plan result is'+BGRControlPlangResult);
        if(BGRControlPlangResult.bResult)
        { 
            list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = GlobalSiteParametersISPM(); 
            Xmlstreamwriter xmlW = new Xmlstreamwriter();
            xmlW.writeStartDocument('utf-8','1.0');
            
            xmlW.writeStartElement(null,'CONTROL_PLAN_MANUF_LIST', null);
            Set<String> toolIdSet = new Set<String>();
            Set<String> dataPointSet = new Set<String>();
            List<BGR_Control_Plan__c> connectionList = new List<BGR_Control_Plan__c>();
            for(sObject sRec: BGRControlPlangResult.objResultList)
            {
                BGR_Control_Plan__c brRec = (BGR_Control_Plan__c)sRec;
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
                            BGR_Control_Plan__c brRec = (BGR_Control_Plan__c)sRec;
                            xmlW.writeStartElement(null,'CONTROL_PLAN_LINE',null); // CONTROL_PLAN_LINE start
                            
                            xmlW.writeStartElement(null,'TEST_OPERATION_NO',null); 
                            xmlW.writeCharacters(String.valueOf(brRec.Cus_Test_OPNO__c));
                            xmlW.writeEndElement();
                            
                            xmlW.writeStartElement(null,'TEST_OPERATION_DESC',null); 
                            xmlW.writeCharacters(String.valueOf(brRec.Test_Operation_Desc__c));
                            xmlW.writeEndElement();
                            
                            xmlW.writeStartElement(null,'NORM_TYPE',null); 
                            xmlW.writeCharacters(String.valueOf(brRec.Norm_Type__c));
                            xmlW.writeEndElement();
                            
                            xmlW.writeStartElement(null,'ROUTING_OPERATION_NO',null);
                            if(brRec.Cus_Operation_Number__c != null)
                            {
                                xmlW.writeCharacters(String.valueOf(brRec.Cus_Operation_Number__c));
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
                            OuterMinValue = String.valueOf(brRec.Outer_Min__c);
                            OuterMinValue = OuterMinValue.substringBetween('[',']');
                            if(string.isBlank(OuterMinValue))
                            {
                                if(brRec.Outer_Min__c != null)
                                {
                                    xmlW.writeCharacters(String.valueOf(brRec.Outer_Min__c));
                                }
                            }
                            else
                            {
                                if(brRec.Outer_Min__c != null)
                                {
                                    xmlW.writeCharacters(mapBGRAttr.get(OuterMinValue));
                                }
                            }
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
                                xmlW.writeCharacters(mapBGRAttr.get(InnerMinValue));
                            }          
                            xmlW.writeEndElement();
                            xmlW.writeStartElement(null,'NOMINAL_VALUE',null);
                            NominalValue = String.valueOf(brRec.Nominal_Value__c);
                            NominalValue = NominalValue.substringBetween('[',']');
                            if(string.isBlank(NominalValue))
                            {
                                if(brRec.Nominal_Value__c != null)
                                {
                                    xmlW.writeCharacters(String.valueOf(brRec.Nominal_Value__c));
                                }
                            }
                            else
                            {
                                if(brRec.Nominal_Value__c != null)
                                {
                                    xmlW.writeCharacters(mapBGRAttr.get(NominalValue));
                                }
                            }          
                            xmlW.writeEndElement();
                            
                            xmlW.writeStartElement(null,'PROCESS_CHARACTERISTICS',null);
                            if(brRec.Process_Characteristic__c != null)
                            {
                                xmlW.writeCharacters(brRec.Process_Characteristic__c);
                            }                   
                            xmlW.writeEndElement();
                            
                            xmlW.writeStartElement(null,'SPECIAL_CHAR_CLASS',null);
                            if(brRec.Special_Characteristic_Classification__c != null)
                            {                 
                                xmlW.writeCharacters(brRec.Special_Characteristic_Classification__c);
                            }                   
                            xmlW.writeEndElement();
                            
                            xmlW.writeStartElement(null,'OUTER_MAX',null);
                            OuterMaxValue = String.valueOf(brRec.Outer_Max__c);
                            OuterMaxValue = OuterMaxValue.substringBetween('[',']');
                            if(string.isBlank(OuterMaxValue))
                            {
                                if(brRec.Outer_Max__c != null)
                                {
                                    xmlW.writeCharacters(String.valueOf(brRec.Outer_Max__c));
                                }
                            }
                            else
                            {
                                if(brRec.Outer_Max__c != null && mapBGRAttr.get(OuterMaxValue) != null)
                                {
                                    xmlW.writeCharacters(mapBGRAttr.get(OuterMaxValue));
                                }
                            }                        
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
                                    xmlW.writeCharacters(mapBGRAttr.get(InnerMaxValue));
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
                            for(BGR_Control_Plan__c brRec : connectionList)
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
                        /*for(sObject sRec: BGRControlPlangResult.objResultList)
                        {
                            BGR_Control_Plan__c brRec = (BGR_Control_Plan__c)sRec;
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
    }
    return BGRControlPlangResult;
}
    
    /*
* Method to retrive Inventory Part details
*/
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
                // String InventoryPartTypeGCI='';
                // String InventoryPartTypeCDC = '';
                // String InventoryPartTypeGP = '';
                //if(  sobj.get('Site_10__c') == 4444)
                // if(bgrLead.Site_10__c == 4444)
                // {
                //     InventoryPartTypeCDC = 'Purchased';
                
                // } else {
                //     InventoryPartTypeCDC = 'Manufactured';
                // }
                // //if( sobj.get('Site_20__c') == 4444)
                // if(bgrLead.Site_20__c == 4444)
                // {
                //     InventoryPartTypeGCI = 'Purchased';
                
                // } else {
                //     InventoryPartTypeGCI = 'Manufactured';
                // }
                // //if( sobj.get('Site_30__c') == 4444)
                // if(bgrLead.Site_30__c == 4444)
                // {
                //     InventoryPartTypeGP = 'Purchased';
                
                // } else {
                //     InventoryPartTypeGP = 'Manufactured';
                // }
                // //if( sobj.get('Site_40__c') == 4444) 
                // if(bgrLead.Site_40__c == 4444)
                // {
                //     InventoryPartTypeGP = 'Purchased';
                
                // } else {
                //     InventoryPartTypeGP = 'Manufactured';
                // }
                //                 w.writeStartElement(null, 'INVENTORY_PART', null);
                //                 w.writeStartElement(null, 'CONTRACT', null);  
                //                 w.writeCharacters(bgrLead.InventorySite__c);
                //                 w.writeEndElement();
                //                 w.writeStartElement(null, 'PART_NO', null);  
                //                 w.writeCharacters(PARTNUMBER.toUpperCase());
                //                 w.writeEndElement();
                //                 w.writeStartElement(null, 'TEMPLATE_ID', null);  
                //                 w.writeCharacters(bgrLead.InventoryPartTemplate_ID__c);
                //                 w.writeEndElement();
                //                 /*w.writeStartElement(null, 'WORKING_DAYS', null);  
                // w.writeCharacters('CDC');
                // w.writeEndElement();*/
                //                 w.writeStartElement(null, 'PART_TYPE', null);  
                //                 w.writeCharacters(bgrLead.InventoryPartType__c);
                //                 w.writeEndElement();
                //                 w.writeStartElement(null, 'PLANNER', null);  
                //                 w.writeCharacters(PLANNER);
                //                 w.writeEndElement();
                //                 w.writeStartElement(null, 'CUSTOMS_STAT_NO', null);  
                //                 w.writeCharacters(CUSTOMS_STAT_NO);
                //                 w.writeEndElement();
                //                 w.writeStartElement(null, 'ENG_REVISION', null);  
                //                 //w.writeCharacters(' ');
                //                 w.writeEndElement();
                //                 w.writeEndElement();
                //                 w.writeStartElement(null, 'INVENTORY_PART', null);
                //                 w.writeStartElement(null, 'CONTRACT', null);  
                //                 w.writeCharacters(bgrLead.InventorySite__c);
                //                 w.writeEndElement();
                //                 w.writeStartElement(null, 'PART_NO', null);  
                //                 w.writeCharacters(PARTNUMBER.toUpperCase());
                //                 w.writeEndElement();
                //                 w.writeStartElement(null, 'TEMPLATE_ID', null);  
                //                 w.writeCharacters(bgrLead.InventoryPartTemplate_ID__c);
                //                 w.writeEndElement();
                //                 /*w.writeStartElement(null, 'WORKING_DAYS', null);  
                // w.writeCharacters('GCI');
                // w.writeEndElement();*/
                //                 w.writeStartElement(null, 'PART_TYPE', null);  
                //                 w.writeCharacters(bgrLead.InventoryPartType__c);
                //                 w.writeEndElement();
                //                 w.writeStartElement(null, 'PLANNER', null);  
                //                 w.writeCharacters(PLANNER);
                //                 w.writeEndElement();
                //                 w.writeStartElement(null, 'CUSTOMS_STAT_NO', null);  
                //                 w.writeCharacters(CUSTOMS_STAT_NO);
                //                 w.writeEndElement();
                //                 w.writeStartElement(null, 'ENG_REVISION', null);  
                //                 //w.writeCharacters(' ');
                //                 w.writeEndElement();
                //                 w.writeEndElement();
                //                 w.writeStartElement(null, 'INVENTORY_PART', null);
                //                 w.writeStartElement(null, 'CONTRACT', null);  
                //                 w.writeCharacters(bgrLead.InventorySite__c);
                //                 w.writeEndElement();
                //                 w.writeStartElement(null, 'PART_NO', null);  
                //                 w.writeCharacters(PARTNUMBER.toUpperCase());
                //                 w.writeEndElement();
                //                 w.writeStartElement(null, 'TEMPLATE_ID', null);  
                //                 w.writeCharacters(bgrLead.InventoryPartTemplate_ID__c);
                //                 w.writeEndElement();
                //                 /*w.writeStartElement(null, 'WORKING_DAYS', null);  
                // w.writeCharacters('GP');
                // w.writeEndElement();*/
                // w.writeStartElement(null, 'PART_TYPE', null);  
                //                 w.writeCharacters(bgrLead.InventoryPartType__c);
                //                 w.writeEndElement();
                //                 w.writeStartElement(null, 'PLANNER', null);  
                //                 w.writeCharacters(PLANNER);
                //                 w.writeEndElement();
                //                 w.writeStartElement(null, 'CUSTOMS_STAT_NO', null);  
                //                 w.writeCharacters(CUSTOMS_STAT_NO);
                //                 w.writeEndElement();
                //                 w.writeStartElement(null, 'ENG_REVISION', null);  
                //                 //w.writeCharacters(' ');
                //                 w.writeEndElement();
                //                 w.writeEndElement();
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
    
    public List<Global_Site_Part_Parameters_PPS__c> getGlobalSitePPS()
    {
        Boolean isFlag = false;
        list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = new list<Global_Site_Part_Parameters_ISPM__c>();
        String SOQL = 'Select InventorySite__c,InventoryPartType__c,InventoryPartTemplate_ID__c,SalesSite__c,Sourcing_Option__c,PurchaseSite__c,PurchasePartTemplate_ID__c,MfgSite__c';
        SOQL += ' From Global_Site_Part_Parameters_ISPM__c ';
        if(currentBGR.Lead_Time_Site_10__c != null)
        {
            isFlag = true;
            SOQL += ' where (SITE__c = \'10\' and LeadTimeLL__c <='+currentBGR.Lead_Time_Site_10__c+' and LeadTimeUL__c >='+currentBGR.Lead_Time_Site_10__c+' and SERIALTRACKCODE__c =\''+INV_SERIAL_TRACKING+'\')';
        }
        if(currentBGR.Lead_Time_Site_20__c != null)
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
            SOQL += ' (SITE__c = \'20\' and LeadTimeLL__c <='+currentBGR.Lead_Time_Site_20__c+' and LeadTimeUL__c >='+currentBGR.Lead_Time_Site_20__c+' and SERIALTRACKCODE__c =\''+INV_SERIAL_TRACKING+'\')';
        }
        if(currentBGR.Lead_Time_Site_30__c != null)
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
            SOQL += ' (SITE__c = \'30\' and LeadTimeLL__c <='+currentBGR.Lead_Time_Site_30__c+' and LeadTimeUL__c >='+currentBGR.Lead_Time_Site_30__c+' and SERIALTRACKCODE__c =\''+INV_SERIAL_TRACKING+'\')';
        }
        if(currentBGR.Lead_Time_Site_40__c != null)
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
            SOQL += ' (SITE__c = \'40\' and LeadTimeLL__c <='+currentBGR.Lead_Time_Site_40__c+' and LeadTimeUL__c >='+currentBGR.Lead_Time_Site_40__c+' and SERIALTRACKCODE__c =\''+INV_SERIAL_TRACKING+'\')';
        }
        system.debug('getGlobalSitePPS:'+SOQL);
        GlobalSiteParametersISPMList = database.query(SOQL);
        Set<String> purchasedInventorySites = new Set<String>();
        if(GlobalSiteParametersISPMList.size() > 0)
        {
            for(Global_Site_Part_Parameters_ISPM__c globalISPM : GlobalSiteParametersISPMList)
            {
                System.debug('***** inventory type = '+globalISPM.InventoryPartType__c);
                if(globalISPM.InventoryPartType__c == 'Purchased')
                {
                    purchasedInventorySites.add(globalISPM.InventorySite__c);
                }
            }
        }
        List<Global_Site_Part_Parameters_PPS__c> globalSitePPSList = new List<Global_Site_Part_Parameters_PPS__c>();
        if(purchasedInventorySites.size() > 0)
        {
            for(Global_Site_Part_Parameters_PPS__c ppsRecord: [SELECT Id,Name,Site__c,VendorSite__c,VendorLTLL__c,VendorLTUL__c,Primary_Vendor__c,PPS_VendoNo__c,PurchaseSite__c from Global_Site_Part_Parameters_PPS__c WHERE Site__c IN:purchasedInventorySites order by Site__c])
            {
                // 10 => 20 & 30
                if(ppsRecord.Site__c == '10') 
                {
                    if(ppsRecord.VendorSite__c == '20' && 
                       ppsRecord.VendorLTLL__c <= currentBGR.Lead_Time_Site_20__c && 
                       ppsRecord.VendorLTUL__c > currentBGR.Lead_Time_Site_20__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '30' && 
                            ppsRecord.VendorLTLL__c <= currentBGR.Lead_Time_Site_30__c && 
                            ppsRecord.VendorLTUL__c > currentBGR.Lead_Time_Site_30__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }       
                }
                // 20 => 10 & 30
                if(ppsRecord.Site__c == '20')
                {
                    if(ppsRecord.VendorSite__c == '10' && 
                       ppsRecord.VendorLTLL__c <= currentBGR.Lead_Time_Site_10__c && 
                       ppsRecord.VendorLTUL__c > currentBGR.Lead_Time_Site_10__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '30' && 
                            ppsRecord.VendorLTLL__c <= currentBGR.Lead_Time_Site_30__c && 
                            ppsRecord.VendorLTUL__c > currentBGR.Lead_Time_Site_30__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }       
                }
                // 30 => 10 & 20
                if(ppsRecord.Site__c == '30')
                {
                    if(ppsRecord.VendorSite__c == '10' && 
                       ppsRecord.VendorLTLL__c <= currentBGR.Lead_Time_Site_10__c && 
                       ppsRecord.VendorLTUL__c > currentBGR.Lead_Time_Site_10__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '20' && 
                            ppsRecord.VendorLTLL__c <= currentBGR.Lead_Time_Site_20__c && 
                            ppsRecord.VendorLTUL__c > currentBGR.Lead_Time_Site_20__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }       
                }
                
                // 40 => 10, 20 & 30
                if(ppsRecord.Site__c == '40')
                {
                    if(ppsRecord.VendorSite__c == '10' && 
                       ppsRecord.VendorLTLL__c <= currentBGR.Lead_Time_Site_10__c && 
                       ppsRecord.VendorLTUL__c > currentBGR.Lead_Time_Site_10__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '20' && 
                            ppsRecord.VendorLTLL__c <= currentBGR.Lead_Time_Site_20__c && 
                            ppsRecord.VendorLTUL__c > currentBGR.Lead_Time_Site_20__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }  
                    else if(ppsRecord.VendorSite__c == '30' && 
                            ppsRecord.VendorLTLL__c <= currentBGR.Lead_Time_Site_30__c && 
                            ppsRecord.VendorLTUL__c > currentBGR.Lead_Time_Site_30__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }  
                }
            }
        }
        System.debug('***** globalSitePPSList = '+globalSitePPSList);
        return globalSitePPSList;
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
                        w.writeCharacters((STRING) sobj.get('Component_part__c'));
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
                w.writeCharacters((STRING) sobj.get('Component_part__c'));
                w.writeEndElement();
                w.writeStartElement(null, 'DESCRIPTION', null);
                //w.writeCharacters((STRING) sobj.get('Component_part__c'));
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
    
    public Result getProdDoc( )
    {
        result BGRDocResult=new result();
        result DocResult=getProDoc();
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
                    //w.writeCharacters((STRING) sobj.get('Document__c'));
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
                    //w.writeCharacters((STRING) sobj.get('Document_ID__c'));
                    w.writeEndElement();
                    w.writeStartElement(null, 'FILE_DATA', null);  
                    //w.writeCharacters(' ');
                    w.writeEndElement();
                    w.writeStartElement(null, 'DOC_RESP_SIGN', null);  
                    //w.writeCharacters(' ');
                    w.writeEndElement();
                    /*w.writeStartElement(null, 'DOCUMENT_ID', null);  
                    w.writeCharacters(DocumentID);
                    w.writeEndElement();*/ 
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
        IFS_character_codes__c[] IFS_Attr=[select Element__c,Attribute_Code__c from IFS_character_codes__c where Interface_to_IFS_Attributes__c=true and Product__c='BGR' order by Attribute_Code__c];
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartElement(null, 'ENG_PART_CHAR_LIST', null);
        for(IFS_character_codes__c ifsAtt:IFS_Attr) {
            String strInfo=' ';
            String strVal=' ';
            String strCode;
            if (mapBGRAttr.containsKey(ifsAtt.Attribute_Code__c)) 
            {
                if (ifsAtt.Element__c=='Info')
                {
                    strInfo=mapBGRAttr.get(ifsAtt.Attribute_Code__c);
                }
                else
                {
                    strVal=mapBGRAttr.get(ifsAtt.Attribute_Code__c);
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
                /*if((string.isBlank(strVal) || strVal.length() > 20) && (string.isNotBlank(strInfo)))
                {
                    w.writeStartElement(null, 'VALUE', null);
                    w.writeCharacters('See Info');
                    w.writeEndElement();
                }
                else if(strVal.length() < 20)
                {
                    w.writeStartElement(null, 'VALUE', null);
                    w.writeCharacters(strVal);
                    w.writeEndElement();
                }*/
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
}