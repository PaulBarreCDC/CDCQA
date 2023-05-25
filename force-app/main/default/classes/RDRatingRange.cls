/**
* @File Name          : RDRatingRange.cls
* @Description        :
* @Author             : Nikhil Arpally
* @Group              :
* @Last Modified By   : Nikhil Arpally
* @Last Modified On   : 8/6/2020, 12:16:40 am
* @Modification Log   :
* Ver       Date            Author      		    Modification
* 1.0    4/6/2020          Nikhil Arpally     Initial Version
* 1.1    06-Feb-2021       Rohini Hathi      Service Ticket # 162422, replace format() on Decimal values to .stripTrailingZeros().toPlainString() , and change one parameter for ORP015 for rounding -99 to 0, and return value for RG1MINReal, VG1MINReal, RG1MAXReal, VG1MAXReal
* 1.2    06-May-2021       Rohini Hathi      Service Ticket #200743, for metal girdle within pressure limits, added rule criteria
**/
public class RDRatingRange {

    //public List<String> CONST_UNTS = new List<String>{'atmg', 'atm abs.', 'bar abs.', 'bard', 'barg', 'gf/cm2', 'in. Hg', 'in. water', 'kgf/cm2', 'kgf/cm2 abs.', 'kPa', 'kPa abs.', 'mbarg', 'mbar abs.', 'mm Hg', 'mm water', 'Mpa', 'Mpa abs.','Pa', 'psia', 'psig', 'psid', 'torr'};
    public List<String> CONST_UNTS = new List<String>{'Percent','Specified Burst Pressure Units'};
        public List<SelectOption> getConstUnits() {
            List<SelectOption> units = new List<SelectOption>();
            for(String unit : CONST_UNTS) {
                units.add(new SelectOption(unit, unit));
            }
            return units;
        }
    public List<String> CONST_PRTG = new List<String>{'Rated', 'Specified', 'Burst Pressure Min/Max.', 'No Rating', 'No Rating But Must Withstand', 'Start/Full Relief (Min/Max)'};
        public List<String> CONST_PRNG = new List<String>{'Zero, -10% (-5 psig)', '-10%(-0.6 psig)', '-10%', '-5%(-2.5 psig)', '-5%(-0.3 psig)', '-5%', 'Standard', 'Special - 75% of Std. Mfg. Range', 'Special 50% of Std. Mfg. Range', 'Special - 25% of Std. Mfg. Range'};

            public RDRatingRange(Rupture_Disc__c initRD, String initPTC, String initSZC) {
                currentRptDisc = initRD;
                currentProduct = initPTC;
                currentSizeCap = initSZC;
                addMetalSealCheck=false;
                if(String.isNotBlank(initSZC)) {
                    String strSZC=ConstantsUtil.getSizeDesc(initSZC).SZC;
                    transient RDMasterBlaster__c[] RDMasterList=[select PTC__c,SZC__c,STC__c, DSCVAR__c, DerateType__c,CE_Mark_LL__c,CE_Mark_UL__c,China_ML_LL__c,China_ML_UL__c, Derate_Teflon__c from RDMasterBlaster__c WHERE PTC__c=:initPTC];
                    string strDSCVARCheck='T';
                    if(currentProduct=='PAS' || currentProduct=='CAL')
                        strDSCVARCheck='S';
                    Transient RDMasterBlaster__c[] rdlist=[select PTC__c,SZC__c,STC__c, DSCVAR__c, DerateType__c,CE_Mark_LL__c,CE_Mark_UL__c,China_ML_LL__c,China_ML_UL__c, Derate_Teflon__c,Teflon_Ambient__c from RDMasterBlaster__c WHERE PTC__c=:initPTC AND DSCVAR__c=:strDSCVARCheck AND SZC__c=:strSZC];
                    if(!rdlist.isEmpty())
                        RDMasterBlasterT=rdlist[0];
                    //System.debug('RDMasterBlasterT'+RDMasterBlasterT.Teflon_Ambient__c);
                    if(!RDMasterList.isEmpty()) {
                        RDMasterBlaster=RDMasterList;
                    }
                }
                tbList=tbLis88t();
                mfgList=mfgListVals();
                shpList=lstShopRange();
                gList=grdList();
                getDerateList=getDerateBaseData();
                sealList=sealMaterial();
                //mapRatingValues1=getMapDetails();
                sealCompMaterials=getSealData();

                //RD_tblASMEValues=RD_tblASMEValues();
                // if (PPressureBaseUOM=='psig')
                //     PBurstPressureConverted=currentRptDisc.Converted_Pressure_Setting__c;
                // else
                //     PBurstPressureConverted=convertPressure(RTPRS1, RTPRSU, PPressureBaseUOM);

            }
    public RDRatingRange (Rupture_Disc__c initRD) {
        this(initRD, '', '');
        tbList=tbLis88t();
    }
    public RDRatingRange() {
        //this(new Rupture_Disc__c(), '', '');
        tbList=tbLis88t();
    }
    public list<RD_Seals_Component_Materials__c> sealCompMaterials {get;set;}
    public Map<String, string> mapRatingValues1 {
        get {
            return getMapDetails();

        } set {
            this.mapRatingValues1=value;
        }
    }
    public RDMasterBlaster__c RDMasterBlasterT{get;set;}
    public transient List<RDMasterBlaster__c> RDMasterBlaster{get;set;}
    public Rupture_Disc__c currentRptDisc  {get; set;}
    public String currentProduct {
        get {
            return currentRptDisc.Product__c;
        }
        set {
            this.currentProduct = value;
            if(String.isNotBlank(value)) {
                if(!String.IsEmpty(currentRptDisc.Product__c))
                    setPTC();
            }
        }
    }
    public String currentSizeCap {
        get {
            return currentRptDisc.Size__c;
        }
        set;
    }
    // Product Type Configuration  - 'PAS', 'CAL'
    public Disc_Type_List__c PTC {
        get {
            if(PTC == null) {
                setPTC();
            }
            return PTC;
        }
        set;
    }
    // Pressure Settings
    public Decimal RTPRS1 {
        get {
            return currentRptDisc.Pressure_Setting__c;
        }
        set {
            currentRptDisc.Pressure_Setting__c = value;
            this.RTPRS1 = value;
        }
    }
    public Decimal VTPRS1 {
        get {
            if(currentRptDisc.Vacuum_Setting__c != Null)
                return currentRptDisc.Vacuum_Setting__c;
            else
                return 0.0;
        }
        set {
            currentRptDisc.Vacuum_Setting__c = value;
            this.VTPRS1 = value;
        }
    }
    // Pressure Settings Units - atmg, atm abs., bar abs., bard, barg, gf/cm2, in. Hg, in. water, kgf/cm2, kgf/cm2 abs., kPa, kPa abs., mbarg, mbar abs., mm Hg, mm water, Mpa, Mpa abs., Pa, psia, psig, psid, torr
    public String RTPRSU {
        get {
            if(currentRptDisc.Pressure_Setting_Units__c!=null)
                return currentRptDisc.Pressure_Setting_Units__c;
            else
                return '';
        }
        set {
            currentRptDisc.Pressure_Setting_Units__c = value;
            this.RTPRSU = value;
        }
    }
    //public Map<String,String>
    public String VTPRSU {
        get {
            if(currentRptDisc.Vacuum_Setting_Units__c!=null)
                return currentRptDisc.Vacuum_Setting_Units__c;
            else
                return '';
        }
        set{
            currentRptDisc.Vacuum_Setting_Units__c = value;
            this.VTPRSU = value;
        }
    }
    public string tempMCGD {
        get {
            string tmpMCGD='';
            if(string.isNotBlank(currentRptDisc.Material_Girdle__c)) {
                if((string) PTC.get('PTC__c') == 'PAS' && (currentRptDisc.Material_Girdle__c == '005' || currentRptDisc.Material_Girdle__c == '050' || currentRptDisc.Material_Girdle__c == '007'))
                    return currentRptDisc.Material_Girdle__c;
                else if((string) PTC.get('PTC__c')  == 'PAS' && (currentRptDisc.Material_Girdle__c == '072' || currentRptDisc.Material_Girdle__c == '073'))
                    return '070';
                else
                    return currentRptDisc.Material_Girdle__c;
            } else {
                return '';
            }
        }
        set {
            this.tempMCGD=value;
        }
    }
    // Pressure Units Of Measure
    public String PPressureBaseUOM {
        get {
            String uom;
            if(currentProduct =='PAS') {
                UOM = 'in. water';
            } else {
                UOM = 'psig';
            }
            return uom;
        }
        set;
    }
    public String VPressureBaseUOM {
        get {
            String uom='';
            if(currentProduct =='CAL') {
                UOM = 'in. water';
            } else {
                UOM = 'psig';
            }
            return uom;
        }
        set;
    }
    // PBurstPressureConverted
    public Decimal PBurstPressureConverted {
        get {
            if(currentRptDisc.Relief_Type__c!='Vacuum Relief'){
                return convertPressure(RTPRS1, RTPRSU, PPressureBaseUOM);
            }
            return 0.0;
        }
        set;
    }
    public Decimal VBurstPressureConverted {
        get {
            if(currentRptDisc.Relief_Type__c!='Pressure Relief'){
                return convertPressure(VTPRS1, VTPRSU, VPressureBaseUOM);
            }
            return 0.0;
            //return currentRptDisc.Converted_Vacuum_Setting__c;
        }
        set;
    }
    // Pressure Rating Type - User-selected: Rated, Specified, Burst Pressure Min/Max., No Rating, No Rating But Must Withstand, Start/Full Relief (Min/Max)
    public String RGRAT1 {
        get {
            if(currentRptDisc.Pressure_Rating_Type__c!=null)
                return currentRptDisc.Pressure_Rating_Type__c;
            else
                return '';
        }
        set {
            currentRptDisc.Pressure_Rating_Type__c = value;
            this.RGRAT1 = value;
        }
    }
    public String VGRAT1 {
        get {
            if(currentRptDisc.Vac_Rating_Type__c!=null)
                return currentRptDisc.Vac_Rating_Type__c;
            else
                return '';
        }
        set {
            currentRptDisc.Vac_Rating_Type__c = value;
            this.VGRAT1 = value;
        }
    }
    // Pressure Range Type -  - Zero, -10% (-5 psig), -10%(-0.6 psig), -10%, -5%(-2.5 psig), -5%(-0.3 psig), -5%, Standard, Special - 75% of Std. Mfg. Range, Special 50% of Std. Mfg. Range, Special - 25% of Std. Mfg. Range; Constraint to SELECT RGTYP1 FROM tblPosRatingRngList WHERE RGRAT1 =: RGRAT1
    public String RGTYP1 {
        get {
            return currentRptDisc.Pressure_Range_Type__c;
        }
        set {
            currentRptDisc.Pressure_Range_Type__c = value;
            this.RGTYP1 = value;
        }
    }
    public String VGTYP1 {
        get {
            return currentRptDisc.Vac_Range_Type__c;
        }
        set {
            currentRptDisc.Vac_Range_Type__c = value;
            this.VGTYP1 = value;
        }
    }
    // Lists of options for Rating Range selection
    public List<SelectOption> pressureRatingOptions {get;set;}
    public List<SelectOption> pressureRangeOptions {get;set;}
    public List<SelectOption> vacuumRatingOptions {get;set;}
    public List<SelectOption> vacuumRangeOptions {get;set;}
    public List<SelectOption> pressRefMfgRangeType {get;set;}
    public List<SelectOption> vacRefMfgRangeType {get;set;}
    // Temperature Setting
    public Decimal RTTMSP {
        get {
            return currentRptDisc.Temperature_Setting__c;
        }
        set {
            currentRptDisc.Temperature_Setting__c = value;
            this.RTTMSP = value;
        }
    }
    // Temperature Setting Units - DEG C, DEG F, DEG K, DEG R
    public String RTTMUN {
        get {
            return currentRptDisc.Temperature_Setting_Units__c;
        }
        set {
            currentRptDisc.Temperature_Setting_Units__c = value;
            this.RTTMUN = value;
        }
    }
    // ServiceTempConv
    public Decimal RTTMDF {
        get {
            //if(RTTMSP != null && ) {
            return convertTemperature(RTTMSP,RTTMUN,'Deg F');
            //}
        }
        set;
    }
    // Pressure But Must Withstand
    public Decimal RGRATW {
        get {
            //return RTPRS1;
            if( RGRAT1 == 'No Rating But Must Withstand'){
                return currentRptDisc.Positive_Pressure_Value__c;
            }
            return null;
        }
        set;
    }
    public Decimal VGRATW {
        get {
            //return VTPRS1;
            if( VGRAT1 == 'No Rating But Must Withstand'){
                return currentRptDisc.Back_Pressure_Value__c;
            }
            return null;
        }
        set;
    }
    // Pressure But Must Withstand Units
    public String RGRATU {
        get {
            if(currentRptDisc.Positive_Pressure_Units__c != null)
            	return currentRptDisc.Positive_Pressure_Units__c;
            else
                return RTPRSU;
        }
        set;
    }
    public String VGRATU {
        get {
            if(currentRptDisc.Back_Pressure_Units__c != null)
            	return currentRptDisc.Back_Pressure_Units__c;
            else
            	return VTPRSU;
        }
        set;
    }
    // Press Full Relief Pressure (Max)
    public Decimal FullRelief {
        get {
            return RTPRS1;
        }
        set;
    }
    public Decimal VFullRelief {
        get {
            return VTPRS1;
        }
        set;
    }
    // Press Special Range Min Input
    public Decimal SpecRngMin {
        get {
            return currentRptDisc.Special_Range_Min_Input__c;
        }
        set {
            currentRptDisc.Special_Range_Min_Input__c = value;
            this.SpecRngMin = value;
        }
    }
    public Decimal VSpecRngMin {
        get {
            if(currentRptDisc.Vac_Special_Range_Min_Input__c!=null)
                return currentRptDisc.Vac_Special_Range_Min_Input__c;
            else
                return 0.0;
        }
        set {
            currentRptDisc.Vac_Special_Range_Min_Input__c = value;
            this.VSpecRngMin = value;
        }
    }
    // Press Special Range Max Input
    public Decimal SpecRngMax {
        get {
            if(currentRptDisc.Special_Range_Max_Input__c!=null)
                return currentRptDisc.Special_Range_Max_Input__c;
            else
                return 0.0;
        }
        set {
            currentRptDisc.Special_Range_Max_Input__c = value;
            this.SpecRngMax = value;
        }
    }
    public Decimal VSpecRngMax {
        get {
            if(currentRptDisc.Vac_Special_Range_Max_Input__c!=null)
                return currentRptDisc.Vac_Special_Range_Max_Input__c;
            else
                return 0.0;
        }
        set {
            currentRptDisc.Vac_Special_Range_Max_Input__c = value;
            this.VSpecRngMax = value;
        }
    }

