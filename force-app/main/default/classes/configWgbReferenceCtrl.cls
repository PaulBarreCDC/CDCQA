public class configWgbReferenceCtrl {
    public WasteGasBurner__c oWGB{get;set;}
    public User oUser {get;set;}
    public Map<String, String> LowerStackPedestalMatlMap { get;set;}
    public Map<String, String> PedestalConnectionMap { get;set;}
    public Map<String, String> FlameSensorMap { get;set;}
    public Map<String, String> ThermocoupleMaterialMap { get;set;}
    public Map<String, String> EnclosureTypeMap { get;set;}
    public Map<String, String> ControlPanelAlarmMap { get;set;}
    public Map<String, String> ControlPanelHeaterMap { get;set;}
    public Map<String, String> StandControlMaterialMap { get;set;}
    public Map<String, String> SunshieldControlMap { get;set;}
    public Map<String, String> StepDownTransformerMap { get;set;}
    public Map<String, String> BackupPowerSupplyMap { get;set;}
    
    
    

    public string getUserTimeZone(){
        return userinfo.getTimeZone().toString();
    }
    
    public configWgbReferenceCtrl(ApexPages.StandardController controller){
        LowerStackPedestalMatlMap = new Map<String, String>();
        PedestalConnectionMap = new Map<String, String>();
        FlameSensorMap = new Map<String, String>();
        ThermocoupleMaterialMap = new Map<String, String>();
        EnclosureTypeMap = new Map<String, String>();
        ControlPanelAlarmMap = new Map<String, String>();
        ControlPanelHeaterMap = new Map<String, String>();
        StandControlMaterialMap = new Map<String, String>();
        SunshieldControlMap = new Map<String, String>();
        StepDownTransformerMap = new Map<String, String>();
        BackupPowerSupplyMap = new Map<String, String>();
	   //controller.addFields(new String[]{'Soft_Goods_Material_dynamic__c','Size__c','Connection_dynamic__c'});
       oWGB = (WasteGasBurner__c)controller.getRecord();    
        for(User u : [Select Id,Name From User Where Id =: userinfo.getUserId()]){
            oUser = u;
        }

        
        for(PicklistEntry entry : WasteGasBurner__c.Lower_Stack_Pedestal_Matl__c.getDescribe().getPicklistValues()){
            LowerStackPedestalMatlMap.put(entry.getValue(), entry.getLabel());
        }

        for(PicklistEntry entry : WasteGasBurner__c.Pedestal_Connection__c.getDescribe().getPicklistValues()){
            PedestalConnectionMap.put(entry.getValue(), entry.getLabel());
        }

        for(PicklistEntry entry : WasteGasBurner__c.Flame_Sensor__c.getDescribe().getPicklistValues()){
            FlameSensorMap.put(entry.getValue(), entry.getLabel());
        }

        for(PicklistEntry entry : WasteGasBurner__c.Thermocouple_Material__c.getDescribe().getPicklistValues()){
            ThermocoupleMaterialMap.put(entry.getValue(), entry.getLabel());
        }

        for(PicklistEntry entry : WasteGasBurner__c.Enclosure_Type__c.getDescribe().getPicklistValues()){
            EnclosureTypeMap.put(entry.getValue(), entry.getLabel());
        }

        for(PicklistEntry entry : WasteGasBurner__c.Control_Panel_Alarm__c.getDescribe().getPicklistValues()){
            ControlPanelAlarmMap.put(entry.getValue(), entry.getLabel());
        }

        for(PicklistEntry entry : WasteGasBurner__c.Control_Panel_Heater__c.getDescribe().getPicklistValues()){
            ControlPanelHeaterMap.put(entry.getValue(), entry.getLabel());
        }

        for(PicklistEntry entry : WasteGasBurner__c.Stand_Control_Material__c.getDescribe().getPicklistValues()){
            StandControlMaterialMap.put(entry.getValue(), entry.getLabel());
        }

        for(PicklistEntry entry : WasteGasBurner__c.Sunshield_Control__c.getDescribe().getPicklistValues()){
            SunshieldControlMap.put(entry.getValue(), entry.getLabel());
        }

        for(PicklistEntry entry : WasteGasBurner__c.Step_Down_Transformer__c.getDescribe().getPicklistValues()){
            StepDownTransformerMap.put(entry.getValue(), entry.getLabel());
        }

        for(PicklistEntry entry : WasteGasBurner__c.Back_up_Power_Supply__c.getDescribe().getPicklistValues()){
            BackupPowerSupplyMap.put(entry.getValue(), entry.getLabel());
        }

        

        
        

        
        
        

    }
}