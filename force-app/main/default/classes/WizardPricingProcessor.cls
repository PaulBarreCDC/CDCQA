/**
* @File Name          : WizardPricingProcessor.cls
* @Description        :
* @Author             : ApexIT - SFDC Dev Team
* @Group              :
* @Last Modified By   : Nikhil Arpally
* @Last Modified On   : 11-02-2020
* @Modification Log   :
* Ver       Date            Author      		    Modification
* 1.0    22/5/2020   ApexIT - SFDC Dev Team     Initial Version
**/
public class WizardPricingProcessor {
    public WizardPricingProcessor() {
        //Default Constructor
    }
    public WizardPricingProcessor (id recordId) {
        Result rupRecord=wizardBaseDataProcessor.getObjectDataById(recordId);
        Result rupPrzRecord=wizardBaseDataProcessor.getRDPricingByProdId(recordId);
        if (rupRecord.bResult) {
            rdRecord= (Rupture_Disc__c) rupRecord.objResultList[0];
        }
        if (rupPrzRecord.bResult) {
            rdPricing= (RD_Pricing__c) rupPrzRecord.objResultList[0];
        } else {
            RD_Pricing__c rdPricing=new RD_Pricing__c();
        }
        System.debug('rdPricing: ' + rdPricing);
        System.debug('rdPricing: ' + recordId);
        //if(rdRecord!=null)
        //rtgRngWrap = new RDRatingRange(rdRecord);
        //ROBU=new RdOutputBaseUtility(recordID);
    }
    public Rupture_Disc__c rdRecord{get; set;}
    public RD_Pricing__c rdPricing{get; set;}
    //public RDRatingRange rtgRngWrap  {get;set;}
    public String MCHO {
        get {
            return rdRecord.Material_Outlet__c;
        }
        set {
        //    rdRecord.Material_Outlet__c = value;
            this.MCHO = value;
        }
    }
    public string SURFFINISH {
        get {
            return rdRecord.Surface_Finish__c;
        }
        set {
            this.SURFFINISH=value;
        }
    }
    public string ELECTROPOL {
        get {
            return rdRecord.Electro_polish__c==true?'Y':'N';
        }
        set {
            this.ELECTROPOL=value;
        }
    }
    public String MCHRNG {
        get {
            return rdRecord.Material_Holddown_Ring__c;
        }
        set {
          //  rdRecord.Material_Holddown_Ring__c = value;
            this.MCHRNG = value;
        }
    }
    public String MCAR {
        get {
            return rdRecord.Material_Arcuate_Ring__c;
        }
        set {
           // rdRecord.Material_Arcuate_Ring__c = value;
            this.MCAR = value;
        }
    }
    public boolean NarrowByFlow {
        get {
            return rdRecord.constrain_product_selection_by_flow__c=='Yes'?true:false;
        }
        set;
    }
    public String MCGR1 {
        get {
            return rdRecord.Material_Armor_Ring__c;
        }
        set {
           // rdRecord.Material_Armor_Ring__c = value;
            this.MCGR1 = value;
        }
    }

    public String MCOG {
        get {
            return rdRecord.Material_Outlet_Gasket__c;
        }
        set {
          //  rdRecord.Material_Outlet_Gasket__c = value;
            this.MCOG = value;
        }
    }

    public String MCGR2 {
        get {
            return rdRecord.Material_Armor_Ring2__c;
        }
        set {
           // rdRecord.Material_Armor_Ring2__c = value;
            this.MCGR2 = value;
        }
    }

    public String MCOR {
        get {
            return rdRecord.Material_Outlet_Ring__c  ;
        }
        set {
            //rdRecord.Material_Outlet_Ring__c = value;
            this.MCOR = value;
        }
    }
    public String MCDP {
        get {
            return rdRecord.Material_Dent_Protector__c;
        }
        set {
           // rdRecord.Material_Dent_Protector__c   = value;
            this.MCDP = value;
        }
    }

    public String MCOL {
        get {
            return rdRecord.Material_Outlet_Liner__c;
        }
        set {
        //    rdRecord.Material_Outlet_Liner__c = value;
            this.MCOL = value;
        }
    }
    public String MCVS1 {
        get {
            return rdRecord.Material_Vacuum_Support__c;
        }
        set {
           // rdRecord.Material_Vacuum_Support__c = value;
            this.MCVS1 = value;
        }
    }
    public String MCOC {
        get {
            return rdRecord.Material_Outlet_Coating__c;
        }
        set {
        //    rdRecord.Material_Outlet_Coating__c = value;
            this.MCOC = value;
        }
    }
    public String MCDT1 {
        get {
            return rdRecord.Material_Top_Section__c  ;
        }
        set {
        //    rdRecord.Material_Top_Section__c = value;
            this.MCDT1 = value;
        }
    }
    public String MCDD {
        get {
            return rdRecord.Material_Disc__c;
        }
        set {
        //    rdRecord.Material_Disc__c = value;
            this.MCDD = value;
        }
    }
    public String MCSS1 {
        get {
            return rdRecord.Material_Seal__c;
        }
        set {
        //    rdRecord.Material_Seal__c = value;
            this.MCSS1 = value;
        }
    }
    public String MCGD {
        get {
            return rdRecord.Material_Girdle__c;
        }
        set {
        //    rdRecord.Material_Girdle__c = value;
            this.MCGD = value;
        }
    }
    public String MCSS2 {
        get {
            return rdRecord.Material_Seal2__c;
        }
        set {
        //    rdRecord.Material_Seal2__c = value;
            this.MCSS2 = value;
        }
    }
    public String MCDT2 {
        get {
            return rdRecord.Material_Top_Section2__c;
        }
        set {
        //    rdRecord.Material_Top_Section2__c = value;
            this.MCDT2 = value;
        }
    }

    public String MCIC1 {
        get {
            return rdRecord.Material_Inlet_Coating__c;
        }
        set {
        //    rdRecord.Material_Inlet_Coating__c = value;
            this.MCIC1 = value;
        }
    }
    public String MCSS3 {
        get {
            return rdRecord.Material_Seal3__c;
        }
        set {
        //    rdRecord.Material_Seal3__c = value;
            this.MCSS3 = value;
        }
    }