    // Press Performance Tolerance Min Input
    public Decimal PerfTolMin {
        get {
            return currentRptDisc.Performance_Tolerance_Min_Input__c;
        }
        set {
            currentRptDisc.Performance_Tolerance_Min_Input__c = value;
            this.PerfTolMin = value;
        }
    }
    public Decimal VPerfTolMin {
        get {
            return currentRptDisc.Vac_Performance_Tolerance_Min_Input__c;
        }
        set {
            currentRptDisc.Vac_Performance_Tolerance_Min_Input__c = value;
            this.VPerfTolMin = value;
        }
    }
    // Press Performance Tolerance Max Input
    public Decimal PerfTolMax {
        get {
            return currentRptDisc.Performance_Tolerance_Max_Input__c;
        }
        set {
            currentRptDisc.Performance_Tolerance_Max_Input__c = value;
            this.PerfTolMax = value;
        }
    }
    public Decimal VPerfTolMax {
        get {
            return currentRptDisc.Vac_Performance_Tolerance_Max_Input__c;
        }
        set {
            currentRptDisc.Vac_Performance_Tolerance_Max_Input__c = value;
            this.VPerfTolMax = value;
        }
    }
    // Press Performance Tolerance Units - Percent, Pressure Setting Units
    public String PerfTolUOM {
        get {
            return currentRptDisc.Performance_Tolerance_Input_Units__c;
        }
        set {
            currentRptDisc.Performance_Tolerance_Input_Units__c = value;
            this.PerfTolUOM = value;
        }
    }
    public String VPerfTolUOM {
        get {
            return currentRptDisc.Vac_Performance_Tolerance_Units__c;
        }
        set {
            currentRptDisc.Vac_Performance_Tolerance_Units__c = value;
            this.VPerfTolUOM = value;
        }
    }
    public List<SelectOption> getPerfTolUnitOptions() {
        return new List<SelectOption> {
            new SelectOption('Percent', 'Percent'),
                new SelectOption('Specified Burst Pressure Units','Specified Burst Pressure Units')
                };
                    }
    // Press Burst Press Min/Max Max Input
    public Decimal BPMMMax {
        get {
            //  TODO: remove this; This logic will just correct any misaligned data created during development
            if(currentRptDisc.Press_Burst_Pressure_Max_Input__c != RTPRS1) {
                currentRptDisc.Press_Burst_Pressure_Max_Input__c = RTPRS1;
            }
            return RTPRS1;
        }
        set;
    }
    public Decimal VBPMMMax {
        get {
            //  TODO: remove this; This logic will just correct any misaligned data created during development
            if(currentRptDisc.Vac_Burst_Press_Max_Input__c != RTPRS1) {
                currentRptDisc.Vac_Burst_Press_Max_Input__c = RTPRS1;
            }
            return VTPRS1;
        }
        set;
    }
    // Press Burst Press Min/Max Min Input
    public Decimal BPMMMin {
        get {
            return currentRptDisc.Press_Burst_Pressure_Min_Input__c;
        }
        set {
            currentRptDisc.Press_Burst_Pressure_Min_Input__c = value;
            this.BPMMMin = value;
        }
    }
    public Decimal VBPMMMin {
        get {
            return currentRptDisc.Vac_Burst_Press_Min_Input__c;
        }
        set {
            currentRptDisc.Vac_Burst_Press_Min_Input__c = value;
            this.VBPMMMin = value;
        }
    }
    // Press Reference Manufacturing Range Type - Zero, -10% (-5 psig), -10%(-0.6 psig), -10%, -5%(-2.5 psig), -5%(-0.3 psig), -5%, Standard, Special - 75% of Std. Mfg. Range, Special 50% of Std. Mfg. Range, Special - 25% of Std. Mfg. Range
    public String BPMMRefRng {
        get {
            return currentRptDisc.Reference_Mfg_Range_Type__c;
        }
        set {
            currentRptDisc.Reference_Mfg_Range_Type__c = value;
            this.BPMMRefRng = value;
        }
    }
    public String VBPMMRefRng {
        get {
            return currentRptDisc.Vac_Reference_Mfg_Range_Type__c;
        }
        set {
            currentRptDisc.Vac_Reference_Mfg_Range_Type__c = value;
            this.VBPMMRefRng = value;
        }
    }
    /** IMPORTANT NOTE : ALL ATTRIBUTES BENEATH THIS ARE FOR ENGINEERING TAB IN OCPQ **/
    // TODO: optimize all callouts
    // Manufacturing Range String A (This was a string, but makes more sense in a map)
    public static String mfgWhereClause='';
    public static List<Manufacturing_Range_Value__c> mfgRngList=new List<Manufacturing_Range_Value__c>();
    public Manufacturing_Range_Value__c MfgRngValsA {
        get {
            Decimal psigPressure = 0.0;
            String whereClause = '';
            Map<String,Object> whereVars = new Map<String,Object>();
            Boolean query = null;

            if((RGRAT1 == 'Rated' || RGRAT1 == 'Specified') && RGTYP1 == 'Special') {
                // return MfgRngValues table values where RGEMAXLL and RGEMAXUL is compaired to SpecRngMax converted to psig
                psigPressure = convertPressure(SpecRngMax, RTPRSU, 'psig');
                // if(MfgRngValsA != null && psigPressure >= MfgRngValsA.RGEMAXLL__c && psigPressure < MfgRngValsA.RGEMAXUL__c) {
                //     query = false;
                // } else {
                //     query = true;
                //     whereClause = 'RGRAT1__c =\''+RGRAT1+'\' AND RGTYP1__c = \''+RGTYP1+'\' AND RGEMAXLL__c <='+psigPressure+' AND RGEMAXUL__c >'+psigPressure;
                //     whereVars.put('psigPressure', psigPressure);
                //     if(whereClause==mfgWhereClause)
                //         query = false;
                //     mfgWhereClause=whereClause;
                // }
                //List<Manufacturing_Range_Value__c> mfgRngVals =filterMgfBase (mfgList,'RGEMAX',psigPressure,true);
                List<Manufacturing_Range_Value__c> mfgRngVals =filterMgfBase (mfgList,'RGEMAX',psigPressure,true,RGRAT1,RGTYP1);
                if(!mfgRngVals.isEmpty())
                    return mfgRngVals.get(0);
            } else if((RGRAT1 == 'Rated' || RGRAT1 == 'Specified') && (RGTYP1 != 'Performance Tolerance' || RGTYP1 != 'Special') && (!string.IsBlank(RGTYP1))) {
                // return MfgRngValues table values where RTPRS1LL and RTPRS1UL is compaired to RTPRS1 converted to psig
                psigPressure = currentRptDisc.Converted_Pressure_Setting__c;
                //     if(MfgRngValsA != null && psigPressure >= MfgRngValsA.RTPRS1LL__c && psigPressure < MfgRngValsA.RTPRS1UL__c) {
                //         query = false;
                //     } else {
                //         query = true;
                //         whereClause = 'RGRAT1__c = \''+RGRAT1+'\' AND RGTYP1__c =\'' +RGTYP1+'\' AND RTPRS1LL__c <='+psigPressure+ 'AND RTPRS1UL__c >'+psigPressure;
                //         whereVars.put('psigPressure', psigPressure);
                //         if(whereClause==mfgWhereClause)
                //             query = false;
                //         mfgWhereClause=whereClause;
                //     }
                // }
                // if(query == true) {
                //     SObject[] mfgRngVal = ConstantsUtil.queryTableValue2('RGRAT1__c, RGTYP1__c, RGEMAXLL__c, RGEMAXUL__c, MinMfgRngAdder__c, MinMfgRngMulti__c,  MaxMfgRngMulti__c,  MaxMfgRngAdder__c',
                //                                                       'Manufacturing_Range_Value__c',
                //                                                       whereClause,
                //                                                       whereVars
                //                                                      );
                //     if(mfgRngVal.size()>0) {
                //         //mfgRngList.add((Manufacturing_Range_Value__c) mfgRngVal[0]);
                //         return (Manufacturing_Range_Value__c) mfgRngVal[0];
                //     }
                // }
                //return mfgRngList[0];
                List<Manufacturing_Range_Value__c> mfgRngVals =filterMgfBase (mfgList,'RTPRS1',psigPressure,true,RGRAT1,RGTYP1);
                if(!mfgRngVals.isEmpty())
                    return mfgRngVals.get(0);
            }
            return MfgRngValsA;
        }
        private set;
    }
    public Manufacturing_Range_Value__c VMfgRngValsA {
        get {
            Decimal psigPressure = 0.0;
            // NOTE: WHAT DO WE DO ABOUT PERFORMANCE TOLERANCE
            if((VGRAT1 == 'Rated' || VGRAT1 == 'Specified') && VGTYP1 == 'Special') {
                // return MfgRngValues table values where RGEMAXLL and RGEMAXUL is compared to SpecRngMax converted to psig
                psigPressure = convertPressure(VSpecRngMax, VTPRSU, 'psig');
                // List<Manufacturing_Range_Value__c> mfgRngVals = [
                //     SELECT RGRAT1__c, RGTYP1__c, RGEMAXLL__c, RGEMAXUL__c, MinMfgRngAdder__c,    MinMfgRngMulti__c,  MaxMfgRngMulti__c,  MaxMfgRngAdder__c
                //     FROM Manufacturing_Range_Value__c
                //     WHERE RGRAT1__c = :VGRAT1 AND RGTYP1__c != :VGTYP1 AND RGEMAXLL__c <= :psigPressure AND RGEMAXUL__c >= :psigPressure];
                List<Manufacturing_Range_Value__c> mfgRngVals =filterMgfBase (mfgList,'RGEMAX',psigPressure,true,VGRAT1,VGTYP1);
                if(!mfgRngVals.isEmpty())
                    return mfgRngVals.get(0);
            } else if((VGRAT1 == 'Rated' || VGRAT1 == 'Specified') && (VGTYP1 != 'Performance Tolerance' || VGTYP1 != 'Special' )) {
                // return MfgRngValues table values where VTPRS1LL and VTPRS1UL is compared to VTPRS1 converted to psig
                psigPressure = convertPressure(VTPRS1, VTPRSU, 'psig');
                // List<Manufacturing_Range_Value__c> mfgRngVals = [
                //     SELECT RGRAT1__c, RGTYP1__c, RTPRS1LL__c, RTPRS1UL__c, MinMfgRngAdder__c,    MinMfgRngMulti__c,  MaxMfgRngMulti__c,  MaxMfgRngAdder__c
                //     FROM Manufacturing_Range_Value__c
                //     WHERE RGRAT1__c = :VGRAT1 AND RGTYP1__c != :VGTYP1 AND RTPRS1LL__c <= :psigPressure AND RTPRS1UL__c >= :psigPressure];
                List<Manufacturing_Range_Value__c> mfgRngVals =filterMgfBase (mfgList,'RTPRS1',psigPressure,true,VGRAT1,VGTYP1);
                if(!mfgRngVals.isEmpty())
                    return mfgRngVals.get(0);
            }
            return VMfgRngValsA;
        }
        set;
    }
    // BurstTolStringA
    public RD_tblBurstTolMethod__c BurstTolStringA {
        get {
            Decimal psigPressure = 0.0;
            if((RGRAT1=='Rated' || RGRAT1=='Specified') && RGTYP1=='Special') {
                // return tblBurstTolMethod table values where RatedPressLL and RatedPressUL is compared to SpecRngMax converted to psig
                psigPressure = convertPressure(SpecRngMax, RTPRSU, 'psig');
                // List<RD_tblBurstTolMethod__c> burstTolMethodVals = [
                //     SELECT SizeLL__c, SizeUL__c, RatedPressLL__c, RatedPressUL__c, BPMMMinPressLL__c, BPMMMinPressUL__c, BPMMMaxPressLL__c, BPMMMaxPressUL__c, MinAdd__c, MinMulti__c, MaxAdd__c, MaxMulti__c
                //     FROM RD_tblBurstTolMethod__c
                //     WHERE RatedPressLL__c <= :psigPressure AND RatedPressUL__c >= :psigPressure];
                List<RD_tblBurstTolMethod__c> burstTolMethodVals =filterTblBrustList (tbList, 'Rated',psigPressure);
                if(!burstTolMethodVals.isEmpty())
                    return burstTolMethodVals.get(0);
            } else if((RGRAT1=='Rated' || RGRAT1=='Specified') && (RGTYP1 != 'Performance Tolerance' || RGTYP1 != 'Special') && MfgRngValsA!=null) {
                // return tblBurstTolMethod table values where RatedPressLL and RatedPressUL is compared to (RTPRS1 converted to psig)*MaxMfgRngMult+MaxMfgRngAdder from MfgRngValsA"
                psigPressure = (currentRptDisc.Converted_Pressure_Setting__c * MfgRngValsA.MaxMfgRngMulti__c) + MfgRngValsA.MaxMfgRngAdder__c;
                // List<RD_tblBurstTolMethod__c> burstTolMethodVals = [
                //     SELECT SizeLL__c, SizeUL__c, RatedPressLL__c, RatedPressUL__c, BPMMMinPressLL__c, BPMMMinPressUL__c, BPMMMaxPressLL__c, BPMMMaxPressUL__c, MinAdd__c, MinMulti__c, MaxAdd__c, MaxMulti__c
                //     FROM RD_tblBurstTolMethod__c
                //     WHERE RatedPressLL__c <= :psigPressure AND RatedPressUL__c >= :psigPressure];
                List<RD_tblBurstTolMethod__c> burstTolMethodVals =filterTblBrustList (tbList, 'Rated',psigPressure);
                if(!burstTolMethodVals.isEmpty())
                    return burstTolMethodVals.get(0);
            }
            return BurstTolStringA;
        }
        set;
    }
    public RD_tblBurstTolMethod__c VBurstTolStringA {
        get {
            Decimal psigPressure = 0.0;
            if((VGRAT1=='Rated' || VGRAT1=='Specified') && VGTYP1=='Special') {
                // return tblBurstTolMethod table values where RatedPressLL and RatedPressUL is compared to SpecRngMax converted to psig
                psigPressure = convertPressure(VSpecRngMax, VTPRSU, 'psig');
                // List<RD_tblBurstTolMethod__c> burstTolMethodVals = [
                //     SELECT SizeLL__c, SizeUL__c, RatedPressLL__c, RatedPressUL__c, BPMMMinPressLL__c, BPMMMinPressUL__c, BPMMMaxPressLL__c, BPMMMaxPressUL__c, MinAdd__c, MinMulti__c, MaxAdd__c, MaxMulti__c
                //     FROM RD_tblBurstTolMethod__c
                //     WHERE RatedPressLL__c <= :psigPressure AND RatedPressUL__c >= :psigPressure];
                List<RD_tblBurstTolMethod__c> burstTolMethodVals =filterTblBrustList (tbList, 'Rated',psigPressure);
                if(!burstTolMethodVals.isEmpty())
                    return burstTolMethodVals.get(0);

            } else if((VGRAT1=='Rated' || VGRAT1=='Specified') && (VGTYP1 != 'Performance Tolerance' || VGTYP1 != 'Special') && VMfgRngValsA!=null) {
                // return tblBurstTolMethod table values where RatedPressLL and RatedPressUL is compared to (RTPRS1 converted to psig)*MfgRngMult+MfgRngAdder from MfgRngValsA"
                psigPressure = (convertPressure(VTPRS1, VTPRSU, 'psig') * VMfgRngValsA.MaxMfgRngMulti__c) + VMfgRngValsA.MaxMfgRngAdder__c;
                // List<RD_tblBurstTolMethod__c> burstTolMethodVals = [
                //     SELECT SizeLL__c, SizeUL__c, RatedPressLL__c, RatedPressUL__c, BPMMMinPressLL__c, BPMMMinPressUL__c, BPMMMaxPressLL__c, BPMMMaxPressUL__c, MinAdd__c, MinMulti__c, MaxAdd__c, MaxMulti__c
                //     FROM RD_tblBurstTolMethod__c
                //     WHERE RatedPressLL__c <= :psigPressure AND RatedPressUL__c >= :psigPressure];
                List<RD_tblBurstTolMethod__c> burstTolMethodVals =filterTblBrustList (tbList, 'Rated',psigPressure);
                if(!burstTolMethodVals.isEmpty())
                    return burstTolMethodVals.get(0);
            }
            return VBurstTolStringA;
        }
        set;
    }
    // PMAX
    public Decimal BURMAX {
        get {
            Decimal BURMAX=0.0;
            if(RGRAT1 == 'Burst Pressure Min/Max.') {
                //Return BPMMMax converted to PPressureBaseUOM
                return convertPressure(BPMMMax, RTPRSU, PPressureBaseUOM);
            } else if(RGRAT1 == 'Specified' && RGTYP1 == 'Performance Tolerance' && PerfTolUOM == 'Specified Burst Pressure Units') {
                //Return (RTPRS1 + PerfTolMax) converted to PPressureBaseUOM
                return convertPressure(RTPRS1 + PerfTolMax, RTPRSU, PPressureBaseUOM);
            } else if(RGRAT1 == 'Specified' && RGTYP1 == 'Performance Tolerance' && PerfTolUOM == 'Percent') {
                //Return (RTPRS1*(1+(PerfTolMax/100))) converted to PPressureBaseUOM
                return convertPressure(RTPRS1*(1+(PerfTolMax/100)), RTPRSU, PPressureBaseUOM);
            } else if((RGRAT1 == 'Specified' || RGRAT1 == 'Rated') && RGTYP1 == 'Special' ) {
                //Return (SpecRngMax converted to PPressureBaseUOM) * MaxMulti from BurstTolStringA + MaxAdd from BurstTolStringA
                return (convertPressure(SpecRngMax, RTPRSU, PPressureBaseUOM) * BurstTolStringA.MaxMulti__c) + BurstTolStringA.MaxAdd__c;
            } else if((RGRAT1 == 'Specified' || RGRAT1 == 'Rated') && (RGTYP1 != 'Performance Tolerance' || RGTYP1 != 'Special') && MfgRngValsA!=null) {
                //Return ((RTPRS1 converted to PPressureBaseUOM) * MaxMfgRngMulti from MfgRngValsA + MaxMfgRngAdder from MfgRngValsA) * MaxMulti from BurstTolStringA + MaxAdd form BurstTolStringA
                return (((convertPressure(RTPRS1, RTPRSU, PPressureBaseUOM) * MfgRngValsA.MaxMfgRngMulti__c) + MfgRngValsA.MaxMfgRngAdder__c) * BurstTolStringA.MaxMulti__c) + BurstTolStringA.MaxAdd__c;
            }
            return BURMAX;
        }
        set;
    }
    public Decimal VMAX {
        get {
            Decimal VMAX=0.0;
            if(VGRAT1 == 'Burst Pressure Min/Max.') {
                //Return BPMMMax converted to VPressureBaseUOM
                return convertPressure(VBPMMMax, VTPRSU, VPressureBaseUOM);
            } else if(VGRAT1 == 'Specified' && VGTYP1 == 'Performance Tolerance' && VPerfTolUOM == 'Specified Burst Pressure Units') {
                //Return (VTPRS1 + PerfTolMax) converted to VPressureBaseUOM
                return convertPressure(VTPRS1 + VPerfTolMax, VTPRSU, VPressureBaseUOM);
            } else if(VGRAT1 == 'Specified' && VGTYP1 == 'Performance Tolerance' && VPerfTolUOM == 'Percent') {
                //Return (VTPRS1*(1+(PerfTolMax/100))) converted to VPressureBaseUOM
                return convertPressure(VTPRS1*(1+(VPerfTolMax/100)), VTPRSU, VPressureBaseUOM);
            } else if((VGRAT1 == 'Specified' || VGRAT1 == 'Rated') && VGTYP1 == 'Special' ) {
                //Return (SpecRngMax converted to VPressureBaseUOM) * MaxMulti from BurstTolStringA + MaxAdd from BurstTolStringA
                //if(BurstTolStringA != Null)
                    return (convertPressure(VSpecRngMax, VTPRSU, VPressureBaseUOM) * VBurstTolStringA.MaxMulti__c) + VBurstTolStringA.MaxAdd__c;
                // else
                //     return VMAX;
            } else if((VGRAT1 == 'Specified' || VGRAT1 == 'Rated') && (String.isNOTBlank(VGTYP1)) && (VGTYP1 != 'Performance Tolerance' || VGTYP1 != 'Special')) {
                //Return ((VTPRS1 converted to VPressureBaseUOM) * MaxMfgRngMulti from MfgRngValsA + MaxMfgRngAdder from MfgRngValsA) * MaxMulti from BurstTolStringA + MaxAdd form BurstTolStringA
                //if(BurstTolStringA != Null && VMfgRngValsA != Null)
                return (((convertPressure(VTPRS1, VTPRSU, VPressureBaseUOM) * VMfgRngValsA.MaxMfgRngMulti__c) + VMfgRngValsA.MaxMfgRngAdder__c) * VBurstTolStringA.MaxMulti__c) + VBurstTolStringA.MaxAdd__c;
                // else
                //     return VMAX;
            }
            return VMAX;
        }
        set;
    }
    // BurstTolStringB
    public RD_tblBurstTolMethod__c BurstTolStringB {
        get {
            if(RGRAT1 == 'Burst Pressure Min/Max.' || RGTYP1=='Performance Tolerance'){
                // Return tblBurstTolMethod table values where BPMMMaxPressLL and BPMMMaxPressUL is compared to BURMAX
                // List<RD_tblBurstTolMethod__c> burstTolMethodVals = [
                //     SELECT SizeLL__c, SizeUL__c, RatedPressLL__c, RatedPressUL__c, BPMMMinPressLL__c, BPMMMinPressUL__c, BPMMMaxPressLL__c, BPMMMaxPressUL__c, MinAdd__c, MinMulti__c, MaxAdd__c, MaxMulti__c
                //     FROM RD_tblBurstTolMethod__c
                //     WHERE BPMMMaxPressLL__c <= :BURMAX AND BPMMMaxPressUL__c >= :BURMAX];
                List<RD_tblBurstTolMethod__c> burstTolMethodVals =filterTblBrustList (tbList, 'BPMMMax',BURMAX);
                if(!burstTolMethodVals.isEmpty())
                    return burstTolMethodVals.get(0);
                else
                    return null;
            } else {
                return null;
            }
            //return BurstTolStringB;
        }
        set;
    }
    public RD_tblBurstTolMethod__c VBurstTolStringB {
        get {
            if(VGRAT1 == 'Burst Pressure Min/Max.' || VGTYP1=='Performance Tolerance') {
                // Return tblBurstTolMethod table values where BPMMMaxPressLL and BPMMMaxPressUL is compared to VMAX
                // List<RD_tblBurstTolMethod__c> burstTolMethodVals = [
                //     SELECT SizeLL__c, SizeUL__c, RatedPressLL__c, RatedPressUL__c, BPMMMinPressLL__c, BPMMMinPressUL__c, BPMMMaxPressLL__c, BPMMMaxPressUL__c, MinAdd__c, MinMulti__c, MaxAdd__c, MaxMulti__c
                //     FROM RD_tblBurstTolMethod__c
                //     WHERE BPMMMaxPressLL__c <= :VMAX AND BPMMMaxPressUL__c >= :VMAX];
                List<RD_tblBurstTolMethod__c> burstTolMethodVals =filterTblBrustList (tbList, 'BPMMMax',VMAX);
                if(!burstTolMethodVals.isEmpty())
                    return burstTolMethodVals.get(0);
            }
            return VBurstTolStringB;
        }
        set;
    }
    // TMR
    public Decimal TMR {
        get {
            decimal TMR=0.0;
            if((RGRAT1 == 'Burst Pressure Min/Max.') || ( RGRAT1 == 'Specified' && RGTYP1 == 'Performance Tolerance')) {
                // Return BURMAX/(MaxMulti from BurstTolStringB) - (MaxAdd from BurstTolStringB)
                return (BURMAX/BurstTolStringB.MaxMulti__c) - BurstTolStringB.MaxAdd__c;
            } else if((RGRAT1 == 'Rated' || RGRAT1 == 'Specified') && RGTYP1 == 'Special' ) {
                // Return SpecRngMax converted to PPressureBaseUOM
                return convertPressure(SpecRngMax, RTPRSU, PPressureBaseUOM);
            } else if((RGRAT1 == 'Rated' || RGRAT1 == 'Specified') && (RGTYP1 != 'Special' && RGTYP1 != 'Performance Tolerance') && MfgRngValsA!=null) {
                // Return (RTPRS1 converted to PPressureBaseUOM) * (MaxMfgRngMulti from MfgRngValsA) + (MaxMfgRngAdder from MfgRngValsA})
                System.debug('MfgRngValsA --> '+MfgRngValsA);
                return (convertPressure(RTPRS1, RTPRSU, PPressureBaseUOM) * MfgRngValsA.MaxMfgRngMulti__c) + MfgRngValsA.MaxMfgRngAdder__c;
            }//else if (RGRAT1 == 'Start/Full Relief (Min/Max)') {
            //     return FullRelief.setScale(2);
            // }
            return TMR;
        }
        set;
    }
    public Decimal VTMR {
        get {
            Decimal VTMR = 0.0;
            if((VGRAT1 == 'Burst Pressure Min/Max.') || ( VGRAT1 == 'Specified' && VGTYP1 == 'Performance Tolerance')) {
                // Return VMAX/(MaxMulti from BurstTolStringB) - (MaxAdd from BurstTolStringB)
                //if(BurstTolStringB != Null){
                    return (VMAX/VBurstTolStringB.MaxMulti__c) - VBurstTolStringB.MaxAdd__c;
                // } else {
                //     return 0.0;
                // }
            } else if((VGRAT1 == 'Rated' || VGRAT1 == 'Specified') && VGTYP1 == 'Special' ) {
                // Return SpecRngMax converted to PPressureBaseUOM
                return convertPressure(VSpecRngMax, VTPRSU, VPressureBaseUOM);
            } else if((VGRAT1 == 'Rated' || VGRAT1 == 'Specified') && (VGTYP1 != 'Special' && VGTYP1 != 'Performance Tolerance') && VMfgRngValsA!=null) {
                // Return (RTPRS1 converted to PPressureBaseUOM) * (MaxMfgRngMulti from VMfgRngValsA) + (MaxMfgRngAdder from VMfgRngValsA})
                return (convertPressure(VTPRS1, VTPRSU, VPressureBaseUOM) * VMfgRngValsA.MaxMfgRngMulti__c) + VMfgRngValsA.MaxMfgRngAdder__c;
            }
            return VTMR;
        }
        set;
    }
    // MfgRngValsB
    public Manufacturing_Range_Value__c MfgRngValsB {
        get {
            if(RGRAT1 == 'Burst Pressure Min/Max.' && RGTYP1 == 'Specify Reference Mfg Range') {
                //Return MfgRngValues table values where RGMAXLL and RGMAXUL is compared to TMR"
                // List<Manufacturing_Range_Value__c> mfgRngVals = [
                //     SELECT RGRAT1__c, RGTYP1__c, RGEMAXLL__c, RGEMAXUL__c, MinMfgRngAdder__c,    MinMfgRngMulti__c,  MaxMfgRngMulti__c,  MaxMfgRngAdder__c
                //     FROM Manufacturing_Range_Value__c
                //     WHERE RGRAT1__c = :VGRAT1 AND RGTYP1__c != :VGTYP1 AND RGEMAXLL__c <= :TMR AND RGEMAXUL__c >= :TMR];
                List<Manufacturing_Range_Value__c> mfgRngVals =filterMgfBase (mfgList,'RGEMAX',TMR,true,'Rated',BPMMRefRng);
                if(!mfgRngVals.isEmpty())
                    return mfgRngVals.get(0);
            }
            return MfgRngValsB;
        }
        set;
    }
    public Manufacturing_Range_Value__c VMfgRngValsB {
        get {
            if(VGRAT1 == 'Burst Pressure Min/Max.' && VGTYP1 == 'Specify Reference Mfg Range') {
                //Return MfgRngValues table values where RGMAXLL and RGMAXUL is compared to VTMR
                // List<Manufacturing_Range_Value__c> mfgRngVals = [
                //     SELECT RGRAT1__c, RGTYP1__c, RGEMAXLL__c, RGEMAXUL__c, MinMfgRngAdder__c,    MinMfgRngMulti__c,  MaxMfgRngMulti__c,  MaxMfgRngAdder__c
                //     FROM Manufacturing_Range_Value__c
                //     WHERE RGRAT1__c = :VGRAT1 AND RGTYP1__c != :VGTYP1 AND RGEMAXLL__c <= :VTMR AND RGEMAXUL__c >= :VTMR];
                List<Manufacturing_Range_Value__c> mfgRngVals =filterMgfBase (mfgList,'RGEMAX',VTMR,true,'Rated',VBPMMRefRng);
                if(!mfgRngVals.isEmpty())
                    return mfgRngVals.get(0);
            }
            return VMfgRngValsB;
        }
        set;
    }
    // BurstTolStringC
    public RD_tblBurstTolMethod__c BurstTolStringC {
        get {
            Decimal psigPressure = 0.0;
            if(((RGRAT1=='Burst Pressure Min/Max.')) && ((RGTYP1=='Specify Reference Mfg Range')) ) {
                // Return tblBurstTolMethod table values where RatedPressLL and RatedPressUL is compared to (TMR/(MaxMfgRngMulti from MfgRngValsB)-(MaxMfgRngAdder from MfgRngValsB)*(MinMfgRngMulti from MfgRngValsB)+(MinMfgRngAdder from MfgRngValsB))
                //if(MfgRngValsB != Null)
                psigPressure = (((TMR/MfgRngValsB.MaxMfgRngMulti__c)-MfgRngValsB.MaxMfgRngAdder__c) * MfgRngValsB.MinMfgRngMulti__c) + MfgRngValsB.MinMfgRngAdder__c;

                // List<RD_tblBurstTolMethod__c> burstTolMethodVals = [
                //     SELECT SizeLL__c, SizeUL__c, RatedPressLL__c, RatedPressUL__c, BPMMMinPressLL__c, BPMMMinPressUL__c, BPMMMaxPressLL__c, BPMMMaxPressUL__c, MinAdd__c, MinMulti__c, MaxAdd__c, MaxMulti__c
                //     FROM RD_tblBurstTolMethod__c
                //     WHERE RatedPressLL__c <= :psigPressure AND RatedPressUL__c >= :psigPressure];
                List<RD_tblBurstTolMethod__c> burstTolMethodVals =filterTblBrustList (tbList, 'Rated',psigPressure);
                if(!burstTolMethodVals.isEmpty())
                    return burstTolMethodVals.get(0);

            } else if((RGRAT1 == 'Rated' || RGRAT1 == 'Specified') && (RGTYP1 == 'Special') ) {
                // Return tblBurstTolMethod table values where RatedPressLL and RatedPressUL is compared to (SpecRngMin converted to psig)
                psigPressure = convertPressure(SpecRngMin, RTPRSU, 'psig');
                // List<RD_tblBurstTolMethod__c> burstTolMethodVals = [
                //     SELECT SizeLL__c, SizeUL__c, RatedPressLL__c, RatedPressUL__c, BPMMMinPressLL__c, BPMMMinPressUL__c, BPMMMaxPressLL__c, BPMMMaxPressUL__c, MinAdd__c, MinMulti__c, MaxAdd__c, MaxMulti__c
                //     FROM RD_tblBurstTolMethod__c
                //     WHERE RatedPressLL__c <= :psigPressure AND RatedPressUL__c >= :psigPressure];
                List<RD_tblBurstTolMethod__c> burstTolMethodVals =filterTblBrustList (tbList, 'Rated',psigPressure);
                if(!burstTolMethodVals.isEmpty())
                    return burstTolMethodVals.get(0);
            } else if((RGRAT1 == 'Rated' || RGRAT1 == 'Specified') && (RGTYP1 != 'Special' && RGTYP1 != 'Performance Tolerance') && MfgRngValsA!=null) {
                // Return tblBurstTolMethod table values where RatedPressLL and RatedPressUL is compared to ((RTPRS1 converted to psig)*(MinMfgRngMulti from MfgRngValsA)+(MinMfgRngAdder from MfgRngValsA))
                psigPressure = (currentRptDisc.Converted_Pressure_Setting__c * MfgRngValsA.MinMfgRngMulti__c) + MfgRngValsA.MinMfgRngAdder__c;
                // List<RD_tblBurstTolMethod__c> burstTolMethodVals = [
                //     SELECT SizeLL__c, SizeUL__c, RatedPressLL__c, RatedPressUL__c, BPMMMinPressLL__c, BPMMMinPressUL__c, BPMMMaxPressLL__c, BPMMMaxPressUL__c, MinAdd__c, MinMulti__c, MaxAdd__c, MaxMulti__c
                //     FROM RD_tblBurstTolMethod__c
                //     WHERE RatedPressLL__c <= :psigPressure AND RatedPressUL__c >= :psigPressure];
                List<RD_tblBurstTolMethod__c> burstTolMethodVals =filterTblBrustList (tbList, 'Rated',psigPressure);
                if(!burstTolMethodVals.isEmpty())
                    return burstTolMethodVals.get(0);
            }
            return BurstTolStringC;
        }
        set;
    }
    public RD_tblBurstTolMethod__c VBurstTolStringC {
        get {
            Decimal psigPressure = 0.0;
            if(((VGRAT1=='Burst Pressure Min/Max.')) && ((VGTYP1=='Specify Reference Mfg Range')) ) {
                // Return tblBurstTolMethod table values where RatedPressLL and RatedPressUL is compared to (TMR/(MaxMfgRngMulti from MfgRngValsB)-(MaxMfgRngAdder from MfgRngValsB)*(MinMfgRngMulti from MfgRngValsB)+(MinMfgRngAdder from MfgRngValsB))
                psigPressure = (((VTMR/VMfgRngValsB.MaxMfgRngMulti__c)-VMfgRngValsB.MaxMfgRngAdder__c) * VMfgRngValsB.MinMfgRngMulti__c) + VMfgRngValsB.MinMfgRngAdder__c;
                // List<RD_tblBurstTolMethod__c> burstTolMethodVals = [
                //     SELECT SizeLL__c, SizeUL__c, RatedPressLL__c, RatedPressUL__c, BPMMMinPressLL__c, BPMMMinPressUL__c, BPMMMaxPressLL__c, BPMMMaxPressUL__c, MinAdd__c, MinMulti__c, MaxAdd__c, MaxMulti__c
                //     FROM RD_tblBurstTolMethod__c
                //     WHERE RatedPressLL__c <= :psigPressure AND RatedPressUL__c >= :psigPressure];
                List<RD_tblBurstTolMethod__c> burstTolMethodVals =filterTblBrustList (tbList, 'Rated',psigPressure);
                if(!burstTolMethodVals.isEmpty())
                    return burstTolMethodVals.get(0);
            } else if((VGRAT1 == 'Rated' || VGRAT1 == 'Specified') && (VGTYP1 == 'Special') ) {
                // Return tblBurstTolMethod table values where RatedPressLL and RatedPressUL is compared to (VSpecRngMin converted to psig)
                psigPressure = convertPressure(VSpecRngMin, VTPRSU, 'psig');
                // List<RD_tblBurstTolMethod__c> burstTolMethodVals = [
                //     SELECT SizeLL__c, SizeUL__c, RatedPressLL__c, RatedPressUL__c, BPMMMinPressLL__c, BPMMMinPressUL__c, BPMMMaxPressLL__c, BPMMMaxPressUL__c, MinAdd__c, MinMulti__c, MaxAdd__c, MaxMulti__c
                //     FROM RD_tblBurstTolMethod__c
                //     WHERE RatedPressLL__c <= :psigPressure AND RatedPressUL__c >= :psigPressure];
                List<RD_tblBurstTolMethod__c> burstTolMethodVals =filterTblBrustList (tbList, 'Rated',psigPressure);
                if(!burstTolMethodVals.isEmpty())
                    return burstTolMethodVals.get(0);
            } else if((VGRAT1 == 'Rated' || VGRAT1 == 'Specified') && (VGTYP1 != 'Special' && VGTYP1 != 'Performance Tolerance') && VMfgRngValsA!=null) {
                // Return tblBurstTolMethod table values where RatedPressLL and RatedPressUL is compared to ((RTPRS1 converted to psig)*(MinMfgRngMulti from MfgRngValsA)+(MinMfgRngAdder from MfgRngValsA))
                psigPressure = (convertPressure(VTPRS1, VTPRSU, 'psig') * VMfgRngValsA.MinMfgRngMulti__c) + VMfgRngValsA.MinMfgRngAdder__c;
                // List<RD_tblBurstTolMethod__c> burstTolMethodVals = [
                //     SELECT SizeLL__c, SizeUL__c, RatedPressLL__c, RatedPressUL__c, BPMMMinPressLL__c, BPMMMinPressUL__c, BPMMMaxPressLL__c, BPMMMaxPressUL__c, MinAdd__c, MinMulti__c, MaxAdd__c, MaxMulti__c
                //     FROM RD_tblBurstTolMethod__c
                //     WHERE RatedPressLL__c <= :psigPressure AND RatedPressUL__c >= :psigPressure];
                List<RD_tblBurstTolMethod__c> burstTolMethodVals =filterTblBrustList (tbList, 'Rated',psigPressure);
                if(!burstTolMethodVals.isEmpty())
                    return burstTolMethodVals.get(0);
            }
            return VBurstTolStringC;
        }
        set;
    }
    // PMIN
    public Decimal BURMIN {
        get {
            Decimal BURMIN = 0.0;
            if(RGRAT1 == 'Burst Pressure Min/Max.' && RGTYP1 == 'Specify Reference Mfg Range') {
                //Return (((((TMR)/(MaxMfgRngMulti from MfgStringB)-(MaxMfgRngAdder from MfgStringB))*(MinMfgRngMulti from MfgStringB)+ (MinMfgRngAdder from MfgStringB))* (MinMulti from BurstTolStringC)+(MinAdd from BurstTolStringC)
                if(MfgRngValsB != Null && BurstTolStringC != Null){
                    return (((((TMR/MfgRngValsB.MaxMfgRngMulti__c)-MfgRngValsB.MaxMfgRngAdder__c) * MfgRngValsB.MinMfgRngMulti__c) + MfgRngValsB.MinMfgRngAdder__c) * BurstTolStringC.MinMulti__c) + BurstTolStringC.MinAdd__c;
                }else {
                    return 0.0;
                }
            } else if(RGRAT1 == 'Burst Pressure Min/Max.' && RGTYP1 == 'Specify Min') {
                //Return BPMMMin converted to psig
                return convertPressure(BPMMMin, RTPRSU, 'psig');
            } else if(RGRAT1 == 'Specified' && RGTYP1 == 'Performance Tolerance' && PerfTolUOM == 'Specified Burst Pressure Units'){
                //Return (RTPRS1-PerfTolMin) converted to psig
                return convertPressure((RTPRS1-PerfTolMin), RTPRSU, 'psig');
            } else if(RGRAT1 == 'Specified' && RGTYP1 == 'Performance Tolerance' && PerfTolUOM == 'Percent'){
                //Return (RTPRS1 * ( 1 - (PerfTolMin / 100))) converted to psig
                return convertPressure((RTPRS1 * ( 1 - (PerfTolMin / 100))), RTPRSU, 'psig');
            } else if((RGRAT1 == 'Rated' || RGRAT1 == 'Specified') && RGTYP1 == 'Special'){
                //Return (SpecRngMin converted to psig)* (MinMulti from BurstTolStringC)+(MinAdd from BurstTolStringC)
                return (convertPressure(SpecRngMin, RTPRSU, 'psig') * BurstTolStringC.MinMulti__c) + BurstTolStringC.MinAdd__c;
            } else if ((RGRAT1 == 'Rated' || RGRAT1 == 'Specified') && (RGTYP1 != 'Performance Tolerance' || RGTYP1 != 'Special') && MfgRngValsA!=null) {
                return ((((((PBurstPressureConverted* MfgRngValsA.MinMfgRngMulti__c)
                            +MfgRngValsA.MinMfgRngAdder__c))*BurstTolStringC.MinMulti__c) +BurstTolStringC.MinAdd__c));
            }
            return BURMIN;
        }
        set;
    }
    public Decimal VMIN {
        get {
            Decimal VMIN = 0.0;
            if(VGRAT1 == 'Burst Pressure Min/Max.' && VGTYP1 == 'Specify Reference Mfg Range') {
                //Return (((((TMR)/(MaxMfgRngMulti from MfgStringB)-(MaxMfgRngAdder from MfgStringB))*(MinMfgRngMulti from MfgStringB)+ (MinMfgRngAdder from MfgStringB))* (MinMulti from BurstTolStringC)+(MinAdd from BurstTolStringC)
                if(VMfgRngValsB != Null && VBurstTolStringC != Null)
                    return (((((VTMR/VMfgRngValsB.MaxMfgRngMulti__c) - VMfgRngValsB.MaxMfgRngAdder__c) * VMfgRngValsB.MinMfgRngMulti__c) + VMfgRngValsB.MinMfgRngAdder__c) * VBurstTolStringC.MinMulti__c) + VBurstTolStringC.MinAdd__c;
                // else
                //     return 0.0;
            } else if(VGRAT1 == 'Burst Pressure Min/Max.' && VGTYP1 == 'Specify Min') {
                //Return BPMMMin converted to psig
                return convertPressure(VBPMMMin, VTPRSU, 'psig');
            } else if(VGRAT1 == 'Specified' && VGTYP1 == 'Performance Tolerance' && VPerfTolUOM == 'Specified Burst Pressure Units'){
                //Return (RTPRS1-PerfTolMin) converted to psig
                return convertPressure((VTPRS1-VPerfTolMin), VTPRSU, 'psig');
            } else if(VGRAT1 == 'Specified' && VGTYP1 == 'Performance Tolerance' && VPerfTolUOM == 'Percent') {
                //Return (RTPRS1 * ( 1 - (PerfTolMin / 100))) converted to psig
                return convertPressure((VTPRS1 * ( 1 - (VPerfTolMin / 100))), VTPRSU, 'psig');
            } else if((VGRAT1 == 'Rated' || VGRAT1 == 'Specified') && VGTYP1 == 'Special'){
                //Return (SpecRngMin converted to psig)* (MinMulti from BurstTolStringC)+(MinAdd from BurstTolStringC)
                return (convertPressure(VSpecRngMin, VTPRSU, 'psig') * VBurstTolStringC.MinMulti__c) + VBurstTolStringC.MinAdd__c;
            } else if ((VGRAT1 == 'Rated' || VGRAT1 == 'Specified') && (VGTYP1 != 'Performance Tolerance' || VGTYP1 != 'Special') && VMfgRngValsA!=null) {
                return ((((((VBurstPressureConverted* VMfgRngValsA.MinMfgRngMulti__c)
                            +VMfgRngValsA.MinMfgRngAdder__c))*VBurstTolStringC.MinMulti__c) +VBurstTolStringC.MinAdd__c));
            }
            return VMIN;
        }
        set;
    }

