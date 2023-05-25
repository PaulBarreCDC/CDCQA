/************************************************************************
* Class Name: RVOutputUtility
* This class handles RV Output
* @Modification Log   : 
* Ver       Date            Author                  Modification
* 1.0        --             ApexIT                 Initial Version
* 1.1    21-Apr-2021       Rohini Hathi         Service Ticket #202187, Setting the xml attributes in the end of the method
* 1.2    27-May-2021       Rohini Hathi         Service Ticket #200844, for fiberglass AllKynar attribute
************************************************************************/
public class RVOutputUtility {
    // currentBGR : current RV record
    public Relief_Valve__c currentRV {get; set;}
    public RVWeightDetermination WeightD {get;set;}
    public Map<String, String> mapWeight;
    public String posPalletComponentPart; // needed for RVWeightDetermination
    public string posDiaphragmComponentPart;
    public string posDiaphragmBackupComponentPart;
    public string vacDiaphragmComponentPart;
    public string vacDiaphragmBackupComponentPart;
    /* Constructor which will take RV ID as the Parameter and fetch all the fields which are used for OUTPUTS*/
    public RVOutputUtility (Relief_Valve__c rvRecord) 
    {
        currentRV = rvRecord;
        postConstSetAttributes();
    }
    public RVOutputUtility (Id recordID) 
    {
        currentRV= (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(recordID).objResultList[0];
        //GMODEL = GMODELPTC + '-' + strSZC + MCBODY + MCSEAT + PNMCPALL + currentRV.Element_Material__c + '-' + MCDPHM.left(1) + MCSTMJ + OPTIONCODE;
        postConstSetAttributes();
    }
    
    public void postConstSetAttributes()
    {
        system.debug('##MaxProcPresPSIG: '+MaxProcPresPSIG+'PosFlowPresPSIG: '+PosFlowPresPSIG);
        if(currentRV.Converted_Max_Process_Pressure__c!=0.0)
        {
            MaxProcPresPSIG = currentRV.Converted_Max_Process_Pressure__c;
        }
        else 
        {
            MaxProcPresPSIG = 0.0;
        }
        system.debug('##MaxProcPresPSIG: '+MaxProcPresPSIG+'PosFlowPresPSIG: '+PosFlowPresPSIG);
        // MasterBlaster Records methods
        MasterBlasterRecord = new RV_Master_Blaster__c();
        list<RV_Master_Blaster__c> MBSetList = new list<RV_Master_Blaster__c>();
        MBSetList = [Select id,PosLoad__c,PosEffDia__c,PosFullOP__c,PosIntMethod__c,
                     VacLoad__c,VacEffDia__c,VacFullOP__c,VacIntMethod__c from RV_Master_Blaster__c  
                     where PTC__c=:PTC 
                     and SZC__c=:SZC
                     and BRAND__c=:currentRV.Brand__c limit 1];
        if(MBSetList.size() > 0)
        {
            MasterBlasterRecord = MBSetList[0];
        }

        //Convert pressure and Vacuum methods
        String strRGEUNT = '';
        String strVGEUNT = '';
        /*string strRGEUNT=[select Text__c from RV_Valve_Attributes_Details__c 
where Attribute__c=:'RGEUNT' and numval1__c<:PosSetPresOSIG and numval2__c>=:PosSetPresOSIG limit 1][0].Text__c;

string strVGEUNT=[select Text__c from RV_Valve_Attributes_Details__c 
where Attribute__c=:'VGEUNT' and numval1__c<:VacSetPresOSIG and numval2__c>=:VacSetPresOSIG limit 1][0].Text__c;*/
        
        List<RV_Valve_Attributes_Details__c> rvValueAttribute = new List<RV_Valve_Attributes_Details__c>();
        rvValueAttribute = [select Text__c,Attribute__c,numval1__c,numval2__c 
                            from RV_Valve_Attributes_Details__c where 
                            Attribute__c=:'RGEUNT' OR Attribute__c=:'VGEUNT'
                            ORDER BY Attribute__c,numval1__c,numval2__c];
        for(RV_Valve_Attributes_Details__c rvValAttr: rvValueAttribute)
        {
            if(rvValAttr.Attribute__c == 'RGEUNT')
            {
                if(rvValAttr.numval1__c < PosSetPresOSIG && rvValAttr.numval2__c >= PosSetPresOSIG)
                {
                    strRGEUNT = rvValAttr.Text__c;
                }
            }
            if(rvValAttr.Attribute__c == 'VGEUNT')
            {
                if(rvValAttr.numval1__c < VacSetPresOSIG && rvValAttr.numval2__c >= VacSetPresOSIG)
                {
                    strVGEUNT = rvValAttr.Text__c;
                }
            }
        }
        
        Result res1=new result();        
        res1=unitConversions.convertPressure(RTPRSU,strRGEUNT,RTPRS1);
        ConvertedPressure=res1.dblRetValue;
        
        Result res2=new result();        
        res2=unitConversions.convertPressure(VTPRSU,strVGEUNT,VTPRS1);
        ConvertedVacuum=res2.dblRetValue;
        
        //PosFlowPresPSIG equation related conversions
       If (CurrentRV.Constraint_Product_Selection_By_Flow__c == true)
        {
            if(PosFlowPres==0)
            {
                if((currentRV.Pressure_Setting__c!=null) && (currentRV.Pressure_Setting_Units__c!=null) && (currentRV.Overpressure__c!=null) )
                {
                    Result res=new result();        
                    res=unitConversions.convertPressure(currentRV.Pressure_Setting_Units__c, 'psig',currentRV.Pressure_Setting__c + (currentRV.Pressure_Setting__c * currentRV.Overpressure__c)/100);
                    decPosFlowPresPSIG=res.dblRetValue;
                }               
            }
            else
            {
                decPosFlowPresPSIG=currentRV.Converted_Relieving_Pressure_Value__c;
            }                     
        }
        else if(currentRV.Constraint_Product_Selection_By_Flow__c == false && (currentRV.Pressure_Setting__c!=null))
        {
            Result res=new result();        
            res=unitConversions.convertPressure(currentRV.Pressure_Setting_Units__c, 'psig',(currentRV.Pressure_Setting__c * 2));
            decPosFlowPresPSIG=res.dblRetValue;
        }
        //VacFlowPresPSIG equation related conversions
        If (CurrentRV.Constraint_Product_Selection_By_Flow__c == true)
        {
            if(VacFlowPres==0)
            {
                if((currentRV.Vacuum_Setting__c!=null) && (currentRV.Vacuum_Setting_Units__c!=null) && (currentRV.V_Overpressure_Vacuum_Value__c!=null) )
                {
                    Result res=new result();        
                    res=unitConversions.convertPressure(currentRV.Vacuum_Setting_Units__c, 'psig',currentRV.Vacuum_Setting__c + (currentRV.Vacuum_Setting__c * currentRV.V_Overpressure_Vacuum_Value__c)/100);
                    decVacFlowPresPSIG=res.dblRetValue;
                }               
            }
            else
            {
                decVacFlowPresPSIG=currentRV.V_Converted_Relieving_Vacuum_Value__c;
            }   
                  
        }
        else if(currentRV.Constraint_Product_Selection_By_Flow__c == false && (currentRV.Vacuum_Setting__c!=null))
        {
            Result res=new result();        
            res=unitConversions.convertPressure(currentRV.Vacuum_Setting_Units__c, 'psig',(currentRV.Vacuum_Setting__c * 2));
            decVacFlowPresPSIG=res.dblRetValue;
        }
        PosSettingRecord = new RV_PosSettingLimits__c();
        list<RV_PosSettingLimits__c> posSetList = new list<RV_PosSettingLimits__c>();
        if(MCWGHT != 'N')
        {
            posSetList = [Select id, PalletDesign__c, SpacerYN__c from RV_PosSettingLimits__c  
                          where PTC__c=:PTC 
                          and SZC__c=:SZC 
                          and BackpressureLL__c<:EFFMBP 
                          and BackpressureUL__c>=:EFFMBP 
                          and SettingLL__c<:PosSetPresOSIG 
                          and SettingUL__c>=:PosSetPresOSIG 
                          and PalletMatlCode__c=:MCPALL 
                          and WeightMatlCode__c=:MCWGHT 
                          and PalletType__c=:GPTYPE limit 1];
        }
        else
        {
            posSetList = [Select id, PalletDesign__c, SpacerYN__c from RV_PosSettingLimits__c  
                          where PTC__c=:PTC 
                          and SZC__c=:SZC 
                          and BackpressureLL__c<:EFFMBP 
                          and BackpressureUL__c>=:EFFMBP 
                          and SettingLL__c<:PosSetPresOSIG 
                          and SettingUL__c>=:PosSetPresOSIG 
                          and PalletMatlCode__c=:MCPALL 
                          and (WeightMatlCode__c= 'NA' OR WeightMatlCode__c = 'N')                          
                          and PalletType__c=:GPTYPE limit 1];
        }        
        if(posSetList.size() > 0)
        {
            PosSettingRecord = posSetList[0];
        }
        VacSettingRecord = new RV_VacSettingLimits__c();
        list<RV_VacSettingLimits__c> vacSetList = new list<RV_VacSettingLimits__c>();
        System.debug('##Query printing: '+'PTC: '+PTC+'SZC: '+SZC+'EFFMOP: '+EFFMOP+'VacSetPresOSIG: '+VacSetPresOSIG+'MCVPAL: '+MCVPAL+'MCWGHT: '+MCWGHT+'GPTYPE'+GPTYPE);
        if(MCWGHT != 'N')
        {
            vacSetList = [Select PalletDesign__c, SpacerYN__c, BackpressureUL__c from RV_VacSettingLimits__c 
                          where PTC__c=:PTC 
                          and SZC__c=:SZC 
                          and BackpressureLL__c<:EFFMOP 
                          and BackpressureUL__c>=:EFFMOP 
                          and SettingLL__c<:VacSetPresOSIG 
                          and SettingUL__c>=:VacSetPresOSIG 
                          and PalletMatlCode__c=:MCVPAL 
                          and WeightMatlCode__c=:MCWGHT 
                          and PalletType__c=:GPTYPE limit 1];
        }
        else
        {
            vacSetList = [Select PalletDesign__c, SpacerYN__c, BackpressureUL__c from RV_VacSettingLimits__c 
                          where PTC__c=:PTC 
                          and SZC__c=:SZC 
                          and BackpressureLL__c<:EFFMOP 
                          and BackpressureUL__c>=:EFFMOP 
                          and SettingLL__c<:VacSetPresOSIG 
                          and SettingUL__c>=:VacSetPresOSIG 
                          and PalletMatlCode__c=:MCVPAL 
                          and (WeightMatlCode__c= 'NA' OR WeightMatlCode__c = 'N')  
                          and PalletType__c=:GPTYPE limit 1];
        }
        if(vacSetList.size() > 0)
        {
            VacSettingRecord = vacSetList[0];
        }
        
        List<RV_Outputs__c> rvOutputList = new List<RV_Outputs__c>();
        String fieldsAPIname = FLMutility.getObjectFields('RV_Outputs__c');    
        String soql = 'SELECT ' + fieldsAPIname +' FROM RV_Outputs__c ';
        soql += ' WHERE RV_Outputs_Relation_Field__c =\''+String.escapeSingleQuotes(currentRV.Id)+'\' ';    
        System.debug('@Developer --> soql :' + soql);    
        rvOutputList = Database.query(soql);
        if(rvOutputList.size() > 0)
        {
            if(string.isNotBlank(rvOutputList[0].OA_Override__c))
            {
                OA = rvOutputList[0].OA_Override__c;
            }
            else
            {
                OA = currentRV.OA__c;
            }
            if(string.isNotBlank(rvOutputList[0].OB_Override__c))
            {
                OB = rvOutputList[0].OB_Override__c;
            }
            else
            {
                OB = currentRV.OB__c;
            }
            if(string.isNotBlank(rvOutputList[0].OW_Override__c))
            {
                OW = rvOutputList[0].OW_Override__c;
            }
            else
            {
                OW = currentRV.OW__c;
            }
            if(string.isNotBlank(rvOutputList[0].PC_Override__c))
            {
                PC = rvOutputList[0].PC_Override__c;
            }
            else
            {
                PC = currentRV.PC__c;
            }
        }
        else
        {
            OA = currentRV.OA__c;
            OB = currentRV.OB__c;
            OW = currentRV.OW__c;
            PC = currentRV.PC__c;
        }
        mapRV_Attribute=new Map<String, string>();
        system.debug('*** calling getattribute method.');
        mapRVAttr.put('ValveSubModel',ValveSubModel);
        WeightD = new RVWeightDetermination(currentRV);
        mapWeight=WeightD.getInitialWeightDetermination(currentRV, mapRVAttr);
        setmapRVSAttrInitalItems();
        mapRV_Attribute=getMapAttribute(); 
        setmapRVSAttrInitalItems();
        //Service Ticket #202187 RHATHI shifted XMLattributesMap(); from here to the end of this method.. 
        getQuoteAttributes();
        //WeightD = new RVWeightDetermination(currentRV);
        mapWeight=WeightD.getInitialWeightDetermination(currentRV, mapRVAttr);
        XMLattributesMap();//Service Ticket #202187, RHATHI
        System.debug('%%% currentRV.Element_Material__c = '+currentRV.Element_Material__c);
        System.debug('%%% ValveSubModel = '+mapRVAttr.get('ValveSubModel'));
    }
    
       
    public RV_Master_Blaster__c MasterBlasterRecord;
    public RV_PosSettingLimits__c PosSettingRecord;
    public RV_VacSettingLimits__c VacSettingRecord;
    
    public decimal decPosFlowPresPSIG{get;set;}
    public decimal decVacFlowPresPSIG{get;set;}
    public decimal ConvertedPressure{get;set;}
    public decimal ConvertedVacuum{get;set;}
    public map<string,string> mapRV_Attribute {get;set;}
    public Map<String, String> mapRVAttr = new Map<String, String>();
    public Map<String, String> XmlMapRVAttr = new Map<String, String>();
    public void setmapRVSAttrInitalItems()
    {
        // issue 4207 - GPDS05/6/7/8 missing John Vaughan Coastal Cloud
        mapRVAttr.put('GPDS05',posDiaphragmComponentPart);
        mapRVAttr.put('GPDS06',posDiaphragmBackupComponentPart);
        mapRVAttr.put('GPDS07',vacDiaphragmComponentPart);
        mapRVAttr.put('GPDS08',vacDiaphragmBackupComponentPart);

        mapRVAttr.put('ASSYPARTNO',ASSYPARTNO);
        mapRVAttr.put('UOMSystem',UOMSystem);
        mapRVAttr.put('PRDLIN',PRDLIN);
        mapRVAttr.put('GPDS13',mapWeight.get('GPDS13'));
        System.debug('VVVVVVGPDS13' +mapWeight.get('GPDS13'));
        System.debug('VVVVVVGPDS14' +mapWeight.get('GPDS14'));
        mapRVAttr.put('GPDS14',mapWeight.get('GPDS14'));
        mapRVAttr.put('GPDS15',mapWeight.get('GPDS15'));
        mapRVAttr.put('GPDS16',mapWeight.get('GPDS16'));
        mapRVAttr.put('ValveMAWPPSIG',String.valueOf(ValveMAWPPSIG));
        mapRVAttr.put('BodyMAWPpsig',String.valueOf(BodyMAWPpsig));
        mapRVAttr.put('VacPalletMAWPpsig',String.valueOf(VacPalletMAWPpsig));
        system.debug('ValveMAWPPSIG2nd'+mapRVAttr.get('ValveMAWPPSIG')); 
        system.debug('ValveMAWPPSIG2nd'+String.valueOf(ValveMAWPPSIG)); 
        system.debug('BodyMAWPpsig2nd'+mapRVAttr.get('BodyMAWPpsig'));
        system.debug('VacPalletMAWPpsig2nd'+mapRVAttr.get('VacPalletMAWPpsig'));
        system.debug('CONSTBDYTST2nd'+String.valueOf(CONSTBDYTST)); 
        mapRVAttr.put('PosFlow',PosFlow);
        mapRVAttr.put('VacFlow',VacFlow);
        mapRVAttr.put('Brand',Brand);
        mapRVAttr.put('RTPRS1',String.valueOf(RTPRS1));
        mapRVAttr.put('RTPRSU',RTPRSU);
        mapRVAttr.put('GPRSC1',String.valueOf(GPRSC1));
        mapRVAttr.put('PosBackPres',String.valueOf(PosBackPres));
        mapRVAttr.put('PosBackPresUOM',PosBackPresUOM);
        mapRVAttr.put('PosBackPresPSIG',String.valueOf(PosBackPresPSIG));
        mapRVAttr.put('VTPRS1',String.valueOf(VTPRS1));
        mapRVAttr.put('VTPRSU',VTPRSU);
        mapRVAttr.put('GVRSC1',String.valueOf(GVRSC1));
        mapRVAttr.put('MaxProcPres',String.valueOf(MaxProcPres));
        mapRVAttr.put('MaxProcPresUOM',MaxProcPresUOM);
        mapRVAttr.put('MaxProcPresPSIG',String.valueOf(MaxProcPresPSIG));
        mapRVAttr.put('AtmPres',String.valueOf(AtmPres));
        mapRVAttr.put('AtmPresUOM',AtmPresUOM);
        mapRVAttr.put('AtmPresPSIA',String.valueOf(AtmPresPSIA));
        mapRVAttr.put('DPM',DPM);
        mapRVAttr.put('PosDomePresMax',String.valueOf(PosDomePresMax));
        mapRVAttr.put('PosDomePresMaxFact',String.valueOf(PosDomePresMaxFact));
        mapRVAttr.put('PosMediaName',PosMediaName);
        mapRVAttr.put('PosK',String.valueOf(PosK));
        mapRVAttr.put('PosMW',String.valueOf(PosMW));
        mapRVAttr.put('PosZ',String.valueOf(PosZ));
        mapRVAttr.put('POSFLOWRATE',String.valueOf(POSFLOWRATE));
        mapRVAttr.put('POSFLOWRATEUOM',POSFLOWRATEUOM);
        mapRVAttr.put('POSFLOWRATESCFH',String.valueOf(POSFLOWRATESCFH));
        mapRVAttr.put('POSFLOWPRES',String.valueOf(POSFLOWPRES));
        mapRVAttr.put('PosFlowPresUOM',PosFlowPresUOM);
        mapRVAttr.put('GPOPCT',String.valueOf(GPOPCT));
        mapRVAttr.put('PosFlowPresPSIG',String.valueOf(PosFlowPresPSIG));
        mapRVAttr.put('PosTemp',String.valueOf(PosTemp));
        mapRVAttr.put('PosTempUOM',PosTempUOM);
        mapRVAttr.put('PosTempDEGR',String.valueOf(PosTempDEGR));
        mapRVAttr.put('VACDPM',VACDPM);
        mapRVAttr.put('VacMediaName',VacMediaName);
        mapRVAttr.put('VacK',String.valueOf(VacK));
        mapRVAttr.put('VacMW',String.valueOf(VacMW));
        mapRVAttr.put('VacZ',String.valueOf(VacZ));
        mapRVAttr.put('VacFlowRate',String.valueOf(VacFlowRate));
        mapRVAttr.put('VacFlowRateUOM',VacFlowRateUOM);
        mapRVAttr.put('VacFlowRateSCFH',String.valueOf(VacFlowRateSCFH));
        mapRVAttr.put('VacFlowPres',String.valueOf(VacFlowPres));
        mapRVAttr.put('VacFlowPresUOM',VacFlowPresUOM);
        mapRVAttr.put('GVOPCT',String.valueOf(GVOPCT));
        mapRVAttr.put('VacFlowPresPSIG',String.valueOf(VacFlowPresPSIG));
        mapRVAttr.put('VacTemp',String.valueOf(VacTemp));
        mapRVAttr.put('VacTempUOM',VacTempUOM);
        mapRVAttr.put('VacTempDEGR',String.valueOf(VacTempDEGR));
        mapRVAttr.put('PED',PED);
        mapRVAttr.put('ATEX',ATEX);
        mapRVAttr.put('GasGroup',GasGroup);
        mapRVAttr.put('ATEXZONE',ATEXZONE);
        mapRVAttr.put('CUTR',CUTR);
        mapRVAttr.put('NACE',NACE);
        mapRVAttr.put('VENTING',VENTING);
        mapRVAttr.put('OPPERCENT',OPPERCENT);
        mapRVAttr.put('FACompliant',FACompliant);
        mapRVAttr.put('PTC',PTC);
        mapRVAttr.put('SZC',SZC);
        mapRVAttr.put('HCLASS',HCLASS);
        mapRVAttr.put('MCBODY',MCBODY);
        mapRVAttr.put('GPFACE',GPFACE);
        mapRVAttr.put('MCSEAT',MCSEAT);
        mapRVAttr.put('MCPALL',MCPALL);
        mapRVAttr.put('GPTYPE',GPTYPE);
        mapRVAttr.put('MCDPHM',MCDPHM);
        mapRVAttr.put('MCVPAL',MCVPAL);
        mapRVAttr.put('MCPSGD',MCPSGD);
        mapRVAttr.put('MCWGHT',MCWGHT);
        mapRVAttr.put('MCSPRG',MCSPRG);
        mapRVAttr.put('MCFAST',MCFAST);
        mapRVAttr.put('MCSTMJ',MCSTMJ);
        mapRVAttr.put('GPAINT',GPAINT);
        mapRVAttr.put('MCCOTB',MCCOTB);
        mapRVAttr.put('MCCOTP',MCCOTP);
        mapRVAttr.put('MCELMT',MCELMT);
        mapRVAttr.put('GOUTOP',GOUTOP);
        mapRVAttr.put('VPRTOP',VPRTOP);
        mapRVAttr.put('POSPROXSENSOR',POSPROXSENSOR);
        mapRVAttr.put('VACPROXSENSOR',VACPROXSENSOR);
        mapRVAttr.put('GPACT',GPACT);
        mapRVAttr.put('ManualBlowdown',ManualBlowdown);
        mapRVAttr.put('RemoteSense',RemoteSense);
        mapRVAttr.put('PilotExhstPiped',PilotExhstPiped);
        mapRVAttr.put('FieldTestConnect',FieldTestConnect);
        mapRVAttr.put('PilotSplyFilter',PilotSplyFilter);
        mapRVAttr.put('GMTH21',GMTH21);
        mapRVAttr.put('XRAY',XRAY);
        mapRVAttr.put('FWLDP',FWLDP);
        mapRVAttr.put('PMI',PMI);
        mapRVAttr.put('LDP',LDP);
        mapRVAttr.put('USONICEXAM',USONICEXAM);
        mapRVAttr.put('MAGPARTEXAM',MAGPARTEXAM);
        mapRVAttr.put('PARTNUMBER',PARTNUMBER);
        mapRVAttr.put('PARTNUMBERDESC',PARTNUMBERDESC);
        mapRVAttr.put('BRINHARDEXAM',BRINHARDEXAM);
        mapRVAttr.put('CHARPYIMPEXAM',CHARPYIMPEXAM);
        mapRVAttr.put('VISCASTEXAM',VISCASTEXAM);
        mapRVAttr.put('IGCEXAM',IGCEXAM);
        mapRVAttr.put('SHLTSTMETHBDY',SHLTSTMETHBDY);
        mapRVAttr.put('ASSYLOCATION',ASSYLOCATION);
        mapRVAttr.put('MATLSOURCE',MATLSOURCE);
        mapRVAttr.put('ValveSubModel',ValveSubModel);
        System.debug('VVVV  ASYTYP--------' +ASYTYP);
        System.debug('VVVV  BODYDESIGN--------' +BODYDESIGN);
        mapRVAttr.put('ASYTYP',ASYTYP);
        mapRVAttr.put('BODYDESIGN',BODYDESIGN);
        mapRVAttr.put('BodyDesign',BodyDesign);
        mapRVAttr.put('FASubModel',FASubModel);
        mapRVAttr.put('ESZC',ESZC);
        mapRVAttr.put('VENDORPAINT',VENDORPAINT);
        mapRVAttr.put('INHOUSEPAINT',INHOUSEPAINT);
        mapRVAttr.put('RGEUNT',RGEUNT);
        mapRVAttr.put('VGEUNT',VGEUNT);
        mapRVAttr.put('QTYLL',String.valueOf(QTYLL));
        mapRVAttr.put('QTYUL',String.valueOf(QTYUL));
        mapRVAttr.put('QTY',String.valueOf(QTY));
        mapRVAttr.put('Model',Model);
        mapRVAttr.put('SubModel',SubModel);
        mapRVAttr.put('SteamJacketMatlCode',SteamJacketMatlCode);
        mapRVAttr.put('PROXSENSORPRES',PROXSENSORPRES);
        mapRVAttr.put('DrillingCode',DrillingCode);
        mapRVAttr.put('BodyMatlCode',BodyMatlCode);
        mapRVAttr.put('PosMatlID',PosMatlID);
        mapRVAttr.put('VisualCastingExam',VisualCastingExam);
        mapRVAttr.put('ShlTstBdyPSIG',String.valueOf(ShlTstBdyPSIG));
        mapRVAttr.put('ShlTstBdyPSIGMx',String.valueOf(ShlTstBdyPSIGMx));
        mapRVAttr.put('SHLTSTACTPSIGMx',String.valueOf(SHLTSTACTPSIGMx));
        mapRVAttr.put('VacSettingMax',String.valueOf(VacSettingMax));
        mapRVAttr.put('VacValveLeakMax',String.valueOf(VacValveLeakMax));
        mapRVAttr.put('FilletLiquidDye',FilletLiquidDye);
        mapRVAttr.put('MaterialSource',MaterialSource);
        mapRVAttr.put('EFFMOP',String.valueOf(EFFMOP));
        //Equation Attributes
        mapRVAttr.put('PosSetPresOSIG',String.valueOf(PosSetPresOSIG));
        mapRVAttr.put('VacSetPresOSIG',String.valueOf(VacSetPresOSIG)); 
        mapRVAttr.put('PosDomePresMax',String.valueOf(PosDomePresMax));
        mapRVAttr.put('PosPilotLeakHigh',String.valueOf(PosPilotLeakHigh));
        mapRVAttr.put('PosPilotLeakLow',String.valueOf(PosPilotLeakLow));
        mapRVAttr.put('PosPilotSetMax',String.valueOf(PosPilotSetMax));
        mapRVAttr.put('PosPilotSetMin',String.valueOf(PosPilotSetMin));
        mapRVAttr.put('POSPROXSENSOR',POSPROXSENSOR);
        
        mapRVAttr.put('PosSettingMinFact',String.valueOf(PosSettingMinFact));
        mapRVAttr.put('PosSettingMaxFact',String.valueOf(PosSettingMaxFact));
        mapRVAttr.put('PosValveLeakMinFact',String.valueOf(PosValveLeakMinFact));
        mapRVAttr.put('PosValveLeakMaxFact',String.valueOf(PosValveLeakMaxFact));       
        
        mapRVAttr.put('PosSettingMax',String.valueOf(PosSettingMax));
        mapRVAttr.put('PosSettingMin',String.valueOf(PosSettingMin));
        mapRVAttr.put('PosStaticPresMax',String.valueOf(PosStaticPresMax));
        mapRVAttr.put('PosStaticPresMin',String.valueOf(PosStaticPresMin));
        mapRVAttr.put('PosValveLeakMax',String.valueOf(PosValveLeakMax));
        mapRVAttr.put('PosValveLeakMin',String.valueOf(PosValveLeakMin));
        mapRVAttr.put('PTC',PTC);
        mapRVAttr.put('RemoteSense',RemoteSense);
        mapRVAttr.put('RGEUNT',RGEUNT);
        mapRVAttr.put('RTPRS1',String.valueOf(RTPRS1));
        mapRVAttr.put('RTPRSU',RTPRSU);
        mapRVAttr.put('SHLTSTACTPSIG',SHLTSTACTPSIG);
        mapRVAttr.put('SHLTSTACTPSIGMX',SHLTSTACTPSIGMX);
        mapRVAttr.put('SHLTSTBDYPSIG',String.valueOf(SHLTSTBDYPSIG));
        mapRVAttr.put('SHLTSTBDYPSIGMX',String.valueOf(SHLTSTBDYPSIGMX));
        mapRVAttr.put('SHLTSTMETHBDY',SHLTSTMETHBDY);
        mapRVAttr.put('SOURCINGOPT',SOURCINGOPT);
        mapRVAttr.put('SZC',SZC);
        mapRVAttr.put('USONICEXAM',USONICEXAM);
        mapRVAttr.put('VacDomePresMax',String.valueOf(VacDomePresMax));
        mapRVAttr.put('VacPilotLeakHigh',String.valueOf(VacPilotLeakHigh));
        mapRVAttr.put('VacPilotLeakLow',String.valueOf(VacPilotLeakLow));
        mapRVAttr.put('VacPilotSetMax',String.valueOf(VacPilotSetMax));
        mapRVAttr.put('VacPilotSetMin',String.valueOf(VacPilotSetMin));
        mapRVAttr.put('VACPROXSENSOR',VACPROXSENSOR);
        mapRVAttr.put('VacSettingMax',String.valueOf(VacSettingMax));
        mapRVAttr.put('VacSettingMin',String.valueOf(VacSettingMin));
        mapRVAttr.put('VacStaticPresMax',String.valueOf(VacStaticPresMax));
        mapRVAttr.put('VacStaticPresMin',String.valueOf(VacStaticPresMin));
        mapRVAttr.put('VacValveLeakMax',String.valueOf(VacValveLeakMax));
        mapRVAttr.put('VacValveLeakMin',String.valueOf(VacValveLeakMin));
        //MasterBlaster Attributes
        mapRVAttr.put('PosLoad',PosLoad);
        mapRVAttr.put('VacLoad',VacLoad);
        mapRVAttr.put('PosSpacer',PosSpacer);
        mapRVAttr.put('VacSpacer',VacSpacer);
        mapRVAttr.put('PosPalletDesign',PosPalletDesign);
        mapRVAttr.put('VacPalletDesign',VacPalletDesign);
        mapRVAttr.put('PNMCPALL',PNMCPALL);
        mapRVAttr.put('GMODEL1',GMODEL1);
        mapRVAttr.put('GMODEL2',GMODEL2);
        mapRVAttr.put('GMODEL3',GMODEL3);
        mapRVAttr.put('GMODEL4',GMODEL4);
        mapRVAttr.put('GMODEL5',GMODEL5);
        mapRVAttr.put('GMODEL6',GMODEL6);
        mapRVAttr.put('GMODEL7',GMODEL7);
        mapRVAttr.put('GMODEL8',GMODEL8);
        mapRVAttr.put('GMODEL9',GMODEL9);
        mapRVAttr.put('GMODELN',GMODELN);
        mapRVAttr.put('GMODEL',GMODEL);
        mapRVAttr.put('OA',OA);
        mapRVAttr.put('OB',OB);
        mapRVAttr.put('OW',OW);
        mapRVAttr.put('PC',PC);
        mapRVAttr.put('WtPalletFiberglassVacuumDesign',WtPalletFiberglassVacuumDesign);
        mapRVAttr.put('FBGModel', FBGModel); //Service Ticket #200844
    }
    
    
    public void XMLattributesMap()
    {
        XmlMapRVAttr.put('ASSYPARTNO',ASSYPARTNO);
        XmlMapRVAttr.put('UOMSystem',UOMSystem);
        XmlMapRVAttr.put('GPDS13',mapWeight.get('GPDS13'));
        XmlMapRVAttr.put('GPDS14',mapWeight.get('GPDS14'));
        XmlMapRVAttr.put('GPDS15',mapWeight.get('GPDS15'));
        XmlMapRVAttr.put('GPDS16',mapWeight.get('GPDS16'));
        XmlMapRVAttr.put('ValveMAWPPSIG',String.valueOf(ValveMAWPPSIG));
        XmlMapRVAttr.put('BodyMAWPpsig',String.valueOf(BodyMAWPpsig));
        XmlMapRVAttr.put('VacPalletMAWPpsig',String.valueOf(VacPalletMAWPpsig));
        XmlMapRVAttr.put('PosFlow',PosFlow);
        XmlMapRVAttr.put('VacFlow',VacFlow);
        XmlMapRVAttr.put('Brand',Brand);
        XmlMapRVAttr.put('RTPRS1',String.valueOf(RTPRS1));
        XmlMapRVAttr.put('RTPRSU',RTPRSU);
        XmlMapRVAttr.put('GPRSC1',String.valueOf(GPRSC1));
        XmlMapRVAttr.put('PosBackPres',String.valueOf(PosBackPres));
        XmlMapRVAttr.put('PosBackPresUOM',PosBackPresUOM);
        XmlMapRVAttr.put('PosBackPresPSIG',String.valueOf(PosBackPresPSIG));
        XmlMapRVAttr.put('VTPRS1',String.valueOf(VTPRS1));
        XmlMapRVAttr.put('VTPRSU',VTPRSU);
        XmlMapRVAttr.put('GVRSC1',String.valueOf(GVRSC1));
        XmlMapRVAttr.put('MaxProcPres',String.valueOf(MaxProcPres));
        XmlMapRVAttr.put('MaxProcPresUOM',MaxProcPresUOM);
        XmlMapRVAttr.put('MaxProcPresPSIG',String.valueOf(MaxProcPresPSIG));
        XmlMapRVAttr.put('AtmPres',String.valueOf(AtmPres));
        XmlMapRVAttr.put('AtmPresUOM',AtmPresUOM);
        XmlMapRVAttr.put('AtmPresPSIA',String.valueOf(AtmPresPSIA));
        XmlMapRVAttr.put('DPM',DPM);
        XmlMapRVAttr.put('PosDomePresMax',String.valueOf(PosDomePresMax));
        XmlMapRVAttr.put('PosMediaName',PosMediaName);
        XmlMapRVAttr.put('PosK',String.valueOf(PosK));
        XmlMapRVAttr.put('PosMW',String.valueOf(PosMW));
        XmlMapRVAttr.put('PosZ',String.valueOf(PosZ));
        XmlMapRVAttr.put('POSFLOWRATE',String.valueOf(POSFLOWRATE));
        XmlMapRVAttr.put('POSFLOWRATEUOM',POSFLOWRATEUOM);
        XmlMapRVAttr.put('POSFLOWRATESCFH',String.valueOf(POSFLOWRATESCFH));
        XmlMapRVAttr.put('POSFLOWPRES',String.valueOf(POSFLOWPRES));
        XmlMapRVAttr.put('PosFlowPresUOM',PosFlowPresUOM);
        XmlMapRVAttr.put('GPOPCT',String.valueOf(GPOPCT));
        XmlMapRVAttr.put('PosFlowPresPSIG',String.valueOf(PosFlowPresPSIG));
        XmlMapRVAttr.put('PosTemp',String.valueOf(PosTemp));
        XmlMapRVAttr.put('PosTempUOM',PosTempUOM);
        XmlMapRVAttr.put('PosTempDEGR',String.valueOf(PosTempDEGR));
        XmlMapRVAttr.put('PRDLIN',PRDLIN);
        XmlMapRVAttr.put('VACDPM',VACDPM);
        XmlMapRVAttr.put('VacMediaName',VacMediaName);
        XmlMapRVAttr.put('VacK',String.valueOf(VacK));
        XmlMapRVAttr.put('VacMW',String.valueOf(VacMW));
        XmlMapRVAttr.put('VacZ',String.valueOf(VacZ));
        XmlMapRVAttr.put('VacFlowRate',String.valueOf(VacFlowRate));
        XmlMapRVAttr.put('VacFlowRateUOM',VacFlowRateUOM);
        XmlMapRVAttr.put('VacFlowRateSCFH',String.valueOf(VacFlowRateSCFH));
        XmlMapRVAttr.put('VacFlowPres',String.valueOf(VacFlowPres));
        XmlMapRVAttr.put('VacFlowPresUOM',VacFlowPresUOM);
        XmlMapRVAttr.put('GVOPCT',String.valueOf(GVOPCT));
        XmlMapRVAttr.put('VacFlowPresPSIG',String.valueOf(VacFlowPresPSIG));
        XmlMapRVAttr.put('VacTemp',String.valueOf(VacTemp));
        XmlMapRVAttr.put('VacTempUOM',VacTempUOM);
        XmlMapRVAttr.put('VacTempDEGR',String.valueOf(VacTempDEGR));
        XmlMapRVAttr.put('PED',PED);
        XmlMapRVAttr.put('ATEX',ATEX);
        XmlMapRVAttr.put('GasGroup',GasGroup);
        XmlMapRVAttr.put('ATEXZONE',ATEXZONE);
        XmlMapRVAttr.put('CUTR',CUTR);
        XmlMapRVAttr.put('NACE',NACE);
        XmlMapRVAttr.put('VENTING',VENTING);
        XmlMapRVAttr.put('OPPERCENT',OPPERCENT);
        XmlMapRVAttr.put('FACompliant',FACompliant);
        XmlMapRVAttr.put('PTC',PTC);
        XmlMapRVAttr.put('SZC',SZC);
        XmlMapRVAttr.put('HCLASS',HCLASS);
        XmlMapRVAttr.put('MCBODY',MCBODY);
        XmlMapRVAttr.put('GPFACE',GPFACE);
        XmlMapRVAttr.put('MCSEAT',MCSEAT);
        XmlMapRVAttr.put('MCPALL',MCPALL);
        XmlMapRVAttr.put('GPTYPE',GPTYPE);
        XmlMapRVAttr.put('MCDPHM',MCDPHM);
        XmlMapRVAttr.put('MCVPAL',MCVPAL);
        XmlMapRVAttr.put('MCPSGD',MCPSGD);
        XmlMapRVAttr.put('MCWGHT',MCWGHT);
        XmlMapRVAttr.put('MCSPRG',MCSPRG);
        XmlMapRVAttr.put('MCFAST',MCFAST);
        XmlMapRVAttr.put('MCSTMJ',MCSTMJ);
        XmlMapRVAttr.put('GPAINT',GPAINT);
        XmlMapRVAttr.put('MCCOTB',MCCOTB);
        XmlMapRVAttr.put('MCCOTP',MCCOTP);
        XmlMapRVAttr.put('MCELMT',MCELMT);
        XmlMapRVAttr.put('GOUTOP',GOUTOP);
        XmlMapRVAttr.put('VPRTOP',VPRTOP);
        XmlMapRVAttr.put('POSPROXSENSOR',POSPROXSENSOR);
        XmlMapRVAttr.put('VACPROXSENSOR',VACPROXSENSOR);
        XmlMapRVAttr.put('GPACT',GPACT);
        XmlMapRVAttr.put('ManualBlowdown',ManualBlowdown);
        XmlMapRVAttr.put('RemoteSense',RemoteSense);
        XmlMapRVAttr.put('PilotExhstPiped',PilotExhstPiped);
        XmlMapRVAttr.put('FldTestCon',FieldTestConnect);
        XmlMapRVAttr.put('PilotSplyFilter',PilotSplyFilter);
        XmlMapRVAttr.put('GMTH21',GMTH21);
        XmlMapRVAttr.put('XRAY',XRAY);
        XmlMapRVAttr.put('FWLDP',FWLDP);
        XmlMapRVAttr.put('PMI',PMI);
        XmlMapRVAttr.put('LDP',LDP);
        XmlMapRVAttr.put('USONICEXAM',USONICEXAM);
        XmlMapRVAttr.put('MAGPARTEXAM',MAGPARTEXAM);
        XmlMapRVAttr.put('PARTNUMBER',PARTNUMBER);
        XmlMapRVAttr.put('PARTNUMBERDESC',PARTNUMBERDESC);
        XmlMapRVAttr.put('BRINHARDEXAM',BRINHARDEXAM);
        XmlMapRVAttr.put('CHARPYIMPEXAM',CHARPYIMPEXAM);
        XmlMapRVAttr.put('VISCASTEXAM',VISCASTEXAM);
        XmlMapRVAttr.put('IGCEXAM',IGCEXAM);
        XmlMapRVAttr.put('SHLTSTMETHBDY',SHLTSTMETHBDY);
        XmlMapRVAttr.put('ASSYLOCATION',ASSYLOCATION);
        XmlMapRVAttr.put('MATLSOURCE',MATLSOURCE);
        XmlMapRVAttr.put('ASYTYP',ASYTYP);
        XmlMapRVAttr.put('BODYDESIGN',BODYDESIGN);
        XmlMapRVAttr.put('FASubModel',FASubModel);
        XmlMapRVAttr.put('ESZC',ESZC);
        XmlMapRVAttr.put('VENDORPAINT',VENDORPAINT);
        XmlMapRVAttr.put('INHOUSEPAINT',INHOUSEPAINT);
        XmlMapRVAttr.put('RGEUNT',RGEUNT);
        XmlMapRVAttr.put('VGEUNT',VGEUNT);
        XmlMapRVAttr.put('QTYLL',String.valueOf(QTYLL));
        XmlMapRVAttr.put('QTYUL',String.valueOf(QTYUL));
        XmlMapRVAttr.put('Model',Model);
        XmlMapRVAttr.put('SubModel',SubModel);
        XmlMapRVAttr.put('SteamJacketMatlCode',SteamJacketMatlCode);
        XmlMapRVAttr.put('PROXSENSORPRES',PROXSENSORPRES);
        XmlMapRVAttr.put('DrillingCode',DrillingCode);
        XmlMapRVAttr.put('BodyMatlCode',BodyMatlCode);
        XmlMapRVAttr.put('PosMatlID',PosMatlID);
        XmlMapRVAttr.put('VisualCastingExam',VisualCastingExam);
        XmlMapRVAttr.put('ShlTstBdyPSIG',String.valueOf(ShlTstBdyPSIG));
        XmlMapRVAttr.put('ShlTstBdyPSIGMx',String.valueOf(ShlTstBdyPSIGMx));
        XmlMapRVAttr.put('SHLTSTACTPSIGMx',String.valueOf(SHLTSTACTPSIGMx));
        XmlMapRVAttr.put('VacSettingMax',String.valueOf(VacSettingMax));
        XmlMapRVAttr.put('VacValveLeakMax',String.valueOf(VacValveLeakMax));
        XmlMapRVAttr.put('FilletLiquidDye',FilletLiquidDye);
        XmlMapRVAttr.put('MaterialSource',MaterialSource);
        XmlMapRVAttr.put('EFFMOP',String.valueOf(EFFMOP));
        //Equation Attributes
        XmlMapRVAttr.put('PosSetPresOSIG',String.valueOf(PosSetPresOSIG));
        XmlMapRVAttr.put('VacSetPresOSIG',String.valueOf(VacSetPresOSIG)); 
        XmlMapRVAttr.put('PosDomePresMax',String.valueOf(PosDomePresMax));
        XmlMapRVAttr.put('PosPilotLeakHi',String.valueOf(PosPilotLeakHigh));
        XmlMapRVAttr.put('PosPilotLeakLow',String.valueOf(PosPilotLeakLow));
        XmlMapRVAttr.put('PosPilotSetMax',String.valueOf(PosPilotSetMax));
        XmlMapRVAttr.put('PosPilotSetMin',String.valueOf(PosPilotSetMin));
        XmlMapRVAttr.put('POSPROXSENSOR',POSPROXSENSOR);     
        XmlMapRVAttr.put('PosSettingMinFact',String.valueOf(PosSettingMinFact));
        XmlMapRVAttr.put('PosSettingMaxFact',String.valueOf(PosSettingMaxFact));
        XmlMapRVAttr.put('PosValveLeakMinFact',String.valueOf(PosValveLeakMinFact));
        XmlMapRVAttr.put('PosValveLeakMaxFact',String.valueOf(PosValveLeakMaxFact));          
        XmlMapRVAttr.put('PosSettingMax',String.valueOf(PosSettingMax));
        XmlMapRVAttr.put('PosSettingMin',String.valueOf(PosSettingMin));
        XmlMapRVAttr.put('PosStatPresMax',String.valueOf(PosStaticPresMax));
        XmlMapRVAttr.put('PosStatPresMin',String.valueOf(PosStaticPresMin));
        XmlMapRVAttr.put('PosValveLeakMax',String.valueOf(PosValveLeakMax));
        XmlMapRVAttr.put('PosValveLeakMin',String.valueOf(PosValveLeakMin));
        XmlMapRVAttr.put('PTC',PTC);
        XmlMapRVAttr.put('RemoteSense',RemoteSense);
        XmlMapRVAttr.put('RGEUNT',RGEUNT);
        XmlMapRVAttr.put('RTPRS1',String.valueOf(RTPRS1));
        XmlMapRVAttr.put('RTPRSU',RTPRSU);
        XmlMapRVAttr.put('SHLTSTACTPSIG',SHLTSTACTPSIG);
        XmlMapRVAttr.put('SHLTSTACTPSIGMX',SHLTSTACTPSIGMX);
        XmlMapRVAttr.put('SHLTSTBDYPSIG',String.valueOf(SHLTSTBDYPSIG));
        XmlMapRVAttr.put('SHLTSTBDYPSIGMX',String.valueOf(SHLTSTBDYPSIGMX));
        //mapRVAttr.put('SHLTSTMETHBDY',SHLTSTMETHBDY);
        XmlMapRVAttr.put('SOURCINGOPT',SOURCINGOPT);
        XmlMapRVAttr.put('SZC',SZC);
        XmlMapRVAttr.put('USONICEXAM',USONICEXAM);
        XmlMapRVAttr.put('VacDomePresMax',String.valueOf(VacDomePresMax));
        XmlMapRVAttr.put('VacPilotLeakHi',String.valueOf(VacPilotLeakHigh));
        XmlMapRVAttr.put('VacPilotLeakLow',String.valueOf(VacPilotLeakLow));
        XmlMapRVAttr.put('VacPilotSetMax',String.valueOf(VacPilotSetMax));
        XmlMapRVAttr.put('VacPilotSetMin',String.valueOf(VacPilotSetMin));
        XmlMapRVAttr.put('VACPROXSENSOR',VACPROXSENSOR);
        XmlMapRVAttr.put('VacSettingMax',String.valueOf(VacSettingMax));
        XmlMapRVAttr.put('VacSettingMin',String.valueOf(VacSettingMin));
        XmlMapRVAttr.put('VacStatPresMax',String.valueOf(VacStaticPresMax));
        XmlMapRVAttr.put('VacStatPresMin',String.valueOf(VacStaticPresMin));
        XmlMapRVAttr.put('VacValveLeakMax',String.valueOf(VacValveLeakMax));
        XmlMapRVAttr.put('VacValveLeakMin',String.valueOf(VacValveLeakMin));
        //MasterBlaster Attributes
        XmlMapRVAttr.put('PosLoad',PosLoad);
        XmlMapRVAttr.put('VacLoad',VacLoad);
        XmlMapRVAttr.put('PosSpacer',PosSpacer);
        XmlMapRVAttr.put('VacSpacer',VacSpacer);
        XmlMapRVAttr.put('PosPalletDesign',PosPalletDesign);
        XmlMapRVAttr.put('VacPalletDesign',VacPalletDesign);
        //Missed Attributes
        XmlMapRVAttr.put('FBASSY',FBASSY);
        XmlMapRVAttr.put('GMODEL',GMODEL);
        XmlMapRVAttr.put('GPDS03',GPDS03);
        XmlMapRVAttr.put('GPDS05',mapWeight.get('GPDS05'));
        XmlMapRVAttr.put('GPDS06',mapWeight.get('GPDS06'));
        XmlMapRVAttr.put('GPDS07',mapWeight.get('GPDS07'));
        XmlMapRVAttr.put('GPDS08',mapWeight.get('GPDS08'));
       //XmlMapRVAttr.put('GPDS09',mapWeight.get('GPDS09'));
        XmlMapRVAttr.put('GPDS09',GPDS09);
        XmlMapRVAttr.put('GPDS17',mapWeight.get('GPDS17'));
        XmlMapRVAttr.put('GPDS18',mapWeight.get('GPDS18'));
        XmlMapRVAttr.put('GPDS19',mapWeight.get('GPDS19'));
        XmlMapRVAttr.put('GPDS20',mapWeight.get('GPDS20'));
        XmlMapRVAttr.put('GPDS21',mapWeight.get('GPDS21'));
        XmlMapRVAttr.put('GPDS22',mapWeight.get('GPDS22'));
        XmlMapRVAttr.put('GPDS23',mapWeight.get('GPDS23'));
        XmlMapRVAttr.put('GPDS24',mapWeight.get('GPDS24'));
        XmlMapRVAttr.put('GPDS25',mapWeight.get('GPDS25'));
        XmlMapRVAttr.put('GPDS26',mapWeight.get('GPDS26'));
        XmlMapRVAttr.put('GPDS27',mapWeight.get('GPDS27'));
        XmlMapRVAttr.put('GPDS28',mapWeight.get('GPDS28'));
        XmlMapRVAttr.put('GPDS29',mapWeight.get('GPDS29'));
        XmlMapRVAttr.put('GPDS30',mapWeight.get('GPDS30'));
        XmlMapRVAttr.put('GPDS31',mapWeight.get('GPDS31'));
        XmlMapRVAttr.put('GPDS32',mapWeight.get('GPDS32'));
        XmlMapRVAttr.put('GPDS33',mapWeight.get('GPDS33'));
        XmlMapRVAttr.put('GPDS34',mapWeight.get('GPDS34'));
        XmlMapRVAttr.put('GPDS35',mapWeight.get('GPDS35'));
        XmlMapRVAttr.put('GPDS36',mapWeight.get('GPDS36'));
        XmlMapRVAttr.put('GPDS37',mapWeight.get('GPDS37'));
        XmlMapRVAttr.put('GPDS38',mapWeight.get('GPDS38'));
        XmlMapRVAttr.put('GPDS39',mapWeight.get('GPDS39'));
        XmlMapRVAttr.put('GPDS40',mapWeight.get('GPDS40'));
        XmlMapRVAttr.put('GPDS41',mapWeight.get('GPDS41'));
        XmlMapRVAttr.put('GPDS42',mapWeight.get('GPDS42'));
        XmlMapRVAttr.put('GPDS43',mapWeight.get('GPDS43'));
        XmlMapRVAttr.put('GPDS44',mapWeight.get('GPDS44'));
        XmlMapRVAttr.put('GTAG01',GTAG01);
        XmlMapRVAttr.put('GTAG02',GTAG02);
        XmlMapRVAttr.put('GTAG04',GTAG04);
        XmlMapRVAttr.put('GTAG05',GTAG05);
        XmlMapRVAttr.put('GTAG06',GTAG06);
        XmlMapRVAttr.put('GTAG08',GTAG08);
        XmlMapRVAttr.put('GTAG10',GTAG10);
        XmlMapRVAttr.put('GTAG14',GTAG14);
        XmlMapRVAttr.put('GTAG15',GTAG15);
        XmlMapRVAttr.put('GTAG16',GTAG16);
        XmlMapRVAttr.put('GTAG17',GTAG17);
        XmlMapRVAttr.put('GTAG18',GTAG18);
        XmlMapRVAttr.put('GTAG19',GTAG19);
        XmlMapRVAttr.put('GTAG20',GTAG20);
        XmlMapRVAttr.put('GTAG21',GTAG21);
        XmlMapRVAttr.put('GTAG22',GTAG22);
        XmlMapRVAttr.put('GTAG23',GTAG23);
        XmlMapRVAttr.put('GTAGPN',GTAGPN);
        XmlMapRVAttr.put('IINO',IINO);
        XmlMapRVAttr.put('OA',OA);
        XmlMapRVAttr.put('OB',OB);
        XmlMapRVAttr.put('OW',OW);
        XmlMapRVAttr.put('PC',PC);
        XmlMapRVAttr.put('PRDLIN',PRDLIN);
    }
    
    public void getQuoteAttributes()
    {
        mapRV_Attribute.put('OB170',OB170);
        mapRV_Attribute.put('OB250',OB250);
        mapRV_Attribute.put('OB300',OB300);
        mapRV_Attribute.put('OB320',OB320);
        mapRV_Attribute.put('OB370',OB370);
        mapRV_Attribute.put('OB400',OB400);
        mapRV_Attribute.put('OB420',OB420);
        mapRV_Attribute.put('OB480',OB480);
    }
    //Output Methods  Starts from here
    //ControlPlan Method (Completed)
    
    Public Result getControlPlan()
    {
        result RVControlPlan = new Result();
        List<String> selectCols = new List<String> {'TEST_OPERATION_DESC__c','NORM_TYPE__c','Operation_Number__c','DATA_TYPE__c','CATEGORY_ID__c','INSPECTION_CODE__c',
        'SAMPLE_PERCENT__c','Process_Characteristic__c','OUTER_MIN__c','INNER_MIN__c','NOMINAL_VALUE__c','INNER_MAX__c','OUTER_MAX__c','Tool_ID__c','Data_Point__c','Test_OPNO__c'};
        //RVControlPlan=wizardBaseDataProcessor.getDataFromTranslationObj('Test_OPNO__c','RV_Valve_ControlPlan_Translation__c','RV_Valve_ControlPlan_Details__c',mapRVAttr,selectCols);
        RVControlPlan=wizardBaseDataProcessor.getSortedDataFromTranslationObj('Test_OPNO__c','RV_Valve_ControlPlan_Translation__c','RV_Valve_ControlPlan_Details__c',mapRVAttr,selectCols,'Test_OPNO__c');
        /*if(RVControlPlan.bResult)
        { 
            system.debug('ControlPlan Result' +RVControlPlan.objResultList);
        }*/
        return RVControlPlan; 
    }
    
    //Document Method (Completed)
    
    Public Result getDocument()
    {
        result RVDocument = new Result();
        List<String> selectCols = new List<String> {'Document__c','Document_ID__c','Revision__c'};
        RVDocument=wizardBaseDataProcessor.getDataFromTranslationObj('Document__c','RV_Valve_Document_Translation__c','RV_Valve_Document_Details__c',mapRVAttr,selectCols);
        /*if(RVDocument.bResult)
        { 
            system.debug('Document Result' +RVDocument.objResultList);
        }*/
        return RVDocument; 
    }
    
    //Routing Method (Completed)
    
    Public Result getRouting()
    {
        result RVRouting = new Result();
        List<String> selectCols = new List<String> {'Operation__c','Standard_Operation_ID__c','Outside_Operation_Item__c','Descr__c'};
        RVRouting=wizardBaseDataProcessor.getSortedDataFromTranslationObj('Operation__c','RV_Valve_Routing_Translation__c','RV_Valve_Routing_Details__c',mapRVAttr,selectCols,'Operation__c');
        /*if(RVRouting.bResult)
        { 
            system.debug('Routing Result' +RVRouting.objResultList);
        } */
        return RVRouting; 
    }
    
    //Structure Method (Completed)
    
    Public Result getStructure()
    {
        result RVStructure = new Result();
        List<String> selectCols = new List<String> {'ItemNo__c','Component_Part__c','Qty_per_Assembly__c','Scrap_Factor__c','Component_Scrap__c','Structure_Element__c'};
        RVStructure=wizardBaseDataProcessor.getSortedDataFromTranslationObj('Structure_Element__c','RV_Valve_Structure_Translation__c','RV_Valve_Structure_Details__c',mapRVAttr,selectCols,'ItemNo__c');
        if(RVStructure.bResult)
                {
                    for (sObject sobj:RVStructure.objResultList)
                    {
                        if((string) sobj.get('Structure_Element__c')=='PosSpring')
                        {
                            GPDS03=(string) sobj.get('Component_Part__c');
                        }       
                        if((string) sobj.get('Structure_Element__c')=='VacSpring')
                        {
                            GPDS09=(string) sobj.get('Component_Part__c');
                        }
                        if((string) sobj.get('Structure_Element__c')=='FlameArresterPN')
                        {
                            FBASSY=(string) sobj.get('Component_Part__c');
                        }
                    }
                }
        
        return RVStructure; 
    }
    
    public string GPDS03{get;set;}
    public string GPDS09{get;set;}
    public string FBASSY{get;set;}    

    //WorkGuideLines Method (Completed)
    
    Public Result getWorkGuideLines()
    {
        result RVWorkGuideLines = new Result();
        List<String> selectCols = new List<String> {'Operation__c','Description__c','Text__c','Type__c','Sign_Off__c','Inspection_Sign_Off_Required__c,GuidlineSeq__c'};
        RVWorkGuideLines=wizardBaseDataProcessor.getSortedDataFromTranslationObj('GuidlineSeq__c','RV_Work_Guidelines_Translation__c','RV_Work_Guidelines_Details__c',mapRVAttr,selectCols,'GuidlineSeq__c');
        /*if(RVWorkGuideLines.bResult)
        { 
            system.debug('WorkGuideLines Result' +RVWorkGuideLines.objResultList);
        } */
        return RVWorkGuideLines; 
    }
    
    //Price Method  (Completed)
    
    Public Result getPricing()
    {
        result RVPrice = new Result();
        List<String> selectCols = new List<String> {'Price__c','Pricing_Element__c'};        
            RVPrice=wizardBaseDataProcessor.getSortedDataFromTranslationObj('Pricing_Element__c','RV_Valve_Price_Translation__c','RV_Valve_Price_Details__c',mapRVAttr,selectCols,'Pricing_Element__c');
        if(RVPrice.bResult)
        { 
            system.debug('Pricing Result' +RVPrice.objResultList);
        } 
        return RVPrice; 
    }
    
    Public Result getLeadTime()
    {
        result RVLead = new Result();
        List<String> selectCols = new List<String> {'Lead_Time_Item_No__c','RunTimeSchedule__c','QueueTimeSchedule__c'};        
        RVLead=wizardBaseDataProcessor.getSortedDataFromTranslationObj('Lead_Time_Item_No__c','RV_Valve_Lead_Time_Translation__c','RV_Valve_Lead_Time_Details__c',mapRVAttr,selectCols,'Lead_Time_Item_No__c');
        return RVLead; 
    } 
    
    //Lookup Attributes 
 /*   public string ValveSubModel{
        get{
            string strBODYDESIGN='';
            
            strBODYDESIGN=[select Text__c from RV_Valve_Attributes_Details__c where Attribute__c=:'ValveSubModel' and Text1Val__c=:PTC][0].Text__c;
            return strBODYDESIGN;
        }
        set{
            this.ValveSubModel=value;
        }

    }*/

    Public map<string,string> getMapAttribute()
    {
        //System.debug('In getMapAttribute');
        Map<String, string> mapRV_Attribute1 = new Map<String, string>(); 
        //Get the inital map attributes values
        getRVAttributes(mapRV_Attribute1);
        /*for(String attri: mapRVAttr.keySet())
        {
            System.debug('Attribute = '+attri+', value = '+mapRVAttr.get(attri));
        }*/
        //Get the dependent map attribute values
        //System.debug('second time invoking the same map');
        getRVAttributes(mapRV_Attribute1);
        System.debug('VVVVVVVVVV  ASYTYP------' +mapRV_Attribute1.get('ASYTYP'));
        System.debug('VVVVVVVVVV  BodyDesign------' +mapRV_Attribute1.get('BodyDesign'));
        System.debug('VVVVVVVVVV  PosDomePresMaxFact ------' +mapRV_Attribute1.get('PosDomePresMaxFact'));
        return mapRV_Attribute1;
    }
    
    public void getRVAttributes(Map<String, string> RVAttributeMap)
    {
        result RVAttributes = new Result();
        //System.debug('Calling wizardBaseDataProcessor');
        List<String> selectCols = new List<String> {'Text__c','Attribute__c','Value__c'};
           // mapRVAttr.put('ValveMAWPPSIG',String.valueOf(ValveMAWPPSIG));
           
        RVAttributes=wizardBaseDataProcessor.getDataFromTranslationObj('Attribute__c','RV_Valve_Attributes_Translation__c','RV_Valve_Attributes_Details__c',mapRVAttr,selectCols);      
        //System.debug('Result = '+RVAttributes.bResult+', RVAttributes = '+RVAttributes);
        if(RVAttributes.bResult)
        { 
            for(sObject objD : RVAttributes.objResultList)
            {
                RV_Valve_Attributes_Details__c rvLookupData = (RV_Valve_Attributes_Details__c)objD;
                System.debug('--> Attribute = '+rvLookupData.Attribute__c+', Value = '+rvLookupData.Value__c+', Text = '+rvLookupData.Text__c);
                System.debug('--> condition check Text__c = '+(rvLookupData.Text__c != null)+', value = '+(rvLookupData.Value__c == null));
                if(rvLookupData.Text__c != null && rvLookupData.Value__c == null)
                {
                    System.debug('Inside condition '+rvLookupData.Attribute__c+', value = '+rvLookupData.Text__c);
                    RVAttributeMap.put(rvLookupData.Attribute__c, rvLookupData.Text__c);
                    System.debug('Adding to map '+rvLookupData.Attribute__c+', value = '+rvLookupData.Text__c);
                    mapRVAttr.put(rvLookupData.Attribute__c, rvLookupData.Text__c);
                    System.debug('--> In map attribute = '+rvLookupData.Attribute__c+', value = '+mapRVAttr.get(rvLookupData.Attribute__c));            
                }
                if(rvLookupData.Text__c == null && rvLookupData.Value__c != null)
                {
                    RVAttributeMap.put(rvLookupData.Attribute__c, String.valueOf(rvLookupData.Value__c));
                    mapRVAttr.put(rvLookupData.Attribute__c, String.valueOf(rvLookupData.Value__c));                    
                }
                if(rvLookupData.Text__c != null && rvLookupData.Value__c != null)
                {
                    RVAttributeMap.put(rvLookupData.Attribute__c, rvLookupData.Text__c+' '+rvLookupData.Value__c);
                    mapRVAttr.put(rvLookupData.Attribute__c, rvLookupData.Text__c+' '+rvLookupData.Value__c);
                }
                if(rvLookupData.Text__c == null && rvLookupData.Value__c == null)
                {
                    RVAttributeMap.put(rvLookupData.Attribute__c, '');
                    mapRVAttr.put(rvLookupData.Attribute__c, '');
                }
                System.debug('--> In map attribute = '+rvLookupData.Attribute__c+', value = '+mapRVAttr.get(rvLookupData.Attribute__c));
            }
        }
    }
    
   
    public Map<String, String> GetAttributeMapQuoteDescription()
    {
        Map<String, String> quoteAttriVsDesc = new Map<String, String>();
        if(mapRV_Attribute.size() > 0)
        {
            List<String> quoteKey = new List<String>((mapRV_Attribute).Keyset());
            quoteKey.sort();
            for(String mapKey: quoteKey)
            {
                //System.debug('*** mapKey = '+mapKey+', mapRV_Attribute = '+mapRV_Attribute.get(mapKey));
                if(mapKey.startsWithIgnoreCase('O') || mapKey.startsWithIgnoreCase('PC'))
                {
                    quoteAttriVsDesc.put(mapKey,mapRV_Attribute.get(mapKey));
                }
            }
        }
        return quoteAttriVsDesc;
    }

    //OA attributes
    /*
    public Map<String, String> GetAttributesOA()
    {        
        Map<String, String> quoteAttriVsDesc2 = new Map<String, String>();
        Map<String, String> quoteAttriVsDescforOA = new Map<String, String>();        
        quoteAttriVsDesc2=getMapAttribute();
        if(quoteAttriVsDesc2.size() > 0)
        {
            List<String> quoteKey = new List<String>((quoteAttriVsDesc2).Keyset());
            quoteKey.sort();
            for(String mapKey: quoteKey)
            {               
                if(mapKey.startsWithIgnoreCase('OA'))
                {
                    quoteAttriVsDescforOA .put(mapKey,quoteAttriVsDesc2.get(mapKey));
                    //System.debug('OA------------>' + quoteAttriVsDescforOA .get(mapKey));
                }               
            }
        }
        return quoteAttriVsDescforOA;
    }
    
    //OB attributes
    public Map<String, String> GetAttributesOB()
    {        
        Map<String, String> quoteAttriVsDesc2 = new Map<String, String>();
        Map<String, String> quoteAttriVsDescforOA = new Map<String, String>();        
        quoteAttriVsDesc2=getMapAttribute();
        if(quoteAttriVsDesc2.size() > 0)
        {
            List<String> quoteKey = new List<String>((quoteAttriVsDesc2).Keyset());
            quoteKey.sort();
            for(String mapKey: quoteKey)
            {               
                if(mapKey.startsWithIgnoreCase('OB'))
                {
                    quoteAttriVsDescforOA .put(mapKey,quoteAttriVsDesc2.get(mapKey));
                    //System.debug('OB------------>' + quoteAttriVsDescforOA .get(mapKey));
                }               
            }
        }
        return quoteAttriVsDescforOA;
    }
    
    //OW attributes
    public Map<String, String> GetAttributesOW()
    {        
        Map<String, String> quoteAttriVsDesc2 = new Map<String, String>();
        Map<String, String> quoteAttriVsDescforOA = new Map<String, String>();        
        quoteAttriVsDesc2=getMapAttribute();
        if(quoteAttriVsDesc2.size() > 0)
        {
            List<String> quoteKey = new List<String>((quoteAttriVsDesc2).Keyset());
            quoteKey.sort();
            for(String mapKey: quoteKey)
            {               
                if(mapKey.startsWithIgnoreCase('OW'))
                {
                    quoteAttriVsDescforOA .put(mapKey,quoteAttriVsDesc2.get(mapKey));
                    //System.debug('OW------------>' + quoteAttriVsDescforOA .get(mapKey));
                }               
            }
        }
        return quoteAttriVsDescforOA;
    }
    
    //PC attributes
    public Map<String, String> GetAttributesPC()
    {        
        Map<String, String> quoteAttriVsDesc2 = new Map<String, String>();
        Map<String, String> quoteAttriVsDescforOA = new Map<String, String>();        
        quoteAttriVsDesc2=getMapAttribute();
        if(quoteAttriVsDesc2.size() > 0)
        {
            List<String> quoteKey = new List<String>((quoteAttriVsDesc2).Keyset());
            quoteKey.sort();
            for(String mapKey: quoteKey)
            {               
                if(mapKey.startsWithIgnoreCase('PC'))
                {
                    quoteAttriVsDescforOA .put(mapKey,quoteAttriVsDesc2.get(mapKey));
                    //System.debug('PC------------>' + quoteAttriVsDescforOA .get(mapKey));
                }               
            }
        }
        return quoteAttriVsDescforOA;
    }*/
    
    // Getter Settor to store ASSYPARTNO 
    
    public String ASSYPARTNO {
    get {
            if(currentRV.ASSYPARTNO__c!=null)
                return currentRV.ASSYPARTNO__c;  
            else
                return ' ';
        }
    set {
            this.ASSYPARTNO = value;
        }
    }    
    
    //Lookup methods needed for RVAttr map
    public String ASYTYP {
    get {
            return mapRV_Attribute.get('ASYTYP')==null?'': mapRV_Attribute.get('ASYTYP');  
        }
    set {
            this.ASYTYP = value;
        }
    }    
   public String ValveSubModel {
    get {          
           return mapRV_Attribute.get('ValveSubModel')==null?'': mapRV_Attribute.get('ValveSubModel');  
         //   return PTC;
        }
    set {
            this.ValveSubModel = value;
        }
    }    
public String BODYDESIGN {
    get {
           // return mapRV_Attribute.get('BodyDesign')==null?'': mapRV_Attribute.get('BodyDesign');   
           return currentRV.Body_Design__c;
        }
    set {
            this.BODYDESIGN = value;
        }
    }    
      
public String FASubModel {
    get {
            return mapRV_Attribute.get('FASubModel')==null?'': mapRV_Attribute.get('FASubModel');  
        }
    set {
            this.FASubModel = value;
        }
    }    
public String ESZC {
    get {
            return mapRV_Attribute.get('ESZC')==null?'': mapRV_Attribute.get('ESZC');  
        }
    set {
            this.ESZC = value;
        }
    }    
public String VENDORPAINT {
    get {
            return mapRV_Attribute.get('VENDORPAINT')==null?'': mapRV_Attribute.get('VENDORPAINT');  
        }
    set {
            this.VENDORPAINT = value;
        }
    }    
public String INHOUSEPAINT {
    get {
            return mapRV_Attribute.get('INHOUSEPAINT')==null?'': mapRV_Attribute.get('INHOUSEPAINT');  
        }
    set {
            this.INHOUSEPAINT = value;
        }
    }    
public String RGEUNT {
    get {
            return mapRV_Attribute.get('RGEUNT')==null?'': mapRV_Attribute.get('RGEUNT');  
        }
    set {
            this.RGEUNT = value;
        }
    }    
public String VGEUNT {
    get {
            return mapRV_Attribute.get('VGEUNT')==null?'': mapRV_Attribute.get('VGEUNT');  
        }
    set {
            this.VGEUNT = value;
        }
    }  
    
    //Lookup Methods    

    public String GTAG01 {
    get {
            return mapRV_Attribute.get('GTAG01')==null?'': mapRV_Attribute.get('GTAG01');  
        }
    set {
            this.GTAG01 = value;
        }
    }    
    
    public String GTAG04 {
    get {
            return mapRV_Attribute.get('GTAG04')==null?'': mapRV_Attribute.get('GTAG04');  
        }
    set {
            this.GTAG04 = value;
        }
    }    
    
    public String GTAG05 {
    get {
            return mapRV_Attribute.get('GTAG05')==null?'': mapRV_Attribute.get('GTAG05');  
        }
    set {
            this.GTAG05 = value;
        }
    }    
    
    public String GTAG06 {
    get {
            return mapRV_Attribute.get('GTAG06')==null?'': mapRV_Attribute.get('GTAG06');  
        }
    set {
            this.GTAG06 = value;
        }
    }    
    
    public String GTAG14 {
    get {
            return mapRV_Attribute.get('GTAG14')==null?'': mapRV_Attribute.get('GTAG14');  
        }
    set {
            this.GTAG14 = value;
        }
    }    
    
    public String GTAG15 {
    get {
            return mapRV_Attribute.get('GTAG15')==null?'': mapRV_Attribute.get('GTAG15');  
        }
    set {
            this.GTAG15 = value;
        }
    }      
    
    public String GTAG16 {
    get {
            return mapRV_Attribute.get('GTAG16')==null?'': mapRV_Attribute.get('GTAG16');  
        }
    set {
            this.GTAG16 = value;
        }
    }    
    
    public String GTAG17 {
    get {
            return mapRV_Attribute.get('GTAG17')==null?'': mapRV_Attribute.get('GTAG17');  
        }
    set {
            this.GTAG17 = value;
        }
    }    
    
    public String GTAG19 {
    get {
            return mapRV_Attribute.get('GTAG19')==null?'': mapRV_Attribute.get('GTAG19');  
        }
    set {
            this.GTAG19 = value;
        }
    }    
    
    public String GTAG21 {
    get {
            return mapRV_Attribute.get('GTAG21')==null?'': mapRV_Attribute.get('GTAG21');  
        }
    set {
            this.GTAG21 = value;
        }
    }    
    
    public String GTAG22 {
    get {
            return mapRV_Attribute.get('GTAG22')==null?'': mapRV_Attribute.get('GTAG22');  
        }
    set {
            this.GTAG22 = value;
        }
    }    
    
    public String GTAG23 {
    get {
            return mapRV_Attribute.get('GTAG23')==null?'': mapRV_Attribute.get('GTAG23');  
        }
    set {
            this.GTAG23 = value;
        }
    }    
    
    public String GTAGPN {
    get {
            return mapRV_Attribute.get('GTAGPN')==null?'': mapRV_Attribute.get('GTAGPN');  
        }
    set {
            this.GTAGPN = value;
        }
    }    
    
    public String IINO {
    get {
            return mapRV_Attribute.get('IINO')==null?'': mapRV_Attribute.get('IINO');  
        }
    set {
            this.IINO = value;
        }
    }    
        
    public String SHLTSTACTPSIG {
    get {
            return mapRV_Attribute.get('SHLTSTACTPSIG')==null?'': mapRV_Attribute.get('SHLTSTACTPSIG');  
        }
    set {
            this.SHLTSTACTPSIG = value;
        }
    }    
    
    public String SHLTSTACTPSIGMX {
    get {
            return mapRV_Attribute.get('SHLTSTACTPSIGMX')==null?'': mapRV_Attribute.get('SHLTSTACTPSIGMX');  
        }
    set {
            this.SHLTSTACTPSIGMX = value;
        }
    }    
    
    public String SOURCINGOPT {
    get {
            return mapRV_Attribute.get('SOURCINGOPT')==null?'': mapRV_Attribute.get('SOURCINGOPT');  
        }
    set {
            this.SOURCINGOPT = value;
        }
    }    
    
    public String PRDLIN{
    get {
            return mapRV_Attribute.get('PRDLIN')==null?'': mapRV_Attribute.get('PRDLIN');  
        }
    set {
            this.PRDLIN = value;
        }
    }
    
    public decimal PosSettingMaxFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('PosSettingMaxFact'));
        }
    set {
            this.PosSettingMaxFact = value;
        }
    }
    
    public decimal PosSettingMinFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('PosSettingMinFact'));
        }
    set {
            this.PosSettingMinFact = value;
        }
    }
    
    public decimal PosValveLeakMaxFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('PosValveLeakMaxFact'));
        }
    set {
            this.PosValveLeakMaxFact = value;
        }
    } 
    
    public decimal PosValveLeakMinFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('PosValveLeakMinFact'));
        }
    set {
            this.PosValveLeakMinFact = value;
        }
    }
    
    public decimal VacSettingMaxFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('VacSettingMaxFact'));
         }
    set {
            this.VacSettingMaxFact = value;
        }
    } 
    
    public decimal VacSettingMinFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('VacSettingMinFact'));
        }
    set {
            this.VacSettingMinFact = value;
        }
    }
    
    public decimal VacValveLeakMaxFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('VacValveLeakMaxFact'));
        }
    set {
            this.VacValveLeakMaxFact = value;
        }
    } 
    
    public decimal VacValveLeakMinFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('VacValveLeakMinFact'));
        }
    set {
            this.VacValveLeakMinFact = value;
        }
    }
    public decimal PosPilotSetMinFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('PosPilotSetMinFact'));
        }
    set {
            this.PosPilotSetMinFact = value;
        }
    } 

    public decimal PosPilotSetMaxFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('PosPilotSetMaxFact'));
        }
    set {
            this.PosPilotSetMaxFact = value;
        }
    } 

    public decimal VacPilotSetMinFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('VacPilotSetMinFact'));
        }
    set {
            this.VacPilotSetMinFact = value;
        }
    } 

    public decimal VacPilotSetMaxFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('VacPilotSetMaxFact'));
        }
    set {
            this.VacPilotSetMaxFact = value;
        }
    } 

    public decimal PosDomePresMaxFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('PosDomePresMaxFact'));
        }
    set {
            this.PosDomePresMaxFact = value;
        }
    } 

    public decimal VacDomePresMaxFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('VacDomePresMaxFact'));
        }
    set {
            this.VacDomePresMaxFact = value;
        }
    } 

    public decimal PosPilotLeakLowFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('PosPilotLeakLowFact'));
        }
    set {
            this.PosPilotLeakLowFact = value;
        }
    }
    
    public string MPTC {
    get {
            return currentRV.Model_Size__c;
        }
    set {
            this.MPTC = value;
        }
    } 


    public decimal PosPilotLeakHighFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('PosPilotLeakHighFact'));
        }
    set {
            this.PosPilotLeakHighFact = value;
        }
    } 

    public decimal VacPilotLeakLowFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('VacPilotLeakLowFact'));
        }
    set {
            this.VacPilotLeakLowFact = value;
        }
    } 

    public decimal VacPilotLeakHighFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('VacPilotLeakHighFact'));
        }
    set {
            this.VacPilotLeakHighFact = value;
        }
    } 

    public decimal PosStaticPresMinFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('PosStaticPresMinFact'));
        }
    set {
            this.PosStaticPresMinFact = value;
        }
    } 

    public decimal PosStaticPresMaxFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('PosStaticPresMaxFact'));
        }
    set {
            this.PosStaticPresMaxFact = value;
        }
    } 

    public decimal VacStaticPresMinFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('VacStaticPresMinFact'));
        }
    set {
            this.VacStaticPresMinFact = value;
        }
    } 

    public decimal VacStaticPresMaxFact {
    get {
            return convertNullToZero(mapRV_Attribute.get('VacStaticPresMaxFact'));
        }
    set {
            this.VacStaticPresMaxFact = value;
        }
    } 
 
    public decimal BodyMAWPpsig{
        get{
             return convertNullToZero(mapRV_Attribute.get('BodyMAWPpsig'));
        }
        set{
            this.BodyMAWPpsig=value;
        }
    }
  

    
    //Missing Attributes 
    public string SHLTSTMETHACT{
        get{
            return '';
        }
        set{
            this.SHLTSTMETHACT=value;
        }
    }

    
    //BRAND
    public string Brand{
        get{
            if(currentRV.Brand__c != null)          
                return currentRV.Brand__c;            
             
            else 
                return ' ';      
        }
        set{
            this.Brand=value;
        }
    }
    
    
    //Equation methods Starts here
    
    //Blue Highlighted (inputs getters)
    //Yellow (Not Written)
    //Orange(Doubts)
    //Green(Completed)
    
    /* 
    //ConvertPressure (AtmPres, AtmPresUOM, "psia")   
    public decimal AtmPresPSIA{
        get{
              return unitConversions.convertPressure(AtmPresUOM,'psia',AtmPres);
        }
        set{
            this.AtmPresPSIA=value;
        }
    }*/

    //Greater of ( VacFlowPresPSIG or PosBackPresPSIG or 0) 
    public decimal EffMBP{
        get{
            if(VacFlowPresPSIG!=null && PosBackPresPSIG!=null)
            {
                 if(VacFlowPresPSIG>PosBackPresPSIG)
                    return VacFlowPresPSIG;
                else if(PosBackPresPSIG>VacFlowPresPSIG)
                    return PosBackPresPSIG;
                else 
                    return 0.0;
            }            
            else
                return 0.0;
        }
        set{
            this.EffMBP=value;
        }
    } 
    
    //Greater of ( MaxProcPresPSIG or PosFlowPresPSIG )
    public decimal EFFMOP{
        get{ 
            system.debug('##MaxProcPresPSIG: '+MaxProcPresPSIG+'PosFlowPresPSIG: '+PosFlowPresPSIG);
            if(MaxProcPresPSIG!=null && PosFlowPresPSIG!=null)
            {
                if(MaxProcPresPSIG>PosFlowPresPSIG)
                    return MaxProcPresPSIG;
                else 
                    return PosFlowPresPSIG;
            }            
            else
                return 0.0;
        }
        set{
            this.EFFMOP=value;
        }
    }    
    
    public string OPTIONCODE{
        get{
             if(PED=='N' &&  ATEX=='N' &&  CUTR=='N' &&  NACE=='N' &&  GPAINT=='0' &&  VPRTOP=='0' &&  POSPROXSENSOR=='N' && 
                VACPROXSENSOR=='N' &&  GMTH21=='N' &&  XRAY=='N' &&  FWLDP=='N' &&  PMI=='N' &&  LDP=='N' &&  USONICEXAM=='N' &&  
                MAGPARTEXAM=='N' &&  BRINHARDEXAM=='N' &&  CHARPYIMPEXAM=='N' &&  VISCASTEXAM=='N' &&  IGCEXAM=='N'
                && SHLTSTMETHBDY=='AIR' &&  ASSYLOCATION=='00' &&  MATLSOURCE=='00' )
                  return '0';
              else
                  return 'Z';
        }
        set{
            this.OPTIONCODE=value;
        }
    }   
    
    /*public string GMODEL
    {
        get
        {
            string strSZC;
            integer strLEN=SZC.length();
            if(strLEN<2)
            {
                strSZC='0'+SZC;
            }
            else
            {
                strSZC=SZC;
            }
            System.debug('%%%% ASYTYP = '+ASYTYP+', currentRV.Element_Material__c = '+currentRV.Element_Material__c);
            if(ASYTYP == 'PVRV')
            {
                return GMODELPTC + '-' + strSZC + '-' + MCBODY + MCSEAT + PNMCPALL + '-' + MCDPHM.left(1) + MCSTMJ + OPTIONCODE;
            }
            if(ASYTYP == 'POV')
            {
                return GMODELPTC + '-' + strSZC + '-' + MCBODY + '-' + MCPSGD.left(1) + '-' + GMODELGPTYPE + GPACT.left(1) + '-' + GMODELOpt1 + GMODELOpt2 + GMODELOpt3 + OPTIONCODE;
            }
            if(ASYTYP == 'ERV')
            {
                return GMODELPTC + '-' + strSZC + '-' + MCBODY + '-' + MCDPHM.left(1) + HCLASS + MCSTMJ + OPTIONCODE;
            }
            if(ASYTYP == 'PVRV w/FA')
            {
                return GMODELPTC + '-' + strSZC + '-' + MCBODY + MCSEAT + PNMCPALL + currentRV.Element_Material__c + '-' + MCDPHM.left(1) + MCSTMJ + OPTIONCODE;
            }
            else
            {
                return '';
            }
        }
        set
        {
            this.GMODEL=value;
        }
    }*/
    
     public string GMODEL {
        get {
            
            return  GMODEL1+GMODEL2+GMODEL3+GMODEL4+GMODEL5+GMODEL6+GMODEL7+GMODEL8+GMODEL9+OPTIONCODE;
        }
        set {
            //currentBGR.Ratio_of_Specific_Heats__c = value;
            this.GMODEL = value;
            
        }
    }
    
     public string GMODEL1 {
        get {
             return mapRV_Attribute.get('GMODEL-1')==null?'': mapRV_Attribute.get('GMODEL-1');
        }
        set {
            this.GMODEL1 = value;
        }
    }  
        public string GMODEL2 {
        get {
             return mapRV_Attribute.get('GMODEL-2')==null?'': mapRV_Attribute.get('GMODEL-2');
        }
        set {
            this.GMODEL2 = value;
        }
    }
    
    public string GMODEL3 {
        get {
             return mapRV_Attribute.get('GMODEL-3')==null?'': mapRV_Attribute.get('GMODEL-3');
        }
        set {
            this.GMODEL3 = value;
        }
    }
      
    public string GMODEL4 {
        get {
             return mapRV_Attribute.get('GMODEL-4')==null?'': mapRV_Attribute.get('GMODEL-4');
        }
        set {
            this.GMODEL4 = value;
        }
    }
      
     public string GMODEL5 {
        get {
             return mapRV_Attribute.get('GMODEL-5')==null?'': mapRV_Attribute.get('GMODEL-5');
        }
        set {
            this.GMODEL5 = value;
        }
    }
    
     public string GMODEL6 {
        get {
             return mapRV_Attribute.get('GMODEL-6')==null?'': mapRV_Attribute.get('GMODEL-6');
        }
        set {
            this.GMODEL6 = value;
        }
     }   
         
        public string GMODEL7 {
        get {
             return mapRV_Attribute.get('GMODEL-7')==null?'': mapRV_Attribute.get('GMODEL-7');
        }
        set {
            this.GMODEL7 = value;
        } 
    }    
     
    public string GMODEL8 {
        get {
            return mapRV_Attribute.get('GMODEL-8')==null?'': mapRV_Attribute.get('GMODEL-8');
        }
        set {
            this.GMODEL8 = value;
        } 
    }    
    
    public string GMODEL9 {
        get {
            return mapRV_Attribute.get('GMODEL-9')==null?'': mapRV_Attribute.get('GMODEL-9');
        }
        set {
            this.GMODEL9 = value;
        } 
    }
    
    public string GMODELN {
        get {
             return mapRV_Attribute.get('GMODEL-N')==null?'': mapRV_Attribute.get('GMODEL-N');
        }
        set {
            this.GMODELN = value;
        } 
    }
    
    
    public string GTAG02{
        get{
            result res=new result();
            res=unitConversions.SignificantDigitsNormal(ValveMAWPPSIG / 14.5038,3,-99);
            decimal Sigval_ValveMAWPPSIG=res.dblRetValue;            
                if (UOMSystem =='USC') 
                    return 'MAWP: '+ValveMAWPPSIG.stripTrailingZeros().toPlainString()+' psig';
                else if (UOMSystem =='SI') 
                    return  'MAWP: '+Sigval_ValveMAWPPSIG.stripTrailingZeros().toPlainString()+' barg'; 
                else
                    return 'Error';
        }
        set{
            this.GTAG02=value;
        }
    }

    public string GTAG08{
        get{            
            result res1=new result();
            res1=unitConversions.SignificantDigitsNormal(StdPosAirFlowSCFH,3,-99);
            decimal Sigval1=res1.dblRetValue; 
            
            result res2=new result();
            res2=unitConversions.SignificantDigitsNormal(StdPosAirFlowSCFH / 36.3063,3,-99);
            decimal Sigval2=res2.dblRetValue; 
            
            if(PosFlow=='Y')
            {
                if(UOMSystem =='USC')
                    return Sigval1.stripTrailingZeros().toPlainString() +' SCFH';
                else if(UOMSystem =='SI')
                    return Sigval2.stripTrailingZeros().toPlainString() +' Nm3/h';
                else
                    return 'Error';
            }
            else
                return ' ';
        }
        set{
            this.GTAG08=value;
        }
    }    
   
    
    public string GTAG10{
        get{
            //IF (VacFlow = "Y", IF ( UOMSystem = "USC", SignificantDigitsNormal ( StdVacAirFlowSCFH, 3, -99) &" SCFH", IF ( UOMSystem = "SI", SignificantDigitsNormal ( StdVacAirFlowSCFH / 37.3258, 3, -99) &" Nm3/h" ), "Error" ), "")
            
            result res1=new result();
            res1=unitConversions.SignificantDigitsNormal(StdVacAirFlowSCFH,3,-99);
            decimal Sigval1=res1.dblRetValue; 
            
            result res2=new result();
            res2=unitConversions.SignificantDigitsNormal(StdVacAirFlowSCFH / 36.3063,3,-99);
            decimal Sigval2=res2.dblRetValue; 
            
            if(VacFlow=='Y')
            {
                if(UOMSystem =='USC')
                    return Sigval1.stripTrailingZeros().toPlainString() +' SCFH';
                else if(UOMSystem =='SI')
                    return Sigval2.stripTrailingZeros().toPlainString() +' Nm3/h';
                else
                    return 'Error';
            } 
            //else
            return ' ';
        }
        set{
            this.GTAG10=value;
        }
    }   
    
     public string GTAG18{
        get{
            if(PosFlow=='Y')
                return (RTPRS1 * (1 + StdPosFullOP / 100)).stripTrailingZeros().toPlainString()+' '+RTPRSU;
            else 
                return ' ';
        }
        set{
            this.GTAG18=value;
        }
    }
    
    public string GTAG20{
        get{
            if(VacFlow=='Y')
                return (VTPRS1 * (1 + StdVacFullOP / 100)).stripTrailingZeros().toPlainString()+' '+VTPRSU;
            else
                return ' ';
        }
        set{
            this.GTAG20=value;
        }
    }    
    
    public string OA{
        get;
        
        set{
            this.OA=value;
        }
    }
        
    public string OA01{
        get{
            string strOA01='';
            return strOA01='Model:' + GMODEL;          
        }
        set{
            this.OA01=value;
        }
    }
    
    public string OB{
        get;
        
        set{
            this.OB=value;
        }
    }
        
    public string OB170{
        get{
            if(manualBlowdown=='Y' || remoteSense=='Y' || pilotExhstPiped=='Y' || FieldTestConnect =='Y' || pilotSplyFilter=='Y')
                return 'Pilot Options:';    
            else 
                return ' ';
        }
        set{
            this.OB170=value;
        }
    }    
    
    public string OB250{
        get{
           //OB250  IF (PosFlow = "Y", "  Pressure Setting: " & RTPRS1 & " " & RTPRSU & IF (RTPRSU=RGEUNT, "", "  (" & GPRSC1 & " " & RGEUNT & ")" ), "")
           if(PosFlow=='Y')
           {
               string str2='';
               string str1=' ' + 'Pressure Setting: '+ RTPRS1.stripTrailingZeros().toPlainString() +' '+RTPRSU;
               if(RTPRSU==RGEUNT){
                   return str1;
               }else{
                   str2=' ('+ GPRSC1.toPlainString() + ' '+ RGEUNT+' )';
                   return str1+str2;
               }
           }               
            return '';
        }
        set{
            this.OB250=value;
        }
    } 
   
    public string OB300{
        get{
            if(PosFlow=='Y')
                return 'Relieving Pressure: '+GTAG18;   
            else 
                return ' ';
        }
        set{
            this.OB300=value;
        }
    } 
    
    public string OB320{
        get{
            if(PosFlow=='Y')
                return 'Flow: '+GTAG08+' Air';   
            else 
                return ' ';
        }
        set{
            this.OB320=value;
        }
    } 
    
    public string OB370{
        get{
            // OB370 IF (VacFlow = "Y", "  Vacuum Setting: " & VTPRS1 & " " & VTPRSU & IF (VTPRSU=VGEUNT, "", "  (" & GVRSC1 & " " & VGEUNT & ")" ), "")
            
            if(VacFlow=='Y')
            {
                string str2='';
                string str1=' ' + 'Vacuum Setting: '+ VTPRS1.stripTrailingZeros().toPlainString() +' '+VTPRSU;
                if(VTPRSU==VGEUNT){
                    return str1;
                }else{
                    str2=' ('+ GVRSC1.stripTrailingZeros().toPlainString() + ' '+ VGEUNT+' )';
                    return str1+str2;
                }
            }               
            return '';
        }
        set{
            this.OB370=value;
        }
    } 
    
    public string OB400{
        get{
            if(VacFlow=='Y')
                return 'Relieving Vacuum: '+GTAG20; 
            else 
                return ' ';
        }
        set{
            this.OB400=value;
        }
    } 
    
    public string OB420{
        get{
            if(VacFlow=='Y')
                return 'Flow: '+GTAG10+' Air';   
            else 
                return ' ';
        }
        set{
            this.OB420=value;
        }
    } 
    
    public string OB480{
        get{
                return 'Valve: '+GTAG02;
        }
        set{
            this.OB480=value;
        }
    } 
        
    public string OnEngrHoldFlag{
        get{
            //IF (List Price = 9999999, or List Price = 0, or LeadTime (for any Site) = 0 )  THEN "TRUE"                            
            return ' ';
        }
        set{
            this.OnEngrHoldFlag=value;
        }
    } 
    
    public string OW{
        get;
        
        set{
            this.OW=value;
        }
    } 
    
    public string PC{
        get;
        
        set{
            this.PC=value;
        }
    } 
        
    public string PNMCPALL{
        get{
            if(MCPALL=='N')
                return MCVPAL;
            else 
                return MCPALL;
        }
        set{
            this.PNMCPALL=value;
        }
    } 
         
    public decimal PosP1{
        get{
            if(AtmPresPSIA!=null && PosFlowPresPSIG!=null)
            {
               return AtmPresPSIA + PosFlowPresPSIG; 
            }
            else
               return 0.0;
        }
        set{
            this.PosP1=value;
        }
    }
    
    public decimal PosP2{
        get{
            if(AtmPresPSIA!=null && PosBackPresPSIG!=null)
            {
               return AtmPresPSIA + PosBackPresPSIG; 
            }
            else
               return 0.0;
        }
        set{
            this.PosP2=value;
        }
    }

    //changed formula
    public decimal StdPosPresRatio{
        get{
           /* decimal decStdPosPresRatio=0.0;
            decStdPosPresRatio= 14.6959 / ( PosSetPresPSIG * (1 + StdPosFullOP / 100) + 14.6959 );
            if(decStdPosPresRatio!=null)
                return decStdPosPresRatio;
            else
                return 0.0;*/
            return currentRV.StdPosPresRatio__c;
        }
        set{
            this.StdPosPresRatio=value;
        }
    }
    
    public decimal PosPresRatioHigh{
        get{
            return currentRV.PosPresRatioHigh__c;
        }
        set{
            this.PosPresRatioHigh=value;
        }
    }
    
    public decimal PosKdHigh{
        get{
            return currentRV.PosKdHigh__c;
        }
        set{
            this.PosKdHigh=value;
        }
    }
    
    public decimal PosPresRatioLow{
        get{
            return currentRV.PosPresRatioLow__c;
        }
        set{
            this.PosPresRatioLow=value;
        }
    }
    
    public decimal PosKdLow{
        get{
            return currentRV.PosKdLow__c;
        }
        set{
            this.PosKdLow=value;
        }
    }
    
    public decimal StdPosKd{
        get{
            /*NOTE: If either PosPresRatioLow or PosPresRatioHigh return no record, Then Set StdPosKd = 0
            IF (PosIntMethod = "Linear") THEN  (( StdPosPresRatio - PosPresRatioHigh ) * 
                    ( PosKdLow - PosKdHigh ) / ( PosPresRatioLow - PosPresRatioHigh ) + PosKdHigh)
            ELSE IF (PosIntMethod = "Power") THEN  (EXP ( ( LN(StdPosPresRatio) - LN(PosPresRatioHigh) ) 
                        * ( LN(PosKdLow) - LN(PosKdHigh) ) / ( LN(PosPresRatioLow) - LN(PosPresRatioHigh) ) + LN(PosKdHigh) ))*/
            
            /*decimal decStdPosKd=0.0;
            if(PosPresRatioLow!=null || PosPresRatioHigh!=null || PosKdHigh != null)
            {
                if(PosIntMethod =='Linear')
                {
                    decimal numerator = ((StdPosPresRatio - PosPresRatioHigh)*(PosKdLow - PosKdHigh));
                    decimal denominator = (PosPresRatioLow - PosPresRatioHigh) + PosKdHigh;
                    if(denominator != 0.0)
                    {
                        return decStdPosKd= numerator/denominator;
                    }
                    else
                    {
                        return 0.0;
                    }
                }
                else if(PosIntMethod =='Power')
                {
                    return 0.0;
                }
                //return decStdPosKd=(EXP((LN(StdPosPresRatio)-LN(PosPresRatioHigh))*(LN(PosKdLow)-LN(PosKdHigh))/(LN(PosPresRatioLow)-LN(PosPresRatioHigh)) + LN(PosKdHigh)));
                else 
                {
                    return 0.0;
                }
                
            }
            else
            {
                return 0.0;
            }*/
            return currentRV.StdPosKd__c;
        }
        set{
            this.StdPosKd=value;
        }
    }
    
    public decimal StdPosAirFlowSCFH{
        get{
            if(currentRV.StdPosAirFlowSCFH__c != null){
               return currentRV.StdPosAirFlowSCFH__c;
            }
            else{
                return 0;
            }
            
        }
        set{
            this.StdPosAirFlowSCFH=value;
        }
    }
    
    public decimal PosSetPresOSIG{
        get{
            decimal decPosSetPresOSIG=0.0;
            decPosSetPresOSIG=PosSetPresPSIG * 16;
            if(decPosSetPresOSIG!=null)
                return decPosSetPresOSIG;
            else
                return 0.0;
        }
        set{
            this.PosSetPresOSIG=value;
        }
    }
    
    public decimal PosSetPresPSIG{
        get{
            if(currentRV.Converted_Pressure_Setting__c!=null)
                return currentRV.Converted_Pressure_Setting__c;
            else
                return 0.0;
        }
        set{
            this.PosSetPresPSIG=value;
        }
    }
  
  /*  public decimal ConvertPressure{
        get{  
            if(RTPRS1 != null)
            {
                result res=new result();
                res=unitConversions.ConvertPressure(RTPRSU,RGEUNT,RTPRS1);
                decimal convertedval=res.dblRetValue;
                if(convertedval!=null)
                {
                    return convertedval;
                }
                else
                {
                    return 0.0;
                }
            }
            return 0.0;
        }
        set{
            this.ConvertPressure=value;
        }
    }
    public decimal ConvertVacuum{
        get{
            if(VTPRS1 != null)
            {
                result res=new result();
                res=unitConversions.ConvertPressure(VTPRSU,VGEUNT,VTPRS1);
                decimal convertedval=res.dblRetValue;
                if(convertedval!=null)
                {
                    return convertedval;
                }
                else
                {
                    return 0.0;
                }
            }
                return 0.0;    
        }
        set{
            this.ConvertVacuum=value;
        }
    }
  */
    
    public decimal PosSettingMax{
        get{
            //SignificantDigitsDown ( ConvertPressure (RTPRS1, RTPRSU, RGEUNT)* PosSettingMaxFact , 3, -99) 
            decimal conpress=ConvertedPressure;
            result res=new result();
            res=unitConversions.SignificantDigitsDown(conpress * PosSettingMaxFact,3,-99);
            decimal decPosSettingMax=res.dblRetValue;
            if(decPosSettingMax!=null)
                return decPosSettingMax;
            else
                return 0.0;
        }
        set{
            this.PosSettingMax=value;
        }
    }
    
    public decimal PosSettingMin{
        get{
            //SignificantDigitsUp ( ConvertPressure (RTPRS1, RTPRSU, RGEUNT)* PosSettingMinFact , 3, -99) 
            decimal conpress=ConvertedPressure;
            result res=new result();
            res=unitConversions.SignificantDigitsUp(conpress * PosSettingMinFact,3,-99);
            decimal decPosSettingMin=res.dblRetValue;
            if(decPosSettingMin!=null)
                return decPosSettingMin;
            else
                return 0.0;
        }
        set{
            this.PosSettingMin=value;
        }
    }
    
    public decimal PosValveLeakMax{
        get{
            //SignificantDigitsDown ( ConvertPressure (RTPRS1, RTPRSU, RGEUNT)* PosValveLeakMaxFact , 3, -99) 
            decimal conpress=ConvertedPressure;
            result res=new result();
            res=unitConversions.SignificantDigitsDown(conpress * PosValveLeakMaxFact,3,-99);
            decimal PosValveLeakMax=res.dblRetValue;
            if(PosValveLeakMax!=null)
                return PosValveLeakMax;
            else
                return 0.0;
        }
        set{
            this.PosValveLeakMax=value;
        }
    }
    
    public decimal PosValveLeakMin{
        get{
            //SignificantDigitsUp ( ConvertPressure (RTPRS1, RTPRSU, RGEUNT)* PosValveLeakMinFact , 3, -99) 
            decimal conpress=ConvertedPressure;
            result res=new result();
            res=unitConversions.SignificantDigitsUp(conpress * PosValveLeakMinFact,3,-99);
            decimal PosValveLeakMin=res.dblRetValue;
            if(PosValveLeakMin!=null)
                return PosValveLeakMin;
            else
                return 0.0;
        }
        set{
            this.PosValveLeakMin=value;
        }
    }   
    
    public decimal ShlTstBdyPSIG{
        get{
            //RoundUp ( ValveMAWPPSIG * 1.5, 0)
            //result res=new result();
            decimal ShlTstBdyPSIG;
            ShlTstBdyPSIG=unitConversions.RoundUp(ValveMAWPPSIG * 1.5,0);
            if(ShlTstBdyPSIG!=null)
                return ShlTstBdyPSIG;            
            else
                return 0.0;
        }
        set{
            this.ShlTstBdyPSIG=value;
        }
    }
    
    public decimal ShlTstBdyPSIGMx{
        get{
            //RoundDown ( ShlTstBdyPSIG * 1.1, 0)
            //result res=new result();
            decimal ShlTstBdyPSIGMx;
            ShlTstBdyPSIGMx=unitConversions.RoundDown(ShlTstBdyPSIG * 1.1,0);
            if(ShlTstBdyPSIGMx!=null)
                return ShlTstBdyPSIGMx;
            else
                return 0.0;
        }
        set{
            this.ShlTstBdyPSIGMx=value;
        }
    }
    
    public string UOMSystem{
        get{
            if(ATEX=='Y' || PED=='Y' || CUTR=='Y' || HCLASS=='B' || HCLASS=='C')
                return 'SI';
            else
                return 'USC'; 
        }
        set{
            this.UOMSystem=value;
        }
    }
   
    public decimal VacP1{
        get{
            if(AtmPresPSIA!=null)
                return AtmPresPSIA;
            else
                return 0.0;
        }
        set{
            this.VacP1=value;
        }
    }
    
    public decimal VacP2{
        get{
            decimal decVacP2=0.0;
            if(AtmPresPSIA!= null && VacFlowPresPSIG != null)
            {
                decVacP2=AtmPresPSIA-VacFlowPresPSIG;
            }
            if(decVacP2!=null)
            {
                return decVacP2;
            }
            else 
            {
                return 0.0;
            }
        }
        set{
            this.VacP2=value;
        }
    }
    
    public decimal StdVacPresRatio{
        get{
            /*decimal decStdVacPresRatio=0.0;
            decStdVacPresRatio=( 14.6959 - VacSetPresPSIG * (1 + StdVacFullOP / 100) ) / 14.6959;
            if(decStdVacPresRatio!=null)
                return decStdVacPresRatio;
            else
                return 0.0;*/
            return currentRV.StdVacPresRatio__c;
        }
        set{
            this.StdVacPresRatio=value;
        }
    }

    public decimal VacPresRatioHigh{
        get{
            if(currentRV.VacPresRatioHigh__c != null){
               return currentRV.VacPresRatioHigh__c;
            }
            else{
                return 0;
            }
        }
        set{
            this.VacPresRatioHigh=value;
        }
    }

    public decimal VacKdHigh{
        get{
            return currentRV.VacKdHigh__c;
        }
        set{
            this.VacKdHigh=value;
        }
    }

    public decimal VacPresRatioLow{
        get{
            if(currentRV.VacPresRatioLow__c != null){
               return currentRV.VacPresRatioLow__c;
            }
            else{
                return 0.0;
            }
        }
        set{
            this.VacPresRatioLow=value;
        }
    }

    public decimal VacKdLow{
        get{
            if(currentRV.VacKdLow__c != null){
               return currentRV.VacKdLow__c;
            }
            else{
                return 0.0;
            }
        }
        set{
            this.VacKdLow=value;
        }
    }

    public decimal StdVacKd{
        get{
            /*decimal decStdVacKd=0.0;
            if(VacPresRatioLow!=null || VacPresRatioHigh!=null)
            {
            if(VacIntMethod =='Linear')
            {
                 decStdVacKd=(((StdVacPresRatio - VacPresRatioHigh)*(VacKdLow - VacKdHigh))/(VacPresRatioLow - VacPresRatioHigh) + VacKdHigh);
                if(decStdVacKd!=null)
                    return decStdVacKd;
                else
                    return 0.0;
            }               
            else if(VacIntMethod =='Power')
                return 0.0;
            //return decStdVacKd=(EXP((LN(StdVacPresRatio)-LN(VacPresRatioHigh))*(LN(VacKdLow)-LN(VacKdHigh))/(LN(VacPresRatioLow)-LN(VacPresRatioHigh)) + LN(VacKdHigh)));
            else 
                return 0.0;
            }
            else
                return 0.0;*/
            if(currentRV.StdVacKd__c != null){
               return currentRV.StdVacKd__c;
            }
            else{
                return 0;
            }
       
        }
        set{
            this.StdVacKd=value;
        }
    }

    public decimal StdVacAirFlowSCFH{
        get{
            if(currentRV.StdVacAirFlowSCFH__c != null){
               return currentRV.StdVacAirFlowSCFH__c;
            }
            else{
                return 0.0;
            }
            
        }
        set{
            this.StdVacAirFlowSCFH=value;
        }
    }
    
    public decimal VacSetPresOSIG{
        get{
             decimal decVacSetPresOSIG=0.0;
             decVacSetPresOSIG=VacSetPresPSIG * 16;
            if(decVacSetPresOSIG!=null)
                return decVacSetPresOSIG;
            else 
                return 0.0;
        }
        set{
            this.VacSetPresOSIG=value;
        }
    }

    public decimal VacSetPresPSIG{
        get{
            if(currentRV.Converted_Vacuum_Setting__c!=null)
                return currentRV.Converted_Vacuum_Setting__c;
            else
                return 0.0;
        }
        set{
            this.VacSetPresPSIG=value;
        }
    }

    public decimal VacSettingMax{
        get{
            //SignificantDigitsDown ( ConvertPressure (VTPRS1, VTPRSU, VGEUNT)* VacSettingMaxFact, 3, -99) 
            decimal conpress=ConvertedVacuum;
            result res=new result();
            res=unitConversions.SignificantDigitsDown(conpress * VacSettingMaxFact,3,-99);
            decimal VacSettingMax=res.dblRetValue;
            if(VacSettingMax!=null)
                return VacSettingMax;
            else
                return 0.0;
        }
        set{
            this.VacSettingMax=value;
        }
    }

    public decimal VacSettingMin{
        get{
            //SignificantDigitsUp ( ConvertPressure (VTPRS1, VTPRSU, VGEUNT)* VacSettingMinFact, 3, -99) 
            decimal conpress=ConvertedVacuum;
            result res=new result();
            res=unitConversions.SignificantDigitsUp(conpress * VacSettingMinFact,3,-99);
            decimal VacSettingMin=res.dblRetValue;
            if(VacSettingMin!=null)
                return VacSettingMin;
            else
                return 0.0;
        }
        set{
            this.VacSettingMin=value;
        }
    }

    public decimal VacValveLeakMax{
        get{
            //SignificantDigitsDown ( ConvertPressure (VTPRS1, VTPRSU, VGEUNT)* VacValveLeakMaxFact, 3, -99) 
            decimal conpress=ConvertedVacuum;
            result res=new result();
            res=unitConversions.SignificantDigitsDown(conpress * VacValveLeakMaxFact,3,-99);
            decimal VacValveLeakMax=res.dblRetValue;
            if(VacValveLeakMax!=null)
                return VacValveLeakMax;
            else
                return 0.0;
        }
        set{
            this.VacValveLeakMax=value;
        }
    }

    public decimal VacValveLeakMin{
        get{
            //SignificantDigitsUp ( ConvertPressure (VTPRS1, VTPRSU, VGEUNT)* VacValveLeakMinFact, 3, -99) 
            decimal conpress=ConvertedVacuum;
            result res=new result();
            res=unitConversions.SignificantDigitsUp(conpress * VacValveLeakMinFact,3,-99);
            decimal VacValveLeakMin=res.dblRetValue;
            if(VacValveLeakMin!=null)
                return VacValveLeakMin;
            else
                return 0.0;
        }
        set{
            this.VacValveLeakMin=value;
        }
    }

    public decimal ValveMAWPPSIG{
        get{
            if(BodyMAWPpsig!=null && VacPalletMAWPpsig!=null)
            {
                //Added By Abhishek 21stMay
                if(BodyMAWPpsig < VacPalletMAWPpsig || VacPalletMAWPpsig == 0.0)
                    return BodyMAWPpsig;
                else 
                    return VacPalletMAWPpsig;                
            }
            else
                return 0.0;
        }
        set{
            this.ValveMAWPPSIG=value;
        }
    }    
    
    public decimal PosPilotSetMin{
        get{
            //SignificantDigitsUp ( ConvertPressure (RTPRS1, RTPRSU, RGEUNT)* PosPilotSetMinFact , 3, -99) 
            decimal conpress=ConvertedPressure;
            result res=new result();
            res=unitConversions.SignificantDigitsUp(conpress * PosPilotSetMinFact,3,-99);
            decimal PosPilotSetMin=res.dblRetValue;
            if(PosPilotSetMin!=null)
                return PosPilotSetMin;
            else
                return 0.0;
        }
        set{
            this.PosPilotSetMin=value;
        }
    }

    public decimal PosPilotSetMax{
        get{
            //SignificantDigitsDown ( ConvertPressure (RTPRS1, RTPRSU, RGEUNT)* PosPilotSetMaxFact , 3, -99) 
            decimal conpress=ConvertedPressure;
            result res=new result();
            res=unitConversions.SignificantDigitsDown(conpress * PosPilotSetMaxFact,3,-99);
            decimal PosPilotSetMax=res.dblRetValue;
            if(PosPilotSetMax!=null)
                return PosPilotSetMax;
            else
                return 0.0;
        }
        set{
            this.PosPilotSetMax=value;
        }
    }

    public decimal VacPilotSetMin{
        get{
            //SignificantDigitsUp ( ConvertPressure (VTPRS1, VTPRSU, VGEUNT)* VacPilotSetMinFact, 3, -99) 
            decimal conpress=ConvertedVacuum;
            result res=new result();
            res=unitConversions.SignificantDigitsUp(conpress * VacPilotSetMinFact,3,-99);
            decimal VacPilotSetMin=res.dblRetValue;
            if(VacPilotSetMin!=null)
                return VacPilotSetMin;
            else
                return 0.0;
        }
        set{
            this.VacPilotSetMin=value;
        }
    }

    public decimal VacPilotSetMax{
        get{
            //SignificantDigitsDown ( ConvertPressure (VTPRS1, VTPRSU, VGEUNT)* VacPilotSetMaxFact, 3, -99)
            decimal conpress=ConvertedVacuum;
            result res=new result();
            res=unitConversions.SignificantDigitsDown(conpress * VacPilotSetMaxFact,3,-99);
            decimal VacPilotSetMax=res.dblRetValue;
            if(VacPilotSetMax!=null)
                return VacPilotSetMax;
            else
                return 0.0; 
        }
        set{
            this.VacPilotSetMax=value;
        }
    }

    public decimal PosDomePresMax{
        get{
            //SignificantDigitsDown ( ConvertPressure (RTPRS1, RTPRSU, RGEUNT)* PosDomePresMaxFact , 3, -99) 
            decimal conpress=ConvertedPressure;
            result res=new result();
            res=unitConversions.SignificantDigitsDown(conpress * PosDomePresMaxFact,3,-99);
            decimal PosDomePresMax=res.dblRetValue;
            if(PosDomePresMax!=null)
                return PosDomePresMax;
            else
                return 0.0; 
        }
        set{
            this.PosDomePresMax=value;
        }
    }

    public decimal VacDomePresMax{
        get{
            //SignificantDigitsDown ( ConvertPressure (VTPRS1, VTPRSU, VGEUNT)* VacDomePresMaxFact, 3, -99) 
            decimal conpress=ConvertedVacuum;
            result res=new result();
            res=unitConversions.SignificantDigitsDown(conpress * VacDomePresMaxFact,3,-99);
            decimal VacDomePresMax=res.dblRetValue;
            if(VacDomePresMax!=null)
                return VacDomePresMax;
            else
                return 0.0; 
        }
        set{
            this.VacDomePresMax=value;
        }
    }

    public decimal PosPilotLeakLow{
        get{
            //SignificantDigitsUp ( ConvertPressure (RTPRS1, RTPRSU, RGEUNT)* PosPilotLeakLowFact , 3, -99) 
            decimal conpress=ConvertedPressure;
            result res=new result();
            res=unitConversions.SignificantDigitsUp(conpress * PosPilotLeakLowFact,3,-99);
            decimal PosPilotLeakLow=res.dblRetValue;
            if(PosPilotLeakLow!=null)
                return PosPilotLeakLow;
            else
                return 0.0; 
        }
        set{
            this.PosPilotLeakLow=value;
        }
    }

    public decimal PosPilotLeakHigh{
        get{
            //SignificantDigitsDown ( ConvertPressure (RTPRS1, RTPRSU, RGEUNT)* PosPilotLeakHighFact , 3, -99) 
            decimal conpress=ConvertedPressure;
            result res=new result();
            res=unitConversions.SignificantDigitsDown(conpress * PosPilotLeakHighFact,3,-99);
            decimal PosPilotLeakHigh=res.dblRetValue;
            if(PosPilotLeakHigh!=null)
                return PosPilotLeakHigh;
            else
                return 0.0; 
        }
        set{
            this.PosPilotLeakHigh=value;
        }
    }

    public decimal VacPilotLeakLow{
        get{
            //SignificantDigitsUp ( ConvertPressure (VTPRS1, VTPRSU, VGEUNT)* VacPilotLeakLowFact, 3, -99) 
            decimal conpress=ConvertedVacuum;
            result res=new result();
            res=unitConversions.SignificantDigitsUp(conpress * VacPilotLeakLowFact,3,-99);
            decimal VacPilotLeakLow=res.dblRetValue;
            if(VacPilotLeakLow!=null)
                return VacPilotLeakLow;
            else
                return 0.0; 
        }
        set{
            this.VacPilotLeakLow=value;
        }
    }

    public decimal VacPilotLeakHigh{
        get{
            //SignificantDigitsDown ( ConvertPressure (VTPRS1, VTPRSU, VGEUNT)* VacPilotLeakHighFact, 3, -99) 
            decimal conpress=ConvertedVacuum;
            result res=new result();
            res=unitConversions.SignificantDigitsDown(conpress * VacPilotLeakHighFact,3,-99);
            decimal VacPilotLeakHigh=res.dblRetValue;
            if(VacPilotLeakHigh!=null)
                return VacPilotLeakHigh;
            else
                return 0.0; 
        }
        set{
            this.VacPilotLeakHigh=value;
        }
    }

    public decimal PosStaticPresMin{
        get{
            //SignificantDigitsUp ( ConvertPressure (RTPRS1, RTPRSU, RGEUNT)* PosStaticPresMinFact , 3, -99) 
            decimal conpress=ConvertedPressure;
            result res=new result();
            res=unitConversions.SignificantDigitsUp(conpress * PosStaticPresMinFact,3,-99);
            decimal PosStaticPresMin=res.dblRetValue;
            if(PosStaticPresMin!=null)
                return PosStaticPresMin;
            else
                return 0.0; 
        }
        set{
            this.PosStaticPresMin=value;
        }
    }

    public decimal PosStaticPresMax{
        get{
            //SignificantDigitsDown ( ConvertPressure (RTPRS1, RTPRSU, RGEUNT)* PosStaticPresMaxFact , 3, -99) 
            decimal conpress=ConvertedPressure;
            result res=new result();
            res=unitConversions.SignificantDigitsDown(conpress * PosStaticPresMaxFact,3,-99);
            decimal PosStaticPresMax=res.dblRetValue;
            if(PosStaticPresMax!=null)
                return PosStaticPresMax;
            else
                return 0.0; 
        }
        set{
            this.PosStaticPresMax=value;
        }
    }

    public decimal VacStaticPresMin{
        get{
            //SignificantDigitsUp ( ConvertPressure (VTPRS1, VTPRSU, VGEUNT)* VacStaticPresMinFact, 3, -99)
            decimal conpress=ConvertedVacuum;
            result res=new result();
            res=unitConversions.SignificantDigitsUp(conpress * VacStaticPresMinFact,3,-99);
            decimal VacStaticPresMin=res.dblRetValue;
            if(VacStaticPresMin!=null)
                return VacStaticPresMin;
            else
                return 0.0;  
        }
        set{
            this.VacStaticPresMin=value;
        }
    }

    public decimal VacStaticPresMax{
        get{
            //SignificantDigitsDown ( ConvertPressure (VTPRS1, VTPRSU, VGEUNT)* VacStaticPresMaxFact, 3, -99) 
            decimal conpress=ConvertedVacuum;
            result res=new result();
            res=unitConversions.SignificantDigitsDown(conpress * VacStaticPresMaxFact,3,-99);
            decimal VacStaticPresMax=res.dblRetValue;
            if(VacStaticPresMax!=null)
                return VacStaticPresMax;
            else
                return 0.0; 
        }
        set{
            this.VacStaticPresMax=value;
        }
    }

    public decimal PosCritical{
        get{
            //( 2 / (PosK + 1) ) ^ (PosK / (PosK - 1) ) decf=math.pow(10, DecimalPlaces);  10 ^ DecimalPlaces
             double dblPosCritical=0.0,base=0.0,power=0.0;
             if(Posk!=null)
             {
                 base=2/(PosK+1);
                 power= PosK/(Posk-1);  
                 integer a=12;
                 dblPosCritical=math.pow(base, power);
                 decimal decPosCritical=decimal.valueOf(dblPosCritical);
                 if(decPosCritical!=null)
                    return decPosCritical;
                 else
                    return 0.0;
             }
             else
                 return 0.0;
        }
        set{
            this.PosCritical=value;
        }
    }

    public decimal VacCritical{
        get{
            //( 2 / (VacK + 1) ) ^ (VacK / (VacK - 1) )
             double dblVacCritical=0.0,base=0.0,power=0.0;
             if(Vack!=null)
             {
                 base=2/(VacK+1);
                 power= VacK/(VacK-1);  
                 integer a=12;
                 dblVacCritical=math.pow(base, power);
                 decimal decVacCritical=decimal.valueOf(dblVacCritical);
                 if(decVacCritical!=null)
                     return decVacCritical;
                 else
                    return 0.0;
             }
             else
                 return 0.0;
        }
        set{
            this.VacCritical=value;
        }
    }

    //Equations Methods End here
    
 
    public string PosLoad{
        get{
            if(MasterBlasterRecord.PosLoad__c!=null)
                return MasterBlasterRecord.PosLoad__c;
            else
                return ' ';
        }
        set{
            this.PosLoad=value;
        }
    }
    public decimal StdPosEffDia{
        get{
            if(MasterBlasterRecord.PosEffDia__c!=null)
                return MasterBlasterRecord.PosEffDia__c;
            else
                return 0.0;
        }
        set{
            this.StdPosEffDia=value;
        }
    }
    
    public decimal StdPosFullOP{
        get{
            if(MasterBlasterRecord.PosFullOP__c!=null)
                return MasterBlasterRecord.PosFullOP__c;
            else
                return 0.0;
        }
        set{
            this.StdPosFullOP=value;
        }
    }
    
    public string PosIntMethod{
        get{
            if(MasterBlasterRecord.PosIntMethod__c!=null)
                return MasterBlasterRecord.PosIntMethod__c;
            else
                return ' ';
        }
        set{
            this.PosIntMethod=value;
        }
    }
        
    public string VacLoad{
        get{
            if(MasterBlasterRecord.VacLoad__c!=null)
                return MasterBlasterRecord.VacLoad__c;
            else
                return ' ';
        }
        set{
            this.VacLoad=value;
        }
    }
    
    public decimal StdVacEffDia{
        get{
            if(MasterBlasterRecord.VacEffDia__c!=null)
                return MasterBlasterRecord.VacEffDia__c;
            else
                return 0.0;
        }
        set{
            this.StdVacEffDia=value;
        }
    }
      
    public decimal StdVacFullOP{
        get{
            if(MasterBlasterRecord.VacFullOP__c!=null)
                return MasterBlasterRecord.VacFullOP__c;
            else
                return 0.0;
        }
        set{
            this.StdVacFullOP=value;
        }
    }  
    
    public string VacIntMethod{
        get{
            if(MasterBlasterRecord.VacIntMethod__c!=null)
                return MasterBlasterRecord.VacIntMethod__c;
            else
                return ' ';
        }
        set{
            this.VacIntMethod=value;
        }
    }
    
    //Pending getters and setters from MasterBlaster

    public string PosPalletDesign{
        get
        {
            return PosSettingRecord.PalletDesign__c;
        }
        set
        {
            this.PosPalletDesign=value;
        }
    }
    
    public string PosSpacer{
        get
        {
            if(PosSettingRecord.SpacerYN__c != null)
            {
                return PosSettingRecord.SpacerYN__c;
            }
            else
            {
                return 'N';
            }
        }
        set
        {
            this.PosSpacer=value;
        }
    }
    
    public string VacPalletDesign{
        get
        {
            return VacSettingRecord.PalletDesign__c;
        }
        set
        {
            this.VacPalletDesign=value;
        }
    }        
            
    public string VacSpacer{
        get
        {
            if(VacSettingRecord.SpacerYN__c != null)
            {
                return VacSettingRecord.SpacerYN__c;
            }
            else
            {
                return 'N';
            }
        }

        set
        {
            this.VacSpacer=value;
        }
    }
    
    public decimal VacPalletMAWPpsig{
        get
        {
            if(VacSettingRecord.BackpressureUL__c!=null)
                return VacSettingRecord.BackpressureUL__c;
            else
                return 0.0;
        }
        set
        {
            this.VacPalletMAWPpsig=value;
        }
    }

    
    //MasterBlaster Methods End here
    
    
    
    
    //RV Getters and Setters
    
    //Not Completed
    public string PosFlow{
        get{
            if(currentRV.Relief_Type__c=='Pressure' || currentRV.Relief_Type__c=='Pressure & Vacuum')
                return 'Y';
            else
                return 'N';
        }
        set{
            this.PosFlow=value;
        }
    }
    //Not Completed
    public string VacFlow{
        get{
            if(currentRV.Relief_Type__c=='Vacuum' || currentRV.Relief_Type__c=='Pressure & Vacuum')
                return 'Y';
            else
                return 'N';
        }
        set{
            this.VacFlow=value;
        }
    }
    
    public decimal RTPRS1{
        get{
             if(currentRV.Pressure_Setting__c!=null)
                return currentRV.Pressure_Setting__c;
            else
                return 0.0;
        }
        set{
            this.RTPRS1=value;
        }
    }
    
    public string RTPRSU{
        get{
              return currentRV.Pressure_Setting_Units__c;
        }
        set{
            this.RTPRSU=value;
        }
    }
    
    public decimal GPRSC1{
        get{
            decimal conpress=ConvertedPressure;
            //system.debug('ConvertedPressure'+ConvertedPressure);
            if(conpress!=null)
            {
                result res=new result();
                res=unitConversions.SignificantDigitsNormal(conpress,3,-99);
                //system.debug('resPres'+res);
                decimal GPRSC1=res.dblRetValue;
                if(GPRSC1!=null)
                    return GPRSC1;
                else
                    return 0.0; 
            }
            else
                return 0.0;
            
        }
        set{
            this.GPRSC1=value;
        }
    }    
    
    public decimal PosBackPres{
        get{
            if(currentRV.Back_Pressure__c!=null)
                return currentRV.Back_Pressure__c.setScale(4);
            else
                return 0.0;
        }
        set{
            this.PosBackPres=value;
        }
    }
    
    public string PosBackPresUOM{
        get{
              return currentRV.Back_Pressure_Units__c;
        }
        set{
            this.PosBackPresUOM=value;
        }
    }    
    
    public decimal PosBackPresPSIG{
        get{
            if(currentRV.Converted_Back_Pressure__c!=0.0)
              return currentRV.Converted_Back_Pressure__c;
            else 
                return 0.0;
        }
        set{
            this.PosBackPresPSIG=value;
        }
    }
    
    public decimal VTPRS1{
        get{
            if(currentRV.Vacuum_Setting__c!=null)
              return currentRV.Vacuum_Setting__c;
            else 
                return 0.0;
        }
        set{
            this.VTPRS1=value;
        }
    }    
    
    public string VTPRSU{
        get{
              return currentRV.Vacuum_Setting_Units__c;
        }
        set{
            this.VTPRSU=value;
        }
    }
    
    public decimal GVRSC1{
        get{
            
            decimal conpress=ConvertedVacuum;
            if(conpress!=null)
            {
                result res=new result();
                res=unitConversions.SignificantDigitsNormal(conpress,3,-99);
                decimal vacres=res.dblRetValue;
                if(vacres!=null)
                    return vacres;
                else
                    return 0.0;
            }
            else
                return 0.0;
        }
        set{
            this.GVRSC1=value;
        }
    }
           
    public decimal MaxProcPres{
        get{
            if(currentRV.Max_Process_Pressure__c!=null)
                return currentRV.Max_Process_Pressure__c.setScale(4);
            else
                return 0.0;
        }
        set{
            this.MaxProcPres=value;
        }
    }
    
    public string MaxProcPresUOM{
        get{
              return currentRV.Max_Process_Pressure_Unit__c;
        }
        set{
            this.MaxProcPresUOM=value;
        }
    }
    
    public decimal MaxProcPresPSIG{
        get{
            if(currentRV.Converted_Max_Process_Pressure__c!=0.0)
              return currentRV.Converted_Max_Process_Pressure__c;
            else 
                return 0.0;
        }
        set{
            this.MaxProcPresPSIG=value;
        }
    }
    
    public decimal AtmPres{
        get{
            if(currentRV.Atmospheric_Pressure__c!=null)
              return currentRV.Atmospheric_Pressure__c;
            else
              return 0.0;
        }
        set{
            this.AtmPres=value;
        }
    }
    
    public string AtmPresUOM{
        get{
              return currentRV.Atmospheric_Pressure_Units__c;
        }
        set{
            this.AtmPresUOM=value;
        }
    }    
    
    public decimal AtmPresPSIA{
        get{
            if(currentRV.Converted_Atmospheric_Pressure__c!=null)
              return currentRV.Converted_Atmospheric_Pressure__c;
            else
                return 0.0;
        }
        set{
            this.AtmPresPSIA=value;
        }
    }
    
    //Needs to verifyfVacFlowPres
    public string DPM{
        get{
              return currentRV.Media__c;
        }
        set{
            this.DPM=value;
        }
    }    
    
    public string PosMediaName{
        get{
              return currentRV.Customer_Specified_Media_Name__c;
        }
        set{
            this.PosMediaName=value;
        }
    }
    
    public decimal PosK{
        get{
            if(currentRV.Ratio_of_Specific_Heats__c!=null)
              return currentRV.Ratio_of_Specific_Heats__c;
            else
                return 0.0;
        }
        set{
            this.PosK=value;
        }
    }    
    
    public decimal PosMW{
        get{
            if(currentRV.Molecular_Weight__c!=null)
              return currentRV.Molecular_Weight__c;
            else
                return 0.0;
        }
        set{
            this.PosMW=value;
        }
    }
    
    public decimal PosZ{
        get{
            if(currentRV.Compressibility_Factor__c!=null)
              return currentRV.Compressibility_Factor__c;
            else
                return 0.0;
        }
        set{
            this.PosZ=value;
        }
    }
           
    public decimal POSFLOWRATE{
        get{
            if(currentRV.Pressure_Relief_Req_Flow_Rate__c!=null)
              return currentRV.Pressure_Relief_Req_Flow_Rate__c;
            else
                return 0.0;
        }
        set{
            this.POSFLOWRATE=value;
        }
    }
    
    public string POSFLOWRATEUOM{
        get{
              return currentRV.Pressure_Relief_Req_Flow_Units__c;
        }
        set{
            this.POSFLOWRATEUOM=value;
        }
    }
     
    public decimal POSFLOWRATESCFH{
        get{
            System.debug('POSFLOWRATESCFH'+ currentRV.Converted_Pressure_Relief_Req_Flow__c);
            if(currentRV.Converted_Pressure_Relief_Req_Flow__c!=null && currentRV.Constraint_Product_Selection_By_Flow__c == true)
              return currentRV.Converted_Pressure_Relief_Req_Flow__c;
            else
                return 0.0;
        }
        set{
            this.POSFLOWRATESCFH=value;
        }
    } 
    
    public decimal POSFLOWPRES{
        get{
            if(currentRV.Enter_Relieving_Pressure_Value__c!=null)
              return currentRV.Enter_Relieving_Pressure_Value__c.setScale(4);
            else
                return 0.0;
        }
        set{
            this.POSFLOWPRES=value;
        }
    }
     
    public string PosFlowPresUOM{
        get{
              return currentRV.Enter_Relieving_Pressure_Units__c;
        }
        set{
            this.PosFlowPresUOM=value;
        }
    }
    
    public decimal GPOPCT{
        get{
            if(currentRV.Overpressure__c!=null)
              return currentRV.Overpressure__c;
            else
                return 0.0;              
        }
        set{
            this.GPOPCT=value;
        }
    }
     
    public decimal PosFlowPresPSIG{
        get{
            if(decPosFlowPresPSIG!=null)
                return decPosFlowPresPSIG;
            else
                return 0.0;
            /*
            if(currentRV.Constraint_Product_Selection_By_Flow__c == true)
            {
                if((currentRV.Enter_Relieving_Pressure_Value__c == 0.0 || currentRV.Enter_Relieving_Pressure_Value__c != null) && currentRV.Overpressure__c != null && currentRV.Converted_Pressure_Setting__c !=null)
                {
                    system.debug('If condition');
                    system.debug('Enter_Relieving_Pressure_Value__c' +currentRV.Enter_Relieving_Pressure_Value__c);
                    system.debug('Overpressure__c'+currentRV.Overpressure__c);
                    system.debug('currentRV.Converted_Pressure_Setting__c'+currentRV.Converted_Pressure_Setting__c);
                    return currentRV.Converted_Pressure_Setting__c + (currentRV.Converted_Pressure_Setting__c * currentRV.Overpressure__c);
                }
                else if(currentRV.Converted_Relieving_Pressure_Value__c != null && currentRV.Converted_Relieving_Pressure_Value__c != 0.0)
                {
                    return currentRV.Converted_Relieving_Pressure_Value__c;
                }
                else
                {
                    return 0.0;
                }
            }
            else if(currentRV.Converted_Pressure_Setting__c != null)
            {
                return currentRV.Converted_Pressure_Setting__c * 2;
            }
            else
            {
                return 0.0;
            }
            */
        }
        set{
            this.PosFlowPresPSIG=value;
        }
    } 

    
    public decimal PosTemp{
        get{
            if(currentRV.Pressure_Relieving_Temperature__c!=null)
              return currentRV.Pressure_Relieving_Temperature__c;
            else
                return 0.0;
        }
        set{
            this.PosTemp=value;
        }
    }
     
    public string PosTempUOM{
        get{
              return currentRV.Pressure_Relieving_Temperature_Units__c;
        }
        set{
            this.PosTempUOM=value;
        }
    }    
     
    public decimal PosTempDEGR{
        get{
            if(currentRV.Converted_Pressure_Relieving_Temperature__c!=null)
              return currentRV.Converted_Pressure_Relieving_Temperature__c;
            else 
                return 0.0;
        }
        set{
            this.PosTempDEGR=value;
        }
    } 
    
    public string VACDPM{
        get{
              return currentRV.Vacuum_Media__c;
        }
        set{
            this.VACDPM=value;
        }
    }
     
    public string VacMediaName{
        get{
              return currentRV.Customer_Specified_Media_Name__c;
        }
        set{
            this.VacMediaName=value;
        }
    }
    
    public decimal VacK{
        get{
            if(currentRV.Ratio_of_Specific_Heats__c!=null)
              return currentRV.Ratio_of_Specific_Heats__c;
            else
                return 0.0;
        }
        set{
            this.VacK=value;
        }
    }    
    
    public decimal VacMW{
        get{
             if(currentRV.Molecular_Weight__c!=null)
              return currentRV.Molecular_Weight__c;
            else
                return 0.0;
        }
        set{
            this.VacMW=value;
        }
    }
    
    public decimal VacZ{
        get{
             if(currentRV.Compressibility_Factor__c!=null)
              return currentRV.Compressibility_Factor__c;
            else
                return 0.0;
        }
        set{
            this.VacZ=value;
        }
    }
           
    public decimal VacFlowRate{
        get{
             if(currentRV.Vacuum_Relief_Req_Flow__c!=null)
              return currentRV.Vacuum_Relief_Req_Flow__c;
            else
                return 0.0;
        }
        set{
            this.VacFlowRate=value;
        }
    }
     
    public string VacFlowRateUOM{
        get{
              return currentRV.Vacuum_Relief_Required_Flow_Units__c;
        }
        set{
            this.VacFlowRateUOM=value;
        }
    } 
    
    public decimal VacFlowRateSCFH{
        get{
             if(currentRV.Converted_Vacuum_Relief_Req_Flow__c!=null)
              return currentRV.Converted_Vacuum_Relief_Req_Flow__c;
            else
                return 0.0;
        }
        set{
            this.VacFlowRateSCFH=value;
        }
    }
     
    public decimal VacFlowPres{
        get{
             if(currentRV.V_Enter_Relieving_Vacuum_Value__c!=null)
              return currentRV.V_Enter_Relieving_Vacuum_Value__c.setScale(4);
            else
                return 0.0;
        }
        set{
            this.VacFlowPres=value;
        }
    }
    
    public string VacFlowPresUOM{
        get{
              return currentRV.V_Enter_Relieving_Vacuum_units__c;
        }
        set{
            this.VacFlowPresUOM=value;
        }
    }
     
    public decimal GVOPCT{
        get{
             if(currentRV.V_Overpressure_Vacuum_Value__c!=null)
              return currentRV.V_Overpressure_Vacuum_Value__c;
            else
                return 0.0;
        }
        set{
            this.GVOPCT=value;
        }
    } 
    
    
    // changed formula
    // If(IsNull(GVOPCT), ConvertPressure (VacFlowPres, VacFlowPresUOM, "psig"), 
    // ConvertPressure (VTPRS1 * (GVOPCT + 100%), VTPRSU, "psig")
    // return currentRV.V_Converted_Relieving_Vacuum_Value__c;
    // result resultConvertedPressure=new result();
    // resultConvertedPressure=unitConversions.convertPressure(WGBProd.Pressure_Setting_Units__c,'in. water',WGBProd.Pilot_Supply_Pressure__c);
    // 
    // if(GVOPCT==null)
    //      return currentRV.V_Converted_Relieving_Vacuum_Value__c;
    // else
    //      return 
    //  
    public decimal VacFlowPresPSIG{
        get{
            if(decVacFlowPresPSIG!=null)
                return decVacFlowPresPSIG;
            else
                return 0.0;
            /*
          if(currentRV.Constraint_Product_Selection_By_Flow__c == true)
            {
                if((currentRV.V_Enter_Relieving_Vacuum_Value__c == 0.0 || currentRV.V_Enter_Relieving_Vacuum_Value__c == null) &&(currentRV.V_Overpressure_Vacuum_Value__c != null))
                {
                    system.debug('@@ currentRV.Converted_Vacuum_Setting__c'+currentRV.Converted_Vacuum_Setting__c+'currentRV.V_Overpressure_Vacuum_Value__c'+currentRV.V_Overpressure_Vacuum_Value__c+'currentRV.V_Enter_Relieving_Vacuum_Value__c'+currentRV.V_Enter_Relieving_Vacuum_Value__c);
                    return currentRV.Converted_Vacuum_Setting__c + (currentRV.Converted_Vacuum_Setting__c * currentRV.V_Overpressure_Vacuum_Value__c);
                }
                else
                {
                    return currentRV.V_Converted_Relieving_Vacuum_Value__c;
                }
            }
            else if(currentRV.Converted_Vacuum_Setting__c != null)
            {
                return currentRV.Converted_Vacuum_Setting__c * 2;
            }
            else
            {
                return 0.0;
            }*/
        }
        set{
            this.VacFlowPresPSIG=value;
        }
    }
    public decimal VacTemp{
        get{
            if(currentRV.V_Vacuum_Relieving_Temperature__c!=null)
              return currentRV.V_Vacuum_Relieving_Temperature__c;
            else
                return 0.0;
        }
        set{
            this.VacTemp=value;
        }
    }
     
    public string VacTempUOM{
        get{
              return currentRV.V_Vacuum_Relieving_Temperature_Units__c;
        }
        set{
            this.VacTempUOM=value;
        }
    }
 
    public decimal VacTempDEGR{
        get{
            if(currentRV.V_Converted_Vacuum_Relieving_Temperature__c!=null)
              return currentRV.V_Converted_Vacuum_Relieving_Temperature__c;
            else
                return 0.0;
        }
        set{
            this.VacTempDEGR=value;
        }
    }
    
    public String PED {
        get {
            return currentRV.PED_bkend__c;
        }
        set {
            this.PED = value;
        }
    }    
    public string ATEX {
        get {
            return currentRV.Atex_bkend__c;
        }
        set {
            this.ATEX = value;
        }
    }
    
     public string GasGroup{
        get{
            return currentRV.Gas_Group__c;
        }
        set{
            this.GasGroup=value;
        }
    }
    
    public string ATEXZONE{
        get{
            if(currentRV.Zone__c != null)
            {
                return currentRV.Zone__c;
            }
            else
            {
                return '';
            }
        }
        set{
            this.ATEXZONE=value;
        }
    }
    
    public String CUTR {
        get {
            return currentRV.CUTR_bkend__c;
        }
        set {
            this.CUTR = value;
        }
    }   
    
    public String NACE {
        get {
            return currentRV.Nace_Backend__c;
        }
        set {
            this.NACE = value;
        }
    }  
    
     public string VENTING {
        get {
            return currentRV.Type_of_model__c;
        }
        set {           
            this.VENTING = value;
        }
    } 
    
    public string OPPERCENT {
        get {
            return currentRV.Type_of_overpressure_valve__c;
        }
        set {           
            this.OPPERCENT = value;
        }
    } 
    
    public string FACompliant {
        get {
            return currentRV.Is_flame_arrester_needed_with_your_valve__c;
        }
        set {           
            this.FACompliant = value;
        }
    } 
    
    public String PTC {
        get {
            return currentRV.Model_name__c;
        }
        set {
            currentRV.Model_name__c  = value;
            this.PTC = value;
        }
    }
   public String SZC {
        get {
            return currentRV.Size__c;
        }
        set {
            this.SZC = value;
        }
    }

    public String PARTNUMBER {
        get{
            return currentRV.Part_Number__c;
        }
        set{
            this.PARTNUMBER = value;
        }
    }

   public String PARTNUMBERDESC {
        get{
            if(currentRV.Quote_Description_Engineer_Override__c == true)
            {
                string OB070 = '';
                if(currentRV.OB070__c != null)
                {
                    OB070 = currentRV.OB070__c;
                }
                else
                {
                    OB070 = '';
                }
                string OB060 = '';
                if(currentRV.OB060__c != null)
                {
                    OB060 = currentRV.OB060__c;
                }
                else
                {
                    OB060 = '';
                }
                
                return 'Special' + ' ' + BRAND + ' ' + 'Model: ' + PTC + ' ' + currentRV.OA04__c + ' ' + currentRV.OA05__c + ' ' + currentRV.OB010__c + ' ' + OB060 + ' ' + OB070 + ' ' + currentRV.OB080__c;
            }
            else
            {
                string OB070 = '';
                if(currentRV.OB070__c != null)
                {
                    OB070 = currentRV.OB070__c;
                }
                else
                {
                    OB070 = '';
                }
                string OB060 = '';
                if(currentRV.OB060__c != null)
                {
                    OB060 = currentRV.OB060__c;
                }
                else
                {
                    OB060 = '';
                }
                
                return ''+BRAND + ' ' + 'Model: ' + PTC + ' ' + currentRV.OA04__c + ' ' + currentRV.OA05__c + ' ' + currentRV.OB010__c + ' ' + OB060 + ' ' + OB070 + ' ' + currentRV.OB080__c;
                //system.debug('OA04'+currentRV.OA04__c+'OA05'+currentRV.OA05__c+'OB010'+currentRV.OB010__c);
            }
        }
        set{
            this.PARTNUMBERDESC = value;
        }
    }

    public string PARTREV { 
        get 
        {
            if(currentRV.PARTREV__c != null)
                return currentRV.PARTREV__c;
            else
                return '1';
        }
        set 
        {
            this.PARTREV = value;
        }
    }

    public string NOTE { 
        get 
        {
            if(currentRV.Engineering_Notes__c != null)
                return currentRV.Engineering_Notes__c;
            else
                return ' ';
        }
        set 
        {
            this.NOTE = value;
        }
    }

    public String PARTMANAGEDIN {
        get {
            if(currentRV.Quote_Description_Engineer_Override__c == false)
            {
                return 'Salesforce';
            }
            else{
                return 'IFS';
            }
        }
        set {
            this.PARTMANAGEDIN = value;
        }
    }
 
    public String HCLASS {
        get {
            return currentRV.Drilling__c;
        }
        set {
            currentRV.Drilling__c    = value;
            this.HCLASS = value;
        }
    }
    
    public String MCBODY {
        get {
            if(currentRV.Body_Material__c!=null)
                return currentRV.Body_Material__c;
            else 
                return ' ';
        }
        set {
            currentRV.Body_Material__c   = value;
            this.MCBODY = value;
        }
    }
    
    public string GPFACE{
        get{
            return currentRV.Facing__c;
        }
        set{
            this.GPFACE=value;
        }
    }
    
     public String MCSEAT {
        get {
            return currentRV.Seat_Material__c;
        }
        set {
            currentRV.Seat_Material__c   = value;
            this.MCSEAT = value;
        }
    }    
    
    public string MCPALL{
        get{
            if(currentRV.Pressure_Pallet_Material__c != null)
            {
                return currentRV.Pressure_Pallet_Material__c;
            }
            else
            {
                return '';
            }
        }
        set{
            this.MCPALL=value;
        }
    }
    
    public String GPTYPE {
        get {
            return currentRV.Pallet_Type__c;
     
        }
        set {
            currentRV.Pallet_Type__c     = value;
            this.GPTYPE = value;
        }
    }    
    
    //MCDPHM
    public string MCDPHM{
        get{
             return currentRV.Diaphragm_Material__c;
        }
        set{
            this.MCDPHM=value;
        }
    }
  
    //MCVPAL
   
    public string MCVPAL{
        get{
            if(currentRV.Vacuum_Pallet_Material__c != null)
            {
                return currentRV.Vacuum_Pallet_Material__c;
            }
            else
            {
                return '';
            }
        
        }
        set{
            this.MCVPAL=value;
        }
    }
   //MCPSGD
   public string MCPSGD{
        get{
            if(currentRV.Pilot_Soft_Goods_Material__c !=null)
            {
                  if(currentRV.Pilot_Soft_Goods_Material__c == 'N')
                {
                    return 'NA';
                }
                else{
                    return currentRV.Pilot_Soft_Goods_Material__c;            
                }  
            }
            else
                return ' ';
  
        }
        set{
            this.MCPSGD=value;
        }
    }
   //MCWGHT
   public string MCWGHT{
        get{
         return currentRV.Weight_Material__c;
  
        }
        set{
            this.MCWGHT=value;
        }
    }
   //MCSPRG 
   public string MCSPRG{
        get{
          return currentRV.Spring_Material__c;

        }
        set{
            this.MCSPRG=value;
        }
    }
   //MCFAST
   public string MCFAST{
        get{
              return currentRV.Fastener_Material__c;

        }
        set{
            this.MCFAST=value;
        }
    }
   //MCSTMJ
    public string MCSTMJ{
        get{
            return currentRV.Steam_Jacket_Material__c;          
        }
        set{
            this.MCSTMJ=value;
        }
    }
    
    public String GPAINT {
        get {
            return currentRV.Painting_Coating_Option__c;
          
        }
        set {
            currentRV.Painting_Coating_Option__c = value;
            this.GPAINT = value;
        }
    }    
    
    //MCCOTB
    public string MCCOTB{
        get{
             return currentRV.Body_Coating_Material__c;
          
        }
        set{
            this.MCCOTB=value;
        }
    }
    //MCCOTP
    public string MCCOTP{
        get{
            return currentRV.Pallet_Fastener_Coating_Material__c;

        }
        set{
            this.MCCOTP=value;
        }
    }
    //MCELMT
    public string MCELMT{
        get{
             return currentRV.Element_Material__c;

        }
        set{
            this.MCELMT=value;
        }
    }    
    //GOUTOP
    public string GOUTOP{
        get{
              return currentRV.Flame_Arrester_Option__c;
        }
        set{
            this.GOUTOP=value;
        }
    }
    //VPRTOP
    public string VPRTOP{
        get{
            if(currentRV.Vacuum_Port_Option__c!=null)
              return currentRV.Vacuum_Port_Option__c;
            else
                return ' ';              
        }
        set{
            this.VPRTOP=value;
        }
    }
    //POSPROXSENSOR
    //start updated by Abhishek 14/4
    public string POSPROXSENSOR{
        get{
              return currentRV.Pressure_Port_Proximity_Sensor_Backend__c;
        }
        set{
            this.POSPROXSENSOR=value;
        }
    }
    //VACPROXSENSOR
    public string VACPROXSENSOR{
        get{
              return currentRV.Vacuum_Port_Proximity_Sensor_Backend__c;
        }
        set{
            this.VACPROXSENSOR=value;
        }
    }
    //GPACT
    public string GPACT{
        get{
            if(currentRV.Pilot_Action__c!=null)
                return currentRV.Pilot_Action__c;  
            else
                return ' ';
        }
        set{
            this.GPACT=value;
        }
    }
    //manualBlowdown
    public string ManualBlowdown{
        get{
            if(currentRV.Manual_Blowdown__c == true)
            {
              return 'Y';
            }
            else
            {
                return 'N';
            }
        }
        set{
            this.manualBlowdown=value;
        }
    }
    //remoteSense
    public string RemoteSense{
        get{
            if(currentRV.Remote_Sense__c == true)
            {
              return 'Y';
            }
            else
            {
                return 'N';
            }
        }
        set{
            this.remoteSense=value;
        }
    }    
    //pilotExhstPiped
    public string PilotExhstPiped{
        get{
            if(currentRV.Pilot_Exhaust_Piped_to_Discharge_Header__c == true)
            {
              return 'Y';
            }
            else
            {
                return 'N';
            }
        }
        set{
            this.pilotExhstPiped=value;
        }
    }
    //fieldTestConnect
     public String FieldTestConnect {
        get{
            if(currentRV.Field_Test_Connection__c == true)
            {
              return 'Y';
            }
            else
            {
                return 'N';
            }
        }
        set{
            this.FieldTestConnect =value;
        }
    } 
    //pilotSplyFilter
    public String PilotSplyFilter{
        get{
            if(currentRV.Pilot_Supply_Filter__c == true)
            {
              return 'Y';
            }
            else
            {
                return 'N';
            }
        }
        set{
            this.pilotSplyFilter=value;
        }
    }
    
    
    public String GMTH21 {
        get {
            if(currentRV.Method21_Leak_Detection__c == true)
            {
                return 'Y';
            }
            else
            {
                return 'N';
            }
       
        }
        set {            
            this.GMTH21 = value;
        }
    }    
    public String XRAY {
        get {
          return currentRV.Radiography__c;
           
        }
        set {
          currentRV.Radiography__c = value;
            this.XRAY = value;
        }
    }    
    public String FWLDP {
        get {
            if(currentRV.Fillet_Weld_Liquid_Dye_Penetrant__c == true)
            {
                return 'Y';
            }
            else
            {
                return 'N';
            }
        }
        set {
            
            this.FWLDP = value;
        }
    }
    
    public String PMI {
        get {
                if(currentRV.Positive_Material_Identification__c!=null)
                    return currentRV.Positive_Material_Identification__c;           
            else
                return 'N';
        }
        set {
           //currentRV.Positive_Material_Identification__c = value;
            this.PMI = value;
        }
    }
    
    public String LDP {
        get {
            return currentRV.Liquid_Dye_Penetrant__c;
         
        }
        set {
            this.LDP = value;
        }
    }    
    public String USONICEXAM {
        get {
            if(currentRV.Ultrasonic_Examination__c == true)
            {
                return 'Y';
            }
            else
            {
                return 'N';
            }
        }
        set {
           
            this.USONICEXAM = value;
        }
    }
    public String MAGPARTEXAM {
        get {
            if(currentRV.Magnetic_Particle_Examination__c == true)
            {
                return 'Y';
            }
          else
          {
              return 'N';
          }
        }
        set {
            
            this.MAGPARTEXAM = value;
        }
    }    
    public String BRINHARDEXAM {
        get {
            if(currentRV.Brinell_hardness_examination__c == true)
            {
                return 'Y';
            }
            else
            {
                return 'N';
            }
        }
        set {
            
            this.BRINHARDEXAM = value;
        }
    }
    
    //CHARPYIMPEXAM
    public String CHARPYIMPEXAM {
        get {
            if(currentRV.Charpy_Impact_Testing__c == true)
            {
                return 'Y';
            }
            else
            {
                return 'N';
            }
        }
        set {
            this.CHARPYIMPEXAM = value;
        }
    }
    
    public String VISCASTEXAM {
        get {
            if(currentRV.Visual_Casting_Examination__c == true)
            {
                return 'Y';
            }
            else
            {
                return 'N';
            }
        }
        set {
            
            this.VISCASTEXAM = value;
        }
    }
    
    //IGCEXAM
    public String IGCEXAM {
        get {
          return currentRV.Intergranular_Corossion_Test_Backend__c;
         
        }
        set {
            this.IGCEXAM = value;
        }
    }
    
    //SHLTSTMETHBDY   Needs to be verified
    public String SHLTSTMETHBDY{
        get{
            if(currentRV.Shell_Test_Valve_Body__c != null)
            {
                return currentRV.Shell_Test_Valve_Body__c;
            }
            else
            {
                return 'N';
            }
           
        }
        set{
            this.SHLTSTMETHBDY=value;
        }
    }
    
    
    //ASSYLOCATION  pending
    public string ASSYLOCATION{
        get{
            return currentRV.Final_Assembly_Location_Requirements__c;
        }
        set{
            this.ASSYLOCATION=value;
        }
    }
    
    //MATLSOURCE  pending
    public string MATLSOURCE{
        get{
            return currentRV.Material_Sourcing_Requirements__c;
        }
        set{
            this.MATLSOURCE=value;
        }
    }
    //end updated by Abhishek 14/4
   //getters setters by vik over here   
        
    public String Model {
        get {
            return currentRV.Model_name__c;
        }
        set {
            currentRV.Model_name__c  = value;
            this.PTC = value;
        }
    }
    public String Size {
        get {
            return currentRV.Size_Preference__c;
        }
        set {
            currentRV.Size_Preference__c     = value;
            this.Size = value;
        }
    }  
    public string Schedule {
        get {
            return currentRV.Schedule_BaseLead__c;
        }
        set {
            currentRV.Schedule_BaseLead__c = value;
            this.Schedule = value;
        }
    }
    public decimal QTY {
        get {
            return currentRV.Quantity__c;
        }
        set {
            currentRV.Quantity__c = value;
            this.QTY = value;
        }
    }
 
    public String ReliefType {
        get {
            return currentRV.Relief_Type__c;
        }
        set {
            currentRV.Relief_Type__c= value;
            this.ReliefType = value;
        }
    }    
    
    public decimal SettingMinPressure {
        get {
            if(PosSettingMin!=null)
                return PosSettingMin;
            else
                return 0.0;
        }
        set {
            this.SettingMinPressure = value;
        }
    }
    
    public decimal SettingMinVacuum {
        get {
            if(VacSettingMin!=null)
                return VacSettingMin;
            else
                return 0.0;
        }
        set {
            this.SettingMinVacuum = value;
        }
    }
    
    
    public decimal QTYLL {
        get {
                return QTY;
        }
        set {
            this.QTYLL = value;
        }
    }
    
    public decimal QTYUL {
        get {
                return QTY;
        }
        set {
            this.QTYUL = value;
        }
    }
    
    public string SubModel {
        get {
                return PTC;
        }
        set {
            this.SubModel = value;
        }
    }
    
    public string SteamJacketMatlCode {
        get 
        {
            return currentRV.Steam_Jacket_Material__c;
        }
        set 
        {
            this.SteamJacketMatlCode = value;
        }
    }
    
    public String PROXSENSORPRES {
        get {
                return POSPROXSENSOR;
        }
        set {
            this.PROXSENSORPRES = value;
        }
    }
    
    public string DrillingCode {
        get {
                return HCLASS;
        }
        set {
            this.DrillingCode = value;
        }
    }
    
    public string BodyMatlCode {
        get {
                return MCBODY;
        }
        set {
            this.BodyMatlCode = value;
        }
    }
    
    public string PosMatlID {
        get {
                return PMI;
        }
        set {
            this.PosMatlID = value;
        }
    }
    
    public String VisualCastingExam {
        get {
                return VISCASTEXAM;
        }
        set {
            this.VisualCastingExam = value;
        }
    }
    
    public String FilletLiquidDye {
        get {
                return FWLDP;
        }
        set {
            this.FilletLiquidDye = value;
        }
    }
    
    public string MaterialSource {
        get {
                return MATLSOURCE;
        }
        set {
            this.MaterialSource = value;
        }
    }
    public Decimal convertNullToZero(String value)
    {
        if(value == null)
        {
            value = '0.00';
        }
        return decimal.valueOf(value);
    }
    
    public String ASSEMBLYWT{ 
        get {
        return mapRV_Attribute.get('ASSEMBLYWT')==null?' ': mapRV_Attribute.get('ASSEMBLYWT');
                }
            set {
                    this.ASSEMBLYWT= value;
                }
            }
    public String ASSEMBLYWTUOM{ 
        get {
        return mapRV_Attribute.get('ASSEMBLYWTUOM')==null?' ': mapRV_Attribute.get('ASSEMBLYWTUOM');
                }
            set {
                    this.ASSEMBLYWTUOM= value;
                }
            }
    public String ATTRTEMPLATE{ 
        get {
        return mapRV_Attribute.get('ATTRTEMPLATE')==null?' ': mapRV_Attribute.get('ATTRTEMPLATE');
                }
            set {
                    this.ATTRTEMPLATE= value;
                }
            }
    public String COMPDESCRIPTION{ 
        get {
        return mapRV_Attribute.get('COMPDESCRIPTION')==null?' ': mapRV_Attribute.get('COMPDESCRIPTION');
                }
            set {
                    this.COMPDESCRIPTION= value;
                }
            }
    public String COMPINVSERTRK{ 
        get {
        return mapRV_Attribute.get('COMPINVSERTRK')==null?' ': mapRV_Attribute.get('COMPINVSERTRK');
                }
            set {
                    this.COMPINVSERTRK= value;
                }
            }
    public String COMPLOTTRACK{ 
        get {
        return mapRV_Attribute.get('COMPLOTTRACK')==null?' ': mapRV_Attribute.get('COMPLOTTRACK');
                }
            set {
                    this.COMPLOTTRACK= value;
                }
            }
    public String COMPPROVIDE{ 
        get {
        return mapRV_Attribute.get('COMPPROVIDE')==null?' ': mapRV_Attribute.get('COMPPROVIDE');
                }
            set {
                    this.COMPPROVIDE= value;
                }
            }
    public String COMPRESPONID{ 
        get {
        return mapRV_Attribute.get('COMPRESPONID')==null?' ': mapRV_Attribute.get('COMPRESPONID');
                }
            set {
                    this.COMPRESPONID= value;
                }
            }
    public String ConnectionOutlet{ 
        get {
        return mapRV_Attribute.get('ConnectionOutlet')==null?' ': mapRV_Attribute.get('ConnectionOutlet');
                }
            set {
                    this.ConnectionOutlet= value;
                }
            }
    public String CONSTBDYTST{ 
        get {
        return mapRV_Attribute.get('CONSTBDYTST')==null?' ': mapRV_Attribute.get('CONSTBDYTST');
                }
            set {
                    this.CONSTBDYTST= value;
                }
            }
    public String CUSTOMSTATNO{ 
        get {
        return mapRV_Attribute.get('CUSTOMSTATNO')==null?' ': mapRV_Attribute.get('CUSTOMSTATNO');
                }
            set {
                    this.CUSTOMSTATNO= value;
                }
            }
    public String GMODELGPTYPE{ 
        get {
        return mapRV_Attribute.get('GMODELGPTYPE')==null?' ': mapRV_Attribute.get('GMODELGPTYPE');
                }
            set {
                    this.GMODELGPTYPE= value;
                }
            }
    public String GMODELOpt1{ 
        get {
        return mapRV_Attribute.get('GMODELOpt1')==null?' ': mapRV_Attribute.get('GMODELOpt1');
                }
            set {
                    this.GMODELOpt1= value;
                }
            }
    public String GMODELOpt2{ 
        get {
        return mapRV_Attribute.get('GMODELOpt2')==null?' ': mapRV_Attribute.get('GMODELOpt2');
                }
            set {
                    this.GMODELOpt2= value;
                }
            }
    public String GMODELOpt3{ 
        get {
        return mapRV_Attribute.get('GMODELOpt3')==null?' ': mapRV_Attribute.get('GMODELOpt3');
                }
            set {
                    this.GMODELOpt3= value;
                }
            }
    public String GMODELPTC{ 
        get {
        return mapRV_Attribute.get('GMODELPTC')==null?' ': mapRV_Attribute.get('GMODELPTC');
                }
            set {
                    this.GMODELPTC= value;
                }
            }
    public String HSNSACCODE{ 
        get {
        return mapRV_Attribute.get('HSNSACCODE')==null?' ': mapRV_Attribute.get('HSNSACCODE');
                }
            set {
                    this.HSNSACCODE= value;
                }
            }
    public String LOTTRACKCODE{ 
        get {
        return mapRV_Attribute.get('LOTTRACKCODE')==null?' ': mapRV_Attribute.get('LOTTRACKCODE');
                }
            set {
                    this.LOTTRACKCODE= value;
                }
            }
    public String PARTCLASS{ 
        get {
        return mapRV_Attribute.get('PARTCLASS')==null?' ': mapRV_Attribute.get('PARTCLASS');
                }
            set {
                    this.PARTCLASS= value;
                }
            }
    public String PARTUOM{ 
        get {
        return mapRV_Attribute.get('PARTUOM')==null?' ': mapRV_Attribute.get('PARTUOM');
                }
            set {
                    this.PARTUOM= value;
                }
            }
    public String PLANNER{ 
        get {
        return mapRV_Attribute.get('PLANNER')==null?' ': mapRV_Attribute.get('PLANNER');
                }
            set {
                    this.PLANNER= value;
                }
            }
    public String PNMCDPHM{ 
        get {
        return mapRV_Attribute.get('PNMCDPHM')==null?' ': mapRV_Attribute.get('PNMCDPHM');
                }
            set {
                    this.PNMCDPHM= value;
                }
            }
    public String PNMODEL{ 
        get {
        return mapRV_Attribute.get('PNMODEL')==null?' ': mapRV_Attribute.get('PNMODEL');
                }
            set {
                    this.PNMODEL= value;
                }
            }
    public String PROVIDE{ 
        get {
        return mapRV_Attribute.get('PROVIDE')==null?' ': mapRV_Attribute.get('PROVIDE');
                }
            set {
                    this.PROVIDE= value;
                }
            }
    public String RESPONSIBLE_ID{ 
        get {
        return mapRV_Attribute.get('RESPONSIBLE_ID')==null?' ': mapRV_Attribute.get('RESPONSIBLE_ID');
                }
            set {
                    this.RESPONSIBLE_ID= value;
                }
            }
    public String SALESGROUP{ 
        get {
        return mapRV_Attribute.get('SALESGROUP')==null?' ': mapRV_Attribute.get('SALESGROUP');
                }
            set {
                    this.SALESGROUP= value;
                }
            }
    public String SALESPRICEGROUP{ 
        get {
        return mapRV_Attribute.get('SALESPRICEGROUP')==null?' ': mapRV_Attribute.get('SALESPRICEGROUP');
                }
            set {
                    this.SALESPRICEGROUP= value;
                }
            }
    public String SERIALTRACKCODE{ 
        get {
            if(Test.isRunningTest())
            {
                return 'Serial Tracking';
            }
        return mapRV_Attribute.get('SERIALTRACKCODE')==null?' ': mapRV_Attribute.get('SERIALTRACKCODE');
                }
            set {
                    this.SERIALTRACKCODE= value;
                }
            }
    public String WtPosPalletFiberglassMatlCode{ 
        get {
        return mapRV_Attribute.get('WtPosPalletFiberglassMatlCode')==null?' ': mapRV_Attribute.get('WtPosPalletFiberglassMatlCode');
                }
            set {
                    this.WtPosPalletFiberglassMatlCode= value;
                }
            }
    public String WtVacPalletFiberglassMatlCode{ 
        get {
        return mapRV_Attribute.get('WtVacPalletFiberglassMatlCode')==null?' ': mapRV_Attribute.get('WtVacPalletFiberglassMatlCode');
                }
            set {
                    this.WtVacPalletFiberglassMatlCode= value;
                }
            }
    public String WtPalletFiberglassPressureDesign{ 
        get {
        return mapRV_Attribute.get('WtPalletFiberglassPressureDesign')==null?' ': mapRV_Attribute.get('WtPalletFiberglassPressureDesign');
                }
            set {
                    this.WtPalletFiberglassPressureDesign= value;
                }
            }
    public String WtPosPalletFiberglassType{ 
        get {
        return mapRV_Attribute.get('WtPosPalletFiberglassType')==null?' ': mapRV_Attribute.get('WtPosPalletFiberglassType');
                }
            set {
                    this.WtPosPalletFiberglassType= value;
                }
            }
    public String WtVacPalletFiberglassType{ 
        get {
        return mapRV_Attribute.get('WtVacPalletFiberglassType')==null?' ': mapRV_Attribute.get('WtVacPalletFiberglassType');
                }
            set {
                    this.WtVacPalletFiberglassType= value;
                }
            }
    public String WtPalletFiberglassVacuumDesign{ 
        get {
        return mapRV_Attribute.get('WtPalletFiberglassVacuumDesign')==null?' ': mapRV_Attribute.get('WtPalletFiberglassVacuumDesign');
                }
            set {
                    this.WtPalletFiberglassVacuumDesign= value;
                }
            }
    //Service Ticket #200844 
    public String FBGModel{ 
        get {
                return mapRV_Attribute.get('FBGModel')==null?' ': mapRV_Attribute.get('FBGModel');
            }
        set {
                this.FBGModel= value;
            }
    }

    public Map<string,string> getmapRVInterfaceAttr(){
        
            Map<String, string> myMap1 = new Map<String, String>(); 
                myMap1.put('ASSYLOCATION',ASSYLOCATION);
                myMap1.put('ASYTYP',ASYTYP);
                myMap1.put('ATEX',ATEX);
                myMap1.put('ATEXZONE',ATEXZONE);
                myMap1.put('BRINHARDEXAM',BRINHARDEXAM);
                myMap1.put('CHARPYIMPEXAM',CHARPYIMPEXAM);
                myMap1.put('CUTR',CUTR);
                myMap1.put('ESZC',ESZC);
                myMap1.put('FBASSY',FBASSY);
                myMap1.put('FieldTestConnect',FieldTestConnect);
                myMap1.put('FWLDP',FWLDP);
                myMap1.put('GasGroup',GasGroup);
                myMap1.put('GMODEL',GMODEL);
                myMap1.put('GMTH21',GMTH21);
                myMap1.put('GOUTOP',GOUTOP);
                myMap1.put('GPACT',GPACT);
                myMap1.put('GPAINT',GPAINT);
                myMap1.put('GPDS03',GPDS03);
        
            //Weight IFS Attributes are below
                myMap1.put('GPDS05',mapWeight.get('GPDS05'));
                myMap1.put('GPDS06',mapWeight.get('GPDS06'));
                myMap1.put('GPDS07',mapWeight.get('GPDS07'));
                myMap1.put('GPDS08',mapWeight.get('GPDS08'));
                //myMap1.put('GPDS09',mapWeight.get('GPDS09'));
                myMap1.put('GPDS09',GPDS09);
                myMap1.put('GPDS13',mapWeight.get('GPDS13'));
                myMap1.put('GPDS14',mapWeight.get('GPDS14'));
                myMap1.put('GPDS15',mapWeight.get('GPDS15'));
                myMap1.put('GPDS16',mapWeight.get('GPDS16'));
                myMap1.put('GPDS17',mapWeight.get('GPDS17'));
                myMap1.put('GPDS18',mapWeight.get('GPDS18'));
                myMap1.put('GPDS19',mapWeight.get('GPDS19'));
                myMap1.put('GPDS20',mapWeight.get('GPDS20'));
                myMap1.put('GPDS21',mapWeight.get('GPDS21'));
                myMap1.put('GPDS22',mapWeight.get('GPDS22'));
                myMap1.put('GPDS23',mapWeight.get('GPDS23'));
                myMap1.put('GPDS24',mapWeight.get('GPDS24'));
                myMap1.put('GPDS25',mapWeight.get('GPDS25'));
                myMap1.put('GPDS26',mapWeight.get('GPDS26'));
                myMap1.put('GPDS27',mapWeight.get('GPDS27'));
                myMap1.put('GPDS28',mapWeight.get('GPDS28'));
                myMap1.put('GPDS29',mapWeight.get('GPDS29'));
                myMap1.put('GPDS30',mapWeight.get('GPDS30'));
                myMap1.put('GPDS31',mapWeight.get('GPDS31'));
                myMap1.put('GPDS32',mapWeight.get('GPDS32'));
                myMap1.put('GPDS33',mapWeight.get('GPDS33'));
                myMap1.put('GPDS34',mapWeight.get('GPDS34'));
                myMap1.put('GPDS35',mapWeight.get('GPDS35'));
                myMap1.put('GPDS36',mapWeight.get('GPDS36'));
                myMap1.put('GPDS37',mapWeight.get('GPDS37'));
                myMap1.put('GPDS38',mapWeight.get('GPDS38'));
                myMap1.put('GPDS39',mapWeight.get('GPDS39'));
                myMap1.put('GPDS40',mapWeight.get('GPDS40'));
                myMap1.put('GPDS41',mapWeight.get('GPDS41'));
                myMap1.put('GPDS42',mapWeight.get('GPDS42'));
                myMap1.put('GPDS43',mapWeight.get('GPDS43'));
                myMap1.put('GPDS44',mapWeight.get('GPDS44')); 
            //Weight IFS Attributes End here
            
                myMap1.put('GPFACE',GPFACE);
                myMap1.put('GPRSC1',String.valueOf(GPRSC1));
                myMap1.put('GPTYPE',GPTYPE);
                myMap1.put('GTAG01',GTAG01);
                myMap1.put('GTAG02',GTAG02);
                myMap1.put('GTAG04',GTAG04);
                myMap1.put('GTAG05',GTAG05);
                myMap1.put('GTAG06',GTAG06);
                myMap1.put('GTAG08',GTAG08);
                myMap1.put('GTAG10',GTAG10);
                myMap1.put('GTAG14',GTAG14);
                myMap1.put('GTAG15',GTAG15);
                myMap1.put('GTAG16',GTAG16);
                myMap1.put('GTAG17',GTAG17);
                myMap1.put('GTAG18',GTAG18);
                myMap1.put('GTAG19',GTAG19);
                myMap1.put('GTAG20',GTAG20);
                myMap1.put('GTAG21',GTAG21);
                myMap1.put('GTAG22',GTAG22);
                myMap1.put('GTAG23',GTAG23);
                myMap1.put('GTAGPN',GTAGPN);
                myMap1.put('GVRSC1',String.valueOf(GVRSC1));
                myMap1.put('HCLASS',HCLASS);
                myMap1.put('IGCEXAM',IGCEXAM);
                myMap1.put('IINO',IINO);
                myMap1.put('LDP',LDP);
                myMap1.put('MAGPARTEXAM',MAGPARTEXAM);
                myMap1.put('ManualBlowdown',ManualBlowdown);
                myMap1.put('MATLSOURCE',MATLSOURCE);
                myMap1.put('MCBODY',MCBODY);
                myMap1.put('MCCOTB',MCCOTB);
                myMap1.put('MCCOTP',MCCOTP);
                myMap1.put('MCDPHM',MCDPHM);
                myMap1.put('MCELMT',MCELMT);
                myMap1.put('MCFAST',MCFAST);
                myMap1.put('MCPALL',MCPALL);
                myMap1.put('MCPSGD',MCPSGD);
                myMap1.put('MCSEAT',MCSEAT);
                myMap1.put('MCSPRG',MCSPRG);
                myMap1.put('MCSTMJ',MCSTMJ);
                myMap1.put('MCVPAL',MCVPAL);
                myMap1.put('MCWGHT',MCWGHT);
                myMap1.put('NACE',NACE);
                myMap1.put('OA',OA);
                myMap1.put('OB',OB);
                myMap1.put('OW',OW);
                myMap1.put('PC',PC);
                myMap1.put('PED',PED);
                myMap1.put('PilotExhstPiped',PilotExhstPiped);
                myMap1.put('PilotSplyFilter',PilotSplyFilter);
                myMap1.put('PMI',PMI);
                myMap1.put('PosDomePresMax',String.valueOf(PosDomePresMax));
                myMap1.put('PosPilotLeakHigh',String.valueOf(PosPilotLeakHigh));
                myMap1.put('PosPilotLeakLow',String.valueOf(PosPilotLeakLow));
                myMap1.put('PosPilotSetMax',String.valueOf(PosPilotSetMax));
                myMap1.put('PosPilotSetMin',String.valueOf(PosPilotSetMin));
                myMap1.put('POSPROXSENSOR',POSPROXSENSOR);
                myMap1.put('PosSettingMax',String.valueOf(PosSettingMax));
                myMap1.put('PosSettingMin',String.valueOf(PosSettingMin));
                myMap1.put('PosStaticPresMax',String.valueOf(PosStaticPresMax));
                myMap1.put('PosStaticPresMin',String.valueOf(PosStaticPresMin));
                myMap1.put('PosValveLeakMax',String.valueOf(PosValveLeakMax));
                myMap1.put('PosValveLeakMin',String.valueOf(PosValveLeakMin));
                myMap1.put('PTC',PTC);
                myMap1.put('PRDLIN',PRDLIN);
                myMap1.put('RemoteSense',RemoteSense);
                myMap1.put('RGEUNT',RGEUNT);
                myMap1.put('RTPRS1',(RTPRS1).stripTrailingZeros().toPlainString());
                myMap1.put('RTPRSU',RTPRSU);
                myMap1.put('SHLTSTACTPSIG',SHLTSTACTPSIG);
                myMap1.put('SHLTSTACTPSIGMX',SHLTSTACTPSIGMX);
                myMap1.put('SHLTSTBDYPSIG',String.valueOf(SHLTSTBDYPSIG));
                myMap1.put('SHLTSTBDYPSIGMX',String.valueOf(SHLTSTBDYPSIGMX));
                myMap1.put('SHLTSTMETHBDY',SHLTSTMETHBDY);
                myMap1.put('SOURCINGOPT',SOURCINGOPT);
                myMap1.put('SZC',SZC);
                myMap1.put('USONICEXAM',USONICEXAM);
                myMap1.put('VacDomePresMax',String.valueOf(VacDomePresMax));
                myMap1.put('VacPilotLeakHigh',String.valueOf(VacPilotLeakHigh));
                myMap1.put('VacPilotLeakLow',String.valueOf(VacPilotLeakLow));
                myMap1.put('VacPilotSetMax',String.valueOf(VacPilotSetMax));
                myMap1.put('VacPilotSetMin',String.valueOf(VacPilotSetMin));
                myMap1.put('VACPROXSENSOR',VACPROXSENSOR);
                myMap1.put('VacSettingMax',String.valueOf(VacSettingMax));
                myMap1.put('VacSettingMin',String.valueOf(VacSettingMin));
                myMap1.put('VacStaticPresMax',String.valueOf(VacStaticPresMax));
                myMap1.put('VacStaticPresMin',String.valueOf(VacStaticPresMin));
                myMap1.put('VacValveLeakMax',String.valueOf(VacValveLeakMax));
                myMap1.put('VacValveLeakMin',String.valueOf(VacValveLeakMin));
                myMap1.put('VGEUNT',VGEUNT);
                myMap1.put('VISCASTEXAM',VISCASTEXAM);
                myMap1.put('VPRTOP',VPRTOP);
                myMap1.put('VTPRS1',(VTPRS1).stripTrailingZeros().toPlainString());
                myMap1.put('VTPRSU',VTPRSU);
                myMap1.put('XRAY',XRAY);
                system.debug('IFS Attribute result:' +myMap1);
                return myMap1;
    }

    public Map<string,string> getmapTroubleShootingRVAttr(){
        
            Map<String, string> myMap1 = new Map<String, String>(); 
        system.debug('IFS Attribute BodyMAWPpsig:' +BodyMAWPpsig);
                myMap1.put('ASSEMBLYWT',ASSEMBLYWT);
                myMap1.put('ASSEMBLYWTUOM',ASSEMBLYWTUOM);
                myMap1.put('AtmPresPSIA',String.valueOf(AtmPresPSIA));
                myMap1.put('ATTRTEMPLATE',ATTRTEMPLATE);
                myMap1.put('BodyDesign',BodyDesign);
                myMap1.put('BodyMAWPpsig',String.valueOf(BodyMAWPpsig));
                myMap1.put('COMPDESCRIPTION',COMPDESCRIPTION);
                myMap1.put('COMPINVSERTRK',COMPINVSERTRK);
                myMap1.put('COMPLOTTRACK',COMPLOTTRACK);
                myMap1.put('COMPPROVIDE',COMPPROVIDE);
                myMap1.put('COMPRESPONID',COMPRESPONID);
                myMap1.put('ConnectionOutlet',ConnectionOutlet);
                myMap1.put('CONSTBDYTST',CONSTBDYTST);
                myMap1.put('CUSTOMSTATNO',CUSTOMSTATNO);
                myMap1.put('EffMBP',String.valueOf(EffMBP));
                myMap1.put('EFFMOP',String.valueOf(EFFMOP));
            /*  myMap1.put('ERVEyeNutPartNum',ERVEyeNutPartNum);
                myMap1.put('ERVHWPartNum',ERVHWPartNum);
                myMap1.put('ERVModuleEyeNutWt',ERVModuleEyeNutWt);
                myMap1.put('ERVModuleHWWt',ERVModuleHWWt); */
                myMap1.put('FASubModel',FASubModel);
        //      myMap1.put('FBGRetPlatePartNum',FBGRetPlatePartNum);
        //      myMap1.put('FBGRetPlateWt',FBGRetPlateWt);
                myMap1.put('GMODELGPTYPE',GMODELGPTYPE);
                myMap1.put('GMODELOpt1',GMODELOpt1);
                myMap1.put('GMODELOpt2',GMODELOpt2);
                myMap1.put('GMODELOpt3',GMODELOpt3);
                myMap1.put('GMODELPTC',GMODELPTC);
                myMap1.put('HSNSACCODE',HSNSACCODE);
                myMap1.put('INHOUSEPAINT',INHOUSEPAINT);
                myMap1.put('LOTTRACKCODE',LOTTRACKCODE);
                myMap1.put('MaxProcPresPSIG',String.valueOf(MaxProcPresPSIG));
                myMap1.put('PARTCLASS',PARTCLASS);
                myMap1.put('PARTUOM',PARTUOM);
                myMap1.put('PLANNER',PLANNER);
                myMap1.put('PNMCDPHM',PNMCDPHM);
                myMap1.put('PNMCPALL',PNMCPALL);
                myMap1.put('PNMODEL',PNMODEL);
        /*      myMap1.put('PosBackPresPSIG',String.valueOf(PosBackPresPSIG));
                myMap1.put('PosBackupDiaphThk',PosBackupDiaphThk);
                myMap1.put('PosBackupDiaphWt',PosBackupDiaphWt);
                myMap1.put('PosCavityDiameter1',PosCavityDiameter1);
                myMap1.put('PosCavityDiameter2',PosCavityDiameter2);
                myMap1.put('PosCavityHeight1',PosCavityHeight1);
                myMap1.put('PosCavityHeight2',PosCavityHeight2);  */
                myMap1.put('PosCritical',String.valueOf(PosCritical));
        /*      myMap1.put('PosDiaAllow_1',PosDiaAllow_1);
                myMap1.put('PosDiaAllow_2',PosDiaAllow_2);
                myMap1.put('PosDiaAllow_3',PosDiaAllow_3);
                myMap1.put('PosDiaAllow_4',PosDiaAllow_4);
                myMap1.put('PosDiaAllow_5',PosDiaAllow_5);
                myMap1.put('PosDiaAllow_6',PosDiaAllow_6);
                myMap1.put('PosDiaAllow_7',PosDiaAllow_7);
                myMap1.put('PosDiaMin_1',PosDiaMin_1);
                myMap1.put('PosDiaMin_2',PosDiaMin_2);
                myMap1.put('PosDiaMin_3',PosDiaMin_3);
                myMap1.put('PosDiaMin_4',PosDiaMin_4);
                myMap1.put('PosDiaMin_5',PosDiaMin_5);
                myMap1.put('PosDiaMin_6',PosDiaMin_6);
                myMap1.put('PosDiaMin_7',PosDiaMin_7);
                myMap1.put('PosDiaphragmThk',PosDiaphragmThk);
                myMap1.put('PosDiaphragmWt',PosDiaphragmWt);    */
                myMap1.put('PosDomePresMaxFact',String.valueOf(PosDomePresMaxFact));
                
            //  myMap1.put('PosEffSealingDiameter',PosEffSealingDiameter);
            //  myMap1.put('PosFiberglassWtNeedStr',PosFiberglassWtNeedStr);
                myMap1.put('PosFlowPresPSIG',String.valueOf(PosFlowPresPSIG));
                myMap1.put('POSFLOWRATESCFH',String.valueOf(POSFLOWRATESCFH));
        /*      myMap1.put('PosHt_1',PosHt_1);
                myMap1.put('PosHt_2',PosHt_2);
                myMap1.put('PosHt_3',PosHt_3);
                myMap1.put('PosHt_4',PosHt_4);
                myMap1.put('PosHt_5',PosHt_5);
                myMap1.put('PosHt_6',PosHt_6);
                myMap1.put('PosHt_7',PosHt_7);
                myMap1.put('PosHtAvail_1',PosHtAvail_1);
                myMap1.put('PosHtAvail_2',PosHtAvail_2);
                myMap1.put('PosHtAvail_3',PosHtAvail_3);
                myMap1.put('PosHtAvail_4',PosHtAvail_4);
                myMap1.put('PosHtAvail_5',PosHtAvail_5);
                myMap1.put('PosHtAvail_6',PosHtAvail_6);
                myMap1.put('PosHtAvail_7',PosHtAvail_7);  */
                myMap1.put('PosIntMethod',PosIntMethod);
                myMap1.put('PosKdHigh',String.valueOf(PosKdHigh));
                myMap1.put('PosKdLow',String.valueOf(PosKdLow));
                myMap1.put('PosLoad',PosLoad);
                myMap1.put('PosP1',String.valueOf(PosP1));
                myMap1.put('PosP2',String.valueOf(PosP2));
                myMap1.put('PosPalletDesign',PosPalletDesign);
                
        /*      myMap1.put('PosPalletPartNum',PosPalletPartNum);
                myMap1.put('PosPalletThk',PosPalletThk);
                myMap1.put('PosPalletWt',PosPalletWt);  */
                myMap1.put('PosPilotLeakHighFact',String.valueOf(PosPilotLeakHighFact));
                myMap1.put('PosPilotLeakLowFact',String.valueOf(PosPilotLeakLowFact));
                myMap1.put('PosPilotSetMaxFact',String.valueOf(PosPilotSetMaxFact));
                myMap1.put('PosPilotSetMax',String.valueOf(PosPilotSetMax));
                myMap1.put('PosPilotSetMinFact',String.valueOf(PosPilotSetMinFact));
                myMap1.put('PosPilotSetMin',String.valueOf(PosPilotSetMin));
                myMap1.put('PosSettingMin',String.valueOf(PosSettingMin));
                myMap1.put('PosPresRatioHigh',String.valueOf(PosPresRatioHigh));
                myMap1.put('PosPresRatioLow',String.valueOf(PosPresRatioLow));
                myMap1.put('PosSetPresOSIG',String.valueOf(PosSetPresOSIG));
                myMap1.put('PosSetPresPSIG',String.valueOf(PosSetPresPSIG));
                myMap1.put('PosSettingMaxFact',String.valueOf(PosSettingMaxFact));
                myMap1.put('PosSettingMaxFact',String.valueOf(PosSettingMaxFact));
                myMap1.put('PosSettingMax',String.valueOf(PosSettingMax));
                myMap1.put('PosSpacer',PosSpacer);
                myMap1.put('PosStaticPresMaxFact',String.valueOf(PosStaticPresMaxFact));
                myMap1.put('PosStaticPresMinFact',String.valueOf(PosStaticPresMinFact));
        //      myMap1.put('PosStemDiameter',PosStemDiameter);
                myMap1.put('PosTempDEGR',String.valueOf(PosTempDEGR));
        //      myMap1.put('PosTotWtNeed',PosTotWtNeed);
                myMap1.put('PosValveLeakMaxFact',String.valueOf(PosValveLeakMaxFact));
                myMap1.put('PosValveLeakMax',String.valueOf(PosValveLeakMax));
                myMap1.put('PosValveLeakMinFact',String.valueOf(PosValveLeakMinFact));
                myMap1.put('PosValveLeakMin',String.valueOf(PosValveLeakMin));
        /*      myMap1.put('PosWt_1',PosWt_1);
                myMap1.put('PosWt_2',PosWt_2);
                myMap1.put('PosWt_3',PosWt_3);
                myMap1.put('PosWt_4',PosWt_4);
                myMap1.put('PosWt_5',PosWt_5);
                myMap1.put('PosWt_6',PosWt_6);
                myMap1.put('PosWt_7',PosWt_7);
                myMap1.put('PosWtNeed_1',PosWtNeed_1);
                myMap1.put('PosWtNeed_2',PosWtNeed_2);
                myMap1.put('PosWtNeed_3',PosWtNeed_3);
                myMap1.put('PosWtNeed_4',PosWtNeed_4);
                myMap1.put('PosWtNeed_5',PosWtNeed_5);
                myMap1.put('PosWtNeed_6',PosWtNeed_6);
                myMap1.put('PosWtNeed_7',PosWtNeed_7);
                myMap1.put('PosWtPalletFiberglassPartNo',PosWtPalletFiberglassPartNo);  */
                myMap1.put('PROVIDE',PROVIDE);              
                myMap1.put('RESPONSIBLE_ID',RESPONSIBLE_ID);
                myMap1.put('SALESGROUP',SALESGROUP);
                myMap1.put('SALESPRICEGROUP',SALESPRICEGROUP);
                myMap1.put('SERIALTRACKCODE',SERIALTRACKCODE);
                myMap1.put('StdPosAirFlowSCFH',String.valueOf(StdPosAirFlowSCFH));
                myMap1.put('StdPosEffDia',String.valueOf(StdPosEffDia));
                myMap1.put('StdPosFullOP',String.valueOf(StdPosFullOP));
                myMap1.put('StdPosKd',String.valueOf(StdPosKd));
                myMap1.put('StdPosPresRatio',String.valueOf(StdPosPresRatio));
                myMap1.put('StdVacAirFlowSCFH',String.valueOf(StdVacAirFlowSCFH));
                myMap1.put('StdVacEffDia',String.valueOf(StdVacEffDia));
                myMap1.put('StdVacFullOP',String.valueOf(StdVacFullOP));
                myMap1.put('StdVacKd',String.valueOf(StdVacKd));
                myMap1.put('StdVacPresRatio',String.valueOf(StdVacPresRatio));
                myMap1.put('UOMSystem',UOMSystem);
        /*      myMap1.put('VacBackupDiaphThk',VacBackupDiaphThk);
                myMap1.put('VacBackupDiaphWt',VacBackupDiaphWt);
                myMap1.put('VacCavityDiameter1',VacCavityDiameter1);
                myMap1.put('VacCavityDiameter2',VacCavityDiameter2);
                myMap1.put('VacCavityHeight1',VacCavityHeight1);
                myMap1.put('VacCavityHeight2',VacCavityHeight2);    */
                myMap1.put('VacCritical',String.valueOf(VacCritical));
        /*      myMap1.put('VacDiaAllow_1',VacDiaAllow_1);
                myMap1.put('VacDiaAllow_2',VacDiaAllow_2);
                myMap1.put('VacDiaAllow_3',VacDiaAllow_3);
                myMap1.put('VacDiaAllow_4',VacDiaAllow_4);
                myMap1.put('VacDiaAllow_5',VacDiaAllow_5);
                myMap1.put('VacDiaAllow_6',VacDiaAllow_6);
                myMap1.put('VacDiaAllow_7',VacDiaAllow_7);
                myMap1.put('VacDiaMin_1',VacDiaMin_1);
                myMap1.put('VacDiaMin_2',VacDiaMin_2);
                myMap1.put('VacDiaMin_3',VacDiaMin_3);
                myMap1.put('VacDiaMin_4',VacDiaMin_4);
                myMap1.put('VacDiaMin_5',VacDiaMin_5);
                myMap1.put('VacDiaMin_6',VacDiaMin_6);
                myMap1.put('VacDiaMin_7',VacDiaMin_7);
                myMap1.put('VacDiaphragmThk',VacDiaphragmThk);
                myMap1.put('VacDiaphragmWt',VacDiaphragmWt);    */
                myMap1.put('VacDomePresMaxFact',String.valueOf(VacDomePresMaxFact));
                myMap1.put('VacDomePresMax',String.valueOf(VacDomePresMax));
        //      myMap1.put('VacEffSealingDiameter',VacEffSealingDiameter);
        //      myMap1.put('VacFiberglassWtNeedStr',VacFiberglassWtNeedStr);
                myMap1.put('VacFlowPresPSIG',String.valueOf(VacFlowPresPSIG));
                myMap1.put('VacFlowRateSCFH',String.valueOf(VacFlowRateSCFH));
        /*      myMap1.put('VacHt_1',VacHt_1);
                myMap1.put('VacHt_2',VacHt_2);
                myMap1.put('VacHt_3',VacHt_3);
                myMap1.put('VacHt_4',VacHt_4);
                myMap1.put('VacHt_5',VacHt_5);
                myMap1.put('VacHt_6',VacHt_6);
                myMap1.put('VacHt_7',VacHt_7);
                myMap1.put('VacHtAvail_1',VacHtAvail_1);
                myMap1.put('VacHtAvail_2',VacHtAvail_2);
                myMap1.put('VacHtAvail_3',VacHtAvail_3);
                myMap1.put('VacHtAvail_4',VacHtAvail_4);
                myMap1.put('VacHtAvail_5',VacHtAvail_5);
                myMap1.put('VacHtAvail_6',VacHtAvail_6);
                myMap1.put('VacHtAvail_7',VacHtAvail_7);    */
                myMap1.put('VacIntMethod',VacIntMethod);
                myMap1.put('VacKdHigh',String.valueOf(VacKdHigh));
                myMap1.put('VacKdLow',String.valueOf(VacKdLow));
                myMap1.put('VacLoad',VacLoad);
                myMap1.put('VacP1',String.valueOf(VacP1));
                myMap1.put('VacP2',String.valueOf(VacP2));
                myMap1.put('VacPalletDesign',VacPalletDesign);
                myMap1.put('VacPalletMAWPpsig',String.valueOf(VacPalletMAWPpsig));
        /*      myMap1.put('VacPalletPartNum',VacPalletPartNum);
                myMap1.put('VacPalletThk',VacPalletThk);
                myMap1.put('VacPalletWt',VacPalletWt);  */
                myMap1.put('VacPilotLeakHighFact',String.valueOf(VacPilotLeakHighFact));
                myMap1.put('VacPilotLeakLowFact',String.valueOf(VacPilotLeakLowFact));
                myMap1.put('VacPilotSetMaxFact',String.valueOf(VacPilotSetMaxFact));
                myMap1.put('VacPilotSetMax',String.valueOf(VacPilotSetMax));
                myMap1.put('VacPilotSetMinFact',String.valueOf(VacPilotSetMinFact));
                myMap1.put('VacPresRatioHigh',String.valueOf(VacPresRatioHigh));
                myMap1.put('VacPresRatioLow',String.valueOf(VacPresRatioLow));
                myMap1.put('VacSetPresOSIG',String.valueOf(VacSetPresOSIG));
                myMap1.put('VacSetPresPSIG',String.valueOf(VacSetPresPSIG));
                myMap1.put('VacSettingMaxFact',String.valueOf(VacSettingMaxFact));
                myMap1.put('VacSettingMax',String.valueOf(VacSettingMax));
                myMap1.put('VacSettingMinFact',String.valueOf(VacSettingMinFact));
                myMap1.put('VacSpacer',VacSpacer);
                myMap1.put('VacStaticPresMaxFact',String.valueOf(VacStaticPresMaxFact));
                myMap1.put('VacStaticPresMinFact',String.valueOf(VacStaticPresMinFact));
            //  myMap1.put('VacStemDiameter',VacStemDiameter);
                myMap1.put('VacTempDEGR',String.valueOf(VacTempDEGR));
            //  myMap1.put('VacTotWtNeed',VacTotWtNeed);
                myMap1.put('VacValveLeakMaxFact',String.valueOf(VacValveLeakMaxFact));
                myMap1.put('VacValveLeakMinFact',String.valueOf(VacValveLeakMinFact));
            /*  myMap1.put('VacWt_1',VacWt_1);
                myMap1.put('VacWt_2',VacWt_2);
                myMap1.put('VacWt_3',VacWt_3);
                myMap1.put('VacWt_4',VacWt_4);
                myMap1.put('VacWt_5',VacWt_5);
                myMap1.put('VacWt_6',VacWt_6);
                myMap1.put('VacWt_7',VacWt_7);
                myMap1.put('VacWtNeed_1',VacWtNeed_1);
                myMap1.put('VacWtNeed_2',VacWtNeed_2);
                myMap1.put('VacWtNeed_3',VacWtNeed_3);
                myMap1.put('VacWtNeed_4',VacWtNeed_4);
                myMap1.put('VacWtNeed_5',VacWtNeed_5);
                myMap1.put('VacWtNeed_6',VacWtNeed_6);
                myMap1.put('VacWtNeed_7',VacWtNeed_7);
                myMap1.put('VacWtPalletFiberglassPartNo',String.valueOf(VacWtPalletFiberglassPartNo));  */
                myMap1.put('ValveMAWPPSIG',String.valueOf(ValveMAWPPSIG));
                myMap1.put('ValveSubModel',ValveSubModel);
                myMap1.put('VENDORPAINT',VENDORPAINT);
                myMap1.put('WtPosPalletFiberglassMatlCode',WtPosPalletFiberglassMatlCode);
                myMap1.put('WtVacPalletFiberglassMatlCode',WtVacPalletFiberglassMatlCode);
                myMap1.put('WtPalletFiberglassPressureDesign',WtPalletFiberglassPressureDesign);
                myMap1.put('WtPosPalletFiberglassType',WtPosPalletFiberglassType);
                myMap1.put('WtVacPalletFiberglassType',WtVacPalletFiberglassType);
                myMap1.put('WtPalletFiberglassVacuumDesign',WtPalletFiberglassVacuumDesign);
                myMap1.put('FBGModel', FBGModel); //Service Ticket #200844
        
            //Weight Attributes for Troubleshooting start here
                myMap1.put('ERVEyeNutPartNum',mapWeight.get('ERVEyeNutPartNum'));
                myMap1.put('ERVHWPartNum',mapWeight.get('ERVHWPartNum'));
                myMap1.put('ERVModuleEyeNutWt',mapWeight.get('ERVModuleEyeNutWt'));
                myMap1.put('ERVModuleHWWt',mapWeight.get('ERVModuleHWWt'));
                myMap1.put('FBGRetPlatePartNum',mapWeight.get('FBGRetPlatePartNum'));
                myMap1.put('FBGRetPlateWt',mapWeight.get('FBGRetPlateWt'));
                myMap1.put('PosBackupDiaphThk',mapWeight.get('PosBackupDiaphThk'));
                myMap1.put('PosBackupDiaphWt',mapWeight.get('PosBackupDiaphWt'));
                myMap1.put('PosCavityDiameter1',mapWeight.get('PosCavityDiameter1'));
                myMap1.put('PosCavityDiameter2',mapWeight.get('PosCavityDiameter2'));
                myMap1.put('PosCavityHeight1',mapWeight.get('PosCavityHeight1'));
                myMap1.put('PosCavityHeight2',mapWeight.get('PosCavityHeight2'));
                myMap1.put('PosDiaAllow_1',mapWeight.get('PosDiaAllow_1'));
                myMap1.put('PosDiaAllow_2',mapWeight.get('PosDiaAllow_2'));
                myMap1.put('PosDiaAllow_3',mapWeight.get('PosDiaAllow_3'));
                myMap1.put('PosDiaAllow_4',mapWeight.get('PosDiaAllow_4'));
                myMap1.put('PosDiaAllow_5',mapWeight.get('PosDiaAllow_5'));
                myMap1.put('PosDiaAllow_6',mapWeight.get('PosDiaAllow_6'));
                myMap1.put('PosDiaAllow_7',mapWeight.get('PosDiaAllow_7'));
                myMap1.put('PosDiaMin_1',mapWeight.get('PosDiaMin_1'));
                myMap1.put('PosDiaMin_2',mapWeight.get('PosDiaMin_2'));
                myMap1.put('PosDiaMin_3',mapWeight.get('PosDiaMin_3'));
                myMap1.put('PosDiaMin_4',mapWeight.get('PosDiaMin_4'));
                myMap1.put('PosDiaMin_5',mapWeight.get('PosDiaMin_5'));
                myMap1.put('PosDiaMin_6',mapWeight.get('PosDiaMin_6'));
                myMap1.put('PosDiaMin_7',mapWeight.get('PosDiaMin_7'));
                myMap1.put('PosDiaphragmThk',mapWeight.get('PosDiaphragmThk'));
                myMap1.put('PosDiaphragmWt',mapWeight.get('PosDiaphragmWt'));
                myMap1.put('PosEffSealingDiameter',mapWeight.get('PosEffSealingDiameter'));
                myMap1.put('PosFiberglassWtNeedStr',mapWeight.get('PosFiberglassWtNeedStr'));
                myMap1.put('PosHt_1',mapWeight.get('PosHt_1'));
                myMap1.put('PosHt_2',mapWeight.get('PosHt_2'));
                myMap1.put('PosHt_3',mapWeight.get('PosHt_3'));
                myMap1.put('PosHt_4',mapWeight.get('PosHt_4'));
                myMap1.put('PosHt_5',mapWeight.get('PosHt_5'));
                myMap1.put('PosHt_6',mapWeight.get('PosHt_6'));
                myMap1.put('PosHt_7',mapWeight.get('PosHt_7'));
                myMap1.put('PosHtAvail_1',mapWeight.get('PosHtAvail_1'));
                myMap1.put('PosHtAvail_2',mapWeight.get('PosHtAvail_2'));
                myMap1.put('PosHtAvail_3',mapWeight.get('PosHtAvail_3'));
                myMap1.put('PosHtAvail_4',mapWeight.get('PosHtAvail_4'));
                myMap1.put('PosHtAvail_5',mapWeight.get('PosHtAvail_5'));
                myMap1.put('PosHtAvail_6',mapWeight.get('PosHtAvail_6'));
                myMap1.put('PosHtAvail_7',mapWeight.get('PosHtAvail_7'));
                myMap1.put('PosPalletPartNum',mapWeight.get('PosPalletPartNum'));
                myMap1.put('PosPalletThk',mapWeight.get('PosPalletThk'));
                myMap1.put('PosPalletWt',mapWeight.get('PosPalletWt'));
                myMap1.put('PosStemDiameter',mapWeight.get('PosStemDiameter'));
                myMap1.put('PosTotWtNeed',mapWeight.get('PosTotWtNeed'));
                myMap1.put('PosWt_1',mapWeight.get('PosWt_1'));
                myMap1.put('PosWt_2',mapWeight.get('PosWt_2'));
                myMap1.put('PosWt_3',mapWeight.get('PosWt_3'));
                myMap1.put('PosWt_4',mapWeight.get('PosWt_4'));
                myMap1.put('PosWt_5',mapWeight.get('PosWt_5'));
                myMap1.put('PosWt_6',mapWeight.get('PosWt_6'));
                myMap1.put('PosWt_7',mapWeight.get('PosWt_7'));
                myMap1.put('PosWtNeed_1',mapWeight.get('PosWtNeed_1'));
                myMap1.put('PosWtNeed_2',mapWeight.get('PosWtNeed_2'));
                myMap1.put('PosWtNeed_3',mapWeight.get('PosWtNeed_3'));
                myMap1.put('PosWtNeed_4',mapWeight.get('PosWtNeed_4'));
                myMap1.put('PosWtNeed_5',mapWeight.get('PosWtNeed_5'));
                myMap1.put('PosWtNeed_6',mapWeight.get('PosWtNeed_6'));
                myMap1.put('PosWtNeed_7',mapWeight.get('PosWtNeed_7'));
                myMap1.put('PosWtPalletFiberglassPartNo',mapWeight.get('PosWtPalletFiberglassPartNo'));
                myMap1.put('VacBackupDiaphThk',mapWeight.get('VacBackupDiaphThk'));
                myMap1.put('VacBackupDiaphWt',mapWeight.get('VacBackupDiaphWt'));
                myMap1.put('VacCavityDiameter1',mapWeight.get('VacCavityDiameter1'));
                myMap1.put('VacCavityDiameter2',mapWeight.get('VacCavityDiameter2'));
                myMap1.put('VacCavityHeight1',mapWeight.get('VacCavityHeight1'));
                myMap1.put('VacCavityHeight2',mapWeight.get('VacCavityHeight2'));
                myMap1.put('VacDiaAllow_1',mapWeight.get('VacDiaAllow_1'));
                myMap1.put('VacDiaAllow_2',mapWeight.get('VacDiaAllow_2'));
                myMap1.put('VacDiaAllow_3',mapWeight.get('VacDiaAllow_3'));
                myMap1.put('VacDiaAllow_4',mapWeight.get('VacDiaAllow_4'));
                myMap1.put('VacDiaAllow_5',mapWeight.get('VacDiaAllow_5'));
                myMap1.put('VacDiaAllow_6',mapWeight.get('VacDiaAllow_6'));
                myMap1.put('VacDiaAllow_7',mapWeight.get('VacDiaAllow_7'));
                myMap1.put('VacDiaMin_1',mapWeight.get('VacDiaMin_1'));
                myMap1.put('VacDiaMin_2',mapWeight.get('VacDiaMin_2'));
                myMap1.put('VacDiaMin_3',mapWeight.get('VacDiaMin_3'));
                myMap1.put('VacDiaMin_4',mapWeight.get('VacDiaMin_4'));
                myMap1.put('VacDiaMin_5',mapWeight.get('VacDiaMin_5'));
                myMap1.put('VacDiaMin_6',mapWeight.get('VacDiaMin_6'));
                myMap1.put('VacDiaMin_7',mapWeight.get('VacDiaMin_7'));
                myMap1.put('VacDiaphragmThk',mapWeight.get('VacDiaphragmThk'));
                myMap1.put('VacDiaphragmWt',mapWeight.get('VacDiaphragmWt'));
                myMap1.put('VacEffSealingDiameter',mapWeight.get('VacEffSealingDiameter'));
                myMap1.put('VacFiberglassWtNeedStr',mapWeight.get('VacFiberglassWtNeedStr'));
                myMap1.put('VacHt_1',mapWeight.get('VacHt_1'));
                myMap1.put('VacHt_2',mapWeight.get('VacHt_2'));
                myMap1.put('VacHt_3',mapWeight.get('VacHt_3'));
                myMap1.put('VacHt_4',mapWeight.get('VacHt_4'));
                myMap1.put('VacHt_5',mapWeight.get('VacHt_5'));
                myMap1.put('VacHt_6',mapWeight.get('VacHt_6'));
                myMap1.put('VacHt_7',mapWeight.get('VacHt_7'));
                myMap1.put('VacHtAvail_1',mapWeight.get('VacHtAvail_1'));
                myMap1.put('VacHtAvail_2',mapWeight.get('VacHtAvail_2'));
                myMap1.put('VacHtAvail_3',mapWeight.get('VacHtAvail_3'));
                myMap1.put('VacHtAvail_4',mapWeight.get('VacHtAvail_4'));
                myMap1.put('VacHtAvail_5',mapWeight.get('VacHtAvail_5'));
                myMap1.put('VacHtAvail_6',mapWeight.get('VacHtAvail_6'));
                myMap1.put('VacHtAvail_7',mapWeight.get('VacHtAvail_7'));
                myMap1.put('VacPalletPartNum',mapWeight.get('VacPalletPartNum'));
                myMap1.put('VacPalletThk',mapWeight.get('VacPalletThk'));
                myMap1.put('VacPalletWt',mapWeight.get('VacPalletWt'));
                myMap1.put('VacStemDiameter',mapWeight.get('VacStemDiameter'));
                myMap1.put('VacTotWtNeed',mapWeight.get('VacTotWtNeed'));
                myMap1.put('VacWt_1',mapWeight.get('VacWt_1'));
                myMap1.put('VacWt_2',mapWeight.get('VacWt_2'));
                myMap1.put('VacWt_3',mapWeight.get('VacWt_3'));
                myMap1.put('VacWt_4',mapWeight.get('VacWt_4'));
                myMap1.put('VacWt_5',mapWeight.get('VacWt_5'));
                myMap1.put('VacWt_6',mapWeight.get('VacWt_6'));
                myMap1.put('VacWt_7',mapWeight.get('VacWt_7'));
                myMap1.put('VacWtNeed_1',mapWeight.get('VacWtNeed_1'));
                myMap1.put('VacWtNeed_2',mapWeight.get('VacWtNeed_2'));
                myMap1.put('VacWtNeed_3',mapWeight.get('VacWtNeed_3'));
                myMap1.put('VacWtNeed_4',mapWeight.get('VacWtNeed_4'));
                myMap1.put('VacWtNeed_5',mapWeight.get('VacWtNeed_5'));
                myMap1.put('VacWtNeed_6',mapWeight.get('VacWtNeed_6'));
                myMap1.put('VacWtNeed_7',mapWeight.get('VacWtNeed_7'));
                myMap1.put('VacWtPalletFiberglassPartNo',mapWeight.get('VacWtPalletFiberglassPartNo'));
        system.debug('IFS Attribute BodyMAWPpsig:' +BodyMAWPpsig);
        		system.debug('IFS Attribute result:' +myMap1);
            //Weight Attributes for TroubleShooting End here

            return myMap1;
    }
    
    //Reordr Attributes
     public Boolean PEDreorder {
        get {
            return currentRV.PED_2014_68_EU_CE_mark__c;
        }
        set {
            this.PEDreorder = value;
        }
    }    
    public Boolean ATEXreorder {
        get {
            return currentRV.Atex_Certificate__c;
        }
        set {
            this.ATEXreorder = value;
        }
    }
    
    public Boolean CUTRreorder {
        get {
            return currentRV.CU_TR__c;
        }
        set {
            this.CUTRreorder = value;
        }
    }   
    
    public Boolean NACEreorder {
        get {
            return currentRV.NACE__c;
        }
        set {
            this.NACEreorder = value;
        }
    }  
    
