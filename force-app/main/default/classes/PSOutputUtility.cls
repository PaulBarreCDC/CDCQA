/************************************************************************
* Class Name: PSOutputUtility
* This class handles Part selector Output
* This class provide details on Part selector routing/Lead Time/Engg Part Details/
* Pricing details/Inventory Part Details/Sales Part Details etc.
************************************************************************/

public class PSOutputUtility {
    
   public Part_Selector__c currentPS  {get; set;} 
   public Map<string,string> mapPS_Attribute {get;set;}
    //public Map<string,string> mapPsAttr{get;set;}
   
    /* Constructor which will take BGR ID as the Parameter and fetch all the fields which are used for OUTPUTS*/
    public PSOutputUtility (Id recordID) 
    {
       	currentPS= (Part_Selector__c) wizardBaseDataProcessor.getObjectDataById(recordID).objResultList[0]; 
        if(currentPS != null && currentPS.Is_managed_in_Salesforce__c == true)
        {
            IFSManaged = 'N';
        }
        else
        {
            IFSManaged = 'Y';
        }
        if(currentPS.Quote_Description_Engineer_Override__c == true)
        {
            PARTNUMBER = currentPS.Part_Number__c;
        }
        else
        {
            //PARTNUMBER = currentPS.Part_Number__c;
            PARTNUMBER = currentPS.Part_Number_Backup__c;
            //PARTNUMBER = currentPS.Existing_partnumber__c;//added by Ashim
        }
        system.debug('## Printing current PS' +currentPS);
        system.debug('## Printing PartNumber' +PARTNUMBER);
        List<PS_Output__c> psOutputList = new List<PS_Output__c>();
        String fieldsAPIname = FLMutility.getObjectFields('PS_Output__c');    
        String soql = 'SELECT ' + fieldsAPIname +' FROM PS_Output__c ';
        soql += ' WHERE Part_Selector__c =\''+String.escapeSingleQuotes(currentPS.Id)+'\' ';    
        System.debug('@Developer --> soql :' + soql);    
        psOutputList = Database.query(soql);
        if(psOutputList.size() > 0)
        {
           if(string.isNotBlank(psOutputList[0].OA_Override__c))
            {
                OA = psOutputList[0].OA_Override__c;
            }
            else
            {
                OA = currentPS.OA__c;
            }
            if(string.isNotBlank(psOutputList[0].OB_Override__c))
            {
                OB = psOutputList[0].OB_Override__c;
            }
            else
            {
                OB = currentPS.OB__c;                
            }
            
            if(string.isNotBlank(psOutputList[0].ORP_Override__c))
            {
                ORP = psOutputList[0].ORP_Override__c;
            }
            else
            {
                ORP = currentPS.ORP__c;
            }
            
            if(string.isNotBlank(psOutputList[0].ORV_Override__c))
            {
                ORV = psOutputList[0].ORV_Override__c;
            }
            else
            {
                ORV = currentPS.ORV__c;
            }
            if(string.isNotBlank(psOutputList[0].OW_Override__c))
            {
                OW = psOutputList[0].OW_Override__c;
            }
            else
            {
                OW = currentPS.OW__c;
            }
            if(string.isNotBlank(psOutputList[0].PC_Override__c))
            {
                PC = psOutputList[0].PC_Override__c;
            }
            else
            {
                PC = currentPS.PC__c;
            }
                       
        }
        else
        {
            OA = currentPS.OA__c;
            OB = currentPS.OB__c;
            OW = currentPS.OW__c;
            PC = currentPS.PC__c;
            ORV = currentPS.ORV__c;
            ORP = currentPS.ORP__c;
        }

	    mapPSAttr=new Map<String, string>(); 
        mapPS_Attribute = new Map<String, String>();
        mapPS_Attribute = getMapAttribute();
        getmapPSInterfaceAttr();
        mapPSAttr.put('SERIALTRACKCODE', mapPS_Attribute.get('SERIALTRACKCODE'));
        system.debug('Const OA ' + OA+ ' OB ' + OB + ' OW '+OW);
    }   
        
