/**
* @File Name          : RDOutputUtilityXML.cls
* @Description        :
* @Author             : Nikhil Arpally
* @Group              :
* @Last Modified By   : Nikhil Arpally
* @Last Modified On   : 18/6/2020, 2:41:56 pm
* @Modification Log   :
* Ver       Date            Author                  Modification
* 1.0    13/5/2020   Nikhil Arpally     Initial Version
**/

public class RDOutputUtilityXML implements HandlerInterface {
    public RDOutputUtilityXML(Id recordID) {
        currentRD= (Rupture_Disc__c) wizardBaseDataProcessor.getObjectDataById(recordID).objResultList[0];
        // if(currentRD.Product__c!=null && currentRD.Size__c!=null && currentRD.Seat__c!=null)
        //     rtgRngWrap = new RDRatingRange(currentRD,currentRD.Product__c,SZC);
        ROBU=new RdOutputBaseUtility(currentRD.Id);
        mapRDXMLOutputs=getXMLOutputs();
        rdOutput=[Select Base_Lead_Time_GP__c,Base_Lead_Time_GCI__c,Base_Lead_Time_CDC__c,Base_Lead_Time_40__c,Adder_Lead_Time_GP__c,Adder_Lead_Time_GCI__c,Adder_Lead_Time_CDC__c,Adder_Lead_Time_40__c,Comp_Lead_Time_GP__c,Comp_Lead_Time_GCI__c,Comp_Lead_Time_CDC__c,Comp_Lead_Time_40__c,Total_Lead_Time_CDC__c,Total_Lead_Time_GP_ORD__c,Total_Lead_Time_GCI__c,Total_Lead_Time_40__c,OW__c,OW_Override__c,OA__c,OA_Override__c,OB__c,OB_Override__c,ORP__c,ORP_Override__c,ORV__c,ORV_Override__c,Total_Lead_Time_CDC_ORD__c,Total_Lead_Time_GCI_ORD__c,LABMAT__c,LABDSC__c,Total_Lead_Time_40_ORD__c FROM RD_Outputs__c WHERE RD_Outputs_Relation_Field__c=:currentRD.Id][0];
        mapRDOutPuts=ROBU.mapRDAttr;
        result res=ROBU.getLookupAttributes();
        // mapRDOutPuts.putAll(rtgRngWrap.mapRatingValues1);

    }
    public string SZC {
        get {
            if(!String.isBlank(currentRD.Size__c))
                return ConstantsUtil.getSizeDesc(currentRD.Size__c).SZC;
            else
                return '';
        }
        set {
            this.SZC=value;
        }
    }
    public RD_Outputs__c rdOutput {set;get;}
    public RDRatingRange rtgRngWrap {set; get;}
    public Map<string,string> getXMLOutputs() {
        List<RD_XML_Outputs__c> listXMLOpts = new List<RD_XML_Outputs__c>();
        Map<string, string> mapName = new Map<string, string>();
        try {
            string query='SELECT Id, MCD__c, SZC__c, Value__c, Output__c, PTC__c FROM RD_XML_Outputs__c';
            string dynamicWhereClause;
            dynamicWhereClause=' Where (PTC__c=\''+ROBU.PTC+'\' OR PTC__c=\'-\') ';
            dynamicWhereClause=dynamicWhereClause+' AND (STC__c=\''+currentRD.seat__c+'\' OR STC__c=\'-\') ';
            dynamicWhereClause=dynamicWhereClause+' AND (SZC__c=\''+SZC+'\' OR SZC__c=\'-\') ';
            dynamicWhereClause=dynamicWhereClause+' AND (MCD__c=\''+ROBU.MCD+'\' OR MCD__c=\'-\') ';
            dynamicWhereClause=dynamicWhereClause+' Order BY PTC__c,SZC__c,MCD__c DESC';
            listXMLOpts=Database.query(query+dynamicWhereClause);
            for(RD_XML_Outputs__c xmlOt:listXMLOpts) {
                if(!mapName.containsKey(xmlOt.Output__c))
                    mapName.put(xmlOt.Output__c,xmlOt.Value__c);
            }
        } catch (Exception e) {

        }
        return mapName;

    }
    public Map<String,String> mapNewAttributeNames{
        get {
            Map<String,String> newMap=new Map<String,String>();
            newMap.put('GASGRP','GASGROUP');
            newMap.put('ZONE','ATEXZONE');
            newMap.put('SURFINISH','SURFFINISH');

            return newMap;
        }
        set {
            this.mapNewAttributeNames=value;
        }
    }
    public RdOutputBaseUtility ROBU {set;get;}
    public Map<String,String> mapRDXMLOutputs;
    public Map<String,String> mapRDOutPuts {set;get;}
    public Rupture_Disc__c currentRD{get; set;}
    //
    public string LOTTRACKCODE {
        get {
            return mapRDXMLOutputs.get('LOTTRACKCODE')==null?'':mapRDXMLOutputs.get('LOTTRACKCODE');
        }
        set {
            this.LOTTRACKCODE = value;
        }
    }
    public string PROVIDE {
        get {
            return mapRDXMLOutputs.get('PROVIDE')==null?'':mapRDXMLOutputs.get('PROVIDE');
        }
        set {
            this.PROVIDE = value;
        }
    }
    public string SERIALTRACKCODE {
        get {
            return mapRDXMLOutputs.get('SERIALTRACKCODE')==null?'':mapRDXMLOutputs.get('SERIALTRACKCODE');
        }
        set {
            this.SERIALTRACKCODE = value;
        }
    }
    public string PARTCLASS {
        get {
            return mapRDXMLOutputs.get('PARTCLASS')==null?'':mapRDXMLOutputs.get('PARTCLASS');
        }
        set {
            this.PARTCLASS = value;
        }
    }
    public string RESPONSIBLE_ID {
        get {
            return mapRDXMLOutputs.get('RESPONSIBLE_ID')==null?'':mapRDXMLOutputs.get('RESPONSIBLE_ID');
        }
        set {
            this.RESPONSIBLE_ID = value;
        }
    }
    public string COMPDESCRIP {
        get {
            return mapRDXMLOutputs.get('COMPDESCRIPTION')==null?'':mapRDXMLOutputs.get('COMPDESCRIPTION');
        }
        set {
            this.COMPDESCRIP = value;
        }
    }
    public string PLANNER {
        get {
            return mapRDXMLOutputs.get('PLANNER')==null?'':mapRDXMLOutputs.get('PLANNER');
        }
        set {
            this.PLANNER = value;
        }
    }
    public string COMPLOTTRACK {
        get {
            return mapRDXMLOutputs.get('COMPLOTTRACK')==null?'':mapRDXMLOutputs.get('COMPLOTTRACK');
        }
        set {
            this.COMPLOTTRACK = value;
        }
    }public string COMPPROVIDE {
        get {
            return mapRDXMLOutputs.get('COMPPROVIDE')==null?'':mapRDXMLOutputs.get('COMPPROVIDE');
        }
        set {
            this.COMPPROVIDE = value;
        }
    }
    public string COMPRESPONID {
        get {
            return mapRDXMLOutputs.get('COMPRESPONID')==null?'':mapRDXMLOutputs.get('COMPRESPONID');
        }
        set {
            this.COMPRESPONID = value;
        }
    }
    public string COMPINVSERTRK {
        get {
            return mapRDXMLOutputs.get('COMPINVSERTRK')==null?'':mapRDXMLOutputs.get('COMPINVSERTRK');
        }
        set {
            this.COMPINVSERTRK = value;
        }
    }
    public string ATTRTEMPLATE {
        get {
            return mapRDXMLOutputs.get('ATTRTEMPLATE')==null?'':mapRDXMLOutputs.get('ATTRTEMPLATE');
        }
        set {
            this.ATTRTEMPLATE = value;
        }
    }
    public string PARTUOM {
        get {
            return mapRDXMLOutputs.get('PARTUOM')==null?'':mapRDXMLOutputs.get('PARTUOM');
        }
        set {
            this.PARTUOM = value;
        }
    }
    public string HSNSACCODE {
        get {
            return mapRDXMLOutputs.get('HSNSACCODE')==null?'':mapRDXMLOutputs.get('HSNSACCODE');
        }
        set {
            this.HSNSACCODE = value;
        }
    }
    public string ASSEMBLYWTUOM {
        get {
            return mapRDXMLOutputs.get('ASSEMBLYWTUOM')==null?'':mapRDXMLOutputs.get('ASSEMBLYWTUOM');
        }
        set {
            this.ASSEMBLYWTUOM = value;
        }
    }
    public string SALESGROUP {
        get {
            return mapRDXMLOutputs.get('SALESGROUP')==null?'':mapRDXMLOutputs.get('SALESGROUP');
        }
        set {
            this.SALESGROUP = value;
        }
    }
    public string SALESPRICEGROUP {
        get {
            return mapRDXMLOutputs.get('SALESPRICEGROUP')==null?'':mapRDXMLOutputs.get('SALESPRICEGROUP');
        }
        set {
            this.SALESPRICEGROUP = value;
        }
    }
    public string CUSTOMSTATNO {
        get {
            return mapRDXMLOutputs.get('CUSTOMSTATNO')==null?'':mapRDXMLOutputs.get('CUSTOMSTATNO');
        }
        set {
            this.CUSTOMSTATNO = value;
        }
    }
    public string ASSEMBLYWT {
        get {
            return mapRDXMLOutputs.get('ASSEMBLYWT')==null?'':mapRDXMLOutputs.get('ASSEMBLYWT');
        }
        set {
            this.ASSEMBLYWT = value;
        }
    }
    //
    public string PARTNUMBER {
        get {
            return currentRD.Part_Number__c;
        }
        set {
            this.PARTNUMBER=value;
        }
    }
    public string PARTREV {
        get {
            return currentRD.PARTREV__c==null?'1':currentRD.PARTREV__c;
        }
        set {
            this.PARTREV=value;
        }
    }
    public string ENGPARTREV {
        get {
            return currentRD.PARTREV__c==null?'1':currentRD.PARTREV__c;
        }
        set {
            this.ENGPARTREV=value;
        }
    }