public Boolean POSPROXSENSORreorder {
        get{
              return currentRV.Pressure_Port_Proximity_Sensor__c;
        }
        set{
            this.POSPROXSENSORreorder=value;
        }
    }
    //VACPROXSENSOR
    public Boolean VACPROXSENSORreorder {
        get{
              return currentRV.Vacuum_Port_Proximity_Sensor__c;
        }
        set{
            this.VACPROXSENSORreorder=value;
        }
    }

    //manualBlowdown
    public Boolean manualBlowdownreorder {
        get{
              return currentRV.Manual_Blowdown__c;
        }
        set{
            this.manualBlowdownreorder=value;
        }
    }
    //remoteSense
    public Boolean remoteSensereorder {
        get{
              return currentRV.Remote_Sense__c;
        }
        set{
            this.remoteSensereorder=value;
        }
    }    
    //pilotExhstPiped
    public Boolean pilotExhstPipedreorder {
        get{
              return currentRV.Pilot_Exhaust_Piped_to_Discharge_Header__c;
        }
        set{
            this.pilotExhstPipedreorder=value;
        }
    }
    //fieldTestConnect
     public Boolean fieldTestConnectreorder {
        get{
              return currentRV.Field_Test_Connection__c;
        }
        set{
            this.fieldTestConnectreorder=value;
        }
    } 
    //pilotSplyFilter
    public Boolean pilotSplyFilterreorder {
        get{
              return currentRV.Pilot_Supply_Filter__c;
        }
        set{
            this.pilotSplyFilterreorder=value;
        }
    }
    
    
    public Boolean GMTH21reorder {
        get {
            return currentRV.Method21_Leak_Detection__c;
       
        }
        set {            
            this.GMTH21reorder = value;
        }
    }    
   
    public Boolean FWLDPreorder {
        get {
         return currentRV.Fillet_Weld_Liquid_Dye_Penetrant__c;
        
        }
        set {
            
            this.FWLDPreorder = value;
        }
    }

    public Boolean USONICEXAMreorder {
        get {
           return currentRV.Ultrasonic_Examination__c;
         
        }
        set {
           
            this.USONICEXAMreorder = value;
        }
    }
    public Boolean MAGPARTEXAMreorder {
        get {
          return currentRV.Magnetic_Particle_Examination__c;
          
        }
        set {
            
            this.MAGPARTEXAMreorder = value;
        }
    }    
    public Boolean BRINHARDEXAMreorder {
        get {
           return currentRV.Brinell_hardness_examination__c;
         
        }
        set {
            
            this.BRINHARDEXAMreorder = value;
        }
    }
    
    //CHARPYIMPEXAM
    public Boolean CHARPYIMPEXAMreorder {
        get {
          return currentRV.Charpy_Impact_Testing__c;
         
        }
        set {
            this.CHARPYIMPEXAMreorder = value;
        }
    }
    
    public Boolean VISCASTEXAMreorder {
        get {
           return currentRV.Visual_Casting_Examination__c;
         
        }
        set {
            
            this.VISCASTEXAMreorder = value;
        }
    }
    
    //IGCEXAM
    public Boolean IGCEXAMreorder {
        get {
          return currentRV.Intergranular_Corossion_Test__c;
         
        }
        set {
            this.IGCEXAMreorder = value;
        }
    }
      

    public string MSZC {
    get {
            return currentRV.Size_Preference__c;
        }
    set {
            this.MSZC = value;
        }
    }
    
    public decimal conMaxProcPress{ 
    get {
            if(currentRV.Converted_Max_Process_Pressure__c!=null)
                return currentRV.Converted_Max_Process_Pressure__c;
            else
                return 0.0;
        }
    set {
            this.conMaxProcPress= value;
        }
    }