        public Map<string,string> mapPSAttr {
        get{
            Map<String, string> myMap1 = new Map<String, string>(); 
            myMap1.put('BRAND',BRAND);
			myMap1.put('ASSEMBLYWT',ASSEMBLYWT);
			myMap1.put('ASYTYP',ASYTYP);
            myMap1.put('ASSEMBLYWTUOM',ASSEMBLYWTUOM);
            //myMap1.put('ATMPRESPSIA',ATMPRESPSIA);
            myMap1.put('ATTRTEMPLATE',ATTRTEMPLATE);
			myMap1.put('ATEX',ATEX);
			myMap1.put('Brand',Brand);
            myMap1.put('COMPDESCRIPTION',COMPDESCRIPTION);
            myMap1.put('COMPINVSERTRK',COMPINVSERTRK);
			myMap1.put('COMPLOTTRACK',COMPLOTTRACK);
			myMap1.put('COMPPROVIDE',COMPPROVIDE);
			myMap1.put('COMPRESPONID',COMPRESPONID);
			myMap1.put('CUSTOMSTATNO',CUSTOMSTATNO);
			myMap1.put('CUTR',CUTR);
			myMap1.put('ESZC',ESZC);
			myMap1.put('GMODEL',GMODEL);
			myMap1.put('GMODEL1',GMODEL1);
			myMap1.put('GMODEL2',GMODEL2);
			myMap1.put('GMODEL3',GMODEL3);
			myMap1.put('GMODEL4',GMODEL4);
			myMap1.put('GMODEL5',GMODEL5);
			myMap1.put('GMODEL6',GMODEL6);
			myMap1.put('GMODEL7',GMODEL7);
			myMap1.put('GPFACE',GPFACE);
			myMap1.put('GTAG01',GTAG01);
            myMap1.put('GTAG02',GTAG02);
			myMap1.put('GTAG04',GTAG04);
			myMap1.put('GTAG05',GTAG05);
			myMap1.put('GTAG06',GTAG06);
            myMap1.put('GTAG07',GTAG07);
            myMap1.put('GTAG08',GTAG08);
            myMap1.put('GTAG09',GTAG09);
            myMap1.put('GTAG10',GTAG10);
            myMap1.put('GTAG14',GTAG14);
			myMap1.put('GTAG15',GTAG15);
			myMap1.put('GTAG16',GTAG16);
			myMap1.put('GTAG17',GTAG17);
            myMap1.put('GTAG18',GTAG18);
            myMap1.put('GTAG19',GTAG19);
            myMap1.put('GTAG20',GTAG20);
            myMap1.put('GTAG21',GTAG21);
            myMap1.put('GTAG22',GTAG22);
            myMap1.put('GTAG23',GTAG23);
            myMap1.put('Gprsc1',Gprsc1);
			myMap1.put('GTAGPN',GTAGPN);
           	myMap1.put('GPRSC1',GPRSC1);
          	myMap1.put('GVRSC1',GVRSC1);
			myMap1.put('HCLASS',HCLASS);
			myMap1.put('HSNSACCODE',HSNSACCODE);
			myMap1.put('IINO',IINO);
			myMap1.put('INHOUSEPAINT',INHOUSEPAINT);
			myMap1.put('LOTTRACKCODE',LOTTRACKCODE);
			myMap1.put('MCBODY',MCBODY);
			myMap1.put('MCDPHM',MCDPHM);
			myMap1.put('MCELMT',MCELMT);
			myMap1.put('MCHOUS',MCHOUS);
			myMap1.put('MCPALL',MCPALL);
			myMap1.put('NACE',NACE);
			myMap1.put('OA',OA);
			myMap1.put('OA01',OA01);
			myMap1.put('OA02',OA02);
			myMap1.put('OA04',OA04);
			myMap1.put('OA05',OA05);
			myMap1.put('OA06',OA06);
			myMap1.put('OB',OB);
			myMap1.put('OB010',OB010);
			myMap1.put('OB020',OB020);
			myMap1.put('OB030',OB030);
			myMap1.put('OB040',OB040);
			myMap1.put('OB050',OB050);
            myMap1.put('OB060',OB060);
			myMap1.put('OB110',OB110);
			myMap1.put('OB120',OB120);
			myMap1.put('OB210',OB210);
			myMap1.put('OB220',OB220);
			myMap1.put('OB230',OB230);
			myMap1.put('OB240',OB240);
			myMap1.put('OB250',OB250);
			myMap1.put('OB260',OB260);
			myMap1.put('OB310',OB310);
			myMap1.put('OB311',OB311);
			myMap1.put('OB312',OB312);
            myMap1.put('OB370',OB370);
			myMap1.put('OB410',OB410);
			myMap1.put('OB411',OB411);
			myMap1.put('OB420',OB420);
			myMap1.put('OB421',OB421);
			myMap1.put('OB430',OB430);
			myMap1.put('OB431',OB431);
			myMap1.put('OB440',OB440);
			myMap1.put('OB441',OB441);
			myMap1.put('OB510',OB510);
			myMap1.put('OB530',OB530);
			myMap1.put('OB540',OB540);
			myMap1.put('OB550',OB550);
			//myMap1.put('OnEngrHoldFlag',OnEngrHoldFlag);
			myMap1.put('OW',OW);
			myMap1.put('OW110',OW110);
			myMap1.put('OW120',OW120);
			myMap1.put('OW130',OW130);
			myMap1.put('OW140',OW140);
			myMap1.put('OW150',OW150);
			myMap1.put('OW160',OW160);
			myMap1.put('OW170',OW170);
			myMap1.put('OW180',OW180);
			myMap1.put('OW190',OW190);
			myMap1.put('OW200',OW200);
			myMap1.put('OW210',OW210);
			myMap1.put('OW220',OW220);
			myMap1.put('OW230',OW230);
			myMap1.put('OW240',OW240);
			myMap1.put('OW250',OW250);
			myMap1.put('OW260',OW260);
			myMap1.put('OW270',OW270);
			myMap1.put('OW280',OW280);
			myMap1.put('OW290',OW290);
			myMap1.put('OW300',OW300);
			myMap1.put('OW310',OW310);
			myMap1.put('OW320',OW320);
			myMap1.put('OW330',OW330);
			myMap1.put('OW340',OW340);
			myMap1.put('OW910',OW910);
			myMap1.put('OW920',OW920);
			myMap1.put('PARTCLASS',PARTCLASS);
			myMap1.put('PartNum',PartNum);
			myMap1.put('PARTUOM',PARTUOM);
			myMap1.put('PC',PC);
			myMap1.put('PC410',PC410);
			myMap1.put('PC411',PC411);
			myMap1.put('PC420',PC420);
			myMap1.put('PC421',PC421);
			myMap1.put('PC430',PC430);
			myMap1.put('PC431',PC431);
			myMap1.put('PC440',PC440);
			myMap1.put('PC441',PC441);
			myMap1.put('PLANNER',PLANNER);
			myMap1.put('ProdGroup',ProdGroup);
			myMap1.put('PROVIDE',PROVIDE);
			myMap1.put('PTC',PTC);
			myMap1.put('RESPONSIBLE_ID',RESPONSIBLE_ID);
			myMap1.put('SALESGROUP',SALESGROUP);
			myMap1.put('SALESPRICEGROUP',SALESPRICEGROUP);
			myMap1.put('SERIALTRACKCODE',SERIALTRACKCODE);
			myMap1.put('SETTING',SETTING);
			myMap1.put('SHLTSTBDYPSIG',SHLTSTBDYPSIG);			
			myMap1.put('SOURCINGOPT',SOURCINGOPT);			
			myMap1.put('SPRING',SPRING);
			myMap1.put('GPDS01',GPDS01);
            myMap1.put('GPDS03',GPDS03);
            myMap1.put('GPDS05',GPDS05);
            myMap1.put('GPDS06',GPDS06);
            myMap1.put('GPDS07',GPDS07);
            myMap1.put('GPDS09',GPDS09);
            myMap1.put('GPDS17',GPDS17);
            myMap1.put('GPDS18',GPDS18);
            myMap1.put('GPDS19',GPDS19);
            myMap1.put('GPDS20',GPDS20);
            myMap1.put('GPDS21',GPDS21);
            myMap1.put('GPDS22',GPDS22);
            myMap1.put('GPDS23',GPDS23);
            myMap1.put('GPDS24',GPDS24);
            myMap1.put('GPDS25',GPDS25);
            myMap1.put('GPDS26',GPDS26);
            myMap1.put('GPDS27',GPDS27);
            myMap1.put('GPDS28',GPDS28);
            myMap1.put('PRDLIN',PRDLIN);
            myMap1.put('RGEUNT',RGEUNT);
            myMap1.put('RTPRS1',RTPRS1);
            myMap1.put('RTPRSU',RTPRSU);
            myMap1.put('VGEUNT',VGEUNT);
            myMap1.put('VTPRS1',VTPRS1);
            myMap1.put('VTPRSU',VTPRSU);
            myMap1.put('GPAINT',GPAINT);
            myMap1.put('MCSEAT',MCSEAT);
            myMap1.put('MCWGHT',MCWGHT);   
            myMap1.put('SZC',SZC);
            myMap1.put('GENOPT',GENOPT);
            myMap1.put('MCENVG',MCENVG);
            myMap1.put('MCSPRG',MCSPRG);
            myMap1.put('PosSetCode',PosSetCode);
            myMap1.put('VacSetCode',VacSetCode);          
			myMap1.put('VENDORPAINT',VENDORPAINT);		           
           	myMap1.put('PARTNUMBER',PARTNUMBER);
            myMap1.put('PARTREV',PARTREV);
            myMap1.put('PSAssyPartNumberLookup',PSAssyPartNumberLookup);
            myMap1.put('IFSManaged',IFSManaged);
            return myMap1;
        }
        set{
            this.mapPSAttr=value;
        }
          
  }
    
    
    public map<string,string> getMapAttribute() 
    {
        Map<String, string> mapPS_Attribute = new Map<String, string>(); 
        result PSAttributes = new Result();
        List<String> selectCols = new List<String> {'Text__c','Value__c','Attribute__c'};
        PSAttributes=wizardBaseDataProcessor.getSortedDataFromTranslationObj1('Attribute__c','PS_Attributes_Translation__c','PS_Attributes_Details__c',mapPSAttr,selectCols,'Attribute__c',ProdGroup,SubGroup);
        system.debug('Check if entering'+PSAttributes.bResult);
        if(PSAttributes.bResult)
        { 
            for(sObject objD : PSAttributes.objResultList)
            {
				
                PS_Attributes_Details__c PSLookupData = (PS_Attributes_Details__c)objD;
				system.debug(PSLookupData.Attribute__c+'====>'+ PSLookupData.Text__c);
                system.debug('Attribute: '+PSLookupData.Attribute__c +',Text: ' +PSLookupData.Text__c +',Value: ' +PSLookupData.Value__c);
                if(PSLookupData.Text__c != null && PSLookupData.Value__c == null)
                {
                    mapPS_Attribute.put(PSLookupData.Attribute__c, PSLookupData.Text__c);
                }
                if(PSLookupData.Text__c == null && PSLookupData.Value__c != null)
                {
                    mapPS_Attribute.put(PSLookupData.Attribute__c, PSLookupData.Value__c);
                }
                if(PSLookupData.Text__c != null && PSLookupData.Value__c != null)
                {
                    mapPS_Attribute.put(PSLookupData.Attribute__c, PSLookupData.Text__c+' '+PSLookupData.Value__c);
                }
                if(PSLookupData.Text__c == null && PSLookupData.Value__c == null)
                {
                    mapPS_Attribute.put(PSLookupData.Attribute__c, '');
                }
                mapPSAttr.put(PSLookupData.Attribute__c,mapPS_Attribute.get(PSLookupData.Attribute__c));
                //System.debug('***** Adding into map as key = '+PSLookupData.Attribute__c+' and value = '+(PSLookupData.Text__c+' '+PSLookupData.Value__c));
				system.debug(PSLookupData.Attribute__c+'***'+mapPS_Attribute.get(PSLookupData.Attribute__c));
            }
        }
        system.debug(mapPS_Attribute);
        return mapPS_Attribute;
    }
    
     public String ASSEMBLYWT {
        get {
            return mapPS_Attribute.get('ASSEMBLYWT')==null?'': mapPS_Attribute.get('ASSEMBLYWT');
        }
        set {
            this.ASSEMBLYWT = value;
        }
    }
    
     public String ASSEMBLYWTUOM {
        get {
            return mapPS_Attribute.get('ASSEMBLYWTUOM')==null?'': mapPS_Attribute.get('ASSEMBLYWTUOM');
        }
        set {
            this.ASSEMBLYWTUOM = value;
        }         
    }
    
    public string ASYTYP {
        get {
            return mapPS_Attribute.get('ASYTYP')==null?'': mapPS_Attribute.get('ASYTYP');
        }
        set {
            //currentPS.Ratio_of_Specific_Heats__c = value;
            this.ASYTYP = value;
            
        }
    }
	
    public string GPRSC1 {
        get {
            return mapPS_Attribute.get('GPRSC1')==null?'': mapPS_Attribute.get('GPRSC1');
        }
        set {
            //currentPS.Ratio_of_Specific_Heats__c = value;
            this.GPRSC1 = value;
            
        }
    }
    
    /*public string SPRING {
        get {
            return mapPS_Attribute.get('SPRING')==null?'': mapPS_Attribute.get('SPRING');
        }
        set {
            //currentPS.Ratio_of_Specific_Heats__c = value;
            this.SPRING = value;
            
        }
    }*/
    
    Public String PARTNUMBER{
        get{
            if(currentPS.Quote_Description_Engineer_Override__c == true)
            {
                return currentPS.Part_Number__c;
            }
            else
            {
                return currentPS.Part_Number_Backup__c;
                //return currentPS.Existing_partnumber__c;//added by Ashim
                //return currentPS.Part_Number__c;
            }
        }
        set{
            this.PARTNUMBER = value;
            System.debug('@@@@@@PARTNUMBER' + PARTNUMBER);
        }
    }
    
        public string GVRSC1 {
        get {
            return mapPS_Attribute.get('GVRSC1')==null?'': mapPS_Attribute.get('GVRSC1');
        }
        set {
            //currentPS.Ratio_of_Specific_Heats__c = value;
            this.GVRSC1 = value;
            
        }
    }
    
    public string GPDS01 {
        get {
            return mapPS_Attribute.get('GPDS01')==null?'': mapPS_Attribute.get('GPDS01');
        }
        set {
            this.GPDS01 = value;
            
        }
    }
    
    public string GPDS03 {
        get {
            return mapPS_Attribute.get('GPDS03')==null?'': mapPS_Attribute.get('GPDS03');
        }
        set {
            this.GPDS03 = value;
            
        }
    }
    
