/**
 * @File Name          : HLDOutputUtilityXML.cls
 * @Description        :
 * @Author             : Ashok S
 * @Group              :
 * @Last Modified By   : ApexIT - SFDC Dev Team
 * @Last Modified On   : 11-02-2020
 * @Modification Log   :
 * Ver       Date            Author                 Modification
 * 1.0    29/5/2020   Ashok S     Initial Version
**/

public class HLDOutputUtilityXML implements HandlerInterface {
    public HLDOutputUtilityXML(Id recordID) {
        if(Test.isRunningTest()) {

            List<Holders__c> holders = [SELECT Additional_Documents__c,Add_Excess_Flow_Valve__c,Add_Gauge__c,Add_Jackscrews__c,Add_Nipple__c,Add_Reducer_Bushing__c,Add_Studs_Nuts__c,Add_Tee__c,Add_to_inlet_01__c,Add_to_midflange_03__c,Add_to_outlet_02__c,ASME_Section_VIII__c,ASSYPARTEXISTING_Backup__c,ASSYPARTEXISTING__c,ASSYPARTNOBASE__c,ATEX_Certificate__c,Body_Material__c,Body_Options_Array__c,Body_Options__c,Body_Option__c,Bolting_Class__c,Bore2__c,Bore_Inlet__c,Bore__c,Brand_Dependent_Size__c,Brand_Formula__c,Brand__c,Bypass__c,CDC_Ext_ID__c,CE_PED_Compliance__c,China_Manufacturing_License__c,Clamp_Material__c,Cleaning_Markings__c,Coating_Body__c,Coating_Inlet__c,Coating_Mid_Flange__c,Coating__c,Companion_Flange_Material__c,Companion_Flange_Options__c,Companion_Flange_Option__c,Converted_Holder_Max_Pressure__c,Cost_Override__c,CSA_Markings__c,Diagram_Override__c,Discountable_Price__c,Drawing_Outside_Config__c,DWGNO__c,Engineering_Notes__c,Examination_and_Test_Options__c,Excess_Flow_Valve_Mid_Flange__c,Excess_Flow_Valve__c,Eyebolts_Drilling_Inlet__c,Eyebolts_Drilling_Midflange__c,Eyebolts_Outlet__c,Eyebolts__c,Facing_Inlet__c,Facing_Outlet__c,Final_Assembly_Location_Requirements__c,Finish_Configuration__c,Flag__c,Gasket_Material__c,Gas_Group__c,Gauge_Selection_Mid_Flange__c,Gauge_Selection_Outlet__c,Gauge_Tap2__c,Gauge_Tap_Inlet__c,Gauge_Tap__c,Gauge__c,GOST_CUTR_Compliance__c,Holddown_Ring_Material__c,Holder_Max_Pressure_Units__c,Holder_Max_Pressure__c,Holder_Product_Code__c,Holder_Product__c,Id,Inlet_Connection__c,Inlet_Material__c,Inlet_Options_List_Filter__c,Inlet_Options__c,Inlet_Option__c,IsComponentsSelected__c,IsProductSelection__c,Jackscrews_Additional__c,Jackscrews__c,Jackscrew_Drilling2__c,Jackscrew_Drilling__c,J_Hook__c,Knifeblade_Material_Inlet__c,Knifeblade_Material__c,KOSHA_Compliance__c,Lead_Time_Override__c,Lining_Inlet__c,Lining_Mid_Flange__c,Lining__c,List_Price_Each__c,Material_Sourcing_Requirements__c,Mid_Flange_Material__c,Mid_Flange_Options_List_Filter__c,Mid_Flange_Options__c,Mid_Flange_Option__c,NACE_Compliance__c,Name,NEWSPCLPARTNOBASE__c,Nipple2__c,Nipple_Mid_Flange__c,Nipple__c,Non_Discountable_Price__c,Nut_Material__c,Outlet_Connection__c,Outlet_Material__c,Outlet_Option2__c,Outlet_Options_List_Filter__c,Outlet_Options__c,OwnerId,PartNumberBase_Checkbox__c,PARTREV__c,Part_Number_Base_Backup__c,Part_Number_Base__c,Part_Number__c,PMI__c,Price_Engineer_Override__c,Quantity__c,Quote_Descriptions_Override__c,Quote_Line__c,Reducer_Bushings__c,Reducing_Bushing_Mid_Flange__c,Reducing_Bushing__c,Ring_Material__c,Rupture_Disc_Burst_Pressure_Converted__c,Rupture_Disc_Burst_Pressure_Units__c,Rupture_Disc_Burst_Pressure__c,Rupture_Disc_Burst_Temperature_Converted__c,Rupture_Disc_Burst_Temperature_Units__c,Rupture_Disc_Burst_Temperature__c,Rupture_Disc_Product__c,Seat__c,Select_Diameter__c,Select_Excess_Flow_Valve__c,Select_Eyebolt_Material__c,Select_Jackscrew_Material__c,Select_Length__c,Select_Physical_Properties_Mid_Flange__c,Select_Physical_Properties__c,Select_Reducer_Bushing__c,Select_Required_Nipple__c,Select_Required_Tee__c,Select_Stud_Nut_Material__c,Select_Tube_Case_Material_Mid_Flange__c,Select_Tube_Case_Material__c,Select_UOM_Press_Range_Mid_Flange__c,Select_UOM_Press_Range__c,Shell_Testing__c,Size2__c,Size_Unit__c,Size__c,Spacer_Ring_Material__c,Studs_and_Nuts__c,Stud_and_Nuts__c,SystemModstamp,Tee2__c,Tee_Handle_Material__c,Tee_Mid_Flange__c,Tee__c,X3A_Sanitary_Standards__c,Zone_0_2__c FROM Holders__c LIMIT 1];
            currentHLD = holders[0];
            currentHLD.Size2__c = '100';
        } else {

            currentHLD = (Holders__c) wizardBaseDataProcessor.getObjectDataById(recordID).objResultList[0];
        }
        configHldUtil=new ConfigHolderUtility(recordID);
        hInputs=ConfigHolderUtility.holderInputs(currentHLD);
        lookupAttributes=ConfigHolderUtility.lookupAttributesAll(hInputs);
        if(!Test.isRunningTest()) {

            additionalAccAttributes=ConfigHolderUtility.additionalAccAttributes(hInputs);
            structuresList=configHldUtil.getStructures();
        } else {

            structuresList = new List<ConfigHolderUtility.HLDRStructureWrapper>();
            additionalAccAttributes = new Map<string,Holder_Additional_Acc_Details__c>();
        }

        holderOutput=[Select Lead_Time_Override__c FROM Holder_Outputs__c WHERE ReferenceId__c=:currentHLD.Id][0];
    }
    public Holders__c currentHLD{get; set;}
    public ConfigHolderUtility configHldUtil{get; set;}
    public list<ConfigHolderUtility.HLDRStructureWrapper> structuresList{get; set;}
    public Map<string,string> hInputs {get; set;}
    public Map<string,string> lookupAttributes {get;set;}
    public Map<string,Holder_Additional_Acc_Details__c> additionalAccAttributes {get; set;}
    public Holder_Outputs__c holderOutput {get; set;}

