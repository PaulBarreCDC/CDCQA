/**
* @File Name          : RdOutputBaseUtility.cls
* @Description        :
* @Author             : ApexIT - SFDC Dev Team
* @Group              :
* @Last Modified By   : Nikhil Arpally
* @Last Modified On   : 11-02-2020
* @Modification Log   :
* Ver       Date            Author                  Modification
* 1.0    13/5/2020     ApexIT - SFDC Dev Team     Initial Version
* 1.1    09/03/2021    Rohini Hathi               Service Ticket #200977 
* 1.2    09/04/2021    Vivek Pandey               Service Ticket #200477
* 1.3    06/05/2021    Rohini Hathi               Service Ticket #204282, handle null in GTAG10
* 1.4    12/05/2021    Rohini Hathi               Service Ticket #204266, BDI Interface cable, when not selected  
* 1.5    08/06/2021    Rohini Hathi               Service Ticket #203408, Option Code not Populating, qry correction for PNO generation and to display on TS tab
* 1.6    13/08/2021    Rohini Hathi               Service Ticket #207974 , RD: IntegrX Description update, add extra space and letter N- if InletConnection is N then dont print that value,
**/
public class RdOutputBaseUtility {

    public RdOutputBaseUtility (Id recordID) {
        currentRD= (Rupture_Disc__c) wizardBaseDataProcessor.getObjectDataById(recordID).objResultList[0];
        ifsList=[select Element__c,Attribute_Code__c from IFS_character_codes__c where Interface_to_IFS_Attributes__c=true and Product__c='RD'];
        RD_Outputs__c[] rdOutputList=[Select Base_Lead_Time_GP__c,Base_Lead_Time_GCI__c,Base_Lead_Time_CDC__c,Base_Lead_Time_40__c,Adder_Lead_Time_GP__c,
                                      Adder_Lead_Time_GCI__c,Adder_Lead_Time_CDC__c,Adder_Lead_Time_40__c,Comp_Lead_Time_GP__c,Comp_Lead_Time_GCI__c,
                                      Comp_Lead_Time_CDC__c,Comp_Lead_Time_40__c,Total_Lead_Time_CDC__c,Total_Lead_Time_GP__c,Total_Lead_Time_GCI__c,
                                      Total_Lead_Time_GP_ORD__c,Total_Lead_Time_40__c,OW__c,OW_Override__c,OA__c,OA_Override__c,OB__c,OB_Override__c,
                                      ORP__c,ORP_Override__c,ORV__c,ORV_Override__c,Total_Lead_Time_CDC_ORD__c,Total_Lead_Time_GCI_ORD__c,LABMAT__c,
                                      LABDSC__c,Total_Lead_Time_40_ORD__c,ORP010__c,ORP015__c,ORP027__c,ORV010__c,ORV015__c,ORV027__c,ORV020__c,ORP020__c,ORP025__c,ORV025__c,
                                      SRV__c ,SRP__c
                                      FROM RD_Outputs__c WHERE RD_Outputs_Relation_Field__c=:currentRD.Id];
        System.debug('RD_Outputs__c: ' + rdOutputList);
        //rdOutlist=new List<RD_Outputs__c>();
        rdOutputs=new RD_Outputs__c();
        if(rdOutputList.size()>0)
            rdOutputs=rdOutputList[0];


        List<RD_Drawings__c> rdDiagramList1=[select Drawing_Number__c,Drawing_ID__c,Drawing_Info__c,Drawing_ID_Override__c,Dim_A__c,Dim_A_Override__c,Dim_B__c,Dim_B_Override__c,Dim_C__c,Dim_C_Override__c,Dim_D__c,Dim_D_Override__c,Dim_E__c,Dim_E_Override__c,Dim_F__c,Dim_F_Override__c,IINO_Drawing_Number__c from  RD_Drawings__c where Rupture_Disc__c=:currentRD.id];
        rdDiagram=new RD_Drawings__c();
        if(rdDiagramList1.size()>0)
            rdDiagram=rdDiagramList1[0];

        RD_QuotLineValues=RD_QuotLineValues();
        RDMasterBlaster=RDMasterBlaster();
        RD_tblASMEValues=RD_tblASMEValues();
        RDOptnCode=RDOptionCode();
        RDTestCode=RDTstCd();
        rdPosLst= rdPosBaseList();
        mapRD_SourceCode=mapSrcCd();
        rdDscInfoLst=rdDisInfoList();
        mapRDAttr=getMapDetails();
        mapRD_Material=getMaterials('OB');
        mapRD_LABMAT=getMaterials('LABMAT');
        result resEval=getEvaluation();
        result resLkAttr=getLookupAttributes();
        mapInterfaceAttr=getInterfaceAttr();
        sealCompMaterials=getSealData();
        Composite=[select Composite__c from Disc_Type_List__c where PTC__c=:PTC][0].Composite__c;
        // MasterCapHt=
        if(HCLASS!=null)
            bsList=baseRDHLDList();
        string strMasterCapHt;
        if((PTC=='FFA')||(PTC=='LFA')||(PTC=='FFV')||(PTC=='LFV')||(PTC=='VPC')||(PTC=='VPR')||(PTC=='VPS')||(PTC=='STD')
           ||(PTC=='SFC')||(PTC=='LSD')||(PTC=='LSS')||(PTC=='LST')||(PTC=='STT')||(PTC=='WMP'))
        {
            RD_tblCompCapHtSTD__c[] rdCapHt1=[select CapHeight__c from RD_tblCompCapHtSTD__c where SizeLL__c<=:SizeValue and SizeUL__c>:SizeValue and DiscMatlCode__c=:MCDD  and ThckLL__c<=:DiscThick and ThckUL__c>:DiscThick];
            if(rdCapHt1.size()>0)
                strMasterCapHt=rdCapHt1[0].CapHeight__c;

        }
        else
        {
            RD_tblCompCapHt__c[] rdCapHt=[select CapHt__c from RD_tblCompCapHt__c where PTC__c=:PTC and DSCVAR__c=:DSCVAR and SizeLL__c<:SizeValue and SizeUL__c>=:SizeValue];
            if(rdCapHt.size()>0)
                strMasterCapHt=rdCapHt[0].CapHt__c;
        }
        if(strMasterCapHt!=null)
            MasterCapHt=strMasterCapHt;
        else
            MasterCapHt='N';
        // added by Robert on 12/14 to provide a way for Rhen to see CapHt on troubleshooting tab
        mapRDAttr.put('CAPHT',MasterCapHt);

    }
    public list<RD_Seals_Component_Materials__c> sealCompMaterials {get;set;}
    public Map<string,string> mapRDAttr{set;get;}
    public Map<string,string> mapInterfaceAttr{set;get;}
    public List<IFS_character_codes__c> ifsList{set;get;}
    //  public RD_Output_Attributes RdOA {get;set;}
    public RD_Outputs__c rdOutputs {get;set;}
    public RD_Drawings__c rdDiagram {get;set;}
    public Rupture_Disc__c currentRD{get; set;}
    //  public RDRatingRange rtgRngWrap {get; set;}
    // public RDThicknessFormulae rdThickness{get;set;}
    public Map<string,string> getMapDetails() {
        Map<String, string> myMap1 = new Map<String, string>();
        myMap1.put('PMI',PMI);
        myMap1.put('RTPRS1',currentRD.Pressure_Setting__c==null?'':currentRD.Pressure_Setting__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('RTPRSU',RTPRSU==null?'':RTPRSU);
        myMap1.put('OA',rdOutputs.OA_Override__c==null?'':rdOutputs.OA_Override__c);
        myMap1.put('OB',rdOutputs.OB_Override__c==null?'':rdOutputs.OB_Override__c);
        myMap1.put('OW',rdOutputs.OW_Override__c==null?'':rdOutputs.OW_Override__c);
        myMap1.put('ORP',rdOutputs.ORP_Override__c==null?'':rdOutputs.ORP_Override__c);
        myMap1.put('ORV',rdOutputs.ORV_Override__c==null?'':rdOutputs.ORV_Override__c);
        myMap1.put('ORP010',rdOutputs.ORP010__c==null?'':rdOutputs.ORP010__c);
        myMap1.put('ORP020',rdOutputs.ORP020__c==null?'':rdOutputs.ORP020__c);
        myMap1.put('ORP015',rdOutputs.ORP015__c==null?'':rdOutputs.ORP015__c);
        myMap1.put('ORP025',rdOutputs.ORP025__c==null?'':rdOutputs.ORP025__c);
        myMap1.put('ORP027',rdOutputs.ORP027__c==null?'':rdOutputs.ORP027__c);
        myMap1.put('ORV010',rdOutputs.ORV010__c==null?'':rdOutputs.ORV010__c);
        myMap1.put('ORV020',rdOutputs.ORV020__c==null?'':rdOutputs.ORV020__c);
        myMap1.put('ORV015',rdOutputs.ORV015__c==null?'':rdOutputs.ORV015__c);
        myMap1.put('ORV025',rdOutputs.ORV025__c==null?'':rdOutputs.ORV025__c);
        myMap1.put('ORV027',rdOutputs.ORV027__c==null?'':rdOutputs.ORV027__c);
        myMap1.put('GTAG02',rdOutputs.ORP010__c==null?'':rdOutputs.ORP010__c);
        myMap1.put('GTAG03',rdOutputs.ORP015__c==null?'':rdOutputs.ORP015__c);
        myMap1.put('GTAG04',rdOutputs.ORP027__c==null?'':rdOutputs.ORP027__c);
        myMap1.put('GTAG05',rdOutputs.ORV010__c==null?'':rdOutputs.ORV010__c);
        myMap1.put('GTAG06',rdOutputs.ORV015__c==null?'':rdOutputs.ORV015__c);
        myMap1.put('GTAG07',rdOutputs.ORV027__c==null?'':rdOutputs.ORV027__c);
        myMap1.put('GTAG09',GTAG09);
        myMap1.put('SRV',(rdOutputs.SRV__c==null||currentRD.Relief_Type__c=='Pressure Relief')?'':rdOutputs.SRV__c);
        myMap1.put('SRP',rdOutputs.SRP__c==null?'':rdOutputs.SRP__c);
        myMap1.put('VGRATU',VGRATU==null?'':VGRATU);
        myMap1.put('VGRATW',VGRATW==null?'':VGRATW.stripTrailingZeros().toPlainString()+'');
        myMap1.put('VTPRS1',currentRD.Vacuum_Setting__c==null?'':currentRD.Vacuum_Setting__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('ZONE',currentRD.Zone_0_2__c==null?'':currentRD.Zone_0_2__c);
        myMap1.put('BCL',currentRD.Cable_Length__c==null?'':currentRD.Cable_Length__c);
        myMap1.put('COIN',currentRD.Inlet_Option_Code__c==null?'':currentRD.Inlet_Option_Code__c);
        myMap1.put('COOUT',currentRD.Outlet_Option_Code__c==null?'':currentRD.Outlet_Option_Code__c);
        myMap1.put('GASGRP',GASGRP);
        myMap1.put('MetalSealThick',MetalSealThick+'');
        myMap1.put('HIC',HIC);
        myMap1.put('MCGR',MCGR);
        myMap1.put('MCIC',MCIC);
        myMap1.put('MCIR',MCIR);
        myMap1.put('MCSM',MCSM);
        myMap1.put('MCSS',MCSS);
        myMap1.put('MCVS',MCVS);
        myMap1.put('MCST',MCST);
        myMap1.put('RGRATW',RGRATW==null?'':RGRATW.stripTrailingZeros().toPlainString()+'');
        System.debug('rdOutputs.LABDSC__c :--- > '+rdOutputs.LABDSC__c);
        System.debug('rdOutputs.LABMAT__c :--- > '+rdOutputs.LABMAT__c);
        //  myMap1.put('OW',rdOutputs.OW_Override__c==null?'':rdOutputs.OW_Override__c);
        myMap1.put('LABDSC',rdOutputs.LABDSC__c==null?'':rdOutputs.LABDSC__c);
        myMap1.put('LABMAT',rdOutputs.LABMAT__c==null?'':rdOutputs.LABMAT__c);
        myMap1.put('DimA',rdDiagram.Dim_A_Override__c==null?'':rdDiagram.Dim_A_Override__c);
        myMap1.put('DimB',rdDiagram.Dim_B_Override__c==null?'':rdDiagram.Dim_B_Override__c);
        myMap1.put('DimC',rdDiagram.Dim_C_Override__c==null?'':rdDiagram.Dim_C_Override__c);
        myMap1.put('DimD',rdDiagram.Dim_D_Override__c==null?'':rdDiagram.Dim_D_Override__c);
        myMap1.put('DimE',rdDiagram.Dim_E_Override__c==null?'':rdDiagram.Dim_E_Override__c);
        myMap1.put('DimF',rdDiagram.Dim_F_Override__c==null?'':rdDiagram.Dim_F_Override__c);
        myMap1.put('DrawingID',rdDiagram.Drawing_ID__c==null?'':rdDiagram.Drawing_ID__c);
        myMap1.put('DWGNO',rdDiagram.Drawing_Number__c==null?'':rdDiagram.Drawing_Number__c);
        myMap1.put('IINO',rdDiagram.Drawing_Info__c==null?'':rdDiagram.Drawing_Info__c);
        myMap1.put('DPM',DPM);
        myMap1.put('TefSealThick',TefSealThick==null?'':+TefSealThick+'');
        myMap1.put('SeatDesc',SeatDesc);
        myMap1.put('SizeValue',SizeValue+'');
        myMap1.put('DERATE',DERATE==null?'':DERATE);
        myMap1.put('MCDERATE',MCDERATE==null?'':MCDERATE);
        myMap1.put('RGEUNT',PPressureBaseUOM==null?'':PPressureBaseUOM);
        myMap1.put('VGEUNT',VPressureBaseUOM==null?'':VPressureBaseUOM);
        //myMap1.put('ASSYLOCATION',ASSYLOCATION);
        myMap1.put('ASSYLOCATION',ASSYLOCATION==null?'':ASSYLOCATION);
        myMap1.put('ATEX',ATEX);
        myMap1.put('CSA',CSA);
        //myMap1.put('DERATE',DERATE);
        myMap1.put('HCLASS',HCLASS==null?'':HCLASS);
        myMap1.put('MATLSOURCE',MATLSOURCE);
        myMap1.put('RTTMDF',RTTMDF.stripTrailingZeros().toPlainString()+'');
        myMap1.put('PTC',PTC);
        myMap1.put('addIntegralBDI',addIntegralBDI);
        myMap1.put('SZC',strSZC);
        myMap1.put('ENTITY',ENTITY);
        //myMap1.put('THIRDT',THIRDT);
        myMap1.put('DSCVAR',DSCVAR);
        myMap1.put('BDISubAssyCheck',BDISubAssyCheck);
        myMap1.put('StripMatlCode',StripMatlCode);
        myMap1.put('STC',STC);
        myMap1.put('CompSTC',CompSTC);
        myMap1.put('HOC',HOC);
        myMap1.put('BCT',BCT);
        myMap1.put('PTC',PTC);
        myMap1.put('NACE',NACE);
        myMap1.put('ADMERK',ADMERK);
        myMap1.put('PMI',PMI);
        myMap1.put('addIntegralBDI',addIntegralBDI);
        myMap1.put('DSCVAR',DSCVAR);
        myMap1.put('RPVM084',RPVM084);
        myMap1.put('StripMatlCode',StripMatlCode);
        myMap1.put('BCT',BCT);
        myMap1.put('CSSUM',currentRD.Size_Units__c==null?'-':currentRD.Size_Units__c);
        //myMap1.put('PartSeat',PartSeat);
        myMap1.put('BEC',BEC);
        myMap1.put('OW040',OW040==null?'':OW040);
        myMap1.put('OW0403',OW0403==null?'':OW0403);
        myMap1.put('OW0405',OW0405==null?'':OW0405);
        myMap1.put('OW041',OW041==null?'':OW041);
        myMap1.put('OW042',OW042==null?'':OW042);
        myMap1.put('DiscTopThick',DiscTopThick+'');
        myMap1.put('PED',PED);
        myMap1.put('CEMARK',PED);
        myMap1.put('GASGROUP',GASGRP);
        myMap1.put('PBPMAX',currentRD.Press_Burst_Pressure_Max_Input__c==null? '':currentRD.Press_Burst_Pressure_Max_Input__c+'');
        myMap1.put('PBPMIN',currentRD.Press_Burst_Pressure_Min_Input__c==null? '':currentRD.Press_Burst_Pressure_Min_Input__c+'');
        myMap1.put('CHINAMFG',CHINAMFG);
        myMap1.put('CSA',CSA);
        myMap1.put('ATEX',ATEX);
        myMap1.put('ATEXZONE',ATEX);
        myMap1.put('KOSHA',KOSHA);
        myMap1.put('CUTR',CUTR);
        myMap1.put('SHELLTEST',SHELLTEST);
        myMap1.put('SURFINISH',SURFFINISH);
        myMap1.put('SURFFINISH',SURFFINISH);
        myMap1.put('ELECTROPOL',ELECTROPOL);
        myMap1.put('D3ASRV',D3ASRV);
        myMap1.put('INDPCK',INDPCK);
        myMap1.put('INDVDLPKG',INDPCK);
        myMap1.put('3A',D3ASRV);
        myMap1.put('CLEAN',CLEAN);
        myMap1.put('ASME',ASME);
        myMap1.put('MCGD',MCGD==null?'':MCGD);
        myMap1.put('TMPTSTASME',TMPTSTASME);
        myMap1.put('CSPECS',CSPECS);
        myMap1.put('MCBDIG',MCBDIG==null?'':MCBDIG);
        myMap1.put('MCBS',MCBS  ==null?'':MCBS);
        myMap1.put('MCAR',MCAR  ==null?'':MCAR);
        myMap1.put('MCDD',MCDD==null?'':MCDD);
        myMap1.put('MCDP',MCDP  ==null?'':MCDP);
        myMap1.put('MCDT1',MCDT1==null?'':MCDT1);
        myMap1.put('MCDT2',MCDT2==null?'':MCDT2);
        myMap1.put('MCGD',MCGD  ==null?'':MCGD);
        myMap1.put('MCGR1',MCGR1==null?'':MCGR1);
        myMap1.put('MCGR2',MCGR2==null?'':MCGR2);
        myMap1.put('MCHI',MCHI==null?'':MCHI);
        myMap1.put('MCHO',MCHO==null?'':MCHO);
        myMap1.put('MCHRNG',MCHRNG==null?'':MCHRNG);
        myMap1.put('MCHS',MCHS==null?'':MCHS);
        myMap1.put('MCHT',MCHT==null?'':MCHT);
        myMap1.put('MCIC1',MCIC1==null?'':MCIC1);
        myMap1.put('MCIC2',MCIC2==null?'':MCIC2);
        myMap1.put('MCIG',MCIG==null?'':MCIG);
        myMap1.put('MCIL',MCIL==null?'':MCIL);
        myMap1.put('MCIR1',MCIR1==null?'':MCIR1);
        myMap1.put('MCIR2',MCIR2==null?'':MCIR2);
        myMap1.put('MCIR3',MCIR3==null?'':MCIR3);
        myMap1.put('MCOC',MCOC==null?'':MCOC);
        myMap1.put('MCOG',MCOG==null?'':MCOG);
        myMap1.put('MCOL',MCOL==null?'':MCOL);
        myMap1.put('MCOR',MCOR==null?'':MCOR);
        myMap1.put('MCSS1',MCSS1==null?'':MCSS1);
        myMap1.put('MCSS2',MCSS2==null?'':MCSS2);
        myMap1.put('MCSS3',MCSS3==null?'':MCSS3);
        myMap1.put('MCTSOR',MCTSOR==null?'':MCTSOR);
        myMap1.put('MCVS1',MCVS1==null?'':MCVS1);
        myMap1.put('MCVS2',MCVS2==null?'':MCVS2);
        myMap1.put('MCVS3',MCVS3==null?'':MCVS3);
        myMap1.put('MCD',MCD==null?'':MCD);
        myMap1.put('Quantity',QTY+'');
        myMap1.put('PBurstPressConverted',PBurstPressureConverted==null?'':PBurstPressureConverted+'');
        myMap1.put('VACUUMWTHSTND',VACUUMWTHSTND);
        myMap1.put('POSWTHSTND',POSWTHSTND);
        myMap1.put('RG1MIN',currentRD.RG1MIN__c==null?'':currentRD.RG1MIN__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('RG1MAX',currentRD.RG1MAX__c==null?'':currentRD.RG1MAX__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('RG2MIN',currentRD.RG2MIN__c==null?'':currentRD.RG2MIN__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('RG2MAX',currentRD.RG2MAX__c==null?'':currentRD.RG2MAX__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('RG3MIN',currentRD.RG3MIN__c==null?'':currentRD.RG3MIN__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('RG3MAX',currentRD.RG3MAX__c==null?'':currentRD.RG3MAX__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('RGSMIN',currentRD.RGSMIN__c==null?'':currentRD.RGSMIN__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('RGSMAX',currentRD.RGSMAX__c==null?'':currentRD.RGSMAX__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('RGEMIN',currentRD.RGEMIN__c==null?'':currentRD.RGEMIN__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('RGEMAX',currentRD.RGEMAX__c==null?'':currentRD.RGEMAX__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('VG1MIN',currentRD.VG1MIN__c==null||currentRD.VG1MIN__c==0?'':currentRD.VG1MIN__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('VG1MAX',currentRD.VG1MAX__c==null||currentRD.VG1MAX__c==0?'':currentRD.VG1MAX__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('VG2MIN',currentRD.VG2MIN__c==null||currentRD.VG2MIN__c==0?'':currentRD.VG2MIN__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('VG2MAX',currentRD.VG2MAX__c==null||currentRD.VG2MAX__c==0?'':currentRD.VG2MAX__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('VG3MIN',currentRD.VG3MIN__c==null?'':currentRD.VG3MIN__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('VG3MAX',currentRD.VG3MAX__c==null?'':currentRD.VG3MAX__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('VGSMIN',currentRD.VGSMIN__c==null||currentRD.VGSMIN__c==0?'':currentRD.VGSMIN__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('VGSMAX',currentRD.VGSMAX__c==null?'':currentRD.VGSMAX__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('VGEMIN',currentRD.VGEMIN__c==null?'':currentRD.VGEMIN__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('VGEMAX',currentRD.VGEMAX__c==null?'':currentRD.VGEMAX__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('RG3DRT',currentRD.RG3DRT__c==null?'':currentRD.RG3DRT__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('VG3DRT',currentRD.VG3DRT__c==null?'':currentRD.VG3DRT__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('BACKPRESSINPUT',currentRD.Back_Pressure_Value__c==null?'':currentRD.Back_Pressure_Value__c.format()+'');
        myMap1.put('BACKPRESSUOM',currentRD.Back_Pressure_Units__c==null?'':currentRD.Back_Pressure_Units__c+'');
        myMap1.put('RGRATU',RGRATU==null?'':RGRATU+'');
        myMap1.put('RGTYP1',RGTYP1==null?'':RGTYP1+'');
        myMap1.put('RGRAT1',RGRAT1==null?'':RGRAT1+'');
        myMap1.put('RTTMSP',RTTMSP==null?'':RTTMSP.stripTrailingZeros().toPlainString()+'');
        myMap1.put('RTTMUN',RTTMUN==null?'':RTTMUN+'');

        myMap1.put('VTPRSU',VTPRSU==null?'':VTPRSU+'');
        myMap1.put('VGTYP1',VGTYP1==null?'':VGTYP1+'');
        myMap1.put('VGRAT1',VGRAT1==null?'':VGRAT1+'');
        myMap1.put('GTAG10',GTAG10==null?'':GTAG10+'');

        myMap1.put('VPTMAX',currentRD.Vac_Performance_Tolerance_Max_Input__c==null?'':currentRD.Vac_Performance_Tolerance_Max_Input__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('VPTMIN',currentRD.Vac_Performance_Tolerance_Min_Input__c==null?'':currentRD.Vac_Performance_Tolerance_Min_Input__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('VPTUOM',currentRD.Vac_Performance_Tolerance_Units__c);
        myMap1.put('VSRMAX',currentRD.Vac_Special_Range_Max_Input__c==null?'':currentRD.Vac_Special_Range_Max_Input__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('VSRMIN',currentRD.Vac_Special_Range_Min_Input__c==null?'':currentRD.Vac_Special_Range_Min_Input__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('PPTMAX',currentRD.Performance_Tolerance_Max_Input__c==null?'':currentRD.Performance_Tolerance_Max_Input__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('PPTMIN',currentRD.Performance_Tolerance_Min_Input__c==null?'':currentRD.Performance_Tolerance_Min_Input__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('PPTUOM',currentRD.Performance_Tolerance_Input_Units__c);
        myMap1.put('PSRMAX',currentRD.Special_Range_Max_Input__c==null?'':currentRD.Special_Range_Max_Input__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('PSRMIN',currentRD.Special_Range_Min_Input__c==null?'':currentRD.Special_Range_Min_Input__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('PSTRTR',currentRD.RG1MIN__c==null?'':currentRD.RG1MIN__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('PFULRL',currentRD.Pressure_Setting__c==null?'':currentRD.Pressure_Setting__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('VFULRL',currentRD.Vacuum_Setting__c==null?'':currentRD.Vacuum_Setting__c.stripTrailingZeros().toPlainString()+'');
        myMap1.put('VSTRTR',currentRD.VG1MIN__c==null||currentRD.VG1MIN__c==0?'':currentRD.VG1MIN__c.stripTrailingZeros().toPlainString()+'');
        //myMap1.put('BBT',SHELLTEST);
        //myMap1.put('BTC',SHELLTEST);
        myMap1.put('DHRTMX','');
        myMap1.put('CAPHT',MasterCapHt);
        myMap1.put('DISCOPT', (String.isBlank(DiscOpt) == true? '000': DiscOpt) ); //Service Ticket #203408, to display the DiscOption on troubleshooting tab

        // myMap1.put('VGEMIN',currentRD.VGEMIN__c==null?'':currentRD.VGEMIN__c.setScale(2)+'');
        // myMap1.put('VGEMAX',currentRD.VGEMAX__c==null?'':currentRD.VGEMAX__c.setScale(2)+'');
        // myMap1.put('RG3DRT',currentRD.RG3DRT__c==null?'':currentRD.RG3DRT__c.setScale(2)+'');
        // myMap1.put('VG3DRT',currentRD.VGEMAX__c==null?'':currentRD.VG3DRT__c.setScale(2)+'');
        //myMap1.put('Pa', arg1)
        // myMap1.put('RGRAT1',RGRAT1);
        // myMap1.put('VGRAT1',VGRAT1);
        decimal decBackPress=0;
        if (!String.IsBlank(currentRD.Vacuum_Withstand__c) && currentRD.Vacuum_Withstand__c!='No Requirements') {
            if (currentRD.Vacuum_Withstand__c=='Full Vacuum') {
                decBackPress=15;
            } else {
                decBackPress=currentRD.Converted_Back_Pressure_Value__c;
            }
        }
        myMap1.put('BACKPRESSCONV',decBackPress+'');
        myMap1.put('BACKPRESSCONVERTED',decBackPress+'');
        return myMap1;
    }
    public String PPressureBaseUOM {
        get {
            String uom;
            if(PTC =='PAS') {
                UOM = 'in. water';
            } else {
                UOM = 'psig';
            }
            return uom;
        }
        set;
    }
    public String RGRATU {
        get {
            if(currentRD.Positive_Pressure_Units__c != null)
            	return currentRD.Positive_Pressure_Units__c;
            else
                return null;
        }
        set;
    }
    public String VGRATU {
        get {
            if(currentRD.Back_Pressure_Units__c != null)
            	return currentRD.Back_Pressure_Units__c;
            else
            	return null;
        }
        set;
    }
    public String VPressureBaseUOM {
        get {
            String uom='';
            if(PTC =='CAL') {
                UOM = 'in. water';
            } else {
                UOM = 'psig';
            }
            return uom;
        }
        set;
    }
    public Map<String,String> getInterfaceAttr() {
        Map<String,String> iMap=new Map<String,String>();
        System.debug('ifsList: ' + ifsList);
        for (IFS_character_codes__c ifs:ifsList) {
            if (mapRDAttr.containsKey(ifs.Attribute_Code__c))
            {
                if(mapRDAttr.get(ifs.Attribute_Code__c)!=NULL)
                    iMap.put(ifs.Attribute_Code__c,mapRDAttr.get(ifs.Attribute_Code__c));
            } else {
                iMap.put(ifs.Attribute_Code__c,'');
            }
        }
        return iMap;
    }

    // public String RGRAT1 {
    //     get {
    //         if(currentRD.Pressure_Rating_Type__c!=null)
    //             return currentRD.Pressure_Rating_Type__c;
    //         else
    //             return '';
    //     }
    //     set {
    //         currentRD.Pressure_Rating_Type__c = value;
    //         this.RGRAT1 = value;
    //     }
    // }
    // public String VGRAT1 {
    //     get {
    //         if(currentRD.Vac_Rating_Type__c!=null)
    //             return currentRD.Vac_Rating_Type__c;
    //         else
    //             return '';
    //     }
    //     set {
    //         currentRD.Vac_Rating_Type__c = value;
    //         this.VGRAT1 = value;
    //     }
    // }

    public String RGTYP1 {
        get {
            return currentRD.Pressure_Range_Type__c;
        }
        set {
            currentRD.Pressure_Range_Type__c = value;
            this.RGTYP1 = value;
        }
    }
    public String VGTYP1 {
        get {
            return currentRD.Vac_Range_Type__c;
        }
        set {
            currentRD.Vac_Range_Type__c = value;
            this.VGTYP1 = value;
        }
    }
    public string VACUUMWTHSTND {
        get {
            return currentRD.Vacuum_Withstand__c==null?'':currentRD.Vacuum_Withstand__c;
        }
        set {
            this.VACUUMWTHSTND = value;
        }
    }
    public string POSWTHSTND {
        get {
            return currentRD.Pressure_Withstand__c==null?'':currentRD.Pressure_Withstand__c;
        }
        set {
            this.POSWTHSTND = value;
        }
    }
    public String RGRAT1 {
        get {
            if(currentRD.Pressure_Rating_Type__c!=null)
                return currentRD.Pressure_Rating_Type__c;
            else
                return '';
        }
        set {
            currentRD.Pressure_Rating_Type__c = value;
            this.RGRAT1 = value;
        }
    }
    public String VGRAT1 {
        get {
            if(currentRD.Vac_Rating_Type__c!=null)
                return currentRD.Vac_Rating_Type__c;
            else
                return '';
        }
        set {
            currentRD.Vac_Rating_Type__c = value;
            this.VGRAT1 = value;
        }
    }
    //XML Method
    /*
public Result getEngPartCharacterXML( )
{
result RDCharResult=new result();
// result CharResult=getEngPartCharacterXML();
IFS_character_codes__c[] IFS_Attr=[select Element__c,Attribute_Code__c from IFS_character_codes__c where Interface_to_IFS_Attributes__c=true and Product__c='RD'];
Dom.Document doc = new Dom.Document();
XmlStreamWriter w = new XmlStreamWriter();
w.writeStartElement(null, 'ENG_PART_CHAR_LIST', null);
for(IFS_character_codes__c ifsAtt:IFS_Attr) {
String strInfo=' ';
String strVal=' ';
String strCode;
system.debug('Map KEy '+ifsAtt.Attribute_Code__c);
system.debug('Map Contains '+RdOA.mapRDAttr.containsKey(ifsAtt.Attribute_Code__c));
system.debug('Map '+RdOA.mapRDAttr);
if (RdOA.mapRDAttr.containsKey(ifsAtt.Attribute_Code__c))
{
if (ifsAtt.Element__c=='Info')
{
strInfo=RdOA.mapRDAttr.get(ifsAtt.Attribute_Code__c);
}
else
{
strVal=RdOA.mapRDAttr.get(ifsAtt.Attribute_Code__c);
}
strCode=ifsAtt.Attribute_Code__c;
w.writeStartElement(null, 'ENG_PART_CHAR', null);
w.writeStartElement(null, 'CHAR_TEMPLATE', null);
w.writeCharacters(RdOA.CHAR_TEMPLATE);
w.writeEndElement();
w.writeStartElement(null, 'CHARACTERISTIC_CODE', null);
w.writeCharacters(strCode);
w.writeEndElement();
w.writeStartElement(null, 'VALUE', null);
w.writeCharacters(strVal);
w.writeEndElement();
w.writeStartElement(null, 'INFO', null);
w.writeCharacters(strInfo);
w.writeEndElement();
w.writeEndElement();
}
}
// if(CharResult.bResult)
//{
//for(sObject sobj:CharResult.objResultList)
//{

// }
//  }
w.writeEndElement();
//w.writeEndDocument();
string xmlOutput = w.getXmlString();
system.debug('XML is xmlOutput  '+xmlOutput );
w.close();
string xmldata = doc.toXmlString();
system.debug('XML is '+xmldata);
RDCharResult.xmlStringResult=xmlOutput;
return RDCharResult;
}
*/
    public decimal RTPRS1 {
        get {
            return currentRD.Pressure_Setting__c;
        }
        set {
            currentRD.Pressure_Setting__c = value;
            this.RTPRS1 = value;
        }
    }
    public String  RTPRSU {
        get {
            return currentRD.Pressure_Setting_Units__c;
        }
        set {
            currentRD.Pressure_Setting_Units__c = value;
            this.RTPRSU = value;
        }
    }

    public String  BDISubAssyCheck {
        get {
            return '-';
        }
        set {
            //currentRD.Pressure_Setting_Units__c = value;
            this.BDISubAssyCheck = value;
        }
    }

    public String  StripMatlCode {
        get {
            return currentRD.Strip_Type__c==null?'':currentRD.Strip_Type__c;
        }
        set {
            //currentRD.Pressure_Setting_Units__c = value;
            this.StripMatlCode = value;
        }
    }

    public ID QuoteLine {
        get {
            return currentRD.Quote_Line__c;
        }
        set {
            this.QuoteLine = value;
        }
    }
    public integer QTY {
        get {
            return integer.ValueOf(currentRD.Quantity__c);
        }
        set {
            this.QTY = value;
        }
    }


    public String RD_QuotLineValues {set;get;}
    public String RD_QuotLineValues() {
        RD_QuotLineValues = [Select SBQQ__Quote__r.Brand__c FROM SBQQ__QuoteLine__c WHERE ID =: QuoteLine].SBQQ__Quote__r.Brand__c;
        System.debug('QuoteLine Query'+RD_QuotLineValues);
        return RD_QuotLineValues;
    }

    public String  ENTITY {
        get {
            if(String.isNotBlank(RD_QuotLineValues)){
                return RD_QuotLineValues;
            }
            return '';
            // return [Select SBQQ__Quote__r.Brand__c
            //         from SBQQ__QuoteLine__c
            //         where ID =: QuoteLine
            //        ].SBQQ__Quote__r.Brand__c==null?'': [Select SBQQ__Quote__r.Brand__c
            //                                             from SBQQ__QuoteLine__c
            //                                             where ID =: QuoteLine
            //                                            ].SBQQ__Quote__r.Brand__c;
        }
        set {
            this.ENTITY = value;
        }
    }

    public String  Brand {
        get {
            if(String.isNotBlank(RD_QuotLineValues)){
                return RD_QuotLineValues;
            }
            return '';
            // return [Select SBQQ__Quote__r.Brand__c
            //         from SBQQ__QuoteLine__c
            //         where ID =: QuoteLine
            //        ].SBQQ__Quote__r.Brand__c==null?'': [Select SBQQ__Quote__r.Brand__c
            //                                             from SBQQ__QuoteLine__c
            //                                             where ID =: QuoteLine
            //                                            ].SBQQ__Quote__r.Brand__c;
        }
        set {
            this.Brand = value;
        }
    }

    // public String THIRDT {
    //     get {
    //         return 'T';
    //     }
    //     set {
    //         this.THIRDT = value;
    //     }
    // }

    public String CompSTC {
        get {
            return currentRD.Seat__c;
        }
        set {
            this.CompSTC = value;
        }
    }
    public decimal RGEMIN {
        get {
            return currentRD.RGEMIN__c==null?0:currentRD.RGEMIN__c;
        }
        set {
            this.RGEMIN = value;
        }
    }
    public decimal VG2MIN {
        get {
            return currentRD.VG2MIN__c==null?0:currentRD.VG2MIN__c;
        }
        set {
            this.VG2MIN = value;
        }
    }
    public decimal RG2MIN {
        get {
            return currentRD.RG2MIN__c==null?0:currentRD.RG2MIN__c;
        }
        set {
            this.RG2MIN = value;
        }
    }
    public decimal VGSMIN {
        get {
            return currentRD.VGSMIN__c==null?0:currentRD.VGSMIN__c;
        }
        set {
            this.VGSMIN = value;
        }
    }
    public decimal RGSMIN {
        get {
            return currentRD.RGSMIN__c==null?0:currentRD.RGSMIN__c;
        }
        set {
            this.RGSMIN = value;
        }
    }


    public string MasterCapHt {set;get;}
    public Decimal  PBurstPressureConverted {
        get {
            return currentRD.Converted_Pressure_Setting__c;
        }
        set {
            currentRD.Converted_Pressure_Setting__c = value;
            this.PBurstPressureConverted = value;
        }
    }

    public decimal  RTTMSP {
        get {
            return currentRD.Temperature_Setting__c;
        }
        set {
            currentRD.Temperature_Setting__c = value;
            this.RTTMSP = value;
        }
    }

    public String  RTTMUN {
        get {
            return currentRD.Temperature_Setting_Units__c;
        }
        set {
            currentRD.Temperature_Setting_Units__c = value;
            this.RTTMUN = value;
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

    public decimal  VTPRS1 {
        get {
            return currentRD.Vacuum_Setting__c;
        }
        set {
            currentRD.Vacuum_Setting__c = value;
            this.VTPRS1 = value;
        }
    }

    public String  VTPRSU {
        get {
            return currentRD.Vacuum_Setting_Units__c;
        }
        set {
            currentRD.Vacuum_Setting_Units__c = value;
            this.VTPRSU = value;
        }
    }

    public Decimal  VBurstPressureConverted {
        get {
            return currentRD.Converted_Vacuum_Setting__c;
        }
        set {
            currentRD.Converted_Vacuum_Setting__c = value;
            this.VBurstPressureConverted = value;
        }
    }

    public string DPM {
        get {
            return currentRD.Is_there_a_liquid_relief_scenario__c=='Yes'?'Y':'N';
        }
        set {
            currentRD.Is_there_a_liquid_relief_scenario__c = value;
            this.DPM = value;
        }

    }

    public String ASME {
        get {

            String strASME= currentRD.ASME_Section_VIII_Division_1__c==false?'N':'8';
            return strASME;
        }
        set {
            this.ASME =  value;
        }
    }

    public String  PED {
        get {
            return currentRD.PED_2014_68_EU_CE_mark__c=='NonePED'?'N':currentRD.PED_2014_68_EU_CE_mark__c;
        }
        set {
            //currentRD.PED_2014_68_EU_CE_mark__c = value;
            this.PED = value;
        }
    }

    public String  CHINAMFG {
        get {
            System.debug('currentRD.China_Manufacturing_License__c: - '+currentRD.China_Manufacturing_License__c);
            return (currentRD.China_Manufacturing_License__c==null||currentRD.China_Manufacturing_License__c=='NoneCML')?'N':currentRD.China_Manufacturing_License__c;
        }
        set {
            currentRD.China_Manufacturing_License__c = value;
            this.CHINAMFG = value;
        }
    }

    public String CSA {
        get {

            String strCSA= currentRD.CSA_Marking_CRN_Number__c==false?'N':'Y';
            return strCSA;
        }
        set {
            this.CSA =  value;
        }
    }

    public String ATEX {
        get {

            String strATEX= currentRD.Atex_Certificate__c==false?'N':'Y';
            return strATEX;
        }
        set {
            this.ATEX =  value;
        }
    }

    public String  GASGRP {
        get {
            return currentRD.Gas_Group__c==null?'':currentRD.Gas_Group__c;
        }
        set {
            currentRD.Gas_Group__c = value;
            this.GASGRP = value;
        }
    }

    public String  ZONE {
        get {
            return currentRD.Zone_0_2__c==null?'':currentRD.Zone_0_2__c;
        }
        set {
            currentRD.Zone_0_2__c = value;
            this.ZONE = value;
        }
    }

    public String  KOSHA {
        get {
            String strKOSHA= currentRD.KOSHA_Compliance__c==false?'N':'Y';
            return strKOSHA;
        }
        set {
            this.KOSHA =  value;
        }
    }

    public String  CUTR {
        get {

            String strCUTR= currentRD.CU_TR__c==false?'N':'Y';
            return strCUTR;
        }
        set {
            this.CUTR =  value;
        }
    }

    public String  D3ASRV {
        get {

            String strD3ASRV= currentRD.X3A_Sanitary_Standards__c?'Y':'N';
            return strD3ASRV;
        }
        set {
            this.D3ASRV =  value;
        }
    }

    public String  ADMERK {
        get {

            String strADMERK= currentRD.Comply_with_AD2000_Merkblat_A1__c==false?'N':'Y';
            return strADMERK;
        }
        set {
            this.ADMERK =  value;
        }
    }

    public String  RPVM084 {
        get {

            String strRPVM084= currentRD.Comply_with_Regels_Voor_Tosellan_Oder_Dr__c==false?'N':'Y';
            return strRPVM084;
        }
        set {
            this.RPVM084 =  value;
        }
    }

    public String NACE {
        get {
            return currentRD.NACE__c;
        }
        set {
            currentRD.NACE__c = value;
            this.NACE = value;
        }
    }

    public String strSZC {
        get {
            return ConstantsUtil.getSizeDesc(currentRD.Size__c+'').SZC;
        }
        set {
            //currentRD.Size__c = value;
            this.strSZC = value;
        }
    }

    public decimal decSZC {
        get {
            // decimal decsize=0.0;
            // string strsize='';
            // strsize=currentRD.Size__c;
            // decsize=decimal.valueOf(strsize);
            return (decimal) ConstantsUtil.getSizeDesc(currentRD.Size__c).SizeValue;
        }
        set {
            //currentRD.Size__c = String.valueOf(value);
            this.decSZC = value;
        }
    }

    public String CSSUM {
        get {
            return currentRD.Size_Units__c;
        }
        set {
            currentRD.Size_Units__c = value;
            this.CSSUM = value;
        }
    }

    public String PTC {
        get {
            return currentRD.Product__c;
        }
        set {
            currentRD.Product__c = value;
            this.PTC = value;
        }
    }

    public String SeatDesc {
        get {
            return ConstantsUtil.mapSTCDesc.get(currentRD.Seat__c);
        }
        set {
            //currentRD.Seat__c = value;
            this.SeatDesc = value;
        }
    }

    public String HCLASS {
        get {
            return currentRD.Pressure_Class__c;
            //return 'test';
        }
        set {
            currentRD.Pressure_Class__c = value;
            this.HCLASS = value;
        }
    }

    public String HIC {
        get {
            return currentRD.Inlet_Connection__c;
            //return 'test';
        }
        set {
            currentRD.Inlet_Connection__c = value;
            this.HIC = value;
        }
    }

    public String HOC {
        get {
            return currentRD.Outlet_Connection__c;
            //return 'test';
        }
        set {
            currentRD.Outlet_Connection__c = value;
            this.HOC = value;
        }
    }

    //Simha Getter Setter variables Starts from here

    public String MCHO {
        get {
            return currentRD.Material_Outlet__c;
        }
        set {
            currentRD.Material_Outlet__c = value;
            this.MCHO = value;
        }
    }
    public String MCHRNG {
        get {
            return currentRD.Material_Holddown_Ring__c;
        }
        set {
            currentRD.Material_Holddown_Ring__c = value;
            this.MCHRNG = value;
        }
    }
    public String MCAR {
        get {
            return currentRD.Material_Arcuate_Ring__c;
        }
        set {
            currentRD.Material_Arcuate_Ring__c = value;
            this.MCAR = value;
        }
    }
    public String MCGR1 {
        get {
            return currentRD.Material_Armor_Ring__c;
        }
        set {
            currentRD.Material_Armor_Ring__c = value;
            this.MCGR1 = value;
        }
    }

    public String MCOG {
        get {
            return currentRD.Material_Outlet_Gasket__c;
        }
        set {
            currentRD.Material_Outlet_Gasket__c = value;
            this.MCOG = value;
        }
    }

    public String MCGR2 {
        get {
            return currentRD.Material_Armor_Ring2__c;
        }
        set {
            currentRD.Material_Armor_Ring2__c = value;
            this.MCGR2 = value;
        }
    }

    public String MCOR {
        get {
            return currentRD.Material_Outlet_Ring__c ;
        }
        set {
            currentRD.Material_Outlet_Ring__c = value;
            this.MCOR = value;
        }
    }
    public String MCDP {
        get {
            return currentRD.Material_Dent_Protector__c;
        }
        set {
            currentRD.Material_Dent_Protector__c  = value;
            this.MCDP = value;
        }
    }

    public String MCOL {
        get {
            return currentRD.Material_Outlet_Liner__c;
        }
        set {
            currentRD.Material_Outlet_Liner__c = value;
            this.MCOL = value;
        }
    }
    public String MCVS1 {
        get {
            return currentRD.Material_Vacuum_Support__c;
        }
        set {
            currentRD.Material_Vacuum_Support__c = value;
            this.MCVS1 = value;
        }
    }
    public String MCOC {
        get {
            return currentRD.Material_Outlet_Coating__c;
        }
        set {
            currentRD.Material_Outlet_Coating__c = value;
            this.MCOC = value;
        }
    }
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
    public String MCSS1 {
        get {
            return currentRD.Material_Seal__c;
        }
        set {
            currentRD.Material_Seal__c = value;
            this.MCSS1 = value;
        }
    }
    public String MCGD {
        get {
            return currentRD.Material_Girdle__c;
        }
        set {
            currentRD.Material_Girdle__c = value;
            this.MCGD = value;
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
    public String MCDT2 {
        get {
            return currentRD.Material_Top_Section2__c;
        }
        set {
            currentRD.Material_Top_Section2__c = value;
            this.MCDT2 = value;
        }
    }


    public String MCIC1 {
        get {
            return currentRD.Material_Inlet_Coating__c;
        }
        set {
            currentRD.Material_Inlet_Coating__c = value;
            this.MCIC1 = value;
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

    public String MCIR1 {
        get {
            return currentRD.Material_Inlet_Ring__c;
        }
        set {
            currentRD.Material_Inlet_Ring__c = value;
            this.MCIR1 = value;
        }
    }
    public String MCIL {
        get {
            return currentRD.Material_Inlet_Liner__c;
        }
        set {
            currentRD.Material_Inlet_Liner__c = value;
            this.MCIL = value;
        }
    }
    public String MCIR2 {
        get {
            return currentRD.Material_Inlet_Ring2__c;
        }
        set {
            currentRD.Material_Inlet_Ring2__c = value;
            this.MCIR2 = value;
        }
    }


    public String MCVS2 {
        get {
            return currentRD.Material_Vacuum_Support2__c ;
        }
        set {
            currentRD.Material_Vacuum_Support2__c     = value;
            this.MCVS2 = value;
        }
    }
    public String MCIC2 {
        get {
            return currentRD.Material_Inlet_Coating2__c;
        }
        set {
            currentRD.Material_Inlet_Coating2__c = value;
            this.MCIC2 = value;
        }
    }
    public String MCIR3 {
        get {
            return currentRD.Material_Inlet_Ring3__c;
        }
        set {
            currentRD.Material_Inlet_Ring3__c = value;
            this.MCIR3 = value;
        }
    }


    public String MCHS {
        get {
            return currentRD.Material_Handling_Support__c;
        }
        set {
            currentRD.Material_Handling_Support__c = value;
            this.MCHS = value;
        }
    }
    public String MCIG {
        get {
            return currentRD.Material_Inlet_Gasket__c;
        }
        set {
            currentRD.Material_Inlet_Gasket__c = value;
            this.MCIG = value;
        }
    }
    public String MCHT {
        get {
            return currentRD.Material_Hi_Temp_Assembly__c;
        }
        set {
            currentRD.Material_Hi_Temp_Assembly__c = value;
            this.MCHT = value;
        }
    }
    public String MCTSOR {
        get {
            return currentRD.Material_Inlet_O_Ring__c;
        }
        set {
            currentRD.Material_Inlet_O_Ring__c = value;
            this.MCTSOR = value;
        }
    }
    public String MCHI {
        get {
            return currentRD.Material_Inlet__c;
        }
        set {
            currentRD.Material_Inlet__c = value;
            this.MCHI = value;
        }
    }
    public string addIntegralBDICheck {
        get {
            String straddIntegralBDI1= currentRD.Add_Integral_B_D_I_Integral_BDI_FLX_Sen__c?'Y':'N';
            return straddIntegralBDI1;
        }
        set {
            this.addIntegralBDICheck = value;
        }
    }
    public String addIntegralBDI {
        get {
            String straddIntegralBDI= currentRD.Add_Integral_BDI_Integral_BDI_FLX_Sensor__c==null?'N':currentRD.Add_Integral_BDI_Integral_BDI_FLX_Sensor__c;
            return straddIntegralBDI;
        }
        set {
            this.addIntegralBDI =  value;
        }
    }
    public String MCBS {
        get {
            return currentRD.Strip_Type__c==null?'':currentRD.Strip_Type__c;
        }
        set {
            currentRD.Strip_Type__c  = value;
            this.MCBS = value;
        }
    }
    public String MCBDIG {
        get {
            return currentRD.Gasket_Material__c==null?'':currentRD.Gasket_Material__c;
        }
        set {
            currentRD.Gasket_Material__c = value;
            this.MCBDIG = value;
        }
    }
    public String WiringConfig {
        get {
            return currentRD.Wiring_Configuration__c==null?'':currentRD.Wiring_Configuration__c;
        }
        set {
            currentRD.Wiring_Configuration__c = value;
            this.WiringConfig = value;
        }
    }
    public String BCT {
        get {
            return currentRD.Wire_Type__c==null?'':currentRD.Wire_Type__c;
        }
        set {
            currentRD.Wire_Type__c = value;
            this.BCT = value;
        }
    }
    public String BCL {
        get {
            return currentRD.Cable_Length__c==null?'':currentRD.Cable_Length__c;
        }
        set {
            currentRD.Cable_Length__c = value;
            this.BCL = value;
        }
    }
    public String BEC {
        get {
            return currentRD.End_Connection__c==null?'':currentRD.End_Connection__c;
        }
        set {
            currentRD.End_Connection__c = value;
            this.BEC = value;
        }
    }
    public String InterfaceCable {
        get {
            return currentRD.To_Make_With_BDI_FLX_Interface_cable__c==null?'':currentRD.To_Make_With_BDI_FLX_Interface_cable__c;
        }
        set {
            currentRD.To_Make_With_BDI_FLX_Interface_cable__c = value;
            this.InterfaceCable = value;
        }
    }
    public String TMPTSTASME {
        get {
            String strTMPTSTASME= currentRD.Temperature_Test_per_ASME__c==false?'N':'8';
            return strTMPTSTASME;
        }
        set {
            this.TMPTSTASME =  value;
        }
    }
    public String SHELLTEST {
        get {
            String strSHELLTEST= currentRD.Shell_Test__c ==false?'N':'Y';
            return strSHELLTEST;
        }
        set {
            this.SHELLTEST =  value;
        }
    }

    public String PMI {
        get {
            return currentRD.PMI__c==null?'N':currentRD.PMI__c;
        }
        set {
            // currentRD.PMI__c = value;
            this.PMI = value;
        }
    }
    public String SURFFINISH {
        get {
            return currentRD.Surface_Finish__c==null?'N':currentRD.Surface_Finish__c;
        }
        set {
            //currentRD.Surface_Finish__c = value;
            this.SURFFINISH = value;
        }
    }
    public String ELECTROPOL {
        get {
            String strELECTROPOL= currentRD.Electro_polish__c==false?'N':'Y';
            return strELECTROPOL;
        }
        set {
            this.ELECTROPOL =  value;
        }
    }

    public String INDPCK {
        get {
            String strINDPCK= currentRD.Individual_Packaging__c==true?'Y':'N';
            return strINDPCK;
        }
        set {
            this.INDPCK =  value;
        }
    }
    public String CLEAN {
        get {
            return currentRD.Cleanings__c==null?'N':currentRD.Cleanings__c;
        }
        set {
            currentRD.Cleanings__c = value;
            this.CLEAN = value;
        }
    }
    public String CSPECS {
        get {
            System.debug('currentRD.Customer_Specific_Requirements__c'+currentRD.Customer_Specific_Requirements__c);
            return currentRD.Customer_Specific_Requirements__c==null?'N':currentRD.Customer_Specific_Requirements__c;
        }
        set {
            currentRD.Customer_Specific_Requirements__c = value;
            this.CSPECS = value;
        }
    }

    // Code added by Dinesh
    // public String VGRATU {
    //     get {
    //         return VTPRSU;
    //     }
    //     set;
    // }

    public Decimal VGRATW {
        get {
            //return VTPRS1;
            if( VGRAT1 == 'No Rating But Must Withstand'){
                return currentRD.Back_Pressure_Value__c;
            }
            return null;
        }
        set;
    }
    public Decimal RGRATW {
        get {
            //return RTPRS1;
            if( RGRAT1 == 'No Rating But Must Withstand'){
                return currentRD.Positive_Pressure_Value__c;
            }
            return null;
        }
        set;
    }

    /* public String SRP {
get {
String retSRP = '';
if(String.isNotBlank(SRP010)){
//retSRP += SRP010 + '</BR>';
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
} */

    /*public String ORP020 {
get {
String sign = '';
if(RTTMSP < 0.0) {
sign = 'MINUS ';
}
if(RGTYP1 == 'Standard')
return 'MFG. RNG.: ' + RG1MINReal.setScale(2) + ' To '+ RG1MAXReal.setScale(2) + ' ' + RTPRSU + ' @ ' + sign + Math.abs(RTTMSP.setScale(2)) + ' ' + RTTMUN;
if(RGTYP1 == 'Zero')
return 'ZERO MANUFACTURING RANGE';
if(RGTYP1=='-10% (-5 Psig)' || RGTYP1=='-10% (-0.6 Psig)' || RGTYP1=='-5% (-2.5 Psig)' || RGTYP1=='-5% (-0.3 Psig)' || RGTYP1=='-10%' || RGTYP1=='-5%')
return ORP020A + ' ' + String.valueOf(RG1MINReal.setScale(2)) + ' To ' + String.valueOf(RG1MAXReal.setScale(2)) + ' ' + RTPRSU + ' @ ' + sign + Math.abs(RTTMSP.setScale(2)) + ' ' + RTTMUN;
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
*/



    //Simha Code
    public string STC {
        get {
            string strSTC='';
            // List<RD_SeatList__c> rdSeatList = new List<RD_SeatList__c>();
            // rdSeatList = [select AssySeat__c from RD_SeatList__c where Desc__c=:SeatDesc limit 1];
            // if(rdSeatList.size() > 0)
            // {
            //     strSTC = rdSeatList[0].AssySeat__c;
            // }
            return currentRD.Seat__c ;
        }
        set {
            this.STC = value;
        }
    }

    // public string PartSeat {
    //     get {
    //         // string strPartSeat='';
    //         // List<RD_SeatList__c> rdSeatList = new List<RD_SeatList__c>();
    //         // rdSeatList = [select PartSeat__c from RD_SeatList__c where Desc__c=:SeatDesc];
    //         // if(rdSeatList.size() > 0)
    //         // {
    //         //     strPartSeat = rdSeatList[0].PartSeat__c;
    //         // }
    //         //return strPartSeat;
    //         return ConstantsUtil.mapSTCDesc.get(currentRD.Seat__c);
    //     }
    //     set {
    //         this.PartSeat = value;
    //     }
    // }
    public String COIN {
        get {
            if(String.isBlank(currentRD.Inlet_Option_Code__c)){
                currentRD.Inlet_Option_Code__c = 'N';
            }
            return currentRD.Inlet_Option_Code__c;
        }
        set {
            this.COIN = value;
        }
    }

    public String COOUT {
        get {
            if(String.isBlank(currentRD.Outlet_Option_Code__c)){
                currentRD.Outlet_Option_Code__c = 'N';
            }
            return currentRD.Outlet_Option_Code__c;

        }
        set {
            this.COOUT = value;
        }
    }
    public decimal SizeValue {
        get {
            string strSizeValue='';
            decimal decSizeValue=0.0;
            // strSizeValue=[select SizeValue__c from RD_SizeList__c where code__c=:strSZC][0].SizeValue__c;
            decSizeValue=ConstantsUtil.getSizeDesc(currentRD.Size__c).SizeValue;
            return decSizeValue;
        }
        set {
            this.SizeValue = value;
        }
    }
    public string Composite {set;get;}
    //     get {
    //         string strComposite='';
    //         if(Composite==null) {
    //             strComposite=[select Composite__c from Disc_Type_List__c where PTC__c=:PTC][0].Composite__c;
    //             return strComposite;
    //         } else {
    //             return Composite;
    //         }
    //     }
    //     set {
    //         this.Composite = value;
    //     }
    // }

    //[Reverse Engineer Logic to populate attribute DiscThickness in BigMachines]
    public decimal DiscThick {
        get {
            //result res=rdThickness.RDThicknessCal();
            //result res=new result();
            if (currentRD.Disc_Thickness__c!=null)
                return currentRD.Disc_Thickness__c;
            else
                return 0.9;
        }
        set {
            this.DiscThick = value;
        }
    }

    //[Reverse Engineer Logic to populate attribute TopSectionThickness in BigMachines]
    public decimal TopSectThick {
        get {
            //result res=new result();
            //result res=rdThickness.RDTopSectionThickness();
            if (currentRD.TopSection_Thickness__c!=null)
                return currentRD.TopSection_Thickness__c;
            else
                return 0.9;
        }
        set {
            this.TopSectThick = value;
        }
    }
    public decimal DiscTopThick {
        get {
            decimal strDiscTopThick=0;
            if(DiscThick!=null)
                return strDiscTopThick=DiscThick;
            else if(TopSectThick!=null)
                return strDiscTopThick=TopSectThick;
            else
                return strDiscTopThick;
        }
        set {
            this.DiscTopThick = value;
        }
    }

    public decimal TefSealThick{
        get {
            decimal decTefSealThick=0.0;
            if((MCSS=='070' || MCSS=='071' || MCSS=='072' || MCSS=='073') && PTC !='PAS' && PTC !='CAL')
            {

                System.debug('PTC'+PTC);
                System.debug('strSZC'+strSZC);
                System.debug('RGEMIN'+RGEMIN);
                System.debug('RTTMDF'+RTTMDF);

                if(rdDscInfoLst.size() > 0){
                    decTefSealThick=rdDscInfoLst[0].SealThck__c;
                    return decTefSealThick;
                }else{
                    return decTefSealThick;
                }
                // decTefSealThick=[select SealThck__c from Disc_Information__c where PTC__c=:PTC and SZC__c=:strSZC and MfgRngLL__c<=:RGEMIN
                //                  and MfgRngUL__c>:RGEMIN and TempLL__c<=:RTTMDF and TempUL__c>:RTTMDF][0].SealThck__c;
                //strTefSealThick=String.valueOf(decTefSealThick1);
                //return decTefSealThick;
            }

            else if(PTC=='CAL')
            {
                decimal decTefSealThick2;
                // decTefSealThick2=[select SealThck__c from RD_tblPosCalRating__c where PTC__c=:PTC and SZC__c=:strSZC and
                //                  MinGrdlRatedLL__c<=:VG2Min and MinGrdlRatedUL__c>:VG2Min and TempLL__c<:RTTMDF and
                //                  TempUL__c<=:RTTMDF and MinTSMfgRngLL__c<=:RGSMin and MinTSMfgRngUL__c>:RGSMin][0].SealThck__c;
                decTefSealThick2=rdPosCalVal('SealThck__c',VG2Min,RGSMin,rdPosLst);
                //strTefSealThick=String.valueOf(decTefSealThick2);
                return decTefSealThick2;
            }

            else if(PTC=='PAS')
            {
                if(RGEMIN==null)
                    RGEMIN=0.0;
                if(VGSMIN==null)
                    VGSMIN=0.0;
                decimal decTefSealThick3;
                List<RD_tblPosCalRating__c> ratingList = new List<RD_tblPosCalRating__c>();
                // ratingList=[select SealThck__c from RD_tblPosCalRating__c where PTC__c=:PTC and SZC__c=:strSZC and
                //             MinGrdlRatedLL__c<=:RGEMIN and MinGrdlRatedUL__c>:RGEMIN and TempLL__c<:RTTMDF and
                //             TempUL__c<=:RTTMDF and MinTSMfgRngLL__c<=:VGSMIN and MinTSMfgRngUL__c>:VGSMin];
                decTefSealThick3=rdPosCalVal('SealThck__c',RGEMIN,VGSMIN,rdPosLst);
                //strTefSealThick=String.valueOf(decTefSealThick3);
                return decTefSealThick3;
            }
            else if(MCSS!='070' && MCSS!='071' && MCSS!='072' && MCSS!='073')
                return decTefSealThick=0.005;
            else
                return decTefSealThick;
        }
        set {
            this.TefSealThick = value;
        }
    }

    //[Reverse Engineer Logic to populate attribute MetalSealThickness in BigMachines]
    public decimal MetalSealThick {
        get {
            //result res=new result();
            //result res=rdThickness.RDMetalSealThickness();
            if (currentRD.MetalSeal_Thickness__c!=null)
                return currentRD.MetalSeal_Thickness__c;
            else
                return 0.9;
        }
        set {
            this.MetalSealThick = value;
        }
    }
    public decimal SlotCoverStripThick {
        get {
            string strSlotCoverStripThick='';
            decimal decSlotCoverStripThick=0.0;
            if(SlotCoverStripThick==null) {
                // decSlotCoverStripThick=[select SCStripThck__c from Disc_Information__c where PTC__c=:PTC and SZC__c=:strSZC and
                //                         MfgRngLL__c<=:RGEMIN and MfgRngUL__c>:RGEMIN and TempLL__c<=:RTTMDF and TempUL__c>:RTTMDF][0].SCStripThck__c;
                if(!rdDscInfoLst.isEmpty()) {
                    decSlotCoverStripThick=rdDscInfoLst[0].SCStripThck__c;
                    if(decSlotCoverStripThick==0.0)
                    {
                        decSlotCoverStripThick=0.005;
                        strSlotCoverStripThick=String.valueOf(decSlotCoverStripThick);
                        return decSlotCoverStripThick;
                    }
                    else
                        return decSlotCoverStripThick;
                } else {
                    return decSlotCoverStripThick;
                }
            } else {
                return SlotCoverStripThick=0.0;
            }
        }
        set {
            this.SlotCoverStripThick = value;
        }
    }
    public decimal SlotCover1ThickStructure {
        get {
            string strSlotCover1Thick='';
            decimal decSlotCover1Thick=0.0;
            if (SlotCover1ThickStructure==null) {
                if(PTC=='CAL' && DSCVAR=='S'){
                    if(RGSMin==null)
                        RGSMin=0.0;
                    if(VG2MIN==null)
                        VG2MIN=0.0;
                    decSlotCover1Thick=rdPosCalVal('SC1Thck__c',VG2Min,RGSMin,rdPosLst);
                    strSlotCover1Thick=String.valueOf(decSlotCover1Thick);
                    return decSlotCover1Thick;
                }
                else if(PTC=='PAS' && DSCVAR=='S'){
                    if(RGEMIN==null)
                        RGEMIN=0.0;
                    if(VG2MIN==null)
                        VG2MIN=0.0;
                    decSlotCover1Thick=rdPosCalVal('SC1Thck__c',RGEMIN,VG2Min,rdPosLst);
                    strSlotCover1Thick=String.valueOf(decSlotCover1Thick);
                    return decSlotCover1Thick;
                }
                else if(PTC=='CAL' && DSCVAR=='V'){
                    decSlotCover1Thick=rdPosCalVal('NRSC1Thck__c',VG2Min,RGSMin,rdPosLst);
                    strSlotCover1Thick=String.valueOf(decSlotCover1Thick);
                    return decSlotCover1Thick;
                }
                else if(PTC=='PAS' && DSCVAR=='V') {
                    if(RGEMIN==null)
                        RGEMIN=0.0;
                    if(VG2Min==null)
                        VG2Min=0.0;
                    decSlotCover1Thick=rdPosCalVal('NRSC1Thck__c',RGEMIN,VG2Min,rdPosLst);
                    strSlotCover1Thick=String.valueOf(decSlotCover1Thick);
                    return decSlotCover1Thick;
                }
                else {
                    return 0;
                }
            } else {
                return SlotCover1ThickStructure;
            }
        }
        set {
            this.SlotCover1ThickStructure = value;
        }
    }
    public decimal SlotCover1Thick {
        get {
            string strSlotCover1Thick='';
            decimal decSlotCover1Thick=0.0;
            if (SlotCover1Thick==null) {
                if(PTC=='CAL' && DSCVAR=='S'){

                    // decSlotCover1Thick=[select SC1Thck__c from RD_tblPosCalRating__c where PTC__c=:PTC and SZC__c=:strSZC and
                    //                     MinGrdlRatedLL__c<=:VG2Min and MinGrdlRatedUL__c>:VG2Min and TempLL__c<:RTTMDF and
                    //                     TempUL__c<=:RTTMDF and MinTSMfgRngLL__c<=:RGSMin and MinTSMfgRngUL__c>:RGSMin][0].SC1Thck__c;
                    if(RGSMin==null)
                        RGSMin=0.0;
                    if(VG2MIN==null)
                        VG2MIN=0.0;
                    decSlotCover1Thick=rdPosCalVal('SC1Thck__c',VG2Min,RGSMin,rdPosLst);
                    strSlotCover1Thick=String.valueOf(decSlotCover1Thick);
                    return decSlotCover1Thick;
                }

                else if(PTC=='PAS' && DSCVAR=='S'){

                    // decSlotCover1Thick=[select SC1Thck__c from RD_tblPosCalRating__c where PTC__c=:PTC and SZC__c=:strSZC and
                    //                     MinGrdlRatedLL__c<=:RGEMIN and MinGrdlRatedUL__c>:RGEMIN and TempLL__c<:RTTMDF and
                    //                     TempUL__c<=:RTTMDF and MinTSMfgRngLL__c<=:VG2Min and MinTSMfgRngUL__c>:VG2Min][0].SC1Thck__c;
                    if(RGEMIN==null)
                        RGEMIN=0.0;
                    if(VG2MIN==null)
                        VG2MIN=0.0;
                    decSlotCover1Thick=rdPosCalVal('SC1Thck__c',RGEMIN,VG2Min,rdPosLst);
                    strSlotCover1Thick=String.valueOf(decSlotCover1Thick);
                    return decSlotCover1Thick;
                }

                else if(PTC=='CAL' && DSCVAR!='S'){

                    // decSlotCover1Thick=[select NRSC1Thck__c from RD_tblPosCalRating__c where PTC__c=:PTC and SZC__c=:strSZC and
                    //                     MinGrdlRatedLL__c<=:VG2Min and MinGrdlRatedUL__c>:VG2Min and TempLL__c<:RTTMDF and
                    //                     TempUL__c<=:RTTMDF and MinTSMfgRngLL__c<=:RGSMin and MinTSMfgRngUL__c>:RGSMin][0].NRSC1Thck__c;
                    decSlotCover1Thick=rdPosCalVal('NRSC1Thck__c',VG2Min,RGSMin,rdPosLst);
                    strSlotCover1Thick=String.valueOf(decSlotCover1Thick);
                    return decSlotCover1Thick;
                }

                else if(PTC=='PAS' && DSCVAR!='S') {

                    // decSlotCover1Thick=[select NRSC1Thck__c from RD_tblPosCalRating__c where PTC__c=:PTC and SZC__c=:strSZC and
                    //                     MinGrdlRatedLL__c<=:RGEMIN and MinGrdlRatedUL__c>:RGEMIN and TempLL__c<:RTTMDF and
                    //                     TempUL__c<=:RTTMDF and MinTSMfgRngLL__c<=:VG2Min and MinTSMfgRngUL__c>:VG2Min][0].NRSC1Thck__c;
                    if(RGEMIN==null)
                        RGEMIN=0.0;
                    if(VG2Min==null)
                        VG2Min=0.0;
                    decSlotCover1Thick=rdPosCalVal('NRSC1Thck__c',RGEMIN,VG2Min,rdPosLst);
                    strSlotCover1Thick=String.valueOf(decSlotCover1Thick);
                    return decSlotCover1Thick;
                }

                else {

                    // decSlotCover1Thick=[select SlotCovThck__c from Disc_Information__c where  PTC__c=:PTC and SZC__c=:strSZC and
                    //                     MfgRngLL__c<=:RGEMIN and MfgRngUL__c>:RGEMIN and TempLL__c<=:RTTMDF and TempUL__c>:RTTMDF][0].SlotCovThck__c;
                    if(rdDscInfoLst.size() > 0){
                        decSlotCover1Thick=rdDscInfoLst[0].SlotCovThck__c;
                        strSlotCover1Thick=String.valueOf(decSlotCover1Thick);
                    }
                    return decSlotCover1Thick;
                }
            } else {
                return SlotCover1Thick;
            }
        }
        set {
            this.SlotCover1Thick = value;
        }
    }
    public decimal SlotCover2Thick {
        get {
            string strSlotCover2Thick='';
            decimal decSlotCover2Thick=0.0;
            if (SlotCover2Thick==null) {
                if(PTC=='CAL' && DSCVAR=='S')
                {

                    // decSlotCover2Thick=[select SC2Thck__c from RD_tblPosCalRating__c where PTC__c=:PTC and SZC__c=:strSZC and
                    //                     MinGrdlRatedLL__c<=:VG2Min and MinGrdlRatedUL__c>:VG2Min and TempLL__c<:RTTMDF and
                    //                     TempUL__c<=:RTTMDF and MinTSMfgRngLL__c<=:RGSMin and MinTSMfgRngUL__c>:RGSMin][0].SC2Thck__c;
                    if(RGSMin==null)
                        RGSMin=0.0;
                    if(VG2Min==null)
                        VG2Min=0.0;
                    decSlotCover2Thick=rdPosCalVal('SC2Thck__c',VG2Min,RGSMin,rdPosLst);
                    strSlotCover2Thick=String.valueOf(decSlotCover2Thick);
                    return decSlotCover2Thick;
                }

                else if(PTC=='PAS' && DSCVAR=='S')
                {
                    // decSlotCover2Thick=[select SC2Thck__c from RD_tblPosCalRating__c where PTC__c=:PTC and SZC__c=:strSZC and
                    //                     MinGrdlRatedLL__c<=:RGEMIN and MinGrdlRatedUL__c>:RGEMIN and TempLL__c<:RTTMDF and
                    //                     TempUL__c<=:RTTMDF and MinTSMfgRngLL__c<=:VG2Min and MinTSMfgRngUL__c>:VG2Min][0].SC2Thck__c;
                    if(RGEMIN==null)
                        RGEMIN=0.0;
                    if(VG2Min==null)
                        VG2Min=0.0;
                    decSlotCover2Thick=rdPosCalVal('SC2Thck__c',RGEMIN,VG2Min,rdPosLst);
                    strSlotCover2Thick=String.valueOf(decSlotCover2Thick);
                    return decSlotCover2Thick;
                }

                else if(PTC=='CAL' && DSCVAR!='S')
                {
                    // decSlotCover2Thick=[select NRSC2Thck__c from RD_tblPosCalRating__c where PTC__c=:PTC and SZC__c=:strSZC and
                    //                     MinGrdlRatedLL__c<=:VG2Min and MinGrdlRatedUL__c>:VG2Min and TempLL__c<:RTTMDF and
                    //                     TempUL__c<=:RTTMDF and MinTSMfgRngLL__c<=:RGSMin and MinTSMfgRngUL__c>:RGSMin][0].NRSC2Thck__c;
                    if(RGSMin==null)
                        RGSMin=0.0;
                    if(VG2Min==null)
                        VG2Min=0.0;
                    decSlotCover2Thick=rdPosCalVal('NRSC2Thck__c',VG2Min,RGSMin,rdPosLst);
                    strSlotCover2Thick=String.valueOf(decSlotCover2Thick);
                    return decSlotCover2Thick;
                }

                else if(PTC=='PAS' && DSCVAR!='S')
                {
                    //rdPosLst
                    if(RGEMIN==null)
                        RGEMIN=0.0;
                    if(VG2Min==null)
                        VG2Min=0.0;
                    decSlotCover2Thick=rdPosCalVal('NRSC2Thck__c',RGEMIN,VG2Min,rdPosLst);
                    // decSlotCover2Thick=[select NRSC2Thck__c from RD_tblPosCalRating__c where PTC__c=:PTC and SZC__c=:strSZC and
                    //                     MinGrdlRatedLL__c<=:RGEMIN and MinGrdlRatedUL__c>:RGEMIN and TempLL__c<:RTTMDF and
                    //                     TempUL__c<=:RTTMDF and MinTSMfgRngLL__c<=:VG2Min and MinTSMfgRngUL__c>:VG2Min][0].NRSC2Thck__c;
                    //strSlotCover2Thick=String.valueOf(decSlotCover2Thick);
                    // strSlotCover2Thick=decSlotCover2Thick;
                    return decSlotCover2Thick;
                }
                else
                    return decSlotCover2Thick;
            } else {
                return decSlotCover2Thick;
            }
        }
        set {
            this.SlotCover2Thick = value;
        }
    }
    public decimal OuletGasketThick=0;
    public decimal RVIGasketThick=0;
    public decimal InletRingThick=0;
    public decimal ArcuateRingThick=0;
    public decimal OutletRingThick=0;
    public decimal OutletLinerThick=0;
    public decimal VacuumSupportThick=0;
    public decimal HandlingSupportThick=0;
    //'=OuletGasketThick+RVIGasketThick+InletRingThick+ArcuateRingThick+OutletRingThick+InletLinerThick+OutletLinerThick+VacuumSupportThick+HandlingSupportThick+DiscTopThick+TefSealThick+MetalSealThick+SlotCoverStripThick+SlotCover1Thick+SlotCover2Thick
    public decimal AssyThick {
        get {
            System.debug('DiscTopThick: ' + DiscTopThick);
            System.debug('TefSealThick: ' + TefSealThick);
            System.debug('MetalSealThick: ' + MetalSealThick);
            System.debug('SlotCoverStripThick: ' + SlotCoverStripThick);
            System.debug('SlotCover1Thick: ' + SlotCover1Thick);
            // System.debug('SlotCover2Thick: ' + SlotCover2Thick);
            decimal slotcvr2=SlotCover2Thick!=null?SlotCover2Thick:0;
            return DiscTopThick+TefSealThick+MetalSealThick+SlotCoverStripThick+SlotCoverStripThick+SlotCover1Thick+slotcvr2;
        }
        set {
            this.AssyThick = value;
        }
    }
    public string DSCVAR
    {
        get {
            return currentRD.DSCVAR__c;
        }
        set {
            this.DSCVAR = value;
        }
    }
    public string MCSS {
        get {
            string strMCSS='';
            System.debug('MCSS1: ' + MCSS1);
            System.debug('MCSS2: ' + MCSS2);
            System.debug('MCSS3: ' + MCSS3);
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
            System.debug('MCDT1: ' + MCDT1);
            System.debug('MCDT1: ' + MCDT1);
            if(MCDT1!=null)
                return MCDT1;
            else if(MCDT2!=null)
                return MCDT2;
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
                return MCDD;
            else if(MCDT!=null)
                return MCDT;
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
            // System.debug('MCSS-->: ' + MCSS);
            // System.debug('MCDT-->: ' + MCDT);
            // if(MCSS!='070' && MCSS!='071' &&  MCSS!='072' && MCSS!='073')
            //     return strMCSM=MCSS;
            // else if(MCSS=='070' || MCSS=='071' || MCSS=='072' || MCSS=='073')
            //     return strMCSM=MCDT;
            // else
            //     return strMCSM;
            if(string.isNotBlank(currentRD.MCSM__c)) {
                return currentRD.MCSM__c;
            } else
                return '';
        }
        set {
            this.MCSM = value;
        }
    }
    public string MCST {
        get {
            string strMCST='';
            if(MCST==null) {
                if(MCSS=='071' || MCSS=='072' || MCSS=='073')
                    return strMCST=MCSS;
                else if(MCSS=='070' && PTC!='CAL' && PTC!='PAS'){
                    decimal decMCST=0.0;
                    // decMCST=[select SealMatl__c from Disc_Information__c where PTC__c=:PTC and SZC__c=:strSZC and MfgRngLL__c<=:RGEMIN
                    //         and MfgRngUL__c>:RGEMIN and TempLL__c<=:RTTMDF and TempUL__c>:RTTMDF][0].SealMatl__c;
                    if(rdDscInfoLst.size() > 0){
                        decMCST=rdDscInfoLst[0].SealMatl__c;
                        strMCST=String.valueOf(decMCST);
                        if(strMCST.length() == 2){
                            strMCST = '0' + strMCST;
                        } else if(strMCST.length() == 1){
                            strMCST = '00' + strMCST;
                        }
                        return strMCST;
                    }else{
                        return strMCST;
                    }

                }
                else if(MCSS=='070' && (PTC=='CAL' || PTC=='PAS'))
                    return strMCST='073';
                else
                    return strMCST;
            } else {
                return MCST;
            }
        }
        set {
            this.MCST = value;
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
            return currentRD.Material_Vaccum_Support3__c ;
        }
        set {
            this.MCVS3 = value;
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
    public string MCSC {
        get {
            string strMCSC='';
            if(MCSC==null) {
                if(MCSM=='001' || MCSM=='012')
                    return strMCSC=MCSM;
                else if(MCST=='070' && MCSM!=null){
                    decimal decMCSC;
                    // decMCSC=[select SealMatl__c from Disc_Information__c where PTC__c=:PTC and SZC__c=:strSZC and MfgRngLL__c<=:RGEMIN
                    //         and MfgRngUL__c>:RGEMIN and TempLL__c<=:RTTMDF and TempUL__c>:RTTMDF][0].SealMatl__c;
                    decMCSC=rdDscInfoLst[0].SealMatl__c;
                    strMCSC=String.valueOf(decMCSC);
                    return strMCSC;
                }
                else if(MCST=='071' || MCST=='072' || MCST=='073' || MCSM==null)
                    return strMCSC=MCST;
                else if((MCSS=='070' || MCSS=='071' || MCSS=='072' || MCSS=='073') && (MCSM!=null))
                    return strMCSC=MCDT;
                else
                    return strMCSC;
            } else {
                return MCSC;
            }
        }
        set {
            this.MCSC = value;
        }
    }

    public decimal TMR {
        get {
            return currentRD.TMR__c;
        }
        set {
            this.TMR = value;
        }
    }
    public Map<string,RDSourceCode__c> mapSrcCd() {
        Map<String, RDSourceCode__c> myMap = new Map<String, RDSourceCode__c>();
        for(RDSourceCode__c objCS : [SELECT ArcRingSC__c,DiscSC__c,GirdleCovSC__c,GirdleSC__c,HandSuptSC__c,HolderInlSC__c,HolderOutSC__c,HolderRingSC__c,IGaskSC__c,ILinerSC__c,IRingSC__c,MSealSC__c,OGaskSC__c,OLinerSC__c,ORingSC__c,SlotCoverSC__c,SlotCoverStripsSC__c,TopSectSC__c,TSealSC__c,TSORingSC__c,VacSuptSC__c,Material_Sourcing_Requirements__c FROM RDSourceCode__c])
            myMap.put(objCS.Material_Sourcing_Requirements__c, objCS);
        return myMap;
    }

    public Map<string,RDSourceCode__c> mapRD_SourceCode {get;set;}
    //     get {
    //         Map<String, RDSourceCode__c> myMap = new Map<String, RDSourceCode__c>();
    //         if (mapRD_SourceCode==null) {
    //             for(RDSourceCode__c objCS : [SELECT ArcRingSC__c,DiscSC__c,GirdleCovSC__c,GirdleSC__c,HandSuptSC__c,HolderInlSC__c,HolderOutSC__c,HolderRingSC__c,IGaskSC__c,ILinerSC__c,IRingSC__c,MSealSC__c,OGaskSC__c,OLinerSC__c,ORingSC__c,SlotCoverSC__c,SlotCoverStripsSC__c,TopSectSC__c,TSealSC__c,TSORingSC__c,VacSuptSC__c,Material_Sourcing_Requirements__c FROM RDSourceCode__c])
    //                 myMap.put(objCS.Material_Sourcing_Requirements__c, objCS);
    //             return myMap;
    //         } else {
    //             return mapRD_SourceCode;
    //         }
    //     }
    //     set {
    //         this.mapRD_SourceCode = value;
    //     }
    // }
    public String MATLSOURCE {
        get {
            return currentRD.Material_Sourcing_Requirements__c==null?'00':currentRD.Material_Sourcing_Requirements__c;
        }
        set {
            currentRD.Material_Sourcing_Requirements__c = value;
            this.MATLSOURCE = value;
        }
    }
    public String ASSYLOCATION {
        get {
            return currentRD.Final_Assembly_Location_Requirements__c;
        }
        set {
            currentRD.Final_Assembly_Location_Requirements__c = value;
            this.ASSYLOCATION = value;
        }
    }
    public String OGaskSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).OGaskSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).OGaskSC__c;
        }
        set{
            this.OGaskSC = value;
        }
    }

    public String IGaskSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).IGaskSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).IGaskSC__c;
        }
        set{
            this.IGaskSC = value;
        }
    }

    public String IRingSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).IRingSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).IRingSC__c;
        }
        set{
            this.IRingSC = value;
        }
    }

    public String ArcRingSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).ArcRingSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).ArcRingSC__c;
        }
        set{
            this.ArcRingSC = value;
        }
    }
    public String ORingSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).ORingSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).ORingSC__c;
        }
        set{
            this.ORingSC = value;
        }
    }
    public String ILinerSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).ILinerSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).ILinerSC__c;
        }
        set{
            this.ILinerSC = value;
        }
    }
    public String OLinerSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).OLinerSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).OLinerSC__c;
        }
        set{
            this.OLinerSC = value;
        }
    }
    public String DiscSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).DiscSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).DiscSC__c;
        }
        set{
            this.DiscSC = value;
        }
    }
    public String TopSectSC {
        get {
            if(mapRD_SourceCode.containsKey(MATLSOURCE))
            {
                return mapRD_SourceCode.get(MATLSOURCE).TopSectSC__c;
            }
            return '';
        }
        set{
            this.TopSectSC = value;
        }
    }
    public String MSealSC {
        get {
            if(mapRD_SourceCode.containsKey(MATLSOURCE))
            {
                return mapRD_SourceCode.get(MATLSOURCE).MSealSC__c;
            }
            return '';
        }
        set{
            this.MSealSC = value;
        }
    }
    public String TSealSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).TSealSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).TSealSC__c;
        }
        set{
            this.TSealSC = value;
        }
    }
    public String GirdleSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).GirdleSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).GirdleSC__c;
        }
        set{
            this.GirdleSC = value;
        }
    }
    public String GirdleCovSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).GirdleCovSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).GirdleCovSC__c;
        }
        set{
            this.GirdleCovSC = value;
        }
    }
    public String SlotCoverStripsSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).SlotCoverStripsSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).SlotCoverStripsSC__c;
        }
        set{
            this.SlotCoverStripsSC = value;
        }
    }
    public String SlotCoverSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).SlotCoverSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).SlotCoverSC__c;
        }
        set{
            this.SlotCoverSC = value;
        }
    }
    public String VacSuptSC {
        get
        {
            if(mapRD_SourceCode.containsKey(MATLSOURCE))
            {
                return mapRD_SourceCode.get(MATLSOURCE).VacSuptSC__c == null?'': mapRD_SourceCode.get(MATLSOURCE).VacSuptSC__c;
            }
            else
            {
                return '-';
            }
        }
        set{
            this.VacSuptSC = value;
        }
    }
    public String HandSuptSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).HandSuptSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).HandSuptSC__c;
        }
        set{
            this.HandSuptSC = value;
        }
    }
    public String HolderInSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).HolderInlSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).HolderInlSC__c;
        }
        set{
            this.HolderInSC = value;
        }
    }
    public String HolderOutSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).HolderOutSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).HolderOutSC__c;
        }
        set{
            this.HolderOutSC = value;
        }
    }
    public String HolderRingSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).HolderRingSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).HolderRingSC__c;
        }
        set{
            this.HolderRingSC = value;
        }
    }
    public String TSORingSC {
        get {
            return mapRD_SourceCode.get(MATLSOURCE).TSORingSC__c==null?'': mapRD_SourceCode.get(MATLSOURCE).TSORingSC__c;
        }
        set{
            this.TSORingSC = value;
        }
    }

    //pending --- RG3MIN & RG3MAX filter need to add in Query
    public RD_tblASMEValues__c[] RD_tblASMEValues {set;get;}
    public RD_tblASMEValues__c[] RD_tblASMEValues() {
        List<RD_tblASMEValues__c> RD_tblASMEValues = new List<RD_tblASMEValues__c>();
        List<String> lstOfDPM = new List<String>();
        Decimal strOutletOptionASMECode = 0.0;
        Integer deciSZC = 0;
        if(String.isNotBlank(OutletOptionASMECode)){
            strOutletOptionASMECode = Decimal.valueOf(OutletOptionASMECode);
        }
        if(String.isNotBlank(strSZC)){
            deciSZC = Integer.valueOf(strSZC);
        }

        if(DPM == 'Y'){
            //lstOfDPM.add('Liquid');
            //lstOfDPM.add('Gas');
            lstOfDPM.add('Y');
        } else {
            lstOfDPM.add('N');
        }
        System.debug('DPM : --'+lstOfDPM);
        System.debug('HIC : --'+HIC);
        System.debug('HOC : --'+HOC);
        System.debug('InletOptionASMECode : --'+InletOptionASMECode);
        System.debug('strOutletOptionASMECode : --'+strOutletOptionASMECode);
        System.debug('deciSZC : --'+deciSZC);
        System.debug('currentRD.RG3MIN__c : --'+currentRD.RG3MIN__c);
        System.debug('currentRD.RG3MAX__c : --'+currentRD.RG3MAX__c);

        RD_tblASMEValues = [SELECT Id, ASMECertNo__c, ASMEInletOption__c, ASMEOutOption__c, CertOWText__c, Comment__c, DPM__c, DSCVAR__c, HIC__c, HOC__c, KDValueGas__c, KDValueLiquid__c, KD_Text__c, KR_Text__c, MNFAValue__c, MNFAin2__c, MNFAmm2__c, PTC__c, PressLL__c, PressUL__c, STC__c, SZC__c, SeatDesc__c, SizingCertText__c, SizingKrText__c
                            FROM RD_tblASMEValues__c
                            WHERE PTC__c =: PTC AND DSCVAR__c =: DSCVAR AND STC__c =:STC AND DPM__c in :lstOfDPM AND HIC__c in (:HIC,'-') AND HOC__c in (:HOC,'-') AND
                            ASMEInletOption__c = : InletOptionASMECode AND ASMEOutOption__c =: strOutletOptionASMECode AND SZC__c =:strSZC AND PressLL__c <= :currentRD.RG2MIN__c  AND PressUL__c >= :currentRD.RG2MAX__c];
        // AND ASMEOutOption__c in (:OutletOptionASMECode,'""')];
        // AND PressLL__c in (:RG3MIN,'""') AND PressUL__c in (:RG3MAX,'""')
        System.debug('RD_tblASMEValues'+RD_tblASMEValues);
        return RD_tblASMEValues;
    }
    //return value in column 'KR_Text' from table 'tblASMEValues' where column 'PTC'='PTC'
    //and column 'DSCVAR'='DSCVAR' and column 'STC'='STC' and column 'ProcMedia' = 'DPM' and column 'ASMEInletOption'='InletOptionASMECode' and column
    //'ASMEOutOption'='OutletOptionASMECode' and column 'SZC'='SZC' and column 'HIC'='HIC' and column 'HOC'='HOC' and column 'PressLL'<='RG3MIN' and column 'PressUL'>='RG3MAX'

    public RDMasterBlaster__c[] RDMasterBlaster {set;get;}
    public RDMasterBlaster__c[] RDMasterBlaster() {
        List<RDMasterBlaster__c> RdMasterBlaster = new List<RDMasterBlaster__c>();
        if(PTC!=null) {
            RdMasterBlaster = [SELECT Id, Name, ASME_BPE__c, ASME_LL__c, ASME_UL__c, Application__c, Atex__c, Brand__c, CE_Mark_LL__c, CE_Mark_UL__c, CE_Mark__c, CSA__c, CU_TR_Compliant_Discs__c, China_ML_LL__c, China_ML_UL__c, DSCVAR__c, DerateType__c, Derate_EQN__c, Derate_Teflon__c, Direction__c, Fike_Seat__c, KOSHA_LL__c, KOSHA_UL__c, Liquid_Relief__c, MNFA__c, MatlCodePos__c, MatlCodeVac__c, NACE__c, NonFragDesign__c, OPtoBpRatio__c, PTC__c, PosValue__c, PosWithstand_Ind_Value__c, PosWithstand_Ind__c, PressLL__c, PressUL__c, Quick_Change_Seat__c, STC__c, SZC__c, Teflon_Ambient__c, TempLL__c, TempUL__c, VMNFA__c, VacLL__c, VacUL__c, VacValue__c, VacWithstand_Ind_Value__c, VacWithstand_Ind__c, X3A__c
                               FROM RDMasterBlaster__c
                               WHERE PTC__c =:PTC AND STC__c=:STC AND DSCVAR__c=:DSCVAR AND SZC__c =:strSZC];//AND SZC__c =:integer.valueOf(strSZC)
        }
        System.debug('RdMasterBlaster PTC__c'+PTC);
        System.debug('RdMasterBlaster STC__c'+STC);
        System.debug('RdMasterBlaster SZC__c'+strSZC);
        System.debug('RdMasterBlaster DSCVAR'+DSCVAR);
        System.debug('RdMasterBlaster'+RdMasterBlaster);
        return RdMasterBlaster;
    }

    public RD_Option_Code__c[] RDOptionCode() {
        List<RD_Option_Code__c> RdOpCd = new List<RD_Option_Code__c>();
        string strMetalGirdle='Yes';
        string strMCIC='""';
        string strMCOC='""';
        string strSURFFINISH = '-'; //Service Ticket #203408
        if(MCGD=='070'|| MCGD=='071'|| MCGD=='072'|| MCGD=='073')
            strMetalGirdle='No';
        if (MCIC!=null)
            strMCIC=MCIC;
        if(MCOC!=null)
            strMCOC=MCOC;
        //Service Ticket #203408, updated the query to consider '-' in the where clause SURFFINISH and others
        if (String.isBlank(SURFFINISH) ||  SURFFINISH == 'N'){
            strSURFFINISH = '-';
        }else{
            strSURFFINISH = SURFFINISH;
        }    
         
        RdOpCd = [select id,ArcRingOpt__c,DiscOpt__c,Electropolish__c,GirdleCovOpt__c,GirdleOpt__c,HandSuptOpt__c,HolderInlOpt__c,HolderOutOpt__c,HolderRingOpt__c,IGaskOpt__c,ILinerOpt__c,Inlet_Coating__c,IRingOpt__c,Metal_Girdle__c,MSealOpt__c,OGaskOpt__c,OLinerOpt__c,ORingOpt__c,Outlet_Coating__c,SlotCoverOpt__c,SlotCoverStripsOpt__c,Surface_Finish__c,TopSectOpt__c,TSealOpt__c,TSORingOpt__c,VacSuptOpt__c from RD_Option_Code__c
                  where Inlet_Coating__c in (:strMCIC, '-') and Metal_Girdle__c in (:strMetalGirdle, '-')  and Outlet_Coating__c in (:strMCOC, '-') and Electropolish__c=:ELECTROPOL and Surface_Finish__c =:SURFFINISH ]; 
        System.debug('RdOpCd: ' + RdOpCd);
        return RdOpCd;
    }
    public RD_Option_Code__c[] RDOptnCode {set;get;}
    public String OGaskOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].OGaskOpt__c==null?'':RDOptnCode[0].OGaskOpt__c;
            else
                return '';

        }
        set{
            this.OGaskOpt = value;
        }
    }
    public String IGaskOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].IGaskOpt__c==null?'':RDOptnCode[0].IGaskOpt__c;
            else
                return '';
        }
        set{
            this.IGaskOpt = value;
        }
    }
    public String IRingOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].IRingOpt__c==null?'':RDOptnCode[0].IRingOpt__c;
            else
                return '';
        }
        set{
            this.IRingOpt = value;
        }
    }
    public String ArcRingOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].ArcRingOpt__c==null?'':RDOptnCode[0].ArcRingOpt__c;
            else
                return '';
        }
        set{
            this.ArcRingOpt = value;
        }
    }
    public String ORingOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].ORingOpt__c==null?'':RDOptnCode[0].ORingOpt__c;
            else
                return '';
        }
        set{
            this.ORingOpt = value;
        }
    }
    public String ILinerOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].ILinerOpt__c==null?'':RDOptnCode[0].ILinerOpt__c;
            else
                return '';
        }
        set{
            this.ILinerOpt = value;
        }
    }
    public String OLinerOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].OLinerOpt__c==null?'':RDOptnCode[0].OLinerOpt__c;
            else
                return '';
        }
        set{
            this.OLinerOpt = value;
        }
    }
    public String DiscOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].DiscOpt__c==null?'':RDOptnCode[0].DiscOpt__c;
            else
                return '';
        }
        set{
            this.DiscOpt = value;
        }
    }
    public String TopSectOpt {
        get {
            if(RDOptnCode.size() > 0)
            {
                return RDOptnCode[0].TopSectOpt__c;
            }
            return '';
        }
        set{
            this.TopSectOpt = value;
        }
    }
    public String MSealOpt {
        get {
            if(RDOptnCode.size() > 0)
            {
                return RDOptnCode[0].MSealOpt__c==null?'':RDOptnCode[0].MSealOpt__c;
            }
            return '';
        }
        set{
            this.MSealOpt = value;
        }
    }
    public String TSealOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].TSealOpt__c==null?'':RDOptnCode[0].TSealOpt__c;
            else
                return '';
        }
        set{
            this.TSealOpt = value;
        }
    }
    public String GirdleOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].GirdleOpt__c==null?'':RDOptnCode[0].GirdleOpt__c;
            else
                return '';
        }
        set{
            this.GirdleOpt = value;
        }
    }
    public String GirdleCovOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].GirdleCovOpt__c==null?'':RDOptnCode[0].GirdleCovOpt__c;
            else
                return '';
        }
        set{
            this.GirdleCovOpt = value;
        }
    }
    public String SlotCoverStripsOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].SlotCoverStripsOpt__c==null?'':RDOptnCode[0].SlotCoverStripsOpt__c;
            else
                return '';
        }
        set{
            this.SlotCoverStripsOpt = value;
        }
    }
    public String SlotCoverOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].SlotCoverOpt__c==null?'':RDOptnCode[0].SlotCoverOpt__c;
            else
                return '';
        }
        set{
            this.SlotCoverOpt = value;
        }
    }public String VacSuptOpt {
        get {
            if(RDOptnCode.size() > 0)
            {
                return RDOptnCode[0].VacSuptOpt__c;
            }
            else
            {
                return '';
            }
        }
        set{
            this.VacSuptOpt = value;
        }
    }
    public String HandSuptOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].HandSuptOpt__c==null?'':RDOptnCode[0].HandSuptOpt__c;
            else
                return '';
        }
        set{
            this.HandSuptOpt = value;
        }
    }
    public String HolderInOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].HolderInlOpt__c==null?'':RDOptnCode[0].HolderInlOpt__c;
            else
                return '';
        }
        set{
            this.HolderInOpt = value;
        }
    }
    public String HolderOutOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].HolderOutOpt__c==null?'':RDOptnCode[0].HolderOutOpt__c;
            else
                return '';
        }
        set{
            this.HolderOutOpt = value;
        }
    }
    public String HolderRingOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].HolderRingOpt__c==null?'':RDOptnCode[0].HolderRingOpt__c;
            else
                return '';
        }
        set{
            this.HolderRingOpt = value;
        }
    }
    public String TSORingOpt {
        get {
            if(RDOptnCode.size() > 0)
                return RDOptnCode[0].TSORingOpt__c==null?'':RDOptnCode[0].TSORingOpt__c;
            else
                return '';
        }
        set{
            this.TSORingOpt = value;
        }
    }
    public RD_Test_Code__c[] RDTstCd() {
        List<RD_Test_Code__c> RdTestCd = new List<RD_Test_Code__c>();
        Schema.DescribeFieldResult fieldResult = Rupture_Disc__c.NACE__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        string strNACE='None';
        for (Schema.PicklistEntry f : ple) {
            if ( f.getValue()==NACE)
                strNACE=f.getLabel();
        }
        RdTestCd = [select id,ArcRingTest__c,CreatedById,DiscTest__c,GirdleCovTest__c,GirdleTest__c,HandSuptTest__c,HolderInlTest__c,HolderOutTest__c,HolderRingTest__c,IGaskTest__c,ILinerTest__c,IRingTest__c,MSealTest__c,NACE__c,OGaskTest__c,OLinerTest__c,ORingTest__c,PTC__c,Shell_Test__c,SlotCoverStripsTest__c,SlotCoverTest__c,TopSectTest__c,TSealTest__c,TSORingTest__c,VacSuptTest__c from RD_Test_Code__c where NACE__c=:strNACE and Shell_Test__c=:SHELLTEST ];
        return RdTestCd;
    }
    public RD_Test_Code__c[] RDTestCode {set;get;}
    //     get{
    //         if(RDTestCode==null) {
    //             System.debug('NACE: ' + NACE);
    //             System.debug('SHELLTEST: ' + SHELLTEST);
    //             List<RD_Test_Code__c> RdTestCd = new List<RD_Test_Code__c>();
    //             RdTestCd = [select id,ArcRingTest__c,CreatedById,DiscTest__c,GirdleCovTest__c,GirdleTest__c,HandSuptTest__c,HolderInlTest__c,HolderOutTest__c,HolderRingTest__c,IGaskTest__c,ILinerTest__c,IRingTest__c,MSealTest__c,NACE__c,OGaskTest__c,OLinerTest__c,ORingTest__c,PTC__c,Shell_Test__c,SlotCoverStripsTest__c,SlotCoverTest__c,TopSectTest__c,TSealTest__c,TSORingTest__c,VacSuptTest__c from RD_Test_Code__c where NACE__c=:NACE and Shell_Test__c=:SHELLTEST ];
    //             System.debug('RdTestCd: ' + RdTestCd);
    //             return RdTestCd;
    //         }
    //         return RDTestCode;
    //     }
    //     set {
    //         this.RDTestCode=value;
    //     }
    // }
    public String OGaskTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].OGaskTest__c==null?'':RDTestCode[0].OGaskTest__c;
            else
                return '';
        }
        set{
            this.OGaskTest = value;
        }
    }
    public String IGaskTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].IGaskTest__c==null?'':RDTestCode[0].IGaskTest__c;
            else
                return '';
        }
        set{
            this.IGaskTest = value;
        }
    }
    public String IRingTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].IRingTest__c==null?' ':RDTestCode[0].IRingTest__c;
            else
                return '';
        }
        set{
            this.IRingTest = value;
        }
    }
    public String ArcRingTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].ArcRingTest__c==null?'':RDTestCode[0].ArcRingTest__c;
            else
                return '';
        }
        set{
            this.ArcRingTest = value;
        }
    }
    public String ORingTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].ORingTest__c==null?'':RDTestCode[0].ORingTest__c;
            else
                return '';
        }
        set{
            this.ORingTest = value;
        }
    }
    public String ILinerTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].ILinerTest__c==null?'':RDTestCode[0].ILinerTest__c;
            else
                return '';
        }
        set{
            this.ILinerTest = value;
        }
    }
    public String OLinerTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].OLinerTest__c==null?'':RDTestCode[0].OLinerTest__c;
            else
                return '';
        }
        set{
            this.OLinerTest = value;
        }
    }
    public String DiscTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].DiscTest__c==null?'':RDTestCode[0].DiscTest__c;
            else
                return '';
        }
        set{
            this.DiscTest = value;
        }
    }
    public String TopSectTest {
        get {
            if(RDTestCode.size()>0)
            {
                return RDTestCode[0].TopSectTest__c;
            }
            return '';
        }
        set{
            this.TopSectTest = value;
        }
    }
    public String MSealTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].MSealTest__c==null?'':RDTestCode[0].MSealTest__c;
            else
                return '';
        }
        set{
            this.MSealTest = value;
        }
    }
    public String TSealTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].TSealTest__c==null?'':RDTestCode[0].TSealTest__c;
            else
                return '';
        }
        set{
            this.TSealTest = value;
        }
    }
    public String GirdleTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].GirdleTest__c==null?'':RDTestCode[0].GirdleTest__c;
            else
                return '';
        }
        set{
            this.GirdleTest = value;
        }
    }
    public String GirdleCovTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].GirdleCovTest__c==null?'':RDTestCode[0].GirdleCovTest__c;
            else
                return '';
        }
        set{
            this.GirdleCovTest = value;
        }
    }
    public String SlotCoverStripsTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].SlotCoverStripsTest__c==null?'':RDTestCode[0].SlotCoverStripsTest__c;
            else
                return '';
        }
        set{
            this.SlotCoverStripsTest = value;
        }
    }
    public String SlotCoverTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].SlotCoverTest__c==null?'':RDTestCode[0].SlotCoverTest__c;
            else
                return '';
        }
        set{
            this.SlotCoverTest = value;
        }
    }
    public String VacSuptTest {
        get {
            if(RDTestCode.size()>0)
            {
                return RDTestCode[0].VacSuptTest__c;
            }
            return '';
        }
        set{
            this.VacSuptTest = value;
        }
    }
    public String HandSuptTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].HandSuptTest__c==null?'':RDTestCode[0].HandSuptTest__c;
            else
                return '';
        }
        set{
            this.HandSuptTest = value;
        }
    }
    public String HolderInlTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].HolderInlTest__c==null?'':RDTestCode[0].HolderInlTest__c;
            else
                return '';
        }
        set{
            this.HolderInlTest = value;
        }
    }
    public String HolderOutTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].HolderOutTest__c==null?'':RDTestCode[0].HolderOutTest__c;
            else
                return '';
        }
        set{
            this.HolderOutTest = value;
        }
    }
    public String HolderRingTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].HolderRingTest__c==null?'':RDTestCode[0].HolderRingTest__c;
            else
                return '';
        }
        set{
            this.HolderRingTest = value;
        }
    }
    public String TSORingTest {
        get {
            if(RDTestCode.size()>0)
                return RDTestCode[0].TSORingTest__c==null?'':RDTestCode[0].TSORingTest__c;
            else
                return '';
        }
        set{
            this.TSORingTest = value;
        }
    }
    public string OLineOpt {
        get {
            return OLinerOpt;
        }
        set {
            this.OLineOpt = value;
        }
    }
    public string OnLineTest {
        get {
            return OLinerTest;
        }
        set {
            this.OnLineTest = value;
        }
    }
    //Simha Getter Setter variables Ends here
    public string getMatCode(String mt) {
        String key = '';
        System.debug('key LEngth: ' + mt.length());
        switch on mt.length() {
            when 0 {
                key='000';
            }
            when 1 {
                key = '00' + mt;
            }
            when 2 {
                key = '0' + mt;
            }
            when else {
                key = mt;
            }
        }
        System.debug('key LEngth2: ' +key);
        return key;
    }
    // Simha GettingPartnumber Methods Starts from here
    /*RD outputs for Outlet Gasket Part Number */
    public Result getOutletGasketPartNumber() {
        result OGResult=new result();
        if (MCOG!=null)
            MCOG=getMatCode(MCOG);
        if(PTC != null && DSCVAR != null && strSZC!=null && MCOG != null && RTTMDF != null && OGaskSC != null && STC != null && DiscTopThick != null  && OGaskTest != null)
        {
            List<String> selectCols=new List<String>{'OutletGasketPartNumber__c','Part_Code__c','Part_Seat__c','Thck_Code__c','Thickness__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};
                String strPTC='\''+PTC+'\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strSZC='\''+strSZC+'\'';
            String strMCOG='\''+MCOG+'\'';
            String strRTTMDF=''+RTTMDF+'';
            String strOGaskSC='\''+OGaskSC+'\'';
            String strSTC='\''+STC+'\'';
            String strDiscTopThick=''+DiscTopThick+'';
            String strOGaskOpt='\''+OGaskOpt+'\'';
            String strOGaskTest='\''+OGaskTest+'\'';
            if (OGaskTest=='0'||OGaskTest=='')
                strOGaskTest='\'000\'';
            if(OGaskOpt=='')
                strOGaskOpt='\'000\'';
            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','SZC__c','MCOG__c','TempLL__c','TempUL__c','SourceCode__c','STC__c','DiscThckLL__c','DiscThckUL__c','OptionCode__c','TestingCode__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strSZC,strMCOG,strRTTMDF,strRTTMDF,strOGaskSC,strSTC,strDiscTopThick,strDiscTopThick,strOGaskOpt,strOGaskOpt};
                    List<String> whereComps=new List<String>{'=','=','=','=','<=','>','=','=','<=','>','=','='};
                        List<String> extraChars=new List<String>{'','','','','','','','','','','',''};
                            OGResult=wizardBaseDataProcessor.getProdOutputDescData('OutletGasketPartNumber__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(OGResult.bResult)
            {
                system.debug('Outlet Gasket Part Number' +OGResult.objResultList );

            }
        }
        return OGResult;
    }
    /*RD outputs for Inlet Gasket Part Number */
    public Result getInletGasketPartNumber() {
        result IGResult=new result();
        if(PTC != null && DSCVAR != null && strSZC!=null && MCIG != null && RTTMDF != null && IGaskSC != null && STC != null && TefSealThick != null && DiscTopThick != null && AssyThick != null  && IGaskTest != null)
        {
            List<String> selectCols=new List<String>{'InletGasketPartNumber__c','Part_Code__c','Part_Seat__c','Thickness__c','Thck_Code__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};
                if (MCIG!=null)
                MCIG=getMatCode(MCIG);

            String strPTC='\''+PTC+'\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strSZC='\''+strSZC+'\'';
            String strMCIG='\''+MCIG+'\'';
            String strRTTMDF=''+RTTMDF+'';
            String strIGaskSC='\''+IGaskSC+'\'';
            String strSTC='\''+STC+'\'';
            String strTefSealThick=''+TefSealThick+'';
            String strDiscTopThick=''+DiscTopThick+'';
            String strAssyThick=''+AssyThick+'';
            String strIGaskOpt='\''+IGaskOpt+'\'';
            String strIGaskTest='\''+IGaskTest+'\'';
            if (IGaskTest=='0'||IGaskTest=='')
                strIGaskTest='\'000\'';
            if(IGaskOpt=='')
                strIGaskOpt='\'000\'';
            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','SZC__c','MCIG__c','TempLL__c','TempUL__c','SourceCode__c','STC__c','TefSealThickLL__c','TefSealThickUL__c','DiscThckLL__c','DiscThckUL__c','AssyThickLL__c','AssyThickUL__c','OptionCode__c','TestingCode__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strSZC,strMCIG,strRTTMDF,strRTTMDF,strIGaskSC,strSTC,strTefSealThick,strTefSealThick,strDiscTopThick,strDiscTopThick,strAssyThick,strAssyThick,strIGaskOpt,strIGaskTest};
                    List<String> whereComps=new List<String>{'=','=','=','=','<=','>','=','=','<=','>','<=','>','<=','>','=','='};
                        List<String> extraChars=new List<String>{'','','','','NULL','NULL','','','NULL','NULL','','','NULL','NULL','',''};
                            IGResult=wizardBaseDataProcessor.getProdOutputDescData('RDInletGasketPartNumber__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(IGResult.bResult)
            {
                //IGResult.objResultList=IGResult.objResultList[0];
                system.debug('Inlet Gasket Part Number' +IGResult.objResultList );

            }
        }
        return IGResult;
    }
    /*RD outputs for RVI Gasket Part Number */
    public Result getRVIGasketPartNumber() {
        result RVResult=new result();
        if(PTC != null && strSZC!=null && MCOG != null && OGaskSC != null  && OGaskTest != null)
        {
            List<String> selectCols=new List<String>{'NAME','Thickness__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};
                if (MCOG!=null)
                MCOG=getMatCode(MCOG);
            String strPTC='\''+PTC+'\'';
            String strSZC='\''+strSZC+'\'';
            String strMCOG='\''+MCOG+'\'';
            String strOGaskSC='\''+OGaskSC+'\'';
            String strOGaskOpt='\''+OGaskOpt+'\'';
            String strOGaskTest='\''+OGaskTest+'\'';
            if (OGaskTest=='0'||OGaskTest=='')
                strOGaskTest='\'000\'';
            if(OGaskOpt=='')
                strOGaskOpt='\'000\'';
            List<String> whereCols=new List<String>{'PTC__c','SZC__c','Matl__c','SourceCode__c','OptionCode__c','TestingCode__c'};
                List<String> whereVals=new List<String>{strPTC,strSZC,strMCOG,strOGaskSC,strOGaskOpt,OGaskTest};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','='};
                        List<String> extraChars=new List<String>{'','','','','',''};
                            RVResult=wizardBaseDataProcessor.getProdOutputDescData('RVIGasketPartNumber__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(RVResult.bResult)
            {
                system.debug('Inlet Gasket Part Number' +RVResult.objResultList );

            }
        }
        return RVResult;
    }
    /*RD outputs for Inlet Ring Part Number */
    public Result getInletRingPartNumber() {
        result IRResult=new result();
        //if (IRingOpt==NULL||IRingOpt=='')
        IRingOpt='000';
        System.debug('Inlet Ring-----2'+IRingOpt);
        System.debug('CSPECS-----2'+CSPECS);
        if(PTC != null && DSCVAR != null && CSPECS != null && strSZC!=null && MCIR != null && IRingSC != null && STC != null )
        {
            List<String> selectCols=new List<String>{'InletRingPartNumber__c','Part_Code__c','Seat_Code__c','Thickness__c','Thck_Code__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};
                // if (MCIR!=null)
                // MCIR=getMatCode(MCIR);
                if (IRingTest=='0')
                IRingTest='000';
            String strPTC='\''+PTC+'\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strCSPECS;
            if(CSPECS=='N')
                strCSPECS='N';
            else {
                strCSPECS = CSPECS; //Service Ticket # 200977 removed single quotes
            }
            String strSZC='\''+strSZC+'\'';
            String strMCIR='\''+getMatCode(MCIR)+'\'';
            String strIRingSC='\''+IRingSC+'\'';
            String strSTC='\''+STC+'\'';
            String strIRingOpt;
            if (string.IsBlank(strIRingOpt))
                strIRingOpt='\'000\'';
            else
                strIRingOpt='\''+IRingOpt+'\'';
            String strIRingTest;
            if (IRingTest=='0'||IRingTest=='')
                strIRingTest='\'000\'';
            else
                strIRingTest='\''+IRingTest+'\'';
            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','CSPECS__c','SZC__c','MCIR__c','SourceCode__c','STC__c','OptionCode__c','TestingCode__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strCSPECS,strSZC,strMCIR,strIRingSC,strSTC,strIRingOpt,strIRingTest};
                    List<String> whereComps=new List<String>{'=','=','LIKE','=','=','=','=','=','='};
                        List<String> extraChars=new List<String>{'','','','','','','','',''};
                            IRResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Inlet_Ring_Part_Number__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(IRResult.bResult)
            {
                system.debug('Inlet Gasket Part Number' +IRResult.objResultList );

            }
        }
        return IRResult;
    }
    /*RD outputs for Outlet Ring Part Number */
    public Result getOutletRingPartNumber() {
        result ORResult=new result();
        System.debug('dfghjkl: --->');
        if(PTC != null && DSCVAR != null && DPM != null && strSZC!=null && MCOR != null && MCDT != null && ORingSC != null && STC != null && TMR != null && TefSealThick != null  && ORingTest != null)
        {
            List<String> selectCols=new List<String>{'OutletRingPartNumber__c','Part_Code__c','Part_Seat__c','Thickness__c','ThckCode__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};
                System.debug('dfghjkl: ');
            String strPTC='\''+PTC+'\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strDPM='\''+DPM+'\'';
            String strSZC='\''+strSZC+'\'';
            String strMCOR='\''+getMatCode(MCOR)+'\'';
            String strMCDT='\''+getMatCode(MCDT)+'\'';

            // System.debug('strTMR: ' + strTMR);
            // System.debug('strMCOR: ' + strTMR);
            // System.debug('strMCDT: ' + strMCDT);
            String strORingSC='\''+ORingSC+'\'';
            String strSTC='\''+STC+'\'';
            String strTMR=''+TMR+'';
            String strTefSealThick=''+TefSealThick+'';
            String strORingOpt='\''+ORingOpt+'\'';
            String strORingTest='\''+ORingTest+'\'';
            //System.debug('strTMR: ' + strTMR);
            if (ORingTest=='0'||ORingTest=='')
                strORingTest='\'000\'';
            if(ORingOpt=='')
                strORingOpt='\'000\'';
            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','ProcMedia__c','SZC__c','MCOR__c','MCDT__c','SourceCode__c','STC__c','PressLL__c','PressUL__c','TefSealThickLL__c','TefSealThickUL__c','OptionCode__c','TestingCode__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strDPM,strSZC,strMCOR,strMCDT,strORingSC,strSTC,strTMR,strTMR,strTefSealThick,strTefSealThick,strORingOpt,strORingTest};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','=','=','=','<=','>','<=','>','=','='};
                        List<String> extraChars=new List<String>{'','','-','','','-','','','NULL','NULL','NULL','NULL','',''};
                            ORResult=wizardBaseDataProcessor.getProdOutputDescData('Outlet_Ring_Part_Number__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(ORResult.bResult)
            {
                system.debug('Outlet Ring Part Number' +ORResult.objResultList );

            }
        }
        return ORResult;
    }
    /*RD outputs for Arcuate Ring Part Number */
    public Result getArcuateRingPartNumber() {
        result ARResult=new result();
        if(PTC != null && DSCVAR != null && strSZC!=null && MCAR != null && ArcRingSC != null && STC != null  && ArcRingTest != null)
        {
            List<String> selectCols=new List<String>{'ArcuateRingPartNumber__c','Part_Code__c','Part_Seat__c','Thickness__c','ThckCode__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};
                String strPTC='\''+PTC+'\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strSZC='\''+strSZC+'\'';
            String strMCAR='\''+getMatCode(MCAR)+'\'';
            String strArcRingSC='\''+ArcRingSC+'\'';
            String strSTC='\''+STC+'\'';
            String strArcRingOpt='\''+ArcRingOpt+'\'';
            String strArcRingTest=''+ArcRingTest+'';
            if (ArcRingTest=='0'||ArcRingTest=='')
                strArcRingTest='\'000\'';
            if(ArcRingOpt=='')
                strArcRingOpt='\'000\'';
            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','SZC__c','MCAR__c','SourceCode__c','STC__c','OptionCode__c','TestingCode__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strSZC,strMCAR,strArcRingSC,strSTC,strArcRingOpt,strArcRingTest};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','=','=','='};
                        List<String> extraChars=new List<String>{'','','','','','','',''};
                            ARResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Arcuate_Ring_Part_Number__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(ARResult.bResult)
            {
                system.debug('Arcuate Ring Part Number' +ARResult.objResultList );

            }
        }
        return ARResult;
    }
    // public result getHolderComponentPartNumber() {
    //     result hlderPartResult=new Result();
    //     if(PTC != null && DSCVAR != null && strSZC != null  && STC !=NULL) {
    //         // HolderInlSC__c,HolderOutSC__c,HolderRingSC__c
    //         // HolderInlOpt__c,HolderOutOpt__c,HolderRingOpt__c
    //         String dynamicWhereClause='';
    //         // String dynamicWhereClause2='';
    //         // String dynamicWhereClause3='';
    //         boolean isFlag=true;
    //         if(string.isNotBlank(MCHI)) {
    //             string strHolderInSC;
    //             if(isFlag)
    //                 dynamicWhereClause+=' AND (';
    //             else
    //                 dynamicWhereClause+=' OR';
    //             isFlag=false;

    //             if(HolderInSC=='')
    //                 strHolderInSC='00';
    //             else
    //                 strHolderInSC=HolderInSC;
    //             string strHolderInOpt;
    //             if(HolderInOpt=='0' ||HolderInOpt=='')
    //                 strHolderInOpt='\'000\'';
    //             else
    //                 strHolderInOpt=HolderInOpt;
    //             string strHolderInlTest;
    //             if(HolderInlTest=='0' ||HolderInlTest=='')
    //                 strHolderInlTest='\'000\'';
    //             else
    //                 strHolderInlTest=HolderInlTest;
    //            // HolderInlTest__c,HolderOutTest__c,HolderRingTest__c
    //            dynamicWhereClause+=' (PartCode__c=\'01\' AND Connection__c=\''+HIC+'\' AND Matl__c=\''+MCHI+'\'  AND SourceCode__c=\''+strHolderInSC+'\' AND OptionCode__c=\''+strHolderInOpt+'\' AND TestingCode__c=\''+strHolderInlTest+'\')';

    //         }
    //         if(string.isNotBlank(MCHO)) {
    //             string strHolderOutSC;
    //             if(isFlag)
    //                 dynamicWhereClause+=' AND (';
    //             else
    //                 dynamicWhereClause+=' OR';
    //             isFlag=false;
    //             if(HolderOutSC=='')
    //                 strHolderOutSC='00';
    //             else
    //                 strHolderOutSC=HolderOutSC;
    //             string strHolderOutOpt;
    //             if(HolderOutOpt=='0' ||HolderOutOpt=='')
    //                 strHolderOutOpt='\'000\'';
    //             else
    //                 strHolderOutOpt=HolderOutOpt;
    //             string strHolderOutTest;
    //             if(HolderOutTest=='0' ||HolderOutTest=='')
    //                 strHolderOutTest='\'000\'';
    //             else
    //                 strHolderOutTest=HolderOutTest;
    //             //HolderInlTest__c,HolderOutTest__c,HolderRingTest__c
    //             dynamicWhereClause+=' (PartCode__c=\'02\' AND Connection__c=\''+HOC+'\' AND Matl__c=\''+MCHO+'\'  AND SourceCode__c=\''+strHolderOutSC+'\' AND OptionCode__c=\''+strHolderOutOpt+'\' AND TestingCode__c=\''+strHolderOutTest+'\')';
    //         }
    //         if(string.isNotBlank(MCHRNG)) {
    //             string strHolderRingSC;
    //             if(isFlag)
    //                 dynamicWhereClause+=' AND (';
    //             else
    //                 dynamicWhereClause+=' OR';
    //             isFlag=false;
    //             if(HolderRingSC=='')
    //                 strHolderRingSC='00';
    //             else
    //                 strHolderRingSC=HolderRingSC;
    //             string strHolderRingOpt;
    //             if(HolderRingOpt=='0' ||HolderRingOpt=='')
    //                 strHolderRingOpt='\'000\'';
    //             else
    //                 strHolderRingOpt=HolderRingOpt;
    //             string strHolderRingTest;
    //             if(HolderRingTest=='0' ||HolderRingTest=='')
    //                 strHolderRingTest='\'000\'';
    //             else
    //                 strHolderRingTest=HolderRingTest;
    //             //HolderInlTest__c,HolderOutTest__c,HolderRingTest__c
    //             dynamicWhereClause+=' (PartCode__c=\'02\' AND Connection__c=\''+HOC+'\' AND Matl__c=\''+MCHRNG+'\'  AND SourceCode__c=\''+strHolderRingSC+'\' AND OptionCode__c=\''+strHolderRingOpt+'\' AND TestingCode__c=\''+strHolderRingTest+'\')';
    //         }
    //         if(!isFlag) {
    //             dynamicWhereClause+=' )';
    //         }
    //         string selQuery='SELECT id,Leadtime__c, Component_Scrap__c, Qty_Per_Assembly__c, Scrap_Factor__c, HolderComponentPartNumber__c FROM RD_Holder_Component_Part_Number__c WHERE PTC__c=\''+PTC+'\' AND SZC__c =\''+strSZC+'\' AND STC__c=\''+STC+'\' AND HCLASS__c=\''+HCLASS+'\''+dynamicWhereClause;
    //         try {
    //             hlderPartResult.objResultList=Database.query(selQuery);
    //             hlderPartResult.bResult=true;
    //         } catch (Exception e) {
    //             hlderPartResult.bResult=false;
    //            System.debug('HolderComponent Structure Error: ' + e.getMessage());
    //            System.debug('e.getStackTraceString(): ' + e.getStackTraceString());
    //         }

    //     }
    //     return hlderPartResult;
    // }
    public List<RD_Holder_Component_Part_Number__c> baseRDHLDList() {
        List<RD_Holder_Component_Part_Number__c> rdHldCmP=new List<RD_Holder_Component_Part_Number__c>();
        string selQuery='SELECT id,Leadtime__c, Component_Scrap__c, Qty_Per_Assembly__c, Scrap_Factor__c, HolderComponentPartNumber__c,PartCode__c,Connection__c,Matl__c,SourceCode__c,OptionCode__c,TestingCode__c FROM RD_Holder_Component_Part_Number__c WHERE PTC__c=\''+PTC+'\' AND SZC__c =\''+strSZC+'\' AND STC__c=\''+STC+'\' AND HCLASS__c=\''+HCLASS+'\'';
        system.debug('strQuery Holder Component'+selQuery);
        rdHldCmP=Database.query(selQuery);
        return rdHldCmP;
    }
    public List<RD_Holder_Component_Part_Number__c> bsList{set;get;}
    public RD_Holder_Component_Part_Number__c filterRDHolderComponetPartNum(string strPartCode, string strCon, string strMatlcode,string strSourceCode, string strOptionCode, string strTstCode) {
        RD_Holder_Component_Part_Number__c RDCompPart=new RD_Holder_Component_Part_Number__c();
        if(strSourceCode=='' ||strSourceCode=='0' )
            strSourceCode='00';
        if(strOptionCode=='0' ||strOptionCode=='')
            strOptionCode='000';
        if(strTstCode=='0' ||strTstCode=='')
            strTstCode='000';

        for (RD_Holder_Component_Part_Number__c rdH:bsList) {
            if(rdH.PartCode__c==strPartCode && (rdH.Connection__c==strCon|| (strPartCode=='06'||strPartCode=='99')) && rdH.Matl__c==strMatlcode && (rdH.SourceCode__c==strSourceCode && rdH.OptionCode__c==strOptionCode && rdH.TestingCode__c==strTstCode) ) {
                return rdH;

            }
        }
        return null;
    }
    //vikram part number methods

    //DiscPartNumber method
    public Result getDiscPartNumber() {
        result DiscPartNumberResult=new result();
        if(PTC != null && DSCVAR != null&& MasterCapHt != null&& strSZC != null && MCDD !=NULL && DiscSC !=NULL && STC !=NULL && DiscThick !=NULL  && DiscTest !=NULL)
        {
            List<String> selectCols=new List<String>{'DiscPartNumber__c','Part_Code__c','Part_Seat__c','Thck_Code__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};

                String strPTC='\''+PTC+'\'';
            //strPTC='\'STD\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strMasterCapHt='\''+MasterCapHt+'\'';
            String strSZC='\''+strSZC+'\'';
            String strMCDD='\''+getMatCode(MCDD)+'\'';
            String strDiscSC='\''+DiscSC+'\'';
            String strSTC='\''+STC+'\'';
            String strDiscThick=''+DiscThick+'';
            //String strDiscThick='0.0035';
            String strDiscOpt='\''+DiscOpt+'\'';
            String strDiscTest='\''+DiscTest+'\'';
            if(DiscOpt=='')
                strDiscOpt='\'000\'';
            if(DiscTest=='0' ||DiscTest=='')
                strDiscTest='\'000\'';

            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','CapHt__c','SZC__c','MCD__c','SourceCode__c','STC__c','Thickness__c','OptionCode__c','TestingCode__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strMasterCapHt,strSZC,strMCDD,strDiscSC,strSTC,strDiscThick,strDiscOpt,strDiscTest};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','=','=','=','=','='};
                        List<String> extraChars=new List<String>{'','','','','','','','','',''};
                            DiscPartNumberResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Disc_Part_Number__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(DiscPartNumberResult.bResult)
            {
                system.debug('Work Guidelines list' +DiscPartNumberResult.objResultList );

            }
        }
        return DiscPartNumberResult;
    }

    //TopSectionPartNumber method
    public Result getTopSectionPartNumber() {
        result TopSectionPartNumberResult=new result();
        System.debug('MasterCapHt: ' + MasterCapHt);
        System.debug('TopSectOpt: ' + TopSectOpt);
        System.debug('TopSectThick: ' + TopSectThick);
        if(PTC != null && DSCVAR != null&& MasterCapHt != null&& strSZC != null && MCDT !=NULL && TopSectSC !=NULL && STC !=NULL && TopSectThick !=NULL && TopSectTest !=NULL)
        {
            List<String> selectCols=new List<String>{'TopSectionPartNumber__c ','Part_Code__c','Part_Seat__c','ThckCode__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};
                String strPTC='\''+PTC+'\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strMasterCapHt='\''+MasterCapHt+'\'';
            String strSZC='\''+strSZC+'\'';
            String strMCDT='\''+getMatCode(MCDT)+'\'';
            String strTopSectSC='\''+TopSectSC+'\'';
            String strSTC='\''+STC+'\'';
            String strTopSectThick=''+TopSectThick+'';
            //0.0025
            //String strTopSectThick='0.0025';
            String strTopSectOpt='\''+TopSectOpt+'\'';
            String strTopSectTest='\''+TopSectTest+'\'';
            if(TopSectOpt==null||TopSectOpt=='')
                strTopSectOpt='\'000\'';
            if(TopSectTest=='0'||TopSectTest=='')
                strTopSectTest='\'000\'';
            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','CapHt__c','SZC__c','MCD__c','SourceCode__c','STC__c','Thickness__c','OptionCode__c','TestingCode__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strMasterCapHt,strSZC,strMCDT,strTopSectSC,strSTC,strTopSectThick,strTopSectOpt,strTopSectTest};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','=','=','=','=','='};
                        List<String> extraChars=new List<String>{'','','','','','','','','',''};
                            TopSectionPartNumberResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Top_Section_Part_Number__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(TopSectionPartNumberResult.bResult)
            {
                system.debug('Work Guidelines list' +TopSectionPartNumberResult.objResultList );

            }
        }
        return TopSectionPartNumberResult;
    }

    //MetalSealPartNumber method
    public Result getMetalSealPartNumber() {
        result MetalSealPartNumberResult=new result();
        if(PTC != null && DSCVAR != null&& MasterCapHt != null&& strSZC != null && MCSM !=NULL && MSealSC !=NULL && STC !=NULL && MetalSealThick !=NULL  && MSealTest !=NULL)
        {
            List<String> selectCols=new List<String>{'MetalSealPartNumber__c','Part_Code__c','PartSeat__c','Thck_Code__c','Qty_Per_Assembly__c','Thickness__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};
                String strPTC='\''+PTC+'\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strMasterCapHt='\''+MasterCapHt+'\'';
            String strSZC='\''+strSZC+'\'';
            String strMCSM='\''+getMatCode(MCSM)+'\'';
            String strMSealSC='\''+MSealSC+'\'';
            String strSTC='\''+STC+'\'';
            String strMetalSealThick=''+MetalSealThick+'';
            // String strMetalSealThick='0.002';
            String strMSealOpt='\''+MSealOpt+'\'';
            String strMSealTest='\''+MSealTest+'\'';
            System.debug('strMCSM: ' + strMCSM);
            if (MSealTest=='0'|| MSealTest=='')
                strMSealTest='\'000\'';
            if (MSealOpt==''||MSealOpt=='0')
                strMSealOpt='\'000\'';
            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','CapHt__c','SZC__c','MetalSealMatl__c','SourceCode__c','STC__c','Thickness__c','OptionCode__c','TestingCode__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strMasterCapHt,strSZC,strMCSM,strMSealSC,strSTC,strMetalSealThick,strMSealOpt,strMSealTest};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','=','=','=','=','='};
                        List<String> extraChars=new List<String>{'','','','','','','','','',''};
                            MetalSealPartNumberResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Metal_Seal_Part_Number__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(MetalSealPartNumberResult.bResult)
            {
                system.debug('Work Guidelines list' +MetalSealPartNumberResult.objResultList );

            }
        }
        return MetalSealPartNumberResult;
    }


    //TeflonSealPartNumber method
    public Result getTeflonSealPartNumber() {
        result TeflonSealPartNumberResult=new result();
        if(PTC != null && DSCVAR != null&& MasterCapHt != null&& strSZC != null && MCST !=NULL && TSealSC !=NULL && STC !=NULL && TefSealThick !=NULL  && TSealTest !=NULL)
        {
            List<String> selectCols=new List<String>{'TeflonSealPartNumber__c','Part_Code__c','PartSeat__c','ThckCode__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};
                String strPTC='\''+PTC+'\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strMasterCapHt='\''+MasterCapHt+'\'';
            String strSZC='\''+strSZC+'\'';
            String strMCST='\''+getMatCode(MCST)+'\'';
            String strTSealSC='\''+TSealSC+'\'';
            String strSTC='\''+STC+'\'';
            String strTefSealThick=''+TefSealThick+'';
            String strTSealOpt='\''+TSealOpt+'\'';
            String strTSealTest='\''+TSealTest+'\'';
            if (TSealTest=='0' ||TSealTest=='')
                strTSealTest='\'000\'';
            if(TSealOpt=='')
                strTSealOpt='\'000\'';
            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','CapHt__c','SZC__c','TefSealMatl__c','SourceCode__c','STC__c','Thickness__c','OptionCode__c','TestingCode__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strMasterCapHt,strSZC,strMCST,strTSealSC,strSTC,strTefSealThick,strTSealOpt,strTSealTest};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','=','=','=','=','='};
                        List<String> extraChars=new List<String>{'','','','','','','','','',''};
                            TeflonSealPartNumberResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Teflon_Seal_Part_Number__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(TeflonSealPartNumberResult.bResult)
            {
                system.debug('Work Guidelines list' +TeflonSealPartNumberResult.objResultList );

            }
        }
        return TeflonSealPartNumberResult;
    }


    //GirdlePartNumber method
    public Result getGirdlePartNumber() {
        result GirdlePartNumberResult=new result();
        if(PTC != null && DSCVAR != null && strSZC != null && MCGD !=NULL && GirdleSC !=NULL && STC !=NULL && VG2MIN!= NULL && RG2MIN !=NULL   && GirdleTest !=NULL)
        {
            List<String> selectCols=new List<String>{'GirdlePartNumber__c','Part_Code__c','PartSeat__c','Thickness__c','ThckCode__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};
                String strPTC='\''+PTC+'\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strSZC='\''+strSZC+'\'';
            String strVG2MIN;
            String strRG2MIN;
            String strVG2MIN2;
            String strRG2MIN2;
            String strVal;
            if(PTC=='CAL'){
                strVal=''+VG2MIN.stripTrailingZeros().toPlainString()+'';
            }
            else{
                strVal=''+RG2MIN.stripTrailingZeros().toPlainString()+'';
            }

            String strMCGD='\''+getMatCode(MCGD)+'\'';
            String strGirdleSC='\''+GirdleSC+'\'';
            String strSTC='\''+STC+'\'';
            String strGirdleOpt='\''+GirdleOpt+'\'';
            String strGirdleTest='\''+GirdleTest+'\'';
            if (GirdleTest=='0'|| GirdleTest=='')
                strGirdleTest='\'000\'';
            if(GirdleOpt==''||GirdleOpt=='0')
                strGirdleOpt='\'000\'';

            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','SZC__c','MCGD__c','SourceCode__c','STC__c','PressLL__c','PressUL__c','OptionCode__c','TestingCode__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strSZC,strMCGD,strGirdleSC,strSTC,strVal,strVal,strGirdleOpt,strGirdleTest};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','=','<=','>','=','='};
                        List<String> extraChars=new List<String>{'','','','','','','','','',''};
                            GirdlePartNumberResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Girdle_Part_Number__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(GirdlePartNumberResult.bResult)
            {
                system.debug('Work Guidelines list' +GirdlePartNumberResult.objResultList );

            }
        }
        return GirdlePartNumberResult;
    }

    //GirdleCoverPartNumber method
    public Result getGirdleCoverPartNumber() {
        result GirdleCoverPartNumberResult=new result();
        if(PTC != null && DSCVAR != null && strSZC != null && GirdleCovSC !=NULL && STC !=NULL  && GirdleCovTest !=NULL)
        {
            List<String> selectCols=new List<String>{'Girdle_Cover_Part_Number__c','Part_Code__c','PartSeat__c','Thickness__c','Thick_Code__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};
                String strPTC='\''+PTC+'\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strSZC='\''+strSZC+'\'';
            String strGirdleCovSC='\''+GirdleCovSC+'\'';
            String strSTC='\''+STC+'\'';
            String strGirdleCovOpt='\''+GirdleCovOpt+'\'';
            String strGirdleCovTest='\''+GirdleCovTest+'\'';
            if(GirdleCovOpt==''|| GirdleCovOpt=='0')
                strGirdleCovOpt='\'000\'';
            if(GirdleCovTest=='0'||GirdleCovTest=='')
                strGirdleCovTest='\'000\'';
            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','SZC__c','Sourcing_Code__c','STC__c','Option_Code__c','Testing_Code__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strSZC,strGirdleCovSC,strSTC,strGirdleCovOpt,strGirdleCovTest};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','=','='};
                        List<String> extraChars=new List<String>{'','','','','','',''};
                            GirdleCoverPartNumberResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Girdle_Cover_Part_Number__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(GirdleCoverPartNumberResult.bResult)
            {
                system.debug('Work Guidelines list' +GirdleCoverPartNumberResult.objResultList );

            }
        }
        return GirdleCoverPartNumberResult;
    }

    //SlotCoverStripPartNumber method
    public Result getSlotCoverStripPartNumber() {
        result SlotCoverStripPartNumberResult=new result();
        if(PTC != null && DSCVAR != null && strSZC != null && MCDT !=NULL && SlotCoverStripsSC !=NULL && STC !=NULL && SlotCoverStripThick !=NULL  && SlotCoverStripsTest !=NULL)
        {
            List<String> selectCols=new List<String>{'SlotCoverStripsPartNumber__c','Part_Code__c','Part_Seat__c','Thck_Code__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};
                String strPTC='\''+PTC+'\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strSZC='\''+strSZC+'\'';
            String strMCDT='\''+getMatCode(MCDT)+'\'';
            String strSlotCoverStripsSC='\''+SlotCoverStripsSC+'\'';
            String strSTC='\''+STC+'\'';
            String strSlotCoverStripThick=''+SlotCoverStripThick+'';
            String strSlotCoverStripsOpt='\''+SlotCoverStripsOpt+'\'';
            String strSlotCoverStripsTest='\''+SlotCoverStripsTest+'\'';
            if(SlotCoverStripsOpt==''||SlotCoverStripsOpt=='0')
                strSlotCoverStripsOpt='\'000\'';
            if(SlotCoverStripsTest=='0'||SlotCoverStripsTest=='')
                strSlotCoverStripsTest='\'000\'';
            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','SZC__c','MCDT__c','SourceCode__c','STC__c','Thickness__c','OptionCode__c','TestingCode__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strSZC,strMCDT,strSlotCoverStripsSC,strSTC,strSlotCoverStripThick,strSlotCoverStripsOpt,strSlotCoverStripsTest};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','=','=','=','='};
                        List<String> extraChars=new List<String>{'','','','','','','','',''};
                            SlotCoverStripPartNumberResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Slot_Cover_Strip_Part_Number__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(SlotCoverStripPartNumberResult.bResult)
            {
                system.debug('Work Guidelines list' +SlotCoverStripPartNumberResult.objResultList );

            }
        }
        return SlotCoverStripPartNumberResult;
    }


    //SlotCoverPartNumber method
    public Result getSlotCoverPartNumber() {
        result SlotCoverPartNumberResult=new result();
        System.debug('getSlotCoverPartNumber PTC '+PTC);
        System.debug('getSlotCoverPartNumber DSCVAR '+DSCVAR);
        System.debug('getSlotCoverPartNumber MasterCapHt '+MasterCapHt);
        System.debug('getSlotCoverPartNumber strSZC'+strSZC);
        System.debug('getSlotCoverPartNumber MCSC '+MCSC);
        System.debug('getSlotCoverPartNumber SlotCoverSC '+SlotCoverSC);
        System.debug('getSlotCoverPartNumber SlotCover1Thick '+SlotCover1Thick);
        System.debug('getSlotCoverPartNumber SlotCoverTest '+SlotCoverTest);
        if(PTC != null && DSCVAR != null && MasterCapHt != null && strSZC != null && MCSC !=NULL && SlotCoverSC !=NULL && STC !=NULL && SlotCover1Thick !=NULL  && SlotCoverTest !=NULL)
        {
            System.debug('Inside If Slot Cover Part Number');
            List<String> selectCols=new List<String>{'Slot_Cover_Part_Number_1__c','Thck_Code_1__c','Part_Code__c','Part_Seat__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};
                String strPTC='\''+PTC+'\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strMasterCapHt='\''+MasterCapHt+'\'';
            String strSZC='\''+strSZC+'\'';
            String strMCSC='\''+getMatCode(MCSC)+'\'';
            String strSlotCoverSC='\''+SlotCoverSC+'\'';
            String strSTC='\''+STC+'\'';
            String strSlotCover1Thick=''+SlotCover1Thick+'';
            String strSlotCoverOpt='\''+SlotCoverOpt+'\'';
            String strSlotCoverTest='\''+SlotCoverTest+'\'';
            if(SlotCoverOpt==''||SlotCoverOpt=='0')
                strSlotCoverOpt='\'000\'';
            if(SlotCoverTest=='0'||SlotCoverTest=='')
                strSlotCoverTest='\'000\'';
            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','CapHt__c','SZC__c','Matl__c','SourceCode__c','STC__c','Thickness__c','OptionCode__c','TestingCode__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strMasterCapHt,strSZC,strMCSC,strSlotCoverSC,strSTC,strSlotCover1Thick,strSlotCoverOpt,strSlotCoverTest};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','=','=','=','=','='};
                        List<String> extraChars=new List<String>{'','','','','','','','','',''};
                            SlotCoverPartNumberResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Slot_Cover_Part_Number__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(SlotCoverPartNumberResult.bResult)
            {
                system.debug('Work Guidelines list' +SlotCoverPartNumberResult.objResultList );
            }
        }
        return SlotCoverPartNumberResult;
    }

    //Simha part number Methods

    //RD outputs for VacuumSupportPartNumber
    public Result getVacuumSupportPartNumber() {
        result VacSuppResult=new result();
        if(PTC != null && DSCVAR != null&& MasterCapHt!=null && strSZC!=null && MCVS!=null && VacSuptSC!=null && STC!=null && RTTMDF!=null && RGSMIN!=null && RGEMIN!=null  && VacSuptTest!=null)
        {
            List<String> selectCols=new List<String>{'VacuumSupportPartNumber__c','Part_Code__c','PartSeat__c','Thickness__c','ThckCode__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};

                String strPTC='\''+PTC+'\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strMasterCapHt='\''+MasterCapHt+'\'';
            String strSZC='\''+strSZC+'\'';
            String strMCVS='\''+getMatCode(MCVS)+'\'';
            String strVacSuptSC='\''+VacSuptSC+'\'';
            String strSTC='\''+STC+'\'';
            String strRGSMIN;
            String strRGEMIN;
            String strRGSMIN2;
            String strRGEMIN2;
            String strVal;
            if(RTTMDF <=72){
                strVal=''+RGSMIN+'';
            }
            Else{
                strVal=''+RGEMIN+'';
            }


            String strVacSuptOpt='\''+VacSuptOpt+'\'';
            String strVacSuptTest='\''+VacSuptTest+'\'';

            if(VacSuptOpt==''||VacSuptOpt=='0')
                strVacSuptOpt='\'000\'';
            if(VacSuptTest=='0'||VacSuptTest=='')
                strVacSuptTest='\'000\'';

            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','CapHt__c','SZC__c','MCVS__c','SourceCode__c','STC__c','PressLL__c','PressUL__c','OptionCode__c','TestingCode__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strMasterCapHt,strSZC,strMCVS,strVacSuptSC,strSTC,strVal,strVal,strVacSuptOpt,strVacSuptTest};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','=','=','<=','>','=','='};
                        List<String> extraChars=new List<String>{'','','','','','','','','','',''};
                            VacSuppResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Vacuum_Support_Part_Number__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(VacSuppResult.bResult)
            {
                system.debug('VacuumSupportPartNumber list' +VacSuppResult.objResultList );

            }
        }
        return VacSuppResult;
    }

    //RD outputs for HandlingSupportPartNumber
    public Result getHandlingSupportPartNumber() {
        result HandSuppResult=new result();
        if(PTC != null && DSCVAR != null&& MasterCapHt!=null && strSZC!=null && MCDD!=null&& HandSuptSC!=null && STC!=null && RTTMDF!=null && RGSMIN!=null  && HandSuptTest!=null)
        {
            List<String> selectCols=new List<String>{'HandlingSupportPartNumber__c','Part_Code__c','PartSeat__c','Thickness__c','ThckCode__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};

                String strPTC='\''+PTC+'\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strMasterCapHt='\''+MasterCapHt+'\'';
            String strSZC='\''+strSZC+'\'';
            String strMCDD='\''+getMatCode(MCDD)+'\'';
            String strHandSuptSC='\''+HandSuptSC+'\'';
            String strSTC='\''+STC+'\'';
            String strRGSMIN;
            String strRGEMIN;
            String strRGSMIN2;
            String strRGEMIN2;
            String strVal;
            System.debug('aaaaaaaaaaaRGSMIN: ' + RGSMIN);
            System.debug('aaaaaaaaaaaRGEMIN: ' + RGEMIN);
            if(RTTMDF <=72){
                strVal=''+RGSMIN+'';
            }
            Else{
                strVal=''+RGEMIN+'';
            }

            // if(RTTMDF <=72){
            //     strVal=''+RGSMIN+'';
            // }
            // Else{
            //     strVal=''+RGEMIN+'';
            // }

            String strHandSuptOpt='\''+HandSuptOpt+'\'';
            String strHandSuptTest='\''+HandSuptTest+'\'';
            if(HandSuptOpt=='')
                strHandSuptOpt='\'000\'';
            if(HandSuptTest=='0')
                strHandSuptTest='\'000\'';

            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','CapHt__c','SZC__c','MCHS__c','SourceCode__c','STC__c','PressLL__c','PressUL__c','OptionCode__c','TestingCode__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strMasterCapHt,strSZC,strMCDD,strHandSuptSC,strSTC,strVal,strVal,strHandSuptOpt,strHandSuptTest};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','=','=','<=','>','=','='};
                        List<String> extraChars=new List<String>{'','','','','','','','','','',''};
                            HandSuppResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Handling_Support_Part_Number__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(HandSuppResult.bResult)
            {
                system.debug('HandlingSupportPartNumber list' +HandSuppResult.objResultList );

            }
        }
        return HandSuppResult;
    }

    //RD outputs for IntegralBDIPartNumber
    public Result getIntegralBDIPartNumber() {
        result IntegBDIResult=new result();
        // System.debug('aaaaaaaaaaPTC: ' + PTC);
        // System.debug('aaaaaaaaaaPTPartSeatC: ' + STC);
        // System.debug('aaaaaaaaaaTefSealThick: ' + TefSealThick);
        // system.debug('aaaaaaaaaaMCBDIG : ' + MCBDIG);
        // system.debug('aaaaaaaaaaMCBS : ' + MCBS);
        // system.debug('aaaaaaaaaaBCT : ' + BCT);
        // system.debug('aaaaaaaaaaBEC : ' + BEC);
        // system.debug('aaaaaaaaaaInterfaceCable : ' + InterfaceCable);
        if(PTC != null && strSZC!=null && STC!=null && TefSealThick!=null && MCBDIG!=null && MCBS!=null && BCT!=null && BCL!=null && BEC!=null &&InterfaceCable!=null)
        {
            List<String> selectCols=new List<String>{'ModulePN__c','BTC__c','SubAssyUsed__c','LeadtimeSchedule__c','ROP__c','OrderDesc1__c','OrderDesc2__c','OrderDesc3__c','OrderDesc4__c','OrderDesc5__c','OrderDesc6__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};
                String strPTC='\''+PTC+'\'';
            String strSZC='\''+strSZC+'\'';
            String strPartSeat='\''+STC+'\'';
            String strTefSealThick=''+TefSealThick+'';
            String strMCBDIG='\''+MCBDIG+'\'';
            String strMCBS='\''+MCBS+'\'';
            String strBCT='\''+BCT+'\'';
            String strBCL='\''+BCL+'\'';
            String strBEC='\''+BEC+'\'';
            String strInterfaceCable='\''+InterfaceCable+'\'';
            String strMCOR;
            if (String.isNotBlank(MCOR))
                strMCOR='\'On\'';
            else
                strMCOR='\'Off\'';
            System.debug('strMCOR: ' + strMCOR);
            List<String> whereCols=new List<String>{'PTC__c','SZC__c','CompSTC__c','OutRingOnOff__c','Seal_Thickness__c','GasketMatlCode__c','StripMatlCode__c','WireType__c','CableLength__c','EndConnection__c','Interface__c'};
                List<String> whereVals=new List<String>{strPTC,strSZC,strPartSeat,strMCOR,strTefSealThick,strMCBDIG,strMCBS,strBCT,strBCL,strBEC,strInterfaceCable};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','=','=','=','=','=','='};
                        List<String> extraChars=new List<String>{'','','-','-','NULL','','','','','','-'};
                            IntegBDIResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Integral_BDI_Part_Number__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(IntegBDIResult.bResult)
            {
                system.debug('IntegralBDIPartNumber' +IntegBDIResult.objResultList );

            }
        }
        return IntegBDIResult;
    }

    //RD outputs for InletLinerPartNumber
    public Result getInletLinerPartNumber() {
        result InletLinerResult=new result();
        if(PTC != null && DSCVAR!=null && MasterCapHt!=null && strSZC!=null && MCIL!=null && ILinerSC!=null && STC!=null && DiscThick!=null && RTTMDF!=null && ILinerTest!=null)
        {
            List<String> selectCols=new List<String>{'InletLinerPartNumber__c','Part_Code__c','Part_Seat__c','Thickness__c','ThckCode__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};
                String strPTC='\''+PTC+'\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strMasterCapHt='\''+MasterCapHt+'\'';
            String strSZC='\''+strSZC+'\'';
            String strMCIL='\''+getMatCode(MCIL)+'\'';
            String strILinerSC='\''+ILinerSC+'\'';
            String strSTC='\''+STC+'\'';
            String strDiscThick=DiscThick+'';
            String strRTTMDF=RTTMDF+'';
            String strILinerOpt='\''+ILinerOpt+'\'';
            String strILinerTest='\''+ILinerTest+'\'';
            if(ILinerOpt=='')
                strILinerOpt='\'000\'';
            if(ILinerTest=='0'||ILinerTest=='')
                strILinerTest='\'000\'';
            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','CapHt__c','SZC__c','MCIL__c','SourceCode__c','STC__c','DiscThickLL__c','DiscThickUL__c','TempLL__c','TempUL__c','OptionCode__c','TestingCode__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strMasterCapHt,strSZC,strMCIL,strILinerSC,strSTC,strDiscThick,strDiscThick,strRTTMDF,strRTTMDF,strILinerOpt,strILinerTest};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','=','=','<=','>','<=','>','=','='};
                        List<String> extraChars=new List<String>{'','','','','','','','','','NULL','NULL','',''};
                            InletLinerResult=wizardBaseDataProcessor.getProdOutputDescData('Inlet_Liner_Part_Number__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(InletLinerResult.bResult)
            {
                system.debug('InletLinerPartNumber' +InletLinerResult.objResultList );

            }
        }
        return InletLinerResult;
    }

    //RD outputs for OutletLinerPartNumber
    public Result getOutletLinerPartNumber() {
        result OutletLinerResult=new result();
        if(PTC != null && DSCVAR!=null && MasterCapHt!=null && strSZC!=null && MCOL!=null && OLinerSC!=null && STC!=null && DiscThick!=null && RTTMDF!=null && RGEMIN!=null && OnLineTest!=null)
        {
            List<String> selectCols=new List<String>{'OutletLinerPartNumber__c','Part_Code__c','PartSeat__c','Thickness__c','ThckCode__c','Qty_Per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Leadtime__c'};
                String strPTC='\''+PTC+'\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strMasterCapHt='\''+MasterCapHt+'\'';
            String strSZC='\''+strSZC+'\'';
            String strMCOL='\''+getMatCode(MCOL)+'\'';
            String strOLinerSC='\''+OLinerSC+'\'';
            String strSTC='\''+STC+'\'';
            String strDiscThick=DiscThick+'';
            String strRTTMDF=RTTMDF+'';
            String strRGEMIN=RGEMIN+'';
            String strOLineOpt='\''+OLineOpt+'\'';
            String strOnLineTest='\''+OnLineTest+'\'';
            if(OLineOpt=='')
                strOLineOpt='\'000\'';
            if(OnLineTest=='0'|| OnLineTest=='')
                strOnLineTest='\'000\'';
            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','CapHt__c','SZC__c','MCOL__c','SourceCode__c','STC__c','DiscThckLL__c','DiscThckUL__c','TempLL__c','TempUL__c','MfgRngLL__c','MfgRngUL__c','OptionCode__c','TestingCode__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strMasterCapHt,strSZC,strMCOL,strOLinerSC,strSTC,strDiscThick,strDiscThick,strRTTMDF,strRTTMDF,strRGEMIN,strRGEMIN,strOLineOpt,strOnLineTest};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','=','=','<=','>','<=','>','<=','>','=','='};
                        List<String> extraChars=new List<String>{'','','','','','','','','','','','NULL','NULL','',''};
                            OutletLinerResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Outlet_Line_Part_Number__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(OutletLinerResult.bResult)
            {
                system.debug('OutletLinerPartNumber' +OutletLinerResult.objResultList );

            }
        }
        return OutletLinerResult;
    }
    // GettingPartnumber Methods Starts from here
    // * Method for BGR Product Documents
    public Result getProDoc() {
        result PDResult=new result();
        if(PTC != null && DSCVAR != null && strSZC != null && addIntegralBDI != null && SeatDesc != null)
        {
            List<String> selectCols=new List<String>{'Document__c','Document_No__c'};
                String strPTC='\''+PTC+'\'';
            String strDSCVAR='\''+DSCVAR+'\'';
            String strSZC='\''+integer.valueOf(strSZC)+'\'';
            String strSeatDesc='\''+ SeatDesc+'\'';
            String straddIntegralBDI='\''+addIntegralBDI+'\'';
            List<String> whereCols=new List<String>{'PTC__c','DSCVAR__c','SizeLL__c','SizeUL__c','Seat__c','addIntegralBDI__c'};
                List<String> whereVals=new List<String>{strPTC,strDSCVAR,strSZC,strSZC,strSeatDesc,straddIntegralBDI};
                    List<String> whereComps=new List<String>{'=','=','<=','>=','=','='};
                        List<String> extraChars=new List<String>{'','','','','',''};
                            PDResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Document_instruction__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(PDResult.bResult)
            {
                system.debug('Product Document list' +PDResult.objResultList );

            }
        }
        return PDResult;
    }

    public class RDStructureWrapper {
        public string ComponentPart {set;get;}
        //public string SpringCode {set;get;}
        public string PartCode {set;get;}
        public string PartSeat {set;get;}
        public string Thickness {set;get;}
        public string ThckCode {set;get;}
        public string Qty {set;get;}
        public string ScrapFactor {set;get;}
        public string ComponentScrap {set;get;}
        public string LineItemNo {set;get;}
        public string BTC {set;get;}
        public string SubAssyUsed {set;get;}
        public string LeadtimeSchedule {set;get;}
        public string ROP {set;get;}
        public string OrderDesc1 {set;get;}
        public string OrderDesc2 {set;get;}
        public string OrderDesc3 {set;get;}
        public string OrderDesc4 {set;get;}
        public string OrderDesc5 {set;get;}
        public string OrderDesc6 {set;get;}
        public string DocumentNo {set;get;}
    }


    public List<RDStructureWrapper> getConsolidatedStructureDetails() {
        List<RDStructureWrapper> listOfWrapper = new List<RDStructureWrapper>();
        if(PTC != null && DSCVAR != null && strSZC != null  && STC !=NULL && HCLASS!=null) {
            if(string.isNotBlank(MCHI)) {
                RD_Holder_Component_Part_Number__c rec=filterRDHolderComponetPartNum('01',HIC,MCHI,HolderInSC,HolderInOpt,HolderInlTest);
                if(rec!=null) {
                    system.debug('STRUCT MCHI'+rec);
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) rec.get('HolderComponentPartNumber__c');
                    //ins.SpringCode=(string) sObj.get('InletRingPartNumber__c');
                    // ins.PartCode = (string) sObj.get('Part_Code__c');
                    // ins.PartSeat = (string) sObj.get('Seat_Code__c');
                    // ins.Thickness = String.ValueOf((decimal) sObj.get('Thickness__c'));
                    // ins.ThckCode = (string) sObj.get('Thck_Code__c');
                    ins.Qty =(string) rec.get('Qty_Per_Assembly__c')+'';
                    ins.ScrapFactor =(string) rec.get('Scrap_Factor__c');
                    ins.ComponentScrap =  (string) rec.get('Component_Scrap__c');
                    ins.LineItemNo =(string) rec.get('Leadtime__c');
                    listOfWrapper.add(ins);
                } else {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart='INLET';
                    ins.PartCode = '';
                    ins.PartSeat = '';
                    ins.Qty ='1';
                    ins.ScrapFactor ='';
                    ins.ComponentScrap =  '';
                    ins.LineItemNo ='';
                    listOfWrapper.add(ins);
                }

            }
            if(string.isNotBlank(MCHO)) {
                RD_Holder_Component_Part_Number__c rec=filterRDHolderComponetPartNum('02',HOC,MCHO,HolderOutSC,HolderOutOpt,HolderOutTest);
                if(rec!=null) {
                    system.debug('STRUCT MCHO'+rec);
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) rec.get('HolderComponentPartNumber__c');
                    //ins.SpringCode=(string) sObj.get('InletRingPartNumber__c');
                    // ins.PartCode = (string) sObj.get('Part_Code__c');
                    // ins.PartSeat = (string) sObj.get('Seat_Code__c');
                    // ins.Thickness = String.ValueOf((decimal) sObj.get('Thickness__c'));
                    // ins.ThckCode = (string) sObj.get('Thck_Code__c');
                    ins.Qty =(string) rec.get('Qty_Per_Assembly__c')+'';
                    ins.ScrapFactor =(string) rec.get('Scrap_Factor__c');
                    ins.ComponentScrap =  (string) rec.get('Component_Scrap__c');
                    ins.LineItemNo =(string) rec.get('Leadtime__c');
                    listOfWrapper.add(ins);
                }  else {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart='OUTLET';
                    ins.PartCode = '';
                    ins.PartSeat = '';
                    ins.Qty ='1';
                    ins.ScrapFactor ='';
                    ins.ComponentScrap =  '';
                    ins.LineItemNo ='';
                    listOfWrapper.add(ins);
                }
            }
            if(string.isNotBlank(MCHRNG)) {
                RD_Holder_Component_Part_Number__c rec=filterRDHolderComponetPartNum('06','Ring',MCHRNG,HolderRingSC,HolderRingOpt,HolderRingTest);
                if(rec!=null) {
                    system.debug('STRUCT MCHRNG'+rec);
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) rec.get('HolderComponentPartNumber__c');
                    //ins.SpringCode=(string) sObj.get('InletRingPartNumber__c');
                    // ins.PartCode = (string) sObj.get('Part_Code__c');
                    // ins.PartSeat = (string) sObj.get('Seat_Code__c');
                    // ins.Thickness = String.ValueOf((decimal) sObj.get('Thickness__c'));
                    // ins.ThckCode = (string) sObj.get('Thck_Code__c');
                    ins.Qty =(string) rec.get('Qty_Per_Assembly__c')+'';
                    ins.ScrapFactor =(string) rec.get('Scrap_Factor__c');
                    ins.ComponentScrap =  (string) rec.get('Component_Scrap__c');
                    ins.LineItemNo =(string) rec.get('Leadtime__c');
                    listOfWrapper.add(ins);
                }  else {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart='HOLDDOWNRING';
                    ins.PartCode = '';
                    ins.PartSeat = '';
                    ins.Qty ='1';
                    ins.ScrapFactor ='';
                    ins.ComponentScrap =  '';
                    ins.LineItemNo ='';
                    listOfWrapper.add(ins);
                }
            }
            if(string.isNotBlank(MCTSOR)) {
                RD_Holder_Component_Part_Number__c rec=filterRDHolderComponetPartNum('99','Ring',MCTSOR,TSORingSC,TSORingOpt,TSORingTest);
                if(rec!=null) {
                    system.debug('STRUCT MCTSOR'+rec);
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) rec.get('HolderComponentPartNumber__c');
                    //ins.SpringCode=(string) sObj.get('InletRingPartNumber__c');
                    // ins.PartCode = (string) sObj.get('Part_Code__c');
                    // ins.PartSeat = (string) sObj.get('Seat_Code__c');
                    // ins.Thickness = String.ValueOf((decimal) sObj.get('Thickness__c'));
                    // ins.ThckCode = (string) sObj.get('Thck_Code__c');
                    ins.Qty =(string) rec.get('Qty_Per_Assembly__c')+'';
                    ins.ScrapFactor =(string) rec.get('Scrap_Factor__c');
                    ins.ComponentScrap =  (string) rec.get('Component_Scrap__c');
                    ins.LineItemNo =(string) rec.get('Leadtime__c');
                    listOfWrapper.add(ins);
                }  else {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart='INLETORING';
                    ins.PartCode = '';
                    ins.PartSeat = '';
                    ins.Qty ='1';
                    ins.ScrapFactor ='';
                    ins.ComponentScrap =  '';
                    ins.LineItemNo ='';
                    listOfWrapper.add(ins);
                }
            }
        }
        if (String.isNotBlank(MCIR)) {
            result resInlet = getInletRingPartNumber();
            if (resInlet.bResult) {
                for(sObject sObj:resInlet.objResultList) {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) sObj.get('InletRingPartNumber__c');
                    //ins.SpringCode=(string) sObj.get('InletRingPartNumber__c');
                    ins.PartCode = (string) sObj.get('Part_Code__c');
                    ins.PartSeat = (string) sObj.get('Seat_Code__c');
                    ins.Thickness = String.ValueOf((decimal) sObj.get('Thickness__c'));
                    ins.ThckCode = (string) sObj.get('Thck_Code__c');
                    ins.Qty =(decimal) sObj.get('Qty_Per_Assembly__c')+'';
                    ins.ScrapFactor =(string) sObj.get('Scrap_Factor__c');
                    ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
                    ins.LineItemNo =(string) sObj.get('Leadtime__c');
                    listOfWrapper.add(ins);
                    break;
                }
            } else if(resInlet.strErrorMessage=='No Data Found') {
                RDStructureWrapper ins=new RDStructureWrapper();
                ins.ComponentPart='INLETRING';
                ins.PartCode = '';
                ins.PartSeat = '';
                ins.Qty ='1';
                ins.ScrapFactor ='';
                ins.ComponentScrap =  '';
                ins.LineItemNo ='';
                listOfWrapper.add(ins);
            }
            //System.debug('@@@ 3857 getInletRingPartNumber -> '+resInlet.bResult);
        }

        if (String.isNotBlank(MCIL) && PTC != 'SLS') {
            result resInlet = getInletLinerPartNumber();
            if (resInlet.bResult) {
                for(sObject sObj:resInlet.objResultList) {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) sObj.get('InletLinerPartNumber__c');
                    //ins.SpringCode=(string) sObj.get('InletLinerPartNumber__c');
                    ins.PartCode = (string) sObj.get('Part_Code__c');
                    ins.PartSeat = (string) sObj.get('Part_Seat__c');
                    ins.Thickness = (decimal) sObj.get('Thickness__c')+'';
                    ins.ThckCode = (string) sObj.get('ThckCode__c');
                    ins.Qty =(decimal) sObj.get('Qty_Per_Assembly__c')+'';
                    ins.ScrapFactor =(decimal) sObj.get('Scrap_Factor__c')+'';
                    ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
                    ins.LineItemNo =(string) sObj.get('Leadtime__c');
                    listOfWrapper.add(ins);
                    break;
                }
            } else if(resInlet.strErrorMessage=='No Data Found') {
                RDStructureWrapper ins=new RDStructureWrapper();
                ins.ComponentPart='INLETLINER';
                ins.PartCode = '';
                ins.PartSeat = '';
                ins.Qty ='1';
                ins.ScrapFactor ='';
                ins.ComponentScrap =  '';
                ins.LineItemNo ='';
                listOfWrapper.add(ins);
            }
        }

        if (String.isNotBlank(MCOR) || (Composite == 'Yes' && STC == 'FS' && TefSealThick > 0 && TefSealThick <= 0.002 && String.isBlank(MCVS) && String.isBlank(MCIR) && strSZC != '0011')) {
            result resInlet = getOutletRingPartNumber();
            if (resInlet.bResult) {
                for(sObject sObj:resInlet.objResultList) {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) sObj.get('OutletRingPartNumber__c');
                    //ins.SpringCode=(string) sObj.get('OutletRingPartNumber__c');
                    ins.PartCode = (string) sObj.get('Part_Code__c');
                    ins.PartSeat = (string) sObj.get('Part_Seat__c');
                    ins.Thickness = String.ValueOf((decimal) sObj.get('Thickness__c'));
                    //ins.Thickness = (string) sObj.get('Thickness__c');
                    ins.ThckCode = (string) sObj.get('ThckCode__c');
                    ins.Qty =(decimal) sObj.get('Qty_Per_Assembly__c')+'';
                    ins.ScrapFactor =(decimal) sObj.get('Scrap_Factor__c')+'';
                    ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c')+'';
                    ins.LineItemNo =(string) sObj.get('Leadtime__c');
                    listOfWrapper.add(ins);
                    break;
                }
            } else if(resInlet.strErrorMessage=='No Data Found') {
                RDStructureWrapper ins=new RDStructureWrapper();
                ins.ComponentPart='OUTLETRING';
                ins.PartCode = '';
                ins.PartSeat = '';
                ins.Qty ='1';
                ins.ScrapFactor ='';
                ins.ComponentScrap =  '';
                ins.LineItemNo ='';
                listOfWrapper.add(ins);
            }
        }

        if ((String.isNotBlank(addIntegralBDI) && addIntegralBDI!='N')) {
            result resInlet = getIntegralBDIPartNumber();
            if (resInlet.bResult) {
                for(sObject sObj:resInlet.objResultList) {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) sObj.get('ModulePN__c');
                    //ins.SpringCode=(string) sObj.get('ModulePN__c');
                    ins.BTC =(string) sObj.get('BTC__c');
                    ins.SubAssyUsed =(string) sObj.get('SubAssyUsed__c');
                    ins.LeadtimeSchedule =  (string) sObj.get('LeadtimeSchedule__c');
                    ins.ROP =(string) sObj.get('ROP__c');
                    ins.OrderDesc1 =(string) sObj.get('OrderDesc1__c');
                    ins.OrderDesc2 =(string) sObj.get('OrderDesc2__c');
                    ins.OrderDesc3 =  (string) sObj.get('OrderDesc3__c');
                    ins.OrderDesc4 =(string) sObj.get('OrderDesc4__c');
                    ins.OrderDesc5 =(string) sObj.get('OrderDesc5__c');
                    ins.OrderDesc6 =(string) sObj.get('OrderDesc6__c');
                    ins.Qty =(decimal) sObj.get('Qty_Per_Assembly__c')+'';
                    ins.ScrapFactor =(decimal) sObj.get('Scrap_Factor__c')+'';
                    ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
                    ins.LineItemNo =(string) sObj.get('Leadtime__c');
                    listOfWrapper.add(ins);
                    break;
                }
            } else if(resInlet.strErrorMessage=='No Data Found') {
                RDStructureWrapper ins=new RDStructureWrapper();
                ins.ComponentPart='INTEGRALBDI';
                ins.PartCode = '';
                ins.PartSeat = '';
                ins.Qty ='1';
                ins.ScrapFactor ='';
                ins.ComponentScrap =  '';
                ins.LineItemNo ='';
                listOfWrapper.add(ins);
            }
        }
        System.debug('PTC'+PTC);
        System.debug('MCSS'+MCSS);
        if ( string.isNotBlank(MCSS) && ((MCSS != '070' && MCSS != '071' && MCSS != '072' && MCSS != '073') ||
                                         ( (Composite == 'Yes' && PTC != 'CPC' && PTC != 'CPS' && PTC != 'CPR' && PTC != 'CFC' && PTC != 'CFR' && PTC != 'CFS' && PTC != 'EV1' && PTC != 'EV2' && PTC != 'EV3' && PTC != 'LI1' &&  PTC != 'LI2' && PTC != 'PCS' && PTC != 'TKS') && isMetalCheck(MCSS) ))/*||
('Add Meatl Seal' == 'Yes')*/ ) {
    System.debug('getMetalSealPartNumber');
    result resInlet = getMetalSealPartNumber();
    if (resInlet.bResult) {
        for(sObject sObj:resInlet.objResultList) {
            RDStructureWrapper ins=new RDStructureWrapper();
            ins.ComponentPart=(string) sObj.get('MetalSealPartNumber__c');
            //ins.SpringCode=(string) sObj.get('MetalSealPartNumber__c');
            ins.PartCode = (string) sObj.get('Part_Code__c');
            ins.PartSeat = (string) sObj.get('PartSeat__c');
            ins.ThckCode = (string) sObj.get('Thck_Code__c');
            ins.Qty =integer.ValueOf((decimal) sObj.get('Qty_Per_Assembly__c'))+'';
            ins.ScrapFactor =(decimal) sObj.get('Scrap_Factor__c')+'';
            ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
            ins.LineItemNo =(string) sObj.get('Leadtime__c');
            listOfWrapper.add(ins);
            break;
        }
    }
}

        if (MCSS == '070' || MCSS == '071' || MCSS == '072' || MCSS == '073') {
            result resInlet = getTeflonSealPartNumber();
            if (resInlet.bResult) {
                for(sObject sObj:resInlet.objResultList) {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) sObj.get('TeflonSealPartNumber__c');
                    //ins.SpringCode=(string) sObj.get('TeflonSealPartNumber__c');
                    ins.PartCode = (string) sObj.get('Part_Code__c');
                    ins.PartSeat = (string) sObj.get('PartSeat__c');
                    ins.ThckCode = (string) sObj.get('ThckCode__c');
                    ins.Qty =(decimal) sObj.get('Qty_Per_Assembly__c')+'';
                    ins.ScrapFactor =(decimal) sObj.get('Scrap_Factor__c')+'';
                    ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
                    ins.LineItemNo =(string) sObj.get('Leadtime__c');
                    listOfWrapper.add(ins);
                    //break;
                }
            } else if(resInlet.strErrorMessage=='No Data Found') {
                RDStructureWrapper ins=new RDStructureWrapper();
                ins.ComponentPart='TEFLONSEAL';
                ins.PartCode = '';
                ins.PartSeat = '';
                ins.Qty ='1';
                ins.ScrapFactor ='';
                ins.ComponentScrap =  '';
                ins.LineItemNo ='';
                listOfWrapper.add(ins);
            }
        }

        if (String.isNotBlank(MCGD)) {
            result resInlet = getGirdlePartNumber();
            if (resInlet.bResult) {
                for(sObject sObj:resInlet.objResultList) {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) sObj.get('GirdlePartNumber__c');
                    //ins.SpringCode=(string) sObj.get('GirdlePartNumber__c');
                    ins.PartCode = (string) sObj.get('Part_Code__c');
                    ins.PartSeat = (string) sObj.get('PartSeat__c');
                    ins.Thickness = (decimal) sObj.get('Thickness__c')+'';
                    ins.ThckCode = (string) sObj.get('ThckCode__c');
                    ins.Qty =(decimal) sObj.get('Qty_Per_Assembly__c')+'';
                    ins.ScrapFactor =(decimal) sObj.get('Scrap_Factor__c')+'';
                    ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
                    ins.LineItemNo =(string) sObj.get('Leadtime__c');
                    listOfWrapper.add(ins);
                    break;
                }
            } else if(resInlet.strErrorMessage=='No Data Found') {
                RDStructureWrapper ins=new RDStructureWrapper();
                ins.ComponentPart='GIRDLE';
                ins.PartCode = '';
                ins.PartSeat = '';
                ins.Qty ='1';
                ins.ScrapFactor ='';
                ins.ComponentScrap =  '';
                ins.LineItemNo ='';
                listOfWrapper.add(ins);
            }
        }

        if (String.isNotBlank(MCIG) ||
            (Composite == 'Yes' && STC == 'FS' && TefSealThick <= 0.002 && TefSealThick> 0 && String.isBlank(MCVS)  && String.isBlank(MCIR)) ||
            (Composite == 'Yes' && STC == 'SF' && AssyThick< 0.030)||
            (PTC != 'RE2' || PTC == 'GFS' || PTC == 'SLS')) {
                result resInlet=getInletGasketPartNumber();
                if (resInlet.bResult) {
                    for(sObject sObj:resInlet.objResultList) {
                        RDStructureWrapper ins=new RDStructureWrapper();
                        ins.ComponentPart=(string) sObj.get('InletGasketPartNumber__c');
                        //ins.SpringCode=(string) sObj.get('InletGasketPartNumber__c');
                        ins.PartCode = (string) sObj.get('Part_Code__c');
                        ins.PartSeat = (string) sObj.get('Part_Seat__c');
                        ins.Thickness = (decimal) sObj.get('Thickness__c')+'';
                        ins.ThckCode = (string) sObj.get('Thck_Code__c')+'';
                        ins.Qty =(string) sObj.get('Qty_Per_Assembly__c')+'';
                        ins.ScrapFactor =(string) sObj.get('Scrap_Factor__c')+'';
                        ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
                        ins.LineItemNo =(string) sObj.get('Leadtime__c');
                        listOfWrapper.add(ins);
                        break;
                    }
                } else if(resInlet.strErrorMessage=='No Data Found') {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart='INLETGASKET';
                    ins.PartCode = '';
                    ins.PartSeat = '';
                    ins.Qty ='1';
                    ins.ScrapFactor ='';
                    ins.ComponentScrap =  '';
                    ins.LineItemNo ='';
                    listOfWrapper.add(ins);
                }
            }

        if (String.isNotBlank(MCDT)) {
            result resInlet=getTopSectionPartNumber();
            if (resInlet.bResult) {
                for(sObject sObj:resInlet.objResultList) {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) sObj.get('TopSectionPartNumber__c');
                    //ins.SpringCode=(string) sObj.get('TopSectionPartNumber__c');
                    ins.PartCode = (string) sObj.get('Part_Code__c');
                    ins.PartSeat = (string) sObj.get('Part_Seat__c');
                    ins.ThckCode = (string) sObj.get('ThckCode__c');
                    ins.Qty =integer.ValueOf((decimal) sObj.get('Qty_Per_Assembly__c'))+'';
                    ins.ScrapFactor =(decimal) sObj.get('Scrap_Factor__c')+'';
                    ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
                    ins.LineItemNo =(string) sObj.get('Leadtime__c');
                    listOfWrapper.add(ins);
                    break;
                }
            } else if(resInlet.strErrorMessage=='No Data Found') {
                RDStructureWrapper ins=new RDStructureWrapper();
                ins.ComponentPart='TOPSECTION';
                ins.PartCode = '';
                ins.PartSeat = '';
                ins.Qty ='1';
                ins.ScrapFactor ='';
                ins.ComponentScrap =  '';
                ins.LineItemNo ='';
                listOfWrapper.add(ins);
            }
        }

        if (string.isNotBlank(MCOG) &&
            (PTC != 'RE2' && PTC != 'GFS' && PTC != 'SLS')) {
                result resInlet = getOutletGasketPartNumber();
                if (resInlet.bResult) {
                    for(sObject sObj:resInlet.objResultList) {
                        RDStructureWrapper ins=new RDStructureWrapper();
                        ins.ComponentPart=(string) sObj.get('OutletGasketPartNumber__c');
                        //ins.SpringCode=(string) sObj.get('OutletGasketPartNumber__c');
                        ins.PartCode = (string) sObj.get('Part_Code__c');
                        ins.PartSeat = (string) sObj.get('Part_Seat__c');
                        ins.Thickness = (decimal) sObj.get('Thickness__c')+'';
                        ins.ThckCode = (string) sObj.get('Thck_Code__c');
                        ins.Qty =(string) sObj.get('Qty_Per_Assembly__c')+'';
                        ins.ScrapFactor =(string) sObj.get('Scrap_Factor__c')+'';
                        ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
                        ins.LineItemNo =(string) sObj.get('Leadtime__c');
                        listOfWrapper.add(ins);
                        break;
                    }
                } else if(resInlet.strErrorMessage=='No Data Found') {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart='OUTLETGASKET';
                    ins.PartCode = '';
                    ins.PartSeat = '';
                    ins.Qty ='1';
                    ins.ScrapFactor ='';
                    ins.ComponentScrap =  '';
                    ins.LineItemNo ='';
                    listOfWrapper.add(ins);
                }
            }

        if (String.isNotBlank(MCHS)) {
            result resInlet=getHandlingSupportPartNumber();
            if (resInlet.bResult) {
                for(sObject sObj:resInlet.objResultList) {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) sObj.get('HandlingSupportPartNumber__c');
                    //ins.SpringCode=(string) sObj.get('HandlingSupportPartNumber__c');
                    ins.PartCode = (string) sObj.get('Part_Code__c');
                    ins.PartSeat = (String) sObj.get('Part_Seat__c');
                    ins.Thickness = (decimal) sObj.get('Thickness__c')+'';
                    ins.ThckCode = (string) sObj.get('Thck_Code__c');
                    ins.Qty =(Decimal) sObj.get('Qty_Per_Assembly__c')+'';
                    ins.ScrapFactor =(Decimal) sObj.get('Scrap_Factor__c')+'';
                    ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
                    ins.LineItemNo =(string) sObj.get('Leadtime__c');
                    listOfWrapper.add(ins);
                    break;
                }
            } else if(resInlet.strErrorMessage=='No Data Found') {
                RDStructureWrapper ins=new RDStructureWrapper();
                ins.ComponentPart='HANDLINGSUPPORT';
                ins.PartCode = '';
                ins.PartSeat = '';
                ins.Qty ='1';
                ins.ScrapFactor ='';
                ins.ComponentScrap =  '';
                ins.LineItemNo ='';
                listOfWrapper.add(ins);
            }
        }

        if (String.isNotBlank(MCVS)) {
            result resInlet=getVacuumSupportPartNumber();
            if (resInlet.bResult) {
                for(sObject sObj:resInlet.objResultList) {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) sObj.get('VacuumSupportPartNumber__c');
                    //ins.SpringCode=(string) sObj.get('VacuumSupportPartNumber__c');
                    ins.PartCode = (string) sObj.get('Part_Code__c');
                    ins.PartSeat = (string) sObj.get('PartSeat__c');
                    ins.Thickness = (decimal) sObj.get('Thickness__c')+ '';
                    ins.ThckCode = (string) sObj.get('ThckCode__c');
                    ins.Qty =(Decimal) sObj.get('Qty_Per_Assembly__c') + '';
                    ins.ScrapFactor =(decimal) sObj.get('Scrap_Factor__c') + '';
                    ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
                    ins.LineItemNo =(string) sObj.get('Leadtime__c');
                    listOfWrapper.add(ins);
                    break;
                }
            } else if(resInlet.strErrorMessage=='No Data Found') {
                RDStructureWrapper ins=new RDStructureWrapper();
                ins.ComponentPart='VACUUMSUPPORT';
                ins.PartCode = '';
                ins.PartSeat = '';
                ins.Qty ='1';
                ins.ScrapFactor ='';
                ins.ComponentScrap =  '';
                ins.LineItemNo ='';
                listOfWrapper.add(ins);
            }
        }

        if (String.isNotBlank(MCOL)) {
            result resInlet=getOutletLinerPartNumber();
            if (resInlet.bResult) {
                for(sObject sObj:resInlet.objResultList) {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) sObj.get('OutletLinerPartNumber__c');
                    //ins.SpringCode=(string) sObj.get('OutletRingPartNumber__c');
                    ins.PartCode = (string) sObj.get('Part_Code__c');
                    ins.PartSeat = (string) sObj.get('PartSeat__c');
                    ins.Thickness = (string) sObj.get('Thickness__c')+'';
                    ins.ThckCode = (string) sObj.get('ThckCode__c');
                    ins.Qty =(string) sObj.get('Qty_Per_Assembly__c')+'';
                    ins.ScrapFactor =(string) sObj.get('Scrap_Factor__c')+'';
                    ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
                    ins.LineItemNo =(string) sObj.get('Leadtime__c');
                    listOfWrapper.add(ins);
                    break;
                }
            } else if(resInlet.strErrorMessage=='No Data Found') {
                RDStructureWrapper ins=new RDStructureWrapper();
                ins.ComponentPart='OUTLETLINER';
                ins.PartCode = '';
                ins.PartSeat = '';
                ins.Qty ='1';
                ins.ScrapFactor ='';
                ins.ComponentScrap =  '';
                ins.LineItemNo ='';
                listOfWrapper.add(ins);
            }
        }

        if (String.isNotBlank(MCDD)) {
            result resInlet=getDiscPartNumber();
            if (resInlet.bResult) {
                for(sObject sObj:resInlet.objResultList) {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) sObj.get('DiscPartNumber__c');
                    //ins.SpringCode=(string) sObj.get('DiscPartNumber__c');
                    ins.PartCode = (string) sObj.get('Part_Code__c');
                    ins.PartSeat = (string) sObj.get('Part_Seat__c');
                    ins.ThckCode = (string) sObj.get('Thck_Code__c');
                    ins.Qty =Integer.ValueOf((decimal) sObj.get('Qty_Per_Assembly__c'))+'';
                    ins.ScrapFactor =(decimal) sObj.get('Scrap_Factor__c')+'';
                    ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
                    ins.LineItemNo =(string) sObj.get('Leadtime__c');
                    listOfWrapper.add(ins);
                    break;
                }
            } else if(resInlet.strErrorMessage=='No Data Found') {
                RDStructureWrapper ins=new RDStructureWrapper();
                ins.ComponentPart='DISCCOMPONET';
                ins.PartCode = '';
                ins.PartSeat = '';
                ins.Qty ='1';
                ins.ScrapFactor ='';
                ins.ComponentScrap =  '';
                ins.LineItemNo ='';
                listOfWrapper.add(ins);
            }
        }

        if (String.isNotBlank(MCAR)) {
            result resInlet=getArcuateRingPartNumber();
            if (resInlet.bResult) {
                for(sObject sObj:resInlet.objResultList) {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) sObj.get('ArcuateRingPartNumber__c');
                    //ins.SpringCode=(string) sObj.get('ArcuateRingPartNumber__c');
                    ins.PartCode = (string) sObj.get('Part_Code__c');
                    ins.PartSeat = (string) sObj.get('Part_Seat__c');
                    ins.Thickness = (decimal) sObj.get('Thickness__c')+'';
                    ins.ThckCode = (string) sObj.get('ThckCode__c');
                    ins.Qty =(decimal) sObj.get('Qty_Per_Assembly__c')+'';
                    ins.ScrapFactor =(decimal) sObj.get('Scrap_Factor__c')+'';
                    ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
                    ins.LineItemNo =(string) sObj.get('Leadtime__c');
                    listOfWrapper.add(ins);
                    break;
                }
            } else if(resInlet.strErrorMessage=='No Data Found') {
                RDStructureWrapper ins=new RDStructureWrapper();
                ins.ComponentPart='ARCUATERING';
                ins.PartCode = '';
                ins.PartSeat = '';
                ins.Qty ='1';
                ins.ScrapFactor ='';
                ins.ComponentScrap =  '';
                ins.LineItemNo ='';
                listOfWrapper.add(ins);
            }
        }

        if (MCGD!= '070' && MCGD!= '071' && MCGD!= '072' && MCGD!= '073' && String.isNotBlank(MCGD)) {
            result resInlet=getGirdleCoverPartNumber();
            if (resInlet.bResult) {
                for(sObject sObj:resInlet.objResultList) {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) sObj.get('Girdle_Cover_Part_Number__c');
                    //ins.SpringCode=(string) sObj.get('Girdle_Cover_Part_Number__c');
                    ins.PartCode = (string) sObj.get('Part_Code__c');
                    ins.PartSeat = (string) sObj.get('PartSeat__c');
                    ins.Thickness = (decimal) sObj.get('Thickness__c')+'';
                    ins.ThckCode = (string) sObj.get('Thick_Code__c');
                    ins.Qty =integer.ValueOf((decimal) sObj.get('Qty_Per_Assembly__c'))+'';
                    ins.ScrapFactor =(decimal) sObj.get('Scrap_Factor__c')+'';
                    ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
                    ins.LineItemNo =(string) sObj.get('Leadtime__c');
                    listOfWrapper.add(ins);
                    break;
                }
            } else if(resInlet.strErrorMessage=='No Data Found') {
                RDStructureWrapper ins=new RDStructureWrapper();
                ins.ComponentPart='GIRDLECOVER';
                ins.PartCode = '';
                ins.PartSeat = '';
                ins.Qty ='1';
                ins.ScrapFactor ='';
                ins.ComponentScrap =  '';
                ins.LineItemNo ='';
                listOfWrapper.add(ins);
            }
        }

        if (PTC == 'RVT' || PTC == 'SRV') {
            result resInlet=getRVIGasketPartNumber();
            if (resInlet.bResult) {
                for(sObject sObj:resInlet.objResultList) {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) sObj.get('RVIGasketPartNumber__c');
                    //ins.SpringCode=(string) sObj.get('RVIGasketPartNumber__c');
                    ins.Thickness = (decimal) sObj.get('Thickness__c')+'';
                    ins.Qty =(decimal) sObj.get('Qty_Per_Assembly__c')+'';
                    ins.ScrapFactor =(decimal) sObj.get('Scrap_Factor__c')+'';
                    ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
                    ins.LineItemNo =(string) sObj.get('Leadtime__c');
                    listOfWrapper.add(ins);
                    break;
                }
            } else if(resInlet.strErrorMessage=='No Data Found') {
                RDStructureWrapper ins=new RDStructureWrapper();
                ins.ComponentPart='RVIGASKET';
                ins.PartCode = '';
                ins.PartSeat = '';
                ins.Qty ='1';
                ins.ScrapFactor ='';
                ins.ComponentScrap =  '';
                ins.LineItemNo ='';
                listOfWrapper.add(ins);
            }
        }

        if ((Composite != 'Yes' && MetalSealThick > 0.002) &&
            SlotCoverStripThick >0) {
                result resInlet=getSlotCoverStripPartNumber();
                if (resInlet.bResult) {
                    for(sObject sObj:resInlet.objResultList) {
                        RDStructureWrapper ins=new RDStructureWrapper();
                        ins.ComponentPart=(string) sObj.get('SlotCoverStripsPartNumber__c');
                        //ins.SpringCode=(string) sObj.get('RVIGasketPartNumber__c');
                        ins.PartCode = (string) sObj.get('Part_Code__c');
                        ins.PartSeat = (string) sObj.get('Part_Seat__c');
                        ins.ThckCode = (string) sObj.get('Thck_Code__c');
                        ins.Qty =integer.valueOf((decimal) sObj.get('Qty_Per_Assembly__c'))+'';
                        ins.ScrapFactor =(decimal) sObj.get('Scrap_Factor__c')+'';
                        ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
                        ins.LineItemNo =(string) sObj.get('Leadtime__c');
                        listOfWrapper.add(ins);
                        break;
                    }
                } else if(resInlet.strErrorMessage=='No Data Found') {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart='SLOTCOVERSTRIPS';
                    ins.PartCode = '';
                    ins.PartSeat = '';
                    ins.Qty ='1';
                    ins.ScrapFactor ='';
                    ins.ComponentScrap =  '';
                    ins.LineItemNo ='';
                    listOfWrapper.add(ins);
                }
            }
        boolean isSlotCoverValid=false;
        System.debug('isSlotCoverValid MCSM->'+MCSM);
        System.debug('isSlotCoverValid MetalSealThick->'+MetalSealThick);
        if(Composite == 'Yes' && currentRD.Relief_Type__c != 'Pressure & Vacuum Relief' && PTC!='TKS') {
            if(strSZC=='0011'|| (string.isNotBlank(MCSM) && MetalSealThick>0.002) || (SizeValue>=8 && MetalSealThick<=0.002 && MCSM!='001' && MCSM!='012')) {
                isSlotCoverValid=false;
                System.debug('isSlotCoverValid'+isSlotCoverValid);
            } else {
                isSlotCoverValid=true;
            }
        }
        System.debug('isSlotCoverValid SlotCover1ThickStructure'+SlotCover1ThickStructure);
        // if (SlotCover1ThickStructure>0) {
        //     isSlotCoverValid=true;
        // } else {
        //     isSlotCoverValid=false;
        // }
        system.debug('isSlotCoverValid'+isSlotCoverValid);
        if (isSlotCoverValid || SlotCover1ThickStructure>0 ) {// &&(PTC == 'PAS' || PTC == 'CAL')
            result resInlet=getSlotCoverPartNumber();
            if (resInlet.bResult) {
                for(sObject sObj:resInlet.objResultList) {
                    RDStructureWrapper ins=new RDStructureWrapper();
                    ins.ComponentPart=(string) sObj.get('Slot_Cover_Part_Number_1__c');
                    //ins.SpringCode=(string) sObj.get('RVIGasketPartNumber__c');
                    ins.PartCode = (string) sObj.get('Part_Code__c');
                    ins.PartSeat = (string) sObj.get('Part_Seat__c');
                    ins.ThckCode = (string) sObj.get('Thck_Code_1__c');
                    ins.Qty =integer.valueOf((decimal) sObj.get('Qty_Per_Assembly__c'))+'';
                    ins.ScrapFactor =(decimal) sObj.get('Scrap_Factor__c')+'';
                    ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
                    ins.LineItemNo =(string) sObj.get('Leadtime__c');
                    listOfWrapper.add(ins);
                    break;
                }
            } else if(resInlet.strErrorMessage=='No Data Found') {
                RDStructureWrapper ins=new RDStructureWrapper();
                ins.ComponentPart='SLOTCOVER';
                ins.PartCode = '';
                ins.PartSeat = '';
                ins.Qty ='1';
                ins.ScrapFactor ='';
                ins.ComponentScrap =  '';
                ins.LineItemNo ='';
                listOfWrapper.add(ins);
            }
        }

        //    if (addIntegralBDI!=NULL) {
        //         result resInlet=getProDoc();
        //         if (resInlet.bResult) {
        //             for(sObject sObj:resInlet.objResultList) {
        //                 RDStructureWrapper ins=new RDStructureWrapper();
        //                 ins.ComponentPart=(string) sObj.get('HolderComponentPartNumber__c');
        //                 //ins.SpringCode=(string) sObj.get('RVIGasketPartNumber__c');
        //                 ins.Qty =(string) sObj.get('Qty_Per_Assembly__c');
        //                 ins.ScrapFactor =(string) sObj.get('Scrap_Factor__c');
        //                 ins.ComponentScrap =  (string) sObj.get('Component_Scrap__c');
        //                 ins.LineItemNo =(string) sObj.get('Leadtime__c');
        //                 listOfWrapper.add(ins);
        //                 break;
        //             }
        //         }
        //     }
        System.debug('Components List: ' + listOfWrapper.size());
        System.debug('listOfWrapper: ' + listOfWrapper);
        strData=listOfWrapper;
        return listOfWrapper;
    }
    public List<Disc_Information__c> rdDscInfoLst{set;get;}
    public List<Disc_Information__c> rdDisInfoList() {
        if(RGEMIN==null)
            RGEMIN=0;
        System.debug('PTC: ' + PTC);
        System.debug('strSZC: ' + strSZC);
        System.debug('RGEMIN: ' + Double.valueOf(RGEMIN));
        System.debug('RTTMDF: ' + RTTMDF);
        // System.debug('RTTMDF: ' + RTTMDF);
        string query='select SealMatl__c,SlotCovThck__c,SCStripThck__c,SealThck__c from Disc_Information__c where PTC__c=\''+PTC+'\' AND SZC__c=\''+strSZC+'\'  AND MfgRngLL__c<='+Double.valueOf(RGEMIN)+' AND MfgRngUL__c>'+Double.valueOf(RGEMIN)+' AND TempLL__c<='+RTTMDF+' AND TempUL__c>'+RTTMDF;
        system.debug('query'+query);
        List<Disc_Information__c> rd=database.query(query);
        return rd;
    }
    public List<RD_tblPosCalRating__c> rdPosBaseList() {
        string query;
        if(PTC=='CAL') {
            query='select NRSC2Thck__c,MinGrdlRatedUL__c,MinGrdlRatedLL__c,MinTSMfgRngLL__c,MinTSMfgRngUL__c,SC2Thck__c,NRSC1Thck__c,SC1Thck__c,SealThck__c from RD_tblPosCalRating__c where PTC__c=\''+PTC+'\' and SZC__c=\''+strSZC+'\' and TempLL__c<'+RTTMDF+' AND TempUL__c>='+RTTMDF;
        } else {
            query='select NRSC2Thck__c,MinGrdlRatedUL__c,MinGrdlRatedLL__c,MinTSMfgRngLL__c,MinTSMfgRngUL__c,SC2Thck__c,NRSC1Thck__c,SC1Thck__c,SealThck__c from RD_tblPosCalRating__c where PTC__c=\''+PTC+'\' and SZC__c=\''+strSZC+'\' and TempLL__c<='+RTTMDF+' AND TempUL__c>'+RTTMDF;
        }

        List<RD_tblPosCalRating__c> rd=database.query(query);
        return rd;
    }
    public List<RD_tblPosCalRating__c> rdPosLst{set;get;}
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
    public Result getDiscLeadTimeProduct() {
        result Disc_LeadTime_ProductResult=new result();
        if(PTC != null && SizeValue != null && STC != null && QTY != null )
        {
            List<String> selectCols=new List<String>{'LeadtimeSchedule__c'};
                String strPTC='\''+PTC+'\'';
            String strSTC='\''+STC+'\'';
            String strSZC1='\''+strSZC+'\'';
            String strQTY=''+QTY+'';
            //String strQTYUL='\''+QTY+'\'';
            List<String> whereCols=new List<String>{'PTC__c','SZC__c','STC__c','QTYLL__c','QTYUL__c'};
                List<String> whereVals=new List<String>{strPTC,strSZC1,strSTC,strQTY,strQTY};
                    List<String> whereComps=new List<String>{'=','=','=','<=','>'};
                        List<String> extraChars=new List<String>{'','','','',''};
                            Disc_LeadTime_ProductResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Disc_LeadTime_Product__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(Disc_LeadTime_ProductResult.bResult)
            {
                system.debug('Lead Time Product:' +Disc_LeadTime_ProductResult.objResultList );

            }
        }
        return Disc_LeadTime_ProductResult;
    }
    public Result getDiscLeadTimeOptions() {
        result Disc_LeadTime_OptionsResult=new result();
        System.debug('CHINAMFG: ' + CHINAMFG);
        System.debug('ADMERK: ' + ADMERK);
        System.debug('RPVM084: ' + RPVM084);
        System.debug('PMI: ' + PMI);
        System.debug('ELECTROPOL: ' + ELECTROPOL);
        System.debug('SURFFINISH: ' + SURFFINISH);
        if(CHINAMFG != null && ADMERK != null&& RPVM084 != null&& PMI != null && ELECTROPOL !=null && SURFFINISH !=null)
        {
            List<String> selectCols=new List<String>{'Schedule__c'};
                String strCHINAMFG='\''+CHINAMFG+'\'';
            String strADMERK='\''+ADMERK+'\'';
            String strRPVM084='\''+RPVM084+'\'';
            String strPMI='\''+PMI+'\'';
            String strELECTROPOL='\''+ELECTROPOL+'\'';
            String strSURFFINISH='\''+SURFFINISH+'\'';
            List<String> whereCols=new List<String>{'CHINAMFG__c','ADMERK__c','RPVM084__c','PMI__c','ELECTROPOL__c','SURFFINISH__c'};
                List<String> whereVals=new List<String>{strCHINAMFG,strADMERK,strRPVM084,strPMI,strELECTROPOL,strSURFFINISH};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','='};
                        List<String> extraChars=new List<String>{'','','','','',''};
                            Disc_LeadTime_OptionsResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Disc_LeadTime_Options__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(Disc_LeadTime_OptionsResult.bResult)
            {
                system.debug('Lead Time Options:' +Disc_LeadTime_OptionsResult.objResultList );

            }
        }
        return Disc_LeadTime_OptionsResult;
    }
    public List<RDStructureWrapper> strData{set;get;}
    public result getRDLeadTime() {
        result leadTime=new result();
        result resLeadProduct=getDiscLeadTimeProduct();
        result resresLeadOpt=getDiscLeadTimeOptions();
        Set<String> listSchedule=new Set<String>();
        if (resLeadProduct.bResult)
            listSchedule.add('\''+(string) resLeadProduct.objResultList[0].get('LeadtimeSchedule__c')+'\'');
        if (resresLeadOpt.bResult)
            listSchedule.add('\''+(string) resresLeadOpt.objResultList[0].get('Schedule__c')+'\'');
        String separator = ', ';
        String schedules=String.join(new List<String>(listSchedule), separator);
        if(strData!=null) {
            for(RDStructureWrapper lt:strData) {
                listSchedule.add('\''+lt.LineItemNo+'\'');
            }
        } else {

        }
        list<string> strL=new List<String>(listSchedule);
        System.debug('listSchedule: ' + strL);
        System.debug('Select X10__c,X20__c,X30__c,X40__c,Schedule__c from GlobalLeadTime__c Where QtyLL__c<='+QTY+' AND QtyUL__c>'+QTY+' AND Schedule__c IN (:strL) ' );
        // List<ApexPages.Message> messages = new List<ApexPages.Message>();
        // if(QTY == Null)
        //     return messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Quantity: Please enter a positive integer value greater than 0'));
        GlobalLeadTime__c[] leadList=Database.query('Select X10__c,X20__c,X30__c,X40__c,Schedule__c from GlobalLeadTime__c Where QtyLL__c<='+QTY+' AND QtyUL__c>'+QTY+' AND Schedule__c IN '+strL);
        System.debug('leadList: ' + leadList);
        System.debug('leadList Size: ' + leadList.size());
        Map<String, GlobalLeadTime__c> myMap = new Map<String, GlobalLeadTime__c>();
        for(GlobalLeadTime__c objCS : leadList) {
            if(!myMap.containsKey(objCS.Schedule__c))
                myMap.put(objCS.Schedule__c, objCS);
        }
        System.debug('myMap: ' + myMap);
        RD_Outputs__c[] rdOutputList=[Select Base_Lead_Time_GP__c,Base_Lead_Time_GCI__c,Base_Lead_Time_CDC__c,Base_Lead_Time_40__c,
                                      Adder_Lead_Time_GP__c,Adder_Lead_Time_GCI__c,Adder_Lead_Time_CDC__c,Adder_Lead_Time_40__c,
                                      Comp_Lead_Time_GP__c,Comp_Lead_Time_GCI__c,Comp_Lead_Time_CDC__c,Comp_Lead_Time_40__c,
                                      Total_Lead_Time_CDC__c,Total_Lead_Time_GP__c,Total_Lead_Time_GCI__c,Total_Lead_Time_GP_ORD__c,ORV020__c,ORP020__c,ORP025__c,ORV025__c,
                                      Total_Lead_Time_CDC_ORD__c,Total_Lead_Time_GCI_ORD__c,Total_Lead_Time_40_ORD__c
                                      ,ORP010__c,ORP015__c,ORP027__c,ORV010__c,ORV015__c,ORV027__c, SRV__c ,SRP__c
                                      FROM RD_Outputs__c WHERE RD_Outputs_Relation_Field__c=:currentRD.Id];
        RD_Outputs__c rdOutput=new RD_Outputs__c();
        if(!rdOutputList.isEmpty())
            rdOutput=rdOutputList[0];
        if (resLeadProduct.bResult) {
            GlobalLeadTime__c lT=myMap.get((string) resLeadProduct.objResultList[0].get('LeadtimeSchedule__c'));
            System.debug('lT: ' + lT);
            if(resLeadProduct.objResultList.size()>0) {
                if(lT.X10__c!=null)
                    rdOutput.Base_Lead_Time_GP__c=lT.X10__c;
                if(lT.X20__c!=null)
                    rdOutput.Base_Lead_Time_GCI__c=lT.X20__c;
                if(lT.X30__c!=null)
                    rdOutput.Base_Lead_Time_CDC__c=lT.X30__c;
                if(lT.X40__c!=null)
                    rdOutput.Base_Lead_Time_40__c=lT.X40__c;
            } else {
                rdOutput.Base_Lead_Time_GP__c=4995;
                rdOutput.Base_Lead_Time_GCI__c=7777;
                rdOutput.Base_Lead_Time_CDC__c=7777;
                rdOutput.Base_Lead_Time_40__c=7777;

            }
        } else if(resLeadProduct.strErrorMessage=='No Data Found') {
            rdOutput.Base_Lead_Time_GP__c=4995;
            rdOutput.Base_Lead_Time_GCI__c=7777;
            rdOutput.Base_Lead_Time_CDC__c=7777;
            rdOutput.Base_Lead_Time_40__c=7777;
        }
        if (resresLeadOpt.bResult) {
            GlobalLeadTime__c lT1=myMap.get((string) resresLeadOpt.objResultList[0].get('Schedule__c'));
            System.debug('lT1: ' + lT1);
            if(resresLeadOpt.objResultList.size()>0) {
                if(lT1.X10__c!=null)
                    rdOutput.Adder_Lead_Time_GP__c=lT1.X10__c;
                if(lT1.X20__c!=null)
                    rdOutput.Adder_Lead_Time_GCI__c=lT1.X20__c;
                if(lT1.X30__c!=null)
                    rdOutput.Adder_Lead_Time_CDC__c=lT1.X30__c;
                if(lT1.X40__c!=null)
                    rdOutput.Adder_Lead_Time_40__c=lT1.X40__c;
            } else {
                rdOutput.Adder_Lead_Time_GP__c=4995;
                rdOutput.Adder_Lead_Time_GCI__c=7777;
                rdOutput.Adder_Lead_Time_CDC__c=7777;
                rdOutput.Adder_Lead_Time_40__c=7777;
            }
        } else if(resresLeadOpt.strErrorMessage=='No Data Found') {
            rdOutput.Adder_Lead_Time_GP__c=4995;
            rdOutput.Adder_Lead_Time_GCI__c=7777;
            rdOutput.Adder_Lead_Time_CDC__c=7777;
            rdOutput.Adder_Lead_Time_40__c=7777;
        }
        integer intMax10=0;
        integer intMax20=0;
        integer intMax30=0;
        integer intMax40=0;
        for(RDStructureWrapper lt3:strData) {
            GlobalLeadTime__c lT2=myMap.get(lt3.LineItemNo);
            System.debug('lt3: ' + lt3.LineItemNo);
            System.debug('lT2: ' + lT2);
            if(lT2!=null) {
                if(intMax10<lT2.X10__c)
                    intMax10=integer.valueOf(lT2.X10__c);
                if(intMax20<lT2.X20__c)
                    intMax20=integer.valueOf(lT2.X20__c);
                if(intMax30<lT2.X30__c)
                    intMax30=integer.valueOf(lT2.X30__c);
                if(intMax40<lT2.X40__c)
                    intMax40=integer.valueOf(lT2.X40__c);
            }

        }
        rdOutput.Comp_Lead_Time_GP__c=intMax10;
        rdOutput.Comp_Lead_Time_CDC__c=intMax30;
        rdOutput.Comp_Lead_Time_GCI__c=intMax20;
        rdOutput.Comp_Lead_Time_40__c=intMax40;

        if(rdOutput.Base_Lead_Time_GP__c==7777||rdOutput.Adder_Lead_Time_GP__c==7777||rdOutput.Comp_Lead_Time_GP__c==7777 ) {
            rdOutput.Total_Lead_Time_GP__c=7777;
        } else if (rdOutput.Base_Lead_Time_GP__c==4995||rdOutput.Adder_Lead_Time_GP__c==4995||rdOutput.Comp_Lead_Time_GP__c==4995) {
            rdOutput.Total_Lead_Time_GP__c=4995;
        }
        else {
            if(rdOutput.Base_Lead_Time_GP__c == null ){
                rdOutput.Base_Lead_Time_GP__c = 0;
            }
            if(rdOutput.Adder_Lead_Time_GP__c == null ){
                rdOutput.Adder_Lead_Time_GP__c = 0;
            }
            if(rdOutput.Comp_Lead_Time_GP__c == null ){
                rdOutput.Comp_Lead_Time_GP__c = 0;
            }
            rdOutput.Total_Lead_Time_GP__c=rdOutput.Base_Lead_Time_GP__c +rdOutput.Adder_Lead_Time_GP__c +rdOutput.Comp_Lead_Time_GP__c;
            System.debug('rdOutput.Total_Lead_Time_GP__c'+rdOutput.Total_Lead_Time_GP__c);
        }
        //
        if(rdOutput.Base_Lead_Time_GCI__c==7777||rdOutput.Adder_Lead_Time_GCI__c==7777||rdOutput.Comp_Lead_Time_GCI__c==7777 ) {
            rdOutput.Total_Lead_Time_GCI__c=7777;
        } else if (rdOutput.Base_Lead_Time_GCI__c==4995||rdOutput.Adder_Lead_Time_GCI__c==4995||rdOutput.Comp_Lead_Time_GP__c==4995) {
            rdOutput.Total_Lead_Time_GCI__c=4995;
        }
        else {
            rdOutput.Total_Lead_Time_GCI__c=rdOutput.Base_Lead_Time_GCI__c==null?0:rdOutput.Base_Lead_Time_GCI__c+rdOutput.Adder_Lead_Time_GCI__c==null?0:rdOutput.Adder_Lead_Time_GCI__c+rdOutput.Comp_Lead_Time_GCI__c==null?0:rdOutput.Comp_Lead_Time_GCI__c;
        }

        //
        if(rdOutput.Base_Lead_Time_CDC__c==7777||rdOutput.Adder_Lead_Time_CDC__c==7777||rdOutput.Comp_Lead_Time_CDC__c==7777 ) {
            rdOutput.Total_Lead_Time_CDC__c=7777;
        } else if (rdOutput.Base_Lead_Time_CDC__c==4995||rdOutput.Adder_Lead_Time_CDC__c==4995||rdOutput.Comp_Lead_Time_CDC__c==4995) {
            rdOutput.Total_Lead_Time_CDC__c=4995;
        }
        else {
            rdOutput.Total_Lead_Time_CDC__c=rdOutput.Base_Lead_Time_CDC__c==null?0:rdOutput.Base_Lead_Time_CDC__c+rdOutput.Adder_Lead_Time_CDC__c==null?0:rdOutput.Adder_Lead_Time_CDC__c+rdOutput.Comp_Lead_Time_CDC__c==null?0:rdOutput.Comp_Lead_Time_CDC__c;
        }
        //
        if(rdOutput.Base_Lead_Time_40__c==7777||rdOutput.Adder_Lead_Time_40__c==7777||rdOutput.Comp_Lead_Time_40__c==7777 ) {
            rdOutput.Total_Lead_Time_40__c=7777;
        } else if (rdOutput.Base_Lead_Time_40__c==4995||rdOutput.Adder_Lead_Time_40__c==4995||rdOutput.Comp_Lead_Time_40__c==4995) {
            rdOutput.Total_Lead_Time_40__c=4995;
        }
        else {
            rdOutput.Total_Lead_Time_40__c=rdOutput.Base_Lead_Time_40__c==null?0:rdOutput.Base_Lead_Time_40__c+rdOutput.Adder_Lead_Time_40__c==null?0:rdOutput.Adder_Lead_Time_40__c+rdOutput.Comp_Lead_Time_40__c==null?0:rdOutput.Comp_Lead_Time_40__c;
        }


        rdOutput.Total_Lead_Time_40_ORD__c=rdOutput.Total_Lead_Time_40__c;
        rdOutput.Total_Lead_Time_CDC_ORD__c=rdOutput.Total_Lead_Time_CDC__c;
        rdOutput.Total_Lead_Time_GCI_ORD__c=rdOutput.Total_Lead_Time_GCI__c;
        rdOutput.Total_Lead_Time_GP_ORD__c=rdOutput.Total_Lead_Time_GP__c;
        system.debug('rdOutput:'+rdOutput.Total_Lead_Time_40_ORD__c);
        system.debug('rdOutput:'+rdOutput.Total_Lead_Time_CDC_ORD__c);
        system.debug('rdOutput:'+rdOutput.Total_Lead_Time_GCI_ORD__c);
        system.debug('rdOutput:'+rdOutput.Total_Lead_Time_GP_ORD__c);
        upsert rdOutput;
        system.debug('rdOutput:'+rdOutput.Total_Lead_Time_40_ORD__c);
        system.debug('rdOutput:'+rdOutput.Total_Lead_Time_CDC_ORD__c);
        system.debug('rdOutput:'+rdOutput.Total_Lead_Time_GCI_ORD__c);
        system.debug('rdOutput:'+rdOutput.Total_Lead_Time_GP_ORD__c);
        return leadTime;
    }
    Public Result getRouting()
    {
        result RDRouting = new Result();
        List<string> selectCols = new List<string> {'Standard_Operation_ID__c','Outside_Operation_Item__c','Operation_No__c'};
            RDRouting=wizardBaseDataProcessor.getSortedDataFromTranslationObj('Operation_No__c','RD_RoutingTranslation__c','RD_RoutingDetail__c',mapRDAttr,selectCols,'Operation_No__c');
        if(RDRouting.bResult)
        {
            system.debug('***Routing Result' +RDRouting.objResultList );
        }
        return RDRouting;
    }
    Public Result getWorkGuideLines()
    {
        result RDWorkGuideLines = new Result();
        List<String> selectCols = new List<String> {'Guidline_Seq__c','Description__c','Text__c','Type__c',
            'Sign_Off__c','Inspection_Sign_Off_Required__c','Operation__c'};
                RDWorkGuideLines=wizardBaseDataProcessor.getSortedDataFromTranslationObj('Test__c','RD_WorkGuidelinesTranslation__c','RD_WorkGuidelinesDetail__c',mapRDAttr,selectCols,'Guidline_Seq__c');
        if(RDWorkGuideLines.bResult)
        {
            system.debug('WorkGuideLines Result' +RDWorkGuideLines.objResultList);

        }
        return RDWorkGuideLines;
    }
    Public Result getControlPlan()
    {
        result RDControlPlan = new Result();
        result res=new result();
        result res1=getEvaluation();
        // System.debug('PED---------------->'+currentRD.PED_2014_68_EU_CE_mark__c==null?'N':currentRD.PED_2014_68_EU_CE_mark__c);
        // System.debug('PED---------------->'+mapRDAttr.get('PED'));
        // List<String> selectCols = new List<String> {'Output__c','Attribute__c'};
        // res=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','RD_EvaluationTranslation__c','RD_EvaluationDetail__c',mapRDAttr,selectCols);
        // if(res.bResult)
        // {
        //     for()
        //     mapRDAttr.put((string) sobj.get('Attribute__c'),(string) sobj.get('Output__c'));
        // }
        //     system.debug('RDEvaluation Result' +mapRDAttr);

        // }
        List<String> selectCol1s = new List<String> {'TEST_OPERATION_DESC__c','NORM_TYPE__c','Operation_Number__c','DATA_TYPE__c','CATEGORY_ID__c','INSPECTION_CODE__c','SAMPLE_PERCENT__c','Process_Characteristic__c','Special_Characteristic_Classification__c','OUTER_MIN__c','INNER_MIN__c','NOMINAL_VALUE__c','INNER_MAX__c','OUTER_MAX__c','Tool_ID__c','Data_Point__c','Test_OPNO__c'};
            RDControlPlan=wizardBaseDataProcessor.getDataFromTranslationObj('Test_OPNO__c','RD_ControlPlanTranslation__c','RD_ControlPlanDetail__c',mapRDAttr,selectCol1s);
        if(RDControlPlan.bResult)
        {
            system.debug('ControlPlan Result' +RDControlPlan.objResultList);

        }
        return RDControlPlan;
    }
    // RD Evaluation Method

    Public Result getEvaluation()
    {
        result RDEvaluation = new Result();
        List<String> selectCols = new List<String> {'Output__c','Attribute__c'};
            RDEvaluation=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','RD_EvaluationTranslation__c','RD_EvaluationDetail__c',mapRDAttr,selectCols);
        if(RDEvaluation.bResult)
        {
            system.debug('RDEvaluation Result' +RDEvaluation.objResultList);
            for (sObject sObj : RDEvaluation.objResultList) {
                if (!mapRDAttr.containsKey((string) sObj.get('Attribute__c'))) {
                    mapRDAttr.put((string) sObj.get('Attribute__c'),(string) sObj.get('Output__c'));
                }
            }
        }
        return RDEvaluation;
    }
    public result getLookupAttributes() {
        result lckAttr=new result();
        // mapRDAttr.remove('DPM');
        // string temptxt='';
        // if(DPM=='N')
        // 	temptxt='Gas';
        // else
        //     temptxt='Liquid';
        // mapRDAttr.put('DPM',temptxt);
        List<String> selectCols = new List<String> {'Text__c','Value__c','Attribute__c'};
            lckAttr=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','RD_Attributes_LookUp_Translation__c','RD_Attributes_Lookup_Detail__c',mapRDAttr,selectCols);
        if(lckAttr.bResult)
        {
            string tempVal='';
            boolean blVal=false;
            for (sObject sObj : lckAttr.objResultList) {
                //if (mapRDAttr.containsKey((string) sObj.get('Attribute__c'))) {
                if ((string) sObj.get('Text__c')!=null) {
                    if ((string) sObj.get('Attribute__c')=='OW500') {
                        blVal=true;
                        if ((string) sObj.get('Text__c')=='Tag: Gas/Vapor/Liquid')
                            tempVal='Gas/Vapor/Liquid';
                        else if ((string) sObj.get('Text__c')=='Tag: Gas/Vapor Only') {
                            tempVal='Gas/Vapor Only';
                        } else  {
                            tempVal='';
                        }
                    }
                    if(mapRDAttr.containsKey((string) sObj.get('Attribute__c'))) {
                        mapRDAttr.remove((string) sObj.get('Attribute__c'));
                        mapRDAttr.put((string) sObj.get('Attribute__c'),(string) sObj.get('Text__c'));
                    }
                    else
                        mapRDAttr.put((string) sObj.get('Attribute__c'),(string) sObj.get('Text__c'));
                }
                else if ((string) sObj.get('Value__c')!=null) {
                    if(mapRDAttr.containsKey((string) sObj.get('Attribute__c'))) {
                        mapRDAttr.remove((string) sObj.get('Attribute__c'));
                        mapRDAttr.put((string) sObj.get('Attribute__c'),(string) sObj.get('Value__c'));
                    }
                    else
                        mapRDAttr.put((string) sObj.get('Attribute__c'),(string) sObj.get('Value__c'));
                }

                //}
            }
            System.debug('GTAG08 Check 1-->'+tempVal);
            System.debug('GTAG08 Check-->'+mapRDAttr.get('GTAG08'));
            // value is returned before its removed
            // value is returned before its removed
            if(blVal) {
                mapRDAttr.Remove('GTAG08');
                mapRDAttr.put('GTAG08',tempVal);
            } else {
                mapRDAttr.Remove('GTAG08');
                mapRDAttr.put('GTAG08','');
            }

            // mapRDAttr.get('GTAG08')=tempVal;
        }
        return lckAttr;
    }
    Public Result getOW(){
        System.debug('getOW');
        result RDOW = new Result();
        //Result resKOS = resLkAttr;
        System.debug('***KOSHATAG' +mapRDAttr.containsKey('KOSHATAG'));
        System.debug('***KOSHATAG' +mapRDAttr.get('KOSHATAG'));
        // mapRDAttr.remove('DPM');
        // mapRDAttr.put('DPM',DPM=='Liquid'?'Y':'N');
        List<String> selectCols = new List<String> {'Comp__c','OWDesc__c'};
            RDOW=wizardBaseDataProcessor.getDataFromTranslationObj('Comp__c','RD_Output_OW_Translation__c','RD_Output_OW_Detail__c',mapRDAttr,selectCols);
        System.debug('RDOW --> '+RDOW);
        String strOW='';
        if(RDOW.bResult){
            List<Integer> aList = new List<Integer>();
            for (sObject sobj:RDOW.objResultList)
            {
                string a=(string) sobj.get('Comp__c');
                Integer i=integer.valueOf(a);
                aList.add(i);
            }
            aList.sort();
            System.debug('***OW Result' +RDOW.objResultList );
            for(Integer a: aList)
            {
                for (sObject sOb:RDOW.objResultList) {
                    string a2=(string) sOb.get('Comp__c');
                    Integer i2=integer.valueOf(a2);
                    if(a==i2)
                    {
                        if ((String) sOb.get('OWDesc__c')!=null) {
                            String strInsideBlock=(String) sOb.get('OWDesc__c');
                            if(strInsideBlock.contains('[')) {
                                String startText = strInsideBlock.substringBefore('[');
                                strOW += String.isNotBlank(startText)? startText+'' :'';
                                string s1=strInsideBlock.substringBefore(']');
                                s1=s1+']';
                                String s2=strInsideBlock.substringAfter(']');
                                System.debug('OW S2 CHeck Outside-->'+s2);
                                while (string.IsNotBlank(s1)) {

                                    String strBtw=s1.substringBetween('[',']');
                                    System.debug('strBtw'+strBtw);
                                    if(string.isNotBlank(mapRDAttr.get(strBtw)))
                                        strOW+=''+mapRDAttr.get(strBtw);
                                    System.debug('strOW'+strOW);
                                    if(s2.contains('[')) {
                                        String startText1 = s2.substringBefore('[');
                                        system.debug('startText1'+startText1);
                                        boolean isfalse=startText1=='\\n';
                                        system.debug('startText1'+isfalse);
                                        strOW += String.isBlank(startText1) || ((isfalse && string.isBlank(mapRDAttr.get(strBtw))))? '' :startText1+'';
                                        s1=s2.substringBefore(']');
                                        if(string.IsNotBlank(s1))
                                            s1=s1+']';
                                    } else {
                                        s1='';
                                    }
                                    System.debug('OW S2 CHeck Inside 1-->'+s2);
                                    System.debug('OW S1 CHeck Inside 1-->'+s1);
                                    if(String.isNotBlank(s2) && string.isBlank(s1))
                                        strOW+=s2;
                                    s2=s2.substringAfter(']');
                                    System.debug('OW S2 CHeck Inside 2-->'+s2);
                                    // if(string.isNotBlank(s1) && string.isNotBlank(mapRDAttr.get(strBtw)))
                                    //     strOW+= ' \n a '+s1;
                                }
                                //strOW+= ' \n ';
                            } else {
                                strOW+=strInsideBlock;
                            }
                            if(string.isNotBlank(strInsideBlock))
                                strOW+='\n';
                        }
                    }
                }

            }
        }
        //strOW=strOW.replaceAll('\\s+','');
        System.debug('@@@ final OW --> '+strOW);
        strOW = strOW.replaceAll('\n\n', '\n');
        //System.debug('@@@ final OW --> '+strOW);
        strOW = strOW.replaceAll('\n\n', '\n');
        //System.debug('@@@ final OW --> '+strOW);
        strOW = strOW.replaceAll('\n\n', '\n');
        //System.debug('@@@ final OW --> '+strOW);
        strOW = strOW.replaceAll('\n\n', '\n');
        strOW = strOW.replaceAll('\n\n', '\n');
        System.debug('@@@ final OW 2--> '+strOW);
        RDOW.strRetValue=strOW;
        return RDOW;
    }
    public map<String,string> mapRD_Material{set;get;}
    public map<String,string> mapRD_LABMAT{set;get;}
    public Map<string,string> getMaterials(string key1) {
        map<String, string> mapMat = new map<String, string>();
        for(RD_GeneralMaterialsList__c objCS :[select MatlCode__c,Matl__c,TagMatlDesc__c from RD_GeneralMaterialsList__c] ) {
            String finalMTCD;
            if(objCS.MatlCode__c.length()!=3) {
                finalMTCD = '0'+objCS.MatlCode__c;
            } else {
                finalMTCD=objCS.MatlCode__c;
            }
            if(!mapMat.containsKey(finalMTCD)) {
                if(key1=='OB')
                    mapMat.put(finalMTCD, objCS.Matl__c);
                else if(key1=='LABMAT')
                    mapMat.put(finalMTCD, objCS.TagMatlDesc__c);
            }
            //System.debug('mapMat:--- '+mapMat);
        }

        return mapMat;
    }
    //--------------- pending ------------------
    public Result getOA() {
        result OAResult=new result();
        System.debug('HCLASS:- ' +HCLASS);
        String trimmedSZC = strSZC;
        //trimmedSZC=integer.valueOf(strSZC)+'';
        System.debug('PTC:- '+PTC);
        System.debug('trimmedSZC:- '+trimmedSZC);
        System.debug('CSSUM:- '+CSSUM);
        System.debug('STC:- '+STC);
        System.debug('COIN:- '+COIN);
        System.debug('COOUT:- '+COOUT);
        System.debug('DPM:- '+DPM);
        System.debug('addIntegralBDI:- '+addIntegralBDI);
        System.debug('DSCVAR:- '+DSCVAR);
        if(PTC != null && trimmedSZC != null && CSSUM != null && STC != null && COIN !=null && COOUT !=null && DPM !=null && addIntegralBDI!=null && DSCVAR!=null)
        {
            System.debug('OA Check IF:- ');
            List<String> selectCols=new List<String>{'OA__c','LABDSC__c'};
                String strPTC='\''+PTC+'\'';
            String SZC='\''+trimmedSZC+'\'';
            String strCSSUM='\''+CSSUM+'\'';
            String strSTC='\''+STC+'\'';
            String strCOIN='\''+COIN+'\'';
            String strCOOUT='\''+COOUT+'\'';
            String strHCLASS= '';
            string strDSCVAR='\''+DSCVAR+'\'';
            if(String.isNOTBlank(HCLASS)){
                strHCLASS='\''+HCLASS+'\'';
            }else{
                strHCLASS= '\'N/A\'';
            }
            String strDPM='\''+DPM+'\'';
            String straddIntegralBDI='\''+addIntegralBDI+'\'';
            List<String> whereCols=new List<String>{'PTC__c','SZC__c','CSSUM__c','STC__c','COIN__c','COOUT__c','HCLASS__c','DPM__c','addIntegralBDI__c','DSCVAR__C'};
                List<String> whereVals=new List<String>{strPTC,SZC,strCSSUM,strSTC,strCOIN,strCOOUT,strHCLASS,strDPM,straddIntegralBDI,strDSCVAR};
                    List<String> whereComps=new List<String>{'=','=','=','=','=','=','=','=','=','='};
                        List<String> extraChars=new List<String>{'','','','','','','null','','',''};
                            OAResult=wizardBaseDataProcessor.getProdOutputDescData('RD_Output_OA__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(OAResult.bResult)
            {
                system.debug('OA Quote Description Details' +OAResult.objResultList );

            }
        }
        return OAResult;
    }
    //--------------- pending ------------------
    public map<string,string> getOB_LABMAT_Ouput() {
        map<String, string> mapOB_LABMAT = new map<String, string>();
        string strOBResult='';
        string strLabResult='';
        string strOBResult1;
        string strLabResult1;
        System.debug('mapRD_LABMAT: 4677' + mapRD_LABMAT);
        System.debug('mapRD_LABMAT: 4678' + mapRD_Material);
        if(String.isNotBlank(MCHO)) {
            //if(MCHO!=null) {
            string strOBResultHOC;
            //strOBResult+=mapRD_Material.get(MCHO);
            if(HOC!='N' && HOC != null){
                System.debug('@@@ HOC: - '+HOC);
                strOBResultHOC=mapRD_Material.get(HOC);
                System.debug('@@@ mapRD_Material.get(HOC): - '+mapRD_Material.get(HOC));
                System.debug('@@@ mapRD_Material.get(HOC): - '+mapRD_Material.get(MCHO));
                strOBResult+=mapRD_Material.get(MCHO)+' '+ HOC+' '+'Outlet \n';
            }
            else
            {
                System.debug('@@@ ELSE mapRD_Material.get(MCOH): - '+mapRD_Material.get(MCHO));
                strOBResult=mapRD_Material.get(MCHO)+' '+'Outlet \n';//Service Ticket #207974, add extra space
            }

            //strLabResult=mapRD_LABMAT.get(MCHO);
            strLabResult=mapRD_LABMAT.get(MCHO) +''+'/';
        }
        if(String.isNotBlank(MCHRNG)) {
            strOBResult1=mapRD_Material.get(MCHRNG);
            strOBResult+=strOBResult1+' '+'Holddown Ring \n';
            strLabResult1=mapRD_LABMAT.get(MCHRNG);
            strLabResult+=strLabResult1 +''+'/';
        }

        if(String.isNotBlank(MCAR)) {
            strOBResult1=mapRD_Material.get(MCAR);
            strOBResult+=strOBResult1+' '+'Arcuate Ring \n';
            strLabResult1=mapRD_LABMAT.get(MCAR);
            strLabResult+=strLabResult1 +' '+'/';
        }

        if(String.isNotBlank(MCGR1)) {
            strOBResult1=mapRD_Material.get(MCGR1);
            strOBResult+=strOBResult1+' '+'Armor Ring \n';
            strLabResult1=mapRD_LABMAT.get(MCGR1);
            strLabResult+=strLabResult1 +' '+'/';
        }
        if(String.isNotBlank(MCOG)) {
            strOBResult1=mapRD_Material.get(MCOG);
            strOBResult+=strOBResult1+' '+'Outlet Gasket \n';
            strLabResult1=mapRD_LABMAT.get(MCOG);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCGR2)) {
            strOBResult1=mapRD_Material.get(MCGR2);
            strOBResult+=strOBResult1+' '+'Armor Ring \n';
            strLabResult1=mapRD_LABMAT.get(MCGR2);
            strLabResult+=strLabResult1 +''+'/';
        }
        //System.debug('var MCOR: ' + MCOR);
        if(String.isNotBlank(MCOR)) {
            strOBResult1=mapRD_Material.get(MCOR);
            strOBResult+=strOBResult1+' '+'Outlet Ring \n';
            strLabResult1=mapRD_LABMAT.get(MCOR);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCDP)) {
            strOBResult1=mapRD_Material.get(MCDP);
            strOBResult+=strOBResult1+' '+'Dent Protector \n';
            strLabResult1=mapRD_LABMAT.get(MCDP);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCOL)) {
            strOBResult1=mapRD_Material.get(MCOL);
            strOBResult+=strOBResult1+' '+'Outlet Liner \n';
            strLabResult1=mapRD_LABMAT.get(MCOL);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCVS1)) {
            System.debug('@@@ MCVS1 Vacuum Support'+MCVS1);
            strOBResult1=mapRD_Material.get(MCVS1);
            strOBResult+=strOBResult1+' '+'Vacuum Support  \n';

            strLabResult1=mapRD_LABMAT.get(MCVS1);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCOC)) {
            strOBResult1=mapRD_Material.get(MCOC);
            strOBResult+=strOBResult1+' '+'Outlet Coating \n';

            strLabResult1=mapRD_LABMAT.get(MCOC);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCDT1)) {
            strOBResult1=mapRD_Material.get(MCDT1);
            strOBResult+=strOBResult1+' '+'Top Section \n';

            strLabResult1=mapRD_LABMAT.get(MCDT1);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCDT1) && ((MCSS==('070'))||(MCSS==('071'))||(MCSS==('072'))||(MCSS==('073'))) && String.isNotBlank(MCSM)) {

            strOBResult1=mapRD_Material.get(MCSM);
            strOBResult+=strOBResult1+' '+'Seal \n';
            System.debug('strOBResult MCDT1 --> '+strOBResult);
            strLabResult1=mapRD_LABMAT.get(MCSM);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCDD)) {
            strOBResult1=mapRD_Material.get(MCDD);
            strOBResult+=strOBResult1+' '+'Disc \n';

            strLabResult1=mapRD_LABMAT.get(MCDD);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCSS1)) {
            strOBResult1=mapRD_Material.get(MCSS1);
            strOBResult+=strOBResult1+' '+'Seal \n';

            strLabResult1=mapRD_LABMAT.get(MCSS1);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCGD)) {
            strOBResult1=mapRD_Material.get(MCGD);
            strOBResult+=strOBResult1+' '+'Girdle \n';

            strLabResult1=mapRD_LABMAT.get(MCGD);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCSS2)) {
            strOBResult1=mapRD_Material.get(MCSS2);
            strOBResult+=strOBResult1+' '+'Seal \n';

            strLabResult1=mapRD_LABMAT.get(MCSS2);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCDT2)) {
            strOBResult1=mapRD_Material.get(MCDT2);
            strOBResult+=strOBResult1+' '+'Top Section \n';

            strLabResult1=mapRD_LABMAT.get(MCDT2);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCDT2) && ((MCSS==('070'))||(MCSS==('071'))||(MCSS==('072'))||(MCSS==('073'))) && String.isNotBlank(MCSM)) {

            strOBResult1=mapRD_Material.get(MCSM);
            strOBResult+=strOBResult1+' '+'Seal \n';
            System.debug('strOBResult MCDT2 --> '+strOBResult);
            strLabResult1=mapRD_LABMAT.get(MCSM);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCIC1)) {
            strOBResult1=mapRD_Material.get(MCIC1);
            strOBResult+=strOBResult1+' '+'Inlet Coating \n';

            strLabResult1=mapRD_LABMAT.get(MCIC1);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCSS3)) {
            strOBResult1=mapRD_Material.get(MCSS3);
            strOBResult+=strOBResult1+' '+'Seal \n';

            strLabResult1=mapRD_LABMAT.get(MCSS3);
            strLabResult+=strLabResult1 +''+'/';
        }
        // if(String.isNotBlank(MCSS)) {
        //     strOBResult1=mapRD_Material.get(MCSS);
        //     strOBResult+=strOBResult1+' '+'Seal \n';
        //     System.debug('strOBResult MCSS --> '+strOBResult);
        //     strLabResult1=mapRD_LABMAT.get(MCSS);
        //     strLabResult+=strLabResult1 +''+'/';
        // }
        if(String.isNotBlank(MCIR1)) {
            strOBResult1=mapRD_Material.get(MCIR1);
            strOBResult+=strOBResult1+' '+'Inlet Ring \n';

            strLabResult1=mapRD_LABMAT.get(MCIR1);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCIL)) {
            strOBResult1=mapRD_Material.get(MCIL);
            strOBResult+=strOBResult1+' '+'Inlet Liner \n';

            strLabResult1=mapRD_LABMAT.get(MCIL);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCIR2)) {
            strOBResult1=mapRD_Material.get(MCIR2);
            strOBResult+=strOBResult1+' '+'Inlet Ring \n';

            strLabResult1=mapRD_LABMAT.get(MCIR2);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCVS2)) {
            System.debug('@@@ MCVS2 Vacuum Support'+MCVS2);
            strOBResult1=mapRD_Material.get(MCVS2);
            strOBResult+=strOBResult1+' '+'Vacuum Support  \n';

            strLabResult1=mapRD_LABMAT.get(MCVS2);
            strLabResult+=strLabResult1 +''+'/';
        }
        // if(String.isNotBlank(MCVS)) {
        //     System.debug('@@@ MCVS Vacuum Support'+MCVS);
        //     strOBResult1=mapRD_Material.get(MCVS);
        //     strOBResult+=strOBResult1+' '+'Vacuum Support \n';

        //     strLabResult1=mapRD_LABMAT.get(MCVS);
        //     strLabResult+=strLabResult1 +''+'/';
        // }
        if(String.isNotBlank(MCIC2)) {
            strOBResult1=mapRD_Material.get(MCIC2);
            strOBResult+=strOBResult1+' '+'Inlet Coating \n';

            strLabResult1=mapRD_LABMAT.get(MCIC2);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCIR3)) {
            strOBResult1=mapRD_Material.get(MCIR3);
            strOBResult+=strOBResult1+' '+'Inlet Ring \n';

            strLabResult1=mapRD_LABMAT.get(MCIR3);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCHS)) {
            strOBResult1=mapRD_Material.get(MCHS);
            strOBResult+=strOBResult1+' '+'Handling Support \n';

            strLabResult1=mapRD_LABMAT.get(MCHS);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCVS3)) {
            System.debug('@@@ MCVS3 Vacuum Support'+MCVS3);
            strOBResult1=mapRD_Material.get(MCVS3);
            strOBResult+=strOBResult1+' '+'Vacuum Support  \n';

            strLabResult1=mapRD_LABMAT.get(MCVS3);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCIG)) {
            strOBResult1=mapRD_Material.get(MCIG);
            strOBResult+=strOBResult1+' '+'Inlet Gasket \n';

            strLabResult1=mapRD_LABMAT.get(MCIG);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCHT)) {
            strOBResult1=mapRD_Material.get(MCHT);
            strOBResult+=strOBResult1+' '+'Hi-Temp Assy \n';

            strLabResult1=mapRD_LABMAT.get(MCHT);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(MCTSOR)) {
            strOBResult1=mapRD_Material.get(MCTSOR);
            strOBResult+=strOBResult1+' '+'O-Ring \n';

            strLabResult1=mapRD_LABMAT.get(MCTSOR);
            strLabResult+=strLabResult1 +''+'/';
        }

        if(String.isNotBlank(MCHI)) {
            string strOBResultHIC;
            strOBResult1=mapRD_Material.get(MCHI);
            if(HIC!=null){
                strOBResultHIC=mapRD_Material.get(HIC)==null?HIC:mapRD_Material.get(HIC);
                //Ticket# 207974 , if InletConnection is N then skip that var, N need not be printed
                if(strOBResultHIC == 'N'){
                    strOBResult+=strOBResult1+' '+'Inlet \n';
                
                }else{
                    strOBResult+=strOBResult1+' '+strOBResultHIC+' '+'Inlet \n';
                
                }
            }
            else
                strOBResult+=strOBResult1+' '+'Inlet \n';
            strLabResult1=mapRD_LABMAT.get(MCHI);
            strLabResult+=strLabResult1 +''+'/';
        }
        if(String.isNotBlank(addIntegralBDI)) {
            strOBResult1=mapRD_Material.get(MCTSOR)==null?'':mapRD_Material.get(MCTSOR);
            System.debug('strOBResult1:--'+strOBResult1);
            if(addIntegralBDI=='BDI')
            {
                strOBResult+=strOBResult1+' '+'Integral B.D.I. Specifications: \n';
            }
            else if(addIntegralBDI=='BDI-FLX')
            {
                strOBResult+=strOBResult1+' '+'Integral BDI-FLX Specifications: \n';
            }
            list<RD_Integral_BDI_Table__c> listbdi=BDIRecL();
            if(listbdi.size()>0) {
                RD_Integral_BDI_Table__c bdiInstance=listbdi[0];
                if(string.isNotBlank(bdiInstance.OrderDesc1__c))
                    strOBResult=strOBResult+' '+bdiInstance.OrderDesc1__c+' \n';
                if(string.isNotBlank(bdiInstance.OrderDesc2__c))
                    strOBResult=strOBResult+' '+bdiInstance.OrderDesc2__c+' \n';
                if(string.isNotBlank(bdiInstance.OrderDesc3__c))
                    strOBResult=strOBResult+' '+bdiInstance.OrderDesc3__c+' \n';
                if(string.isNotBlank(bdiInstance.OrderDesc4__c))
                    strOBResult=strOBResult+' '+bdiInstance.OrderDesc4__c+' \n';
                if(string.isNotBlank(bdiInstance.OrderDesc5__c))
                    strOBResult=strOBResult+' '+bdiInstance.OrderDesc5__c+' \n';
                if(string.isNotBlank(bdiInstance.OrderDesc6__c))
                    strOBResult=strOBResult+' '+bdiInstance.OrderDesc6__c+' \n';
            }
        }
        mapOB_LABMAT.put('OB',string.IsBlank(strOBResult)?'':strOBResult);
        mapOB_LABMAT.put('LABMAT',string.IsBlank(strLabResult)?'':strLabResult);
        //System.debug('mapOB_LABMAT: -'+mapOB_LABMAT);
        return mapOB_LABMAT;
    }
    public list<RD_Integral_BDI_Table__c> BDIRecL() {
        String bdistr='';
        if(addIntegralBDI=='BDI')
            bdistr='Integral BDI';
        else
            bdistr=addIntegralBDI;
        // Added  Interface__c in the query for Service Ticket #200477
        //Service Ticket #204266, handling Interface query, when not selected.
        string query='Select Id, OrderDesc1__c, OrderDesc2__c, OrderDesc6__c, OrderDesc5__c, OrderDesc3__c, OrderDesc4__c FROM  RD_Integral_BDI_Table__c  where PTC__c=\''+currentRD.Product__c+'\' and SZC__c=\''+strSZC+'\' and CompSTC__c=\''+currentRD.Seat__c+'\' AND Type__c=\''+bdistr+'\' AND StripMatlCode__c=\''+MCBS+'\' AND GasketMatlCode__c=\''+MCBDIG+'\' AND Wiring_Configuration__c=\''+WiringConfig+'\' AND WireType__c=\''+BCT+'\' AND CableLength__c=\''+BCL+'\' AND EndConnection__c=\''+BEC+'\'';
        if( !String.isBlank(currentRD.To_Make_With_BDI_FLX_Interface_cable__c ) ){
            query='Select Id, OrderDesc1__c, OrderDesc2__c, OrderDesc6__c, OrderDesc5__c, OrderDesc3__c, OrderDesc4__c FROM  RD_Integral_BDI_Table__c  where PTC__c=\''+currentRD.Product__c+'\' and SZC__c=\''+strSZC+'\' and Interface__c=\''+currentRD.To_Make_With_BDI_FLX_Interface_cable__c+'\' and CompSTC__c=\''+currentRD.Seat__c+'\' AND Type__c=\''+bdistr+'\' AND StripMatlCode__c=\''+MCBS+'\' AND GasketMatlCode__c=\''+MCBDIG+'\' AND Wiring_Configuration__c=\''+WiringConfig+'\' AND WireType__c=\''+BCT+'\' AND CableLength__c=\''+BCL+'\' AND EndConnection__c=\''+BEC+'\'';
        }
       
        System.debug('BDI QUERY'+query);
        RD_Integral_BDI_Table__c[] bdirec=Database.query(query);

        return bdirec;
    }
    public Decimal TOTTEM {
        get {//=if( PTC <> PAS, PBurstPressConverted, VBurstPressConverted)
            return PTC !='PAS' ? PBurstPressureConverted : VBurstPressureConverted;
        }
        set {
            this.TOTTEM = value;
        }
    }

    public Decimal METLDER {
        get {
            return currentRD.Metal_Derate__c;
        }
        set {
            currentRD.Metal_Derate__c = value;
            this.METLDER = value;
        }
    }

    // public Decimal ALUMEQN {
    //     get {//= 2 * TOTTEM / (METLDER + ALUMDER)
    //         return 2*TOTTEM/(METLDER+ALUMDER);
    //     }
    //     set {
    //         this.ALUMEQN = value;
    //     }
    // }

    public Decimal METLEQN {
        get {//= TOTTEM / METLDER
            return TOTTEM/METLDER;
        }
        set {
            this.METLEQN = value;
        }
    }

    public Decimal BACKPRESSCONV {
        get {//ConvertPressure (BACKPRESSINPUT, BACKPRESSUOM, "psig")
            decimal decBackPress;
            if (!String.IsBlank(currentRD.Vacuum_Withstand__c) && currentRD.Vacuum_Withstand__c!='No Requirements') {

                if (currentRD.Vacuum_Withstand__c!='Full Vacuum') {
                    decBackPress=15;
                } else {
                    decBackPress=currentRD.Converted_Back_Pressure_Value__c;
                }
            }
            return decBackPress;
        }
        set {
            this.BACKPRESSCONV = value;
        }
    }

    public Decimal BPMMMax {
        get {//= RTPRS1
            return RTPRS1;
        }
        set {
            this.BPMMMax = value;
        }
    }
    public class DTSMWrapper {
        @AuraEnabled public String setMatlCodePos { get;set; }
        @AuraEnabled public String setMatlCodeVac { get;set; }
        public DTSMWrapper() {
            this.setMatlCodePos = setMatlCodePos;
            this.setMatlCodeVac = setMatlCodeVac;
        }
    }

    public DTSMWrapper DiscTopSectMatlList {
        get {//Based upon all inputs filtering the masterblaster table, plus filtering on product selected 'SZC' 'PTC' and 'SeatDesc'
            //then return list of material codes still avialable in column E or F whichever has values.
            //This list will be used later as contraint on available disc and top section materials that are available.
            DTSMWrapper dtsmWrapper = new DTSMWrapper();
            if(RDMasterBlaster.size() > 0){
                for(RDMasterBlaster__c eachRDMB : RDMasterBlaster){
                    dtsmWrapper.setMatlCodePos =  eachRDMB.MatlCodePos__c;
                    dtsmWrapper.setMatlCodeVac =  eachRDMB.MatlCodeVac__c;
                }
                return dtsmWrapper;
            }
            else
                return dtsmWrapper;
        }
        set {
            this.DiscTopSectMatlList = value;
        }
    }

    public String MATLCODEPOS {
        get {
            if(RDMasterBlaster.size() > 0)
                return RDMasterBlaster[0].MatlCodePos__c;
            else
                return '-';
        }
        set {
            this.MATLCODEPOS = value;
        }
    }

    public String MATLCODEVAC {
        get {
            if(RDMasterBlaster.size() > 0)
                return RDMasterBlaster[0].MatlCodeVac__c;
            else
                return '-';
        }
        set {
            this.MATLCODEVAC = value;
        }
    }

    public String MCDERATE {
        get {//=if(PTC <> PAS, MATLCODEPOS, MATLCODEVAC)
            //return PTC != 'PAS' ? MATLCODEPOS : MATLCODEVAC !=null ? MATLCODEVAC:'-';
            return MCD;
        }
        set {
            this.MCDERATE = value;
        }
    }

    public String OW040 {
        get {
            System.debug('OW040 ->>>> ');
            if(RD_tblASMEValues.size() > 0 && currentRD.ASME_Section_VIII_Division_1__c){
                currentRD.SizingKrText__c = RD_tblASMEValues[0].SizingKrText__c;
                System.debug('OW040 --> '+RD_tblASMEValues[0].SizingKrText__c);
                return RD_tblASMEValues[0].KR_Text__c;
            }
            else
                return '';
        }
        set {
            this.OW040 = value;
        }
    }
    public string GTAG09 {
        get {
            //If PTC=(SNX or HPH or HP2 or HPZ or HPS or SNL or LPX or SXM)
            List<String> lstPTCS=new List<String>{'SNX','HPH','HP2','HPZ','HPS','SNL','LPX','SXM'};
                if(lstPTCS.contains(PTC)) {
                    if(RD_tblASMEValues.size() > 0){
                        return OW041;
                    }
                    else
                        return '';
                }
            return '';
        }
        set {
            this.OW040 = value;
        }
    }

    public String OW0403 {
        get {
            if(RD_tblASMEValues.size() > 0 ){
                System.debug('OW0403 --> '+RD_tblASMEValues[0].KD_Text__c);
                return RD_tblASMEValues[0].KD_Text__c;
            }
            else
                return '';
        }
        set {
            this.OW0403 = value;
        }
    }

    public String OW0405 {
        get {
            if(RD_tblASMEValues.size() > 0 && currentRD.ASME_Section_VIII_Division_1__c){
                currentRD.SizingCertText__c = 'National Board Certification Number '+String.valueOf(RD_tblASMEValues[0].SizingCertText__c);
                System.debug('OW0405 --> '+RD_tblASMEValues[0].SizingCertText__c);
                return RD_tblASMEValues[0].CertOWText__c;
            }
            else
                return '';
        }
        set {
            this.OW0405 = value;
        }
    }

    public String OW041 {
        get {
            System.debug('OW041 ->>>> ');
            if(RD_tblASMEValues.size() > 0 && currentRD.ASME_Section_VIII_Division_1__c){
                if(CSSUM == 'US Units'){
                    System.debug('OW041 --> '+RD_tblASMEValues[0].MNFAin2__c);
                    return RD_tblASMEValues[0].MNFAin2__c;
                } else if(CSSUM == 'Metric'){
                    System.debug('OW041 --> '+RD_tblASMEValues[0].MNFAmm2__c);
                    return RD_tblASMEValues[0].MNFAmm2__c;
                } else {
                    return '';
                }
            }
            else
                return '';
        }
        set {
            this.OW041 = value;
        }
    }

    public String KDValueGas {
        get {
            if(RD_tblASMEValues.size() > 0)
                return RD_tblASMEValues[0].KDValueGas__c;
            else
                return '';
        }
        set {
            this.KDValueGas = value;
        }
    }

    public String KDValueLiquid {
        get {
            if(RD_tblASMEValues.size() > 0)
                return RD_tblASMEValues[0].KDValueLiquid__c;
            else
                return '';
        }
        set {
            this.KDValueLiquid = value;
        }
    }

    public Decimal MNFAValue {
        get {
            if(RD_tblASMEValues.size() > 0)
                return RD_tblASMEValues[0].MNFAValue__c;
            else
                return null;
        }
        set {
            this.MNFAValue = value;
        }
    }

    public String OW042 {
        get {
            System.debug('KDValueGas --> '+KDValueGas);
            System.debug('KDValueLiquid --> '+KDValueLiquid);
            System.debug('CSSUM'+CSSUM);
            Decimal WTgas = 0.0;
            Decimal WTliquid = 0.0;
            Decimal WTg = 0.0;
            Decimal WTl = 0.0;
            Decimal intKDValueGas = 0.0;
            Decimal intKDValueLiquid = 0.0;
            if(String.isNotBlank(KDValueGas)){
                intKDValueGas = Decimal.valueOf(KDValueGas);
            }
            if(String.isNotBlank(KDValueLiquid)){
                intKDValueLiquid = Decimal.valueOf(KDValueLiquid);
            }
            if(String.isNotBlank(KDValueGas) && MNFAValue!=null){
                //WTgas = (356*(MNFAValue)*(KDValueGas)*((RG2MIN*1.1)+14.6959)*SQRT((28.97/(RTTMDF+459.67))))/60;
                WTgas = (356*(MNFAValue)*(intKDValueGas)*((RG2MIN*1.1)+14.6959)*Math.SQRT((28.97/(RTTMDF+459.67))))/60;
                if(CSSUM == 'Metric'){
                    WTgas = WTgas*0.453592;
                }
                WTg = unitConversions.SignificantDigitsNormal(WTgas,4,1).dblRetValue;
            }

            if(String.isNotBlank(KDValueLiquid) && MNFAValue!=null){
                //WTliquid = 2407*(MNFAValue)*(KDValueLiquid)*SQRT((RG2MIN*1.1)*62.371);
                WTliquid = 2407*(MNFAValue)*(intKDValueLiquid)*Math.SQRT((RG2MIN*1.1)*62.371);
                WTliquid = WTliquid*.124675/62.371;
                if(CSSUM == 'Metric'){
                    WTliquid = WTliquid*3.78541;
                }
                WTl = unitConversions.SignificantDigitsNormal(WTliquid,4,1).dblRetValue;
            }

            if(String.isNotBlank(KDValueGas) && String.isBlank(KDValueLiquid) && CSSUM == 'US Units'){
                return 'Capacity: '+WTg.format()+' lb/min of air';
            }

            if(String.isNotBlank(KDValueGas) && String.isBlank(KDValueLiquid) && CSSUM == 'Metric'){
                return 'Capacity: '+WTg.format()+' kg/min of air';
            }

            if(String.isBlank(KDValueGas) && String.isNotBlank(KDValueLiquid) && CSSUM == 'US Units'){
                return 'Capacity: '+WTl.format()+' gal/min of water';
            }

            if(String.isBlank(KDValueGas) && String.isNotBlank(KDValueLiquid) && CSSUM == 'Metric'){
                return 'Capacity: '+WTl.format()+' l/min of water';
            }

            if(String.isNotBlank(KDValueGas) && String.isNotBlank(KDValueLiquid) && CSSUM == 'US Units'){
                return 'Capacity: '+WTg.format()+' lb/min of air, '+WTl+' gal/min of water';
            }

            if(String.isNotBlank(KDValueGas) && String.isNotBlank(KDValueLiquid) && CSSUM == 'Metric'){
                return 'Capacity: '+WTg.format()+' kg/min of air, '+WTl+' l/min of water';
            }

            if(String.isBlank(KDValueGas) && String.isBlank(KDValueLiquid)){
                return '';
            }

            return '';
        }
        set {
            this.OW042 = value;
        }
    }

    public String GTAG10 {
        get {// = OW040 +" "+OW041
            System.debug('GTAG10 ->>> ');
            return ( ((OW040 == null?'':OW040)+' '+(OW041 == null ?'':OW041)).trim() ) ;//Service Ticket #204282, handle null value, during concatenating string
        }
        set {
            this.GTAG10 = value;
        }
    }

    public Decimal POSPRESSCONV {
        get {//ConvertPressure (POSPRESSINPUT, POSPRESSUOM, "psig")
            return currentRD.Converted_Positive_Pressure_Value__c;
        }
        set {
            currentRD.Converted_Positive_Pressure_Value__c = value;
            this.POSPRESSCONV = value;
        }
    }

    public Decimal TEFAMB {
        get {
            if(RDMasterBlaster.size() > 0)
                return RDMasterBlaster[0].Teflon_Ambient__c;
            else
                return null;
        }
        set {
            this.TEFAMB = value;
        }
    }

    public string DERATE {
        get {
            if(RDMasterBlaster.size() > 0)
                return RDMasterBlaster[0].DerateType__c;
            else
                return null;
        }
        set {
            this.DERATE = value;
        }
    }
    // public Decimal TEFEQN {
    //     get {//= ((TOTTEM - TEFAMB * TEFDER)/METLDER) + TEFAMB
    //         return ((TOTTEM - TEFAMB * TEFDER)/METLDER + TEFAMB);
    //     }
    //     set {
    //         this.TEFEQN = value;
    //     }
    // }

    public String DERATEEQN {
        get {
            if(RDMasterBlaster.size() > 0)
                return RDMasterBlaster[0].Derate_EQN__c;
            else
                return '-';
        }
        set {
            this.DERATEEQN = value;
        }
    }

    // public Decimal TOTAMB {
    //     get {//= IF((DERATEEQN = METL OR COMM), METLEQN, IF(DERATEEQN = COMA, ALUMEQN, TEFEQN))
    //         return ((DERATEEQN == 'METL' || DERATEEQN == 'COMM')  ? METLEQN : DERATEEQN == 'COMA' ? ALUMEQN : TEFEQN);
    //     }
    //     set {
    //         this.TOTAMB = value;
    //     }
    // }
    public List<RD_Seals_Component_Materials__c> getSealData() {
        List<RD_Seals_Component_Materials__c> sealList = new List<RD_Seals_Component_Materials__c>();
        //System.debug('isFrag in getSealMAterials --> '+isFrag);
        String strQuery = 'Select id,MatlCode__c,Add_Metal_Seal__c,PressLL__c,PressUL__c from RD_Seals_Component_Materials__c where PTC__c=\''+currentRD.product__c+'\' and STC__c=\''+currentRD.seat__c+'\' and SZC__c=\''+ConstantsUtil.getSizeDesc(String.valueOf(currentRD.size__c)).SZC+'\' AND SealUpperTemp__c>='+currentRD.Converted_Temperature_Setting__c;
        String isFlag=currentRD.Non_Fragmenting_Design_Required__c?'Yes':'No';
        if(currentRD.Non_Fragmenting_Design_Required__c)
            strQuery+=' AND Non_Fragmenting__c=\''+isFlag+'\'';
        //System.debug('Dynamic Query'+strQuery);
        sealList=Database.query(strQuery);
        // System.debug('sealList'+sealList);
        return sealList;
    }
    public boolean isMetalCheck(string mtlcheck) {
        boolean bln=false;
        decimal TMRCHECK;
        decimal BMRCHECK;
        if(currentRD.TMRCHECK__c!=null)
            TMRCHECK=currentRD.TMRCHECK__c;
        else
            TMRCHECK=PBurstPressureConverted;
        if(currentRD.BMRCHECK__c!=null)
            BMRCHECK=currentRD.BMRCHECK__c;
        else
            BMRCHECK=PBurstPressureConverted;
        for(RD_Seals_Component_Materials__c sl:sealCompMaterials) {
            if((sl.PressLL__c<=TMRCHECK && sl.PressUL__c>=BMRCHECK) && sl.MatlCode__c==mtlcheck) {
                if(sl.Add_Metal_Seal__c=='Yes')
                    bln=true;
            }
        }
        return bln;
    }
    public String InletOptionASMECode {
        get {
            return currentRD.ASME_Inlet_Option_Code__c;
        }
        set {
            this.InletOptionASMECode = value;
        }
    }

    public String OutletOptionASMECode {
        get {
            return currentRD.ASME_Outlet_Option_Code__c;
        }
        set {
            this.OutletOptionASMECode = value;
        }
    }

    //--------------- pending ------------------//
    // public Decimal TEFDER {
    //     get {
    //         return 0.0;
    //     }
    //     set {
    //         this.TEFDER = value;
    //     }
    // }

    // //--------------- pending ------------------//
    // public Decimal ALUMDER {
    //     get {
    //         return 0.0;//currentRD.Metal_Derate__c;
    //     }
    //     set {
    //         this.ALUMDER = value;
    //     }
    // }
}