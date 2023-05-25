public with sharing class DataSelectorWizard 
{
    private static DataSelectorWizard instance = null;
    //the constructor is marked PRIVATE
    // so that no Apex code outside this class can create the instance
    private DataSelectorWizard()
    {

    }

    /*
    This static method will be the only way to get the Single
    instance of this class.
    */
    public static DataSelectorWizard getInstance()
    {
        if (instance == null)
        {
            // Create the single instance now.
            instance = new DataSelectorWizard();
        }
        return instance;
    }
    public static Flame_Product__c getFlameProductRecord(String quotelineId)
    {
        Flame_Product__c flameProduct;
        String fieldsAPIname = FLMutility.getObjectFields('Flame_Product__c');
        String soql = 'SELECT '+fieldsAPIname+' FROM Flame_Product__c where Quote_Line__c =\''+String.escapeSingleQuotes(quotelineId)+'\' limit 1';
        flameProduct  = Database.query(soql);
        return flameProduct;
    }
     public static BGR__c getBGRProductRecord(String quotelineId)
    {
        BGR__c BGRProduct;
        String fieldsAPIname = FLMutility.getObjectFields('BGR__c');
        String soql = 'SELECT Quote_Line__r.SBQQ__Quote__r.Brand__c, '+fieldsAPIname+' FROM BGR__c where Quote_Line__c =\''+String.escapeSingleQuotes(quotelineId)+'\' limit 1';
        BGRProduct  = Database.query(soql);
        return BGRProduct;
    }
    
     public static Part_Selector__c getPartSelectorRecord(String PSId)
    {
        Part_Selector__c PSProduct;
        String fieldsAPIname = FLMutility.getObjectFields('Part_Selector__c');
        String soql = 'SELECT '+fieldsAPIname+' FROM Part_Selector__c where Id=\''+String.escapeSingleQuotes(PSId)+'\' limit 1';
        PSProduct  = Database.query(soql);
        return PSProduct;
    }
    public static Holders__c getHolderProductRecord(String quotelineId)
    {
        Holders__c holderProduct;
        String fieldsAPIname = FLMutility.getObjectFields('Holders__c');
        System.debug('fieldsAPIname...'+fieldsAPIname);
        System.debug('quotelineId....'+quotelineId);
        String soql = 'SELECT '+fieldsAPIname+' FROM Holders__c where Quote_Line__c =\''+String.escapeSingleQuotes(quotelineId)+'\' limit 1';
        holderProduct  = Database.query(soql);
        return holderProduct;
    }
    
    public static Map<String, GasFlowRate__c> getFlameProductRecord()
    {
        Map<String, GasFlowRate__c> flowRateMap = new Map<String, GasFlowRate__c>();
        for(GasFlowRate__c gfw : [select Multiplier__c,DensityActualFrom__c,DensityActualTo__c,DensityStandardFrom__c,DensityStandardTo__c,PFromPsia__c,PToPsia__c,TFromR__c,TToR__c,GasFlowRate_UOM_From__c,GasFlowRate_UOM_To__c from GasFlowRate__c])
        {
            if(String.isNotBlank(gfw.GasFlowRate_UOM_From__c) && String.isNotBlank(gfw.GasFlowRate_UOM_To__c))
            {
                String flowRateKey = gfw.GasFlowRate_UOM_From__c +'_'+ gfw.GasFlowRate_UOM_To__c;
                if(!flowRateMap.containsKey(flowRateKey))
                {
                    flowRateMap.put(flowRateKey, gfw);
                }
            }
        }
        return flowRateMap;
    }

    /*
    public static List<FLM_KD__c> getFLMKDRecord()
    {
        List<FLM_KD__c> KDTable = new List<FLM_KD__c>();
        KDTable = [select KD__c,PresRatio__c,EffDia__c, Model__c,ConnSizeCode__c from FLM_KD__c
                        order by PresRatio__c ASC];
        return KDTable;
    }
    public static Map<String, Map<String, Map<String, List<FLM_MasterBlaster__c>>>> getFLMMasterBlaster(Flame_Product__c flmprod)
    {
        Map<String, Map<String, Map<String, List<FLM_MasterBlaster__c>>>> masterMap= new Map<String, Map<String, Map<String, List<FLM_MasterBlaster__c>>>>();
       //
      //   * Outer key1 = Model+connectionsize+elementsize
      //   * Outer key2 = Outerkey1+Bodymaterial
      //   * Outer key3 = Outerkey2+HousingMaterial
        
        for(FLM_MasterBlaster__c fm: [SELECT Id, Model__c, ConnSizeCode__c, ElemSizeCode__c,BodyMatlCode__c,HousingMatlCode__c,ElemMatlCode__c FROM FLM_MasterBlaster__c
                                     WHERE Model__c =:flmprod.Model__c AND ConnSizeCode__c =:flmprod.Connection_Size__c AND ElemSizeCode__c =:flmProd.Element_Size__c])
        {
            String outerKey1 = fm.Model__c +'_'+ fm.ConnSizeCode__c +'_'+ fm.ElemSizeCode__c;
            String outerKey2 = outerKey1 + '_' + fm.BodyMatlCode__c;
            String outerKey3 = outerKey2 + '_'+ fm.HousingMatlCode__c;
            if(!masterMap.containsKey(outerKey1))
            {
                masterMap.put(outerKey1,new Map<String, Map<String, List<FLM_MasterBlaster__c>>>());
                if(!masterMap.get(outerKey1).containsKey(outerKey2))
                {
                    masterMap.get(outerKey1).put(outerKey2, new Map<String, List<FLM_MasterBlaster__c>>());
                }
                if(!masterMap.get(outerKey1).get(outerKey2).containsKey(outerKey2))
                {
                    masterMap.get(outerKey1).get(outerKey2).put(outerKey3, new List<FLM_MasterBlaster__c>());
                }
            }
            masterMap.get(outerKey1).get(outerKey2).get(outerKey3).add(fm);
        }
        system.debug('**** returning masterMap = '+masterMap);
        return masterMap;
    }*/
    
    public static Result convertGasFlowRate(GasFlowRate__c temp, decimal GasFlowRate_Value_From, decimal P_psia, decimal MW, decimal T_DegR, decimal Z) 
    {
        
        decimal convertedValue;
        decimal numerator;
        decimal numerator1;
        decimal denominator1;
        decimal numerator2;
        decimal denominator2;
        Result objResult = new Result();
        try{
            if (temp != null && temp.Id != null) 
            {
                numerator=GasFlowRate_Value_From*temp.Multiplier__c;
                numerator1=Math.pow(((P_psia*MW*144)/(1545*T_DegR*Z)).doubleValue(), temp.DensityActualFrom__c.doubleValue());
                denominator1=Math.pow(((P_psia*MW*144)/(1545*T_DegR*Z)).doubleValue(), temp.DensityActualTo__c.doubleValue());
                numerator2=Math.pow(((temp.PFromPsia__c*MW*144)/(1545*temp.TFromR__c*Z)).doubleValue(), temp.DensityStandardFrom__c.doubleValue());
                denominator2=Math.pow(((temp.PToPsia__c*MW*144)/(1545*temp.TToR__c*Z)).doubleValue(), temp.DensityStandardTo__c.doubleValue());
                objResult.dblRetValue=numerator*(numerator1/denominator1)*(numerator2/denominator2);
                objResult.bResult = true;
                System.debug('***** From = '+temp.GasFlowRate_UOM_From__c+', to = '+temp.GasFlowRate_UOM_To__c);
                System.debug('***** convertGasFlowRate : ' + string.valueof(objResult.dblRetValue));
            } else {
                objResult.bResult = false; 
                //objResult.dblRetValue=0;
                objResult.strErrorMessage = 'No Data Found';
            }
            
        }
        catch(Exception e) { 
            System.debug('The following exception has occurred: unitConversions:convertGasFlowRate()' + e.getMessage());
            objResult.bResult = false;
            //objResult.dblRetValue=0;
            objResult.strErrorMessage = e.getMessage();
            System.debug(objResult.strErrorMessage);
        }
        
        return objResult;
    }
}