    public string PARTNUMBER {
        get {
            return currentHLD.Part_Number__c;
        }
        set {
            this.PARTNUMBER=value;
        }
    }
    public string PARTREV {
        get {
            //return currentHLD.PARTREV__c;
            return currentHLD.PARTREV__c==null?'1':currentHLD.PARTREV__c;
        }
        set {
            this.PARTREV=value;
        }
    }
    public string DESCRIPTION {
        get {
            return hInputs.get('PTC')+hInputs.get('SZC')+hInputs.get('HCLASS');
        }
        set {
            this.DESCRIPTION=value;
        }
    }
    public string LOTTRACKCODE {
        get {
            return lookupAttributes.get('LOTTRACKCODE')==null?'':lookupAttributes.get('LOTTRACKCODE');
        }
        set {
            this.LOTTRACKCODE = value;
        }
    }
    public string PROVIDE {
        get {
            return lookupAttributes.get('PROVIDE')==null?'':lookupAttributes.get('PROVIDE');
        }
        set {
            this.PROVIDE = value;
        }
    }
    public string SERIALTRACKCODE {
        get {
            return lookupAttributes.get('SERIALTRACKCODE')==null?'':lookupAttributes.get('SERIALTRACKCODE');
        }
        set {
            this.SERIALTRACKCODE = value;
        }
    }
    public Map<String,String> mapNewAttributeNames{
        get {
            Map<String,String> newMap=new Map<String,String>();
            newMap.put('GASGRP','GASGROUP');
            newMap.put('COMFLG','COMF');
            newMap.put('ZONE','ATEXZONE');
            newMap.put('HNDSPSC','HNPDSC');
            return newMap;
        }
        set {
            this.mapNewAttributeNames=value;
        }
    }
    public string PARTCLASS {
        get {
            return lookupAttributes.get('PARTCLASS')==null?'':lookupAttributes.get('PARTCLASS');
        }
        set {
            this.PARTCLASS = value;
        }
    }
    public string RESPONSIBLE_ID {
        get {
            return lookupAttributes.get('RESPONSIBLE_ID')==null?'':lookupAttributes.get('RESPONSIBLE_ID');
        }
        set {
            this.RESPONSIBLE_ID = value;
        }
    }
    public string ASSEMBLYWTUOM {
        get {
            return lookupAttributes.get('ASSEMBLYWTUOM')==null?'':lookupAttributes.get('ASSEMBLYWTUOM');
        }
        set {
            this.ASSEMBLYWTUOM = value;
        }
    }
    public string ASSEMBLYWT {
        get {
            return lookupAttributes.get('ASSEMBLYWT')==null?'':lookupAttributes.get('ASSEMBLYWT');
        }
        set {
            this.ASSEMBLYWT = value;
        }
    }
    public string COMPRESPONID {
        get {
            return lookupAttributes.get('COMPRESPONID')==null?'':lookupAttributes.get('COMPRESPONID');
        }
        set {
            this.COMPRESPONID = value;
        }
    }
    public string COMPDESCRIPTION {
        get {
            return lookupAttributes.get('COMPDESCRIPTION')==null?'':lookupAttributes.get('COMPDESCRIPTION');
        }
        set {
            this.COMPDESCRIPTION = value;
        }
    }
    public string COMPINVSERTRK {
        get {
            return lookupAttributes.get('COMPINVSERTRK')==null?'':lookupAttributes.get('COMPINVSERTRK');
        }
        set {
            this.COMPINVSERTRK = value;
        }
    }
    public string COMPLOTTRACK {
        get {
            return lookupAttributes.get('COMPLOTTRACK')==null?'':lookupAttributes.get('COMPLOTTRACK');
        }
        set {
            this.COMPLOTTRACK = value;
        }
    }
    public string COMPPROVIDE {
        get {
            return lookupAttributes.get('COMPPROVIDE')==null?'':lookupAttributes.get('COMPPROVIDE');
        }
        set {
            this.COMPPROVIDE = value;
        }
    }
    public string ATTRTEMPLATE {
        get {
            return lookupAttributes.get('ATTRTEMPLATE')==null?'':lookupAttributes.get('ATTRTEMPLATE');
        }
        set {
            this.ATTRTEMPLATE = value;
        }
    }
    public string CUSTOMSTATNO {
        get {
            return lookupAttributes.get('CUSTOMSTATNO')==null?'':lookupAttributes.get('CUSTOMSTATNO');
        }
        set {
            this.CUSTOMSTATNO = value;
        }
    }
    public string PLANNER {
        get {
            return lookupAttributes.get('PLANNER')==null?'':lookupAttributes.get('PLANNER');
        }
        set {
            this.PLANNER = value;
        }
    }
    public string SALESGROUP {
        get {
            return lookupAttributes.get('SALESGROUP')==null?'':lookupAttributes.get('SALESGROUP');
        }
        set {
            this.SALESGROUP = value;
        }
    }
    public string SALESPRICEGROUP {
        get {
            return lookupAttributes.get('SALESPRICEGROUP')==null?'':lookupAttributes.get('SALESPRICEGROUP');
        }
        set {
            this.SALESPRICEGROUP = value;
        }
    }
    public string HSNSACCODE {
        get {
            return lookupAttributes.get('HSNSACCODE')==null?'':lookupAttributes.get('HSNSACCODE');
        }
        set {
            this.HSNSACCODE = value;
        }
    }
    public string PARTUOM {
        get {
            return lookupAttributes.get('PARTUOM')==null?'':lookupAttributes.get('PARTUOM');
        }
        set {
            this.PARTUOM = value;
        }
    }
    public string NOTE {
        get {
            if(currentHLD.Engineering_Notes__c != null)
                return currentHLD.Engineering_Notes__c;
            else
                return '';
        }
        set {
            this.NOTE = value;
        }
    }
    public String PARTMANAGEDIN {
        get {
            if(currentHLD.Quote_Descriptions_Override__c == false)
                return 'Salesforce';
            else
                return 'IFS';
        }
        set {
            this.PARTMANAGEDIN = value;
        }
    }
    public list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPM()
    {
        Boolean isFlag = false;
        list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = new list<Global_Site_Part_Parameters_ISPM__c>();
        String SOQL = 'Select InventorySite__c,InventoryPartType__c,InventoryPartTemplate_ID__c,SalesSite__c,Sourcing_Option__c,PurchaseSite__c,PurchasePartTemplate_ID__c,MfgSite__c';
        SOQL += ' From Global_Site_Part_Parameters_ISPM__c ';
        if(holderOutput.Lead_Time_Override__c != null)
        {
            isFlag = true;
            SOQL += ' where (Site__c= \'10\' and LeadTimeLL__c <='+holderOutput.Lead_Time_Override__c+' and LeadTimeUL__c >='+holderOutput.Lead_Time_Override__c+' and SERIALTRACKCODE__c =\''+SERIALTRACKCODE+'\')';
        }
        //if(holderOutput.Total_Lead_Time_GCI_OHLD__c != null)
        //{
            if(isFlag == true)
            {
                SOQL += ' or ';
            }
            else
            {
                SOQL += ' where ';
                isFlag =true;
            }
            SOQL += ' (Site__c= \'20\' and LeadTimeLL__c <=7777 and LeadTimeUL__c >=7777 and SERIALTRACKCODE__c =\''+SERIALTRACKCODE+'\')';
       // }
       // if(holderOutput.Total_Lead_Time_CDC_OHLD__c != null)
        //{
            if(isFlag == true)
            {
                SOQL += ' or ';
            }
            else
            {
                SOQL += ' where ';
                isFlag =true;
            }
            SOQL += ' (Site__c = \'30\' and LeadTimeLL__c <=7777 and LeadTimeUL__c >=7777 and SERIALTRACKCODE__c =\''+SERIALTRACKCODE+'\')';
       // }
       // if(holderOutput.Total_Lead_Time_40_OHLD__c != null)
       // {
            if(isFlag == true)
            {
                SOQL += ' or ';
            }
            else
            {
                SOQL += ' where ';
                isFlag =true;
            }
            SOQL += ' (Site__c = \'40\' and LeadTimeLL__c <=7777 and LeadTimeUL__c >=7777 and SERIALTRACKCODE__c =\''+SERIALTRACKCODE+'\')';
       // }
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
        if(holderOutput.Lead_Time_Override__c != null)
        {
            isFlag = true;
            SOQL += ' where (Site__c = \'10\' and LeadTimeLL__c <='+holderOutput.Lead_Time_Override__c+' and LeadTimeUL__c >='+holderOutput.Lead_Time_Override__c+' and SERIALTRACKCODE__c =\''+SERIALTRACKCODE+'\')';
        }
        //if(holderOutput.Total_Lead_Time_GCI_OHLD__c != null)
        //{
            if(isFlag == true)
            {
                SOQL += ' or ';
            }
            else
            {
                SOQL += ' where ';
                isFlag =true;
            }
            SOQL += ' (Site__c = \'20\' and LeadTimeLL__c <=7777 and LeadTimeUL__c >=7777 and SERIALTRACKCODE__c =\''+SERIALTRACKCODE+'\')';
        //}
        //if(holderOutput.Total_Lead_Time_CDC_OHLD__c != null)
        //{
            if(isFlag == true)
            {
                SOQL += ' or ';
            }
            else
            {
                SOQL += ' where ';
                isFlag =true;
            }
            SOQL += ' (Site__c = \'30\' and LeadTimeLL__c <=7777 and LeadTimeUL__c >=7777 and SERIALTRACKCODE__c =\''+SERIALTRACKCODE+'\')';
        //}
        //if(holderOutput.Total_Lead_Time_40_OHLD__c != null)
        //{
            if(isFlag == true)
            {
                SOQL += ' or ';
            }
            else
            {
                SOQL += ' where ';
                isFlag =true;
            }
            SOQL += ' (Site__c = \'40\' and LeadTimeLL__c <=7777 and LeadTimeUL__c >=7777 and SERIALTRACKCODE__c =\''+SERIALTRACKCODE+'\')';
        //}
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
                    //System.debug('Total_Lead_Time_GCI_OHLD__c-----null'+holderOutput.Total_Lead_Time_GCI_OHLD__c);
                    //System.debug('Total_Lead_Time_CDC_OHLD__c-----null'+holderOutput.Total_Lead_Time_CDC_OHLD__c);
                   // System.debug('Total_Lead_Time_40_OHLD__c-----null'+holderOutput.Total_Lead_Time_40_OHLD__c);
                    if(ppsRecord.VendorSite__c == '20' &&
                       ppsRecord.VendorLTLL__c <= 7777 &&
                       ppsRecord.VendorLTUL__c > 7777)
                    {
                        SYstem.debug('Inside4------');
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '30' &&
                            ppsRecord.VendorLTLL__c <= 7777 &&
                            ppsRecord.VendorLTUL__c > 7777)
                    {
                        SYstem.debug('Inside5------');
                        globalSitePPSList.add(ppsRecord);
                    }
                }
                // 20 => 10 & 30
                if(ppsRecord.Site__c == '20')
                {
                    if(ppsRecord.VendorSite__c == '10' &&
                       ppsRecord.VendorLTLL__c <= holderOutput.Lead_Time_Override__c &&
                       ppsRecord.VendorLTUL__c > holderOutput.Lead_Time_Override__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '30' &&
                            ppsRecord.VendorLTLL__c <= 7777 &&
                            ppsRecord.VendorLTUL__c > 7777)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                }
                // 30 => 10 & 20
                if(ppsRecord.Site__c == '30')
                {
                    if(ppsRecord.VendorSite__c == '10' &&
                       ppsRecord.VendorLTLL__c <= holderOutput.Lead_Time_Override__c &&
                       ppsRecord.VendorLTUL__c > holderOutput.Lead_Time_Override__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '20' &&
                            ppsRecord.VendorLTLL__c <= 7777 &&
                            ppsRecord.VendorLTUL__c > 7777)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                }