    public String MCIR1 {
        get {
            return rdRecord.Material_Inlet_Ring__c;
        }
        set {
        //    rdRecord.Material_Inlet_Ring__c = value;
            this.MCIR1 = value;
        }
    }
    public String MCIL {
        get {
            return rdRecord.Material_Inlet_Liner__c;
        }
        set {
        //    rdRecord.Material_Inlet_Liner__c = value;
            this.MCIL = value;
        }
    }
    public String MCIR2 {
        get {
            return rdRecord.Material_Inlet_Ring2__c;
        }
        set {
        //    rdRecord.Material_Inlet_Ring2__c = value;
            this.MCIR2 = value;
        }
    }
    public String MCVS2 {
        get {
            return rdRecord.Material_Vacuum_Support2__c  ;
        }
        set {
        //    rdRecord.Material_Vacuum_Support2__c  = value;
            this.MCVS2 = value;
        }
    }
    public String MCIC2 {
        get {
            return rdRecord.Material_Inlet_Coating2__c;
        }
        set {
        //    rdRecord.Material_Inlet_Coating2__c = value;
            this.MCIC2 = value;
        }
    }
    public String MCIR3 {
        get {
            return rdRecord.Material_Inlet_Ring3__c;
        }
        set {
        //    rdRecord.Material_Inlet_Ring3__c = value;
            this.MCIR3 = value;
        }
    }
    public String MCHS {
        get {
            return rdRecord.Material_Handling_Support__c;
        }
        set {
        //    rdRecord.Material_Handling_Support__c = value;
            this.MCHS = value;
        }
    }
    public String MCIG {
        get {
            return rdRecord.Material_Inlet_Gasket__c;
        }
        set {
        //    rdRecord.Material_Inlet_Gasket__c = value;
            this.MCIG = value;
        }
    }
    public String MCHT {
        get {
            return rdRecord.Material_Hi_Temp_Assembly__c;
        }
        set {
        //    rdRecord.Material_Hi_Temp_Assembly__c = value;
            this.MCHT = value;
        }
    }
    public String MCTSOR {
        get {
            return rdRecord.Material_Inlet_O_Ring__c;
        }
        set {
        //    rdRecord.Material_Inlet_O_Ring__c = value;
            this.MCTSOR = value;
        }
    }
    public String MCHI {
        get {
            return rdRecord.Material_Inlet__c;
        }
        set {
        //    rdRecord.Material_Inlet__c = value;
            this.MCHI = value;
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
    public string MCSM {
        get {
            // string strMCSM='';
            // if(MCSS!='070' || MCSS!='071' || MCSS!='072' || MCSS!='073')
            //     return strMCSM=MCSS;
            // else if(MCSS=='070' || MCSS=='071' || MCSS=='072' || MCSS=='073')
            //     return strMCSM=MCDT;
            // else
            //     return strMCSM;
            return rdRecord.MCSM__c==null?'':rdRecord.MCSM__c;
        }
        set {
            this.MCSM = value;
        }
    }
    public string MCGR {
        get {
            string strMCGR='';
            if(MCGR1!=null)
                return strMCGR=MCGR1;
            else if(MCGR2!=null)
                return strMCGR=MCGR2;
            else
                return strMCGR;
        }
        set {
            this.MCGR = value;
        }
    }
    public String MCVS3 {
        get {
            return rdRecord.Material_Vaccum_Support3__c  ;
        }
        set {
        //    rdRecord.Material_Vaccum_Support3__c= value;
            this.MCVS3 = value;
        }
    }
    public String PTC {
        get {
            return rdRecord.Product__c;
        }
        set {
            //rdRecord.Product__c = value;
            this.PTC = value;
        }
    }
    public String SZC {
        get {
            return ConstantsUtil.getSizeDesc(rdRecord.Size__c).SZC==null?'0002':ConstantsUtil.getSizeDesc(rdRecord.Size__c).SZC;
        }
        set {
            //rdRecord.SZC = value;
            this.SZC = value;
        }
    }
    public String STC {
        get {
            return rdRecord.Seat__c;
        }
        set {
            //rdRecord.SZC = value;
            this.STC = value;
        }
    }
    public integer QTY {
        get {

            integer Ln;
            if(rdRecord.Quantity__c==null)
                Ln=0;
            else
                Ln=integer.valueOf(rdRecord.Quantity__c);
            return Ln;
        }
        set {
            //rdRecord.SZC = value;
            this.QTY = value;
        }
    }
    public decimal decSZC {
        get {
            decimal decsize=0.0;
            string strsize='';
            strsize=rdRecord.Size__c;
            if(String.isNotBlank(strsize))
            {
                decsize= (decimal) ConstantsUtil.getSizeDesc(strsize).SizeValue;
            }
            return decsize;
        }
        set {
            // rdRecord.Size__c = String.valueOf(value);
            this.decSZC = value;
        }
    }
    public string MCVS {
        get {
            string strMCVS='';
            if(MCVS1!=null)
                return strMCVS=MCVS1;
            else if(MCVS2!=null)
                return strMCVS=MCVS2;
            else if(MCVS3!=null)
                return strMCVS=MCVS3;
            else
                return strMCVS;
        }
        set {
            this.MCVS = value;
        }
    }
    public string MCIC {
        get {
            string strMCIC='';
            if(MCIC1!=null)
                return strMCIC=MCIC1;
            else if(MCIC2!=null)
                return strMCIC=MCIC2;
            else
                return strMCIC;
        }
        set {
            this.MCIC = value;
        }
    }
    public string MCBS {
        get {
            //string strMCBS='';
            return rdRecord.Strip_Type__c;

        }
        set {
            this.MCBS = value;
        }
    }
    public String BCT {
        get {
            return rdRecord.Wire_Type__c;
        }
        set {
        //    rdRecord.Wire_Type__c = value;
            this.BCT = value;
        }
    }
    public String BCL {
        get {
            return rdRecord.Cable_Length__c;
        }
        set {
        //    rdRecord.Cable_Length__c = value;
            this.BCL = value;
        }
    }
    public String BEC {
        get {
            return rdRecord.End_Connection__c;
        }
        set {
        //    rdRecord.End_Connection__c = value;
            this.BEC = value;
        }
    }
    public string MCIR {
        get {
            string strMCIR='';
            if(MCIR1!=null)
                return strMCIR=MCIR1;
            else if(MCIR2!=null)
                return strMCIR=MCIR2;
            else if(MCIR3!=null)
                return strMCIR=MCIR3;
            else
                return strMCIR;
        }
        set {
            this.MCIR = value;
        }
    }
    public string DPM {
        get {
            return rdRecord.Is_there_a_liquid_relief_scenario__c=='Yes'?'Y':'N';
        }
        set {
            // rdRecord.Is_there_a_liquid_relief_scenario__c = value;
            this.DPM = value;
        }

    }
    public String PMI {
        get {
            return rdRecord.PMI__c;
        }
        set {
            //rdRecord.PMI__c = value;
            this.PMI = value;
        }
    }
    public string AssignedRangeType {
        get {
            return rdRecord.Assigned_RangeType__c==null?'':rdRecord.Assigned_RangeType__c;

        }
        set {
            this.AssignedRangeType = value;
        }
    }
    public string VAssignedRangeType {
        get {
            return rdRecord.VAssignedRangeType__c==null?'':rdRecord.VAssignedRangeType__c;

        }
        set {
            this.VAssignedRangeType = value;
        }
    }

    public decimal RG3DRT {
        get {
            return rdRecord.RG3DRT__c==null?0:rdRecord.RG3DRT__c;

        }
        set {
            this.RG3DRT = value;
        }
    }
    public decimal VG3DRT {
        get {
            return rdRecord.VG3DRT__c==null?0:rdRecord.VG3DRT__c;

        }
        set {
            this.VG3DRT = value;
        }
    }
    public decimal TMR {
        get {
            return rdRecord.TMR__c==null?0:rdRecord.TMR__c;
        }
        set {
            this.TMR = value;
        }
    }

    public decimal VTMR {
        get {
            return rdRecord.VTMR__c==null?0:rdRecord.VTMR__c;

        }
        set {
            this.VTMR = value;
        }
    }

    public decimal FinalTMRFloat {
        get {
            if(PTC=='PAS'){
                return VTMRFloat;
            }else{
                return TMRFloat;
            }
        }
        set {
            this.FinalTMRFloat = value;
        }
    }

    public String FinalAssignedRangeType {
        get {
            if(PTC=='PAS'){
                return VAssignedRangeType;
            }else{
                return AssignedRangeType;
            }
        }
        set {
            this.FinalAssignedRangeType = value;
        }
    }

    public decimal TMRFloat {
        get {
            if(TMR>0 && RG3DRT != 0){
                return TMRFloat = TMR/(RG3DRT/100);
            }
            else if(TMR>0  && RG3DRT == 0){
                return TMRFloat = TMR;
            }
            else if(rdRecord.Pressure_Rating_Type__c == 'No Rating But Must Withstand'){
                return TMRFloat = rdRecord.Converted_Positive_Pressure_Value__c;
            }
            return rdRecord.TMR__c==null?0:rdRecord.TMR__c;
        }
        set {
            this.TMRFloat = value;
        }
    }

    public decimal VTMRFloat {
        get {
            if(VTMR>0  && VG3DRT != 0){
                return VTMRFloat = VTMR/(VG3DRT/100);
            }
            else if(VTMR>0  && VG3DRT == 0){
                return VTMRFloat = VTMR;
            }
            else if(rdRecord.Vac_Rating_Type__c == 'No Rating But Must Withstand'){
                return VTMRFloat = rdRecord.Converted_Back_Pressure_Value__c;
            }
            return rdRecord.VTMR__c==null?0:rdRecord.VTMR__c;
        }
        set {
            this.VTMRFloat = value;
        }
    }
    public String ADMERK {
        get {

            return rdRecord.Comply_with_AD2000_Merkblat_A1__c==false?'N':'Y';
        }
        set {
            this.ADMERK =  value;
        }
    }
    // public String RPVM048 {
    //     get {

    //         return rdRecord.Comply_with_AD2000_Merkblat_A1__c==false?'N':'Y';
    //     }
    //     set {
    //         this.RPVM048 =  value;
    //     }
    // }
    public String  RPVM084 {
        get {

            return rdRecord.Comply_with_Regels_Voor_Tosellan_Oder_Dr__c==false?'N':'Y';
            //return strRPVM084;
        }
        set {
            this.RPVM084 =  value;
        }
    }
    public String  CHINAMFG {
        get {
            return rdRecord.China_Manufacturing_License__c=='NoneCML'?'N':rdRecord.China_Manufacturing_License__c;
        }
        set {
        //    rdRecord.China_Manufacturing_License__c = value;
            this.CHINAMFG = value;
        }
    }
    public String ASME {
        get {

            String strASME= rdRecord.ASME_Section_VIII_Division_1__c==false?'N':'8';
            return strASME;
        }
        set {
            this.ASME =  value;
        }
    }

    public String  PED {
        get {
            return (rdRecord.PED_2014_68_EU_CE_mark__c=='NonePED'||rdRecord.PED_2014_68_EU_CE_mark__c==null)?'N':rdRecord.PED_2014_68_EU_CE_mark__c;
        }
        set {
        //    rdRecord.PED_2014_68_EU_CE_mark__c = value;
            this.PED = value;
        }
    }
    public String TMPTSTASME {
        get {
            String strTMPTSTASME= rdRecord.Temperature_Test_per_ASME__c==false?'N':'8';
            return strTMPTSTASME;
        }
        set {
            this.TMPTSTASME =  value;
        }
    }
    public String addIntegralBDI {
        get {
            String straddIntegralBDI= rdRecord.Add_Integral_B_D_I_Integral_BDI_FLX_Sen__c?'y':'n';
            return straddIntegralBDI;
        }
        set {
            this.addIntegralBDI =  value;
        }
    }
    public Decimal  RTTMDF {
        get {
            return rdRecord.Converted_Temperature_Setting__c;
        }
        set {
        //    rdRecord.Converted_Temperature_Setting__c = value;
            this.RTTMDF = value;
        }
    }
    public String NACE {
        get {
            return rdRecord.NACE__c;
        }
        set {
        //    rdRecord.NACE__c = value;
            this.NACE = value;
        }
    }
    public String CLEAN {
        get {
            return rdRecord.Cleanings__c;
        }
        set {
            //rdRecord.NACE__c = value;
            this.CLEAN = value;
        }
    }
    public String CSPECS {
        get {
            return rdRecord.Mark_Pack_Clean__c;
        }
        set {
            //rdRecord.NACE__c = value;
            this.CSPECS = value;
        }
    }


    public static Map<string,string> mapNonDiscountableFields {
        get {
            return new Map<String, String>
            {
                'AsmeCeLotChargeA'  => 'ASME_CE_or_Temp_Test_Lot_Charge__c',
                    'ThirdPartyLotChargeA'  => 'Third_Party_Lot_Charge__c',
                    'LiqLotCharge'  => 'Liquid_Test_Lot_Charge__c',
                    'GraphiteLotA'  => 'Graphite_Rupture_Disc_Lot_Charge__c',
                    'SpecAssyLotChargeA'  => 'Special_Assembly_Lot_Charge__c',
                    'PMILotCharge'  => 'PMI_Lot_Charge__c',
                    'BackPressureLotCharge'  => 'Back_Pressure_Lot_Charge__c',
                    'NaceLotCharge'  => 'NACE_Lot_Charge__c',
                    'CUTRLotCharge'  => 'CUTR_Lot_Charge__c',
                    'KOSHALotCharge'  => 'KOSHA_Lot_Charge__c',
                    'CSALotCharge'  => 'CSA_Lot_Charge__c',
                    'ATEXLotCharge'  => 'ATEX_Lot_Charge__c'
                    };
                        }
        set  {
            mapNonDiscountableFields = value;
        }
    }
    public static Map<string,string> mapDiscountableFields {
        get {
            return new Map<String, String>
            {
                'BaseDiscPriceA'  => 'Base_Rupture_Disc_Price_Each__c',
                    // 'TopSecDisc'=>'Rupture_Disc_or_Top_Section_Price_Each__c',
                    // 'SealA'=>'Seal_Price_Each_Override__c',
                    // 'GirdleA'=>'Girdle_Price_Each__c',
                    'MfgRngA'  => 'Manufacturing_Range_Price_Adder__c',
                    'VacSup'  => 'Vacuum_Support_Price_Each__c',
                    //'Ring'  => 'Rings_Price_Adder__c',
                    'ORing'=>'Outlet_Ring_Price_Each__c',
                    'IRing'=>'Inlet_Ring_Price_Each__c',
                    //'Gasket'  => 'Gaskets_Price_Adder__c',
                    'IGasket'=>'Inlet_Gasket_Price_Each__c',
                    'OGasket'=>'Outlet_Gasket_Price_Each__c',
                    //'Liner'  => 'Liners_Price_Adder__c',
                    'ILiner'=>'Inlet_Liner_Price_Each__c',
                    'OLiner'=>'Outlet_Liner_Price_Each__c',
                    //'Coating'  => 'Coatings_Price_Adder__c',
                    'ICoating'=>'Inlet_Coating_Price_Each__c',
                    'OCoating'=>'Outlet_Coating_Price_Each__c',
                    'IntBDIA'  => 'Integral_BDI_Price_Each__c',
                    'IntBDIWireA'  => 'Integral_BDI_Custom_Wiring_Price_Each__c',
                    'CleaningA'  => 'Cleaning_Price_Each__c',
                    'IndPack'  => 'Individual_Packaging_Price_Each__c',
                    //'Holder'  => 'Holders_Price_Adder__c',
                    'IHolder'=>'Holder_Inlet_Price_Each__c',
                    'OHolder'=>'Holder_Outlet_Price_Each__c',
                    'HDRingHolder'=>'Holder_Holddown_Ring_Price_Each__c',
                    'HandSup'  => 'Handling_Support_Price_Each__c',
                    'DentProt'  => 'Dent_Protector_Price_Each__c',
                    'ArmorRing'  => 'Armor_Ring__c',
                    'surfFinish'  => 'Surface_Finish_Electropolish_Price_Each__c',
                    'SpecAssyPriceAddA'  => 'Special_Assembly_Price_Each_Adder__c',
                    'thirdPartyTestDiscPriceEach'  => 'Third_Party_Test_Disc_Price_Each__c'
                    };
                        }
        set  {
            mapDiscountableFields = value;
        }
    }
    public static Map<string,string> mapPricingfields {
        get {
            return new Map<String, String>
            {
                'TopSecDisc'=>'Rupture_Disc_or_Top_Section_Price_Each__c',
                    'SealA'=>'Seal_Price_Each__c',
                    'GirdleA'=>'Girdle_Price_Each__c',
                    'BaseDiscPriceA'  => 'Base_Rupture_Disc_Price_Each__c',
                    'MfgRngA'  => 'Manufacturing_Range_Price_Adder__c',
                    'VacSup'  => 'Vacuum_Support_Price_Each__c',
                    'Ring'  => 'Rings_Price_Adder__c',
                    'ORing'=>'Outlet_Ring_Price_Each__c',
                    'IRing'=>'Inlet_Ring_Price_Each__c',
                    'Gasket'  => 'Gaskets_Price_Adder__c',
                    'IGasket'=>'Inlet_Gasket_Price_Each__c',
                    'OGasket'=>'Outlet_Gasket_Price_Each__c',
                    'Liner'  => 'Liners_Price_Adder__c',
                    'ILiner'=>'Inlet_Liner_Price_Each__c',
                    'OLiner'=>'Outlet_Liner_Price_Each__c',
                    'Coating'  => 'Coatings_Price_Adder__c',
                    'ICoating'=>'Inlet_Coating_Price_Each__c',
                    'IHolder'=>'Holder_Inlet_Price_Each__c',
                    'OHolder'=>'Holder_Outlet_Price_Each__c',
                    'HDRingHolder'=>'Holder_Holddown_Ring_Price_Each__c',
                    'OCoating'=>'Outlet_Coating_Price_Each__c',
                    'IntBDIA'  => 'Integral_BDI_Price_Each__c',
                    'IntBDIWireA'  => 'Integral_BDI_Custom_Wiring_Price_Each__c',
                    'CleaningA'  => 'Cleaning_Price_Each__c',
                    'IndPack'  => 'Individual_Packaging_Price_Each__c',
                    'Holder'  => 'Holders_Price_Adder__c',
                    'HandSup'  => 'Handling_Support_Price_Each__c',
                    'DentProt'  => 'Dent_Protector_Price_Each__c',
                    'ArmorRing'  => 'Armor_Ring__c',
                    'surfFinish'  => 'Surface_Finish_Electropolish_Price_Each__c',
                    'SpecAssyPriceAddA'  => 'Special_Assembly_Price_Each_Adder__c',
                    'thirdPartyTestDiscPriceEach'  => 'Third_Party_Test_Disc_Price_Each__c',
                    'AsmeCeLotChargeA'  => 'ASME_CE_or_Temp_Test_Lot_Charge__c',
                    'ThirdPartyLotChargeA'  => 'Third_Party_Lot_Charge__c',
                    'LiqLotCharge'  => 'Liquid_Test_Lot_Charge__c',
                    'GraphiteLotA'  => 'Graphite_Rupture_Disc_Lot_Charge__c',
                    'SpecAssyLotChargeA'  => 'Special_Assembly_Lot_Charge__c',
                    'PMILotCharge'  => 'PMI_Lot_Charge__c',
                    'BackPressureLotCharge'  => 'Back_Pressure_Lot_Charge__c',
                    'NaceLotCharge'  => 'NACE_Lot_Charge__c',
                    'CUTRLotCharge'  => 'CUTR_Lot_Charge__c',
                    'KOSHALotCharge'  => 'KOSHA_Lot_Charge__c',
                    'CSALotCharge'  => 'CSA_Lot_Charge__c',
                    'ATEXLotCharge'  => 'ATEX_Lot_Charge__c'
                    };
                        }
        set  {
            mapPricingfields = value;
        }
    }
    public static Map<string,string> mapPricingOverriddenfields {
        get {
            return new Map<String, String>
            {
                'TopSecDisc'=>'Rupture_Disc_TopSect_Price_Each_Override__c',
                    'SealA'=>'Seal_Price_Each_Override__c',
                    'GirdleA'=>'Girdle_Price_Each_Override__c',
                    'BaseDiscPriceA'  => 'Base_Rupture_Disc_Price_Each_Override__c',
                    'MfgRngA'  => 'Manufacturing_Range_Price_Adder_Override__c',
                    'VacSup'  => 'Vacuum_Support_Price_Each_Override__c',
                    'IRing'=>'Inlet_Ring_Price_Each_Override__c',
                    'ORing'=>'Outlet_Ring_Price_Each_Override__c',
                    'Ring'  => 'Ring_s_Price_Adder_Override__c',
                    'Gasket'  => 'Gasket_s_Price_Adder_Override__c',
                    'IGasket'=>'Inlet_Gasket_Price_Each_Override__c',
                    'OGasket'=>'Outlet_Gasket_Price_Each_Override__c',
                    'Liner'  => 'Liner_s_Price_Adder_Override__c',
                    'ILiner'=>'Inlet_Liner_Price_Each_Override__c',
                    'OLiner'=>'Outlet_Liner_Price_Each_Override__c',
                    'Coating'  => 'Coating_s_Price_Adder_Override__c',
                    'ICoating'=>'Inlet_Coating_Price_Each_Override__c',
                    'OCoating'=>'Outlet_Coating_Price_Each_Override__c',
                    'IHolder'=>'Holder_Inlet_Price_Each_Override__c',
                    'OHolder'=>'Holder_Outlet_Price_Each_Override__c',
                    'HDRingHolder'=>'Holder_Holddown_Ring_Price_Each_Override__c',
                    'IntBDIA'  => 'Integral_BDI_Price_Each_Override__c',
                    'IntBDIWireA'  => 'Integral_BDICustWiring_PriceEch_Override__c',
                    'CleaningA'  => 'Cleaning_Price_Each_Override__c',
                    'IndPack'  => 'Individual_Packaging_Price_Each_Override__c',
                    'Holder'  => 'Holder_Price_Adder_Override__c',
                    'HandSup'  => 'Handling_Support_Price_Each_Override__c',
                    'DentProt'  => 'Dent_Protector_Price_Each_Override__c',
                    'ArmorRing'  => 'Armor_Ring_Override__c',
                    'surfFinish'  => 'Surface_FinishElectropolishPriceOverride__c',
                    'SpecAssyPriceAddA'  => 'Special_Assembly_PriceEch_Adder_Override__c',
                    'thirdPartyTestDiscPriceEach'  => 'Third_Party_Test_DiscPrice_Each_Override__c',
                    'AsmeCeLotChargeA'  => 'ASME_CE_or_Temp_Test_LotCharge_Override__c',
                    'ThirdPartyLotChargeA'  => 'Third_Party_Lot_Charge_Override__c',
                    'LiqLotCharge'  => 'Liquid_Test_Lot_Charge_Override__c',
                    'GraphiteLotA'  => 'Graphite_Rupture_Disc_LotCharge_Override__c',
                    'SpecAssyLotChargeA'  => 'Special_Assembly_Lot_Charge_Override__c',
                    'PMILotCharge'  => 'PMI_Lot_Charge_Override__c',
                    'BackPressureLotCharge'  => 'Back_Pressure_Lot_Charge_Override__c',
                    'NaceLotCharge'  => 'NACE_Lot_Charge_Override__c',
                    'CUTRLotCharge'  => 'CUTR_Lot_Charge_Override__c',
                    'KOSHALotCharge'  => 'KOSHA_Lot_Charge_Override__c',
                    'CSALotCharge'  => 'CSA_Lot_Charge_Override__c',
                    'ATEXLotCharge'  => 'ATEX_Lot_Charge_Overide__c'
                    };
                        }
        set  {
            mapPricingOverriddenfields = value;
        }
    }

    /* public Map<string,string> mapPricingfields {
get {
return new Map<String, String>
{
'Shippable Quantity'  => 'Shippable_Quantity__c',
'Qty of Test Rupture Discs Charged for'  => 'Qty_of_Test_Rupture_Discs_Charged_for__c',
'Base Rupture Disc Price Each'  => 'Base_Rupture_Disc_Price_Each__c',
'Quantity Discount Multiplier'  => 'Quantity_Discount_Multiplier__c',
'Rupture Disc or Top Section Price Each'  => 'Rupture_Disc_or_Top_Section_Price_Each__c',
'Seal Price Each'  => 'Seal_Price_Each__c',
'Girdle Price Each'  => 'Girdle_Price_Each__c',
'Manufacturing Range Price Adder'  => 'Manufacturing_Range_Price_Adder__c',
'Vacuum Support Price Each'  => 'Vacuum_Support_Price_Each__c',
'Inlet Ring Price Each'  => 'Inlet_Ring_Price_Each__c',
'Outlet Ring Price Each'  => 'Outlet_Ring_Price_Each__c',
'Inlet Gasket Price Each'  => 'Inlet_Gasket_Price_Each__c',
'Outlet Gasket Price Each'  => 'Outlet_Gasket_Price_Each__c',
'Inlet Liner Price Each'  => 'Inlet_Liner_Price_Each__c',
'Outlet Liner Price Each'  => 'Outlet_Liner_Price_Each__c',
'Inlet Coating Price Each'  => 'Inlet_Coating_Price_Each__c',
'Outlet Coating Price Each'  => 'Outlet_Coating_Price_Each__c',
'Integral BDI Price Each'  => 'Integral_BDI_Price_Each__c',
'Integral BDI Custom Wiring Price Each'  => 'Integral_BDI_Custom_Wiring_Price_Each__c',
'Cleaning Price Each'  => 'Cleaning_Price_Each__c',
'Individual Packaging Price Each'  => 'Individual_Packaging_Price_Each__c',
'Holder Inlet Price Each'  => 'Holder_Inlet_Price_Each__c',
'Holder Outlet Price Each'  => 'Holder_Outlet_Price_Each__c',
'Holder Holddown Ring Price Each'  => 'Holder_Holddown_Ring_Price_Each__c',
'Handling Support Price Each'  => 'Handling_Support_Price_Each__c',
'Dent Protector Price Each'  => 'Dent_Protector_Price_Each__c',
'Graphite Rupture Disc Price Each'  => 'Graphite_Rupture_Disc_Price_Each__c',
'Third Party Test Disc Price Each'  => 'Third_Party_Test_Disc_Price_Each__c',
'Surface Finish/Electropolish Price Each'  => 'Surface_Finish_Electropolish_Price_Each__c',
'ASME, CE or Temp Test Lot Charge'  => 'ASME_CE_or_Temp_Test_Lot_Charge__c',
'Third Party Witness Test Lot Charge'  => 'Third_Party_Witness_Test_Lot_Charge__c',
'Liquid Test Lot Charge'  => 'Liquid_Test_Lot_Charge__c',
'Graphite Rupture Disc Lot Charge'  => 'Graphite_Rupture_Disc_Lot_Charge__c',
'PMI Lot Charge'  => 'PMI_Lot_Charge__c',
'Back Pressure Lot Charge'  => 'Back_Pressure_Lot_Charge__c',
'NACE Lot Charge'  => 'NACE_Lot_Charge__c',
'CUTR Lot Charge'  => 'CUTR_Lot_Charge__c',
'Special Assembly Lot Charge'  => 'Special_Assembly_Lot_Charge__c'
};
}
set  {
mapPricingfields = value;
}
decimal ILiner=0;
decimal OLiner=0;
decimal ICoating=0;
decimal OCoating=0;
}
decimal IHolder=0;
decimal OHolder=0;
decimal HDRingHolder=0;
public Map<string,string> mapPricingOverriddenfields {
get {
return new Map<String, String>
{
'ASME, CE or Temp Test LotCharge Override'  => 'ASME_CE_or_Temp_Test_LotCharge_Override__c',
'Back Pressure Lot Charge Override'  => 'Back_Pressure_Lot_Charge_Override__c',
'Base Rupture Disc Price Each Override'  => 'Base_Rupture_Disc_Price_Each_Override__c',
'Cleaning Price Each Override'  => 'Cleaning_Price_Each_Override__c',
'CUTR Lot Charge Override'  => 'CUTR_Lot_Charge_Override__c',
'Dent Protector Price Each Override'  => 'Dent_Protector_Price_Each_Override__c',
'Girdle Price Each Override'  => 'Girdle_Price_Each_Override__c',
'Graphite Rupture Disc LotCharge Override'  => 'Graphite_Rupture_Disc_LotCharge_Override__c',
'Graphite Rupture DiscPrice Each Override'  => 'Graphite_Rupture_DiscPrice_Each_Override__c',
'Handling Support Price Each Override'  => 'Handling_Support_Price_Each_Override__c',
'Holder Holddown Ring Price Each Override'  => 'Holder_Holddown_Ring_Price_Each_Override__c',
'Holder Inlet Price Each Override'  => 'Holder_Inlet_Price_Each_Override__c',
'Holder Outlet Price Each Override'  => 'Holder_Outlet_Price_Each_Override__c',
'Individual Packaging Price Each Override'  => 'Individual_Packaging_Price_Each_Override__c',
'Inlet Coating Price Each Override'  => 'Inlet_Coating_Price_Each_Override__c',
'Inlet Gasket Price Each Override'  => 'Inlet_Gasket_Price_Each_Override__c',
'Inlet Liner Price Each Override'  => 'Inlet_Liner_Price_Each_Override__c',
'Inlet Ring Price Each Override'  => 'Inlet_Ring_Price_Each_Override__c',
'Integral BDI Price Each Override'  => 'Integral_BDI_Price_Each_Override__c',
'Integral BDICustWiring PriceEch Override'  => 'Integral_BDICustWiring_PriceEch_Override__c',
'Liquid Test Lot Charge Override'  => 'Liquid_Test_Lot_Charge_Override__c',
'Manufacturing Range Price Adder Override'  => 'Manufacturing_Range_Price_Adder_Override__c',
'NACE Lot Charge Override'  => 'NACE_Lot_Charge_Override__c',
'Outlet Coating Price Each Override'  => 'Outlet_Coating_Price_Each_Override__c',
'Outlet Gasket Price Each Override'  => 'Outlet_Gasket_Price_Each_Override__c',
'Outlet Liner Price Each Override'  => 'Outlet_Liner_Price_Each_Override__c',
'Outlet Ring Price Each Override'  => 'Outlet_Ring_Price_Each_Override__c',
'PMI Lot Charge Override'  => 'PMI_Lot_Charge_Override__c',
'Qty of Test RD Charged Override'  => 'Qty_of_Test_RD_Charged_Override__c',
'Quantity Discount Multiplier Override'  => 'Quantity_Discount_Multiplier_Override__c',
'Rupture Disc TopSect Price Each Override'  => 'Rupture_Disc_TopSect_Price_Each_Override__c',
'Seal Price Each Override'  => 'Seal_Price_Each_Override__c',
'Shippable Quantity Override'  => 'Shippable_Quantity_Override__c',
'Special Assembly Lot Charge Override'  => 'Special_Assembly_Lot_Charge_Override__c',
'Surface FinishElectropolishPriceOverride'  => 'Surface_FinishElectropolishPriceOverride__c',
'Third Party Test DiscPrice Each Override'  => 'Third_Party_Test_DiscPrice_Each_Override__c',
'Third PartyWitnessTestLotCharge Override'  => 'Third_PartyWitnessTestLotCharge_Override__c',
'Vacuum Support Price Each Override'  => 'Vacuum_Support_Price_Each_Override__c'
};
}
set  {
mapPricingOverriddenfields = value;
}
}*/
    public String SeatDesc {
        get {
            return ConstantsUtil.mapSTCDesc.get(rdRecord.Seat__c);
        }
        set {
            //currentRD.Seat__c = value;
            this.SeatDesc = value;
        }
    }
    public result getRDAdderPriceValues() {
        result resPriceCal=new result();
        List<sObject> baseQtyPrzData=new List<sObject>();
        System.debug('SZC: ' + SZC);
        decimal SizeValue=ConstantsUtil.getSizeDesc(SZC).SizeValue;
        for (string key:mapPricingfields.keySet()){
            System.debug('key: ' + key);
            rdPricing.put(mapPricingfields.get(key),null);
        }
        upsert rdPricing;
        //try {

        //System.debug('Inside the PRicing Calculation'+baseData.objResultList);
        //1. [QtyCopy]
        integer intQtyCopy=QTY;
        RDPricing.Shippable_Quantity__c=QTY;
        System.debug('RD PRICING intQtyCopy: ' + intQtyCopy);
        //2.[TPTQTYA] =
        decimal decTPTQTYA=0;
        System.debug('ADMERK: ' + ADMERK);
        System.debug('CHINAMFG: ' + CHINAMFG);
        System.debug('RPVM084: ' + RPVM084);
        System.debug('QTY: ' + QTY);
        RDPricingThirdPartyTestQty__c[] RDThirdPartyTest=[select Quantity_to_be_tested__c from RDPricingThirdPartyTestQty__c where ADMERK__c=:ADMERK and CHINAMFG__c=:CHINAMFG and RPVM084__c=:RPVM084 and QtyLL__c<=:QTY and QtyUL__c>=:QTY];

        if (!RDThirdPartyTest.isEmpty()) {
            RDPricing.Third_Party_Test_Disc_Price_Each__c=RDThirdPartyTest[0].Quantity_to_be_tested__c;
            decTPTQTYA=RDThirdPartyTest[0].Quantity_to_be_tested__c;
        } else {
            decTPTQTYA=0;
            RDPricing.Third_Party_Test_Disc_Price_Each__c=0;
        }
        System.debug('RD PRICING decTPTQTYA: ' + decTPTQTYA);
        System.debug('RD PRICING Record ID: ' + rdRecord.id);
        //3.PriceTempTestQtyA
        System.debug('RD PRICING ASME: ' + ASME);
        System.debug('RD PRICING TMPTSTASME: ' + rdRecord.Temperature_Test_per_ASME__c);
        System.debug('RD PRICING TMPTSTASME: ' + TMPTSTASME);
        System.debug('RD PRICING RTTMDF: ' + RTTMDF);
        System.debug('RD PRICING QTY: ' + QTY);
        System.debug('RD PRICING SizeValueUL__c: ' + double.valueOf(SizeValue));
        System.debug('RD PRICING PED: ' + PED);
        String strPED=null;
        if(PED!='N') {
            strPED=PED;
        }
        //System.debug('TMPTSTASME: ' + rdRecord.Temperature_Test_per_ASME__c);
        // System.debug('TMPTSTASME: ' + TMPTSTASME);
        // System.debug('RTTMDF: ' + RTTMDF);
        // System.debug('QTY: ' + QTY);
        // System.debug('SizeValueUL__c: ' + double.valueOf(SizeValue));
        decimal PriceTempTestQtyA=0;
        RDPricingTempTestPriceQty__c[] RDTempTestList=[select PriceQty__c from RDPricingTempTestPriceQty__c where ASME__c=:ASME AND PED__c in (:PED,'') AND OrderQtyLL__c<=:QTY AND OrderQtyUL__c>=:QTY AND TMPTSTASME__c=:TMPTSTASME AND Temp__c<=:RTTMDF AND Temp_1__c>=:RTTMDF AND SizeValueLL__c<=:double.valueOf(SizeValue) and SizeValueUL__c>=:double.valueOf(SizeValue) ];
        System.debug('PriceTempTestQtyA: ' + PriceTempTestQtyA);
        if (!RDTempTestList.isEmpty()) {
            PriceTempTestQtyA=RDTempTestList[0].PriceQty__c;
            RDpricing.Price_Temp_Test_Qty_A__c=RDTempTestList[0].PriceQty__c;
        }
        System.debug('RD PRICING  SizeValue: ' + SizeValue);
        System.debug('RD PRICING PriceTempTestQtyA: ' + PriceTempTestQtyA);
        // [PriceTestDiscQtyA]
        decimal decBackPress=1;
        boolean isValidProd=PTC=='CAL'||PTC=='PAS';
        if ((rdRecord.Vacuum_Withstand__c=='No Requirements' || rdRecord.Vacuum_Withstand__c=='Full Vacuum' )||  (rdRecord.Vacuum_Withstand__c==null || isValidProd)) {
            decBackPress=0;
        }
        System.debug('RD PRICING BackPress: ' + decBackPress);
        decimal NaceTestQty=0;
        if(NACE!=null && NACE!='N')
            NaceTestQty=1;
        System.debug('RD PRICING NaceTestQty: ' + NaceTestQty);
        decimal decPriceTestDiscQtyA=NaceTestQty+decBackPress+PriceTempTestQtyA+decTPTQTYA;
        //
        System.debug('RD PRICING PriceTestDiscQtyA: ' + decPriceTestDiscQtyA);
        integer PriceQtyA=integer.ValueOf(unitConversions.RoundNormal(decPriceTestDiscQtyA+QTY,0));
        Map<string,string> tempMap=new Map<string,string>{'SeatDesc'=>SeatDesc};
            List<String> selectCols1 = new List<String> {'Text__c','Value__c','Attribute__c'};
                result lckAttr=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','RD_Attributes_LookUp_Translation__c','RD_Attributes_Lookup_Detail__c',tempMap,selectCols1);
        string strSeat='';
        if(lckAttr.bResult)
        {
            for (sObject sObj : lckAttr.objResultList) {
                if ((string) sObj.get('Attribute__c')=='PartSeat') {
                    strSeat=(string) sObj.get('Text__c');
                }
            }
        }
        if(String.isBlank(strSeat)) {
            strSeat=rdRecord.Seat__c;
        }
        RDPricing.PriceQtyA__c=PriceQtyA;
        System.debug('RD PRICING PriceQtyA: ' + PriceQtyA);
        Result baseData=getRDAdderBaseList(rdRecord.Product__c, rdRecord.Size__c, strSeat,PriceQtyA,AssignedRangeType);
        decimal BaseDiscPriceA=0;
        decimal SpecAssyPriceAddA=0;
        decimal ThirdPartyLotCharge=0;
        decimal TopSecDisc=0;
        decimal SealA=0;
        decimal GirdleA=0;
        decimal MfgRngA=0;
        decimal VacSup=0;
        decimal Liner=0;
        decimal Ring=0;
        decimal decsurfFinish=0;
        decimal Gasket=0;
        decimal Coating=0;
        decimal IntBDIA=0;
        decimal DentProt=0;
        decimal ArmorRing=0;
        decimal HandSup=0;
        decimal thirdPartyTestDiscPriceEach=0;
        decimal AsmeCeLotChargeA=0;
        decimal ThirdPartyLotChargeA =0;
        decimal LiqLotCharge =0;
        decimal GraphiteLotA =0;
        decimal SpecAssyLotChargeA =0;
        decimal PMILotCharge =0;
        decimal BackPressureLotCharge =0;
        decimal NaceLotCharge =0;
        decimal CUTRLotCharge =0;
        decimal KOSHALotCharge =0;
        decimal CSALotCharge =0;
        decimal ATEXLotCharge=0;
        decimal IntBDIWireA=0;
        decimal CleaningA=0;
        decimal IndPack=0;
        //************************ */
        boolean bdecsurfFinish=false;
        boolean bThirdPartyLotCharge=false;
        boolean bPMILotCharge =false;
        boolean bLiqLotCharge =false;
        boolean bGraphiteLotA =false;
        boolean bNaceLotCharge =false;
        boolean bCUTRLotCharge =false;
        boolean bKOSHALotCharge =false;
        boolean bCSALotCharge =false;
        boolean bATEXLotCharge=false;
        //************************* */
        decimal DiscountablePriceEach=0;
        decimal NondiscountableLotCharge=0;
        decimal QtyDiscountMultiA=0;
        //5. [QtyDiscountMultiA] = value lookup from QtyDscPricing, based upon PTC, and Qty
        String query='Select DiscountMulti__c from RDPricingQtyDscMulti__c where Prod__c LIKE \'%'+PTC+'%\' and QtyLL__c<='+PriceQtyA+' and QtyUL__c>='+PriceQtyA;
        RDPricingQtyDscMulti__c[] discQty=Database.query(query);
        if (MCD=='008') {
            RDPricing.Quantity_Discount_Multiplier__c=1;
            QtyDiscountMultiA=1;
        }
        if (!discQty.isEmpty()) {
            System.debug('discQty: ' + discQty);
            System.debug('RDPricing: ' + RDPricing);
            rdPricing.Quantity_Discount_Multiplier__c=discQty[0].DiscountMulti__c==null?0:discQty[0].DiscountMulti__c;
            QtyDiscountMultiA=discQty[0].DiscountMulti__c;
        } else {
            rdPricing.Quantity_Discount_Multiplier__c=1;
            QtyDiscountMultiA=1;
        }
        System.debug('RD PRICING QtyDiscountMultiA: ' + QtyDiscountMultiA);
        //25. [IntBDIWireA] = value lookup from PriceWiring, based upon BCT, BCL, BEC
        System.debug('BCT: ' + BCT);
        System.debug('BCL: ' + BCL);
        System.debug('BEC: ' + BEC);
        String strPTC='\''+PTC+'\'';
        String strSTC='\''+STC+'\'';
        String strSZC='\''+SZC+'\'';
        String strQty=Qty+'';
        String strSizeValue=SizeValue+'';
        if(BCT!=null && BCL!=null && BEC!=null) {
            System.debug('RD PRICING BCL: ' + BCL);
            System.debug('RD PRICING BCT: ' + BCT);
            System.debug('RD PRICINGBEC: ' + BEC);
            RDPriceWiring__c[] ListWIRE=[select Price__c from RDPriceWiring__c where WireLength__c=:BCL and WireType__c=:BCT and Connection__c=:BEC];
            if(ListWIRE.size()>0)
                IntBDIWireA=ListWIRE[0].Price__c;
            else {
                IntBDIWireA=9999999;
            }
            RDPricing.Integral_BDI_Custom_Wiring_Price_Each__c=IntBDIWireA;
        }
        System.debug('RD PRICING IntBDIWireA: ' + IntBDIWireA);
        //26. [CleaningA] = value lookup from CleaningPrice, based upon CLEAN1, PTC, SizeValue, PriceQty
        string tempClean='';
        if (CLEAN!='N' && string.isnotBlank(CLEAN)) {
            tempClean=CLEAN;
        } else if (string.isnotBlank(CSPECS)) {
            tempClean=CSPECS;
        }
        System.debug('RD PRICING tempClean: ' + tempClean);
        System.debug('RD PRICING CSPECS: ' + CSPECS);
        System.debug('RD PRICING CLEAN: ' + CLEAN);
        Result cleanResult=new result();
        List<String> clnselectCols=new List<String>{'PriceEach__c'};
            List<String> clnwhereCols=new List<String>{'Prod__c','Cleaning__c','SizeValueLL__c','SizeValueUL__c','QtyLL__c','QtyUL__c'};
                List<String> clnwhereValues = new List<String>{PTC,tempClean,strSizeValue,strSizeValue,strQty,strQty};
                    List<String> clnwhereComps = new List<String>{'LIKE','LIKE','<=','>=','<=','>='};
                        List<String> clnextraChars = new List<String>{'','','','','',''};
                            cleanResult=wizardBaseDataProcessor.getDataListbyUsingLikeOpp('RDCleaningPrice__c',clnselectCols,clnwhereCols,clnwhereValues,clnwhereComps,clnextraChars);
        if (cleanResult.bResult && string.isNotBlank(tempClean)) {
            CleaningA=(decimal) cleanResult.objResultList[0].get('PriceEach__c');
            RDPricing.Cleaning_Price_Each__c=CleaningA;
        } else if (cleanResult.strErrorMessage=='No Data Found' && string.isNotBlank(tempClean)) {
            CleaningA=9999999;
            RDPricing.Cleaning_Price_Each__c=CleaningA;
        }
        System.debug('RD PRICING CleaningA: ' + CleaningA);
        //27. [IndPack] = value lookup from IndivPackaging, based upon PTC, (PartSeat), SZC, qtyA1
        if(rdRecord.Individual_Packaging__c) {
            Result packResult=new result();
            List<String> selectCols=new List<String>{'List_Price__c'};
                List<String> whereCols=new List<String>{'Prod__c','CompSTC__c','Size__c','QtyLL__c','QtyUL__c'};
                    List<String> whereValues = new List<String>{PTC,STC,SZC,strQty,strQty};
                        List<String> whereComps = new List<String>{'LIKE','LIKE','LIKE','<=','>='};
                            List<String> extraChars = new List<String>{'-','-','-','',''};
                                packResult=wizardBaseDataProcessor.getDataListbyUsingLikeOpp('RDPricingIndivPackaging__c',selectCols,whereCols,whereValues,whereComps,extraChars);
            if (packResult.bResult) {
                IndPack=(decimal) packResult.objResultList[0].get('List_Price__c');
                RDPricing.Individual_Packaging_Price_Each__c=IndPack;
            } else if (packResult.strErrorMessage=='No Data Found') {
                IndPack=9999999;
                RDPricing.Individual_Packaging_Price_Each__c=IndPack;
            }
        }
        //
        System.debug('RD PRICING IndPack: ' + IndPack);

        //28. [IHolder]
        System.debug('qtd: ' + 'SELECT ListPrice__c, FROM RDP_HPricingHolderCompPricing__c WHERE Prod__c LIKE \'%'+PTC+'%\' AND size__c LIKE \'%'+SZC+'%\' and Class__c='+rdRecord.Pressure_Class__c+' AND Qty_LL__c<='+QTY+' AND Qty_UL__c>'+QTY);
        RDP_HPricingHolderCompPricing__c[] holderList=Database.query('SELECT ListPrice__c,PartMatl__c,Part__c FROM RDP_HPricingHolderCompPricing__c WHERE Prod__c LIKE \'%'+PTC+'%\' AND size__c LIKE \'%'+SZC+'%\'   and Class__c=\''+rdRecord.Pressure_Class__c+'\' AND Qty_LL__c<='+QTY+' AND Qty_UL__c>'+QTY);
        decimal Holder=0;
        boolean bIHolder=false;
        boolean bOHolder=false;
        boolean bHDRingHolder=false;
        decimal IHolder=0;
        decimal OHolder=0;
        decimal HDRingHolder=0;
        //decimal
        if(!holderList.isEmpty()) {

            for(RDP_HPricingHolderCompPricing__c rec:holderList) {
                if(string.isNotBlank(MCHI)) {
                    if(rec.PartMatl__c.contains(MCHI) && rec.Part__c=='Inlet')
                    {
                        IHolder=rec.ListPrice__c;
                        //28. [IHolder]=rec.ListPrice__c
                        RDPricing.Holder_Inlet_Price_Each__c=rec.ListPrice__c;
                        bIHolder=true;
                    }
                }

                //29. [OHolder] =
                if(string.isNotBlank(MCHO)) {
                    if (rec.PartMatl__c.contains(MCHO) && rec.Part__c=='Outlet' ) {
                        //[OHolder] = rec.ListPrice__c;
                        OHolder=rec.ListPrice__c;
                        RDPricing.Holder_Outlet_Price_Each__c= rec.ListPrice__c;
                        bOHolder=true;
                    }
                }
                //30. [HDRingHolder] =
                if(string.isNotBlank(MCHRNG)) {
                    if (rec.PartMatl__c.contains(MCHRNG) && rec.Part__c=='Ring' ) {
                        //[OHolder] = rec.ListPrice__c;
                        bHDRingHolder=true;
                        HDRingHolder=rec.ListPrice__c;
                        RDPricing.Holder_Holddown_Ring_Price_Each__c=rec.ListPrice__c;
                    }
                }
            }
        }
        if(string.isNotBlank(MCHI) && !bIHolder) {
            IHolder=9999999;
            //28. [IHolder]=rec.ListPrice__c
            RDPricing.Holder_Inlet_Price_Each__c=IHolder;
        }
        if(string.isNotBlank(MCHO) && !bOHolder) {
            OHolder=9999999;
            RDPricing.Holder_Outlet_Price_Each__c= OHolder;
        }
        if(string.isNotBlank(MCHRNG) && !bHDRingHolder) {
            HDRingHolder=9999999;
            //28. [IHolder]=rec.ListPrice__c
            RDPricing.Holder_Holddown_Ring_Price_Each__c=HDRingHolder;
        }
        //31.Holder
        //Holder=IHolder+OHolder+HDRingHolder;
        if((IHolder==9999999 || OHolder==9999999)|| HDRingHolder==9999999) {
            Holder=9999999;
        } else {
            Holder=IHolder+OHolder+HDRingHolder;
        }
        RDPricing.Holders_Price_Adder__c=Holder;
        if(baseData.bResult) {

            //6 [TopSecDisc]
            System.debug('RD PRICING MCDD: ' + MCDD);
            String PartStr='';
            if(string.isNotBlank(MCDD))
            {
                PartStr = 'Disc';
            }
            else if(string.isNotBlank(MCDT1)|| string.isNotBlank(MCDT2))
            {
                PartStr = 'Top Section';
            }
            System.debug('RD PRICING MCD: ' + MCD);
            System.debug('RD PRICING PartStr:'+PartStr);
            System.debug('baseData.objResultList ' + baseData.objResultList);
            System.debug('RD PRICING FinalTMRFloat:33 ' + FinalTMRFloat);
            if(PartStr!=null && String.isNotBlank(MCD)) {


                System.debug('INside Loop Basedata Objresu ' + baseData.objResultList);
                TopSecDisc=getRDAdderValues(baseData.objResultList,PartStr,MCD,FinalTMRFloat.setScale(2)).dblRetValue;
                System.debug('TopSecDisc'+TopSecDisc);
                if(TopSecDisc==null)
                    TopSecDisc=9999999;
                RDPricing.Rupture_Disc_or_Top_Section_Price_Each__c=TopSecDisc;

            }
            System.debug('RD PRICING SealA: MCSS->' + MCSS);
            System.debug('RD PRICING SealA: FinalTMRFloat->' + FinalTMRFloat);
            //7. [SealA] = value lookup from DiscCompPricing, based upon PTC, “SealSeal”, SZC, VTMRFloat, PartSeat, PartMatlStr, PriceQtyA
            System.debug('RD PRICING TopSecDisc: ' + TopSecDisc);
            if(String.isNotBlank(MCSS)) {
                SealA=getRDAdderValues(baseData.objResultList,'Seal',MCSS,FinalTMRFloat.setScale(2)+ 0.01).dblRetValue;
                if(SealA==null)
                    SealA=9999999;
                RDPricing.Seal_Price_Each__c=SealA;
            }
            String strDPM = '';
            if(DPM == 'N'){
                strDPM = 'Gas';
            } else {
                strDPM = 'Either';
            }

            String strQuery = 'SELECT List_Price__c FROM RDPricingHPXProcessMediaAdj__c';
            String whereClause = ' WHERE Prod__c LIKE \'%'+PTC+'%\' AND Size__c =\''+SZC+'\' AND Mfg_Rng__c LIKE \'%'+FinalAssignedRangeType+'%\' AND Part_Matl__c LIKE \'%'+MCDD+'%\' AND DPM__c LIKE \'%'+strDPM+'%\' AND QtyLL__c <= '+PriceQtyA+' AND QtyUL__c >= '+PriceQtyA;
            System.debug('rdPricing whereClause'+whereClause);
            RDPricingHPXProcessMediaAdj__c[] rdHPXProMedia = DataBase.query(strQuery + whereClause);
            If(rdHPXProMedia.size()>0){
                RDPricing.HPXProMedia_Adder__c=rdHPXProMedia[0].List_Price__c;
                if(TopSecDisc!=9999999)
                    TopSecDisc +=rdHPXProMedia[0].List_Price__c;
                RDPricing.Rupture_Disc_or_Top_Section_Price_Each__c=TopSecDisc;
            }
            System.debug('RD PRICING SealA: ' + SealA);
            //8. [GirdleA]  =value lookup from DiscCompPricing, based upon PTC, “Girdle”, SZC, TMRFloat, PartSeat, MCGD
            decimal decMax=0.0;
            if(PTC=='CAL') {
                decMax=rdRecord.VG2MAX__c;
            } else {
                decMax=rdRecord.RG2MAX__c;
            }
            if (String.isNotBlank(MCGD)) {
                GirdleA=getRDAdderValues(baseData.objResultList,'Girdle',MCGD,decMax).dblRetValue;
                if(GirdleA==null)
                    GirdleA=9999999;
                RDPricing.Girdle_Price_Each__c=GirdleA;
            }
            System.debug('RD PRICING GirdleA: ' + GirdleA);
            //9. [BaseDiscPriceA]
            if(GirdleA==9999999 || SealA==9999999|| TopSecDisc==9999999) {
                BaseDiscPriceA=9999999;
            } else {
                BaseDiscPriceA=(GirdleA+SealA+TopSecDisc)*rdPricing.Quantity_Discount_Multiplier__c;
            }
            RDPricing.Base_Rupture_Disc_Price_Each__c=BaseDiscPriceA;
            System.debug('RD PRICING BaseDiscPriceA: ' + BaseDiscPriceA);
            //10. [MfgRngA] = (value lookup from MfgRngPricing, based upon PTC, AssignedRangeType, SizeValue) / PriceQtyA
            System.debug('RD PRICING FinalAssignedRangeType: ' + FinalAssignedRangeType);
            System.debug('RD PRICING AssignedRangeType: ' + AssignedRangeType);
            if (string.isNotBlank(FinalAssignedRangeType)) {
                RDPricingMfgRngPrice__c[] mfgList=Database.query('select Lot_Price__c from RDPricingMfgRngPrice__c where Prod__c Like \'%'+PTC+'%\' and AssignedMfgRng__c=\''+FinalAssignedRangeType+'\' and SizeValueLL__c<='+decSZC+' and SizeValueUL__c>='+decSZC+'');
                System.debug('RD PRICING mfgList: ' + mfgList);
                if (mfgList.size()>0) {
                    MfgRngA=(decimal) mfgList[0].get('Lot_Price__c')/PriceQtyA;
                    RDPricing.Manufacturing_Range_Price_Adder__c=MfgRngA.setScale(2);
                } else {
                    MfgRngA=9999999;
                    RDPricing.Manufacturing_Range_Price_Adder__c=MfgRngA;
                }
            }
            System.debug('RD PRICING MfgRngA: ' + MfgRngA);
            // 11. [VacSup] = value lookup from DiscCompPricing, based upon PTC, "Vacuum Support", SZC, TMRFloat, PartSeat, MCVS
            if (String.isNotBlank(MCVS)) {
                VacSup=getRDAdderValues(baseData.objResultList,'Vacuum Support',MCVS,FinalTMRFloat.setScale(2)).dblRetValue;
                if(VacSup==null)
                    VacSup=9999999;
                RDPricing.Vacuum_Support_Price_Each__c=VacSup;
            }
            System.debug('RD PRICING VacSup: ' + VacSup);
            decimal IRing=0;
            decimal ORing=0;
            decimal IGasket=0;
            decimal OGasket=0;
            decimal ILiner=0;
            decimal OLiner=0;
            decimal ICoating=0;
            decimal OCoating=0;
            //12. [IRing] =  value lookup from DiscCompPricing, based upon PTC, "Ring", SZC, TMRFloat, PartSeat, MCIR
            if (String.isNotBlank(MCIR)) {
                IRing=getRDAdderValues(baseData.objResultList,'Ring',MCIR,FinalTMRFloat.setScale(2)).dblRetValue;
                if(IRing==null)
                    IRing=9999999;
                RDPricing.Inlet_Ring_Price_Each__c=IRing;
            }
            System.debug('RD PRICING IRing: ' + IRing);
            //13. [ORing] =  value lookup from DiscCompPricing, based upon PTC, "Ring", SZC, TMRFloat, PartSeat, MCOR
            if (String.isNotBlank(MCOR)) {
                ORing=getRDAdderValues(baseData.objResultList,'Ring',MCOR,FinalTMRFloat.setScale(2)).dblRetValue;
                if(ORing==null)
                    ORing=9999999;
                RDPricing.Outlet_Ring_Price_Each__c=ORing;
            }
            System.debug('RD PRICING ORing: ' + ORing);
            if(IRing==9999999||ORing==9999999)
                Ring=9999999;
            else
                Ring=IRing + ORing;
            RDPricing.Rings_Price_Adder__c=Ring;
            System.debug('RD PRICING Ring: ' + Ring);
            //14. [Ring] = IRing + ORing
            //15. [IGasket] =  value lookup from DiscCompPricing, based upon PTC, "Gasket", SZC, TMRFloat, PartSeat, MCIG
            if (String.isNotBlank(MCIG)) {
                IGasket=getRDAdderValues(baseData.objResultList,'Gasket',MCIG,FinalTMRFloat.setScale(2)).dblRetValue;
                if(IGasket==null)
                    IGasket=9999999;
                RDPricing.Inlet_Gasket_Price_Each__c=IGasket;
            }
            System.debug('RD PRICING IGasket: ' + IGasket);
            //16. [OGasket] =  value lookup from DiscCompPricing, based upon PTC, "Gasket", SZC, TMRFloat, PartSeat, MCOG
            if (MCOG!=null) {
                OGasket=getRDAdderValues(baseData.objResultList,'Gasket',MCOG,FinalTMRFloat.setScale(2)).dblRetValue;
                if(OGasket==null)
                    OGasket=9999999;
                RDPricing.Outlet_Gasket_Price_Each__c=OGasket;
            }
            System.debug('RD PRICING OGasket: ' + OGasket);
            //17. [Gasket] = IGasket + OGasket
            if(IGasket==9999999||OGasket==9999999)
                Gasket=9999999;
            else
                Gasket=IGasket+OGasket;
            RDPricing.Gaskets_Price_Adder__c=Gasket;
            System.debug('RD PRICING Gasket: ' + Gasket);
            //18. [ILiner]=value lookup from DiscCompPricing, based upon PTC, "Liner", SZC, TMRFloat, PartSeat, MCIL
            if (String.isNotBlank(MCIL)) {
                ILiner=getRDAdderValues(baseData.objResultList,'Liner',MCIL,FinalTMRFloat.setScale(2)).dblRetValue;
                if(ILiner==null)
                    ILiner=9999999;
                RDPricing.Inlet_Liner_Price_Each__c=ILiner;
            }
            System.debug('RD PRICING ILiner: ' + ILiner);
            //19. [OLiner]=value lookup from DiscCompPricing, based upon PTC, "Liner", SZC, TMRFloat, PartSeat, MCOL
            if (String.isNotBlank(MCOL)) {
                OLiner=getRDAdderValues(baseData.objResultList,'Liner',MCOL,FinalTMRFloat.setScale(2)).dblRetValue;
                if(OLiner==null)
                    OLiner=9999999;
                RDPricing.Outlet_Liner_Price_Each__c=OLiner;
            }
            System.debug('RD PRICING ILiner: ' + OLiner);
            //20. [Liner] =  ILiner + OLiner
            if(ILiner==9999999||OLiner==9999999)
                Liner=9999999;
            else
                Liner=ILiner + OLiner;
            RDPricing.Liners_Price_Adder__c=Liner;
            //21. [ICoating] = value lookup from DiscCompPricing, based upon PTC, "Coating", SZC, TMRFloat, PartSeat, MCIC
            if(String.isNotBlank(MCIC)) {
                ICoating=getRDAdderValues(baseData.objResultList,'Coating',MCIC,FinalTMRFloat.setScale(2)).dblRetValue;
                if(ICoating==null)
                    ICoating=9999999;
                RDPricing.Inlet_Coating_Price_Each__c=ICoating;
            }
            System.debug('RD PRICING ICoating: ' + ICoating);
            //22. [OCoating] = value lookup from DiscCompPricing, based upon PTC, "Coating", SZC, TMRFloat, PartSeat, MCOC
            if(String.isNotBlank(MCOC)) {
                OCoating=getRDAdderValues(baseData.objResultList,'Coating',MCOC,FinalTMRFloat.setScale(2)).dblRetValue;
                if(OCoating==null)
                    OCoating=9999999;
                RDPricing.Outlet_Coating_Price_Each__c=OCoating;
            }
            System.debug('RD PRICING OCoating: ' + OCoating);
            //23. [Coating] = ICoating + OCoating
            if(ICoating==9999999||OCoating==9999999)
                Coating=9999999;
            else
                Coating=ICoating + OCoating;
            //Coating=ICoating + OCoating;
            System.debug('RD PRICING Coating: ' + Coating);
            RDPricing.Coatings_Price_Adder__c=Coating;
            //24. [IntBDIA] = value lookup from DiscCompPricing, based upon PTC, BDIPart, SZC, TMRFloat, PartSeat, MCBS, QtyCopy
            if(String.isNotBlank(MCBS)) {
                string BDIPart='';
                if(addIntegralBDI == 'BDIFLX')
                    BDIPart = 'Integral Flexible Sensor';
                if(addIntegralBDI == 'BDI')
                    BDIPart = 'Integral BDI Strip';
                Result baseData1=getRDAdderBaseList(rdRecord.Product__c, rdRecord.Size__c, strSeat,integer.valueOf(rdRecord.Quantity__c),AssignedRangeType);
                IntBDIA=getRDAdderValues(baseData1.objResultList,BDIPart,MCBS,(FinalTMRFloat+0.01).setScale(2)).dblRetValue;
                if(IntBDIA==null)
                    IntBDIA=9999999;
                RDPricing.Integral_BDI_Price_Each__c=IntBDIA;
            }
            System.debug('RD PRICING IntBDIA: ' + IntBDIA);
            //32. [HandSup] = value lookup from DiscCompPricing, based upon PTC, "Handling Support", SZC, TMRFloat, PartSeat, MCHS
            if(String.isNotBlank(MCHS)) {
                HandSup=getRDAdderValues(baseData.objResultList,'Handling Support',MCHS,FinalTMRFloat.setScale(2)).dblRetValue;
                if(HandSup==null)
                    HandSup=9999999;
                RDPricing.Handling_Support_Price_Each__c=HandSup;
            }
            System.debug('RD PRICING HandSup: ' + HandSup);
            //33. [DentProt] = value lookup from DiscCompPricing, based upon PTC, "Dent Protector", SZC, TMRFloat, PartSeat, MCDP
            if(String.isNotBlank(MCDP)) {
                DentProt=getRDAdderValues(baseData.objResultList,'Dent Protector',MCDP,FinalTMRFloat.setScale(2)).dblRetValue;
                if(DentProt==null)
                    DentProt=9999999;
                RDPricing.Dent_Protector_Price_Each__c=DentProt;
            }
            System.debug('RD PRICING DentProt: ' + DentProt);
            //34. [ArmorRing]
            //decimal ArmorRing=0;
            if (String.isNotBlank(MCGR)) {
                ArmorRing=getRDAdderValues(baseData.objResultList,'Armor Ring',MCGR,FinalTMRFloat.setScale(2)).dblRetValue;
                if(ArmorRing==null)
                    ArmorRing=9999999;
                RDPricing.Armor_Ring__c=ArmorRing;
            }
            System.debug('RD PRICING ArmorRing: ' + ArmorRing);
        }
        //35. [TDPM]
        RDPricingTestDiscPrice__c[] testDisList=[select id,TestDiscPriceMethod__c from RDPricingTestDiscPrice__c where PTC__c=:PTC];
        string decTDPM='';
        if (testDisList.size()>0) {
            decTDPM=String.valueOf(integer.valueOf(testDisList[0].TestDiscPriceMethod__c)) ;
            RDPricing.Test_Disc_Price_Method__c=decTDPM;
        }
        //40. [thirdPartyTestDiscPriceEach] =

        //43. [AsmeCeLotChargeA] =
        Disc_Type_List__c[] DiscType=[SELECT Id, LiquidTestReqd__c FROM Disc_Type_List__c where PTC__c=:PTC];
        boolean isLiquidTestReq=false;
        if(DiscType.size()>0)
            isLiquidTestReq=DiscType[0].LiquidTestReqd__c=='Yes'?true:false;

        //45. [LiqLotCharge] = value lookup from LotCharge, based upon LiquidTestReqd and PTC

        //HP2,HPH,HPN,HPS,HPX,HPZ,LPX
        List<string> skipPTC_DPM = new List<string>{'HPN','HPZ','HPS','LPX','HPH','HP2','HPT','HPX'};
            if(DPM=='Y' && !skipPTC_DPM.contains(PTC) &&isLiquidTestReq)
            RDPricing.Liquid_Test_Lot_Charge__c=[select Lot_Price__c from RDPricingLotCharges__c  where Reason__c='Liquid Service Lot Test Charge'].Lot_Price__c;
        else
            RDPricing.Liquid_Test_Lot_Charge__c=0;
        system.debug('RD PRICING isLiquidTestReq--->' +isLiquidTestReq);
        system.debug('RD PRICING DPM--->' +DPM);
        system.debug('RD PRICING skipPTC_DPM--->' +skipPTC_DPM.contains(PTC));
        //46. [GraphiteLotA] =
        //SZC='0100';
        System.debug('rdRecord.Converted_Pressure_Setting__c: ' + rdRecord.Converted_Pressure_Setting__c);
        System.debug('RTTMDF: ' + RTTMDF);
        System.debug('PED: ' + PED);
        RDPricing_GraphiteLotCharge__c[] graphiteLotAList=[select LotCharge__c from RDPricing_GraphiteLotCharge__c where PED__c=:PED AND SZC__c=:SZC AND PressLL__c<=:(rdRecord.Converted_Pressure_Setting__c) AND PressUL__c>=:(rdRecord.Converted_Pressure_Setting__c) AND TempLL__c<=:(RTTMDF) AND TempUL__c>:(RTTMDF)];
        if (!graphiteLotAList.isEmpty() && MCD=='043') {
            System.debug('graphiteLotAList: ' + graphiteLotAList);
            RDPricing.Graphite_Rupture_Disc_Lot_Charge__c=graphiteLotAList[0].LotCharge__c;
        } else {
            RDPricing.Graphite_Rupture_Disc_Lot_Charge__c=0;
        }
        //47. [PriceA_PMILotCharge] = value lookup from CDCPMIPrice, based upon ExamTestingOptions and qtyA1
        if(PMI!='N' && String.isNotBlank(PMI)) {
            RDPricingPMIPrice__c[] pmiList=[select LotCharge__c from RDPricingPMIPrice__c where QtyLL__c<=:QTY and QtyUL__c>=:QTY and PMI__C=:PMI];
            if(pmiList.size()>0)
                RDPricing.PMI_Lot_Charge__c=pmiList[0].LotCharge__c;
            else {
                RDPricing.PMI_Lot_Charge__c=9999999;
            }
        }

        //RDPricing.PMI_Lot_Charge__c=.LotCharge__c;
        //50. [CUTRLotCharge] = value lookup from LotCharge, based upon CUTR
        RDPricingLotCharges__c[] rdLotChargeList=[select Lot_Price__c,Reason__c from RDPricingLotCharges__c];
        if (!rdLotChargeList.isEmpty()) {
            for (RDPricingLotCharges__c lotCharge:rdLotChargeList) {
                if (rdRecord.CU_TR__c==true && lotCharge.Reason__c=='CUTRLotCharge') {
                    // 50. [CUTRLotCharge]
                    CUTRLotCharge=lotCharge.Lot_Price__c;
                    RDPricing.CUTR_Lot_Charge__c=CUTRLotCharge;
                    bCUTRLotCharge=true;
                }
                if (NarrowByFlow && lotCharge.Reason__c=='Narrow By Flow') {
                    SpecAssyLotChargeA=lotCharge.Lot_Price__c;
                    RDPricing.Special_Assembly_Lot_Charge__c=SpecAssyLotChargeA;
                    //RDPricing.=
                }
                if (rdRecord.Atex_Certificate__c && lotCharge.Reason__c=='ATEX') {
                    //[ATEXLotCharge] =lotCharge.Lot_Price__c
                    ATEXLotCharge=lotCharge.Lot_Price__c;
                    RDPricing.ATEX_Lot_Charge__c=ATEXLotCharge;
                    bATEXLotCharge=true;
                    //RDPricing
                }
                if (rdRecord.CSA_Marking_CRN_Number__c && lotCharge.Reason__c=='CSA') {
                    //[[CSALotCharge] =] =lotCharge.Lot_Price__c
                    CSALotCharge=lotCharge.Lot_Price__c;
                    RDPricing.CSA_Lot_Charge__c=CSALotCharge;
                    bCSALotCharge=true;
                    //RDPricing

                }
                if (rdRecord.KOSHA_Compliance__c && lotCharge.Reason__c=='KOSHA') {
                    //[[KOSHA] =] =lotCharge.Lot_Price__c
                    KOSHALotCharge=lotCharge.Lot_Price__c;
                    RDPricing.KOSHA_Lot_Charge__c=KOSHALotCharge;
                    bKOSHALotCharge=true;
                    //RDPricing
                }
                if (rdRecord.NACE__c!=null && lotCharge.Reason__c=='NACE') {
                    //[[KOSHA] =] =lotCharge.Lot_Price__c
                    NaceLotCharge=lotCharge.Lot_Price__c;
                    RDPricing.NACE_Lot_Charge__c=KOSHALotCharge;
                }
                //ThirdPartyLotCharge
                System.debug('RD PRICING ADMERK'+ADMERK);
                System.debug('RD PRICING RPVM084'+RPVM084);
                System.debug('RD PRICING CHINAMFG'+CHINAMFG);

                if ((ADMERK=='Y' || RPVM084=='Y') && lotCharge.Reason__c=='ADMERK & RPVM048') {
                    //RDPricing.
                    System.debug('RD PRICING --INSIDE ADMERK & RPVM084'+lotCharge.Lot_Price__c);
                    bThirdPartyLotCharge=true;
                    ThirdPartyLotCharge=lotCharge.Lot_Price__c;
                    RDPricing.Third_Party_Lot_Charge__c=ThirdPartyLotCharge;
                } else if (CHINAMFG=='CUSTSI' && lotCharge.Reason__c=='CUSTSI') {
                    System.debug('RD PRICING --INSIDE CUSTSI'+lotCharge.Lot_Price__c);
                    bThirdPartyLotCharge=true;
                    ThirdPartyLotCharge=lotCharge.Lot_Price__c;
                    RDPricing.Third_Party_Lot_Charge__c=ThirdPartyLotCharge;
                }
                if (CHINAMFG=='CDCSI' && lotCharge.Reason__c=='CDCSI') {
                    System.debug('RD PRICING --INSIDE CDCSI'+lotCharge.Lot_Price__c);
                    bThirdPartyLotCharge=true;
                    ThirdPartyLotCharge=lotCharge.Lot_Price__c;
                    RDPricing.Third_Party_Lot_Charge__c=ThirdPartyLotCharge;
                }
                if( lotCharge.Reason__c=='Surface Finish Cert Lot Charge') {
                    if ((SURFFINISH=='N'||SURFFINISH=='20'||SURFFINISH=='0.5') && ELECTROPOL == 'N' ) {
                        decsurfFinish=0.0;
                        bdecsurfFinish=true;

                    } else if ((SURFFINISH=='15'||SURFFINISH=='0.4')  && ELECTROPOL == 'N') {
                        decsurfFinish=lotCharge.Lot_Price__c.divide(PriceQtyA,0);
                        bdecsurfFinish=true;
                    }
                }
                if(lotCharge.Reason__c=='Electropolish Lot Charge') {
                    if (((SURFFINISH=='12'||SURFFINISH=='10'||SURFFINISH=='0.35'||SURFFINISH=='0.26' || ELECTROPOL == 'Y') && PriceQtyA<30)) {
                        decsurfFinish=lotCharge.Lot_Price__c.divide(PriceQtyA,0);
                        bdecsurfFinish=true;
                    }
                }
                if (((SURFFINISH=='12'||SURFFINISH=='10'||SURFFINISH=='0.35'||SURFFINISH=='0.26' || ELECTROPOL == 'Y') && PriceQtyA>=30)) {
                    decsurfFinish=BaseDiscPriceA*0.1;
                    bdecsurfFinish=true;
                }
            }
            System.debug('RD PRICING decsurfFinish:: ' + decsurfFinish);
            RDPricing.Surface_Finish_Electropolish_Price_Each__c=decsurfFinish;

            map<string,List<Decimal>> mapTestDiscPrice=new map<string,List<Decimal>>();
            mapTestDiscPrice.put('TestDiscPrice1A',new List<Decimal> {BaseDiscPriceA , MfgRngA , VacSup , Ring , Gasket , Liner , Coating ,IntBDIA , IntBDIWireA , Holder , HandSup , DentProt , ArmorRing , decsurfFinish, SpecAssyPriceAddA});
            mapTestDiscPrice.put('TestDiscPrice2A',new List<Decimal> {BaseDiscPriceA , MfgRngA , VacSup , Ring , Gasket , Liner , Coating , Holder , HandSup , DentProt , ArmorRing , decsurfFinish , SpecAssyPriceAddA});
            mapTestDiscPrice.put('TestDiscPrice3A',new List<Decimal> {BaseDiscPriceA , MfgRngA , VacSup , Gasket , Liner , Coating , IntBDIA , IntBDIWireA , Holder , HandSup , DentProt , ArmorRing , decsurfFinish , SpecAssyPriceAddA});
            mapTestDiscPrice.put('TestDiscPrice4A',new List<Decimal> {BaseDiscPriceA , MfgRngA , VacSup , Ring , Liner , Coating , Holder , HandSup , DentProt , ArmorRing , decsurfFinish , SpecAssyPriceAddA});

            decimal TestDiscPrice1A=0;
            decimal TestDiscPrice2A=0;
            decimal TestDiscPrice3A=0;
            decimal TestDiscPrice4A=0;
            map<string,decimal> mapTestDiscValues=new map<string,decimal>();
            for(String key:mapTestDiscPrice.keySet()) {
                decimal ttl=0;
                for(decimal keyvals:mapTestDiscPrice.get(key)) {
                    //System.debug('RD PRICING mapTestDiscPrice:: ' + keyvals);
                    ttl+=keyvals;
                    if(keyvals==9999999) {
                        ttl=9999999;
                        break;
                    }
                }
                mapTestDiscValues.put(key, ttl);

            }




            //36. [TestDiscPrice1A] .p0l
            // decimal TestDiscPrice1A=BaseDiscPriceA + MfgRngA + VacSup + Ring + Gasket + Liner + Coating + IntBDIA + IntBDIWireA + Holder + HandSup + DentProt + ArmorRing + decsurfFinish+ SpecAssyPriceAddA;
            // //37. [TestDiscPrice2A] =
            // decimal TestDiscPrice2A= BaseDiscPriceA + MfgRngA + VacSup + Ring + Gasket + Liner + Coating + Holder + HandSup + DentProt + ArmorRing + decsurfFinish + SpecAssyPriceAddA;
            // //38. [TestDiscPrice3A] =
            // decimal TestDiscPrice3A=BaseDiscPriceA + MfgRngA + VacSup + Gasket + Liner + Coating + IntBDIA + IntBDIWireA + Holder + HandSup + DentProt + ArmorRing + decsurfFinish + SpecAssyPriceAddA;
            // //39. [TestDiscPrice4A] =
            // decimal TestDiscPrice4A=BaseDiscPriceA + MfgRngA + VacSup + Ring + Liner + Coating + Holder + HandSup + DentProt + ArmorRing + decsurfFinish + SpecAssyPriceAddA;
            map<string,decimal> testDiscMap=new map<string,decimal>();
            testDiscMap.put('1',mapTestDiscValues.get('TestDiscPrice1A'));
            testDiscMap.put('2',mapTestDiscValues.get('TestDiscPrice2A'));
            testDiscMap.put('3',mapTestDiscValues.get('TestDiscPrice3A'));
            testDiscMap.put('4',mapTestDiscValues.get('TestDiscPrice4A'));
            System.debug('RD Pricing testDiscMap'+testDiscMap);
            System.debug('RD Pricing testDiscMap ADMERK'+ADMERK);
            System.debug('RD Pricing testDiscMap RPVM084'+RPVM084);
            System.debug('RD Pricing testDiscMap CHINAMFG'+CHINAMFG);
            if(String.IsNotBlank(decTDPM)) {
                if(ADMERK!='N' || RPVM084!='N' || CHINAMFG!='N') {
                    if(testDiscMap.get(decTDPM)!=9999999) {
                        thirdPartyTestDiscPriceEach=(testDiscMap.get(decTDPM) * decTPTQTYA).divide(QTY,2);
                        RDPricing.Third_Party_Test_Disc_Price_Each__c=thirdPartyTestDiscPriceEach;
                    } else {
                        thirdPartyTestDiscPriceEach=9999999;
                        RDPricing.Third_Party_Test_Disc_Price_Each__c=thirdPartyTestDiscPriceEach;
                    }
                }
                System.debug('RD PRICING thirdPartyTestDiscPriceEach: ' + thirdPartyTestDiscPriceEach);
                if(decBackPress>0) {
                    if(testDiscMap.get(decTDPM)!=9999999) {
                        BackPressureLotCharge=testDiscMap.get(decTDPM);
                        RDPricing.Back_Pressure_Lot_Charge__c=testDiscMap.get(decTDPM);
                    } else {
                        BackPressureLotCharge=9999999;
                        RDPricing.Back_Pressure_Lot_Charge__c=testDiscMap.get(decTDPM);
                    }
                }
                System.debug('RD PRICING BackPressureLotCharge: ' + BackPressureLotCharge);
                if(NaceTestQty>0) {
                    if(testDiscMap.get(decTDPM)!=9999999) {
                        NACELotCharge=testDiscMap.get(decTDPM);
                        RDPricing.NACE_Lot_Charge__c=testDiscMap.get(decTDPM);
                    } else {
                        NACELotCharge=9999999;
                        RDPricing.NACE_Lot_Charge__c=NACELotCharge;
                    }
                }
                System.debug('RD PRICING NACELotCharge: ' + NACELotCharge);
                if(ASME!='N'||PED!='N') {
                    if(testDiscMap.get(decTDPM)!=9999999) {
                        AsmeCeLotChargeA=testDiscMap.get(decTDPM)*PriceTempTestQtyA;
                        RDPricing.ASME_CE_or_Temp_Test_Lot_Charge__c=AsmeCeLotChargeA;
                    } else {
                        AsmeCeLotChargeA=9999999;
                        RDPricing.ASME_CE_or_Temp_Test_Lot_Charge__c=AsmeCeLotChargeA;
                    }

                }
                System.debug('RD PRICING AsmeCeLotChargeA: ' + AsmeCeLotChargeA);
            }

            // for(string key:mapDiscountableFields.keySet()) {
            //     DiscountablePriceEach+=(decimal) rdPricing.get(mapPricingFields.get(key));
            //     if((decimal) rdPricing.get(mapPricingFields.get(key))==9999999) {
            //         DiscountablePriceEach=9999999;
            //         break;
            //     }
            // }
            // for(string key:mapNonDiscountableFields.keySet()) {
            //     NondiscountableLotCharge+=(decimal) rdPricing.get(mapPricingFields.get(key));
            //     if((decimal) rdPricing.get(mapPricingFields.get(key))==9999999) {
            //         NondiscountableLotCharge=9999999;
            //         break;
            //     }
            // }
            DiscountablePriceEach=BaseDiscPriceA + MfgRngA + VacSup + Ring + Gasket + Liner + Coating + IntBDIA + IntBDIWireA + CleaningA + IndPack + Holder + HandSup + DentProt + ArmorRing + decsurfFinish + SpecAssyPriceAddA + thirdPartyTestDiscPriceEach ;

            NondiscountableLotCharge= AsmeCeLotChargeA + ThirdPartyLotChargeA + LiqLotCharge + GraphiteLotA + SpecAssyLotChargeA + PMILotCharge + BackPressureLotCharge + NaceLotCharge + CUTRLotCharge + KOSHALotCharge + CSALotCharge + ATEXLotCharge;


            System.debug('RD PRICING DiscountablePriceEach: ' + DiscountablePriceEach);
            System.debug('RD PRICING NON DiscountablePriceEach: ' + NondiscountableLotCharge);

            System.debug('RD PRICING TOTAL: ' + RDPricing.Total_Price__c);
            decimal discountablePrz=0.0;
            decimal nonDiscountablePrz=0.0;
            decimal total=0.0;
            for (string key:mapPricingOverriddenFields.keySet()){
                System.debug('key: ' + key);
                if (rdPricing.get(mapPricingFields.get(key))!=null) {
                    if(mapNonDiscountableFields.containsKey(key))
                        nonDiscountablePrz+=(decimal) rdPricing.get(mapPricingFields.get(key));
                    else if (mapDiscountableFields.containsKey(key))
                        discountablePrz+=(decimal) rdPricing.get(mapPricingFields.get(key));
                    if((decimal) rdPricing.get(mapPricingFields.get(key))==9999999) {
                        if (mapDiscountableFields.containsKey(key))
                            DiscountablePriceEach=9999999;
                        else if(mapNonDiscountableFields.containsKey(key))
                            NondiscountableLotCharge=9999999;
                        total=9999999;
                    }
                }
                if(!rdRecord.Price_Override__c)
                    rdPricing.put(mapPricingOverriddenFields.get(key),rdPricing.get(mapPricingFields.get(key)));

            }
            if(DiscountablePriceEach==9999999)
                discountablePrz=9999999;
            if(NondiscountableLotCharge==9999999)
                nonDiscountablePrz=9999999;
            RDPricing.Discountable_Price_Each__c=discountablePrz;
            RDPricing.Non_Discountable_Price_Each__c=nonDiscountablePrz;
            rdRecord.Discountable_Price__c=discountablePrz;
            rdRecord.Non_Discountable_Price__c=nonDiscountablePrz;
            if(total==9999999)
                RDPricing.Total_Price__c=total;
            else
                RDPricing.Total_Price__c=discountablePrz+(nonDiscountablePrz/QTY);

        }
        upsert RDPricing;
        upsert rdRecord;
        // } catch (Exception e) {
        //     System.debug(e.getMessage());
        //     System.debug(e.getCause());
        // }
        return resPriceCal;
    }
    public static result getRDAdderBaseList (string strPTC,string strSZC,string strSeat,integer Qty,string MfgRng){
        Result objResult=new Result();
        //Qty=1;
        strSZC=ConstantsUtil.getSizeDesc(strSZC).SZC;
        String strQuery='select Mfg_Rng__c,List_Price__c,Part__c,Part_Matl__c,BP72LL__c,BP72UL__c from RDPricingDiscComponentPricing__c ';
        strQuery=strQuery+'where Prod__c LIKE \'%'+strPTC+'%\' and Size__c =\''+strSZC+'\' and  Comp_Seat__c LIKE \'%'+strSeat+'%\' and QtyLL__c<='+Qty+' and QtyUL__c>='+Qty+' and ( Mfg_Rng__c LIKE \'%'+MfgRng+'%\' OR Mfg_Rng__c=\'-\')';
        System.debug('Pricing Base Data Query'+strQuery);
        try {
            RDPricingDiscComponentPricing__c[] rdDiscQty=Database.query(strQuery);
            if(!rdDiscQty.isEmpty()) {
                System.debug('Pricing Base Data Size'+rdDiscQty.size());
                objResult.objResultList=rdDiscQty;
                objResult.bResult=true;
            }
        } catch  (exception e) {
            objResult.bResult=false;
            objResult.strErrorMessage=e.getMessage();
        }
        return objResult;
    }
    public static result getRDAdderValues(sObject[] sobjBasePrList, string strPart,string strPartMatl,decimal decTMRFloat) {
        Result objResult=new Result();
        try {
            for(sObject sObj:sobjBasePrList) {
                String strFieldPart= (String) sobj.get('Part__c');
                Boolean partBoolean= strFieldPart.contains(strPart);
                string strFieldVal = '';
                if((String) sobj.get('Part_Matl__c') != null){
                    strFieldVal=(String) sobj.get('Part_Matl__c');
                }

                decimal decLL=(decimal) sObj.get('BP72LL__c');
                decimal decUL=(decimal) sObj.get('BP72UL__c');
                if (partBoolean && strFieldVal.contains(strPartMatl) && (decTMRFloat>decLL && decTMRFloat<=decUL))
                {
                    objResult.dblRetValue=(decimal) sobj.get('List_Price__c');
                    objResult.bResult=true;
                    break;
                }
            }
            if(!objResult.bResult) {
                objResult.bResult=false;
                objResult.dblRetValue=9999999;
                objResult.strErrorMessage='No List Price Found';
            }

        } catch (exception e) {
            objResult.bResult=false;
            objResult.dblRetValue=0;
            objResult.strErrorMessage='No Data Found';
        }
        return objResult;
    }
}