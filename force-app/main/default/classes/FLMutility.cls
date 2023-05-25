public with sharing class FLMutility 
{
    private static FLMutility instance = null;
    //the constructor is marked PRIVATE
    // so that no Apex code outside this class can create the instance
    private FLMutility()
    {

    }

    /*
    This static method will be the only way to get the Single
    instance of this class.
    */
    public static FLMutility getInstance()
    {
        if (instance == null)
        {
            // Create the single instance now.
            instance = new FLMutility();
        }
        return instance;
    }
    
    public static String getObjectFields(String objectName)
    {
        String fieldValues = '';
        SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        DescribeSObjectResult objDesc = objectType.getDescribe();
        Map<String, SObjectField> fields = objDesc.fields.getMap(); 
        Set<String> fieldSet = fields.keySet(); 
        for(String f : fieldSet)
        {
            fieldValues += f +',';
        }    
        if(fieldValues.endsWith(',')) 
        fieldValues= fieldValues.substring(0,fieldValues.length()-1);
        return fieldValues;
   }
    public static Map<String, Schema.SObjectField> getSobjectFieldsMap(Schema.SObjectType token)
    {
        Schema.DescribeSObjectResult sobject_describe = token.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        return field_map;
    }
    
    public static Map<String,String> getPicklistLabelByValue(Schema.SObjectType token, String picklistField)
    {
        Map<String,String> picklistLabelVsValue = new Map<String,String>();
        Map<String, Schema.SObjectField> field_map = getSobjectFieldsMap(token);
        List<Schema.PicklistEntry> pick_list_values = field_map.get(picklistField).getDescribe().getPickListValues();
        for(Schema.PicklistEntry a : pick_list_values) 
        {
            picklistLabelVsValue.put(a.getValue(),a.getLabel());
        }
        return picklistLabelVsValue;
    }
        
  /*  public List<selectOption> getAllPicklistOptions(Map<String,String> PicklistLabelAndValue)
    {
        List<selectOption> options = new List<selectOption>();
        for(String pickVal : PicklistLabelAndValue.keySet())
        {
            options.add(new selectOption(pickVal, PicklistLabelAndValue.get(pickVal)));
        }
        return options;
    }*/
    
   /* public List<selectOption> getBodyMaterialOptions(Flame_Product__c flmprod, Map<String,String> BodyMaterialPicklistMap, Map<String, Map<String, Map<String, List<FLM_MasterBlaster__c>>>> FLMMasterBlasterMap)
    {
        List<selectOption> options = new List<selectOption>();
        Set<String> bodyMaterialSet = new Set<String>();
        String bodyMaterialKey = flmProd.Model__c +'_'+ flmProd.Connection_Size__c +'_'+ flmProd.Element_Size__c;
        if(FLMMasterBlasterMap.size() > 0 && FLMMasterBlasterMap.containsKey(bodyMaterialKey))
        {
            for(String key: FLMMasterBlasterMap.get(bodyMaterialKey).keySet())
            {
                if(BodyMaterialPicklistMap.containsKey(key.substringAfterLast('_')))
                {
                    String label = BodyMaterialPicklistMap.get(key.substringAfterLast('_'));
                    if(bodyMaterialSet.add(label))
                    {
                        options.add(new selectOption(key.substringAfterLast('_'), label));
                    }
                }
            }
        }
        if(options.size() == 0)
        {
            options.addAll(getAllPicklistOptions(BodyMaterialPicklistMap));
        }
        return options;
    }
    
    public List<selectOption> getHouseMaterialOptions(Flame_Product__c flmprod, Map<String,String> HouseMaterialPicklistMap, Map<String, Map<String, Map<String, List<FLM_MasterBlaster__c>>>> FLMMasterBlasterMap)
    {
        List<selectOption> options = new List<selectOption>();
        Set<String> houseMaterialSet = new Set<String>();
        String bodyMaterialKey = flmProd.Model__c +'_'+ flmProd.Connection_Size__c +'_'+ flmProd.Element_Size__c;
        String houseMaterialKey = bodyMaterialKey + '_'+ flmProd.Body_Material__c;
        if(FLMMasterBlasterMap.size() > 0 && FLMMasterBlasterMap.containsKey(bodyMaterialKey))
        {
            if(FLMMasterBlasterMap.get(bodyMaterialKey).containsKey(houseMaterialKey))
            {
                for(String key: FLMMasterBlasterMap.get(bodyMaterialKey).get(houseMaterialKey).keySet())
                {
                    if(HouseMaterialPicklistMap.containsKey(key.substringAfterLast('_')))
                    {
                        String label = HouseMaterialPicklistMap.get(key.substringAfterLast('_'));
                        if(houseMaterialSet.add(label))
                        {
                            options.add(new selectOption(key.substringAfterLast('_'), label));
                        }
                    }
                }
            }
        }
        if(options.size() == 0)
        {
            options.addAll(getAllPicklistOptions(HouseMaterialPicklistMap));
        }
        return options;
    }
    
    public List<selectOption> getElementMaterialOptions(Flame_Product__c flmprod, Map<String,String> ElementMaterialPicklistMap, Map<String, Map<String, Map<String, List<FLM_MasterBlaster__c>>>> FLMMasterBlasterMap)
    {
        List<selectOption> options = new List<selectOption>();
        Set<String> ElementMaterialSet = new Set<String>();
        String bodyMaterialKey = flmProd.Model__c +'_'+ flmProd.Connection_Size__c +'_'+ flmProd.Element_Size__c;
        String houseMaterialKey = bodyMaterialKey + '_'+ flmProd.Body_Material__c;
        String elementMaterialKey = houseMaterialKey + '_'+ flmProd.Element_Material__c;
        if(FLMMasterBlasterMap.size() > 0 && FLMMasterBlasterMap.containsKey(bodyMaterialKey))
        {
            if(FLMMasterBlasterMap.get(bodyMaterialKey).containsKey(houseMaterialKey))
            {
                if(FLMMasterBlasterMap.get(bodyMaterialKey).get(houseMaterialKey).containsKey(elementMaterialKey))
                {
                 	for(FLM_MasterBlaster__c fm: FLMMasterBlasterMap.get(bodyMaterialKey).get(houseMaterialKey).get(elementMaterialKey))
                    {
                        if(ElementMaterialPicklistMap.containsKey(fm.ElemMatlCode__c))
                        {
                            String label = ElementMaterialPicklistMap.get(fm.ElemMatlCode__c);
                            if(ElementMaterialSet.add(label))
                            {
                                options.add(new selectOption(fm.ElemMatlCode__c, label));
                            }
                        }
                    }
                }
            }
        }
        if(options.size() == 0)
        {
            options.addAll(getAllPicklistOptions(ElementMaterialPicklistMap));
        }
        return options;
    }*/
	
}