    public string GPDS05 {
        get {
            return mapPS_Attribute.get('GPDS05')==null?'': mapPS_Attribute.get('GPDS05');
        }
        set {
            this.GPDS05 = value;
            
        }
    }
    
    public string GPDS06 {
        get {
            return mapPS_Attribute.get('GPDS06')==null?'': mapPS_Attribute.get('GPDS06');
        }
        set {
            this.GPDS06 = value;
            
        }
    }
    
    public string GPDS07 {
        get {
            return mapPS_Attribute.get('GPDS07')==null?'': mapPS_Attribute.get('GPDS07');
        }
        set {
            this.GPDS07 = value;
            
        }
    }
    
    
    public string GPDS09 {
        get {
            return mapPS_Attribute.get('GPDS09')==null?'': mapPS_Attribute.get('GPDS09');
        }
        set {
            this.GPDS09 = value;
            
        }
    }    
    
    public string GPDS17 {
        get {
            return mapPS_Attribute.get('GPDS17')==null?'': mapPS_Attribute.get('GPDS17');
        }
        set {
            this.GPDS17 = value;
            
        }
    }
    
    public string GPDS18 {
        get {
            return mapPS_Attribute.get('GPDS18')==null?'': mapPS_Attribute.get('GPDS18');
        }
        set {
            this.GPDS18 = value;
            
        }
    }
    
    public string GPDS19 {
        get {
            return mapPS_Attribute.get('GPDS19')==null?'': mapPS_Attribute.get('GPDS19');
        }
        set {
            this.GPDS19 = value;
            
        }
    }
    
    public string GPDS20 {
        get {
            return mapPS_Attribute.get('GPDS20')==null?'': mapPS_Attribute.get('GPDS20');
        }
        set {
            this.GPDS20 = value;
            
        }
    }
    
    public string GPDS21 {
        get {
            return mapPS_Attribute.get('GPDS21')==null?'': mapPS_Attribute.get('GPDS21');
        }
        set {
            this.GPDS21 = value;
            
        }
    }
    
    public string GPDS22 {
        get {
            return mapPS_Attribute.get('GPDS22')==null?'': mapPS_Attribute.get('GPDS22');
        }
        set {
            this.GPDS22 = value;
            
        }
    }
    
    public string GPDS23 {
        get {
            return mapPS_Attribute.get('GPDS23')==null?'': mapPS_Attribute.get('GPDS23');
        }
        set {
            this.GPDS23 = value;
            
        }
    }
    
    public string GPDS24 {
        get {
            return mapPS_Attribute.get('GPDS24')==null?'': mapPS_Attribute.get('GPDS24');
        }
        set {
            this.GPDS24 = value;
            
        }
    }
    
    public string GPDS25 {
        get {
            return mapPS_Attribute.get('GPDS25')==null?'': mapPS_Attribute.get('GPDS25');
        }
        set {
            this.GPDS25 = value;
            
        }
    }
    
    public string GPDS26 {
        get {
            return mapPS_Attribute.get('GPDS26')==null?'': mapPS_Attribute.get('GPDS26');
        }
        set {
            this.GPDS26 = value;
            
        }
    }
    
        public string GPDS27 {
        get {
            return mapPS_Attribute.get('GPDS27')==null?'': mapPS_Attribute.get('GPDS27');
        }
        set {
            this.GPDS27 = value;
            
        }
    }
    
        public string GPDS28 {
        get {
            return mapPS_Attribute.get('GPDS28')==null?'': mapPS_Attribute.get('GPDS28');
        }
        set {
            this.GPDS28 = value;
            
        }
    }
    
    public string PRDLIN {
        get {
            return mapPS_Attribute.get('PRDLIN')==null?'': mapPS_Attribute.get('PRDLIN');
        }
        set {
            //currentPS.Ratio_of_Specific_Heats__c = value;
            this.PRDLIN = value;
            
        }
    }
    
    public string RGEUNT {
        get {
            return mapPS_Attribute.get('RGEUNT')==null?'': mapPS_Attribute.get('RGEUNT');
        }
        set {
            //currentPS.Ratio_of_Specific_Heats__c = value;
            this.RGEUNT = value;
            
        }
    }
    
    public string RTPRS1 {
        get {
            return mapPS_Attribute.get('RTPRS1')==null?'': mapPS_Attribute.get('RTPRS1');
        }
        set {
            //currentPS.Ratio_of_Specific_Heats__c = value;
            this.RTPRS1 = value;
            
        }
    }
    
    public string RTPRSU {
        get {
            return mapPS_Attribute.get('RTPRSU')==null?'': mapPS_Attribute.get('RTPRSU');
        }
        set {
            //currentPS.Ratio_of_Specific_Heats__c = value;
            this.RTPRSU = value;
            
        }
    }
    
    public string VGEUNT {
        get {
            return mapPS_Attribute.get('VGEUNT')==null?'': mapPS_Attribute.get('VGEUNT');
        }
        set {
            //currentPS.Ratio_of_Specific_Heats__c = value;
            this.VGEUNT = value;
            
        }
    }
    
    public string VTPRS1 {
        get {
            return mapPS_Attribute.get('VTPRS1')==null?'': mapPS_Attribute.get('VTPRS1');
        }
        set {
            //currentPS.Ratio_of_Specific_Heats__c = value;
            this.VTPRS1 = value;
            
        }
    } 
    