    public RD_tblBurstTolMethod__c BurstTolStringD {
        get {
            if((RGRAT1 == 'Specified' || RGRAT1=='Burst Pressure Min/Max.') && (RGTYP1== 'Specify Min' || RGTYP1=='Performance Tolerance')) {
                //Return tblBurstTolMethod table values where BPMMMinPressLL and BPMMMinPressUL is compared to BURMIN
                // List<RD_tblBurstTolMethod__c> burstTolMethodVals = [
                //     SELECT SizeLL__c, SizeUL__c, RatedPressLL__c, RatedPressUL__c, BPMMMinPressLL__c, BPMMMinPressUL__c, BPMMMaxPressLL__c, BPMMMaxPressUL__c, MinAdd__c, MinMulti__c, MaxAdd__c, MaxMulti__c
                //     FROM RD_tblBurstTolMethod__c
                //     WHERE BPMMMinPressLL__c <= :BURMIN AND BPMMMinPressUL__c >= :BURMIN];
                List<RD_tblBurstTolMethod__c> burstTolMethodVals =filterTblBrustList (tbList, 'BPMMMin',BURMIN);
                return burstTolMethodVals.get(0);
            }
            return BurstTolStringD;
        }
        set;
    }
    public RD_tblBurstTolMethod__c VBurstTolStringD {
        get {
            if((VGRAT1 == 'Specified' || VGRAT1=='Burst Pressure Min/Max.') && (VGTYP1== 'Specify Min' || VGTYP1=='Performance Tolerance')) {
                //Return tblBurstTolMethod table values where BPMMMinPressLL and BPMMMinPressUL is compared to BURMIN
                // List<RD_tblBurstTolMethod__c> burstTolMethodVals = [
                //     SELECT SizeLL__c, SizeUL__c, RatedPressLL__c, RatedPressUL__c, BPMMMinPressLL__c, BPMMMinPressUL__c, BPMMMaxPressLL__c, BPMMMaxPressUL__c, MinAdd__c, MinMulti__c, MaxAdd__c, MaxMulti__c
                //     FROM RD_tblBurstTolMethod__c
                //     WHERE BPMMMinPressLL__c <= :VMIN AND BPMMMinPressUL__c >= :VMIN];

                List<RD_tblBurstTolMethod__c> burstTolMethodVals = filterTblBrustList (tbList, 'BPMMMin',VMIN);
                if(!burstTolMethodVals.isEmpty())
                    return burstTolMethodVals.get(0);
            }
            return VBurstTolStringD;
        }
        set;
    }
    // Bottom of Manufacturing Range
    public Decimal BMR {
        get {
            Decimal BMR=0.0;
            if((RGRAT1 == 'Rated' || RGRAT1 == 'Specified') && RGTYP1 == 'Special') {
                //Return SpecRngMin converted to psig
                return convertPressure(SpecRngMin, RTPRSU, 'psig');
            } else if(RGRAT1 == 'Burst Pressure Min/Max.' && RGTYP1 == 'Specify Reference Mfg Range') {
                // TODO: Double-check this method for MfgRngValsB
                //Return  (((((TMR)/(MaxMfgRngMulti from MfgStringB)-(MaxMfgRngAdder from MfgStringB))*(MinMfgRngMulti from MfgStringB)+ (MinMfgRngAdder from MfgStringB))
                if(MfgRngValsB != Null)
                    return (((TMR/MfgRngValsB.MaxMfgRngMulti__c) - MfgRngValsB.MaxMfgRngAdder__c) * MfgRngValsB.MinMfgRngMulti__c) + MfgRngValsB.MinMfgRngAdder__c;
                else
                    return BMR;
            } else if(RGRAT1 == 'Burst Pressure Min/Max.' && RGTYP1 == 'Specify Min') {
                //Return ((BURMIN)/(MinMulti from BurstTolStringD) - (MinAdd from BurstTolStringD))
                return ((BURMIN/BurstTolStringD.MinMulti__c) - BurstTolStringD.MinAdd__c);
            } else if(RGRAT1 == 'Specified' && RGTYP1 == 'Performance Tolerance') {
                //Return ((BURMIN)/(MinMulti from BurstTolStringDElements) - (MinAdd from BurstTolStringD))
                return ((BURMIN/BurstTolStringD.MinMulti__c) - BurstTolStringD.MinAdd__c);
            } else if ((RGRAT1 == 'Rated'|| RGRAT1 == 'Specified') && (RGTYP1!='Performance Tolerance' || RGRAT1 != 'Special') && MfgRngValsA!=null)
                return (convertPressure(RTPRS1, RTPRSU, 'psig')*MfgRngValsA.MinMfgRngMulti__c)+ MfgRngValsA.MinMfgRngAdder__c;
            // else if (RGRAT1 == 'Start/Full Relief (Min/Max)'){
            //     return StartRelief.setScale(2);
            // }

            return BMR;
        }
        set;
    }
    public Decimal VBMR {
        get {
            decimal VBMR=0.0;
            if((VGRAT1 == 'Rated' || VGRAT1 == 'Specified') && VGTYP1 == 'Special') {
                //Return SpecRngMin converted to psig
                return convertPressure(VSpecRngMin, VTPRSU, 'psig');
            } else if(VGRAT1 == 'Burst Pressure Min/Max.' && VGTYP1 == 'Specify Reference Mfg Range') {
                // TODO: Double-check this method for MfgRngValsB
                //Return  (((((TMR)/(MaxMfgRngMulti from MfgStringB)-(MaxMfgRngAdder from MfgStringB))*(MinMfgRngMulti from MfgStringB)+ (MinMfgRngAdder from MfgStringB))
                if(VMfgRngValsB!=Null)
                    return (((VTMR/VMfgRngValsB.MaxMfgRngMulti__c) - VMfgRngValsB.MaxMfgRngAdder__c) * VMfgRngValsB.MinMfgRngMulti__c) + VMfgRngValsB.MinMfgRngAdder__c;
                // else
                //     return VBMR;
            } else if(VGRAT1 == 'Burst Pressure Min/Max.' && VGTYP1 == 'Specify Min') {
                //Return ((BURMIN)/(MinMulti from BurstTolStringD) - (MinAdd from BurstTolStringD))
                return ((VMIN/VBurstTolStringD.MinMulti__c) - VBurstTolStringD.MinAdd__c);
            } else if(VGRAT1 == 'Specified' && VGTYP1 == 'Performance Tolerance') {
                //Return ((BURMIN)/(MinMulti from BurstTolStringDElements) - (MinAdd from BurstTolStringD))
                //if(VBurstTolStringD != Null)
                return ((VMIN/VBurstTolStringD.MinMulti__c) - VBurstTolStringD.MinAdd__c);
                // else
                //     return VBMR;
            } else if ((VGRAT1 == 'Rated'|| VGRAT1 == 'Specified') && (VGTYP1!='Performance Tolerance' || VGRAT1 != 'Special') && VMfgRngValsA!=null)
                return (convertPressure(VTPRS1, VTPRSU, 'psig')*VMfgRngValsA.MinMfgRngMulti__c)+ VMfgRngValsA.MinMfgRngAdder__c;
            return VBMR;
        }
        set;
    }
    // Ratio to locate rated pressure
    public Decimal RefRatedRatio {
        get {
            Decimal RefRatedRatio=0.0;
            Manufacturing_Range_Value__c mfgRngVal = new Manufacturing_Range_Value__c();
            //"RGRAT1"="Rated" AND "RGTYP1"=PTCInfo[7] AND RGEMAXLL<VTMR AND RGEMAXUL>=RGEMAXUL
            if(((RGRAT1 == 'Rated' || RGRAT1 == 'Specified') && (RGTYP1 == 'Special' || RGTYP1 == 'Performance Tolerance')) || (RGRAT1 == 'Burst Pressure Min/Max.' && RGTYP1 == 'Specify Min')) {
                // Return MfgRngValues table values where RGEMAXLL and RGEMAXUL is compared to TMR
                // List<Manufacturing_Range_Value__c> mfgRngVals = [
                //     SELECT MinMfgRngMulti__c, MinMfgRngAdder__c, MaxMfgRngMulti__c, MaxMfgRngAdder__c
                //     FROM Manufacturing_Range_Value__c
                //     WHERE RGEMAXLL__c < :TMR AND RGEMAXUL__c >= :TMR];
                List<Manufacturing_Range_Value__c> mfgRngVals =filterMgfBase (mfgList,'RGEMAX',TMR,true,'Rated',(String) PTC.get('RangeComparison__c'));
                mfgRngVal = mfgRngVals.get(0);
                return ((1 - mfgRngVal.MinMfgRngMulti__c) - mfgRngVal.MinMfgRngAdder__c)/(((1 - mfgRngVal.MinMfgRngMulti__c) - mfgRngVal.MinMfgRngAdder__c) + ((mfgRngVal.MaxMfgRngMulti__c - 1) + mfgRngVal.MaxMfgRngAdder__c));
            } else if((RGRAT1 == 'Rated' || RGRAT1 == 'Specified') && (RGTYP1 != 'Special' || RGTYP1 != 'Performance Tolerance')) {
                // Return MfgRngValues table values where RTPRS1LL and RTPRS1UL is compared to RTPRS1 converted to psig
                Decimal psigPressure = currentRptDisc.Converted_Pressure_Setting__c;
                // List<Manufacturing_Range_Value__c> mfgRngVals = [
                //     SELECT MinMfgRngMulti__c, MinMfgRngAdder__c, MaxMfgRngMulti__c, MaxMfgRngAdder__c
                //     FROM Manufacturing_Range_Value__c
                //     WHERE RTPRS1LL__c < :psigPressure AND RTPRS1UL__c >= :psigPressure];
                List<Manufacturing_Range_Value__c> mfgRngVals =filterMgfBase (mfgList,'RTPRS1',psigPressure,true,RGRAT1,(String) PTC.get('RangeComparison__c'));
                mfgRngVal = mfgRngVals.get(0);
                return (
                    ((1 - mfgRngVal.MinMfgRngMulti__c) - mfgRngVal.MinMfgRngAdder__c) / (((1 - mfgRngVal.MinMfgRngMulti__c) - mfgRngVal.MinMfgRngAdder__c) + ((mfgRngVal.MaxMfgRngMulti__c - 1) + mfgRngVal.MaxMfgRngAdder__c))
                );
            } else if(RGRAT1 == 'Burst Pressure Min/Max.' && RGTYP1 != 'Specify Min'){
                //Return MfgRngValues table values where RGEMAXLL and RGEMAXUL is compared to TMR
                // List<Manufacturing_Range_Value__c> mfgRngVals = [
                //     SELECT MinMfgRngMulti__c, MinMfgRngAdder__c, MaxMfgRngMulti__c, MaxMfgRngAdder__c
                //     FROM Manufacturing_Range_Value__c
                //     WHERE RGEMAXLL__c < :TMR AND RGEMAXUL__c >= :TMR];

                List<Manufacturing_Range_Value__c> mfgRngVals =filterMgfBase (mfgList,'RGEMAX',TMR,true,'Rated',(String) PTC.get('RangeComparison__c'));
                if(mfgRngVals.size()>0) {
                    mfgRngVal = mfgRngVals.get(0);
                    return (((1 - mfgRngVal.MinMfgRngMulti__c) - mfgRngVal.MinMfgRngAdder__c) / (((1 - mfgRngVal.MinMfgRngMulti__c) - mfgRngVal.MinMfgRngAdder__c) + ((mfgRngVal.MaxMfgRngMulti__c - 1) + mfgRngVal.MaxMfgRngAdder__c)));
                }
            }
            return RefRatedRatio;
        }
        set;
    }
    public Decimal VRefRatedRatio {
        get {
            Decimal VRefRatedRatio = 0.0;
            Manufacturing_Range_Value__c mfgRngVal = new Manufacturing_Range_Value__c();
            //"RGRAT1"="Rated" AND "RGTYP1"=PTCInfo[7] AND RGEMAXLL<VTMR AND RGEMAXUL>=RGEMAXUL
            if(((VGRAT1 == 'Rated' || VGRAT1 == 'Specified') && (VGTYP1 == 'Special' || VGTYP1 == 'Performance Tolerance')) || (VGRAT1 == 'Burst Pressure Min/Max.' )) {
                // Return MfgRngValues table values where RGEMAXLL and RGEMAXUL is compared to TMR
                // List<Manufacturing_Range_Value__c> mfgRngVals = [
                //     SELECT MinMfgRngMulti__c, MinMfgRngAdder__c, MaxMfgRngMulti__c, MaxMfgRngAdder__c
                //     FROM Manufacturing_Range_Value__c
                //     WHERE RGEMAXLL__c < :VTMR AND RGEMAXUL__c >= :VTMR];
                List<Manufacturing_Range_Value__c> mfgRngVals =filterMgfBase (mfgList,'RGEMAX',VTMR,false,VGRAT1,VGTYP1);
                if(!mfgRngVals.isEmpty())
                    mfgRngVal = mfgRngVals.get(0);
                return ((1 - mfgRngVal.MinMfgRngMulti__c) - mfgRngVal.MinMfgRngAdder__c)/(((1 - mfgRngVal.MinMfgRngMulti__c) - mfgRngVal.MinMfgRngAdder__c) + ((mfgRngVal.MaxMfgRngMulti__c - 1) + mfgRngVal.MaxMfgRngAdder__c));
            } else if((VGRAT1 == 'Rated' || VGRAT1 == 'Specified') && (VGTYP1 != 'Special' || VGTYP1 != 'Performance Tolerance')) {
                // Return MfgRngValues table values where RTPRS1LL and RTPRS1UL is compared to RTPRS1 converted to psig
                Decimal psigPressure = convertPressure(VTPRS1, VTPRSU, 'psig');
                // List<Manufacturing_Range_Value__c> mfgRngVals = [
                //     SELECT MinMfgRngMulti__c, MinMfgRngAdder__c, MaxMfgRngMulti__c, MaxMfgRngAdder__c
                //     FROM Manufacturing_Range_Value__c
                //     WHERE RTPRS1LL__c < :psigPressure AND RTPRS1UL__c >= :psigPressure];
                List<Manufacturing_Range_Value__c> mfgRngVals =filterMgfBase (mfgList,'RTPRS1',psigPressure,false,VGRAT1,VGTYP1);
                if(!mfgRngVals.isEmpty()) {
                    mfgRngVal = mfgRngVals.get(0);
                    return (
                        ((1 - mfgRngVal.MinMfgRngMulti__c) - mfgRngVal.MinMfgRngAdder__c) / (((1 - mfgRngVal.MinMfgRngMulti__c) - mfgRngVal.MinMfgRngAdder__c) + ((mfgRngVal.MaxMfgRngMulti__c - 1) + mfgRngVal.MaxMfgRngAdder__c))
                    );
                }
            } else if(VGRAT1 == 'Burst Pressure Min/Max.' && VGTYP1 != 'Specify Min'){
                //Return MfgRngValues table values where RGEMAXLL and RGEMAXUL is compared to TMR
                // List<Manufacturing_Range_Value__c> mfgRngVals = [
                //     SELECT MinMfgRngMulti__c, MinMfgRngAdder__c, MaxMfgRngMulti__c, MaxMfgRngAdder__c
                //     FROM Manufacturing_Range_Value__c
                //     WHERE RGEMAXLL__c < :VTMR AND RGEMAXUL__c >= :VTMR];
                List<Manufacturing_Range_Value__c> mfgRngVals =filterMgfBase (mfgList,'RGEMAX',VTMR,false,VGRAT1,VGTYP1);
                if(!mfgRngVals.isEmpty()) {
                    mfgRngVal = mfgRngVals.get(0);
                    return (((1 - mfgRngVal.MinMfgRngMulti__c) - mfgRngVal.MinMfgRngAdder__c) / (((1 - mfgRngVal.MinMfgRngMulti__c) - mfgRngVal.MinMfgRngAdder__c) + ((mfgRngVal.MaxMfgRngMulti__c - 1) + mfgRngVal.MaxMfgRngAdder__c)));
                }
            }
            return VRefRatedRatio;
        }
        set;
    }
    // MfgRngValsC
    public Manufacturing_Range_Value__c MfgRngValsC {
        get {
            Decimal psigPressure = 0.0;
            if((RGRAT1 == 'Rated' || RGRAT1 == 'Specified') && (RGTYP1 != 'Special' && RGTYP1 != 'Performance Tolerance')) {
                // MfgRngValues table values where RTPRS1LL and RTPRS1UL is compared to RTPRS1 converted to psig
                psigPressure = currentRptDisc.Converted_Pressure_Setting__c;
                // List<Manufacturing_Range_Value__c> mfgRngVals = [
                //     SELECT MinMfgRngMulti__c, MinMfgRngAdder__c, MaxMfgRngMulti__c, MaxMfgRngAdder__c
                //     FROM Manufacturing_Range_Value__c
                //     WHERE RTPRS1LL__c <= :psigPressure AND RTPRS1UL__c >= :psigPressure];
                List<Manufacturing_Range_Value__c> mfgRngVals =filterMgfBase (mfgList,'RTPRS1',psigPressure,true,RGRAT1,(String) PTC.get('RangeComparison__c'));
                if(!mfgRngVals.isEmpty())
                    return mfgRngVals.get(0);
            }
            psigPressure = ((TMR - BMR) * RefRatedRatio) + BMR;
           // System.debug('psigPressure MfgRngValsC-->'+psigPressure);
            //System.debug('psigPressure TMR-->'+TMR);
            //System.debug('psigPressure BMR-->'+BMR);
            //nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnndqSystem.debug('psigPressure RefRatedRatio-->'+RefRatedRatio);

            // List<Manufacturing_Range_Value__c> mfgRngVals = [
            //     SELECT MinMfgRngMulti__c, MinMfgRngAdder__c, MaxMfgRngMulti__c, MaxMfgRngAdder__c
            //     FROM Manufacturing_Range_Value__c
            //     WHERE RTPRS1LL__c <= :psigPressure AND RTPRS1UL__c >= :psigPressure];
            List<Manufacturing_Range_Value__c> mfgRngVals =filterMgfBase (mfgList,'RTPRS1',psigPressure,true,'Rated',(String) PTC.get('RangeComparison__c'));
            if(!mfgRngVals.isEmpty())
                return mfgRngVals.get(0);
             else
                return new Manufacturing_Range_Value__c(MinMfgRngMulti__c = 0.0, MinMfgRngAdder__c = 0.0, MaxMfgRngMulti__c = 0.0, MaxMfgRngAdder__c = 0.0);
        }
        set;
    }
    public Manufacturing_Range_Value__c VMfgRngStringC {
        get {
            Decimal psigPressure = 0.0;
            if((VGRAT1 == 'Rated' || VGRAT1 == 'Specified') && (VGTYP1 != 'Special' && VGTYP1 != 'Performance Tolerance')) {
                // MfgRngValues table values where RTPRS1LL and RTPRS1UL is compared to RTPRS1 converted to psig
                psigPressure = convertPressure(VTPRS1, VTPRSU, 'psig');
                // List<Manufacturing_Range_Value__c> mfgRngVals = [
                //     SELECT MinMfgRngMulti__c, MinMfgRngAdder__c, MaxMfgRngMulti__c, MaxMfgRngAdder__c
                //     FROM Manufacturing_Range_Value__c
                //     WHERE RTPRS1LL__c <= :psigPressure AND RTPRS1UL__c >= :psigPressure];
                List<Manufacturing_Range_Value__c> mfgRngVals =filterMgfBase (mfgList,'RTPRS1',psigPressure,true,VGRAT1,(String) PTC.get('RangeComparison__c'));
                if(!mfgRngVals.isEmpty())
                    return mfgRngVals.get(0);
            }
            psigPressure = ((VTMR - VBMR) * VRefRatedRatio) + VBMR;
            // List<Manufacturing_Range_Value__c> mfgRngVals = [
            //     SELECT MinMfgRngMulti__c, MinMfgRngAdder__c, MaxMfgRngMulti__c, MaxMfgRngAdder__c
            //     FROM Manufacturing_Range_Value__c
            //     WHERE RTPRS1LL__c <= :psigPressure AND RTPRS1UL__c >= :psigPressure];
            List<Manufacturing_Range_Value__c> mfgRngVals =filterMgfBase (mfgList,'RTPRS1',psigPressure,true,'Rated',(String) PTC.get('RangeComparison__c'));
            if(!mfgRngVals.isEmpty())
                return mfgRngVals.get(0);
            else
                return new Manufacturing_Range_Value__c(MinMfgRngMulti__c = 0.0, MinMfgRngAdder__c = 0.0, MaxMfgRngMulti__c = 0.0, MaxMfgRngAdder__c = 0.0);
            //return VMfgRngStringC;
        }
        set;
    }
    // LSTMR
    public Decimal LSTMR {
        get {
            if((RGRAT1 == 'Rated' || RGRAT1 == 'Specified') && (RGTYP1 != 'Special' && RGTYP1 != 'Performance Tolerance')) {
                return (currentRptDisc.Converted_Pressure_Setting__c * MfgRngValsC.MaxMfgRngMulti__c) + MfgRngValsC.MaxMfgRngAdder__c;
            }
            return ((((TMR - BMR) * RefRatedRatio) + BMR) * MfgRngValsC.MaxMfgRngMulti__c) + MfgRngValsC.MaxMfgRngAdder__c;
        }
        set;
    }
    public Decimal VLSTMR {
        //"If((RGRAT1 == ""Rated"" OR RGRAT1 == ""Specified"") AND (RGTYP1 <> ""Special"" AND RGTYP1 <> ""Performance Tolerance"") ), Then
        //  Return ((RTPRS1 converted to psig) *(MaxMfgRngMulti from MfgRangeStringC) + (MaxMfgRngAdder from MfgRangeStringC)

        //  Else, Then
        //       Return (((TMR) - (BMR)) * (RefRatedRatio) + (BMR)) * (MaxMfgRngMulti from MfgRangeStringC) + (MaxMfgRngAdder from MfgRangeStringC)"

        get {
            if((VGRAT1 == 'Rated' || VGRAT1 == 'Specified') && (VGTYP1 != 'Special' && VGTYP1 != 'Performance Tolerance')) {
                return (convertPressure(VTPRS1, VTPRSU, 'psig') * VMfgRngStringC.MaxMfgRngMulti__c) + VMfgRngStringC.MaxMfgRngAdder__c;
            }
            System.debug('VTMR -- '+VTMR);
            System.debug('VBMR -- '+VBMR);
            System.debug('VRefRatedRatio -- '+VRefRatedRatio);
            System.debug('VMfgRngStringC.MaxMfgRngMulti__c -- '+VMfgRngStringC.MaxMfgRngMulti__c);
            System.debug('VMfgRngStringC.MaxMfgRngAdder__c -- '+VMfgRngStringC.MaxMfgRngAdder__c);
            return ((((VTMR - VBMR) * VRefRatedRatio) + VBMR) * VMfgRngStringC.MaxMfgRngMulti__c) + VMfgRngStringC.MaxMfgRngAdder__c;
        }
        set;
    }
    // LSBMR
    public Decimal LSBMR {
        get {
            if((RGRAT1 == 'Rated' || RGRAT1 == 'Specified') && (RGTYP1 != 'Special' && RGTYP1 != 'Performance Tolerance')) {

                return (currentRptDisc.Converted_Pressure_Setting__c * MfgRngValsC.MinMfgRngMulti__c) + MfgRngValsC.MinMfgRngAdder__c;
            }
            return ((((TMR - BMR) * RefRatedRatio) + BMR) * MfgRngValsC.MinMfgRngMulti__c) + MfgRngValsC.MinMfgRngAdder__c;
        }
        set;
    }
    public Decimal VLSBMR {
        get {
            if((VGRAT1 == 'Rated' || VGRAT1 == 'Specified') && (VGTYP1 != 'Special' && VGTYP1 != 'Performance Tolerance')) {
                return (convertPressure(VTPRS1, VTPRSU, 'psig') * VMfgRngStringC.MinMfgRngMulti__c) + VMfgRngStringC.MinMfgRngAdder__c;
            }
            return ((((VTMR - VBMR) * VRefRatedRatio) + VBMR) * VMfgRngStringC.MinMfgRngMulti__c) + VMfgRngStringC.MinMfgRngAdder__c;
        }
        set;
    }