public decimal conBackPress{ 
    get {
            if(currentRV.Converted_Back_Pressure__c!=null)
                return currentRV.Converted_Back_Pressure__c;
            else
                return 0.0;
        }
    set {
            this.conBackPress= value;
        }
    }
    
public decimal conPressSet{ 
    get {
            if(currentRV.Converted_Pressure_Setting__c!=null)
                return currentRV.Converted_Pressure_Setting__c;
            else
                return 0.0;
        }
    set {
            this.conPressSet= value;
        }
    }
    
public decimal conVacSet{ 
    get {
            if(currentRV.Converted_Vacuum_Setting__c!=null)
                return currentRV.Converted_Vacuum_Setting__c;
            else
                return 0.0;
        }
    set {
            this.conVacSet= value;
        }
    }
    
public decimal conRelPressVal{ 
    get {
            if(currentRV.Converted_Relieving_Pressure_Value__c!=null)
                return currentRV.Converted_Relieving_Pressure_Value__c;
            else
                return 0.0;
        }
    set {
            this.conRelPressVal= value;
        }
    }
    
public decimal conAtmPress{ 
    get {
            if(currentRV.Converted_Atmospheric_Pressure__c!=null)
                return currentRV.Converted_Atmospheric_Pressure__c;
            else
                return 0.0;
        }
    set {
            this.conAtmPress= value;
        }
    }
    
