public class ConfigPartSelectorReferenceCtrl {
    public Part_Selector__c oPS{get;set;}
    public User oUser {get;set;}
    public string getUserTimeZone(){
        return userinfo.getTimeZone().toString();
    }

    public List<attData> lstAttVal{get;set;}
    public map<string,string> mapAttWiseLabel;
    
    public ConfigPartSelectorReferenceCtrl(ApexPages.StandardController controller){
        if (!Test.isRunningTest()) { 
            controller.addFields(new String[]{'Product_Attribute_Data__c'});
        }
        mapAttWiseLabel = new map<string,string>();
        oPS = (Part_Selector__c)controller.getRecord();    
        for(User u : [Select Id,Name From User Where Id =: userinfo.getUserId()]){
            oUser = u;
        }

        string sProductAttributeData = oPS.Product_Attribute_Data__c;



        if(sProductAttributeData != null && sProductAttributeData != ''){
            lstAttVal = new list<attData>(); 
            sProductAttributeData = oPS.Product_Attribute_Data__c;
            list<ProductAttribueData> lstPAD =  ( List<ProductAttribueData>) JSON.deserialize(sProductAttributeData, List<ProductAttribueData>.class);
            
            for(PS_Input_Field_Labels__c IFL : [select id,Attribute_Text_Description__c,Attribute_Code__c,ProdGroup__c,SubGroup__c from PS_Input_Field_Labels__c  
                                                WHERE ProdGroup__c = : oPS.ProductGroup__c
                                                AND SubGroup__c = : oPS.SubGroup__c]){

                if(!mapAttWiseLabel.containsKey(IFL.Attribute_Code__c)){
                    mapAttWiseLabel.put(IFL.Attribute_Code__c, IFL.Attribute_Text_Description__c);
                }
            }
        
            
            
            for(ProductAttribueData pad : lstPAD){
                
                string sValue = fetchInputAttributeDesc(oPS.ProductGroup__c,oPS.SubGroup__c, pad.sAttributeCode, pad.sValue);
                attData oattData = new attData(mapAttWiseLabel.get(pad.sAttributeCode) , sValue);
                lstAttVal.add(oattData);
            }            
        }
     
    }

    private string fetchInputAttributeDesc(string PDgroup, string subPDgroup, string att, string sVal){

        List<PS_Input_Attr_Value_Desc__c > inputvaluesList=[select id,Text_Description_of_Attribute_Value__c,Attribute__c,ProdGroup__c,
                                                            SubGroup__c,Value__c
                                                            from PS_Input_Attr_Value_Desc__c
                                                            where ProdGroup__c=:PDgroup
                                                            and SubGroup__c=:subPDgroup
                                                            and Attribute__c = : att 
                                                            and value__c = : sVal LIMIT 1
                                                            ];
        return  inputvaluesList[0].Text_Description_of_Attribute_Value__c;

    }
    

    public class ProductAttribueData{
        String sAttributeCode ;
        String sValue;

        public ProductAttribueData(){
            sAttributeCode = '';
            sValue = '';
        }

        public ProductAttribueData(String sAttrCode,String sVal){
            sAttributeCode = sAttrCode;
            sValue = sVal;
        }
    }


    public class attData{
       public string sLable {get;set;}
       public string sValue {get;set;}
        public attData(string sLbl,string sVal){
            sLable = sLbl;
            sValue = sVal;
        }
    }

   

}