    public string VTPRSU {
        get {
            return mapPS_Attribute.get('VTPRSU')==null?'': mapPS_Attribute.get('VTPRSU');
        }
        set {
            //currentPS.Ratio_of_Specific_Heats__c = value;
            this.VTPRSU = value;
            
        }
    } 
    
    
	public string ATEX {
        get {
            if(currentPS.Atex__c != null)
            {
                return currentPS.Atex__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentPS.Atex__c = value;
            this.ATEX = value;
        }
    }
    
    public string spring {
        get {
            if(currentPS.spring__c != null)
            {
                return currentPS.spring__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentPS.spring__c = value;
            this.spring = value;
        }
    }
    
     public string GPAINT {
        get {
            if(currentPS.GPAINT__c != null)
            {
                return currentPS.GPAINT__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentPS.GPAINT__c = value;
            this.GPAINT = value;
        }
    }
    
    public string MCSEAT {
        get {
            if(currentPS.MCSEAT__c != null)
            {
                return currentPS.MCSEAT__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentPS.MCSEAT__c = value;
            this.MCSEAT = value;
        }
    }
    
    public string MCWGHT {
        get {
            if(currentPS.MCWGHT__c != null)
            {
                return currentPS.MCWGHT__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentPS.MCWGHT__c = value;
            this.MCWGHT = value;
        }
    }
    
    public String ATTRTEMPLATE{
        get {
            //System.debug('kjvfgf'+mapPS_Attribute);
            return mapPS_Attribute.get('ATTRTEMPLATE')==null?'': mapPS_Attribute.get('ATTRTEMPLATE');  
            
        }
        set {
            this.ATTRTEMPLATE= value;
        }
    }
	
	  public String Brand {
        get {
            return currentPS.Brand__c;
        }
        set {
            this.Brand = value;
        }
    } 
    
    Public string IFSManaged
    {
        get
        {
            if(currentPS.Is_managed_in_Salesforce__c == true)
            {
                return 'N';
            }
            else
            {
                return 'Y';
            }
        }
        set 
        {
            this.IFSManaged = value;
        }
    }
    
   
    public String COMPDESCRIPTION{
        get {
            //System.debug('kjvfgf'+mapPS_Attribute);
            return mapPS_Attribute.get('COMPDESCRIPTION')==null?'': mapPS_Attribute.get('COMPDESCRIPTION');  
            
        }
        set {
            this.COMPDESCRIPTION= value;
        }
    }
	
	public String COMPINVSERTRK{
        get {
            //System.debug('kjvfgf'+mapPS_Attribute);
            return mapPS_Attribute.get('COMPINVSERTRK')==null?'': mapPS_Attribute.get('COMPINVSERTRK');  
            
        }
        set {
            this.COMPINVSERTRK= value;
        }
    }
	
	 public string COMPLOTTRACK {
        get {
             return mapPS_Attribute.get('COMPLOTTRACK')==null?'': mapPS_Attribute.get('COMPLOTTRACK');
        }
        set {
            this.COMPLOTTRACK = value;
        }
    }
    
    public string COMPPROVIDE {
        get {
             return mapPS_Attribute.get('COMPPROVIDE')==null?'': mapPS_Attribute.get('COMPPROVIDE');
        }
        set {
            this.COMPPROVIDE = value;
        }
    }
    
    Public string GENOPT {
        get{
            return currentPS.GENOPT__c;
        }
        set{
            this.GENOPT = value;
        }
    }
	
    Public string MCENVG {
        get{
            return currentPS.MCENVG__c;
        }
        set{
            this.MCENVG = value;
        }
    }
    
    Public string MCSPRG {
        get{
            return currentPS.MCSPRG__c;
        }
        set{
            this.MCSPRG = value;
        }
    }
    
    Public string PosSetCode {
        get{
            return currentPS.PosSetCode__c;
        }
        set{
            this.PosSetCode = value;
        }
    }
    
    
    Public string VacSetCode {
        get{
            return currentPS.VacSetCode__c;
        }
        set{
            this.VacSetCode = value;
        }
    }
    

        
	 public string COMPRESPONID {
        get {
             return mapPS_Attribute.get('COMPRESPONID')==null?'': mapPS_Attribute.get('COMPRESPONID');
        }
        set {
            this.COMPRESPONID = value;
        }
    }
    
    public string CUSTOMSTATNO {
        get {
             return mapPS_Attribute.get('CUSTOMSTATNO')==null?'': mapPS_Attribute.get('CUSTOMSTATNO');
        }
        set {
            this.CUSTOMSTATNO = value;
        }
    }
	
	public string CUTR {
        get {
            if(currentPS.CUTR__c!= null)
            {
                return currentPS.CUTR__c;
            }
            else{
                return '';
                
                
            } 
        }
        set {
            currentPS.CUTR__c = value;
            this.CUTR = value;
        }
    }
    
    public String ESZC {
        get {
            return currentPS.ESZC__c;
        }
        set {
            this.ESZC = value;
        }
    }
    
    /*public String PARTREV {
        get 
        {
            if(currentPS.PARTREV__c != null)
                return currentPS.PARTREV__c;
            else
                return '1';
        }
        set 
        {
            this.PARTREV = value;
        }
    }*/ 
    
    
    public string GMODEL1 {
        get {
             return mapPS_Attribute.get('GMODEL-1')==null?'': mapPS_Attribute.get('GMODEL-1');
        }
        set {
            this.GMODEL1 = value;
        }
    }  
        public string GMODEL2 {
        get {
             return mapPS_Attribute.get('GMODEL-2')==null?'': mapPS_Attribute.get('GMODEL-2');
        }
        set {
            this.GMODEL2 = value;
        }
    }
    
    public string GMODEL3 {
        get {
             return mapPS_Attribute.get('GMODEL-3')==null?'': mapPS_Attribute.get('GMODEL-3');
        }
        set {
            this.GMODEL3 = value;
        }
    }
      
    public string GMODEL4 {
        get {
             return mapPS_Attribute.get('GMODEL-4')==null?'': mapPS_Attribute.get('GMODEL-4');
        }
        set {
            this.GMODEL4 = value;
        }
    }
      
     public string GMODEL5 {
        get {
             return mapPS_Attribute.get('GMODEL-5')==null?'': mapPS_Attribute.get('GMODEL-5');
        }
        set {
            this.GMODEL5 = value;
        }
    }
    
     public string GMODEL6 {
        get {
             return mapPS_Attribute.get('GMODEL-6')==null?'': mapPS_Attribute.get('GMODEL-6');
        }
        set {
            this.GMODEL6 = value;
        }
     }   
         
        public string GMODEL7 {
        get {
             return mapPS_Attribute.get('GMODEL-7')==null?'': mapPS_Attribute.get('GMODEL-7');
        }
        set {
            this.GMODEL7 = value;
        } 
    }
    
     public string GPFACE {
        get {
             return mapPS_Attribute.get('GPFACE')==null?'': mapPS_Attribute.get('GPFACE');
        }
        set {
            this.GPFACE = value;
        } 
    }
    
    public string GTAG01 {
        get {
             return mapPS_Attribute.get('GTAG01')==null?'': mapPS_Attribute.get('GTAG01');
        }
        set {
            this.GTAG01 = value;
        } 
    }
    
     public string GTAG02 {
        get {
             return mapPS_Attribute.get('GTAG02')==null?'': mapPS_Attribute.get('GTAG02');
        }
        set {
            this.GTAG02 = value;
        } 
    }
    
	public string GTAG04 {
        get {
             return mapPS_Attribute.get('GTAG04')==null?'': mapPS_Attribute.get('GTAG04');
        }
        set {
            this.GTAG04 = value;
        } 
    }
    
    public string GTAG05 {
        get {
             return mapPS_Attribute.get('GTAG05')==null?'': mapPS_Attribute.get('GTAG05');
        }
        set {
            this.GTAG05 = value;
        } 
    }
    
    public string GTAG06 {
        get {
             return mapPS_Attribute.get('GTAG06')==null?'': mapPS_Attribute.get('GTAG06');
        }
        set {
            this.GTAG06 = value;
        } 
    }
    
    public string GTAG07 {
        get {
            return mapPS_Attribute.get('GTAG07')==null?'': mapPS_Attribute.get('GTAG07');
        }
        set {
            this.GTAG07 = value;
            
        }
    }
    public string GTAG08 {
        get {
            return mapPS_Attribute.get('GTAG08')==null?'': mapPS_Attribute.get('GTAG08');
        }
        set {
            this.GTAG08 = value;
            
        }
    }
    
    public string GTAG09 {
        get {
            return mapPS_Attribute.get('GTAG09')==null?'': mapPS_Attribute.get('GTAG09');
        }
        set {
            this.GTAG09 = value;
            
        }
    }
    
    public string GTAG10 {
        get {
            return mapPS_Attribute.get('GTAG10')==null?'': mapPS_Attribute.get('GTAG10');
        }
        set {
            this.GTAG10 = value;
            
        }
    }
    
     public string GTAG14 {
        get {
             return mapPS_Attribute.get('GTAG14')==null?'': mapPS_Attribute.get('GTAG14');
        }
        set {
            this.GTAG14 = value;
        } 
    }
	
    public string GTAG15 {
        get {
             return mapPS_Attribute.get('GTAG15')==null?'': mapPS_Attribute.get('GTAG15');
        }
        set {
            this.GTAG15 = value;
        } 
    }
   
    public string GTAG16 {
        get {
             return mapPS_Attribute.get('GTAG16')==null?'': mapPS_Attribute.get('GTAG16');
        }
        set {
            this.GTAG16 = value;
        } 
    }
    
     public string GTAG17 {
        get {
             return mapPS_Attribute.get('GTAG17')==null?'': mapPS_Attribute.get('GTAG17');
        }
        set {
            this.GTAG17 = value;
        } 
    }
    
    public string GTAG18 {
        get {
            return mapPS_Attribute.get('GTAG18')==null?'': mapPS_Attribute.get('GTAG18');
        }
        set {
            this.GTAG18 = value;
            
        }
    }
    
    public string GTAG19 {
        get {
            return mapPS_Attribute.get('GTAG19')==null?'': mapPS_Attribute.get('GTAG19');
        }
        set {
            this.GTAG19 = value;
            
        }
    }
   
    public string GTAG20 {
        get {
            return mapPS_Attribute.get('GTAG20')==null?'': mapPS_Attribute.get('GTAG20');
        }
        set {
            this.GTAG20 = value;
            
        }
    }
    
    public string GTAG21 {
        get {
            return mapPS_Attribute.get('GTAG21')==null?'': mapPS_Attribute.get('GTAG21');
        }
        set {
            this.GTAG21 = value;
            
        }
    }
    
    public string GTAG22 {
        get {
            return mapPS_Attribute.get('GTAG22')==null?'': mapPS_Attribute.get('GTAG22');
        }
        set {
            this.GTAG22 = value;
            
        }
    }
    
    public string GTAG23 {
        get {
            return mapPS_Attribute.get('GTAG23')==null?'': mapPS_Attribute.get('GTAG23');
        }
        set {
            this.GTAG23 = value;
            
        }
    }
     public string GTAGPN {
        get {
             return mapPS_Attribute.get('GTAGPN')==null?'': mapPS_Attribute.get('GTAGPN');
        }
        set {
            this.GTAGPN = value;
        } 
    }
    
    public String HCLASS {
        get {
            if(currentPS.HCLASS__c != null)
            {
                return currentPS.HCLASS__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentPS.HCLASS__c = value;
            this.HCLASS = value;
        }
    }
    
    public string PARTREV { 
        get 
        {
            if(currentPS.PARTREV__c != null)
            {
                return currentPS.PARTREV__c;
            }
            else
            {
                return '1';
            }
        }
        set 
        {
            this.PARTREV = value;
            System.debug('@@@PARTREV' +PARTREV);
        }
        
    }
   
    
         public string IINO  {
        get {
             return mapPS_Attribute.get('IINO')==null?'': mapPS_Attribute.get('IINO');
        }
        set {
            this.IINO = value;
        } 
    }
	
     public string HSNSACCODE {
        get {
             return mapPS_Attribute.get('HSNSACCODE')==null?'': mapPS_Attribute.get('HSNSACCODE');
        }
        set {
            this.HSNSACCODE = value;
        } 
    }

     public string INHOUSEPAINT {
        get {
             return mapPS_Attribute.get('INHOUSEPAINT')==null?'': mapPS_Attribute.get('INHOUSEPAINT');
        }
        set {
            this.INHOUSEPAINT = value;
        } 
    }
    
    public string LOTTRACKCODE {
        get {
             return mapPS_Attribute.get('LOTTRACKCODE')==null?'': mapPS_Attribute.get('LOTTRACKCODE');
        }
        set {
            this.LOTTRACKCODE = value;
        } 
    }
    
    public String MCBODY {
        get {
            if(currentPS.MCBODY__c != null)
            {
                return currentPS.MCBODY__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentPS.MCBODY__c = value;
            this.MCBODY = value;
        }
    }
    public String MCDPHM {
        get {
            if(string.isNotBlank(currentPS.MCDPHM__c))

            {
                return currentPS.MCDPHM__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentPS.MCDPHM__c = value;
            this.MCDPHM = value;
        }
    }
    
    
    
    public String MCELMT
 {
        get {
            if(string.isNotBlank(currentPS.MCELMT__c))
            {
                return currentPS.MCELMT__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentPS.MCELMT__c = value;
            this.MCELMT = value;
        }
    }
    
    public String MCHOUS {
        get {
            if(string.isNotBlank(currentPS.MCHOUS__c))
            {
                return currentPS.MCHOUS__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentPS.MCHOUS__c = value;
            this.MCHOUS = value;
        }
    }
    
    public string MCPALL {
        get {
            string MCPALL1;
            MCPALL1 = mapPS_Attribute.get('MCPALL')==null?'': mapPS_Attribute.get('MCPALL'); 
            // return mapPS_Attribute.get('MCPALL')==null?'': mapPS_Attribute.get('MCPALL');
            if(MCPALL1 == null || string.isBlank(MCPALL1))
            {
                MCPALL1= currentPS.MCPALL__c ;
                
            } 
            return MCPALL1;
            
        }
        set {
            this.MCPALL = value;
        }
    }
    
    public string NACE {
        get {
            if(currentPS.NACE__c != null)
            {
                return currentPS.NACE__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentPS.NACE__c = value;
            this.NACE = value;
        }
    }
       
   
    
    public string OA02 {
        get {
             return mapPS_Attribute.get('OA02')==null?'': mapPS_Attribute.get('OA02 '); 

        }
        set {
            this.OA02 = value;
        }
    }
	
    public string OA04 {
        get {
             return mapPS_Attribute.get('OA04')==null?'': mapPS_Attribute.get('OA04'); 

        }
        set {
            this.OA04 = value;
        }
    }

    public string OA05 {
        get {
             return mapPS_Attribute.get('OA05')==null?'': mapPS_Attribute.get('OA05 '); 

        }
        set {
            this.OA05 = value;
        }
    }

    public string OA06 {
        get {
             return mapPS_Attribute.get('OA06')==null?'': mapPS_Attribute.get('OA06 '); 

        }
        set {
            this.OA06 = value;
        }
    }
    
    Public string OB010 {
        get {
             return mapPS_Attribute.get('OB010')==null?'': mapPS_Attribute.get('OB010 '); 

        }
        set {
            this.OB010 = value;
        }
    }
    
     Public string OB020 {
        get {
             return mapPS_Attribute.get('OB020')==null?'': mapPS_Attribute.get('OB020 '); 

        }
        set {
            this.OB020 = value;
        }
    }
    
     Public string OB030 {
        get {
             return mapPS_Attribute.get('OB030')==null?'': mapPS_Attribute.get('OB030 '); 

        }
        set {
            this.OB030 = value;
        }
    }
     Public string OB040 {
        get {
             return mapPS_Attribute.get('OB040')==null?'': mapPS_Attribute.get('OB040 '); 

        }
        set {
            this.OB040 = value;
        }
    }
     Public string OB050 {
        get {
             return mapPS_Attribute.get('OB050')==null?'': mapPS_Attribute.get('OB050 '); 

        }
        set {
            this.OB050 = value;
        }
    }
    
    Public string OB060 {
        get {
             return mapPS_Attribute.get('OB060')==null?'': mapPS_Attribute.get('OB060 '); 

        }
        set {
            this.OB060 = value;
        }
    }
    
    Public string OB110 {
        get {
             return mapPS_Attribute.get('OB11')==null?'': mapPS_Attribute.get('OB110 '); 

        }
        set {
            this.OB110 = value;
        }
    }
    Public string OB120 {
        get {
             return mapPS_Attribute.get('OB120')==null?'': mapPS_Attribute.get('OB120 '); 

        }
        set {
            this.OB120 = value;
        }
    }
    
     Public string OB210 {
        get {
             return mapPS_Attribute.get('OB210')==null?'': mapPS_Attribute.get('OB210 '); 

        }
        set {
            this.OB210 = value;
        }
    }
    
    Public string OB220 {
        get {
             return mapPS_Attribute.get('OB220')==null?'': mapPS_Attribute.get('OB220 '); 

        }
        set {
            this.OB220 = value;
        }
    }
    Public string OB230 {
        get {
             return mapPS_Attribute.get('OB230')==null?'': mapPS_Attribute.get('OB230 '); 

        }
        set {
            this.OB230 = value;
        }
    }
    Public string OB240 {
        get {
             return mapPS_Attribute.get('OB240')==null?'': mapPS_Attribute.get('OB240 '); 

        }
        set {
            this.OB240 = value;
        }
    }
    Public string OB250 {
        get {
             return mapPS_Attribute.get('OB250')==null?'': mapPS_Attribute.get('OB250'); 

        }
        set {
            this.OB250 = value;
        }
    }
    Public string OB260 {
        get {
             return mapPS_Attribute.get('OB260')==null?'': mapPS_Attribute.get('OB260 '); 

        }
        set {
            this.OB260 = value;
        }
    }
    Public string OB310 {
        get {
             return mapPS_Attribute.get('OB310')==null?'': mapPS_Attribute.get('OB310 '); 

        }
        set {
            this.OB310 = value;
        }
    }
    
     Public string OB370  {
        get {
             return mapPS_Attribute.get('OB370 ')==null?'': mapPS_Attribute.get('OB370'); 

        }
        set {
            this.OB370  = value;
        }
    }
    
    Public string OB311 {
        get {
             return mapPS_Attribute.get('OB311')==null?'': mapPS_Attribute.get('OB311'); 

        }
        set {
            this.OB311 = value;
        }
    }
    Public string OB312 {
        get {
             return mapPS_Attribute.get('OB312')==null?'': mapPS_Attribute.get('OB312'); 

        }
        set {
            this.OB312 = value;
        }
    }
    
    Public string OB410 {
        get {
             return mapPS_Attribute.get('OB410')==null?'': mapPS_Attribute.get('OB410'); 

        }
        set {
            this.OB410 = value;
        }
    }
    
     Public string OB411 {
        get {
             return mapPS_Attribute.get('OB411')==null?'': mapPS_Attribute.get('OB411'); 

        }
        set {
            this.OB411 = value;
        }
    }
    
    Public string OB420 {
        get {
             return mapPS_Attribute.get('OB420')==null?'': mapPS_Attribute.get('OB420'); 

        }
        set {
            this.OB420 = value;
        }
    }
    
        Public string OB421 {
        get {
             return mapPS_Attribute.get('OB421')==null?'': mapPS_Attribute.get('OB421'); 

        }
        set {
            this.OB421 = value;
        }
    }
    
        Public string OB430 {
        get {
             return mapPS_Attribute.get('OB430')==null?'': mapPS_Attribute.get('OB430'); 

        }
        set {
            this.OB430 = value;
        }
    }
    
            Public string OB431 {
        get {
             return mapPS_Attribute.get('OB431')==null?'': mapPS_Attribute.get('OB431'); 

        }
        set {
            this.OB431 = value;
        }
    }
    
            Public string OB440 {
        get {
             return mapPS_Attribute.get('OB440')==null?'': mapPS_Attribute.get('OB440'); 

        }
        set {
            this.OB440 = value;
        }
    }
    
    Public string OB441 {
        get {
             return mapPS_Attribute.get('OB441')==null?'': mapPS_Attribute.get('OB441'); 

        }
        set {
            this.OB441 = value;
        }
    }
    
      Public string OB510 {
        get {
             return mapPS_Attribute.get('OB510')==null?'': mapPS_Attribute.get('OB510'); 

        }
        set {
            this.OB510 = value;
        }
    }
	
     Public string OB530 {
        get {
             return mapPS_Attribute.get('OB530')==null?'': mapPS_Attribute.get('OB530'); 

        }
        set {
            this.OB530 = value;
        }
    }

     Public string OB540 {
        get {
             return mapPS_Attribute.get('OB540')==null?'': mapPS_Attribute.get('OB540'); 

        }
        set {
            this.OB540 = value;
        }
    }

     Public string OB550 {
        get {
             return mapPS_Attribute.get('OB550')==null?'': mapPS_Attribute.get('OB550'); 

        }
        set {
            this.OB550 = value;
        }
    }

     Public string OW110 {
        get {
             return mapPS_Attribute.get('OW110')==null?'': mapPS_Attribute.get('OW110'); 

        }
        set {
            this.OW110 = value;
        }
    }
    
    Public string OW120 {
        get {
             return mapPS_Attribute.get('OW120')==null?'': mapPS_Attribute.get('OW120'); 

        }
        set {
            this.OW120 = value;
        }
    }
    
    Public string OW130 {
        get {
             return mapPS_Attribute.get('OW130')==null?'': mapPS_Attribute.get('OW130'); 

        }
        set {
            this.OW130 = value;
        }
    }
    
    Public string OW140 {
        get {
             return mapPS_Attribute.get('OW140')==null?'': mapPS_Attribute.get('OW140'); 

        }
        set {
            this.OW140 = value;
        }
    }
    
    Public string OW150 {
        get {
             return mapPS_Attribute.get('OW150')==null?'': mapPS_Attribute.get('OW150'); 

        }
        set {
            this.OW150 = value;
        }
    }
    
    Public string OW160 {
        get {
             return mapPS_Attribute.get('OW160')==null?'': mapPS_Attribute.get('OW160'); 

        }
        set {
            this.OW160 = value;
        }
    }
    
    Public string OW170 {
        get {
             return mapPS_Attribute.get('OW170')==null?'': mapPS_Attribute.get('OW170'); 

        }
        set {
            this.OW170 = value;
        }
    }
    
    Public string OW180 {
        get {
             return mapPS_Attribute.get('OW180')==null?'': mapPS_Attribute.get('OW180'); 

        }
        set {
            this.OW180 = value;
        }
    }
    
    Public string OW190 {
        get {
             return mapPS_Attribute.get('OW190')==null?'': mapPS_Attribute.get('OW190'); 

        }
        set {
            this.OW190 = value;
        }
    }
    
    Public string OW200 {
        get {
             return mapPS_Attribute.get('OW200')==null?'': mapPS_Attribute.get('OW200'); 

        }
        set {
            this.OW200 = value;
        }
    }
    
    Public string OW210 {
        get {
             return mapPS_Attribute.get('OW210')==null?'': mapPS_Attribute.get('OW210'); 

        }
        set {
            this.OW210 = value;
        }
    }

    
    Public string OW220 {
        get {
             return mapPS_Attribute.get('OW220')==null?'': mapPS_Attribute.get('OW220'); 

        }
        set {
            this.OW220 = value;
        }
    } 
    
    Public string OW230 {
        get {
             return mapPS_Attribute.get('OW230')==null?'': mapPS_Attribute.get('OW230'); 

        }
        set {
            this.OW230 = value;
        }
    }
       
    Public string OW240 {
        get {
             return mapPS_Attribute.get('OW240')==null?'': mapPS_Attribute.get('OW240'); 

        }
        set {
            this.OW240 = value;
        }
    }

    
    Public string OW250 {
        get {
             return mapPS_Attribute.get('OW250')==null?'': mapPS_Attribute.get('OW250'); 

        }
        set {
            this.OW250 = value;
        }
    }

    
    Public string OW260 {
        get {
             return mapPS_Attribute.get('OW260')==null?'': mapPS_Attribute.get('OW260'); 

        }
        set {
            this.OW260 = value;
        }
    }

    
    Public string OW270 {
        get {
             return mapPS_Attribute.get('OW270')==null?'': mapPS_Attribute.get('OW270'); 

        }
        set {
            this.OW270 = value;
        }
    }

    
    Public string OW280 {
        get {
             return mapPS_Attribute.get('OW280')==null?'': mapPS_Attribute.get('OW280'); 

        }
        set {
            this.OW280 = value;
        }
    }

    
    Public string OW290 {
        get {
             return mapPS_Attribute.get('OW290')==null?'': mapPS_Attribute.get('OW290'); 

        }
        set {
            this.OW290 = value;
        }
    }

    Public string OW300 {
        get {
             return mapPS_Attribute.get('OW300')==null?'': mapPS_Attribute.get('OW300'); 

        }
        set {
            this.OW300 = value;
        }
    }
    
    Public string OW310 {
        get {
             return mapPS_Attribute.get('OW310')==null?'': mapPS_Attribute.get('OW310'); 

        }
        set {
            this.OW310 = value;
        }
    }
    
    Public string OW320 {
        get {
             return mapPS_Attribute.get('OW320')==null?'': mapPS_Attribute.get('OW320'); 

        }
        set {
            this.OW320 = value;
        }
    }
    
    Public string OW330 {
        get {
             return mapPS_Attribute.get('OW330')==null?'': mapPS_Attribute.get('OW330'); 

        }
        set {
            this.OW330 = value;
        }
    }
    
    Public string OW340 {
        get {
             return mapPS_Attribute.get('OW340')==null?'': mapPS_Attribute.get('OW340'); 

        }
        set {
            this.OW340 = value;
        }
    }
    
     Public string OW910 {
        get {
             return mapPS_Attribute.get('OW910')==null?'': mapPS_Attribute.get('OW910'); 

        }
        set {
            this.OW910 = value;
        }
    }
    
    
     Public string OW920 {
        get {
             return mapPS_Attribute.get('OW920')==null?'': mapPS_Attribute.get('OW920'); 

        }
        set {
            this.OW920 = value;
        }
    }
    
    Public string PARTCLASS  {
        get {
             return mapPS_Attribute.get('PARTCLASS')==null?'': mapPS_Attribute.get('PARTCLASS'); 

        }
        set {
            this.PARTCLASS = value;
        }
    }
    
    public String PartNum
	 {
        get {
            return currentPS.PartNum__c;
        }
        set {
            this.PartNum = value;
        }
     }
    
    
     Public String PSAssyPartNumberLookup{
        get{
            
            //return currentPS.Part_Number__c;
            //return currentPS.Part_Number_Backup__c;
            return currentPS.Part_Number_Backup__c;//added by Ashim
            
            //return currentPS.PSAssyPartNumberLookup__c;
        }
        set{
            this.PSAssyPartNumberLookup = value;
        }
    }
    
    Public string PARTUOM {
        get {
             return mapPS_Attribute.get('PARTUOM')==null?'': mapPS_Attribute.get('PARTUOM'); 

        }
        set {
            this.PARTUOM = value;
        }
    }
    
    Public string PC410 {
        get {
             return mapPS_Attribute.get('PC410')==null?'': mapPS_Attribute.get('PC410'); 

        }
        set {
            this.PC410 = value;
        }
    }
    
    Public string PC411 {
        get {
             return mapPS_Attribute.get('PC411')==null?'': mapPS_Attribute.get('PC411'); 

        }
        set {
            this.PC411 = value;
        }
    }
    
    Public string PC420 {
        get {
             return mapPS_Attribute.get('PC420')==null?'': mapPS_Attribute.get('PC420'); 

        }
        set {
            this.PC420 = value;
        }
    }
    
     Public string PC421 {
        get {
             return mapPS_Attribute.get('PC421')==null?'': mapPS_Attribute.get('PC421'); 

        }
        set {
            this.PC421 = value;
        }
    }
    
     Public string PC430 {
        get {
             return mapPS_Attribute.get('PC430')==null?'': mapPS_Attribute.get('PC430'); 

        }
        set {
            this.PC430 = value;
        }
    }
    
     Public string PC431 {
        get {
             return mapPS_Attribute.get('PC431')==null?'': mapPS_Attribute.get('PC431'); 

        }
        set {
            this.PC431 = value;
        }
    }
    
     Public string PC440 {
        get {
             return mapPS_Attribute.get('PC440')==null?'': mapPS_Attribute.get('PC440'); 

        }
        set {
            this.PC440 = value;
        }
    }
    
      Public string PC441{
        get {
             return mapPS_Attribute.get('PC441')==null?'': mapPS_Attribute.get('PC441'); 

        }
        set {
            this.PC441 = value;
        }
    }    
    
    
    Public string PLANNER {
        get {
             return mapPS_Attribute.get('PLANNER')==null?'': mapPS_Attribute.get('PLANNER'); 

        }
        set {
            this.PLANNER = value;
        }
    }  
    
     public string ProdGroup
      {
        get {
            if(currentPS.ProductGroup__c != null)
            {
                return currentPs.ProductGroup__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentPS.ProductGroup__c = value;
            this.ProdGroup = value;
        }
    }
    
     Public string PROVIDE {
        get {
             return mapPS_Attribute.get('PROVIDE')==null?'': mapPS_Attribute.get('PROVIDE'); 

        }
        set {
            this.PROVIDE = value;
        }
    }  
    
    
    public string PTC

      {
        get {
            
            if(currentPS.PTC__c != null)
            {
                return currentPS.PTC__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentPS.PTC__c = value;
            this.PTC = value;
        }
    }
    
    Public string RESPONSIBLE_ID
     {
        get {
             return mapPS_Attribute.get('RESPONSIBLEID')==null?'': mapPS_Attribute.get('RESPONSIBLEID'); 

        }
        set {
            this.RESPONSIBLE_ID = value;
        }
    }  
    
    Public string SALESGROUP {
        get {
             return mapPS_Attribute.get('SALESGROUP')==null?'': mapPS_Attribute.get('SALESGROUP'); 

        }
        set {
            this.SALESGROUP = value;
        }
    }  
    
     Public string SALESPRICEGROUP {
        get {
             return mapPS_Attribute.get('SALESPRICEGROUP')==null?'': mapPS_Attribute.get('SALESPRICEGROUP'); 

        }
        set {
            this.SALESPRICEGROUP = value;
        }
    }  
    
      Public string SERIALTRACKCODE {
        get {
             return mapPS_Attribute.get('SERIALTRACKCODE')==null?'': mapPS_Attribute.get('SERIALTRACKCODE'); 

        }
        set {
            this.SERIALTRACKCODE = value;
        }
    }  
    
    public string SETTING
      {
        get {
            if(currentPS.SETTING__c != null)
            {
                return currentPS.SETTING__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentPS.SETTING__c = value;
            this.SETTING = value;
        }
    }
    
    
    Public string SHLTSTBDYPSIG {
        get {
             return mapPS_Attribute.get('SHLTSTBDYPSIG')==null?'': mapPS_Attribute.get('SHLTSTBDYPSIG'); 

        }
        set {
            this.SHLTSTBDYPSIG = value;
        }
    }  
    
     Public string SOURCINGOPT {
        get {
             return mapPS_Attribute.get('SOURCINGOPT')==null?'': mapPS_Attribute.get('SOURCINGOPT'); 

        }
        set {
            this.SOURCINGOPT = value;
        }
    }  
    
    public string SubGroup
     {
        get {
            if(currentPS.SubGroup__c != null)
            {
                return currentPS.SubGroup__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentPS.SubGroup__c = value;
            this.SubGroup = value;
        }
    }

      public string SZC{
        get {
            if(String.isNotBlank(currentPS.SZC__c))
            {
                return currentPS.SZC__c;
            }
            else{
                return '';
            } 
        }
        set {
            currentPS.SZC__c = value;
            this.SZC = value;
        }
    }
    
     /*public String SZC {
        get {
            return currentPS.SZC__c;
        }
        set {
            this.SZC = value;
        }
    }*/
    
    Public string VENDORPAINT {
        get {
             return mapPS_Attribute.get('VENDORPAINT')==null?'': mapPS_Attribute.get('VENDORPAINT'); 

        }
        set {
            this.VENDORPAINT = value;
        }
    }   
    
     Public String GMODEL {
        get{
            return GMODEL1 + GMODEL2 + GMODEL3 + GMODEL4 + GMODEL5 + GMODEL6 + GMODEL7;
        }
        set{
            this.GMODEL = value;
            System.debug('Gmodel value===' +GMODEL);
        }
    } 
   
    
     
    Public string OA {
        get ;
             //return OA01__c + OA02__c + OA04__c + OA05__c + OA06__c;
			
            
            //return currentPS.OA__c;
            
        
        
        set {
            this.OA	 = value;
        }
    }  
    
    Public string OA01 {
        get {
             
			
            return  'Model: '+ GMODEL;

        }
        set {
            this.OA01 = value;
        }
    }
    
    Public string OB {
        get;
             //return currentPS.OB__c; 
        

        
        set {
            this.OB	 = value;
        }
    } 
    
    Public string OW {
        get;
             //return currentPS.OW__c;
        

        set {
            this.OW	 = value;
        }
    }  
    
     Public string PC{
         get;
             //return currentPS.PC__c;
         

        set {
            this.PC	 = value;
        }
    } 
    
    Public string ORP{
        get;
             //return currentPS.ORP__c;
            
        

        set {
            this.ORP = value;
        }
    } 
    
    Public string ORV{
        get;
             //return currentPS.ORV__c;
        

        set {
            this.ORV = value;
        }
    } 
    
    //@ Ouput method for Structures
     Public Result getStructure()
    {
        result PSStructure = new Result();
        List<String> selectCols = new List<String> {'Component_Part__c','Qty_per_Assembly__c','ProdGroup__c','SubGroup__c','Scrap_Factor__c','Component_Scrap__c','ItemNo__c','Structure_Element__c'};
                 
        PSStructure=wizardBaseDataProcessor.getSortedDataFromTranslationObj1('ItemNo__c','PS_Structure_Translation__c','PS_Structure_Details__c',mapPSAttr,selectCols,'ItemNo__c',ProdGroup,SubGroup);
        return PSStructure; 
    }
     
    //@ Ouput method for Routing
   Public Result getRouting()
    {
        result PSRouting = new Result();
        List<String> selectCols = new List<String> {'Standard_Operation_ID__c,Operation__c,Outside_Operation_Item__c,Descr__c'};
        PSRouting=wizardBaseDataProcessor.getSortedDataFromTranslationObj1('Operation__c','PS_Routing_Translation__c','PS_Routing_Details__c',mapPSAttr,selectCols,'Operation__c',ProdGroup,SubGroup);
        /*if(PSRouting.bResult)
        { 
            system.debug('Routing Result' +PSRouting.objResultList);
        }*/ 
        return PSRouting; 
    }
 
    Public Result getControlPlan()
    {
        System.debug('**** Control plan method invoke');
        result PSControlPlan = new Result();
        List<String> selectCols = new List<String> {'Operation_Number__c','Data_Point__c','INNER_MAX__c','DATA_TYPE__c','CATEGORY_ID__c','INNER_MIN__c',
        'INSPECTION_CODE__c','NOMINAL_VALUE__c','NORM_TYPE__c','OUTER_MAX__c','OUTER_MIN__c','Process_Characteristic__c','TEST_OPERATION_DESC__c','Tool_ID__c','Test_OPNO__c','SAMPLE_PERCENT__c'};       
        PSControlPlan=wizardBaseDataProcessor.getSortedDataFromTranslationObj1('Test_OPNO__c','PS_ControlPlan_Translation__c','PS_ControlPlan_Details__c',mapPSAttr,selectCols,'Test_OPNO__c',ProdGroup,SubGroup);        
        /*if(PSControlPlan.bResult)
        { 
            system.debug('ControlPlan Result' +PSControlPlan.objResultList);
        }*/
        
         system.debug('ControlPlan Result' +PSControlPlan);
        return PSControlPlan; 
       
    }
    
    Public Result getWorkGuideLines()
        
    {
        result PSWorkGuideLines = new Result();
        List<String> selectCols = new List<String> {'GuidlineSeq__c','Operation__c','Description__c','Inspection_Sign_Off_Required__c','Sign_Off__c','Text__c,Type__c'};
        PSWorkGuideLines=wizardBaseDataProcessor.getSortedDataFromTranslationObj1('GuidlineSeq__c','PS_Work_Guidelines_Translation__c','PS_Work_Guidelines_Details__c',mapPSAttr,selectCols,'GuidlineSeq__c',ProdGroup,SubGroup);
        /*if(PSWorkGuideLines.bResult)
        { 
            system.debug('WorkGuideLines Result' +PSWorkGuideLines.objResultList);
        }*/ 
        
         system.debug('WorkGuideLines Result' +PSWorkGuideLines);
        return PSWorkGuideLines; 
    }
    
    Public Result getDocument()
   {
        result PSDocument = new Result();
        List<String> selectCols = new List<String> {'Document__c','Document_ID__c','Revision__c'};
        PSDocument = wizardBaseDataProcessor.getSortedDataFromTranslationObj1('Document__c','PS_Document_Translation__c','PS_Document_Details__c',mapPSAttr,selectCols,'Document__c',ProdGroup,SubGroup);
        /*if(PSDocument.bResult)
        { 
            system.debug('Document Result' +PSDocument.objResultList);
        }*/
        return PSDocument; 
    }
    
    
    public Map<string,string> getmapPSInterfaceAttr(){
            Map<String, string> myMap1 = new Map<String, String>(); 
                myMap1.put('ASYTYP',mapPSAttr.get('ASYTYP'));
                myMap1.put('ATEX',mapPSAttr.get('ATEX'));
				myMap1.put('CUTR',mapPSAttr.get('CUTR'));
				myMap1.put('ESZC',mapPSAttr.get('ESZC'));
				myMap1.put('GMODEL',mapPSAttr.get('GMODEL'));
				myMap1.put('GPFACE',mapPSAttr.get('GPFACE'));
				myMap1.put('GTAG01',mapPSAttr.get('GTAG01'));
        		myMap1.put('GTAG02',mapPSAttr.get('GTAG02'));
				myMap1.put('GTAG04',mapPSAttr.get('GTAG04'));
				myMap1.put('GTAG05',mapPSAttr.get('GTAG05'));
				myMap1.put('GTAG06',mapPSAttr.get('GTAG06'));
        		myMap1.put('GTAG07',mapPSAttr.get('GTAG07'));
        		myMap1.put('GTAG08',mapPSAttr.get('GTAG08'));
        		myMap1.put('GTAG09',mapPSAttr.get('GTAG09'));
        		myMap1.put('GTAG10',mapPSAttr.get('GTAG10'));
				myMap1.put('GTAG14',mapPSAttr.get('GTAG14'));
				myMap1.put('GTAG15',mapPSAttr.get('GTAG15'));
				myMap1.put('GTAG16',mapPSAttr.get('GTAG16'));
				myMap1.put('GTAG17',mapPSAttr.get('GTAG17'));
        		myMap1.put('GTAG18',mapPSAttr.get('GTAG18'));
        		myMap1.put('GTAG19',mapPSAttr.get('GTAG19'));
        		myMap1.put('GTAG20',mapPSAttr.get('GTAG20'));
        		myMap1.put('GTAG21',mapPSAttr.get('GTAG21'));
        		myMap1.put('GTAG22',mapPSAttr.get('GTAG22'));
        		myMap1.put('GTAG23',mapPSAttr.get('GTAG23'));
				myMap1.put('GTAGPN',mapPSAttr.get('GTAGPN'));
				myMap1.put('HCLASS',mapPSAttr.get('HCLASS'));
				myMap1.put('IINO',mapPSAttr.get('IINO'));
				myMap1.put('MCBODY',mapPSAttr.get('MCBODY'));
				myMap1.put('MCDPHM',mapPSAttr.get('MCDPHM'));
				myMap1.put('MCELMT',mapPSAttr.get('MCELMT'));
				myMap1.put('MCHOUS',mapPSAttr.get('MCHOUS'));
				myMap1.put('MCPALL',mapPSAttr.get('MCPALL'));
				myMap1.put('OA',mapPSAttr.get('OA'));
				myMap1.put('OB',mapPSAttr.get('OB'));
				myMap1.put('OW',mapPSAttr.get('OW'));
				myMap1.put('PC',mapPSAttr.get('PC'));
				myMap1.put('PTC',mapPSAttr.get('PTC'));
                myMap1.put('GPAINT',mapPSAttr.get('GPAINT'));
                myMap1.put('MCSEAT',mapPSAttr.get('MCSEAT'));
                myMap1.put('MCWGHT',mapPSAttr.get('MCWGHT'));
				myMap1.put('SETTING',mapPSAttr.get('SETTING'));
				myMap1.put('SHLTSTBDYPSIG',mapPSAttr.get('SHLTSTBDYPSIG'));
				myMap1.put('SOURCINGOPT',mapPSAttr.get('SOURCINGOPT'));
				myMap1.put('SPRING',mapPSAttr.get('SPRING'));
				myMap1.put('SZC',mapPSAttr.get('SZC'));
				return myMap1;
				}
    //return myMap1;
    
    
          public Map<string,string> getmapPSTroubleshootingAttr(){
            Map<String, string> myMap1 = new Map<String, String>(); 
              	myMap1.put('PSAssyPartNumberLookup',mapPSAttr.get('PSAssyPartNumberLookup'));
                myMap1.put('ASSEMBLYWT',mapPSAttr.get('ASSEMBLYWT'));
                myMap1.put('ASSEMBLYWTUOM',mapPSAttr.get('ASSEMBLYWTUOM'));
				myMap1.put('ATTRTEMPLATE',mapPSAttr.get('ATTRTEMPLATE'));
				myMap1.put('COMPDESCRIPTION',mapPSAttr.get('COMPDESCRIPTION'));
				myMap1.put('COMPINVSERTRK',mapPSAttr.get('COMPINVSERTRK'));
				myMap1.put('COMPLOTTRACK',mapPSAttr.get('COMPLOTTRACK'));
				myMap1.put('COMPPROVIDE',mapPSAttr.get('COMPPROVIDE'));
				myMap1.put('COMPRESPONID',mapPSAttr.get('COMPRESPONID'));
				myMap1.put('CUSTOMSTATNO',mapPSAttr.get('CUSTOMSTATNO'));
				myMap1.put('GMODEL1',mapPSAttr.get('GMODEL1'));
				myMap1.put('GMODEL2',mapPSAttr.get('GMODEL2'));
				myMap1.put('GMODEL3',mapPSAttr.get('GMODEL3'));
				myMap1.put('GMODEL4',mapPSAttr.get('GMODEL4'));
				myMap1.put('GMODEL5',mapPSAttr.get('GMODEL5'));
				myMap1.put('GMODEL6',mapPSAttr.get('GMODEL6'));
				myMap1.put('GMODEL7',mapPSAttr.get('GMODEL7'));
				myMap1.put('HSNSACCODE',mapPSAttr.get('HSNSACCODE'));
				myMap1.put('INHOUSEPAINT',mapPSAttr.get('INHOUSEPAINT'));
				myMap1.put('LOTTRACKCODE',mapPSAttr.get('LOTTRACKCODE'));
				myMap1.put('PARTCLASS',mapPSAttr.get('PARTCLASS'));
				myMap1.put('PARTUOM',mapPSAttr.get('PARTUOM'));
				myMap1.put('PLANNER',mapPSAttr.get('PLANNER'));
				myMap1.put('PROVIDE',mapPSAttr.get('PROVIDE'));
                myMap1.put('GPDS01',mapPSAttr.get('GPDS01'));
                myMap1.put('GPDS03',mapPSAttr.get('GPDS03'));
                myMap1.put('GPDS05',mapPSAttr.get('GPDS05'));
                myMap1.put('GPDS06',mapPSAttr.get('GPDS06'));
                myMap1.put('GPDS07',mapPSAttr.get('GPDS07'));
                myMap1.put('GPDS09',mapPSAttr.get('GPDS09'));
                myMap1.put('GPDS17',mapPSAttr.get('GPDS17'));
                myMap1.put('GPDS18',mapPSAttr.get('GPDS18'));
                myMap1.put('GPDS19',mapPSAttr.get('GPDS19'));
                myMap1.put('GPDS20',mapPSAttr.get('GPDS20'));
                myMap1.put('GPDS21',mapPSAttr.get('GPDS21'));
                myMap1.put('GPDS22',mapPSAttr.get('GPDS22'));
                myMap1.put('GPDS23',mapPSAttr.get('GPDS23'));
                myMap1.put('GPDS24',mapPSAttr.get('GPDS24'));
                myMap1.put('GPDS25',mapPSAttr.get('GPDS25'));
                myMap1.put('GPDS26',mapPSAttr.get('GPDS26'));
                myMap1.put('GPDS27',mapPSAttr.get('GPDS27'));
                myMap1.put('GPDS28',mapPSAttr.get('GPDS28'));
                myMap1.put('PRDLIN',mapPSAttr.get('PRDLIN')); 
                myMap1.put('RGEUNT',mapPSAttr.get('RGEUNT'));
                myMap1.put('RTPRS1',mapPSAttr.get('RTPRS1')); 
                myMap1.put('RTPRSU',mapPSAttr.get('RTPRSU')); 
                myMap1.put('VGEUNT',mapPSAttr.get('VGEUNT'));              
                myMap1.put('VTPRS1',mapPSAttr.get('VTPRS1')); 
                myMap1.put('VTPRSU',mapPSAttr.get('VTPRSU'));               
				myMap1.put('RESPONSIBLE_ID',mapPSAttr.get('RESPONSIBLE_ID'));
				myMap1.put('SALESGROUP',mapPSAttr.get('SALESGROUP'));
				myMap1.put('SALESPRICEGROUP',mapPSAttr.get('SALESPRICEGROUP'));
				myMap1.put('SERIALTRACKCODE',mapPSAttr.get('SERIALTRACKCODE'));
				myMap1.put('VENDORPAINT',mapPSAttr.get('VENDORPAINT'));				
				return myMap1;
				}
    
    public Map<String, String> GetPSIFSDescription()
    {
        Map<String, String> quoteAttriVsDesc = new Map<String, String>();
        List<PS_IFS_Description__c> PSIFSDesc = new List<PS_IFS_Description__c>();
        
        //String partNumberBase = currentPS.Part_Number_Base__c;
        String partNumberBase = currentPS.Part_Number_Base_Backup__c; //added by Ashim
        PSIFSDesc = [SELECT Id,Name,OA__c,OB__c,ORP__c,ORV__c,OW__c,CUSTOMS_STAT_NO__c,CHAR_TEMPLATE__c,INV_SERIAL_TRACKING__c,PLANNER__c,HSN_SAC_CODE__c FROM PS_IFS_Description__c WHERE ASSYPARTNO__c = :partNumberBase];
        
        if(PSIFSDesc.size() == 0) {
            
            if(currentPS.Quote_Description_Engineer_Override__c && currentPS.Part_Number_Base__c != currentPS.Part_Number_Backup__c) {
                
                system.debug('partNumberBase::'+partNumberBase);
                //partNumberBase = currentPS.Part_Number__c;
                partNumberBase = currentPS.Part_Number_Backup__c; //added by Ashim
                system.debug('partNumberBase::'+partNumberBase);
            }
            PSIFSDesc = [SELECT Id,Name,OA__c,OB__c,ORP__c,ORV__c,OW__c,CUSTOMS_STAT_NO__c,CHAR_TEMPLATE__c,INV_SERIAL_TRACKING__c,PLANNER__c,HSN_SAC_CODE__c FROM PS_IFS_Description__c WHERE ASSYPARTNO__c = :partNumberBase];
        }
        
        if(PSIFSDesc.size() > 0)
        {
            for(PS_IFS_Description__c psDesc : PSIFSDesc)
            {
                if(String.isNotBlank(psDesc.OA__c))
                {
                    quoteAttriVsDesc.put('OA',psDesc.OA__c);
                }
                if(String.isNotBlank(psDesc.OB__c))
                {
                    quoteAttriVsDesc.put('OB',psDesc.OB__c);
                }
                if(String.isNotBlank(psDesc.ORP__c))
                {
                    quoteAttriVsDesc.put('ORP',psDesc.ORP__c);
                }
                if(String.isNotBlank(psDesc.ORV__c))
                {
                    quoteAttriVsDesc.put('ORV',psDesc.ORV__c);
                }
                if(String.isNotBlank(psDesc.OW__c))
                {
                    quoteAttriVsDesc.put('OW',psDesc.OW__c);
                }
                
                if(String.isNotBlank(psDesc.CUSTOMS_STAT_NO__c))
                {
                    quoteAttriVsDesc.put('CUSTOMS_STAT_NO',psDesc.CUSTOMS_STAT_NO__c);
                }
                if(String.isNotBlank(psDesc.CHAR_TEMPLATE__c))
                {
                    quoteAttriVsDesc.put('CHAR_TEMPLATE',psDesc.CHAR_TEMPLATE__c);
                }
                if(String.isNotBlank(psDesc.INV_SERIAL_TRACKING__c))
                {
                    quoteAttriVsDesc.put('INV_SERIAL_TRACKING',psDesc.INV_SERIAL_TRACKING__c);
                }
                if(String.isNotBlank(psDesc.PLANNER__c))
                {
                    quoteAttriVsDesc.put('PLANNER',psDesc.PLANNER__c);
                }
                if(String.isNotBlank(psDesc.HSN_SAC_CODE__c))
                {
                    quoteAttriVsDesc.put('HSN_SAC_CODE',psDesc.HSN_SAC_CODE__c);
                }
            }
        }
        return quoteAttriVsDesc;
    }
    
    public Map<String, String> GetAttributeMapQuoteDescription()
    {
        Map<String, String> quoteAttriVsDesc = new Map<String, String>();
        
        if(mapPS_Attribute.size() > 0)
        {
            List<String> quoteKey = new List<String>((mapPS_Attribute).Keyset());
            quoteKey.sort();
            for(String mapKey: quoteKey)
            {
                //System.debug('*** mapKey = '+mapKey+', mapPS_Attribute = '+mapPS_Attribute.get(mapKey));
                if(mapKey.startsWithIgnoreCase('O') || mapKey.startsWithIgnoreCase('PC'))
                {
                    quoteAttriVsDesc.put(mapKey,mapPS_Attribute.get(mapKey));
                }
            }
        }
        return quoteAttriVsDesc;
    }
   
}