public decimal conRelVacVal{ 
    get {
            if(currentRV.V_Converted_Relieving_Vacuum_Value__c!=null)
                return currentRV.V_Converted_Relieving_Vacuum_Value__c;
            else
                return 0.0;
        }
    set {
            this.conRelVacVal= value;
        }
    }
    
public decimal conPressRelReqFlow{ 
    get {
            if(currentRV.Converted_Pressure_Relief_Req_Flow__c!=null)
                return currentRV.Converted_Pressure_Relief_Req_Flow__c;
            else
                return 0.0;
        }
    set {
            this.conPressRelReqFlow= value;
        }
    }
    
public decimal conconVacRelReqFlow{ 
    get {
            if(currentRV.Converted_Vacuum_Relief_Req_Flow__c!=null)
                return currentRV.Converted_Vacuum_Relief_Req_Flow__c;
            else
                return 0.0;
        }
    set {
            this.conconVacRelReqFlow= value;
        }
    }
    
public decimal conVacRelTemp{ 
    get {
            if(currentRV.V_Converted_Vacuum_Relieving_Temperature__c!=null)
                return currentRV.V_Converted_Vacuum_Relieving_Temperature__c;
            else
                return 0.0;
        }
    set {
            this.conVacRelTemp= value;
        }
    }
    
