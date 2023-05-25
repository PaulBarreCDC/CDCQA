/**
* @File Name          : RVOutputUtilityXML.cls
* @Description        : The class contructs the XML parts needed for IFS
* @Author             : Vinayak Singh
* @Group              : 
* @Last Modified By   : Vinayak Singh
* @Last Modified On   : 15/05/2020, 11:22:22 am
* @Modification Log   : 
* Ver       Date            Author                  Modification
* 1.0    13/5/2020        Vinayak Singh     Initial Version
* 1.1    08/04/2021       Rohini Hathi      Service Ticket #200752, limit chars in desc field
**/

public class RVOutputUtilityXML implements HandlerInterface{
    public RVOutputUtilityXML(Id recordID) {
        currentRV= (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(recordID).objResultList[0];  
        RVOU = new RVOutputUtility(currentRV.id);
    }
    public Map<String,String> mapRVOutPuts {set;get;}
    public Relief_Valve__c currentRV{get; set;}
    public RVOutputUtility RVOU;
    public list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPM()
    {
        Boolean isFlag = false;
        list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = new list<Global_Site_Part_Parameters_ISPM__c>();
        String SOQL = 'Select InventorySite__c,InventoryPartType__c,InventoryPartTemplate_ID__c,SalesSite__c,Sourcing_Option__c,PurchaseSite__c,PurchasePartTemplate_ID__c,MfgSite__c';
        SOQL += ' From Global_Site_Part_Parameters_ISPM__c ';
        if(currentRV.Lead_Time_Site_10__c != null)
        {
            isFlag = true;
            SOQL += ' where (SITE__c = \'10\' and LeadTimeLL__c <='+currentRV.Lead_Time_Site_10__c+' and LeadTimeUL__c >='+currentRV.Lead_Time_Site_10__c+' and SERIALTRACKCODE__c =\''+RVOU.SERIALTRACKCODE+'\')';
        }
        if(currentRV.Lead_Time_Site_20__c != null)
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
            SOQL += ' (SITE__c = \'20\' and LeadTimeLL__c <='+currentRV.Lead_Time_Site_20__c+' and LeadTimeUL__c >='+currentRV.Lead_Time_Site_20__c+' and SERIALTRACKCODE__c =\''+RVOU.SERIALTRACKCODE+'\')';
        }
        if(currentRV.Lead_Time_Site_30__c != null)
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
            SOQL += ' (SITE__c = \'30\' and LeadTimeLL__c <='+currentRV.Lead_Time_Site_30__c+' and LeadTimeUL__c >='+currentRV.Lead_Time_Site_30__c+' and SERIALTRACKCODE__c =\''+RVOU.SERIALTRACKCODE+'\')';
        }
        if(currentRV.Lead_Time_Site_40__c != null)
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
            SOQL += ' (SITE__c = \'40\' and LeadTimeLL__c <='+currentRV.Lead_Time_Site_40__c+' and LeadTimeUL__c >='+currentRV.Lead_Time_Site_40__c+' and SERIALTRACKCODE__c =\''+RVOU.SERIALTRACKCODE+'\')';
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
        if(currentRV.Lead_Time_Site_10__c != null)
        {
            isFlag = true;
            SOQL += ' where (SITE__c = \'10\' and LeadTimeLL__c <='+currentRV.Lead_Time_Site_10__c+' and LeadTimeUL__c >='+currentRV.Lead_Time_Site_10__c+' and SERIALTRACKCODE__c =\''+RVOU.SERIALTRACKCODE+'\')';
        }
        if(currentRV.Lead_Time_Site_20__c != null)
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
            SOQL += ' (SITE__c = \'20\' and LeadTimeLL__c <='+currentRV.Lead_Time_Site_20__c+' and LeadTimeUL__c >='+currentRV.Lead_Time_Site_20__c+' and SERIALTRACKCODE__c =\''+RVOU.SERIALTRACKCODE+'\')';
        }
        if(currentRV.Lead_Time_Site_30__c != null)
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
            SOQL += ' (SITE__c = \'30\' and LeadTimeLL__c <='+currentRV.Lead_Time_Site_30__c+' and LeadTimeUL__c >='+currentRV.Lead_Time_Site_30__c+' and SERIALTRACKCODE__c =\''+RVOU.SERIALTRACKCODE+'\')';
        }
        if(currentRV.Lead_Time_Site_40__c != null)
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
            SOQL += ' (SITE__c = \'40\' and LeadTimeLL__c <='+currentRV.Lead_Time_Site_40__c+' and LeadTimeUL__c >='+currentRV.Lead_Time_Site_40__c+' and SERIALTRACKCODE__c =\''+RVOU.SERIALTRACKCODE+'\')';
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
            for(Global_Site_Part_Parameters_PPS__c ppsRecord: [SELECT Id,Name,Site__c,VendorSite__c,VendorLTLL__c,VendorLTUL__c,Primary_Vendor__c,PPS_VendoNo__c,PurchaseSite__c from Global_Site_Part_Parameters_PPS__c WHERE Site__c IN:purchasedInventorySites order by Site__c])
            {
                // 10 => 20 & 30
                if(ppsRecord.Site__c == '10') 
                {
                    if(ppsRecord.VendorSite__c == '20' && 
                       ppsRecord.VendorLTLL__c <= currentRV.Lead_Time_Site_20__c && 
                       ppsRecord.VendorLTUL__c > currentRV.Lead_Time_Site_20__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '30' && 
                            ppsRecord.VendorLTLL__c <= currentRV.Lead_Time_Site_30__c && 
                            ppsRecord.VendorLTUL__c > currentRV.Lead_Time_Site_30__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }       
                }
                // 20 => 10 & 30
                if(ppsRecord.Site__c == '20')
                {
                    if(ppsRecord.VendorSite__c == '10' && 
                       ppsRecord.VendorLTLL__c <= currentRV.Lead_Time_Site_10__c && 
                       ppsRecord.VendorLTUL__c > currentRV.Lead_Time_Site_10__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '30' && 
                            ppsRecord.VendorLTLL__c <= currentRV.Lead_Time_Site_30__c && 
                            ppsRecord.VendorLTUL__c > currentRV.Lead_Time_Site_30__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }       
                }
                // 30 => 10 & 20
                if(ppsRecord.Site__c == '30')
                {
                    if(ppsRecord.VendorSite__c == '10' && 
                       ppsRecord.VendorLTLL__c <= currentRV.Lead_Time_Site_10__c && 
                       ppsRecord.VendorLTUL__c > currentRV.Lead_Time_Site_10__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '20' && 
                            ppsRecord.VendorLTLL__c <= currentRV.Lead_Time_Site_20__c && 
                            ppsRecord.VendorLTUL__c > currentRV.Lead_Time_Site_20__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }       
                }
                
                // 40 => 10, 20 & 30
                if(ppsRecord.Site__c == '40')
                {
                    if(ppsRecord.VendorSite__c == '10' && 
                       ppsRecord.VendorLTLL__c <= currentRV.Lead_Time_Site_10__c && 
                       ppsRecord.VendorLTUL__c > currentRV.Lead_Time_Site_10__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }
                    else if(ppsRecord.VendorSite__c == '20' && 
                            ppsRecord.VendorLTLL__c <= currentRV.Lead_Time_Site_20__c && 
                            ppsRecord.VendorLTUL__c > currentRV.Lead_Time_Site_20__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }  
                    else if(ppsRecord.VendorSite__c == '30' && 
                            ppsRecord.VendorLTLL__c <= currentRV.Lead_Time_Site_30__c && 
                            ppsRecord.VendorLTUL__c > currentRV.Lead_Time_Site_30__c)
                    {
                        globalSitePPSList.add(ppsRecord);
                    }  
                }
            }
        }
        System.debug('***** globalSitePPSList = '+globalSitePPSList);
        return globalSitePPSList;
    }
    
    public result getEngineeringParts() {
        result resEngParts=new result();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'ENG_PART_REC', null); 
        w.writeStartElement(null, 'ENG_PART', null); 
        w.writeStartElement(null, 'ENG_PART_NO', null);  
        w.writeCharacters(RVOU.PARTNUMBER.toUpperCase());
        w.writeEndElement();
        w.writeStartElement(null, 'ENG_PART_REV', null);  
        w.writeCharacters(RVOU.PARTREV);
        w.writeEndElement();
        w.writeStartElement(null, 'DESCRIPTION', null); 
        //Service Ticket #200752 , RVOU.PARTNUMBERDESC variable stores the description value
        w.writeCharacters(String.isNotBlank(RVOU.PARTNUMBERDESC)?RVOU.PARTNUMBERDESC.length()<200?RVOU.PARTNUMBERDESC:RVOU.PARTNUMBERDESC.substring(0,200):'');
        w.writeEndElement();
        w.writeStartElement(null, 'LOT_TRACKING_CODE', null);  
        w.writeCharacters(RVOU.LOTTRACKCODE);
        w.writeEndElement();
        w.writeStartElement(null, 'PROVIDE', null);  
        w.writeCharacters(RVOU.PROVIDE);
        w.writeEndElement();
        w.writeStartElement(null, 'INV_SERIAL_TRACKING', null);  
        w.writeCharacters(RVOU.SERIALTRACKCODE);
        w.writeEndElement();
        w.writeStartElement(null, 'PART_CLASS', null);  
        w.writeCharacters(RVOU.PARTCLASS);
        w.writeEndElement();
        w.writeStartElement(null, 'RESPONSIBLE_ID', null);  
        w.writeCharacters(RVOU.RESPONSIBLE_ID);
        w.writeEndElement();
        w.writeStartElement(null, 'NOTE', null);  
        w.writeCharacters(RVOU.NOTE);
        w.writeEndElement();
        w.writeStartElement(null, 'PARTMANAGEDIN', null);
        w.writeCharacters(RVOU.PARTMANAGEDIN);
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
                w.writeStartElement(null,child1.getName(), null);
                w.writeCharacters(child1.getText());
                w.writeEndElement();
            }
            w.writeEndElement();
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
        w.close();
        string xmldata = doc.toXmlString();
        resEngParts.xmlStringResult=xmlOutput;
        
        return resEngParts;
    }
    
    public result getEngPartStructureXML() {
        result resEngPartsStruct=new result();
        result EngstrucResult=RVOU.getStructure();
        Map<String, String> mapWeight = RVOU.mapWeight;
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'ENG_PART_STRUCTURE_LIST', null); 
        string xmlOutput1 = w.getXmlString();
        Result doc1=getProdDoc();        
        string xmlOutput2=xmlOutput1+doc1.xmlStringResult;
        if(EngstrucResult.bResult)
        {
            for(sObject sobj:EngstrucResult.objResultList) {
                w.writeStartElement(null, 'ENG_PART_STRUCTURE', null);
                w.writeStartElement(null, 'PART_NO', null);  
                w.writeCharacters((STRING) sobj.get('Component_part__c'));
                w.writeEndElement();
                w.writeStartElement(null, 'DESCRIPTION', null);
                w.writeCharacters(RVOU.COMPDESCRIPTION);
                w.writeEndElement();
                w.writeStartElement(null, 'LOT_TRACKING_CODE', null);  
                w.writeCharacters(RVOU.LOTTRACKCODE);
                w.writeEndElement();
                w.writeStartElement(null, 'PROVIDE', null);  
                w.writeCharacters(RVOU.PROVIDE);
                w.writeEndElement();
                w.writeStartElement(null, 'INV_SERIAL_TRACKING', null);  
                w.writeCharacters(RVOU.SERIALTRACKCODE);
                w.writeEndElement();
                w.writeStartElement(null, 'RESPONSIBLE_ID', null);  
                w.writeCharacters(RVOU.RESPONSIBLE_ID);
                w.writeEndElement();
                w.writeStartElement(null, 'NOTE', null);  
                w.writeCharacters(RVOU.NOTE);
                w.writeEndElement();
                w.writeStartElement(null, 'DRAW_POS_NO', null);  
                w.writeCharacters((STRING) sobj.get('ItemNo__c'));
                w.writeEndElement();
                w.writeStartElement(null, 'QTY_PER_ASSEMBLY', null);  
                w.writeCharacters((STRING) sobj.get('Qty_per_Assembly__c'));
                w.writeEndElement();
                w.writeStartElement(null, 'SORT_CODE', null);  
                w.writeCharacters((STRING) sobj.get('ItemNo__c'));
                w.writeEndElement();
                w.writeEndElement(); 
            }
            for(Valve_Structure_Details_Appx__c valveStructureDetail : [SELECT Id,ItemNo__c, Component_Part__c,
                                                                            Component_Scrap__c,Qty_per_Assembly__c,
                                                                            Scrap_Factor__c,Stucture_Element__c
                                                                           FROM Valve_Structure_Details_Appx__c])
            {
                if(String.isNotBlank(valveStructureDetail.Component_Part__c))
                {
                    String valveStructDetailPartNumber = valveStructureDetail.Component_Part__c;
                    String valveStructDetailQty = valveStructureDetail.Qty_per_Assembly__c;
                    if(valveStructDetailPartNumber.contains('['))
                    {
                        valveStructDetailPartNumber = valveStructDetailPartNumber.substringBetween('[', ']');
                    }
                    if(valveStructDetailQty.contains('['))
                    {
                        valveStructDetailQty = valveStructDetailQty.substringBetween('[', ']');
                    }
                    if(mapWeight.containsKey(valveStructDetailPartNumber) && String.isNotBlank(mapWeight.get(valveStructDetailPartNumber)))
                    {
                        if(!mapWeight.containsKey(valveStructDetailQty))
                        {
                            mapWeight.put(valveStructDetailQty,valveStructureDetail.Qty_per_Assembly__c);
                        }
                        w.writeStartElement(null, 'ENG_PART_STRUCTURE', null);
                        w.writeStartElement(null, 'PART_NO', null);  
                        w.writeCharacters((STRING) mapWeight.get(valveStructDetailPartNumber));
                        w.writeEndElement();
                        w.writeStartElement(null, 'DESCRIPTION', null);
                        w.writeCharacters(RVOU.COMPDESCRIPTION);
                        w.writeEndElement();
                        w.writeStartElement(null, 'LOT_TRACKING_CODE', null);  
                        w.writeCharacters(RVOU.LOTTRACKCODE);
                        w.writeEndElement();
                        w.writeStartElement(null, 'PROVIDE', null);  
                        w.writeCharacters(RVOU.PROVIDE);
                        w.writeEndElement();
                        w.writeStartElement(null, 'INV_SERIAL_TRACKING', null);  
                        w.writeCharacters(RVOU.SERIALTRACKCODE);
                        w.writeEndElement();
                        w.writeStartElement(null, 'RESPONSIBLE_ID', null);  
                        w.writeCharacters(RVOU.RESPONSIBLE_ID);
                        w.writeEndElement();
                        w.writeStartElement(null, 'NOTE', null);  
                        w.writeCharacters(RVOU.NOTE);
                        w.writeEndElement();
                        w.writeStartElement(null, 'DRAW_POS_NO', null);  
                        w.writeCharacters((STRING) valveStructureDetail.ItemNo__c);
                        w.writeEndElement();
                        w.writeStartElement(null, 'QTY_PER_ASSEMBLY', null);  
                        w.writeCharacters((STRING) mapWeight.get(valveStructDetailQty));
                        w.writeEndElement();
                        w.writeStartElement(null, 'SORT_CODE', null);  
                        w.writeCharacters((STRING) valveStructureDetail.ItemNo__c);
                        w.writeEndElement();
                        w.writeEndElement(); 
                    }
                }
            }
        }        
        w.writeEndElement();
        w.writeEndDocument(); 
        string xmlOutput = w.getXmlString();
        w.close();
        string xmldata = doc.toXmlString();
        system.debug('XML is xmlOutput  '+xmlOutput );
        resEngPartsStruct.xmlStringResult=xmlOutput;
        return resEngPartsStruct;
    }
    
    public result getEngPartCharacterXML() 
    {
        System.debug('**** generating xml for getEngPartCharacterXML');
        RVOU = new RVOutputUtility(currentRV.id);
        result resEngPartChar=new result();
        IFS_character_codes__c[] IFS_Attr=[select Element__c,Attribute_Code__c from IFS_character_codes__c where Interface_to_IFS_Attributes__c=true and Product__c='RV' order by Attribute_Code__c];
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartElement(null, 'ENG_PART_CHAR_LIST', null);
        for(IFS_character_codes__c ifsAtt:IFS_Attr) {
            String strInfo=' ';
            String strVal=' ';
            String strCode;
            
            if (RVOU.XmlMapRVAttr.containsKey(ifsAtt.Attribute_Code__c)) 
            {
                if (ifsAtt.Element__c=='Info')
                {
                    if(RVOU.XmlMapRVAttr.containskey(ifsAtt.Attribute_Code__c) && RVOU.XmlMapRVAttr.get(ifsAtt.Attribute_Code__c) != null){
                        strInfo=RVOU.XmlMapRVAttr.get(ifsAtt.Attribute_Code__c);
                    }
                }
                else
                {
                    if(RVOU.XmlMapRVAttr.containskey(ifsAtt.Attribute_Code__c) && RVOU.XmlMapRVAttr.get(ifsAtt.Attribute_Code__c) != null){
                        strVal=RVOU.XmlMapRVAttr.get(ifsAtt.Attribute_Code__c);
                    }
                }
                strCode=ifsAtt.Attribute_Code__c;
                w.writeStartElement(null, 'ENG_PART_CHAR', null);
                w.writeStartElement(null, 'CHAR_TEMPLATE', null);  
                w.writeCharacters(RVOU.ATTRTEMPLATE);
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
        w.writeEndElement();
        string xmlOutput = w.getXmlString();
        system.debug('XML is xmlOutput  '+xmlOutput );
        w.close();
        string xmldata = doc.toXmlString();
        system.debug('XML is '+xmldata);
        resEngPartChar.xmlStringResult=xmlOutput;
        return resEngPartChar;
    }
    
    public result getProdDoc() {
        result resProdDoc=new result();
        result DocResult=RVOU.getDocument();
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
                    w.writeEndElement();
                }   
                
            }
        }
        w.writeEndElement();
        string xmlOutput = w.getXmlString();
        w.close();
        string xmldata = doc.toXmlString();
        resProdDoc.xmlStringResult=xmlOutput;
        return resProdDoc;
    }
    
    public result getProductCatalog() {
        result resProdCat=new result();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'PART_CATALOG_REC', null); 
        w.writeStartElement(null, 'PART_CATALOG', null); 
        w.writeStartElement(null, 'WEIGHT_NET', null);  
        w.writeCharacters(RVOU.ASSEMBLYWT);
        w.writeEndElement();
        w.writeStartElement(null, 'UOM', null);  
        w.writeCharacters(RVOU.ASSEMBLYWTUOM);
        w.writeEndElement();
        w.writeEndElement();
        w.writeEndElement();
        w.writeEndDocument();
        string xmlOutput = w.getXmlString();
        //system.debug('XML is xmlOutput  '+xmlOutput );
        w.close();
        string xmldata = doc.toXmlString();
        //system.debug('XML is '+xmldata);
        resProdCat.xmlStringResult=xmlOutput;
        return resProdCat;
    }
    
    public result getStructureXML() {
        result resStruXML=new result();
        result strucResult=RVOU.getStructure();
        Map<String, String> mapWeight = RVOU.mapWeight;
        list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = GlobalSiteParametersISPM();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'PRODUCT_STRUCTURE_LIST', null); 
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
                    w.writeCharacters(RVOU.PARTNUMBER.toUpperCase());
                    w.writeEndElement();
                    w.writeStartElement(null, 'PROD_STRUCTURE_LIST', null); 
                    for(sObject sobj:strucResult.objResultList) 
                    {
                        w.writeStartElement(null, 'PRODUCT_STRUCTURE', null);
                        w.writeStartElement(null, 'LINE_ITEM_NO', null);  
                        w.writeCharacters((STRING) sobj.get('ItemNo__c'));
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
                    }
                    for(Valve_Structure_Details_Appx__c valveStructureDetail : [SELECT Id,ItemNo__c, Component_Part__c,
                                                                            Component_Scrap__c,Qty_per_Assembly__c,
                                                                            Scrap_Factor__c,Stucture_Element__c
                                                                           FROM Valve_Structure_Details_Appx__c])
                    {
                        if(String.isNotBlank(valveStructureDetail.Component_Part__c))
                        {
                            String valveStructDetailPartNumber = valveStructureDetail.Component_Part__c;
                            String valveStructDetailQty = valveStructureDetail.Qty_per_Assembly__c;
                            if(valveStructDetailPartNumber.contains('['))
                            {
                                valveStructDetailPartNumber = valveStructDetailPartNumber.substringBetween('[', ']');
                            }
                            if(valveStructDetailQty.contains('['))
                            {
                                valveStructDetailQty = valveStructDetailQty.substringBetween('[', ']');
                            }
                            if(mapWeight.containsKey(valveStructDetailPartNumber) && String.isNotBlank(mapWeight.get(valveStructDetailPartNumber)))
                            {
                                if(!mapWeight.containsKey(valveStructDetailQty))
                                {
                                    mapWeight.put(valveStructDetailQty,valveStructureDetail.Qty_per_Assembly__c);
                                }
                                w.writeStartElement(null, 'PRODUCT_STRUCTURE', null);
                                w.writeStartElement(null, 'LINE_ITEM_NO', null);  
                                w.writeCharacters((STRING) valveStructureDetail.ItemNo__c);
                                w.writeEndElement(); 
                                w.writeStartElement(null, 'COMPONENT_PART', null);  
                                w.writeCharacters((STRING) mapWeight.get(valveStructDetailPartNumber));
                                w.writeEndElement();
                                w.writeStartElement(null, 'QTY_PER_ASSEMBLY', null);  
                                w.writeCharacters((STRING) mapWeight.get(valveStructDetailQty));
                                w.writeEndElement();
                                w.writeStartElement(null, 'COMPONENT_SCRAP', null);  
                                w.writeCharacters((STRING) valveStructureDetail.Component_Scrap__c);
                                w.writeEndElement();
                                w.writeStartElement(null, 'SHRINKAGE_FACTOR', null);  
                                w.writeCharacters((STRING) valveStructureDetail.Scrap_Factor__c);
                                w.writeEndElement();
                                w.writeEndElement(); 
                            }
                        }
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
        resStruXML.xmlStringResult=xmlOutput;
        return resStruXML;
    }
    
    public result GetInventoryPartDetails() {
        result resInv=new result();
        list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = GlobalSiteParametersISPM();
        Dom.Document doc = new Dom.Document();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
        w.writeStartElement(null, 'INVENTORY_PART_LIST', null); 
        if(GlobalSiteParametersISPMList.size() > 0)
        {
            for(Global_Site_Part_Parameters_ISPM__c bgrLead : GlobalSiteParametersISPMList){
                
                w.writeStartElement(null, 'INVENTORY_PART', null);
                w.writeStartElement(null, 'CONTRACT', null);  
                w.writeCharacters(bgrLead.InventorySite__c);
                w.writeEndElement();
                w.writeStartElement(null, 'PART_NO', null);  
                w.writeCharacters(RVOU.PARTNUMBER.toUpperCase());
                w.writeEndElement();
                w.writeStartElement(null, 'TEMPLATE_ID', null);  
                w.writeCharacters(bgrLead.InventoryPartTemplate_ID__c);
                w.writeEndElement();
                
                w.writeStartElement(null, 'PART_TYPE', null);  
                w.writeCharacters(bgrLead.InventoryPartType__c);
                w.writeEndElement();
                w.writeStartElement(null, 'PLANNER', null);  
                w.writeCharacters(RVOU.PLANNER);
                w.writeEndElement();
                w.writeStartElement(null, 'CUSTOMS_STAT_NO', null);  
                w.writeCharacters(RVOU.CUSTOMSTATNO);
                w.writeEndElement();
                w.writeStartElement(null, 'ENG_REVISION', null);  
                w.writeCharacters(RVOU.PARTREV);
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
    
    public result getPurchasePartSuppliers() {
        result resPurchase=new result();
        list<Global_Site_Part_Parameters_PPS__c> GlobalSiteParametersPPSList = getGlobalSitePPS();
        Dom.Document doc = new Dom.Document();
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
                w.writeCharacters(RVOU.PARTNUMBER.toUpperCase());
                w.writeEndElement();
                w.writeStartElement(null, 'VENDOR_NO', null);  
                w.writeCharacters(globalSitePPS.PPS_VendoNo__c);
                w.writeEndElement();
                w.writeStartElement(null, 'BUY_UNIT_MEAS', null);  
                w.writeCharacters(RVOU.PARTUOM);
                w.writeEndElement();
                w.writeStartElement(null, 'PRIMARY_VENDOR_DB', null);  
                w.writeCharacters(globalSitePPS.Primary_Vendor__c != null ? globalSitePPS.Primary_Vendor__c : '');
                w.writeEndElement();
                w.writeStartElement(null, 'HSN_SAC_CODE', null);  
                if(globalSitePPS.PurchaseSite__c == '30')
                {
                    w.writeCharacters(RVOU.HSNSACCODE);
                }
                else
                {
                    w.writeCharacters('');
                }
                w.writeEndElement();
                w.writeStartElement(null, 'LIST_PRICE', null);  
                System.debug('*** currentRV = '+currentRV.List_Price_Each__c);
                w.writeCharacters(currentRV.List_Price_Each__c != null ? currentRV.List_Price_Each__c+'' : '');
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
    
    public result getSalesParts() {
        result resSalesPart=new result();
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
                w.writeCharacters(RVOU.PARTNUMBER.toUpperCase());
                w.writeEndElement();
                w.writeStartElement(null, 'CATALOG_GROUP', null);  
                w.writeCharacters(RVOU.SALESGROUP);
                w.writeEndElement();
                w.writeStartElement(null, 'SALES_PRICE_GROUP', null);  
                w.writeCharacters(RVOU.SALESPRICEGROUP);
                w.writeEndElement();
                w.writeStartElement(null, 'SOURCING_OPTION', null);  
                w.writeCharacters(bgrLead.Sourcing_Option__c);
                w.writeEndElement();
                w.writeStartElement(null, 'HSN_SAC_CODE', null);
                if(bgrLead.SalesSite__c == '30')
                {
                    w.writeCharacters(RVOU.HSNSACCODE);
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
        resSalesPart.xmlStringResult=xmlOutput;
        return resSalesPart;
    }
    
    public result GetRoutingDetails() {
        result resRouting=new result();
        Dom.Document doc = new Dom.Document();
        result routingStep = RVOU.getRouting();
        List<RV_Valve_Routing_Details__c> lstRDR = new List<RV_Valve_Routing_Details__c>();
        if(routingStep.bResult && routingStep.objResultList.size() > 0)
        {
            for(sObject objResult: routingStep.objResultList)
            {
                lstRDR.add((RV_Valve_Routing_Details__c) objResult);
            }
        }
        List<RV_Work_Guidelines_Details__c> lstGL = new List<RV_Work_Guidelines_Details__c>();
        Result rdGuideLineResult = RVOU.getWorkGuideLines();
        if(rdGuideLineResult.bResult && rdGuideLineResult.objResultList.size() > 0)
        {
            for(sObject objResult: rdGuideLineResult.objResultList)
            {
                RV_Work_Guidelines_Details__c bgrGuideLine = (RV_Work_Guidelines_Details__c)objResult;
                lstGL.add(bgrGuideLine);
                
            }
        }
        if(lstRDR.size()>0)
        { 
            list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = GlobalSiteParametersISPM();
            Xmlstreamwriter xmlW = new Xmlstreamwriter();
            xmlW.writeStartDocument('utf-8','1.0');
            xmlW.writeStartElement(null,'ROUTING_HEAD_LIST', null);
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
                        xmlW.writeCharacters(RVOU.PARTNUMBER.toUpperCase());
                        xmlW.writeEndElement();           
                        xmlW.writeStartElement(null,'ROUTING_OPERATION_LIST',null);
                        for(RV_Valve_Routing_Details__c brRec: lstRDR)
                        {	
                            system.debug(brRec);
                            xmlW.writeStartElement(null,'ROUTING_OPERATION',null);                
                            xmlW.writeStartElement(null,'OPERATION_NO',null);
                            xmlW.writeCharacters(brRec.Operation__c);
                            xmlW.writeEndElement();                 
                            xmlW.writeStartElement(null,'STD_OP_ID',null);
                            xmlW.writeCharacters(brRec.Standard_Operation_Id__c);
                            xmlW.writeEndElement();               
                            xmlW.writeStartElement(null,'OUTSIDE_OP_ITEM',null);
                            string ASSYPARTNO = '';
                            string ControlVal=(string) brRec.Outside_Operation_Item__c;
                            if(ControlVal!=null)
                            {
                                if(ControlVal.contains('[') && ControlVal.contains(']'))
                                {
                                    string  Test_Oper_Desc_val='';
                                    ASSYPARTNO = (string) brRec.Outside_Operation_Item__c;
                                    if(ASSYPARTNO!=null)
                                    {
                                        ASSYPARTNO = ASSYPARTNO.substringBetween('[',']');
                                    }
                                    else
                                    {
                                        Test_Oper_Desc_val = RVOU.mapRVAttr.get(ASSYPARTNO);
                                    }
                                    
                                    String[] arrPTC  =new String[5];
                                    arrPTC=ControlVal.split('\\[');
                                    String strPTC1  = arrPTC[0];
                                    String strPTC2  = arrPTC[1];
                                    String str2SplitOB170 =strPTC2;
                                    String[] arrPTC2  = new String[5];
                                    arrPTC2=str2SplitOB170.split('\\]');
                                    String strPTC4 = '';
                                    if(arrPTC2.size()>1)
                                    {
                                        strPTC4  = arrPTC2[1];
                                    }
                                    else
                                    {
                                        strPTC4 = '';
                                    }
                                    string attributeValue=strPTC1+Test_Oper_Desc_val+strPTC4;
                                    
                                    if(brRec.Outside_Operation_Item__c != null)
                                    {
                                        if(!Test.isRunningTest())
                                        {
                                            xmlW.writeCharacters(RVOU.PARTNUMBER.toUpperCase() + attributeValue);
                                        }
                                    }
                                }
                            }
                            else
                            {
                                xmlW.writeCharacters('');
                            }
                            xmlW.writeEndElement(); 
                            //if(brRec.Operation__c == '0070' || brRec.Operation__c == '70')
                           // {
                                if(lstGL.size()>0)
                                {
                                    xmlW.writeStartElement(null,'ROUTING_OPER_WORK_GUIDE_LIST',null);
                                    for(RV_Work_Guidelines_Details__c bgRec: lstGL)
                                    {
                                        if(brRec.Operation__c == bgRec.Operation__c)
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
                                    }
                                    xmlW.writeEndElement(); //ROUTING_OPER_WORK_GUIDE_LIST end
                                }
                            //}
                            //Guideline Iteration Complete
                            xmlW.writeEndElement(); //ROUTING_OPERATION end
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
    
    public result GetControlPlanDetails() {
        result resCntrl=new result();
        Dom.Document doc = new Dom.Document();
        string OuterMinValue = '';
        string InnerMinValue = '';
        string NominalValue = '';
        string InnerMaxValue = '';
        string OuterMaxValue = '';   
        result rdCntlPln =RVOU.getControlPlan();
        if(rdCntlPln.bResult)
        { 
            list<Global_Site_Part_Parameters_ISPM__c> GlobalSiteParametersISPMList = GlobalSiteParametersISPM(); 
            Xmlstreamwriter xmlW = new Xmlstreamwriter();
            xmlW.writeStartDocument('utf-8','1.0');
            xmlW.writeStartElement(null,'CONTROL_PLAN_MANUF_LIST', null);
            Set<String> toolIdSet = new Set<String>();
            Set<String> dataPointSet = new Set<String>();
            List<RV_Valve_ControlPlan_Details__c> connectionList = new List<RV_Valve_ControlPlan_Details__c>();
            for(sObject sRec: rdCntlPln.objResultList)
            {
                RV_Valve_ControlPlan_Details__c brRec = (RV_Valve_ControlPlan_Details__c)sRec;
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
                        xmlW.writeCharacters(RVOU.PARTNUMBER.toUpperCase());
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
                            RV_Valve_ControlPlan_Details__c brRec = (RV_Valve_ControlPlan_Details__c)sRec;
                            xmlW.writeStartElement(null,'CONTROL_PLAN_LINE',null); // CONTROL_PLAN_LINE start
                            xmlW.writeStartElement(null,'TEST_OPERATION_NO',null); 
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
                            OuterMinValue = String.valueOf(brRec.Outer_Min__c);
                            if(OuterMinValue!=null)
                            {
                                OuterMinValue = OuterMinValue.substringBetween('[',']');
                            }
                            if(string.isBlank(OuterMinValue) || OuterMinValue == null)
                            {
                               if(string.isNotBlank(brRec.Outer_Min__c))
                                    {
                                        xmlW.writeCharacters(String.valueOf(brRec.Outer_Min__c));
                                    }
                            }
                            else
                            {
                                xmlW.writeCharacters(RVOU.mapRVAttr.get(OuterMinValue));
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
                                if(string.isNotBlank(brRec.Inner_Min__c))
                                    {
                                        xmlW.writeCharacters(String.valueOf(brRec.Inner_Min__c));
                                    }
                            }
                            else
                            {
                                xmlW.writeCharacters(RVOU.mapRVAttr.get(InnerMinValue));
                            }          
                            xmlW.writeEndElement();
                            xmlW.writeStartElement(null,'NOMINAL_VALUE',null);
                            NominalValue = String.valueOf(brRec.Nominal_Value__c);
                            if(NominalValue!=null)
                            {
                                NominalValue = NominalValue.substringBetween('[',']');
                            }
                            if(string.isBlank(NominalValue) || NominalValue == null)
                            {
                                if(string.isNotBlank(brRec.Nominal_Value__c))
                                    {
                                        xmlW.writeCharacters(String.valueOf(brRec.Nominal_Value__c));
                                    }
                            }
                            else
                            {
                                xmlW.writeCharacters(RVOU.mapRVAttr.get(NominalValue));
                            }  
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
                            OuterMaxValue = String.valueOf(brRec.Outer_Max__c);
                            if(OuterMaxValue!=null)
                            {
                                OuterMaxValue = OuterMaxValue.substringBetween('[',']');
                            }
                            if(string.isBlank(OuterMaxValue) || OuterMaxValue == null)
                            {
                               if(string.isNotBlank(brRec.Outer_Max__c))
                                    {
                                        xmlW.writeCharacters(String.valueOf(brRec.Outer_Max__c));
                                    }  
                            }
                            else
                            {
                                xmlW.writeCharacters(RVOU.mapRVAttr.get(OuterMaxValue));
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
                                if(string.isNotBlank(brRec.Inner_Max__c))
                                    {
                                        xmlW.writeCharacters(String.valueOf(brRec.Inner_Max__c));
                                    }  
                            }
                            else
                            {
                                if(brRec.Inner_Max__c != null)
                                {
                                    xmlW.writeCharacters(RVOU.mapRVAttr.get(InnerMaxValue));
                                }
                            }                           
                            xmlW.writeEndElement();
                            xmlW.writeStartElement(null,'INSPECTION_CODE',null); 
                            if(brRec.Inspection_Code__c != null)
                            {
                                xmlW.writeCharacters(brRec.Inspection_Code__c);
                            }
                            else
                            {
                                 xmlW.writeCharacters(' ');
                            }
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
                            for(RV_Valve_ControlPlan_Details__c brRec : connectionList)
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
            xmlW.writeEndDocument(); 
            String xmlStringxmlRes = xmlW.getXmlString();
            System.debug('XML is xmlOutput :'+xmlW.getXmlString());     
            xmlW.close();
            string xmldata = doc.toXmlString();
            system.debug('XML is '+xmldata);
            resCntrl.xmlStringResult=xmlStringxmlRes;
        }
        return resCntrl;
    }
    
    public result getPartNumber(){
        result resPartNo=new result();
        return resPartNo;
    }
    
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
            for(Global_Site_Part_Parameters_ISPM__c bgrLead : GlobalSiteParametersISPMList){
                if(bgrLead.PurchaseSite__c != '{null}') 
                {
                    w.writeStartElement(null, 'PURCHASE_PART', null);
                    w.writeStartElement(null, 'CONTRACT', null);
                    w.writeCharacters(bgrLead.PurchaseSite__c);
                    w.writeEndElement();
                    w.writeStartElement(null, 'PART_NO', null);  
                    w.writeCharacters(RVOU.PARTNUMBER.toUpperCase());
                    w.writeEndElement();
                    w.writeStartElement(null, 'DESCRIPTION', null);  
                    //Service Ticket #200752 , RVOU.PARTNUMBERDESC variable stores the description value
                    w.writeCharacters(String.isNotBlank(RVOU.PARTNUMBERDESC)?RVOU.PARTNUMBERDESC.length()<200?RVOU.PARTNUMBERDESC:RVOU.PARTNUMBERDESC.substring(0,200):'');
                    w.writeEndElement();
                    w.writeStartElement(null, 'TEMPLATE_ID', null);  
                    w.writeCharacters(bgrLead.PurchasePartTemplate_ID__c);
                    w.writeEndElement();
                    w.writeStartElement(null, 'UOM', null);  
                    w.writeCharacters(RVOU.PARTUOM);
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