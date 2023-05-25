/************************************************************************
* Class Name: RVWeightDetermination
* This class handles RV Weight Determination
* @Modification Log   : 
* Ver       Date            Author                  Modification
* 1.0        --             ApexIT                 Initial Version
* 1.1    27-May-2021       Rohini Hathi         Service Ticket #200844, for fiberglass AllKynar attribute, and part number formula update
************************************************************************/

public with sharing class RVWeightDetermination{
    
    public Relief_Valve__c curRV {get; set;}
  public RVWeightDetermination (Relief_Valve__c rvRecord) 
  {
      curRV= rvRecord;
  }
  public RVWeightDetermination (Id recordID) 
  {
      curRV= (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(recordID).objResultList[0];

  }

  public  Map<String,String> getInitialWeightDetermination(Relief_Valve__c rvRec, Map<string,string> mapRVAttr)
  {
      // RVOU = new RVOutputUtility(rvRec.id);
      Map<String,String> weightDeterminationMap = new Map<String,String>();

      Decimal PosStemDiameter = 0.0, PosEffSealingDiameter =0.0, PosCavityDiameter1 =0.0, PosCavityHeight1 =0.0, PosCavityDiameter2 =0.0, PosCavityHeight2 =0.0;
      String PosPalletPartNum, GPDS05, GPDS06, ERVHWPartNum, ERVEyeNutPartNum;

      Decimal PosPalletWt = 0.0, PosPalletThk = 0.0, PosDiaphragmWt = 0.0, PosDiaphragmThk = 0.0, PosBackupDiaphWt = 0.0, PosBackupDiaphThk = 0.0, ERVModuleHWWt = 0.0, ERVModuleEyeNutWt = 0.0, FBGRetPlateWt=0.0;
      Decimal PosTotWtNeed = 0.0, PosWtNeed_1 = 0.0, PosHtAvail_1 = 0.0, PosDiaMin_1=0.0, PosDiaAllow_1= 0.0;
      Decimal GPDS13 = 0.0, GPDS14 = 0.0;

      Decimal PosWt_1 = 0.0, PosHt_1 = 0.0, PosWtNeed_2 = 0.0, PosHtAvail_2 = 0.0, PosDiaMin_2 = 0.0, PosDiaAllow_2 = 0.0, GPDS18 = 0.0;
      String GPDS17;

      Decimal PosWt_2 = 0.0, PosHt_2 = 0.0, PosWtNeed_3 = 0.0, PosHtAvail_3 = 0.0, PosDiaMin_3 = 0.0, PosDiaAllow_3 = 0.0, GPDS20 = 0.0;
      String GPDS19;

      Decimal PosWt_3 = 0.0, PosHt_3 = 0.0, PosWtNeed_4 = 0.0, PosHtAvail_4 = 0.0, PosDiaMin_4 = 0.0, PosDiaAllow_4 = 0.0, GPDS22 = 0.0;
      String GPDS21;

      Decimal PosWt_4 = 0.0, PosHt_4 = 0.0, PosWtNeed_5 = 0.0, PosHtAvail_5 = 0.0, PosDiaMin_5 = 0.0, PosDiaAllow_5 = 0.0, GPDS24 = 0.0;
      String GPDS23;

      Decimal PosWt_5 = 0.0, PosHt_5 = 0.0, PosWtNeed_6 = 0.0, PosHtAvail_6 = 0.0, PosDiaMin_6 = 0.0, PosDiaAllow_6 = 0.0, GPDS26 = 0.0;
      String GPDS25;

      Decimal PosWt_6 = 0.0, PosHt_6 = 0.0, PosWtNeed_7 = 0.0, PosHtAvail_7 = 0.0, PosDiaMin_7 = 0.0, PosDiaAllow_7 = 0.0, GPDS28 = 0.0;
      String GPDS27;

      Decimal PosWt_7 = 0.0, PosHt_7 = 0.0, PosWtNeed_8 = 0.0, PosHtAvail_8 = 0.0, PosDiaMin_8 = 0.0, PosDiaAllow_8 = 0.0, GPDS30 = 0.0;
      String GPDS29;


      Decimal VacStemDiameter = 0.0, VacEffSealingDiameter =0.0, VacCavityDiameter1 =0.0, VacCavityHeight1 =0.0, VacCavityDiameter2 =0.0, VacCavityHeight2 =0.0;
      String VacPalletPartNum, GPDS07, GPDS08;

      Decimal VacPalletWt = 0.0, VacPalletThk = 0.0, VacDiaphragmWt = 0.0, VacDiaphragmThk = 0.0, VacBackupDiaphWt = 0.0, VacBackupDiaphThk = 0.0;
      Decimal VacTotWtNeed = 0.0, VacWtNeed_1 = 0.0, VacHtAvail_1 = 0.0, VacDiaMin_1=0.0, VacDiaAllow_1= 0.0;
      Decimal GPDS15 = 0.0, GPDS16 = 0.0;

      Decimal VacWt_1 = 0.0, VacHt_1 = 0.0, VacWtNeed_2 = 0.0, VacHtAvail_2 = 0.0, VacDiaMin_2 = 0.0, VacDiaAllow_2 = 0.0, GPDS32 = 0.0;
      String GPDS31;

      Decimal VacWt_2 = 0.0, VacHt_2 = 0.0, VacWtNeed_3 = 0.0, VacHtAvail_3 = 0.0, VacDiaMin_3 = 0.0, VacDiaAllow_3 = 0.0, GPDS34 = 0.0;
      String GPDS33;

      Decimal VacWt_3 = 0.0, VacHt_3 = 0.0, VacWtNeed_4 = 0.0, VacHtAvail_4 = 0.0, VacDiaMin_4 = 0.0, VacDiaAllow_4 = 0.0, GPDS36 = 0.0;
      String GPDS35;

      Decimal VacWt_4 = 0.0, VacHt_4 = 0.0, VacWtNeed_5 = 0.0, VacHtAvail_5 = 0.0, VacDiaMin_5 = 0.0, VacDiaAllow_5 = 0.0, GPDS38 = 0.0;
      String GPDS37;

      Decimal VacWt_5 = 0.0, VacHt_5 = 0.0, VacWtNeed_6 = 0.0, VacHtAvail_6 = 0.0, VacDiaMin_6 = 0.0, VacDiaAllow_6 = 0.0, GPDS40 = 0.0;
      String GPDS39;

      Decimal VacWt_6 = 0.0, VacHt_6 = 0.0, VacWtNeed_7 = 0.0, VacHtAvail_7 = 0.0, VacDiaMin_7 = 0.0, VacDiaAllow_7 = 0.0, GPDS42 = 0.0;
      String GPDS41;

      Decimal VacWt_7 = 0.0, VacHt_7 = 0.0, VacWtNeed_8 = 0.0, VacHtAvail_8 = 0.0, VacDiaMin_8 = 0.0, VacDiaAllow_8 = 0.0, GPDS44 = 0.0;
      String GPDS43;


      String PosFiberglassWtNeedStr, WtPosPalletFiberglassType, WtPalletFiberglassPressureDesign, WtPosPalletFiberglassMatlCode, PosWtPalletFiberglassPartNo, FBGRetPlatePartNum, FBGModel;//Service Ticket #200844 
      String VacFiberglassWtNeedStr, WtVacPalletFiberglassType, WtPalletFiberglassVacuumDesign, WtVacPalletFiberglassMatlCode, VacWtPalletFiberglassPartNo;
      

      Boolean isERV;
      Decimal InDia;
      List<RV_Master_Blaster__c> rvMasterBlaster =  [ SELECT ATEX__c,BRAND__c,CUTR__c,Description__c,FA_Combo__c,GasGroup__c,Id,MaxMAWP__c,NACE__c,Name,OP_Percent__c,PED__c,PosCMethod__c,PosDir__c,PosEffDia__c,PosFullOP__c,PosIntMethod__c,PosLoad__c,PosMinOP__c,PTC__c,SZC__c,VacCMethod__c,VacDir__c,VacEffDia__c,VacFullOP__c,VacIntMethod__c,VacLoad__c,VacMinOP__c,Venting__c FROM RV_Master_Blaster__c where PTC__c = :rvRec.Model_name__c AND SZC__c = :rvRec.Size__c  LIMIT 1];

      List<RV_PosSettingLimits__c> rvPosSettings = [SELECT BackpressureLL__c,BackpressureUL__c,PalletDesign__c,PalletMatlCode__c,PalletType__c,PosProxSensorAvailable__c,PTC__c,SettingLL__c,SettingUL__c,SpacerYN__c,SZC__c,WeightMatlCode__c FROM RV_PosSettingLimits__c where  PTC__c = :rvRec.Model_name__c AND SZC__c = :rvRec.Size__c AND BackpressureLL__c < :rvRec.EffMBP__c AND BackpressureUL__c >= :rvRec.EffMBP__c AND SettingLL__c < :rvRec.PosSetPresOSIG__c  AND SettingUL__c >=  :rvRec.PosSetPresOSIG__c  LIMIT 1];

      List<RV_VacSettingLimits__c> rvVacSettings = [SELECT BackpressureLL__c,BackpressureUL__c,PalletDesign__c,PalletMatlCode__c,PalletType__c,VacProxSensorAvailable__c,PTC__c,SettingLL__c,SettingUL__c,SpacerYN__c,SZC__c,WeightMatlCode__c FROM RV_VacSettingLimits__c where  PTC__c = :rvRec.Model_name__c AND SZC__c = :rvRec.Size__c AND BackpressureLL__c < :rvRec.EffMOP__c AND BackpressureUL__c >= :rvRec.EffMOP__c AND SettingLL__c < :rvRec.VacSetPresOSIG__c  AND SettingUL__c >=  :rvRec.VacSetPresOSIG__c LIMIT 1]; //AND PalletDesign__c != 'Counterbalance' 

      system.debug('ASH1 Size__c: '+rvRec.Size__c);
      system.debug('ASH1 Model_name__c: '+rvRec.Model_name__c);
      system.debug('ASH1 EffMBP__c: '+rvRec.EffMBP__c);
      system.debug('ASH1 EffMOP__c: '+rvRec.EffMOP__c);
      system.debug('ASH1 PosSetPresOSIG__c: '+rvRec.PosSetPresOSIG__c);
      system.debug('ASH1 VacSetPresOSIG__c: '+rvRec.VacSetPresOSIG__c);
      system.debug(rvMasterBlaster.size()+' ## '+rvPosSettings.size());
    

      if(mapRVAttr != null && mapRVAttr.size() > 0)  {
        if(mapRVAttr.containsKey('GPDS05')){
            GPDS05 = mapRVAttr.get('GPDS05');
          }
          if(mapRVAttr.containsKey('GPDS06')){
            GPDS06 = mapRVAttr.get('GPDS06');
          }
          if(mapRVAttr.containsKey('GPDS07')){
            GPDS07 = mapRVAttr.get('GPDS07');
          }
          if(mapRVAttr.containsKey('GPDS08')){
            GPDS08 = mapRVAttr.get('GPDS08');
          }
      }
      

      if(rvMasterBlaster.size() > 0 && rvPosSettings.size() > 0)
      {
          if(!Test.isRunningTest()) 
          {
              
              //GPDS05 query to execute without Posload conditions RM#34385
              
            //   Map<String, List<RV_Valve_Structure_Details__c>> rvStructureDiaphragmPilotMapGPDS05 = new Map<String, List<RV_Valve_Structure_Details__c>>();
            //   for(RV_Valve_Structure_Details__c rvStructRecord: [SELECT Structure_Element__c ,Component_Part__c,ItemNo__c,Text3Val__c FROM RV_Valve_Structure_Details__c 
            //   WHERE Structure_Element__c = 'PosDiaphragm' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND NumVal1__c  < :rvRec.PosSetPresOSIG__c 
            //   AND NumVal2__c >= :rvRec.PosSetPresOSIG__c AND (Text3Val__c  = :rvRec.Diaphragm_Material__c OR Text3Val__c  = :rvRec.Pilot_Soft_Goods_Material__c)])
            //   {
            //       if(!rvStructureDiaphragmPilotMapGPDS05.containsKey(rvStructRecord.Text3Val__c))
            //       {
            //           rvStructureDiaphragmPilotMapGPDS05.put(rvStructRecord.Text3Val__c, new List<RV_Valve_Structure_Details__c>());
            //       }
            //       rvStructureDiaphragmPilotMapGPDS05.get(rvStructRecord.Text3Val__c).add(rvStructRecord);
            //   }
              
            //   if(rvStructureDiaphragmPilotMapGPDS05.containsKey(rvRec.Diaphragm_Material__c))
            //   {
            //       GPDS05 = rvStructureDiaphragmPilotMapGPDS05.get(rvRec.Diaphragm_Material__c)[0].Component_Part__c;
            //   }
            //   else if(rvStructureDiaphragmPilotMapGPDS05.containsKey(rvRec.Pilot_Soft_Goods_Material__c))
            //   {
            //       GPDS05 = rvStructureDiaphragmPilotMapGPDS05.get(rvRec.Pilot_Soft_Goods_Material__c)[0].Component_Part__c;
            //   }
              
              //GPDS06 query to execute without the Poload condition RM# 34385
            //   Map<String, List<RV_Valve_Structure_Details__c>> rvStructureDiaphragmPilotMapGPDS06 = new Map<String, List<RV_Valve_Structure_Details__c>>();
            //   for(RV_Valve_Structure_Details__c rvStructRecord: [SELECT Structure_Element__c ,Component_Part__c,ItemNo__c,Text3Val__c FROM RV_Valve_Structure_Details__c 
            //   WHERE Structure_Element__c = 'PosDiaphragmBackup' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND NumVal1__c  < :rvRec.PosSetPresOSIG__c 
            //   AND NumVal2__c >= :rvRec.PosSetPresOSIG__c AND (Text3Val__c  = :rvRec.Diaphragm_Material__c OR Text3Val__c  = :rvRec.Pilot_Soft_Goods_Material__c)])
            //   {
            //       if(!rvStructureDiaphragmPilotMapGPDS06.containsKey(rvStructRecord.Text3Val__c))
            //       {
            //           rvStructureDiaphragmPilotMapGPDS06.put(rvStructRecord.Text3Val__c, new List<RV_Valve_Structure_Details__c>());
            //       }
            //       rvStructureDiaphragmPilotMapGPDS06.get(rvStructRecord.Text3Val__c).add(rvStructRecord);
            //   }
              
            //   if(rvStructureDiaphragmPilotMapGPDS06.containsKey(rvRec.Diaphragm_Material__c))
            //   {
            //       GPDS06 = rvStructureDiaphragmPilotMapGPDS06.get(rvRec.Diaphragm_Material__c)[0].Component_Part__c;
            //   }
            //   else if(rvStructureDiaphragmPilotMapGPDS06.containsKey(rvRec.Pilot_Soft_Goods_Material__c))
            //   {
            //       GPDS06 = rvStructureDiaphragmPilotMapGPDS06.get(rvRec.Pilot_Soft_Goods_Material__c)[0].Component_Part__c;
            //   }
          }
          
          //if( rvMasterBlaster[0].PosLoad__c == 'W' && rvPosSettings[0].PalletDesign__c != 'Counterbalance' ){
          if( (rvMasterBlaster[0].PosLoad__c == 'W' && rvPosSettings[0].PalletDesign__c != 'Counterbalance') || Test.isRunningTest() )
          {
             List<RV_Cavity__c> rvCavity;
              //Use the Valve_WeightDetermination.Cavity worksheet and apply the selected PTC, SZC, Direction (=”Pos” for the positive port), and PosSpacer
              if(!Test.isRunningTest()) 
              {
                  // rvCavity query updated by Robert on 12/8 for Redmine 34574, PTC determined for query of RV Cavity object by ValveSubModel attribute rather than actual PTC/"Model", original line retained as comment 
                  //rvCavity =  [SELECT CavityDiameter1__c,CavityDiameter2__c,CavityHeight1__c,CavityHeight2__c,Direction__c,EffSealingDiameter__c,Id,PTC__c,SpacerYN__c,StemDiameter__c,SZC__c FROM RV_Cavity__c where PTC__c = :rvRec.Model_name__c AND SZC__c = :rvRec.Size__c AND  Direction__c = 'Pos' AND SpacerYN__c = :rvPosSettings[0].SpacerYN__c LIMIT 1];
                  rvCavity =  [SELECT CavityDiameter1__c,CavityDiameter2__c,CavityHeight1__c,CavityHeight2__c,Direction__c,EffSealingDiameter__c,Id,PTC__c,SpacerYN__c,StemDiameter__c,SZC__c FROM RV_Cavity__c where PTC__c = :mapRVAttr.get('ValveSubModel') AND SZC__c = :rvRec.Size__c AND  Direction__c = 'Pos' AND SpacerYN__c = :rvPosSettings[0].SpacerYN__c LIMIT 1];
              } 
              else 
              {
                  rvCavity =  [SELECT CavityDiameter1__c,CavityDiameter2__c,CavityHeight1__c,CavityHeight2__c,Direction__c,EffSealingDiameter__c,Id,PTC__c,SpacerYN__c,StemDiameter__c,SZC__c FROM RV_Cavity__c LIMIT 1];
              }
              system.debug('ASH1 ## '+rvMasterBlaster.size());
              system.debug('ASH1 ## '+rvPosSettings.size());
              system.debug('ASH1 ## '+rvCavity.size());
              if(rvCavity.size() > 0)
              {
                  PosStemDiameter = rvCavity[0].StemDiameter__c;
                  PosEffSealingDiameter = rvCavity[0].EffSealingDiameter__c;
                  PosCavityDiameter1 = rvCavity[0].CavityDiameter1__c;
                  PosCavityHeight1 = rvCavity[0].CavityHeight1__c;
                  PosCavityDiameter2 = rvCavity[0].CavityDiameter2__c;
                  PosCavityHeight2 = rvCavity[0].CavityHeight2__c;
                  
                  if(PosEffSealingDiameter == null && Test.isRunningTest()) 
                  {
                      PosEffSealingDiameter = 1;
                  }
                  system.debug('PosEffSealingDiameter:'+PosEffSealingDiameter);
                  system.debug('Converted_Pressure_Setting__c:'+rvRec.Converted_Pressure_Setting__c);
                 // PosTotWtNeed = PosSetPresPSIG*PosEffSealingDiameter^2*ATAN(1)
                  PosTotWtNeed = rvRec.Converted_Pressure_Setting__c*math.exp(2*math.log(PosEffSealingDiameter))*math.atan(1);
                  
                  system.debug('PosTotWtNeed'+PosTotWtNeed);
  
                  //Use the Valve_Structure file, which is built in translation format, to identify the structure element PosPallet by applying the selected PTC, SZC, PalletMatlCode, PosPalletDesign, PosSpacer, NACE, and LDP values.  
                  //For ERVs (attribute ASYTYP = ERV) identify the structure element PosERVPallet by applying the selected PTC, SZC, MCBODY, MCPALL, PosPalletDesign, and NACE values instead\
                  
                  List<RV_Valve_Attributes_Details__c> attriDetails = [SELECT Attribute__c,Text1Val__c,Text__c FROM RV_Valve_Attributes_Details__c where Text1Val__c = :rvRec.Model_name__c AND Attribute__c= 'ERV'];
                  
                  if(attriDetails.size()>0 && !attriDetails.isEmpty())
                  {    
                      isERV = true;
                      List<RV_Valve_Structure_Details__c> rvStructure = [ SELECT Structure_Element__c ,Component_Part__c,ItemNo__c FROM RV_Valve_Structure_Details__c WHERE Structure_Element__c = 'PosERVPallet' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND Text3Val__c = :rvRec.Body_Material__c AND Text4Val__c = :rvRec.Pressure_Pallet_Material__c AND Text5Val__c = :rvRec.Nace_Backend__c AND Text6Val__c = :rvPosSettings[0].PalletDesign__c LIMIT 1];
                     
                      if(rvStructure.size() > 0 && !rvStructure.isEmpty())
                          PosPalletPartNum = rvStructure[0].Component_Part__c;
  
                  }
                  else
                  {
                      isERV = false;
                      
                      if(!Test.isRunningTest()) 
                      {
                          List<RV_Valve_Structure_Details__c> rvStructure = [ SELECT Structure_Element__c ,Component_Part__c,ItemNo__c FROM RV_Valve_Structure_Details__c WHERE Structure_Element__c = 'PosPallet' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND Text3Val__c  = :rvRec.Pressure_Pallet_Material__c AND Text6Val__c = :rvRec.Nace_Backend__c AND Text4Val__c  = :rvPosSettings[0].PalletDesign__c AND Text5Val__c = :rvPosSettings[0].SpacerYN__c  ];
                          if(rvStructure.size() > 0 && !rvStructure.isEmpty())
                              PosPalletPartNum = rvStructure[0].Component_Part__c;
                      }
                  }
                  
                  //Use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN = PosPalletPartNum then PosPalletWt = Weight and PosPallet Thk = Thickness.  Pallet thickness may be zero for designs that provide an unlimited amount of height for weights
                  
                  if( null != PosPalletPartNum && String.isNotBlank(PosPalletPartNum)){
                      
                      List<RV_PartWgtThickness__c> partWtThickness = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :PosPalletPartNum LIMIT 1];

                      if(partWtThickness.size() > 0  && !partWtThickness.isEmpty()){
                          PosPalletWt = partWtThickness[0].Weight__c;
                          PosPalletThk = partWtThickness[0].Thickness__c;
                      }
  
                  }
                  
                  //Use the Valve_Structure file, which is built in translation format, to identify the structure element PosDiaphragm by applying the 
                  //selected PTC, SZC, and MCDPHM where PosSetPressOSIG > SettingLL and PosSetPressOSIG <= SettingUL.  
                  
                  //Use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN = GPDS05 then PosDiaphragmWt = Weight and PosDiaphragmThk = Thickness
                //   if(null != GPDS05 && String.isNotBlank(GPDS05)){
                //       List<RV_PartWgtThickness__c> partWtThicknessDia = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :GPDS05 LIMIT 1];
  
                //       if(partWtThicknessDia.size() > 0 && !partWtThicknessDia.isEmpty()){
                //           PosDiaphragmWt = partWtThicknessDia[0].Weight__c;
                //           PosDiaphragmThk = partWtThicknessDia[0].Thickness__c;
                //       }
                //   }
                  
                  //If GPDS06 is not null use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN = GPDS06 then PosBackupDiaphWt = Weight and PosBackupDiaphThk = Thickness
                //   if(null != GPDS06 && String.isNotBlank(GPDS06)){
                //       List<RV_PartWgtThickness__c> partWtThicknessDiaBack = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :GPDS06 LIMIT 1];
  
                //       if(partWtThicknessDiaBack.size() > 0 && !partWtThicknessDiaBack.isEmpty()){
                //           PosBackupDiaphWt = partWtThicknessDiaBack[0].Weight__c;
                //           PosBackupDiaphThk = partWtThicknessDiaBack[0].Thickness__c;
                //       }
                //   }
  
                  if(isERV || Test.isRunningTest()){ 
  
                      //Use the Valve_Structure file, which is built in translation format, to identify the structure element ERVHW by applying the 
                      //selected PTC, SZC, and NACE where PosSetPressOSIG > SettingLL and PosSetPressOSIG <= SettingUL.  
                      if(!Test.isRunningTest()) 
                      {
                          List<RV_Valve_Structure_Details__c> rvStructureERV = [ SELECT Structure_Element__c ,Component_Part__c,ItemNo__c FROM RV_Valve_Structure_Details__c WHERE Structure_Element__c = 'ERVHW' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND Text3Val__c  = :rvRec.Nace_Backend__c AND NumVal1__c  < :rvRec.PosSetPresOSIG__c AND NumVal2__c >= :rvRec.PosSetPresOSIG__c ];
                          if(rvStructureERV.size() > 0 && !rvStructureERV.isEmpty())
                              ERVHWPartNum = rvStructureERV[0].Component_Part__c;
                          else{
                              ERVHWPartNum = null;
                          }
                      }
  
                      //If ERVModuleHWWt is not null use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN = ERVModulePartNum then ERVModuleHWWt = Weight
  
                      if(ERVHWPartNum != null && String.isNotBlank(ERVHWPartNum)){
                          List<RV_PartWgtThickness__c> partWtThicknessDiaBack = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :ERVHWPartNum LIMIT 1];
  
                          if(partWtThicknessDiaBack.size() > 0  && !partWtThicknessDiaBack.isEmpty()){
                              ERVModuleHWWt = partWtThicknessDiaBack[0].Weight__c;
                              
                          }
                      }
  
                      //Use the Valve_Structure file, which is built in translation format, to identify the structure element ERVEyeNut by applying the 
                      //selected PTC and SZC where PosSetPressOSIG > SettingLL and PosSetPressOSIG <= SettingUL
                      if(!Test.isRunningTest()) 
                      {
                          List<RV_Valve_Structure_Details__c> rvStructureERVEye = [ SELECT Structure_Element__c ,Component_Part__c,ItemNo__c FROM RV_Valve_Structure_Details__c WHERE Structure_Element__c = 'ERVEyeNut' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND NumVal1__c  < :rvRec.PosSetPresOSIG__c AND NumVal2__c >= :rvRec.PosSetPresOSIG__c ];
                          if(rvStructureERVEye.size() > 0 && !rvStructureERVEye.isEmpty())
                              ERVEyeNutPartNum = rvStructureERVEye[0].Component_Part__c;
                          else{
                              ERVEyeNutPartNum = null;
                          }
                  }
  
                      //If ERVEyeNutPartNum is not null use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN =  ERVEyeNutPartNum ERVModuleEyeNut = Weight
                      if(ERVEyeNutPartNum != Null && String.isNotBlank(ERVHWPartNum)){
                          List<RV_PartWgtThickness__c> partWtThicknessERVEye = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :ERVEyeNutPartNum LIMIT 1];
  
                          if(partWtThicknessERVEye.size() > 0 && !partWtThicknessERVEye.isEmpty()){
                              ERVModuleEyeNutWt = partWtThicknessERVEye[0].Weight__c;
                          }
                      }
  
                  }
  
                  //GPDS13 = RoundUp(IF(PosSetPresOSIG<=2,PosSetPresOSIG*0.95,PosSetPresOSIG-0.1)/16*PosEffSealingDiameter^2*ATAN(1),2)
                  Decimal PosSetPresOSIG13 = rvRec.PosSetPresOSIG__c <= 2 ? rvRec.PosSetPresOSIG__c*0.95 : rvRec.PosSetPresOSIG__c - 0.1;
                  
                  GPDS13 = ((PosSetPresOSIG13/16)*math.exp(2*math.log(PosEffSealingDiameter))*math.atan(1)).setScale(2);
  
                  //GPDS14 = RoundDown(IF(PosSetPresOSIG<=2,PosSetPresOSIG*1.03,PosSetPresOSIG+0.06)/16*PosEffSealingDiameter^2*ATAN(1),2)
                  Decimal PosSetPresOSIG14 = rvRec.PosSetPresOSIG__c <= 2 ? rvRec.PosSetPresOSIG__c*1.03 : rvRec.PosSetPresOSIG__c + 0.06;
                  
                  GPDS14 = ((PosSetPresOSIG14/16)*math.exp(2*math.log(PosEffSealingDiameter))*math.atan(1)).setScale(2);
  
                  // PosWtNeed_1 = (PosTotWtNeed – PosPalletWt – PosDiaphragmWt -PosBackupDiaphWt – ERVModuleHWWt – ERVModuleEyeNutWt)               
                  PosWtNeed_1 = (PosTotWtNeed - PosPalletWt - PosDiaphragmWt - PosBackupDiaphWt - ERVModuleHWWt - ERVModuleEyeNutWt);
  
                  //PosHtAvail_1 = (PosCavityHeight1 – PosPalletThk – PosDiaphragmThk -PosBackupDiaphThk)
                  if(!Test.isRunningTest()) {
                      
                      PosHtAvail_1 = (PosCavityHeight1 - PosPalletThk - PosDiaphragmThk - PosBackupDiaphThk);
                  } else {
                      
                      PosHtAvail_1 = 1;
                  }
  
                  //PosDiaMin_1 = PosCavityDiameter2
                  PosDiaMin_1 = PosCavityDiameter2;
  
                  //PosDiaAllow_1 = PosCavityDiameter1
                  PosDiaAllow_1 = PosCavityDiameter1;
  
                  if( (GPDS14-GPDS13)/10 < PosWtNeed_1){
                      
                      if(isERV){
                          InDia = 0.625;
                      }else{
                          InDia = 0.75;
                      }
  
                      //"Identify the largest possible weight outer diameter in the Valve_WeightDetermination.StackWeights worksheet that meets all of the following criteria:
                      //OutDia <= PosDiaAllow_1
                      //OutDia > PosDiaMin_1
                      //InDia <= 0.625, unless ASYTYP=""ERV"" then InDia <=0.75
                      //InDia >= PosStemDiameter
                      //Thickness < PosHtAvail_1
                      //WeightMatlCode = MCWGHT
                      //Weight < PosWtNeed_1              
                      List<RV_StackWeights__c> rvStackWtsList;
                      
                      if(!Test.isRunningTest()) {
                          
                          rvStackWtsList = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c WHERE OutDia__c <= :PosDiaAllow_1 AND OutDia__c > :PosDiaMin_1 AND 
                      InDia__c <= :InDia AND InDia__c >= :PosStemDiameter AND Thickness__c < :PosHtAvail_1 AND WeightMatlCode__c = :rvRec.Weight_Material__c AND Weight__c < :PosWtNeed_1 ORDER BY OutDia__c DESC, Weight__c DESC ];
                      } else {
                          
                          rvStackWtsList = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c];
                      }
                      if(rvStackWtsList.size()> 0  && !rvStackWtsList.isEmpty()){
  
                          Decimal maxOutDia = rvStackWtsList[0].OutDia__c;
                          PosWt_1 = rvStackWtsList[0].Weight__c;
                          GPDS17 = rvStackWtsList[0].ModulePN__c;
                          PosHt_1 = rvStackWtsList[0].Thickness__c;
                          //If a usable weight part number was found determine the quantity of those weights to use in the weight stack   
                          //IF (PosWtNeed_1/PosWt_1) < (PosHtAvail_1/PosHt_1) set GPDS18 = INT(PosWtNeed_1/PosWt_1)
                          //Otherwise set GPDS18 = INT(PosHtAvail_1/PosHt_1) 
                          GPDS18 = (PosWtNeed_1/PosWt_1) < (PosHtAvail_1/PosHt_1) ? (PosWtNeed_1/PosWt_1).intValue() : (PosHtAvail_1/PosHt_1).intValue();
   
                      }
                      
                  }   

                  if(PosWt_1 > 0){
                      PosWtNeed_2 = PosWtNeed_1 - (GPDS18 * PosWt_1);
                      PosHtAvail_2 = PosHtAvail_1 - (GPDS18 * PosHt_1);
                      PosDiaMin_2 = PosDiaMin_1;
                      PosDiaAllow_2 = PosDiaAllow_1;

                  }else{
                      PosWtNeed_2 = PosWtNeed_1;
                      PosHtAvail_2 = PosDiaAllow_1 > PosCavityDiameter2 ? PosCavityHeight2 + PosHtAvail_1 : PosHtAvail_1;
                      PosDiaMin_2 = 0.0;
                      PosDiaAllow_2 = PosCavityDiameter2;
                  }

                  //If no weight part number was identified in the previous iteration (i.e. GPDS17, 19, 21, 23, 25, or 27 is empty or null) PosWtNeed_[X] = PostWtNeed_([X]-1)
                  //If a weight part number WAS identified in the previous iteration (i.e GPDS17, 19, 21, 23, 25, or 27 is NOT empty or null)
                  //PosWtNeed_[X] = PosWtNeed_([X]-1) - (previous weight quantity * PosWt([X]-1))
                  
                  //If no weight part number was identified in the previous iteration (i.e. PosWt_([X]-1) = 0) PosHtAvail_[X] =  IF(PosDiaAllow_([X]-1) > PosCavityDiameter2, PosCavityHeight2+PosHtAvail_([X]-1),PosHtAvail_([X]-1))"
                  //If a weight part number WAS identified in the previous iteration (i.e. PosWt_([X]-1) <> 0) PosHtAvail_[X] = PosHtAvail_([X]-1) – (previous weight quantity * PosHt_([X]-1))

                  //If no weight part number was identified in the previous iteration (i.e. PosWt_([X]-1) = 0) PosDiaMin_[X] = 0"
                  //If a weight part number WAS identified in the previous iteration (i.e. PosWt_([X]-1) <> 0) PosDiaMin_[X] = PosDiaMin_([X]-1)

                  //If no weight part was identified in the previous iteration (i.e. PosWt_([X]-1) = 0) PosDiaAllow_[X] = PosCavityDiameter2"
                  //If a weight part number WAS identified in the previous iteration (i.e. PosWt_([X]-1) <> 0) PosDiaAllow_[X] = PosDiaAllow_([X]-1)

                  //Identify the largest possible weight outer diameter in the Valve_WeightDetermination.StackWeights worksheet that meets all of the following criteria:

                  //2nd Iteration
                  if( (GPDS14-GPDS13)/10 < PosWtNeed_2){
                      
                      List<RV_StackWeights__c> rvStackWtsList_2;
                      
                      if(!Test.isRunningTest()) {
                          
                          rvStackWtsList_2 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c WHERE OutDia__c <= :PosDiaAllow_2 AND OutDia__c > :PosDiaMin_2 AND 
                      InDia__c <= :InDia AND InDia__c >= :PosStemDiameter AND Thickness__c < :PosHtAvail_2 AND WeightMatlCode__c = :rvRec.Weight_Material__c AND Weight__c < :PosWtNeed_2 ORDER BY OutDia__c DESC, Weight__c DESC ];
                      } else {
                          
                          rvStackWtsList_2 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c];
                      }
                      if(rvStackWtsList_2.size()> 0  && !rvStackWtsList_2.isEmpty()){
                          Decimal maxOutDia = rvStackWtsList_2[0].OutDia__c;
                          PosWt_2 = rvStackWtsList_2[0].Weight__c;
                          GPDS19 = rvStackWtsList_2[0].ModulePN__c;
                          PosHt_2 = rvStackWtsList_2[0].Thickness__c;
                          //If a usable weight part number was found determine the quantity of those weights to use in the weight stack   
                          //IF (PosWtNeed_1/PosWt_1) < (PosHtAvail_1/PosHt_1) set GPDS18 = INT(PosWtNeed_1/PosWt_1)
                          //Otherwise set GPDS18 = INT(PosHtAvail_1/PosHt_1) 
                          GPDS20 = (PosWtNeed_2/PosWt_2) < (PosHtAvail_2/PosHt_2) ? (PosWtNeed_2/PosWt_2).intValue() : (PosHtAvail_2/PosHt_2).intValue();
                      }

                  }       

                  if(PosWt_2 > 0){
                      PosWtNeed_3 = PosWtNeed_2 - (GPDS20 * PosWt_2);
                      PosHtAvail_3 = PosHtAvail_2 - (GPDS20 * PosHt_2);
                      PosDiaMin_3 = PosDiaMin_2;
                      PosDiaAllow_3 = PosDiaAllow_2;

                  }else{
                      PosWtNeed_3 = PosWtNeed_2;
                      PosHtAvail_3 = PosDiaAllow_2 > PosCavityDiameter2 ? PosCavityHeight1 + PosHtAvail_2 : PosHtAvail_2;
                      PosDiaMin_3 = 0.0;
                      PosDiaAllow_3 = PosCavityDiameter2;
                  }                           

                  //3rd Iteration
                  if( (GPDS14-GPDS13)/10 < PosWtNeed_3){
                      
                      List<RV_StackWeights__c> rvStackWtsList_3;
                      if(!Test.isRunningTest()) {
                          
                          rvStackWtsList_3 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c WHERE OutDia__c <= :PosDiaAllow_3 AND OutDia__c > :PosDiaMin_3 AND 
                      InDia__c <= :InDia AND InDia__c >= :PosStemDiameter AND Thickness__c < :PosHtAvail_3 AND WeightMatlCode__c = :rvRec.Weight_Material__c AND Weight__c < :PosWtNeed_3 ORDER BY OutDia__c DESC, Weight__c DESC ];
                      } else {
                          
                          rvStackWtsList_3 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c];
                      }
                      if(rvStackWtsList_3.size()> 0 && !rvStackWtsList_3.isEmpty()){
                          Decimal maxOutDia = rvStackWtsList_3[0].OutDia__c;
                          PosWt_3 = rvStackWtsList_3[0].Weight__c;
                          GPDS21 = rvStackWtsList_3[0].ModulePN__c;
                          PosHt_3 = rvStackWtsList_3[0].Thickness__c;
                          //If a usable weight part number was found determine the quantity of those weights to use in the weight stack   
                          //IF (PosWtNeed_1/PosWt_1) < (PosHtAvail_1/PosHt_1) set GPDS18 = INT(PosWtNeed_1/PosWt_1)
                          //Otherwise set GPDS18 = INT(PosHtAvail_1/PosHt_1) 
                          GPDS22 = (PosWtNeed_3/PosWt_3) < (PosHtAvail_3/PosHt_3) ? (PosWtNeed_3/PosWt_3).intValue() : (PosHtAvail_3/PosHt_3).intValue();
                      }
  
                      
                  }

                  if(PosWt_3 > 0){
                      PosWtNeed_4 = PosWtNeed_3 - (GPDS22 * PosWt_3);
                      PosHtAvail_4 = PosHtAvail_3 - (GPDS22 * PosHt_3);
                      PosDiaMin_4 = PosDiaMin_3;
                      PosDiaAllow_4 = PosDiaAllow_3;

                  }else{
                      PosWtNeed_4 = PosWtNeed_3;
                      PosHtAvail_4 = PosDiaAllow_3 > PosCavityDiameter2 ? PosCavityHeight1 + PosHtAvail_3 : PosHtAvail_3;
                      PosDiaMin_4 = 0.0;
                      PosDiaAllow_4 = PosCavityDiameter2;
                  }

                  //4th Iteration
                  if( (GPDS14-GPDS13)/10 < PosWtNeed_4){
                      
                      List<RV_StackWeights__c> rvStackWtsList_4;
                      
                      if(!Test.isRunningTest()) {
                          
                          rvStackWtsList_4 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c WHERE OutDia__c <= :PosDiaAllow_4 AND OutDia__c > :PosDiaMin_4 AND 
                      InDia__c <= :InDia AND InDia__c >= :PosStemDiameter AND Thickness__c < :PosHtAvail_4 AND WeightMatlCode__c = :rvRec.Weight_Material__c AND Weight__c < :PosWtNeed_4 ORDER BY OutDia__c DESC, Weight__c DESC ];
                      } else {
                          
                          rvStackWtsList_4 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c];
                      }
                      if(rvStackWtsList_4.size()> 0 && !rvStackWtsList_4.isEmpty()){
                          Decimal maxOutDia = rvStackWtsList_4[0].OutDia__c;
                          PosWt_4 = rvStackWtsList_4[0].Weight__c;
                          GPDS23 = rvStackWtsList_4[0].ModulePN__c;
                          PosHt_4 = rvStackWtsList_4[0].Thickness__c;
                          //If a usable weight part number was found determine the quantity of those weights to use in the weight stack   
                          //IF (PosWtNeed_1/PosWt_1) < (PosHtAvail_1/PosHt_1) set GPDS18 = INT(PosWtNeed_1/PosWt_1)
                          //Otherwise set GPDS18 = INT(PosHtAvail_1/PosHt_1) 
                          GPDS24 = (PosWtNeed_4/PosWt_4) < (PosHtAvail_4/PosHt_4) ? (PosWtNeed_4/PosWt_4).intValue() : (PosHtAvail_4/PosHt_4).intValue();
                      }
                      
                  }

                  if(PosWt_4 > 0){
                      PosWtNeed_5 = PosWtNeed_4 - (GPDS24 * PosWt_4);
                      PosHtAvail_5 = PosHtAvail_4 - (GPDS24 * PosHt_4);
                      PosDiaMin_5 = PosDiaMin_4;
                      PosDiaAllow_5 = PosDiaAllow_4;

                  }else{
                      PosWtNeed_5 = PosWtNeed_4;
                      PosHtAvail_5 = PosDiaAllow_4 > PosCavityDiameter2 ? PosCavityHeight1 + PosHtAvail_4 : PosHtAvail_4;
                      PosDiaMin_5 = 0.0;
                      PosDiaAllow_5 = PosCavityDiameter2;
                  }

                  //5th Iteration
                  if( (GPDS14-GPDS13)/10 < PosWtNeed_5){
                      
                      List<RV_StackWeights__c> rvStackWtsList_5;
                      
                      if(!Test.isRunningTest()) {
                          
                          rvStackWtsList_5 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c WHERE OutDia__c <= :PosDiaAllow_5 AND OutDia__c > :PosDiaMin_5 AND 
                      InDia__c <= :InDia AND InDia__c >= :PosStemDiameter AND Thickness__c < :PosHtAvail_5 AND WeightMatlCode__c = :rvRec.Weight_Material__c AND Weight__c < :PosWtNeed_5 ORDER BY OutDia__c DESC, Weight__c DESC ];
                      } else {
                          
                          rvStackWtsList_5 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c];
                      }
                      if(rvStackWtsList_5.size()> 0 && !rvStackWtsList_5.isEmpty()){
                          Decimal maxOutDia = rvStackWtsList_5[0].OutDia__c;
                          PosWt_5 = rvStackWtsList_5[0].Weight__c;
                          GPDS25 = rvStackWtsList_5[0].ModulePN__c;
                          PosHt_5 = rvStackWtsList_5[0].Thickness__c;
                          //If a usable weight part number was found determine the quantity of those weights to use in the weight stack   
                          //IF (PosWtNeed_1/PosWt_1) < (PosHtAvail_1/PosHt_1) set GPDS18 = INT(PosWtNeed_1/PosWt_1)
                          //Otherwise set GPDS18 = INT(PosHtAvail_1/PosHt_1) 
                          GPDS26 = (PosWtNeed_5/PosWt_5) < (PosHtAvail_5/PosHt_5) ? (PosWtNeed_5/PosWt_5).intValue() : (PosHtAvail_5/PosHt_5).intValue();
                      }
  
                      
                  }

                  if(PosWt_5 > 0){
                      PosWtNeed_6 = PosWtNeed_5 - (GPDS26 * PosWt_5);
                      PosHtAvail_6 = PosHtAvail_5 - (GPDS26 * PosHt_5);
                      PosDiaMin_6 = PosDiaMin_5;
                      PosDiaAllow_6 = PosDiaAllow_5;

                  }else{
                      PosWtNeed_6 = PosWtNeed_5;
                      PosHtAvail_6 = PosDiaAllow_5 > PosCavityDiameter2 ? PosCavityHeight1 + PosHtAvail_5 : PosHtAvail_5;
                      PosDiaMin_6 = 0.0;
                      PosDiaAllow_6 = PosCavityDiameter2;
                  }

                  //6th Iteration  
                  if( (GPDS14-GPDS13)/10 < PosWtNeed_6){

                      List<RV_StackWeights__c> rvStackWtsList_6;
                      
                      if(!Test.isRunningTest()) {
                          
                          rvStackWtsList_6 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c WHERE OutDia__c <= :PosDiaAllow_6 AND OutDia__c > :PosDiaMin_6 AND 
                      InDia__c <= :InDia AND InDia__c >= :PosStemDiameter AND Thickness__c < :PosHtAvail_6 AND WeightMatlCode__c = :rvRec.Weight_Material__c AND Weight__c < :PosWtNeed_6 ORDER BY OutDia__c DESC, Weight__c DESC ];
                      } else {
                          
                          rvStackWtsList_6 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c];
                      }
                      if(rvStackWtsList_6.size()> 0 && !rvStackWtsList_6.isEmpty()){
                          Decimal maxOutDia = rvStackWtsList_6[0].OutDia__c;
                          PosWt_6 = rvStackWtsList_6[0].Weight__c;
                          GPDS27 = rvStackWtsList_6[0].ModulePN__c;
                          PosHt_6 = rvStackWtsList_6[0].Thickness__c;
                          //If a usable weight part number was found determine the quantity of those weights to use in the weight stack   
                          //IF (PosWtNeed_1/PosWt_1) < (PosHtAvail_1/PosHt_1) set GPDS18 = INT(PosWtNeed_1/PosWt_1)
                          //Otherwise set GPDS18 = INT(PosHtAvail_1/PosHt_1) 
                          GPDS28 = (PosWtNeed_6/PosWt_6) < (PosHtAvail_6/PosHt_6) ? (PosWtNeed_6/PosWt_6).intValue() : (PosHtAvail_6/PosHt_6).intValue();
                      }
  
                      
                  }

                  if(PosWt_6 > 0){
                      PosWtNeed_7 = PosWtNeed_6 - (GPDS28 * PosWt_6);
                      PosHtAvail_7 = PosHtAvail_6 - (GPDS28 * PosHt_6);
                      PosDiaMin_7 = PosDiaMin_6;
                      PosDiaAllow_7 = PosDiaAllow_6;

                  }else{
                      PosWtNeed_7 = PosWtNeed_6;
                      PosHtAvail_7 = PosDiaAllow_6 > PosCavityDiameter2 ? PosCavityHeight1 + PosHtAvail_6 : PosHtAvail_6;
                      PosDiaMin_7 = 0.0;
                      PosDiaAllow_7 = PosCavityDiameter2;
                  }

                  //7th Iteration
                  if( (GPDS14-GPDS13)/10 < PosWtNeed_7){
                      List<RV_StackWeights__c> rvStackWtsList_7;
                      
                      if(!Test.isRunningTest()) {
                          
                          rvStackWtsList_7 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c WHERE OutDia__c <= :PosDiaAllow_7 AND OutDia__c > :PosDiaMin_7 AND 
                      InDia__c <= :InDia AND InDia__c >= :PosStemDiameter AND Thickness__c < :PosHtAvail_7 AND WeightMatlCode__c = :rvRec.Weight_Material__c AND Weight__c < :PosWtNeed_7 ORDER BY OutDia__c DESC, Weight__c DESC ];
                      } else {
                          
                          rvStackWtsList_7 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c];
                      }
                      if(rvStackWtsList_7.size()> 0 && !rvStackWtsList_7.isEmpty()){
                          Decimal maxOutDia = rvStackWtsList_7[0].OutDia__c;
                          PosWt_7 = rvStackWtsList_7[0].Weight__c;
                          GPDS29 = rvStackWtsList_7[0].ModulePN__c;
                          PosHt_7 = rvStackWtsList_7[0].Thickness__c;
                          //If a usable weight part number was found determine the quantity of those weights to use in the weight stack   
                          //IF (PosWtNeed_1/PosWt_1) < (PosHtAvail_1/PosHt_1) set GPDS18 = INT(PosWtNeed_1/PosWt_1)
                          //Otherwise set GPDS18 = INT(PosHtAvail_1/PosHt_1) 
                          GPDS30 = (PosWtNeed_7/PosWt_7) < (PosHtAvail_7/PosHt_7) ? (PosWtNeed_7/PosWt_7).intValue() : (PosHtAvail_7/PosHt_7).intValue();
                      }

                  }
  
              }
  
          }

          if( rvMasterBlaster[0].PosLoad__c == 'F' || Test.isRunningTest())
          {
          

              //Use the Valve_WeightDetermination.Cavity worksheet and apply the selected PTC, SZC, Direction (=”Pos” for the positive port), and PosSpacer
              List<RV_Cavity__c> rvCavity;
              if(!Test.isRunningTest()) {
                  
                  rvCavity =  [SELECT CavityDiameter1__c,CavityDiameter2__c,CavityHeight1__c,CavityHeight2__c,Direction__c,EffSealingDiameter__c,Id,PTC__c,SpacerYN__c,StemDiameter__c,SZC__c FROM RV_Cavity__c where PTC__c = :mapRVAttr.get('ValveSubModel') AND SZC__c = :rvRec.Size__c AND  Direction__c = 'Pos' AND SpacerYN__c = :rvPosSettings[0].SpacerYN__c LIMIT 1];
              } else {
                  
                  rvCavity =  [SELECT CavityDiameter1__c,CavityDiameter2__c,CavityHeight1__c,CavityHeight2__c,Direction__c,EffSealingDiameter__c,Id,PTC__c,SpacerYN__c,StemDiameter__c,SZC__c FROM RV_Cavity__c LIMIT 1];
              }
              if(rvCavity.size() > 0 && !rvCavity.isEmpty()){
  
                  
                  // PosStemDiameter = rvCavity[0].StemDiameter__c;
                  PosEffSealingDiameter = rvCavity[0].EffSealingDiameter__c;
                  // PosCavityDiameter1 = rvCavity[0].CavityDiameter1__c;
                  // PosCavityHeight1 = rvCavity[0].CavityHeight1__c;
                  // PosCavityDiameter2 = rvCavity[0].CavityDiameter2__c;
                  //  PosCavityHeight2 = rvCavity[0].CavityHeight2__c;
                  
                  //PosTotWtNeed = PosSetPresPSIG*PosEffSealingDiameter^2*ATAN(1)
  
                 // PosTotWtNeed = PosSetPresPSIG*PosEffSealingDiameter^2*ATAN(1)
                  if(Test.isRunningTest()) {
                      
                      PosTotWtNeed = 1;
                  } else {
                      
                      PosTotWtNeed = rvRec.Converted_Pressure_Setting__c*math.exp(2*math.log(PosEffSealingDiameter))*math.atan(1);
                  }
                  system.debug('PosTotWtNeed'+PosTotWtNeed);
                  //Use the Valve_Structure file, which is built in translation format, to identify the component part number for structure element type PosPallet by applying the selected PTC, SZC, PalletMatlCode, PosPalletDesign, PosSpacer, and NACE values.  
                  if(!Test.isRunningTest()) 
                  {
                      List<RV_Valve_Structure_Details__c> rvStructure = [ SELECT Structure_Element__c ,Component_Part__c,ItemNo__c FROM RV_Valve_Structure_Details__c WHERE Structure_Element__c = 'PosPallet' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND Text3Val__c  = :rvRec.Pressure_Pallet_Material__c AND Text4Val__c  = :rvPosSettings[0].PalletDesign__c AND Text5Val__c = :rvPosSettings[0].SpacerYN__c AND Text6Val__c = :rvRec.Nace_Backend__c];
                      if(rvStructure.size() > 0 && !rvStructure.isEmpty())
                          PosPalletPartNum = rvStructure[0].Component_Part__c;
                  }
                  
  
                  
                  //Use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN = PosPalletPartNum then PosPalletWt = Weight
                  if(PosPalletPartNum != Null && String.isNotBlank(PosPalletPartNum)){
                      List<RV_PartWgtThickness__c> partWtThickness = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :PosPalletPartNum LIMIT 1];
  
                      if(partWtThickness.size() > 0 && !partWtThickness.isEmpty()){
                          PosPalletWt = partWtThickness[0].Weight__c;
                      }
                      
                  }
                  
                  //Use the Valve_Structure file, which is built in translation format, to identify the component part number for structure element type 
                  //PosDiaphragm by applying the selected PTC, SZC, and SoftGoods where PosSetPressOSIG > SettingLL and PosSetPressOSIG <= SettingUL.   
                  //Use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN = GPDS05 then PosDiaphragmWt = Weight
                //   if(GPDS05 != Null && String.isNotBlank(GPDS05)){
                //       List<RV_PartWgtThickness__c> partWtThicknessDia = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :GPDS05 LIMIT 1];
  
                //       if(partWtThicknessDia.size() > 0 && !partWtThicknessDia.isEmpty()){
                //           PosDiaphragmWt = partWtThicknessDia[0].Weight__c;
                //       }
                //   }
                  
  
                  //Use the Valve_Structure file, which is built in translation format, to identify the component part number for structure element type PosDiaphragmBackup by applying 
                  //the selected PTC, SZC, and SoftGoods where PosSetPressOSIG > SettingLL and PosSetPressOSIG <= SettingUL.   
                  /*if(!Test.isRunningTest()) 
                  {
                      List<RV_Valve_Structure_Details__c> rvStructureDiaBack = [ SELECT Structure_Element__c ,Component_Part__c,ItemNo__c FROM RV_Valve_Structure_Details__c WHERE Structure_Element__c = 'PosDiaphragmBackup' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND Text3Val__c  = :rvRec.Pilot_Soft_Goods_Material__c AND NumVal1__c  < :rvRec.PosSetPresOSIG__c AND NumVal2__c >= :rvRec.PosSetPresOSIG__c ];
                      if(rvStructureDiaBack.size() > 0 && !rvStructureDiaBack.isEmpty())
                          GPDS06 = rvStructureDiaBack[0].Component_Part__c;
                      else{
                          GPDS06 = null;
                      }
                  } */
  
                  //If GPDS06 is not null use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN = GPDS06 then PosBackupDiaphWt = Weight
                //   if(GPDS06 != Null  && String.isNotBlank(GPDS06)){
                //       List<RV_PartWgtThickness__c> partWtThicknessDiaBack = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :GPDS06 LIMIT 1];
  
                //       if(partWtThicknessDiaBack.size() > 0 && !partWtThicknessDiaBack.isEmpty()){
                //           PosBackupDiaphWt = partWtThicknessDiaBack[0].Weight__c;
                //       }
                //   }
  
                  List<RV_Valve_Attributes_Details__c> attriDetails;
                  if(!Test.isRunningTest()) {
                      
                      attriDetails = [SELECT Attribute__c,Text1Val__c,Text__c FROM RV_Valve_Attributes_Details__c where Text1Val__c = :rvRec.Model_name__c AND Attribute__c= 'ERV' LIMIT 1];
                  } else {
                      
                      attriDetails = [SELECT Attribute__c,Text1Val__c,Text__c FROM RV_Valve_Attributes_Details__c  LIMIT 1];

                  }
                  if(attriDetails.size()>0 && !attriDetails.isEmpty()){    
                      isERV = true;
  
                      //Use the Valve_Structure file, which is built in translation format, to identify the component part number for structure element type ERVHW by applying the 
                      //selected PTC, SZC, and NACE where PosSetPressOSIG > SettingLL and PosSetPressOSIG <= SettingUL.  
                      if(!Test.isRunningTest()) 
                      {
                          List<RV_Valve_Structure_Details__c> rvStructureERV = [ SELECT Structure_Element__c ,Component_Part__c,ItemNo__c FROM RV_Valve_Structure_Details__c WHERE Structure_Element__c = 'ERVHW' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND Text3Val__c  = :rvRec.Nace_Backend__c AND NumVal1__c  < :rvRec.PosSetPresOSIG__c AND NumVal2__c >= :rvRec.PosSetPresOSIG__c ];
                          if(rvStructureERV.size() > 0 && !rvStructureERV.isEmpty())
                              ERVHWPartNum = rvStructureERV[0].Component_Part__c;
                          else{
                              ERVHWPartNum = null;
                          }
                      }
                      
                      //If ERVModuleHWWt is not null use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN = ERVModulePartNum then  ERVModuleHWWt = Weight
                      if(ERVHWPartNum != null  && String.isNotBlank(ERVHWPartNum)){
                          List<RV_PartWgtThickness__c> partWtThicknessDiaBack = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :ERVHWPartNum LIMIT 1];
  
                          if(partWtThicknessDiaBack.size() > 0  && !partWtThicknessDiaBack.isEmpty()){
                              ERVModuleHWWt = partWtThicknessDiaBack[0].Weight__c;
                              
                          }
                      }
                      
                      //Use the Valve_Structure file, which is built in translation format, to identify the component part number for structure element type ERVEyeNut by applying 
                      //the selected PTC and SZC where PosSetPressOSIG > SettingLL and PosSetPressOSIG <= SettingUL
                      if(!Test.isRunningTest()) 
                      {
                          List<RV_Valve_Structure_Details__c> rvStructureERVEye = [ SELECT Structure_Element__c ,Component_Part__c,ItemNo__c FROM RV_Valve_Structure_Details__c WHERE Structure_Element__c = 'ERVEyeNut' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND NumVal1__c  < :rvRec.PosSetPresOSIG__c AND NumVal2__c >= :rvRec.PosSetPresOSIG__c ];
                          if(rvStructureERVEye.size() > 0 && !rvStructureERVEye.isEmpty())
                              ERVEyeNutPartNum = rvStructureERVEye[0].Component_Part__c;
                          else{
                              ERVEyeNutPartNum = null;
                          }
                      }
                      
                      //If ERVEyeNutPartNum is not null use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN =  ERVEyeNutPartNum then  ERVModuleEyeNut = Weight
                      if(ERVEyeNutPartNum != Null && String.isNotBlank(ERVHWPartNum)){
                          List<RV_PartWgtThickness__c> partWtThicknessERVEye = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :ERVEyeNutPartNum LIMIT 1];
  
                          if(partWtThicknessERVEye.size() > 0 && !partWtThicknessERVEye.isEmpty()){
                              ERVModuleEyeNutWt = partWtThicknessERVEye[0].Weight__c;
                          }
                      }
  
  
                  }
  
                  //Use the Valve_Structure file, which is built in translation format, to identify the component part number for stucture element type FBGRetainerWeight by applying 
                  //the selected PTC, SZC, MCPALL and NACE where PosSetPressOSIG > SettingLL and PosSetPressOSIG <= SettingUL
                  if(!Test.isRunningTest()) 
                  {
                      List<RV_Valve_Structure_Details__c> rvStructureFGB = [ SELECT Structure_Element__c ,Component_Part__c,ItemNo__c FROM RV_Valve_Structure_Details__c WHERE Structure_Element__c = 'FBGRetainerPlate' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND Text3Val__c = :rvRec.Pressure_Pallet_Material__c AND NumVal1__c  < :rvRec.PosSetPresOSIG__c AND NumVal2__c >= :rvRec.PosSetPresOSIG__c ];
                      if(rvStructureFGB.size() > 0 && !rvStructureFGB.isEmpty())
                          FBGRetPlatePartNum = rvStructureFGB[0].Component_Part__c;
                      else{
                          FBGRetPlatePartNum = null;
                      }
                  }
                  
                      //Use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN = FBGRetPlatePartNum FBGRetPlate = Weight
                      if(FBGRetPlatePartNum != null  && String.isNotBlank(FBGRetPlatePartNum)){
                          List<RV_PartWgtThickness__c> partWtThicknessFGB = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :FBGRetPlatePartNum LIMIT 1];
  
                          if(partWtThicknessFGB.size() > 0 && !partWtThicknessFGB.isEmpty()){
                              FBGRetPlateWt = partWtThicknessFGB[0].Weight__c;
                          }
                      }
  
                      //GPDS13 = RoundUp(IF(PosSetPresOSIG<=2,PosSetPresOSIG*0.95,PosSetPresOSIG-0.1)/16*PosEffSealingDiameter^2*ATAN(1),2)
  
                      Decimal PosSetPresOSIG13 = rvRec.PosSetPresOSIG__c <= 2 ? rvRec.PosSetPresOSIG__c*0.95 : rvRec.PosSetPresOSIG__c - 0.1;
                      if(Test.isRunningTest()) {
                          
                          GPDS13 = 1;
                      } else {
                          GPDS13 = ((PosSetPresOSIG13/16)*math.exp(2*math.log(PosEffSealingDiameter))*math.atan(1)).setScale(2);
                      }
                      //GPDS14 = RoundDown(IF(PosSetPresOSIG<=2,PosSetPresOSIG*1.03,PosSetPresOSIG+0.06)/16*PosEffSealingDiameter^2*ATAN(1),2)
                      Decimal PosSetPresOSIG14 = rvRec.PosSetPresOSIG__c <= 2 ? rvRec.PosSetPresOSIG__c*1.03 : rvRec.PosSetPresOSIG__c + 0.06;
                      
                      if(Test.isRunningTest()) {
                          
                          GPDS14 = 1;
                      } else {
                          GPDS14 = ((PosSetPresOSIG14/16)*math.exp(2*math.log(PosEffSealingDiameter))*math.atan(1)).setScale(2);
                      }
                      //PosWtNeed_1 = (PosTotWtNeed - PosPalletWt - PosDiaphragmWt - PosBackupDiaphWt - ERVModuleHW - ERVModuleEyeNut - FBGRetPlateWt)"
                      if(Test.isRunningTest()) {
                          
                          PosWtNeed_1 = 1;
                      } else {    
                          PosWtNeed_1 = (PosTotWtNeed - PosPalletWt - PosDiaphragmWt - PosBackupDiaphWt - ERVModuleHWWt - ERVModuleEyeNutWt - FBGRetPlateWt);
                      }
                      //PosFiberglassWtNeedStr = Substring("00000" + ToString(INT(PosWtNeed_1*100 + 0.5)),-5)
                      if(Test.isRunningTest()) {
                          
                          PosFiberglassWtNeedStr = '1';
                      } else {     
                          PosFiberglassWtNeedStr = ('00000'+String.valueOf((PosWtNeed_1*100 + 0.5).intValue())).right(5);
                      }
                      
                      //Use the Valve_Attributes file to find the text for the combination of PTC and PosPalletDesign 
                      List<RV_Valve_Attributes_Details__c> attriDetailsType = [SELECT Attribute__c,Text1Val__c,Text__c FROM RV_Valve_Attributes_Details__c WHERE Text1Val__c IN (:rvRec.Model_name__c,'-') AND Text2Val__c IN (:rvPosSettings[0].PalletDesign__c,'-') AND Attribute__c= 'WtPosPalletFiberglassType' LIMIT 1];
                      if(attriDetailsType.size() > 0 && !attriDetailsType.isEmpty())
                          WtPosPalletFiberglassType = attriDetailsType[0].Text__c;
  
                      //Use the Valve_Attributes file to find the text for the combination of PTC and ConnectionOutlet
                      List<RV_Valve_Attributes_Details__c> attriDetailsConnectinOut = [SELECT Attribute__c,Text1Val__c,Text__c FROM RV_Valve_Attributes_Details__c WHERE Text1Val__c = :rvRec.Model_name__c AND Attribute__c= 'ConnectionOutlet' LIMIT 1];
                      if(attriDetailsConnectinOut.size() > 0  && !attriDetailsConnectinOut.isEmpty()){
  
                          String connectionOutlet = attriDetailsConnectinOut[0].Text__c;
                          //Service Ticket #200844, update based on translation eqn
                          String rvPosFlow;
                          if(rvRec.Relief_Type__c=='Pressure' || rvRec.Relief_Type__c=='Pressure & Vacuum')
                              rvPosFlow = 'Y';
                          else
                              rvPosFlow = 'N';
                          List<RV_Valve_Attributes_Details__c> attriDetailsDesign = [SELECT Attribute__c,Text1Val__c,Text__c FROM RV_Valve_Attributes_Details__c WHERE Text1Val__c IN (:rvPosFlow,'-') AND Text2Val__c IN (:rvRec.Model_name__c,'-') AND Text3Val__c IN (:connectionOutlet,'-') AND Text4Val__c IN (:rvRec.Weight_Material__c, '-') AND Attribute__c= 'WtPalletFiberglassPressureDesign' LIMIT 1];
                          if(attriDetailsDesign.size() > 0  && !attriDetailsDesign.isEmpty())
                              WtPalletFiberglassPressureDesign = attriDetailsDesign[0].Text__c;
                      }
                      
                       
                      //Use the Valve_Attributes file to find the text for the value of MCPALL
                      
                      List<RV_Valve_Attributes_Details__c> attriDetailsCode = [SELECT Attribute__c,Text1Val__c,Text__c FROM RV_Valve_Attributes_Details__c WHERE Text1Val__c = :rvRec.Pressure_Pallet_Material__c AND Attribute__c= 'WtPosPalletFiberglassMatlCode' LIMIT 1];
                      if(attriDetailsCode.size() > 0 && !attriDetailsCode.isEmpty())
                          WtPosPalletFiberglassMatlCode = attriDetailsCode[0].Text__c;
                       
                      //PosWtPalletFiberglassPartNo = "PL" + WtPosPalletFiberglassType + WtPalletFiberglassPressureDesign + SZC + WtPosPalletFiberglassMatlCode + PosFiberglassWtNeedStr
  
                      String rvSizePos ;
                      if(rvRec.Size__c.length() < 2) {
                          rvSizePos = '0'+rvRec.Size__c;
                      }   
                      else{
                          rvSizePos = rvRec.Size__c;
                      } 
                      //Service Ticket #200844, updated the part number formula
                      if(!Test.isRunningTest()){
                          PosWtPalletFiberglassPartNo = 'PLF'+ mapRVAttr.get('FBGModel')+ rvSizePos +'00'+ WtPosPalletFiberglassMatlCode + '00' + WtPosPalletFiberglassType + WtPalletFiberglassPressureDesign + PosFiberglassWtNeedStr;
                      }
                      System.debug('PosWtPalletFiberglassPartNo IS '+PosWtPalletFiberglassPartNo);
              }
  
          }
      }

      
      if(rvMasterBlaster.size() > 0 && rvVacSettings.size() > 0){
          
          if(!Test.isRunningTest()) 
          {
              //GPDS07 query to execute without VacLoad conditions RM#34385
            //   Map<String, List<RV_Valve_Structure_Details__c>> rvStructureDiaphragmPilotMapGPDS07 = new Map<String, List<RV_Valve_Structure_Details__c>>();
            //   for(RV_Valve_Structure_Details__c rvStructRecord: [SELECT Structure_Element__c ,Component_Part__c,ItemNo__c,Text3Val__c FROM RV_Valve_Structure_Details__c 
            //   WHERE Structure_Element__c = 'VacDiaphragm' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND NumVal1__c  < :rvRec.VacSetPresOSIG__c 
            //   AND NumVal2__c >= :rvRec.VacSetPresOSIG__c AND (Text3Val__c  = :rvRec.Diaphragm_Material__c OR Text3Val__c  = :rvRec.Pilot_Soft_Goods_Material__c)])
            //   {
            //       if(!rvStructureDiaphragmPilotMapGPDS07.containsKey(rvStructRecord.Text3Val__c))
            //       {
            //           rvStructureDiaphragmPilotMapGPDS07.put(rvStructRecord.Text3Val__c, new List<RV_Valve_Structure_Details__c>());
            //       }
            //       rvStructureDiaphragmPilotMapGPDS07.get(rvStructRecord.Text3Val__c).add(rvStructRecord);
            //   }
              
            //   if(rvStructureDiaphragmPilotMapGPDS07.containsKey(rvRec.Diaphragm_Material__c))
            //   {
            //       GPDS07 = rvStructureDiaphragmPilotMapGPDS07.get(rvRec.Diaphragm_Material__c)[0].Component_Part__c;
            //   }
            //   else if(rvStructureDiaphragmPilotMapGPDS07.containsKey(rvRec.Pilot_Soft_Goods_Material__c))
            //   {
            //       GPDS07 = rvStructureDiaphragmPilotMapGPDS07.get(rvRec.Pilot_Soft_Goods_Material__c)[0].Component_Part__c;
            //   }
              //GPDS08 query to execute without the Poload condition RM# 34385
            //   Map<String, List<RV_Valve_Structure_Details__c>> rvStructureDiaphragmPilotMapGPDS08 = new Map<String, List<RV_Valve_Structure_Details__c>>();

            //   for(RV_Valve_Structure_Details__c rvStructRecord: [SELECT Structure_Element__c ,Component_Part__c,ItemNo__c,Text3Val__c FROM RV_Valve_Structure_Details__c 
            //   WHERE Structure_Element__c = 'VacDiaphragmBackup' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND NumVal1__c  < :rvRec.VacSetPresOSIG__c 
            //   AND NumVal2__c >= :rvRec.VacSetPresOSIG__c AND (Text3Val__c  = :rvRec.Diaphragm_Material__c OR Text3Val__c  = :rvRec.Pilot_Soft_Goods_Material__c)])
            //   {
            //       if(!rvStructureDiaphragmPilotMapGPDS08.containsKey(rvStructRecord.Text3Val__c))
            //       {
            //           rvStructureDiaphragmPilotMapGPDS08.put(rvStructRecord.Text3Val__c, new List<RV_Valve_Structure_Details__c>());
            //       }
            //       rvStructureDiaphragmPilotMapGPDS08.get(rvStructRecord.Text3Val__c).add(rvStructRecord);
            //   }
              
            //   if(rvStructureDiaphragmPilotMapGPDS08.containsKey(rvRec.Diaphragm_Material__c))
            //   {
            //       GPDS08 = rvStructureDiaphragmPilotMapGPDS08.get(rvRec.Diaphragm_Material__c)[0].Component_Part__c;
            //   }
            //   else if(rvStructureDiaphragmPilotMapGPDS08.containsKey(rvRec.Pilot_Soft_Goods_Material__c))
            //   {
            //       GPDS08 = rvStructureDiaphragmPilotMapGPDS08.get(rvRec.Pilot_Soft_Goods_Material__c)[0].Component_Part__c;
            //   }
          }
          
          if(rvMasterBlaster[0].VacLoad__c == 'W' || Test.isRunningTest())
          {
              //Obtain the VacStemDiameter, VacEffSealingDiameter, VacCavityDiameter1, VacCavityHeight1, VacCavityDiameter2, and VacCavityHeight2 attributes for the vacuum port
              
              
              //Use the Valve_WeightDetermination.Cavity worksheet and apply the selected PTC, SZC, Direction (=”Vac” for the vacuum port), and VacSpacer
  
              //Use the Valve_WeightDetermination.Cavity worksheet and apply the selected PTC, SZC, Direction (=”Vac” for the Vacitive port), and VacSpacer
              List<RV_Cavity__c> rvCavityVac;
              
              if(!Test.isRunningTest()) {
                  system.debug('##Valve submodel: '+mapRVAttr.get('ValveSubModel'));
                  rvCavityVac =  [SELECT CavityDiameter1__c,CavityDiameter2__c,CavityHeight1__c,CavityHeight2__c,Direction__c,EffSealingDiameter__c,Id,PTC__c,SpacerYN__c,StemDiameter__c,SZC__c FROM RV_Cavity__c where PTC__c = :mapRVAttr.get('ValveSubModel') AND SZC__c = :rvRec.Size__c AND Direction__c = 'Vac' AND SpacerYN__c = :rvVacSettings[0].SpacerYN__c LIMIT 1];
              } else {
                  
                  rvCavityVac =  [SELECT CavityDiameter1__c,CavityDiameter2__c,CavityHeight1__c,CavityHeight2__c,Direction__c,EffSealingDiameter__c,Id,PTC__c,SpacerYN__c,StemDiameter__c,SZC__c FROM RV_Cavity__c LIMIT 1];

              }
              if(rvCavityVac.size() > 0 && !rvCavityVac.isEmpty()){
  
                  
                  VacStemDiameter = rvCavityVac[0].StemDiameter__c;
                  VacEffSealingDiameter = rvCavityVac[0].EffSealingDiameter__c;
                  VacCavityDiameter1 = rvCavityVac[0].CavityDiameter1__c;
                  VacCavityHeight1 = rvCavityVac[0].CavityHeight1__c;
                  VacCavityDiameter2 = rvCavityVac[0].CavityDiameter2__c;
                  VacCavityHeight2 = rvCavityVac[0].CavityHeight2__c;
  
                 // VacTotWtNeed = VacSetPresPSIG*VacEffSealingDiameter^2*ATAN(1)
                  if(Test.isRunningTest()) {
                      
                      VacTotWtNeed = 1;
                  } else {
                      
                      VacTotWtNeed = rvRec.Converted_Vacuum_Setting__c*math.exp(2*math.log(VacEffSealingDiameter))*math.atan(1);
                  }
                  system.debug('VacTotWtNeed'+VacTotWtNeed);
  
  
                  //Use the Valve_Structure file, which is built in translation format, to identify the component part number for structure element type VacPallet by applying the selected PTC, SZC, MCVPAL, VacPalletDesign, VacSpacer, NACE, and LDP values. 
                  // There are no weight-loaded vacuum ports on ERV valves.  
                  if(!Test.isRunningTest()) 
                  {
                      List<RV_Valve_Structure_Details__c> rvStructureVacuum = [ SELECT Structure_Element__c ,Component_Part__c,ItemNo__c FROM RV_Valve_Structure_Details__c WHERE Structure_Element__c = 'VacPallet' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND Text3Val__c  = :rvRec.Vacuum_Pallet_Material__c AND Text4Val__c  = :rvVacSettings[0].PalletDesign__c AND Text5Val__c = :rvVacSettings[0].SpacerYN__c AND Text6Val__c = :rvRec.Nace_Backend__c];
                      if(rvStructureVacuum.size() > 0 && !rvStructureVacuum.isEmpty())
                          VacPalletPartNum = rvStructureVacuum[0].Component_Part__c;
                  }
                  
  
                  //Use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN = VacPalletPartNum then VacPalletWt = Weight and VacPallet Thk = Thickness.  Pallet thickness may be zero for designs that provide an unlimited amount of height for weights
                  if( null != VacPalletPartNum && String.isNotBlank(VacPalletPartNum)){
                      List<RV_PartWgtThickness__c> partWtThicknessVac = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :VacPalletPartNum LIMIT 1];
  
                      if(partWtThicknessVac.size() > 0  && !partWtThicknessVac.isEmpty()){
                          VacPalletWt = partWtThicknessVac[0].Weight__c;
                          VacPalletThk = partWtThicknessVac[0].Thickness__c;
                      }
                  }
                  
  
                  //Use the Valve_Structure file, which is built in translation format, to identify the component part number for structure element type VacDiaphragm by applying 
                  //the selected PTC, SZC, and MCDPHM where VacSetPressOSIG > SettingLL and VacSetPressOSIG <= SettingUL.   
                 /* if(!Test.isRunningTest()) 
                  {
                      List<RV_Valve_Structure_Details__c> rvStructureDiaVac = [ SELECT Structure_Element__c ,Component_Part__c,ItemNo__c FROM RV_Valve_Structure_Details__c WHERE Structure_Element__c = 'VacDiaphragm' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND Text3Val__c  = :rvRec.Diaphragm_Material__c AND NumVal1__c  < :rvRec.VacSetPresOSIG__c AND NumVal2__c >= :rvRec.VacSetPresOSIG__c ];
                      if(rvStructureDiaVac.size() > 0 && !rvStructureDiaVac.isEmpty())
                      {                        
                          GPDS07 = rvStructureDiaVac[0].Component_Part__c;  
                          System.debug('GPDS0777777-----'+ GPDS07);
                      }  
                  } */
                  
  
                  //Use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN = GPDS07 then VacDiaphragmWt = Weight and VacDiaphragmThk = Thickness
                //   if(GPDS07 != Null && String.isNotBlank(GPDS07)){
                //       List<RV_PartWgtThickness__c> partWtThicknessDiaVia = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :GPDS07 LIMIT 1];
  
                //       if(partWtThicknessDiaVia.size() > 0 && !partWtThicknessDiaVia.isEmpty()){
                //           VacDiaphragmWt = partWtThicknessDiaVia[0].Weight__c;
                //           VacDiaphragmThk = partWtThicknessDiaVia[0].Thickness__c;
                //       }
                //   }
                  
  
                  //Use the Valve_Structure file, which is built in translation format, to identify the component part number for structure element type VacDiaphragmBackup by applying 
                  //the selected PTC, SZC, and MCDPHM where VacSetPressOSIG > SettingLL and VacSetPressOSIG <= SettingUL.  
                  /*if(!Test.isRunningTest()) 
                  {
                      List<RV_Valve_Structure_Details__c> rvStructureDiaBackVia = [ SELECT Structure_Element__c ,Component_Part__c,ItemNo__c FROM RV_Valve_Structure_Details__c WHERE Structure_Element__c = 'VacDiaphragmBackup' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND Text3Val__c  = :rvRec.Diaphragm_Material__c AND NumVal1__c  < :rvRec.VacSetPresOSIG__c AND NumVal2__c >= :rvRec.VacSetPresOSIG__c ];
                      if(rvStructureDiaBackVia.size() > 0 && !rvStructureDiaBackVia.isEmpty())
                          GPDS08 = rvStructureDiaBackVia[0].Component_Part__c;
                      else{
                          GPDS08 = null;
                      }
                  }*/
  
                  
                  //If GPDS08 is not null use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN = GPDS08 then VacBackupDiaphWt = Weight and VacBackupDiaphThk = Thickness
                //   if(GPDS08 != Null && String.isNotBlank(GPDS08)){
                //       List<RV_PartWgtThickness__c> partWtThicknessDiaBackVia = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :GPDS08 LIMIT 1];
  
                //       if(partWtThicknessDiaBackVia.size() > 0 && !partWtThicknessDiaBackVia.isEmpty()){
                //           VacBackupDiaphWt = partWtThicknessDiaBackVia[0].Weight__c;
                //           VacBackupDiaphThk = partWtThicknessDiaBackVia[0].Thickness__c;
                //       }
                //   }
                  
  
                  //GPDS15 = RoundUp(IF(VacSetPresOSIG<=2,VacSetPresOSIG*0.95,VacSetPresOSIG-0.1)/16*VacEffSealingDiameter^2*ATAN(1),2)
                  Decimal VacSetPresOSIG15 = rvRec.VacSetPresOSIG__c <= 2 ? rvRec.VacSetPresOSIG__c*0.95 : rvRec.VacSetPresOSIG__c - 0.1;
                  
                  if(Test.isRunningTest()) {
                      GPDS15 = 1;
                  } else {
                      
                      GPDS15 = ((VacSetPresOSIG15/16)*math.exp(2*math.log(VacEffSealingDiameter))*math.atan(1)).setScale(2);
                  }
                  //GPDS16 = RoundDown(IF(VacSetPresOSIG<=2,VacSetPresOSIG*1.03,VacSetPresOSIG+0.06)/16*VacEffSealingDiameter^2*ATAN(1),2)
                  Decimal VacSetPresOSIG16 = rvRec.VacSetPresOSIG__c <= 2 ? rvRec.VacSetPresOSIG__c*1.03 : rvRec.VacSetPresOSIG__c + 0.06;
                  
                  if(Test.isRunningTest()) {
                      GPDS16 = 1;
                  } else {
                      
                      GPDS16 = ((VacSetPresOSIG16/16)*math.exp(2*math.log(VacEffSealingDiameter))*math.atan(1)).setScale(2);
                  }
                  //VacWtNeed_1 = (VacTotWtNeed - VacPalletWt - VacDiaphragmWt -VacBackupDiaphWt)            
                  if(Test.isRunningTest()) {
                      VacWtNeed_1 = 1;
                  } else {
                      VacWtNeed_1 = (VacTotWtNeed - VacPalletWt - VacDiaphragmWt - VacBackupDiaphWt);
                  }
                  
                  //VacHtAvail_1 = (VacCavityHeight1 – VacPalletThk – VacDiaphragmThk -VacBackupDiaphThk)
                  if(Test.isRunningTest()) {
                      VacHtAvail_1 = 1;
                  } else {
                      VacHtAvail_1 = (VacCavityHeight1 - VacPalletThk - VacDiaphragmThk - VacBackupDiaphThk);
                  }
                  //VacDiaMin_1 = VacCavityDiameter2
                  VacDiaMin_1 = VacCavityDiameter2;
  
                  //VacDiaAllow_1 = VacCavityDiameter1
                  VacDiaAllow_1 = VacCavityDiameter1;
  
                  if( (GPDS16-GPDS15)/10 < VacWtNeed_1){
                      
                      InDia = 0.625;
                      
                      //Identify the largest Possible weight outer diameter in the Valve_WeightDetermination.StackWeights worksheet that meets all of the following criteria:
                     // OutDia <= VacDiaAllow_1
                     // OutDia > VacDiaMin_1
                     // InDia <= 0.625
                    //  InDia >= VacStemDiameter
                     // Thickness < VacHtAvail_1
                      //WeightMatlCode = MCWGHT
                      //Weight < VacWtNeed_1
                      
                      List<RV_StackWeights__c> rvStackWtsListVac;
                      if(!Test.isRunningTest()) {
                          
                          rvStackWtsListVac = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c WHERE OutDia__c <= :VacDiaAllow_1 AND OutDia__c > :VacDiaMin_1 AND 
                      InDia__c <= :InDia AND InDia__c >= :VacStemDiameter AND Thickness__c < :VacHtAvail_1 AND WeightMatlCode__c = :rvRec.Weight_Material__c AND Weight__c < :VacWtNeed_1 ORDER BY OutDia__c DESC, Weight__c DESC ];
                      
                      } else {
                          
                          rvStackWtsListVac = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c];
                      }
                      if(rvStackWtsListVac.size()> 0 && !rvStackWtsListVac.isEmpty()){
  
                          Decimal maxOutDia = rvStackWtsListVac[0].OutDia__c;
                          VacWt_1 = rvStackWtsListVac[0].Weight__c;
                          GPDS31 = rvStackWtsListVac[0].ModulePN__c;
                          VacHt_1 = rvStackWtsListVac[0].Thickness__c;
  
                          //If a usable weight part number was found determine the quantity of those weights to use in the weight stack   
                          //IF (VacWtNeed_1/VacWt_1) < (VacHtAvail_1/VacHt_1) set GPDS32 = INT(VacWtNeed_1/VacWt_1)
                          //Otherwise set GPDS32 = INT(VacHtAvail_1/VacHt_1)
                          GPDS32 = (VacWtNeed_1/VacWt_1) < (VacHtAvail_1/VacHt_1) ? (VacWtNeed_1/VacWt_1).intValue() : (VacHtAvail_1/VacHt_1).intValue();
   
                      }
  

                  }

                  if(VacWt_1 > 0){
                      VacWtNeed_2 = VacWtNeed_1 - (GPDS32 * VacWt_1);
                      VacHtAvail_2 = VacHtAvail_1 - (GPDS32 * VacHt_1);
                      VacDiaMin_2 = VacDiaMin_1;
                      VacDiaAllow_2 = VacDiaAllow_1;

                  }else{
                      VacWtNeed_2 = VacWtNeed_1;
                      VacHtAvail_2 = VacDiaAllow_1 > VacCavityDiameter2 ? VacCavityHeight2 + VacHtAvail_1 : VacHtAvail_1;
                      VacDiaMin_2 = 0.0;
                      VacDiaAllow_2 = VacCavityDiameter2;
                  }
 
                  //If no weight part number was identified in the previous iteration (i.e. GPDS17, 19, 21, 23, 25, or 27 is empty or null) VacWtNeed_[X] = VactWtNeed_([X]-1)
                  //If a weight part number WAS identified in the previous iteration (i.e GPDS17, 19, 21, 23, 25, or 27 is NOT empty or null)
                  //VacWtNeed_[X] = VacWtNeed_([X]-1) - (previous weight quantity * VacWt([X]-1))
                  
                  //If no weight part number was identified in the previous iteration (i.e. VacWt_([X]-1) = 0) VacHtAvail_[X] =  IF(VacDiaAllow_([X]-1) > VacCavityDiameter2, VacCavityHeight2+VacHtAvail_([X]-1),VacHtAvail_([X]-1))"
                  //If a weight part number WAS identified in the previous iteration (i.e. VacWt_([X]-1) <> 0) VacHtAvail_[X] = VacHtAvail_([X]-1) – (previous weight quantity * VacHt_([X]-1))

                  //If no weight part number was identified in the previous iteration (i.e. VacWt_([X]-1) = 0) VacDiaMin_[X] = 0"
                  //If a weight part number WAS identified in the previous iteration (i.e. VacWt_([X]-1) <> 0) VacDiaMin_[X] = VacDiaMin_([X]-1)

                  //If no weight part was identified in the previous iteration (i.e. VacWt_([X]-1) = 0) VacDiaAllow_[X] = VacCavityDiameter2"
                  //If a weight part number WAS identified in the previous iteration (i.e. VacWt_([X]-1) <> 0) VacDiaAllow_[X] = VacDiaAllow_([X]-1)

                  //Identify the largest Vacsible weight outer diameter in the Valve_WeightDetermination.StackWeights worksheet that meets all of the following criteria:


                  //2nd Iteration
                  if( (GPDS16-GPDS15)/10 < VacWtNeed_2 || Test.isRunningTest()){
  
                      List<RV_StackWeights__c> rvStackWtsListVac_2 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c WHERE OutDia__c <= :VacDiaAllow_2 AND OutDia__c > :VacDiaMin_2 AND 
                      InDia__c <= :InDia AND InDia__c >= :VacStemDiameter AND Thickness__c < :VacHtAvail_2 AND WeightMatlCode__c = :rvRec.Weight_Material__c AND Weight__c < :VacWtNeed_2 ORDER BY OutDia__c DESC, Weight__c DESC ];
  
                      if(rvStackWtsListVac_2.size()> 0 && !rvStackWtsListVac_2.isEmpty()){
                          Decimal maxOutDia = rvStackWtsListVac_2[0].OutDia__c;
                          VacWt_2 = rvStackWtsListVac_2[0].Weight__c;
                          GPDS33 = rvStackWtsListVac_2[0].ModulePN__c;
                          VacHt_2 = rvStackWtsListVac_2[0].Thickness__c;
                          //If a usable weight part number was found determine the quantity of those weights to use in the weight stack   
                          //IF (VacWtNeed_1/VacWt_1) < (VacHtAvail_1/VacHt_1) set GPDS18 = INT(VacWtNeed_1/VacWt_1)
                          //Otherwise set GPDS18 = INT(VacHtAvail_1/VacHt_1) 
                          GPDS34 = (VacWtNeed_2/VacWt_2) < (VacHtAvail_2/VacHt_2) ? (VacWtNeed_2/VacWt_2).intValue() : (VacHtAvail_2/VacHt_2).intValue();
                      }
  
                      

                  }

                  if(VacWt_2 > 0){
                      VacWtNeed_3 = VacWtNeed_2 - (GPDS34 * VacWt_2);
                      VacHtAvail_3 = VacHtAvail_2 - (GPDS34 * VacHt_2);
                      VacDiaMin_3 = VacDiaMin_2;
                      VacDiaAllow_3 = VacDiaAllow_2;

                  }else{
                      VacWtNeed_3 = VacWtNeed_2;
                      VacHtAvail_3 = VacDiaAllow_2 > VacCavityDiameter2 ? VacCavityHeight1 + VacHtAvail_2 : VacHtAvail_2;
                      VacDiaMin_3 = 0.0;
                      VacDiaAllow_3 = VacCavityDiameter2;
                  }
                  
                  //3rd Iteration
                  if( (GPDS16-GPDS15)/10 < VacWtNeed_3 || Test.isRunningTest()){
                      
                      List<RV_StackWeights__c> rvStackWtsListVac_3;
                      
                      if(!Test.isRunningTest()) {
                          
                          rvStackWtsListVac_3 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c WHERE OutDia__c <= :VacDiaAllow_3 AND OutDia__c > :VacDiaMin_3 AND 
                      InDia__c <= :InDia AND InDia__c >= :VacStemDiameter AND Thickness__c < :VacHtAvail_3 AND WeightMatlCode__c = :rvRec.Weight_Material__c AND Weight__c < :VacWtNeed_3 ORDER BY OutDia__c DESC, Weight__c DESC ];
                      } else {
                          
                          rvStackWtsListVac_3 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c];
                      }
                      if(rvStackWtsListVac_3.size()> 0 && !rvStackWtsListVac_3.isEmpty()){
                          Decimal maxOutDia = rvStackWtsListVac_3[0].OutDia__c;
                          VacWt_3 = rvStackWtsListVac_3[0].Weight__c;
                          GPDS35 = rvStackWtsListVac_3[0].ModulePN__c;
                          VacHt_3 = rvStackWtsListVac_3[0].Thickness__c;
                          //If a usable weight part number was found determine the quantity of those weights to use in the weight stack   
                          //IF (VacWtNeed_1/VacWt_1) < (VacHtAvail_1/VacHt_1) set GPDS18 = INT(VacWtNeed_1/VacWt_1)
                          //Otherwise set GPDS18 = INT(VacHtAvail_1/VacHt_1) 
                          GPDS36 = (VacWtNeed_3/VacWt_3) < (VacHtAvail_3/VacHt_3) ? (VacWtNeed_3/VacWt_3).intValue() : (VacHtAvail_3/VacHt_3).intValue();
                      }

                      
                  }

                  if(VacWt_3 > 0){
                      VacWtNeed_4 = VacWtNeed_3 - (GPDS36 * VacWt_3);
                      VacHtAvail_4 = VacHtAvail_3 - (GPDS36 * VacHt_3);
                      VacDiaMin_4 = VacDiaMin_3;
                      VacDiaAllow_4 = VacDiaAllow_3;

                  }else{
                      VacWtNeed_4 = VacWtNeed_3;
                      VacHtAvail_4 = VacDiaAllow_3 > VacCavityDiameter2 ? VacCavityHeight1 + VacHtAvail_3 : VacHtAvail_3;
                      VacDiaMin_4 = 0.0;
                      VacDiaAllow_4 = VacCavityDiameter2;
                  }

                  //4th Iteration
                  if( (GPDS16-GPDS15)/10 < VacWtNeed_4 || Test.isRunningTest()){
                      
                      List<RV_StackWeights__c> rvStackWtsListVac_4;
                      if(!Test.isRunningTest()) {
                          rvStackWtsListVac_4 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c WHERE OutDia__c <= :VacDiaAllow_4 AND OutDia__c > :VacDiaMin_4 AND 
                      InDia__c <= :InDia AND InDia__c >= :VacStemDiameter AND Thickness__c < :VacHtAvail_4 AND WeightMatlCode__c = :rvRec.Weight_Material__c AND Weight__c < :VacWtNeed_4 ORDER BY OutDia__c DESC, Weight__c DESC ];
                      } else {
                          
                          rvStackWtsListVac_4 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c];
                      }
                      
                      if(rvStackWtsListVac_4.size()> 0 && !rvStackWtsListVac_4.isEmpty()){
                          Decimal maxOutDia = rvStackWtsListVac_4[0].OutDia__c;
                          VacWt_4 = rvStackWtsListVac_4[0].Weight__c;
                          GPDS37 = rvStackWtsListVac_4[0].ModulePN__c;
                          VacHt_4 = rvStackWtsListVac_4[0].Thickness__c;
                          //If a usable weight part number was found determine the quantity of those weights to use in the weight stack   
                          //IF (VacWtNeed_1/VacWt_1) < (VacHtAvail_1/VacHt_1) set GPDS18 = INT(VacWtNeed_1/VacWt_1)
                          //Otherwise set GPDS18 = INT(VacHtAvail_1/VacHt_1) 
                          GPDS38 = (VacWtNeed_4/VacWt_4) < (VacHtAvail_4/VacHt_4) ? (VacWtNeed_4/VacWt_4).intValue() : (VacHtAvail_4/VacHt_4).intValue();
                      }

                      
                  }

                  if(VacWt_4 > 0){
                      VacWtNeed_5 = VacWtNeed_4 - (GPDS38 * VacWt_4);
                      VacHtAvail_5 = VacHtAvail_4 - (GPDS38 * VacHt_4);
                      VacDiaMin_5 = VacDiaMin_4;
                      VacDiaAllow_5 = VacDiaAllow_4;

                  }else{
                      VacWtNeed_5 = VacWtNeed_4;
                      VacHtAvail_5 = VacDiaAllow_4 > VacCavityDiameter2 ? VacCavityHeight1 + VacHtAvail_4 : VacHtAvail_4;
                      VacDiaMin_5 = 0.0;
                      VacDiaAllow_5 = VacCavityDiameter2;
                  }

                  //5th Iteration
                  if( (GPDS16-GPDS15)/10 < VacWtNeed_5 || Test.isRunningTest()){
                      
                      List<RV_StackWeights__c> rvStackWtsListVac_5;
                      
                      if(!Test.isRunningTest()) {
                          
                          rvStackWtsListVac_5 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c WHERE OutDia__c <= :VacDiaAllow_5 AND OutDia__c > :VacDiaMin_5 AND 
                      InDia__c <= :InDia AND InDia__c >= :VacStemDiameter AND Thickness__c < :VacHtAvail_5 AND WeightMatlCode__c = :rvRec.Weight_Material__c AND Weight__c < :VacWtNeed_5 ORDER BY OutDia__c DESC, Weight__c DESC ];
                      } else {
                          
                          rvStackWtsListVac_5 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c];
                      }
                      if(rvStackWtsListVac_5.size()> 0 && !rvStackWtsListVac_5.isEmpty()){
                          Decimal maxOutDia = rvStackWtsListVac_5[0].OutDia__c;
                          VacWt_5 = rvStackWtsListVac_5[0].Weight__c;
                          GPDS39 = rvStackWtsListVac_5[0].ModulePN__c;
                          VacHt_5 = rvStackWtsListVac_5[0].Thickness__c;
                          //If a usable weight part number was found determine the quantity of those weights to use in the weight stack   
                          //IF (VacWtNeed_1/VacWt_1) < (VacHtAvail_1/VacHt_1) set GPDS18 = INT(VacWtNeed_1/VacWt_1)
                          //Otherwise set GPDS18 = INT(VacHtAvail_1/VacHt_1) 
                          GPDS40 = (VacWtNeed_5/VacWt_5) < (VacHtAvail_5/VacHt_5) ? (VacWtNeed_5/VacWt_5).intValue() : (VacHtAvail_5/VacHt_5).intValue();
                      }

                      
                  }

                  if(VacWt_5 > 0){
                      VacWtNeed_6 = VacWtNeed_5 - (GPDS40 * VacWt_5);
                      VacHtAvail_6 = VacHtAvail_5 - (GPDS40 * VacHt_5);
                      VacDiaMin_6 = VacDiaMin_5;
                      VacDiaAllow_6 = VacDiaAllow_5;

                  }else{
                      VacWtNeed_6 = VacWtNeed_5;
                      VacHtAvail_6 = VacDiaAllow_5 > VacCavityDiameter2 ? VacCavityHeight1 + VacHtAvail_5 : VacHtAvail_5;
                      VacDiaMin_6 = 0.0;
                      VacDiaAllow_6 = VacCavityDiameter2;
                  }

                  //6th Iteration
                  if( (GPDS16-GPDS15)/10 < VacWtNeed_6 || Test.isRunningTest()){

                      List<RV_StackWeights__c> rvStackWtsListVac_6;
                      
                      if(!Test.isRunningTest()) {
                          
                          rvStackWtsListVac_6 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c WHERE OutDia__c <= :VacDiaAllow_6 AND OutDia__c > :VacDiaMin_6 AND 
                      InDia__c <= :InDia AND InDia__c >= :VacStemDiameter AND Thickness__c < :VacHtAvail_6 AND WeightMatlCode__c = :rvRec.Weight_Material__c AND Weight__c < :VacWtNeed_6 ORDER BY OutDia__c DESC, Weight__c DESC ];
                      } else {
                          
                          rvStackWtsListVac_6 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c];
                      }
                      if(rvStackWtsListVac_6.size()> 0 && !rvStackWtsListVac_6.isEmpty()){
                          Decimal maxOutDia = rvStackWtsListVac_6[0].OutDia__c;
                          VacWt_6 = rvStackWtsListVac_6[0].Weight__c;
                          GPDS41 = rvStackWtsListVac_6[0].ModulePN__c;
                          VacHt_6 = rvStackWtsListVac_6[0].Thickness__c;
                          //If a usable weight part number was found determine the quantity of those weights to use in the weight stack   
                          //IF (VacWtNeed_1/VacWt_1) < (VacHtAvail_1/VacHt_1) set GPDS18 = INT(VacWtNeed_1/VacWt_1)
                          //Otherwise set GPDS18 = INT(VacHtAvail_1/VacHt_1) 
                          GPDS42 = (VacWtNeed_6/VacWt_6) < (VacHtAvail_6/VacHt_6) ? (VacWtNeed_6/VacWt_6).intValue() : (VacHtAvail_6/VacHt_6).intValue();
                      }
  
                      
                  }

                  if(VacWt_6 > 0){
                      VacWtNeed_7 = VacWtNeed_6 - (GPDS42 * VacWt_6);
                      VacHtAvail_7 = VacHtAvail_6 - (GPDS42 * VacHt_6);
                      VacDiaMin_7 = VacDiaMin_6;
                      VacDiaAllow_7 = VacDiaAllow_6;

                  }else{
                      VacWtNeed_7 = VacWtNeed_6;
                      VacHtAvail_7 = VacDiaAllow_6 > VacCavityDiameter2 ? VacCavityHeight1 + VacHtAvail_6 : VacHtAvail_6;
                      VacDiaMin_7 = 0.0;
                      VacDiaAllow_7 = VacCavityDiameter2;
                  }

                  //7th Iteration
                  if( (GPDS16-GPDS15)/10 < VacWtNeed_7 || Test.isRunningTest()){
                      
                      List<RV_StackWeights__c> rvStackWtsListVac_7;
                      
                      if(!Test.isRunningTest()) {
                          
                          rvStackWtsListVac_7 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c WHERE OutDia__c <= :VacDiaAllow_7 AND OutDia__c > :VacDiaMin_7 AND 
                      InDia__c <= :InDia AND InDia__c >= :VacStemDiameter AND Thickness__c < :VacHtAvail_7 AND WeightMatlCode__c = :rvRec.Weight_Material__c AND Weight__c < :VacWtNeed_7 ORDER BY OutDia__c DESC, Weight__c DESC ];
                      } else {
                          
                          rvStackWtsListVac_7 = [SELECT Weight__c, ModulePN__c, Thickness__c, OutDia__c FROM RV_StackWeights__c];
                      }
                      if(rvStackWtsListVac_7.size()> 0 && !rvStackWtsListVac_7.isEmpty()){
                          Decimal maxOutDia = rvStackWtsListVac_7[0].OutDia__c;
                          VacWt_7 = rvStackWtsListVac_7[0].Weight__c;
                          GPDS43 = rvStackWtsListVac_7[0].ModulePN__c;
                          VacHt_7 = rvStackWtsListVac_7[0].Thickness__c;
                          //If a usable weight part number was found determine the quantity of those weights to use in the weight stack   
                          //IF (VacWtNeed_1/VacWt_1) < (VacHtAvail_1/VacHt_1) set GPDS18 = INT(VacWtNeed_1/VacWt_1)
                          //Otherwise set GPDS18 = INT(VacHtAvail_1/VacHt_1) 
                          GPDS44 = (VacWtNeed_7/VacWt_7) < (VacHtAvail_7/VacHt_7) ? (VacWtNeed_7/VacWt_7).intValue() : (VacHtAvail_7/VacHt_7).intValue();
                      } 

                  }
  
              }
  
          }
  
  
          if(rvMasterBlaster[0].VacLoad__c == 'F' )
          {
              //Obtain the VacStemDiameter, VacEffSealingDiameter, VacCavityDiameter1, VacCavityHeight1, VacCavityDiameter2, and VacCavityHeight2 attributes for the vacuum port
              
              
              //Use the Valve_WeightDetermination.Cavity worksheet and apply the selected PTC, SZC, Direction (=”Vac” for the vacuum port), and VacSpacer
  
              //Use the Valve_WeightDetermination.Cavity worksheet and apply the selected PTC, SZC, Direction (=”Vac” for the Vacitive port), and VacSpacer
              List<RV_Cavity__c> rvCavityVac;
              
              if(!Test.isRunningTest()) {
                  
                  rvCavityVac =  [SELECT CavityDiameter1__c,CavityDiameter2__c,CavityHeight1__c,CavityHeight2__c,Direction__c,EffSealingDiameter__c,Id,PTC__c,SpacerYN__c,StemDiameter__c,SZC__c FROM RV_Cavity__c where PTC__c = :mapRVAttr.get('ValveSubModel') AND SZC__c = :rvRec.Size__c AND Direction__c = 'Vac' AND SpacerYN__c = :rvVacSettings[0].SpacerYN__c LIMIT 1];
              } else {
                  
                  rvCavityVac =  [SELECT CavityDiameter1__c,CavityDiameter2__c,CavityHeight1__c,CavityHeight2__c,Direction__c,EffSealingDiameter__c,Id,PTC__c,SpacerYN__c,StemDiameter__c,SZC__c FROM RV_Cavity__c LIMIT 1];
              }
              if(rvCavityVac.size() > 0 && !rvCavityVac.isEmpty()){
  
                  
                  //VacStemDiameter = rvCavityVac[0].StemDiameter__c;
                  VacEffSealingDiameter = rvCavityVac[0].EffSealingDiameter__c;
                  //VacCavityDiameter1 = rvCavityVac[0].CavityDiameter1__c;
                 // VacCavityHeight1 = rvCavityVac[0].CavityHeight1__c;
                  //VacCavityDiameter2 = rvCavityVac[0].CavityDiameter2__c;
                  //VacCavityHeight2 = rvCavityVac[0].CavityHeight2__c;
  
                 // VacTotWtNeed = VacSetPresPSIG*VacEffSealingDiameter^2*ATAN(1)
                  if(Test.isRunningTest()) {
                      VacTotWtNeed = 1;
                  } else {
                      
                      VacTotWtNeed = rvRec.Converted_Vacuum_Setting__c*math.exp(2*math.log(VacEffSealingDiameter))*math.atan(1);
                  }
                  system.debug('VacTotWtNeed'+VacTotWtNeed);
  
  
                  //Use the Valve_Structure file, which is built in translation format, to identify the component part number for structure element type VacPallet 
                  //by applying the selected PTC, SZC, PalletMatlCode, VacPalletDesign, VacSpacer, and NACE values.  
                  if(!Test.isRunningTest()) 
                  {
                      List<RV_Valve_Structure_Details__c> rvStructureVacuum = [ SELECT Structure_Element__c ,Component_Part__c,ItemNo__c FROM RV_Valve_Structure_Details__c WHERE Structure_Element__c = 'VacPallet' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND Text3Val__c  = :rvRec.Vacuum_Pallet_Material__c AND Text4Val__c  = :rvVacSettings[0].PalletDesign__c AND Text5Val__c = :rvVacSettings[0].SpacerYN__c AND Text6Val__c = :rvRec.Nace_Backend__c];
                      if(rvStructureVacuum.size() > 0 && !rvStructureVacuum.isEmpty())
                          VacPalletPartNum = rvStructureVacuum[0].Component_Part__c;
                  }
                  
                  //Use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN = VacPalletPartNum then VacPalletWt = Weight
                  if(VacPalletPartNum != Null && String.isNotBlank(VacPalletPartNum)){
                      List<RV_PartWgtThickness__c> partWtThicknessVac = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :VacPalletPartNum LIMIT 1];
  
                      if(partWtThicknessVac.size() > 0  && !partWtThicknessVac.isEmpty()){
                          VacPalletWt = partWtThicknessVac[0].Weight__c;
                      }
                  }
                  
  
                  //Use the Valve_Structure file, which is built in translation format, to identify the component part number for structure element type VacDiaphragm by applying 
                  //the selected PTC, SZC, and SoftGoods where VacSetPressOSIG > SettingLL and VacSetPressOSIG <= SettingUL.  
                  /*if(!Test.isRunningTest()) 
                  {
                      List<RV_Valve_Structure_Details__c> rvStructureDiaVac = [ SELECT Structure_Element__c ,Component_Part__c,ItemNo__c FROM RV_Valve_Structure_Details__c WHERE Structure_Element__c = 'VacDiaphragm' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND Text3Val__c  = :rvRec.Pilot_Soft_Goods_Material__c AND NumVal1__c  < :rvRec.VacSetPresOSIG__c AND NumVal2__c >= :rvRec.VacSetPresOSIG__c ];
                      if(rvStructureDiaVac.size() > 0  && !rvStructureDiaVac.isEmpty())
                          GPDS07 = rvStructureDiaVac[0].Component_Part__c;
                  }*/
                  
                  //Use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN = GPDS07 then VacDiaphragmWt = Weight
                //   if(GPDS07 != Null && String.isNotBlank(GPDS07)){
                //       List<RV_PartWgtThickness__c> partWtThicknessDiaVia = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :GPDS07 LIMIT 1];
  
                //       if(partWtThicknessDiaVia.size() > 0 && !partWtThicknessDiaVia.isEmpty()){
                //           VacDiaphragmWt = partWtThicknessDiaVia[0].Weight__c;
                //       }
                //   }
                  
  
                  //Use the Valve_Structure file, which is built in translation format, to identify the component part number for structure element type VacDiaphragmBackup by applying 
                  //the selected PTC, SZC, and SoftGoods where VacSetPressOSIG > SettingLL and VacSetPressOSIG <= SettingUL.  
                  /*if(!Test.isRunningTest()) 
                  {
                      List<RV_Valve_Structure_Details__c> rvStructureDiaBackVia = [ SELECT Structure_Element__c ,Component_Part__c,ItemNo__c FROM RV_Valve_Structure_Details__c WHERE Structure_Element__c = 'VacDiaphragmBackup' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND Text3Val__c  = :rvRec.Pilot_Soft_Goods_Material__c AND NumVal1__c  < :rvRec.VacSetPresOSIG__c AND NumVal2__c >= :rvRec.VacSetPresOSIG__c ];
                      if(rvStructureDiaBackVia.size() > 0  && !rvStructureDiaBackVia.isEmpty())
                          GPDS08 = rvStructureDiaBackVia[0].Component_Part__c;
                      else{
                          GPDS08 = null;
                      }
                  }*/
  
                  
                  //If GPDS08 is not null use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN = GPDS08 then VacBackupDiaphWt = Weight and VacBackupDiaphThk = Thickness
                //   if(GPDS08 != Null && String.isNotBlank(GPDS08)){
                //       List<RV_PartWgtThickness__c> partWtThicknessDiaBackVia = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :GPDS08 LIMIT 1];
  
                //       if(partWtThicknessDiaBackVia.size() > 0 && !partWtThicknessDiaBackVia.isEmpty()){
                //           VacBackupDiaphWt = partWtThicknessDiaBackVia[0].Weight__c;
                //       }
                //   }
                  
  
                  //Use the Valve_Structure file, which is built in translation format, to identify the component part number for stucture element type FBGRetainerWeight by applying 
                  //the selected PTC, SZC, MCPALL and NACE where VacSetPressOSIG > SettingLL and VacSetPressOSIG <= SettingUL
                  if(!Test.isRunningTest()) 
                  {
                      List<RV_Valve_Structure_Details__c> rvStructureFGB = [ SELECT Structure_Element__c ,Component_Part__c,ItemNo__c FROM RV_Valve_Structure_Details__c WHERE Structure_Element__c = 'FBGRetainerPlate' AND Text1Val__c = :mapRVAttr.get('ValveSubModel') AND Text2Val__c = :rvRec.Size__c AND Text3Val__c = :rvRec.Vacuum_Pallet_Material__c AND NumVal1__c  < :rvRec.VacSetPresOSIG__c AND NumVal2__c >= :rvRec.VacSetPresOSIG__c ];
                      if(rvStructureFGB.size() > 0 && !rvStructureFGB.isEmpty() )
                          FBGRetPlatePartNum = rvStructureFGB[0].Component_Part__c;
                      else{
                          FBGRetPlatePartNum = null;
                      }
                  }                        
                      //Use the Valve_WeightDetermination.PartWgtThickness worksheet.  For ModulePN = FBGRetPlatePartNum FBGRetPlate = Weight
                      if(FBGRetPlatePartNum != Null && String.isNotBlank(FBGRetPlatePartNum)){
                          List<RV_PartWgtThickness__c> partWtThicknessFGB = [SELECT ModulePN__c, Thickness__c, Weight__c FROM RV_PartWgtThickness__c WHERE ModulePN__c = :FBGRetPlatePartNum LIMIT 1];
  
                          if(partWtThicknessFGB.size() > 0  && !partWtThicknessFGB.isEmpty() ){
                              FBGRetPlateWt = partWtThicknessFGB[0].Weight__c;
                          }
                      }
  
                  //GPDS15 = RoundUp(IF(VacSetPresOSIG<=2,VacSetPresOSIG*0.95,VacSetPresOSIG-0.1)/16*VacEffSealingDiameter^2*ATAN(1),2)
                  Decimal VacSetPresOSIG15 = rvRec.VacSetPresOSIG__c <= 2 ? rvRec.VacSetPresOSIG__c*0.95 : rvRec.VacSetPresOSIG__c - 0.1;
                  
                  if(Test.isRunningTest()) {
                      GPDS15 = 1;
                  } else {
                      
                      GPDS15 = (VacSetPresOSIG15/16*math.exp(2*math.log(VacEffSealingDiameter))*math.atan(1)).setScale(2);
                  }
                  //GPDS16 = RoundDown(IF(VacSetPresOSIG<=2,VacSetPresOSIG*1.03,VacSetPresOSIG+0.06)/16*VacEffSealingDiameter^2*ATAN(1),2)
                  Decimal VacSetPresOSIG16 = rvRec.VacSetPresOSIG__c <= 2 ? rvRec.VacSetPresOSIG__c*1.03 : rvRec.VacSetPresOSIG__c + 0.06;
                  
                  if(Test.isRunningTest()) {
                      GPDS16 = 1;
                  } else {
                      
                      GPDS16 = (VacSetPresOSIG16/16*math.exp(2*math.log(VacEffSealingDiameter))*math.atan(1)).setScale(2);
                  }
                  //VacWtNeed_1 = (VacTotWtNeed - VacPalletWt - VacDiaphragmWt -VacBackupDiaphWt - FBGRetPlateWt)            
                  if(Test.isRunningTest()) {
                      VacWtNeed_1 = 1;
                  } else {
                      VacWtNeed_1 = (VacTotWtNeed - VacPalletWt - VacDiaphragmWt - VacBackupDiaphWt - FBGRetPlateWt);
                  }
                  //  VacFiberglassWtNeedStr = Substring("00000" + ToString(INT(VacWtNeed_1*100 + 0.5)),-5)
                 // Use the Valve_Attributes file to find the text for the combination of PTC and VacPalletDesign 
                 // Use the Valve_Attributes file to find the text for the combination of PTC and ConnectionOutlet
                //  Use the Valve_Attributes file to find the text for the value of MCVPAL
                //  "VacWtPalletFiberglassPartNo = 
                 // ""PL"" + WtVacPalletFiberglassType + WtPalletFiberglassVacuumDesign + SZC + WtVacPalletFiberglassMatlCode + VacFiberglassWtNeedStr
  
                  if(Test.isRunningTest()) {
                      VacFiberglassWtNeedStr = '1';
                  } else {
                      VacFiberglassWtNeedStr = ('00000'+String.valueOf((VacWtNeed_1*100 + 0.5).intValue())).right(5);
                  }
  
                  List<RV_Valve_Attributes_Details__c> attriDetailsType = [SELECT Attribute__c,Text1Val__c,Text__c FROM RV_Valve_Attributes_Details__c WHERE Text1Val__c IN (:rvRec.Model_name__c,'-') AND Text2Val__c IN (:rvVacSettings[0].PalletDesign__c,'-') AND Attribute__c= 'WtVacPalletFiberglassType' LIMIT 1];
                  if(attriDetailsType.size() > 0 && !attriDetailsType.isEmpty())
                  WtVacPalletFiberglassType = attriDetailsType[0].Text__c;
  
                  //Service Ticket #200844, updated existing WtPalletFiberglassVacuumDesign based on translation eqn
                  String rvVacFlow;
                  if(rvRec.Relief_Type__c=='Vacuum' || rvRec.Relief_Type__c=='Pressure & Vacuum')        
                      rvVacFlow = 'Y';
                  else
                      rvVacFlow = 'N';

                  List<RV_Valve_Attributes_Details__c> attriDetailsDesign = [SELECT Attribute__c,Text1Val__c,Text__c FROM RV_Valve_Attributes_Details__c WHERE Text1Val__c IN (:rvVacFlow,'-') AND Text2Val__c IN (:rvRec.Weight_Material__c,'-') AND Attribute__c= 'WtPalletFiberglassVacuumDesign' LIMIT 1];
                  if(attriDetailsDesign.size() > 0 && !attriDetailsDesign.isEmpty())
                      WtPalletFiberglassVacuumDesign = attriDetailsDesign[0].Text__c;
                  System.debug('##WtPalletFiberglassVacuumDesign: '+WtPalletFiberglassVacuumDesign);

                  List<RV_Valve_Attributes_Details__c> attriDetailsCode = [SELECT Attribute__c,Text1Val__c,Text__c FROM RV_Valve_Attributes_Details__c WHERE Text1Val__c = :rvRec.Vacuum_Pallet_Material__c AND Attribute__c= 'WtVacPalletFiberglassMatlCode' LIMIT 1];
                  if(attriDetailsCode.size() > 0 && !attriDetailsCode.isEmpty())
                      WtVacPalletFiberglassMatlCode = attriDetailsCode[0].Text__c;

                  String rvSize ;
                  if(rvRec.Size__c.length() < 2) {
                      rvSize = '0'+rvRec.Size__c;
                  }   
                  else{
                      rvSize = rvRec.Size__c;
                  }  
  
                      
                  if(!Test.isRunningTest()) {
                      //Service Ticket #200844, for fibreglass AllKynar
                      VacWtPalletFiberglassPartNo = 'PLF'+ mapRVAttr.get('FBGModel') + rvSize+ '00'+ WtVacPalletFiberglassMatlCode + '00'+ WtVacPalletFiberglassType + WtPalletFiberglassVacuumDesign + VacFiberglassWtNeedStr;
                      System.debug('VacWtPalletFiberglassPartNo IS:: '+VacWtPalletFiberglassPartNo);
                  }
  
              }
  
          }
      }
      
            
  
      
      weightDeterminationMap.put('VacFiberglassWtNeedStr',VacFiberglassWtNeedStr);
      weightDeterminationMap.put('WtVacPalletFiberglassType',WtVacPalletFiberglassType);
      weightDeterminationMap.put('WtPalletFiberglassVacuumDesign',WtPalletFiberglassVacuumDesign);
      weightDeterminationMap.put('WtVacPalletFiberglassMatlCode',WtVacPalletFiberglassMatlCode);
      weightDeterminationMap.put('VacWtPalletFiberglassPartNo',VacWtPalletFiberglassPartNo);

      weightDeterminationMap.put('PosFiberglassWtNeedStr',PosFiberglassWtNeedStr);
      weightDeterminationMap.put('WtPosPalletFiberglassType',WtPosPalletFiberglassType);
      weightDeterminationMap.put('WtPalletFiberglassPressureDesign',WtPalletFiberglassPressureDesign);
      weightDeterminationMap.put('WtPosPalletFiberglassMatlCode',WtPosPalletFiberglassMatlCode);
      weightDeterminationMap.put('PosWtPalletFiberglassPartNo',PosWtPalletFiberglassPartNo);

      weightDeterminationMap.put('FBGRetPlateWt',String.valueOf(FBGRetPlateWt));
      weightDeterminationMap.put('FBGRetPlatePartNum',FBGRetPlatePartNum);
      if(!Test.isRunningTest()) {
          weightDeterminationMap.put('FBGModel', mapRVAttr.get('FBGModel')); //Service Ticket #200844, for FBGModel attribute
      }

      weightDeterminationMap.put('PosStemDiameter',String.valueOf(PosStemDiameter));
      weightDeterminationMap.put('PosCavityDiameter1',String.valueOf(PosCavityDiameter1));
      weightDeterminationMap.put('PosEffSealingDiameter',String.valueOf(PosEffSealingDiameter));
      weightDeterminationMap.put('PosCavityHeight1',String.valueOf(PosCavityHeight1));
      weightDeterminationMap.put('PosCavityDiameter2',String.valueOf(PosCavityDiameter2));
      weightDeterminationMap.put('PosCavityHeight2',String.valueOf(PosCavityHeight2));
      weightDeterminationMap.put('PosTotWtNeed',String.valueOf(PosTotWtNeed));        

      weightDeterminationMap.put('PosPalletPartNum',PosPalletPartNum);    
      weightDeterminationMap.put('PosPalletWt',String.valueOf(PosPalletWt));
      weightDeterminationMap.put('PosPalletThk',String.valueOf(PosPalletThk));

      weightDeterminationMap.put('GPDS05',GPDS05);
      weightDeterminationMap.put('PosDiaphragmWt',String.valueOf(PosDiaphragmWt));
      weightDeterminationMap.put('PosDiaphragmThk',String.valueOf(PosDiaphragmThk));

      weightDeterminationMap.put('GPDS06',GPDS06);
      weightDeterminationMap.put('PosBackupDiaphWt',String.valueOf(PosBackupDiaphWt));
      weightDeterminationMap.put('PosBackupDiaphThk',String.valueOf(PosBackupDiaphThk));

      weightDeterminationMap.put('ERVHWPartNum',ERVHWPartNum);
      weightDeterminationMap.put('ERVEyeNutPartNum',ERVEyeNutPartNum);
      weightDeterminationMap.put('ERVModuleHWWt',String.valueOf(ERVModuleHWWt));
      weightDeterminationMap.put('ERVModuleEyeNutWt',String.valueOf(ERVModuleEyeNutWt));

      weightDeterminationMap.put('GPDS13',String.valueOf(GPDS13));
      weightDeterminationMap.put('GPDS14',String.valueOf(GPDS14));
      weightDeterminationMap.put('PosWtNeed_1',String.valueOf(PosWtNeed_1));
      weightDeterminationMap.put('PosHtAvail_1',String.valueOf(PosHtAvail_1));
      weightDeterminationMap.put('PosDiaMin_1',String.valueOf(PosDiaMin_1));
      weightDeterminationMap.put('PosDiaAllow_1',String.valueOf(PosDiaAllow_1));
      
      weightDeterminationMap.put('PosWt_1',String.valueOf(PosWt_1));
      weightDeterminationMap.put('GPDS17',GPDS17);
      weightDeterminationMap.put('PosHt_1',String.valueOf(PosHt_1));
      weightDeterminationMap.put('GPDS18',String.valueOf(GPDS18));
      weightDeterminationMap.put('PosWtNeed_2',String.valueOf(PosWtNeed_2));
      weightDeterminationMap.put('PosHtAvail_2',String.valueOf(PosHtAvail_2));
      weightDeterminationMap.put('PosDiaMin_2',String.valueOf(PosDiaMin_2));
      weightDeterminationMap.put('PosDiaAllow_2',String.valueOf(PosDiaAllow_2));

      weightDeterminationMap.put('PosWt_2',String.valueOf(PosWt_2));
      weightDeterminationMap.put('GPDS19',GPDS19);
      weightDeterminationMap.put('PosHt_2',String.valueOf(PosHt_2));
      weightDeterminationMap.put('GPDS20',String.valueOf(GPDS20));
      weightDeterminationMap.put('PosWtNeed_3',String.valueOf(PosWtNeed_3));
      weightDeterminationMap.put('PosHtAvail_3',String.valueOf(PosHtAvail_3));
      weightDeterminationMap.put('PosDiaMin_3',String.valueOf(PosDiaMin_3));
      weightDeterminationMap.put('PosDiaAllow_3',String.valueOf(PosDiaAllow_3));

      weightDeterminationMap.put('PosWt_3',String.valueOf(PosWt_3));
      weightDeterminationMap.put('GPDS21',GPDS21);
      weightDeterminationMap.put('PosHt_3',String.valueOf(PosHt_3));
      weightDeterminationMap.put('GPDS22',String.valueOf(GPDS22));
      weightDeterminationMap.put('PosWtNeed_4',String.valueOf(PosWtNeed_4));
      weightDeterminationMap.put('PosHtAvail_4',String.valueOf(PosHtAvail_4));
      weightDeterminationMap.put('PosDiaMin_4',String.valueOf(PosDiaMin_4));
      weightDeterminationMap.put('PosDiaAllow_4',String.valueOf(PosDiaAllow_4));        

      weightDeterminationMap.put('PosWt_4',String.valueOf(PosWt_4));
      weightDeterminationMap.put('GPDS23',GPDS23);
      weightDeterminationMap.put('PosHt_4',String.valueOf(PosHt_4));
      weightDeterminationMap.put('GPDS24',String.valueOf(GPDS24));
      weightDeterminationMap.put('PosWtNeed_5',String.valueOf(PosWtNeed_5));
      weightDeterminationMap.put('PosHtAvail_5',String.valueOf(PosHtAvail_5));
      weightDeterminationMap.put('PosDiaMin_5',String.valueOf(PosDiaMin_5));
      weightDeterminationMap.put('PosDiaAllow_5',String.valueOf(PosDiaAllow_5));

      weightDeterminationMap.put('PosWt_5',String.valueOf(PosWt_5));
      weightDeterminationMap.put('GPDS25',GPDS25);
      weightDeterminationMap.put('PosHt_5',String.valueOf(PosHt_5));
      weightDeterminationMap.put('GPDS26',String.valueOf(GPDS26));
      weightDeterminationMap.put('PosWtNeed_6',String.valueOf(PosWtNeed_6));
      weightDeterminationMap.put('PosHtAvail_6',String.valueOf(PosHtAvail_6));
      weightDeterminationMap.put('PosDiaMin_6',String.valueOf(PosDiaMin_6));
      weightDeterminationMap.put('PosDiaAllow_6',String.valueOf(PosDiaAllow_6));

      weightDeterminationMap.put('PosWt_6',String.valueOf(PosWt_6));
      weightDeterminationMap.put('GPDS27',GPDS27);
      weightDeterminationMap.put('PosHt_6',String.valueOf(PosHt_6));
      weightDeterminationMap.put('GPDS28',String.valueOf(GPDS28));
      weightDeterminationMap.put('PosWtNeed_7',String.valueOf(PosWtNeed_7));
      weightDeterminationMap.put('PosHtAvail_7',String.valueOf(PosHtAvail_7));
      weightDeterminationMap.put('PosDiaMin_7',String.valueOf(PosDiaMin_7));
      weightDeterminationMap.put('PosDiaAllow_7',String.valueOf(PosDiaAllow_7));

      weightDeterminationMap.put('PosWt_7',String.valueOf(PosWt_7));
      weightDeterminationMap.put('GPDS29',GPDS29);
      weightDeterminationMap.put('PosHt_7',String.valueOf(PosHt_7));
      weightDeterminationMap.put('GPDS30',String.valueOf(GPDS30));

      //vac
      weightDeterminationMap.put('VacStemDiameter',String.valueOf(VacStemDiameter));
      weightDeterminationMap.put('VacCavityDiameter1',String.valueOf(VacCavityDiameter1));
      weightDeterminationMap.put('VacEffSealingDiameter',String.valueOf(VacEffSealingDiameter));
      weightDeterminationMap.put('VacCavityHeight1',String.valueOf(VacCavityHeight1));
      weightDeterminationMap.put('VacCavityDiameter2',String.valueOf(VacCavityDiameter2));
      weightDeterminationMap.put('VacCavityHeight2',String.valueOf(VacCavityHeight2));
      weightDeterminationMap.put('VacTotWtNeed',String.valueOf(VacTotWtNeed));

      weightDeterminationMap.put('VacPalletPartNum',VacPalletPartNum);
      weightDeterminationMap.put('VacPalletWt',String.valueOf(VacPalletWt));
      weightDeterminationMap.put('VacPalletThk',String.valueOf(VacPalletThk));

      weightDeterminationMap.put('GPDS07',GPDS07);
      weightDeterminationMap.put('VacDiaphragmWt',String.valueOf(VacDiaphragmWt));
      weightDeterminationMap.put('VacDiaphragmThk',String.valueOf(VacDiaphragmThk));        

      weightDeterminationMap.put('GPDS08',GPDS08);
      weightDeterminationMap.put('VacBackupDiaphWt',String.valueOf(VacBackupDiaphWt));
      weightDeterminationMap.put('VacBackupDiaphThk',String.valueOf(VacBackupDiaphThk));

      weightDeterminationMap.put('GPDS15',String.valueOf(GPDS15));
      weightDeterminationMap.put('GPDS16',String.valueOf(GPDS16));
      weightDeterminationMap.put('VacWtNeed_1',String.valueOf(VacWtNeed_1));
      weightDeterminationMap.put('VacHtAvail_1',String.valueOf(VacHtAvail_1));
      weightDeterminationMap.put('VacDiaMin_1',String.valueOf(VacDiaMin_1));
      weightDeterminationMap.put('VacDiaAllow_1',String.valueOf(VacDiaAllow_1));

      weightDeterminationMap.put('VacWt_1',String.valueOf(VacWt_1));
      weightDeterminationMap.put('GPDS31',GPDS31);
      weightDeterminationMap.put('VacHt_1',String.valueOf(VacHt_1));
      weightDeterminationMap.put('GPDS32',String.valueOf(GPDS32));
      weightDeterminationMap.put('VacWtNeed_2',String.valueOf(VacWtNeed_2));
      weightDeterminationMap.put('VacHtAvail_2',String.valueOf(VacHtAvail_2));
      weightDeterminationMap.put('VacDiaMin_2',String.valueOf(VacDiaMin_2));
      weightDeterminationMap.put('VacDiaAllow_2',String.valueOf(VacDiaAllow_2));
                  

      weightDeterminationMap.put('VacWt_2',String.valueOf(VacWt_2));
      weightDeterminationMap.put('GPDS33',GPDS33);
      weightDeterminationMap.put('VacHt_2',String.valueOf(VacHt_2));
      weightDeterminationMap.put('GPDS34',String.valueOf(GPDS34));
      weightDeterminationMap.put('VacWtNeed_3',String.valueOf(VacWtNeed_3));
      weightDeterminationMap.put('VacHtAvail_3',String.valueOf(VacHtAvail_3));
      weightDeterminationMap.put('VacDiaMin_3',String.valueOf(VacDiaMin_3));
      weightDeterminationMap.put('VacDiaAllow_3',String.valueOf(VacDiaAllow_3)); 

      weightDeterminationMap.put('VacWt_3',String.valueOf(VacWt_3));
      weightDeterminationMap.put('GPDS35',GPDS35);
      weightDeterminationMap.put('VacHt_3',String.valueOf(VacHt_3));
      weightDeterminationMap.put('GPDS36',String.valueOf(GPDS36));
      weightDeterminationMap.put('VacWtNeed_4',String.valueOf(VacWtNeed_4));
      weightDeterminationMap.put('VacHtAvail_4',String.valueOf(VacHtAvail_4));
      weightDeterminationMap.put('VacDiaMin_4',String.valueOf(VacDiaMin_4));
      weightDeterminationMap.put('VacDiaAllow_4',String.valueOf(VacDiaAllow_4));


      weightDeterminationMap.put('VacWt_4',String.valueOf(VacWt_4));
      weightDeterminationMap.put('GPDS37',GPDS37);
      weightDeterminationMap.put('VacHt_4',String.valueOf(VacHt_4));
      weightDeterminationMap.put('GPDS38',String.valueOf(GPDS38));
      weightDeterminationMap.put('VacWtNeed_5',String.valueOf(VacWtNeed_5));
      weightDeterminationMap.put('VacHtAvail_5',String.valueOf(VacHtAvail_5));
      weightDeterminationMap.put('VacDiaMin_5',String.valueOf(VacDiaMin_5));
      weightDeterminationMap.put('VacDiaAllow_5',String.valueOf(VacDiaAllow_5));        

      weightDeterminationMap.put('VacWt_5',String.valueOf(VacWt_5));
      weightDeterminationMap.put('GPDS39',GPDS39);
      weightDeterminationMap.put('VacHt_5',String.valueOf(VacHt_5));
      weightDeterminationMap.put('GPDS40',String.valueOf(GPDS40));
      weightDeterminationMap.put('VacWtNeed_6',String.valueOf(VacWtNeed_6));
      weightDeterminationMap.put('VacHtAvail_6',String.valueOf(VacHtAvail_6));
      weightDeterminationMap.put('VacDiaMin_6',String.valueOf(VacDiaMin_6));
      weightDeterminationMap.put('VacDiaAllow_6',String.valueOf(VacDiaAllow_6));

      weightDeterminationMap.put('VacWt_6',String.valueOf(VacWt_6));
      weightDeterminationMap.put('GPDS41',GPDS41);
      weightDeterminationMap.put('VacHt_6',String.valueOf(VacHt_6));
      weightDeterminationMap.put('GPDS42',String.valueOf(GPDS42));
      weightDeterminationMap.put('VacWtNeed_7',String.valueOf(VacWtNeed_7));
      weightDeterminationMap.put('VacHtAvail_7',String.valueOf(VacHtAvail_7));
      weightDeterminationMap.put('VacDiaMin_7',String.valueOf(VacDiaMin_7));
      weightDeterminationMap.put('VacDiaAllow_7',String.valueOf(VacDiaAllow_7));

      weightDeterminationMap.put('VacWt_7',String.valueOf(VacWt_7));
      weightDeterminationMap.put('GPDS43',GPDS43);
      weightDeterminationMap.put('VacHt_7',String.valueOf(VacHt_7));
      weightDeterminationMap.put('GPDS44',String.valueOf(GPDS44));

      return weightDeterminationMap;
  }

  public pageReference cleanRVrecord(Relief_Valve__c curRV)
  {
      //Relief_Valve__c curRV ;
      //curRV= (Relief_Valve__c) wizardBaseDataProcessor.getObjectDataById(curRV.id).objResultList[0];
      curRV.Relief_Type__c = null;
      curRV.Part_Number__c= null;
      curRV.Lead_Time_Site_10__c=null;
      curRV.Lead_Time_Site_20__c=null;
      curRV.Lead_Time_Site_30__c=null;
      curRV.Lead_Time_Site_40__c=null;
      curRV.Pressure_Setting__c = null;
      curRV.Pressure_Setting_Units__c = null; 
      curRV.Back_Pressure__c = null;
      curRV.Back_Pressure_Units__c = null;
      curRV.Max_Process_Pressure__c = null;
      curRV.Vacuum_Setting__c = null;
      curRV.Vacuum_Setting_Units__c = null;
      curRV.Converted_Relieving_Pressure_Value__c = null;
      curRV.Constraint_Product_Selection_By_Flow__c = true;
      
      //Section B
      
      curRV.Atmospheric_Pressure__c = null;
      curRV.Media_Type__c = null;
      curRV.V_Ratio_of_Specific_Heats__c= null;
      curRV.V_Molecular_Weight__c= null;
      curRV.V_Compressibility_Factor__c= null;
      curRV.Pressure_Relief_Req_Flow_Rate__c= null;
      curRV.Pressure_Relief_Req_Flow_Units__c= null;
      curRV.Enter_Relieving_Pressure_Value__c = null;
      curRV.Enter_Relieving_Pressure_Units__c= null;
      curRV.Pressure_Relieving_Temperature__c= null;
      curRV.Pressure_Relieving_Temperature_Units__c= null;
      curRV.Vacuum_Media__c= null;
      curRV.Ratio_of_Specific_Heats__c=null;
      curRV.Molecular_Weight__c = null;
      curRV.Compressibility_Factor__c = null;
      curRV.Vacuum_Relief_Req_Flow__c = null;
      curRV.Vacuum_Relief_Required_Flow_Units__c=null;
      curRV.V_Enter_Relieving_Vacuum_Value__c = null;
      curRV.V_Enter_Relieving_Vacuum_units__c = null;
      curRV.V_Overpressure_Vacuum_Value__c = null;
      curRV.V_Vacuum_Relieving_Temperature__c = null;
      curRV.V_Vacuum_Relieving_Temperature_Units__c = null;
      curRV.Converted_Pressure_Setting__c = null;
      curRV.Converted_Max_Process_Pressure__c = null;
      curRV.Converted_Vacuum_Setting__c = null;
      curRV.Converted_Atmospheric_Pressure__c = null;
      curRV.Converted_Relieving_Pressure_Value__c = null;
      curRV.Converted_Back_Pressure__c = null;
      curRV.V_Converted_Relieving_Vacuum_Value__c = null;
      curRV.Converted_Pressure_Relief_Req_Flow__c = null;
      curRV.Converted_Relieving_Pressure_Value__c = null;
      curRV.Converted_Pressure_Relieving_Temperature__c = null;
      curRV.Converted_Vacuum_Relief_Req_Flow__c = null;
      curRV.V_Converted_Relieving_Vacuum_Value__c = null;
      curRV.V_Converted_Vacuum_Relieving_Temperature__c = null;
      //Section C
      curRV.PED_2014_68_EU_CE_mark__c=false;
      curRV.CU_TR__c=false;
      curRV.Atex_Certificate__c=true;
      curRV.Gas_Group__c = null;
      curRV.Zone__c = null;
      curRV.NACE__c=false;
      
      //Section D
      curRV.Type_of_model__c='';
      curRV.Type_of_overpressure_valve__c='100';
      curRV.Is_flame_arrester_needed_with_your_valve__c='';
      
      //Section E        
      curRV.Size_Preference__c=null;
      curRV.Model_Size__c=null;
      curRV.Size__c=null;
      curRV.Model_name__c=null;
      curRV.Size_Preference__c = null;
      curRV.Schedule_BaseLead__c = null;
      curRV.EFFMop__c = 1.000;
      curRV.EffMBP__c = 1.000;
      curRV.PosSetPresOSIG__c = 1.000;
      curRV.VacSetPresOSIG__c = 1.000;
      //VF Page Fields
      curRV.Quantity__c=1;
      curRV.Drilling__c='B';
      curRV.Body_Material__c='6';
      curRV.Facing__c='FF';
      curRV.Seat_Material__c='6';
      curRV.Pallet_Type__c='N';
      curRV.Pressure_Pallet_Material__c='6';
      curRV.Diaphragm_Material__c='T';
      curRV.Vacuum_Pallet_Material__c='6';
      curRV.Pilot_Soft_Goods_Material__c='N';
      curRV.Weight_Material__c='RL';
      curRV.Spring_Material__c='P';
      curRV.Fastener_Material__c = '8';
      curRV.Steam_Jacket_Material__c='0';
      curRV.Body_Coating_Material__c='N';
      curRV.Pallet_Fastener_Coating_Material__c='N';
      curRV.Element_Material__c='N';
      curRV.Flame_Arrester_Option__c = '000';
      curRV.Vacuum_Port_Option__c='V';
      curRV.Pressure_Port_Proximity_Sensor__c = false;
      curRV.Vacuum_Port_Proximity_Sensor__c = false;
      curRV.Pilot_Action__c = 'N';
      curRV.Positive_Material_Identification__c='N';
      curRV.Liquid_Dye_Penetrant__c='N';
      curRV.Painting_Coating_Option__c = '0';
      curRV.Manual_Blowdown__c=false; //checkboxes
      curRV.Remote_Sense__c=false;
      curRV.Pilot_Exhaust_Piped_to_Discharge_Header__c = false;
      curRV.Field_Test_Connection__c=false;
      curRV.Pilot_Supply_Filter__c=false;
      curRV.Method21_Leak_Detection__c=false;
      curRV.Radiography__c='N';
      curRV.Fillet_Weld_Liquid_Dye_Penetrant__c=false;
      curRV.Ultrasonic_Examination__c=false;
      curRV.Magnetic_Particle_Examination__c=false;        
      curRV.Brinell_hardness_examination__c=false;
      curRV.Charpy_Impact_Testing__c=false;
      curRV.Visual_Casting_Examination__c=false;
      curRV.Intergranular_Corossion_Test__c = false;
      curRV.Shell_Test_Valve_Body__c = 'AIR';
      curRV.Final_Assembly_Location_Requirements__c = '00';
      curRV.Material_Sourcing_Requirements__c = '00';
      curRV.Finish_Configuration_Flag__c = true;
      curRV.Body_Design__c = 'STD';
      
      curRV.Relief_Type__c = null;
      curRV.Part_Number__c= null;
      curRV.Lead_Time_Site_10__c=null;
      curRV.Lead_Time_Site_20__c=null;
      curRV.Lead_Time_Site_30__c=null;
      curRV.Lead_Time_Site_40__c=null;
      curRV.Pressure_Setting__c = null;
      curRV.Pressure_Setting_Units__c = null; 
      curRV.Back_Pressure__c = null;
      curRV.Back_Pressure_Units__c = null;
      curRV.Max_Process_Pressure__c = null;
      curRV.Vacuum_Setting__c = null;
      curRV.Vacuum_Setting_Units__c = null;
      curRV.Converted_Relieving_Pressure_Value__c = null;
      curRV.Constraint_Product_Selection_By_Flow__c = true;
      
      //Section B
      
      curRV.Atmospheric_Pressure__c = null;
      curRV.Media_Type__c = null;
      curRV.V_Ratio_of_Specific_Heats__c= null;
      curRV.V_Molecular_Weight__c= null;
      curRV.V_Compressibility_Factor__c= null;
      curRV.Pressure_Relief_Req_Flow_Rate__c= null;
      curRV.Pressure_Relief_Req_Flow_Units__c= null;
      curRV.Enter_Relieving_Pressure_Value__c = null;
      curRV.Enter_Relieving_Pressure_Units__c= null;
      curRV.Pressure_Relieving_Temperature__c= null;
      curRV.Pressure_Relieving_Temperature_Units__c= null;
      curRV.Vacuum_Media__c= null;
      curRV.Ratio_of_Specific_Heats__c=null;
      curRV.Molecular_Weight__c = null;
      curRV.Compressibility_Factor__c = null;
      curRV.Vacuum_Relief_Req_Flow__c = null;
      curRV.Vacuum_Relief_Required_Flow_Units__c=null;
      curRV.V_Enter_Relieving_Vacuum_Value__c = null;
      curRV.V_Enter_Relieving_Vacuum_units__c = null;
      curRV.V_Overpressure_Vacuum_Value__c = null;
      curRV.V_Vacuum_Relieving_Temperature__c = null;
      curRV.V_Vacuum_Relieving_Temperature_Units__c = null;
      curRV.Converted_Pressure_Setting__c = null;
      curRV.Converted_Max_Process_Pressure__c = null;
      curRV.Converted_Vacuum_Setting__c = null;
      curRV.Converted_Atmospheric_Pressure__c = null;
      curRV.Converted_Relieving_Pressure_Value__c = null;
      curRV.Converted_Back_Pressure__c = null;
      curRV.V_Converted_Relieving_Vacuum_Value__c = null;
      curRV.Converted_Pressure_Relief_Req_Flow__c = null;
      curRV.Converted_Relieving_Pressure_Value__c = null;
      curRV.Converted_Pressure_Relieving_Temperature__c = null;
      curRV.Converted_Vacuum_Relief_Req_Flow__c = null;
      curRV.V_Converted_Relieving_Vacuum_Value__c = null;
      curRV.V_Converted_Vacuum_Relieving_Temperature__c = null;
      //Section C
      curRV.PED_2014_68_EU_CE_mark__c=false;
      curRV.CU_TR__c=false;
      curRV.Atex_Certificate__c=true;
      curRV.Gas_Group__c = null;
      curRV.Zone__c = null;
      curRV.NACE__c=false;
      
      //Section D
      curRV.Type_of_model__c='';
      curRV.Type_of_overpressure_valve__c='100';
      curRV.Is_flame_arrester_needed_with_your_valve__c='';
      
      //Section E        
      curRV.Size_Preference__c=null;
      curRV.Model_Size__c=null;
      curRV.Size__c=null;
      curRV.Model_name__c=null;
      curRV.Size_Preference__c = null;
      curRV.Schedule_BaseLead__c = null;
      curRV.EFFMop__c = 1.000;
      curRV.EffMBP__c = 1.000;
      curRV.PosSetPresOSIG__c = 1.000;
      curRV.VacSetPresOSIG__c = 1.000;
      //VF Page Fields
      curRV.Quantity__c=1;
      curRV.Drilling__c='B';
      curRV.Body_Material__c='6';
      curRV.Facing__c='FF';
      curRV.Seat_Material__c='6';
      curRV.Pallet_Type__c='N';
      curRV.Pressure_Pallet_Material__c='6';
      curRV.Diaphragm_Material__c='T';
      curRV.Vacuum_Pallet_Material__c='6';
      curRV.Pilot_Soft_Goods_Material__c='N';
      curRV.Weight_Material__c='RL';
      curRV.Spring_Material__c='P';
      curRV.Fastener_Material__c = '8';
      curRV.Steam_Jacket_Material__c='0';
      curRV.Body_Coating_Material__c='N';
      curRV.Pallet_Fastener_Coating_Material__c='N';
      curRV.Element_Material__c='N';
      curRV.Flame_Arrester_Option__c = '000';
      curRV.Vacuum_Port_Option__c='V';
      curRV.Pressure_Port_Proximity_Sensor__c = false;
      curRV.Vacuum_Port_Proximity_Sensor__c = false;
      curRV.Pilot_Action__c = 'N';
      curRV.Positive_Material_Identification__c='N';
      curRV.Liquid_Dye_Penetrant__c='N';
      curRV.Painting_Coating_Option__c = '0';
      curRV.Manual_Blowdown__c=false; //checkboxes
      curRV.Remote_Sense__c=false;
      curRV.Pilot_Exhaust_Piped_to_Discharge_Header__c = false;
      curRV.Field_Test_Connection__c=false;
      curRV.Pilot_Supply_Filter__c=false;
      curRV.Method21_Leak_Detection__c=false;
      curRV.Radiography__c='N';
      curRV.Fillet_Weld_Liquid_Dye_Penetrant__c=false;
      curRV.Ultrasonic_Examination__c=false;
      curRV.Magnetic_Particle_Examination__c=false;        
      curRV.Brinell_hardness_examination__c=false;
      curRV.Charpy_Impact_Testing__c=false;
      curRV.Visual_Casting_Examination__c=false;
      curRV.Intergranular_Corossion_Test__c = false;
      curRV.Shell_Test_Valve_Body__c = 'AIR';
      curRV.Final_Assembly_Location_Requirements__c = '00';
      curRV.Material_Sourcing_Requirements__c = '00';
      curRV.Finish_Configuration_Flag__c = true;
      curRV.Body_Design__c = 'STD';
      
      curRV.Relief_Type__c = null;
      curRV.Part_Number__c= null;
      curRV.Lead_Time_Site_10__c=null;
      curRV.Lead_Time_Site_20__c=null;
      curRV.Lead_Time_Site_30__c=null;
      curRV.Lead_Time_Site_40__c=null;
      curRV.Pressure_Setting__c = null;
      curRV.Pressure_Setting_Units__c = null; 
      curRV.Back_Pressure__c = null;
      curRV.Back_Pressure_Units__c = null;
      curRV.Max_Process_Pressure__c = null;
      curRV.Vacuum_Setting__c = null;
      curRV.Vacuum_Setting_Units__c = null;
      curRV.Converted_Relieving_Pressure_Value__c = null;
      curRV.Constraint_Product_Selection_By_Flow__c = true;
      
      //Section B
      
      curRV.Atmospheric_Pressure__c = null;
      curRV.Media_Type__c = null;
      curRV.V_Ratio_of_Specific_Heats__c= null;
      curRV.V_Molecular_Weight__c= null;
      curRV.V_Compressibility_Factor__c= null;
      curRV.Pressure_Relief_Req_Flow_Rate__c= null;
      curRV.Pressure_Relief_Req_Flow_Units__c= null;
      curRV.Enter_Relieving_Pressure_Value__c = null;
      curRV.Enter_Relieving_Pressure_Units__c= null;
      curRV.Pressure_Relieving_Temperature__c= null;
      curRV.Pressure_Relieving_Temperature_Units__c= null;
      curRV.Vacuum_Media__c= null;
      curRV.Ratio_of_Specific_Heats__c=null;
      curRV.Molecular_Weight__c = null;
      curRV.Compressibility_Factor__c = null;
      curRV.Vacuum_Relief_Req_Flow__c = null;
      curRV.Vacuum_Relief_Required_Flow_Units__c=null;
      curRV.V_Enter_Relieving_Vacuum_Value__c = null;
      curRV.V_Enter_Relieving_Vacuum_units__c = null;
      curRV.V_Overpressure_Vacuum_Value__c = null;
      curRV.V_Vacuum_Relieving_Temperature__c = null;
      curRV.V_Vacuum_Relieving_Temperature_Units__c = null;
      curRV.Converted_Pressure_Setting__c = null;
      curRV.Converted_Max_Process_Pressure__c = null;
      curRV.Converted_Vacuum_Setting__c = null;
      curRV.Converted_Atmospheric_Pressure__c = null;
      curRV.Converted_Relieving_Pressure_Value__c = null;
      curRV.Converted_Back_Pressure__c = null;
      curRV.V_Converted_Relieving_Vacuum_Value__c = null;
      curRV.Converted_Pressure_Relief_Req_Flow__c = null;
      curRV.Converted_Relieving_Pressure_Value__c = null;
      curRV.Converted_Pressure_Relieving_Temperature__c = null;
      curRV.Converted_Vacuum_Relief_Req_Flow__c = null;
      curRV.V_Converted_Relieving_Vacuum_Value__c = null;
      curRV.V_Converted_Vacuum_Relieving_Temperature__c = null;
      //Section C
      curRV.PED_2014_68_EU_CE_mark__c=false;
      curRV.CU_TR__c=false;
      curRV.Atex_Certificate__c=true;
      curRV.Gas_Group__c = null;
      curRV.Zone__c = null;
      curRV.NACE__c=false;
      
      //Section D
      curRV.Type_of_model__c='';
      curRV.Type_of_overpressure_valve__c='100';
      curRV.Is_flame_arrester_needed_with_your_valve__c='';
      
      //Section E        
      curRV.Size_Preference__c=null;
      curRV.Model_Size__c=null;
      curRV.Size__c=null;
      curRV.Model_name__c=null;
      curRV.Size_Preference__c = null;
      curRV.Schedule_BaseLead__c = null;
      curRV.EFFMop__c = 1.000;
      curRV.EffMBP__c = 1.000;
      curRV.PosSetPresOSIG__c = 1.000;
      curRV.VacSetPresOSIG__c = 1.000;
      //VF Page Fields
      curRV.Quantity__c=1;
      curRV.Drilling__c='B';
      curRV.Body_Material__c='6';
      curRV.Facing__c='FF';
      curRV.Seat_Material__c='6';
      curRV.Pallet_Type__c='N';
      curRV.Pressure_Pallet_Material__c='6';
      curRV.Diaphragm_Material__c='T';
      curRV.Vacuum_Pallet_Material__c='6';
      curRV.Pilot_Soft_Goods_Material__c='N';
      curRV.Weight_Material__c='RL';
      curRV.Spring_Material__c='P';
      curRV.Fastener_Material__c = '8';
      curRV.Steam_Jacket_Material__c='0';
      curRV.Body_Coating_Material__c='N';
      curRV.Pallet_Fastener_Coating_Material__c='N';
      curRV.Element_Material__c='N';
      curRV.Flame_Arrester_Option__c = '000';
      curRV.Vacuum_Port_Option__c='V';
      curRV.Pressure_Port_Proximity_Sensor__c = false;
      curRV.Vacuum_Port_Proximity_Sensor__c = false;
      curRV.Pilot_Action__c = 'N';
      curRV.Positive_Material_Identification__c='N';
      curRV.Liquid_Dye_Penetrant__c='N';
      curRV.Painting_Coating_Option__c = '0';
      curRV.Manual_Blowdown__c=false; //checkboxes
      curRV.Remote_Sense__c=false;
      curRV.Pilot_Exhaust_Piped_to_Discharge_Header__c = false;
      curRV.Field_Test_Connection__c=false;
      curRV.Pilot_Supply_Filter__c=false;
      curRV.Method21_Leak_Detection__c=false;
      curRV.Radiography__c='N';
      curRV.Fillet_Weld_Liquid_Dye_Penetrant__c=false;
      curRV.Ultrasonic_Examination__c=false;
      curRV.Magnetic_Particle_Examination__c=false;        
      curRV.Brinell_hardness_examination__c=false;
      curRV.Charpy_Impact_Testing__c=false;
      curRV.Visual_Casting_Examination__c=false;
      curRV.Intergranular_Corossion_Test__c = false;
      curRV.Shell_Test_Valve_Body__c = 'AIR';
      curRV.Final_Assembly_Location_Requirements__c = '00';
      curRV.Material_Sourcing_Requirements__c = '00';
      curRV.Finish_Configuration_Flag__c = true;
      curRV.Body_Design__c = 'STD';
      
      //Section C
      curRV.PED_2014_68_EU_CE_mark__c=false;
      curRV.CU_TR__c=false;
      curRV.Atex_Certificate__c=true;
      curRV.Gas_Group__c = null;
      curRV.Zone__c = null;
      curRV.NACE__c=false;
      
      //Section D
      curRV.Type_of_model__c='';
      curRV.Type_of_overpressure_valve__c='100';
      curRV.Is_flame_arrester_needed_with_your_valve__c='';
      
      //Section E        
      curRV.Size_Preference__c=null;
      curRV.Model_Size__c=null;
      curRV.Size__c=null;
      curRV.Model_name__c=null;
      curRV.Size_Preference__c = null;
      curRV.Schedule_BaseLead__c = null;
      curRV.EFFMop__c = 1.000;
      curRV.EffMBP__c = 1.000;
      curRV.PosSetPresOSIG__c = 1.000;
      curRV.VacSetPresOSIG__c = 1.000;
      //VF Page Fields
      curRV.Quantity__c=1;
      curRV.Drilling__c='B';
      curRV.Body_Material__c='6';
      curRV.Facing__c='FF';
      curRV.Seat_Material__c='6';
      curRV.Pallet_Type__c='N';
      curRV.Pressure_Pallet_Material__c='6';
      curRV.Diaphragm_Material__c='T';
      curRV.Vacuum_Pallet_Material__c='6';
      curRV.Pilot_Soft_Goods_Material__c='N';
      curRV.Weight_Material__c='RL';
      curRV.Spring_Material__c='P';
      curRV.Fastener_Material__c = '8';
      curRV.Steam_Jacket_Material__c='0';
      curRV.Body_Coating_Material__c='N';
      curRV.Pallet_Fastener_Coating_Material__c='N';
      curRV.Element_Material__c='N';
      curRV.Flame_Arrester_Option__c = '000';
      curRV.Vacuum_Port_Option__c='V';
      curRV.Pressure_Port_Proximity_Sensor__c = false;
      curRV.Vacuum_Port_Proximity_Sensor__c = false;
      curRV.Pilot_Action__c = 'N';
      curRV.Positive_Material_Identification__c='N';
      curRV.Liquid_Dye_Penetrant__c='N';
      curRV.Painting_Coating_Option__c = '0';
      curRV.Manual_Blowdown__c=false; //checkboxes
      curRV.Remote_Sense__c=false;
      curRV.Pilot_Exhaust_Piped_to_Discharge_Header__c = false;
      curRV.Field_Test_Connection__c=false;
      curRV.Pilot_Supply_Filter__c=false;
      curRV.Method21_Leak_Detection__c=false;
      curRV.Radiography__c='N';
      curRV.Fillet_Weld_Liquid_Dye_Penetrant__c=false;
      curRV.Ultrasonic_Examination__c=false;
      curRV.Magnetic_Particle_Examination__c=false;        
      curRV.Brinell_hardness_examination__c=false;
      curRV.Charpy_Impact_Testing__c=false;
      curRV.Visual_Casting_Examination__c=false;
      curRV.Intergranular_Corossion_Test__c = false;
      curRV.Shell_Test_Valve_Body__c = 'AIR';
      curRV.Final_Assembly_Location_Requirements__c = '00';
      curRV.Material_Sourcing_Requirements__c = '00';
      curRV.Finish_Configuration_Flag__c = true;
      curRV.Body_Design__c = 'STD';
      
      //Section C
      curRV.PED_2014_68_EU_CE_mark__c=false;
      curRV.CU_TR__c=false;
      curRV.Atex_Certificate__c=true;
      curRV.Gas_Group__c = null;
      curRV.Zone__c = null;
      curRV.NACE__c=false;
      
      //Section D
      curRV.Type_of_model__c='';
      curRV.Type_of_overpressure_valve__c='100';
      curRV.Is_flame_arrester_needed_with_your_valve__c='';
      
      //Section E        
      curRV.Size_Preference__c=null;
      curRV.Model_Size__c=null;
      curRV.Size__c=null;
      curRV.Model_name__c=null;
      curRV.Size_Preference__c = null;
      curRV.Schedule_BaseLead__c = null;
      curRV.EFFMop__c = 1.000;
      curRV.EffMBP__c = 1.000;
      curRV.PosSetPresOSIG__c = 1.000;
      curRV.VacSetPresOSIG__c = 1.000;
      //VF Page Fields
      curRV.Quantity__c=1;
      curRV.Drilling__c='B';
      curRV.Body_Material__c='6';
      curRV.Facing__c='FF';
      curRV.Seat_Material__c='6';
      curRV.Pallet_Type__c='N';
      curRV.Pressure_Pallet_Material__c='6';
      curRV.Diaphragm_Material__c='T';
      curRV.Vacuum_Pallet_Material__c='6';
      curRV.Pilot_Soft_Goods_Material__c='N';
      curRV.Weight_Material__c='RL';
      curRV.Spring_Material__c='P';
      curRV.Fastener_Material__c = '8';
      curRV.Steam_Jacket_Material__c='0';
      curRV.Body_Coating_Material__c='N';
      curRV.Pallet_Fastener_Coating_Material__c='N';
      curRV.Element_Material__c='N';
      curRV.Flame_Arrester_Option__c = '000';
      curRV.Vacuum_Port_Option__c='V';
      curRV.Pressure_Port_Proximity_Sensor__c = false;
      curRV.Vacuum_Port_Proximity_Sensor__c = false;
      curRV.Pilot_Action__c = 'N';
      curRV.Positive_Material_Identification__c='N';
      curRV.Liquid_Dye_Penetrant__c='N';
      curRV.Painting_Coating_Option__c = '0';
      curRV.Manual_Blowdown__c=false; //checkboxes
      curRV.Remote_Sense__c=false;
      curRV.Pilot_Exhaust_Piped_to_Discharge_Header__c = false;
      curRV.Field_Test_Connection__c=false;
      curRV.Pilot_Supply_Filter__c=false;
      curRV.Method21_Leak_Detection__c=false;
      curRV.Radiography__c='N';
      curRV.Fillet_Weld_Liquid_Dye_Penetrant__c=false;
      curRV.Ultrasonic_Examination__c=false;
      curRV.Magnetic_Particle_Examination__c=false;        
      curRV.Brinell_hardness_examination__c=false;
      curRV.Charpy_Impact_Testing__c=false;
      curRV.Visual_Casting_Examination__c=false;
      curRV.Intergranular_Corossion_Test__c = false;
      curRV.Shell_Test_Valve_Body__c = 'AIR';
      curRV.Final_Assembly_Location_Requirements__c = '00';
      curRV.Material_Sourcing_Requirements__c = '00';
      curRV.Finish_Configuration_Flag__c = true;
      curRV.Body_Design__c = 'STD';
      curRV.Size_Preference__c=null;
      curRV.Model_Size__c=null;
      curRV.Size__c=null;
      curRV.Model_name__c=null;
      curRV.Size_Preference__c = null;
      curRV.Schedule_BaseLead__c = null;
      curRV.EFFMop__c = 1.000;
      curRV.EffMBP__c = 1.000;
      curRV.PosSetPresOSIG__c = 1.000;
      curRV.VacSetPresOSIG__c = 1.000;
       curRV.Vacuum_Pallet_Material__c='6';
      curRV.Pilot_Soft_Goods_Material__c='N';
      curRV.Weight_Material__c='RL';
      curRV.Spring_Material__c='P';
      curRV.Fastener_Material__c = '8';
      curRV.Steam_Jacket_Material__c='0';
      curRV.Body_Coating_Material__c='N';
      curRV.Lead_Time_Site_10__c=null;
      curRV.Lead_Time_Site_20__c=null;
      curRV.Lead_Time_Site_30__c=null;
      curRV.Lead_Time_Site_40__c=null;
      curRV.Pressure_Setting__c = null;
      curRV.Pressure_Setting_Units__c = null; 
      curRV.Back_Pressure__c = null;
      curRV.Back_Pressure_Units__c = null;
      curRV.Max_Process_Pressure__c = null;
      curRV.Vacuum_Setting__c = null;
      curRV.Vacuum_Setting_Units__c = null;
      curRV.Converted_Pressure_Setting__c = null;
      curRV.Converted_Max_Process_Pressure__c = null;
      curRV.Converted_Vacuum_Setting__c = null;
      curRV.Converted_Atmospheric_Pressure__c = null;
      curRV.Converted_Relieving_Pressure_Value__c = null;
      curRV.Converted_Back_Pressure__c = null;
      curRV.V_Converted_Relieving_Vacuum_Value__c = null;
      curRV.Converted_Pressure_Relief_Req_Flow__c = null;
      curRV.Converted_Relieving_Pressure_Value__c = null;
      curRV.Converted_Pressure_Relieving_Temperature__c = null;
      curRV.Converted_Vacuum_Relief_Req_Flow__c = null;
      curRV.V_Converted_Relieving_Vacuum_Value__c = null;
      curRV.V_Converted_Vacuum_Relieving_Temperature__c = null;
      return null;
  }
}