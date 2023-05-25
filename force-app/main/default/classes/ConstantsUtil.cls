public with sharing class ConstantsUtil {
    public static List<String> componentOptions = new List<String> {
        'OUTLET GASKET',
            'INLET GASKET',
            'INLET RING',
            'INLET RING 2',
            'ARCUATE RING',
            'OUTLET RING',
            'MIDDLE RING',
            'INLET LINER',
            'OUTLET LINER',
            'INLET COATING',
            'OUTLET COATING',
            'DISC',
            'TOP SECTION',
            'SEAL',
            'GIRDLE',
            'DENT PROTECTOR',
            'VACUUM SUPPORT',
            'VACUUM SUPPORT INLET',
            'HANDLING SUPPORT',
            'INLET',
            'OUTLET',
            'HOLDOWN RING',
            'INLET O-RING',
            'ARMOR RING',
            'HI-TEMP ASSEMBLY'
            };
                public static RD_GeneralMaterialsList__c[] RDMaterialList=[select MatlCode__c,Matl__c from RD_GeneralMaterialsList__c];
    public static Map<String, String> materialDescription() {
        Map<String,string> stDec = new Map<String, String>();
        for (RD_GeneralMaterialsList__c sz : RDMaterialList) {
            if(!stDec.containsKey(sz.MatlCode__c)) {
                stDec.put(sz.MatlCode__c,sz.Matl__c);
            }
        }
        return stDec;
    }
    public static map<string,string> mapMatlCodewithMatl=new map<string,string>(materialDescription());
    // public static Map<string,string> mapMatlCodewithMatl{
    //     get{
    //         return new Map<string,string>
    //         {
    //             '001'=>'Aluminum',
    //                 '002'=>'Alloy 400',
    //                 '003'=>'Alloy 600',
    //                 '004'=>'Nickel',
    //                 '005'=>'316 SS',
    //                 '006'=>'Alloy B',
    //                 '007'=>'Alloy C276',
    //                 '008'=>'Tantalum',
    //                 '009'=>'Titanium',
    //                 '010'=>'Gold',
    //                 '011'=>'Platinum',
    //                 '012'=>'Silver',
    //                 '013'=>'Lead',
    //                 '014'=>'Alloy 20',
    //                 '015'=>'FDA Grade Red Silicone',
    //                 '016'=>'254 SMO SS (F44)',
    //                 '017'=>'Titanium Grade 2',
    //                 '018'=>'Flexible Graphite',
    //                 '019'=>'ECTFE',
    //                 '020'=>'Carbon Steel',
    //                 '021'=>'Alloy Steel',
    //                 '022'=>'Brass',
    //                 '023'=>'Bronze',
    //                 '024'=>'Copper',
    //                 '025'=>'Zirconium',
    //                 '026'=>'FDA Grade Clear Silicone',
    //                 '027'=>'Alloy B2',
    //                 '030'=>'Alloy 625',
    //                 '031'=>'Alloy 825',
    //                 '033'=>'Polycarbonate',
    //                 '034'=>'Polycarbonate',
    //                 '035'=>'Black Buna-N',
    //                 '036'=>'Polystyrene',
    //                 '037'=>'PVC',
    //                 '038'=>'Silicone Rubber',
    //                 '039'=>'Vinyl',
    //                 '040'=>'Kynar(R)',
    //                 '041'=>'Zinc/Phos Ctd/Alloy',
    //                 '042'=>'SAF 2205 Alloy Steel',
    //                 '043'=>'Graphite',
    //                 '044'=>'Black Neoprene',
    //                 '045'=>'Polyethylene',
    //                 '046'=>'Fiberglass',
    //                 '047'=>'Acetal',
    //                 '048'=>'Epoxy',
    //                 '049'=>'Nylon 6/6',
    //                 '050'=>'316L SS',
    //                 '051'=>'304 SS',
    //                 '052'=>'304L SS',
    //                 '053'=>'310 SS',
    //                 '054'=>'303 SS',
    //                 '055'=>'317 SS',
    //                 '056'=>'317L SS',
    //                 '057'=>'320 SS',
    //                 '058'=>'320L SS',
    //                 '059'=>'17-7 SS',
    //                 '060'=>'17-4 SS',
    //                 '061'=>'321 SS',
    //                 '062'=>'347 SS',
    //                 '063'=>'AA 3003-H14 (ASTM B209)',
    //                 '069'=>'Alloy C4',
    //                 '070'=>'Fluoropolymer',
    //                 '071'=>'PTFE',
    //                 '072'=>'PFA',
    //                 '073'=>'FEP',
    //                 '074'=>'Polyimide',
    //                 '075'=>'Kalrez(R)',
    //                 '076'=>'Black FKM',
    //                 '077'=>'Black Chemfilm(R)',
    //                 '078'=>'Glass-Filled Fluoropolymer',
    //                 '079'=>'Phenolic',
    //                 '080'=>'Non-Asbestos',
    //                 '081'=>'Alloy C22',
    //                 '082'=>'White Buna-N',
    //                 '084'=>'SAPP',
    //                 '085'=>'Fluoropolymer/Fiberglass',
    //                 '086'=>'EPDM',
    //                 '087'=>'ASTM A 105',
    //                 '088'=>'Fiberfrax(R)',
    //                 '089'=>'ASME SA-350-LF1',
    //                 '090'=>'ASME SA-350-LF2',
    //                 '091'=>'ASTM A 350-LF2',
    //                 '092'=>'ASME SA-350-LF3',
    //                 '093'=>'ASTM A 322-4140',
    //                 '094'=>'ASTM A 181-60',
    //                 '095'=>'ASTM A 181-70',
    //                 '096'=>'ASTM A 182-F11-CLS2',
    //                 '097'=>'ASTM A 182-F12',
    //                 '098'=>'ASTM A 576',
    //                 '099'=>'300 Series SS',
    //                 '0A1'=>'ASTM A 516-70',
    //                 '0A2'=>'ASTM A 216-WCB',
    //                 '0A3'=>'ASTM A 193-B7',
    //                 '0A4'=>'ASTM A 322-4340',
    //                 '0A5'=>'Polyolefin',
    //                 '0A6'=>'ASME SA-182-F22',
    //                 '0A7'=>'AA 6061-T6',
    //                 '0A8'=>'AA 2024-T4',
    //                 '0A9'=>'AA 6061-T651',
    //                 '0AA'=>'ASME SA-182-F316 (EN 10204 3.2)',
    //                 '0AB'=>'Acrylic',
    //                 '0AC'=>'Belden(R) 85230',
    //                 '0AD'=>'ASTM B 479-1100-H19',
    //                 '0AE'=>'Graph-Lock(R) 3124',
    //                 '0AF'=>'Blue PVC',
    //                 '0AG'=>'ASTM B 148',
    //                 '0AH'=>'Alloy K500',
    //                 '0AJ'=>'316/316L SS',
    //                 '0AK'=>'316 SS (Electropolished)',
    //                 '0AL'=>'316L SS (Electropolished)',
    //                 '0AM'=>'Ceramic',
    //                 '0AN'=>'ASME SB-168 Section III',
    //                 '0AO'=>'ASME SA-193-B7 Section III',
    //                 '0AP'=>'ASME SA-194-2H Section III',
    //                 '0AQ'=>'ASME SA-723-G3-C2A',
    //                 '0AR'=>'FDA Grade FEP',
    //                 '0AS'=>'Case Hardened Steel',
    //                 '0AT'=>'ASTM A 320-L7M',
    //                 '0AU'=>'ASTM A 194-7M',
    //                 '0AV'=>'ETFE',
    //                 '0AW'=>'Belden(R) 89463',
    //                 '0AX'=>'ASTM A 108-1045',
    //                 '0AY'=>'Titanium Grade 3',
    //                 '0AZ'=>'ASTM A 352-LCB',
    //                 '0B1'=>'AA 2024-T351',
    //                 '0B2'=>'AA 2219-T8511',
    //                 '0B3'=>'ASTM B 574',
    //                 '0B5'=>'Polyurethane',
    //                 '0B6'=>'Blue-Gard(R) 3200',
    //                 '0B7'=>'White Neoprene',
    //                 '0B8'=>'Calcium Impregnated PTFE',
    //                 '0B9'=>'Gylon(R) 3500',
    //                 '0BA'=>'ASTM A 193-B8',
    //                 '0BB'=>'ASTM A 194-8',
    //                 '0BC'=>'ASME SA-182-F304L Ni > 9.5% & Mo < .5%',
    //                 '0BD'=>'THERM-PUR 4122-FC',
    //                 '0BE'=>'ASME SA-723-G1-C2A',
    //                 '0BF'=>'FKM GF',
    //                 '0BG'=>'ASTM A 320-B8',
    //                 '0BH'=>'ASTM A 352-LCC',
    //                 '0BI'=>'ASME SA-182-F304L Ni > 9.5% & Mo < .4%',
    //                 '0BJ'=>'ASTM A 320-8',
    //                 '0BK'=>'Tealon(R) TF1580',
    //                 '0BL'=>'Titanium Grade 7',
    //                 '0BM'=>'316 SS C >= .04%',
    //                 '0BN'=>'ASTM A 194-2HM',
    //                 '0BO'=>'Fluorosilicone',
    //                 '0BP'=>'Thermiculite(R) 715',
    //                 '0BQ'=>'ASTM A 320-B8M',
    //                 '0BR'=>'Polyamide',
    //                 '0BS'=>'Isofrax(R) 1260C',
    //                 '0BT'=>'ASTM A194-7',
    //                 '0BU'=>'ASTM A350-7',
    //                 '0BV'=>'Kalrez(R) 4079',
    //                 '0BW'=>'ASME SA-564-630',
    //                 '0BX'=>'Nitrile (N0602-70)',
    //                 '0BY'=>'AA 4047',
    //                 '0BZ'=>'ASTM A193-B7',
    //                 '0C1'=>'Garlock(R) 9850',
    //                 '0C2'=>'Gylon(R) 3510',
    //                 '0C3'=>'Naval Bronze',
    //                 '0C4'=>'Copper 110',
    //                 '0C5'=>'Gylon(R) 3545',
    //                 '0C6'=>'Alloy 718',
    //                 '0C7'=>'ASTM A 182-F304',
    //                 '0C8'=>'ASTM A 479-316',
    //                 '0C9'=>'PH 13-8 SS AMS 5629',
    //                 '0CA'=>'ASTM A193-B8M NACE',
    //                 '0CB'=>'ASTM A194-8M NACE',
    //                 '0CC'=>'301 SS',
    //                 '0CD'=>'PBT',
    //                 '0CE'=>'ASTM A514',
    //                 '0CF'=>'Duplex 2507',
    //                 '0CG'=>'ASTM A 333',
    //                 '0CH'=>'MARKEZ(R) Z1028',
    //                 '0CI'=>'EPR Rubber',
    //                 '0CJ'=>'Blue FKM',
    //                 '0CK'=>'HNBR (35% ACN)',
    //                 '0CL'=>'AA319-F',
    //                 '0CM'=>'Chloroprene',
    //                 '0CN'=>'ASTM A29-4140',
    //                 '0CO'=>'Hard Drawn Zinc Coated (Galvanized) Steel',
    //                 '0CP'=>'ASTM A182-F53',
    //                 '0CQ'=>'PTFE Coated SS',
    //                 '0CR'=>'ASTM A420-WPL6',
    //                 '0CT'=>'ASME SA-105 w/ impact test',
    //                 '0CU'=>'Low Smoke Zero Halogen',
    //                 '0CV'=>'1.4401 (EN 10216-5)',
    //                 '0CW'=>'1.4401 (EN 10217-7)',
    //                 '0CX'=>'1.4401 (EN 1515-4)',
    //                 '0CY'=>'1.4404 (EN 10216-5)',
    //                 '0CZ'=>'1.4404 (EN 10217-7)',
    //                 '0D1'=>'White EPDM',
    //                 '0D2'=>'AA 1145 (ASTM B373)',
    //                 '0D3'=>'18-8 SS',
    //                 '0D4'=>'Alloy 20',
    //                 '0D5'=>'ABS',
    //                 '0D7'=>'304H SS',
    //                 '0D8'=>'ASTM A 579',
    //                 '0D9'=>'ASTM A 194-2H',
    //                 '0DA'=>'1.4404 (EN 1515-4)',
    //                 '0DB'=>'1.0425 (EN 10216-2)',
    //                 '0DC'=>'1.0425 (EN 10217-2/10217-5)',
    //                 '0DD'=>'ENAW-6061 (EN 12392)',
    //                 '0DE'=>'1.4435',
    //                 '0DF'=>'Klingertop-chem-2000',
    //                 '0DG'=>'PVDF',
    //                 '0DH'=>'316LN SS',
    //                 '0DI'=>'EPR-962',
    //                 '0DJ'=>'2# Ester',
    //                 '0DK'=>'ASTM A515-65',
    //                 '0DL'=>'Klingersil (R) C-4401',
    //                 '0DM'=>'Hard Drawn Zinc Coated Steel',
    //                 '0DN'=>'ASME SA-182-304/304L',
    //                 '0DO'=>'ASTM A193-B8M Class 2',
    //                 '0DP'=>'ASTM A193-B8 Class 1',
    //                 '0DQ'=>'ASTM A193-B8 Class 2',
    //                 '0DR'=>'ASTM A320-B8 Class 1',
    //                 '0DS'=>'ASTM A320-B8 Class 2',
    //                 '0DT'=>'ASTM A320-B8M Class 1',
    //                 '0DU'=>'ASTM A320-B8M Class 2',
    //                 '0DV'=>'ASTM A 194-2',
    //                 '0DW'=>'ASTM A 194-8 Class 1',
    //                 '0DX'=>'ASTM A 194-8 Class 2',
    //                 '0DY'=>'ASTM A 194-2HM',
    //                 '0DZ'=>'ASTM A181-60 Section III',
    //                 '0E1'=>'Gylon(R) 3504',
    //                 '0E2'=>'Silicone',
    //                 '0E3'=>'Natural Chemfilm(R)',
    //                 '0E4'=>'PTFE',
    //                 '0E5'=>'Duplex 2205 SS',
    //                 '0E6'=>'316Ti SS',
    //                 '0E7'=>'ASME SA-182-F51',
    //                 '0E8'=>'LowTemp Buna-N',
    //                 '0E9'=>'4130 HT Alloy Steel',
    //                 '0EA'=>'ASTM A 194-8M Class 2',
    //                 '0EB'=>'ASTM A995 Grade 5',
    //                 '0EC'=>'ASTM A 182-F51',
    //                 '0ED'=>'Polyphenylene Sulfide (PPS) - 40% Glass Filled',
    //                 '0EE'=>'316 H SS/1.4401',
    //                 '0EF'=>'Alloy B3',
    //                 '0EG'=>'Alloy C276 (Electropolished)',
    //                 '0EH'=>'AA 3003-0',
    //                 '0EI'=>'400 Series SS',
    //                 '0EJ'=>'FDA Grade/USP Class VI Black Viton(R) GF-600S',
    //                 '0EK'=>'O1 Tool Steel',
    //                 '0EL'=>'ASTM A193-B7 NACE',
    //                 '0EM'=>'ASTM A194-2H NACE',
    //                 '0EN'=>'HNBR',
    //                 '0EO'=>'AA 5052-H32',
    //                 '0EP'=>'EPR Rubber (Grey)',
    //                 '0EQ'=>'ASME SA-479-316',
    //                 '0ER'=>'PEEK (Polyetheretherketone)',
    //                 '0F1'=>'Blue-Gard(R) 3700',
    //                 '0F2'=>'Malleable Iron',
    //                 '0F3'=>'Hypalon(R)',
    //                 '0F4'=>'ASTM A 320-L7',
    //                 '0F6'=>'Alloy 800-HT',
    //                 '0F7' => 'ASTM A 350-LF3',
    //                 '0F8'=>'PCTFE',
    //                 '0F9'=>'Blue-Gard(R) 3300',
    //                 '0G1'=>'Butyl',
    //                 '0G3'=>'Polypropylene',
    //                 '0G4'=>'Gylon(R) HP3561',
    //                 '0G8'=>'Garlock(R) 9900',
    //                 '0G9'=>'AA 5052-O',
    //                 '0H1'=>'AA 5052-H34',
    //                 '0H2'=>'AA 1100-O',
    //                 '0H3'=>'AA 6061-O',
    //                 '0H4'=>'AA 6061-T4',
    //                 '0H5'=>'1018 Carbon Steel',
    //                 '0H7'=>'Thermoplastic Rubber',
    //                 '0H8'=>'Foam',
    //                 '0H9'=>'H13 Tool Steel',
    //                 '0I1'=>'Mika/Alloy 600',
    //                 '0I2'=>'Cad Plated Alloy Stl',
    //                 '0I3'=>'Blue EPDM',
    //                 '0I4'=>'Black EPDM',
    //                 '0I5'=>'ASME SA-723-G2-C2A',
    //                 '0I6'=>'AA 1100 (ASTM B209)',
    //                 '0I7'=>'440C SS (AFBMA GR48)',
    //                 '0I8'=>'Music Wire',
    //                 '0I9'=>'Super Duplex',
    //                 '0J1'=>'ASTM B 265-2',
    //                 '0J2'=>'ASTM B 265-1',
    //                 '0J3'=>'ASTM A 182-F55',
    //                 '0J4'=>'Haynes 230(R)',
    //                 '0J5'=>'Graph-Lock(R) 3125TC',
    //                 '0J6'=>'AISI 4130',
    //                 '0J7'=>'TiNiobium',
    //                 '0J8'=>'FDA Grade White Viton(R)',
    //                 '0J9'=>'Belden(R) 8422',
    //                 '0K1'=>'ASME Brass',
    //                 '0K2'=>'302 SS',
    //                 '0K3'=>'Blue-Gard(R) 3000',
    //                 '0K4'=>'ASME SA-193-B8S',
    //                 '0K5'=>'ASME SB-162-201',
    //                 '0K6'=>'ASME SA-240-316',
    //                 '0K7'=>'ASTM B 162-201',
    //                 '0K8'=>'AISI A2',
    //                 '0K9'=>'Carpenter Project 70',
    //                 '0L1'=>'90/10 Copper Nickel',
    //                 '0L2'=>'Graph-Lock(R) 3125SS',
    //                 '0L3'=>'Zirconium 702',
    //                 '0L4'=>'FDA Grade Black Viton(R)',
    //                 '0L5'=>'FDA Grade White Buna-N',
    //                 '0L6'=>'FDA Grade Black EPDM',
    //                 '0L7'=>'FDA Grade White EPDM',
    //                 '0L8'=>'FDA Grade PTFE',
    //                 '0L9'=>'ASME SA-723-G1-C2',
    //                 '0M1'=>'Fluoropolymer Encapsulated FKM',
    //                 '0M2'=>'Flexible Graphite/304',
    //                 '0M3'=>'ASTM A 351-CF8M',
    //                 '0M4'=>'Flexible Graphite',
    //                 '0M5'=>'ASTM A 182-6 MO',
    //                 '0M6'=>'Cork Elastomer',
    //                 '0M8'=>'Zinc Plated Steel',
    //                 '0M9'=>'904L SS',
    //                 '0N1'=>'FDA Grade Platinum Cured Silicone',
    //                 '0N3'=>'Flexible Graphite/316',
    //                 '0N5'=>'FDA Grade/USP Class VI Steel Reinforced PTFE',
    //                 '0N6'=>'Hastelloy C-2000(R)',
    //                 '0N7'=>'Hastelloy B-3(R)',
    //                 '0N8'=>'FDA Grade Black Buna-N',
    //                 '0P1'=>'Belden(R) 8441',
    //                 '0P2'=>'ASME SA-216-WCB',
    //                 '0P3'=>'ASME SA-105',
    //                 '0P4'=>'ASME SA-516-70',
    //                 '0P5'=>'ASME SA-240-316L',
    //                 '0P6'=>'FDA Grade/USP Class VI Peroxide Cured Silicone',
    //                 '0P7'=>'FDA Grade/USP Class VI Black Viton(R)',
    //                 '0P8'=>'FDA Grade/USP Class VI Black EPDM',
    //                 '0P9'=>'FDA Grade/USP Class VI White EPDM',
    //                 '0Q1'=>'FDA Grade/USP Class VI PTFE',
    //                 '0Q2'=>'FDA Grade/USP Class VI Platinum Cured Silicone',
    //                 '0Q4'=>'ASME SA-479-316 Section III',
    //                 '0Q5'=>'ASME SA-182 Section III',
    //                 '0Q6'=>'Hydrogenated Nitrile (N1231-80)',
    //                 '0Q7'=>'Thermiculite(R) 815',
    //                 '0Q8'=>'AMS 4340H',
    //                 '0Q9'=>'416 SS',
    //                 '0R1'=>'Silver Solder',
    //                 '0R2'=>'Kalrez(R) 6230',
    //                 '0R3'=>'410 SS',
    //                 '0R4'=>'FDA Grade/USP Class VI Red Silicone',
    //                 '0R5'=>'FDA Grade/USP Class VI White Viton(R)',
    //                 '0R6'=>'ASME SB-209-1145-H19',
    //                 '0R8'=>'Belden(R) 87760',
    //                 '0R9'=>'Glass',
    //                 '0S1'=>'Alloy 2562',
    //                 '0S2'=>'Nodular Iron',
    //                 '0S3'=>'420 SS',
    //                 '0S5'=>'Alloy X',
    //                 '0S6'=>'Nitrile',
    //                 '0S7'=>'Cadmium Plated Steel',
    //                 '0S8'=>'SBR Rubber',
    //                 '0S9'=>'FR 25',
    //                 '0T1'=>'Galvanized Steel',
    //                 '0T2'=>'Belden(R) 3072F',
    //                 '0T3'=>'Garlock(R) 5500',
    //                 '0T4'=>'ASME SA-182-F11',
    //                 '0T5'=>'ASTM A 401',
    //                 '0T6'=>'ASTM A 229',
    //                 '0T7'=>'Derakane(R) 411-45',
    //                 '0T8'=>'Derakane(R) 470-36',
    //                 '0T9'=>'Furan',
    //                 '0U2'=>'Brown FKM',
    //                 '0U3'=>'13-8 SS',
    //                 '0U4'=>'Spring Steel',
    //                 '0U5'=>'Aflas(R)',
    //                 '0U6'=>'Gylon(R) 3540',
    //                 '0U7'=>'PH 15-7 SS',
    //                 '0U8'=>'Chemraz(R)',
    //                 '0V1'=>'ePTFE',
    //                 '0V3'=>'PBT',
    //                 '0V4'=>'Nylon',
    //                 '0V5'=>'ASTM B 479-8111-H19',
    //                 '0V6'=>'Black FKM B',
    //                 '0V7'=>'Nickel Plated Steel',
    //                 '0V8'=>'Alloy 800H',
    //                 '0V9'=>'AA 2011-T3 Aluminum',
    //                 '0W1'=>'Graph-Lock(R) 3128 Hochdruck',
    //                 '0W2'=>'Chlorinated Polyvinyl Chloride',
    //                 '0W3'=>'High Density Polyethylene',
    //                 '0W4'=>'Phenolic Resin J2027L',
    //                 '0W5'=>'ASME SA-106',
    //                 '0W6'=>'Klinger(R) 2005',
    //                 '0W7'=>'ASME SA-182-F5',
    //                 '0W8'=>'ASME SA-182-F9',
    //                 '0X1'=>'Fairprene(R)',
    //                 '0X3'=>'Black FKM A',
    //                 '0X4'=>'Werkstoff 1.0425 Carbon Steel',
    //                 '0X5'=>'ASME SA-182-F316L',
    //                 '0X6'=>'ASTM A 516-60',
    //                 '0X7'=>'ASTM A 193-B7M',
    //                 '0X8'=>'ASTM A 194-4',
    //                 '0X9'=>'AL-6XN(R) Alloy',
    //                 '0Y1'=>'ASTM A 193-B8M Class 1',
    //                 '0Y2'=>'ASTM A 194-8M Class 1',
    //                 '0Y3'=>'Cast Iron',
    //                 '0Y4'=>'FKM F',
    //                 '0Y5'=>'ASME SA-240',
    //                 '0Y6'=>'ASME SA-479',
    //                 '0Y8'=>'ASTM A 494-M-35-2',
    //                 '0Z2'=>'Sigma 600 White PTFE',
    //                 '0Z3'=>'Hetron(R) 197-3',
    //                 '0Z4'=>'Inconel(R) X-750',
    //                 '0Z5'=>'ASME SA-494-CW12MW',
    //                 '0Z6'=>'NEDOX(R) FM-5 Coating',
    //                 '0Z7'=>'PPO-PS',
    //                 '0Z8'=>'ASME SA-105 Section III',
    //                 '0Z9'=>'ASME SA-516-70 Section III'
    //                 };

    //                     }
    //     set  {
    //         mapMatlCodewithMatl = value;
    //     }
    // }
    public static RD_SeatList__c[] RDSeatList=[SELECT Id, PartSeat__c, AssySeat__c, Desc__c, Sort_Order__c, SizeUL__c, SeatGroup__c, SizeLL__c FROM RD_SeatList__c];
    public static Map<String, String> seatDescription() {
        Map<String,string> stDec = new Map<String, String>();
        for (RD_SeatList__c sz : RDSeatList) {
            if(!stDec.containsKey(sz.AssySeat__c)) {
                stDec.put(sz.AssySeat__c,sz.Desc__c);
            }
        }
        return stDec;
    }
    public static Map<String, List<RD_SeatList__c>> seatDescriptionWithSZC() {
        Map<String,List<RD_SeatList__c>> stDec = new Map<String, List<RD_SeatList__c>>();
        for (RD_SeatList__c sz : RDSeatList) {
            if(!stDec.containsKey(sz.AssySeat__c)) {
                List<RD_SeatList__c> temp=new List<RD_SeatList__c>();
                temp.add(sz);
                stDec.put(sz.AssySeat__c,temp);
            } else {
                stDec.get(sz.AssySeat__c).add(sz);
            }
        }
        return stDec;
    }
    public static string getSeatDescFromSZCandSTC(string STC,string SZC) {
        string strSeatDesc=STC;
        decimal decSZC=getSizeVal(SZC);
        if(mapSTCDescWithSZC.containsKey(STC)) {
            for(RD_SeatList__c dsp:mapSTCDescWithSZC.get(STC)) {
                if(decimal.valueOf(dsp.SizeLL__c)<=decSZC && decimal.valueOf(dsp.SizeUL__c)>decSZC)
                    strSeatDesc=dsp.Desc__c;
            }
        }
        return strSeatDesc;

    }
    public static map<string,List<RD_SeatList__c>> mapSTCDescWithSZC=new map<string,List<RD_SeatList__c>>(seatDescriptionWithSZC());
    public static map<string,string> mapSTCDesc=new map<string,string>(seatDescription());
    //  public static map<string,string> mapSTCDesc= new map<string,string> {
    //     'A1'  =>  '150# ASME Bolting',
    //     'A2'  =>  '300# ASME Bolting',
    //     'A3'  =>  '300/600# ASME Bolting',
    //     'A3'  =>  '600# ASME Bolting',
    //     'A4'  =>  '900# ASME Bolting',
    //     'A5'  =>  '900/1500# ASME Bolting',
    //     'A5'  =>  '1500# ASME Bolting',
    //     'A6'  =>  '2500# ASME Bolting',
    //     'A9'  =>  '400# ASME Bolting',
    //     'AA'  =>  '(AA) Autoclave Angular Seat',
    //     'AF'  =>  '(AF) Autoclave Flat Seat',
    //     'C1'  =>  '1000 PSIG',
    //     'C2'  =>  '2000 PSIG',
    //     'C3'  =>  '3000 PSIG',
    //     'C4'  =>  '4000 PSIG',
    //     'C5'  =>  '6000 PSIG',
    //     'C6'  =>  '10000 PSIG',
    //     'C7'  =>  '15000 PSIG',
    //     'C8'  =>  '20000 PSIG',
    //     'C9'  =>  '10 PSIG',
    //     'CA'  =>  '40 PSIG',
    //     'CB'  =>  '50 PSIG',
    //     'CC'  =>  '75 PSIG',
    //     'CD'  =>  '100 PSIG',
    //     'CE'  =>  '1200 PSIG',
    //     'CF'  =>  '(CF) Flanged Clean Sweep',
    //     'CJ'  =>  '9137 PSIG',
    //     'CL'  =>  '(CL) Flanged Clean Sweep',
    //     'CS'  =>  '(CS) Sanitary Clean Sweep',
    //     'D1'  =>  'PN 6 DIN Bolting',
    //     'D2'  =>  'PN 10 DIN Bolting',
    //     'D3'  =>  'PN 10/16 DIN Bolting',
    //     'D3'  =>  'PN 16 DIN Bolting',
    //     'D4'  =>  'PN 25 DIN Bolting',
    //     'D5'  =>  'PN 10/40 DIN Bolting',
    //     'D5'  =>  'PN 25/40 DIN Bolting',
    //     'D5'  =>  'PN 40 DIN Bolting',
    //     'D6'  =>  'PN 63 DIN Bolting',
    //     'D7'  =>  'PN 100 DIN Bolting',
    //     'D8'  =>  'PN 63/160 DIN Bolting',
    //     'D8'  =>  'PN 100/160 DIN Bolting',
    //     'D8'  =>  'PN 160 DIN Bolting',
    //     'D9'  =>  'PN 250 DIN Bolting',
    //     'DD'  =>  '(DD) Double Disc',
    //     'DZ'  =>  'PN 320 DIN Bolting',
    //     'FH'  =>  '(FH) Fike Heavy Lip',
    //     'FL'  =>  '(FL) Fike Light Lip',
    //     'FS'  =>  '(FS) Flat Seat',
    //     'FU'  =>  '(FU) Fike Union Light Lip',
    //     'FX'  =>  '(FX) Fike Union Heavy Lip',
    //     'HF'  =>  '(HF) High Pressure Flat Seat',
    //     'HL'  =>  '(HL) Heavy Lip',
    //     'IS'  =>  '(IS) Industry Standard',
    //     'J1'  =>  '2/5K JIS Bolting',
    //     'J1'  =>  '5K JIS Bolting',
    //     'J2'  =>  '10K JIS Bolting',
    //     'J3'  =>  '16K JIS Bolting',
    //     'J4'  =>  '10/20K JIS Bolting',
    //     'J4'  =>  '16/20K JIS Bolting',
    //     'J4'  =>  '20K JIS Bolting',
    //     'J5'  =>  '30K JIS Bolting',
    //     'J6'  =>  '30/40K JIS Bolting',
    //     'J6'  =>  '40K JIS Bolting',
    //     'J7'  =>  '63K JIS Bolting',
    //     'LL'  =>  '(LL) Light Lip',
    //     'NA'  =>  '(NA) NovAseptic NA-Connect',
    //     'QC'  =>  '(QC) Quick Change',
    //     'QL'  =>  '(QL) Low Pressure Quick Change',
    //     'QU'  =>  '(QU) UNISERT Quick Change',
    //     'S1'  =>  '30 PSIG',
    //     'S2'  =>  '40 PSIG',
    //     'S3'  =>  '50 PSIG',
    //     'S4'  =>  '75 PSIG',
    //     'S5'  =>  '100 PSIG',
    //     'S6'  =>  '150 PSIG',
    //     'S7'  =>  '175 PSIG',
    //     'S8'  =>  '200 PSIG',
    //     'S9'  =>  '250 PSIG',
    //     'SA'  =>  '275 PSIG',
    //     'SB'  =>  '720 PSIG',
    //     'SF'  =>  '(SF) Sanitary Fitting',
    //     'SL'  =>  '(SL) Sanitary Clean Sweep',
    //     'TG'  =>  '(TG) Tongue and Groove',
    //     'UF'  =>  '(UF) Union Flat Seat',
    //     'UH'  =>  '(UH) Union Heavy Lip',
    //     'UL'  =>  '(UL) Union Light Lip',
    //     'UT'  =>  '(UT) Union Tongue and Groove',
    //     'VP'  =>  '(VP) Vent Panel',
    //     'Z1'  =>  'for (LL) Screw Type Holder',
    //     'Z2'  =>  'for (FS) Screw Type Holder',
    //     'Z3'  =>  'for (HF) Screw Type Holder'

    //     };
    public static RD_ProductList__c[] RDProdList=[SELECT Code__c, Dispaly__c,Type__c FROM RD_ProductList__c];
    public static Map<String, String> mapPTCDescriptions() {
        Map<String,string> stDec = new Map<String, String>();
        for (RD_ProductList__c sz : RDProdList) {
            if(!stDec.containsKey(sz.Code__c) && sz.Type__c=='Product') {
                stDec.put(sz.Code__c,sz.Dispaly__c);
            }
        }
        return stDec;
    }
    public static map<string,string> mapPTCDesc=new map<string,string>(mapPTCDescriptions());
    // public static map<String,String> mapPTCDesc =new map<String,String> {
    //     'CAL'  =>  'CAL-VAC',
    //         'CDC'   =>  'CDC',
    //         'CDG'   =>  'CDCV-G',
    //         'CDS'   =>  'CDCV-G in Screw Type',
    //         'CDT'   =>  'CDCV-G in Tite-Seal',
    //         'CDV'   =>  'CDCV',
    //         'CFC'   =>  'Composite Formed Circular Vent Panel',
    //         'CFR'   =>  'Composite Formed Rectangular Vent Panel',
    //         'CFS'   =>  'Composite Formed Square Vent Panel',
    //         'CPC'   =>  'Composite Flat Circular Vent Panel',
    //         'CPR'   =>  'Composite Flat Rectangular Vent Panel',
    //         'CPS'   =>  'Composite Flat Square Vent Panel',
    //         'EV1'   =>  'ENVIRO-SEAL I',
    //         'EV2'   =>  'ENVIRO-SEAL II',
    //         'EV3'   =>  'ENVIRO-SEAL III',
    //         'FCM'   =>  'CM',
    //         'FCV'   =>  'CMV',
    //         'FFA'   =>  'FA',
    //         'FFS'   =>  'FAS',
    //         'FFV'   =>  'FAV',
    //         'FRS'   =>  'RAS',
    //         'GFS'   =>  'GRAFSERT',
    //         'HP2'   =>  'SANITRX HPX II-95',
    //         'HPH'   =>  'SANITRX HPX II-90',
    //         'HPN'   =>  'HPX-90',
    //         'HPS'   =>  'SANITRX HPX-95',
    //         'HPT'   =>  'HPX-Ta',
    //         'HPX'   =>  'HPX-95',
    //         'HPZ'   =>  'SANITRX HPX-90',
    //         'ICL'   =>  'ICON-TL',
    //         'ICN'   =>  'ICON',
    //         'KBA'   =>  'KBA',
    //         'LCM'   =>  'CM (LaMOT)',
    //         'LCV'   =>  'CMV (LaMOT)',
    //         'LDG'   =>  'LDV-G (LaMOT)',
    //         'LDS'   =>  'LDV-G in Screw Type (L)',
    //         'LDT'   =>  'LDV-G in Throwaway (L)',
    //         'LDV'   =>  'LDV (LaMOT)',
    //         'LFA'   =>  'FA (LaMOT)',
    //         'LFV'   =>  'FAV (LaMOT)',
    //         'LI1'   =>  'IS1 (LaMOT)',
    //         'LI2'   =>  'IS2 (LaMOT)',
    //         'LLD'   =>  'LD (LaMOT)',
    //         'LOX'   =>  'LOTRX',
    //         'LPL'   =>  'PL',
    //         'LPV'   =>  'LPLV (LaMOT)',
    //         'LPX'   =>  'SANITRX LPX',
    //         'LSD'   =>  'STD (LaMOT)',
    //         'LSS'   =>  'STD in Screw Type (L)',
    //         'LST'   =>  'STD in Throwaway (L)',
    //         'M9T'   =>  'MX-9T',
    //         'MCX'   =>  'MICRO X',
    //         'MNX'   =>  'MINTRX',
    //         'PAS'   =>  'POS-A-SET',
    //         'PCS'   =>  'PC-SERT',
    //         'PLL'   =>  'LPL (LaMOT)',
    //         'PLV'   =>  'PLV',
    //         'RCS'   =>  'RCS',
    //         'RSD'   =>  'RSD',
    //         'RSW'   =>  'RSDW',
    //         'RVT'   =>  'SRA in RVI Tite-Seal',
    //         'SFC'   =>  'Standard Formed Circular Vent Panel',
    //         'SLS'   =>  'SEALSERT',
    //         'SNL'   =>  'SANITRX LP',
    //         'SNX'   =>  'SANITRX',
    //         'SRA'   =>  'SRA in Tite-Seal',
    //         'SRS'   =>  'SRA (Screwtype)',
    //         'SRU'   =>  'SRA (Union)',
    //         'SRV'   =>  'SRA (RVI)',
    //         'SST'   =>  'SRA in Screw Type',
    //         'STD'   =>  'STANDARD',
    //         'STT'   =>  'STD in Tite-Seal',
    //         'STX'   =>  'STAR X',
    //         'SXM'   =>  'SANITRX MP',
    //         'SXP'   =>  'STAR X HP',
    //         'TKS'   =>  'TANKSERT',
    //         'ULH'   =>  'ULTRX HP',
    //         'ULX'   =>  'ULTRX',
    //         'VIP'   =>  'VIP',
    //         'VPC'   =>  'Flat Circular Vent Panel',
    //         'VPR'   =>  'Flat Rectangular Vent Panel',
    //         'VPS'   =>  'Flat Square Vent Panel',
    //         'VRD'   =>  'VRD',
    //         'WMP'   =>  'WMP',
    //         'WMR'   =>  'WMR',
    //         'ZAP'   =>  'ZAP'
    //         } ;

    // Map<String, CustomObject__c> myMap = new Map<String, CustomObject__c>();
    // for(CustomObject__c objCS : [Select z.Name, z.Id From CustomObject__c z])
    //         myMap.put(objCS.Name, objCS);
    // public Decimal SizeValue {get;set;}
    //     public String nmDesc {get;set;}
    //     public String mmDesc {get;set;}
    //     public String DescIND {get;set;}
    //     public String DescMMA {get;set;}
    //     public String DescMMD {get;set;}
    public static RD_SizeList__c[] sizeList=[SELECT Id, Sort_Order__c, Desc__c, code__c, DescMMA__c, SizeValue__c, mmDesc__c, DescMMD__c, DescIND__c FROM RD_SizeList__c];

    public static Map<String, SizeDesc> sizeDescription() {
        Map<String,SizeDesc> szDec = new Map<String, SizeDesc>();
        for (RD_SizeList__c sz : sizeList) {
            if(!szDec.containsKey(sz.code__c)) {
                szDec.put(sz.code__c,new SizeDesc(sz.code__c, Decimal.valueOf(sz.SizeValue__c), sz.Desc__c, sz.mmDesc__c,sz.DescIND__c , sz.DescMMA__c, sz.DescMMD__c));
            }
        }
        return szDec;
    }
    public static Map<String, SizeDesc> sizeDescriptions=new Map<String, SizeDesc>(sizeDescription());
    // public static Map<String,SizeDesc> szDec = new Map<String, SizeDesc> {
    //     '0001' => new SizeDesc('0001', 0.0625, '1/16"', '1/16"', '', '', '')
    // };
    // public static Map<String, SizeDesc> sizeDescriptions = new Map<String, SizeDesc> {
    //     '0001' => new SizeDesc('0001', 0.0625, '1/16"', '1/16"', '', '', ''),
    //     '0002' => new SizeDesc('0002', 0.125, '1/8"', '1/8', '', '', ''),
    //     '0003' => new SizeDesc('0003', 0.1875, '3/16"', '3/16"', '', '', ''),
    //     '0004' => new SizeDesc('0004', 0.25, '1/4"', '1/4"', '', '', ''),
    //     '0005' => new SizeDesc('0005', 0.3125, '5/16"', '5/16"', '', '', ''),
    //     '0006' => new SizeDesc('0006', 0.375, '3/8"', '3/8"', '', '', ''),
    //     '0007' => new SizeDesc('0007', 0.4375, '7/16"', '7/16"', '', '', ''),
    //     '0008' => new SizeDesc('0008', 0.5, '1/2" (13mm)', '(1/2") 13mm', '', '', ''),
    //     '0009' => new SizeDesc('0009', 0.5625, '9/16"', '9/16"', '', '', ''),
    //     '0010' => new SizeDesc('0010', 0.625, '5/8"', '5/8"', '', '', ''),
    //     '0011' => new SizeDesc('0011', 0.6875, '11/16"', '11/16"', '', '', ''),
    //     '0012' => new SizeDesc('0012', 0.75, '3/4" (20mm)', '(3/4") 20mm', '', '', ''),
    //     '0013' => new SizeDesc('0013', 0.8125, '13/16"', '13/16"', '', '', ''),
    //     '0014' => new SizeDesc('0014', 0.875, '7/8"', '7/8"', '', '', ''),
    //     '0015' => new SizeDesc('0015', 0.9375, '15/16"', '15/16"', '', '', ''),
    //     '0100' => new SizeDesc('0100', 1, '1" (25mm)', '(1") 25mm', '', '', ''),
    //     '0104' => new SizeDesc('0104', 1.25, '1-1/4" (32mm)', '(1-1/4") 32mm', '', '', ''),
    //     '0108' => new SizeDesc('0108', 1.5, '1-1/2" (40mm)', '(1-1/2") 40mm', '', '', ''),
    //     '0200' => new SizeDesc('0200', 2, '2" (50mm)', '(2") 50mm', '', '', ''),
    //     '0208' => new SizeDesc('0208', 2.5, '2-1/2" (65mm)', '(2-1/2") 65mm', '', '', ''),
    //     '0300' => new SizeDesc('0300', 3, '3" (80mm)', '(3") 80mm', '', '', ''),
    //     '0308' => new SizeDesc('0308', 3.5, '3-1/2" (89mm)', '(3-1/2") 89mm', '', '', ''),
    //     '0400' => new SizeDesc('0400', 4, '4" (100mm)', '(4") 100mm', '', '', ''),
    //     '0600' => new SizeDesc('0600', 6, '6" (150mm)', '(6") 150mm', '', '', ''),
    //     '0800' => new SizeDesc('0800', 8, '8" (200mm)', '(8") 200mm', '', '', ''),
    //     '1200' => new SizeDesc('1200', 12, '12" (300mm)', '(12") 300mm', '', '', ''),
    //     '1400' => new SizeDesc('1400', 14, '14" (350mm)', '(14") 350mm', '', '', ''),
    //     '1000' => new SizeDesc('1000', 10, '10" (250mm)', '(10") 250mm', '', '', ''),
    //     '1600' => new SizeDesc('1600', 16, '16" (400mm)', '(16") 400mm', '', '', ''),
    //     '1800' => new SizeDesc('1800', 18, '18" (450mm)', '(18") 450mm', '', '', ''),
    //     '2000' => new SizeDesc('2000', 20, '20" (500mm)', '(20") 500mm', '', '', ''),
    //     '2400' => new SizeDesc('2400', 24, '24" (600mm)', '(24") 600mm', '', '', ''),
    //     '2600' => new SizeDesc('2600', 26, '26" (650mm)', '(26") 650mm', '', '', ''),
    //     '2800' => new SizeDesc('2800', 28, '28" (700mm)', '(28") 700mm', '', '', ''),
    //     '3000' => new SizeDesc('3000', 30, '30" (750mm)', '(30") 750mm', '', '', ''),
    //     '3200' => new SizeDesc('3200', 32, '32" (800mm)', '(32") 800mm', '', '', ''),
    //     '3600' => new SizeDesc('3600', 36, '36" (900mm)', '(36") 900mm', '', '', ''),
    //     '4000' => new SizeDesc('4000', 40, '40" (102cm)', '(40") 102cm', '', '', ''),
    //     '1212' => new SizeDesc('1212', 12, '12" x 12', '(12") 30cm x (12") 30cm', '', '', ''),
    //     '1218' => new SizeDesc('1218', 18, '12" x 18', '(12") 30cm x (18") 46cm', '', '', ''),
    //     '1224' => new SizeDesc('1224', 24, '12" x 24', '(12") 30cm x (24") 61cm', '', '', ''),
    //     '1818' => new SizeDesc('1818', 18, '18" x 18', '(18") 46cm x (18") 46cm', '', '', ''),
    //     '1824' => new SizeDesc('1824', 24, '18" x 24', '(18") 46cm x (24") 61cm', '', '', ''),
    //     '1830' => new SizeDesc('1830', 30, '18" x 30', '(18") 46cm x (30") 76cm', '', '', ''),
    //     '1835' => new SizeDesc('1835', 35, '18" x 35', '(18") 46cm x (35") 89cm', '', '', ''),
    //     '2424' => new SizeDesc('2424', 24, '24" x 24', '(24") 61cm x (24") 61cm', '', '', ''),
    //     '2430' => new SizeDesc('2430', 30, '24" x 30', '(24") 61cm x (30") 76cm', '', '', ''),
    //     '2436' => new SizeDesc('2436', 36, '24" x 36', '(24") 61cm x (36") 91cm', '', '', ''),
    //     '2444' => new SizeDesc('2444', 44, '24" x 44', '(24") 61cm x (44") 112cm', '', '', ''),
    //     '3030' => new SizeDesc('3030', 30, '30" x 30', '(30") 76cm x (30") 76cm', '', '', ''),
    //     '3036' => new SizeDesc('3036', 36, '30" x 36', '(30") 76cm x (36") 91cm', '', '', ''),
    //     '3044' => new SizeDesc('3044', 44, '30" x 44', '(30") 76cm x (44") 112cm', '', '', ''),
    //     '3636' => new SizeDesc('3636', 36, '36" x 36', '(36") 91cm x (36") 91cm', '', '', ''),
    //     '3644' => new SizeDesc('3644', 44, '36" x 44', '(36") 91cm x (44") 112cm', '', '', ''),
    //     '4400' => new SizeDesc('4400', 44, '44" (112cm)', '(44") 112cm', '', '', ''),
    //     '4444' => new SizeDesc('4444', 44, '44" x 44', '(44") 112cm x (44") 112cm', '', '', ''),
    //     '0110' => new SizeDesc('0110', 1.625, '1-5/8" (42mm)', '1-5/8" (42mm)', '', '', ''),
    //     '4469' => new SizeDesc('4469', 69, '44" x 69', '(44") 112cm x (69") 175cm', '', '', ''),
    //     '4200' => new SizeDesc('4200', 42, '42"', '(42") x (42") ', '', '', '')
    // };
    public static Map<String,String> prodCodeImageNameMap = new Map<String,String> {
        'CAL' => 'CAL-VAC',
            'CDC' => 'STANDARD 30deg SEAT',
            'CDG' => 'STANDARD 30deg SEAT',
            'CDT' => 'STANDARD 30deg SEAT',
            'CDV' => 'STANDARD 30deg SEAT',
            'CFC' => 'STANDARD 30deg SEAT',
            'CFR' => 'STANDARD 30deg SEAT',
            'CFS' => 'STANDARD 30deg SEAT',
            'CPC' => 'STANDARD 30deg SEAT',
            'CPR' => 'STANDARD 30deg SEAT',
            'CPS' => 'STANDARD 30deg SEAT',
            'EV1' => 'ENVIRO-SEAL',
            'EV2' => 'ENVIRO-SEAL',
            'EV3' => 'ENVIRO-SEAL',
            'FCM' => 'STANDARD 30deg SEAT',
            'FCV' => 'STANDARD 30deg SEAT',
            'FFA' => 'STANDARD 30deg SEAT',
            'FFS' => 'STANDARD 30deg SEAT',
            'FFV' => 'STANDARD 30deg SEAT',
            'FRS' => 'STANDARD 30deg SEAT',
            'GFS' => 'GRAFSERT',
            'HP2' => 'SANITRX HPX II',
            'HPH' => 'SANITRX HPX II',
            'HPN' => 'HPX',
            'HPS' => 'SRA SANITRX HPX',
            'HPT' => 'HPX-Ta',
            'HPX' => 'HPX',
            'HPZ' => 'SRA SANITRX HPX',
            'ICN' => 'ICON',
            'KBA' => 'STANDARD 30deg SEAT',
            'LCM' => 'STANDARD 30deg SEAT',
            'LCV' => 'STANDARD 30deg SEAT',
            'LDG' => 'STANDARD 30deg SEAT',
            'LDS' => 'STANDARD 30deg SEAT',
            'LDT' => 'STANDARD 30deg SEAT',
            'LDV' => 'STANDARD 30deg SEAT',
            'LFA' => 'STANDARD 30deg SEAT',
            'LFV' => 'STANDARD 30deg SEAT',
            'LI1' => 'STANDARD 30deg SEAT',
            'LI2' => 'STANDARD 30deg SEAT',
            'LLD' => 'STANDARD 30deg SEAT',
            'LOX' => 'LOTRX',
            'LPL' => 'STANDARD 30deg SEAT',
            'LPV' => 'STANDARD 30deg SEAT',
            'LPX' => 'SANITRX LPX',
            'LSD' => 'STANDARD 30deg SEAT',
            'LSS' => 'STANDARD 30deg SEAT',
            'LST' => 'STANDARD 30deg SEAT',
            'M9T' => 'STANDARD 30deg SEAT',
            'MCX' => 'MICRO X',
            'MNX' => 'MINTRX',
            'PAS' => 'POS-A-SET',
            'PCS' => 'STANDARD 30deg SEAT',
            'PLL' => 'STANDARD 30deg SEAT',
            'PLV' => 'STANDARD 30deg SEAT',
            'RCS' => 'RCS',
            'RSD' => 'STANDARD 30deg SEAT',
            'RSW' => 'STANDARD 30deg SEAT',
            'RVT' => 'STANDARD 30deg SEAT',
            'SFC' => 'STANDARD 30deg SEAT',
            'SLS' => 'STANDARD 30deg SEAT',
            'SNL' => 'SANITRX LP',
            'SNX' => 'STANDARD 30deg SEAT',
            'SRA' => 'STANDARD 30deg SEAT',
            'SRS' => 'SRA SANITRX HPX',
            'SRU' => 'SRA SANITRX HPX',
            'SRV' => 'SRA SANITRX HPX',
            'STD' => 'STANDARD 30deg SEAT',
            'STT' => 'STANDARD 30deg SEAT',
            'STX' => 'STAR X',
            'SXM' => 'STANDARD 30deg SEAT',
            'SXP' => 'STANDARD 30deg SEAT',
            'TKS' => 'TANKSERT',
            'ULH' => 'STANDARD 30deg SEAT',
            'ULX' => 'ULTRX',
            'VIP' => 'STANDARD 30deg SEAT',
            'VPC' => 'STANDARD 30deg SEAT',
            'VPR' => 'STANDARD 30deg SEAT',
            'VPS' => 'STANDARD 30deg SEAT',
            'VRD' => 'STANDARD 30deg SEAT',
            'WMP' => 'WMP',
            'Unassigned1' => 'COMPOSITE 30deg SEAT',
            'Unassigned2' => 'COMPOSITE FS'
            };
                public static Boolean isValidComponentOption(String fieldName) {
                    return componentOptions.indexOf(fieldName.toUpperCase()) > -1;
                }
    public static SizeDesc getSizeDesc(String SZC) {
        String key = '';
        switch on SZC.length() {
            when 1 {
                key = '000' + SZC;
            }
            when 2 {
                key = '00' + SZC;
            }
            when 3 {
                key = '0' + SZC;
            }
            when else {
                key = SZC;
            }
        }
        if (sizeDescriptions.containsKey(key))
            return sizeDescriptions.get(key);
        else
            return null;
    }
    public static Decimal getSizeVal(String SZC) {
        System.debug('SZC-->'+SZC);
        return getSizeDesc(SZC).SizeValue==null?decimal.valueOf(SZC):getSizeDesc(SZC).SizeValue;
    }
    public static string getSzcDesc(String SZC) {
        if((getSizeDesc(SZC).nmDesc != NULL)){
            return getSizeDesc(SZC).nmDesc;
        } else{
            return '';
        }
    }
    public static Decimal getSizeVal12(String SZC) {
        System.debug('SZC-->'+SZC);
        System.debug('XXXXXXXXX->'+sizeList[0].code__c);
        return getSizeDesc(SZC).SizeValue==null?decimal.valueOf(SZC):getSizeDesc(SZC).SizeValue;
    }
    // TODO : move these methods to util
    public static sObject queryTableValue(String fieldsString, String tableName, String whereConditions, Map<String,Object> whereVariables) {
        sObject sObj = null;
        String whereClause = whereConditions;
        try {
            if(whereConditions.contains('{{')) {
                Set<String> keys = whereVariables.keySet();
                for(String key : keys) {
                    String keyVar = '{{' + key + '}}';
                    Object value = whereVariables.get(key);
                    if(whereConditions.contains(key)) {
                        whereClause = whereClause.replaceAll(key, String.valueOf(value));
                    }
                }
            }
            System.debug('whereClause Nikhil: ' + whereClause);
            System.debug('fieldsString Nikhil: ' + fieldsString);
            sObj = Database.query(
                'SELECT ' + fieldsString + ' FROM ' + tableName + ' WHERE ' + whereClause + ' LIMIT 1'
            );
        } catch(DMLException dmle) {
            System.debug('Error in dml call');
            //sObj = Schema.getGlobalDescribe().get(tableName).newSObject();
        }
        return sObj;
    }

    public static List<sObject> queryTableValue2(String fieldsString, String tableName, String whereConditions, Map<String,Object> whereVariables) {
        List<sObject> sObjList = null;
        String whereClause = whereConditions;
        try {
            if(whereConditions.contains('{{')) {
                Set<String> keys = whereVariables.keySet();
                for(String key : keys) {
                    String keyVar = '{{' + key + '}}';
                    Object value = whereVariables.get(key);
                    if(whereConditions.contains(key)) {
                        whereClause = whereClause.replaceAll(key, String.valueOf(value));
                    }
                }
            }
            System.debug('whereClause Nikhil: ' + whereClause);
            System.debug('fieldsString Nikhil: ' + fieldsString);
            sObjList = Database.query(
                'SELECT ' + fieldsString + ' FROM ' + tableName + ' WHERE ' + whereClause
            );
        } catch(DMLException dmle) {
            System.debug('Error in dml call');
            //sObj = Schema.getGlobalDescribe().get(tableName).newSObject();
        }
        return sObjList;
    }
    public static List<sObject> queryTableValues(String fieldsString, String tableName, String whereConditions, Map<String,Object> whereVariables, String limitOrderBy) {
        List<sObject> sObjList = null;
        String whereClause = whereConditions;
        try {
            if(whereConditions.contains('{{')) {
                Set<String> keys = whereVariables.keySet();
                for(String key : keys) {
                    String keyVar = '{{' + key + '}}';
                    Object value = whereVariables.get(key);
                    if(whereConditions.contains(key)) {
                        whereClause = whereClause.replaceAll(key, String.valueOf(value));
                    }
                }
            }
            sObjList = Database.query(
                'SELECT ' + fieldsString + ' FROM ' + tableName + ' WHERE ' + whereClause + ' ' + limitOrderBy
            );
        } catch(DMLException dmle) {
            System.debug('Error in dml call');
            //sObj = Schema.getGlobalDescribe().get(tableName).newSObject();
        }
        return sObjList;
    }

    public static String join(List<String> values, String delmiter) {
        String result = '';
        Integer lastIdx = values.size() - 1;
        for (Integer idx=0; idx<values.size(); idx++) {
            result += idx!=lastIdx ? values.get(idx) + delmiter : values.get(idx);
        }
        return result;
    }

    public class SizeDesc {
        public String SZC {get;set;}
        public Decimal SizeValue {get;set;}
        public String nmDesc {get;set;}
        public String mmDesc {get;set;}
        public String DescIND {get;set;}
        public String DescMMA {get;set;}
        public String DescMMD {get;set;}

        public SizeDesc(String sizeCode, Decimal sizeVal, String nonMtrcDesc, String mtrcDesc, String indDesc, String mmaDesc, String mmdDesc) {
            SZC = sizeCode;
            SizeValue = sizeVal;
            nmDesc = nonMtrcDesc;
            mmDesc = mtrcDesc;
            DescIND = indDesc;
            DescMMA = mmaDesc;
            DescMMD = mmdDesc;
        }
    }

    public static Map<String,String> brandSourcingEntityMap = new Map<String,String> {
        'CDC' => '10',
            'LaMot' => '10',
            'Groth' => '20',
            'LVA' => '20'
            };
                public static Map<String, String> mapOfHCLASSDesc() {
                    Map<String,string> stDec = new Map<String, String>();
                    for (RD_ProductList__c sz : RDProdList) {
                        if(!stDec.containsKey(sz.Code__c) && sz.Type__c=='HCLASS') {
                            stDec.put(sz.Code__c,sz.Dispaly__c);
                        }
                    }
                    return stDec;
                }
    public static map<string,string> mapOfHCLASS=new map<string,string>(mapOfHCLASSDesc());
    // public static Map<String,String> mapOfHCLASS = new Map<String,String> {
    //     'C1' => '1000 PSIG',
    //     'C3' => '3000 PSIG',
    //     'CF' => '5000 PSIG',
    //     'CJ' => '9137 PSIG',
    //     'C6' => '10000 PSIG',
    //     'C7' => '15000 PSIG',
    //     'C8' => '20000 PSIG'
    // };



    public static Map<String,Decimal> mapOfWithWMPHIC = new Map<String,Decimal> {
        '1 BSPP' => 1,
            '1 BSPT' => 1,
            '1 MPT' => 1,
            '1/2 BSPP' => 0.5,
            '1/2 BSPT' => 0.5,
            '1/2 MPT' => 0.5,
            '1/2-20 SAE' => 0.25,
            '1/4 BSPP' => 0.25,
            '1/4 BSPT' => 0.25,
            '1/4 MPT' => 0.25,
            '1/8 BSPT' => 0.125,
            '1/8 MPT' => 0.125,
            '3/4 BSPP' => 0.75,
            '3/4 BSPT' => 0.75,
            '3/4 MPT' => 0.75,
            '3/4-16 SAE' => 0.375,
            '3/8 BSPP' => 0.375,
            '3/8 BSPT' => 0.375,
            '3/8 MPT' => 0.375,
            '3/8-24 SAE' => 0.125,
            '7/16-20 SAE' => 0.125,
            '9/16-18 SAE' => 0.25
            };

                public static Map<String,Decimal> mapOfWithoutWMPHIC = new Map<String,Decimal> {
                    '1 BSPP' => 1,
                        '1 BSPT' => 1,
                        '1 FPT' => 1,
                        '1 MPT' => 1,
                        '1/2 BSPP' => 0.5,
                        '1/2 BSPT' => 0.5,
                        '1/2 FPT' => 0.5,
                        '1/2 MPT' => 0.5,
                        '1/2-20 SAE' => 0.236,
                        '1/4 BSPP' => 0.25,
                        '1/4 BSPT' => 0.25,
                        '1/4 FPT' => 0.25,
                        '1/4 MPT' => 0.25,
                        '3/4 BSPP' => 0.75,
                        '3/4 BSPT' => 0.75,
                        '3/4 FPT' => 0.75,
                        '3/4 MPT' => 0.75,
                        '3/4-16 SAE' => 0.394,
                        '3/8 BSPP' => 0.375,
                        '3/8 BSPT' => 0.375,
                        '3/8 FPT' => 0.375,
                        '3/8 MPT' => 0.375,
                        '7/16-20 SAE' => 0.177,
                        '9/16-18 SAE' => 0.295,
                        'Free' => 9,
                        'Muffled' => 8,
                        'NA' => 0,
                        'Ring' => 0
                        };
                            }