public decimal conPressRelTemp{ 
    get {
            if(currentRV.Converted_Pressure_Relieving_Temperature__c!=null)
                return currentRV.Converted_Pressure_Relieving_Temperature__c;
            else
                return 0.0;
        }
    set {
            this.conPressRelTemp= value;
        }
    }
    
    /*
   // RV outputs for Lead Time 
   public Result getLeadTime() {
        Result LDTResult=new result();
        if(Schedule != null && QTY != null)
        {
            List<String> selectCols=new List<String>{'CDC__c','GCI__c','GP__c'};
            String strSchedule='\''+Schedule+'\'';
            String strQTY=''+QTY+'';
            List<String> whereCols=new List<String>{'Schedule__c','QtyLL__c','QtyUL__c'};
            List<String> whereVals=new List<String>{strSchedule,strQTY,strQTY};
            List<String> whereComps=new List<String>{'=','<=','>='};
            List<String> extraChars=new List<String>{'','',''};  
            LDTResult=wizardBaseDataProcessor.getProdOutputDescData('RV_LeadTime_Global_Leadtime__c',selectCols,whereCols,whereVals,whereComps,extraChars);
            if(LDTResult.bResult)
            { 
                system.debug('Lead Time list' +LDTResult.objResultList );
                
            } 
        }
        return LDTResult;
    }  
    
    
    // RV outputs for Working Guidelines  
    public List<Relief_Valve_Guideline__c> getRVGuildeline() {
        Result rvGuideline = new Result();
        List<Relief_Valve_Guideline__c> lstGl = [SELECT Id, PED_2014_68_EU_CE_mark__c, Atex_Certificate__c, 
                                                 CU_TR__c, NACE__c, XRAY__c, Fillet_Weld_Liquid_Dye_Penetrant__c, 
                                                 Positive_Material_Identification__c, Liquid_Dye_Penetrant__c, 
                                                 Ultrasonic_Examination__c, Magnetic_Particle_Examination__c, 
                                                 Brinell_hardness_examination__c, Visual_Casting_Examination__c, 
                                                 Method21_Leak_Detection__c, Painting_Coating_Option__c, 
                                                 Guideline_Sequence__c, Operation_Number__c, Guideline_Description__c, 
                                                 Guideline_Text__c, Guideline_Type__c, Sign_Off__c, 
                                                 Inspection_Sign_Off_Required__c FROM Relief_Valve_Guideline__c
                                                 where PED_2014_68_EU_CE_mark__c=:PED  OR Atex_Certificate__c=:ATEX OR  
                                                 CU_TR__c=:CUTR OR  NACE__c=:NACE OR XRAY__c=:XRAY OR 
                                                 Fillet_Weld_Liquid_Dye_Penetrant__c =:FWLDP OR
                                                 Positive_Material_Identification__c =:PMI OR 
                                                 Liquid_Dye_Penetrant__c =:LDP OR Ultrasonic_Examination__c=:USONICEXAM OR 
                                                 Magnetic_Particle_Examination__c=:MAGPARTEXAM OR Brinell_hardness_examination__c =:BRINHARDEXAM OR  
                                                 Visual_Casting_Examination__c =:VISCASTEXAM OR Method21_Leak_Detection__c =: GMTH21 OR
                                                 Painting_Coating_Option__c =: GPAINT];
        System.debug('Output: '+lstGl);
        return lstGl;
        
    }
    // RV outputs for Document  
    public List<Relief_Valve_Document__c>  getRVDocument() {
        List<Relief_Valve_Document__c> lstGl = [SELECT Id, Model_Size__c, Document__c, Size_Preference__c, 
                                                 Document_Id__c,Atex_Certificate_2014_34_EU__c, Revision__c,
                                                 CU_TR__c FROM Relief_Valve_Document__c Where 
                                                 Atex_Certificate_2014_34_EU__c=:ATEX OR CU_TR__c=:CUTR 
                                                 OR Model_Size__c=:Model OR Size_Preference__c=:size];
        System.debug('Output: '+lstGl);
        return lstGl;
    }
    // RV outputs for routing  
    public List<Relief_Valve_Routing__c>  getRouting() {
        List<Relief_Valve_Routing__c> lstRR = [SELECT Id, Operation__c, Standard_Operation_ID__c, 
                                               Outside_Operation_Item__c, Description__c 
                                               FROM Relief_Valve_Routing__c  
                                               where (Positive_Material_Identification__c=:PMI)
                                               OR (Visual_Casting_Examination__c=:VISCASTEXAM)
                                               OR (Model__c=:PTC AND Size__c=:Size AND Pallet_Type__c=:GPTYPE AND Body_Material__c=:MCBODY AND Seat_Material__c=:MCSEAT)
                                               OR (Painting_Coating_Option__c=:GPAINT)];
        System.debug('Output: '+lstRR);
        return lstRR;
    }
    public List<Relief_Valve_Control_Plan__c>  getControlPlan() {
        List<Relief_Valve_Control_Plan__c> lstCP = [SELECT Id, Test_Operation_Desc__c, Norm_Type__c, Operation_Number__c, 
                                                    Data_Type__c, Category_ID__c, Inspection_Code__c, Process_Characteristic__c,
                                                    Outer_Min__c, Inner_Min__c, Nominal_Value__c, Inner_Max__c, Outer_Max__c,
                                                    Tool_Id__c, Data_Point__c, Connected_To_Trigger__c, Connected_To_Tool__c,
                                                    Reciept_Not_Allowed__c, Mandatory__c, Simplified_Revision_Handling__c,
                                                    Relief_Type__c FROM Relief_Valve_Control_Plan__c 
                                                   where Relief_Type__c=:ReliefType];
        System.debug('Output: '+lstCP);
        return lstCP;
    } 
    
   */
    

}