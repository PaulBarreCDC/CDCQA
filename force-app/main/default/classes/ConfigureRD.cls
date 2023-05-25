/**
* @File Name          : ConfigureRD.cls
* @Description        :
* @Author             : ApexIT - SFDC Dev Team
* @Group              :
* @Last Modified By   : Nikhil Arpally
* @Last Modified On   : 11-02-2020
* @Modification Log   :
* Ver       Date            Author                 Modification
* 1.0    13/5/2020   ApexIT - SFDC Dev Team     Initial Version
* 1.1    02 Feb 2021   Rohini Hathi               Ticket # 161642
* 1.2    30 Mar 2021   Rohini Hathi               Service Ticket #200731, typo error
* 1.3    07 Jul 2021   Samriddha M                Service Ticket # 204266, UI Part - Interface Cable does not appear until the user hits save & continue
* 1.4    18 Aug 2021   Rohini Hathi             Service Ticket #205427, added field D3ASRV in RD_Disc_Comp_Mat_Cd, which is based on 3A Sanitary Stds Certification checkbox
**/
public with sharing class ConfigureRD {

    //Added for PDF
    public User oUser {get;set;}
    public string getUserTimeZone(){
        return userinfo.getTimeZone().toString();
    }

    public SBQQ__QuoteLine__c quoteLine {set;get;}
    public Rupture_Disc__c conProd {set; get;}
    public string strQuoteStatus {set;get;}
    public  RDRatingRange rtgRngWrap {set; get;}
    public boolean showsales {get;set;}
    public boolean disableButton {get;set;}
    public  RDComponents cmpWrap {set; get;}
    public  RD_Outputs__c rdOutput {get;set;}
    public RD_Outputs__c[] rdOutlist {get;set;}
    public  RdOutputBaseUtility RDOU {set;get;}
    public string optionalComponents {get;set;}
    public boolean showProductReview{get;set;}
    public boolean showPricing{get;set;}
    public boolean showProductDiagram{get;set;}
    public boolean showProductEngSpl{get;set;}
    public boolean showProductMnfOutputs{get;set;}
    public boolean showProductTroubleSouting{get;set;}
    public string requiredComponents {get;set;}
    public string refURL{get;set;}
    public string selectedTab {set;get;}
    public id quoteLineId {set;get;}
    public product2 prod {set;get;}
    public  string dynamicProdNarrowFilter {set;get;}

    //added by piyush
    public string editModeLable {get;set;}
    public boolean bShowEditButton{get;set;}
    public boolean bShowEditButtonImage{get;set;} //added by piyush
    public string quoteStatus;
    public string configStatus;
    public string defaultQuoteLineView;
    public string QuoteLIneView{get;set;}
    public boolean bShowReturnToProductSelectionButton{get;set;}
    public transient ProductAccessibilityConfig__mdt oPacMetaData;
    public boolean bReadOnlyChceckBox {get;set;}
    public boolean bReadOnlyChceckBoxImage {get;set;} //added by piyush
    public string strURL{get;set;}
    public boolean errOnSaveComp {
        get {
            //Boolean errOnSaveComp = true;
            // if(errOnSaveComp)
            //     return true;
            // else
            //     return true;
            return errOnSaveComp;
        }
        set {
            this.errOnSaveComp=value;
        }
    }
    public ConfigureRD(ApexPages.StandardController controller) {
        //Added for PDF
        for(User u : [Select Id,Name From User Where Id =: userinfo.getUserId()]){
            oUser = u;
        }

		ReorderFlag=false;
        errOnSaveComp = true;
        showsales = False;
        disableButton = False;
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        set<string> profilesetstr = new set<string>();
        profilesetstr.add('System Administrator');
        profilesetstr.add('CDC Engineering');
        profilesetstr.add('CDC Prod. Planning');
        profilesetstr.add('CDC Business Super User');

        if(profilesetstr.contains(profileName )) {
            showsales = True;
            system.debug('=========='+showsales);
        }
        showPricing=false;
        showProductEngSpl=false;
        showProductReview=false;
        showProductDiagram=false;
        showProductEngSpl=false;
        showProductMnfOutputs=false;
        showProductTroubleSouting=false;
        // visibility logic ended
        quoteLineId=ApexPages.currentPage().getParameters().get('qid');
        System.debug('QuoteLine'+quoteLineId);
        if(string.isNotBlank(quoteLineId)) {
            quoteLine=[SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteLineId];
            strQuoteStatus=quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
        }
        disableDic=false;
        disableTop=false;
        //try {
        id RecordID=wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLineId);
        result resConProd=wizardBaseDataProcessor.getObjectDataById(RecordID);
        RDOBUStructWrapper=new List<RdOutputBaseUtility.RDStructureWrapper>();
        if (!resConProd.objResultList.isEmpty())
            conProd= (Rupture_Disc__c) resConProd.objResultList[0];
        else
            conProd=new Rupture_Disc__c();
        strBrand=[select Quote_Line__c,Quote_Line__r.SBQQ__Quote__r.Brand__c from Rupture_Disc__c where id=:conProd.Id].Quote_Line__r.SBQQ__Quote__r.Brand__c;
        //Load Data for Ratting and Range
        if(conProd.Product__c!=null && conProd.Size__c!=null && conProd.Seat__c!=null)
            rtgRngWrap = new RDRatingRange(conProd,conProd.Product__c,SZC);
        // else
        //     rtgRngWrap = new RDRatingRange();
        string strWithStand='N';
        if(conProd.Rating_and_Range_Flag__c) {
            if(String.isNotBlank(rtgRngWrap.RGRAT1)) {
                rtgRngWrap.pressureRangeOptions=rtgRngWrap.mapRGTYP1.get(rtgRngWrap.RGRAT1);
                System.debug('rtgRngWrap.pressureRangeOptions --> ConfigureRD --> '+rtgRngWrap.pressureRangeOptions);
            }
            if(String.isNotBlank(rtgRngWrap.VGRAT1)) {
                rtgRngWrap.vacuumRangeOptions=rtgRngWrap.mapVGTYP1.get(rtgRngWrap.VGRAT1);
            }
            System.debug('Nikhil: ' + strWithStand);
            if ((!String.IsBlank(conProd.Vacuum_Withstand__c) && conProd.Vacuum_Withstand__c!='No Requirements') ||
                (!String.isBlank(conProd.Pressure_Withstand__c) && conProd.Pressure_Withstand__c!='No Requirements')) {
                    strWithStand='Y';
                }
            decimal decRG3DRT=unitConversions.RoundNormal(conProd.RG3DRT__c,2);
            decimal decTEMP=unitConversions.RoundNormal(conprod.Converted_Temperature_Setting__c,2);
            decimal decPress=0;
            if (decPBrustConvertedValue!=null)
                decPress=decPBrustConvertedValue;
            string strMCDCheck='';
            if(String.IsBlank(conProd.Disc_Material_of_Construction__c) && String.isBlank(MCD)) {
                strMCDCheck='000';
            } else {
                if(String.isNotBlank(MCD)) {
                    strMCDCheck=MCD;
                } else {
                    strMCDCheck=conProd.Disc_Material_of_Construction__c;
                }
            }
            decimal decBMRCHECK=9999;
            boolean checkMCXPrd=false;
            system.debug('decBMRCHECK++++'+conProd.BMRCHECK__c);
            if(conProd.BMRCHECK__c!=null) {
                decBMRCHECK=unitConversions.RoundNormal(conProd.BMRCHECK__c,2);
            } else {
                if(conProd.Product__c=='MCX'||conProd.Product__c=='M9T') {
                    if(conProd.Components_Flag__c) {
                        if(rtgRngWrap.BMRCHECK!=null)
                            decBMRCHECK=rtgRngWrap.BMRCHECK;
                        checkMCXPrd=true;
                    }
                }
            }
            decimal decTMRCHECK=9999;
            boolean checkSTDPrd=false;
            system.debug('decTMRCHECK++++'+conProd.TMRCHECK__c);
            if(conProd.TMRCHECK__c!=null) {
                decTMRCHECK=unitConversions.RoundNormal(conProd.TMRCHECK__c,2);
            } else {
                if(conProd.Product__c=='LSS'||conProd.Product__c=='STD'||conProd.Product__c=='LST') {
                    if(conProd.Components_Flag__c) {
                        if(rtgRngWrap.TMRCHECK!=null)
                            decTMRCHECK=rtgRngWrap.TMRCHECK;
                        checkSTDPrd=true;
                    }
                }
            }
            System.debug('NACE Value -->'+conProd.NACE__c);
            //Service Ticket #205427, added parameter for 3A Sanitary Stds
            cmpWrap=new  RDComponents(conProd.Product__c,conProd.Size__c,conProd.Seat__c,conProd.DSCVAR__c,strMCDCheck,decBMRCHECK,decTMRCHECK,strWithStand,decTEMP,decPress,conProd.Non_Fragmenting_Design_Required__c?'Yes':'No',conProd.Atex_Certificate__c?'Yes':'No',(!String.IsBlank(conProd.NACE__c)&&conProd.NACE__c!='N')?'Yes':'No', conProd.X3A_Sanitary_Standards__c); 
            if(checkMCXPrd) {
                cmpWrap.checkTypeB(MCD,decBMRCHECK);
            }
            disableButton = (!showsales) && conProd.Quote_Descriptions_Override__c;
            if(cmpWrap.reqComps.contains('Material_Top_Section__c') && (!String.IsBlank(conProd.Disc_Material_of_Construction__c ) && conProd.Disc_Material_of_Construction__c != '-')) {
                conProd.Material_Top_Section__c=conProd.Disc_Material_of_Construction__c;
                disableTop=true;
            }
            if(cmpWrap.reqComps.contains('Material_Top_Section2__c') && (!String.IsBlank(conProd.Disc_Material_of_Construction__c) && conProd.Disc_Material_of_Construction__c != '-')) {
                conProd.Material_Top_Section2__c=conProd.Disc_Material_of_Construction__c;
                disableTop=true;
            }
            if(cmpWrap.reqComps.contains('Material_Disc__c') &&  (!String.IsBlank(conProd.Disc_Material_of_Construction__c) && conProd.Disc_Material_of_Construction__c != '-')) {
                system.debug('ggggggg1gggggggggggggggggggg');
                conProd.Material_Disc__c=conProd.Disc_Material_of_Construction__c;
                disableDic=true;
            }
            if(disableDic||disableTop) {
                calculateRG3DRT();
            }
        }
       // BDIRecords=new List<RD_Integral_BDI_Table__c>();
        BDIRecords=BDIList();
        System.debug('BDIRecords: ' + BDIRecords);
        mapDocData=new Map<String,string>();
        mapIFSAttributes=new Map<String,string>();
        mapNonIFSAttributes=new Map<String,string>();
        System.debug('Record ID'+conProd.Id);
        if(string.isNotBlank(conprod.Product__c))
            rdPosLst= rdPosBaseList();
        else
            rdPosLst=new List<RD_tblPosCalRating__c>();
        if (conProd.Finish_Configuration_Flag__c) {
            System.debug('Finish_Configuration_Flag Test Inside: ');
            RDOU=new RdOutputBaseUtility(recordID);
            // RDOBUStructWrapper=RDOU.getConsolidatedStructureDetails();
            // RDOU.mapRDAttr.putAll(rtgRngWrap.mapRatingValues1);
            // for(string str:lookUpAttr) {
            //     if(RDOU.mapRDAttr.containsKey(str)) {
            //         if(RDOU.mapRDAttr.get(str)!=null)
            //             mapIFSAttributes.put(str,RDOU.mapRDAttr.get(str));
            //         else
            //         mapIFSAttributes.put(str,'');
            //         //System.debug('Final values : ' +RDOU.mapRDAttr.get(str));
            //     } else {
            //         mapIFSAttributes.put(str,'');
            //     }
            // }
        } else {
            System.debug('Finish_Configuration_Flag Test Outside: ');
        }

        //Load Data for Diagrams
        /*rdDiagramList=new List <RD_Drawings__c>();
if (!conProd.Drawing_Outside_Config__c) {
getDiaData();
if(rdDiagramList.size()==0) {
//result abc=loadDiagramData();
}
}*/
        //RD_Outputs__c[] rdOutputList=new list<RD_Outputs__c>();
        transient RD_Outputs__c[] rdOutputList=[Select Base_Lead_Time_GP__c,Base_Lead_Time_GCI__c,Base_Lead_Time_CDC__c,Base_Lead_Time_40__c,
                                      Adder_Lead_Time_GP__c,Adder_Lead_Time_GCI__c,Adder_Lead_Time_CDC__c,Adder_Lead_Time_40__c,
                                      Comp_Lead_Time_GP__c,Comp_Lead_Time_GCI__c,Comp_Lead_Time_CDC__c,Comp_Lead_Time_40__c,
                                      Total_Lead_Time_CDC__c,Total_Lead_Time_GP__c,Total_Lead_Time_GCI__c,Total_Lead_Time_GP_ORD__c,
                                      Total_Lead_Time_40__c,OW__c,OW_Override__c,OA__c,OA_Override__c,OB__c,OB_Override__c,ORP__c,
                                      ORP_Override__c,ORV__c,ORV_Override__c,Total_Lead_Time_CDC_ORD__c,Total_Lead_Time_GCI_ORD__c,
                                      LABMAT__c,LABDSC__c,Total_Lead_Time_40_ORD__c,ORP010__c,ORP015__c,ORP027__c,ORV010__c,ORV020__c,ORP020__c,ORP025__c,ORV025__c,
                                      ORV015__c,ORV027__c,SRV__c ,SRP__c
                                      FROM RD_Outputs__c WHERE RD_Outputs_Relation_Field__c=:conProd.Id order by createddate asc limit 1];
        System.debug('RD_Outputs__c: ' + rdOutputList);
        rdOutlist=new List<RD_Outputs__c>();
        rdOutput=new RD_Outputs__c();
        if(rdOutputList.size()>0)
            rdOutput=rdOutputList[0];
        rdOutlist.add(rdOutput);

        // Load data for Pricing
        //getPricingData();
        //getDiaData();
        //getCost();
        //Load Data for Components
        system.debug(disableButton);
        // } catch (Exception e) {
        //     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Page Error'));
        // }
        disableButton = true; // added by piyush
        // ######### added by piyush
        editModeLable = 'Edit';
        quoteStatus = quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
        system.debug('conProd --> Configuration_Complete__c ' + conProd.Finish_Configuration_Flag__c);
        system.debug('conProd Quote_Descriptions_Override__c --> ' + conProd.Quote_Descriptions_Override__c);

        if(conProd.Finish_Configuration_Flag__c){
            if(conProd.Quote_Descriptions_Override__c){
                // complete with override
                configStatus = 'Complete with Override(s)';

            }else{
                // complete no override
                configStatus = 'Complete No Overrides';
            }
        }else{
            configStatus = 'Incomplete';
            // incomplete
        }
        system.debug('quoteStatus----> ' + quoteStatus);
        system.debug('configStatus----> ' + configStatus);
        oPacMetaData = fetchCurrentProductAccessibility( quoteStatus , configStatus);
        system.debug('oPacMetaData----> ' + oPacMetaData);
        bShowEditButton = false;
        bReadOnlyChceckBox = false;
        bShowReturnToProductSelectionButton = true;
        defaultQuoteLineView = oPacMetaData.Default_View__c;
        QuoteLIneView = oPacMetaData.View__c;

        system.debug('QuoteLIneView----> ' + QuoteLIneView);
        if(QuoteLIneView == 'Editable'){
            bShowEditButton = true;
            if(defaultQuoteLineView == 'Editable'){
                disableButton = false;
                bShowEditButton = false;
            }else{
                disableButton = true;
            }

        }else if(QuoteLIneView == 'Read Only'){
            bReadOnlyChceckBox = true;
        }
        system.debug('bShowEditButton----> ' + bShowEditButton);


        //added by piyush
        bShowEditButtonImage = bShowEditButton;
        bReadOnlyChceckBoxImage = bReadOnlyChceckBox;
        if(profileName != 'CDC Engineering' &&  profileName != 'System Administrator'){
            bShowEditButtonImage = false;
            bReadOnlyChceckBoxImage = true;

            if (conProd.Diagram_Override__c == true ||
                conProd.Price_Override__c == true ||
                conProd.Lead_Time_Override__c == true ||
                conProd.Build_Cost_Override__c == true ||
                conProd.Quote_Descriptions_Override__c == true
               ){
                   disableButton = true;
                   bShowEditButton = false;
               }

        }



        //----------------piyush----------------

        if (conProd.Finish_Configuration_Flag__c) {
            selectedTab = 'ProductReview';
            getTabData();

        }

    }


	//Reorder purpose Code Start
	public Boolean ReorderFlag{get;set;}

    public ConfigureRD (Id quoteLineId)
    {
        //Added for PDF
        for(User u : [Select Id,Name From User Where Id =: userinfo.getUserId()]){
            oUser = u;
        }

        errOnSaveComp = true;
        showsales = False;
        disableButton = False;
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        set<string> profilesetstr = new set<string>();
        profilesetstr.add('System Administrator');
        profilesetstr.add('CDC Engineering');
        profilesetstr.add('CDC Prod. Planning');
        profilesetstr.add('CDC Business Super User');

        if(profilesetstr.contains(profileName )) {
            showsales = True;
            system.debug('=========='+showsales);
        }
        showPricing=false;
        showProductEngSpl=false;
        showProductReview=false;
        showProductDiagram=false;
        showProductEngSpl=false;
        showProductMnfOutputs=false;
        showProductTroubleSouting=false;
        // visibility logic ended
        //quoteLineId=ApexPages.currentPage().getParameters().get('qid');
        System.debug('QuoteLine'+quoteLineId);
        if(string.isNotBlank(quoteLineId)) {
            quoteLine=[SELECT Id,SBQQ__Quote__c,SBQQ__Quote__r.SBQQ__Status__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteLineId];
            strQuoteStatus=quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
        }
        disableDic=false;
        disableTop=false;
        //try {
        id RecordID=wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLineId);
        result resConProd=wizardBaseDataProcessor.getObjectDataById(RecordID);
        RDOBUStructWrapper=new List<RdOutputBaseUtility.RDStructureWrapper>();
        if (!resConProd.objResultList.isEmpty())
            conProd= (Rupture_Disc__c) resConProd.objResultList[0];
        else
            conProd=new Rupture_Disc__c();
        strBrand=[select Quote_Line__c,Quote_Line__r.SBQQ__Quote__r.Brand__c from Rupture_Disc__c where id=:conProd.Id].Quote_Line__r.SBQQ__Quote__r.Brand__c;
        //Load Data for Ratting and Range
        if(conProd.Product__c!=null && conProd.Size__c!=null && conProd.Seat__c!=null)
            rtgRngWrap = new RDRatingRange(conProd,conProd.Product__c,SZC);
        else
            rtgRngWrap = new RDRatingRange();
        string strWithStand='N';
        if(conProd.Rating_and_Range_Flag__c) {
            if(String.isNotBlank(rtgRngWrap.RGRAT1)) {
                rtgRngWrap.pressureRangeOptions=rtgRngWrap.mapRGTYP1.get(rtgRngWrap.RGRAT1);
                System.debug('rtgRngWrap.pressureRangeOptions --> ConfigureRD --> '+rtgRngWrap.pressureRangeOptions);
            }
            if(String.isNotBlank(rtgRngWrap.VGRAT1)) {
                rtgRngWrap.vacuumRangeOptions=rtgRngWrap.mapVGTYP1.get(rtgRngWrap.VGRAT1);
            }
            System.debug('Nikhil: ' + strWithStand);
            if ((!String.IsBlank(conProd.Vacuum_Withstand__c) && conProd.Vacuum_Withstand__c!='No Requirements') ||
                (!String.isBlank(conProd.Pressure_Withstand__c) && conProd.Pressure_Withstand__c!='No Requirements')) {
                    strWithStand='Y';
                }
            decimal decRG3DRT=unitConversions.RoundNormal(conProd.RG3DRT__c,2);
            decimal decTEMP=unitConversions.RoundNormal(conprod.Converted_Temperature_Setting__c,2);
            decimal decPress=0;
            if (decPBrustConvertedValue!=null)
                decPress=decPBrustConvertedValue;
            string strMCDCheck='';
            if(String.IsBlank(conProd.Disc_Material_of_Construction__c) && String.isBlank(MCD)) {
                strMCDCheck='000';
            } else {
                if(String.isNotBlank(MCD)) {
                    strMCDCheck=MCD;
                } else {
                    strMCDCheck=conProd.Disc_Material_of_Construction__c;
                }
            }
            decimal decBMRCHECK=9999;
            boolean checkMCXPrd=false;
            system.debug('decBMRCHECK++++'+conProd.BMRCHECK__c);
            if(conProd.BMRCHECK__c!=null) {
                decBMRCHECK=unitConversions.RoundNormal(conProd.BMRCHECK__c,2);
            } else {
                if(conProd.Product__c=='MCX'||conProd.Product__c=='M9T') {
                    if(conProd.Components_Flag__c) {
                        if(rtgRngWrap.BMRCHECK!=null)
                            decBMRCHECK=rtgRngWrap.BMRCHECK;
                        checkMCXPrd=true;
                    }
                }
            }
            decimal decTMRCHECK=9999;
            boolean checkSTDPrd=false;
            system.debug('decTMRCHECK++++'+conProd.TMRCHECK__c);
            if(conProd.TMRCHECK__c!=null) {
                decTMRCHECK=unitConversions.RoundNormal(conProd.TMRCHECK__c,2);
            } else {
                if(conProd.Product__c=='LSS'||conProd.Product__c=='STD'||conProd.Product__c=='LST') {
                    if(conProd.Components_Flag__c) {
                        if(rtgRngWrap.TMRCHECK!=null)
                            decTMRCHECK=rtgRngWrap.TMRCHECK;
                        checkSTDPrd=true;
                    }
                }
            }
            System.debug('NACE Value -->'+conProd.NACE__c);
            //Service Ticket #205427, added parameter for 3A Sanitary Stds
            cmpWrap=new  RDComponents(conProd.Product__c,conProd.Size__c,conProd.Seat__c,conProd.DSCVAR__c,strMCDCheck,decBMRCHECK,decTMRCHECK,strWithStand,decTEMP,decPress,conProd.Non_Fragmenting_Design_Required__c?'Yes':'No',conProd.Atex_Certificate__c?'Yes':'No',(!String.IsBlank(conProd.NACE__c)&&conProd.NACE__c!='N')?'Yes':'No', conProd.X3A_Sanitary_Standards__c);
            if(checkMCXPrd) {
                cmpWrap.checkTypeB(MCD,decBMRCHECK);
            }
            disableButton = (!showsales) && conProd.Quote_Descriptions_Override__c;
            if(cmpWrap.reqComps.contains('Material_Top_Section__c') && (!String.IsBlank(conProd.Disc_Material_of_Construction__c ) && conProd.Disc_Material_of_Construction__c != '-')) {
                conProd.Material_Top_Section__c=conProd.Disc_Material_of_Construction__c;
                disableTop=true;
            }
            if(cmpWrap.reqComps.contains('Material_Top_Section2__c') && (!String.IsBlank(conProd.Disc_Material_of_Construction__c) && conProd.Disc_Material_of_Construction__c != '-')) {
                conProd.Material_Top_Section2__c=conProd.Disc_Material_of_Construction__c;
                disableTop=true;
            }
            if(cmpWrap.reqComps.contains('Material_Disc__c') &&  (!String.IsBlank(conProd.Disc_Material_of_Construction__c) && conProd.Disc_Material_of_Construction__c != '-')) {
                system.debug('ggggggg1gggggggggggggggggggg');
                conProd.Material_Disc__c=conProd.Disc_Material_of_Construction__c;
                disableDic=true;
            }
            if(disableDic||disableTop) {
                calculateRG3DRT();
            }
        }
        BDIRecords=BDIList();
        System.debug('BDIRecords: ' + BDIRecords);
        mapDocData=new Map<String,string>();
        mapIFSAttributes=new Map<String,string>();
        mapNonIFSAttributes=new Map<String,string>();
        System.debug('Record ID'+conProd.Id);
        if(string.isNotBlank(conprod.Product__c))
            rdPosLst= rdPosBaseList();
        else
            rdPosLst=new List<RD_tblPosCalRating__c>();
        if (conProd.Finish_Configuration_Flag__c) {
            System.debug('Finish_Configuration_Flag Test Inside: ');
            RDOU=new RdOutputBaseUtility(recordID);
        } else {
            System.debug('Finish_Configuration_Flag Test Outside: ');
        }

        //RD_Outputs__c[] rdOutputList=new list<RD_Outputs__c>();
        RD_Outputs__c[] rdOutputList=[Select Base_Lead_Time_GP__c,Base_Lead_Time_GCI__c,Base_Lead_Time_CDC__c,Base_Lead_Time_40__c,
                                      Adder_Lead_Time_GP__c,Adder_Lead_Time_GCI__c,Adder_Lead_Time_CDC__c,Adder_Lead_Time_40__c,
                                      Comp_Lead_Time_GP__c,Comp_Lead_Time_GCI__c,Comp_Lead_Time_CDC__c,Comp_Lead_Time_40__c,
                                      Total_Lead_Time_CDC__c,Total_Lead_Time_GP__c,Total_Lead_Time_GCI__c,Total_Lead_Time_GP_ORD__c,
                                      Total_Lead_Time_40__c,OW__c,OW_Override__c,OA__c,OA_Override__c,OB__c,OB_Override__c,ORP__c,
                                      ORP_Override__c,ORV__c,ORV_Override__c,Total_Lead_Time_CDC_ORD__c,Total_Lead_Time_GCI_ORD__c,
                                      LABMAT__c,LABDSC__c,Total_Lead_Time_40_ORD__c,ORP010__c,ORP015__c,ORP027__c,ORV010__c,ORV020__c,ORP020__c,ORP025__c,ORV025__c,
                                      ORV015__c,ORV027__c,SRV__c ,SRP__c,RD_Outputs_Relation_Field__c
                                      FROM RD_Outputs__c WHERE RD_Outputs_Relation_Field__c=:conProd.Id];
        System.debug('RD_Outputs__c: ' + rdOutputList);
        rdOutlist=new List<RD_Outputs__c>();
        rdOutput=new RD_Outputs__c();
        if(rdOutputList.size()>0)
            rdOutput=rdOutputList[0];
        rdOutlist.add(rdOutput);

        if(rdOutput.RD_Outputs_Relation_Field__c == null)
        {
               rdOutput.RD_Outputs_Relation_Field__c = conProd.Id;
        }

        system.debug(disableButton);
        disableButton = true; // added by piyush
        // ######### added by piyush
        editModeLable = 'Edit';
        quoteStatus = quoteLine.SBQQ__Quote__r.SBQQ__Status__c;
        system.debug('conProd --> Configuration_Complete__c ' + conProd.Finish_Configuration_Flag__c);
        system.debug('conProd Quote_Descriptions_Override__c --> ' + conProd.Quote_Descriptions_Override__c);

        if(conProd.Finish_Configuration_Flag__c){
            if(conProd.Quote_Descriptions_Override__c){
                // complete with override
                configStatus = 'Complete with Override(s)';

            }else{
                // complete no override
                configStatus = 'Complete No Overrides';
            }
        }else{
            configStatus = 'Incomplete';
            // incomplete
        }
        system.debug('quoteStatus----> ' + quoteStatus);
        system.debug('configStatus----> ' + configStatus);
        oPacMetaData = fetchCurrentProductAccessibility( quoteStatus , configStatus);
        system.debug('oPacMetaData----> ' + oPacMetaData);
        bShowEditButton = false;
        bReadOnlyChceckBox = false;
        bShowReturnToProductSelectionButton = true;
        defaultQuoteLineView = oPacMetaData.Default_View__c;
        QuoteLIneView = oPacMetaData.View__c;

        system.debug('QuoteLIneView----> ' + QuoteLIneView);
        if(QuoteLIneView == 'Editable'){
            bShowEditButton = true;
            if(defaultQuoteLineView == 'Editable'){
                disableButton = false;
                bShowEditButton = false;
            }else{
                disableButton = true;
            }

        }else if(QuoteLIneView == 'Read Only'){
            bReadOnlyChceckBox = true;
        }
        system.debug('bShowEditButton----> ' + bShowEditButton);

        //added by piyush
        bShowEditButtonImage = bShowEditButton;
        bReadOnlyChceckBoxImage = bReadOnlyChceckBox;
        if(profileName != 'CDC Engineering' &&  profileName != 'System Administrator'){
            bShowEditButtonImage = false;
            bReadOnlyChceckBoxImage = true;

            if (conProd.Diagram_Override__c == true ||
                conProd.Price_Override__c == true ||
                conProd.Lead_Time_Override__c == true ||
                conProd.Build_Cost_Override__c == true ||
                conProd.Quote_Descriptions_Override__c == true
               ){
                   disableButton = true;
                   bShowEditButton = false;
               }
        }
        //----------------piyush----------------

        if (conProd.Finish_Configuration_Flag__c) {
            selectedTab = 'ProductReview';
            getTabData();
        }
    }

	//Reorder purpose Code End

    public pageReference goBackToQuote() {
        Id qID = [SELECT Id,SBQQ__Quote__c FROM SBQQ__QuoteLine__c  WHERE id = :quotelineId].SBQQ__Quote__c;
        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        system.debug('$$$Back URl:'+qID);
        if(userinfo.IsPortalEnabled){
            strURL =  '/s/detail/'+qID ;
        }else{
            strURL = '/lightning/r/SBQQ__Quote__c/'+qID+'/view';
        }
        return null;
    }

    private ProductAccessibilityConfig__mdt fetchCurrentProductAccessibility(string sQuoteStatus, string sConfigStatus){
        ProductAccessibilityConfig__mdt oPac;
        system.debug('meta --> ' + UtilityHelper.self.lstProductAccessibilityConfigs);
        for(ProductAccessibilityConfig__mdt pac : UtilityHelper.self.lstProductAccessibilityConfigs){
            list<string> lstQuoteStatus = pac.Quote_Status__c.split(';');
            if(lstQuoteStatus.contains(sQuoteStatus)){
                if(pac.Config_Status__c == 'All' && oPac == null){
                    oPac = pac;
                }else{
                    if(pac.Config_Status__c == sConfigStatus){
                        oPac = pac;
                    }
                }
            }
        }

        return oPac == null ? new ProductAccessibilityConfig__mdt() : oPac;
    }


    public PageReference EnableEditMode(){
        disableButton = !disableButton;
        if(editModeLable == 'Edit'){
            editModeLable = 'Cancel';
            strURL = '/apex/ConfigureProductScreen?qid=' + quoteLine.Id;

        }else{
            editModeLable = 'Edit';
            strURL = '';
        }
        return null;
    }



    public Boolean showCF {
        get {
            Boolean showCF = false;
            if(conProd.Evaluation_Per__c == 'evalPerNone' || conProd.Evaluation_Per__c == 'ASME Gas/Vapor' || conProd.Evaluation_Per__c == 'ASME Water' || conProd.Evaluation_Per__c == 'ASME Steam' || conProd.Evaluation_Per__c == 'API Gas/Vapor' || conProd.Evaluation_Per__c == 'API Liquid' || conProd.Evaluation_Per__c == 'API Steam' || conProd.Evaluation_Per__c == 'ISO Gas/Vapor' || conProd.Evaluation_Per__c == 'ISO Liquid' || conProd.Evaluation_Per__c == 'ISO Dry Steam' || conProd.Evaluation_Per__c == 'ISO Wet Steam'){
                showCF = true;
            }
            return showCF;
        }
        set {
            this.showCF=value;
        }
    }

    public Boolean showMWROSH {
        get {
            Boolean showMWROSH = false;
            if(conProd.Evaluation_Per__c == 'evalPerNone' || conProd.Evaluation_Per__c == 'ASME Gas/Vapor' || conProd.Evaluation_Per__c == 'ASME Water' || conProd.Evaluation_Per__c == 'ASME Steam' || conProd.Evaluation_Per__c == 'API Gas/Vapor' || conProd.Evaluation_Per__c == 'API Liquid' || conProd.Evaluation_Per__c == 'API Steam' || conProd.Evaluation_Per__c == 'ISO Gas/Vapor' || conProd.Evaluation_Per__c == 'ISO Liquid' || conProd.Evaluation_Per__c == 'ISO Dry Steam' || conProd.Evaluation_Per__c == 'ISO Wet Steam' || conProd.Evaluation_Per__c == 'Fauske 2 Phase Gas-Liquid' || conProd.Evaluation_Per__c == 'Fauske 2 Phase Vapor-Liquid'){
                showMWROSH = true;
            }
            return showMWROSH;
        }
        set {
            this.showMWROSH=value;
        }
    }

    public Boolean showFlowRateAndRelivingPressure {
        get {
            Boolean showFlowRateAndRelivingPressure = false;
            if(conProd.Evaluation_Per__c == 'evalPerNone' || conProd.Evaluation_Per__c == 'ASME Gas/Vapor' || conProd.Evaluation_Per__c == 'ASME Water' || conProd.Evaluation_Per__c == 'ASME Steam' || conProd.Evaluation_Per__c == 'API Gas/Vapor' || conProd.Evaluation_Per__c == 'API Liquid' || conProd.Evaluation_Per__c == 'API Steam' || conProd.Evaluation_Per__c == 'ISO Gas/Vapor' || conProd.Evaluation_Per__c == 'ISO Liquid' || conProd.Evaluation_Per__c == 'ISO Dry Steam' || conProd.Evaluation_Per__c == 'ISO Wet Steam' || conProd.Evaluation_Per__c == 'Fauske 2 Phase Gas-Liquid' || conProd.Evaluation_Per__c == 'Fauske 2 Phase Vapor-Liquid' || conProd.Evaluation_Per__c == 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' || conProd.Evaluation_Per__c == 'Fauske All Liquid Flashing'){
                showFlowRateAndRelivingPressure = true;
            }
            return showFlowRateAndRelivingPressure;
        }
        set {
            this.showFlowRateAndRelivingPressure=value;
        }
    }

    /*public Boolean showEnterRelievingPressureValueunits {
get {
Boolean showEnterRelievingPressureValueunits = false;
if(){
showEnterRelievingPressureValueunits = true;
}
return showEnterRelievingPressureValueunits;
}
set {
this.showPresTempValUnits=value;
}
}*/

    public Boolean showPresTempValUnits {
        get {
            Boolean showPresTempValUnits = false;
            if(conProd.Evaluation_Per__c == 'ASME Gas/Vapor' || conProd.Evaluation_Per__c == 'API Gas/Vapor' || conProd.Evaluation_Per__c == 'API Steam' || conProd.Evaluation_Per__c == 'ISO Gas/Vapor' || conProd.Evaluation_Per__c == 'ISO Dry Steam' || conProd.Evaluation_Per__c == 'Fauske 2 Phase Gas-Liquid' || conProd.Evaluation_Per__c == 'Fauske 2 Phase Vapor-Liquid' || conProd.Evaluation_Per__c == 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' || conProd.Evaluation_Per__c == 'Fauske All Liquid Flashing' || conProd.Evaluation_Per__c == 'ISO Wet Steam' ){
                showPresTempValUnits = true;
            }
            return showPresTempValUnits;
        }
        set {
            this.showPresTempValUnits=value;
        }
    }

    public Boolean showDenSpecificVolSpecficGravity {
        get {
            Boolean showDenSpecificVolSpecficGravity = false;
            if(conProd.Evaluation_Per__c == 'ASME Water' || conProd.Evaluation_Per__c == 'API Liquid' || conProd.Evaluation_Per__c == 'ISO Liquid'){
                showDenSpecificVolSpecficGravity = true;
            }
            return showDenSpecificVolSpecficGravity;
        }
        set {
            this.showDenSpecificVolSpecficGravity=value;
        }
    }

    public Boolean showViscosity {
        get {
            Boolean showViscosity = false;
            if(conProd.Evaluation_Per__c == 'API Liquid' || conProd.Evaluation_Per__c == 'ISO Liquid' || conProd.Evaluation_Per__c == 'API Omega Method Subcooled Liquid' || conProd.Evaluation_Per__c == 'API Omega Method 2 Phase Flashing or Nonflashing'){
                showViscosity = true;
            }
            return showViscosity;
        }
        set {
            this.showViscosity=value;
        }
    }

    public Boolean showDryWetSteam {
        get {
            Boolean showDryWetSteam = false;
            if(conProd.Evaluation_Per__c == 'ISO Wet Steam'){
                showDryWetSteam = true;
            }
            return showDryWetSteam;
        }
        set {
            this.showDryWetSteam=value;
        }
    }

    public Boolean showSpecificVolInlet {
        get {
            Boolean showSpecificVolInlet = false;
            if(conProd.Evaluation_Per__c == 'API Omega Method 2 Phase Flashing or Nonflashing'){
                showSpecificVolInlet = true;
            }
            return showSpecificVolInlet;
        }
        set {
            this.showSpecificVolInlet=value;
        }
    }

    public Boolean showDenInlet {
        get {
            Boolean showDenInlet = false;
            if(conProd.Evaluation_Per__c == 'API Omega Method Subcooled Liquid'){
                showDenInlet = true;
            }
            return showDenInlet;
        }
        set {
            this.showDenInlet=value;
        }
    }

    public Boolean showSpecificVol90InletPressure {
        get {
            Boolean showSpecificVol90InletPressure = false;
            if(conProd.Evaluation_Per__c == 'API Omega Method 2 Phase Flashing or Nonflashing'){
                showSpecificVol90InletPressure = true;
            }
            return showSpecificVol90InletPressure;
        }
        set {
            this.showSpecificVol90InletPressure=value;
        }
    }

    public Boolean showSatPressureInletTemp {
        get {
            Boolean showSatPressureInletTemp = false;
            if(conProd.Evaluation_Per__c == 'API Omega Method Subcooled Liquid'){
                showSatPressureInletTemp = true;
            }
            return showSatPressureInletTemp;
        }
        set {
            this.showSatPressureInletTemp=value;
        }
    }

    public Boolean showDen90SatPressure {
        get {
            Boolean showDen90SatPressure = false;
            if(conProd.Evaluation_Per__c == 'API Omega Method Subcooled Liquid'){
                showDen90SatPressure = true;
            }
            return showDen90SatPressure;
        }
        set {
            this.showDen90SatPressure=value;
        }
    }

    public Boolean showStaGasVaporQual {
        get {
            Boolean showStaGasVaporQual = false;
            if(conProd.Evaluation_Per__c == 'Fauske 2 Phase Gas-Liquid' || conProd.Evaluation_Per__c == 'Fauske 2 Phase Vapor-Liquid' || conProd.Evaluation_Per__c == 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid'){
                showStaGasVaporQual = true;
            }
            return showStaGasVaporQual;
        }
        set {
            this.showStaGasVaporQual=value;
        }
    }

    public Boolean showLiquidDensity {
        get {
            Boolean showLiquidDensity = false;
            if(conProd.Evaluation_Per__c == 'Fauske 2 Phase Gas-Liquid' || conProd.Evaluation_Per__c == 'Fauske All Liquid Flashing' || conProd.Evaluation_Per__c == 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid'){
                showLiquidDensity = true;
            }
            return showLiquidDensity;
        }
        set {
            this.showLiquidDensity=value;
        }
    }

    public Boolean showStaVaporDensity {
        get {
            Boolean showStaVaporDensity = false;
            if(conProd.Evaluation_Per__c == 'Fauske 2 Phase Vapor-Liquid' || conProd.Evaluation_Per__c == 'Fauske All Liquid Flashing' || conProd.Evaluation_Per__c == 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid'){
                showStaVaporDensity = true;
            }
            return showStaVaporDensity;
        }
        set {
            this.showStaVaporDensity=value;
        }
    }

    public Boolean showLatHeatVaporLiqSpecificHeat {
        get {
            Boolean showLatHeatVaporLiqSpecificHeat = false;
            if(conProd.Evaluation_Per__c == 'Fauske 2 Phase Vapor-Liquid' || conProd.Evaluation_Per__c == 'Fauske All Liquid Flashing' || conProd.Evaluation_Per__c == 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid'){
                showLatHeatVaporLiqSpecificHeat = true;
            }
            return showLatHeatVaporLiqSpecificHeat;
        }
        set {
            this.showLatHeatVaporLiqSpecificHeat=value;
        }
    }

    public Boolean showStaGasPartPressureUnits {
        get {
            Boolean showStaGasPartPressureUnits = false;
            if(conProd.Evaluation_Per__c == 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid'){
                showStaGasPartPressureUnits = true;
            }
            return showStaGasPartPressureUnits;
        }
        set {
            this.showStaGasPartPressureUnits=value;
        }
    }

    public Boolean showVaporPresStaTemp {
        get {
            Boolean showVaporPresStaTemp = false;
            if(conProd.Evaluation_Per__c == 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid' || conProd.Evaluation_Per__c == 'Fauske All Liquid Flashing'){
                showVaporPresStaTemp = true;
            }
            return showVaporPresStaTemp;
        }
        set {
            this.showVaporPresStaTemp=value;
        }
    }

    public Boolean showIsentrophicCoGasVapo{
        get {
            Boolean showIsentrophicCoGasVapo = false;
            if(conProd.Evaluation_Per__c == 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid'){
                showIsentrophicCoGasVapo = true;
            }
            return showIsentrophicCoGasVapo;
        }
        set {
            this.showIsentrophicCoGasVapo=value;
        }
    }

    public Boolean showMoleWeightGasVapor{
        get {
            Boolean showMoleWeightGasVapor = false;
            if(conProd.Evaluation_Per__c == 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid'){
                showMoleWeightGasVapor = true;
            }
            return showMoleWeightGasVapor;
        }
        set {
            this.showMoleWeightGasVapor=value;
        }
    }

    public List<RD_tblPosCalRating__c> rdPosLst{set;get;}
    public map<string,string> mapDocData{get;set;}
    public string strBrand {set;get;}
    public boolean disableMediaValues {set; get;}
    public decimal decPBrustConvertedValue {
        get {
            return conProd.Converted_Pressure_Setting__c;
        }
        set {
            this.decPBrustConvertedValue=value;
        }
    }
    public decimal decConRelievingPressure {set;get;}
    public decimal decConRelievingTemp {set;get;}
    public decimal decVBrustConvertedValue {
        get {
            return conProd.Converted_Vacuum_Setting__c;
        }
        set {
            this.decVBrustConvertedValue=value;
        }
    }
    public string SZC {
        get {
            System.debug('conProd.Size__c --> '+conProd.Size__c);
            if(!String.isBlank(conProd.Size__c))
                return ConstantsUtil.getSizeDesc(conProd.Size__c).SZC;
            else
                return '';
        }
        set {
            this.SZC=value;
        }
    }
    list<string> lookUpAttr=new List <string> {'GIRDLE','WITHSTANDS','3RDPARTY','WITHSTANDRDCOMP','ASYTYP','GTAG08','GTAG12','OW050','OW500','ALUMDER','TEFDER','Composite','PRDLIN','GTAG01','ENGCATEGORY','GTAG11','PartSeat','STC','SizeValue','KOSHATAG','TPTQTY','BTC','METLDER','HTSCODE'};
        public decimal doubleConvertedFlowCapacity {get;set;}
    public decimal decBackPressConv {
        get {
            return 0.0;
        }
        set {
            this.decBackPressConv=value;
        }
    }
    public boolean showPressure {
        get {
            return conProd.Relief_Type__c=='Pressure Relief'? true:false;
        }
        set {
            this.showPressure=value;
        }
    }
    public boolean showSecB {
        get {
            return conProd.constrain_product_selection_by_flow__c=='Yes'? true:false;
        }
        set {
            this.showSecB=value;
        }
    }
    public boolean showVacuum {
        get {
            return conProd.Relief_Type__c=='Vacuum Relief'? true:false;
        }
        set {
            this.showPressure=value;
        }
    }
    public boolean showPressureVacuum {
        get {
            return conProd.Relief_Type__c=='Pressure & Vacuum Relief'? true:false;
        }
        set {
            this.showPressure=value;
        }
    }
    // public String selectedTab {
    //     get {
    //         String selectedTabParam = ApexPages.currentPage().getParameters().get('selectedTab');
    //         if(String.IsBlank(selectedTab) && String.IsNotBlank(selectedTabParam)) {
    //             return selectedTabParam;
    //         } else if(String.IsNotBlank(selectedTab)) {
    //             return selectedTab;
    //         }
    //         return '';
    //     }
    //     set;
    // }
    public List<RD_Integral_BDI_Table__c> BDIRecords{set;get;}
    public list<RD_Integral_BDI_Table__c> BDIList() {
        list<RD_Integral_BDI_Table__c> recBDI=new list<RD_Integral_BDI_Table__c>();
        System.debug('BDI LOG: '+conProd.Size__c);
        System.debug('BDI LOG: '+conProd.Product__c);
        System.debug('BDI LOG: '+conProd.Seat__c);
        if (conProd.Product__c!=null && conProd.Size__c!= null && conProd.Seat__c!=null) {
            string SZCcode='';
            string dynamicwhereclause='';

            if (String.IsNotBlank(conProd.Size__c)) {
                SZCcode=ConstantsUtil.getSizeDesc(conProd.Size__c).SZC;
                string query='Select WireType__c,StripMatlCode__c,Type__c,Wiring_Configuration__c,GasketMatlCode__c,CableLength__c,EndConnection__c,Interface__c from RD_Integral_BDI_Table__c ';
                dynamicwhereclause=' where PTC__c=\''+conProd.Product__c+'\' and SZC__c=\''+SZCcode +'\' and CompSTC__c=\''+conProd.Seat__c+'\'';
                // string query='Select WireType__c,StripMatlCode__c,Type__c,Wiring_Configuration__c,GasketMatlCode__c,CableLength__c,EndConnection__c,Interface__c from RD_Integral_BDI_Table__c ';
                // dynamicwhereclause=' where PTC__c=\'CDC\' and SZC__c=\'0200\' and CompSTC__c=\'SF\'';
                System.debug('dynamicwhereclause---: ' + dynamicwhereclause);
                recBDI = Database.query(query+dynamicwhereclause);

            }
        }
        return recBDI;
    }

    public String previousBDIWhereClause = '';
    //     public list<RD_Integral_BDI_Table__c> BDIRecords {
    //     get {

    //         string dynamicwhereclause=' ';


    //         if (conProd.Product__c!=null && conProd.Size__c!= null && conProd.Seat__c!=null) {
    //             String SZCcode='0100';
    //             if (String.IsNotBlank(conProd.Size__c)) {
    //                 SZCcode=ConstantsUtil.getSizeDesc(conProd.Size__c).SZC;
    //             }

    //             dynamicwhereclause=' where PTC__c=\''+conProd.Product__c+'\' and SZC__c=\''+SZCcode +'\' and CompSTC__c=\''+conProd.Seat__c+'\'';
    //             System.debug('dynamicwhereclause---: ' + dynamicwhereclause);
    //             recBDI = Database.query(query+dynamicwhereclause);
    //         }
    //         if((BDIRecords != null && !BDIRecords.isEmpty()) && dynamicwhereclause == previousBDIWhereClause) {
    //                 return BDIRecords;
    //         }

    //         System.debug('BDI Records: ' + recBDI);
    //         System.debug('BDI is empty: ' + recBDI.isEmpty());
    //         return recBDI;

    //     }
    //     private set;
    // }
    public boolean showBDI1 {
        get {
            if(BDIRecords.isEmpty())
                return false;
            else
                return true;
        }
        set {
            this.showBDI1=value;
        }
    }


    public boolean showBDI {
        get {
            // if(BDIRecords.isEmpty() || ((conProd.Product__c!='CAL'||conProd.Product__c!='PAS') && conProd.Material_Outlet_Ring__c==null) ||  ((conProd.Product__c=='CAL'||conProd.Product__c=='PAS') && conProd.Material_Seal__c ==null))
            if(!BDIRecords.isEmpty()) {
                boolean isBln=true;
                if((conProd.Product__c!='CAL' && conProd.Product__c!='PAS') && conProd.Material_Outlet_Ring__c!=null) {
                    conProd.Add_Integral_B_D_I_Integral_BDI_FLX_Sen__c=false;
                    isBln=false;
                }
                System.debug('No REcords for BDI');
                if((conProd.Product__c=='CAL'||conProd.Product__c=='PAS')) {
                    decimal decTefSealThick2=0;
                    System.debug('InsideVG2Min'+VG2Min);
                    System.debug('InsideRGSMin'+RGSMin);
                    System.debug('InsideRGEMIN'+RGEMIN);
                    System.debug('InsideVGSMIN'+VGSMIN);
                    if(conProd.Product__c=='CAL')
                    {
                        // if(VG2Min==0)
                        //     VG2Min=rtgRngWrap.VG2MIN;
                        decTefSealThick2=rdPosCalVal('SealThck__c',VG2Min,RGSMin,rdPosLst);
                    }
                    else if(conProd.Product__c=='PAS')
                    {
                        if(RGEMIN==null)
                            RGEMIN=0.0;
                        if(VGSMIN==null)
                            VGSMIN=0.0;
                        List<RD_tblPosCalRating__c> ratingList = new List<RD_tblPosCalRating__c>();
                        decTefSealThick2=rdPosCalVal('SealThck__c',RGEMIN,VGSMIN,rdPosLst);
                        //strTefSealThick=String.valueOf(decTefSealThick3);
                    }
                    system.debug('decTefSealThick2-'+decTefSealThick2);
                    if(decTefSealThick2>0) {
                        // conProd.Add_Integral_B_D_I_Integral_BDI_FLX_Sen__c=true;
                        isBln=true;
                    } else {
                        conProd.Add_Integral_B_D_I_Integral_BDI_FLX_Sen__c=false;
                        isBln=false;
                    }
                }
                return isBln;
            } else
                return false;
        }
        set {
            this.showBDI=value;
        }
    }
    /*public List<SelectOption> getReliefTypes(){
        Schema.sObjectType sobject_type = Rupture_Disc__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Relief_Type__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    public PageReference defalutASME() {
        conProd.ASME_BPE__c=conProd.CSA_Marking_CRN_Number__c ;
        return null;
    }
    public PageReference saveCertificate() {
        try {
            conProd.Bypass__c=false;
            upsert conProd;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }

        return null;
    }
     */
    // public list<SelectOption> getDiscMaterial () {
    //     list<selectOption> options = new List<selectOption>();
    //     AggregateResult[] aggResult=[SELECT MatlCodePos__c,count(id) FROM RDMasterBlaster__c GROUP BY MatlCodePos__c];
    //     Schema.DescribeFieldResult fieldResult = Rupture_Disc__c.Material_Top_Section__c.getDescribe();
    //     List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    //     Map<string,string> myMap=new Map<string,string>();
    //     for( Schema.PicklistEntry pickListVal : ple)
    //         myMap.put(pickListVal.getValue(),pickListVal.getLabel());
    //     for (AggregateResult ar : aggResult)  {
    //         if (ar.get('MatlCodePos__c')=='-')
    //             options.add(new selectOption('-','-'));
    //         else
    //             options.add(new selectOption((String) ar.get('MatlCodePos__c'),myMap.get((String) ar.get('MatlCodePos__c'))));

    //     }
    //     return options;

    // }
    public PageReference saveProductNarrowing() {
        try {
            conProd.Bypass__c=false;
            upsert conProd;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }
        return null;
    }

    /*public pageReference showSection() {
        if(!String.isBlank(conProd.Process_Media__c)) {
            List<Media_Property__c>  mD=[select Media__c,Media_Phase__c,MolecularWeight__c,SpecificHeatRatio__c,Density__c,CompressFactor__c from Media_Property__c where Media__c=:conProd.Process_Media__c];
            if ( ! mD.isEmpty()) {
                conProd.Customer_Specified_Media__c=mD.get(0).Media__c;
                conProd.Molecular_Weight__c=mD.get(0).MolecularWeight__c;
                conProd.Compressibility_Factor__c=mD.get(0).CompressFactor__c;
                conProd.Ratio_of_Specific_Heats__c=mD.get(0).SpecificHeatRatio__c;
                //System.debug('dfghjsfrdgdfhdfhdfk'+conProd.Process_Media__c);
                //System.debug('dfghjsfrdgdfhdfhdfk'+mD.get(0));
                disableMediaValues=true;
            } else {
                disableMediaValues=false;
            }
        }
        return null;
    }*/




    public List<string> notValidStatusForChng {
        get {
            return new List<String>{'Approved','Order Submitted'};
                }
        set {
            this.notValidStatusForChng=value;
        }
    }
    // public string getProductNarrowFilterClause() {
    //     string strdynamicWhereClause='Id != null';
    //     //Filter For Brand this is the first filter on the Master Blaster table.
    //     if(strBrand!=null)
    //         strdynamicWhereClause+=' AND Brand__c=\''+strBrand+'\'';
    //     System.debug('Dynamic Query getProductNarrowFilterClause() Brand Filter'+strdynamicWhereClause);
    //     //Filter on Direction
    //     if(conProd.Relief_Type__c!='') {
    //         if (conProd.Relief_Type__c=='Pressure Relief' )
    //             strdynamicWhereClause+=' AND Direction__c=\'P\'';
    //         else if (conProd.Relief_Type__c=='Vacuum Relief')
    //             strdynamicWhereClause+=' AND Direction__c=\'V\'';
    //         else
    //             strdynamicWhereClause+=' AND Direction__c=\'B\'';
    //     }
    //     System.debug('Dynamic Query getProductNarrowFilterClause Direction'+strdynamicWhereClause);
    //     //     //Filter on PressLL and PressUL
    //     if (decPBrustConvertedValue!=null && conProd.Relief_Type__c!='Vacuum Relief')
    //         strdynamicWhereClause+=' AND PRESSLL__c <='+ decPBrustConvertedValue+' and PRESSUL__c>='+decPBrustConvertedValue;
    //     System.debug('Dynamic Query getProductNarrowFilterClause PressLL and PressUL'+strdynamicWhereClause);
    //     // Filter on TempLL and TempUL
    //     if(conProd.Converted_Temperature_Setting__c!=null) {
    //         strdynamicWhereClause+=' AND TempLL__c <='+ conProd.Converted_Temperature_Setting__c+' and TempUL__c>='+conProd.Converted_Temperature_Setting__c;
    //     }
    //     // Filter on VacLL and VacUL
    //     if (conProd.Converted_Vacuum_Setting__c!=null && conProd.Relief_Type__c!='Vacuum Relief')
    //         strdynamicWhereClause+=' AND VacLL__c <='+ decVBrustConvertedValue+' and VacUL__c>='+decVBrustConvertedValue;
    //     System.debug('Dynamic Query getProductNarrowFilterClause VacLL and VacUL'+strdynamicWhereClause);

    //     //  //Filter on Vac WithStand
    //     if (!String.IsBlank(conProd.Vacuum_Withstand__c) && conProd.Vacuum_Withstand__c!='No Requirements') {
    //         decimal decBackPress;
    //         if (conProd.Vacuum_Withstand__c!='Full Vacuum') {
    //             decBackPress=15;
    //         } else {
    //             decBackPress=conProd.Converted_Back_Pressure_Value__c;
    //         }
    //         string strSubQuery;
    //         strSubQuery=' AND ((VacWithstand_Ind__c=\'Value\' AND VacValue__c>='+decBackPress+')';
    //         decimal decValue=decBackPress.divide(decPBrustConvertedValue, 3);
    //         strSubQuery+=' OR (VacWithstand_Ind__c=\'Ratio\' AND VacValue__c>='+decValue+'))';
    //         strdynamicWhereClause+=strSubQuery;
    //     }
    //     System.debug('Dynamic Query getProductNarrowFilterClause Vac WithStand'+strdynamicWhereClause);
    //     //Filter on Liquid Scenario
    //     if(conProd.Is_there_a_liquid_relief_scenario__c!='') {
    //         string val;
    //         if(conProd.Is_there_a_liquid_relief_scenario__c!='Yes')
    //             val='Either';
    //         else
    //             val='Gas';
    //         strdynamicWhereClause+=' AND Liquid_Relief__c=\''+val+'\'';
    //     }
    //     // Filter on Pos WithStand
    //     if (!String.isBlank(conProd.Pressure_Withstand__c) && conProd.Pressure_Withstand__c!='No Requirements') {
    //         decimal decPosPress;
    //         decimal decValue=0;
    //         decPosPress=conProd.Converted_Positive_Pressure_Value__c;
    //         if (decPosPress==null) {
    //             decPosPress=0;
    //         }
    //         string strSubQuery;
    //         strSubQuery=' AND ((PosWithstand_Ind__c=\'Value\' AND PosValue__c>='+decPosPress+')';
    //         if(decVBrustConvertedValue!=null && (decVBrustConvertedValue!=0) && decPosPress!=null)
    //             decValue=decPosPress.divide(decVBrustConvertedValue, 3);
    //         strSubQuery+=' OR (PosWithstand_Ind__c=\'Ratio\' AND PosValue__c>='+decValue+'))';
    //         strdynamicWhereClause+=strSubQuery;
    //     }
    //     System.debug('Dynamic Query getProductNarrowFilterClause Pos WithStand' +strdynamicWhereClause);
    //     //Need to add filter on MNFA

    //     //NEED TO ADD FILTER ON VMNFA
    //     //Filters on Section C
    //     //CSA Check
    //     if(conProd.CSA_Marking_CRN_Number__c!=Null) {
    //         if(conProd.CSA_Marking_CRN_Number__c)
    //             strdynamicWhereClause+=' AND CSA__c=\'Yes\'';
    //         else
    //             strdynamicWhereClause+=' AND CSA__c=\'No\'';
    //     }
    //     System.debug('Dynamic Query getProductNarrowFilterClause CSA CHECK' +strdynamicWhereClause);
    //     //ATEX CHECK
    //     if(conProd.Atex_Certificate__c!=null) {
    //         if(conProd.Atex_Certificate__c)
    //             strdynamicWhereClause+=' AND Atex__c=\'Yes\'';
    //         else
    //             strdynamicWhereClause+=' AND Atex__c=\'No\'';
    //     }
    //     System.debug('Dynamic Query getProductNarrowFilterClause ATEX CHECK' +strdynamicWhereClause);
    //     //CUTR CHECK
    //     if(conProd.CU_TR__c!=Null) {
    //         if(conProd.CU_TR__c)
    //             strdynamicWhereClause+=' AND CU_TR_Compliant_Discs__c=\'Yes\'';
    //         else
    //             strdynamicWhereClause+=' AND CU_TR_Compliant_Discs__c=\'No\'';
    //     }
    //     System.debug('Dynamic Query getProductNarrowFilterClause CUTR CHECK' +strdynamicWhereClause);
    //     //X3A CHECK
    //     if(conProd.X3A_Sanitary_Standards__c!=null) {
    //         if(conProd.X3A_Sanitary_Standards__c)
    //             strdynamicWhereClause+=' AND X3A__c=\'Yes\'';
    //         else
    //             strdynamicWhereClause+=' AND X3A__c=\'No\'';
    //     }
    //     System.debug('Dynamic Query getProductNarrowFilterClause X3A CHECK' +strdynamicWhereClause);
    //     //NACE Check
    //     if(!String.IsBlank(conProd.NACE__c)||conProd.NACE__c!='N')
    //         strdynamicWhereClause+=' AND NACE__c=\'Yes\'';
    //     else
    //         strdynamicWhereClause+=' AND NACE__c=\'No\'';

    //     System.debug('Dynamic Query getProductNarrowFilterClause NACE CHECK' +strdynamicWhereClause);
    //     //ASME Initial Check
    //     if(conProd.ASME_Section_VIII_Division_1__c!=Null) {
    //         if(conProd.ASME_Section_VIII_Division_1__c) {
    //             if (decPBrustConvertedValue!=0 && decPBrustConvertedValue!=null) {
    //                 strdynamicWhereClause+=' AND ASME_LL__c <='+ decPBrustConvertedValue+' and ASME_UL__c>='+decPBrustConvertedValue;
    //             }
    //             if (decVBrustConvertedValue!=0 && decVBrustConvertedValue!=null) {
    //                 strdynamicWhereClause+=' AND ASME_LL__c <='+ decVBrustConvertedValue+' and ASME_UL__c>='+decVBrustConvertedValue;
    //             }
    //         }
    //     }
    //     System.debug('Dynamic Query getProductNarrowFilterClause ASME CHECK' +strdynamicWhereClause);
    //     //CE Mark CHECK
    //     if(conProd.PED_2014_68_EU_CE_mark__c!=Null) {
    //         if(!String.IsBlank(conProd.PED_2014_68_EU_CE_mark__c)) {
    //             if (decPBrustConvertedValue!=0 && decPBrustConvertedValue!=null) {
    //                 strdynamicWhereClause+=' AND CE_Mark_LL__c <='+ decPBrustConvertedValue+' and CE_Mark_UL__c>='+decPBrustConvertedValue;
    //             }
    //             if (decVBrustConvertedValue!=0 && decVBrustConvertedValue!=null) {
    //                 strdynamicWhereClause+=' AND CE_Mark_LL__c <='+ decVBrustConvertedValue+' and CE_Mark_UL__c>='+decVBrustConvertedValue;
    //             }
    //         }
    //     }

    //     System.debug('Dynamic Query getProductNarrowFilterClause CE MARK CHECK' +strdynamicWhereClause);
    //     //CHINAMFG Check
    //     if(conProd.China_Manufacturing_License__c!=Null) {
    //         if(!String.IsBlank(conProd.China_Manufacturing_License__c)) {
    //             if (decPBrustConvertedValue!=0 && decPBrustConvertedValue!=null) {
    //                 strdynamicWhereClause+=' AND China_ML_LL__c <='+ decPBrustConvertedValue+' and China_ML_UL__c>='+decPBrustConvertedValue;
    //             }
    //             if (decVBrustConvertedValue!=0 && decVBrustConvertedValue!=null) {
    //                 strdynamicWhereClause+=' AND China_ML_LL__c <='+ decVBrustConvertedValue+' and China_ML_UL__c>='+decVBrustConvertedValue;
    //             }
    //         }
    //     }
    //     //KOSHA Check
    //     if(conProd.KOSHA_Compliance__c!=Null) {
    //         //if(!String.IsBlank(conProd.KOSHA_Compliance__c)) {
    //         if(conProd.KOSHA_Compliance__c) {
    //             if (decPBrustConvertedValue!=0 && decPBrustConvertedValue!=null) {
    //                 strdynamicWhereClause+=' AND KOSHA_LL__c <='+ decPBrustConvertedValue+' and KOSHA_UL__c>='+decPBrustConvertedValue;
    //             }
    //             if (decVBrustConvertedValue!=0 && decVBrustConvertedValue!=null) {
    //                 strdynamicWhereClause+=' AND KOSHA_LL__c <='+ decVBrustConvertedValue+' and KOSHA_UL__c>='+decVBrustConvertedValue;
    //             }
    //         }
    //         //}
    //     }
    //     System.debug('Dynamic Query getProductNarrowFilterClause KOSHA CHECK' +strdynamicWhereClause);
    //     //End Of Section C filters
    //     //Filters on Section D
    //     //NON FRAGMENTING DESIGN CHECK
    //     if(conProd.Non_Fragmenting_Design_Required__c!=null) {
    //         if(conProd.Non_Fragmenting_Design_Required__c)
    //             strdynamicWhereClause+=' AND NonFragDesign__c=\'Yes\'';
    //         else
    //             strdynamicWhereClause+=' AND NonFragDesign__c=\'No\'';
    //     }
    //     System.debug('Dynamic Query getProductNarrowFilterClause NON FRAGMENTING DESIGN CHECK' +strdynamicWhereClause);
    //     //OP RATIO CHECK
    //     if (!String.IsBlank(conProd.Operating_Pressure_Ratio__c)) {
    //         Decimal strToDec = decimal.valueOf(conProd.Operating_Pressure_Ratio__c);
    //         strdynamicWhereClause+=' AND OPtoBpRatio__c>='+strToDec;
    //     }
    //     System.debug('Dynamic Query getProductNarrowFilterClause OP RATIO CHECK' +strdynamicWhereClause);
    //     //APPLICATION CHECK
    //     if (!String.IsBlank(conProd.Application_type__c)) {
    //         //Decimal strToDec = decimal.valueOf(conProd.Operating_Pressure_Ratio__c);
    //         strdynamicWhereClause+=' AND Application__c=\''+conProd.Application_type__c+'\'';

    //     }
    //     System.debug('Dynamic Query getProductNarrowFilterClause APPLICATION CHECK' +strdynamicWhereClause);
    //     return strdynamicWhereClause;
    // }
    /* This method will return the list of MasterBlaster Data after narrowing*/
    // TODO : Save DSCVAR__c, Derate_Teflon__c, and DerateType__c to Rupture_Disc__c fields(same name) for use in Components, Engineering(Currently in RDRatingRange.cls)
    //  Follow-up with Shailesh and Sai, as the product selection in the new UI restricts the user to select a single record that sets PTC/SZC/STC from a single RDMasterBlaster__c record,
    //      but the VF page lets user pick separate values for each that could allow invalid configurations
    // @AuraEnabled
    public String previousWhereClause = '';
    // public List<RDMasterBlaster__c> rDMBRecords {
    //     get {
    //         String queryString='select PTC__c,SZC__c,STC__c, DSCVAR__c, DerateType__c, Derate_Teflon__c from RDMasterBlaster__c';
    //         String whereClause=' WHERE ';
    //         whereClause+=getProductNarrowFilterClause();
    //         if((rDMBRecords != null && !rDMBRecords.isEmpty()) && whereClause == previousWhereClause) {
    //             return rDMBRecords;
    //         }
    //         previousWhereClause = whereClause;          //  Set the current criteria to the stored variable
    //         queryString = queryString + whereClause;
    //         string order_by=' order by SZC__c';         //  Set "ORDER BY" in query string
    //         queryString=queryString+order_by;           //  Append "ORDER BY" to the query string
    //         System.debug('rDMBRecords Query : ' + queryString);
    //         List<RDMasterBlaster__c> sobjList = Database.query(queryString);
    //         System.debug('rDMBRecords Query : ' + queryString);
    //         //System.debug('rDMBRecords Result : ' + queryString);
    //         return sobjList;    // Return
    //     }
    //     private set;
    // }

    //  @AuraEnabled
    // public Map<String, RDOptions> getRDRecords() {
    //     Map<String, RDOptions> records = new Map<String, RDOptions>();  //  Create list to store results
    //     //  IF rDMBRecords is empty, or any of the filter criteria is null, skip function
    //     //   ELSE loop over RDMasterBlaster__c records, and return only the unique combinations of product, seat, and size
    //     Set<String> uniqueCombinations = new Set<String>();
    //     if(rDMBRecords.isEmpty()) {
    //         System.debug('No records fit criteria');
    //     } else {
    //         for(RDMasterBlaster__c rdmb : rDMBRecords) {
    //             String keyCheck = rdmb.PTC__c + '|' + rdmb.SZC__c.intValue() + '|' + String.valueOf(rdmb.STC__c);
    //             // IF the RDMasterBlaster__c record's attributes are not present yet, add to the unique set
    //             if(!uniqueCombinations.contains(keyCheck)) {
    //                 records.put(keyCheck, new RDOptions(rdmb.PTC__c, rdmb.STC__c, rdmb.SZC__c, rdmb.DSCVAR__c, rdmb.DerateType__c, rdmb.Derate_Teflon__c));
    //                 uniqueCombinations.add(keyCheck);
    //             }
    //         }
    //     }
    //     return records;
    // }
    // public class RDOptions {
    //     @AuraEnabled
    //     public String product {get;set;}
    //     @AuraEnabled
    //     public String seat {get;set;}
    //     @AuraEnabled
    //     public Decimal size {get;set;}
    //     @AuraEnabled
    //     public String dsc {get;set;}
    //     @AuraEnabled
    //     public String drtType {get;set;}
    //     @AuraEnabled
    //     public Decimal drtTeflon {get;set;}
    //     @AuraEnabled
    //     public String imageURL {get;set;}
    //     public RDOptions(String PTC, String STC, Decimal SZC, String DSCVAR, String DERATETYPE, Decimal DERATETEF) {
    //         product = PTC;
    //         seat = STC;
    //         size = SZC;
    //         dsc = DSCVAR;
    //         drtTeflon = DERATETEF;
    //         drtType = DERATETYPE;
    //         imageURL = getImageURL(PTC);    // USE {!$Resource.cdcStaticResource + RDOption_variable_name.imageURL}
    //     }
    //     public String getImageURL(String prodCode) {
    //         return '/assets/images/products/' + (ConstantsUtil.prodCodeImageNameMap.containsKey(prodCode) ? ConstantsUtil.prodCodeImageNameMap.get(prodCode) : 'STANDARD 30deg SEAT') + '.png';
    //     }
    //     public String getDetails() {
    //         return 'PTC : ' + product + '; STC : ' + seat + '; SZC : ' + String.valueOf(size) + '; DSCVAR : ' + dsc + '; DerateType : ' + drtType +  '; DerateTeflon : ' + drtTeflon;
    //     }
    // }
    // public List<SelectOption> getProductValues() {
    //     List<selectOption> prodOptions = new List<selectOption>();
    //     prodOptions.add(new selectOption('',''));
    //     List<string> uniqueList=new List<string>();
    //     for (RDMasterBlaster__c kv: rDMBRecords ) {
    //         if(!uniqueList.contains(kv.PTC__c)){
    //             uniqueList.add(kv.PTC__c);
    //             prodOptions.add(new selectOption(kv.PTC__c,ConstantsUtil.mapPTCDesc.get(kv.PTC__c)));
    //         }
    //     }
    //     return prodOptions;
    // }

    // public List<SelectOption> getSeatValues() {
    //     List<selectOption> seatOptions = new List<selectOption>();
    //     seatOptions.add(new selectOption('',''));
    //     List<string> uniqueList=new List<string>();
    //     for (RDMasterBlaster__c kv: rDMBRecords ) {
    //         if(!uniqueList.contains(kv.STC__c)){
    //             uniqueList.add(kv.STC__c);
    //             seatOptions.add(new selectOption(kv.STC__c,ConstantsUtil.mapSTCDesc.get(kv.STC__c)));
    //         }
    //     }
    //     return seatOptions;
    // }
    // public List<SelectOption> getSizeValues() {
    //     List<selectOption> sizeOptions = new List<selectOption>();
    //     sizeOptions.add(new selectOption('',''));
    //     List<string> uniqueList=new List<String>();
    //     for (RDMasterBlaster__c kv: rDMBRecords ) {
    //         Integer a= Integer.valueOf(kv.SZC__c.stripTrailingZeros());
    //         String val=String.valueOf(a);
    //         if(!uniqueList.contains(val)){
    //             uniqueList.add(val);
    //             sizeOptions.add(new selectOption(val,ConstantsUtil.getSzcDesc(val)));
    //         }
    //     }
    //     return sizeOptions;
    // }
  /*  public PageReference showEvalutionPerSec() {
        //system.debug('AAAA'+conProd.Evaluation_Per__c);
        if(conProd.Evaluation_Per__c=='ASME Gas/Vapor')
        {
            //showASMEGas=true;
            //showASMEWater=false;
            //system.debug('AAA55A'+showASMEGas);
        }
        else if (conProd.Evaluation_Per__c=='ASME Water')
        {
            //showASMEWater=true;
            //showASMEGas=false;
        }
        return null;

    }*/
   /* public PageReference showSectionB() {

        return null;
    }*/
   /* public List<SelectOption> getFlowRateOtions() {
        List<selectOption> options = new List<selectOption>();
        if (!String.IsBlank(conProd.Evaluation_Per__c)) {
            if (unitConversions.listGasFlowRatenew.contains(conProd.Evaluation_Per__c)) {
                options=unitConversions.optsGasFlowRate;
            } else if (unitConversions.listLiquidFlowRatenew.contains(conProd.Evaluation_Per__c)) {
                options=unitConversions.optsLiquidFlowRate;
            } else if (unitConversions.listStreamFlowRatenew.contains(conProd.Evaluation_Per__c)) {
                options=unitConversions.optsStreamFlowRate;
            }
        }
        return options;
    }*/
    public pageReference getRatingType() {
        Map<string,List<SelectOption>> intiMap=rtgRngWrap.mapRGTYP1;
        // List<ApexPages.Message> messages = new List<ApexPages.Message>();
        // if(rtgRngWrap.RGRAT1 == null || rtgRngWrap.RGTYP1 == null){

        //     messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill the Pressure Rating and Range Fields'));
        //     return null;
        // }
        clearManufacturingRange();
        conProd.Rating_and_Range_Flag__c = false;

        if(String.isNotBlank(rtgRngWrap.RGRAT1)) {
            System.debug('@@@ rtgRngWrap.RGRAT1'+rtgRngWrap.RGRAT1);
            System.debug('pressureRangeOptions: ' + rtgRngWrap.pressureRangeOptions);
            System.debug('intiMap.getMap@@@ 1278'+intiMap);
            if(intiMap.containsKey(rtgRngWrap.RGRAT1)) {
                // if(rtgRngWrap.pressureRangeOptions!=null)
                //     rtgRngWrap.pressureRangeOptions.clear();
                rtgRngWrap.pressureRangeOptions=new list<SelectOption>();
                rtgRngWrap.pressureRangeOptions.add(new SelectOption('', 'Please Select'));
                List<SelectOption> intiMap2=intiMap.get(rtgRngWrap.RGRAT1);
                System.debug('intiMap.getMap@@@'+intiMap);
                rtgRngWrap.pressureRangeOptions.addall(intiMap2);
                rtgRngWrap.RGTYP1='';
            }else {
                rtgRngWrap.pressureRangeOptions.clear();
            }
        }

        return null;
    }

    public pageReference getVacRatingType() {
        clearManufacturingRange();
        conProd.Rating_and_Range_Flag__c = false;
        Map<string,List<SelectOption>> intiMap=rtgRngWrap.mapVGTYP1;
        if(String.isNotBlank(rtgRngWrap.VGRAT1)) {
            if(intiMap.containsKey(rtgRngWrap.VGRAT1)) {
                // if(rtgRngWrap.vacuumRangeOptions!=null)
                //     rtgRngWrap.vacuumRangeOptions.clear();
                rtgRngWrap.vacuumRangeOptions=new list<SelectOption>();
                rtgRngWrap.vacuumRangeOptions.add(new SelectOption('', 'Please Select'));
                List<SelectOption> intiMap2=intiMap.get(rtgRngWrap.VGRAT1);
                rtgRngWrap.vacuumRangeOptions.addall(intiMap2);
                rtgRngWrap.VGTYP1='';
            }
        }
        return null;
    }

    /*public List<SelectOption> getTypes(){
        Schema.sObjectType sobject_type = Rupture_Disc__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get('NACE__c').getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }*/
    public string MCDmaterial {
        get {
            string sMCDT;

            if (conProd.Material_Top_Section__c!=null )
                sMCDT='Top Section';
            else if (conProd.Material_Top_Section2__c!=null)
                sMCDT='Top Section';
            if (conProd.Material_Disc__c!=null )
                sMCDT='Disc';
            else
                sMCDT='Disc';
            return sMCDT;
        }
        set {
            MCDmaterial=value;
        }
    }
    public string MCD {
        get {
            string sMCDT;
            string sMCD;
            if (conProd.Material_Top_Section__c!=null )
                sMCDT=conProd.Material_Top_Section__c;
            else if (conProd.Material_Top_Section2__c!=null)
                sMCDT=conProd.Material_Top_Section2__c;
            if (conProd.Material_Disc__c!=null )
                sMCD=conProd.Material_Disc__c;
            else
                sMCD=sMCDT;
            return sMCD;
        }
        set {
            MCD=value;
        }
    }
    public PageReference saveCleaningsTestsandProcesses() {
        pageReference reloadpage2 = new pageReference('/apex/configRD?qid='+quotelineId);
       // try {
            if(!conProd.Rating_and_Range_Flag__c) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please complete Rating and Range.'));
                return null;
            }
            if(!conProd.Components_Flag__c || !errOnSaveComp) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please complete Components section.'));
                return null;
            }
            if (cmpWrap.reqComps.contains('Material_Arcuate_Ring__c') && conProd.Material_Arcuate_Ring__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Arcuate Ring'));
            if (cmpWrap.reqComps.contains('Material_Armor_Ring2__c') && conProd.Material_Armor_Ring2__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Arcuate Ring'));
            if (cmpWrap.reqComps.contains('Material_Armor_Ring__c') && conProd.Material_Armor_Ring__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Armor Ring'));
            if (cmpWrap.reqComps.contains('Material_Dent_Protector__c') && conProd.Material_Dent_Protector__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Dent Protector'));
            if (cmpWrap.reqComps.contains('Material_Disc__c') && conProd.Material_Disc__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Disc'));
            if (cmpWrap.reqComps.contains('Material_Girdle_Cover__c') && conProd.Material_Girdle_Cover__c ==null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Girdle Cover'));
            if (cmpWrap.reqComps.contains('Material_Girdle__c') && conProd.Material_Girdle__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Girdle'));
            if (cmpWrap.reqComps.contains('Material_Handling_Support__c') && conProd.Material_Handling_Support__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Handling Support'));
            if (cmpWrap.reqComps.contains('Material_Hi_Temp_Assembly__c') && conProd.Material_Hi_Temp_Assembly__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Hi Temp Assembly'));
            if (cmpWrap.reqComps.contains('Material_Holddown_Ring__c') && conProd.Material_Holddown_Ring__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Holddown Ring'));
            if (cmpWrap.reqComps.contains('Material_Inlet_Coating2__c') && conProd.Material_Inlet_Coating2__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet Coating'));
            if (cmpWrap.reqComps.contains('Material_Inlet_Coating__c') && conProd.Material_Inlet_Coating__c== null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet Coating'));
            if (cmpWrap.reqComps.contains('Material_Inlet_Gasket__c') && conProd.Material_Inlet_Gasket__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet Gasket'));
            if (cmpWrap.reqComps.contains('Material_Inlet_Liner__c') && conProd.Material_Inlet_Liner__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet Liner'));
            if (cmpWrap.reqComps.contains('Material_Inlet_O_Ring__c') && conProd.Material_Inlet_O_Ring__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet O Ring'));
            if (cmpWrap.reqComps.contains('Material_Inlet_Ring2__c') && conProd.Material_Inlet_Ring2__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet Ring'));
            if (cmpWrap.reqComps.contains('Material_Inlet_Ring3__c') && conProd.Material_Inlet_Ring3__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet Ring'));
            if (cmpWrap.reqComps.contains('Material_Inlet_Ring__c') && conProd.Material_Inlet_Ring__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet Ring'));
            if (cmpWrap.reqComps.contains('Material_Inlet__c') && conProd.Material_Inlet__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet'));
            if (cmpWrap.reqComps.contains('Material_Outlet_Coating__c') && conProd.Material_Outlet_Coating__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Outlet Coating'));
            if (cmpWrap.reqComps.contains('Material_Outlet_Gasket__c') && conProd.Material_Outlet_Gasket__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Outlet Gasket'));
            if (cmpWrap.reqComps.contains('Material_Outlet_Liner__c') && conProd.Material_Outlet_Liner__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Outlet Liner'));
            if (cmpWrap.reqComps.contains('Material_Outlet_Ring__c') && conProd.Material_Outlet_Ring__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Outlet Ring'));
            if (cmpWrap.reqComps.contains('Material_Outlet__c') && conProd.Material_Outlet__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Outlet'));
            if (cmpWrap.reqComps.contains('Material_Seal2__c') && conProd.Material_Seal2__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Seal'));
            if (cmpWrap.reqComps.contains('Material_Seal3__c') && conProd.Material_Seal3__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Seal'));
            if (cmpWrap.reqComps.contains('Material_Seal__c') && conProd.Material_Seal__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Seal'));
            if (cmpWrap.reqComps.contains('Material_Top_Section2__c') && conProd.Material_Top_Section2__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Top Section'));
            if (cmpWrap.reqComps.contains('Material_Top_Section__c') && conProd.Material_Top_Section__c ==null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Top Section'));
            if (cmpWrap.reqComps.contains('Material_Vaccum_Support3__c') && conProd.Material_Vaccum_Support3__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Vaccum Support'));
            if (cmpWrap.reqComps.contains('Material_Vacuum_Support2__c') && conProd.Material_Vacuum_Support2__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Vaccum Support'));
            if (cmpWrap.reqComps.contains('Material_Vacuum_Support__c') && conProd.Material_Vacuum_Support__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Vaccum Support'));


            String strDPM = '';
            if(conProd.Is_there_a_liquid_relief_scenario__c == 'Yes'){
                strDPM = 'Y';
            } else if(conProd.Is_there_a_liquid_relief_scenario__c == 'No'){
                strDPM = 'N';
            }
            System.debug('tblASMEQuery --->>> '+conProd.RG2MIN__c);
            System.debug('tblASMEQuery --->>> '+conProd.RG2MAX__c);
            decimal decRG2MIN=0,decRG2MAX=0;
            if(conProd.RG2MIN__c==null)
                decRG2MIN=conProd.Converted_Pressure_Setting__c;
            else
                decRG2MIN=conProd.RG2MIN__c;

            if(conProd.RG2MAX__c==null)
                decRG2MAX=conProd.Converted_Pressure_Setting__c;
            else
                decRG2MAX=conProd.RG2MAX__c;
            String tblASMEQuery = 'SELECT Id, DPM__c, DSCVAR__c, PressLL__c, PressUL__c, PTC__c, STC__c, SZC__c,ASMEInletOption__c,ASMEOutOption__c, SizingCertText__c, SizingKrText__c FROM RD_tblASMEValues__c WHERE PTC__c=\''+conProd.product__c+'\' and STC__c=\''+conProd.seat__c+'\' and SZC__c=\''+SZC+'\' AND PressLL__c<='+decRG2MIN+' AND PressUL__c>='+decRG2MAX+' AND DPM__c=\''+strDPM+'\' AND ASMEInletOption__c=\''+conProd.ASME_Inlet_Option_Code__c+'\' AND ASMEOutOption__c='+conProd.ASME_Outlet_Option_Code__c+' AND DSCVAR__c=\''+conProd.DSCVAR__c+'\'';
            System.debug('tblASMEQuery --->>> '+tblASMEQuery);

            //Filter For Inlet Connection
            if(conProd.Inlet_Connection__c!='N')
                tblASMEQuery+=' AND HIC__c IN (\'' + conProd.Inlet_Connection__c + '\',\'-\')';

            //Filter For Outlet Connection
            if(conProd.Outlet_Connection__c!='N')
                tblASMEQuery+=' AND HOC__c IN (\'' + conProd.Outlet_Connection__c + '\',\'-\')';
            List<RD_tblASMEValues__c> lstRDASMEtblValues =new List<RD_tblASMEValues__c>();
            //lstRDASMEtblValues = Database.query(tblASMEQuery);
            if(conProd.Product__c!='CAL')
                lstRDASMEtblValues = Database.query(tblASMEQuery);
            if(conProd.Product__c!='CAL') {
                if(lstRDASMEtblValues.size()==0 && conProd.ASME_Section_VIII_Division_1__c){
                    if(!ReorderFlag)
                    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'No match found on the ASME Values table.'));
                } else if (conProd.ASME_Section_VIII_Division_1__c) {
                    conProd.SizingKrText__c=lstRDASMEtblValues[0].SizingKrText__c;
                    conProd.SizingCertText__c = 'National Board Certification Number '+lstRDASMEtblValues[0].SizingCertText__c;
                }
            }
            System.debug('SizingKrText__c'+conProd.SizingKrText__c);
            System.debug('SizingCertText__c'+conProd.SizingCertText__c);
            // if(lstRDASMEtblValues.size()==0 && conProd.ASME_Section_VIII_Division_1__c){
            //     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Invalid Configuration! Please Revisit.'));
            // }
        if(!Test.isRunningTest())
        {
            if(string.isBlank(MCD) && (!((conProd.Product__c=='CAL' || conProd.Product__c=='PAS') && conProd.DSCVAR__c=='N'))) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter value for Rupture Disc Material'));
            }
        }
			if(!ReorderFlag)
            {
              	if(ApexPages.getMessages().size()>0) {
                    conProd.Components_Flag__c=false;
                    update conProd;
                    return null;
              	}
            }
            conProd.Bypass__c=false;
            conProd.Finish_Configuration_Flag__c=true;
            result resDia=loadDiagramData();
            //System.debug('PRicing Strats : ');
            //upsert conProd;

            //Thickness Formulae
            if(conProd.RGSMIN__c!=null && conProd.RGSMAX__c!=null ) {
                RDThicknessFormulae thickness=new RDThicknessFormulae(conProd,conProd.RGSMIN__c.setScale(1),conProd.RGSMAX__c.setScale(1));
                if(String.isNotBlank(conProd.MCSM__c)){
                    result metalThick=thickness.RDMetalSealThickness();
                    if(metalThick.bResult)
                        conProd.MetalSeal_Thickness__c=metalThick.dblRetValue;
                }

                result discThick=thickness.RDThicknessCal();
                result topsec=thickness.RDTopSectionThickness();

                if(topsec.bResult)
                    conProd.TopSection_Thickness__c=topsec.dblRetValue;
                if(discThick.bResult)
                    conProd.Disc_Thickness__c=discThick.dblRetValue;
                upsert conProd;
            }
            System.debug('PRicing Strats : ');
            //if(!conProd.Price_Override__c) {

            //}
            // RDOU=new RdOutputBaseUtility(conProd.id);
            // RDOBUStructWrapper=RDOU.getConsolidatedStructureDetails();
            // if(!conProd.Lead_Time_Override__c ) {
            //     result re1s=RDOU.getRDLeadTime();
            // }

            // RD_Outputs__c[] rdOutputList=[Select Base_Lead_Time_GP__c,Base_Lead_Time_GCI__c,Base_Lead_Time_CDC__c,Base_Lead_Time_40__c,
            //                               Adder_Lead_Time_GP__c,Adder_Lead_Time_GCI__c,Adder_Lead_Time_CDC__c,Adder_Lead_Time_40__c,
            //                               Comp_Lead_Time_GP__c,Comp_Lead_Time_GCI__c,Comp_Lead_Time_CDC__c,Comp_Lead_Time_40__c,
            //                               Total_Lead_Time_CDC__c,Total_Lead_Time_GP__c,Total_Lead_Time_GCI__c,Total_Lead_Time_GP_ORD__c,
            //                               Total_Lead_Time_40__c,OW__c,OW_Override__c,OA__c,OA_Override__c,OB__c,OB_Override__c,ORP__c,
            //                               ORP_Override__c,ORV__c,ORV_Override__c,Total_Lead_Time_CDC_ORD__c,Total_Lead_Time_GCI_ORD__c,
            //                               LABMAT__c,Total_Lead_Time_40_ORD__c,LABDSC__c,ORP010__c,ORP015__c,ORP027__c,ORV010__c,ORV020__c,ORP020__c,ORP025__c,ORV025__c,
            //                               ORV015__c,ORV027__c,SRV__c ,SRP__c
            //                               FROM RD_Outputs__c
            //                               WHERE RD_Outputs_Relation_Field__c=:conProd.Id];
            // System.debug('RD_Outputs__c: ' + rdOutputList);
            // rdOutlist=new List<RD_Outputs__c>();
            // rdOutput=new RD_Outputs__c();
            // if(rdOutputList.size()>0)
            //     rdOutput=rdOutputList[0];
            // rdOutlist.add(rdOutput);
            // //if(!conProd.Quote_Descriptions_Override__c) {
            // String strOW=' ';
            // result resOW=RDOU.getOW();
            // System.debug('resOW: ' + resOW);
            // if (resOW.bResult) {
            //     strOW=resOW.strRetValue;
            //     strOW=strOW.replace('\\n','\n');
            // }
            // System.debug('OW1--->>>'+strOW);
            // strOW=strOW.replaceAll('\n\n', '\n');
            // System.debug('OW2--->>>'+strOW);
            // //'OA__c','LABDSC__c'
            // if(strOW.length()>1251) {
            //     rdOutput.OW__c=strOW.substring(0, 1250);
            //     if(!conProd.Quote_Descriptions_Override__c)
            //         rdOutput.OW_Override__c =strOW.substring(0, 1250);
            // } else {
            //     rdOutput.OW__c=strOW;
            //     if(!conProd.Quote_Descriptions_Override__c)
            //         rdOutput.OW_Override__c =strOW;
            // }
            // result resOA=RDOU.getOA();
            // String resStrOA = '';
            // String strOA='';
            // String strLABDSC='';
            // if (resOA.bResult) {
            //     for (sObject sOb:resOA.objResultList) {
            //         if ((String) sOb.get('OA__c')!=null){
            //             strOA = (String) sOb.get('OA__c');
            //             strOA = strOA.replace('\\n','\n');
            //             strOA+= '\n';
            //         }

            //         if ((String) sOb.get('LABDSC__c')!=null)
            //             strLABDSC+= (String) sOb.get('LABDSC__c')+'\n';
            //     }
            // }
            // System.debug('strOA: --'+strOA);
            // rdOutput.LABDSC__c=strLABDSC;
            // if(strOA.length()>251) {
            //     rdOutput.OA__c=strOA.substring(0, 250);
            //     if(!conProd.Quote_Descriptions_Override__c)
            //         rdOutput.OA_Override__c=strOA.substring(0, 250);
            // } else  {
            //     rdOutput.OA__c=strOA;
            //     if(!conProd.Quote_Descriptions_Override__c)
            //         rdOutput.OA_Override__c=strOA;
            // }
            // map<string,string> OBMAP=RDOU.getOB_LABMAT_Ouput();
            // if(OBMAP.get('OB').length()>251) {
            //     rdOutput.OB__c=OBMAP.get('OB').substring(0, 250);
            //     if(!conProd.Quote_Descriptions_Override__c)
            //         rdOutput.OB_Override__c=OBMAP.get('OB').substring(0, 250);
            // } else {
            //     rdOutput.OB__c=OBMAP.get('OB');
            //     if(!conProd.Quote_Descriptions_Override__c)
            //         rdOutput.OB_Override__c=OBMAP.get('OB');
            // }
            // if(OBMAP.get('LABMAT').length()>251) {
            //     rdOutput.LABMAT__c=OBMAP.get('LABMAT').substring(0,OBMAP.get('LABMAT').length()-1).substring(0, 250);
            //     rdOutput.LABMAT__c = rdOutput.LABMAT__c.removeEnd('/');
            // } else {
            //     rdOutput.LABMAT__c=OBMAP.get('LABMAT');
            //     rdOutput.LABMAT__c = rdOutput.LABMAT__c.removeEnd('/');
            // }
            // Decimal StartRelief = rtgRngWrap.StartRelief==null?0.0:rtgRngWrap.StartRelief;
            // if(conProd.Relief_Type__c != 'Vacuum Relief'){
            //     if(rtgRngWrap.ORP015!=null)
            //         rdOutput.ORP015__c=rtgRngWrap.ORP015;
            //     rdOutput.ORP__c=rtgRngWrap.ORP;
            //     if(!conProd.Quote_Descriptions_Override__c)
            //         rdOutput.ORP_Override__c=rdOutput.ORP__c;
            //     if(rtgRngWrap.SRP!=null)
            //         rdOutput.SRP__c=rtgRngWrap.SRP;
            // }

            // if(conProd.Relief_Type__c != 'Pressure Relief'){
            //     if(rtgRngWrap.ORV015!=null)
            //         rdOutput.ORV015__c=rtgRngWrap.ORV015;
            //     rdOutput.ORV__c=rtgRngWrap.ORV;
            //     if(!conProd.Quote_Descriptions_Override__c)
            //         rdOutput.ORV_Override__c=rtgRngWrap.ORV;
            //     if(rtgRngWrap.SRV!=null)
            //         rdOutput.SRV__c=rtgRngWrap.SRV;
            // }



            // //}
            // // rdOutput.ORP__c=conProd.ORP__c;
            // // rdOutput.ORV__c=conProd.ORV__c;
            // WizardCostProcessor wcp = new WizardCostProcessor(conProd.Id);
            // List<Cost__c> getCst = wcp.getRDCostData();
            // //getCost();
            // System.debug('SOQL COUNT Checkp Cost'+Limits.getAggregateQueries());

            // System.debug('SOQL COUNT Checkp Outputs'+Limits.getAggregateQueries());
            // getPricingData();
            // // if(resDia.bResult)
            // //     getDiaData();

            // string strBRANDCODE=AssyPartDefinationProcessor.mapBrandwithCode.get(strBrand.ToUpperCase());
            // string ASSYPARTNOBASE=strBRANDCODE+conProd.Product__c+ConstantsUtil.getSizeDesc(conProd.Size__c).SZC+conProd.Seat__c;
            // //For Original partnobase
            // System.debug('resPartEx: ' + ASSYPARTNOBASE);
            // System.debug('resPartEx: ' + ConstantsUtil.getSizeDesc(conProd.Size__c).SZC);
            // System.debug('resPartEx: ' + conProd.Seat__c);
            // if(!conProd.Quote_Descriptions_Override__c)
            //     conProd.ASSYPARTNOBASE__c=ASSYPARTNOBASE;
            // result resPartEx=AssyPartDefinationProcessor.getPartNumberExisting(ASSYPARTNOBASE,conProd,'DISC');
            // System.debug('resPartEx: ' + resPartEx);
            // if(resPartEx.bResult)
            //     conProd.ASSYPARTEXISTING__c=resPartEx.strRetValue;
            // else
            //     conProd.ASSYPARTEXISTING__c=null;

            // // for(string str:lookUpAttr) {
            // //     if(RDOU.mapRDAttr.containsKey(str)) {
            // //         mapIFSAttributes.put(str,RDOU.mapRDAttr.get(str));
            // //         System.debug('Final values : ' +RDOU.mapRDAttr.get(str));
            // //     }
            // // }
            // // Drawing_ID__c,Drawing_Info__c,Drawing_ID_Override__c,Dim_A__c,Dim_A_Override__c,Dim_B__c,Dim_B_Override__c,Dim_C__c,Dim_C_Override__c,Dim_D__c,Dim_D_Override__c,Dim_E__c,Dim_E_Override__c,Dim_F__c,Dim_F_Override__c from  RD_Drawings__c
            // upsert conProd;
            // //if(!conProd.Quote_Descriptions_Override__c)
            // upsert rdOutput;
            // Map<String,string> consolidatedMap=new Map<String,string>();
            // RDOU.rdOutputs=rdOutput;
            // consolidatedMap=RDOU.getMapDetails();
            // RDOU.RD_tblASMEValues=RDOU.RD_tblASMEValues();
            // if(!notValidStatusForChng.contains(strQuoteStatus)) {
            //     getDiaData();
            //     quoteLine.Run_Config_Sync__c = false;
            //     quoteLine.Config_Record_Id__c = conProd.id;
            //     quoteLine.SBQQ__Quantity__c=conProd.Quantity__c;
            //     quoteLine.Engineering_Notes__c = conProd.Engineering_Notes__c;
            //     if(rdPricing.Non_Discountable_Price_Each__c!=9999999 && rdPricing.Non_Discountable_Price_Each__c!=8888888)
            //         quoteLine.Non_Discountable_List_Price__c =  rdPricing.Non_Discountable_Price_Each__c.setScale(2)/ conProd.Quantity__c;
            //     else
            //         quoteLine.Non_Discountable_List_Price__c =  rdPricing.Non_Discountable_Price_Each__c ;
            //     // quoteLine.Non_Discountable_List_Price__c =  (rdPricing.Non_Discountable_Price_Each__c.setscale(2)/conProd.Quantity__c);
            //     quoteLine.Discountable_List_Price__c = rdPricing.Discountable_Price_Each__c.setscale(2);
            //     quoteLine.Leadtime_Site_10__c = rdOutput.Total_Lead_Time_GP_ORD__c;
            //     quoteLine.Leadtime_Site_20__c = rdOutput.Total_Lead_Time_GCI_ORD__c;
            //     quoteLine.Leadtime_Site_30__c = rdOutput.Total_Lead_Time_CDC_ORD__c;
            //     quoteLine.Leadtime_Site_40__c = rdOutput.Total_Lead_Time_40_ORD__c;
            //     quoteLine.Drawing_to_be_created_outside_of_Config__c=conProd.Drawing_Outside_Config__c;
            //     quoteLine.DimA__c=rdDiagram.Dim_A_Override__c;
            //     quoteLine.DimB__c=rdDiagram.Dim_B_Override__c;
            //     quoteLine.DimC__c=rdDiagram.Dim_C_Override__c;
            //     quoteLine.DimD__c=rdDiagram.Dim_D_Override__c;
            //     quoteLine.DimE__c=rdDiagram.Dim_E_Override__c;
            //     quoteLine.DimF__c=rdDiagram.Dim_F_Override__c;
            //     quoteLine.DrawingID__c=rdDiagram.Drawing_ID_Override__c;
            //     quoteLine.Body_Material__c=MCD;
            //     quoteLine.SBQQ__Description__c=strquoteDes.replaceAll('</BR>', '<BR>');
            //     upsert quoteLine;
            // }
            if(!Test.isRunningTest())
                calculateOutputs();
       /* }
        catch(Exception dmle)
        {
        	if(!ReorderFlag)
            	ApexPages.addMessages(dmle);
            return null;
        }*/
        reloadpage2.setRedirect(true);
        return reloadpage2;
        // return null;
    }
    public void calculateOutputs() {
        WizardPricingProcessor wzdPrz=new WizardPricingProcessor(conProd.id);
        result resPric=wzdPrz.getRDAdderPriceValues();
        System.debug('SOQL COUNT Checkp Pricing'+Limits.getAggregateQueries());
        System.debug('PRicing Ends : ' + resPric);
        RDOU=new RdOutputBaseUtility(conProd.id);
        RDOBUStructWrapper=RDOU.getConsolidatedStructureDetails();
        if(!conProd.Lead_Time_Override__c ) {
            if(!Test.isRunningTest())
            	result re1s=RDOU.getRDLeadTime();
        }

        RD_Outputs__c[] rdOutputList=[Select Base_Lead_Time_GP__c,Base_Lead_Time_GCI__c,Base_Lead_Time_CDC__c,Base_Lead_Time_40__c,
                                      Adder_Lead_Time_GP__c,Adder_Lead_Time_GCI__c,Adder_Lead_Time_CDC__c,Adder_Lead_Time_40__c,
                                      Comp_Lead_Time_GP__c,Comp_Lead_Time_GCI__c,Comp_Lead_Time_CDC__c,Comp_Lead_Time_40__c,
                                      Total_Lead_Time_CDC__c,Total_Lead_Time_GP__c,Total_Lead_Time_GCI__c,Total_Lead_Time_GP_ORD__c,
                                      Total_Lead_Time_40__c,OW__c,OW_Override__c,OA__c,OA_Override__c,OB__c,OB_Override__c,ORP__c,
                                      ORP_Override__c,ORV__c,ORV_Override__c,Total_Lead_Time_CDC_ORD__c,Total_Lead_Time_GCI_ORD__c,
                                      LABMAT__c,Total_Lead_Time_40_ORD__c,LABDSC__c,ORP010__c,ORP015__c,ORP027__c,ORV010__c,ORV020__c,ORP020__c,ORP025__c,ORV025__c,
                                      ORV015__c,ORV027__c,SRV__c ,SRP__c
                                      FROM RD_Outputs__c
                                      WHERE RD_Outputs_Relation_Field__c=:conProd.Id  order by createddate asc];
        System.debug('RD_Outputs__c: ' + rdOutputList);
        rdOutlist=new List<RD_Outputs__c>();
        rdOutput=new RD_Outputs__c();
        if(rdOutputList.size()>0)
            rdOutput=rdOutputList[0];
        rdOutlist.add(rdOutput);
        //if(!conProd.Quote_Descriptions_Override__c) {
        String strOW=' ';
        result resOW=RDOU.getOW();
        System.debug('resOW: ' + resOW);
        if (resOW.bResult) {
            strOW=resOW.strRetValue;
            strOW=strOW.replace('\\n','\n');
        }
        System.debug('OW1--->>>'+strOW);
        strOW=strOW.replaceAll('\n\n', '\n');
        System.debug('OW2--->>>'+strOW);
        //'OA__c','LABDSC__c'
        if(strOW.length()>1251) {
            rdOutput.OW__c=strOW.substring(0, 1250);
            if(!conProd.Quote_Descriptions_Override__c)
                rdOutput.OW_Override__c =strOW.substring(0, 1250);
        } else {
            rdOutput.OW__c=strOW;
            if(!conProd.Quote_Descriptions_Override__c)
                rdOutput.OW_Override__c =strOW;
        }
        result resOA=RDOU.getOA();
        String resStrOA = '';
        String strOA='';
        String strLABDSC='';
        if (resOA.bResult) {
            for (sObject sOb:resOA.objResultList) {
                if ((String) sOb.get('OA__c')!=null){
                    strOA = (String) sOb.get('OA__c');
                    strOA = strOA.replace('\\n','\n');
                    strOA+= '\n';
                }

                if ((String) sOb.get('LABDSC__c')!=null)
                    strLABDSC+= (String) sOb.get('LABDSC__c')+'\n';
            }
        }
        System.debug('strOA: --'+strOA);
        rdOutput.LABDSC__c=strLABDSC;
        if(strOA.length()>251) {
            rdOutput.OA__c=strOA.substring(0, 250);
            if(!conProd.Quote_Descriptions_Override__c)
                rdOutput.OA_Override__c=strOA.substring(0, 250);
        } else  {
            rdOutput.OA__c=strOA;
            if(!conProd.Quote_Descriptions_Override__c)
                rdOutput.OA_Override__c=strOA;
        }
        map<string,string> OBMAP=RDOU.getOB_LABMAT_Ouput();
        if(OBMAP.get('OB').length()>251) {
            rdOutput.OB__c=OBMAP.get('OB').substring(0, 250);
            if(!conProd.Quote_Descriptions_Override__c)
                rdOutput.OB_Override__c=OBMAP.get('OB').substring(0, 250);
        } else {
            rdOutput.OB__c=OBMAP.get('OB');
            if(!conProd.Quote_Descriptions_Override__c)
                rdOutput.OB_Override__c=OBMAP.get('OB');
        }
        if(OBMAP.get('LABMAT').length()>251) {
            rdOutput.LABMAT__c=OBMAP.get('LABMAT').substring(0,OBMAP.get('LABMAT').length()-1).substring(0, 250);
            rdOutput.LABMAT__c = rdOutput.LABMAT__c.removeEnd('/');
        } else {
            rdOutput.LABMAT__c=OBMAP.get('LABMAT');
            rdOutput.LABMAT__c = rdOutput.LABMAT__c.removeEnd('/');
        }
        Decimal StartRelief = rtgRngWrap.StartRelief==null?0.0:rtgRngWrap.StartRelief;
        if(conProd.Relief_Type__c != 'Vacuum Relief'){
            // rtgRngWrap.RG3DRT=conProd.RG3DRT__c;
            // rtgRngWrap.RGSMIN=conProd.RGSMIN__c;
            // rtgRngWrap.RGSMAX=conProd.RGSMAX__c;
            if(rtgRngWrap.ORP015!=null)
                rdOutput.ORP015__c=rtgRngWrap.ORP015;
            rdOutput.ORP__c=rtgRngWrap.ORP;
            if(!conProd.Quote_Descriptions_Override__c)
                rdOutput.ORP_Override__c=rdOutput.ORP__c;

        }

        if(conProd.Relief_Type__c != 'Pressure Relief'){
            // rtgRngWrap.VG3DRT=conProd.VG3DRT__c;
            // rtgRngWrap.VGSMIN=conProd.VGSMIN__c;
            // rtgRngWrap.VGSMAX=conProd.VGSMAX__c;
            // rtgRngWrap.VG3MAX=conProd.VG3MAX__c;
            // rtgRngWrap.VG3MIN=conProd.VG3MIN__c;
            if(rtgRngWrap.ORV015!=null)
                rdOutput.ORV015__c=rtgRngWrap.ORV015;
            rdOutput.ORV__c=rtgRngWrap.ORV;
            if(!conProd.Quote_Descriptions_Override__c)
                rdOutput.ORV_Override__c=rtgRngWrap.ORV;
            // if(rtgRngWrap.SRV!=null)
            //     rdOutput.SRV__c=rtgRngWrap.SRV;
        }



        //}
        // rdOutput.ORP__c=conProd.ORP__c;
        // rdOutput.ORV__c=conProd.ORV__c;
        //
        // Need to uncomment
        WizardCostProcessor wcp = new WizardCostProcessor(conProd.Id);
        List<Cost__c> getCst = wcp.getRDCostData();
       // Ends here
       //
        //getCost();
        System.debug('SOQL COUNT Checkp Cost'+Limits.getAggregateQueries());

        System.debug('SOQL COUNT Checkp Outputs'+Limits.getAggregateQueries());
        getPricingData();
        // if(resDia.bResult)
        //     getDiaData();
       // string strBRANDCOD='test';
        //string ASSYPARTNOBASE='test';
		// Need to uncomment
        string strBRANDCODE=AssyPartDefinationProcessor.mapBrandwithCode.get(strBrand.ToUpperCase());
        string ASSYPARTNOBASE=strBRANDCODE+conProd.Product__c+ConstantsUtil.getSizeDesc(conProd.Size__c).SZC+conProd.Seat__c;
        // // Ends here
        System.debug('resPartEx: ' + ASSYPARTNOBASE);
        System.debug('resPartEx: ' + ConstantsUtil.getSizeDesc(conProd.Size__c).SZC);
        System.debug('resPartEx: ' + conProd.Seat__c);
        if(!conProd.Quote_Descriptions_Override__c)
            conProd.ASSYPARTNOBASE__c=ASSYPARTNOBASE;
        result resPartEx=new result();
        resPartEx=AssyPartDefinationProcessor.getPartNumberExisting(ASSYPARTNOBASE,conProd,'DISC');
        System.debug('resPartEx: ' + resPartEx);
        if(resPartEx.bResult)
            conProd.ASSYPARTEXISTING__c=resPartEx.strRetValue;
        else
            conProd.ASSYPARTEXISTING__c=null;

        // for(string str:lookUpAttr) {
        //     if(RDOU.mapRDAttr.containsKey(str)) {
        //         mapIFSAttributes.put(str,RDOU.mapRDAttr.get(str));
        //         System.debug('Final values : ' +RDOU.mapRDAttr.get(str));
        //     }
        // }
        // Drawing_ID__c,Drawing_Info__c,Drawing_ID_Override__c,Dim_A__c,Dim_A_Override__c,Dim_B__c,Dim_B_Override__c,Dim_C__c,Dim_C_Override__c,Dim_D__c,Dim_D_Override__c,Dim_E__c,Dim_E_Override__c,Dim_F__c,Dim_F_Override__c from  RD_Drawings__c
        upsert conProd;
        //if(!conProd.Quote_Descriptions_Override__c)
        upsert rdOutput;
        Map<String,string> consolidatedMap=new Map<String,string>();
        RDOU.rdOutputs=rdOutput;
        consolidatedMap=RDOU.getMapDetails();
        RDOU.RD_tblASMEValues=RDOU.RD_tblASMEValues();
        if(!notValidStatusForChng.contains(strQuoteStatus)) {
            getDiaData();
            quoteLine.Run_Config_Sync__c = false;
            quoteLine.Config_Record_Id__c = conProd.id;
            quoteLine.SBQQ__Quantity__c=conProd.Quantity__c;
            quoteLine.Engineering_Notes__c = conProd.Engineering_Notes__c;
            if(rdPricing.Non_Discountable_Price_Each__c!=9999999 && rdPricing.Non_Discountable_Price_Each__c!=8888888)
                quoteLine.Non_Discountable_List_Price__c =  rdPricing.Non_Discountable_Price_Each__c.setScale(2)/ conProd.Quantity__c;
            else
                quoteLine.Non_Discountable_List_Price__c =  rdPricing.Non_Discountable_Price_Each__c ;
            // quoteLine.Non_Discountable_List_Price__c =  (rdPricing.Non_Discountable_Price_Each__c.setscale(2)/conProd.Quantity__c);
            quoteLine.Discountable_List_Price__c = rdPricing.Discountable_Price_Each__c.setscale(2);
            quoteLine.Leadtime_Site_10__c = rdOutput.Total_Lead_Time_GP_ORD__c;
            quoteLine.Leadtime_Site_20__c = rdOutput.Total_Lead_Time_GCI_ORD__c;
            quoteLine.Leadtime_Site_30__c = rdOutput.Total_Lead_Time_CDC_ORD__c;
            quoteLine.Leadtime_Site_40__c = rdOutput.Total_Lead_Time_40_ORD__c;
            quoteLine.Drawing_to_be_created_outside_of_Config__c=conProd.Drawing_Outside_Config__c;
            quoteLine.DimA__c=rdDiagram.Dim_A_Override__c;
            quoteLine.DimB__c=rdDiagram.Dim_B_Override__c;
            quoteLine.DimC__c=rdDiagram.Dim_C_Override__c;
            quoteLine.DimD__c=rdDiagram.Dim_D_Override__c;
            quoteLine.DimE__c=rdDiagram.Dim_E_Override__c;
            quoteLine.DimF__c=rdDiagram.Dim_F_Override__c;
            quoteLine.DrawingID__c=rdDiagram.Drawing_ID_Override__c;
            quoteLine.Body_Material__c=MCD;
            quoteLine.SBQQ__Description__c=strquoteDes.replaceAll('</BR>', '<BR>');
            upsert quoteLine;
        }
    }
    public pageReference getPart() {
        string strBRANDCODE=AssyPartDefinationProcessor.mapBrandwithCode.get(strBrand.ToUpperCase());
        string ASSYPARTNOBASE=strBRANDCODE+conProd.Product__c+ConstantsUtil.getSizeDesc(conProd.Size__c).SZC+conProd.Seat__c;
        if(!conProd.Quote_Descriptions_Override__c) {

            conProd.ASSYPARTNOBASE__c=ASSYPARTNOBASE;
        } else {
            if(!string.isBlank(conProd.NEWSPCLPARTNOBASE__c))
                conProd.ASSYPARTNOBASE__c='';
            else
                conProd.ASSYPARTNOBASE__c=ASSYPARTNOBASE;
            //conProd.ASSYPARTNOBASE__c='';
        }
        return null;
    }
    public pageReference getPARTBASE() {
        if(!conProd.Quote_Descriptions_Override__c) {
            string strBRANDCODE=AssyPartDefinationProcessor.mapBrandwithCode.get(strBrand.ToUpperCase());
            string ASSYPARTNOBASE=strBRANDCODE+conProd.Product__c+ConstantsUtil.getSizeDesc(conProd.Size__c).SZC+conProd.Seat__c;
            conProd.ASSYPARTNOBASE__c=ASSYPARTNOBASE;
        } else {
            if(!string.isBlank(conProd.NEWSPCLPARTNOBASE__c))
                conProd.ASSYPARTEXISTING__c='';
            //conProd.ASSYPARTNOBASE__c='';
        }

        if(((string.isBlank(conProd.ASSYPARTNOBASE__c) && string.isBlank(conProd.NEWSPCLPARTNOBASE__c)) && conProd.Quote_Descriptions_Override__c) && conProd.Quote_Descriptions_Override__c) {
            // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Select Value for Partnumber Base'));
            // return null;
        } else {
            upsert conProd;
        }

        return null;
    }
    public map<string,string> mapNonIFSAttributes{set;get;}
    public map<string,string> mapIFSAttributes{set;get;}
    public string strquoteDes {
        get {
            String strProdOver = '';
            System.debug('SAM DEBUG strProdOver value 0: ' + strProdOver);
            if(String.isNotBlank(rdOutput.OA_Override__c)){
                strProdOver += rdOutput.OA_Override__c +'\n';
                System.debug('SAM DEBUG strProdOver value 1: ' + strProdOver);
            }
            
            if(String.isNotBlank(rdOutput.OB_Override__c)){
                strProdOver += rdOutput.OB_Override__c+'\n';
                System.debug('SAM DEBUG strProdOver value 2: ' + strProdOver);
            }
            
            if(String.isNotBlank(rdOutput.ORP_Override__c)){
                strProdOver += rdOutput.ORP_Override__c+'\n' ;
                System.debug('SAM DEBUG strProdOver value 3: ' + strProdOver);
            }
            
            if(String.isNotBlank(rdOutput.ORV_Override__c)){
                strProdOver += rdOutput.ORV_Override__c+'\n' ;
                System.debug('SAM DEBUG strProdOver value 4: ' + strProdOver);
            }
            
            if(String.isNotBlank(rdOutput.OW_Override__c)){
                strProdOver += rdOutput.OW_Override__c;
                System.debug('SAM DEBUG strProdOver value 5: ' + strProdOver);
            }
            System.debug('SAM DEBUG strquoteDes value 6: ' + strquoteDes);
            System.debug('DEBUGGG strquoteDes BEFORE:::' +strquoteDes);
            System.debug('DEBUGGG strProdOver BEFORE:::' +strProdOver);
            strquoteDes = strProdOver;
            System.debug('DEBUGGG strquoteDes AFTER:::' +strquoteDes);
            System.debug('DEBUGGG strProdOverAFTER:::' +strProdOver);

            System.debug('SAM DEBUG strProdOver replace value : ' + strquoteDes.replaceAll('\n', '</BR>'));
            return strquoteDes.replaceAll('\n', '</BR>');
            //return rdOutput.OA_Override__c+'\n'+rdOutput.OB_Override__c+'\n'+rdOutput.ORP_Override__c+'\n'+rdOutput.ORV_Override__c+'\n'+rdOutput.OW_Override__c;
        }
        set {
            this.strquoteDes=value;
        }
    }
    public boolean showSurfaceFinish {
        get {
            List<String> listProd=new  List<String>();
            listProd.add('SNL');//Ticket # 161642 , 02 Feb 2021
            listProd.add('SNX');
            listProd.add('LPX');
            listProd.add('HPZ');
            listProd.add('HPS');
            listProd.add('HPH');
            listProd.add('HP2');
            listProd.add('SXM');
            listProd.add('SNA');
            
            if(listProd.CONTAINS(conProd.Product__c) && (MCD=='050'||MCD=='005'))
                return TRUE;
            ELSE
                return FALSE;

        }
        SET {
            this.showSurfaceFinish=value;
        }
    }
    public boolean shwShellTest {
        get {
            //List<String> PTCName = new List<String>{'CDS', 'CDT', 'LDS', 'LDT', 'LSS', 'LST', 'RVT', 'SRA', 'SST', 'STT'};
            //if(PTCName.CONTAINS(conProd.Product__c) && (String.isNotBlank(conProd.Material_Inlet_Ring2__c) || String.isNotBlank(conProd.Material_Inlet_Ring3__c) ||String.isNotBlank(conProd.Material_Inlet_Ring__c)))
            if( String.isNotBlank(conProd.Material_Inlet__c))
                return true;
            else {
                return false;
            }
        }
        set {
            this.shwShellTest=value;
        }
    }
    public boolean shwASMETEST {
        get {
           // List<string> lsPTC=new List<string>{'GFS','SLS'}; || lsPTC.contains(conProd.Product__c)
            if(conProd.ASME_Section_VIII_Division_1__c ) {
                return false;
            } else {
                return true;
            }
        }
        set {
            this.shwASMETEST=value;
        }
    }
    public boolean blShellTest {
        get {
            if(string.isNotBlank(conProd.Material_Inlet__c) && ((conProd.PED_2014_68_EU_CE_mark__c!='NonePED') || conProd.ASME_Section_VIII_Division_1__c)) {
                conProd.Shell_Test__c=true;
                return true;
            } else
                return false;
        }
        set {
            this.blShellTest=value;
            //conProd.Shell_Test__c=blShellTest;
        }
    }
    public void calculateRG3DRT() {
        system.debug('RG3DRT Value On ConfigureRD Cls@1044 Before'+conProd.RG3DRT__c);
        decimal intRG3DRT=rtgRngWrap.RG3DRT;
        decimal intTMRCHECK=rtgRngWrap.TMRCHECK;
        decimal intBMRCHECK=rtgRngWrap.BMRCHECK;
        List<String> prdListForLiners= new list<String>{'STD','LSS','LST','LSD'};
        decimal decTEMP=unitConversions.RoundNormal(conprod.Converted_Temperature_Setting__c,2);
        decimal decPress=0;
        // decimal decVG3DRT=unitConversions.RoundNormal(conProd.VG3DRT__c,2);
        // decimal decVac=0;
        if (decPBrustConvertedValue!=null)
            decPress=decPBrustConvertedValue;
        if (decVBrustConvertedValue!=null)
            decPress=0.0;
        System.debug('INSIDE----->>>>>>>>'+conProd.Product__c);
        System.debug('INSIDE----->>>>>>>>'+prdListForLiners);
        if(prdListForLiners.contains(conProd.Product__c)) {
            System.debug('INSIDE----->>>>>>>>');
            //Service Ticket #205427, added parameter for 3A Sanitary Stds
            cmpWrap=new  RDComponents(conProd.Product__c,conProd.Size__c,conProd.Seat__c,conProd.DSCVAR__c,MCD,intBMRCHECK,intTMRCHECK,strWSTD,decTEMP,decPress,conProd.Non_Fragmenting_Design_Required__c?'Yes':'No',conProd.Atex_Certificate__c?'Yes':'No',(!String.IsBlank(conProd.NACE__c)&&conProd.NACE__c!='N')?'Yes':'No', conProd.X3A_Sanitary_Standards__c);
        }
        // system.debug('RG3DRT Value On ConfigureRD Cls@1046 BEFORE SEAL'+intRG3DRT);
        // system.debug('RG3DRT TMRCHECK Value On ConfigureRD Cls@1047 BEFORE SEAL'+intTMRCHECK);
        // system.debug('RG3DRT BMRCHECK Value On ConfigureRD Cls@1048 BEFORE SEAL'+intBMRCHECK);
        List<RD_Seals_Component_Materials__c> sealComps=cmpWrap.getSealMAterials(conProd.Product__c,conProd.seat__c,SZC,conProd.Converted_Temperature_Setting__c,intTMRCHECK,conProd.Non_Fragmenting_Design_Required__c?'Yes':'No');
        List<SelectOption> opts=new List<SelectOption>();
        opts.add(new SelectOption('',''));
        Map<string,string> mapMatlCodewithMatl=cmpWrap.getMaterialNames();
        for (RD_Seals_Component_Materials__c sealMat:sealComps) {
            String key = sealMat.MatlCode__c;
            switch on key.length() {
                when 1 {
                    key = '00' + key;
                }
                when 2 {
                    key = '0' + key;
                }
            }
            if (mapMatlCodewithMatl.containsKey(key)) {
                opts.add(new SelectOption(key,mapMatlCodewithMatl.get(key)));
            } else {
                opts.add(new SelectOption(key,key));
            }
        }
        if(cmpWrap.mapMatOptions.containsKey('MCSS2')) {
            cmpWrap.mapMatOptions.get('MCSS2').clear();
            cmpWrap.mapMatOptions.get('MCSS2').addAll(opts);
        }
        if(cmpWrap.mapMatOptions.containsKey('MCSS1')) {
            cmpWrap.mapMatOptions.get('MCSS1').clear();
            cmpWrap.mapMatOptions.get('MCSS1').addAll(opts);
        }
        if(cmpWrap.mapMatOptions.containsKey('MCSS3')) {
            cmpWrap.mapMatOptions.get('MCSS3').clear();
            cmpWrap.mapMatOptions.get('MCSS3').addAll(opts);
        }
        List<String> prdList= new list<String>{'MCX','M9T'};
        system.debug('RG3DRT Value On ConfigureRD Cls@1086 BEFORE SEAL1-->'+intRG3DRT);
        system.debug('RG3DRT TMRCHECK Value On ConfigureRD Cls@1087 BEFORE SEAL1-->'+intTMRCHECK);
        system.debug('RG3DRT BMRCHECK Value On ConfigureRD Cls@1088 BEFORE SEAL1-->'+intBMRCHECK);
        if(prdList.contains(conProd.Product__c)) {
            System.debug('Vaccum Support Calling-->');
            cmpWrap.checkTypeB(MCD,intBMRCHECK);
            System.debug('Vaccum Support End-->');
        }
    }
    public void calRG3DRT() {

        string strMCSS='';
        if(string.isNotBlank(conProd.Material_Seal__c))
            strMCSS=conProd.Material_Seal__c;
        else if(string.isNotBlank(conProd.Material_Seal2__c))
            strMCSS=conProd.Material_Seal2__c;
        else if(string.isNotBlank(conProd.Material_Seal3__c))
            strMCSS=conProd.Material_Seal3__c;
        List<String> myStrings = new List<String>{'070','071','072','073'};
            if(myStrings.contains(strMCSS))
            rtgRngWrap.MCSM='';
        decimal intRG3DRT=rtgRngWrap.RG3DRT;
        decimal intTMRCHECK=rtgRngWrap.TMRCHECK;
        decimal intBMRCHECK=rtgRngWrap.BMRCHECK;
        system.debug('RG3DRT Value On ConfigureRD Cls@1086 strMCSS-->'+strMCSS);
        system.debug('RG3DRT Value On ConfigureRD Cls@1086 --->'+intRG3DRT);
        system.debug('RG3DRT TMRCHECK Value On ConfigureRD Cls@1087 After intTMRCHECK-->'+intTMRCHECK);
        system.debug('RG3DRT BMRCHECK Value On ConfigureRD Cls@1088 After intBMRCHECK-->'+intBMRCHECK);
        //for testclass, 19 feb 2021
	if(!Test.isRunningTest())
        	rtgRngWrap.addMetalSealCheck=rtgRngWrap.isMetalCheck(strMCSS); 
        system.debug('RG3DRT BMRCHECK Value On ConfigureRD Cls MEtal Seal Check -->'+rtgRngWrap.addMetalSealCheck);
        if(rtgRngWrap.addMetalSealCheck) {
            if(string.isNotBlank(conProd.Material_Seal__c))
                strMCSS=conProd.Material_Seal__c;
            else if(string.isNotBlank(conProd.Material_Seal2__c))
                strMCSS=conProd.Material_Seal2__c;
            else if(string.isNotBlank(conProd.Material_Seal3__c))
                strMCSS=conProd.Material_Seal3__c;
            string abc=rtgRngWrap.MCSM;
            intRG3DRT=rtgRngWrap.RG3DRT;
            intTMRCHECK=rtgRngWrap.TMRCHECK;
            intBMRCHECK=rtgRngWrap.BMRCHECK;

            // system.debug('RG3DRT Value On ConfigureRD Cls@1086 After SEAL2'+intRG3DRT);
            // system.debug('RG3DRT TMRCHECK Value On ConfigureRD Cls@1087 After SEAL2'+intTMRCHECK);
            // system.debug('RG3DRT BMRCHECK Value On ConfigureRD Cls@1088 After SEAL2'+intBMRCHECK);
        }
        conProd.MCSM__c=rtgRngWrap.MCSM;
        system.debug('RG3DRT BMRCHECK Value On ConfigureRD MCSM-->'+rtgRngWrap.MCSM);
        conProd.RG3DRT__c=intRG3DRT;
        conProd.BMRCHECK__c=intBMRCHECK;
        conProd.TMRCHECK__c=intTMRCHECK;
        //rtgRngWrap.RG3DRT=conProd.RG3DRT__c;
        conProd.VG1MIN__c=rtgRngWrap.VG1MIN;
        conProd.VG2MIN__c=rtgRngWrap.VG2MIN;
        conProd.VGSMIN__c=rtgRngWrap.VGSMIN;
        conProd.RGSMIN__c=rtgRngWrap.RGSMIN;
        conProd.RGEMIN__c=rtgRngWrap.RGEMIN;
        System.debug('FINAL RG3DRT'+intRG3DRT);
        System.debug('FINAL VG2MIN__c'+conProd.VG2MIN__c);
        System.debug('FINAL RGSMIN__c'+conProd.RGSMIN__c);
        System.debug('FINAL RG3DRT'+intRG3DRT);
        boolean bl=showBDI;
        update conProd;
    }
     /*
    public List<SelectOption> getMediaTypes() {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('',''));
        options.add(new selectOption('Customer Specified','Customer Specified'));
        System.debug('dsbckbdskfj'+conProd.Evaluation_Per__c);
        if (conProd.Evaluation_Per__c!=null) {
            String mediaTy;
            if (conProd.Evaluation_Per__c=='ASME Gas/Vapor' || conProd.Evaluation_Per__c=='API Gas/Vapor' || conProd.Evaluation_Per__c=='ISO Gas/Vapor') {
                mediaTy='Gas/Vapor';
                System.debug('dsbckbdskfjbjkbk'+conProd.Evaluation_Per__c);
            } else if (conProd.Evaluation_Per__c=='ASME Water' || conProd.Evaluation_Per__c=='API Liquid' || conProd.Evaluation_Per__c=='ISO Liquid'|| conProd.Evaluation_Per__c=='API Omega Method Subcooled Liquid' ) {
                mediaTy='Liquid';
            } else if (conProd.Evaluation_Per__c=='ASME Steam' || conProd.Evaluation_Per__c=='API Steam' || conProd.Evaluation_Per__c=='ISO Dry Steam' || conProd.Evaluation_Per__c=='ISO Wet Steam') {
                mediaTy='Dry and Saturated Steam*Dry and Saturated or Superheated Steam*Homogenous Wet Steam of Dryness 90% and Over';
            } else {
                mediaTy='';
            }
            System.debug('eeeeeeeeeee'+mediaTy);
            List<Media_Property__c> mediaPropertyList=[select Media_Phase__c,Media__c from Media_Property__c where Media_Phase__c=:mediaTy];
            for (Media_Property__c mP:mediaPropertyList) {
                options.add(new selectOption(mP.Media__c,mP.Media__c));
            }
        }
        System.debug('eeeeeeeeeee'+options);
        return options;
    }
    public PageReference applyDefaluts() {
        if (conProd.Pressure_Units__c!=null) {
            conProd.Pressure_Setting_Units__c=conProd.Pressure_Units__c;
            conProd.Back_Pressure_Units__c=conProd.Pressure_Units__c;
            conProd.Positive_Pressure_Units__c=conProd.Pressure_Units__c;
            conProd.Enter_Relieving_Pressure_units__c=conProd.Pressure_Units__c;
            conProd.Vacuum_Setting_Units__c=conProd.Pressure_Units__c;
        }
        if (conProd.Temperature_Units__c!=null) {
            conProd.Temperature_Setting_Units__c =conProd.Temperature_Units__c;
            conProd.Enter_Different_Temperature_Units__c=conProd.Temperature_Units__c ;

        }
        if(conProd.Flow_Rate_Units__c!=null) {
            //conProd.Required_Flow_Capacity_Units__c=conProd.Flow_Rate_Units__c;
            conProd.Required_Flow_Units__c=conProd.Flow_Rate_Units__c;
        }
        return null;
    }*/

    // public PageReference saveRelief() {
    //     conProd.Relief_Flag__c=true;
    //     Result resultConvertPressure= new Result();
    //     Result resultConvertTemperature= new Result();
    //     Result resultConvertVaccum= new Result();
    //     Result resultConvertPositivePressure= new Result();
    //     if(conProd.Relief_Type__c=='Pressure Relief') {

    //         if (conProd.Pressure_Setting__c != Null)
    //         {
    //             resultConvertPressure=unitConversions.convertPressure(conProd.Pressure_Setting_Units__c,'psig',conProd.Pressure_Setting__c);
    //             if(resultConvertPressure.bResult)
    //                 conProd.Converted_Pressure_Setting__c=resultConvertPressure.dblRetValue;
    //             else
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
    //         }
    //         if(conProd.Temperature_Setting_Units__c==null|| String.IsBlank(conProd.Temperature_Setting_Units__c)) {
    //             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Temperature Units: Please enter a value'));

    //         }
    //         if (conProd.Temperature_Setting__c != Null )
    //         {

    //             result resultTempPressure=unitConversions.getConvertedValErrorMsg('Temparature',1000,-320,'Deg F',conProd.Temperature_Setting_Units__c,conProd.Temperature_Setting__c,'Temperature Units');
    //             if(resultTempPressure.bErrorCheck)
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,resultTempPressure.strErrorMessage));
    //             else {
    //                 resultConvertTemperature=unitConversions.convertTemperature(conProd.Temperature_Setting_Units__c,'Deg F',conProd.Temperature_Setting__c);
    //                 if(resultConvertTemperature.bResult)
    //                     conProd.Converted_Temperature_Setting__c=resultConvertTemperature.dblRetValue;
    //                 else
    //                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertTemperature.strErrorMessage));
    //             }

    //         }
    //         Result resultConvertBackPressure= new Result();
    //         if (conProd.Back_Pressure_Value__c != Null)
    //         {
    //             resultConvertBackPressure=unitConversions.convertPressure(conProd.Back_Pressure_Units__c,'psig',conProd.Back_Pressure_Value__c);
    //             if(resultConvertBackPressure.bResult)
    //                 conProd.Converted_Back_Pressure_Value__c=resultConvertBackPressure.dblRetValue;
    //             else
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,resultConvertBackPressure.strErrorMessage));
    //         }
    //     } else if (conProd.Relief_Type__c=='Vacuum Relief') {


    //         if (conProd.Vacuum_Setting__c != Null)
    //         {

    //             resultConvertVaccum=unitConversions.convertPressure(conProd.Vacuum_Setting_Units__c,'psig',conProd.Vacuum_Setting__c);
    //             if(resultConvertVaccum.bResult)
    //                 conProd.Converted_Vacuum_Setting__c=resultConvertVaccum.dblRetValue;
    //             else
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertVaccum.strErrorMessage));
    //         }
    //         if (conProd.Temperature_Setting__c != Null)
    //         {

    //             resultConvertTemperature=unitConversions.convertTemperature(conProd.Temperature_Setting_Units__c,'Deg F',conProd.Temperature_Setting__c);
    //             if(resultConvertTemperature.bResult)
    //                 conProd.Converted_Temperature_Setting__c=resultConvertTemperature.dblRetValue;
    //             else
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,resultConvertTemperature.strErrorMessage));
    //         }
    //         if (conProd.Positive_Pressure_Value__c != Null)
    //         {

    //             resultConvertPositivePressure=unitConversions.convertPressure(conProd.Positive_Pressure_Units__c,'psig',conProd.Positive_Pressure_Value__c);
    //             if(resultConvertPositivePressure.bResult)
    //                 conProd.Converted_Positive_Pressure_Value__c=resultConvertPositivePressure.dblRetValue;
    //             else
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPositivePressure.strErrorMessage));
    //         }
    //     } else {
    //         if (conProd.Pressure_Setting__c != Null)
    //         {
    //             resultConvertPressure=unitConversions.convertPressure(conProd.Pressure_Setting_Units__c,'psig',conProd.Pressure_Setting__c);
    //             if(resultConvertPressure.bResult)
    //                 conProd.Converted_Pressure_Setting__c=resultConvertPressure.dblRetValue;
    //             else
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
    //         }
    //         if (conProd.Temperature_Setting__c != Null)
    //         {

    //             resultConvertTemperature=unitConversions.convertTemperature(conProd.Temperature_Setting_Units__c,'Deg F',conProd.Temperature_Setting__c);
    //             if(resultConvertTemperature.bResult)
    //                 conProd.Converted_Temperature_Setting__c=resultConvertTemperature.dblRetValue;
    //             else
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertTemperature.strErrorMessage));
    //         }
    //         if (conProd.Vacuum_Setting__c != Null)
    //         {

    //             resultConvertVaccum=unitConversions.convertPressure(conProd.Vacuum_Setting_Units__c,'psig',conProd.Vacuum_Setting__c);
    //             if(resultConvertVaccum.bResult)
    //                 conProd.Converted_Vacuum_Setting__c=resultConvertVaccum.dblRetValue;
    //             else
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertVaccum.strErrorMessage));
    //         }
    //     }
    //     try {
    //         conProd.Bypass__c=false;
    //         //conProd=RDDataCleanProcessor.clearDataBasedOnReliefType(conProd);
    //         clearDataBasedOnReliefType();
    //         clearSectEProductSelection();
    //         string str=getProductNarrowFilterClause();
    //         //conProd.Bypass__c=false;
    //         upsert conProd;
    //     }
    //     catch(Exception dmle)
    //     {
    //         ApexPages.addMessages(dmle);
    //         return null;
    //     }
    //     return null;
    // }
    //******************************************************************************************************* */
    //Section B Logic
    //******************************************************************************************************* */
    public double dConvertedSpecificGravity=0;
    public double dConvertedSpecificVolume=0;
    public double dRelievingPressure=0;
    public double dRelievingTemp=0;
    public double dFlowRate=0;
    public List<String> requiredFlowRateCheck = new List<String> {
        'ASME WATER','WFF','hghghgg'
            };
                // public PageReference saveSizing() {
                //     conProd.Sizing_Flag__c =true;
                //     clearSizingData();
                //     //Reliveing Pressure Calculations
                //     System.debug('ConfigRD:saveSizing()');

                //     system.debug('saveSizing::Sizing Relieving Pressure'+conProd.Relieving_Pressure_at_Inlet__c);
                //     if (conProd.Relieving_Pressure_at_Inlet__c=='Enter Relieving Pressure Value/ units') {
                //         //decConRelievingPressure
                //         Result resultConvertRelievingPressure=unitConversions.convertPressure(conProd.Enter_Relieving_Pressure_units__c,unitConversions.relievPressBaseUOM,conProd.Enter_Relieving_Pressure_Value__c);
                //         if (resultConvertRelievingPressure.bResult) {
                //             decConRelievingPressure=resultConvertRelievingPressure.dblRetValue;
                //         }
                //     } else {
                //         System.debug('Presure Relieving1');
                //         if (conProd.Relieving_Pressure_at_Inlet__c.contains('%')) {
                //             System.debug('Presure Relieving2');
                //             Integer myInt = Integer.valueOf(conProd.Relieving_Pressure_at_Inlet__c.substringBefore('%'));
                //             System.debug('myInt r'+myInt);
                //             decimal adderVal;
                //             if (myInt==10) {
                //                 adderVal=0.1;
                //             } else if (myInt==16) {
                //                 adderVal=0.16;
                //             } else if (myInt==21) {
                //                 adderVal=2.1;
                //             } else {
                //                 adderVal=0;
                //             }
                //             System.debug('adderVal r'+adderVal);
                //             adderVal=decPBrustConvertedValue*adderVal;
                //             System.debug('adderVal'+adderVal);
                //             decConRelievingPressure=decPBrustConvertedValue+adderVal;
                //             System.debug('decConRelievingPressure'+decConRelievingPressure);
                //         } else {
                //             System.debug('Presure Relieving3');
                //             Integer myInt=Integer.valueOf(conProd.Relieving_Pressure_at_Inlet__c);
                //             decConRelievingPressure=decPBrustConvertedValue+myInt;
                //             System.debug('Presure Relieving4'+decConRelievingPressure);
                //         }
                //         decConRelievingPressure=unitConversions.convertPressure('psig',unitConversions.relievPressBaseUOM,decConRelievingPressure).dblRetValue;
                //     }
                //     //Reliveing Temperature Calculations
                //     if(conProd.Pressure_Relieving_Temperature__c =='Same As Temperature Setting') {
                //         System.debug('TEmp1 Units'+conProd.Temperature_Setting_Units__c);
                //         System.debug('TEmp1 '+conProd.Temperature_Setting__c);
                //         System.debug('TEmp Units'+unitConversions.mapRD_RelievingTemperatureBaseUOM);
                //         result doubleRelievingTemp=unitConversions.convertTemperature(conProd.Temperature_Setting_Units__c,unitConversions.relievTempBaseUOM,conProd.Temperature_Setting__c);
                //         if (doubleRelievingTemp.bResult) {
                //             decConRelievingTemp=doubleRelievingTemp.dblRetValue;
                //         }
                //     }
                //     else {
                //         System.debug('TEmp Units'+conProd.Enter_Different_Temperature_Units__c);
                //         System.debug('TEmp '+conProd.Enter_Different_Temperature_Value__c);
                //         System.debug('TEmp Units'+unitConversions.mapRD_RelievingTemperatureBaseUOM.get(conProd.Evaluation_Per__c));
                //         result doubleRelievingTemp=unitConversions.convertTemperature(conProd.Enter_Different_Temperature_Units__c ,unitConversions.relievTempBaseUOM,conProd.Enter_Different_Temperature_Value__c);
                //         if (doubleRelievingTemp.bResult) {
                //             decConRelievingTemp=doubleRelievingTemp.dblRetValue;
                //         }
                //     }
                //     //Density Calculations will start here
                //     if (conProd.Density_Specific_Volume_Specific_Gravity__c!=null) {
                //         Result resultConvertDensity=unitConversions.convertDensitySpecifyVolume(conProd.Density_SpecificVolume_SpcfcGravityUnits__c,'lb/ft3', conProd.Density_Specific_Volume_Specific_Gravity__c);
                //         if(resultConvertDensity.bResult)
                //             conProd.Converted_Density__c=resultConvertDensity.dblRetValue;
                //         else
                //             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error Message'+resultConvertDensity.strErrorMessage));
                //     }
                //     //Specific Volume
                //     if(conProd.Specific_Volume_at_inlet__c!=null) {
                //         Result resultConverGravity=unitConversions.convertDensitySpecifyVolume(conProd.Specific_Volume_at_Inlet_Units__c,'lb/ft3', conProd.Specific_Volume_at_inlet__c);
                //         if(resultConverGravity.bResult)
                //             dConvertedSpecificVolume=resultConverGravity.dblRetValue;
                //         else
                //             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error Message'+resultConverGravity.strErrorMessage));
                //     }
                //     //Specific Gravity

                //     if(conProd.Density_at_Inlet__c!=null) {
                //         Result resultConverGravity=unitConversions.convertDensitySpecifyVolume(conProd.Density_at_Inlet_Units__c,'lb/ft3', conProd.Density_at_Inlet__c);
                //         if(resultConverGravity.bResult)
                //             dConvertedSpecificGravity=resultConverGravity.dblRetValue;
                //         else
                //             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error Message'+resultConverGravity.strErrorMessage));
                //     }
                //     //Required_Flow_Rate Conversion Calculations
                //     System.debug('Required_Flow_Rate Conversion Calculations');
                //     if (unitConversions.listGasFlowRatenew.contains(conProd.Evaluation_Per__c) || unitConversions.listStreamFlowRatenew.contains(conProd.Evaluation_Per__c)) {
                //         if(conProd.Required_Flow_Rate__c!=null && conProd.Required_Flow_units__c!=null) {
                //             result resultFlowCapacity=unitConversions.convertGasFlowRate(conProd.Required_Flow_units__c,unitConversions.mapRD_FlowRateBaseUOM.get(conProd.Evaluation_Per__c),conProd.Required_Flow_Rate__c,decConRelievingPressure,conProd.Molecular_Weight__c,decConRelievingTemp,conProd.Compressibility_Factor__c );
                //             if (resultFlowCapacity.bResult) {
                //                 doubleConvertedFlowCapacity=resultFlowCapacity.dblRetValue;
                //             }
                //         }
                //     } else {
                //         if(conProd.Converted_Density__c!=null && conProd.Required_Flow_Rate__c!=null) {
                //             result resultFlowCapacity=unitConversions.convertLiquidFlowRate(conProd.Required_Flow_units__c,unitConversions.mapRD_FlowRateBaseUOM.get(conProd.Evaluation_Per__c),conProd.Required_Flow_Rate__c,conProd.Converted_Density__c);
                //             if (resultFlowCapacity.bResult) {
                //                 doubleConvertedFlowCapacity=resultFlowCapacity.dblRetValue;
                //             }
                //         }
                //     }
                //     //Calculate Viscosity
                //     result resultConvertViscosity=new result();
                //     if (conProd.Viscosity__c !=null) {
                //         resultConvertViscosity=unitConversions.convertViscosity(conProd.Viscosity_units__c,unitConversions.mapRD_ViscosityBaseUOM.get(conProd.Evaluation_Per__c), conProd.Viscosity__c);
                //         if(resultConvertViscosity.bResult)
                //             conProd.Converted_Viscosity__c=resultConvertViscosity.dblRetValue;
                //         else
                //             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,resultConvertViscosity.strErrorMessage));
                //     }
                //     Result doubleFlowArea =new Result();
                //     if (unitConversions.relievPressBaseUOM !=unitConversions.mapRD_RelievingPressureBaseUOM.get(conProd.Evaluation_Per__c)) {
                //         decConRelievingPressure=unitConversions.convertPressure(unitConversions.relievPressBaseUOM,unitConversions.mapRD_RelievingPressureBaseUOM.get(conProd.Evaluation_Per__c),decConRelievingPressure).dblRetValue;
                //     }
                //     if (unitConversions.relievTempBaseUOM !=unitConversions.mapRD_RelievingTemperatureBaseUOM.get(conProd.Evaluation_Per__c)) {
                //         System.debug('decConRelievingTemp In'+unitConversions.relievTempBaseUOM);
                //         System.debug('decConRelievingTemp In'+unitConversions.mapRD_RelievingTemperatureBaseUOM.get(conProd.Evaluation_Per__c));
                //         result dec=unitConversions.convertTemperature(unitConversions.relievTempBaseUOM,unitConversions.mapRD_RelievingTemperatureBaseUOM.get(conProd.Evaluation_Per__c),decConRelievingTemp);
                //         if(dec.bResult) {
                //             decConRelievingTemp=dec.dblRetValue;
                //         }
                //     }
                //     System.debug('decConRelievingTemp'+decConRelievingTemp);
                //     switch on conProd.Evaluation_Per__c {
                //         When 'ASME Gas/Vapor' {
                //             if(conProd.Media_Type__c=='Air' )
                //                 doubleFlowArea=RDDiscSizingCapacity.ASMEAIRSize(doubleConvertedFlowCapacity.doubleValue(),decConRelievingPressure.doubleValue(),decConRelievingTemp.doubleValue(),conProd.Molecular_Weight__c.doubleValue());
                //             else
                //                 doubleFlowArea=RDDiscSizingCapacity.ASMEGASSize(doubleConvertedFlowCapacity.doubleValue(),decConRelievingPressure.doubleValue(),decConRelievingTemp.doubleValue(),conProd.Ratio_of_Specific_Heats__c.doubleValue(),conProd.Molecular_Weight__c.doubleValue(),conProd.Compressibility_Factor__c.doubleValue());
                //         }
                //         When 'ASME Water'   {
                //             doubleFlowArea= RDDiscSizingCapacity.ASMEWaterSize(doubleConvertedFlowCapacity.doubleValue(),decConRelievingPressure.doubleValue(),Double.valueOf(14.7),dConvertedSpecificGravity );
                //         }
                //         When 'ASME Steam' {
                //             doubleFlowArea=RDDiscSizingCapacity.ASMESteamSize(doubleConvertedFlowCapacity.doubleValue(),decConRelievingPressure.doubleValue());
                //         }
                //         when 'API Gas/Vapor' {
                //             doubleFlowArea=RDDiscSizingCapacity.APIGASSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(), Double.valueOf(14.7),conProd.Ratio_of_Specific_Heats__c.doubleValue(), decConRelievingTemp.doubleValue(), conProd.Molecular_Weight__c.doubleValue(), conProd.Compressibility_Factor__c.doubleValue());
                //         }
                //         When 'API Liquid' {
                //             System.debug('u r here gentleman');
                //             doubleFlowArea=RDDiscSizingCapacity.APILiquidSize(doubleConvertedFlowCapacity.doubleValue(),decConRelievingPressure.doubleValue(), dConvertedSpecificGravity, resultConvertViscosity.dblRetValue, Double.valueOf(14.7));
                //         }
                //         when 'API Steam' {
                //             doubleFlowArea=RDDiscSizingCapacity.APISteamSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(),decConRelievingTemp.doubleValue());
                //         }
                //         When 'ISO Gas/Vapor' {
                //             //ISOGASSize(double Qm, double Po,double Pb,double To,double K, double M, double Zo)
                //             doubleFlowArea=RDDiscSizingCapacity.ISOGASSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(),double.valueOf(1.014),decConRelievingTemp.doubleValue(),conProd.Ratio_of_Specific_Heats__c.doubleValue(),conProd.Molecular_Weight__c.doubleValue(),conProd.Compressibility_Factor__c.doubleValue());
                //         }
                //         When 'ISO Liquid' {
                //             // doubleFlowArea=RDDiscSizingCapacity.ISOLiquidSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(),dConvertedSpecificVolume,conProd.Converted_Viscosity__c.doubleValue(),double.valueOf(1.014));
                //         }
                //         When 'ISO Dry Steam' {
                //             doubleFlowArea=RDDiscSizingCapacity.ISODryStreamSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(), decConRelievingTemp.doubleValue());
                //             // System.debug('sfdsfdsgfdsyufgdshfgsdfg'+doubleFlowArea.strErrorMessage);
                //         }
                //         when 'ISO Wet Steam' {
                //             doubleFlowArea=RDDiscSizingCapacity.ISOWetStreamSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(),Double.valueOf(conProd.Dryness_of_Wet_Steam__c));
                //             // System.debug('sfdsfdsgfdsyufgdshfgsdfg'+doubleFlowArea.strErrorMessage);
                //         }
                //     }
                //     try {
                //         if (doubleFlowArea.bResult){
                //             conProd.Flow_Area__c=doubleFlowArea.dblRetValue;
                //             result conRes=unitConversions.convertArea('in2',conProd.Required_Flow_Area_Units__c,conProd.Flow_Area__c);
                //             if (conRes.bResult) {
                //                 conProd.Output_Required_Flow_Area__c=conRes.dblRetValue;
                //             }
                //         }
                //         System.debug('Convered Flow Area: ' + conProd.Output_Required_Flow_Area__c);
                //         conProd.Bypass__c=false;
                //         upsert conProd;
                //     }
                //     catch(Exception dmle)
                //     {
                //         ApexPages.addMessages(dmle);
                //         return null;
                //     }
                //     return null;
                // }
                //**************************************************************************************************** */
                //Product Section E
                //******************************************************************************************************* */
               /* public PageReference saveProductSelection() {
                    conProd.Product_Selection__c=true;
                    //try {
                    conProd.Bypass__c=false;
                    // conProd.MNFA__c=RDDiscSizingCapacity.RDMasterBlaster(Integer.valueOf(conProd.Size__c), conProd.Product__c, conProd.Seat__c).dblRetValue;
                    // result resDSCVAR=RDDiscSizingCapacity.RD_DSCVAR(Integer.valueOf(conProd.Size__c), conProd.Product__c, conProd.Seat__c);
                    // if (resDSCVAR.bResult)
                    //     conProd.DSCVAR__c=resDSCVAR.strRetValue;
                    // System.debug('resDSCVAR: ' + resDSCVAR);

                    upsert conProd;
                    rtgRngWrap = new RDRatingRange(conProd, conProd.Product__c, conProd.Size__c);
                    System.debug('conProd.Product__c: ' + conProd.Product__c);
                    System.debug('conProd.Size__c: ' + conProd.Size__c);
                    System.debug('conProd.Seat__c: ' + conProd.Seat__c);
                    System.debug('conProd.DSCVAR__c: ' + conProd.DSCVAR__c);
                    System.debug('conProd.DSCVAR__c: ' + conProd.Disc_Material_of_Construction__c);

                    //} catch(Exception dmle) {
                    //  ApexPages.addMessages(dmle);
                    //return null;
                    //}
                    PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
                    pageRef.setRedirect(true);
                    return pageRef;
                    //return tempPage ;
                    //return null;
                }*/
    //******************************************************************************************* */
    //LOGIC TO GET DIAGRAMS
    //******************************************************************************************* */
    public string diagramURL{set;get;}
    public boolean showDia1{set;get;}
    public boolean showDia2{set;get;}
    public result loadDiagramData() {
        result resDiaData=new result();
        map<string,string> mapDia=new map<string,string>();
        mapDia.put('PTC',conProd.Product__c);
        mapDia.put('SZC',ConstantsUtil.getSizeDesc(conProd.Size__c).SZC);
        mapDia.put('STC',conProd.Seat__c);
        mapDia.put('HCLASS',conProd.Pressure_Class__c);
        mapDia.put('HIC',conProd.Inlet_Connection__c);
        mapDia.put('HOC',conProd.Outlet_Connection__c);
        mapDia.put('DSCVAR',conProd.DSCVAR__c);
        mapDia.put('CUTR',conProd.CU_TR__c?'Y':'N');
        // mapDia.put('PTC','CAL');
        // mapDia.put('SZC','0300');
        // mapDia.put('STC','FS');
        // mapDia.put('HCLASS','N/A');
        // mapDia.put('HIC','N');
        // mapDia.put('HOC','N');
        // mapDia.put('DSCVAR','R');
        // mapDia.put('CUTR','Yes');
        List <String> selectCols=new List <String>();
        selectCols.add('DWGNO__c');
        selectCols.add('DrawingID__c');
        selectCols.add('Revision__c');
        selectCols.add('DimA__c');
        selectCols.add('DimB__c');
        selectCols.add('DimC__c');
        selectCols.add('DimD__c');
        selectCols.add('DimE__c');
        selectCols.add('DimF__c');
        selectCols.add('Document_Type__c');
        mapDia.put('SizeValue',String.ValueOf(ConstantsUtil.getSizeDesc(conProd.Size__c).SizeValue));
        resDiaData=wizardBaseDataProcessor.getDataFromTranslationObj('Document_Type__c','RD_Manufacturing_Document_Translation__c','RD_Manufacturing_Document_Detail__c',mapDia,selectCols);

        result resD=new result ();
        List<RD_Drawings__c> rdDiagramList1=[select Drawing_Number__c,IINO_Drawing_Number__c,Drawing_ID__c,Drawing_Info__c,Drawing_ID_Override__c,Dim_A__c,Dim_A_Override__c,Dim_B__c,Dim_B_Override__c,Dim_C__c,Dim_C_Override__c,Dim_D__c,Dim_D_Override__c,Dim_E__c,Dim_E_Override__c,Dim_F__c,Dim_F_Override__c from  RD_Drawings__c where Rupture_Disc__c=:conProd.id  order by createddate asc];
        RD_Drawings__c rdD= new RD_Drawings__c();
        if (rdDiagramList1.size()>0) {
            rdD=rdDiagramList1[0];
        } else {
            rdD.Rupture_Disc__c=conProd.id;
        }
        List<RD_Drawings__c> rdDiaList = new List<RD_Drawings__c>();
        boolean isDiaFound=false;
        if(resDiaData.bResult) {
            for (sObject sObj: resDiaData.objResultList) {
                if ((string) sObj.get('Document_Type__c')=='AssyDwg') {
                    isDiaFound=true;
                    rdD.Drawing_ID__c=(string) sObj.get('DrawingID__c');
                    rdD.Dim_A__c=(string) sObj.get('DimA__c');
                    rdD.Dim_B__c=(string) sObj.get('DimB__c');
                    rdD.Dim_C__c=(string) sObj.get('DimC__c');
                    rdD.Dim_D__c=(string) sObj.get('DimD__c');
                    rdD.Dim_E__c=(string) sObj.get('DimE__c');
                    rdD.Dim_F__c=(string) sObj.get('DimF__c');
                    rdD.Drawing_Number__c=(string) sObj.get('DWGNO__c');
                    rdD.Revision__c=(string) sObj.get('Revision__c');
                    if(!conProd.Diagram_Override__C) {
                        rdD.Drawing_ID_Override__c=(string) sObj.get('DrawingID__c');
                        rdD.Dim_A_Override__c=(string) sObj.get('DimA__c');
                        rdD.Dim_B_Override__c=(string) sObj.get('DimB__c');
                        rdD.Dim_C_Override__c=(string) sObj.get('DimC__c');
                        rdD.Dim_D_Override__c=(string) sObj.get('DimD__c');
                        rdD.Dim_E_Override__c=(string) sObj.get('DimE__c');
                        rdD.Dim_F_Override__c=(string) sObj.get('DimF__c');
                    }
                    //rdD.Rupture_Disc__c=conProd.id;
                } else if ((string) sObj.get('Document_Type__c')=='IINO'){
                    rdD.IINO_Drawing_Number__c=(string) sObj.get('DWGNO__c');
                    rdD.Drawing_Info__c=(string) sObj.get('DrawingID__c');
                    if(!conProd.Diagram_Override__C) {
                        rdD.Drawing_Info_Override__c=(string) sObj.get('DrawingID__c');
                    }
                }
            }
            if(resDiaData.objResultList.size()==0 || !isDiaFound) {
                rdD.Drawing_ID__c='9999';
                rdD.Dim_A__c='';
                rdD.Dim_B__c='';
                rdD.Dim_C__c='';
                rdD.Dim_D__c='';
                rdD.Dim_E__c='';
                rdD.Dim_F__c='';
                if(!conProd.Diagram_Override__C) {
                    rdD.Drawing_ID_Override__c='9999';
                    rdD.Dim_A_Override__c='';
                    rdD.Dim_B_Override__c='';
                    rdD.Dim_C_Override__c='';
                    rdD.Dim_D_Override__c='';
                    rdD.Dim_E_Override__c='';
                    rdD.Dim_F_Override__c='';
                }
            }
            try {
                rdDiaList.add(rdD);
                upsert rdD;
                resD.objResultList= rdDiaList;
                resD.bResult=true;
            } catch (Exception e) {
                resD.bResult=false;
                resD.strErrorMessage='RECORDS ARE NOT FOUND';
            }
            //resDiaData.objResultList.add(rdD);
            resDiaData.bResult=true;
        } else {
            rdD.Drawing_ID__c='9999';
            rdD.Dim_A__c='';
            rdD.Dim_B__c='';
            rdD.Dim_C__c='';
            rdD.Dim_D__c='';
            rdD.Dim_E__c='';
            rdD.Dim_F__c='';
            if(!conProd.Diagram_Override__C) {
                rdD.Drawing_ID_Override__c='9999';
                rdD.Dim_A_Override__c='';
                rdD.Dim_B_Override__c='';
                rdD.Dim_C_Override__c='';
                rdD.Dim_D_Override__c='';
                rdD.Dim_E_Override__c='';
                rdD.Dim_F_Override__c='';
            }
            try {
                rdDiaList.add(rdD);
                upsert rdD;
                resD.objResultList= rdDiaList;
                resD.bResult=true;
            } catch (Exception e) {
                resD.bResult=false;
                resD.strErrorMessage='RECORDS ARE NOT FOUND';
            }
            //resDiaData.objResultList.add(rdD);
            resDiaData.bResult=true;
        }

        return resD;
    }
    public RD_Drawings__c rdDiagram{set;get;}
    public RD_Drawings__c prodDiagram{set;get;}
    public List<RD_Drawings__c> rdDiagramList {set;get;}
    public void getDiaData() {
        rdDiagramList=[select Drawing_Number__c,IINO_Drawing_Number__c,Drawing_ID__c,Drawing_Info__c,Drawing_ID_Override__c,Dim_A__c,Dim_A_Override__c,Dim_B__c,Dim_B_Override__c,Dim_C__c,Dim_C_Override__c,Dim_D__c,Dim_D_Override__c,Dim_E__c,Dim_E_Override__c,Dim_F__c,Dim_F_Override__c from  RD_Drawings__c where Rupture_Disc__c=:conProd.id];
        if (!rdDiagramList.isEmpty()) {
            rdDiagram=rdDiagramList[0];
            diagramURL=rdDiagram.Drawing_ID_Override__c;
            diagramURL+='.png';
            if(diagramURL.startsWith('1')) {
                showDia1=true;
                showDia2=false;
            }
            else {
                showDia2=true;
                showDia1=false;
            }

        } else {
            result abc=loadDiagramData();
            if (abc.bResult)
                rdDiagram=(RD_Drawings__c) abc.objResultList[0];
        }
        //System.debug('mapDocData: ' + mapDocData);
        if(rdDiagram.Drawing_Number__c!=null)
            mapDocData.put('AssyDwg',rdDiagram.Drawing_Number__c);
        else
            mapDocData.put('AssyDwg','');
        if(rdDiagram.IINO_Drawing_Number__c!=null)
            mapDocData.put('IINO (Installation Instruction Document Number)',rdDiagram.IINO_Drawing_Number__c);
        else
            mapDocData.put('IINO (Installation Instruction Document Number)','');
        System.debug('mapDocData: ' + mapDocData);
    }
    public pageReference generalSave() {
        try {
            update conProd;
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                quoteLine.Run_Config_Sync__c = false;
                quoteLine.Engineering_Notes__c = conProd.Engineering_Notes__c;
                upsert quoteLine;
            }
        } catch (Exception e) {

        }
        return null;
    }
    public pageReference saveDiagrams() {
        try {
            update rdDiagram;
            update conProd;
            getDiaData();
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                quoteLine.Drawing_to_be_created_outside_of_Config__c=conProd.Drawing_Outside_Config__c;
                quoteLine.DimA__c=rdDiagram.Dim_A_Override__c;
                quoteLine.DimB__c=rdDiagram.Dim_B_Override__c;
                quoteLine.DimC__c=rdDiagram.Dim_C_Override__c;
                quoteLine.DimD__c=rdDiagram.Dim_D_Override__c;
                quoteLine.DimE__c=rdDiagram.Dim_E_Override__c;
                quoteLine.DimF__c=rdDiagram.Dim_F_Override__c;
                quoteLine.DrawingID__c=rdDiagram.Drawing_ID_Override__c;
                //quoteLine.SBQQ__Description__c=strquoteDes;
                upsert quoteLine;
            }
        } catch (Exception e) {

        }
        return null;
    }
    public string disabledCSS3 {
        get {
            return 'border-color: rgb(201, 199, 197);background-color: rgb(236, 235, 234); width:210px;cursor: not-allowed; pointer-events: none;';
        }
        set;
    }
    public string disabledCSS2 {
        get {
            return 'border-color: rgb(201, 199, 197);background-color: rgb(236, 235, 234); cursor: not-allowed; pointer-events: none;';
        }
        set;
    }
    public string disabledCSS {
        get {
            return 'border-color: rgb(201, 199, 197);background-color: rgb(236, 235, 234); width:50px; cursor: not-allowed; pointer-events: none;';
        }
        set;
    }
    public string stlCSS2 {
        get {
            return 'border-color: rgb(201, 199, 197);background-color: rgb(236, 235, 234); width:80px; cursor: not-allowed; pointer-events: none;';
        }
        set;
    }
    public boolean disableDic {get;set;}
    public boolean disableTop {get;set;}
    public string stlCSS3 {
        get {
            return 'border-color: rgb(201, 199, 197);background-color: rgb(236, 235, 234); width:500px; cursor: not-allowed; pointer-events: none;';
        }
        set;
    }
    public string stlCSS21 {
        get {
            return 'border-color: rgb(201, 199, 197);background-color: rgb(236, 235, 234);  cursor: not-allowed; pointer-events: none;';
        }
        set;
    }
    public pageReference applyDefalutsDiagrams() {
        if(!conProd.Diagram_Override__C) {
            System.debug('conProd.Diagram_Override__C: ' + conProd.Diagram_Override__C);
            rdDiagram.Drawing_ID_Override__c=rdDiagram.Drawing_ID__c;
            rdDiagram.Dim_A_Override__c=rdDiagram.Dim_A__c;
            rdDiagram.Dim_B_Override__c=rdDiagram.Dim_B__c;
            rdDiagram.Dim_C_Override__c=rdDiagram.Dim_C__c;
            rdDiagram.Dim_D_Override__c=rdDiagram.Dim_D__c;
            rdDiagram.Dim_E_Override__c=rdDiagram.Dim_E__c;
            rdDiagram.Dim_F_Override__c=rdDiagram.Dim_F__c;
        }
        if(conProd.Drawing_Outside_Config__c) {
            rdDiagram.Drawing_ID_Override__c='9999';
            // rdDiagram.Drawing_ID__c='9999';
            rdDiagram.Dim_A_Override__c='';
            rdDiagram.Dim_B_Override__c='';
            rdDiagram.Dim_C_Override__c='';
            rdDiagram.Dim_D_Override__c='';
            rdDiagram.Dim_E_Override__c='';
            rdDiagram.Dim_F_Override__c='';
        }
        update rdDiagram;
        update conProd;
        getDiaData();
        if(!notValidStatusForChng.contains(strQuoteStatus)) {
            quoteLine.Drawing_to_be_created_outside_of_Config__c=conProd.Drawing_Outside_Config__c;
            quoteLine.DimA__c=rdDiagram.Dim_A_Override__c;
            quoteLine.DimB__c=rdDiagram.Dim_B_Override__c;
            quoteLine.DimC__c=rdDiagram.Dim_C_Override__c;
            quoteLine.DimD__c=rdDiagram.Dim_D_Override__c;
            quoteLine.DimE__c=rdDiagram.Dim_E_Override__c;
            quoteLine.DimF__c=rdDiagram.Dim_F_Override__c;
            quoteLine.DrawingID__c=rdDiagram.Drawing_ID_Override__c;
            //quoteLine.SBQQ__Description__c=strquoteDes;
            upsert quoteLine;
        }
        return null;
    }
    //***************************************************************************************************** */
    //PRICING LOGIC STARTS HERE
    //********************************************************************************************************* */
    public RD_Pricing__c rdPricing{set; get;}
    public Map<string,string> mapPricingFields {
        get{
            return WizardPricingProcessor.mapPricingfields;
        }
        set {
            mapPricingFields=value;
        }
    }
    public Map<string,string> mapPricingOverriddenFields {
        get{
            return WizardPricingProcessor.mapPricingOverriddenfields;
        }
        set {
            mapPricingOverriddenFields=value;
        }
    }
    public Map<string,string> mapNonDiscountableFields {
        get{
            return WizardPricingProcessor.mapNonDiscountableFields;
        }
        set {
            mapNonDiscountableFields=value;
        }
    }
    public Map<string,string> mapDiscountableFields {
        get{
            return WizardPricingProcessor.mapDiscountableFields;
        }
        set {
            mapDiscountableFields=value;
        }
    }
    public void getPricingData() {
        Result rupPrzRecord=wizardBaseDataProcessor.getRDPricingByProdId(conProd.Id);
        if (rupPrzRecord.bResult) {
            rdPricing= (RD_Pricing__c) rupPrzRecord.objResultList[0];
        } else {
            RD_Pricing__c rdPricing=new RD_Pricing__c();
        }
    }
    public pageReference applyDefalutsPricing() {
        //Map<string,string> pricingFieldset=
        System.debug('mapPricingFields: ' + mapPricingFields);
        System.debug('mapPricingOverriddenfields: ' + mapPricingOverriddenfields);
        decimal discountablePrz=0.0;
        decimal nonDiscountablePrz=0.0;
        decimal total=0.0;
        if(!conProd.Price_Override__c) {
            for (string key:mapPricingOverriddenFields.keySet()){
                System.debug('key: ' + key);
                rdPricing.put(mapPricingOverriddenFields.get(key),rdPricing.get(mapPricingFields.get(key)));
                if (rdPricing.get(mapPricingOverriddenFields.get(key))!=null) {
                    if(mapNonDiscountableFields.containsKey(key))
                        nonDiscountablePrz+=(decimal) rdPricing.get(mapPricingOverriddenFields.get(key));
                    else if (mapDiscountableFields.containsKey(key))
                        discountablePrz+=(decimal) rdPricing.get(mapPricingOverriddenFields.get(key));
                    if((decimal) rdPricing.get(mapPricingOverriddenFields.get(key))==9999999)
                        total=9999999;
                }
            }
            conProd.Discountable_Price__c=discountablePrz;
            conProd.Non_Discountable_Price__c=nonDiscountablePrz;
            RDPricing.Discountable_Price_Each__c=discountablePrz;
            RDPricing.Non_Discountable_Price_Each__c=nonDiscountablePrz;
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                quoteLine.Run_Config_Sync__c = false;
                if(nonDiscountablePrz!=9999999 && nonDiscountablePrz!=8888888)
                    quoteLine.Non_Discountable_List_Price__c =  nonDiscountablePrz.setScale(2)/ conProd.Quantity__c;
                else
                    quoteLine.Non_Discountable_List_Price__c =  nonDiscountablePrz ;

                //quoteLine.Non_Discountable_List_Price__c =   nonDiscountablePrz.setScale(2)/conProd.Quantity__c;
                quoteLine.Discountable_List_Price__c = discountablePrz.setScale(2);
                update quoteLine;
            }
            if(total==9999999)
                RDPricing.Total_Price__c=total;
            else
                RDPricing.Total_Price__c=discountablePrz+(nonDiscountablePrz/conProd.Quantity__c);
            //RDPricing.Total_Price__c=RDPricing.Discountable_Price_Each__c+RDPricing.Non_Discountable_Price_Each__c;
        }
        update rdPricing;
        update conProd;

        getPricingData();
        return null;
    }
    public pageReference savePricing() {
        try {
            decimal discountablePrz=0.0;
            decimal nonDiscountablePrz=0.0;
            decimal total=0.0;

            decimal baseA=0;
            decimal Ring=0;
            decimal Gasket=0;
            decimal Liner=0;
            decimal Coating=0;
            decimal holder=0;
            if(RDPricing.Rupture_Disc_TopSect_Price_Each_Override__c!=null)
                baseA+=RDPricing.Rupture_Disc_TopSect_Price_Each_Override__c;
            if(RDPricing.Seal_Price_Each_Override__c!=null)
                baseA+=RDPricing.Seal_Price_Each_Override__c;
            if(RDPricing.Girdle_Price_Each_Override__c!=null)
                baseA+=RDPricing.Girdle_Price_Each_Override__c;
            if(RDPricing.Quantity_Discount_Multiplier__c!=null)
                baseA*=rdPricing.Quantity_Discount_Multiplier__c;
            // if(RDPricing.HPXProMedia_Adder__c!=null)
            //     baseA+=RDPricing.HPXProMedia_Adder__c;
            RDPricing.Base_Rupture_Disc_Price_Each_Override__c=baseA;
            //Ring
            if(RDPricing.Inlet_Ring_Price_Each_Override__c!=null)
                Ring+=RDPricing.Inlet_Ring_Price_Each_Override__c;
            if(RDPricing.Outlet_Ring_Price_Each_Override__c!=null)
                Ring+=RDPricing.Outlet_Ring_Price_Each_Override__c;
            RDPricing.Ring_s_Price_Adder_Override__c=Ring;
            //GASKET
            if(RDPricing.Inlet_Gasket_Price_Each_Override__c!=null)
                Gasket+=RDPricing.Inlet_Gasket_Price_Each_Override__c;
            if(RDPricing.Outlet_Gasket_Price_Each_Override__c!=null)
                Gasket+=RDPricing.Outlet_Gasket_Price_Each_Override__c;
            RDPricing.Gasket_s_Price_Adder_Override__c=Gasket;
            //Liner
            if(RDPricing.Inlet_Liner_Price_Each_Override__c!=null)
                Liner+=RDPricing.Inlet_Liner_Price_Each_Override__c;
            if(RDPricing.Outlet_Liner_Price_Each_Override__c!=null)
                Liner+=RDPricing.Outlet_Liner_Price_Each_Override__c;
            RDPricing.Liner_s_Price_Adder_Override__c=Liner;
            //Coating
            if(RDPricing.Inlet_Coating_Price_Each_Override__c!=null)
                Coating+=RDPricing.Inlet_Coating_Price_Each_Override__c;
            if(RDPricing.Outlet_Coating_Price_Each_Override__c!=null)
                Coating+=RDPricing.Outlet_Coating_Price_Each_Override__c;
            RDPricing.Coating_s_Price_Adder_Override__c=Coating;
            //Holder
            if(RDPricing.Holder_Inlet_Price_Each_Override__c!=null)
                holder+=RDPricing.Holder_Inlet_Price_Each_Override__c;
            if(RDPricing.Holder_Outlet_Price_Each_Override__c!=null)
                holder+=RDPricing.Holder_Outlet_Price_Each_Override__c;
            if(RDPricing.Holder_Holddown_Ring_Price_Each_Override__c!=null)
                holder+=RDPricing.Holder_Holddown_Ring_Price_Each_Override__c;
            RDPricing.Holder_Price_Adder_Override__c=holder;
            // RDPricing.Base_Rupture_Disc_Price_Each_Override__c=(RDPricing.Rupture_Disc_TopSect_Price_Each_Override__c==null?0:RDPricing.Rupture_Disc_TopSect_Price_Each_Override__c+RDPricing.Seal_Price_Each_Override__c==null?0:RDPricing.Seal_Price_Each_Override__c+RDPricing.Girdle_Price_Each_Override__c==null?0:RDPricing.Girdle_Price_Each_Override__c)*rdPricing.Quantity_Discount_Multiplier__c;
            // //Ring
            // RDPricing.Ring_s_Price_Adder_Override__c=RDPricing.Inlet_Ring_Price_Each_Override__c==null?0:RDPricing.Inlet_Ring_Price_Each_Override__c+RDPricing.Outlet_Ring_Price_Each_Override__c==null?0:RDPricing.Outlet_Ring_Price_Each_Override__c;
            // //Gasket
            // RDPricing.Gasket_s_Price_Adder_Override__c=RDPricing.Inlet_Gasket_Price_Each_Override__c==null?0:RDPricing.Inlet_Gasket_Price_Each_Override__c+RDPricing.Outlet_Gasket_Price_Each_Override__c==null?0:RDPricing.Outlet_Gasket_Price_Each_Override__c;
            // //Liner
            // RDPricing.Liner_s_Price_Adder_Override__c=RDPricing.Inlet_Liner_Price_Each_Override__c==null?0:RDPricing.Inlet_Liner_Price_Each_Override__c+RDPricing.Outlet_Liner_Price_Each_Override__c==null?0:RDPricing.Outlet_Liner_Price_Each_Override__c;
            // //Coating
            // RDPricing.Coating_s_Price_Adder_Override__c=RDPricing.Inlet_Coating_Price_Each_Override__c==null?0:RDPricing.Inlet_Coating_Price_Each_Override__c+RDPricing.Outlet_Coating_Price_Each_Override__c==null?0:RDPricing.Outlet_Coating_Price_Each_Override__c;
            // //Holder
            // RDPricing.Holder_Price_Adder_Override__c=RDPricing.Holder_Inlet_Price_Each_Override__c==null?0:RDPricing.Holder_Inlet_Price_Each_Override__c+RDPricing.Holder_Outlet_Price_Each_Override__c==null?0:RDPricing.Holder_Outlet_Price_Each_Override__c+RDPricing.Holder_Holddown_Ring_Price_Each_Override__c==null?0:RDPricing.Holder_Holddown_Ring_Price_Each_Override__c;
            for (string key:mapPricingOverriddenFields.keySet()){
                System.debug('key: ' + key);
                if (rdPricing.get(mapPricingOverriddenFields.get(key))!=null) {
                    if(mapNonDiscountableFields.containsKey(key))
                        nonDiscountablePrz+=(decimal) rdPricing.get(mapPricingOverriddenFields.get(key));
                    else if (mapDiscountableFields.containsKey(key))
                        discountablePrz+=(decimal) rdPricing.get(mapPricingOverriddenFields.get(key));
                    if((decimal) rdPricing.get(mapPricingOverriddenFields.get(key))==9999999)
                        total=9999999;
                }
                //rdPricing.put(mapPricingOverriddenFields.get(key),rdPricing.get(mapPricingFields.get(key)));
            }
            RDPricing.Discountable_Price_Each__c=discountablePrz.setScale(2);
            RDPricing.Non_Discountable_Price_Each__c=nonDiscountablePrz.setScale(2);
            conProd.Discountable_Price__c=discountablePrz.setScale(2);
            conProd.Non_Discountable_Price__c=nonDiscountablePrz.setScale(2);
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                quoteLine.Run_Config_Sync__c = false;
                if(nonDiscountablePrz!=9999999 && nonDiscountablePrz!=8888888)
                    quoteLine.Non_Discountable_List_Price__c =  nonDiscountablePrz.setScale(2)/ conProd.Quantity__c;
                else
                    quoteLine.Non_Discountable_List_Price__c =  nonDiscountablePrz ;

                // quoteLine.Non_Discountable_List_Price__c =   nonDiscountablePrz.setScale(2)/conProd.Quantity__c;
                quoteLine.Discountable_List_Price__c = discountablePrz.setScale(2);
                update quoteLine;
            }
            //RDPricing.Total_Price__c=RDPricing.Discountable_Price_Each__c+RDPricing.Non_Discountable_Price_Each__c;
            if(total==9999999)
                RDPricing.Total_Price__c=total;
            else
                RDPricing.Total_Price__c=discountablePrz+(nonDiscountablePrz/conProd.Quantity__c);
            System.debug('Override nonDiscountablePrz'+nonDiscountablePrz);
            System.debug('Override discountablePrz'+discountablePrz);
            System.debug('Override total'+total);
            update rdPricing;
            update conProd;
            getPricingData();
        } catch (Exception e) {

        }
        return null;
    }
    //******************************************************************************************************* */
    //PRICING LOGIC ENDS HERe
    //******************************************************************************************************* */
    // public pageReference getTabData()
    // {
    //     return null;
    // }
    public PageReference saveRatingRange() {
        //  try {
        List<ApexPages.Message> msgs = rtgRngWrap.runConstraints();


        // if(conProd.Quantity__c <= 0){
        //     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Quantity '));
        // }
        if(msgs.size() > 0) {
            system.debug('MSGS-->>'+msgs);
            for(ApexPages.Message msg : msgs) {
                ApexPages.addMessage(msg);
                conProd.Rating_and_Range_Flag__c=false;
                system.debug('RATING ND RANGE @1948');
                update conProd;
                return null;
            }
        }
        clearCalculatedValues();
        clearOutputObject();
        if(conProd.Relief_Type__c=='Vacuum Relief'){

            if(conProd.Product__c == 'CAL'){
                if(conProd.Pressure_Withstand__c == 'No Requirements'){
                    rtgRngWrap.RGRAT1 = 'No Rating';
                    conProd.Pressure_Rating_Type__c = 'No Rating';
                } else {
                    rtgRngWrap.RGRAT1 = 'No Rating But Must Withstand';
                    conProd.Pressure_Rating_Type__c = 'No Rating But Must Withstand';
                }
       			System.debug('Inside Check No2 Rating2--->>>>>>>'+rtgRngWrap.RGRAT1);
            } else {
                rtgRngWrap.RGRAT1 = '';
                conProd.Pressure_Rating_Type__c = '';
            }
        }
        System.debug('Inside Check No Rating2--->>>>>>>'+rtgRngWrap.RGRAT1);
        System.debug('Inside Check No Rating3--->>>>>>>'+conProd.Pressure_Rating_Type__c);
        if(conProd.Relief_Type__c=='Pressure Relief'){
            if(conProd.Product__c == 'PAS'){
                if(conProd.Vacuum_Withstand__c == 'No Requirements'){
                    rtgRngWrap.VGRAT1 = 'No Rating';
                    conProd.Vac_Rating_Type__c = 'No Rating';
                } else if(conProd.Vacuum_Withstand__c == 'Back Pressure'){
                    rtgRngWrap.VGRAT1 = 'No Rating But Must Withstand';
                    conProd.Vac_Rating_Type__c = 'No Rating But Must Withstand';
                }
            }  else {
                rtgRngWrap.VGRAT1 = '';
                conProd.Vac_Rating_Type__c = '';
            }
        }
        system.debug('RATING ND RANGE @2425');
        if(conProd.Relief_Type__c=='Pressure Relief') {
            conProd.RG1MIN__c=rtgRngWrap.RG1MIN;
            conprod.RG1MAX__c=rtgRngWrap.RG1MAX;
            conProd.RG2MIN__c=rtgRngWrap.RG2MIN;
            conprod.RG2MAX__c=rtgRngWrap.RG2MAX;
            conProd.RGEMIN__c=rtgRngWrap.RGEMIN;
            conprod.TMR__c=rtgRngWrap.TMR;
            rdOutput.ORP__c=rtgRngWrap.ORP;
            if(conProd.Product__c == 'PAS') {
                rdOutput.ORV__c=rtgRngWrap.ORV;
                rdOutput.ORV010__c=rtgRngWrap.ORV010;
                rdOutput.ORV020__c=rtgRngWrap.ORV020;
                rdOutput.ORV025__c=rtgRngWrap.ORV025;
                rdOutput.ORV015__c=rtgRngWrap.ORV015;
                rdOutput.ORV027__c=rtgRngWrap.ORV027;
                if(!conProd.Quote_Descriptions_Override__c) {
                    rdOutput.ORV_Override__c=rtgRngWrap.ORV;
                }
            }
            rdOutput.ORP010__c=rtgRngWrap.ORP010;
            rdOutput.ORP020__c=rtgRngWrap.ORP020;
            rdOutput.ORP025__c=rtgRngWrap.ORP025;
            rdOutput.ORP015__c=rtgRngWrap.ORP015;
            rdOutput.ORP027__c=rtgRngWrap.ORP027;
            rdOutput.SRP__c=rtgRngWrap.SRP;
            if(!conProd.Quote_Descriptions_Override__c) {

                rdOutput.ORP_Override__c=rdOutput.ORP__c;

            }
            conProd.Assigned_RangeType__c=rtgRngWrap.AssignedRangeType;
            conProd.RG3DRT__c=rtgRngWrap.RG3DRT;
        }
        if(conProd.Relief_Type__c=='Vacuum Relief') {
            system.debug('RATING ND RANGE - Vacuum Relief @1975');
            conProd.VG2MIN__c=rtgRngWrap.VG2MIN;
            conprod.VG2MAX__c=rtgRngWrap.VG2MAX;
            conProd.VG1MIN__c=rtgRngWrap.VG1MIN;
            conprod.VG1MAX__c=rtgRngWrap.VG1MAX;
            conProd.VG3DRT__c=rtgRngWrap.VG3DRT;
            conprod.VTMR__c=rtgRngWrap.VTMR;
            rdOutput.ORV__c=rtgRngWrap.ORV;
            if(conProd.Product__c == 'CAL') {
                System.debug('RATING ND RANGE - Vacuum Relief--->>>>>>>'+rtgRngWrap.RGRAT1);
                System.debug('RATING ND RANGE - Vacuum Relief2--->>>>>>>'+rtgRngWrap.ORP);
                rdOutput.ORP__c=rtgRngWrap.ORP;
                rdOutput.ORP010__c=rtgRngWrap.ORP010;
                rdOutput.ORP020__c=rtgRngWrap.ORP020;
                rdOutput.ORP025__c=rtgRngWrap.ORP025;
                rdOutput.ORP015__c=rtgRngWrap.ORP015;
                rdOutput.ORP027__c=rtgRngWrap.ORP027;
                if(!conProd.Quote_Descriptions_Override__c) {
                	rdOutput.ORP_Override__c=rdOutput.ORP__c;
            	}
            }
            rdOutput.ORV010__c=rtgRngWrap.ORV010;
            rdOutput.ORV020__c=rtgRngWrap.ORV020;
            rdOutput.ORV025__c=rtgRngWrap.ORV025;
            rdOutput.ORV015__c=rtgRngWrap.ORV015;
            rdOutput.ORV027__c=rtgRngWrap.ORV027;
            rdOutput.SRV__c=rtgRngWrap.SRV;

            if(!conProd.Quote_Descriptions_Override__c) {

                rdOutput.ORV_Override__c=rtgRngWrap.ORV;
            }
            conProd.VAssignedRangeType__c=rtgRngWrap.VAssignedRangeType;
        }
        if (conProd.Relief_Type__c=='Pressure & Vacuum Relief'){
            system.debug('RATING ND RANGE @1975');
            conProd.RG1MIN__c=rtgRngWrap.RG1MIN;
            conprod.RG1MAX__c=rtgRngWrap.RG1MAX;
            conProd.RG2MIN__c=rtgRngWrap.RG2MIN;
            conprod.RG2MAX__c=rtgRngWrap.RG2MAX;
            conProd.RGEMIN__c=rtgRngWrap.RGEMIN;
            conprod.TMR__c=rtgRngWrap.TMR;
            rdOutput.ORP__c=rtgRngWrap.ORP;
            rdOutput.ORP010__c=rtgRngWrap.ORP010;
            rdOutput.ORP020__c=rtgRngWrap.ORP020;
            rdOutput.ORP025__c=rtgRngWrap.ORP025;
            rdOutput.ORV025__c=rtgRngWrap.ORV025;
            rdOutput.ORP015__c=rtgRngWrap.ORP015;
            rdOutput.ORP027__c=rtgRngWrap.ORP027;
            rdOutput.ORV010__c=rtgRngWrap.ORV010;
            rdOutput.ORV020__c=rtgRngWrap.ORV020;
            rdOutput.ORV015__c=rtgRngWrap.ORV015;
            rdOutput.ORV027__c=rtgRngWrap.ORV027;
            rdOutput.SRV__c=rtgRngWrap.SRV;
            rdOutput.SRP__c=rtgRngWrap.SRP;

            if(!conProd.Quote_Descriptions_Override__c) {

                rdOutput.ORP_Override__c=rdOutput.ORP__c;
            }
            conProd.Assigned_RangeType__c=rtgRngWrap.AssignedRangeType;
            conProd.VAssignedRangeType__c=rtgRngWrap.VAssignedRangeType;

            conprod.VTMR__c=rtgRngWrap.VTMR;
            // //VACCUM
            conProd.VG1MIN__c=rtgRngWrap.VG1MIN;
            conProd.VG2MIN__c=rtgRngWrap.VG2MIN;
            conprod.VG2MAX__c=rtgRngWrap.VG2MAX;
            //conProd.VG1MIN__c=rtgRngWrap.VG1MIN;
            conprod.VG1MAX__c=rtgRngWrap.VG1MAX;
            rdOutput.ORV__c=rtgRngWrap.ORV;

            // conProd.VG3DRT__c=rtgRngWrap.VG3DRT;
            if(!conProd.Quote_Descriptions_Override__c) {

                rdOutput.ORV_Override__c=rtgRngWrap.ORV;
            }

        }
        decimal intTMRCHECK=rtgRngWrap.TMRCHECK;
        decimal intBMRCHECK=rtgRngWrap.BMRCHECK;
        conProd.Rating_and_Range_Flag__c=true;
        system.debug('RATING ND RANGE @1999');

        bShowEditButton = false; //added by piyush
        bShowReturnToProductSelectionButton = false;  //added by piyush
        conProd.Finish_Configuration_Flag__c = false;  //added by piyush
        update conProd;
        system.debug('conProd.Quote_Descriptions_Override__c' +conProd.Quote_Descriptions_Override__c);
        //if(!conProd.Quote_Descriptions_Override__c)
        update rdOutput;
        string strWithStand='N';
        if ((!String.IsBlank(conProd.Vacuum_Withstand__c) && conProd.Vacuum_Withstand__c!='No Requirements') ||
            (!String.isBlank(conProd.Pressure_Withstand__c) && conProd.Pressure_Withstand__c!='No Requirements')) {
                strWithStand='Y';
            }
        decimal decRG3DRT=unitConversions.RoundNormal(conProd.RG3DRT__c,2);
        decimal decTEMP=unitConversions.RoundNormal(conprod.Converted_Temperature_Setting__c,2);
        decimal decPress=0;
        // decimal decVG3DRT=unitConversions.RoundNormal(conProd.VG3DRT__c,2);
        // decimal decVac=0;
        if (decPBrustConvertedValue!=null)
            decPress=decPBrustConvertedValue;
        if (decVBrustConvertedValue!=null)
            decPress=0.0;
        System.debug('DSCVAR---->>>>>>>'+conProd.DSCVAR__c);
        decimal decTMRCHECK=0;
        decimal decBMRCHECK=0;
        if(conProd.TMRCHECK__c!=null)
            decTMRCHECK=unitConversions.RoundNormal(conProd.TMRCHECK__c,2);
        else
            decTMRCHECK=decRG3DRT;
        if(conProd.BMRCHECK__c!=null)
            decBMRCHECK=unitConversions.RoundNormal(conProd.BMRCHECK__c,2);
        else
            decBMRCHECK=decRG3DRT;
        //Service Ticket #205427, added parameter for 3A Sanitary Stds
        cmpWrap=new  RDComponents(conProd.Product__c,conProd.Size__c,conProd.Seat__c, conProd.DSCVAR__c ,conProd.Disc_Material_of_Construction__c,decBMRCHECK,decTMRCHECK,strWithStand,decTEMP,decPress,conProd.Non_Fragmenting_Design_Required__c?'Yes':'No',conProd.Atex_Certificate__c?'Yes':'No',(!String.IsBlank(conProd.NACE__c)&&conProd.NACE__c!='N')?'Yes':'No', conProd.X3A_Sanitary_Standards__c);
        System.debug('cmpWrap: --- '+cmpWrap);

        if(!ReorderFlag){
            clearSectGComponents();
        }

        if(cmpWrap.reqComps.contains('Material_Top_Section__c') && (!String.IsBlank(conProd.Disc_Material_of_Construction__c ) && conProd.Disc_Material_of_Construction__c != '-')) {
            conProd.Material_Top_Section__c=conProd.Disc_Material_of_Construction__c;
            disableTop=true;
        }
        if(cmpWrap.reqComps.contains('Material_Top_Section2__c') && (!String.IsBlank(conProd.Disc_Material_of_Construction__c) && conProd.Disc_Material_of_Construction__c != '-')) {
            conProd.Material_Top_Section2__c=conProd.Disc_Material_of_Construction__c;
            disableTop =true;
        }
        if(cmpWrap.reqComps.contains('Material_Disc__c') &&  (!String.IsBlank(conProd.Disc_Material_of_Construction__c) && conProd.Disc_Material_of_Construction__c != '-')) {
            system.debug('ggggggggggggggggggggggggggg');
            conProd.Material_Disc__c=conProd.Disc_Material_of_Construction__c;
            disableDic=true;
        }
        if(disableDic||disableTop) {
            calculateRG3DRT();
        }
        system.debug('RATING ND RANGE @2027');
        // } catch (Exception e) {
        //     return null;
        // }
        return null;
    }
    public string strWSTD {
        get {
            string strWithStand1='N';
            if ((!String.IsBlank(conProd.Vacuum_Withstand__c) && conProd.Vacuum_Withstand__c!='No Requirements') ||
                (!String.isBlank(conProd.Pressure_Withstand__c) && conProd.Pressure_Withstand__c!='No Requirements')) {
                    strWithStand1='Y';
                }
            return strWithStand1;
        }
        set;
    }
    public void clearCalculatedValues() {
        conProd.RG1MIN__c=null;
        conprod.RG1MAX__c=null;
        conProd.RG2MIN__c=null;
        conprod.RG2MAX__c=null;
        conProd.RGEMIN__c=null;
        conprod.TMR__c=null;
        rdOutput.ORP__c=null;
        rdOutput.ORP010__c=null;
        rdOutput.ORP020__c=null;
        rdOutput.ORP025__c=null;
        rdOutput.ORP015__c=null;
        rdOutput.ORP027__c=null;
        rdOutput.SRP__c=null;
        conProd.VG2MIN__c=null;
        conprod.VG2MAX__c=null;
        conProd.VG1MIN__c=null;
        conprod.VG1MAX__c=null;
        conProd.VG3DRT__c=null;
        conprod.VTMR__c=null;
        rdOutput.ORV__c=null;
        rdOutput.ORV010__c=null;
        rdOutput.ORV020__c=null;
        rdOutput.ORV025__c=null;
        rdOutput.ORV015__c=null;
        rdOutput.ORV027__c=null;
        rdOutput.SRV__c=null;
    }
    public Boolean HideVacuumRating{
        get{
            if(conProd.Product__c != 'CAL' || (conProd.Product__c == 'PAS' && (conProd.Vac_Rating_Type__c != 'No Rating But Must Withstand' || conProd.Vac_Rating_Type__c != 'No Rating'))){
                return true;
            } else {
                return false;
            }
        }
        set;
    }
    //HCLASS Method for Table D_DiscHolderParts
    // public string previousHClassWhereClause{set;get;}
    // public List<RD_D_DiscHolderParts__c> HCLASSRecords{
    //     get {
    //         String queryString='select HCLASS__c,PartCode__c,ConnSize__c,Connection__c from RD_D_DiscHolderParts__c';
    //         String whereClause='';

    //         if(conProd.Product__c!=null && SZC!=null) {

    //                 whereClause=whereClause+' where PTC__c =\''+ conProd.Product__c +'\' and SZC__c=\''+SZC+'\'';

    //             }
    //         queryString = queryString + whereClause;
    //         string order_by=' order by HCLASS__c';
    //         queryString=queryString+order_by;
    //         System.debug('DynamicQuery'+queryString);
    //         if((HCLASSRecords != null && !HCLASSRecords.isEmpty()) && whereClause == previousHClassWhereClause) {
    //             return HCLASSRecords;
    //         }
    //         previousHClassWhereClause=whereClause;
    //         List<RD_D_DiscHolderParts__c> sobjList = Database.query(queryString);
    //         System.debug('HCLASSRecords Query : ' + sobjList);
    //         return sobjList;
    //     }
    //     private set;
    // }
    // //HCLASS Options
    // public List<SelectOption> getHCLASSValues() {
    //     List<selectOption> HCLASSOptions = new List<selectOption>();
    //     List<string> uniqueList=new List<string>();
    //     HCLASSOptions.add(new selectOption('',''));
    //     for (RD_D_DiscHolderParts__c kv: HCLASSRecords ) {
    //         if(!uniqueList.contains(kv.HCLASS__c)){
    //             uniqueList.add(kv.HCLASS__c);
    //             HCLASSOptions.add(new selectOption(kv.HCLASS__c,kv.HCLASS__c));
    //             //  System.debug('HCLASS Records---'+HCLASSOptions);
    //         }
    //     }
    //     return HCLASSOptions;
    // }
    // public decimal decHICSize{set;get;}
    // public pageReference refreshHOC() {
    //     //decHICSize=conProd.Outlet_Connection__c
    //     decHICSize=decimal.valueOf(conProd.Inlet_Connection__c);
    //     System.debug('decHICSize: ' + decHICSize);
    //     return null;
    // }
    // //HIC Options based from RD_D_DiscHolderParts__c object
    // public List<SelectOption> getHICValues() {
    //     List<selectOption> HICOptions = new List<selectOption>();
    //     List<string> uniqueList=new List<string>();
    //     HICOptions.add(new selectOption('',''));
    //     for (RD_D_DiscHolderParts__c kv: HCLASSRecords ) {
    //         if(!uniqueList.contains(kv.Connection__c) && kv.PartCode__c=='01'){
    //             uniqueList.add(kv.Connection__c);
    //             HICOptions.add(new selectOption(string.valueOf(kv.ConnSize__c),kv.Connection__c));
    //         }
    //     }
    //         return HICOptions;
    // }
    // //HOC Options based from RD_D_DiscHolderParts__c object
    // public List<SelectOption> getHOCValues() {
    //     List<selectOption> HOCOptions = new List<selectOption>();
    //     List<string> uniqueList=new List<string>();
    //     HOCOptions.add(new selectOption('',''));
    //             for (RD_D_DiscHolderParts__c kv: HCLASSRecords ) {
    //             if(!uniqueList.contains(kv.Connection__c) && kv.PartCode__c=='02' && kv.ConnSize__c>=decHICSize){
    //                 uniqueList.add(kv.Connection__c);
    //                 HOCOptions.add(new selectOption(string.valueOf(kv.ConnSize__c),kv.Connection__c));
    //             }
    //         }
    //         return HOCOptions;
    // }
    // //HCLASS2 Method for Table D_tblInletForScrewType
    // public string prevHCLASSwhereClause{set;get;}
    // public List<RD_D_tblInletForScrewType__c> HCLASSRecords2{
    //     get {
    //         String queryString='select HCLASS__c,HIC__c from RD_D_tblInletForScrewType__c';
    //         String whereClause='';

    //         if(conProd.Product__c!=null && conProd.Size__c!=null && conProd.Seat__c!=null) {

    //             whereClause=whereClause+' where PTC__c =\''+ conProd.Product__c +'\' and SZC__c=\''+SZC+'\' and SeatDesc__c=\''+ConstantsUtil.mapSTCDesc.get(conProd.Seat__c)+'\'';
    //         }
    //         queryString = queryString + whereClause;
    //         List<RD_D_tblInletForScrewType__c> sobjList=new List<RD_D_tblInletForScrewType__c>();
    //         string order_by=' order by HCLASS__c';
    //         queryString=queryString+order_by;
    //         System.debug('DynamicQuery'+queryString);
    //         if((HCLASSRecords != null && !HCLASSRecords.isEmpty())) {
    //             return sobjList;
    //         }
    //         if((HCLASSRecords2!=null && !HCLASSRecords2.isEmpty()) && whereClause == prevHCLASSwhereClause) {
    //             return HCLASSRecords2;
    //         }
    //         prevHCLASSwhereClause=whereClause;
    //         sobjList = Database.query(queryString);
    //         System.debug('HCLASSRecord2 Query : ' + sobjList);
    //         return sobjList;
    //     }
    //     private set;
    // }
    // //HCLASS OPTIONS
    // public List<SelectOption> getHCLASSValues2() {
    //     List<selectOption> HCLASSOptions = new List<selectOption>();
    //     List<string> uniqueList=new List<string>();
    //     HCLASSOptions.add(new selectOption('',''));
    //     for (RD_D_tblInletForScrewType__c kv: HCLASSRecords2 ) {
    //         if(!uniqueList.contains(kv.HCLASS__c)){
    //             uniqueList.add(kv.HCLASS__c);
    //             HCLASSOptions.add(new selectOption(kv.HCLASS__c,kv.HCLASS__c));
    //         }
    //     }
    //     return HCLASSOptions;
    // }
    // //HIC OPTIONS
    // public List<SelectOption> getHICValues2() {
    //     List<selectOption> HICOptions = new List<selectOption>();
    //     List<string> uniqueList=new List<string>();
    //     HICOptions.add(new selectOption('',''));
    //     for (RD_D_tblInletForScrewType__c kv: HCLASSRecords2 ) {
    //         if(!uniqueList.contains(kv.HIC__c) && kv.HCLASS__c==conProd.Pressure_Class__c){
    //             uniqueList.add(kv.HIC__c);
    //             HICOptions.add(new selectOption(kv.HIC__c,kv.HIC__c));
    //         }
    //     }
    //     return HICOptions;
    // }
    // public boolean showHOC {set;get;}
    // //Final HCLASS HOC & HIC Options
    // public list<selectOption> getConsolidateHCLASSOptns() {
    //     List<selectOption> Options = new List<selectOption>();
    //     Options.add(new selectOption('N/A','N/A'));
    //     if (getHCLASSValues().size()>1)
    //         return getHCLASSValues();
    //     else if (getHCLASSValues2().size()>1)
    //         return getHCLASSValues2();
    //     else
    //         return Options;
    // }
    // public list<selectOption> getConsolidateHICOptns() {
    //     List<selectOption> Options = new List<selectOption>();
    //     Options.add(new selectOption('N','N'));
    //     if (getHICValues().size()>1)
    //         return getHICValues();
    //     else if (getHICValues2().size()>1)
    //         return getHICValues2();
    //     else
    //         return Options;
    // }
    // public list<selectOption> getConsolidateHOCOptns() {
    //     List<selectOption> Options = new List<selectOption>();
    //     // showHOC=true;
    //     Options.add(new selectOption('N','N'));
    //     if (getHOCValues().size()>1)
    //         return getHOCValues();
    //     else {
    //         //showHOC=false;
    //         return Options;
    //     }
    // }
    public string strBID {
        get {
            if (conProd.Add_Integral_BDI_Integral_BDI_FLX_Sensor__c=='BDI') {
                return 'Integral BDI';
            } else if (conProd.Add_Integral_BDI_Integral_BDI_FLX_Sensor__c=='BDI-FLX') {
                return 'BDI-FLX';
            }
            return '';
        }
        set;
    }
    public list<selectOption> getBDIOptions() {
        List<selectOption> bdiOptions = new List<selectOption>();
        bdiOptions.add(new selectOption('',''));
        List<string> uniqueList=new List<string>();
        for (RD_Integral_BDI_Table__c kv: BDIRecords ) {
            if(!uniqueList.contains(kv.Type__c)) {
                uniqueList.add(kv.Type__c);
                bdiOptions.add(new selectOption(kv.Type__c,kv.Type__c));
            }
        }
        return bdiOptions;
    }
    public string strStripMat='';
    public string strGasket='';
    public string strWireConfig='';
    public string strWireType='';
    public string strCableLength='';
    public string strEndCon='';
    public list<selectOption> getStripMatlCode() {
        List<selectOption> wireOptions = new List<selectOption>();
        wireOptions.add(new selectOption('',''));
        List<string> uniqueList=new List<string>();
        System.debug('BID getStripMatlCode Loaded ');
        System.debug('BID getStripMatlCode Loaded '+BDIRecords);
        System.debug('BID getStripMatlCode Loaded '+conProd.Add_Integral_BDI_Integral_BDI_FLX_Sensor__c);
        // String strBID='';
        // if (conProd.Add_Integral_BDI_Integral_BDI_FLX_Sensor__c=='BDI') {
        //     strBID='Integral BDI';
        // } else if (conProd.Add_Integral_BDI_Integral_BDI_FLX_Sensor__c=='BDIFLX') {
        //     strBID='Integral BDI-FLX';
        // }
        integer count=0;
        System.debug('BID getStripMatlCode Loaded strBID: ' + strBID);
        for (RD_Integral_BDI_Table__c kv: BDIRecords ) {
            System.debug('BID getStripMatlCode Loaded kv.Type__c: ' + kv.Type__c);
            boolean additionalCheck=String.isNotBlank(strBID)&& (kv.Type__c==strBID);
            if(!uniqueList.contains(kv.StripMatlCode__c) && additionalCheck){
                uniqueList.add(kv.StripMatlCode__c);
                if(ConstantsUtil.mapMatlCodewithMatl.containsKey(kv.StripMatlCode__c))
                    wireOptions.add(new selectOption(kv.StripMatlCode__c,ConstantsUtil.mapMatlCodewithMatl.get(kv.StripMatlCode__c)));
                else
                    wireOptions.add(new selectOption(kv.StripMatlCode__c,kv.StripMatlCode__c));
                count++;
                strStripMat=kv.StripMatlCode__c;
            }
        }
        System.debug('BID getStripMatlCode Loaded '+wireOptions);
        if(count==1)
            wireOptions.remove(0);
        else
            strStripMat='';

        return wireOptions;
    }
    public list<selectOption> getGasket() {
        List<selectOption> wireOptions = new List<selectOption>();
        wireOptions.add(new selectOption('',''));
        List<string> uniqueList=new List<string>();
        integer count=0;
        if(string.isNotBlank(strStripMat))
            conProd.Strip_Type__c=strStripMat;
        for (RD_Integral_BDI_Table__c kv: BDIRecords ) {
            boolean additionalCheck=(strBID!=null) && (kv.StripMatlCode__c==conProd.Strip_Type__c && conProd.Strip_Type__c!=null) && (kv.Type__c==strBID);
            if(!uniqueList.contains(kv.GasketMatlCode__c)){
                uniqueList.add(kv.GasketMatlCode__c);
                if(ConstantsUtil.mapMatlCodewithMatl.containsKey(kv.GasketMatlCode__c))
                    wireOptions.add(new selectOption(kv.GasketMatlCode__c,ConstantsUtil.mapMatlCodewithMatl.get(kv.GasketMatlCode__c)));
                else
                    wireOptions.add(new selectOption(kv.GasketMatlCode__c,kv.GasketMatlCode__c));
                //wireOptions.add(new selectOption(kv.GasketMatlCode__c,kv.GasketMatlCode__c));
                count++;
                strGasket=kv.GasketMatlCode__c;
            }
        }
        if(count==1)
            wireOptions.remove(0);
        else
            strGasket='';
        return wireOptions;
    }
    public list<selectOption> getWireConfigType() {
        List<selectOption> wireOptions = new List<selectOption>();
        wireOptions.add(new selectOption('',''));
        integer count=0;
        List<string> uniqueList=new List<string>();
        if(string.isNotBlank(strStripMat))
            conProd.Strip_Type__c=strStripMat;
        if(string.isNotBlank(strGasket))
            conProd.Gasket_Material__c=strGasket;
        for (RD_Integral_BDI_Table__c kv: BDIRecords ) {
            boolean additionalCheck=(strBID!=null ) && (kv.StripMatlCode__c==conProd.Strip_Type__c && conProd.Strip_Type__c!=null) && (conProd.Gasket_Material__c==kv.GasketMatlCode__c && conProd.Gasket_Material__c!=null) && (kv.Type__c==strBID);
            if(!uniqueList.contains(kv.Wiring_Configuration__c) && additionalCheck){
                uniqueList.add(kv.Wiring_Configuration__c);
                wireOptions.add(new selectOption(kv.Wiring_Configuration__c,kv.Wiring_Configuration__c));
                count++;
                strWireConfig=kv.Wiring_Configuration__c;
            }

        }
        if(count==1)
            wireOptions.remove(0);
        else
            strWireConfig='';
        return wireOptions;
    }
    public list<selectOption> getWireType() {
        List<selectOption> wireOptions = new List<selectOption>();
        wireOptions.add(new selectOption('',''));
        List<string> uniqueList=new List<string>();
        integer count=0;
        if(string.isNotBlank(strStripMat))
            conProd.Strip_Type__c=strStripMat;
        if(string.isNotBlank(strGasket))
            conProd.Gasket_Material__c=strGasket;
        if(string.isNotBlank(strWireConfig))
            conProd.Wiring_Configuration__c=strWireConfig;
        for (RD_Integral_BDI_Table__c kv: BDIRecords ) {
            boolean additionalCheck=(strBID!=null ) && (kv.StripMatlCode__c==conProd.Strip_Type__c && conProd.Strip_Type__c!=null) && (conProd.Gasket_Material__c==kv.GasketMatlCode__c && conProd.Gasket_Material__c!=null) && (kv.Type__c==strBID) && (conProd.Wiring_Configuration__c==kv.Wiring_Configuration__c && conProd.Wiring_Configuration__c!=null);
            if(!uniqueList.contains(kv.WireType__c) && additionalCheck){
                uniqueList.add(kv.WireType__c);
                wireOptions.add(new selectOption(kv.WireType__c,kv.WireType__c));
                count++;
                strWireType=kv.WireType__c;
            }
        }
        if(count==1)
            wireOptions.remove(0);
        else
            strWireType='';
        return wireOptions;
    }


    public list<selectOption> getCableLength() {
        List<selectOption> wireOptions = new List<selectOption>();
        wireOptions.add(new selectOption('',''));
        List<string> uniqueList=new List<string>();
        integer count=0;
        if(string.isNotBlank(strStripMat))
            conProd.Strip_Type__c=strStripMat;
        if(string.isNotBlank(strGasket))
            conProd.Gasket_Material__c=strGasket;
        if(string.isNotBlank(strWireConfig))
            conProd.Wiring_Configuration__c=strWireConfig;
        if(string.isNotBlank(strWireType))
            conProd.Wire_Type__c=strWireType;
        for (RD_Integral_BDI_Table__c kv: BDIRecords ) {
            boolean additionalCheck=(strBID!=null ) && (kv.StripMatlCode__c==conProd.Strip_Type__c && conProd.Strip_Type__c!=null) && (conProd.Gasket_Material__c==kv.GasketMatlCode__c && conProd.Gasket_Material__c!=null) && (conProd.Wire_Type__c==kv.WireType__c && conProd.Wire_Type__c!=null) && (kv.Type__c==strBID) && (conProd.Wiring_Configuration__c==kv.Wiring_Configuration__c && conProd.Wiring_Configuration__c!=null);
            if(!uniqueList.contains(kv.CableLength__c) && additionalCheck){
                uniqueList.add(kv.CableLength__c);
                wireOptions.add(new selectOption(kv.CableLength__c,kv.CableLength__c));
                count++;
                strCableLength=kv.CableLength__c;
            }
        }
        if(count==1)
            wireOptions.remove(0);
        else
            strCableLength='';
        return wireOptions;
    }
    public list<selectOption> getEndConnection() {
        List<selectOption> wireOptions = new List<selectOption>();
        wireOptions.add(new selectOption('',''));
        List<string> uniqueList=new List<string>();
        integer count=0;
        if(string.isNotBlank(strStripMat))
            conProd.Strip_Type__c=strStripMat;
        if(string.isNotBlank(strGasket))
            conProd.Gasket_Material__c=strGasket;
        if(string.isNotBlank(strWireConfig))
            conProd.Wiring_Configuration__c=strWireConfig;
        if(string.isNotBlank(strWireType))
            conProd.Wire_Type__c=strWireType;
        if(string.isNotBlank(strCableLength))
            conProd.Cable_Length__c=strCableLength;
        for (RD_Integral_BDI_Table__c kv: BDIRecords ) {
            boolean additionalCheck=(strBID!=null ) && (kv.StripMatlCode__c==conProd.Strip_Type__c && conProd.Strip_Type__c!=null) && (conProd.Gasket_Material__c==kv.GasketMatlCode__c && conProd.Gasket_Material__c!=null) && (conProd.Wire_Type__c==kv.WireType__c && conProd.Wire_Type__c!=null) && (conProd.Cable_Length__c==kv.CableLength__c && conProd.Cable_Length__c!=null) && (kv.Type__c==strBID) && (conProd.Wiring_Configuration__c==kv.Wiring_Configuration__c && conProd.Wiring_Configuration__c!=null);
            if(!uniqueList.contains(kv.EndConnection__c) && additionalCheck){
                uniqueList.add(kv.EndConnection__c);
                wireOptions.add(new selectOption(kv.EndConnection__c,kv.EndConnection__c));
                count++;
                strEndCon=kv.EndConnection__c;
            }
        }
        if(count==1)
            wireOptions.remove(0);
        else
            strEndCon='';
        return wireOptions;
    }
    public boolean showInterfaceOptions {
        get {
            if(String.isNotBlank(ConProd.To_Make_With_BDI_FLX_Interface_cable__c))
                return true;
            else {
                return false;
            }
        }
        set {
            this.showInterfaceOptions=value;
        }
    }
    public list<SelectOption> getInterfaceCable() {
        List<selectOption> interfaceOptions = new List<selectOption>();
        boolean isFound=false;
        interfaceOptions.add(new selectOption('',''));
        List<string> uniqueList=new List<string>();
        //Service Ticket #204266, setting the filter values
        if(string.isNotBlank(strStripMat))
            conProd.Strip_Type__c=strStripMat;
        if(string.isNotBlank(strGasket))
            conProd.Gasket_Material__c=strGasket;
        if(string.isNotBlank(strWireConfig))
            conProd.Wiring_Configuration__c=strWireConfig;
        if(string.isNotBlank(strWireType))
            conProd.Wire_Type__c=strWireType;
        if(string.isNotBlank(strCableLength))
            conProd.Cable_Length__c=strCableLength;
        if(string.isNotBlank(strEndCon))
            conProd.End_Connection__c=strEndCon;

        for (RD_Integral_BDI_Table__c kv: BDIRecords ) {
            boolean additionalCheck=(strBID!=null ) && (kv.StripMatlCode__c==conProd.Strip_Type__c && conProd.Strip_Type__c!=null) && (conProd.Gasket_Material__c==kv.GasketMatlCode__c && conProd.Gasket_Material__c!=null) && (conProd.Wire_Type__c==kv.WireType__c && conProd.Wire_Type__c!=null) && (conProd.Cable_Length__c==kv.CableLength__c && conProd.Cable_Length__c!=null) && (kv.Type__c==strBID) && (conProd.Wiring_Configuration__c==kv.Wiring_Configuration__c && conProd.Wiring_Configuration__c!=null) &&
                (conProd.End_Connection__c==kv.EndConnection__c && conProd.End_Connection__c!=null);
            if(!uniqueList.contains(kv.Interface__c) && additionalCheck && kv.Interface__c!='-'){
                uniqueList.add(kv.Interface__c);
                interfaceOptions.add(new selectOption(kv.Interface__c,kv.Interface__c));
                isFound=true;
            }
        }
        showInterfaceOptions=isFound;
        return interfaceOptions;
    }



    public PageReference saveComponents() {
        try {
            bShowEditButton = false; //added by piyush
            bShowReturnToProductSelectionButton = false;  //added by piyush
            conProd.Finish_Configuration_Flag__c = false;  //added by piyush

            if(!conProd.Rating_and_Range_Flag__c) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please complete Rating and Range.'));
                return null;
            }
            conProd.Bypass__c=false;
            if (cmpWrap.reqComps.contains('Material_Arcuate_Ring__c') && conProd.Material_Arcuate_Ring__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Arcuate Ring'));
            if (cmpWrap.reqComps.contains('Material_Armor_Ring2__c') && conProd.Material_Armor_Ring2__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Arcuate Ring'));
            if (cmpWrap.reqComps.contains('Material_Armor_Ring__c') && conProd.Material_Armor_Ring__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Armor Ring'));
            if (cmpWrap.reqComps.contains('Material_Dent_Protector__c') && conProd.Material_Dent_Protector__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Dent Protector'));
            if (cmpWrap.reqComps.contains('Material_Disc__c') && conProd.Material_Disc__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Disc'));
            if (cmpWrap.reqComps.contains('Material_Girdle_Cover__c') && conProd.Material_Girdle_Cover__c ==null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Girdle Cover'));
            if (cmpWrap.reqComps.contains('Material_Girdle__c') && conProd.Material_Girdle__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Girdle'));
            if (cmpWrap.reqComps.contains('Material_Handling_Support__c') && conProd.Material_Handling_Support__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Handling Support'));
            if (cmpWrap.reqComps.contains('Material_Hi_Temp_Assembly__c') && conProd.Material_Hi_Temp_Assembly__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Hi Temp Assembly'));
            if (cmpWrap.reqComps.contains('Material_Holddown_Ring__c') && conProd.Material_Holddown_Ring__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Holddown Ring'));
            if (cmpWrap.reqComps.contains('Material_Inlet_Coating2__c') && conProd.Material_Inlet_Coating2__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet Coating'));
            if (cmpWrap.reqComps.contains('Material_Inlet_Coating__c') && conProd.Material_Inlet_Coating__c== null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet Coating'));
            if (cmpWrap.reqComps.contains('Material_Inlet_Gasket__c') && conProd.Material_Inlet_Gasket__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet Gasket'));
            if (cmpWrap.reqComps.contains('Material_Inlet_Liner__c') && conProd.Material_Inlet_Liner__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet Liner'));
            if (cmpWrap.reqComps.contains('Material_Inlet_O_Ring__c') && conProd.Material_Inlet_O_Ring__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet O Ring'));
            if (cmpWrap.reqComps.contains('Material_Inlet_Ring2__c') && conProd.Material_Inlet_Ring2__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet Ring'));
            if (cmpWrap.reqComps.contains('Material_Inlet_Ring3__c') && conProd.Material_Inlet_Ring3__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet Ring'));
            if (cmpWrap.reqComps.contains('Material_Inlet_Ring__c') && conProd.Material_Inlet_Ring__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet Ring'));
            if (cmpWrap.reqComps.contains('Material_Inlet__c') && conProd.Material_Inlet__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Inlet'));
            if (cmpWrap.reqComps.contains('Material_Outlet_Coating__c') && conProd.Material_Outlet_Coating__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Outlet Coating'));
            if (cmpWrap.reqComps.contains('Material_Outlet_Gasket__c') && conProd.Material_Outlet_Gasket__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Outlet Gasket'));
            if (cmpWrap.reqComps.contains('Material_Outlet_Liner__c') && conProd.Material_Outlet_Liner__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Outlet Liner'));
            if (cmpWrap.reqComps.contains('Material_Outlet_Ring__c') && conProd.Material_Outlet_Ring__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Outlet Ring'));
            if (cmpWrap.reqComps.contains('Material_Outlet__c') && conProd.Material_Outlet__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Outlet'));
            if (cmpWrap.reqComps.contains('Material_Seal2__c') && conProd.Material_Seal2__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Seal'));
            if (cmpWrap.reqComps.contains('Material_Seal3__c') && conProd.Material_Seal3__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Seal'));
            if (cmpWrap.reqComps.contains('Material_Seal__c') && conProd.Material_Seal__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Seal'));
            if (cmpWrap.reqComps.contains('Material_Top_Section2__c') && conProd.Material_Top_Section2__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Top Section'));
            if (cmpWrap.reqComps.contains('Material_Top_Section__c') && conProd.Material_Top_Section__c ==null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Top Section'));
            if (cmpWrap.reqComps.contains('Material_Vaccum_Support3__c') && conProd.Material_Vaccum_Support3__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Vaccum Support'));
            if (cmpWrap.reqComps.contains('Material_Vacuum_Support2__c') && conProd.Material_Vacuum_Support2__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Vaccum Support'));
            if (cmpWrap.reqComps.contains('Material_Vacuum_Support__c') && conProd.Material_Vacuum_Support__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a value for Vaccum Support'));
            if(string.isNotBlank(conProd.Material_Top_Section2__c) && string.isNotBlank(conProd.Material_Top_Section__c)) {
                if(conProd.Material_Top_Section2__c!=conProd.Material_Top_Section__c)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter a Same materials for Top Sections'));
            }
            integer siz=integer.valueOf(SZC);
            if(conProd.Product__c!='PAS' && conProd.Product__c!='CAL') {
                // RDMasterBlaster__c[] RDMasterList=new list<RDMasterBlaster__c>();
                RDMasterBlaster__c[] RDMasterList=[select PTC__c,SZC__c,STC__c, DSCVAR__c, Id, MatlCodeVac__c, MatlCodePos__c, PressUL__c, PressLL__c, VacUL__c, VacLL__c, DerateType__c, Derate_EQN__c, Derate_Teflon__c, TempLL__c, TempUL__c, KOSHA_UL__c, KOSHA_LL__c, China_ML_UL__c, China_ML_LL__c, CE_Mark_UL__c, CE_Mark_LL__c, CE_Mark__c, ASME_UL__c, ASME_LL__c,Teflon_Ambient__c from RDMasterBlaster__c WHERE PTC__c=:conProd.Product__c AND STC__c=:conprod.Seat__c AND DSCVAR__c=:conProd.DSCVAR__c and MatlCodePos__c=:MCD AND SZC__c=:SZC];
                System.debug('Component Section-------------------------->>>>WHERE PTC__c='+conProd.Product__c+' AND STC__c='+conprod.Seat__c+' AND DSCVAR__c='+conProd.DSCVAR__c+' and MatlCodePos__c='+MCD+' AND SZC__c='+siz);

                System.debug('Component Section-------------------------->>>>'+RDMasterList.size());
                Map<string,List<Derate_Value__c>> mapDetValues=new Map<string,List<Derate_Value__c>>();
                mapDetValues=mapDerateValues(conProd.Converted_Temperature_Setting__c);
                if(RDMasterList.size()==1) {
                    string key=matlCodeProcessor(RDMasterList[0].MatlCodePos__c)+RDMasterList[0].DerateType__c;
                    decimal deratevalue=1;
                    decimal brustPressure=0;
                    if(RDMasterList[0].PTC__c!='CAL')
                        brustPressure=conProd.Converted_Pressure_Setting__c;
                    else
                        brustPressure=conProd.Converted_Vacuum_Setting__c;
                    if(mapDetValues.containsKey(key)) {
                        deratevalue=mapDetValues.get(key)[0].Derate__c;
                    }
                    if(RDMasterList[0].Derate_EQN__c=='METL' || RDMasterList[0].Derate_EQN__c=='COMM') {
                        brustPressure=brustPressure/deratevalue;
                    } else if (RDMasterList[0].Derate_EQN__c=='COMA') {
                        decimal MetAlum=0;
                        string strMetlAlum='001'+RDMasterList[0].DerateType__c;
                        if(mapDetValues.containsKey(strMetlAlum))
                            MetAlum=mapDetValues.get(strMetlAlum)[0].Derate__c;
                        brustPressure=2*brustPressure/(deratevalue+MetAlum);
                    } else if (RDMasterList[0].Derate_EQN__c=='COMT') {
                        string strMetlAlum='001'+RDMasterList[0].DerateType__c;
                        decimal TefDer=1;
                        string strTef='070'+RDMasterList[0].DerateType__c;
                        if(mapDetValues.containsKey(strTef))
                            TefDer=mapDetValues.get(strTef)[0].Derate__c;
                        brustPressure=brustPressure-(TefDer*RDMasterList[0].Teflon_Ambient__c)/deratevalue;
                        brustPressure+=RDMasterList[0].Teflon_Ambient__c;
                    } else {

                    }
                    System.debug('mmmmmmmbrustPressure'+brustPressure);
                    System.debug('mmmmmmmbrustPressure'+RDMasterList[0].PressLL__c);
                    if(RDMasterList[0].PressLL__c<=brustPressure) {

                    } else {
                        errOnSaveComp = false;
                        Map<string,string> mapMatlCodewithMatl=cmpWrap.getMaterialNames();
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Derated burst pressure of '+mapMatlCodewithMatl.get(MCD)+' '+MCDmaterial+'  below disc minimum pressure of '+RDMasterList[0].PressLL__c.format()+' psi.'));
                    }
                    if(RDMasterList[0].PressUL__c>=brustPressure ) {
                        //rdMasterIDs.put(localRDM.id, localRDM);
                    } else {
                        errOnSaveComp = false;
                        Map<string,string> mapMatlCodewithMatl=cmpWrap.getMaterialNames();
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Derated burst pressure of '+mapMatlCodewithMatl.get(MCD)+' '+MCDmaterial+' exceeds disc maximum pressure of '+RDMasterList[0].PressUL__c.format()+' psi.'));
                    }
                }
            }
            if(!Test.isRunningTest())
            {
                if(string.isBlank(MCD) && (!((conProd.Product__c=='CAL' || conProd.Product__c=='PAS') && conProd.DSCVAR__c=='N'))) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter value for Rupture Disc Material'));
                }
            }
			if(!ReorderFlag)
            {
                if(ApexPages.getMessages().size()>0) {
                    //conProd.Components_Flag__c=false; AND SZC__c=:conprod.Size__c  AND STC__c=:conprod.Seat__c
                    //update conProd;
                    return null;

                }
            }

            errOnSaveComp = true;
            Map<String, String> mapFieldName = new Map<String, String>();
            for(String key:cmpWrap.mapComponents.keySet()) {
                mapFieldName.put(cmpWrap.mapComponents.get(key),key);
            }
            string strWithStand1='N';
            if ((!String.IsBlank(conProd.Vacuum_Withstand__c) && conProd.Vacuum_Withstand__c!='No Requirements') ||
                (!String.isBlank(conProd.Pressure_Withstand__c) && conProd.Pressure_Withstand__c!='No Requirements')) {
                    strWithStand1='Y';
                }
            Map<String,String> mapAttributes1=new Map<String,String>();
            // string srtBMRCheck='-1';
            // conProd.RG3DRT__c=intRG3DRT;
            // conProd.BMRCHECK__c=intBMRCHECK;
            // conProd.TMRCHECK__c=intTMRCHECK;
            // //rtgRngWrap.RG3DRT=conProd.RG3DRT__c;
            // decimal intTMRCHECK=rtgRngWrap.TMRCHECK;
            // decimal intBMRCHECK=rtgRngWrap.BMRCHECK;
            // System.debug('FINAL RG3DRT'+intRG3DRT);
            Decimal StartRelief = rtgRngWrap.StartRelief==null?0.0:rtgRngWrap.StartRelief;
            if(conProd.Relief_Type__c=='Pressure Relief') {
                conProd.TMR__c=rtgRngWrap.TMR;
                conProd.RG1MIN__c=rtgRngWrap.RG1MIN;
                conprod.RG1MAX__c=rtgRngWrap.RG1MAX;
                conProd.RG2MIN__c=rtgRngWrap.RG2MIN;
                conprod.RG2MAX__c=rtgRngWrap.RG2MAX;
                conProd.RGEMIN__c=rtgRngWrap.RGEMIN;
                conProd.RG3DRT__c=rtgRngWrap.RG3DRT;
                conProd.RG3MIN__c=rtgRngWrap.RG3MIN;
                conProd.RG3MAX__c=rtgRngWrap.RG3MAX;
                conProd.RGSMIN__c=rtgRngWrap.RGSMIN;
                conProd.RGSMAX__c=rtgRngWrap.RGSMAX;
                conProd.RGEMIN__c=rtgRngWrap.RGEMIN;
                conProd.RGEMAX__c=rtgRngWrap.RGEMAX;
                rdOutput.ORP__c=rtgRngWrap.ORP;
                conProd.BMRCHECK__c=rtgRngWrap.TMRCHECK;
                conProd.TMRCHECK__c=rtgRngWrap.BMRCHECK;
                if(!conProd.Quote_Descriptions_Override__c)
                    rdOutput.ORP_Override__c=rdOutput.ORP__c;
                conProd.Assigned_RangeType__c=rtgRngWrap.AssignedRangeType;
                //if(rtgRngWrap.SRP!=null)
                    rdOutput.SRP__c=rtgRngWrap.SRP;
            }
            if(conProd.Relief_Type__c=='Vacuum Relief') {
                conProd.VG2MIN__c=rtgRngWrap.VG2MIN;
                conprod.VG2MAX__c=rtgRngWrap.VG2MAX;
                conProd.VG1MIN__c=rtgRngWrap.VG1MIN;
                conprod.VG1MAX__c=rtgRngWrap.VG1MAX;
                conProd.VG3MIN__c=rtgRngWrap.VG3MIN;
                conProd.VG3MAX__c=rtgRngWrap.VG3MAX;
                conProd.VGSMIN__c=rtgRngWrap.VGSMIN;
                conProd.VGSMAX__c=rtgRngWrap.VGSMAX;
                conProd.VGEMIN__c=rtgRngWrap.VGEMIN;
                conProd.VGEMAX__c=rtgRngWrap.VGEMAX;
                conProd.RG3DRT__c=rtgRngWrap.RG3DRT;
                conProd.VG3DRT__c=rtgRngWrap.VG3DRT;
                conProd.BMRCHECK__c=rtgRngWrap.TMRCHECK;
                conProd.TMRCHECK__c=rtgRngWrap.BMRCHECK;
                conProd.VTMR__c=rtgRngWrap.VTMR;
                rdOutput.ORV__c=rtgRngWrap.ORV;
                if(!conProd.Quote_Descriptions_Override__c)
                    rdOutput.ORV_Override__c=rtgRngWrap.ORV;
              //  if(rtgRngWrap.SRV!=null)
                    rdOutput.SRV__c=rtgRngWrap.SRV;
                conProd.VAssignedRangeType__c=rtgRngWrap.VAssignedRangeType;
            }
            if(conProd.Relief_Type__c=='Pressure & Vacuum Relief') {
                //Pressure Relief
                System.debug('---------->>>>>>>>>>>');
                conProd.TMR__c=rtgRngWrap.TMR;
                conProd.RG1MIN__c=rtgRngWrap.RG1MIN;
                conprod.RG1MAX__c=rtgRngWrap.RG1MAX;
                conProd.RG2MIN__c=rtgRngWrap.RG2MIN;
                conprod.RG2MAX__c=rtgRngWrap.RG2MAX;
                conProd.RGEMIN__c=rtgRngWrap.RGEMIN;
                conProd.RG3DRT__c=rtgRngWrap.RG3DRT;
                conProd.RG3MIN__c=rtgRngWrap.RG3MIN;
                conProd.RG3MAX__c=rtgRngWrap.RG3MAX;
                conProd.RGSMIN__c=rtgRngWrap.RGSMIN;
                conProd.RGSMAX__c=rtgRngWrap.RGSMAX;
                conProd.RGEMIN__c=rtgRngWrap.RGEMIN;
                conProd.RGEMAX__c=rtgRngWrap.RGEMAX;
                StartRelief = rtgRngWrap.StartRelief==null?0.0:rtgRngWrap.StartRelief;
                if(rtgRngWrap.ORP015!=null )
                    rdOutput.ORP015__c=rtgRngWrap.ORP015;
                if(rtgRngWrap.ORV015!=null)
                    rdOutput.ORV015__c=rtgRngWrap.ORV015;
                // if(rtgRngWrap.SRP!=null)
                    // rdOutput.SRP__c=rtgRngWrap.SRP;

                // conProd.BMRCHECK__c=rtgRngWrap.TMRCHECK;
                // conProd.TMRCHECK__c=rtgRngWrap.BMRCHECK;
                rdOutput.ORP__c=rtgRngWrap.ORP;
                if(!conProd.Quote_Descriptions_Override__c)
                    rdOutput.ORP_Override__c=rdOutput.ORP__c;
                conProd.Assigned_RangeType__c=rtgRngWrap.AssignedRangeType;

                //Vacuum Relief
                conProd.VG3MIN__c=rtgRngWrap.VG3MIN;
                conProd.VG3MAX__c=rtgRngWrap.VG3MAX;
                conProd.VGSMIN__c=rtgRngWrap.VGSMIN;
                conProd.VGSMAX__c=rtgRngWrap.VGSMAX;
                conProd.VGEMIN__c=rtgRngWrap.VGEMIN;
                conProd.VGEMAX__c=rtgRngWrap.VGEMAX;
                conProd.RG3DRT__c=rtgRngWrap.RG3DRT;
                conProd.VG3DRT__c=rtgRngWrap.VG3DRT;
                conProd.VG2MIN__c=rtgRngWrap.VG2MIN;
                conprod.VG2MAX__c=rtgRngWrap.VG2MAX;
                conProd.VG1MIN__c=rtgRngWrap.VG1MIN;
                conprod.VG1MAX__c=rtgRngWrap.VG1MAX;
                conProd.VTMR__c=rtgRngWrap.VTMR;
                rdOutput.ORV__c=rtgRngWrap.ORV;
                if(!conProd.Quote_Descriptions_Override__c)
                    rdOutput.ORV_Override__c=rtgRngWrap.ORV;
                conProd.VAssignedRangeType__c=rtgRngWrap.VAssignedRangeType;
            }
            conProd.Components_Flag__c=true;
            if(!showBDI) {
                conProd.Add_Integral_BDI_Integral_BDI_FLX_Sensor__c=null;
                conProd.Strip_Type__c=null;
                conProd.Gasket_Material__c=null;
                conProd.Wiring_Configuration__c=null;
                conProd.Wire_Type__c=null;
                conProd.Cable_Length__c=null;
                conProd.End_Connection__c=null;
                conProd.To_Make_With_BDI_FLX_Interface_cable__c=null;
            }
            if(!showInterfaceOptions)
                conProd.To_Make_With_BDI_FLX_Interface_cable__c=null;
            conProd.MCSM__c=rtgRngWrap.MCSM;
            string srtBMRCheck='-1';
            string srtTMRCheck='-1';
            if(conProd.BMRCHECK__c!=null)
                srtBMRCheck=conProd.BMRCHECK__c.setScale(2)+'';
            if(conProd.TMRCHECK__c!=null)
                srtTMRCheck=conProd.TMRCHECK__c.setScale(2)+'';
            mapAttributes1.put('PTC', conProd.Product__c);
            mapAttributes1.put('DSCVAR',  conProd.DSCVAR__c);
            mapAttributes1.put('SZC',ConstantsUtil.getSizeDesc(conProd.Size__c).SZC);
            mapAttributes1.put('WITHSTANDRDCOMP',  strWithStand1);
            mapAttributes1.put('MCD', MCD);
            mapAttributes1.put('TMRCHECK',srtTMRCheck+'');
            mapAttributes1.put('BMRCHECK',srtBMRCheck+'');
            mapAttributes1.put('SizeVal',ConstantsUtil.getSizeDesc(SZC).SizeValue+'');
            List<String> listFieldName = new List<String>{'Id'};
                Result RDCompDetails=wizardBaseDataProcessor.getDynamicQueryFromTranslationObj('Type__c','RD_ComponentMBTranslation__c','RD_ComponentMBDetail__c',mapAttributes1,listFieldName);
            string dynamicWhereMBC=' Where Id!=Null';
            if(String.isNotBlank(RDCompDetails.strRetValue)) {
                dynamicWhereMBC+=' AND ('+RDCompDetails.strRetValue+')';
            }
            System.debug('Dynamic Query'+dynamicWhereMBC);
            //string dynamicWhereMBC=' Where Id!=Null and Type__c=\'A\'  AND text1val__c=\''+conProd.Product__c+'\' AND text2val__c=\''+conProd.DSCVAR__c+'\'';
            for(String key1:cmpWrap.reqComponents) {
                if(mapFieldName.containsKey(key1)) {
                    string fieldName=mapFieldName.get(key1);
                    fieldName+='__c';
                    dynamicWhereMBC+=' AND '+fieldName+' = \'Required\'';
                }
            }
            System.debug('dynamicWhereMBC After Required: ' + dynamicWhereMBC);
            for(String key1:mapFieldName.keySet()) {
           // for(String key1:cmpWrap.optComponents) {
                if(!cmpWrap.reqComponents.contains(key1)) {
                    string fieldName=mapFieldName.get(key1);
                    fieldName+='__c';
                    if ((string) conProd.get(key1) != null)
                        dynamicWhereMBC+=' AND '+fieldName+' = \'Optional\'';
                    else
                        dynamicWhereMBC+=' AND '+fieldName+' = \'No\'';
                }
            }
            //}
            System.debug('dynamicWhereMBC After Optional: ' + dynamicWhereMBC);
            if(BDIRecords.isEmpty())
                conProd.Add_Integral_B_D_I_Integral_BDI_FLX_Sen__c=false;

            System.debug('############# dynamicWhereMBC: ' + dynamicWhereMBC);
            List<RD_ComponentMBDetail__c> RdCompList=Database.query('SELECT ASME_Inlet_Option_Code__c,ASME_Outlet_Option_Code__c,Outlet_Option_Code__c,Inlet_Option_Code__c FROM RD_ComponentMBDetail__c'+dynamicWhereMBC);
            System.debug('#############: ' + RdCompList.size());
            if(!RdCompList.isEmpty())
            {
                // System.debug('#############: Inside ' + RdCompList.size());
                // System.debug('#############: Inside ' + RdCompList[0].ASME_Inlet_Option_Code__c);
                // System.debug('#############: Inside ' + RdCompList[0].ASME_Outlet_Option_Code__c);
                // System.debug('#############: Inside ' + RdCompList[0].Inlet_Option_Code__c);
                // System.debug('#############: Inside ' + RdCompList[0].Outlet_Option_Code__c);

                conProd.ASME_Inlet_Option_Code__c=RdCompList[0].ASME_Inlet_Option_Code__c;
                conProd.ASME_Outlet_Option_Code__c=RdCompList[0].ASME_Outlet_Option_Code__c;
                conProd.Inlet_Option_Code__c=RdCompList[0].Inlet_Option_Code__c;
                conProd.Outlet_Option_Code__c=RdCompList[0].Outlet_Option_Code__c;
            } else  {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Invaild Combination: Please select valid components combination'));
                return null;
            }
            upsert rdOutput;
            upsert conProd;
        }
        catch(Exception dmle)
        {
            ApexPages.addMessages(dmle);
            return null;
        }

        return null;
    }
    public static string matlCodeProcessor(string key) {
        string ky1;
        if(key.length()==1)
            ky1='00'+key;
        else if(key.length()==2)
            ky1='0'+key;
        else
            ky1=key;
        return ky1;
    }
    public static Map<string,List<Derate_Value__c>> mapDerateValues(decimal tempVal) {
        Map<string,List<Derate_Value__c>> newMap=new Map<string,List<Derate_Value__c>>();
        System.debug('tempVal'+tempVal);
        Derate_Value__c[] derateList=Database.query('SELECT Id, Derate__c, DerateType__c, TempUL__c, TempLL__c, MatlCode__c FROM Derate_Value__c WHERE TempLL__c<='+tempVal+' AND TempUL__c>'+tempVal);
        //System.debug('query in local -->SELECT Id, Derate__c, DerateType__c, TempUL__c, TempLL__c, MatlCode__c FROM Derate_Value__c WHERE TempLL__c<='+tempVal+' AND TempUL__c>'+tempVal);
        Set<String> uniqueKey=new Set<String>();
        for (Derate_Value__c dt:derateList) {
            string key=matlCodeProcessor(dt.MatlCode__c+'')+dt.DerateType__c;
            if(uniqueKey.add(key)) {
                List<Derate_Value__c> dtl=new List<Derate_Value__c>();
                dtl.add(dt);
                newMap.put(key,dtl);
            } else {
                newMap.get(key).add(dt);
            }
        }
        System.debug('mapDetValues in local'+newMap);
        return newMap;
    }
    //*************************************************************************************************
    //Quote Description
    //*************************************************************************************************
    Set<String> quotesAttributeSet = new Set<String>{'OA','OB','ORP','ORV','OW'};
        public class QuoteDescriptionWrapper {
            public string attribute {set;get;}
            public string strDesc {set;get;}
            public string strDescOverride {set;get;}
            public Integer noOfLines {set;get;}
        }
    public List<QuoteDescriptionWrapper> quoteDescriptionList{get;set;}
    public list<QuoteDescriptionWrapper> getQuoteDescriptionRec()
    {
        quoteDescriptionList = new List<QuoteDescriptionWrapper>();
        for(string strAttr:quotesAttributeSet) {
            QuoteDescriptionWrapper quoteWrapper=new QuoteDescriptionWrapper();
            quoteWrapper.attribute=strAttr;
            String attributeFieldAPI = strAttr+'__c';
            String dec=(string) rdOutput.get(attributeFieldAPI);
            if(dec!=null) {
                List<String> lines = dec.split('\n');
                quoteWrapper.noOfLines = lines.size();
            } else {
                quoteWrapper.noOfLines=0;
            }
            quoteWrapper.strDesc=dec;
            String decOver=(string) rdOutput.get(strAttr+'_Override__c');
            quoteWrapper.strDescOverride=decOver;
            quoteDescriptionList.add(quoteWrapper);
            System.debug('quoteWrapper: ' + quoteWrapper);
        }
        System.debug('quoteDescriptionList: ' + quoteDescriptionList);
        return quoteDescriptionList;
    }
    public pageReference ApplyDefaultQuoteDescription() {
        if(!conProd.Quote_Descriptions_Override__c)
        {
            for(string strAttr:quotesAttributeSet) {
                //quoteWrapper.attribute=strAttr;
                String attributeFieldAPI = strAttr+'__c';
                String dec=(string) rdOutput.get(attributeFieldAPI);
                string attributeOverride=strAttr+'_Override__c';
                rdOutput.put(attributeOverride, dec);

            }
            conProd.NEWSPCLPARTNOBASE__c=null;
            conProd.ASSYPARTNOBASE__c=null;
            upsert rdOutput;
            update conProd;
            disableButton = (!showsales) && conProd.Quote_Descriptions_Override__c;
            /*List<SBQQ__Quote__Share> quoteSharelst = new List<SBQQ__Quote__Share>();
for(SBQQ__Quote__Share quoteShare : [select id,ParentId, AccessLevel,RowCause,UserOrGroup.name,UserOrGroup.Profile.name from SBQQ__Quote__Share
where UserOrGroup.Profile.Name in ('CDC Inside Sales','CDC Prod. Planning','CDC Partner Community Users Profile')
and RowCause<>'Owner' and ParentId = :conProd.Quote_Line__r.SBQQ__Quote__c ]){

if(!conProd.Quote_Descriptions_Override__c)  {
quoteShare.AccessLevel = 'Edit';
quoteSharelst.add(quoteShare);

}else{
quoteShare.AccessLevel = 'Read';
quoteSharelst.add(quoteShare);
}
}*/
        }

        return getPARTBASE();
    }
    public pageReference saveQuoteDescription() {
        system.debug('SAVE --> ASSYPARTNOBASE__c'+conProd.ASSYPARTNOBASE__c);
        system.debug('SAVE --> NEWSPCLPARTNOBASE__c'+conProd.NEWSPCLPARTNOBASE__c);
        if((string.isBlank(conProd.ASSYPARTNOBASE__c) && string.isBlank(conProd.NEWSPCLPARTNOBASE__c)) && conProd.Quote_Descriptions_Override__c) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Value for PARTNUMBER BASE to complete this action.'));
            return null;
        }
        if(quoteDescriptionList != null && quoteDescriptionList.size() > 0)
        {
            for(QuoteDescriptionWrapper rdQ : quoteDescriptionList)
            {
                String attributeFieldAPI = rdQ.attribute+'_Override__c';
                rdOutput.put(attributeFieldAPI, rdQ.strDescOverride);
            }
            update rdOutput;
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                quoteLine.SBQQ__Description__c=strquoteDes.replaceAll('</BR>', '<BR>');
                //quoteLine.SBQQ__Description__c=strquoteDes;
                upsert quoteLine;
            }
        }
        //update conProd;
        return savePartNumber();
    }
    public pageReference savePartNumber() {
        if(conProd.Quote_Descriptions_Override__c)
        {
            System.debug('NEWSPCLPARTNOBASE: ' + conProd.NEWSPCLPARTNOBASE__c);
            if(String.isBlank(conProd.NEWSPCLPARTNOBASE__c) && string.isBlank(conProd.ASSYPARTNOBASE__c)) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select a value for PARTNUMBER BASE'));
                return null;
            }
            if(String.isNotBlank(conProd.NEWSPCLPARTNOBASE__c) && string.isNotBlank(conProd.ASSYPARTNOBASE__c)) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please choose only one option for PARTNUMBER BASE'));
                return null;
            }
        }
        update conProd;
        return null;
    }
    //*************************************************************************************************
    //Lead Time Data
    //*************************************************************************************************
    public pageReference ApplyDefaultLT() {
        if(!conProd.Lead_Time_Override__c) {
            rdOutput.Total_Lead_Time_40_ORD__c=rdOutput.Total_Lead_Time_40__c;
            rdOutput.Total_Lead_Time_CDC_ORD__c=rdOutput.Total_Lead_Time_CDC__c;
            rdOutput.Total_Lead_Time_GCI_ORD__c=rdOutput.Total_Lead_Time_GCI__c;
            rdOutput.Total_Lead_Time_GP_ORD__c=rdOutput.Total_Lead_Time_GP__c;
            upsert rdOutput;
            upsert conProd;
            if(!notValidStatusForChng.contains(strQuoteStatus)) {
                quoteLine.Run_Config_Sync__c = false;
                quoteLine.Leadtime_Site_10__c = rdOutput.Total_Lead_Time_GP_ORD__c;
                quoteLine.Leadtime_Site_20__c = rdOutput.Total_Lead_Time_GCI_ORD__c;
                quoteLine.Leadtime_Site_30__c = rdOutput.Total_Lead_Time_CDC_ORD__c;
                quoteLine.Leadtime_Site_40__c = rdOutput.Total_Lead_Time_40_ORD__c;
                upsert quoteLine;
            }
        }
        return null;
    }
    public pageReference saveLeadTime() {
        upsert rdOutput;
        upsert conProd;
        if(!notValidStatusForChng.contains(strQuoteStatus)) {
            quoteLine.Run_Config_Sync__c = false;
            quoteLine.Leadtime_Site_10__c = rdOutput.Total_Lead_Time_GP_ORD__c;
            quoteLine.Leadtime_Site_20__c = rdOutput.Total_Lead_Time_GCI_ORD__c;
            quoteLine.Leadtime_Site_30__c = rdOutput.Total_Lead_Time_CDC_ORD__c;
            quoteLine.Leadtime_Site_40__c = rdOutput.Total_Lead_Time_40_ORD__c;
            upsert quoteLine;
        }
        return null;
    }
    //**************************************************************************************************
    //COST LOGIC WILL START HERE
    //**************************************************************************************************
    public List<Cost__c> assembleCost{get;set;}
    public List<Cost__c> buildCost{get;set;}
    public List<Cost__c> overridenCost{get;set;}
    public void getCost() {
        assembleCost = new List<Cost__c>();
        buildCost = new List<Cost__c>();
        overridenCost = new List<Cost__c>();
        // WizardCostProcessor wcp = new WizardCostProcessor(conProd.Id);
        // Map<String,List<Cost__c>> getCst = wcp.getBGRCostData();
        List<Cost__c> costList = [SELECT id,name,Product__c,Cost_Method__c,Part_Number__c,Ref_Id__c,Cost_Sub_Type__c,
                                  Inside_Cost_10__c,Inside_Cost_20__c,Inside_Cost_30__c,
                                  Outside_Cost_10__c,Outside_Cost_20__c,Outside_Cost_30__c,
                                  Inside_Cost_Override_10__c,Inside_Cost_Override_20__c,Inside_Cost_Override_30__c,
                                  Outside_Cost_Override_10__c,Outside_Cost_Override_20__c,Outside_Cost_Override_30__c
                                  FROM Cost__c where Ref_Id__c=:conProd.Id];
        for (Cost__c cs:costList) {
            if(cs.Cost_Method__c=='Assembly')
                assembleCost.add(cs);
            else if(cs.Cost_Method__c=='Build Up')
                buildCost.add(cs);
            else if(cs.Cost_Method__c=='Overriden')
                overridenCost.add(cs);
        }
    }
    public pageReference ApplyDefaultCost() {
        if(conProd.Build_Cost_Override__c == false)
        {
            List<Cost__c> allCost = new List<Cost__c>();
            if(assembleCost.size() > 1)
            {
                allCost.addAll(assembleCost);
            }
            if(buildCost.size() > 0)
            {
                allCost.addAll(buildCost);
            }
            if(allCost.size() > 0)
            {
                for(Cost__c costRecord: buildCost)
                {
                    costRecord = copyCostToCostOverride(costRecord);
                }
                Cost__c nCst= overridenCost[0];
                for(Cost__c costRecord: buildCost)
                {
                    //costRecord = copyCostToCostOverride(costRecord);
                    nCst.Inside_Cost_10__c=costRecord.Inside_Cost_Override_10__c;
                    nCst.Outside_Cost_10__c=costRecord.Outside_Cost_Override_10__c;
                    nCst.Inside_Cost_20__c=costRecord.Inside_Cost_Override_20__c;
                    nCst.Outside_Cost_20__c=costRecord.Outside_Cost_Override_20__c;
                    nCst.Inside_Cost_30__c=costRecord.Inside_Cost_Override_30__c;
                    nCst.Outside_Cost_30__c=costRecord.Outside_Cost_Override_30__c;
                    //nCst.Inside_Cost_10__c
                    allCost.add(nCst);
                }
                update allCost;
            }
            update conProd;
            getCost();
        }
        return null;
    }
    public pageReference saveCosting()
    {
        List<Cost__c> allCost = new List<Cost__c>();
        if(assembleCost.size() > 1)
        {
            allCost.addAll(assembleCost);
        }
        if(buildCost.size() > 0)
        {
            allCost.addAll(buildCost);
        }
        if(allCost.size() > 0)
        {
            Cost__c nCst= overridenCost[0];
            for(Cost__c costRecord: buildCost)
            {
                //costRecord = copyCostToCostOverride(costRecord);
                nCst.Inside_Cost_10__c=costRecord.Inside_Cost_Override_10__c;
                nCst.Outside_Cost_10__c=costRecord.Outside_Cost_Override_10__c;
                nCst.Inside_Cost_20__c=costRecord.Inside_Cost_Override_20__c;
                nCst.Outside_Cost_20__c=costRecord.Outside_Cost_Override_20__c;
                nCst.Inside_Cost_30__c=costRecord.Inside_Cost_Override_30__c;
                nCst.Outside_Cost_30__c=costRecord.Outside_Cost_Override_30__c;
                //nCst.Inside_Cost_10__c
                allCost.add(nCst);
            }
            update allCost;
            //update allCost;
        }
        update conProd;
        getCost();
        return null;
    }
    public Cost__c copyCostToCostOverride(Cost__c costRecord)
    {
        costRecord.Inside_Cost_Override_10__c = costRecord.Inside_Cost_10__c;
        costRecord.Outside_Cost_Override_10__c = costRecord.Outside_Cost_10__c;
        costRecord.Inside_Cost_Override_20__c = costRecord.Inside_Cost_20__c;
        costRecord.Outside_Cost_Override_20__c = costRecord.Outside_Cost_20__c;
        costRecord.Inside_Cost_Override_30__c = costRecord.Inside_Cost_30__c;
        costRecord.Outside_Cost_Override_30__c = costRecord.Outside_Cost_30__c;
        return costRecord;
    }


    public pageReference goBack() {
        Id qID=[SELECT Id,SBQQ__Quote__c FROM SBQQ__QuoteLine__c  WHERE id = :quotelineId].SBQQ__Quote__c;
        User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
        system.debug('$$$Back URl:'+qID);
        if(userinfo.IsPortalEnabled){
            strURL = '/s/rupturedisccmp?quoteId='+qID + '&configId=' + conProd.Id;
        }else{
            strURL = '/lightning/cmp/c__ruptureDiscCmp?c__configId='+conProd.Id + '&c__quoteId=' +qID;
        }
        return null;
    }

    /*  public PageReference goBack() {
Id qID=[SELECT Id,SBQQ__Quote__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteLineId].SBQQ__Quote__c;
User userinfo = [Select ContactId, Profile.Name,IsPortalEnabled from user where Id=: UserInfo.getUserId()];
//string pgRef = '';
if(userinfo.IsPortalEnabled){
// refURL = '/s/rupturedisccmp?configId='+conProd.id + '&quoteId=' + quoteLineId;
refURL =  '/s/detail/' + qID;
}else{
// refURL = '/lightning/cmp/c__ruptureDiscCmp?c__configId='+conProd.id + '&c__quoteId=' + quoteLineId;
refURL = '/lightning/r/SBQQ__Quote__c/'+qID+'/view';
}

// if(userinfo.IsPortalEnabled){
//     refURL =  '/s/productrecommendationscmp?configId='+conProd.id;
// }else{
//     refURL = '/lightning/cmp/c__productRecommendationsCmp?c__configId='+ conProd.id;
// }

//'/lightning/cmp/c__productRecommendationsCmp?c__configId='+conProd.id+'&c__quoteId='+qID
/*PageReference pageRef = new PageReference(pgRef);
pageRef.setRedirect(true);
return pageRef;* /
return null;
}*/

    //Router Wrapper
    public class RouterWrapper
    {
        public string strOperation_No {set;get;}
        public string strStandard_Operation_ID {set;get;}
        public string strOutside_Operation_Item {set;get;}
    }
    public list<RouterWrapper> getRouter()
    {
        list<RouterWrapper> RouterWrapList=new list<RouterWrapper>();

        if (conProd.Finish_Configuration_Flag__c && showProductMnfOutputs) {
            result res=new result();
            if(RDOU!=null) {
                res=RDOU.getRouting();
                if(res.bResult)
                {
                    for (sObject sobj:res.objResultList)
                    {
                        RouterWrapper docWrap=new RouterWrapper();
                        docWrap.strOperation_No  = (string) sobj.get('Operation_No__c');
                        docWrap.strStandard_Operation_ID = (string) sobj.get('Standard_Operation_ID__c');
                        docWrap.strOutside_Operation_Item = (string) sobj.get('Outside_Operation_Item__c');
                        RouterWrapList.add(docWrap);
                    }
                }
            }
        }
        return RouterWrapList;
    }

    //WorkGuidelinesWrapper
    public pageReference reld() {
        return null;
    }
    public class WorkGuideLineWrapper
    {
        public string strOperation {set;get;}
        public string strGuidline_Seq {set;get;}
        public string strDescription{set;get;}
        public string strText {set;get;}
        public string strType {set;get;}
        public string strSign_Off {set;get;}
        public string strInspection_Sign_Off_Required {set;get;}
    }
    public list<WorkGuideLineWrapper> getWorkGuideLines() {
        list<WorkGuideLineWrapper> workguildeWrapList=new list<WorkGuideLineWrapper>();
        if (conProd.Finish_Configuration_Flag__c && showProductMnfOutputs) {
            result res=new result();
            res=RDOU.getWorkGuideLines();
            if(res.bResult) {
                List<Integer> aList = new List<Integer>();
                for (sObject sobj:res.objResultList)
                {
                    string a=(string) sobj.get('Guidline_Seq__c');
                    Integer i=integer.valueOf(a);
                    aList.add(i);
                }
                aList.sort();
                for(Integer a: aList)
                {
                    for (sObject sobj:res.objResultList)
                    {
                        string a2=(string) sobj.get('Guidline_Seq__c');
                        Integer i2=integer.valueOf(a2);
                        if(a==i2)
                        {
                            WorkGuideLineWrapper stWrap=new WorkGuideLineWrapper();
                            stWrap.strOperation = (string) sobj.get('Operation__c');
                            stWrap.strGuidline_Seq = (string) sobj.get('Guidline_Seq__c');
                            stWrap.strDescription = (string) sobj.get('Description__c');
                            stWrap.strText = (string) sobj.get('Text__c');
                            stWrap.strType = (string) sobj.get('Type__c');
                            stWrap.strSign_Off = (string) sobj.get('Sign_Off__c');
                            stWrap.strInspection_Sign_Off_Required = (string) sobj.get('Inspection_Sign_Off_Required__c');
                            workguildeWrapList.add(stWrap);
                        }
                    }
                }
            }
        }
        return workguildeWrapList;
    }
    // Evaluation Wrapper
    public class EvaluationWrapper
    {
        public string strOutput {set;get;}
        public string strAttribute {set;get;}
    }
    // public list<EvaluationWrapper> getEvaluation() {
    //         list<EvaluationWrapper> evaluationWrapList=new list<EvaluationWrapper>();
    //         result res=new result();
    //         res=RDOU.getEvaluation();
    //         if(res.bResult) {
    //             for (sObject sobj:res.objResultList)
    //             {
    //                 EvaluationWrapper stWrap=new EvaluationWrapper();
    //                 stWrap.strOutput = (string) sobj.get('Output__c');
    //                 stWrap.strAttribute = (string) sobj.get('Attribute__c');
    //                 evaluationWrapList.add(stWrap);
    //             }
    //         }
    //         return evaluationWrapList;
    //     }
    // ControlPlan Wrapper
    public class documentWrapper {
        public string documentType {set;get;}
        public string documentId {set;get;}
    }
    public list<documentWrapper> getDocWrapper() {
        list<documentWrapper> dcWrpper = new list<documentWrapper>();
        result res=new result();
        result resDiaData=new result();
        map<string,string> mapDia=new map<string,string>();
        mapDia.put('PTC',conProd.Product__c);
        mapDia.put('SZC',ConstantsUtil.getSizeDesc(conProd.Size__c).SZC);
        mapDia.put('STC',conProd.Seat__c);
        mapDia.put('HCLASS',conProd.Pressure_Class__c);
        mapDia.put('HIC',conProd.Inlet_Connection__c);
        mapDia.put('HOC',conProd.Outlet_Connection__c);
        mapDia.put('DSCVAR',conProd.DSCVAR__c);
        mapDia.put('CUTR',conProd.CU_TR__c?'Y':'N');
        List <String> selectCols=new List <String>();
        selectCols.add('DWGNO__c');
        selectCols.add('DrawingID__c');
        selectCols.add('Revision__c');
        selectCols.add('DimA__c');
        selectCols.add('DimB__c');
        selectCols.add('DimC__c');
        selectCols.add('DimD__c');
        selectCols.add('DimE__c');
        selectCols.add('DimF__c');
        selectCols.add('Document_Type__c');
        mapDia.put('SizeValue',String.ValueOf(ConstantsUtil.getSizeDesc(conProd.Size__c).SizeValue));
        resDiaData=wizardBaseDataProcessor.getDataFromTranslationObj('Document_Type__c','RD_Manufacturing_Document_Translation__c','RD_Manufacturing_Document_Detail__c',mapDia,selectCols);
        if(resDiaData.bResult) {
            for (sObject sobj:resDiaData.objResultList) {
                documentWrapper dcw=new documentWrapper();
                dcw.documentType=(string) sobj.get('Document_Type__c');
                dcw.documentId =(string) sobj.get('DWGNO__c');
                dcWrpper.add(dcw);
            }
        }
        return dcWrpper;
    }
    // ControlPlan Wrapper
    public class ControlPlanWrapper
    {
        public string strTest_OPNO {set;get;}
        public string strTEST_OPERATION_DESC {set;get;}
        public string strNORM_TYPE {set;get;}
        public string strOperation_Number {set;get;}
        public string strDATA_TYPE {set;get;}
        public string strCATEGORY_ID {set;get;}
        public string strINSPECTION_CODE {set;get;}
        public string strSAMPLE_PERCENT {set;get;}
        public string strProcess_Characteristic {set;get;}
        public string strSpecial_Characteristic_Classification {set;get;}
        public string strOUTER_MIN {set;get;}
        public string strINNER_MIN {set;get;}
        public string strNOMINAL_VALUE {set;get;}
        public string strINNER_MAX {set;get;}
        public string strOUTER_MAX {set;get;}
        public string strTool_ID {set;get;}
        public string strData_Point {set;get;}
    }
    public list<ControlPlanWrapper> getControlPlan() {
        list<ControlPlanWrapper> controlPlanWrapList=new list<ControlPlanWrapper>();

        result res=new result();
        if (conProd.Finish_Configuration_Flag__c && showProductMnfOutputs) {
            Map<String,string> dynValues=new Map<string,string>();
            dynValues.put('[RGSMIN]',conProd.RGSMIN__c==NULL?'':conProd.RGSMIN__c+'');
            dynValues.put('[RGSMAX]',conProd.RGSMAX__c==NULL?'':conProd.RGSMAX__c+'');
            dynValues.put('[VGSMIN]',RDOU.mapRDAttr.containsKey('VGSMIN')?RDOU.mapRDAttr.get('VGSMIN'):'');
            dynValues.put('[VGSMAX]',RDOU.mapRDAttr.containsKey('VGSMAX')?RDOU.mapRDAttr.get('VGSMAX'):'');
            dynValues.put('[RGEMIN]',conProd.RGEMIN__c==NULL?'':conProd.RGEMIN__c+'');
            dynValues.put('[RGEMAX]',conProd.RGEMAX__c==NULL?'':conProd.RGEMAX__c+'');
            dynValues.put('[VGEMIN]',RDOU.mapRDAttr.containsKey('VGEMIN')?RDOU.mapRDAttr.get('VGEMIN'):'');
            dynValues.put('[VGEMAX]',RDOU.mapRDAttr.containsKey('VGEMAX')?RDOU.mapRDAttr.get('VGEMAX'):''); //Service Ticket #200731
            dynValues.put('[BACKPRESSCONV] * 1.1',RDOU.mapRDAttr.containsKey('BACKPRESSCONV')?RDOU.mapRDAttr.get('BACKPRESSCONV'):'');
            res=RDOU.getControlPlan();
            if(res.bResult) {
                List<Integer> aList = new List<Integer>();
                for (sObject sobj:res.objResultList)
                {
                    string a=(string) sobj.get('Test_OPNO__c');
                    Integer i=integer.valueOf(a);
                    aList.add(i);
                }
                aList.sort();
                for(Integer a: aList)
                {
                    for (sObject sobj:res.objResultList)
                    {
                        string a2=(string) sobj.get('Test_OPNO__c');
                        Integer i2=integer.valueOf(a2);
                        if(a==i2)
                        {
                            ControlPlanWrapper stWrap=new ControlPlanWrapper();
                            stWrap.strTest_OPNO = (string) sobj.get('Test_OPNO__c');
                            stWrap.strTEST_OPERATION_DESC = (string) sobj.get('TEST_OPERATION_DESC__c');
                            stWrap.strNORM_TYPE = (string) sobj.get('NORM_TYPE__c');
                            stWrap.strOperation_Number = (string) sobj.get('Operation_Number__c');
                            stWrap.strDATA_TYPE = (string) sobj.get('DATA_TYPE__c');
                            stWrap.strCATEGORY_ID = (string) sobj.get('CATEGORY_ID__c');
                            stWrap.strINSPECTION_CODE = (string) sobj.get('INSPECTION_CODE__c');
                            stWrap.strSAMPLE_PERCENT = (string) sobj.get('SAMPLE_PERCENT__c');
                            stWrap.strProcess_Characteristic = (string) sobj.get('Process_Characteristic__c');
                            stWrap.strSpecial_Characteristic_Classification = (string) sobj.get('Special_Characteristic_Classification__c');
                            String outMinVal='';
                            if((string) sobj.get('OUTER_MIN__c')!=null) {
                                string strv=(string) sobj.get('OUTER_MIN__c');
                                if(strv.contains('['))
                                {
                                    if(dynValues.containsKey(strv)) {
                                        outMinVal=dynValues.get(strv);
                                    } else {
                                        outMinVal=strv;
                                    }
                                } else {
                                    outMinVal=strv;
                                }
                            }
                            stWrap.strOUTER_MIN = outMinVal;
                            stWrap.strINNER_MIN = (string) sobj.get('INNER_MIN__c');
                            String nominalVal='';
                            if((string) sobj.get('NOMINAL_VALUE__c')!=null) {
                                string strv=(string) sobj.get('NOMINAL_VALUE__c');
                                if(strv.contains('[BACKPRESSCONV]'))
                                {
                                    system.debug('[BACKPRESSCONV]------------1');
                                    if(dynValues.containsKey('[BACKPRESSCONV] * 1.1')) {
                                        //system.debug('[BACKPRESSCONV]------------2'+dynValues.get(strv));
                                        //dynValues.get(strv);
                                        nominalVal=conProd.Converted_Back_Pressure_Value__c*1.1+'';
                                    } else {
                                        nominalVal=strv;
                                    }
                                } else {
                                    nominalVal=strv;
                                }
                            }
                            stWrap.strNOMINAL_VALUE = nominalVal;
                            stWrap.strINNER_MAX = (string) sobj.get('INNER_MAX__c');
                            String outMaxVal='';
                            if((string) sobj.get('OUTER_MAX__c')!=null) {
                                string strv=(string) sobj.get('OUTER_MAX__c');
                                if(strv.contains('['))
                                {
                                    if(dynValues.containsKey(strv)) {
                                        outMaxVal=dynValues.get(strv);
                                    } else {
                                        outMaxVal=strv;
                                    }
                                } else {
                                    outMaxVal=strv;
                                }
                            }
                            stWrap.strOUTER_MAX = outMaxVal;
                            stWrap.strTool_ID = (string) sobj.get('Tool_ID__c');
                            stWrap.strData_Point = (string) sobj.get('Data_Point__c');
                            controlPlanWrapList.add(stWrap);
                        }
                    }
                }
            }
        }
        return controlPlanWrapList;
    }
    // OW Wrapper
    public class OWWrapper
    {
        public string strComp {set;get;}
        public string strOWDesc {set;get;}
    }
    public list<OWWrapper> getOW() {
        list<OWWrapper> oWWrapList=new list<OWWrapper>();
        result res=new result();
        // if (conProd.Finish_Configuration_Flag__c) {
        //     //if(RDOU!=null)
        //         res=RDOU.getOW();
        //         if(res.bResult) {
        //             for (sObject sobj:res.objResultList)
        //             {
        //                 OWWrapper stWrap=new OWWrapper();
        //                 stWrap.strComp = (string) sobj.get('Comp__c');
        //                 stWrap.strOWDesc = (string) sobj.get('OWDesc__c');
        //                 oWWrapList.add(stWrap);
        //             }
        //         }
        //     //}
        // }
        return oWWrapList;
    }
    public Decimal  RTTMDF {
        get {
            return conProd.Converted_Temperature_Setting__c;
        }
        set {
            conProd.Converted_Temperature_Setting__c = value;
            this.RTTMDF = value;
        }
    }
    public String strSZC {
        get {
            return ConstantsUtil.getSizeDesc(conProd.Size__c).SZC;
        }
        set {
            //conProd.Size__c = value;
            this.strSZC = value;
        }
    }
    // public List<Disc_Information__c> rdDscInfoLst{set;get;}
    // public List<Disc_Information__c> rdDisInfoList() {
    //     decimal RGEMIN=0;
    //     if(conProd.RGEMIN__c!=null)
    //         RGEMIN=conProd.RGEMIN__c;
    //     string query='select SealMatl__c,SlotCovThck__c,SCStripThck__c,SealThck__c from Disc_Information__c where PTC__c=\''+conProd.Product__c+'\' AND SZC__c=\''+strSZC+'\'  AND MfgRngLL__c<='+RGEMIN.setScale(2)+' AND MfgRngUL__c>'+RGEMIN.setScale(2)+' AND TempLL__c<='+RTTMDF+' AND TempUL__c>'+RTTMDF;
    //     system.debug('query'+query);
    //     List<Disc_Information__c> rd=database.query(query);
    //     return rd;
    // }
    public decimal RGEMIN {
        get {
            return conProd.RGEMIN__c==null?0:conProd.RGEMIN__c;
        }
        set {
            this.RGEMIN = value;
        }
    }
    public decimal VG2MIN {
        get {
            return conProd.VG2MIN__c==null?0:conProd.VG2MIN__c;
        }
        set {
            this.VG2MIN = value;
        }
    }
    public decimal RG2MIN {
        get {
            return conProd.RG2MIN__c==null?0:conProd.RG2MIN__c;
        }
        set {
            this.RG2MIN = value;
        }
    }
    public decimal VGSMIN {
        get {
            return conProd.VGSMIN__c==null?0:conProd.VGSMIN__c;
        }
        set {
            this.VGSMIN = value;
        }
    }
    public decimal RGSMIN {
        get {
            return conProd.RGSMIN__c==null?0:conProd.RGSMIN__c;
        }
        set {
            this.RGSMIN = value;
        }
    }
    public List<RD_tblPosCalRating__c> rdPosBaseList() {
        string query;
        if(conprod.Product__c=='CAL') {
            query='select NRSC2Thck__c,MinGrdlRatedUL__c,MinGrdlRatedLL__c,MinTSMfgRngLL__c,MinTSMfgRngUL__c,SC2Thck__c,NRSC1Thck__c,SC1Thck__c,SealThck__c from RD_tblPosCalRating__c where PTC__c=\''+conProd.Product__c+'\' and SZC__c=\''+ConstantsUtil.getSizeDesc(conProd.Size__c).SZC+'\' and TempLL__c<'+conprod.Converted_Temperature_Setting__c+' AND TempUL__c>='+conprod.Converted_Temperature_Setting__c;
        } else {
            query='select NRSC2Thck__c,MinGrdlRatedUL__c,MinGrdlRatedLL__c,MinTSMfgRngLL__c,MinTSMfgRngUL__c,SC2Thck__c,NRSC1Thck__c,SC1Thck__c,SealThck__c from RD_tblPosCalRating__c where PTC__c=\''+conProd.Product__c+'\' and SZC__c=\''+ConstantsUtil.getSizeDesc(conProd.Size__c).SZC+'\' and TempLL__c<='+conprod.Converted_Temperature_Setting__c+' AND TempUL__c>'+conprod.Converted_Temperature_Setting__c;
        }
        List<RD_tblPosCalRating__c> rd=database.query(query);
        return rd;
    }
    public decimal rdPosCalVal(string selCol,decimal decMinGrd,decimal decMinTs,RD_tblPosCalRating__c[] posBase) {
        for(RD_tblPosCalRating__c pos:posBase) {
            boolean minGrdRateCheck=pos.MinGrdlRatedLL__c<=decMinGrd&&pos.MinGrdlRatedUL__c>decMinGrd;
            boolean minTSMfgCheck=pos.MinTSMfgRngLL__c<=decMinTs&&pos.MinTSMfgRngUL__c>decMinTs;
            if(minGrdRateCheck && minTSMfgCheck) {
                return (decimal) pos.get(selCol);
            }
        }
        return 0.0;
    }
    //*******************************************************************************************************/
    //Logic to populate the Structure details
    //*******************************************************************************************************/
    public List<RdOutputBaseUtility.RDStructureWrapper> RDOBUStructWrapper{get;set;}
    public List<RdOutputBaseUtility.RDStructureWrapper> getStructureData() {
        System.debug('Inside Structure11: ');
        List<RdOutputBaseUtility.RDStructureWrapper> str=new List<RdOutputBaseUtility.RDStructureWrapper>();
        System.debug('Inside Structure: ');
        if(conProd.Finish_Configuration_Flag__c) {
            // try {
            //     //RdOutputBaseUtility rdu=new RdOutputBaseUtility('a6W2C000000dYzzUAE');
            //     //RdOutputBaseUtility rdu=new RdOutputBaseUtility(conProd.Id);
            //     str=RDOU.getConsolidatedStructureDetails();
            //     System.debug('str: ' + str);
            // } catch (Exception e) {
            //     System.debug('Error Occurred While fetching the Structure Details ConfigureRD: ' +e.getMessage());
            // }
        }
        //RDOBUStructWrapper=str;
        return RDOBUStructWrapper;
    }
    //
    public pageReference getTabData()
    {
        System.debug('*** selectedTab = '+selectedTab);
        if(selectedTab == 'ProductReview')
        {
            rdOutput=[Select Base_Lead_Time_GP__c,Base_Lead_Time_GCI__c,Base_Lead_Time_CDC__c,Base_Lead_Time_40__c,
                      Adder_Lead_Time_GP__c,Adder_Lead_Time_GCI__c,Adder_Lead_Time_CDC__c,Adder_Lead_Time_40__c,
                      Comp_Lead_Time_GP__c,Comp_Lead_Time_GCI__c,Comp_Lead_Time_CDC__c,Comp_Lead_Time_40__c,
                      Total_Lead_Time_CDC__c,Total_Lead_Time_GP__c,Total_Lead_Time_GCI__c,Total_Lead_Time_GP_ORD__c,
                      Total_Lead_Time_40__c,OW__c,OW_Override__c,OA__c,OA_Override__c,OB__c,OB_Override__c,ORP__c,
                      ORP_Override__c,ORV__c,ORV_Override__c,Total_Lead_Time_CDC_ORD__c,Total_Lead_Time_GCI_ORD__c,
                      LABMAT__c,LABDSC__c,Total_Lead_Time_40_ORD__c,ORP010__c,ORP020__c,ORP025__c,ORV025__c,ORP015__c,ORP027__c,ORV010__c,ORV020__c,
                      ORV015__c,ORV027__c, SRV__c ,SRP__c FROM RD_Outputs__c WHERE RD_Outputs_Relation_Field__c=:conProd.Id  order by createddate asc limit 1];
            rdOutlist.clear();
            rdOutlist.add(rdOutput);
            getPricingData();
            showPricing=false;
            showProductReview=true;
            showProductDiagram=false;
            showProductEngSpl=false;
            showProductMnfOutputs=false;
            showProductTroubleSouting=false;
            System.debug('showProductReview'+showProductReview);
        }
        else if(selectedTab == 'Pricing') {
            getPricingData();
            getCost();
            showPricing=true;
            showProductReview=false;
            showProductDiagram=false;
            showProductEngSpl=false;
            showProductMnfOutputs=false;
            showProductTroubleSouting=false;
        }
        else if (selectedTab == 'Diagram') {
            getDiaData();
            showPricing=false;
            showProductReview=false;
            showProductDiagram=true;
            showProductEngSpl=false;
            showProductMnfOutputs=false;
            showProductTroubleSouting=false;
        }
        else if(selectedTab == 'EngineeringSpl')
        {
            showPricing=false;
            showProductReview=false;
            showProductDiagram=false;
            showProductEngSpl=true;
            showProductMnfOutputs=false;
            showProductTroubleSouting=false;

        }
        else if(selectedTab == 'MfgOutputs')
        {
            if(conProd.Finish_Configuration_Flag__c) {
                getDiaData();
                showPricing=false;
                showProductReview=false;
                showProductDiagram=false;
                showProductEngSpl=false;
                showProductMnfOutputs=true;
                showProductTroubleSouting=false;
                RDOBUStructWrapper=RDOU.getConsolidatedStructureDetails();
                //Map<String,string> consolidatedMap=new Map<String,string>();
                rdOutput=[Select Base_Lead_Time_GP__c,Base_Lead_Time_GCI__c,Base_Lead_Time_CDC__c,Base_Lead_Time_40__c,
                          Adder_Lead_Time_GP__c,Adder_Lead_Time_GCI__c,Adder_Lead_Time_CDC__c,Adder_Lead_Time_40__c,
                          Comp_Lead_Time_GP__c,Comp_Lead_Time_GCI__c,Comp_Lead_Time_CDC__c,Comp_Lead_Time_40__c,
                          Total_Lead_Time_CDC__c,Total_Lead_Time_GP__c,Total_Lead_Time_GCI__c,Total_Lead_Time_GP_ORD__c,
                          Total_Lead_Time_40__c,OW__c,OW_Override__c,OA__c,OA_Override__c,OB__c,OB_Override__c,ORP__c,
                          ORP_Override__c,ORV__c,ORV_Override__c,Total_Lead_Time_CDC_ORD__c,Total_Lead_Time_GCI_ORD__c,
                          LABMAT__c,LABDSC__c,Total_Lead_Time_40_ORD__c,ORP010__c,ORV020__c,ORP020__c,ORP025__c,ORV025__c,ORP015__c,ORP027__c,ORV010__c,
                          ORV015__c,ORV027__c, SRV__c ,SRP__c FROM RD_Outputs__c WHERE RD_Outputs_Relation_Field__c=:conProd.Id order by createddate asc limit 1];
                getDiaData();
                RDOU.rdDiagram=rdDiagram;
                RDOU.rdOutputs=rdOutput;
                Map<String,string> consolidatedMap=new Map<String,string>();
                RDOU.mapRDAttr.clear();
                RDOU.RD_tblASMEValues=RDOU.RD_tblASMEValues();
                consolidatedMap=RDOU.getMapDetails();
                RDOU.mapRDAttr.putAll(consolidatedMap);
                IFS_character_codes__c[] IFS_Attr=[select Element__c,Attribute_Code__c from IFS_character_codes__c where Interface_to_IFS_Attributes__c=true and Product__c='RD'];
                result res=RDOU.getLookupAttributes();
                for(IFS_character_codes__c ifsAtt:IFS_Attr) {
                    if(RDOU.mapRDAttr.containsKey(ifsAtt.Attribute_Code__c)) {
                        // if(ifsAtt.Attribute_Code__c=='SRV') {
                        //     mapIFSAttributes.put(ifsAtt.Attribute_Code__c,rtgRngWrap.SRV);
                        //     continue;
                        // }
                        // if(ifsAtt.Attribute_Code__c=='SRP') {
                        //     mapIFSAttributes.put(ifsAtt.Attribute_Code__c,rtgRngWrap.SRP);
                        //     continue;
                        // }
                        if(RDOU.mapRDAttr.get(ifsAtt.Attribute_Code__c)!=null)
                            mapIFSAttributes.put(ifsAtt.Attribute_Code__c,RDOU.mapRDAttr.get(ifsAtt.Attribute_Code__c));
                        else
                            mapIFSAttributes.put(ifsAtt.Attribute_Code__c,'');
                        //System.debug('Final values : ' +RDOU.mapRDAttr.get(str));


                    } else {
                        mapIFSAttributes.put(ifsAtt.Attribute_Code__c,'');
                    }
                    // map<string,string> ratingMap=rtgRngWrap.mapRatingValues1;
                    //mapIFSAttributes.putAll(ratingMap);

                    mapIFSAttributes.remove('SRV');
                    mapIFSAttributes.remove('SRP');
                    mapIFSAttributes.remove('SRP901');
                    mapIFSAttributes.remove('SRP902');
                    mapIFSAttributes.remove('SRP903');
                    mapIFSAttributes.remove('SRP904');
                }
            }
        }
        else if(selectedTab == 'TroubleShooting')
        {
            if(conProd.Finish_Configuration_Flag__c) {
                IFS_character_codes__c[] IFS_Attr=[select Element__c,Attribute_Code__c from IFS_character_codes__c where Interface_to_IFS_Attributes__c=true and Product__c='RD'];
                result res=RDOU.getLookupAttributes();
                for(IFS_character_codes__c ifsAtt:IFS_Attr) {
                    if(RDOU.mapRDAttr.containsKey(ifsAtt.Attribute_Code__c)) {
                        if(RDOU.mapRDAttr.get(ifsAtt.Attribute_Code__c)!=null)
                            mapIFSAttributes.put(ifsAtt.Attribute_Code__c,RDOU.mapRDAttr.get(ifsAtt.Attribute_Code__c));
                        else
                            mapIFSAttributes.put(ifsAtt.Attribute_Code__c,'');
                        //System.debug('Final values : ' +RDOU.mapRDAttr.get(str));
                    } else {
                        mapIFSAttributes.put(ifsAtt.Attribute_Code__c,'');
                    }
                }

                for(string key:RDOU.mapRDAttr.keySet()) {
                    if(!mapIFSAttributes.containskey(key)) {
                        mapNonIFSAttributes.put(key,RDOU.mapRDAttr.get(key));
                    }
                }
            }

            // for(IFS_character_codes__c ifsAtt:IFS_Attr) {
            //     if(RDOU.mapRDAttr.containsKey(ifsAtt.Attribute_Code__c)) {
            //         if(RDOU.mapRDAttr.get(ifsAtt.Attribute_Code__c)!=null)
            //             mapNonIFSAttributes.put(ifsAtt.Attribute_Code__c,RDOU.mapRDAttr.get(ifsAtt.Attribute_Code__c));
            //         else
            //             mapNonIFSAttributes.put(ifsAtt.Attribute_Code__c,'');
            //         //System.debug('Final values : ' +RDOU.mapRDAttr.get(str));
            //     } else {
            //             mapNonIFSAttributes.put(ifsAtt.Attribute_Code__c,'');
            //     }
            // }
            showPricing=false;
            showProductReview=false;
            showProductDiagram=false;
            showProductEngSpl=false;
            showProductMnfOutputs=false;
            showProductTroubleSouting=true;
            //getTroubleshootingAttributes();
        }

        return null;
    }
    //****************************************************************************************************** */
    //CLEANING LOGIC
    //******************************************************************************************************* */
    public void clearDataBasedOnReliefType(){
         System.debug('Relief_Type__c: '+conProd.Relief_Type__c);
         if (conProd.Relief_Type__c=='Pressure Relief'){
             conProd.Vacuum_Setting__c=null;
             conProd.Converted_Vacuum_Setting__c=null;
             conProd.Vacuum_Setting_Units__c=null;
             conProd.Converted_Positive_Pressure_Value__c=null;
             conProd.Positive_Pressure_Value__c=null;
             conProd.Positive_Pressure_Units__c=null;
             conProd.Pressure_Withstand__c=null;
             conProd.Constrain_product_selection__c=null;
         }
         if(conProd.Relief_Type__c=='Vacuum Relief'){
            conProd.Pressure_Setting__c=null;
             conProd.Converted_Pressure_Setting__c=null;
             conProd.Pressure_Setting_Units__c=null;
             conProd.Vacuum_Withstand__c=null;
             conProd.Back_Pressure_Value__c=null;
             conProd.Back_Pressure_Units__c=null;
             conProd.Converted_Back_Pressure_Value__c=null;
             conProd.Constrain_product_selection__c=null;
         }
         if (conProd.Relief_Type__c=='Pressure & Vacuum Relief'){
             conProd.Vacuum_Withstand__c=null;
             conProd.Back_Pressure_Value__c=null;
             conProd.Back_Pressure_Units__c=null;
             conProd.Converted_Back_Pressure_Value__c=null;
             conProd.Positive_Pressure_Value__c=null;
             conProd.Converted_Positive_Pressure_Value__c=null;
             conProd.Positive_Pressure_Units__c=null;
             conProd.Pressure_Withstand__c=null;
        }
     }
    // public void clearAllSectBfields(){
    //     conProd.Sizing_Flag__c=false;
    //     conProd.Required_Flow_Rate__c=null;
    //     conProd.Required_Flow_units__c=null;
    //     conProd.Relieving_Pressure_at_Inlet__c=null;
    //     conProd.Pressure_Relieving_Temperature__c=null;
    //     conProd.Enter_Relieving_Pressure_Value__c=null;
    //     conProd.Enter_Relieving_Pressure_units__c=null;
    //     conProd.Coefficient_of_Discharge__c=null;
    //     conProd.Enter_Different_Temperature_Value__c=null;
    //     conProd.Enter_Different_Temperature_Units__c=null;
    //     conProd.Density_Specific_Volume_Specific_Gravity__c=null;
    //     conProd.Density_SpecificVolume_SpcfcGravityUnits__c=null;
    //     conProd.Viscosity__c=null;
    //     conProd.Viscosity_units__c=null;
    //     conProd.Specific_Volume_at_inlet__c=null;
    //     conProd.Specific_Volume_at_Inlet_Units__c=null;
    //     conProd.Dryness_of_Wet_Steam__c=null;
    //     conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //     conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //     conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //     conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //     conProd.Stagnation_gas_vapor_quality__c=null;
    //     conProd.Liquid_density__c=null;
    //     conProd.Stagnation_vapor_density__c=null;
    //     conProd.Latent_heat_of_vaporization__c=null;
    //     conProd.Stagnation_gas_partial_pressure__c=null;
    //     conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //     conProd.Isentropic_coefficient_gas__c=null;
    //     conProd.Isentropic_coefficient_vapor__c=null;
    //     conProd.Molecular_Weight_gas__c=null;
    //     conProd.Molecular_Weight_vapor__c=null;
    //     conProd.Liquid_specific_heat__c=null;
    //     conProd.Liquid_density_Units__c=null;
    //     conProd.Vapor_Pres_to_Stagnation_temp_Units__c=null;
    //     conProd.Stagnation_Vapor_Density_Units__c=null;
    //     conProd.VacConverted_Flow_Rate__c=null;
    //     conProd.Stagnation_gas_partial_pressure_Units__c=null;
    //     conProd.VacRequired_Flow_Rate__c=null;
    //     conProd.VacRequired_Flow_Rate_Units__c=null;
    //     conProd.VacPressure_Relieving_Temperature__c=null;
    //     conProd.VacEnter_Different_Temperature_Value__c=null;
    //     conProd.VacEnter_Different_Temperature_Units__c=null;
    //     conProd.VacConverted_Different_Temp_Setting__c=null;
    //     conProd.Density_at_Inlet__c=null;
    //     conProd.Density_at_Inlet_Units__c=null;

    // }
    // public void clearSizingData() {
    //     switch on conProd.Evaluation_Per__c {
    //         When 'ASME Gas/Vapor' {
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;

    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;

    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;

    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //             conProd.Converted_Density__c=null;
    //             conProd.Converted_Viscosity__c=null;
    //             conProd.Converted_Specific_Volume__c=null;

    //         }
    //         when 'ASME Water'{
    //             conProd.Pressure_Relieving_Temperature__c=null;
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Enter_Different_Temperature_Value__c=null;
    //             conProd.Enter_Different_Temperature_Units__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //             conProd.Converted_Density__c=null;
    //             conProd.Converted_Viscosity__c=null;
    //             conProd.Converted_Specific_Volume__c=null;
    //             conProd.Converted_Relieving_Temperature__c=null;
    //             conProd.Converted_Relieving_Temperature__c=null;
    //             conProd.Converted_Different_Temperature_Setting__c=null;

    //         }
    //         when 'ASME Steam'{
    //             conProd.Pressure_Relieving_Temperature__c=null;
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Enter_Different_Temperature_Value__c=null;
    //             conProd.Enter_Different_Temperature_Units__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //             conProd.Converted_Density__c=null;
    //             conProd.Converted_Viscosity__c=null;
    //             conProd.Converted_Specific_Volume__c=null;
    //             conProd.Converted_Relieving_Temperature__c=null;
    //             conProd.Converted_Different_Temperature_Setting__c  =null;

    //         }
    //         when 'API Gas/Vapor'{
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //             conProd.Converted_Density__c=null;
    //             conProd.Converted_Viscosity__c=null;
    //             conProd.Converted_Specific_Volume__c=null;

    //         }
    //         when 'API Liquid'{
    //             conProd.Pressure_Relieving_Temperature__c=null;
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Enter_Different_Temperature_Value__c=null;
    //             conProd.Enter_Different_Temperature_Units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;

    //             conProd.Converted_Specific_Volume__c=null;
    //             conProd.Converted_Relieving_Temperature__c=null;
    //             conProd.Converted_Different_Temperature_Setting__c  =null;

    //         }
    //         when 'API Steam'{
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //             conProd.Converted_Density__c=null;
    //             conProd.Converted_Viscosity__c=null;
    //             conProd.Converted_Specific_Volume__c=null;

    //         }
    //         when 'ISO Gas/Vapor'{
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //             conProd.Converted_Density__c=null;
    //             conProd.Converted_Viscosity__c=null;
    //             conProd.Converted_Specific_Volume__c=null;

    //         }
    //         when 'ISO Liquid'{
    //             conProd.Pressure_Relieving_Temperature__c=null;
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Enter_Different_Temperature_Value__c=null;
    //             conProd.Enter_Different_Temperature_Units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;

    //             conProd.Converted_Viscosity__c=null;
    //             conProd.Converted_Relieving_Temperature__c=null;
    //             conProd.Converted_Different_Temperature_Setting__c  =null;


    //         }
    //         when 'ISO Dry Steam'{
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //             conProd.Converted_Density__c=null;
    //             conProd.Converted_Viscosity__c=null;
    //             conProd.Converted_Specific_Volume__c=null;

    //         }
    //         when 'ISO Wet Steam'{
    //             conProd.Pressure_Relieving_Temperature__c=null;
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Enter_Different_Temperature_Value__c=null;
    //             conProd.Enter_Different_Temperature_Units__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //             conProd.Converted_Density__c=null;
    //             conProd.Converted_Viscosity__c=null;
    //             conProd.Converted_Specific_Volume__c=null;
    //             conProd.Converted_Relieving_Temperature__c=null;
    //             conProd.Converted_Different_Temperature_Setting__c  =null;
    //         }
    //         when 'API Omega Method 2 Phase Flashing or Nonflashing'{
    //             conProd.Pressure_Relieving_Temperature__c=null;
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Enter_Different_Temperature_Value__c=null;
    //             conProd.Enter_Different_Temperature_Units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //             conProd.Converted_Relieving_Temperature__c=null;
    //             conProd.Converted_Different_Temperature_Setting__c  =null;
    //         }
    //         when 'API Omega Method Subcooled Liquid'{
    //             conProd.Pressure_Relieving_Temperature__c=null;
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Enter_Different_Temperature_Value__c=null;
    //             conProd.Enter_Different_Temperature_Units__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //             conProd.Converted_Density__c=null;
    //             conProd.Converted_Relieving_Temperature__c=null;
    //             conProd.Converted_Different_Temperature_Setting__c  =null;

    //         }
    //         when 'Fauske 2 Phase Gas-Liquid'{
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //             conProd.Converted_Density__c=null;
    //             conProd.Converted_Viscosity__c=null;
    //             conProd.Converted_Specific_Volume__c=null;
    //         }
    //         when 'Fauske 2 Phase Vapor-Liquid'{
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //             conProd.Converted_Density__c=null;
    //             conProd.Converted_Viscosity__c=null;
    //             conProd.Converted_Specific_Volume__c=null;
    //         }
    //         when 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid'{
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Converted_Density__c=null;
    //             conProd.Converted_Viscosity__c=null;
    //             conProd.Converted_Specific_Volume__c=null;
    //         }
    //         when 'Fauske All Liquid Flashing'{
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //             conProd.Converted_Density__c=null;
    //             conProd.Converted_Viscosity__c=null;
    //             conProd.Converted_Specific_Volume__c=null;
    //         }
    //     }
    // }
    // public void clearSectCCertifications(){
    //     conProd.ASME_Section_VIII_Division_1__c=false;
    //     conProd.PED_2014_68_EU_CE_mark__c=null;
    //     conProd.China_Manufacturing_License__c=null;
    //     conProd.CSA_Marking_CRN_Number__c=false;
    //     conProd.Atex_Certificate__c=false;
    //     conProd.Gas_Group__c=null;
    //     conProd.Zone_0_2__c=null;
    //     conProd.KOSHA_Compliance__c=false;
    //     conProd.ASME_BPE__c=false;
    //     conProd.CU_TR__c=false;
    //     conProd.X3A_Sanitary_Standards__c=false;
    //     conProd.Comply_with_AD2000_Merkblat_A1__c=false;
    //     conProd.Comply_with_Regels_Voor_Tosellan_Oder_Dr__c=false;
    //     conProd.NACE__c=null;
    // }
    // public void clearSectDProductNarrowing(){
    //     conProd.Disc_Material_of_Construction__c=null;
    //     conProd.Non_Fragmenting_Design_Required__c=false;
    //     conProd.Operating_Pressure_Ratio__c=null;
    //     conProd.Application_type__c=null;
    // }
    // public void clearSectEProductSelection(){
    //     conProd.Product_Selection__c=false;
    //     conProd.Product__c=null;
    //     conProd.Seat__c=null;
    //     conProd.Size__c=null;
    //     conProd.Size_Units__c=null;
    //     conProd.Engineering_Notes__c=null;
    // }
    public void clearOutputObject() {
        rdOutput.OA_Override__c=null;
        rdOutput.OA__c=null;
        rdOutput.OB_Override__c=null;
        rdOutput.OB__c=null;
        rdOutput.OW_Override__c=null;
        rdOutput.OW__c=null;
        rdOutput.ORP_Override__c=null;
        rdOutput.ORP__c=null;
        rdOutput.ORV_Override__c=null;
        rdOutput.ORV__c=null;
        rdOutput.ORP010__c=null;
        rdOutput.ORP020__c=null;
        rdOutput.ORP015__c=null;
        rdOutput.ORP025__c=null;
        rdOutput.ORP027__c=null;
        rdOutput.ORV010__c=null;
        rdOutput.ORV020__c=null;
        rdOutput.ORV015__c=null;
        rdOutput.ORV025__c=null;
        rdOutput.ORV027__c=null;
        rdOutput.SRV__c=null;
        rdOutput.SRP__c=null;
        rdOutput.LABDSC__c=null;
    }
    public void clearSectFManufacturingRange(){
        conProd.Quantity__c=null;
        conProd.Pressure_Rating_Type__c=null;
        conProd.Pressure_Range_Type__c=null;
        conProd.Special_Range_Min_Input__c=null;
        conProd.Special_Range_Max_Input__c=null;
        conProd.Press_Burst_Pressure_Max_Input__c=null;
        conProd.Press_Burst_Pressure_Min_Input__c=null;
        conProd.Reference_Mfg_Range_Type__c=null;
        conProd.Performance_Tolerance_Input_Units__c=null;
        conProd.Performance_Tolerance_Min_Input__c=null;
        conProd.Performance_Tolerance_Max_Input__c=null;
        conProd.Vac_Rating_Type__c=null;
        conProd.Vac_Range_Type__c=null;
        conProd.Vac_Special_Range_Min_Input__c=null;
        conProd.Vac_Special_Range_Max_Input__c=null;
        conProd.Vac_Burst_Press_Max_Input__c=null;
        conProd.Vac_Burst_Press_Min_Input__c=null;
        conProd.Vac_Reference_Mfg_Range_Type__c=null;
        conProd.Vac_Performance_Tolerance_Units__c=null;
        conProd.Vac_Performance_Tolerance_Min_Input__c=null;
        conProd.Vac_Performance_Tolerance_Max_Input__c=null;
    }
    public void clearManufacturingRange(){
        // conProd.Quantity__c=null;
        // conProd.Pressure_Rating_Type__c=null;
        // conProd.Pressure_Range_Type__c=null;
        conProd.Special_Range_Min_Input__c=null;
        conProd.Special_Range_Max_Input__c=null;
        conProd.Press_Burst_Pressure_Max_Input__c=null;
        conProd.Press_Burst_Pressure_Min_Input__c=null;
        conProd.Reference_Mfg_Range_Type__c=null;
        conProd.Performance_Tolerance_Input_Units__c=null;
        conProd.Performance_Tolerance_Min_Input__c=null;
        conProd.Performance_Tolerance_Max_Input__c=null;
        // conProd.Vac_Rating_Type__c=null;
        // conProd.Vac_Range_Type__c=null;
        conProd.Vac_Special_Range_Min_Input__c=null;
        conProd.Vac_Special_Range_Max_Input__c=null;
        conProd.Vac_Burst_Press_Max_Input__c=null;
        conProd.Vac_Burst_Press_Min_Input__c=null;
        conProd.Vac_Reference_Mfg_Range_Type__c=null;
        conProd.Vac_Performance_Tolerance_Units__c=null;
        conProd.Vac_Performance_Tolerance_Min_Input__c=null;
        conProd.Vac_Performance_Tolerance_Max_Input__c=null;
    }
    public void clearSectGComponents(){
        conProd.Components_Flag__c=false;
        conProd.Final_Assembly_Location_Requirements__c=null;
        conProd.Material_Sourcing_Requirements__c=null;
        conProd.United_States_HTS_Code__c=null;
        conProd.Required_Components__c=null;
        conProd.Optional_Components__c=null;
        conProd.Material_Arcuate_Ring__c=null;
        conProd.Material_Armor_Ring2__c=null;
        conProd.Material_Armor_Ring__c=null;
        conProd.Material_Dent_Protector__c=null;
        conProd.Material_Disc__c=null;
        conProd.Material_Girdle_Cover__c=null;
        conProd.Material_Girdle__c=null;
        conProd.Material_Handling_Support__c=null;
        conProd.Material_Hi_Temp_Assembly__c=null;
        conProd.Material_Holddown_Ring__c=null;
        conProd.Material_Inlet_Coating2__c=null;
        conProd.Material_Inlet_Coating__c=null;
        conProd.Material_Inlet_Gasket__c=null;
        conProd.Material_Inlet_Liner__c=null;
        conProd.Material_Inlet_O_Ring__c=null;
        conProd.Material_Inlet_Ring2__c=null;
        conProd.Material_Inlet_Ring3__c=null;
        conProd.Material_Inlet_Ring__c=null;
        conProd.Material_Inlet__c=null;
        conProd.Material_Outlet_Coating__c=null;
        conProd.Material_Outlet_Gasket__c=null;
        conProd.Material_Outlet_Liner__c=null;
        conProd.Material_Outlet_Ring__c=null;
        conProd.Material_Outlet__c=null;
        conProd.Material_Seal2__c=null;
        conProd.Material_Seal3__c=null;
        conProd.Material_Seal__c=null;
        conProd.Material_Top_Section2__c=null;
        conProd.Material_Top_Section__c=null;
        //conProd.Material_of_Vacuum_Support_3__c=null;
        conProd.Material_Vacuum_Support2__c=null;
        conProd.Material_Vacuum_Support__c=null;
        conProd.Add_Integral_BDI_Integral_BDI_FLX_Sensor__c=null;
        conProd.Strip_Type__c=null;
        conProd.Gasket_Material__c=null;
        conProd.Wiring_Configuration__c=null;
        conProd.Wire_Type__c=null;
        conProd.Cable_Length__c=null;
        conProd.End_Connection__c=null;
        conProd.To_Make_With_BDI_FLX_Interface_cable__c=null;
    }
    public void clearSectHCleanings(){
        conProd.Temperature_Test_per_ASME__c=false;
        conProd.Finish_Configuration_Flag__c=false;
        conProd.Shell_Test__c=false;
        conProd.PMI__c=null;
        conProd.Surface_Finish__c=null;
        conProd.Electro_polish__c=false;
        conProd.Packaging_Material__c=false;
        conProd.Individual_Packaging__c=false;
        conProd.Cleanings__c=null;
        conProd.Mark_Pack_Clean__c=null;
        conProd.Customer_Specific_Requirements__c=null;
    }
}