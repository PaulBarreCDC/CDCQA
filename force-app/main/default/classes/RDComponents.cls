/**
 * @File Name          : RDComponents.cls
 * @Description        :
 * @Author             : ApexIT - SFDC Dev Team
 * @Group              :
 * @Last Modified By   : ApexIT - SFDC Dev Team
 * @Last Modified On   : 11-02-2020
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    13/5/2020   ApexIT - SFDC Dev Team     Initial Version
 * 1.1    18 Aug 2021     Rohini Hathi             Service Ticket #205427, added field D3ASRV in RD_Disc_Comp_Mat_Cd, which is based on 3A Sanitary Stds Certification checkbox
 **/
public with sharing class RDComponents {
    Boolean initialized = false;          //  Tells system whether or not the options have been set by constructor
    public  map<string,List<SelectOption>> mapMatOptions {set;get;}
    public Map<string,string> mapComponents {
        get {
            return new Map<String, String>
            {
                'MCHO'  => 'Material_Outlet__c',
                'MCHRNG'  => 'Material_Holddown_Ring__c',
                'MCAR'  => 'Material_Arcuate_Ring__c',
                'MCGR1'  => 'Material_Armor_Ring__c',
                'MCOG'  => 'Material_Outlet_Gasket__c',
                'MCGR2'  => 'Material_Armor_Ring2__c',
                'MCOR'  => 'Material_Outlet_Ring__c',
                'MCDP'  => 'Material_Dent_Protector__c',
                'MCOL'  => 'Material_Outlet_Liner__c',
                'MCVS1'  => 'Material_Vacuum_Support__c',
                'MCOC'  => 'Material_Outlet_Coating__c',
                'MCDT1'  => 'Material_Top_Section__c',
                'MCDD'  => 'Material_Disc__c',
                'MCSS1'  => 'Material_Seal__c',
                'MCGD'  => 'Material_Girdle__c',
                'MCSS2'  => 'Material_Seal2__c',
                'MCDT2'  => 'Material_Top_Section2__c',
                'MCIC1'  => 'Material_Inlet_Coating__c',
                'MCSS3'  => 'Material_Seal3__c',
                'MCIR1'  => 'Material_Inlet_Ring__c',
                'MCIL'  => 'Material_Inlet_Liner__c',
                'MCIR2'  => 'Material_Inlet_Ring2__c',
                'MCVS2'  => 'Material_Vacuum_Support2__c',
                'MCIC2'  => 'Material_Inlet_Coating2__c',
                'MCIR3'  => 'Material_Inlet_Ring3__c',
                'MCHS'  => 'Material_Handling_Support__c',
                'MCVS3'  => 'Material_Vaccum_Support3__c',
                'MCIG'  => 'Material_Inlet_Gasket__c',
                'MCHT'  => 'Material_Hi_Temp_Assembly__c',
                'MCTSOR'  => 'Material_Inlet_O_Ring__c',
                'MCHI'  => 'Material_Inlet__c'
            };

        }
        set  {
            this.mapComponents = value;
        }
    }

        public Map<string,string> mapComponentsMaterials{
        get{
            return new Map<String, String>
            {
                'MCHO'  => 'Outlet',
                'MCHRNG'  => 'Holddown Ring',
                'MCAR'  => 'Arcuate Ring',
                'MCGR1'  => 'Armor Ring',
                'MCOG'  => 'Outlet Gasket',
                'MCGR2'  => 'Armor Ring',
                'MCOR'  => 'Outlet Ring',
                'MCDP'  => 'Dent Protector',
                'MCOL'  => 'Outlet Liner',
                'MCVS1'  => 'Vacuum Support',
                'MCOC'  => 'Outlet Coating',
                'MCDT1'  => 'Top Section',
                'MCDD'  => 'Disc',
                'MCGD'  => 'Girdle',
                'MCDT2'  => 'Top Section',
                'MCIC1'  => 'Inlet Coating',
                'MCIR1'  => 'Inlet Ring',
                'MCIL'  => 'Inlet Liner',
                'MCIR2'  => 'Inlet Ring',
                'MCVS2'  => 'Vacuum Support',
                'MCIC2'  => 'Inlet Coating',
                'MCIR3'  => 'Inlet Ring',
                'MCHS'  => 'Handling Support',
                'MCVS3'  => 'Vacuum Support',
                'MCIG'  => 'Inlet Gasket',
                'MCHT'  => 'Hi-Temp Assembly',
                'MCTSOR'  => 'Inlet O-Ring',
                'MCHI'  => 'Inlet',
                'MCSS3'=> 'Seal',
                'MCSS1'=>'Seal',
                'MCSS2'=>'Seal'

            };
        }
        set  {
            this.mapComponentsMaterials = value;
            }
    }
    public string strAtex {set;get;}
    public string strNace {set;get;}
    public Boolean bool3ASanitaryStds{set;get;}//Service Ticket #205427
    public Map<string,string> mapMatlCodewithMatl{get;set;}
//  public Map<string,string> mapMatlCodewithMatl{
//  get{
//   return new Map<string,string>
//   {
//     '01'=>'Aluminum',
//     '02'=>'Alloy 400',
//     '03'=>'Alloy 600',
//     '04'=>'Nickel',
//     '05'=>'316 SS',
//     '06'=>'Alloy B',
//     '07'=>'Alloy C276',
//     '08'=>'Tantalum',
//     '09'=>'Titanium',
//     '10'=>'Gold',
//     '11'=>'Platinum',
//     '12'=>'Silver',
//     '13'=>'Lead',
//     '14'=>'Alloy 20',
//     '15'=>'FDA Grade Red Silicone',
//     '16'=>'254 SMO SS (F44)',
//     '17'=>'Titanium Grade 2',
//     '18'=>'Flexible Graphite',
//     '19'=>'ECTFE',
//     '20'=>'Carbon Steel',
//     '21'=>'Alloy Steel',
//     '22'=>'Brass',
//     '23'=>'Bronze',
//     '24'=>'Copper',
//     '25'=>'Zirconium',
//     '26'=>'FDA Grade Clear Silicone',
//     '27'=>'Alloy B2',
//     '30'=>'Alloy 625',
//     '31'=>'Alloy 825',
//     '33'=>'Polycarbonate',
//     '34'=>'Polycarbonate',
//     '35'=>'Black Buna-N',
//     '36'=>'Polystyrene',
//     '37'=>'PVC',
//     '38'=>'Silicone Rubber',
//     '39'=>'Vinyl',
//     '40'=>'Kynar(R)',
//     '41'=>'Zinc/Phos Ctd/Alloy',
//     '42'=>'SAF 2205 Alloy Steel',
//     '43'=>'Graphite',
//     '44'=>'Black Neoprene',
//     '45'=>'Polyethylene',
//     '46'=>'Fiberglass',
//     '47'=>'Acetal',
//     '48'=>'Epoxy',
//     '49'=>'Nylon 6/6',
//     '50'=>'316L SS',
//     '51'=>'304 SS',
//     '52'=>'304L SS',
//     '53'=>'310 SS',
//     '54'=>'303 SS',
//     '55'=>'317 SS',
//     '56'=>'317L SS',
//     '57'=>'320 SS',
//     '58'=>'320L SS',
//     '59'=>'17-7 SS',
//     '60'=>'17-4 SS',
//     '61'=>'321 SS',
//     '62'=>'347 SS',
//     '63'=>'AA 3003-H14 (ASTM B209)',
//     '69'=>'Alloy C4',
//     '70'=>'Fluoropolymer',
//     '71'=>'PTFE',
//     '72'=>'PFA',
//     '73'=>'FEP',
//     '74'=>'Polyimide',
//     '75'=>'Kalrez(R)',
//     '76'=>'Black FKM',
//     '77'=>'Black Chemfilm(R)',
//     '78'=>'Glass-Filled Fluoropolymer',
//     '79'=>'Phenolic',
//     '80'=>'Non-Asbestos',
//     '81'=>'Alloy C22',
//     '82'=>'White Buna-N',
//     '84'=>'SAPP',
//     '85'=>'Fluoropolymer/Fiberglass',
//     '86'=>'EPDM',
//     '87'=>'ASTM A 105',
//     '88'=>'Fiberfrax(R)',
//     '89'=>'ASME SA-350-LF1',
//     '90'=>'ASME SA-350-LF2',
//     '91'=>'ASTM A 350-LF2',
//     '92'=>'ASME SA-350-LF3',
//     '93'=>'ASTM A 322-4140',
//     '94'=>'ASTM A 181-60',
//     '95'=>'ASTM A 181-70',
//     '96'=>'ASTM A 182-F11-CLS2',
//     '97'=>'ASTM A 182-F12',
//     '98'=>'ASTM A 576',
//     '99'=>'300 Series SS',
//     'A1'=>'ASTM A 516-70',
//     'A2'=>'ASTM A 216-WCB',
//     'A3'=>'ASTM A 193-B7',
//     'A4'=>'ASTM A 322-4340',
//     'A5'=>'Polyolefin',
//     'A6'=>'ASME SA-182-F22',
//     'A7'=>'AA 6061-T6',
//     'A8'=>'AA 2024-T4',
//     'A9'=>'AA 6061-T651',
//     'AA'=>'ASME SA-182-F316 (EN 10204 3.2)',
//     'AB'=>'Acrylic',
//     'AC'=>'Belden(R) 85230',
//     'AD'=>'ASTM B 479-1100-H19',
//     'AE'=>'Graph-Lock(R) 3124',
//     'AF'=>'Blue PVC',
//     'AG'=>'ASTM B 148',
//     'AH'=>'Alloy K500',
//     'AJ'=>'316/316L SS',
//     'AK'=>'316 SS (Electropolished)',
//     'AL'=>'316L SS (Electropolished)',
//     'AM'=>'Ceramic',
//     'AN'=>'ASME SB-168 Section III',
//     'AO'=>'ASME SA-193-B7 Section III',
//     'AP'=>'ASME SA-194-2H Section III',
//     'AQ'=>'ASME SA-723-G3-C2A',
//     'AR'=>'FDA Grade FEP',
//     'AS'=>'Case Hardened Steel',
//     'AT'=>'ASTM A 320-L7M',
//     'AU'=>'ASTM A 194-7M',
//     'AV'=>'ETFE',
//     'AW'=>'Belden(R) 89463',
//     'AX'=>'ASTM A 108-1045',
//     'AY'=>'Titanium Grade 3',
//     'AZ'=>'ASTM A 352-LCB',
//     'B1'=>'AA 2024-T351',
//     'B2'=>'AA 2219-T8511',
//     'B3'=>'ASTM B 574',
//     'B5'=>'Polyurethane',
//     'B6'=>'Blue-Gard(R) 3200',
//     'B7'=>'White Neoprene',
//     'B8'=>'Calcium Impregnated PTFE',
//     'B9'=>'Gylon(R) 3500',
//     'BA'=>'ASTM A 193-B8',
//     'BB'=>'ASTM A 194-8',
//     'BC'=>'ASME SA-182-F304L Ni > 9.5% & Mo < .5%',
//     'BD'=>'THERM-PUR 4122-FC',
//     'BE'=>'ASME SA-723-G1-C2A',
//     'BF'=>'FKM GF',
//     'BG'=>'ASTM A 320-B8',
//     'BH'=>'ASTM A 352-LCC',
//     'BI'=>'ASME SA-182-F304L Ni > 9.5% & Mo < .4%',
//     'BJ'=>'ASTM A 320-8',
//     'BK'=>'Tealon(R) TF1580',
//     'BL'=>'Titanium Grade 7',
//     'BM'=>'316 SS C >= .04%',
//     'BN'=>'ASTM A 194-2HM',
//     'BO'=>'Fluorosilicone',
//     'BP'=>'Thermiculite(R) 715',
//     'BQ'=>'ASTM A 320-B8M',
//     'BR'=>'Polyamide',
//     'BS'=>'Isofrax(R) 1260C',
//     'BT'=>'ASTM A194-7',
//     'BU'=>'ASTM A350-7',
//     'BV'=>'Kalrez(R) 4079',
//     'BW'=>'ASME SA-564-630',
//     'BX'=>'Nitrile (N0602-70)',
//     'BY'=>'AA 4047',
//     'BZ'=>'ASTM A193-B7',
//     'C1'=>'Garlock(R) 9850',
//     'C2'=>'Gylon(R) 3510',
//     'C3'=>'Naval Bronze',
//     'C4'=>'Copper 110',
//     'C5'=>'Gylon(R) 3545',
//     'C6'=>'Alloy 718',
//     'C7'=>'ASTM A 182-F304',
//     'C8'=>'ASTM A 479-316',
//     'C9'=>'PH 13-8 SS AMS 5629',
//     'CA'=>'ASTM A193-B8M NACE',
//     'CB'=>'ASTM A194-8M NACE',
//     'CC'=>'301 SS',
//     'CD'=>'PBT',
//     'CE'=>'ASTM A514',
//     'CF'=>'Duplex 2507',
//     'CG'=>'ASTM A 333',
//     'CH'=>'MARKEZ(R) Z1028',
//     'CI'=>'EPR Rubber',
//     'CJ'=>'Blue FKM',
//     'CK'=>'HNBR (35% ACN)',
//     'CL'=>'AA319-F',
//     'CM'=>'Chloroprene',
//     'CN'=>'ASTM A29-4140',
//     'CO'=>'Hard Drawn Zinc Coated (Galvanized) Steel',
//     'CP'=>'ASTM A182-F53',
//     'CQ'=>'PTFE Coated SS',
//     'CR'=>'ASTM A420-WPL6',
//     'CT'=>'ASME SA-105 w/ impact test',
//     'CU'=>'Low Smoke Zero Halogen',
//     'CV'=>'1.4401 (EN 10216-5)',
//     'CW'=>'1.4401 (EN 10217-7)',
//     'CX'=>'1.4401 (EN 1515-4)',
//     'CY'=>'1.4404 (EN 10216-5)',
//     'CZ'=>'1.4404 (EN 10217-7)',
//     'D1'=>'White EPDM',
//     'D2'=>'AA 1145 (ASTM B373)',
//     'D3'=>'18-8 SS',
//     'D4'=>'Alloy 20',
//     'D5'=>'ABS',
//     'D7'=>'304H SS',
//     'D8'=>'ASTM A 579',
//     'D9'=>'ASTM A 194-2H',
//     'DA'=>'1.4404 (EN 1515-4)',
//     'DB'=>'1.0425 (EN 10216-2)',
//     'DC'=>'1.0425 (EN 10217-2/10217-5)',
//     'DD'=>'ENAW-6061 (EN 12392)',
//     'DE'=>'1.4435',
//     'DF'=>'Klingertop-chem-2000',
//     'DG'=>'PVDF',
//     'DH'=>'316LN SS',
//     'DI'=>'EPR-962',
//     'DJ'=>'2# Ester',
//     'DK'=>'ASTM A515-65',
//     'DL'=>'Klingersil (R) C-4401',
//     'DM'=>'Hard Drawn Zinc Coated Steel',
//     'DN'=>'ASME SA-182-304/304L',
//     'DO'=>'ASTM A193-B8M Class 2',
//     'DP'=>'ASTM A193-B8 Class 1',
//     'DQ'=>'ASTM A193-B8 Class 2',
//     'DR'=>'ASTM A320-B8 Class 1',
//     'DS'=>'ASTM A320-B8 Class 2',
//     'DT'=>'ASTM A320-B8M Class 1',
//     'DU'=>'ASTM A320-B8M Class 2',
//     'DV'=>'ASTM A 194-2',
//     'DW'=>'ASTM A 194-8 Class 1',
//     'DX'=>'ASTM A 194-8 Class 2',
//     'DY'=>'ASTM A 194-2HM',
//     'DZ'=>'ASTM A181-60 Section III',
//     'E1'=>'Gylon(R) 3504',
//     'E2'=>'Silicone',
//     'E3'=>'Natural Chemfilm(R)',
//     'E4'=>'PTFE',
//     'E5'=>'Duplex 2205 SS',
//     'E6'=>'316Ti SS',
//     'E7'=>'ASME SA-182-F51',
//     'E8'=>'LowTemp Buna-N',
//     'E9'=>'4130 HT Alloy Steel',
//     'EA'=>'ASTM A 194-8M Class 2',
//     'EB'=>'ASTM A995 Grade 5',
//     'EC'=>'ASTM A 182-F51',
//     'ED'=>'Polyphenylene Sulfide (PPS) - 40% Glass Filled',
//     'EE'=>'316 H SS/1.4401',
//     'EF'=>'Alloy B3',
//     'EG'=>'Alloy C276 (Electropolished)',
//     'EH'=>'AA 3003-0',
//     'EI'=>'400 Series SS',
//     'EJ'=>'FDA Grade/USP Class VI Black Viton(R) GF-600S',
//     'EK'=>'O1 Tool Steel',
//     'EL'=>'ASTM A193-B7 NACE',
//     'EM'=>'ASTM A194-2H NACE',
//     'EN'=>'HNBR',
//     'EO'=>'AA 5052-H32',
//     'EP'=>'EPR Rubber (Grey)',
//     'EQ'=>'ASME SA-479-316',
//     'ER'=>'PEEK (Polyetheretherketone)',
//     'F1'=>'Blue-Gard(R) 3700',
//     'F2'=>'Malleable Iron',
//     'F3'=>'Hypalon(R)',
//     'F4'=>'ASTM A 320-L7',
//     'F6'=>'Alloy 800-HT',
//     'F7' => 'ASTM A 350-LF3',
//     'F8'=>'PCTFE',
//     'F9'=>'Blue-Gard(R) 3300',
//     'G1'=>'Butyl',
//     'G3'=>'Polypropylene',
//     'G4'=>'Gylon(R) HP3561',
//     'G8'=>'Garlock(R) 9900',
//     'G9'=>'AA 5052-O',
//     'H1'=>'AA 5052-H34',
//     'H2'=>'AA 1100-O',
//     'H3'=>'AA 6061-O',
//     'H4'=>'AA 6061-T4',
//     'H5'=>'1018 Carbon Steel',
//     'H7'=>'Thermoplastic Rubber',
//     'H8'=>'Foam',
//     'H9'=>'H13 Tool Steel',
//     'I1'=>'Mika/Alloy 600',
//     'I2'=>'Cad Plated Alloy Stl',
//     'I3'=>'Blue EPDM',
//     'I4'=>'Black EPDM',
//     'I5'=>'ASME SA-723-G2-C2A',
//     'I6'=>'AA 1100 (ASTM B209)',
//     'I7'=>'440C SS (AFBMA GR48)',
//     'I8'=>'Music Wire',
//     'I9'=>'Super Duplex',
//     'J1'=>'ASTM B 265-2',
//     'J2'=>'ASTM B 265-1',
//     'J3'=>'ASTM A 182-F55',
//     'J4'=>'Haynes 230(R)',
//     'J5'=>'Graph-Lock(R) 3125TC',
//     'J6'=>'AISI 4130',
//     'J7'=>'TiNiobium',
//     'J8'=>'FDA Grade White Viton(R)',
//     'J9'=>'Belden(R) 8422',
//     'K1'=>'ASME Brass',
//     'K2'=>'302 SS',
//     'K3'=>'Blue-Gard(R) 3000',
//     'K4'=>'ASME SA-193-B8S',
//     'K5'=>'ASME SB-162-201',
//     'K6'=>'ASME SA-240-316',
//     'K7'=>'ASTM B 162-201',
//     'K8'=>'AISI A2',
//     'K9'=>'Carpenter Project 70',
//     'L1'=>'90/10 Copper Nickel',
//     'L2'=>'Graph-Lock(R) 3125SS',
//     'L3'=>'Zirconium 702',
//     'L4'=>'FDA Grade Black Viton(R)',
//     'L5'=>'FDA Grade White Buna-N',
//     'L6'=>'FDA Grade Black EPDM',
//     'L7'=>'FDA Grade White EPDM',
//     'L8'=>'FDA Grade PTFE',
//     'L9'=>'ASME SA-723-G1-C2',
//     'M1'=>'Fluoropolymer Encapsulated FKM',
//     'M2'=>'Flexible Graphite/304',
//     'M3'=>'ASTM A 351-CF8M',
//     'M4'=>'Flexible Graphite',
//     'M5'=>'ASTM A 182-6 MO',
//     'M6'=>'Cork Elastomer',
//     'M8'=>'Zinc Plated Steel',
//     'M9'=>'904L SS',
//     'N1'=>'FDA Grade Platinum Cured Silicone',
//     'N3'=>'Flexible Graphite/316',
//     'N5'=>'FDA Grade/USP Class VI Steel Reinforced PTFE',
//     'N6'=>'Hastelloy C-2000(R)',
//     'N7'=>'Hastelloy B-3(R)',
//     'N8'=>'FDA Grade Black Buna-N',
//     'P1'=>'Belden(R) 8441',
//     'P2'=>'ASME SA-216-WCB',
//     'P3'=>'ASME SA-105',
//     'P4'=>'ASME SA-516-70',
//     'P5'=>'ASME SA-240-316L',
//     'P6'=>'FDA Grade/USP Class VI Peroxide Cured Silicone',
//     'P7'=>'FDA Grade/USP Class VI Black Viton(R)',
//     'P8'=>'FDA Grade/USP Class VI Black EPDM',
//     'P9'=>'FDA Grade/USP Class VI White EPDM',
//     'Q1'=>'FDA Grade/USP Class VI PTFE',
//     'Q2'=>'FDA Grade/USP Class VI Platinum Cured Silicone',
//     'Q4'=>'ASME SA-479-316 Section III',
//     'Q5'=>'ASME SA-182 Section III',
//     'Q6'=>'Hydrogenated Nitrile (N1231-80)',
//     'Q7'=>'Thermiculite(R) 815',
//     'Q8'=>'AMS 4340H',
//     'Q9'=>'416 SS',
//     'R1'=>'Silver Solder',
//     'R2'=>'Kalrez(R) 6230',
//     'R3'=>'410 SS',
//     'R4'=>'FDA Grade/USP Class VI Red Silicone',
//     'R5'=>'FDA Grade/USP Class VI White Viton(R)',
//     'R6'=>'ASME SB-209-1145-H19',
//     'R8'=>'Belden(R) 87760',
//     'R9'=>'Glass',
//     'S1'=>'Alloy 2562',
//     'S2'=>'Nodular Iron',
//     'S3'=>'420 SS',
//     'S5'=>'Alloy X',
//     'S6'=>'Nitrile',
//     'S7'=>'Cadmium Plated Steel',
//     'S8'=>'SBR Rubber',
//     'S9'=>'FR 25',
//     'T1'=>'Galvanized Steel',
//     'T2'=>'Belden(R) 3072F',
//     'T3'=>'Garlock(R) 5500',
//     'T4'=>'ASME SA-182-F11',
//     'T5'=>'ASTM A 401',
//     'T6'=>'ASTM A 229',
//     'T7'=>'Derakane(R) 411-45',
//     'T8'=>'Derakane(R) 470-36',
//     'T9'=>'Furan',
//     'U2'=>'Brown FKM',
//     'U3'=>'13-8 SS',
//     'U4'=>'Spring Steel',
//     'U5'=>'Aflas(R)',
//     'U6'=>'Gylon(R) 3540',
//     'U7'=>'PH 15-7 SS',
//     'U8'=>'Chemraz(R)',
//     'V1'=>'ePTFE',
//     'V3'=>'PBT',
//     'V4'=>'Nylon',
//     'V5'=>'ASTM B 479-8111-H19',
//     'V6'=>'Black FKM B',
//     'V7'=>'Nickel Plated Steel',
//     'V8'=>'Alloy 800H',
//     'V9'=>'AA 2011-T3 Aluminum',
//     'W1'=>'Graph-Lock(R) 3128 Hochdruck',
//     'W2'=>'Chlorinated Polyvinyl Chloride',
//     'W3'=>'High Density Polyethylene',
//     'W4'=>'Phenolic Resin J2027L',
//     'W5'=>'ASME SA-106',
//     'W6'=>'Klinger(R) 2005',
//     'W7'=>'ASME SA-182-F5',
//     'W8'=>'ASME SA-182-F9',
//     'X1'=>'Fairprene(R)',
//     'X3'=>'Black FKM A',
//     'X4'=>'Werkstoff 1.0425 Carbon Steel',
//     'X5'=>'ASME SA-182-F316L',
//     'X6'=>'ASTM A 516-60',
//     'X7'=>'ASTM A 193-B7M',
//     'X8'=>'ASTM A 194-4',
//     'X9'=>'AL-6XN(R) Alloy',
//     'Y1'=>'ASTM A 193-B8M Class 1',
//     'Y2'=>'ASTM A 194-8M Class 1',
//     'Y3'=>'Cast Iron',
//     'Y4'=>'FKM F',
//     'Y5'=>'ASME SA-240',
//     'Y6'=>'ASME SA-479',
//     'Y8'=>'ASTM A 494-M-35-2',
//     'Z2'=>'Sigma 600 White PTFE',
//     'Z3'=>'Hetron(R) 197-3',
//     'Z4'=>'Inconel(R) X-750',
//     'Z5'=>'ASME SA-494-CW12MW',
//     'Z6'=>'NEDOX(R) FM-5 Coating',
//     'Z7'=>'PPO-PS',
//     'Z8'=>'ASME SA-105 Section III',
//     'Z9'=>'ASME SA-516-70 Section III'
//   };

//  }
//  set  {
//     mapMatlCodewithMatl = value;
//             }
//  }


    List<String> cmpntMstrBlstrFields {   //  Get all custom fields from the ComponentMasterBlaster__c sObject, so we don't have to keep adding fields here (API Name for fields on must match ConstantsUtil.componentOptions values to show up)
        get {
            if(cmpntMstrBlstrFields == null) {
                cmpntMstrBlstrFields = new List<String>();
                Map<String, Schema.SObjectField> cmpntMstrBlstrFieldMap = Schema.getGlobalDescribe().get('ComponentMasterBlaster__c').getDescribe().fields.getMap();
                for(String key : cmpntMstrBlstrFieldMap.keySet()) {
                    if(cmpntMstrBlstrFieldMap.get(key).getDescribe().isCustom()) {
                        cmpntMstrBlstrFields.add(key);
                    }
                }
            }
            return cmpntMstrBlstrFields;
        }
        set;
    }
    public String prod {    //  PTC__c in most Rupture Disc tables, saved to Rupture_Disc__c.Product__c
        get;
        set {   //  NOTE: If this value changes, and the class has been initialized, then re-run the valid components; We may be able to get rid of this, if the product selection only happens once in the flow, or if the whole page gets refreshed
            this.prod = value;
            if(initialized && String.isNotBlank(cmbWhereCriteria)) {
                setComponentOptions();
            }
        }
    }
    public String dsc {    //  DSCVAR__c in most Rupture Disc tables, not currently saved to anything.  Needs to be saved with Product Selection
        get;
        set {   //  NOTE: If this value changes, and the class has been initialized, then re-run the valid components; We may be able to get rid of this, if the product selection only happens once in the flow, or if the whole page gets refreshed
            this.dsc = value;
            if(initialized && String.isNotBlank(cmbWhereCriteria)) {
                setComponentOptions();
            }
        }
    }
    public decimal decBMRCHECK {
        get;
        set {
            this.decBMRCHECK=value;
        }
    }
    public string strSTC {
        get;
        set {
            this.strSTC=value;
        }
    }
    public string strMCD {
        get;
        set {
            this.strMCD=value;
        }
    }
    public string strWITHSTANDRDCOMP {
        get;
        set {
            this.strWITHSTANDRDCOMP=value;
        }
    }
    public decimal decRTTMDF {
        get;
        set {
            this.decRTTMDF=value;
        }
    }
    public List<RD_ComponentMBDetail__c> RdCompList{set;get;}
    public map<String,string> mapAttr {set;get;}
    public string optComps {get;set;}
    public string reqComps {get;set;}
    public List<RD_Disc_Comp_Mat_Cd__c> rdCompMaterialName = new List<RD_Disc_Comp_Mat_Cd__c>();
    transient List<RD_Seals_Component_Materials__c> rdSealCompMaaterials=new List<RD_Seals_Component_Materials__c>();
    public list<String> reqComponents {get;set;}
    public list<String> optComponents {get;set;}
    public String size {get;set;}                      //  NOTE: RuptureDisc__c.SZC__c stores the SizeCode, and is referred to as such in SZC__c.  ConstantsUtil.getSizeDesc will give you all of the SizeCode's description; ComponentMasterBlaster__c has a SizeLL and a SizeUL column that I suspect are needed, but not mentioned by the documents
    public String rqrdComponents {get;set;}             //  String of required components for RuptureDisc__c.RequiredComponents__c multi-picklist; Use with VF page
    public List<SelectOption> optlComponents {get;set;} //  List of SelectOptions for RuptureDisc__c.OptionalComponents__c multi-picklist; Use with VF page
    public decimal sizeValue {get;set;}
    /** Constructor: Runs setComponentOptions after setting values*/
    public RDComponents(String PTC, String SZC,string STC, String DSCVAR,String MCD,decimal BMRCHECK,decimal TMRCHECK,String WITHSTANDRDCOMP,decimal RTTMDF,decimal pBrustPressure,String isFragmenting,string Atex,string Nace, Boolean SanitryStds3A) {
        RdCompList=new  List<RD_ComponentMBDetail__c>();
        prod = PTC;
        size =SZC;
        strSTC=STC;
        dsc = DSCVAR;
        sizeValue=ConstantsUtil.getSizeDesc(SZC).SizeValue;
        mapMatOptions=new map<string,List<SelectOption>>();
        decBMRCHECK=BMRCHECK;
        strWITHSTANDRDCOMP=WITHSTANDRDCOMP;
        decRTTMDF=RTTMDF;
        strMCD=MCD;
        strAtex=Atex;
        strNace=Nace;
        bool3ASanitaryStds = SanitryStds3A;//Service Ticket #205427
        mapMatlCodewithMatl=getMaterialNames();
        mapAttr= new map<string,string>();
        mapAttr.put('PTC',prod);
        mapAttr.put('SZC',ConstantsUtil.getSizeDesc(SZC).SZC);
        mapAttr.put('STC',strSTC);
        mapAttr.put('DSCVAR',dsc);
        mapAttr.put('BMRCHECK',String.ValueOf(BMRCHECK));
        mapAttr.put('TMRCHECK',String.ValueOf(TMRCHECK));
        mapAttr.put('SizeVal',String.ValueOf(sizeValue));
        // System.debug('RG3DRTii: ' + RG3DRT);
        // System.debug('DSCVARiii: ' + DSCVAR);
        mapAttr.put('MCD',strMCD);
        mapAttr.put('WITHSTANDRDCOMP',strWITHSTANDRDCOMP);
        System.debug('mapAttr: ' + mapAttr);
        rdCompMaterialName=getMaterials(PTC,DSCVAR,sizeValue,RTTMDF);
        rdSealCompMaaterials=getSealMAterials(PTC,strSTC,ConstantsUtil.getSizeDesc(SZC).SZC,RTTMDF,pBrustPressure,isFragmenting);
        setComponentOptions();
        initialized = true;
        System.debug('rdCompMaterialName: ' + rdCompMaterialName);
        System.debug('rdSealCompMaaterials: ' + rdSealCompMaaterials);
    }
    public RDComponents() {
        mapMatlCodewithMatl=getMaterialNames();
        //rdRecord=rdRec;
        // sizeValue=ConstantsUtil.getSizeDesc(rdRec.Size__c).SizeValue;
        // mapAttr= new map<string,string>();
        // mapAttr.put('PTC',rdRec.Product__c);
        // mapAttr.put('SZC',ConstantsUtil.getSizeDesc(rdRec.Size__c).SZC);
        // mapAttr.put('STC',rdRec.Seat__c);
        // mapAttr.put('DSCVAR',rdRec.DSCVAR__c);
        // mapAttr.put('RG3DRT',rdRec.RG3DRT__c);
        // mapAttr.put('MCD',rdRec.MCD__c);
        // mapAttr.put('SizeVal',String.ValueOf(sizeValue));
    }
    public Rupture_Disc__c rdRecord {get;set;}
    public String cmbWhereCriteria = '';  //  Holds previously run selection criteria for ComponentMasterBlater__c (if the user makes a change that does not change selection criteria, then we do not query again below)
    /** Method: Query to the ComponentMasterBlaster__c sObject; Based on PTC and DSCVAR; If neither of these change when the user selects another product option, we don't re-select the component options */
    public void setComponentOptions() {
        List<String> rqrdCmpList = new List<String>();  //  List of required components; Joined into a string for saving with Rupture Disc (multipick format: "value;value;value")
        optlComponents = new List<SelectOption>();      //  List of optional components in SelectOption format
        Boolean runQuery = false;
        //  Tells system whether or not to run the query to ComponentMasterBlaster__c
        optComps='';
        reqComps='';

        //String whereCriteria = 'PTC__C=\'' + prod + '\' AND DSCVAR__C=\'' + dsc + '\'';   //  TODO: Add Size(?); Holds selection criteria for query
        reqComponents=new List<String>();
        optComponents=new List<String>();
        runQuery = String.isNotBlank(prod) && String.isNotBlank(dsc);
        try {
            if(runQuery) {
                String strCompDetailObjName='RD_ComponentMBDetail__c';
                Map<String, Schema.SObjectField> objectConfigFields = Schema.getGlobalDescribe().get(strCompDetailObjName).getDescribe().fields.getMap();
                Set<String> ConfigFieldNames = objectConfigFields.keySet();
                List <String> selectCols=new List <String>();
                for(String str:ConfigFieldNames) {
                    if(str.endsWith('__c'))
                    selectCols.add(str);
                }
                System.debug('mapAttr'+mapAttr);
                Result RDCompDetails=wizardBaseDataProcessor.getDataFromTranslationObj('Type__c','RD_ComponentMBTranslation__c','RD_ComponentMBDetail__c',mapAttr,selectCols);
                // cmbWhereCriteria = whereCriteria;
                // ComponentMasterBlaster__c cmbRecord = Database.query(
                //     'SELECT ' + ConstantsUtil.join(cmpntMstrBlstrFields, ',') +
                //     ' FROM ComponentMasterBlaster__c WHERE ' +
                //     whereCriteria +
                //     ' LIMIT 1'
                // );
                if(RDCompDetails.bResult) {
                    Set<String> setRequriedComps = new Set<String>();
                    Set<String> setOptionalComps = new Set<String>();
                    // Integer intCount = 0;
                    // System.debug('intCount'+intCount);
                    // if(intCount < 10){
                        System.debug('RDCompDetails.objResultList'+RDCompDetails.objResultList);


                    for (sObject sObj:RDCompDetails.objResultList) {

                        // System.debug('Dynamic Query Where Clause'+whereCriteria);
                        Map<String,Object> cmbRcrdFldValMap = sObj.getPopulatedFieldsAsMap();
                        String strType=(string) sObj.get('Type__c');
                        if(strType=='A') {
                            RdCompList.add((RD_ComponentMBDetail__c) sObj);
                        }
                        for(String fieldName : cmbRcrdFldValMap.keySet())
                        {
                            // System.debug('fieldName: ' + fieldName);
                            String key = fieldName.replace('__c','').replace('_', ' '); //  Change Field API name from "Field_API_Name__c" to "Field API Name"
                            // System.debug('key: ' + key);
                            String value = String.valueOf(sObj.get(fieldName));    //  Get value of field to determine whether it is Required, Optional, or Not Applicable
                            // System.debug('value: ' + value);
                            //  IF the field is not a valid component option, skip it
                            // if(!ConstantsUtil.isValidComponentOption(key)) {
                            //     continue;
                            // }
                            //  IF the field has a value of 'Required', add it to the required list
                            //   ELSE IF the field has a value of 'Yes', add it to the optional list (enabled)
                            //   ELSE the field has a value of 'No', add it to the optional list (disabled)
                            if(value == 'Required') {
                                rqrdCmpList.add(key);
                                // System.debug('Required '+key);
                                // System.debug('Required Filed name'+mapComponents.get(key));
                                if (setRequriedComps.add(mapComponents.get(key))) {
                                    // System.debug('Required '+key+ 'Added');
                                    reqComponents.add(mapComponents.get(key));
                                    reqComps=reqComps+mapComponents.get(key);
                                    mapMatOptions.put(key,getOptions(mapComponentsMaterials.get(key)));
                                }

                            } else if(value == 'Optional') {
                                System.debug('Optional '+key);

                                if (setOptionalComps.add(mapComponents.get(key))) {
                                    optComponents.add(mapComponents.get(key));
                                    optComps=optComps+mapComponents.get(key);
                                    mapMatOptions.put(key,getOptions(mapComponentsMaterials.get(key)));
                                    // optlComponents.add(
                                    //     new SelectOption(
                                    //         key,
                                    //         key,
                                    //         false //isDisabled
                                    //     )
                                    // );
                                }
                            } else {
                                System.debug('Not Optional '+key);
                                // optlComponents.add(
                                //     new SelectOption(
                                //         key,
                                //         key,
                                //         true
                                //     )
                                // );
                            }
                        }
                    }

                }
                System.debug('Required Components'+reqComps);
                System.debug('Optional Components'+optComps);
                System.debug('mapMatOptions: ' + mapMatOptions);
                //  IF there are required components, add them to the final required component string
                if(!rqrdCmpList.isEmpty()) {
                    //rqrdComponents = ConstantsUtil.join(rqrdCmpList, ';');
                }
            }
        } catch(QueryException qe) {
            // System.debug('No records found for : ' + whereCriteria);
        }
    }
        //TODO: Check if we should make these RuptureDisc__c Constraint Rules
    public List<ApexPages.Message> runConstraints() {
        List<ApexPages.Message> messages = new List<ApexPages.Message>();
        // if (reqComps.contains('Material_Vacuum_Support__c') && )
        return messages;
    }
    public List<SelectOption> getOptions(string strComp) {
        List<SelectOption> opts=new List<SelectOption>();
        System.debug('rdSealCompMaaterials : --> getOptions Method --> '+rdSealCompMaaterials);
        opts.add(new SelectOption('',''));
        if (strComp=='Seal') {
            for (RD_Seals_Component_Materials__c sealMat:rdSealCompMaaterials) {
                String key = sealMat.MatlCode__c;
                switch on key.length() {
                    when 1 {
                        key = '0' + key;
                    }
                }
                if (mapMatlCodewithMatl.containsKey(key)) {
                    opts.add(new SelectOption(key,mapMatlCodewithMatl.get(key)));
                } else {
                    opts.add(new SelectOption(key,key));
                }
            }
            System.debug('opts : --> getOptions Method --> '+opts);
            return opts;
        }
        for (RD_Disc_Comp_Mat_Cd__c discMat : rdCompMaterialName) {
            if (discMat.Component__c==strComp) {
                String key = discMat.MatlCode__c;
                switch on key.length() {
                    when 1 {
                        key = '0' + key;
                    }
                }
                if (mapMatlCodewithMatl.containsKey(key)) {
                    opts.add(new SelectOption(key,mapMatlCodewithMatl.get(key)));
                } else {
                    opts.add(new SelectOption(key,key));
                }

            }

        }
        return opts;
    }
    public void checkTypeB(string strMCD,decimal decBMRCHECK) {

        Map<String,String> mapAttributes=new Map<String,String>();
        mapAttributes.put('PTC', mapAttr.get('PTC'));
        mapAttributes.put('DSCVAR',  mapAttr.get('DSCVAR'));
        mapAttributes.put('SZC',  mapAttr.get('SZC'));
        mapAttributes.put('WITHSTANDRDCOMP',  mapAttr.get('WITHSTANDRDCOMP'));
        mapAttributes.put('MCD',  strMCD);
        mapAttributes.put('BMRCHECK', decBMRCHECK+'');
        String strCompDetailObjName='RD_ComponentMBDetail__c';
        Map<String, Schema.SObjectField> objectConfigFields = Schema.getGlobalDescribe().get(strCompDetailObjName).getDescribe().fields.getMap();
        Set<String> ConfigFieldNames = objectConfigFields.keySet();
        List <String> selectCols=new List <String>();
        for(String str:ConfigFieldNames) {
            if(str.endsWith('__c'))
            selectCols.add(str);
        }
        List<String> listFieldName = new List<String>{'MCVS3__c','MCVS1__c','MCVS2__c'};
        Result RDCompDetails=wizardBaseDataProcessor.getDataFromTranslationObj('Type__c','RD_ComponentMBTranslation__c','RD_ComponentMBDetail__c',mapAttributes,selectCols);
        Map<string,Boolean> isRequired=new Map<string,Boolean>{
            'MCVS3'=>false,
            'MCVS2'=>false,
            'MCVS1'=>false
        };
        if(RDCompDetails.bResult) {
            system.debug('RDCompDetails'+RDCompDetails.objResultList);
            if(RDCompDetails.objResultList.size()>0) {
                isRequired.clear();
                isRequired.put('MCVS3', true);
                isRequired.put('MCVS2', true);
                isRequired.put('MCVS1', true);
            }
            integer cnt=1;
            for (sObject sObj:RDCompDetails.objResultList) {
                String strType=(string) sObj.get('Type__c');
                if(strType=='B') {
                    if(cnt==1) {
                        reqComps='';
                        optComps='';
                        reqComponents.clear();
                        optComponents.clear();
                    }
                    Map<String,Object> cmbRcrdFldValMap = sObj.getPopulatedFieldsAsMap();
                    Set<String> setRequriedComps = new Set<String>();
                    Set<String> setOptionalComps = new Set<String>();
                    List<String> rqrdCmpList = new List<String>();
                    for(String fieldName : cmbRcrdFldValMap.keySet())
                    {
                        String key = fieldName.replace('__c','').replace('_', ' '); //  Change Field API name from
                        String value1 = String.valueOf(sObj.get(fieldName));

                        if(value1 == 'Required') {
                            rqrdCmpList.add(key);
                            // System.debug('Required '+key);
                            // System.debug('Required Filed name'+mapComponents.get(key));
                            if (setRequriedComps.add(mapComponents.get(key))) {
                                reqComponents.add(mapComponents.get(key));
                                reqComps=reqComps+mapComponents.get(key);
                                mapMatOptions.put(key,getOptions(mapComponentsMaterials.get(key)));
                            }

                        } else if(value1 == 'Optional') {
                            if (setOptionalComps.add(mapComponents.get(key))) {
                                optComponents.add(mapComponents.get(key));
                                optComps=optComps+mapComponents.get(key);
                                mapMatOptions.put(key,getOptions(mapComponentsMaterials.get(key)));
                            }
                        }
                        if(listFieldName.contains(fieldName)) {
                            if(value1 == 'Required') {
                                System.debug('Conatains KEyssss-->'+key);
                                if(isRequired.containsKey(key)) {
                                    //System.debug('Conatains KEyssss-->'+key);
                                    if(!isRequired.get(key)) {
                                        isRequired.remove(key);
                                        isRequired.put(key, false);
                                    }
                                }
                            } else {
                                isRequired.remove(key);
                                isRequired.put(key, false);
                            }
                        }
                    }
                    // for (String fName : listFieldName) {
                    //     String key = fName.replace('__c','').replace('_', ' '); //  Change Field API name from
                    //     String value = String.valueOf(sObj.get(fName));
                    //     if(value == 'Required') {
                    //         System.debug('Conatains KEyssss-->'+key);
                    //         if(isRequired.containsKey(key)) {
                    //             //System.debug('Conatains KEyssss-->'+key);
                    //             if(!isRequired.get(key)) {
                    //                 isRequired.remove(key);
                    //                 isRequired.put(key, false);
                    //             }
                    //         }
                    //     } else {
                    //         isRequired.remove(key);
                    //         isRequired.put(key, false);
                    //     }
                    // }
                    cnt++;
                }
            }
            //System.debug('ISSSSSSSSSSSSSOPTIONAL'+isRequired);
            System.debug('ISSSSSSSSSSSSSOPTIONAL optComps'+optComps);
            // Map<string,string> mapMatlCodewithMatl2=cmpWrap.getMaterialNames();
            // for (RD_Disc_Comp_Mat_Cd__c discMat : getMaterials(PTC,DSCVAR,sizeValue,RTTMDF)) {
            //     if (discMat.Component__c==strComp) {
            //         String key = discMat.MatlCode__c;
            //         switch on key.length() {
            //             when 1 {
            //                 key = '0' + key;
            //             }
            //         }
            //         if (mapMatlCodewithMatl2.containsKey(key)) {
            //             opts.add(new SelectOption(key,mapMatlCodewithMatl2.get(key)));
            //         } else {
            //             opts.add(new SelectOption(key,key));
            //         }
            //     }
            // }
            System.debug('ISSSSSSSSSSSSSREQUIED'+isRequired);
            System.debug('ISSSSSSSSSSSSSREQUIED reqComps'+reqComps);
            for(String key1:isRequired.keySet()) {
                System.debug('ISSSSSSSSSSSSSREQUIED isRequired.get(key1)'+isRequired.get(key1)+'-------->'+key1);
                if(isRequired.get(key1)){
                    If(reqComps.contains(mapComponents.get(key1))) {
                        reqComps=reqComps+mapComponents.get(key1);
                        mapMatOptions.put(key1,getOptions(mapComponentsMaterials.get(key1)));
                        optComps=optComps.replace(mapComponents.get(key1), '');
                    }
                } else {
                    System.debug('ISSSSSSSSSSSSSREQUIED2 ----reqComps'+reqComps);
                    System.debug('ISSSSSSSSSSSSSREQUIED2 ----key1'+mapComponents.get(key1));
                    If(reqComps.contains(mapComponents.get(key1))) {
                        System.debug('ISSSSSSSSSSSSSREQUIED3 ----reqComps'+reqComps);
                        reqComps=reqComps.replace(mapComponents.get(key1), '');
                       // reqComps=reqComps+mapComponents.get(key1);
                    }
                }
            }
            System.debug('ISSSSSSSSSSSSSREQUIED2 reqComps'+reqComps);
            System.debug('ISSSSSSSSSSSSSOPTIONAL22 optComps'+optComps);
        }
        //return opts;
    }
    public List<RD_Seals_Component_Materials__c> getSealMAterials(String strPTC,String strSTC,string strSZC,decimal RTTMDF,decimal decPressure,String isFrag) {
        List<RD_Seals_Component_Materials__c> sealList = new List<RD_Seals_Component_Materials__c>();
        System.debug('isFrag in getSealMAterials --> '+isFrag);
        String strQuery = 'Select id,MatlCode__c from RD_Seals_Component_Materials__c where PTC__c=\''+strPTC+'\' and STC__c=\''+strSTC+'\' and SZC__c=\''+strSZC+'\' AND SealUpperTemp__c>='+RTTMDF+' AND PressLL__c<='+decPressure+' and PressUL__c>='+decPressure;
        if(isFrag == 'Yes')
            strQuery+=' AND Non_Fragmenting__c=\''+isFrag+'\'';
        if(strAtex=='Yes')
            strQuery+=' AND ATEX__c=\''+strAtex+'\'';
        if(strNace=='Yes')
            strQuery+=' AND NACE__c=\''+strNace+'\'';
        System.debug('Dynamic Query'+strQuery);
        sealList=Database.query(strQuery);
        System.debug('sealList'+sealList);
        return sealList;
    }
    public List<RD_Disc_Comp_Mat_Cd__c> getMaterials(String strPTC,String strDSCVAR,decimal Size,decimal RTTMDF) {
        List<RD_Disc_Comp_Mat_Cd__c> matList = new List<RD_Disc_Comp_Mat_Cd__c>();
        // System.debug('strPTC: ' + strPTC);+' AND Non_Fragmenting__c=\''+isFrag+'\''
        // System.debug('strDSCVAR: ' + strDSCVAR);
        // System.debug('RTTMDF: ' + RTTMDF);
       // System.debug('strSize: ' + strSize);
        //string sz=integer.valueOf(strSize)+'';
        String strQuery='Select id,Component__c,MatlCode__c from RD_Disc_Comp_Mat_Cd__c where PTC__c=\''+strPTC+'\' and DSCVAR__c=\''+strDSCVAR+'\' and SizeLL__c<='+Size+' and SizeUL__c>='+Size+' AND TempLL__c<='+RTTMDF+' AND TempUL__c>='+RTTMDF;
        if(strAtex=='Yes')
            strQuery+=' AND ATEX__c=\''+strAtex+'\'';
        if(strNace=='Yes')
            strQuery+=' AND NACE__c=\''+strNace+'\'';
        //Service Ticket #205427, added parameter for 3A Sanitary Stds
        if(bool3ASanitaryStds == null || bool3ASanitaryStds == false){
            strQuery+=' AND D3ASRV__c=\'N\'';
        }else if(bool3ASanitaryStds == true){
            strQuery+=' AND D3ASRV__c=\'Y\'';
        }
        System.debug('RD Component strQuery' +strQuery);
        matList=Database.query(strQuery);
        // System.debug('matList: ' + Size);
        // System.debug('matList: ' + RTTMDF);
        // System.debug('matList: ' + strDSCVAR);

        // System.debug('matList List: ' + matList);
        // System.debug('matList Size: ' + matList.size());
        return matList;
    }
    public Map<string,string> getMaterialNames() {
        map<String, string> mapMat = new map<String, string>();
        for(RD_GeneralMaterialsList__c objCS :[select MatlCode__c,Matl__c,TagMatlDesc__c from RD_GeneralMaterialsList__c] ) {
            String finalMTCD;
            if(objCS.MatlCode__c.length()!=3) {
                finalMTCD = '0'+objCS.MatlCode__c;
            } else {
                finalMTCD=objCS.MatlCode__c;
            }
            if(!mapMat.containsKey(finalMTCD)) {
                // if(key1=='OB')
                mapMat.put(finalMTCD, objCS.Matl__c);
                // else if(key1=='LABMAT')
                //     mapMat.put(finalMTCD, objCS.TagMatlDesc__c);
            }
        }
        return mapMat;
    }
    //public mapMatVals
}