                // 40 => 10, 20 & 30
                if(ppsRecord.Site__c == '40')
                {
                    if(ppsRecord.VendorSite__c == '10' &&
                       ppsRecord.VendorLTLL__c <= holderOutput.Lead_Time_Override__c &&
                       ppsRecord.VendorLTUL__c > holderOutput.Lead_Time_Override__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '20' &&
                            ppsRecord.VendorLTLL__c <= 7777 &&
                            ppsRecord.VendorLTUL__c > 7777)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '30' &&
                            ppsRecord.VendorLTLL__c <= 7777 &&
                            ppsRecord.VendorLTUL__c > 7777)
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
    * @author Ashok S | 30/5/2020
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

                    System.debug('debug point 1');
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
                    System.debug('debug point 2');

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
            system.debug('XML is xmlOutput  '+xmlOutput );
            w.close();
            string xmldata = doc.toXmlString();

        resEngParts.xmlStringResult=xmlOutput;
        return resEngParts;
    }
    /**
    * @description
    * @author Ashok S | 30/5/2020
    * @return result
    **/
    public result getEngPartStructureXML() {
        result resEngPartsStruct=new result();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'ENG_PART_STRUCTURE_LIST', null);
        string xmlOutput1 = w.getXmlString();
        Result doc1=getProdDoc();
        string xmlOutput2=xmlOutput1+doc1.xmlStringResult;
        integer intSortCode=10;
        for (ConfigHolderUtility.HLDRStructureWrapper eachComp : structuresList){
            //Holder_Additional_Acc_Details__c eachComp=additionalAccAttributes.get(eachKey);
            w.writeStartElement(null, 'ENG_PART_STRUCTURE', null);
            w.writeStartElement(null, 'PART_NO', null);
            w.writeCharacters(eachComp.ComponentPart.toUpperCase());
            w.writeEndElement();
            w.writeStartElement(null, 'DESCRIPTION', null);
            w.writeCharacters(COMPDESCRIPTION);
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
            w.writeCharacters(String.valueOf(eachComp.Qty));
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
    * @author Ashok S | 30/5/2020
    * @return result
    **/
    public result getEngPartCharacterXML() {
        result resEngPartChar=new result();
        IFS_character_codes__c[] IFS_Attr=[select Element__c,Attribute_Code__c from IFS_character_codes__c where Interface_to_IFS_Attributes__c=true and Product__c='HLD'];
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartElement(null, 'ENG_PART_CHAR_LIST', null);
        for(IFS_character_codes__c ifsAtt:IFS_Attr) {
            String strInfo=' ';
            String strVal=' ';
            String strCode;
            if (hInputs.containsKey(ifsAtt.Attribute_Code__c))
            {
                if (ifsAtt.Element__c=='Info')
                {
                    strInfo=hInputs.get(ifsAtt.Attribute_Code__c);
                }
                else
                {
                    strVal=hInputs.get(ifsAtt.Attribute_Code__c);
                }
                strCode=ifsAtt.Attribute_Code__c;
                system.debug('Char code is: initial'+strCode);
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
                if(strVal.length() > 20 || (string.isNotBlank(strInfo))){
                    w.writeStartElement(null, 'VALUE', null);
                    w.writeCharacters('See Info');
                    w.writeEndElement();
                }else{
                    w.writeStartElement(null, 'VALUE', null);
                    if(String.isNotBlank(strVal)){
                        w.writeCharacters(strVal);
                    }
                    w.writeEndElement();
                }
                system.debug('Value is:'+strVal);
                w.writeStartElement(null, 'INFO', null);
                if(strVal.length() > 20 && String.isNotBlank(strVal))
                {
                     w.writeCharacters(strVal);
                }
                else if(String.isNotBlank(strInfo))
                {
                    w.writeCharacters(strInfo);
                }
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
    * @author Ashok S | 30/5/2020
    * @return result
    **/
    public result getENGPARTREV() {
        result engPart=new result();
        result resDiaData=new result();
       // result resDiaData=new result();
        map<string,string> mapDia=new map<string,string>();
        mapDia.put ('Entity', currentHLD.Brand__c);
        mapDia.put('HPTC', currentHLD.Holder_Product_Code__c);
        mapDia.put('SZC', currentHLD.Size2__c);
        mapDia.put('HCLASS', currentHLD.Bolting_Class__c);
        mapDia.put('HIC', currentHLD.Inlet_Connection__c);
        mapDia.put('HOC', currentHLD.Outlet_Connection__c);
        mapDia.put('COIN', currentHLD.Inlet_Option__c);
        mapDia.put('COOUT', currentHLD.Outlet_Option2__c);
        mapDia.put('COMF', currentHLD.Mid_Flange_Option__c);
        if(ConstantsUtil.getSizeDesc(currentHLD.size2__c) != null) {

            mapDia.put('SizeValue',String.ValueOf(ConstantsUtil.getSizeDesc(currentHLD.size2__c).SizeValue));
        }
        List <String> selectCols=new List <String>();
        selectCols.add('DWGNO__c');
        selectCols.add('DrawingID__c');
        selectCols.add('Drawing_Type__c');
        selectCols.add('Revision__c');
        //resDiaData = wizardBaseDataProcessor.getDataFromTranslationObj('Drawing_Type__c', 'Holder_Drawings_Translation__c', 'Holder_Drawings_Detail__c', mapDia, selectCols);
        resDiaData = ConfigHolderUtility.getDataFromTranslationObj('Drawing_Type__c', 'Holder_Drawings_Translation__c', 'Holder_Drawings_Detail__c', mapDia, selectCols, null);
        if(resDiaData.bResult) {
            for (sObject sObj: resDiaData.objResultList) {
                if ((string) sObj.get('Drawing_Type__c')=='Submittal Drawing') {
                    engPart.strRetValue =(string) sObj.get('Revision__c');
                    engPart.bResult=true;
                }
            }
        }
        return engPart;
    }
    public result getProdDoc() {
        result resProdDoc=new result();
        result resDiaData=new result();
        map<string,string> mapDia=new map<string,string>();

        mapDia.put ('Entity', currentHLD.Brand__c);
        mapDia.put('HPTC', currentHLD.Holder_Product_Code__c);
        mapDia.put('SZC', currentHLD.Size2__c);
        mapDia.put('HCLASS', currentHLD.Bolting_Class__c);
        mapDia.put('HIC', currentHLD.Inlet_Connection__c);
        mapDia.put('HOC', currentHLD.Outlet_Connection__c);
        mapDia.put('COIN', currentHLD.Inlet_Option__c);
        mapDia.put('COOUT', currentHLD.Outlet_Option2__c);
        mapDia.put('COMF', currentHLD.Mid_Flange_Option__c);
        if(ConstantsUtil.getSizeDesc(currentHLD.size2__c) != null) {

            mapDia.put('SizeValue',String.ValueOf(ConstantsUtil.getSizeDesc(currentHLD.size2__c).SizeValue));
        }

        List <String> selectCols=new List <String>();
        selectCols.add('DWGNO__c');
        selectCols.add('DrawingID__c');
        /*selectCols.add('DimA__c');
        selectCols.add('DimB__c');
        selectCols.add('DimC__c');
        selectCols.add('DimD__c');
        selectCols.add('DimE__c');
        selectCols.add('DimF__c');*/
        selectCols.add('Drawing_Type__c');
        //resDiaData = wizardBaseDataProcessor.getDataFromTranslationObj('Drawing_Type__c', 'Holder_Drawings_Translation__c', 'Holder_Drawings_Detail__c', mapDia, selectCols);
        resDiaData = ConfigHolderUtility.getDataFromTranslationObj('Drawing_Type__c', 'Holder_Drawings_Translation__c', 'Holder_Drawings_Detail__c', mapDia, selectCols, null);

        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        // w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'DOCUMENT_LIST', null);

        if(resDiaData.bResult)
        {
            for(sObject sobj:resDiaData.objResultList) {

                //if((string) sObj.get('Drawing_Type__c')!='IINO') {
                //Added below if condition for the redmine 34657
                if(sobj.get('DWGNO__c') != null && ((STRING) sobj.get('DWGNO__c')) !=''){
                w.writeStartElement(null, 'DOCUMENT', null);

                    w.writeStartElement(null, 'DOC_NO', null);
                        String dwgNo=(STRING) sobj.get('DWGNO__c')==null?'':(STRING) sobj.get('DWGNO__c');
                        w.writeCharacters(dwgNo);
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

            //check for additiona document section and if present add to the XML
            if(currentHLD.Additional_Documents__c != null && currentHLD.Additional_Documents__c != '') {

                w.writeStartElement(null, 'DOCUMENT', null);

                    w.writeStartElement(null, 'DOC_NO', null);
                        w.writeCharacters(currentHLD.Additional_Documents__c);
                    w.writeEndElement();

                    w.writeStartElement(null, 'DOC_REV', null);
                    w.writeEndElement();

                    w.writeStartElement(null, 'DOC_TITLE', null);
                    w.writeEndElement();

                    w.writeStartElement(null, 'DOC_CLASS', null);
                    w.writeEndElement();

                    w.writeStartElement(null, 'DOC_SHEET', null);
                    w.writeEndElement();

                    w.writeStartElement(null, 'FILE_TYPE', null);
                    w.writeEndElement();

                    w.writeStartElement(null, 'FILE_NAME', null);
                    w.writeEndElement();

                    w.writeStartElement(null, 'FILE_DATA', null);
                    w.writeEndElement();

                    w.writeStartElement(null, 'DOC_RESP_SIGN', null);
                    w.writeEndElement();

                w.writeEndElement();
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
    * @author Ashok S | 30/5/2020
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
    * @author Ashok S | 30/5/2020
    * @return result
    **/
    public result getStructureXML() {
        result resStruXML=new result();
        List<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = GlobalSiteParametersISPM();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'PRODUCT_STRUCTURE_LIST', null);
        if(structuresList.size() > 0 && GlobalSiteParametersISPMList.size() > 0)
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
                    for (ConfigHolderUtility.HLDRStructureWrapper eachComp : structuresList){
                        //Holder_Additional_Acc_Details__c eachComp=additionalAccAttributes.get(eachKey);
                        w.writeStartElement(null, 'PRODUCT_STRUCTURE', null);
                        w.writeStartElement(null, 'LINE_ITEM_NO', null);
                        w.writeCharacters(String.valueOf(intSortCode));
                        w.writeEndElement();
                        w.writeStartElement(null, 'COMPONENT_PART', null);
                        w.writeCharacters(eachComp.ComponentPart.toUpperCase());
                        w.writeEndElement();
                        w.writeStartElement(null, 'QTY_PER_ASSEMBLY', null);
                        w.writeCharacters(String.valueOf(eachComp.Qty));
                        w.writeEndElement();
                        w.writeStartElement(null, 'COMPONENT_SCRAP', null);
                        w.writeCharacters(eachComp.ComponentScrap);
                        w.writeEndElement();
                        w.writeStartElement(null, 'SHRINKAGE_FACTOR', null);
                        w.writeCharacters(eachComp.ScrapFactor);
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
    * @author Ashok S | 30/5/2020
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
    * @author Ashok S | 30/5/2020
    * @return result
    **/
    public result getPurchasePartSuppliers() {
        result resPurchase=new result();
        list<Global_Site_Part_Parameters_PPS__c> GlobalSiteParametersPPSList = getGlobalSitePPS();
        Dom.Document doc = new Dom.Document();
        //string PARTNUMBER1=getPartNum();
        XmlStreamWriter w = new XmlStreamWriter();
        //decimal total=currentHLD.Discountable_Price__c+currentHLD.Non_Discountable_Price__c;
        decimal total=currentHLD.List_Price_Each__c;
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
                if(globalSitePPS.PurchaseSite__c == '30'){
                    w.writeCharacters(HSNSACCODE);
                }
                w.writeEndElement();
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
    * @author Ashok S | 30/5/2020
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
                if(rLead.SalesSite__c == '30'){
                    w.writeCharacters(HSNSACCODE);
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
        resSalesPart.xmlStringResult=xmlOutput;
        return resSalesPart;
    }
    /**
    * @description
    * @author Ashok S | 30/5/2020
    * @return result
    **/
    public result GetRoutingDetails() {
        result resRouting=new result();
        Dom.Document doc = new Dom.Document();
        result routingStep = ConfigHolderUtility.getHLDRouting(hInputs);
        List<Holder_Routing_Detail__c> lstHLDR = new List<Holder_Routing_Detail__c>();
        //Result bgrGuideLineResult2 = getRouting();
        if(routingStep.bResult && routingStep.objResultList.size() > 0)
        {
            System.debug('Inside5----------');
            for(sObject objResult: routingStep.objResultList)
            {
                System.debug('Inside3----------');
                lstHLDR.add((Holder_Routing_Detail__c) objResult);
            }
        }
        List<Holder_WorkGuidelines_Detail__c> lstGL = new List<Holder_WorkGuidelines_Detail__c>();
        Result rdGuideLineResult = ConfigHolderUtility.getHolderWorkGuideLines(hInputs);
        if(rdGuideLineResult.bResult && rdGuideLineResult.objResultList.size() > 0)
        {
            System.debug('Inside5----------');
            for(sObject objResult: rdGuideLineResult.objResultList)
            {
                Holder_WorkGuidelines_Detail__c bgrGuideLine = (Holder_WorkGuidelines_Detail__c)objResult;
                lstGL.add(bgrGuideLine);

            }
        }
        if(lstHLDR.size()>0)
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
                        for(Holder_Routing_Detail__c brRec: lstHLDR)
                        {
                            //BGR_Routing__c brRec = (BGR_Routing__c)sRec;
                            xmlW.writeStartElement(null,'ROUTING_OPERATION',null);
                            xmlW.writeStartElement(null,'OPERATION_NO',null);
                            xmlW.writeCharacters(brRec.OPERATION__c);
                            xmlW.writeEndElement();
                            xmlW.writeStartElement(null,'STD_OP_ID',null);
                            xmlW.writeCharacters(brRec.Standard_Operation_ID__c);
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
                           //if(brRec.OPERATION__c == '0090' || brRec.OPERATION__c == '90')
                            //{
                                if(lstGL.size()>0)
                            {
                                System.debug('Inside1----------');
                                xmlW.writeStartElement(null,'ROUTING_OPER_WORK_GUIDE_LIST',null);
                                for(Holder_WorkGuidelines_Detail__c bgRec: lstGL)
                                {
                                    System.debug('Inside2----------');
                                    if(bgRec.Operation__c == brRec.OPERATION__c){
                                        xmlW.writeStartElement(null,'ROUTING_OPER_WORK_GUIDE',null);
                                        xmlW.writeStartElement(null,'GUIDELINE_SEQ',null);
                                        xmlW.writeCharacters(bgRec.Guideline_Seq__c);
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
    * @author Ashok S | 30/5/2020
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
        result rdCntlPln =ConfigHolderUtility.getHolderControlPlan(hInputs);
        Xmlstreamwriter xmlW = new Xmlstreamwriter();
        xmlW.writeStartDocument('utf-8','1.0');
        xmlW.writeStartElement(null,'CONTROL_PLAN_MANUF_LIST', null);
        if(rdCntlPln.bResult)
        {
            list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = GlobalSiteParametersISPM();
            Set<String> toolIdSet = new Set<String>();
            Set<String> dataPointSet = new Set<String>();
            List<Holder_ControlPlan_Detail__c> connectionList = new List<Holder_ControlPlan_Detail__c>();
            for(sObject sRec: rdCntlPln.objResultList)
            {
                Holder_ControlPlan_Detail__c brRec = (Holder_ControlPlan_Detail__c)sRec;
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
                            Holder_ControlPlan_Detail__c brRec = (Holder_ControlPlan_Detail__c)sRec;
                            xmlW.writeStartElement(null,'CONTROL_PLAN_LINE',null); // CONTROL_PLAN_LINE start

                            xmlW.writeStartElement(null,'TEST_OPERATION_NO',null);
                            //xmlW.writeCharacters(String.valueOf(brRec.Test_OPNO__c));
                            xmlW.writeCharacters(String.valueOf(brRec.Test_OPNO__c));
                            xmlW.writeEndElement();

                            xmlW.writeStartElement(null,'TEST_OPERATION_DESC',null);
                            xmlW.writeCharacters(String.valueOf(brRec.TEST_OPERATION_DESC__c));
                            xmlW.writeEndElement();

                            xmlW.writeStartElement(null,'NORM_TYPE',null);
                            xmlW.writeCharacters(String.valueOf(brRec.NORM_TYPE__c));
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
                                xmlW.writeCharacters(brRec.DATA_TYPE__c);
                            }
                            xmlW.writeEndElement();

                            xmlW.writeStartElement(null,'CATEGORY_ID',null);
                            if(brRec.Category_ID__c != null)
                            {
                                xmlW.writeCharacters(brRec.CATEGORY_ID__c);
                            }
                            xmlW.writeEndElement();

                            xmlW.writeStartElement(null,'OUTER_MIN',null);
                           // OuterMinValue = String.valueOf(brRec.OUTER_MIN__c);
                            //System.debug('AAAAAa-----'+OuterMinValue);
                           // OuterMinValue = OuterMinValue.substringBetween('[',']');
                          //  if(string.isBlank(OuterMinValue))
                         //   {
                                if(brRec.OUTER_MIN__c != null)
                                      xmlW.writeCharacters(String.valueOf(brRec.OUTER_MIN__c));
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
                            InnerMinValue = String.valueOf(brRec.INNER_MIN__c);
                            if(InnerMinValue!=null)
                            {
                                InnerMinValue = InnerMinValue.substringBetween('[',']');
                            }
                            if(string.isBlank(InnerMinValue) || InnerMinValue == null)
                            {
                                if(InnerMinValue!=null)
                                {
                                    xmlW.writeCharacters(String.valueOf(brRec.INNER_MIN__c));
                                }
                            }

                            xmlW.writeEndElement();
                            xmlW.writeStartElement(null,'NOMINAL_VALUE',null);
                          //  NominalValue = String.valueOf(brRec.Nominal_Value__c);
                         //   NominalValue = NominalValue.substringBetween('[',']');
                         //   if(string.isBlank(NominalValue))
                         //   {
                                if(brRec.NOMINAL_VALUE__c != null)
                                    xmlW.writeCharacters(String.valueOf(brRec.NOMINAL_VALUE__c));
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
                            if(brRec.Special_Characteristic_Classification__c != null)
                            {
                                xmlW.writeCharacters(brRec.Special_Characteristic_Classification__c);
                            }
                            xmlW.writeEndElement();

                            xmlW.writeStartElement(null,'OUTER_MAX',null);
                           // OuterMaxValue = String.valueOf(brRec.Outer_Max__c);
                          //  OuterMaxValue = OuterMaxValue.substringBetween('[',']');
                          //  if(string.isBlank(OuterMaxValue))
                           // {
                                if(brRec.OUTER_MAX__c != null)
                                    xmlW.writeCharacters(String.valueOf(brRec.OUTER_MAX__c));
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
                            InnerMaxValue = String.valueOf(brRec.INNER_MAX__c);
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
                                if(brRec.INNER_MAX__c != null)
                                {
                                    xmlW.writeCharacters(String.valueOf(brRec.INNER_MAX__c));
                                }
                            }
                            else
                            {
                                if(brRec.INNER_MAX__c != null)
                                {
                                    xmlW.writeCharacters(String.valueOf(brRec.INNER_MAX__c));
                                }
                            }
                            xmlW.writeEndElement();
                            xmlW.writeStartElement(null,'INSPECTION_CODE',null);
                            xmlW.writeCharacters(brRec.INSPECTION_CODE__c);
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
                            for(Holder_ControlPlan_Detail__c brRec : connectionList)
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
            xmlW.writeEndElement();


        }
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
    * @author Ashok S | 30/5/2020
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
    /**
    * @description
    * @author Ashok Sontineni | 4/6/2020
    * @return result
    **/
    public result getPartNumber(){
        result resPartNo=new result();
        string prtnu=PARTNUMBER;
        if(prtnu!=null) {
            resPartNo.bResult=true;
            resPartNo.strRetValue=PARTNUMBER;
        }
        return resPartNo;
    }

}