    public string DESCRIPTION {
        get {
            return ROBU.PTC+ROBU.strSZC+ROBU.STC;
        }
        set {
            this.DESCRIPTION=value;
        }
    }
    public string NOTE {
        get {
            if(currentRD.Engineering_Notes__c != null)
                return currentRD.Engineering_Notes__c;
            else
                return '';
        }
        set {
            this.NOTE = value;
        }
    }
    public String PARTMANAGEDIN {
        get {
            if(currentRD.Quote_Descriptions_Override__c == false)
                return 'Salesforce';
            else
                return 'IFS';
        }
        set {
            this.PARTMANAGEDIN = value;
        }
    }
    //
    public list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPM()
    {
        Boolean isFlag = false;
        list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = new list<Global_Site_Part_Parameters_ISPM__c>();
        String SOQL = 'Select InventorySite__c,InventoryPartType__c,InventoryPartTemplate_ID__c,SalesSite__c,Sourcing_Option__c,PurchaseSite__c,PurchasePartTemplate_ID__c,MfgSite__c';
        SOQL += ' From Global_Site_Part_Parameters_ISPM__c ';
        if(rdOutput.Total_Lead_Time_GP_ORD__c != null)
        {
            isFlag = true;
            SOQL += ' where (Site__c= \'10\' and LeadTimeLL__c <='+rdOutput.Total_Lead_Time_GP_ORD__c+' and LeadTimeUL__c >='+rdOutput.Total_Lead_Time_GP_ORD__c+' and SERIALTRACKCODE__c =\''+SERIALTRACKCODE+'\')';
        }
        if(rdOutput.Total_Lead_Time_GCI_ORD__c != null)
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
            SOQL += ' (Site__c= \'20\' and LeadTimeLL__c <='+rdOutput.Total_Lead_Time_GCI_ORD__c+' and LeadTimeUL__c >='+rdOutput.Total_Lead_Time_GCI_ORD__c+' and SERIALTRACKCODE__c =\''+SERIALTRACKCODE+'\')';
        }
        if(rdOutput.Total_Lead_Time_CDC_ORD__c != null)
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
            SOQL += ' (Site__c = \'30\' and LeadTimeLL__c <='+rdOutput.Total_Lead_Time_CDC_ORD__c+' and LeadTimeUL__c >='+rdOutput.Total_Lead_Time_CDC_ORD__c+' and SERIALTRACKCODE__c =\''+SERIALTRACKCODE+'\')';
        }
        if(rdOutput.Total_Lead_Time_40_ORD__c != null)
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
            SOQL += ' (Site__c = \'40\' and LeadTimeLL__c <='+rdOutput.Total_Lead_Time_40_ORD__c+' and LeadTimeUL__c >='+rdOutput.Total_Lead_Time_40_ORD__c+' and SERIALTRACKCODE__c =\''+SERIALTRACKCODE+'\')';
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
        if(rdOutput.Total_Lead_Time_GP_ORD__c != null)
        {
            isFlag = true;
            SOQL += ' where (Site__c = \'10\' and LeadTimeLL__c <='+rdOutput.Total_Lead_Time_GP_ORD__c+' and LeadTimeUL__c >='+rdOutput.Total_Lead_Time_GP_ORD__c+' and SERIALTRACKCODE__c =\''+SERIALTRACKCODE+'\')';
        }
        if(rdOutput.Total_Lead_Time_GCI_ORD__c != null)
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
            SOQL += ' (Site__c = \'20\' and LeadTimeLL__c <='+rdOutput.Total_Lead_Time_GCI_ORD__c+' and LeadTimeUL__c >='+rdOutput.Total_Lead_Time_GCI_ORD__c+' and SERIALTRACKCODE__c =\''+SERIALTRACKCODE+'\')';
        }
        if(rdOutput.Total_Lead_Time_CDC_ORD__c != null)
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
            SOQL += ' (Site__c = \'30\' and LeadTimeLL__c <='+rdOutput.Total_Lead_Time_CDC_ORD__c+' and LeadTimeUL__c >='+rdOutput.Total_Lead_Time_CDC_ORD__c+' and SERIALTRACKCODE__c =\''+SERIALTRACKCODE+'\')';
        }
        if(rdOutput.Total_Lead_Time_40_ORD__c != null)
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
            SOQL += ' (Site__c = \'40\' and LeadTimeLL__c <='+rdOutput.Total_Lead_Time_40_ORD__c+' and LeadTimeUL__c >='+rdOutput.Total_Lead_Time_40_ORD__c+' and SERIALTRACKCODE__c =\''+SERIALTRACKCODE+'\')';
        }
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
            SYstem.debug('Inside1------');
            for(Global_Site_Part_Parameters_PPS__c ppsRecord: [SELECT Id,Name,Site__c,VendorSite__c,VendorLTLL__c,VendorLTUL__c,Primary_Vendor__c,PPS_VendoNo__c,PurchaseSite__c from Global_Site_Part_Parameters_PPS__c WHERE Site__c IN:purchasedInventorySites order by Site__c])
            {
                SYstem.debug('Inside2------');
                // 10 => 20 & 30
                if(ppsRecord.Site__c == '10')
                {
                    SYstem.debug('Inside3------');
                    System.debug('VendorSite__c-----20'+ppsRecord.VendorSite__c);
                    System.debug('VendorLTLL__c-----0'+ppsRecord.VendorLTLL__c);
                    System.debug('VendorLTUL__c-----5000'+ppsRecord.VendorLTUL__c);
                    System.debug('Total_Lead_Time_GCI_ORD__c-----null'+rdOutput.Total_Lead_Time_GCI_ORD__c);
                    System.debug('Total_Lead_Time_CDC_ORD__c-----null'+rdOutput.Total_Lead_Time_CDC_ORD__c);
                    System.debug('Total_Lead_Time_40_ORD__c-----null'+rdOutput.Total_Lead_Time_40_ORD__c);
                    if(ppsRecord.VendorSite__c == '20' &&
                       ppsRecord.VendorLTLL__c <= rdOutput.Total_Lead_Time_GCI_ORD__c &&
                       ppsRecord.VendorLTUL__c > rdOutput.Total_Lead_Time_GCI_ORD__c)
                    {
                        SYstem.debug('Inside4------');
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '30' &&
                            ppsRecord.VendorLTLL__c <= rdOutput.Total_Lead_Time_CDC_ORD__c &&
                            ppsRecord.VendorLTUL__c > rdOutput.Total_Lead_Time_CDC_ORD__c)
                    {
                        SYstem.debug('Inside5------');
                        globalSitePPSList.add(ppsRecord);
                    }
                }
                // 20 => 10 & 30
                if(ppsRecord.Site__c == '20')
                {
                    if(ppsRecord.VendorSite__c == '10' &&
                       ppsRecord.VendorLTLL__c <= rdOutput.Total_Lead_Time_GP_ORD__c &&
                       ppsRecord.VendorLTUL__c > rdOutput.Total_Lead_Time_GP_ORD__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '30' &&
                            ppsRecord.VendorLTLL__c <= rdOutput.Total_Lead_Time_CDC_ORD__c &&
                            ppsRecord.VendorLTUL__c > rdOutput.Total_Lead_Time_CDC_ORD__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                }
                // 30 => 10 & 20
                if(ppsRecord.Site__c == '30')
                {
                    if(ppsRecord.VendorSite__c == '10' &&
                       ppsRecord.VendorLTLL__c <= rdOutput.Total_Lead_Time_GP_ORD__c &&
                       ppsRecord.VendorLTUL__c > rdOutput.Total_Lead_Time_GP_ORD__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '20' &&
                            ppsRecord.VendorLTLL__c <= rdOutput.Total_Lead_Time_GCI_ORD__c &&
                            ppsRecord.VendorLTUL__c > rdOutput.Total_Lead_Time_GCI_ORD__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                }

                // 40 => 10, 20 & 30
                if(ppsRecord.Site__c == '40')
                {
                    if(ppsRecord.VendorSite__c == '10' &&
                       ppsRecord.VendorLTLL__c <= rdOutput.Total_Lead_Time_GP_ORD__c &&
                       ppsRecord.VendorLTUL__c > rdOutput.Total_Lead_Time_GP_ORD__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '20' &&
                            ppsRecord.VendorLTLL__c <= rdOutput.Total_Lead_Time_GCI_ORD__c &&
                            ppsRecord.VendorLTUL__c > rdOutput.Total_Lead_Time_GCI_ORD__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '30' &&
                            ppsRecord.VendorLTLL__c <= rdOutput.Total_Lead_Time_CDC_ORD__c &&
                            ppsRecord.VendorLTUL__c > rdOutput.Total_Lead_Time_CDC_ORD__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                }
            }
        }
        System.debug('***** globalSitePPSList = '+globalSitePPSList);
        return globalSitePPSList;
    }
    /**
* @description
* @author Nikhil Arpally | 13/5/2020
* @return result
**/
    public result getEngineeringParts() {
        result resEngParts=new result();
        result resEngPartRev=getENGPARTREV();
        String engPartREV;
        if (resEngPartRev.bResult) {
            engPartREV=resEngPartRev.strRetValue==null?PARTREV:resEngPartRev.strRetValue+PARTREV;
        } else {
            engPartREV=PARTREV;
        }
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'ENG_PART_REC', null);
        w.writeStartElement(null, 'ENG_PART', null);
        w.writeStartElement(null, 'ENG_PART_NO', null);
        w.writeCharacters(PARTNUMBER.toUpperCase());
        w.writeEndElement();
        w.writeStartElement(null, 'ENG_PART_REV', null);
        w.writeCharacters(engPartREV);
        w.writeEndElement();
        w.writeStartElement(null, 'DESCRIPTION', null);
        w.writeCharacters(DESCRIPTION);
        w.writeEndElement();
        w.writeStartElement(null, 'LOT_TRACKING_CODE', null);
        w.writeCharacters(LOTTRACKCODE);
        w.writeEndElement();
        w.writeStartElement(null, 'PROVIDE', null);
        w.writeCharacters(PROVIDE);
        w.writeEndElement();
        w.writeStartElement(null, 'INV_SERIAL_TRACKING', null);
        w.writeCharacters(SERIALTRACKCODE);
        w.writeEndElement();
        w.writeStartElement(null, 'PART_CLASS', null);
        w.writeCharacters(PARTCLASS);
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

        resEngParts.xmlStringResult=xmlOutput;
        return resEngParts;
    }
    public result getENGPARTREV() {
        result engPart=new result();
        result resDiaData=new result();
        map<string,string> mapDia=new map<string,string>();
        mapDia.put('PTC',currentRD.Product__c);
        mapDia.put('SZC',ConstantsUtil.getSizeDesc(currentRD.Size__c).SZC);
        mapDia.put('STC',currentRD.Seat__c);
        mapDia.put('HCLASS',currentRD.Pressure_Class__c);
        mapDia.put('HIC',currentRD.Inlet_Connection__c);
        mapDia.put('HOC',currentRD.Outlet_Connection__c);
        mapDia.put('DSCVAR',currentRD.DSCVAR__c);
        //mapDia.put('CUTR',currentRD.CU_TR__c?'Yes':'No');
        mapDia.put('CUTR',currentRD.CU_TR__c?'Y':'N');
        List <String> selectCols=new List <String>();
        selectCols.add('DWGNO__c');
        selectCols.add('DrawingID__c');
        selectCols.add('DimA__c');
        selectCols.add('DimB__c');
        selectCols.add('DimC__c');
        selectCols.add('DimD__c');
        selectCols.add('DimE__c');
        selectCols.add('DimF__c');
        selectCols.add('Revision__c');
        selectCols.add('Document_Type__c');
        mapDia.put('SizeValue',String.ValueOf(ConstantsUtil.getSizeDesc(currentRD.Size__c).SizeValue));
        resDiaData=wizardBaseDataProcessor.getDataFromTranslationObj('Document_Type__c','RD_Manufacturing_Document_Translation__c','RD_Manufacturing_Document_Detail__c',mapDia,selectCols);
        if(resDiaData.bResult) {
            for (sObject sObj: resDiaData.objResultList) {
                if ((string) sObj.get('Document_Type__c')=='AssyDwg') {
                    engPart.strRetValue =(string) sObj.get('Revision__c');
                    engPart.bResult=true;
                }
            }
        }
        return engPart;
    }
    /**
* @description
* @author Nikhil Arpally | 13/5/2020
* @return result
**/
    public result getEngPartStructureXML() {
        result resEngPartsStruct=new result();
        List<RdOutputBaseUtility.RDStructureWrapper> RDOBUStructWrapper=new List<RdOutputBaseUtility.RDStructureWrapper>();
        RDOBUStructWrapper=ROBU.getConsolidatedStructureDetails();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'ENG_PART_STRUCTURE_LIST', null);
        string xmlOutput1 = w.getXmlString();
        Result doc1=getProdDoc();
        string xmlOutput2=xmlOutput1+doc1.xmlStringResult;
        integer intSortCode=10;
        for (RdOutputBaseUtility.RDStructureWrapper str:RDOBUStructWrapper) {
            w.writeStartElement(null, 'ENG_PART_STRUCTURE', null);
            w.writeStartElement(null, 'PART_NO', null);
            w.writeCharacters(str.ComponentPart==null?'':str.ComponentPart);
            w.writeEndElement();
            w.writeStartElement(null, 'DESCRIPTION', null);
            w.writeCharacters(COMPDESCRIP);
            w.writeEndElement();
            w.writeStartElement(null, 'LOT_TRACKING_CODE', null);
            w.writeCharacters(COMPLOTTRACK);
            w.writeEndElement();
            w.writeStartElement(null, 'PROVIDE', null);
            w.writeCharacters(COMPPROVIDE);
            w.writeEndElement();
            w.writeStartElement(null, 'INV_SERIAL_TRACKING', null);
            w.writeCharacters(COMPINVSERTRK);
            w.writeEndElement();
            w.writeStartElement(null, 'RESPONSIBLE_ID', null);
            w.writeCharacters(COMPRESPONID);
            w.writeEndElement();
            w.writeStartElement(null, 'NOTE', null);
            //w.writeCharacters(NOTE);
            w.writeEndElement();
            w.writeStartElement(null, 'DRAW_POS_NO', null);
            w.writeCharacters(String.valueOf(intSortCode));
            w.writeEndElement();
            w.writeStartElement(null, 'QTY_PER_ASSEMBLY', null);
            w.writeCharacters(str.Qty==null?'':str.Qty);
            //w.writeCharacters(str.Qty);
            w.writeEndElement();
            w.writeStartElement(null, 'SORT_CODE', null);
            w.writeCharacters(String.valueOf(intSortCode));
            w.writeEndElement();
            w.writeEndElement();
            intSortCode+=10;
        }
        w.writeEndElement();
        w.writeEndDocument();
        string xmlOutput = w.getXmlString();
        //system.debug('XML is xmlOutput  '+xmlOutput );
        w.close();
        string xmldata = doc.toXmlString();
        resEngPartsStruct.xmlStringResult=xmlOutput;
        return resEngPartsStruct;
        //return resEngPartsStruct;
    }
    /**
* @description
* @author Nikhil Arpally | 13/5/2020
* @return result
**/
    public result getEngPartCharacterXML() {
        result resEngPartChar=new result();
        IFS_character_codes__c[] IFS_Attr=[select Element__c,Attribute_Code__c from IFS_character_codes__c where Interface_to_IFS_Attributes__c=true and Product__c='RD'];
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartElement(null, 'ENG_PART_CHAR_LIST', null);
        for(IFS_character_codes__c ifsAtt:IFS_Attr) {
            String strInfo=' ';
            String strVal=' ';
            String strCode;
            if (mapRDOutPuts.containsKey(ifsAtt.Attribute_Code__c))
            {
                if (ifsAtt.Element__c=='Info')
                {
                    strInfo=mapRDOutPuts.get(ifsAtt.Attribute_Code__c);
                }
                else
                {
                    strVal=mapRDOutPuts.get(ifsAtt.Attribute_Code__c);
                }
                strCode=ifsAtt.Attribute_Code__c;
                if(mapNewAttributeNames.containsKey(strCode)) {
                    strCode=mapNewAttributeNames.get(strCode);
                }
                w.writeStartElement(null, 'ENG_PART_CHAR', null);
                w.writeStartElement(null, 'CHAR_TEMPLATE', null);
                w.writeCharacters(ATTRTEMPLATE);
                w.writeEndElement();
                w.writeStartElement(null, 'CHARACTERISTIC_CODE', null);
                w.writeCharacters(strCode);
                system.debug('Char code is:'+strCode);
                w.writeEndElement();
                boolean bstrValInfo=false;
                if(string.isNotBlank(strVal)) {
                    if(strVal.length() > 20)
                        bstrValInfo=true;
                }
                if(bstrValInfo || (string.isNotBlank(strInfo))){
                    w.writeStartElement(null, 'VALUE', null);
                    w.writeCharacters('See Info');
                    w.writeEndElement();
                }else{
                    w.writeStartElement(null, 'VALUE', null);
                    if(String.isNotBlank(strVal))
                        w.writeCharacters(strVal);
                    w.writeEndElement();
                }
                system.debug('Value is:'+strVal);
                w.writeStartElement(null, 'INFO', null);
                if(bstrValInfo)
                {
                    //if(String.isNotBlank(strInfo))
                    w.writeCharacters(strVal);
                }
                else
                {
                    if(String.isNotBlank(strInfo))
                        w.writeCharacters(strInfo);
                }
                w.writeEndElement();
                w.writeEndElement();
            } else {
                w.writeStartElement(null, 'ENG_PART_CHAR', null);
                w.writeStartElement(null, 'CHAR_TEMPLATE', null);
                w.writeCharacters(ATTRTEMPLATE);
                w.writeEndElement();
                w.writeStartElement(null, 'CHARACTERISTIC_CODE', null);
                w.writeCharacters(ifsAtt.Attribute_Code__c);
                w.writeEndElement();
                w.writeStartElement(null, 'VALUE', null);
                w.writeEndElement();
                w.writeStartElement(null, 'INFO', null);
                w.writeEndElement();
                w.writeEndElement();
            }
        }
        w.writeEndElement();
        //w.writeEndDocument();
        string xmlOutput = w.getXmlString();
        system.debug('XML is xmlOutput  '+xmlOutput );
        w.close();
        string xmldata = doc.toXmlString();
        system.debug('XML is '+xmldata);
        resEngPartChar.xmlStringResult=xmlOutput;
        return resEngPartChar;
    }
    /**
* @description
* @author Nikhil Arpally | 13/5/2020
* @return result
**/
    public result getProdDoc() {
        result resProdDoc=new result();
        result resDiaData=new result();
        map<string,string> mapDia=new map<string,string>();
        mapDia.put('PTC',currentRD.Product__c);
        mapDia.put('SZC',ConstantsUtil.getSizeDesc(currentRD.Size__c).SZC);
        mapDia.put('STC',currentRD.Seat__c);
        mapDia.put('HCLASS',currentRD.Pressure_Class__c);
        mapDia.put('HIC',currentRD.Inlet_Connection__c);
        mapDia.put('HOC',currentRD.Outlet_Connection__c);
        mapDia.put('DSCVAR',currentRD.DSCVAR__c);
        //mapDia.put('CUTR',currentRD.CU_TR__c?'Yes':'No');
        mapDia.put('CUTR',currentRD.CU_TR__c?'Y':'N');
        List <String> selectCols=new List <String>();
        selectCols.add('DWGNO__c');
        selectCols.add('DrawingID__c');
        selectCols.add('DimA__c');
        selectCols.add('DimB__c');
        selectCols.add('DimC__c');
        selectCols.add('DimD__c');
        selectCols.add('DimE__c');
        selectCols.add('DimF__c');
        selectCols.add('Document_Type__c');
        mapDia.put('SizeValue',String.ValueOf(ConstantsUtil.getSizeDesc(currentRD.Size__c).SizeValue));
        resDiaData=wizardBaseDataProcessor.getDataFromTranslationObj('Document_Type__c','RD_Manufacturing_Document_Translation__c','RD_Manufacturing_Document_Detail__c',mapDia,selectCols);
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        // w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'DOCUMENT_LIST', null);

        if(resDiaData.bResult)
        {
            for(sObject sobj:resDiaData.objResultList) {
              //  if((string) sObj.get('Document_Type__c')=='IINO') {
                //Added below if condition for the redmine 34657
                if(sobj.get('DWGNO__c') != null && ((STRING) sobj.get('DWGNO__c')) !=''){
                    w.writeStartElement(null, 'DOCUMENT', null);
                    w.writeStartElement(null, 'DOC_NO', null);
                    //Document_ID__c
                    w.writeCharacters((STRING) sobj.get('DWGNO__c'));
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
                    // w.writeCharacters((STRING) sobj.get('Document_ID__c'));
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
                //}

            }
        }
        w.writeEndElement();
        // w.writeEndDocument();
        string xmlOutput = w.getXmlString();
        //system.debug('XML is xmlOutput  '+xmlOutput );
        w.close();
        string xmldata = doc.toXmlString();
        //system.debug('XML is '+xmldata);
        resProdDoc.xmlStringResult=xmlOutput;
        return resProdDoc;
        //return resProdDoc;
    }
    /**
* @description
* @author Nikhil Arpally | 13/5/2020
* @return result
**/
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
    /**
* @description
* @author Nikhil Arpally | 13/5/2020
* @return result
**/
    public result getStructureXML() {
        result resStruXML=new result();
        List<RdOutputBaseUtility.RDStructureWrapper> RDOBUStructWrapper=new List<RdOutputBaseUtility.RDStructureWrapper>();
        RDOBUStructWrapper=ROBU.getConsolidatedStructureDetails();
        List<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = GlobalSiteParametersISPM();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'PRODUCT_STRUCTURE_LIST', null);
        if(RDOBUStructWrapper.size()>0 && GlobalSiteParametersISPMList.size() > 0)
        {
            for(Global_Site_Part_Parameters_ISPM__c rLead : GlobalSiteParametersISPMList)
            {
                if(rLead.MfgSite__c != '{null}')
                {
                    w.writeStartElement(null, 'PRODUCT_STRUCTURE_HEAD', null);
                    w.writeStartElement(null, 'CONTRACT', null);
                    w.writeCharacters(rLead.MfgSite__c);
                    w.writeEndElement();
                    w.writeStartElement(null, 'PART_NO', null);
                    w.writeCharacters(PARTNUMBER.toUpperCase());
                    w.writeEndElement();
                    w.writeStartElement(null, 'PROD_STRUCTURE_LIST', null);
                    integer intSortCode=10;
                    for (RdOutputBaseUtility.RDStructureWrapper sobj:RDOBUStructWrapper)
                    {
                        w.writeStartElement(null, 'PRODUCT_STRUCTURE', null);
                        w.writeStartElement(null, 'LINE_ITEM_NO', null);
                        w.writeCharacters(string.valueOf(intSortCode));
                        w.writeEndElement();
                        w.writeStartElement(null, 'COMPONENT_PART', null);
                        w.writeCharacters(sobj.ComponentPart==null?'':sobj.ComponentPart);
                        w.writeEndElement();
                        w.writeStartElement(null, 'QTY_PER_ASSEMBLY', null);
                        w.writeCharacters(sobj.Qty==null?'':sobj.Qty);
                        w.writeEndElement();
                        w.writeStartElement(null, 'COMPONENT_SCRAP', null);
                        w.writeCharacters(sobj.ComponentScrap==null?'':sobj.ComponentScrap);
                        w.writeEndElement();
                        w.writeStartElement(null, 'SHRINKAGE_FACTOR', null);
                        w.writeCharacters(sobj.ScrapFactor==null?'':sobj.ScrapFactor);
                        w.writeEndElement();
                        w.writeEndElement();
                        //w.writeEndElement();
                        // w.writeEndElement();
                        intSortCode+=10;
                    }
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
        resStruXML.xmlStringResult=xmlOutput;
        return resStruXML;
        //return resStruXML;
    }
    /**
* @description
* @author Nikhil Arpally | 13/5/2020
* @return result
**/
    public result getInventoryPartDetails() {
        result resInv=new result();
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
            for(Global_Site_Part_Parameters_ISPM__c rdLead : GlobalSiteParametersISPMList){

                w.writeStartElement(null, 'INVENTORY_PART', null);
                w.writeStartElement(null, 'CONTRACT', null);
                w.writeCharacters(rdLead.InventorySite__c);
                w.writeEndElement();
                w.writeStartElement(null, 'PART_NO', null);
                w.writeCharacters(PARTNUMBER.toUpperCase());
                w.writeEndElement();
                w.writeStartElement(null, 'TEMPLATE_ID', null);
                w.writeCharacters(rdLead.InventoryPartTemplate_ID__c);
                w.writeEndElement();
                w.writeStartElement(null, 'PART_TYPE', null);
                w.writeCharacters(rdLead.InventoryPartType__c);
                w.writeEndElement();
                w.writeStartElement(null, 'PLANNER', null);
                w.writeCharacters(PLANNER);
                w.writeEndElement();
                w.writeStartElement(null, 'CUSTOMS_STAT_NO', null);
                w.writeCharacters(CUSTOMSTATNO);
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
        resInv.xmlStringResult=xmlOutput;
        return resInv;
    }
    /**
* @description
* @author Nikhil Arpally | 13/5/2020
* @return result
**/
    public result getPurchasePartSuppliers() {
        result resPurchase=new result();
        list<Global_Site_Part_Parameters_PPS__c> GlobalSiteParametersPPSList = getGlobalSitePPS();
        Dom.Document doc = new Dom.Document();
        //string PARTNUMBER1=getPartNum();
        XmlStreamWriter w = new XmlStreamWriter();
        decimal disPrice=currentRD.Discountable_Price__c==null?0:currentRD.Discountable_Price__c;
        decimal nonDisPrice=currentRD.Non_Discountable_Price__c==null?0:currentRD.Non_Discountable_Price__c;
        decimal total=disPrice+nonDisPrice;
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
                w.writeCharacters(PARTUOM);
                w.writeEndElement();
                w.writeStartElement(null, 'PRIMARY_VENDOR_DB', null);
                w.writeCharacters(globalSitePPS.Primary_Vendor__c != null ? globalSitePPS.Primary_Vendor__c : '');
                w.writeEndElement();
                w.writeStartElement(null, 'HSN_SAC_CODE', null);
                if(globalSitePPS.PurchaseSite__c=='30')
                   w.writeCharacters(HSNSACCODE);
                else
                    w.writeCharacters('');
                w.writeEndElement();
                //w.writeEndElement();
                w.writeStartElement(null, 'LIST_PRICE', null);
                //System.debug('*** currentWGB = '+currentWGB.List_Price_Each__c);
                w.writeCharacters(total != null ? total+'' : '');
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
        resPurchase.xmlStringResult=xmlOutput;
        return resPurchase;
    }
    /**
* @description
* @author Nikhil Arpally | 13/5/2020
* @return result
**/
    public result getSalesParts() {
        result resSalesPart=new result();
        list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = GlobalSiteParametersISPM();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'SALES_PART_LIST', null);
        if(GlobalSiteParametersISPMList.size() > 0)
        {
            for(Global_Site_Part_Parameters_ISPM__c rLead : GlobalSiteParametersISPMList){
                w.writeStartElement(null, 'SALES_PART', null);
                w.writeStartElement(null, 'CONTRACT', null);
                w.writeCharacters(rLead.SalesSite__c);
                w.writeEndElement();
                w.writeStartElement(null, 'CATALOG_NO', null);
                w.writeCharacters(PARTNUMBER.toUpperCase());
                w.writeEndElement();
                w.writeStartElement(null, 'CATALOG_GROUP', null);
                w.writeCharacters(SALESGROUP);
                w.writeEndElement();
                w.writeStartElement(null, 'SALES_PRICE_GROUP', null);
                w.writeCharacters(SALESPRICEGROUP);
                w.writeEndElement();
                w.writeStartElement(null, 'SOURCING_OPTION', null);
                w.writeCharacters(rLead.Sourcing_Option__c);
                w.writeEndElement();
                w.writeStartElement(null, 'HSN_SAC_CODE', null);
                if(rLead.SalesSite__c=='30')
                   w.writeCharacters(HSNSACCODE);
                else
                    w.writeCharacters('');
                w.writeEndElement();
                //w.writeEndElement();
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
        resSalesPart.xmlStringResult=xmlOutput;
        return resSalesPart;
    }
    /**
* @description
* @author Nikhil Arpally | 13/5/2020
* @return result
**/
    public result GetRoutingDetails() {
        result resRouting=new result();
        Dom.Document doc = new Dom.Document();
        result routingStep = ROBU.getRouting();
        List<RD_RoutingDetail__c > lstRDR = new List<RD_RoutingDetail__c >();
        //Result bgrGuideLineResult2 = getRouting();
        //system.debug('Routing Test'+)
        if(routingStep.bResult && routingStep.objResultList.size() > 0)
        {
            System.debug('Inside5----------');
            for(sObject objResult: routingStep.objResultList)
            {
                System.debug('Inside3----------');
                lstRDR.add((RD_RoutingDetail__c ) objResult);
            }
        }
        List<RD_WorkGuidelinesDetail__c> lstGL = new List<RD_WorkGuidelinesDetail__c>();
        Result rdGuideLineResult = ROBU.getWorkGuideLines();
        if(rdGuideLineResult.bResult && rdGuideLineResult.objResultList.size() > 0)
        {
            System.debug('Inside5----------');
            for(sObject objResult: rdGuideLineResult.objResultList)
            {
                RD_WorkGuidelinesDetail__c bgrGuideLine = (RD_WorkGuidelinesDetail__c)objResult;
                lstGL.add(bgrGuideLine);

            }
        }
        if(lstRDR.size()>0)
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
                        for(RD_RoutingDetail__c brRec: lstRDR)
                        {
                            //BGR_Routing__c brRec = (BGR_Routing__c)sRec;
                            xmlW.writeStartElement(null,'ROUTING_OPERATION',null);
                            xmlW.writeStartElement(null,'OPERATION_NO',null);
                            xmlW.writeCharacters(brRec.Operation_No__c);
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
                            //if(brRec.Operation_No__c == '0070' || brRec.Operation_No__c == '70')
                            //{
                                if(lstGL.size()>0)
                                {
                                    System.debug('Inside1----------');
                                    xmlW.writeStartElement(null,'ROUTING_OPER_WORK_GUIDE_LIST',null);
                                    for(RD_WorkGuidelinesDetail__c bgRec: lstGL)
                                    {
                                        System.debug('Inside2----------');
                                        if(brRec.Operation_No__c==bgRec.Operation__c) {
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
                                    }
                                    xmlW.writeEndElement(); //ROUTING_OPER_WORK_GUIDE_LIST end
                                }
                            //}
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
            resRouting.xmlStringResult=xmlStringxmlRes;
        }
        return resRouting;
    }
    /**
* @description
* @author Nikhil Arpally | 13/5/2020
* @return result
**/
    public result GetControlPlanDetails() {
        result resCntrl=new result();
        Dom.Document doc = new Dom.Document();
        string OuterMinValue = '';
        string InnerMinValue = '';
        string NominalValue = '';
        string InnerMaxValue = '';
        string OuterMaxValue = '';
        result rdCntlPln =getControlPlan();
        Xmlstreamwriter xmlW = new Xmlstreamwriter();
        xmlW.writeStartDocument('utf-8','1.0');
        xmlW.writeStartElement(null,'CONTROL_PLAN_MANUF_LIST', null);
        if(rdCntlPln.bResult)
        {
            list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = GlobalSiteParametersISPM();
            Set<String> toolIdSet = new Set<String>();
            Set<String> dataPointSet = new Set<String>();
            List<RD_ControlPlanDetail__c> connectionList = new List<RD_ControlPlanDetail__c>();
            for(sObject sRec: rdCntlPln.objResultList)
            {
                RD_ControlPlanDetail__c brRec = (RD_ControlPlanDetail__c)sRec;
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
                        for(sObject sRec: rdCntlPln.objResultList)
                        {
                            RD_ControlPlanDetail__c brRec = (RD_ControlPlanDetail__c)sRec;
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
                            OuterMinValue = String.valueOf(brRec.OUTER_MIN__c);
                            System.debug('AAAAAa-----'+OuterMinValue);
                            if(OuterMinValue!=null)
                                OuterMinValue = OuterMinValue.substringBetween('[',']');
                            if(string.isBlank(OuterMinValue))
                            {
                                if(brRec.Outer_Min__c != null)
                                    xmlW.writeCharacters(String.valueOf(brRec.Outer_Min__c));
                                else
                                    xmlW.writeCharacters('');
                            }
                            else
                            {
                                if(brRec.Outer_Min__c != null)
                                {
                                   xmlW.writeCharacters(mapRDOutPuts.get(OuterMinValue));
                                }
                                else
                                    xmlW.writeCharacters('');
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
                                else
                                    xmlW.writeCharacters('');
                            }
                            else
                            {
                                xmlW.writeCharacters(mapRDOutPuts.get(InnerMinValue));
                            }
                            xmlW.writeEndElement();
                            xmlW.writeStartElement(null,'NOMINAL_VALUE',null);
                            NominalValue = String.valueOf(brRec.Nominal_Value__c);
                            if(string.isNotBlank(NominalValue))
                                NominalValue = NominalValue.substringBetween('[',']');
                            if(string.isBlank(NominalValue))
                            {
                                if(brRec.Nominal_Value__c != null)
                                    xmlW.writeCharacters(String.valueOf(brRec.Nominal_Value__c));
                                else
                                    xmlW.writeCharacters('');
                            }
                            else
                            {
                                if(NominalValue != null)
                                {
                                    system.debug('NOMINAL VALUE'+NominalValue);
                                    if(mapRDOutPuts.containsKey(NominalValue))
                                        xmlW.writeCharacters(mapRDOutPuts.get(NominalValue));
                                    else
                                        xmlW.writeCharacters('');
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
                            if(brRec.Special_Characteristic_Classification__c  != null)
                            {
                                xmlW.writeCharacters(brRec.Special_Characteristic_Classification__c );
                            }
                            xmlW.writeEndElement();

                            xmlW.writeStartElement(null,'OUTER_MAX',null);
                            OuterMaxValue = String.valueOf(brRec.Outer_Max__c);
                            if(string.isNotBlank(OuterMaxValue))
                                OuterMaxValue = OuterMaxValue.substringBetween('[',']');

                            if(string.isBlank(OuterMaxValue))
                            {
                                if(brRec.Outer_Max__c != null)
                                    xmlW.writeCharacters(String.valueOf(brRec.Outer_Max__c));
                                else
                                    xmlW.writeCharacters('');
                            }
                            else
                            {
                                if(brRec.Outer_Max__c != null && mapRDOutPuts.get(OuterMaxValue) != null)
                                    xmlW.writeCharacters(mapRDOutPuts.get(OuterMaxValue));
                                else
                                    xmlW.writeCharacters('');
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
                                else
                                    xmlW.writeCharacters('');
                            }
                            else
                            {
                                if(brRec.Inner_Max__c != null)
                                {
                                    xmlW.writeCharacters(mapRDOutPuts.get(InnerMaxValue));
                                }
                                else
                                    xmlW.writeCharacters('');
                            }
                            xmlW.writeEndElement();
                            xmlW.writeStartElement(null,'INSPECTION_CODE',null);
                            if(brRec.Inspection_Code__c != null)
                                xmlW.writeCharacters(brRec.Inspection_Code__c);
                            else
                                xmlW.writeCharacters('');
                           // xmlW.writeCharacters(brRec.Inspection_Code__c);
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
                            for(RD_ControlPlanDetail__c brRec : connectionList)
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
                        xmlW.writeEndElement();
                    }
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
        resCntrl.xmlStringResult=xmlStringxmlRes;
        return resCntrl;
    }
    /**
* @description
* @author Nikhil Arpally | 13/5/2020
* @return result
**/
    public result getPartNumber(){
        result resPartNo=new result();
        return resPartNo;
    }
    Public Result getControlPlan()
    {
        result RDControlPlan = new Result();
        result res=new result();
        Map<String,String> dupMap=ROBU.mapRDAttr;
        List<String> selectCols = new List<String> {'Output__c','Attribute__c'};
            res=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','RD_EvaluationTranslation__c','RD_EvaluationDetail__c',dupMap,selectCols);
        if(res.bResult)
        {
            for (sObject sobj:res.objResultList)
            {
                dupMap.put((string) sobj.get('Attribute__c'),(string) sobj.get('Output__c'));
            }
            system.debug('RDEvaluation Result' +dupMap);

        }
        List<String> selectCol1s = new List<String> {'TEST_OPERATION_DESC__c','NORM_TYPE__c','Operation_Number__c','DATA_TYPE__c','CATEGORY_ID__c','INSPECTION_CODE__c','SAMPLE_PERCENT__c','Process_Characteristic__c','Special_Characteristic_Classification__c','OUTER_MIN__c','INNER_MIN__c','NOMINAL_VALUE__c','INNER_MAX__c','OUTER_MAX__c','Tool_ID__c','Data_Point__c','Test_OPNO__c'};
            RDControlPlan=wizardBaseDataProcessor.getDataFromTranslationObj('Test_OPNO__c','RD_ControlPlanTranslation__c','RD_ControlPlanDetail__c',dupMap,selectCol1s);
        if(RDControlPlan.bResult)
        {
            system.debug('ControlPlan Result' +RDControlPlan.objResultList);

        }
        return RDControlPlan;
    }
    /**
* @description
* @author Nikhil Arpally | 13/5/2020
* @return result
**/
    public result getPurchasePart() {
        result resPurchase=new result();
        list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = GlobalSiteParametersISPM();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        //string PARTNUMBER1=getPartNum();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'PURCHASE_PART_LIST', null);
        if(GlobalSiteParametersISPMList.size() > 0)
        {
            for(Global_Site_Part_Parameters_ISPM__c bgrLead : GlobalSiteParametersISPMList) {
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
                    w.writeCharacters(DESCRIPTION);
                    w.writeEndElement();
                    w.writeStartElement(null, 'TEMPLATE_ID', null);
                    w.writeCharacters(bgrLead.PurchasePartTemplate_ID__c);
                    w.writeEndElement();
                    w.writeStartElement(null, 'UOM', null);
                    w.writeCharacters(PARTUOM);
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
        resPurchase.xmlStringResult=xmlOutput;
        return resPurchase;
    }
}