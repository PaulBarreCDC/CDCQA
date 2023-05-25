public class RDThicknessFormulae {
    public RDThicknessFormulae (Rupture_Disc__c rdRecord,decimal decRGSMIN,decimal decRGSMAX) {
        //currentRD= (Rupture_Disc__c) wizardBaseDataProcessor.getObjectDataById(recordID).objResultList[0];
        currentRD=rdRecord;
        ProdTempTest=[select TempTestReqd__c from Disc_Type_List__c where PTC__c=:PTC][0].TempTestReqd__c;
        //RdRR=new RDRatingRange(currentRD);
        //RDRatingRange RDRatRan = new RDRatingRange();
        RGSMIN = decRGSMIN;
        RGSMAX = decRGSMAX;
        // VGSMIN = decVGSMIN;
        // VGSMAX = decVGSMAX;
        // tefMIN=decTefMIN;
        // tefMAX=decTefMAX;
        CE_RTTMDF=false;
        result basePTCList=getPTCCrossRef();
        RefPTCArr=new List<string>();
        RefPTC=new List<string>();
        RefSTC=new List<string>();
        thickArr=new List<decimal>();
        thickArrA=new List<decimal>();
        thickArrB=new List<decimal>();
        thickArrC=new List<decimal>();
        thickArrD=new List<decimal>();
        thickMfgTSArr=new List<Decimal>();
        thickMfgMSArr=new List<Decimal>();
        thickTSArr=new List<Decimal>();
        thickMSArr=new List<Decimal>();
        if (basePTCList.bResult) {
            RefPTCArr.add('\''+PTC+'\'');
            RefPTCArr.add('\''+(string) basePTCList.objResultList[0].get('RefPTC1__c')+'\'');
            RefPTCArr.add('\''+(string) basePTCList.objResultList[0].get('RefPTC2__c')+'\'');
            RefPTCArr.add('\''+(string) basePTCList.objResultList[0].get('RefPTC3__c')+'\'');
            RefPTCArr.add('\''+(string) basePTCList.objResultList[0].get('RefPTC4__c')+'\'');
            RefPTCArr.add('\''+(string) basePTCList.objResultList[0].get('RefPTC5__c')+'\'');
            //RefPTCArr.add( (string) basePTCList.objResultList[0].get('RefPTC6__c'));
            RefPTC.add(PTC);
            RefPTC.add((string) basePTCList.objResultList[0].get('RefPTC1__c'));
            RefPTC.add((string) basePTCList.objResultList[0].get('RefPTC2__c'));
            RefPTC.add((string) basePTCList.objResultList[0].get('RefPTC3__c'));
            RefPTC.add((string) basePTCList.objResultList[0].get('RefPTC4__c'));
            RefPTC.add((string) basePTCList.objResultList[0].get('RefPTC5__c'));
            RefPTC.add((string) basePTCList.objResultList[0].get('RefPTC6__c'));
            
        }
        
        RefSTCArr=new List<string>();
        result baseSTCList=getSTCCrossRef();
        if (baseSTCList.bResult) {
            RefSTCArr.add('\''+STC+'\'');
            RefSTCArr.add('\''+(string) baseSTCList.objResultList[0].get('RefSTC1__c')+'\'');
            RefSTCArr.add('\''+(string) baseSTCList.objResultList[0].get('RefSTC2__c')+'\'');
            RefSTCArr.add('\''+(string) baseSTCList.objResultList[0].get('RefSTC3__c')+'\'');
            RefSTCArr.add('\''+(string) baseSTCList.objResultList[0].get('RefSTC4__c')+'\'');
            RefSTCArr.add('\''+(string) baseSTCList.objResultList[0].get('RefSTC5__c')+'\'');
            RefSTCArr.add('\''+(string) baseSTCList.objResultList[0].get('RefSTC6__c')+'\'');
            RefSTC.add(STC);
            RefSTC.add((string) baseSTCList.objResultList[0].get('RefSTC1__c'));
            RefSTC.add((string) baseSTCList.objResultList[0].get('RefSTC2__c'));
            RefSTC.add((string) baseSTCList.objResultList[0].get('RefSTC3__c'));
            RefSTC.add((string) baseSTCList.objResultList[0].get('RefSTC4__c'));
            RefSTC.add((string) baseSTCList.objResultList[0].get('RefSTC5__c'));
            RefSTC.add((string) baseSTCList.objResultList[0].get('RefSTC6__c'));
        }
        string lstPTC;
        string lstSTC;
        if(RefPTCArr.size()>0)
            lstPTC=String.join(RefPTCArr,',');
        else {
            lstPTC='\''+PTC+'\'';
            RefPTCArr.add(PTC);
            RefPTC.add(PTC);
        }
        if(RefSTCArr.size()==0) {
            RefSTCArr.add('\''+STC+'\'');
            lstPTC='\''+STC+'\'';
            RefSTC.add(STC);
        } else {
            lstSTC=String.join(RefSTCArr,',');
        }
        system.debug('RefPTC'+RefPTC);
        system.debug('RefSTC'+RefSTC);
        result baseMfgList=getRDtblMfgData(lstPTC,lstSTC);
        if (baseMfgList.bResult) {
            mfgBaseData= baseMfgList.objResultList;
        }
        else{
            mfgBaseData = new List<RD_tblMfgData__c>();
        }
    }
    //public decimal tefMIN{get;set;}
    //public decimal tefMAX{get;set;}
    public Decimal RGSMIN;
    public Decimal RGSMAX;
    public Decimal VGSMIN;
    public Decimal VGSMAX;
    //public decimal topSecThickness{get;set;}
    //public decimal TefSealThickness{get;set;}
    //public decimal metalThickness{get;set;}
    //public decimal discThickness{get;set;}
    //public RDRatingRange RdRR {get;set;}
    public Rupture_Disc__c currentRD{get; set;}
    public List<string> RefPTC {get;set;}
    public List<string> RefSTC {get;set;}
    public decimal[] thickArrA {set;get;}
    public decimal[] thickArrB {set;get;}
    public decimal[] thickArrC {set;get;}
    public decimal[] thickArrD {set;get;}
    public decimal[] thickArr {set;get;}
    public decimal[] thickMfgMSArr {set;get;}
    public decimal[] thickMfgTSArr {set;get;}
    public decimal[] thickTSArr {set;get;}
    public decimal[] thickMSArr {set;get;}
    public string PTC {
        get {
            return currentRD.Product__c;
        }
        set {
            this.PTC=value;
        }
    }
    public string STC {
        get {
            return currentRD.Seat__c;
        }
        set {
            this.STC=value;
        }
    }
    public string ProdTempTest {get;set;}
    public String MCDT1 {
        get {
            return currentRD.Material_Top_Section__c ;
        }
        set {
            currentRD.Material_Top_Section__c = value;
            this.MCDT1 = value;
        }
    }
    public String MCDD {
        get {
            return currentRD.Material_Disc__c;
        }
        set {
            currentRD.Material_Disc__c = value;
            this.MCDD = value;
        }
    }
    public String MCDT2 {
        get {
            return currentRD.Material_Top_Section2__c;
        }
        set {
            currentRD.Material_Top_Section2__c = value;
            this.MCDT2 = value;
        }
    }
    public integer intSZC {
        get {
            return integer.valueOf(currentRD.Size__c);
        }
        set {
            //currentRD.Size__c = value;
            this.intSZC=value;
        }
    }
    public String strSZC {
        get {
            return ConstantsUtil.getSizeDesc(currentRD.Size__c).SZC;
        }
        set {
            //conProd.Size__c = value;
            this.strSZC = value;

        }
    }
    public String MCSS1 {
        get {
            return currentRD.Material_Seal__c;
        }
        set {
            currentRD.Material_Seal__c = value;
            this.MCSS1 = value;
        }
    }
    public String MCSS2 {
        get {
            return currentRD.Material_Seal2__c;
        }
        set {
            currentRD.Material_Seal2__c = value;
            this.MCSS2 = value;
        }
    }
    public String MCSS3 {
        get {
            return currentRD.Material_Seal3__c;
        }
        set {
            currentRD.Material_Seal3__c = value;
            this.MCSS3 = value;
        }
    }
    public string MCSS {
        get {
            string strMCSS='';
            if(MCSS1!=null)
                return strMCSS=MCSS1;
            else if(MCSS2!=null)
                return strMCSS=MCSS2;
            else if(MCSS3!=null)
                return strMCSS=MCSS3;
            else
                return strMCSS;
        }
        set {
            this.MCSS = value;
        }
    }
    public string MCSM {
        get {
            // string strMCSM='';
            // if(MCSS!='070' && MCSS!='071' && MCSS!='072' && MCSS!='073')
            //     return strMCSM=MCSS;
            // else if(MCSS=='070' || MCSS=='071' || MCSS=='072' || MCSS=='073')
            //     return strMCSM=MCDT;
            // else
            //     return strMCSM;
            
            return currentRD.MCSM__c==null?'':currentRD.MCSM__c;
        }
        set {
            this.MCSM = value;
        }
    }
    public string MCDT {
        get {
            string strMCDT='';
            if(MCDT1!=null)
                return strMCDT=MCDT1;
            else if(MCDT2!=null)
                return strMCDT=MCDT2;
            else
                return strMCDT;
        }
        set {
            this.MCDT = value;
        }
    }
    public string DiscMatl {
        get {
            string strMCD='';
            if(MCDD!=null)
                return strMCD=MCDD;
            else if(MCDT!=null)
                return strMCD=MCDT;
            else
                return strMCD;
        }
        set {
            this.DiscMatl = value;
        }
    }
    public Decimal  RTTMDF {
        get {
            return currentRD.Converted_Temperature_Setting__c;
        }
        set {
            currentRD.Converted_Temperature_Setting__c = value;
            this.RTTMDF = value;
        }
    }

    //Added getters and setters for RGEMIN and RGEMAX - Rhen 3 22 22
    public Decimal RGEMIN {
        get {
            return currentRD.RGEMIN__c;
        }
        set {
            currentRD.RGEMIN__c = value;
            this.RGEMIN = value;
        }      
    }
    public Decimal RGEMAX {
        get {
            return currentRD.RGEMAX__c;
        }
        set {
            currentRD.RGEMAX__c = value;
            this.RGEMAX = value;
        }      
    }
    
    public string RefMCD1 {
        get {
            string strRefMCD1 = String.valueof(DiscMatl);
            if(DiscMatl == '005'){
                strRefMCD1 = '050';
            }
            if(DiscMatl == '050'){
                strRefMCD1 = '005';
            }
            return strRefMCD1;
            
        }
        set {
            this.RefMCD1 = value;
        }
    }
    
    public string RefMCSM1 {
        get {
            string strRefMCSM1 = String.valueof(MCSM);
            if(MCSM == '005'){
                strRefMCSM1 = '50';
            }
            if(MCSM == '050'){
                strRefMCSM1 = '05';
            }
            return strRefMCSM1;
            
        }
        set {
            this.RefMCSM1 = value;
        }
    }
    
    public String  CEMARK {
        get {
            return currentRD.PED_2014_68_EU_CE_mark__c;
        }
        set {
            this.CEMARK = value;
        }
    }
    /* Removed CODET becuase it is not a valid variable - Rhen 3 22 22
    public string CODET {
        get {
            return 'C8';
        }
        set {
            this.CODET=value;
        }
    }
    */

    //Added getter and setter for ASME and TMPTSTASME - Rhen 3 22 22
    public string ASME {
        get {
            if(currentRD.ASME_Section_VIII_Division_1__c == true){
                ASME = '8';
            }
            else {
                ASME = 'N';
            }
            return ASME;
        }
        set {
            this.ASME=value;
        }
    }

    public string TMPTSTASME {
        get {
            
            if(currentRD.Temperature_Test_per_ASME__c == true) {
                TMPTSTASME = '8';
            }
            else{
                TMPTSTASME = 'N';
            }
            return TMPTSTASME;
        }
        set {
            this.TMPTSTASME=value;
        }
    }
    
    public Decimal Disc_Thickness {
        get {
            return currentRD.Disc_Thickness__c;
        }
        set {
            this.Disc_Thickness = value;
        }
    }
    
    public Decimal MetalSealThickness {
        get {
            return currentRD.MetalSeal_Thickness__c;
        }
        set {
            this.MetalSealThickness = value;
        }
    }
    
    public Decimal TopSectionThickness {
        get {
            return currentRD.TopSection_Thickness__c;
        }
        set {
            this.TopSectionThickness = value;
        }
    }
    
    public boolean CE_RTTMDF {get;set;}
    public string[] RefPTCArr {get;set;}
    public string[] RefSTCArr {get;set;}
    public RD_tblMfgData__c[] mfgBaseData {get;set;}
    
    public result getRDtblMfgData(string listPTC,string listSTC) {
        result resTblMfgData=new result();
        //RD_tblMfgData__c[] mfgData =[select SerialNo__c,PTC__c,STC__c,MCD__c,M220__c,TEMP_VAL__c,TEMP_AVG__c,AMBIENT_AVG__C from RD_tblMfgData__c LIMIT 10];
        string query='select MCSM__c,PTC__c,STC__c,MCD__c,M220__c,M280__c,SerialNo__c,SEALTYPE__c,M390__c,TEMP_VAL__c,TEMP_AVG__c,AMBIENT_AVG__C from RD_tblMfgData__c where PTC__c IN ('+listPTC+') and SZC__C=\''+strSZC+'\' AND STC__c IN ('+listSTC+')';
        System.debug('query: ' + query);
        RD_tblMfgData__c[] mfgData =Database.query(query);
        if (!mfgData.isEmpty()) {
            resTblMfgData.objResultList=mfgData;
            resTblMfgData.bResult=true;
        } else {
            resTblMfgData.bResult=false;
        }
        return resTblMfgData;
    }
    
    public result getRDtblMfgDataForSTD() {
        result resTblMfgData=new result();
        //string listSTDPTC = ;
        string query='select MCSM__c,PTC__c,STC__c,MCD__c,M220__c,M280__c,SerialNo__c,SEALTYPE__c,M390__c,TEMP_VAL__c,TEMP_AVG__c,AMBIENT_AVG__C from RD_tblMfgData__c where PTC__c = '+'\''+'STD'+'\'';
        System.debug('query'+query);
        RD_tblMfgData__c[] mfgData =Database.query(query);
        
        if (!mfgData.isEmpty()) {
            resTblMfgData.objResultList=mfgData;
            resTblMfgData.bResult=true;
        } else {
            resTblMfgData.bResult=false;
        }
        return resTblMfgData;
    }
    
    public result getPTCCrossRef() {
        result resPTCCrossRef=new result();
        RD_PTCCrossRef__c[] ptcCrossRef=[select RefPTC1__c,RefPTC2__c,RefPTC3__c,RefPTC4__c,RefPTC5__c,RefPTC6__c from RD_PTCCrossRef__c where PTC__c=:PTC];
        if (!ptcCrossRef.isEmpty()) {
            resPTCCrossRef.objResultList=ptcCrossRef;
            resPTCCrossRef.bResult=true;
        } else {
            resPTCCrossRef.bResult=false;
        }
        return resPTCCrossRef;
    }
    public result getSTCCrossRef() {
        result resSTCCrossRef=new result();
        RD_STCCrossRef__c[] stcCrossRef=[select RefSTC1__c,RefSTC2__c,RefSTC3__c,RefSTC4__c,RefSTC5__c,RefSTC6__c from RD_STCCrossRef__c where AssySeat__c=:STC];
        if (!stcCrossRef.isEmpty()) {
            resSTCCrossRef.objResultList=stcCrossRef;
            resSTCCrossRef.bResult=true;
        } else {
            resSTCCrossRef.bResult=false;
        }
        return resSTCCrossRef;
    }
    /*
public result getMSThicknessArrayVals(RD_tblMfgData__c[] mfgBase,decimal strAmbtAvgVal1,decimal strAmbtAvgVal2,decimal strAmbtAvgVal3,string valFlag) {
result resTickArray=new result();
if(String.isBlank(MCSM)) {
MCSM='0';
}
if(RefMCSM1=='') {
RefMCSM1='0';
}
if(MCDT=='') {
MCDT='0';
}
System.debug('MCSM'+MCSM);
for (RD_tblMfgData__c tblVal:mfgBase) {
if(RefSTC.contains(tblVal.STC__c) && ((tblVal.MCSM__c==integer.valueOf(MCSM)) || (tblVal.MCSM__c==integer.valueOf(RefMCSM1))) && (tblVal.AMBIENT_AVG__C>=strAmbtAvgVal1 && tblVal.AMBIENT_AVG__C<=strAmbtAvgVal2 && tblVal.AMBIENT_AVG__C>=strAmbtAvgVal3)) {
if(valFlag=='M280') {
if(tblVal.M280__c!=null)
thickMfgMSArr.add(tblVal.M280__c);
else
thickMfgMSArr.add(0.9999);
}
}
else if(RefSTC.contains(tblVal.STC__c) && RefSTC.contains(tblVal.STC__c) && ((tblVal.MCSM__c==integer.valueOf(MCDT)) || (tblVal.MCSM__c==integer.valueOf(RefMCD1))) && (tblVal.AMBIENT_AVG__C>=strAmbtAvgVal1 && tblVal.AMBIENT_AVG__C<=strAmbtAvgVal2 && tblVal.AMBIENT_AVG__C>=strAmbtAvgVal3)) {
if(valFlag=='Teflon') {
if(tblVal.MCSM__c!=null)
thickMfgTSArr.add(tblVal.MCSM__c);
else
thickMfgTSArr.add(0.9999);
}
}
}
return resTickArray;
}*/
    public result getThicknessArrayVals(RD_tblMfgData__c[] mfgBase,decimal strAmbtAvgVal1,decimal strAmbtAvgVal2,string valFlag) {
        result resTickArray=new result();
        if(DiscMatl=='') {
            DiscMatl='0';
        }
        if(RefMCSM1=='') {
            RefMCSM1='0';
        }
        if(MCSM=='') {
            MCSM='0';
        }
        if(MCDT=='') {
            MCDT='0';
        }
        String strDisMatl=DiscMatl;
        String strRefMCD1=RefMCD1;
        if (strDisMatl.length()==2) {
            System.debug('DiscMatl---: ' + strDisMatl);
            strDisMatl='0'+strDisMatl;
            System.debug('DiscMatl-****: ' + strDisMatl);
        }
        if (RefMCD1.length()==2) {
            strRefMCD1='0'+strRefMCD1;
        }

        // System.debug('strDisMatl : ' + strDisMatl);
        // System.debug('strRefMCD1 : ' + strRefMCD1);
        // System.debug('strAmbtAvgVal1: ' + strAmbtAvgVal1);
        //     System.debug('strAmbtAvgVal2 : ' + strAmbtAvgVal2);
        for (RD_tblMfgData__c tblVal:mfgBase) {
            if(RefPTC.contains(tblVal.PTC__c) && RefSTC.contains(tblVal.STC__c) && (tblVal.MCD__c==strDisMatl || tblVal.MCD__c==strRefMCD1) && (tblVal.AMBIENT_AVG__C>=strAmbtAvgVal1 && tblVal.AMBIENT_AVG__C<=strAmbtAvgVal2 )) {
                //system.debug('Inside Thickeness');
                if(valFlag=='A') {
                    if(tblVal.M220__c!=null)
                        thickArrA.add(tblVal.M220__c);
                    else
                        thickArrA.add(0.9999);
                }
                else if(valFlag=='B') {
                    if(tblVal.M220__c!=null)
                        thickArrB.add(tblVal.M220__c);
                    else
                        thickArrB.add(0.9999);
                }
                else {
                    if(tblVal.M220__c!=null)
                        thickArrC.add(tblVal.M220__c);
                    else
                        thickArrC.add(0.9999);
                }
                // System.debug('thickArrA: ' + thickArrA);
                // System.debug('thickArrB: ' + thickArrB);
                // System.debug('thickArrC: ' + thickArrC);
            }
        }
        return resTickArray;
    }
    
    public result getTSThickness4ArrayVals(RD_tblMfgData__c[] mfgBase,decimal strAmbtAvgVal1,decimal strAmbtAvgVal2,string sealType) {
        Result resultTSThickArray=new Result();
        if(DiscMatl=='') {
            DiscMatl='0';
        }
        if(RefMCSM1=='') {
            RefMCSM1='0';
        }
        if(MCSM=='') {
            MCSM='0';
        }
        if(MCDT=='') {
            MCDT='0';
        }
        for (RD_tblMfgData__c tblVal:mfgBase) {
            if(RefPTC.contains(tblVal.PTC__c) && RefSTC.contains(tblVal.STC__c) &&
               //(tblVal.MCD__c==integer.valueOf(DiscMatl) || tblVal.MCD__c==integer.valueOf(RefMCD1)) &&
               (tblVal.AMBIENT_AVG__C>=strAmbtAvgVal1 && tblVal.AMBIENT_AVG__C<=strAmbtAvgVal2 ) &&
               tblVal.SEALTYPE__c == sealType){
                   if(tblVal.M220__c!=null){
                       thickTSArr.add(tblVal.M220__c);
                   }
                   // else{
                   //     thickTSArr.add(0.9999);
                   // }
               }
        }
        //System.debug('@@thickTSArr '+thickTSArr);
        return resultTSThickArray;
    }
    
    public result getTSThicknessMfgArrayVals(RD_tblMfgData__c[] mfgBase,decimal strAmbtAvgVal1,decimal strAmbtAvgVal2,decimal decThickness,string sealType) {
        Result resultTSThickArray=new Result();
        if(DiscMatl=='') {
            DiscMatl='0';
        }
        if(MCSM=='') {
            MCSM='0';
        }
        if(MCDT=='') {
            MCDT='0';
        }
        
        for (RD_tblMfgData__c tblVal:mfgBase) {
            if(RefPTC.contains(tblVal.PTC__c) && RefSTC.contains(tblVal.STC__c) &&
               (tblVal.MCD__c==DiscMatl || tblVal.MCD__c==RefMCD1) &&
               (tblVal.AMBIENT_AVG__C>=strAmbtAvgVal1 && tblVal.AMBIENT_AVG__C<=strAmbtAvgVal2 ) && tblVal.SEALTYPE__c == sealType) {
                   //thickMfgTSArr.add(0.9999);
                   if(tblVal.M220__c!=null)
                       thickMfgTSArr.add(tblVal.M220__c);
               }
        }
        System.debug('@@thickMfgTSArr size '+thickMfgTSArr.size());
        System.debug('@@thickMfgTSArr '+thickMfgTSArr);
        return resultTSThickArray;
    }
    
    public result RDTopSectionThickness(){
        Result resTopThickness = new Result();
        Result topSec = new Result();
        decimal thicknessTS = 0.9999;//thickness will default to 0.9999 for later logic in case no thickness is found below
        
        if(MCSM != NULL && String.isNotBlank(MCSM)){
            topSec = getTSThickness4ArrayVals(mfgBaseData,RGSMIN,RGSMAX,MCSM);
        }
        
        //If single records are returned then use the most frequent value for thickness
        if(thickTSArr.size() == 1){
            thicknessTS = thickTSArr[0];
        }
        
        //If multiple records are returned then use the most frequent value for thickness
        else if(thickTSArr.size() > 1){
            thicknessTS = 0.0;
            integer masterCount = 0;
            // for(decimal thickVal : thickTSArr){
            //     integer count = 0;
            //     for(integer i=0;i<thickTSArr.size();i++){
            //         if(thickVal == thickTSArr[i]){
            //             count = count + 1;
            //         }
            //     }
            //     if(count > masterCount){
            //         masterCount = count;
            //         thicknessTS = thickVal;
            //     }
            // }
            Set<decimal> strSet = new Set<decimal>();
            Map<decimal,Integer> elCount = new Map<decimal,Integer>();
            for(decimal str: thickTSArr ){
                strSet.add(str);
            }
            for(decimal str: strSet){
                Integer countofChar = 0;
                for(decimal thickVal : thickTSArr){
                    if(str == thickVal){
                        countofChar++;
                    }
                }
                elCount.put(str,countofChar);
                if(countofChar>masterCount) {
                    masterCount = countofChar;
                    thicknessTS = str;
                }
            }
        }
        
        //Lookup most recent mfg no using the obtained thicknessTS
        if(thicknessTS != 0.9999){
            if(MCSM != NULL && String.isNotBlank(MCSM)){
                topSec=getTSThicknessMfgArrayVals(mfgBaseData,RGSMIN,RGSMAX,thicknessTS,MCSM);
            }
        }
        
        if(thicknessTS == 0.9999){
            /* This was a mathematical mistake from the documentation - Rhen 3 22 22
            if(MCSM != NULL && String.isNotBlank(MCSM)){
                if(mfgBaseData.size() > 0){
                    topSec = getTSThickness4ArrayVals(mfgBaseData,(RGSMIN-RGSMIN*0.36),(RGSMAX-RGSMAX*0.36),'Teflon');
                } else {
                    topSec = getTSThickness4ArrayVals(mfgBaseData,((RGSMIN-RGSMIN*0.36)*0.9),((RGSMAX-RGSMAX*0.36)*1.1),'Teflon');
                }
            }
            */

            if(MCSM != NULL && String.isNotBlank(MCSM)){
                if(mfgBaseData.size() > 0){
                    topSec = getTSThickness4ArrayVals(mfgBaseData,(RGSMIN-RGSMIN*0.42),(RGSMAX-RGSMAX*0.42),'Teflon');
                } else {
                    topSec = getTSThickness4ArrayVals(mfgBaseData,((RGSMIN-RGSMIN*0.42)*0.9),((RGSMAX-RGSMAX*0.42)*1.1),'Teflon');
                }
            }

            else if(MCSM == NULL || String.isBlank(MCSM)){
                if(mfgBaseData.size() > 0){
                    topSec =getTSThickness4ArrayVals(mfgBaseData,RGSMIN,RGSMAX,'Teflon');
                } else {
                    topSec =getTSThickness4ArrayVals(mfgBaseData,RGSMIN*0.9,RGSMAX*1.1,'Teflon');
                }
            }
            //else {result topSec =getThicknessArrayVals(mfgBaseData,RGSMIN,RGSMAX,'Teflon');}
        }
        
        //If only one record is returned then use that for thicknessTS
        if(thickTSArr.size() == 1){
            thicknessTS = thickTSArr[0];
            System.debug('thickTSArr.size() == 1'+thicknessTS);
        }
        //If multiple records are returned then use the most frequent value for thicknessTS
        else if(thickTSArr.size() > 1){
            thicknessTS = 0.0;
            integer masterCount = 0;
            // for(decimal thickVal : thickTSArr){
            //     integer count = 0;
            //     for(integer i=0;i<thickTSArr.size();i++){
            //         if(thickVal == thickTSArr[i]){
            //             count = count + 1;
            //         }
            //     }
            //     if(count > masterCount){
            //         masterCount = count;
            //         thicknessTS = thickVal;
            //     }
            // }
            Set<decimal> strSet = new Set<decimal>();
            Map<decimal,Integer> elCount = new Map<decimal,Integer>();
            for(decimal str: thickTSArr ){
                strSet.add(str);
            }
            for(decimal str: strSet){
                Integer countofChar = 0;
                for(decimal thickVal : thickTSArr){
                    if(str == thickVal){
                        countofChar++;
                    }
                }
                elCount.put(str,countofChar);
                if(countofChar>masterCount) {
                    masterCount = countofChar;
                    thicknessTS = str;
                }
            }
            System.debug('thickTSArr.size() > 1'+thicknessTS);
        }
        
        //Lookup most recent mfg no using the obtained thicknessTS
        if(thicknessTS != 0.9999){
            if(MCSM != NULL && String.isNotBlank(MCSM)){
                System.debug('MCSM != NULL && String.isNotBlank(MCSM');
                topSec=getTSThicknessMfgArrayVals(mfgBaseData,(RGSMIN-RGSMIN*0.36)*0.9,(RGSMAX-RGSMAX*0.36)*1.1,thicknessTS,'Teflon');
            }
            else if(MCSM == NULL || String.isBlank(MCSM)){
                System.debug('MCSM == NULL || String.isBlank(MCSM)');
                topSec=getTSThicknessMfgArrayVals(mfgBaseData,RGSMIN*0.9,RGSMAX*1.1,thicknessTS,'Teflon');
            }
        }
        
        //If only one record is returned then use that for mfgNo
        if(thickMfgTSArr.size() == 1){
            thicknessTS = thickMfgTSArr[0];
            System.debug('thickMfgTSArr.size() == 1'+thicknessTS);
        }
        
        //If multiple records are returned then use the most recent record for mfgNo
        else if(thickMfgTSArr.size() > 1){
            integer masterCount = 0;
            // for(decimal thickVal : thickMfgTSArr){
            //     integer count = 0;
            //     for(integer i=0;i<thickMfgTSArr.size();i++){
            //         if(thickVal == thickMfgTSArr[i]){
            //             count = count + 1;
            //         }
            //     }
            //     if(count > masterCount){
            //         masterCount = count;
            //         thicknessTS = thickVal;
            //     }
            // }
            Set<decimal> strSet = new Set<decimal>();
            Map<decimal,Integer> elCount = new Map<decimal,Integer>();
            for(decimal str: thickMfgTSArr ){
                strSet.add(str);
            }
            for(decimal str: strSet){
                Integer countofChar = 0;
                for(decimal thickVal : thickMfgTSArr){
                    if(str == thickVal){
                        countofChar++;
                    }
                }
                elCount.put(str,countofChar);
                if(countofChar>masterCount) {
                    masterCount = countofChar;
                    thicknessTS = str;
                }
            }
            System.debug('thickMfgTSArr.size() > 1'+thicknessTS);
        }
        resTopThickness.bResult=true;
        resTopThickness.dblRetValue=thicknessTS;
        TopSectionThickness = thicknessTS;
        System.debug('@@@ 615 - Final Thickness '+thicknessTS);
        return resTopThickness;
    }
    
    public result getThicknessInitialPass(RD_tblMfgData__c[] mfgBase,decimal decTempLL,decimal decTempUL,decimal decTempAvgLL,decimal decTempAvgUL,String valFlag) {
        result resTickArray=new result();
        List<string> localPTC=RefPTC;
        system.debug('RefPTC'+RefPTC);
        // system.debug('tblVal.MCD__c'+tblVal.MCD__c);
        system.debug('DiscMatl'+DiscMatl);
        system.debug('RefMCD1'+RefMCD1);
        system.debug('RefSTC'+RefSTC);
        system.debug('RefMCD1'+RefMCD1);
        system.debug('RefSTC'+RefSTC);
        system.debug('decTempAvgLL'+decTempAvgLL);
        system.debug('decTempAvgUL'+decTempAvgUL);
        // && (tblVal.TEMP_AVG__c>=decTempAvgLL && tblVal.TEMP_AVG__c<=decTempAvgUL)
        for (RD_tblMfgData__c tblVal:mfgBase) {
            

            // Added condition "&& (tblVal.TEMP_AVG__c>=decTempAvgLL && tblVal.TEMP_AVG__c<=decTempAvgUL)". The code was missing this filter and returning the wrong size array -Rhen 3 22 22
            if(localPTC.contains(tblVal.PTC__c) && RefSTC.contains(tblVal.STC__c) && (tblVal.MCD__c==DiscMatl || tblVal.MCD__c==RefMCD1) && (tblVal.TEMP_VAL__c>=decTempLL && tblVal.TEMP_VAL__c<=decTempUL) && (tblVal.TEMP_AVG__c>=decTempAvgLL && tblVal.TEMP_AVG__c<=decTempAvgUL)) {
                //System.debug('Inside'+tblVal.TEMP_AVG__c);
                if(valFlag=='A')
                    thickArrA.add(tblVal.M220__c);
                else if(valFlag=='B')
                    thickArrB.add(tblVal.M220__c);
                else
                    thickArrC.add(tblVal.M220__c);
            }
        }
        return resTickArray;
    }
    
    public result RDThicknessCal() {
        System.debug('Debug 2' + CE_RTTMDF);
        result resTickness=new result();
        thickArrA=new List<decimal>();
        thickArrB=new List<decimal>();
        thickArrC=new List<decimal>();
        thickArrD=new List<decimal>();
        decimal thickness = 0.9999;
        decimal selectedTemp = 0.0;
        try {
            
            
            //Updated CODET to ASME and TMPTSTASME to use current variables
            //if((CEMARK=='CET' && (RTTMDF < 59 || RTTMDF > 86)) || ((CODET=='C8' || CODET=='T8') && (RTTMDF < 50 || RTTMDF >100)) || (ProdTempTest=='Yes' && (RTTMDF < 50 || RTTMDF >100)))
            if((CEMARK=='CET' && (RTTMDF < 59 || RTTMDF > 86)) || (ASME =='8' && (RTTMDF < 50 || RTTMDF >100)) || (TMPTSTASME =='8' && (RTTMDF < 50 || RTTMDF >100)) || (ProdTempTest=='Yes' && (RTTMDF < 50 || RTTMDF >100))) {
                CE_RTTMDF=true;
                
            }
            String valFlag = '';
            
            //Removed because it always made flag CE_RTTMDF = true - Rhen 3 22 22
            //CE_RTTMDF=true;
            if(CE_RTTMDF) {
                // System.debug('mfgBaseData: ' + mfgBaseData.size());
                // System.debug('initialpass: ' + (RTTMDF-5));
                // System.debug('initialpass: ' + (RTTMDF+5));
                // System.debug('initialpass: ' + (RGSMIN*0.99));
                // System.debug('initialpass: ' + (RGSMAX*1.01));
                
                //Changed RGSMIN to RGEMIN and RGSMAX to  - Rhen 3 22 22
                //result initialpass=getThicknessInitialPass(mfgBaseData,RTTMDF-5,RTTMDF+5,RGSMIN*0.99,RGSMAX*1.01,'A');
                result initialpass=getThicknessInitialPass(mfgBaseData,RTTMDF-5,RTTMDF+5,RGEMIN*0.99,RGEMAX*1.01,'A');
                

                //System.debug('initialpass: ' + initialpass);
                
            }
            
            if(CE_RTTMDF && thickArrA.size()<5) {
                //Changed RGSMIN to RGEMIN and RGSMAX to  - Rhen 3 22 22
                //result initialpass2=getThicknessInitialPass(mfgBaseData,RTTMDF-15,RTTMDF+15,RGSMIN*0.95,RGSMAX*1.05,'B');
                result initialpass2=getThicknessInitialPass(mfgBaseData,RTTMDF-15,RTTMDF+15,RGEMIN*0.95,RGEMAX*1.05,'B');
                
            }
            if(CE_RTTMDF && thickArrA.size()<5 && thickArrB.size()<5) {
                //Changed RGSMIN to RGEMIN and RGSMAX to  - Rhen 3 22 22
                //result initialpass2=getThicknessInitialPass(mfgBaseData,RTTMDF-25,RTTMDF+25,RGSMIN*0.9,RGSMAX*1.1,'C');
                result initialpass2=getThicknessInitialPass(mfgBaseData,RTTMDF-25,RTTMDF+25,RGEMIN*0.9,RGEMAX*1.1,'C');
            }
            if(CE_RTTMDF && thickArrA.size()<5 && thickArrB.size()<5 && thickArrC.size()<1) {
                CE_RTTMDF=false;
            }
            if(!CE_RTTMDF) {
                //System.debug('var A: ' + (RGSMIN*0.99));
                //System.debug('var: A ' + (RGSMIN*1.01));
                
                result secPhase=getThicknessArrayVals(mfgBaseData,RGSMIN*0.99,RGSMAX*1.01,'A');

            }
            if(!CE_RTTMDF && thickArrA.size()<5) {
                // System.debug('var B: ' + (RGSMIN*0.95));
                // System.debug('var: B ' + (RGSMIN*1.05));
                result secPhase2 =getThicknessArrayVals(mfgBaseData,RGSMIN*0.95,RGSMAX*1.05,'B');
            }
            if(!CE_RTTMDF && thickArrA.size()<5  && thickArrB.size()<5) {
                // System.debug('var C: ' + (RGSMIN*0.9));
                // System.debug('var: C: ' + (RGSMIN*1.1));
                result secPhase3 =getThicknessArrayVals(mfgBaseData,RGSMIN*0.9,RGSMAX*1.1,'C');
            }
            
            if(thickArrC.size()==1){
                thickness=thickArrC[0];
                //System.debug('thickArr'+thickness);
            }
            /* Removed due to bad array logic - Rhen 3 22 22
            else if (thickArrB.size()==1){
                thickness=thickArrB[0];
                //System.debug('thickArr'+thickness);
            }
            else if (thickArrA.size()==1){
                thickness=thickArrA[0];
                //System.debug('thickArr'+thickness);
            }
            */

            else if(thickArrC.size() > 1) {
                integer index = thickArrC.size();
                thickness = 0.0;
                integer masterCount = 0;
                Set<decimal> strSet = new Set<decimal>();
                Map<decimal,Integer> elCount = new Map<decimal,Integer>();
                //List<String> strList = new List<String>{A,B,C,D,A,B,A,A,A,A}
                for(decimal str: thickArrC ){
                    strSet.add(str);
                }
                for(decimal str: strSet){
                    Integer countofChar = 0;
                    for(decimal thickVal : thickArrC){
                        if(str == thickVal){
                            countofChar++;
                        }
                    }
                    elCount.put(str,countofChar);
                    if(countofChar>masterCount) {
                        masterCount = countofChar;
                        thickness = str;
                    }
                }
            }
            else if(thickArrB.size() > 1) {
                integer index = thickArrB.size();
                thickness = 0.0;
                integer masterCount = 0;
                Set<decimal> strSet = new Set<decimal>();
                Map<decimal,Integer> elCount = new Map<decimal,Integer>();
                //List<String> strList = new List<String>{A,B,C,D,A,B,A,A,A,A}
                for(decimal str: thickArrB ){
                    strSet.add(str);
                }
                for(decimal str: strSet){
                    Integer countofChar = 0;
                    for(decimal thickVal : thickArrB){
                        if(str == thickVal){
                            countofChar++;
                        }
                    }
                    elCount.put(str,countofChar);
                    if(countofChar>masterCount) {
                        masterCount = countofChar;
                        thickness = str;
                    }
                }
                //System.debug('thickArr'+thickness);
            }
            else if(thickArrA.size() > 1) {
                integer index = thickArrA.size();
                thickness = 0.0;
                integer masterCount = 0;
                Set<decimal> strSet = new Set<decimal>();
                Map<decimal,Integer> elCount = new Map<decimal,Integer>();
                //List<String> strList = new List<String>{A,B,C,D,A,B,A,A,A,A}
                for(decimal str: thickArrA ){
                    strSet.add(str);
                }
                for(decimal str: strSet){
                    Integer countofChar = 0;
                    for(decimal thickVal : thickArrA){
                        if(str == thickVal){
                            countofChar++;
                        }
                    }
                    elCount.put(str,countofChar);
                    if(countofChar>masterCount) {
                        masterCount = countofChar;
                        thickness = str;
                    }
                }
                //System.debug('thickArrA.size() > 1'+thickness);
                /*for(decimal thickVal : thickArrA) {
integer count = 0;
for(integer i=0;i<index;i++) {
if(thickVal == thickArrA[i]){
count = count + 1;
}
}
if(count > masterCount){
masterCount = count;
thickness = thickVal;
}
}*/
            }
        }
        catch(Exception dmle)
        {
            resTickness.bResult=true;
            resTickness.dblRetValue=0;
            return resTickness;
        }
        //('thickness'+thickness);
        resTickness.bResult=true;
        resTickness.dblRetValue=thickness;
        Disc_Thickness = thickness;
        return resTickness;
    }
    
    public result getMSThickness3ArrayVals(RD_tblMfgData__c[] mfgBase,decimal strAmbtAvgVal1,decimal strAmbtAvgVal2) {
        Result resultMSThickArray=new Result();
        if(DiscMatl=='') {
            DiscMatl='0';
        }
        if(RefMCSM1=='') {
            RefMCSM1='0';
        }
        if(MCSM=='') {
            MCSM='0';
        }
        if(MCDT=='') {
            MCDT='0';
        }
        
        for (RD_tblMfgData__c tblVal:mfgBase) {
            if(RefPTC.contains(tblVal.PTC__c) && RefSTC.contains(tblVal.STC__c) &&
               //((tblVal.MCSM__c==integer.valueOf(MCSM)) || (tblVal.MCSM__c==integer.valueOf(RefMCSM1))) &&
               (tblVal.AMBIENT_AVG__C>=strAmbtAvgVal1 && tblVal.AMBIENT_AVG__C<=strAmbtAvgVal2)) {
                   if(tblVal.M280__c!=null)
                       thickMSArr.add(tblVal.M280__c);
               }
        }
        //System.debug('thickMSArr ==> '+thickMSArr);
        return resultMSThickArray;
    }
    
    public result getMSThicknessMfgArrayVals(RD_tblMfgData__c[] mfgBase,decimal strAmbtAvgVal1,decimal strAmbtAvgVal2) {
        Result resultMSThickArray=new Result();
        if(DiscMatl=='') {
            DiscMatl='0';
        }
        if(RefMCSM1=='') {
            RefMCSM1='0';
        }
        if(MCSM=='') {
            MCSM='0';
        }
        if(MCDT=='') {
            MCDT='0';
        }
        
        for (RD_tblMfgData__c tblVal:mfgBase) {
            if(RefPTC.contains(tblVal.PTC__c) && RefSTC.contains(tblVal.STC__c) &&
               //((tblVal.MCSM__c==integer.valueOf(MCSM)) || (tblVal.MCSM__c==integer.valueOf(RefMCSM1))) &&
               //((tblVal.MCSM__c=='') || (tblVal.MCSM__c=='')) &&
               (tblVal.AMBIENT_AVG__C>=strAmbtAvgVal1 && tblVal.AMBIENT_AVG__C<=strAmbtAvgVal2)) {
                   if(tblVal.M220__c!=null)
                       thickMfgMSArr.add(tblVal.M220__c);
               }
        }
        //System.debug('thickMfgMSArr  '+thickMfgMSArr);
        return resultMSThickArray;
    }
    
    public result getMSThickness4ArrayVals(RD_tblMfgData__c[] mfgBase,decimal strAmbtAvgVal1,decimal strAmbtAvgVal2, Decimal thickness) {
        Result resultMSThickArray=new Result();
        if(DiscMatl=='') {
            DiscMatl='0';
        }
        if(RefMCSM1=='') {
            RefMCSM1='0';
        }
        if(MCSM=='') {
            MCSM='0';
        }
        if(MCDT=='') {
            MCDT='0';
        }
        thickMfgMSArr.clear();
        for (RD_tblMfgData__c tblVal:mfgBase) {
            
            if( tblVal.STC__c == 'LL' &&
               (tblVal.AMBIENT_AVG__C>=strAmbtAvgVal1 && tblVal.AMBIENT_AVG__C<=strAmbtAvgVal2)) {
                   
                   //System.debug(' tblVal  '+ tblVal);
                   thickMfgMSArr.add(tblVal.M220__c);
               }
        }
        //System.debug('getMSThickness4ArrayVals ==> '+thickMfgMSArr);
        return resultMSThickArray;
    }
    
    public result RDMetalSealThickness() {
        Result resMSThickness = new Result();
        decimal decMetalTickness= 0.9999;
        integer count = 0;
        string RefMCSM1;
        if(MCSM == '05'){
            RefMCSM1 = '50';
        }
        if(MCSM == '50'){
            RefMCSM1 = '05';
        }
        
        //If only no record is returned then use that for thickness
        if(thickMSArr.size() == 0){
            result decMST=getMSThickness3ArrayVals(mfgBaseData,RGSMIN,RGSMAX);
        }
        
        //If only one record is returned then use that for thickness
        if(thickMSArr.size() == 1){
            decMetalTickness = thickMSArr[0];
        }
        
        //If multiple records are returned then use that for thickness
        else if(thickMSArr.size() > 1){
            decMetalTickness = 0.0;
            integer masterCount = 0;
            for(Decimal thickVal: thickMSArr){
                count = 0;
                for(integer i=0; i<thickMSArr.size(); i++){
                    if(thickVal == thickMSArr[i]){
                        count = count + 1;
                    }
                }
                if(count > masterCount){
                    masterCount = count;
                    decMetalTickness = thickVal;
                }
            }
        }
        
        //Lookup most recent mfg no using the obtained thickness
        if(decMetalTickness != 0.9999){
            result decMST=getMSThicknessMfgArrayVals(mfgBaseData,RGSMIN,RGSMAX);
        }
        
        //If no record is found for a metal seal then lookup using Standard rupture disc records.
        if(decMetalTickness == 0.9999) {
            result decMST=getMSThickness3ArrayVals(mfgBaseData,((RGSMIN+RGSMAX)/2)*0.5,((RGSMIN+RGSMAX)/2)*0.7);
        }
        
        //If only one record is returned then use that for thickness
        if(thickMfgMSArr.size() == 1){
            decMetalTickness = thickMfgMSArr[0];
        }
        
        //If multiple records are returned then use the most frequent value for thickness
        else if(thickMfgMSArr.size() > 1){
            decMetalTickness = 0.0;
            integer masterCount = 0;
            for(decimal thickVal : thickMfgMSArr) {
                count = 0;
                for(integer i=0;i<thickMfgMSArr.size();i++){
                    if(thickVal == thickMfgMSArr[i]){
                        count = count + 1;
                    }
                }
                if(count > masterCount){
                    masterCount = count;
                    decMetalTickness = thickVal;
                }
            }
        }
        
        //Lookup most recent mfg no using the obtained thickness getRDtblMfgData efPTCArr.add('\''+(string) basePTCList.objResultList[0].get('RefPTC3__c')+'\'');
        if(decMetalTickness != 0.9999){
            RD_tblMfgData__c[] tempMfgBaseData = new List<RD_tblMfgData__c>();
            Result tempMfdData = getRDtblMfgDataForSTD();
            if (tempMfdData.bResult) {
                tempMfgBaseData= tempMfdData.objResultList;
            }
            
            result decMST=getMSThickness4ArrayVals(tempMfgBaseData,((RGSMIN+RGSMAX)/2)*0.5,((RGSMIN+RGSMAX)/2)*0.7,decMetalTickness);
        }
        
        //If only one record is returned then use that for mfgNo
        if(thickMfgMSArr.size() == 1){
            decMetalTickness = thickMfgMSArr[0];
        }
        //If multiple records are returned then use the most recent record for mfgNo
        else if(thickMfgMSArr.size() > 1){
            
            //var my_array = /* some array here */;
            Decimal last_element = thickMfgMSArr[thickMfgMSArr.size() - 1];
            decMetalTickness = last_element;
        }
        resMSThickness.bResult=true;
        resMSThickness.dblRetValue=decMetalTickness;
        
        //System.debug('@@@ 919 Final Thickness ==> '+decMetalTickness);
        MetalSealThickness = decMetalTickness;
        return resMSThickness;
    }
    
    //Logic to calculate TefSeal Thickness
    // public result RDTefSealThickness() {
    //     result tefSeal=new result();
    //     // "=If(('MCSS' = ""070"" or 'MCSS' = ""071"" or 'MCSS' = ""072"" or 'MCSS' =""073"") and PTC <> ""PAS"" and PTC <> ""CAL"") Then return value from column 'SealThck' from table 'tblDiscInformation' where column 'PTC' = 'PTC' and column 'SZC' = 'SZC' and column 'MfgRngLL' <= 'REGMIN' and column 'MfgRngUL' > 'RGEMIN' and column 'TempLL' <= 'RTTMDF' and column 'TempUL' > 'RTTMDF'
    //     List<String> myStrings = new List<String>{'70','71','72','73'};
    //     if(myStrings.contains(MCSS) && (PTC!='PAS' && PTC!='CAL')) {
    //         Disc_Information__c [] disList=[select SealThck__c from Disc_Information__c where PTC__c=:PTC and SZC__c=:ConstantsUtil.getSizeDesc(STRING.VALUEof(SZC)).SZC and MfgRngLL__c<=:tefMIN AND MfgRngUL__c>:tefMAX AND TempLL__c<=:RTTMDF AND TempUL__c>:RTTMDF];
    //         if(!disList.isEmpty() && disList.size()>0) {
    //             tefSeal.dblRetValue=disList[0].SealThck__c;
    //             tefSeal.bResult=true;
    //         } else {
    //             tefSeal.bResult=false;
    //         }
    //     } else if (PTC == 'CAL') {
    //         // If(PTC = ""CAL"")Then return value from column 'SealThick' from table 'tblPosCalRating' where column 'PTC' = 'PTC' and column 'SZC' = 'SZC' and column 'MinGrdlRatedLL'<='VG2MINReal' and column 'MinGrdlRatedUL>'VG2MINReal' and column 'TempLL'<'RTTMDF' and column 'TempUL' <=RTTMDF and column 'MinTSMfgRngLL'<='RGSMinReal' and column 'MinTSMfgRngUL'> 'RGSMinReal'
    // //RGSMIN = decRGSMIN;
    //         RD_tblPosCalRating__c [] posCALList=[select SealThck__c from RD_tblPosCalRating__c where PTC__c=:PTC and SZC__c=:ConstantsUtil.getSizeDesc(STRING.VALUEof(SZC)).SZC AND TempLL__c<=:RTTMDF AND TempUL__c>:RTTMDF AND MinGrdlRatedLL__c<=:tefMIN AND MinGrdlRatedUL__c>:tefMAX AND MinTSMfgRngLL__c<=:RGSMin and MinTSMfgRngUL__c>:RGSMAX ];
    //         if(!posCALList.isEmpty() && posCALList.size()>0) {
    //             tefSeal.dblRetValue=posCALList[0].SealThck__c;
    //             tefSeal.bResult=true;
    //         } else {
    //             tefSeal.bResult=false;
    //         }
    //     } else if (PTC == 'PAS') {
    //         RD_tblPosCalRating__c [] posCALList=[select SealThck__c from RD_tblPosCalRating__c where PTC__c=:PTC and SZC__c=:ConstantsUtil.getSizeDesc(STRING.VALUEof(SZC)).SZC AND TempLL__c<=:RTTMDF AND TempUL__c>:RTTMDF AND MinGrdlRatedLL__c<=:tefMIN AND MinGrdlRatedUL__c>:tefMAX AND MinTSMfgRngLL__c<=:VGSMIN and MinTSMfgRngUL__c>:VGSMAX ];
    //         if(!posCALList.isEmpty() && posCALList.size()>0) {
    //             tefSeal.dblRetValue=posCALList[0].SealThck__c;
    //             tefSeal.bResult=true;
    //         } else {
    //             tefSeal.bResult=false;
    //         }
    //     } else if(!myStrings.contains(MCSS)) {
    //         tefSeal.dblRetValue=0.005;
    //         tefSeal.bResult=true;
    //     } else {
    //         tefSeal.dblRetValue=0.000;
    //         tefSeal.bResult=true;
    //     }
    //     return tefSeal;
    // }
}