    // MfgRngPct
    public Decimal MfgRngPct {
        get {
            if((LSTMR - LSBMR)!=0.0)
                return ((TMR - BMR) / (LSTMR - LSBMR)) * 100;
            else
                return 0.0;
        }
        set;
    }
    public Decimal VMfgRngPct {
        get {
            if((VLSTMR - VLSBMR)!=0.0)
                return ((VTMR - VBMR) / (VLSTMR - VLSBMR)) * 100;
            else
                return 0.0;
        }
        set;
    }
    // AssignedRangeType
    public String AssignedRangeType {
        get {
            String AssignedRangeType = '';
            if(RGRAT1 == 'No Rating But Must Withstand') {
                return 'No Rating But Must Withstand';
            }
            // TODO: REPLACE with switch/case
            // TODO: Make sure these strings match the menu values
            if((String) PTC.get('RangeComparison__c') == 'Standard') {
                if(MfgRngPct >= 100) {
                    return 'Standard';
                } else if(MfgRngPct >= 75) {
                    return 'Special - 3/4 Reduced Range';
                } else if(MfgRngPct >= 50) {
                    return 'Special - 1/2 Reduced Range';
                } else if(MfgRngPct >= 25) {
                    return 'Special - 1/4 Reduced Range';
                } else if(MfgRngPct >= 0) {
                    return 'Zero';
                } else {
                    return 'Range Too narrow';
                }
            } else if((String) PTC.get('RangeComparison__c') == '-10% (-5 psig)') {
                if(MfgRngPct >= 100) {
                    return '-10% (-5 psig)';
                } else if(MfgRngPct >= 50) {
                    return  '-5% (-2.5 psig)';
                } else if(MfgRngPct >= 0) {
                    return 'Zero';
                } else {
                    return 'Range Too narrow';
                }
            } else if((String) PTC.get('RangeComparison__c') == '-10% (-0.6 psig)') {
                if(MfgRngPct >= 100) {
                    return '-10% (-0.6 psig)';
                } else if(MfgRngPct >= 50){
                    return '-5% (-0.3 psig)';
                } else if(MfgRngPct >= 0) {
                    return 'Zero';
                } else {
                    return 'Range Too narrow';
                }
            } else if((String) PTC.get('RangeComparison__c') == '-10%') {
                if(MfgRngPct >= 100) {
                    return '-10%';
                } else if(MfgRngPct >= 50) {
                    return '-5%';
                } else if(MfgRngPct >= 0) {
                    return 'Zero';
                } else {
                    return 'Range Too narrow';
                }
            } else if((String) PTC.get('RangeComparison__c') == 'Zero') {
                if((MfgRngPct) >= 0) {
                    return 'Zero';
                } else {
                    return 'Range Too narrow';
                }
            }
            return AssignedRangeType;
        }
        set;
    }
    public String VAssignedRangeType {
        get {
            String VAssignedRangeType = '';
            if(VGRAT1 == 'No Rating But Must Withstand') {
                return 'No Rating But Must Withstand';
            }
            // TODO: REPLACE with switch/case
            // TODO: Make sure these strings match the menu values
            if((String) PTC.get('RangeComparison__c') == 'Standard' && VGRAT1!=null) {
                if(VMfgRngPct >= 100) {
                    return 'Standard';
                } else if(VMfgRngPct >= 75) {
                    return 'Special - 3/4 Reduced Range';
                } else if(VMfgRngPct >= 50) {
                    return 'Special - 1/2 Reduced Range';
                } else if(VMfgRngPct >= 25) {
                    return 'Special - 1/4 Reduced Range';
                } else if(VMfgRngPct >= 0) {
                    return 'Zero';
                } else {
                    return 'Range Too narrow';
                }
            } else if((String) PTC.get('RangeComparison__c') == '-10% (-5 psig)' && VGRAT1!=null) {
                if(VMfgRngPct >= 100) {
                    return '-10% (-5 psig)';
                } else if(VMfgRngPct >= 50) {
                    return  '-5% (-2.5 psig)';
                } else if(VMfgRngPct >= 0) {
                    return 'Zero';
                } else {
                    return 'Range Too narrow';
                }
            } else if((String) PTC.get('RangeComparison__c') == '-10% (-0.6 psig)' && VGRAT1!=null) {
                if(VMfgRngPct >= 100) {
                    return '-10% (-0.6 psig)';
                } else if(VMfgRngPct >= 50){
                    return '-5% (-0.3 psig)';
                } else if(VMfgRngPct >= 0) {
                    return 'Zero';
                } else {
                    return 'Range Too narrow';
                }
            } else if((String) PTC.get('RangeComparison__c') == '-10%' && VGRAT1!=null) {
                if(VMfgRngPct >= 100) {
                    return '-10%';
                } else if(VMfgRngPct >= 50) {
                    return '-5%';
                } else if(VMfgRngPct >= 0) {
                    return 'Zero';
                } else {
                    return 'Range Too narrow';
                }
            } else if((String) PTC.get('RangeComparison__c') == 'Zero' && VGRAT1!=null) {
                if((VMfgRngPct) >= 0) {
                    return 'Zero';
                } else {
                    return 'Range Too narrow';
                }
            }
            return VAssignedRangeType;
        }
        set;
    }
    // RG1MINReal
    public Decimal RG1MINReal {
        get {
            decimal RG1MINReal=0.000000;
            if(((RGRAT1 == 'Rated' || RGRAT1 == 'Specified') && (RGTYP1 != 'Zero' && RGTYP1 != 'Special' && RGTYP1 != 'Performance Tolerance')) || RGTYP1 == 'Performance Tolerance') {
                //return (convertPressure(BMR, 'psig', RTPRSU)).setScale(6);//Service Tkt 162422,commented 
                return Decimal.valueOf(unitConversions.SignificantDigitsNormal(convertPressure(BMR, 'psig', RTPRSU), 6, 0).dblRetValue); //Service Tkt 162422
            } else if(RGTYP1 == 'Special') {
                return SpecRngMin;
            } else if(RGRAT1 == 'Burst Pressure Min/Max.' && RGTYP1 == 'Specify Min') {
                return BPMMMin;
            } else if(RGRAT1 == 'Burst Pressure Min/Max.' && RGTYP1 == 'Specify Reference Mfg Range') {
                //return (convertPressure(BURMIN, 'psig', RTPRSU)).setScale(6); //Service Tkt 162422,commented
                return Decimal.valueOf(unitConversions.SignificantDigitsNormal(convertPressure(BURMIN, 'psig', RTPRSU), 6, 0).dblRetValue); //Service Tkt 162422
            } else if(RGTYP1 == 'Zero' && RGRAT1 != 'Start/Full Relief (Min/Max)') {
                return RTPRS1.setScale(6);
            } else if(RGRAT1 == 'Start/Full Relief (Min/Max)') {
                // GirdleLimCheck table values based upon MaxPressLL and MaxPressUL being compared to PBurstPressureConverted
                // List<Girdle_Lim_Check__c> girdleLims = [
                //     SELECT GirdleMatl__c, MaxPressLL__c, MaxPressUL__c, RangeInt__c, SizeCode__c
                //     FROM Girdle_Lim_Check__c
                //     WHERE MaxPressLL__c < :PBurstPressureConverted AND MaxPressUL__c >= :PBurstPressureConverted and SizeCode__c=:integer.valueOf(currentSizeCap)];
                
                //Service Ticket #200743, added Rule Criteria when calling filterGirdleLimCheck() method
                List<Girdle_Lim_Check__c> girdleLims = new List<Girdle_Lim_Check__c>(); 
                if(currentProduct == 'CAL'){
                    if(VBurstPressureConverted == null ){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Burst Pressure Value not defined for CAL product'));
                    }else{
                        girdleLims =filterGirdleLimCheck(gList,VBurstPressureConverted);
                    }
                }else{
                    girdleLims =filterGirdleLimCheck(gList,PBurstPressureConverted);
                }
                if(girdleLims.size()>0)
                    return unitConversions.SignificantDigitsDown(FullRelief - convertPressure(girdleLims.get(0).RangeInt__c, 'in. water', RTPRSU),3,0).dblRetValue;
                else
                    return RG1MINReal;
            }
            return RG1MINReal;
        }
        set;
    }
    public Decimal VG1MINReal {
        get {
            Decimal VG1MINReal = 0.000000;
            if(((VGRAT1 == 'Rated' || VGRAT1 == 'Specified') && (VGTYP1 != 'Zero' && VGTYP1 != 'Special' && VGTYP1 != 'Performance Tolerance')) || VGTYP1 == 'Performance Tolerance') {
                //return (convertPressure(VBMR, 'psig', VTPRSU)).setScale(6); //Service Tkt 162422,commented
                return Decimal.valueOf(unitConversions.SignificantDigitsNormal(convertPressure(VBMR, 'psig', VTPRSU), 6, 0).dblRetValue); //Service Tkt 162422
            } else if(VGTYP1 == 'Special') {
                return VSpecRngMin;
            } else if(VGRAT1 == 'Burst Pressure Min/Max.' && VGTYP1 == 'Specify Min') {
                return VBPMMMin;
            } else if(VGRAT1 == 'Burst Pressure Min/Max.' && VGTYP1 == 'Specify Reference Mfg Range') {
                //return (convertPressure(VMIN, 'psig', VTPRSU)).setScale(6); //Service Tkt 162422,commented
                return Decimal.valueOf(unitConversions.SignificantDigitsNormal(convertPressure(VMIN, 'psig', VTPRSU), 6, 0).dblRetValue); //Service Tkt 162422
            } else if(VGTYP1 == 'Zero') {
                return VTPRS1.setScale(6);
            } else if(VGRAT1 == 'Start/Full Relief (Min/Max)') {
                // GirdleLimCheck table values based upon MaxPressLL and MaxPressUL being compared to PBurstPressureConverted
                // List<Girdle_Lim_Check__c> girdleLims = [
                //     SELECT GirdleMatl__c, MaxPressLL__c, MaxPressUL__c, RangeInt__c, SizeCode__c
                //     FROM Girdle_Lim_Check__c
                //     WHERE MaxPressLL__c < :VBurstPressureConverted AND MaxPressUL__c >= :VBurstPressureConverted and SizeCode__c=:integer.valueOf(currentSizeCap)];
                
                //Service Ticket #200743, added Rule Criteria when calling filterGirdleLimCheck() method
                List<Girdle_Lim_Check__c> girdleLims = new List<Girdle_Lim_Check__c>();
                if(currentProduct == 'CAL'){
                    girdleLims =filterGirdleLimCheck(gList,VBurstPressureConverted);
                }else{
                    if(PBurstPressureConverted == null ){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Burst Pressure Value is not defined for non CAL product'));
                    }else{
                        girdleLims =filterGirdleLimCheck(gList,PBurstPressureConverted);
                    }
                }
                
                if(girdleLims.size()>0) {
                    System.debug('VFullRElief'+VFullRelief);
                    System.debug('girdleLims VFullRElief'+girdleLims.get(0).RangeInt__c);
                    System.debug('convertPressure VFullRElief'+convertPressure(girdleLims.get(0).RangeInt__c, 'in. water', VTPRSU));
                    return unitConversions.SignificantDigitsDown(VFullRelief - convertPressure(girdleLims.get(0).RangeInt__c, 'in. water', VTPRSU),3,0).dblRetValue;
                }

                else
                    return VG1MINReal;
            }
            return VG1MINReal;
        }
        set;
    }
    public Decimal RG1MAXReal {
        get {
            Decimal RG1MAXReal=0.000000;
            if(((RGRAT1 == 'Rated' || RGRAT1 == 'Specified') && (RGTYP1 != 'Zero' && RGTYP1 != 'Special' && RGTYP1 != 'Performance Tolerance' && RGTYP1 != '-10% (-5 psig)' && RGTYP1 != '-10% (-0.6 psig)' && RGTYP1 != '-10%' && RGTYP1 != '-5% (-2.5 psig)' && RGTYP1 != '-5% (-0.3 psig)' && RGTYP1 != '-5%') && RTPRSU != '') || RGTYP1 == 'Performance Tolerance') {
                //return (convertPressure(TMR, 'psig', RTPRSU)).setScale(6); //Service Tkt 162422,commented
                return Decimal.valueOf(unitConversions.SignificantDigitsNormal(convertPressure(TMR, 'psig', RTPRSU), 6, 0).dblRetValue); //Service Tkt 162422
            } else if(RGTYP1 == 'Special') {
                return SpecRngMax;
            } else if(RGRAT1 == 'Burst Pressure Min/Max.') {
                return BPMMMax;
            } else if(RGTYP1 == 'Zero' || RGTYP1 == '-10% (-5 psig)' || RGTYP1 != '-10% (-0.6 psig)' || RGTYP1 != '-10%' || RGTYP1 != '-5% (-2.5 psig)' || RGTYP1 != '-5% (-0.3 psig)' || RGTYP1 != '-5%') {
                if(RTPRS1!=null)
                    return RTPRS1.setScale(6);
                else
                    return 0.0;
            } else if(RGRAT1 == 'Start/Full Relief (Min/Max)') {
                return FullRelief.setScale(6);
            }
            return RG1MAXReal;
        }
        set;
    }
    public Decimal VG1MAXReal {
        get {
            Decimal VG1MAXReal=0.000000;
            if(((VGRAT1 == 'Rated' || VGRAT1 == 'Specified') && (VGTYP1 != 'Zero' && VGTYP1 != 'Special' && VGTYP1 != 'Performance Tolerance' && VGTYP1 != '-10% (-5 psig)' && VGTYP1 != '-10% (-0.6 psig)' && VGTYP1 != '-10%' && VGTYP1 != '-5% (-2.5 psig)' && VGTYP1 != '-5% (-0.3 psig)' && VGTYP1 != '-5%') && RTPRSU != '') || VGTYP1 == 'Performance Tolerance') {
                //return (convertPressure(VTMR, 'psig', VTPRSU)).setScale(6); //Service Tkt 162422,commented
                return Decimal.valueOf(unitConversions.SignificantDigitsNormal(convertPressure(VTMR, 'psig', VTPRSU), 6, 0).dblRetValue); //Service Tkt 162422
            } else if(VGTYP1 == 'Special') {
                return VSpecRngMax;
            } else if(VGRAT1 == 'Burst Pressure Min/Max.') {
                return VBPMMMax;
            } else if(VGTYP1 == 'Zero' || VGTYP1 == '-10% (-5 psig)' || VGTYP1 != '-10% (-0.6 psig)' || VGTYP1 != '-10%' || VGTYP1 != '-5% (-2.5 psig)' || VGTYP1 != '-5% (-0.3 psig)' || VGTYP1 != '-5%' &&(VTPRS1!=null)) {
                return VTPRS1.setScale(6);
            } else if(VGRAT1 == 'Start/Full Relief (Min/Max)') {
                return VFullRelief.setScale(6);
            }
            return VG1MAXReal=0.0;
        }
        set;
    }
    // RG1MIN
    public Decimal RG1MIN {
        get {
            decimal RG1MIN=0.0;
            if(RGRAT1 == 'Burst Pressure Min/Max.' && RGTYP1 == 'Specify Min') {
                return RG1MINReal;
               // return unitConversions.multiplyAndAdd(RG1MINReal, 0.5);
            } else if(RGRAT1 == 'Burst Pressure Min/Max.' && RGTYP1 == 'Specify Reference Mfg Range') {
                //return unitConversions.multiplyAndAdd(RG1MINReal, 0.5);
                return unitConversions.SignificantDigitsNormal(RG1MINReal, 3, 0).dblRetValue;
            } else if(RGRAT1 == 'Start/Full Relief (Min/Max)' || RGRAT1 == 'No Rating') {
                //return unitConversions.multiplyAndAdd(RG1MINReal, 0.5);
                return RG1MINReal;
            } else if(RGTYP1 == 'Special' || RGTYP1 == 'Zero') {
                //return unitConversions.multiplyAndAdd(RG1MINReal, 0.5);
                return RG1MINReal;
            } else if(RGTYP1 == 'Standard' || RGTYP1 == 'Special - 3/4 Reduced Range' || RGTYP1 == 'Special - 1/2 Reduced Range' || RGTYP1 == 'Special - 1/4 Reduced Range' || RGTYP1 == '-10% (-0.6 psig)' || RGTYP1 == '-10% (-5 psig)' || RGTYP1 == '-5% (-2.5 psig)' || RGTYP1 == '-5% (-0.3 psig)' || RGTYP1 == '-10%' || RGTYP1 == '-5%') {
                //return unitConversions.multiplyAndAdd(RG1MINReal, 0.5);
                return unitConversions.SignificantDigitsNormal(RG1MINReal, 3, 0).dblRetValue;
            } else if(RGRAT1 == 'Specified' && RGTYP1 == 'Performance Tolerance' && PerfTolUOM == 'Percent') {
                return unitConversions.SignificantDigitsNormal(RG1MINReal, 3, 0).dblRetValue;
            } else if(RGRAT1 == 'Specified' && RGTYP1 == 'Performance Tolerance' && PerfTolUOM == 'Specified Burst Pressure Units') {
                return unitConversions.SignificantDigitsNormal(RG1MINReal, 3, 0).dblRetValue;
            }
            return RG1MIN;
        }
        set;
    }
    public Decimal VG1MIN {
        get {
            if(VGRAT1 == 'Burst Pressure Min/Max.' && VGTYP1 == 'Specify Min') {
                //return unitConversions.multiplyAndAdd(VG1MINReal, 0.5);
                return VG1MINReal;
            } else if(VGRAT1 == 'Burst Pressure Min/Max.' && VGTYP1 == 'Specify Reference Mfg Range') {
                //return unitConversions.multiplyAndAdd(VG1MINReal, 0.5);
                return unitConversions.SignificantDigitsNormal(VG1MINReal, 3, 0).dblRetValue;
            } else if(VGRAT1 == 'Start/Full Relief (Min/Max)' || VGRAT1 == 'No Rating') {
               // return unitConversions.multiplyAndAdd(VG1MINReal, 0.5);
               return VG1MINReal;
            } else if(VGTYP1 == 'Special' || VGTYP1 == 'Zero') {
                //return unitConversions.multiplyAndAdd(VG1MINReal, 0.5);
                return VG1MINReal;
            } else if(VGTYP1 == 'Standard' || VGTYP1 == 'Special - 3/4 Reduced Range' || VGTYP1 == 'Special - 1/2 Reduced Range' || VGTYP1 == 'Special - 1/4 Reduced Range' || VGTYP1 == '-10% (-0.6 psig)' || VGTYP1 == '-10% (-5 psig)' || VGTYP1 == '-5% (-2.5 psig)' || VGTYP1 == '-5% (-0.3 psig)' || VGTYP1 == '-10%' || VGTYP1 == '-5%') {
                //return unitConversions.multiplyAndAdd(VG1MINReal, 0.5);
                return unitConversions.SignificantDigitsNormal(VG1MINReal, 3, 0).dblRetValue;
            } else if(VGRAT1 == 'Specified' && VGTYP1 == 'Performance Tolerance' && VPerfTolUOM == 'Percent') {
                //return unitConversions.multiplyAndAdd(VG1MINReal, 0.5);
                return unitConversions.SignificantDigitsNormal(VG1MINReal, 3, 0).dblRetValue;
            } else if(VGRAT1 == 'Specified' && VGTYP1 == 'Performance Tolerance' && VPerfTolUOM == 'Specified Burst Pressure Units') {
                //return unitConversions.multiplyAndAdd(VG1MINReal, 0.5);
                return unitConversions.SignificantDigitsNormal(VG1MINReal, 3, 0).dblRetValue;
            }
            return VG1MIN=0.0;
        }
        set;
    }
    // RG1MAX
    public Decimal RG1MAX {
        get {
            if(RGRAT1 == 'Burst Pressure Min/Max.' || RGRAT1 == 'No Rating' || RGRAT1 == 'Start/Full Relief (Min/Max)') {
               // return unitConversions.multiplyAndAdd(RG1MAXReal, 0.5);
               return RG1MAXReal;
            } else if(RGTYP1 == 'Special' || RGTYP1 == 'Zero') {
               // return unitConversions.multiplyAndAdd(RG1MAXReal, 0.5);
               return RG1MAXReal;
            } else if(RGTYP1 == 'Standard' || RGTYP1 == 'Special - 3/4 Reduced Range' || RGTYP1 == 'Special - 1/2 Reduced Range' || RGTYP1 == 'Special - 1/4 Reduced Range') {
                //return unitConversions.multiplyAndAdd(RG1MAXReal, 0.5);
                return unitConversions.SignificantDigitsNormal(RG1MAXReal, 3, 0).dblRetValue;
            } else if(RGTYP1 == '-10% (-0.6 psig)' || RGTYP1 == '-10% (-5 psig)' || RGTYP1 == '-5% (-2.5 psig)' || RGTYP1 == '-5% (-0.3 psig)' || RGTYP1 == '-10%' || RGTYP1 == '-5%') {
                //return unitConversions.multiplyAndAdd(RG1MAXReal, 0.5);
                return RG1MAXReal;
            } else if(RGRAT1 == 'Specified' && RGTYP1 == 'Performance Tolerance' && PerfTolUOM == 'Percent') {
                //return unitConversions.multiplyAndAdd(RG1MAXReal, 0.5);
                return unitConversions.SignificantDigitsNormal(RG1MAXReal, 3, 0).dblRetValue;
            } else if(RGRAT1 == 'Specified' && RGTYP1 == 'Performance Tolerance' && PerfTolUOM == 'Specified Burst Pressure Units') {
                //return unitConversions.multiplyAndAdd(RG1MAXReal, 0.5);
                return unitConversions.SignificantDigitsNormal(RG1MAXReal, 3, 0).dblRetValue;
            }
            return RG1MAX = 0.0;
        }
        set;
    }
    public Decimal VG1MAX {
        get {
            if(VGRAT1 == 'Burst Pressure Min/Max.' || VGRAT1 == 'No Rating' || VGRAT1 == 'Start/Full Relief (Min/Max)') {
                //return unitConversions.multiplyAndAdd(VG1MAXReal, 0.5);
                return VG1MAXReal;
            } else if(VGTYP1 == 'Special' || VGTYP1 == 'Zero') {
                //return unitConversions.multiplyAndAdd(VG1MAXReal, 0.5);
                return VG1MAXReal;
            } else if(VGTYP1 == 'Standard' || VGTYP1 == 'Special - 3/4 Reduced Range' || VGTYP1 == 'Special - 1/2 Reduced Range' || VGTYP1 == 'Special - 1/4 Reduced Range') {
                //return unitConversions.multiplyAndAdd(VG1MAXReal, 0.5);
                return unitConversions.SignificantDigitsNormal(VG1MAXReal, 3, 0).dblRetValue;
            } else if(VGTYP1 == '-10% (-0.6 psig)' || VGTYP1 == '-10% (-5 psig)' || VGTYP1 == '-5% (-2.5 psig)' || VGTYP1 == '-5% (-0.3 psig)' || VGTYP1 == '-10%' || VGTYP1 == '-5%') {
                //return unitConversions.multiplyAndAdd(VG1MAXReal, 0.5);
                return VG1MAXReal;
            } else if(VGRAT1 == 'Specified' && VGTYP1 == 'Performance Tolerance' && VPerfTolUOM == 'Percent') {
                //return unitConversions.multiplyAndAdd(VG1MAXReal, 0.5);
                return unitConversions.SignificantDigitsNormal(VG1MAXReal, 3, 0).dblRetValue;
            } else if(VGRAT1 == 'Specified' && VGTYP1 == 'Performance Tolerance' && VPerfTolUOM == 'Specified Burst Pressure Units') {
                //return unitConversions.multiplyAndAdd(VG1MAXReal, 0.5);
                return unitConversions.SignificantDigitsNormal(VG1MAXReal, 3, 0).dblRetValue;
            }
            return VG1MAX=0.0;
        }
        set;
    }
    // Press Start Relief Pressure (Min)
    public Decimal StartRelief {
        get {
            if(RGRAT1 == 'Start/Full Relief (Min/Max)') {
                return RG1MIN;
            }
            return StartRelief = 0.0;
        }
        set;
    }
    public Decimal VStartRelief {
        get {
            if(VGRAT1 == 'Start/Full Relief (Min/Max)') {
                return VG1MIN;
            }
            return VStartRelief = 0.0;
        }
        set;
    }
    // RG2MINReal
    public Decimal RG2MINReal {
        get {
            return (convertPressure(RG1MIN, RTPRSU, PPressureBaseUOM)).setScale(6);
        }
        set;
    }
    public Decimal VG2MINReal {
        get {
            return (convertPressure(VG1MIN, VTPRSU, VPressureBaseUOM)).setScale(6);
        }
        set;
    }
    // RG2MAXReal
    public Decimal RG2MAXReal {
        get {
            return (convertPressure(RG1MAX, RTPRSU, PPressureBaseUOM)).setScale(6);
        }
        set;
    }
    public Decimal VG2MAXReal {
        get {
            return (convertPressure(VG1MAX, VTPRSU, VPressureBaseUOM)).setScale(6);
        }
        set;
    }
    // AvgMfgRange
    public Decimal AvgMfgRange {
        get {
            if(RGRAT1 == 'Burst Pressure Min/Max.'){
                return ((RG2MINReal + RG2MAXReal) / 2).setScale(6);
            }
            return PBurstPressureConverted.setScale(6);
        }
        set;
    }
    public Decimal VAvgMfgRange {
        get {
            if(RGRAT1 == 'Burst Pressure Min/Max.'){
                return ((VG2MINReal + VG2MAXReal) / 2).setScale(6);
            }
            return VBurstPressureConverted.setScale(6);
        }
        set;
    }
    /** START EXTRA ATTRS **/
    /*
public Disc_Information__c DiscInfo {
get {
if(DiscInfo == null) {
//              0           1             2                 3               4               5                 6               7
return [
SELECT SealThck__c, SealMatl__c, SecondSealMatl__c, SlotCovMatl__c, SlotCovThck__c, OutLinerMatl__c, OutLinerThck__c, SCStripThck__c
FROM Disc_Information__c
WHERE PTC__c=:currentProduct AND SZC__c=:currentSizeCap AND MfgRngLL__c<=:RGEMIN AND MfgRngUL__c>:RGEMIN AND TempLL__c<=:RGEMIN AND TempUL__c>:RTTMDF
];
}
return DiscInfo;
}
set;
}
*/
    //  NOTE: This is still in BML format, and has yet to be translated
    public Map<String,String> BomMatlCode {
        get {
            //Get values from the PTC
            return BomMatlCode;
            /*
String composite = PTC.get('Composite__c');
String bidir = PTC.get('BidirFlag__c');
String prodCode = PTC.get('ProductLevel__c');
//Get values from the ComponentReqFlagsInfoString
ComponentInfoElements = string[];
if(componentReqFlagsInfoString <> "") {
IOSplit = split(componentReqFlagsInfoString, IODelimiter);
if(sizeofarray(IOSplit) == 2){
ComponentInfoElements = split(IOSplit[1], valDelimiter);
}
}
discRequired = "";
topSectionRequired = "";
sealRequired = "";
inletORingRequired = "";
if(sizeofarray(ComponentInfoElements) == 23){
discRequired = componentInfoElements[10];
topSectionRequired = componentInfoElements[11];
sealRequired = componentInfoElements[12];
inletORingRequired = componentInfoElements[20];
}

//Find Selected Inlet and Outlet Options
discInOut = "";
topSectionInOut = "";
sealInOut = "";
inletORingInOut = "";
if(PTC <> "" AND DSCVAR <> "" AND SizeValue > 0 AND COOUT <> "" AND COIN <> ""){
selectCols = string[]{"OptionCode", "OptionString"};
whereCols = string[]{"PTC", "DSCVAR", "SizeLL", "SizeUL"};
whereVals = string[]{PTC, DSCVAR, string(SizeValue), string(SizeValue)};
whereComps = string[]{"=", "=", "<", ">="};
retTbl = gettabledata("tblOptions", selectCols, whereCols, whereVals, whereComps);
if(sizeofarray(retTbl) > 0){
for row in retTbl{
if(discInOut == "" AND (row[0] == COIN OR row[0] == COOUT) AND find(row[1], "Disc") <> -1){
discInOut = "Yes";
}
elif(topSectionInOut == "" AND (row[0] == COIN OR row[0] == COOUT) AND find(row[1], "Top Section") <> -1){
topSectionInOut = "Yes";
}
elif(sealInOut == "" AND (row[0] == COIN OR row[0] == COOUT) AND find(row[1], "Seal") <> -1){
sealInOut = "Yes";
}
elif(inletORingInOut == "" AND row[0] == COIN AND find(row[1], "Inlet Ring") <> -1){
inletORingInOut = "Yes";
}
}
}
}

//Set a range of the number of components and declare the output array
iRange = range(BOMDescCtrl2);
compMatlCodes = string[];

//Get list of components
componentStr = getarrayattrstring(BOMComponent);
componentArr = split(componentStr, "$,$");

//Loop over all components
for index in iRange{
component = componentArr[index];
if(componentArr[index] == "Seal (Metal)" OR componentArr[index] == "Teflon Seal"){
component = "Seal";
}
if(CompScreenText1 == component){
compMatlCodes[index] = Comp1MatlSelect;
}
elif(CompScreenText2 == component){
compMatlCodes[index] = Comp2MatlSelect;
}
elif(CompScreenText3 == component){
compMatlCodes[index] = Comp3MatlSelect;
}
elif(CompScreenText4 == component){
compMatlCodes[index] = Comp4MatlSelect;
}
elif(CompScreenText5 == component){
compMatlCodes[index] = Comp5MatlSelect;
}
elif(CompScreenText6 == component){
compMatlCodes[index] = Comp6MatlSelect;
}
elif(CompScreenText7 == component){
compMatlCodes[index] = Comp7MatlSelect;
}
elif(CompScreenText8 == component){
compMatlCodes[index] = Comp8MatlSelect;
}
elif(CompScreenText9 == component){
compMatlCodes[index] = Comp9MatlSelect;
}
elif(CompScreenText10 == component){
compMatlCodes[index] = Comp10MatSelect;
}
elif(CompScreenText11 == component){
compMatlCodes[index] = Comp11MatlSelect;
}
elif(CompScreenText12 == component){
compMatlCodes[index] = Comp12MatlSelect;
}
elif(CompScreenText13 == component){
compMatlCodes[index] = Comp13MatlSelect;
}
elif(CompScreenText14 == component){
compMatlCodes[index] = Comp14MatlSelect;
}
elif(CompScreenText15 == component){
compMatlCodes[index] = Comp15MatlSelect;
}
else{
compMatlCodes[index] = "";
}
}


//Special Cases
//Inlet Liner [6]
if(PTC == "SLS"){
compMatlCodes[6] = "";
}
//Inlet Coating[8]
compMatlCodes[8] = "";

//Outlet Coating[9]
compMatlCodes[9] = "";

//RVI Gasket
if(PTC=="SRV" or PTC =="RVT"){
compMatlCodes[9] = "71";
}
// changed slot cover material logic - cdm 6/27/11
SlotCovermatl = "";
If (ProdCode == "CAL-VAC" or ProdCode == "POS-A-SET"){
if (DSCVAR == "S" or DSCVAR == "V"){
slotCoverMatl = "73";
}
else {
slotCoverMatl = "";
}
compMatlCodes[19]=slotCoverMatl;
}
else {


vSCInfo= DiscInfoElements[3];

if(ScOnOff == "On" AND bidir == "No"){
if (vSCInfo=="Metal" or compMatlCodes[13]<>""){
if (compMatlCodes[13] == "01" OR compMatlCodes[13] == "12"){    //MP-1002 4.3.6 Rev AI  if metal seal is 01 or 12 then slot cover matl matches seal
compMatlCodes[19] = compMatlCodes[13];
}
//Added logic so that is the pressure for a CDC is too high and automatically adds a Metal seal, a metal slot cover is used. ACG 1/8/14
elif ((compMatlCodes[14] == "70" or compMatlCodes[14] == "71" or compMatlCodes[14] == "72" or compMatlCodes[14] == "73") AND BOMPartNo[13] =="" ){
if(compMatlCodes[14] =="70"){
compMatlCodes[19]= DiscInfoElements[1];
}
else{
compMatlCodes[19] = compMatlCodes[14];

}
}

else{

compMatlCodes[19] = compMatlCodes[11];
}
}
else {
compMatlCodes[19] = vSCInfo;
}
}

elif(ScOnOff == "On" AND bidir == "Yes"){
if(slotCoverMatl == "Metal" AND (compMatlCodes[13] == "01" OR compMatlCodes[13] == "12")){  //MP-1002 4.3.6 Rev AI
compMatlCodes[19] = compMatlCodes[13];
}
elif(slotCoverMatl == "Metal" AND compMatlCodes[13] <> "01" AND compMatlCodes[13] <> "12"){ //MP-1002 4.3.6 Rev AI
compMatlCodes[19] = compMatlCodes[11];
}
elif(compMatlCodes[13] == ""){  //MP-1002 4.3.6 Rev AI
if(slotCoverMatl <> ""){
selectCols = string[]{"MatlCode"};
whereCols = string[]{"Matl"};
whereVals = string[]{slotCoverMatl};
matlRetTbl = gettabledata("MatlList", selectCols, whereCols, whereVals);
if(sizeofarray(matlRetTbl) > 0){
compMatlCodes[19] = matlRetTbl[0][0];
}
}
}
}

}

print compMatlCodes[19];

//Disc[10]
if((compMatlCodes[10] == "" AND DiscMatl == "") OR (discRequired <> "R" AND discInOut == "")){
compMatlCodes[10] = "";
}
elif(DiscMatl <> "" AND (discRequired == "R" OR discInOut == "Yes")){
compMatlCodes[10] = DiscMatl;
}

//Top Section[11]
if(compMatlCodes[11] == "" OR (topSectionRequired <> "R" AND topSectionInOut == "")){
compMatlCodes[11] = "";
}

//Seal[12]
if(compMatlCodes[12] == "" OR (sealRequired <> "R" AND sealInOut == "")){
compMatlCodes[12] = "";
}

//Metal Seal[13]
if(compMatlCodes[12] == "" OR SealMetalTeflon_ND <> "Metal"){
compMatlCodes[13] = "";
}
if(BOMEngMatl_ND[13]<>""){
compMatlCodes[13] = BOMEngMatl_ND[13];
}
//Teflon Seal[14]
//If customer specified seal material is not Teflon then don't add teflon seal
if(compMatlCodes[12] <> "70" AND compMatlCodes[12] <> "71" AND compMatlCodes[12] <> "72" AND compMatlCodes[12] <> "73"){
compMatlCodes[14] = "";
}

//For CalVac PosASet always assign FEP(73) until inventory tells us to switch to PFA(72)
if(compMatlCodes[14] == "70" and (PTC=="CAL" or PTC=="PAS")){
compMatlCodes[14] = "73";
}
//If Teflon is selected then this will not set 70 to MCST, also the value returned will will be used in the BOM Part No - ZSR 3/14/2011
if(compMatlCodes[12] == "70"){
if(sizeofarray(PTCInfoElements) == 32 AND sizeofarray(DiscInfoElements) == 8){
if(BOMPTC[14] <> "" AND not isnull(BOMPTC[14]) AND PTCInfoElements[14] == "No" AND PTCInfoElements[18] == "Yes"){
compMatlCodes[14] = DiscInfoElements[1];
}
elif(BOMPTC[14] <> "" AND not isnull(BOMPTC[14]) AND PTCInfoElements[14] == "Yes" AND PTC <> "CAL" AND PTC <> "PAS"){
compMatlCodes[14] = DiscInfoElements[1];
}
}
}

//Teflon Girdle[15]
//Always assign FEP(73) until inventory tells us to switch to PFA(72)
//Inventory has told us to make the above switch. changed material to PFA(72). ACG 1/10/2014
if(compMatlCodes[15] == "70"){
compMatlCodes[15] = "72";
}

//Girdle Cover[17]
// changed girdle cover logic - cdm 6/27/2011
compMatlCodes[17] = "";
if(compMatlCodes[15] <> ""){
if (compMatlCodes[15] == "70" OR compMatlCodes[15] == "71" OR compMatlCodes[15] == "72" OR compMatlCodes[15] == "73"){
compMatlcodes[17] = "";
}
else {
compMatlCodes[17] = "73";
}
}




//Slot Cover Strips[18]
compMatlCodes[18] = "";
if(sCStripsOnOff == "On"){  //MP-1002 4.3.17 Rev AI
compMatlCodes[18] = compMatlCodes[11];
}



//Slot Cover 2[20]
compMatlCodes[20] = "";
if(compMatlCodes[19] <> "" AND SC2OnOff == "On"){
compMatlCodes[20] =  compMatlCodes[19];
}

//Vacuum Support [21]
if(PTC == "GFS" OR PTC == "SLS" OR PTC == "RE2"){
compMatlCodes[21] = "";
}

//Inlet O-Ring[26]
if(compMatlCodes[26] == "" OR (inletORingRequired <> "R" AND inletORingInOut == "")){
compMatlCodes[26] = "";
}

//Return the output array
return compMatlCodes;
*/
        }
        set;
    }
    // TODO: Find this guy's actual value; figure out how to fix this
    public Decimal DiscMatl {  // Aluminum [01], 316 SS[05], 316L SS[50], Nickel [04], Alloy 600 (Inc) [03], Alloy 400 (Mon)[02], Alloy B (Hast B) [06], Alloy C726 (Hast C) [07], Alloy C22 (Hast C22) [81], Tantalum [08], Titanium [09], Graphite [43], Fluoropolymer (Tef) [70], Silver [12]
        get {
            if(RTTMDF > 500){
                return 1;
            }
            return 70;
        }
        set;
    }
    // TODO: Get this value from RDMasterBlaster__c
    public List<Derate_Value__c> getDerateBaseData() {
        List<Derate_Value__c> derateList=new List<Derate_Value__c>();
        String DerateType = (String) PTC.get('DerateType__c');
        Decimal STempConv = convertTemperature(RTTMSP, RTTMUN, 'Deg F');
        derateList= [SELECT MatlCode__c, TempLL__c, TempUL__c, DerateType__c, Derate__c FROM Derate_Value__c WHERE  TempLL__c<=:STempConv AND TempUL__c>:STempConv AND DerateType__c=:DerateType];
        return derateList;
    }
    public List<Derate_Value__c> getDerateList=new List<Derate_Value__c>();
    public decimal filterDerate (List<Derate_Value__c> baseData,string matlCode) {
        for (Derate_Value__c dt : baseData) {
            if (String.IsNotBlank(matlCode)) {
                if (matlCodeProcessor(dt.MatlCode__c)==matlCodeProcessor(matlCode)) {
                    return dt.Derate__c;
                }
            }

        }
        return 0;
    }
    public string matlCodeProcessor(string key) {
        string ky1;
        if(key.length()==1)
            ky1='00'+key;
        else if(key.length()==2)
            ky1='0'+key;
        else
            ky1=key;
        return ky1;
    }
    public String MCDT1 {
        get {
            return currentRptDisc.Material_Top_Section__c    ;
        }
        set {
            currentRptDisc.Material_Top_Section__c = value;
            this.MCDT1 = value;
        }
    }
    public String MCDD {
        get {
            return currentRptDisc.Material_Disc__c;
        }
        set {
            currentRptDisc.Material_Disc__c = value;
            this.MCDD = value;
        }
    }
    public String MCSS2 {
        get {
            return currentRptDisc.Material_Seal2__c;
        }
        set {
            currentRptDisc.Material_Seal2__c = value;
            this.MCSS2 = value;
        }
    }
    public String MCSS3 {
        get {
            return currentRptDisc.Material_Seal3__c;
        }
        set {
            currentRptDisc.Material_Seal3__c = value;
            this.MCSS3 = value;
        }
    }
    public String MCSS1 {
        get {
            return currentRptDisc.Material_Seal__c;
        }
        set {
            currentRptDisc.Material_Seal__c = value;
            this.MCSS1 = value;
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
    public list<Disc_Information__c> sealList{get;set;}
    public list<Disc_Information__c> sealMaterial() {
        integer sc=integer.valueOf(currentSizeCap);
        string prd=(string) PTC.get('PTC__c');
        Disc_Information__c[] DiscList=[select SealMatl__c,MfgRngLL__c,MfgRngUL__c from Disc_Information__c where PTC__c=:prd AND SZC__c=:ConstantsUtil.getSizeDesc(String.valueOf(sc)).SZC AND TempLL__c<=:RTTMDF AND TempUL__c>:RTTMDF];
        return DiscList;
    }
    public string filterSealMaterial(Disc_Information__c[] dList,decimal decRGEMIN) {
        string strSeal='';
        for(Disc_Information__c discI:dList) {
            if(discI.MfgRngLL__c<=decRGEMIN && discI.MfgRngUL__c>=decRGEMIN) {
                strSeal=discI.SealMatl__c+'';
                break;
            }
        }
        return strSeal;
    }
    public string MCST {
        get {
            string strMCST='';
            integer sc=integer.valueOf(currentSizeCap);
            string prd=(string) PTC.get('PTC__c');
            if(MCSS=='071' || MCSS=='072' || MCSS=='073')
                return MCSS;
            else if(MCSS=='070' && prd!='CAL' && prd!='PAS') {
                // Disc_Information__c[] DiscList=[select SealMatl__c from Disc_Information__c where PTC__c=:prd AND SZC__c=:ConstantsUtil.getSizeDesc(String.valueOf(sc)).SZC AND  MfgRngLL__c<=:RGEMIN AND MfgRngUL__c>:RGEMIN AND TempLL__c<=:RTTMDF AND TempUL__c>:RTTMDF];
                // return DiscList[0].SealMatl__c+'';
                if(RGEMIN!=null)
                    return filterSealMaterial(sealList,RGEMIN);
                else
                    return '';
            }
            else if(MCSS=='070' && (prd=='CAL' && prd=='PAS'))
                return '073';
            return strMCST;
        }
        set {
            this.MCST = value;
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
    public String MCDT2 {
        get {
            return currentRptDisc.Material_Top_Section2__c;
        }
        set {
            currentRptDisc.Material_Top_Section2__c = value;
            this.MCDT2 = value;
        }
    }
    public string MCD {
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
            this.MCD = value;
        }
    }
    List<String> myStrings = new List<String>{'070','071','072','073'};
        List<String> prodList = new List<String>{'CPC','CPS','CPR','CFC','CFR','CFS','EV1','EV2','EV3','LI1','LI2','PCS','TKS'};
            public boolean addMetalSealCheck{set;get;}
    public boolean isMetalCheck(string mtlcheck) {
        boolean bln=false;
        for(RD_Seals_Component_Materials__c sl:sealCompMaterials) {
            if((sl.PressLL__c<=TMRCHECK && sl.PressUL__c>=BMRCHECK) && sl.MatlCode__c==mtlcheck) {
                if(sl.Add_Metal_Seal__c=='Yes')
                    bln=true;
            }
        }
        return bln;
    }
    public List<RD_Seals_Component_Materials__c> getSealData() {
        List<RD_Seals_Component_Materials__c> sealList = new List<RD_Seals_Component_Materials__c>();
        String strQuery = 'Select id,MatlCode__c,Add_Metal_Seal__c,PressLL__c,PressUL__c from RD_Seals_Component_Materials__c where PTC__c=\''+currentRptDisc.product__c+'\' and STC__c=\''+currentRptDisc.seat__c+'\' and SZC__c=\''+ConstantsUtil.getSizeDesc(String.valueOf(currentRptDisc.size__c)).SZC+'\' AND SealUpperTemp__c>='+currentRptDisc.Converted_Temperature_Setting__c;
        String isFlag=currentRptDisc.Non_Fragmenting_Design_Required__c?'Yes':'No';
        if(currentRptDisc.Non_Fragmenting_Design_Required__c)
            strQuery+=' AND Non_Fragmenting__c=\''+isFlag+'\'';
        sealList=Database.query(strQuery);
        return sealList;
    }

    public string MCSM {
        get {
            string strMCSM='';
            if(!myStrings.contains(MCSS))
                return strMCSM=MCSS;
            else if(myStrings.contains(MCSS) && (!prodList.contains((string) PTC.get('PTC__c'))) && ((string) PTC.get('Composite__c')=='Yes') && addMetalSealCheck)
                return strMCSM=MCDT;
            else
                return strMCSM;
        }
        set {
            this.MCSM = value;
        }
    }
    public Decimal DiscTSDerate {
        get {
            // String DerateType = (String) PTC.get('DerateType__c');
            // if(String.isNotBlank(DerateType) && String.isNotBlank(RTTMUN)) {
            //     Decimal STempConv = convertTemperature(RTTMSP, RTTMUN, 'Deg F');
            //     List<Derate_Value__c> derateValues = [SELECT MatlCode__c, TempLL__c, TempUL__c, DerateType__c, Derate__c FROM Derate_Value__c WHERE MatlCode__c=:DiscMatl AND TempLL__c<=:STempConv AND TempUL__c>:STempConv AND DerateType__c=:DerateType];
            //     if(!derateValues.isEmpty())
            //         return derateValues.get(0).Derate__c;
            // }
            if (MCD!=null)
                return filterDerate(getDerateList,MCD);
            else {
                return 0.0;
            }
        }
        set;
    }
    public Decimal VDiscTSDerate {
        get {
            return DiscTSDerate;
        }
        set;
    }
    public String SEALCK {
        get {
            /*
Boolean isZook = PTC.get('ZookProduct__c') == 'Yes';
if(!isZook) {
returnValue = 'NA';
} else if((BOMMatlCode[12] == '70' || BOMMatlCode[12] == '71'
|| BOMMatlCode[12] == '72' || BOMMatlCode[12] == '73' || BOMMatlCode[12] == '' || BOMMatlCode[12] == '45')) {
returnValue = 'Teflon';
} else if(BOMMatlCode[12] != '') {
returnValue = 'Metal';
} else if(PTC == 'CAL' || PTC == 'PAS') {
returnValue = 'CALPOS';
}
*/
            return SEALCK;
        }
        set;
    }
    public Decimal MetalSealDerate {
        get {
            if (string.isNotBlank(MCSM)) {
                return filterDerate(getDerateList,MCSM);
            }
            else {
                return MetalSealDerate = 0.0;
            }
        }
        set;
    }
    public Decimal TeflonValue {
        get {
            //System.debug('RDMasterBlasterT'+RDMasterBlasterT.Teflon_Ambient__c);
            if (RDMasterBlasterT!=null) {
                return RDMasterBlasterT.Teflon_Ambient__c;
            }
            return TeflonValue = 0.0;
        }
        set;
    }
    public Decimal TeflonDerate {
        get {
            return filterDerate(getDerateList,'070');
        }
        set;
    }

    public Decimal VTeflonValue {
        get {
            return TeflonValue;
        }
        set;
    }
    public Decimal VTeflonDerate {
        get {
            return TeflonDerate;
        }
        set;
    }

    public Decimal SizeValue {
        get {
            return SizeValue;
        }
        set;
    }

    //AvgMfgRange = if(RGRAT1 == ""Burst Pressure Min/Max.""){(RG2MINReal + RG2MAXReal) / 2;} else{PBurstPressureConverted;}
    public Decimal RG3DRT {
        get {
            String DerateType = (String) PTC.get('DerateType__c');
            if(DiscTSDerate!=null)
                system.debug('RG3DRT Value On Rating&Range Cls@2200 DiscTSDerate'+DiscTSDerate);
            if((String) PTC.get('PTC__c') == 'PAS') {
                return 0;
            } else if((DerateType == 'REV' || DerateType == 'MCX' || DerateType == 'RCS') && DiscTSDerate != null) {
                return (DiscTSDerate*100).setScale(1);
            } else if(DerateType == 'TEN' && DiscTSDerate != null && (string.isNotBlank(MCSM) &&MetalSealDerate!=null)) {
                return (100*((DiscTSDerate + MetalSealDerate) / 2).setScale(3)).setScale(1);
                // } else if(DerateType == 'TEN' && string.isBlank(MCSM) && string.isNotBlank(MCST) && AvgMfgRange != null && AvgMfgRange != 0.0 && TeflonValue!=null && TeflonDerate!=null && DiscTSDerate!=null && DiscTSDerate!=0 && (((AvgMfgRange - (TeflonValue * TeflonDerate)) / DiscTSDerate) + TeflonValue)!= 0 && DiscTSDerate != 0) {
            }
            else if(DerateType == 'TEN' && string.isBlank(MCSM) && string.isNotBlank(MCST) && DiscTSDerate != 0 && DiscTSDerate != null) {
                System.debug('TEFLON CHECK------>>>');
                System.debug('TEFLON CHECK AvgMfgRange------>>>'+AvgMfgRange);
                System.debug('TEFLON CHECK------>>> TeflonValue'+TeflonValue);
                System.debug('TEFLON CHECK------>>> TeflonDerate'+TeflonDerate);
                System.debug('TEFLON CHECK------>>> DiscTSDerate'+DiscTSDerate);
                // return (100*((AvgMfgRange / (((AvgMfgRange - (TeflonValue * TeflonDerate)) / DiscTSDerate) + TeflonValue)).setScale(3)))).setScale(1);
                decimal intVal1=(AvgMfgRange - (TeflonValue * TeflonDerate));
                decimal intVal2=intVal1/DiscTSDerate;
                decimal intVal3=intVal2+TeflonValue;
                decimal intVal4=AvgMfgRange/intVal3.setScale(3);
                intVal4=intVal4*100;
                return intVal4.setScale(1);
            } else if(DerateType == 'TEN' && ( string.isBlank(MCSM) && string.isBlank(MCST) && DiscTSDerate != null) ) {
                return (DiscTSDerate*100).setScale(1);
            } else if((String) PTC.get('PTC__c') == 'CAL' && (RGRAT1 == 'No Rating' || RGRAT1 == 'No Rating But Must Withstand' ||string.isBlank(RGRAT1))){
                return 100;
            } else if((String) PTC.get('PTC__c') == 'CAL' && (RGRAT1 != 'No Rating' || RGRAT1 != 'No Rating But Must Withstand') && AvgMfgRange!=null && AvgMfgRange != 0.0 && TeflonValue!=null && TeflonDerate!=null && DiscTSDerate!=null && AvgMfgRange - (TeflonValue * TeflonDerate) != 0 && DiscTSDerate != 0){
                return (100*((AvgMfgRange / (((AvgMfgRange - (TeflonValue * TeflonDerate)) / DiscTSDerate) + TeflonValue)).setScale(3))).setScale(1);
            }
            else
                return 0.0;
        }
        set;
    }
    public Decimal VG3DRT {
        get{
            if (String.IsBlank(VGRAT1)) {
                return 0.0;
            } else if((String) PTC.get('PTC__c') == 'EV2' || (String) PTC.get('PTC__c') == 'EV3' || (String) PTC.get('PTC__c') == 'LI2') {
                return RG3DRT;
            } else if((String) PTC.get('PTC__c') == 'PAS' && (VGRAT1 == 'No Rating' || VGRAT1 == 'No Rating But Must Withstand')) {
                return 100;
            } else if((String) PTC.get('PTC__c') == 'PAS' && (VGRAT1 != 'No Rating' )){
                if (VAvgMfgRange!=0 && VAvgMfgRange - (VTeflonValue * VTeflonDerate) != 0 && VDiscTSDerate != 0)
                    return (100*((VAvgMfgRange / (((VAvgMfgRange - (VTeflonValue * VTeflonDerate)) / VDiscTSDerate) + TeflonValue)).setScale(3))).setScale(1);
                else
                    return 0.0;
            } else {
                return 0.0;
            }
        }
        set{
            this.VG3DRT=value;
        }
    }
    /** END EXTRA ATTRS **/

    public Decimal RG3MINReal {
        get {
            if(RG3DRT!=0.0)
                return (RG2MINReal / (RG3DRT/100)).setScale(6); //[note RG3DRT is derate value not defined in this document]
            else
                return 0.000000;
        }
        set;
    }

    public Decimal VG3MINReal {
        get {
            if(VG3DRT!=0.0)
                return (VG2MINReal / (VG3DRT/100)).setScale(6); //[note RG3DRT is derate value not defined in this document]
            else
                return 0.0;
        }
        set;
    }

    public Decimal RG3MAXReal {
        get {
            if(RG3DRT!=0.0)
                return (RG2MAXReal / (RG3DRT/100)).setScale(6); //[note RG3DRT is derate value not defined in this document]
            else
                return 0.0;
        }
        set;
    }
    public Decimal VG3MAXReal {
        get {
            if(VG3DRT!=0.0)
                return (VG2MAXReal / (VG3DRT/100)).setScale(6); //[note RG3DRT is derate value not defined in this document]
            else
                return 0.0;
        }
        set;
    }
    public Decimal SRPZeroRangeRuleMin {
        get {
            decimal SRPZeroRangeRuleMin=0.0;
            String ShopRngType = (String) PTC.get('PTC__c');
            Decimal pCheck = 0.0;
            if(RGRAT1 == 'Rated' || RGRAT1 == 'Specified') {
                pCheck = (RG2MAXReal + RG2MINReal)/2;
                if((currentProduct != 'CFC' && currentProduct != 'SFC') || ((currentProduct == 'CFC' || currentProduct == 'SFC') && (SizeValue > 16.0)))    {
                    // List<RD_ShopRangeValues__c> shopRngVals = [
                    //     SELECT ShopRngBottomAdd__c, ShopRngBottomMulti__c, ShopRngPressLL__c, ShopRngPressUL__c, ShopRngTopAdd__c, ShopRngTopMulti__c, PTC__c
                    //     FROM RD_ShopRangeValues__c
                    //     WHERE PTC__c=:ShopRngType AND ShopRngPressLL__c<:pCheck AND ShopRngPressUL__c>=:pCheck];
                    List<RD_ShopRangeValues__c> shopRngVals =filterShopRangeValues(pCheck,shpList,ShopRngType);
                    if(!shopRngVals.isEmpty())
                        return (pCheck * shopRngVals.get(0).ShopRngBottomMulti__c) + shopRngVals.get(0).ShopRngBottomAdd__c;
                    else
                        return 0.0;
                }
                if((currentProduct == 'CFC' || currentProduct == 'SFC') && (SizeValue <= 16.0)) {
                    return pCheck - 1.0;
                }
            }
            if(RGRAT1 == 'Burst Pressure Min/Max.') {
                if((currentProduct != 'CFC' && currentProduct != 'SFC') || ((currentProduct == 'CFC' || currentProduct == 'SFC') && (SizeValue > 16.0)))    {
                    pCheck = (TMR + BMR)/2;
                    // List<RD_ShopRangeValues__c> shopRngVals = [
                    //     SELECT ShopRngBottomAdd__c, ShopRngBottomMulti__c, ShopRngPressLL__c, ShopRngPressUL__c, ShopRngTopAdd__c, ShopRngTopMulti__c, PTC__c
                    //     FROM RD_ShopRangeValues__c
                    //     WHERE PTC__c=:ShopRngType AND ShopRngPressLL__c<:pCheck AND ShopRngPressUL__c>=:pCheck];
                    List<RD_ShopRangeValues__c> shopRngVals =filterShopRangeValues(pCheck,shpList,ShopRngType);
                    if(!shopRngVals.isEmpty())
                        return (pCheck * shopRngVals.get(0).ShopRngBottomMulti__c) + shopRngVals.get(0).ShopRngBottomAdd__c;
                    else
                        return 0.0;
                }
                if((currentProduct == 'CFC' || currentProduct == 'SFC') && (SizeValue <= 16.0)) {
                    return pCheck - 1.0;
                }
            }
            return SRPZeroRangeRuleMin;
        }
        set;
    }
    public Decimal VSRPZeroRangeRuleMin {
        get {
            String ShopRngType = (String) PTC.get('PTC__c');
            Decimal pCheck = 0.0;
            if(VGRAT1 == 'Rated' || VGRAT1 == 'Specified') {
                pCheck = (VG2MAXReal + VG2MINReal)/2;
                if((currentProduct != 'CFC' && currentProduct != 'SFC') || ((currentProduct == 'CFC' || currentProduct == 'SFC') && (SizeValue > 16.0)))    {

                    List<RD_ShopRangeValues__c> shopRngVals =filterShopRangeValues(pCheck,shpList,ShopRngType);
                    if(!shopRngVals.isEmpty())
                        return (pCheck * shopRngVals.get(0).ShopRngBottomMulti__c) + shopRngVals.get(0).ShopRngBottomAdd__c;
                    else
                        return 0.0;
                }
                if((currentProduct == 'CFC' || currentProduct == 'SFC') && (SizeValue <= 16.0)) {
                    return pCheck - 1.0;
                }
            }
            if(VGRAT1 == 'Burst Pressure Min/Max.') {
                pCheck = (VTMR + VBMR)/2;
                if((currentProduct != 'CFC' && currentProduct != 'SFC') || ((currentProduct == 'CFC' || currentProduct == 'SFC') && (SizeValue > 16.0)))    {
                    // List<RD_ShopRangeValues__c> shopRngVals = [
                    //     SELECT ShopRngBottomAdd__c, ShopRngBottomMulti__c, ShopRngPressLL__c, ShopRngPressUL__c, ShopRngTopAdd__c, ShopRngTopMulti__c, PTC__c
                    //     FROM RD_ShopRangeValues__c
                    //     WHERE PTC__c=:ShopRngType AND ShopRngPressLL__c<:pCheck AND ShopRngPressUL__c>=:pCheck];
                    List<RD_ShopRangeValues__c> shopRngVals =filterShopRangeValues(pCheck,shpList,ShopRngType);
                    if(!shopRngVals.isEmpty())
                        return (pCheck * shopRngVals.get(0).ShopRngBottomMulti__c) + shopRngVals.get(0).ShopRngBottomAdd__c;
                    else
                        return 0.0;
                }
                if((currentProduct == 'CFC' || currentProduct == 'SFC') && (SizeValue <= 16.0)) {
                    return pCheck - 1.0;
                }
            }
            return VSRPZeroRangeRuleMin=0.0;
        }
        set;
    }
    public Decimal SRPZeroRangeRuleMax {
        get {
            decimal SRPZeroRangeRuleMax=0.0;
            String ShopRngType = (String) PTC.get('PTC__c');
            Decimal pCheck = 0.0;
            if(RGRAT1 == 'Rated' || RGRAT1 == 'Specified') {
                pCheck = (RG2MAXReal + RG2MINReal)/2;
                if((currentProduct != 'CFC' && currentProduct != 'SFC') || ((currentProduct == 'CFC' || currentProduct == 'SFC') && (SizeValue > 16.0))) {
                    List<RD_ShopRangeValues__c> shopRngVals =filterShopRangeValues(pCheck,shpList,ShopRngType);
                    if(!shopRngVals.isEmpty())
                        return (pCheck * shopRngVals.get(0).ShopRngTopMulti__c) + shopRngVals.get(0).ShopRngTopAdd__c;
                    else
                        return 0.0;
                }
                if((currentProduct == 'CFC' || currentProduct == 'SFC') && (SizeValue <= 16.0)) {
                    return pCheck + 1.0;
                }
            }
            if(RGRAT1 == 'Burst Pressure Min/Max.') {
                pCheck = (TMR + BMR)/2;
                if((currentProduct != 'CFC' && currentProduct != 'SFC') || ((currentProduct == 'CFC' || currentProduct == 'SFC') && (SizeValue > 16.0))) {
                    // List<RD_ShopRangeValues__c> shopRngVals = [
                    //     SELECT ShopRngBottomAdd__c, ShopRngBottomMulti__c, ShopRngPressLL__c, ShopRngPressUL__c, ShopRngTopAdd__c, ShopRngTopMulti__c, PTC__c
                    //     FROM RD_ShopRangeValues__c
                    //     WHERE PTC__c=:ShopRngType AND ShopRngPressLL__c<:pCheck AND ShopRngPressUL__c>=:pCheck];
                    List<RD_ShopRangeValues__c> shopRngVals =filterShopRangeValues(pCheck,shpList,ShopRngType);
                    if(!shopRngVals.isEmpty())
                        return (pCheck * shopRngVals.get(0).ShopRngTopMulti__c) + shopRngVals.get(0).ShopRngTopAdd__c;
                    else
                        return 0.0;
                }
                if((currentProduct == 'CFC' || currentProduct == 'SFC') && (SizeValue <= 16.0)) {
                    return pCheck + 1.0;
                }
            }
            return SRPZeroRangeRuleMax;
        }
        set;
    }
    public Decimal VSRPZeroRangeRuleMax {
        get {
            String ShopRngType = (String) PTC.get('PTC__c');
            Decimal pCheck = 0.0;
            if(VGRAT1 == 'Rated' || VGRAT1 == 'Specified') {
                pCheck = (VG2MAXReal + VG2MINReal)/2;
                if((currentProduct != 'CFC' && currentProduct != 'SFC') || ((currentProduct == 'CFC' || currentProduct == 'SFC') && (SizeValue > 16.0)))    {
                    List<RD_ShopRangeValues__c> shopRngVals =filterShopRangeValues(pCheck,shpList,ShopRngType);
                    if(!shopRngVals.isEmpty())
                        return (pCheck * shopRngVals.get(0).ShopRngTopMulti__c) + shopRngVals.get(0).ShopRngTopAdd__c;
                    else
                        return 0.0;
                }
                if((currentProduct == 'CFC' || currentProduct == 'SFC') && (SizeValue <= 16.0)) {
                    return pCheck + 1.0;
                }
            }
            if(VGRAT1 == 'Burst Pressure Min/Max.') {
                pCheck = (VTMR + VBMR)/2;
                if((currentProduct != 'CFC' && currentProduct != 'SFC') || ((currentProduct == 'CFC' || currentProduct == 'SFC') && (SizeValue > 16.0)))    {
                    List<RD_ShopRangeValues__c> shopRngVals =filterShopRangeValues(pCheck,shpList,ShopRngType);
                    if(!shopRngVals.isEmpty())
                        return (pCheck * shopRngVals.get(0).ShopRngTopMulti__c) + shopRngVals.get(0).ShopRngTopAdd__c;
                    else
                        return 0.0;
                }
                if((currentProduct == 'CFC' || currentProduct == 'SFC') && (SizeValue <= 16.0)) {
                    return pCheck + 1.0;
                }
            }
            return VSRPZeroRangeRuleMax=0.0;
        }
        set;
    }
    public Decimal SRPBTRangeRuleMin {
        get {
            if(RGRAT1 == 'No Rating') {
                return 0;
            } else if(RGRAT1 == 'Burst Pressure Min/Max.'){
                return BMR;
            } else {
                return RG2MinReal;
            }
        }
        set;
    }
    public Decimal VSRPBTRangeRuleMin {
        get {
            if(VGRAT1 == 'No Rating') {
                return 0;
            } else if(VGRAT1 == 'Burst Pressure Min/Max.'){
                return VBMR;
            } else {
                return VG2MinReal;
            }
        }
        set;
    }
    public Decimal SRPBTRangeRuleMax {
        get {
            if(RGRAT1 == 'No Rating') {
                return 0.0;
            } else if(RGRAT1 == 'Burst Pressure Min/Max.') {
                return TMR;
            } else {
                return RG2MaxReal;
            }
        }
        set{
            this.SRPBTRangeRuleMax=value;
        }

    }
    public Decimal VSRPBTRangeRuleMax {
        get {
            if(VGRAT1 == 'No Rating') {
                return 0;
            } else if(VGRAT1 == 'Burst Pressure Min/Max.') {
                return VTMR;
            } else {
                return VG2MaxReal;
            }
        }
        set;
    }
    public Decimal RGEMinReal {
        get {
            if(currentProduct != 'PAS') {
                if(SRPBTRangeRuleMax - SRPBTRangeRuleMin >= SRPZeroRangeRuleMax - SRPZeroRangeRuleMin) {
                    return SRPBTRangeRuleMin.setScale(6);
                } else {
                    return SRPZeroRangeRuleMin.setScale(6);
                }
            }
            return RG2MinReal;
        }
        set;
    }
    public Decimal VGEMinReal {
        get {
            if(currentProduct != 'PAS') {
                if(VSRPBTRangeRuleMax - VSRPBTRangeRuleMin >= VSRPZeroRangeRuleMax - VSRPZeroRangeRuleMin) {
                    return VSRPBTRangeRuleMin.setScale(6);
                } else {
                    return VSRPZeroRangeRuleMin.setScale(6);
                }
            }
            return VG2MinReal;
        }
        set;
    }

    public Decimal RGEMaxReal {
        get {
            if(currentProduct != 'PAS') {
                if((SRPBTRangeRuleMax - SRPBTRangeRuleMin) >= (SRPZeroRangeRuleMax - SRPZeroRangeRuleMin)) {
                    return SRPBTRangeRuleMax.setScale(6);
                } else {
                    return SRPZeroRangeRuleMax.setScale(6);
                }
            }
            return RG2MaxReal;
        }
        set;
    }
    public Decimal VGEMaxReal {
        get {
            if(currentProduct != 'PAS') {
                if(VSRPBTRangeRuleMax - VSRPBTRangeRuleMin >= VSRPZeroRangeRuleMax - VSRPZeroRangeRuleMin) {
                    return VSRPBTRangeRuleMax.setScale(6);
                } else {
                    return VSRPZeroRangeRuleMax.setScale(6);
                }
            }
            return VG2MaxReal;
        }
        set;
    }
    public Decimal RGSMinREal {
        get {
            if(RG3DRT!=0.0)
                return (RGEMinReal/(RG3DRT/100)).setScale(6); // [note RG3DRT is derate value not defined in this document];
            else
                return 0.000000;
        }
        set;
    }
    public Decimal VGSMinReal {
        get {
            if(VG3DRT!=0.0)
                return (VGEMinReal/(VG3DRT/100)).setScale(6); // [note RG3DRT is derate value not defined in this document];
            else
                return 0.000000;
        }
        set;
    }
    public Decimal RGSMaxReal {
        get {
            if(RG3DRT!=0.0)
                return (RGEMaxReal / (RG3DRT/100)).setScale(6); // [note RG3DRT is derate value not defined in this document]
            else
                return 0.000000;
        }
        set;
    }
    public Decimal VGSMaxReal {
        get {
            if(VG3DRT!=0.0)
                return (VGEMaxReal / (VG3DRT/100)).setScale(6); // [note RG3DRT is derate value not defined in this document]
            else
                return 0.000000;
        }
        set;
    }
    public Decimal RG2MIN {
        get {
            // if(RGTYP1 == 'Zero') {
            //     return RG2MINReal;
            // }
            return unitConversions.SignificantDigitsNormal(RG2MINReal, 3, 0).dblRetValue;
        }
        set;
    }
    public Decimal VG2MIN {
        get {
            // if(VGTYP1 == 'Zero') {
            //     return VG2MINReal;
            // }
            return unitConversions.SignificantDigitsNormal(VG2MINReal, 3, 0).dblRetValue;
        }
        set;
    }
    public Decimal RG2MAX {
        get {
            // if(RGTYP1 == 'Zero') {
            //     return RG2MAXReal;
            // }
            return unitConversions.SignificantDigitsNormal(RG2MAXReal, 3, 0).dblRetValue;
        }
        set;
    }
    public Decimal VG2MAX {
        get {
            // if(VGTYP1 == 'Zero') {
            //     return VG2MAXReal;
            // }
            return unitConversions.SignificantDigitsNormal(VG2MAXReal, 3, 0).dblRetValue;
        }
        set;
    }
    public Decimal RG3MIN {
        get {
            // if(RGTYP1 == 'Zero') {
            //     return RG3MINReal;
            // }
            return unitConversions.SignificantDigitsNormal(RG3MINReal, 3, 0).dblRetValue;
        }
        set;
    }
    public Decimal VG3MIN {
        get {
            // if(VGTYP1 == 'Zero') {
            //     return VG3MINReal;
            // }
            return unitConversions.SignificantDigitsNormal(VG3MINReal, 3, 0).dblRetValue;
        }
        set;
    }
    public Decimal RG3MAX {
        get {
            // if(RGTYP1 == 'Zero') {
            //     return RG3MAXReal;
            // }
            return unitConversions.SignificantDigitsNormal(RG3MAXReal, 3, 0).dblRetValue;
        }
        set;
    }
    public Decimal VG3MAX {
        get {
            // if(VGTYP1 == 'Zero') {
            //     return VG3MAXReal;
            // }
            return unitConversions.SignificantDigitsNormal(VG3MAXReal,3, 0).dblRetValue;
        }
        set;
    }
    public Decimal RGEMIN {
        get {
            return unitConversions.SignificantDigitsUp(RGEMINReal,3, 0).dblRetValue;
        }
        set;
    }
    public Decimal VGEMIN {
        get {
            return unitConversions.SignificantDigitsUp(VGEMINReal, 3, 0).dblRetValue;
        }
        set;
    }
    public Decimal RGEMAX {
        get {
            return unitConversions.SignificantDigitsDown(RGEMAXReal, 3, 0).dblRetValue;
        }
        set;
    }
    public Decimal VGEMAX {
        get {
            return unitConversions.SignificantDigitsDown(VGEMAXReal, 3, 0).dblRetValue;
        }
        set;
    }
    public Decimal RGSMIN {
        get {
            return unitConversions.SignificantDigitsUp(RGSMINReal,  3, 0).dblRetValue;
        }
        set;
    }
    public Decimal VGSMIN {
        get {
            return unitConversions.SignificantDigitsUp(VGSMINReal, 3, 0).dblRetValue;
        }
        set;
    }
    public Decimal RGSMAX {
        get {
            return unitConversions.SignificantDigitsDown(RGSMaxReal,  3, 0).dblRetValue;
        }
        set;
    }
    public Decimal VGSMAX {
        get {
            return unitConversions.SignificantDigitsDown(VGSMAXReal, 3, 0).dblRetValue;
        }
        set;
    }

    public String ORP010 {
        get {
            //[bidir == value lookup from table DiscTypeList based upon PTC]
            String bidir = (String) PTC.get('BidirFlag__c');
            String sign = '';
            if(RTTMSP < 0.0) {
                sign = 'MINUS ';
            }
            if(bidir == 'yes' && RGRAT1 == 'Rated') {
                return 'POS. RATED: ' + RTPRS1.stripTrailingZeros().toPlainString()  + ' ' + RTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            } else if(bidir == 'no' && RGRAT1 == 'Rated') {
                return 'RATED: ' + RTPRS1.stripTrailingZeros().toPlainString() + ' ' + RTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            } else if(bidir == 'yes' && RGRAT1 == 'Specified') {
                return 'POS SPECIFIED: ' + RTPRS1.stripTrailingZeros().toPlainString() + ' ' + RTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            } else if(bidir == 'no' && RGRAT1 == 'Specified') {
                return 'SPECIFIED: ' + RTPRS1.stripTrailingZeros().toPlainString() + ' ' + RTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            } else if(bidir == 'yes' && RGRAT1 == 'Burst Pressure Min/Max.') {
                return 'POS. BURST PRESSURE: ';
            } else if(bidir == 'no' && RGRAT1 == 'Burst Pressure Min/Max.') {
                return 'BURST PRESSURE: ';
            } else if(bidir == 'yes' && RGRAT1 == 'Start/Full Relief (Min/Max)') {
                return 'POS PRESSURE RATING: ';
            } else if(RGRAT1 == 'No Rating' || RGRAT1 == 'No Rating But Must Withstand') {
                return 'No rating in the POS direction but must withstand: ';
            }
            return ORP010;
        }
        set;
    }
    public String ORV010 {
        get {
            //[bidir == value lookup from table DiscTypeList based upon PTC]
            String bidir = (String) PTC.get('BidirFlag__c');
            String sign = '';
            if(RTTMSP < 0.0) {
                sign = 'MINUS ';
            }
            if(bidir == 'yes' && VGRAT1 == 'Rated') {
                return 'VAC. RATED: ' + VTPRS1.stripTrailingZeros().toPlainString() + ' ' + VTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            } else if(bidir == 'no' && VGRAT1 == 'Rated') {
                return 'RATED: ' + VTPRS1.stripTrailingZeros().toPlainString() + ' ' + VTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            } else if(bidir == 'yes' && VGRAT1 == 'Specified') {
                return 'VAC SPECIFIED: ' + VTPRS1.stripTrailingZeros().toPlainString() + ' ' + VTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            } else if(bidir == 'no' && VGRAT1 == 'Specified') {
                return 'SPECIFIED: ' + VTPRS1.stripTrailingZeros().toPlainString() + ' ' + VTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            } else if(bidir == 'yes' && VGRAT1 == 'Burst Pressure Min/Max.') {
                return 'VAC. BURST PRESSURE: ';
            } else if(bidir == 'no' && VGRAT1 == 'Burst Pressure Min/Max.') {
                return 'BURST PRESSURE: ';
            } else if(bidir == 'yes' && VGRAT1 == 'Start/Full Relief (Min/Max)') {
                return 'VAC PRESSURE RATING: ';
            } else if(VGRAT1 == 'No Rating' || VGRAT1 == 'No Rating But Must Withstand') {
                return 'No rating in the VAC direction but must withstand: ';
            }
            return ORV010;
        }
        set;
    }
    public String ORP015 {
        get {
            String sign = '';
            if(RTTMSP < 0.0) {
                sign = 'MINUS ';
            }
            if(RGRAT1 == 'Burst Pressure Min/Max.' && RGTYP1 == 'Specify Min') {
                return '  ' + BPMMMin.stripTrailingZeros().toPlainString() + ' MIN to ' + BPMMMax.stripTrailingZeros().toPlainString() + ' MAX ' + RTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            } else if(RGRAT1 == 'Burst Pressure Min/Max.' && RGTYP1 == 'Specify Reference Mfg Range' && BURMIN != null) {
                result res1=unitConversions.SignificantDigitsNormal(convertPressure(BURMIN, 'psig', RTPRSU),3,0); // Service Ticket # 162422 changed to 0 from -99
             
	        return '  ' + String.valueOf(res1.dblRetValue) + ' MIN to ' + BPMMMax.stripTrailingZeros().toPlainString() + ' MAX ' + RTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString()+ ' ' + RTTMUN; //Service Tkt# 162422
            } else if(RGRAT1 == 'No Rating But Must Withstand' && RGRATW != null) {
                return '  ' + RGRATW.stripTrailingZeros().toPlainString() + ' ' + RGRATU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' '  + RTTMUN; //Service Tkt# 162422
            } else if(RGRAT1 == 'No Rating') {
                return '0 PSIG  @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            } else if(RGRAT1 == 'Start/Full Relief (Min/Max)' && StartRelief != null && FullRelief != null) {
                return '  ' + StartRelief.stripTrailingZeros().toPlainString() + ' MIN to ' + FullRelief.stripTrailingZeros().toPlainString() + ' MAX ' + RTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString()+ ' ' + RTTMUN; //Service Tkt# 162422
            }
            return ORP015;
        }
        set;
    }
    public String ORV015 {
        get {
            String sign = '';
            if(RTTMSP < 0.0) {
                sign = 'MINUS ';
            }
            if(VGRAT1 == 'Burst Pressure Min/Max.' && VGTYP1 == 'Specify Min') {
                return '  ' + VBPMMMin.stripTrailingZeros().toPlainString() + ' MIN to ' + VBPMMMax.stripTrailingZeros().toPlainString() + ' MAX ' + VTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            } else if(VGRAT1 == 'Burst Pressure Min/Max.' && VGTYP1 == 'Specify Reference Mfg Range' && VMIN != null) {
                result res1=unitConversions.SignificantDigitsNormal(convertPressure(VMIN, 'psig', VTPRSU),3,-99);
                
                return '  ' + String.valueOf(res1.dblRetValue) + ' MIN to ' + VBPMMMax.stripTrailingZeros().toPlainString() + ' MAX ' + VTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            } else if(VGRAT1 == 'No Rating But Must Withstand' && VGRATW != null) {
                return '  ' + VGRATW.stripTrailingZeros().toPlainString() + ' ' + VGRATU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            } else if(VGRAT1 == 'No Rating') {
                return '0 PSIG  @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' '+ RTTMUN; //Service Tkt# 162422
            } else if(VGRAT1 == 'Start/Full Relief (Min/Max)' && VStartRelief != null && VFullRelief != null) {
                return '  ' + VStartRelief.stripTrailingZeros().toPlainString() + ' MIN to ' + VFullRelief.stripTrailingZeros().toPlainString() + ' MAX ' + VTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString()+ ' ' + RTTMUN; //Service Tkt# 162422
            }
            return ORV015;
        }
        set;
    }
    public String ORP020A {
        get {
            if(PBurstPressureConverted >= 6 && RGTYP1 == '-10% (-0.6 psig)') {
                return '-10% MFG. RNG.: ';
            } else if(PBurstPressureConverted >= 6 && RGTYP1 == '-5% (-0.3 psig)') {
                return '-5% MFG. RNG.: ';
            } else if(PBurstPressureConverted < 6 && RGTYP1 == '-10% (-0.6 psig)') {
                return '-0.6 PSIG MFG. RNG.: ';
            } else if(PBurstPressureConverted < 6 && RGTYP1 == '-5% (-0.3 psig)') {
                return '-0.3 PSIG MFG. RNG.: ';
            } else if(PBurstPressureConverted >= 50 && RGTYP1 == '-10% (-5 psig)') {
                return '-10% MFG. RNG.: ';
            } else if(PBurstPressureConverted >= 50 && RGTYP1 == '-5% (-2.5 psig)') {
                return '-5% MFG. RNG.: ';
            } else if(PBurstPressureConverted < 50 && RGTYP1 == '-10% (-5 psig)') {
                return '-5 PSIG MFG. RNG.: ';
            } else if(PBurstPressureConverted < 50 && RGTYP1 == '-5% (-2.5 psig)') {
                return '-2.5 PSIG MFG. RNG.: ';
            } else if(RGTYP1 == '-10%') {
                return '-10% MFG. RNG.: ';
            } else if(RGTYP1 == '-5%') {
                return '-5% MFG. RNG.: ';
            } else {
                return '';
            }
        }
        set;
    }
    public String ORV020A {
        get {
            if(VBurstPressureConverted >= 6 && VGTYP1 == '-10% (-0.6 psig)') {
                return '-10% MFG. RNG.: ';
            } else if(VBurstPressureConverted >= 6 && VGTYP1 == '-5% (-0.3 psig)') {
                return '-5% MFG. RNG.: ';
            } else if(VBurstPressureConverted < 6 && VGTYP1 == '-10% (-0.6 psig)') {
                return '-0.6 PSIG MFG. RNG.: ';
            } else if(VBurstPressureConverted < 6 && VGTYP1 == '-5% (-0.3 psig)') {
                return '-0.3 PSIG MFG. RNG.: ';
            } else if(VBurstPressureConverted >= 50 && VGTYP1 == '-10% (-5 psig)') {
                return '-10% MFG. RNG.: ';
            } else if(VBurstPressureConverted >= 50 && VGTYP1 == '-5% (-2.5 psig)') {
                return '-5% MFG. RNG.: ';
            } else if(VBurstPressureConverted < 50 && VGTYP1 == '-10% (-5 psig)') {
                return '-5 PSIG MFG. RNG.: ';
            } else if(VBurstPressureConverted < 50 && VGTYP1 == '-5% (-2.5 psig)') {
                return '-2.5 PSIG MFG. RNG.: ';
            } else if(VGTYP1 == '-10%') {
                return '-10% MFG. RNG.: ';
            } else if(VGTYP1 == '-5%') {
                return '-5% MFG. RNG.: ';
            } else {
                return '';
            }
        }
        set;
    }

    public String ORP020 {
        get {
            String sign = '';
            if(RTTMSP < 0.0) {
                sign = 'MINUS ';
            }
            if(RGTYP1 == 'Standard')
                return 'MFG. RNG.: ' + RG1MIN.stripTrailingZeros().toPlainString() + ' To '+ RG1MAX.stripTrailingZeros().toPlainString() + ' ' + RTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            if(RGTYP1 == 'Zero')
                return 'ZERO MANUFACTURING RANGE';
            if(RGTYP1=='-10% (-5 Psig)' || RGTYP1=='-10% (-0.6 Psig)' || RGTYP1=='-5% (-2.5 Psig)' || RGTYP1=='-5% (-0.3 Psig)' || RGTYP1=='-10%' || RGTYP1=='-5%')
                return ORP020A + ' ' + RG1MIN.stripTrailingZeros().toPlainString() + ' To ' + RG1MAX.stripTrailingZeros().toPlainString() + ' ' + RTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            if( (RGTYP1 == 'Special') || (RGTYP1 == 'Special - 3/4 Reduced Range') || (RGTYP1 == 'Special - 1/2 Reduced Range') || (RGTYP1 == 'Special - 1/4 Reduced Range'))
                return 'SPEC. MFG. RNG.:';
            if(RGTYP1 == 'Performance Tolerance')
                if(RG1MIN == RG1MAX)
                return 'ZERO MANUFACTURING RANGE';
            else
                return 'SPEC. MFG. RNG.:';
            else
                return '';
        }
        set;
    }

    public String ORV020 {
        get {
            String sign = '';
            if(RTTMSP < 0.0) {
                sign = 'MINUS ';
            }
            if(VGTYP1 == 'Standard')
                return 'MFG. RNG.: ' + VG1MIN.stripTrailingZeros().toPlainString() + ' To '+ VG1MAX.stripTrailingZeros().toPlainString() + ' ' + VTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            if(VGTYP1 == 'Zero')
                return 'ZERO MANUFACTURING RANGE';
            if(VGTYP1=='-10% (-5 Psig)' || VGTYP1=='-10% (-0.6 Psig)' || VGTYP1=='-5% (-2.5 Psig)' || VGTYP1=='-5% (-0.3 Psig)' || VGTYP1=='-10%' || VGTYP1=='-5%')
                return ORP020A + ' ' + VG1MIN.stripTrailingZeros().toPlainString() + ' To ' + VG1MAX.stripTrailingZeros().toPlainString() + ' ' + VTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            if( (VGTYP1 == 'Special') || (VGTYP1 == 'Special - 3/4 Reduced Range') || (VGTYP1 == 'Special - 1/2 Reduced Range') || (VGTYP1 == 'Special - 1/4 Reduced Range'))
                return 'SPEC. MFG. RNG.:';
            if(VGTYP1 == 'Performance Tolerance')
                if(VG1MIN == VG1MAX)
                return 'ZERO MANUFACTURING RANGE';
            else
                return 'SPEC. MFG. RNG.:';
            else
                return '';
        }
        set;
    }

    public String ORP025 {
        get {
            String sign = '';
            if(RTTMSP < 0.0) {
                sign = 'MINUS ';
            }
            if(RGTYP1 == 'Special') {
                return String.valueOf(SpecRngMin.stripTrailingZeros().toPlainString()) + ' To ' + String.valueOf(SpecRngMax.stripTrailingZeros().toPlainString()) + ' ' + RTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN;
            } else if(RGTYP1 == 'Performance Tolerance' && RG1MAX != RG1MIN) {
                return RG1MIN.stripTrailingZeros().toPlainString() + ' To ' + RG1MAX.stripTrailingZeros().toPlainString() + ' ' + RTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            } else if((RGTYP1 == 'Special - 3/4 Reduced Range') || (RGTYP1 == 'Special - 1/2 Reduced Range') || (RGTYP1 == 'Special - 1/4 Reduced Range')) {
                return RG1MIN.stripTrailingZeros().toPlainString() + ' To ' + RG1MAX.stripTrailingZeros().toPlainString() + ' ' + RTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; //Service Tkt# 162422
            }
            return ORP025;
        }
        set;
    }
    public String ORV025 {
        get {
            String sign = '';
            if(RTTMSP < 0.0) {
                sign = 'MINUS ';
            }
            if(VGTYP1 == 'Special') {
                return String.valueOf(VSpecRngMin.stripTrailingZeros().toPlainString()) + ' To ' + String.valueOf(VSpecRngMax.stripTrailingZeros().toPlainString()) + ' ' + VTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN;
            } else if(VGTYP1 == 'Performance Tolerance' && VG1MAX != VG1MIN) {
                return VG1MIN.stripTrailingZeros().toPlainString() + ' To ' + VG1MAX.stripTrailingZeros().toPlainString() + ' ' + VTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; // TODO: verify RG1MINStr2 in CPQ, Service Tkt# 162422
            } else if((VGTYP1 == 'Special - 3/4 Reduced Range') || (VGTYP1 == 'Special - 1/2 Reduced Range') || (VGTYP1 == 'Special - 1/4 Reduced Range')) {
                return VG1MIN.stripTrailingZeros().toPlainString() + ' To ' + VG1MAX.stripTrailingZeros().toPlainString() + ' ' + VTPRSU + ' @ ' + sign + Math.abs(RTTMSP).stripTrailingZeros().toPlainString() + ' ' + RTTMUN; // TODO: verify RG1MINStr2 in CPQ, Service Tkt# 162422
            }
            return ORV025;
        }
        set;
    }
    public String ORP027 {
        get {
            if((RGRAT1 == 'Specified' && RGTYP1 != 'Performance Tolerance') && BURMAX != null && BURMIN != null && PBurstPressureConverted > 0) {
                Decimal custMinPress2 = BURMIN - PBurstPressureConverted;
                Decimal custMaxPress2 = BURMAX - PBurstPressureConverted;
                System.debug('ORP027 custMinPress2-->'+custMinPress2);
                System.debug('ORP027 custMaxPress2-->'+custMaxPress2);
                System.debug('ORP027 PBurstPressureConverted-->'+PBurstPressureConverted);
                System.debug('ORP027 BURMIN-->'+BURMIN);
                System.debug('ORP027 BURMAX-->'+BURMAX);
                Decimal baseMinPress2 = 0.01 * (((custMinPress2 / PBurstPressureConverted) * 100) * 100 - 0.9999).intValue();
                Decimal baseMaxPress2 = 0.01 * (((custMaxPress2 / PBurstPressureConverted) * 100) * 100 + 0.9999).intValue();
                String signMin = '';
                String signMax = '';
                if(baseMinPress2 > 0) {
                    signMin = '+';
                }
                if(baseMaxPress2 > 0) {
                    signMax = '+';
                }
                // String signMin = '+';
                // String signMax = '+';
                // if(baseMinPress2 < 0) {
                //     signMin = '';
                // }
                // if(baseMaxPress2 < 0) {
                //     signMax = '';
                // }
                return 'PERF. TOL.:' + signMin + baseMinPress2.stripTrailingZeros().toPlainString() + '%/' + signMax + baseMaxPress2.stripTrailingZeros().toPlainString() + '%'; //Service Tkt# 162422
            } else if(RGRAT1 == 'Specified' && RGTYP1 == 'Performance Tolerance' && PerfTolUOM == 'Specified Burst Pressure Units') {
                return 'PERF. TOL.:-' + PerfTolMin.stripTrailingZeros().toPlainString() + ' ' + RTPRSU + '/+' + PerfTolMax.stripTrailingZeros().toPlainString() + ' ' + RTPRSU; //Service Tkt# 162422
            } else if(RGRAT1 == 'Specified' && RGTYP1 == 'Performance Tolerance') {
                return 'PERF. TOL.:-' + PerfTolMin.stripTrailingZeros().toPlainString() + '%/+' + PerfTolMax.stripTrailingZeros().toPlainString() + '%'; //Service Tkt# 162422
            }
            return ORP027;
        }
        set;
    }
    public String ORV027 {
        get {
            String ORV027='';
            if((VGRAT1 == 'Specified' && VGTYP1 != 'Performance Tolerance') && VMAX != null && VMIN != null && VBurstPressureConverted > 0) {
                Decimal custMinPress2 = VMIN - VBurstPressureConverted;
                Decimal custMaxPress2 = VMAX - VBurstPressureConverted;
                Decimal baseMinPress2 = 0.01 * (((custMinPress2 / VBurstPressureConverted) * 100) * 100 - 0.9999).intValue();
                Decimal baseMaxPress2 = 0.01 * (((custMaxPress2 / VBurstPressureConverted) * 100) * 100 + 0.9999).intValue();
                String signMin = '';
                String signMax = '';
                if(baseMinPress2 > 0) {
                    signMin = '+';
                }
                if(baseMaxPress2 > 0) {
                    signMax = '+';
                }
                return 'PERF. TOL.:' + signMin + baseMinPress2.stripTrailingZeros().toPlainString() + '%/' + signMax + baseMaxPress2.stripTrailingZeros().toPlainString() + '%'; //Service Tkt# 162422
            } else if(VGRAT1 == 'Specified' && VGTYP1 == 'Performance Tolerance' && VPerfTolUOM == 'Specified Burst Pressure Units') {
                return 'PERF. TOL.:-' + VPerfTolMin.stripTrailingZeros().toPlainString() + ' ' + VTPRSU + '/+' + VPerfTolMax.stripTrailingZeros().toPlainString() + ' ' + VTPRSU; //Service Tkt# 162422
            } else if(VGRAT1 == 'Specified' && VGTYP1 == 'Performance Tolerance') {
                //if(VBurstTolStringD != Null  && VPerfTolMax != Null){
                    return 'PERF. TOL.:-' + VPerfTolMin.stripTrailingZeros().toPlainString() + '%/+' + VPerfTolMax.stripTrailingZeros().toPlainString() + '%'; //Service Tkt# 162422
                // } else {
                //     return ORV027;
                // }
            }
            return ORV027;
        }
        set;
    }
    public String ORP {
        get {
            String retORP = '';
            if(String.isNotBlank(ORP010)){
                retORP += ORP010 + '\n';
            }
            if(String.isNotBlank(ORP015)){
                retORP += ORP015 + '\n';
            }
            if(String.isNotBlank(ORP020)){
                retORP += ORP020 + '\n';
            }
            if(String.isNotBlank(ORP025)){
                retORP += ORP025 + '\n';
            }
            if(String.isNotBlank(ORP027)){
                retORP += ORP027 + '\n';
            }
            return retORP;
            //return setBlankForNull(ORP010) + '\n' + setBlankForNull(ORP015)+ '\n' + setBlankForNull(ORP020)+ '\n' + setBlankForNull(ORP025)+ '\n' + setBlankForNull(ORP027);
        }
        set;
    }
    public String ORV {
        get {
            String retORV = '';
            if(String.isNotBlank(ORV010)){
                retORV += ORV010 + '\n';
            }
            if(String.isNotBlank(ORV015)){
                retORV += ORV015 + '\n';
            }
            if(String.isNotBlank(ORV020)){
                retORV += ORV020 + '\n';
            }
            if(String.isNotBlank(ORV025)){
                retORV += ORV025 + '\n';
            }
            if(String.isNotBlank(ORV027)){
                retORV += ORV027 + '\n';
            }
            return retORV;
            //return setBlankForNull(ORV010) + '\n' + setBlankForNull(ORV015)+ '\n' + setBlankForNull(ORV020)+ '\n' + setBlankForNull(ORV025)+ '\n' + setBlankForNull(ORV027);
        }
        set;
    }
    public String SRP010 {
        get {
            //[zook == value looked up from table DiscTypeList based upon PTC]
            String sign = '';
            String zook = (String) PTC.get('ZookProduct__c');
            if(RTTMDF < 0) {
                sign = 'MINUS ';
            }
            if(zook == 'Yes') {
                return '';
            } else if(zook == 'No' && RGRAT1 == 'Burst Pressure Min/Max.' && RTTMDF != 72) {
                return '  >>' + RG2MIN.stripTrailingZeros().toPlainString() + ' To ' + RG2MAX.stripTrailingZeros().toPlainString() + ' psig @ ' + sign + Math.abs(RTTMDF).stripTrailingZeros().toPlainString() + ' Deg F'; //Service Tkt# 162422
            } else if(zook == 'No' && RGRAT1 == 'Rated' && RGTYP1 == 'Zero' && RTTMDF != 72) {
                return '  >>' + RG2MIN.stripTrailingZeros().toPlainString() + ' psig @' + sign + Math.abs(RTTMDF).stripTrailingZeros().toPlainString() + ' Deg F'; //Service Tkt# 162422
            }
            return SRP010;
        }
        set;
    }
    public String SRV010 {
        get {
            //[zook == value looked up from table DiscTypeList based upon PTC]
            String sign = '';
            String zook = (String) PTC.get('ZookProduct__c');
            if(RTTMDF < 0) {
                sign = 'MINUS ';
            }
            if(zook == 'Yes') {
                return '';
            } else if(zook == 'No' && VGRAT1 == 'Burst Pressure Min/Max.' && RTTMDF != 72) {
                return '  >>' + VG2MIN.stripTrailingZeros().toPlainString() + ' To ' + VG2MAX.stripTrailingZeros().toPlainString() + ' psig @ ' + sign + Math.abs(RTTMDF).stripTrailingZeros().toPlainString() + ' Deg F'; //Service Tkt# 162422
            } else if(zook == 'No' && VGRAT1 == 'Rated' && RGTYP1 == 'Zero' && RTTMDF != 72) {
                return '  >>' + VG2MIN.stripTrailingZeros().toPlainString() + ' psig @' + sign + Math.abs(RTTMDF).stripTrailingZeros().toPlainString() + ' Deg F'; //Service Tkt# 162422
            }
            return SRV010;
        }
        set;
    }
    public String SRP020 {
        get {
            String sign = '';
            String zook = (String) PTC.get('ZookProduct__c');
            if(RTTMDF < 0) {
                sign = 'MINUS ';
            }
            if(zook == 'Yes') {
                return '';
            } else if(zook == 'No' && RGRAT1 == 'Burst Pressure Min/Max.') {
                return '  >>' + RG3MIN.stripTrailingZeros().toPlainString() + ' To ' + RG3MAX.stripTrailingZeros().toPlainString() + ' psig @ 72 Deg F'; //Service Tkt# 162422
            } else if(zook == 'No' && RGRAT1 == 'Rated' && RGTYP1 == 'Zero') {
                return '  >>' + RG3MIN.stripTrailingZeros().toPlainString() + ' psig @ 72 Deg F'; //Service Tkt# 162422
            }
            return SRP020;
        }
        set;
    }
    public String SRV020 {
        get {
            String sign = '';
            String zook = (String) PTC.get('ZookProduct__c');
            if(RTTMDF < 0) {
                sign = 'MINUS ';
            }
            if(zook == 'Yes') {
                return '';
            } else if(zook == 'No' && VGRAT1 == 'Burst Pressure Min/Max.') {
                return '  >>' + VG3MIN.stripTrailingZeros().toPlainString() + ' To ' + VG3MAX.stripTrailingZeros().toPlainString() + ' psig @ 72 Deg F';
            } else if(zook == 'No' && VGRAT1 == 'Rated' && RGTYP1 == 'Zero') {
                return '  >>' + VG3MIN.stripTrailingZeros().toPlainString() + ' psig @ 72 Deg F';
            }
            return SRV020;
        }
        set;
    }
    public String SRP030 {
        get {
            //[zook == value looked up from table DiscTypeList based upon PTC]
            String sign = '';
            String zook = (String) PTC.get('ZookProduct__c');
            if(RTTMDF < 0) {
                sign = 'MINUS ';
            }
            if(zook == 'Yes') {
                return '';
            } else if(zook == 'No' && (RGRAT1 != 'No Rating' && RGRAT1 != 'No Rating But Must Withstand' && RGRAT1 != '') && RTTMDF != 72) {
                return '  >>> Elevated Shop: ' + RGEMIN.stripTrailingZeros().toPlainString() + ' To ' + RGEMAX.stripTrailingZeros().toPlainString() + ' ' + PPressureBaseUOM + ' @ ' + sign + Math.abs(RTTMDF).stripTrailingZeros().toPlainString() + ' Deg F'; //Service Tkt# 162422
            } else if(zook == 'No' && (RGRAT1 != 'No Rating' && RGRAT1 != 'No Rating But Must Withstand' && RGRAT1 != '') && RGRATU != 'in.water') {
                return '  >>> Elevated Shop: ' + RGEMIN.stripTrailingZeros().toPlainString() + ' To ' + RGEMAX.stripTrailingZeros().toPlainString() + ' ' + PPressureBaseUOM + ' @ ' + sign + Math.abs(RTTMDF).stripTrailingZeros().toPlainString() + ' Deg F'; //Service Tkt# 162422
            } else if(zook == 'No' && RGRAT1 == 'No Rating') {
                return '  >>> 0 psig @ ' + RTTMDF.stripTrailingZeros().toPlainString() + ' deg F'; //Service Tkt# 162422
            } else if(zook == 'No' && RGRAT1 == 'No Rating But Must Withstand' && RGRATW != null && RGRATU != ''){
                return '  >>> ' + String.valueOf(unitConversions.SignificantDigitsNormal(convertPressure(RGRATW, RGRATU, 'psig'), 3, 0).dblRetValue) + ' psig @ ' + RTTMDF.stripTrailingZeros().toPlainString() + ' deg F';  //Service Tkt# 162422
            }
            return SRP030;
        }
        set;
    }
    public String SRV030 {
        get {
            //[zook == value looked up from table DiscTypeList based upon PTC]
            String sign = '';
            String zook = (String) PTC.get('ZookProduct__c');
            if(RTTMDF < 0) {
                sign = 'MINUS ';
            }
            if(zook == 'Yes') {
                return '';
            } else if(zook == 'No' && (VGRAT1 != 'No Rating' && VGRAT1 != 'No Rating But Must Withstand' && VGRAT1 != '') && RTTMDF != 72) {
                return '  >>> Elevated Shop: ' + VGEMIN.stripTrailingZeros().toPlainString() + ' To ' + VGEMAX.stripTrailingZeros().toPlainString() + ' ' + VPressureBaseUOM + ' @ ' + sign + Math.abs(RTTMDF).stripTrailingZeros().toPlainString() + ' Deg F'; //Service Tkt# 162422
            } else if(zook == 'No' && (VGRAT1 != 'No Rating' && VGRAT1 != 'No Rating But Must Withstand' && VGRAT1 != '') && VGRATU != 'in.water') {
                return '  >>> Elevated Shop: ' + VGEMIN.stripTrailingZeros().toPlainString() + ' To ' + VGEMAX.stripTrailingZeros().toPlainString() + ' ' + VPressureBaseUOM + ' @ ' + sign + Math.abs(RTTMDF).stripTrailingZeros().toPlainString() + ' Deg F'; //Service Tkt# 162422
            } else if(zook == 'No' && VGRAT1 == 'No Rating') {
                return '  >>> 0 psig @ ' + RTTMDF.stripTrailingZeros().toPlainString() + ' deg F'; //Service Tkt# 162422
            } else if(zook == 'No' && VGRAT1 == 'No Rating But Must Withstand' && VGRATW != null && VGRATU != ''){
                return '  >>> ' + String.valueOf(unitConversions.SignificantDigitsNormal(convertPressure(VGRATW, VGRATU, 'psig'), 3, 0).dblRetValue) + ' psig @ ' + RTTMDF.stripTrailingZeros().toPlainString() + ' deg F'; //Service Tkt# 162422
            }
            return SRV030;
        }
        set;
    }
    public String SRP040 {
        get {
            String zook = (String) PTC.get('ZookProduct__c');
            if(zook == 'Yes') {
                return '';
            } else if(zook == 'No' && (RGRAT1 != 'Start/Full Relief (Min/Max)' && RGRAT1 != 'No Rating' && RGRAT1 != 'No Rating But Must Withstand' && RGRAT1 != '') && PPressureBaseUOM != '') {
                return '  >>> Ambient Shop: ' + RGSMIN.stripTrailingZeros().toPlainString() + ' To ' + RGSMAX.stripTrailingZeros().toPlainString() + ' ' + PPressureBaseUOM + ' @ 72 deg F'; //Service Tkt# 162422
            }
            return SRP040;
        }
        set;
    }
    public String SRV040 {
        get {
            String zook = (String) PTC.get('ZookProduct__c');
            if(zook == 'Yes') {
                return '';
            } else if((zook == 'No' &&  VGRAT1 != 'Start/Full Relief (Min/Max)' && VGRAT1 != 'No Rating' && VGRAT1 != 'No Rating But Must Withstand' && VGRAT1 != '') && VPressureBaseUOM != '') {
                return '  >>> Ambient Shop: ' + VGSMIN.stripTrailingZeros().toPlainString() + ' To ' + VGSMAX.stripTrailingZeros().toPlainString() + ' ' + VPressureBaseUOM + ' @ 72 deg F'; //Service Tkt# 162422
            }
            return SRV040;
        }
        set;
    }

    public String SRP050 {
        get {
            if(RGRAT1 != 'No Rating' && RGRAT1 != 'No Rating But Must Withstand' && RGRAT1 != 'Start/Full Relief (Min/Max)' && RGRAT1 != '') {
                return 'Temp. Factor: ' + RG3DRT.stripTrailingZeros().toPlainString() + '%'; //Service Tkt# 162422
            }
            return SRP050;
        }
        set;
    }
    public String SRV050 {
        get {
            if(VGRAT1 != 'No Rating' && VGRAT1 != 'No Rating But Must Withstand' && VGRAT1 != 'Start/Full Relief (Min/Max)' && String.isNotBlank(VGRAT1)) {

                return 'Temp. Factor: '+ VG3DRT.stripTrailingZeros().toPlainString() + '%'; //Service Tkt# 162422
            }
            return SRV050;
        }
        set;
    }
    public String SRP {
        get {
            String retSRP = '';
            if(String.isNotBlank(SRP010)){
                //ret += SRP010 + '</BR>';
                retSRP += SRP010 + '\n';
            }
            if(String.isNotBlank(SRP020)){
                retSRP += SRP020 + '\n';
            }
            if(String.isNotBlank(SRP030)){
                retSRP += SRP030 + '\n';
            }
            if(String.isNotBlank(SRP040)){
                retSRP += SRP040 + '\n';
            }
            if(String.isNotBlank(SRP050)){
                retSRP += SRP050;
            }
            return retSRP;
        }
        set;
    }
    public String SRV {
        get {
            String retSRV = '';
            if(currentRptDisc.Relief_Type__c!='Pressure Relief' || VGRAT1 == 'No Rating But Must Withstand') {
                if(String.isNotBlank(SRV010)){
                    retSRV += SRV010 + '</BR>';
                }
                if(String.isNotBlank(SRV020)){
                    retSRV += SRV020 + '</BR>';
                }
                if(String.isNotBlank(SRV030)){
                    retSRV += SRV030 + '</BR>';
                }
                if(String.isNotBlank(SRV040)){
                    retSRV += SRV040 + '</BR>';
                }
                if(String.isNotBlank(SRV050)){
                    retSRV += SRV050;
                }
            }
            return retSRV;
        }
        set;
    }
    // RATING/RANGE UTILS AND CONSTRAINTS
    public String getBaseUOM() {
        String uom;
        if(currentProduct =='PAS') {
            UOM = 'in. water';
        } else {  // PTC == 'CAL'
            UOM = 'psig';
        }
        return uom;
    }
    // TODO: Clean conversion methods out of the file
    public static Map<string,double> mapPressureValues=new Map<string,double>();
    public static Map<string,double> mapTemperatureValues=new Map<string,double>();
    public Decimal convertPressure(Decimal pressureSetting, String pressureSettingUnits, String conversionUOM) {
        decimal pressureVal=pressureSetting;
        String key=pressureVal.stripTrailingZeros().toPlainString()+pressureSettingUnits+conversionUOM; //Service Tkt# 162422
        double dbl=0;
        if(mapPressureValues.containsKey(key))
            return mapPressureValues.get(key);
        else {
            dbl=unitConversions.convertPressure(pressureSettingUnits, conversionUOM, pressureVal).dblRetValue;
            mapPressureValues.put(key,dbl);
            return dbl;
        }

    }
    public Decimal convertTemperature(Decimal temperatureSetting, String temperatureSettingUnits, String conversionUOM) {
        String key=temperatureSetting+temperatureSettingUnits+conversionUOM;
        double dbl=0;
        if(mapTemperatureValues.containsKey(key))
            return mapTemperatureValues.get(key);
        else {
            dbl=unitConversions.convertTemperature(temperatureSettingUnits, conversionUOM, temperatureSetting).dblRetValue;
            mapTemperatureValues.put(key,dbl);
            return dbl;
        }
    }
    //public static List<RD_tblBurstTolMethod__c> tbList {get;set;}
    public List<RD_tblBurstTolMethod__c> tbLis88t() {

        List<RD_tblBurstTolMethod__c> burstTolMethodVals = [
            SELECT SizeLL__c, SizeUL__c, RatedPressLL__c, RatedPressUL__c, BPMMMinPressLL__c, BPMMMinPressUL__c, BPMMMaxPressLL__c, BPMMMaxPressUL__c, MinAdd__c, MinMulti__c, MaxAdd__c, MaxMulti__c
            FROM RD_tblBurstTolMethod__c WHERE PTC__c =: currentProduct];
        return burstTolMethodVals;

    }
    public static List<Manufacturing_Range_Value__c> mfgListVals() {
        List<Manufacturing_Range_Value__c> burstTolMethodVals = [
            SELECT MinMfgRngMulti__c, MinMfgRngAdder__c, MaxMfgRngMulti__c, MaxMfgRngAdder__c,RTPRS1LL__c,RTPRS1UL__c,RGRAT1__c, RGTYP1__c, RGEMAXLL__c, RGEMAXUL__c FROM Manufacturing_Range_Value__c];
        return burstTolMethodVals;
    }
    public List<Manufacturing_Range_Value__c> filterMgfBase (List<Manufacturing_Range_Value__c> mfgBst,String filterType,decimal val,boolean includeType,String strRng,String strType) {
        List<Manufacturing_Range_Value__c> mgf=new List<Manufacturing_Range_Value__c>();
        for(Manufacturing_Range_Value__c mf:mfgBst) {
            if (includeType) {
                boolean check=mf.RGRAT1__c==strRng && mf.RGTYP1__c==strType;
                //RGRAT1__c = :VGRAT1 AND RGTYP1__c != :VGTYP1
                // if(mf.RGRAT1__c)
                if ((filterType=='RTPRS1' && check) && (mf.RTPRS1LL__c<val && mf.RTPRS1UL__c>=val)) {
                    mgf.add(mf);
                } else if ((filterType=='RGEMAX' && check) && (mf.RGEMAXLL__c<=val && mf.RGEMAXUL__c>val)) {
                    mgf.add(mf);
                }
            } else {
                if ((filterType=='RTPRS1') && (mf.RTPRS1LL__c<val && mf.RTPRS1UL__c>=val)) {
                    mgf.add(mf);
                } else if ((filterType=='RGEMAX') && (mf.RGEMAXLL__c<=val && mf.RGEMAXUL__c>val)) {
                    mgf.add(mf);
                }
            }
        }
        return mgf;
    }

    public List<Girdle_Lim_Check__c> girdleList {get;set;}
    public List<Girdle_Lim_Check__c> gList {get;set;}
    public List<Girdle_Lim_Check__c> grdList() {
        List<Girdle_Lim_Check__c> lgL=new List<Girdle_Lim_Check__c>();
        lgL=Database.query('SELECT GirdleMatl__c, MaxPressLL__c, MaxPressUL__c, RangeInt__c, SizeCode__c FROM Girdle_Lim_Check__c Where SizeCode__c=\''+ConstantsUtil.getSizeDesc(currentSizeCap).SZC+'\'');
        // lgL=[SELECT GirdleMatl__c, MaxPressLL__c, MaxPressUL__c, RangeInt__c, SizeCode__c FROM Girdle_Lim_Check__c Where SizeCode__c=:integer.valueOf(currentSizeCap)];
        return lgL;
    }
    public List<Girdle_Lim_Check__c> filterGirdleLimCheck(List<Girdle_Lim_Check__c> gcList,decimal minVal) {
        List<Girdle_Lim_Check__c> gg=new List<Girdle_Lim_Check__c>();
        for (Girdle_Lim_Check__c g:gcList) {
            if(g.MaxPressLL__c<minVal && g.MaxPressUL__c>=minVal && (tempMCGD==g.GirdleMatl__c))
                gg.add(g);
        }

        //Service Ticket #200743, allow girdles within pressure limit rule criteria
        if(String.isNotBlank(tempMCGD) && gg.size() == 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Selected girdle material is not within pressure limits.'));
        }
        return gg;
    }

    public List<RD_ShopRangeValues__c> shpList {get;set;}
    public List<RD_ShopRangeValues__c> filterShopRangeValues(decimal pCheck, List<RD_ShopRangeValues__c> shpLst,string shopRngType) {
        List<RD_ShopRangeValues__c> shp= new  List<RD_ShopRangeValues__c>();
        for(RD_ShopRangeValues__c sr:shpLst) {
            if(shopRngType==sr.PTC__c && ( sr.ShopRngPressLL__c<pCheck && sr.ShopRngPressUL__c>=pCheck))
                shp.add(sr);
        }
        return shp;
    }

    public List<RD_ShopRangeValues__c> lstShopRange() {
       // String ShopRngType = (String) PTC.get('ShopRngType__c');
        List<RD_ShopRangeValues__c> rdShpList= [SELECT ShopRngBottomAdd__c, ShopRngBottomMulti__c, ShopRngPressLL__c, ShopRngPressUL__c, ShopRngTopAdd__c, ShopRngTopMulti__c, PTC__c
            FROM RD_ShopRangeValues__c];
        return rdShpList;
    }
    public List<Manufacturing_Range_Value__c> mfgList {get;set;}
    public List<RD_tblBurstTolMethod__c> tbList {get;set;}
    public List<RD_tblBurstTolMethod__c> filterTblBrustList (List<RD_tblBurstTolMethod__c> tblBst,String filterType,decimal filVal) {
        List<RD_tblBurstTolMethod__c> tbl=new List<RD_tblBurstTolMethod__c>();
        for(RD_tblBurstTolMethod__c tb:tblBst) {
            if((filterType=='BPMMMin') && (tb.BPMMMinPressLL__c<=filVal && tb.BPMMMinPressUL__c>filVal)) {
                tbl.add(tb);
            } else if ((filterType=='BPMMMax') && (tb.BPMMMaxPressLL__c<=filVal && tb.BPMMMaxPressUL__c>filVal)) {
                tbl.add(tb);
            } else if ((filterType=='Rated') && (tb.RatedPressLL__c<=filVal && tb.RatedPressUL__c>filVal)) {
                tbl.add(tb);
            }
        }
        return tbl;
    }
    public String setBlankForNull(String strValue)
    {
        if(String.isBlank(strValue))
        {
            strValue = '';
        }
        return strValue;
    }

    public Map<string,List<SelectOption>> mapRGTYP1{set;get;}
    public Map<string,List<SelectOption>> mapVGTYP1{set;get;}
    public void setPTC() {
        // TODO: Add Logic to get PTC
        /* SELECT Product,
0             1       2               3             4                   5               6                 7               8           9             10              11              12
ProductLevel, Media,  LiquidTestReqd, OPtoBpRatio,  Section8Compliant,  RangeTypeGroup, RangeComparison,  BurstTolMethod, DerateType, ShopRngType,  ShopRngMinMax,  NonFragDesign,  DefMfgRngType,
13          14          15              16            17          18            19              20        21            22      23            24                25                  26
BidirFlag,  GoodforVac, VacSuptNeeded,  StandardDisc, Composite,  ZookProduct,  Eleven_Sixteen, STTSFlag, TempTestReqd, CEMark, ProductLine,  MfgDataTemplate,  MfgDataSearchGroup, ProductDescr1,
27              28              29              30
ProductDescr2,  ProductDescr3,  ProductDescr4,  MatingHolder FROM PTC__c WHERE things=stuff
*/
        // TODO: Replace the query here with the ConstantsUtil queryTableValues
        mapRGTYP1=new Map<string,List<SelectOption>>();
        mapVGTYP1=new Map<string,List<SelectOption>>();
        if(String.isNotBlank(currentProduct) || (PTC != null && String.isNotBlank(currentProduct) && PTC.PTC__c != currentProduct)) {
            List<Disc_Type_List__c> discTypeList = [
                SELECT ProductLevel__c, Media__c,  LiquidTestReqd__c, OPtoBpRatio__c,  Section8Compliant__c,  RangeTypeGroup__c, RangeComparison__c,  BurstTolMethod__c, DerateType__c, ShopRngType__c,  ShopRngMinMax__c,  NonFragDesign__c,  DefMfgRngType__c, BidirFlag__c,  GoodforVac__c, VacSupportNeeded__c,  StandardDisc__c, Composite__c,  ZookProduct__c,  Eleven_Sixteen__c, STTSFlag__c, TempTestReqd__c, CEMark__c, ProductLine__c,  MfgDataTemplate__c,  MfgDataSearchGroup__c, ProductDescr1__c, ProductDescr2__c,  ProductDescr3__c,  ProductDescr4__c,  MatingHolder__c, PTC__c
                FROM Disc_Type_List__c
                WHERE PTC__c = :currentProduct];
            PTC = discTypeList.get(0);
            string KOSHA=currentRptDisc.KOSHA_Compliance__c?'Y':'N';
            string RPVM084=currentRptDisc.Comply_with_Regels_Voor_Tosellan_Oder_Dr__c?'Y':'N';
            //string ASME=currentRptDisc.CSA_Marking_CRN_Number__c?'Y':'N'; - Commented and Added Below ASME as per the Bug #31431
            String ASME=currentRptDisc.ASME_Section_VIII_Division_1__c?'Y':'N';
            string ADMERK=currentRptDisc.Comply_with_AD2000_Merkblat_A1__c?'Y':'N';
            //string CEMark=currentRptDisc.PED_2014_68_EU_CE_mark__c!=NULL?'Y':'N';
            string CEMark=currentRptDisc.PED_2014_68_EU_CE_mark__c!='NonePED'?'Y':'N';
            //List<RD_Rating_Range__c> rtgRngVals = [SELECT RGRAT1__c, RGTYP1__c, VGRAT1__c, VGTYP1__c FROM RD_Rating_Range__c WHERE PTC__c = :PTC.PTC__c];
            List<RD_Rating_Range__c> rtgRngVals = [SELECT RGRAT1__c, RGTYP1__c, VGRAT1__c, VGTYP1__c FROM RD_Rating_Range__c WHERE PTC__c = :PTC.PTC__c];
            List<RD_NEW_PosRatingRange__c> rtgRngVals2=[SELECT RGRAT1__c, RGTYP1__c FROM RD_NEW_PosRatingRange__c WHERE PTC__c = :PTC.PTC__c AND KOSHA__c=:KOSHA AND RPVM084__c=:RPVM084 AND ASME__C=:ASME AND ADMERK__c=:ADMERK AND CE_Mark__c=:CEMark];

            // ratingRangeMap = new Map<String, List<String>>();
            // ratingRangeMap.put('RGRAT1')
            pressureRatingOptions = new List<SelectOption>{
                new SelectOption('', '')
                    };
            pressureRangeOptions = new List<SelectOption>{
            new SelectOption('', '')
            };
            vacuumRatingOptions = new List<SelectOption>{
            new SelectOption('', '')
            };
            vacuumRangeOptions = new List<SelectOption>{
            new SelectOption('', '')
            };
            pressRefMfgRangeType = new List<SelectOption>{
                new SelectOption('Please Select', 'Please Select')
                // new SelectOption('Zero', 'Zero'),
                // //  new SelectOption('Standard', 'Standard'),
                // new SelectOption('-10% (-5 Psig)', '-10% (-5 Psig)'),
                // //  new SelectOption('-10% (-0.6 Psig)', '-10% (-0.6 Psig)'),
                // //  new SelectOption('-10%', '-10%'),
                // new SelectOption('-5% (-2.5 Psig)', '-5% (-2.5 Psig)')
                //new SelectOption('-5% (-0.3 Psig)', '-5% (-0.3 Psig)'),
                //new SelectOption('-5%', '-5%'),
                // new SelectOption('Special - 25% of Std. Mfg. Range', 'Special - 25% of Std. Mfg. Range'),
                // new SelectOption('Special - 50% of Std. Mfg. Range', 'Special - 50% of Std. Mfg. Range'),
        // new SelectOption('Special - 75% of Std. Mfg. Range', 'Special - 75% of Std. Mfg. Range')
            };
            vacRefMfgRangeType = new List<SelectOption>{
                new SelectOption('Please Select', 'Please Select')
                // new SelectOption('Zero', 'Zero'),
                // //  new SelectOption('Standard', 'Standard'),
                // new SelectOption('-10% (-5 Psig)', '-10% (-5 Psig)'),
                // //  new SelectOption('-10% (-0.6 Psig)', '-10% (-0.6 Psig)'),
                // // new SelectOption('-10%', '-10%'),
                // new SelectOption('-5% (-2.5 Psig)', '-5% (-2.5 Psig)')
                // new SelectOption('-5% (-0.3 Psig)', '-5% (-0.3 Psig)'),
                // new SelectOption('-5%', '-5%'),
                // new SelectOption('Special - 25% of Std. Mfg. Range', 'Special - 25% of Std. Mfg. Range'),
                // new SelectOption('Special - 50% of Std. Mfg. Range', 'Special - 50% of Std. Mfg. Range'),
            // new SelectOption('Special - 75% of Std. Mfg. Range', 'Special - 75% of Std. Mfg. Range')
            };
            Set<String> pressureRatingUniqueVals = new Set<String>();
            Set<String> pressureRangeUniqueVals = new Set<String>();
            Set<String> pressRefMfgRangeUniqueVals = new Set<String>();
            Set<String> vacRefMfgRangeUniqueVals = new Set<String>();
            Set<String> vacuumRatingUniqueVals = new Set<String>();
            Set<String> vacuumRangeUniqueVals = new Set<String>();
            for(RD_NEW_PosRatingRange__c rtgRngVal1:rtgRngVals2) {
                if(String.isNotBlank(rtgRngVal1.RGRAT1__c) && !pressureRatingUniqueVals.contains(rtgRngVal1.RGRAT1__c)) {
                    pressureRatingUniqueVals.add(rtgRngVal1.RGRAT1__c);
                    pressureRatingOptions.add(new SelectOption(rtgRngVal1.RGRAT1__c, rtgRngVal1.RGRAT1__c));
                }
                if(String.isNotBlank(rtgRngVal1.RGTYP1__c) && !pressureRangeUniqueVals.contains(rtgRngVal1.RGTYP1__c)) {
                    pressureRangeUniqueVals.add(rtgRngVal1.RGTYP1__c);
                    pressureRangeOptions.add(new SelectOption(rtgRngVal1.RGTYP1__c, rtgRngVal1.RGTYP1__c));
                }
                if (String.isNotBlank(rtgRngVal1.RGTYP1__c)) {
                    List<SelectOption> listName = new List<SelectOption>();
                    if(mapRGTYP1.containsKey(rtgRngVal1.RGRAT1__c)) {
                        listName=mapRGTYP1.get(rtgRngVal1.RGRAT1__c);
                        listName.add(new SelectOption(rtgRngVal1.RGTYP1__c, rtgRngVal1.RGTYP1__c));
                        mapRGTYP1.put(rtgRngVal1.RGRAT1__c,listName);
                    } else {
                        listName.add(new SelectOption(rtgRngVal1.RGTYP1__c, rtgRngVal1.RGTYP1__c));
                        mapRGTYP1.put(rtgRngVal1.RGRAT1__c,listName);
                    }
                }
            }
            for(RD_Rating_Range__c rtgRngVal : rtgRngVals) {

                if(rtgRngVal.RGRAT1__c=='Rated' && !pressRefMfgRangeUniqueVals.contains(rtgRngVal.RGTYP1__c)) {
                    if (String.isNotBlank(rtgRngVal.RGTYP1__c) && !rtgRngVal.RGTYP1__c.containsIgnoreCase('Special')) {
                        if(pressRefMfgRangeUniqueVals.add(rtgRngVal.RGTYP1__c))
                            pressRefMfgRangeType.add(new SelectOption(rtgRngVal.RGTYP1__c, rtgRngVal.RGTYP1__c));
                    }
                }

                if(rtgRngVal.VGRAT1__c=='Rated' && !vacRefMfgRangeUniqueVals.contains(rtgRngVal.VGTYP1__c)) {
                    if (String.isNotBlank(rtgRngVal.VGTYP1__c) && !rtgRngVal.VGTYP1__c.containsIgnoreCase('Special')) {
                        if(vacRefMfgRangeUniqueVals.add(rtgRngVal.VGTYP1__c))
                            vacRefMfgRangeType.add(new SelectOption(rtgRngVal.VGTYP1__c, rtgRngVal.VGTYP1__c));
                    }
                }
                // if(String.isNotBlank(rtgRngVal.RGRAT1__c) && !pressureRatingUniqueVals.contains(rtgRngVal.RGRAT1__c)) {
                //     pressureRatingUniqueVals.add(rtgRngVal.RGRAT1__c);
                //     pressureRatingOptions.add(new SelectOption(rtgRngVal.RGRAT1__c, rtgRngVal.RGRAT1__c));
                // }
                // if(String.isNotBlank(rtgRngVal.RGTYP1__c) && !pressureRangeUniqueVals.contains(rtgRngVal.RGTYP1__c)) {
                //     pressureRangeUniqueVals.add(rtgRngVal.RGTYP1__c);
                //     pressureRangeOptions.add(new SelectOption(rtgRngVal.RGTYP1__c, rtgRngVal.RGTYP1__c));
                // }
                // if (String.isNotBlank(rtgRngVal.RGTYP1__c)) {
                //     List<SelectOption> listName = new List<SelectOption>();
                //     if(mapRGTYP1.containsKey(rtgRngVal.RGRAT1__c)) {
                //         listName=mapRGTYP1.get(rtgRngVal.RGRAT1__c);
                //         listName.add(new SelectOption(rtgRngVal.RGTYP1__c, rtgRngVal.RGTYP1__c));
                //         mapRGTYP1.put(rtgRngVal.RGRAT1__c,listName);
                //     } else {
                //         listName.add(new SelectOption(rtgRngVal.RGTYP1__c, rtgRngVal.RGTYP1__c));
                //         mapRGTYP1.put(rtgRngVal.RGRAT1__c,listName);
                //     }
                // }
                if(String.isNotBlank(rtgRngVal.VGRAT1__c) && !vacuumRatingUniqueVals.contains(rtgRngVal.VGRAT1__c)) {
                    vacuumRatingUniqueVals.add(rtgRngVal.VGRAT1__c);
                    vacuumRatingOptions.add(new SelectOption(rtgRngVal.VGRAT1__c, rtgRngVal.VGRAT1__c));
                }
                if(String.isNotBlank(rtgRngVal.VGTYP1__c) && !vacuumRangeUniqueVals.contains(rtgRngVal.VGTYP1__c)) {
                    vacuumRangeUniqueVals.add(rtgRngVal.VGTYP1__c);
                    vacuumRangeOptions.add(new SelectOption(rtgRngVal.VGTYP1__c, rtgRngVal.VGTYP1__c));
                }
                if (String.isNotBlank(rtgRngVal.VGTYP1__c)) {
                    List<SelectOption> listName = new List<SelectOption>();
                    if(mapVGTYP1.containsKey(rtgRngVal.VGRAT1__c)) {
                        listName=mapVGTYP1.get(rtgRngVal.VGRAT1__c);
                        listName.add(new SelectOption(rtgRngVal.VGTYP1__c, rtgRngVal.VGTYP1__c));
                        mapVGTYP1.put(rtgRngVal.VGRAT1__c,listName);
                    } else {
                        listName.add(new SelectOption(rtgRngVal.VGTYP1__c, rtgRngVal.VGTYP1__c));
                        mapVGTYP1.put(rtgRngVal.VGRAT1__c,listName);
                    }
                } else {
                    List<SelectOption> listName = new List<SelectOption>();
                    mapVGTYP1.put(rtgRngVal.VGRAT1__c,listName);
                }
            }
        }
    }

    //TODO: Check if calculated values are valid from MasterBlaster table for CE Mark and China
    public boolean vaildateCompliance(String strComplyType,decimal minRange,decimal maxRange) {
        boolean isValid=false;
        for (RDMasterBlaster__c rd:RDMasterBlaster) {
            if (strComplyType=='PED' && (rd.CE_Mark_LL__c<=minRange && rd.CE_Mark_UL__c>maxRange)) {
                isValid=true;
                break;
            }
            if (strComplyType=='China' && (rd.China_ML_LL__c<=minRange && rd.China_ML_UL__c>maxRange)) {
                isValid=true;
                break;
            }
        }
        return isValid;
    }

    //TODO: Check if we should make these RuptureDisc__c Constraint Rules
    public List<ApexPages.Message> runConstraints() {
        List<ApexPages.Message> messages = new List<ApexPages.Message>();
        Boolean validatePressure = (currentRptDisc.Relief_Type__c=='Pressure Relief' || currentRptDisc.Relief_Type__c=='Pressure & Vacuum Relief');
        Boolean validateVacuum = (currentRptDisc.Relief_Type__c=='Vacuum Relief' || currentRptDisc.Relief_Type__c=='Pressure & Vacuum Relief');
        if(currentRptDisc.Quantity__c == null){
            messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Quantity: Please Enter a Value'));
        }
        if(currentRptDisc.Quantity__c <= 0){
            messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Quantity: Please enter a positive integer value greater than 0'));
        }
        if(validatePressure) {
            if(RGRAT1 == ''){
                messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Pressure Rating Type: Please Select a value from the dropdown'));
            }
            if(String.isBlank(RGTYP1) && currentProduct != 'PAS' && RGRAT1 != 'No Rating But Must Withstand'  && RGRAT1 != 'No Rating'){
                messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Pressure Range Type: Please Select a Value from the dropdown'));
            }

            if(RGTYP1 == 'Special') {
                if(SpecRngMin > RTPRS1) {
                    messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Special Range Min Input must be less than or equal to Pressure Setting'));
                }
                if(SpecRngMax < RTPRS1) {
                    messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Special Range Max Input must be greater than or equal to Pressure Setting'));
                }
            } else if(RGTYP1 == 'Performance Tolerance') {
                if(PerfTolMin < 0) {
                    messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Performance Tolerance Min must be greater than 0'));
                }
                if(PerfTolMax < 0) {
                    messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Performance Tolerance Min must be greater than 0'));
                }
            }
            // else if(RGRAT1 != '' && String.isBlank(RGTYP1)) {
            //     messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Range Type should to be Selected'));
            // }

        }

        if(validateVacuum) {
            if(VGRAT1 == ''){
                messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Vacuum Rating Type: Please Select a value from the dropdown'));
            }
            if(String.isBlank(VGTYP1) && currentProduct != 'CAL' && VGRAT1 != 'No Rating But Must Withstand' && VGRAT1 != 'No Rating'){
                messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Vacuum Range Type: Please Select a Value from the dropdown'));
            }

            if(VGTYP1 == 'Special') {
                if(VSpecRngMin > VTPRS1) {
                    messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Vac Special Range Min Input must be greater than or equal to Vacuum Setting'));
                }
                if(VSPecRngMax < VTPRS1) {
                    messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Vac Special Range Max Input must be greater than or equal to Pressure Setting'));
                }
            } else if(VGTYP1 == 'Performance Tolerance') { //nikhil, 19 feb
                if(VPerfTolMin < 0) {
                    messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Performance Tolerance Min must be greater than 0'));
                }
                if(VPerfTolMax < 0) {
                    messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Performance Tolerance Max must be greater than 0'));
                }
            }
            if(currentProduct == 'EV2' || currentProduct == 'EV3' || currentProduct == 'LI2'){
                if(RGRAT1 != '' && String.isNotBlank(RGTYP1) && VGRAT1 != '' && String.isNotBlank(VGTYP1)){
                    if(RGRAT1 != VGRAT1){
                        messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Pressure Rating Type and Vacuum Rating Type selection are not matching'));
                    }
                    if(RGTYP1 != VGTYP1){
                        messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Pressure Range Type and Vacuum Range Type selection are not matching'));
                    }
                    if(SpecRngMin != Null && VSpecRngMin != Null){
                        if(SpecRngMin != VSpecRngMin)
                            messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Special Range Min Input and Vacuum Special Range Min Input values are not matching'));
                        if(SpecRngMax != VSpecRngMax)
                            messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Special Range Max Input and Vacuum Special Range Max Input values are not matching'));
                    }
                    if(BPMMMin != Null && VBPMMMin != Null){
                        if(BPMMMin != VBPMMMin)
                            messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Press Burst Pressure Min Input and Vacuum Burst Pressure Min Input values are not matching'));
                    }
                }
            }
            // else if(VGRAT1 != '' && String.isBlank(VGTYP1)) {
            //     messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Range Type should to be Selected'));
            // }
        }
        // if(!String.IsBlank(currentRptDisc.PED_2014_68_EU_CE_mark__c) && currentRptDisc.PED_2014_68_EU_CE_mark__c!=null) {
        //     if (RDMasterBlaster.CE_Mark_LL__c>BURMIN || RDMasterBlaster.CE_Mark_UL__c<BURMAX) {
        //         messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Configuration or Product is invaild for certficate PED compliance (CE Mark) '+BURMIN+' BURMAX'+BURMAX+' LL'+RDMasterBlaster.CE_Mark_LL__c+'UL'+RDMasterBlaster.CE_Mark_UL__c));
        //     }
        // }
        // if(!String.IsBlank(currentRptDisc.China_Manufacturing_License__c) && currentRptDisc.China_Manufacturing_License__c!=null) {
        //     if (RDMasterBlaster.CE_Mark_LL__c>RG2MIN || RDMasterBlaster.CE_Mark_UL__c<RG2MAX) {
        //         messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Configuration or Product is invaild for certficate China ML compliance '));
        //     }
        // }
        if(currentRptDisc.KOSHA_Compliance__c!=Null) {
            if(currentRptDisc.KOSHA_Compliance__c) {
                if(RGRAT1!='Rated' && RGTYP1 != 'Zero') {
                    messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Rating Type should be Rated & Rating Range should be Zero for KOSHA Compliance'));
                }
            }
        }
        if(RGRAT1 == 'Burst Pressure Min/Max.' && RGTYP1 == 'Specify Min' && BPMMMin > RTPRS1) {
            messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Burst Pressure Min must be less than or equal to Pressure Setting'));
        }
        if(VGRAT1 == 'Burst Pressure Min/Max.' && VGTYP1 == 'Specify Min' && VBPMMMin > RTPRS1) {
            messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Vac Burst Pressure Min must be less than or equal to Pressure Setting'));
        }
        return messages;
    }

    public Decimal BMRCHECK {
        get {
            Decimal BMRCHECK = 0.0;
            if(RG3DRT != 0){
                BMRCHECK = BMR/(RG3DRT/100);
                //BMRCHECK*=100;
                return BMRCHECK.setScale(6);
            }
            else {
                return BMRCHECK.setScale(6);
            }
        }
        set {
            this.BMRCHECK = value;
        }
    }

    public Decimal TMRCHECK {
        get {
            Decimal TMRCHECK = 0.0;
            if(RG3DRT != 0){
                TMRCHECK = TMR/(RG3DRT/100);
                //TMRCHECK*=100;
                return TMRCHECK.setScale(6);
            }
            else {
                return TMRCHECK.setScale(6);
            }
        }
        set {
            this.TMRCHECK = value;
        }
    }

    public String MROPP {
        get {
            Decimal MaxRecOpPress = 0.0;
            Decimal ConvertedMROP = 0.0;
            String Direction = '';
            String ENGGATEGORY = (String) PTC.get('MfgDataTemplate__c');
            //String PTC = currentProduct;
            if(currentProduct == 'EV2' || currentProduct == 'EV3' || currentProduct == 'IS2' || currentProduct == 'PAS' || currentProduct == 'CAL')
                Direction = 'Positive Direction';
            else
                Direction = '';

            //[OPtoBpRatio == value looked up from table DiscTypeList based upon PTC]
            Decimal OPtoBpRatio = (Decimal) PTC.get('OPtoBpRatio__c');

            if(currentProduct == 'CAL'){
                if(RG2MINReal <= 10){
                    MaxRecOpPress = RG2MINReal - 1;
                }else{
                    MaxRecOpPress = RG2MINReal*0.9;
                }
            } else {
                ConvertedMROP = unitConversions.convertPressure(RTPRSU, 'psig',MaxRecOpPress).dblRetValue;
            }

            If((( ENGGATEGORY == 'REVS' || ENGGATEGORY == 'RCS') && BMR < 40) || (currentProduct == 'CPC' || currentProduct == 'CPS' || currentProduct == 'CPR' || currentProduct == 'CFC' || currentProduct == 'SFC' || currentProduct == 'CFR' || currentProduct == 'CFS' || currentProduct == 'VPC' || currentProduct == 'VPS' || currentProduct == 'VPR')){
                MaxRecOpPress = BURMIN * OPtoBpRatio;
                ConvertedMROP = unitConversions.convertPressure(RTPRSU, 'psig',MaxRecOpPress).dblRetValue;
            }
            else{
                MaxRecOpPress = BMR * OPtoBpRatio;
                ConvertedMROP = unitConversions.convertPressure(RTPRSU, 'psig',MaxRecOpPress).dblRetValue;
            }
            return Direction + unitConversions.RoundNormal(ConvertedMROP,2) + ' ' + VTPRSU + ' @ ' + RTTMSP.setScale(2) + ' ' + RTTMUN;
        }
        set {
            this.MROPP = value;
        }
    }

    public String MROPV {
        get {
            Decimal MaxRecOpPress = 0.0;
            Decimal ConvertedMROP = 0.0;
            String Direction = '';

            if(currentProduct == 'EV2' || currentProduct == 'EV3' || currentProduct == 'IS2' || currentProduct == 'PAS' || currentProduct == 'CAL'){
                Direction = 'Vacuum Direction';
            } else {
                Direction = '';
            }

            //[OPtoBpRatio == value looked up from table DiscTypeList based upon PTC]
            Decimal OPtoBpRatio = (Decimal) PTC.get('OPtoBpRatio__c');

            if(currentProduct == 'CAL'){
                if(RG2MINReal <= 10){
                    MaxRecOpPress = VG2MINReal - 1;
                }
                else{
                    MaxRecOpPress = VG2MINReal*0.9;
                }
            }
            else{
                MaxRecOpPress = VBMR * OPtoBpRatio;
                ConvertedMROP = unitConversions.convertPressure(VTPRSU, 'psig',MaxRecOpPress).dblRetValue;
            }
            return Direction + unitConversions.RoundNormal(ConvertedMROP, 2) + ' ' + VTPRSU + ' @ ' + RTTMSP.setScale(2) + ' ' + RTTMUN;
        }
        set {
            this.MROPV = value;
        }
    }


    public String GTAG02  {
        get {//= ORP010
            return ORP010;
        }
        set {
            this.GTAG02 = value;
        }
    }

    public String GTAG03  {
        get {//= ORP015
            return ORP015;
        }
        set {
            this.GTAG03 = value;
        }
    }

    public String GTAG04  {
        get {//= ORP027
            return ORP027;
        }
        set {
            this.GTAG04 = value;
        }
    }

    public String GTAG05  {
        get {//= ORP010
            return ORP010;
        }
        set {
            this.GTAG05 = value;
        }
    }

    public String GTAG06 {
        get {//= ORP015
            return ORP015;
        }
        set {
            this.GTAG06 = value;
        }
    }

    public String GTAG07  {
        get {//= ORP027
            return ORP027;
        }
        set {
            this.GTAG07 = value;
        }
    }

    public Map<string,string> getMapDetails() {
        Map<String, string> myMap1 = new Map<String, string>();
        myMap1.put('GTAG07',String.isBlank(GTAG07)?'':GTAG07);
        myMap1.put('GTAG06',String.isBlank(GTAG06)?'':GTAG06);
        myMap1.put('GTAG05',String.isBlank(GTAG05)?'':GTAG05);
        myMap1.put('GTAG04',String.isBlank(GTAG04)?'':GTAG04);
        myMap1.put('GTAG03',String.isBlank(GTAG03)?'':GTAG03);
        myMap1.put('GTAG02',String.isBlank(GTAG02)?'':GTAG02);
        return myMap1;
    }

}