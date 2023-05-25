public with sharing class TestConfigureRD { 
    // public Rupture_Disc__c conProd {set; get;}
    // public RDRatingRange rtgRngWrap {set; get;}
    // public id quoteLineId {set;get;}
    // public product2 prod {set;get;}
    // public string dynamicProdNarrowFilter {set;get;}
    // public TestConfigureRD(ApexPages.StandardController controller) {
    //     quoteLineId=ApexPages.currentPage().getParameters().get('qid');
    //     System.debug('QuoteLine'+quoteLineId);
    //     prod=[select Name,Engineering_Notes__c from Product2 where Name='Rupture Disc'and IsActive=true limit 1];
        
    //     id RecordID=wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLineId);
    //     result resConProd=wizardBaseDataProcessor.getObjectDataById(RecordID);
        
    //     if (!resConProd.objResultList.isEmpty())
    //         conProd= (Rupture_Disc__c) resConProd.objResultList[0];
    //     else
    //         conProd=new Rupture_Disc__c();
    //     strBrand=[select Quote_Line__r.SBQQ__Quote__r.Brand__c from Rupture_Disc__c where id=:conProd.Id].Quote_Line__r.SBQQ__Quote__r.Brand__c;
    //     if (conProd.Process_Media__c!=null) {
    //         List<Media_Property__c> mD=[select Media__c,Media_Phase__c,MolecularWeight__c,SpecificHeatRatio__c,Density__c,CompressFactor__c from Media_Property__c where Media__c=:conProd.Process_Media__c];
    //         if ( ! mD.isEmpty()) {
    //             conProd.Molecular_Weight__c=mD.get(0).MolecularWeight__c;
    //             conProd.Compressibility_Factor__c=mD.get(0).CompressFactor__c;
    //             conProd.Ratio_of_Specific_Heats__c=mD.get(0).SpecificHeatRatio__c;
    //             conProd.Customer_Specified_Media__c=mD.get(0).Media__c;
    //             System.debug('dfghjsfrdgdfhdfhdfk'+conProd.Process_Media__c);
    //             System.debug('dfghjsfrdgdfhdfhdfk'+mD.get(0));
    //             disableMediaValues=true;
    //         } else {
    //             disableMediaValues=false;       
    //         }
    //     }
    // }
    // public string strBrand {set;get;}
    // public boolean disableMediaValues {set; get;}
    // public decimal decPBrustConvertedValue { 
    //     get {
    //         return conProd.Converted_Pressure_Setting__c;
    //     } 
    //     set {
    //         this.decPBrustConvertedValue=value;
    //     } 
    // }
    // public decimal decConRelievingPressure {set;get;}
    // public decimal decConRelievingTemp {set;get;}
    // public decimal decVBrustConvertedValue { 
    //     get {
    //         return conProd.Converted_Vacuum_Setting__c;
    //     } 
    //     set {
    //         this.decPBrustConvertedValue=value;
    //     } 
    // }
    // public decimal doubleConvertedFlowCapacity {get;set;}
    // public decimal decBackPressConv {
    //     get {
    //         return 0.0;
    //     }
    //     set {
    //         this.decBackPressConv=value;
    //     }
    // } 
    // public boolean showPressure {
    //     get {
    //         return conProd.Relief_Type__c=='Pressure Relief'? true:false;
    //     }
    //     set {
    //         this.showPressure=value;
    //     }
    // } 
    // public boolean showSecB {
    //     get {
    //         return conProd.constrain_product_selection_by_flow__c=='Yes'? true:false;
    //     }
    //     set {
    //         this.showSecB=value;
    //     }
    // }
    // public boolean showVacuum {
    //     get {
    //         return conProd.Relief_Type__c=='Vacuum Relief'? true:false;
    //     }
    //     set {
    //         this.showPressure=value;
    //     }
    // } 
    // public boolean showPressureVacuum {
    //     get {
    //         return conProd.Relief_Type__c=='Pressure & Vacuum Relief'? true:false;
    //     }
    //     set {
    //         this.showPressure=value;
    //     }
    // }
    // public String selectedTab {
    //     get {
    //         String selectedTabParam = ApexPages.currentPage().getParameters().get('selectedTab');
    //         if(String.IsBlank(selectedTab) && String.IsNotBlank(selectedTabParam)) {
    //             return selectedTabParam;
    //         } else if(String.IsNotBlank(selectedTab)) {
    //             return selectedTab;
    //         }
    //         return '';
    //     }
    //     set;
    // }
    // public List<SelectOption> getReliefTypes(){
    //     Schema.sObjectType sobject_type = Rupture_Disc__c.getSObjectType();
    //     Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
    //     Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
    //     List<Schema.PicklistEntry> pick_list_values = field_map.get('Relief_Type__c').getDescribe().getPickListValues();
    //     List<selectOption> options = new List<selectOption>();
    //     for (Schema.PicklistEntry a : pick_list_values) {
    //         options.add(new selectOption(a.getLabel(), a.getValue()));
    //     }
    //     return options;
    // }
    //     public PageReference defalutASME() {
    //     conProd.ASME_BPE__c=conProd.CSA_Marking_CRN_Number__c ;
    //     return null;
    // }
    //     public PageReference saveCertificate() {
    //     try {
    //         conProd.Bypass__c=false;
    //         upsert conProd;
    //     }
    //     catch(Exception dmle) 
    //     {
    //         ApexPages.addMessages(dmle);
    //         return null;                                   
    //     }
        
    //     return null;
    // }

    //     public list<SelectOption> getDiscMaterial () {
    //     list<selectOption> options = new List<selectOption>();
    //     AggregateResult[] aggResult=[SELECT MatlCodePos__c,count(id) FROM RDMasterBlaster__c GROUP BY MatlCodePos__c];
    //     Schema.DescribeFieldResult fieldResult = Rupture_Disc__c.Material_of_Top_Section__c.getDescribe();
    //     List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    //     Map<string,string> myMap=new Map<string,string>();
    //     for( Schema.PicklistEntry pickListVal : ple)
    //         myMap.put(pickListVal.getValue(),pickListVal.getLabel());
    //     for (AggregateResult ar : aggResult)  {
    //         if (ar.get('MatlCodePos__c')=='-')
    //             options.add(new selectOption('-','-'));
    //         else
    //             options.add(new selectOption((String) ar.get('MatlCodePos__c'),myMap.get((String) ar.get('MatlCodePos__c'))));
            
    //     }
    //     return options;
        
    // }
    //     public PageReference saveProductNarrowing() {
    //     try {
    //         conProd.Bypass__c=false;
    //         upsert conProd;
    //     }
    //     catch(Exception dmle) 
    //     {
    //         ApexPages.addMessages(dmle);
    //         return null;                                   
    //     }
    //     return null;
    // }

    // public pageReference showSection() {
    //     if(!String.isBlank(conProd.Process_Media__c)) {
    //         List<Media_Property__c>  mD=[select Media__c,Media_Phase__c,MolecularWeight__c,SpecificHeatRatio__c,Density__c,CompressFactor__c from Media_Property__c where Media__c=:conProd.Process_Media__c];
    //         if ( ! mD.isEmpty()) {
    //             conProd.Customer_Specified_Media__c=mD.get(0).Media__c;
    //             conProd.Molecular_Weight__c=mD.get(0).MolecularWeight__c;
    //             conProd.Compressibility_Factor__c=mD.get(0).CompressFactor__c;
    //             conProd.Ratio_of_Specific_Heats__c=mD.get(0).SpecificHeatRatio__c;
    //             //System.debug('dfghjsfrdgdfhdfhdfk'+conProd.Process_Media__c);
    //             //System.debug('dfghjsfrdgdfhdfhdfk'+mD.get(0));
    //             disableMediaValues=true;
    //         } else {
    //             disableMediaValues=false;       
    //         }
    //     }
    //     return null;
    // }
	
    
    // public string getProductNarrowFilterClause() {
    //     string strdynamicWhereClause='Id != null';
    //     //Filter For Brand this is the first filter on the Master Blaster table.
    //     /*if(strBrand!=null)
    //         strdynamicWhereClause+=' AND Brand__c=\''+strBrand+'\'';
    //     System.debug('Dynamic Query getProductNarrowFilterClause'+strdynamicWhereClause);
    //     //Filter on Direction
    //     if(conProd.Relief_Type__c!='') {
    //         if (conProd.Relief_Type__c=='Pressure Relief' )
    //             strdynamicWhereClause+=' AND Direction__c=\'P\'';
    //         else if (conProd.Relief_Type__c=='Pressure Relief')
    //             strdynamicWhereClause+=' AND Direction__c=\'V\'';
    //         else
    //             strdynamicWhereClause+=' AND Direction__c=\'B\'';
    //     }
    //     System.debug('Dynamic Query getProductNarrowFilterClause'+strdynamicWhereClause);

    // //     //Filter on PressLL and PressUL
    // //     if (decPBrustConvertedValue!=null) 
    // //         strdynamicWhereClause+=' AND PRESSLL__c <='+ decPBrustConvertedValue+' and PRESSUL__c>='+decPBrustConvertedValue;        
    // //     System.debug('Dynamic Query getProductNarrowFilterClause'+strdynamicWhereClause);

    // // // Filter on VacLL and VacUL
    // //     if (conProd.Converted_Vacuum_Setting__c!=null)
    // //         strdynamicWhereClause+=' AND VacLL__c <='+ decVBrustConvertedValue+' and VacUL__c>='+decVBrustConvertedValue;        
    // //     System.debug('Dynamic Query getProductNarrowFilterClause'+strdynamicWhereClause);

    // //     //Filter on Vac WithStand
    // //     if (!String.IsBlank(conProd.Vacuum_Withstand__c) && conProd.Vacuum_Withstand__c!='No Requirements') {
    // //         decimal decBackPress;
    // //         if (conProd.Vacuum_Withstand__c!='Full Vacuum') {
    // //             decBackPress=15;
    // //         } else {
    // //             decBackPress=conProd.Converted_Back_Pressure_Value__c;
    // //         }
    // //         string strSubQuery;
    // //         strSubQuery=' AND ((VacWithstand_Ind__c=\'Value\' AND VacValue__c>='+decBackPress+')';
    // //         decimal decValue=decBackPress/decPBrustConvertedValue;
    // //         strSubQuery+=' OR (VacWithstand_Ind__c=\'Ratio\' AND VacValue__c>='+decValue+'))';
    // //         strdynamicWhereClause+=strSubQuery;
    // //     }
    //     //Filter on Liquid Scenario
    //     if(conProd.Is_there_a_liquid_relief_scenario__c!='') {
    //         string val;
    //         if(conProd.Is_there_a_liquid_relief_scenario__c!='Yes') 
    //             val='Either'; 
    //         else
    //             val='Gas'; 
    //         strdynamicWhereClause+=' AND Liquid_Relief__c=\''+val+'\'';
    //     }
    //     // Filter on Pos WithStand
    //     if (!String.isBlank(conProd.Pressure_Withstand__c) && conProd.Pressure_Withstand__c!='No Requirements') {
    //         decimal decPosPress;
    //         decPosPress=conProd.Converted_Positive_Pressure_Value__c;
    //         string strSubQuery;
    //         strSubQuery=' AND ((PosWithstand_Ind__c=\'Value\' AND PosValue__c>='+decPosPress+')';
    //         decimal decValue=decPosPress/decVBrustConvertedValue;
    //         strSubQuery+=' OR (PosWithstand_Ind__c=\'Ratio\' AND PosValue__c>='+decValue+'))';
    //         strdynamicWhereClause+=strSubQuery;
    //     }
    //     System.debug('strdynamicWhereClause' +strdynamicWhereClause);
    //     //Need to add filter on MNFA

    //     //Filters on Section C
    //     if(conProd.Atex_Certificate__c!=null) {
    //         if(conProd.Atex_Certificate__c)
    //             strdynamicWhereClause+=' AND Atex__c=\'Yes\'';
    //         else
    //             strdynamicWhereClause+=' AND Atex__c=\'No\'';
    //     }
    //     if(conProd.CU_TR__c!=Null) {
    //         if(conProd.CU_TR__c)
    //             strdynamicWhereClause+=' AND CU_TR_Compliant_Discs__c=\'Yes\'';
    //         else
    //             strdynamicWhereClause+=' AND CU_TR_Compliant_Discs__c=\'No\'';
    //     }
    //     if(conProd.X3A_Sanitary_Standards__c!=null) {
    //         if(conProd.X3A_Sanitary_Standards__c)
    //             strdynamicWhereClause+=' AND X3A__c=\'Yes\'';
    //         else
    //             strdynamicWhereClause+=' AND X3A__c=\'No\'';
    //     }
    //     if(!String.IsBlank(conProd.NACE__c)) 
    //         strdynamicWhereClause+=' AND NACE__c=\'Yes\'';
    //     else
    //         strdynamicWhereClause+=' AND NACE__c=\'No\'';
        
    //     //Filters on Section D
    //     if(conProd.Non_Fragmenting_Design_Required__c!=null) {
    //         if(conProd.Non_Fragmenting_Design_Required__c)
    //             strdynamicWhereClause+=' AND NonFragDesign__c=\'Yes\'';
    //         else
    //             strdynamicWhereClause+=' AND NonFragDesign__c=\'No\'';
    //     }
    //     // if(!String.IsBlank(conProd.Non_Fragmenting_Design_Required__c)) {
    //     //     if(conProd.CU_TR__c)
    //     //         strdynamicWhereClause+=' AND NonFragDesign__c=\'Yes\'';
    //     //     else
    //     //         strdynamicWhereClause+=' AND NonFragDesign__c=\'No\'';
    //     // }
    //     if (!String.IsBlank(conProd.Operating_Pressure_Ratio__c)) {
    //         Decimal strToDec = decimal.valueOf(conProd.Operating_Pressure_Ratio__c);
    //         strdynamicWhereClause+=' AND OPtoBpRatio__c>='+strToDec;
            
    //     }
    //     if (!String.IsBlank(conProd.Application_type__c)) {
    //         //Decimal strToDec = decimal.valueOf(conProd.Operating_Pressure_Ratio__c);
    //         strdynamicWhereClause+=' AND Application__c=\''+conProd.Application_type__c+'\'';
            
    //     }*/
    //     return strdynamicWhereClause;
    // }
    // /* This method will return the list of MasterBlaster Data after narrowing*/
    // // TODO : Save DSCVAR__c, Derate_Teflon__c, and DerateType__c to Rupture_Disc__c fields(same name) for use in Components, Engineering(Currently in RDRatingRange.cls)
    // //  Follow-up with Shailesh and Sai, as the product selection in the new UI restricts the user to select a single record that sets PTC/SZC/STC from a single RDMasterBlaster__c record,
    // //      but the VF page lets user pick separate values for each that could allow invalid configurations
    // @AuraEnabled
    // public String previousWhereClause = ''; 
    // public List<RDMasterBlaster__c> rDMBRecords {
    //     get {
    //         String queryString='select PTC__c,SZC__c,STC__c, DSCVAR__c, DerateType__c, Derate_Teflon__c from RDMasterBlaster__c';
    //         //String whereClause=' WHERE ';
    //         //whereClause+=getProductNarrowFilterClause();
    //         String whereClause=' LIMIT 500 ';
    //         if((rDMBRecords != null && !rDMBRecords.isEmpty()) && whereClause == previousWhereClause) {
    //             return rDMBRecords;
    //         }
    //         previousWhereClause = whereClause;          //  Set the current criteria to the stored variable
    //         queryString = queryString + whereClause;
    //         //string order_by=' order by SZC__c';         //  Set "ORDER BY" in query string
    //         //string order_by = ' order by DESC';
    //         //queryString=queryString+order_by;           //  Append "ORDER BY" to the query string
    //         System.debug('rDMBRecords Query : ' + queryString);
    //         List<RDMasterBlaster__c> sobjList = Database.query(queryString);
    //         System.debug('rDMBRecords Query : ' + queryString);
    //         //System.debug('rDMBRecords Result : ' + queryString);
    //         return sobjList;    // Return
    //     }
    //     private set;
    // }

    // @AuraEnabled
    // public Map<String, RDOptions> getRDRecords() {
    //     Map<String, RDOptions> records = new Map<String, RDOptions>();  //  Create list to store results
    //     //  IF rDMBRecords is empty, or any of the filter criteria is null, skip function
    //     //   ELSE loop over RDMasterBlaster__c records, and return only the unique combinations of product, seat, and size
    //     Set<String> uniqueCombinations = new Set<String>();
    //     if(rDMBRecords.isEmpty()) {
    //         System.debug('No records fit criteria');
    //     } else {            
    //         for(RDMasterBlaster__c rdmb : rDMBRecords) {
    //             String keyCheck = rdmb.PTC__c + '|' + rdmb.SZC__c.intValue() + '|' + String.valueOf(rdmb.STC__c);
    //             // IF the RDMasterBlaster__c record's attributes are not present yet, add to the unique set
    //             if(!uniqueCombinations.contains(keyCheck)) {
    //                 records.put(keyCheck, new RDOptions(rdmb.PTC__c, rdmb.STC__c, rdmb.SZC__c, rdmb.DSCVAR__c, rdmb.DerateType__c, rdmb.Derate_Teflon__c));
    //                 uniqueCombinations.add(keyCheck);
    //             }
    //         }
    //     }
    //     return records;
    // }
    // public class RDOptions {
    //     @AuraEnabled
    //     public String product {get;set;}
    //     @AuraEnabled
    //     public String seat {get;set;}
    //     @AuraEnabled
    //     public Decimal size {get;set;}
    //     @AuraEnabled
    //     public String dsc {get;set;}
    //     @AuraEnabled
    //     public String drtType {get;set;}
    //     @AuraEnabled
    //     public Decimal drtTeflon {get;set;}
    //     @AuraEnabled
    //     public String imageURL {get;set;}
    //     public RDOptions(String PTC, String STC, Decimal SZC, String DSCVAR, String DERATETYPE, Decimal DERATETEF) {
    //         product = PTC;
    //         seat = STC;
    //         size = SZC;
    //         dsc = DSCVAR;
    //         drtTeflon = DERATETEF;
    //         drtType = DERATETYPE;
    //         imageURL = getImageURL(PTC);    // USE {!$Resource.cdcStaticResource + RDOption_variable_name.imageURL}
    //     }
    //     public String getImageURL(String prodCode) {
    //         return '/assets/images/products/' + (ConstantsUtil.prodCodeImageNameMap.containsKey(prodCode) ? ConstantsUtil.prodCodeImageNameMap.get(prodCode) : 'STANDARD 30deg SEAT') + '.png';
    //     }
    //     public String getDetails() {
    //         return 'PTC : ' + product + '; STC : ' + seat + '; SZC : ' + String.valueOf(size) + '; DSCVAR : ' + dsc + '; DerateType : ' + drtType +  '; DerateTeflon : ' + drtTeflon;
    //     }
    // }
    // public List<SelectOption> getProductValues() {
    //     List<selectOption> prodOptions = new List<selectOption>();
    //     prodOptions.add(new selectOption('',''));
    //     List<string> uniqueList=new List<string>();
    //     for (RDMasterBlaster__c kv: rDMBRecords ) {
    //         if(!uniqueList.contains(kv.PTC__c)){
    //             uniqueList.add(kv.PTC__c);
    //             prodOptions.add(new selectOption(kv.PTC__c,ConstantsUtil.mapPTCDesc.get(kv.PTC__c)));
    //         }
    //     }
    //     return prodOptions;
    // }
    // public List<SelectOption> getSeatValues() {
    //     List<selectOption> seatOptions = new List<selectOption>();
    //     seatOptions.add(new selectOption('',''));
    //     List<string> uniqueList=new List<string>();
    //     for (RDMasterBlaster__c kv: rDMBRecords ) {
    //         if(!uniqueList.contains(kv.STC__c)){
    //             uniqueList.add(kv.STC__c);
    //             seatOptions.add(new selectOption(kv.STC__c,ConstantsUtil.mapSTCDesc.get(kv.STC__c)));
    //         }
    //     }
    //     return seatOptions;
    // }
    // public List<SelectOption> getSizeValues() {
    //     List<selectOption> sizeOptions = new List<selectOption>();
    //     sizeOptions.add(new selectOption('',''));
    //     List<string> uniqueList=new List<String>();
    //     for (RDMasterBlaster__c kv: rDMBRecords ) {
    //         Integer a= Integer.valueOf(kv.SZC__c.stripTrailingZeros());
    //         String val=String.valueOf(a);
    //         if(!uniqueList.contains(val)){
    //             uniqueList.add(val);
    //             sizeOptions.add(new selectOption(val,ConstantsUtil.getSzcDesc(val)));
    //         }
    //     }
    //     return sizeOptions;
    // }
    // public PageReference showEvalutionPerSec() {
    //     //system.debug('AAAA'+conProd.Evaluation_Per__c);
    //     if(conProd.Evaluation_Per__c=='ASME Gas/Vapor')
    //     {
    //         //showASMEGas=true;
    //         //showASMEWater=false;
    //         //system.debug('AAA55A'+showASMEGas);
    //     }
    //     else if (conProd.Evaluation_Per__c=='ASME Water')
    //     {
    //         //showASMEWater=true;
    //         //showASMEGas=false;
    //     }
    //     return null;
        
    // }
    // public PageReference showSectionB() {
        
    //     return null; 
    // }
    // public List<SelectOption> getFlowRateOtions() {
    //     List<selectOption> options = new List<selectOption>();
    //     if (!String.IsBlank(conProd.Evaluation_Per__c)) {
    //         if (unitConversions.listGasFlowRatenew.contains(conProd.Evaluation_Per__c)) {
    //             options=unitConversions.optsGasFlowRate;
    //         } else if (unitConversions.listLiquidFlowRatenew.contains(conProd.Evaluation_Per__c)) {
    //             options=unitConversions.optsLiquidFlowRate;
    //         } else if (unitConversions.listStreamFlowRatenew.contains(conProd.Evaluation_Per__c)) {
    //             options=unitConversions.optsStreamFlowRate;
    //         }     
    //     }
    //     return options;
    // }
    // public List<SelectOption> getMediaTypes() {
    //     List<selectOption> options = new List<selectOption>();
    //     options.add(new selectOption('',''));
    //     options.add(new selectOption('Customer Specified','Customer Specified'));
    //     System.debug('dsbckbdskfj'+conProd.Evaluation_Per__c);
    //     if (conProd.Evaluation_Per__c!=null) {
    //         String mediaTy;
    //         if (conProd.Evaluation_Per__c=='ASME Gas/Vapor' || conProd.Evaluation_Per__c=='API Gas/Vapor' || conProd.Evaluation_Per__c=='ISO Gas/Vapor') {
    //             mediaTy='Gas/Vapor';
    //             System.debug('dsbckbdskfjbjkbk'+conProd.Evaluation_Per__c);
    //         } else if (conProd.Evaluation_Per__c=='ASME Water' || conProd.Evaluation_Per__c=='API Liquid' || conProd.Evaluation_Per__c=='ISO Liquid'|| conProd.Evaluation_Per__c=='API Omega Method Subcooled Liquid' ) {
    //             mediaTy='Liquid';
    //         } else if (conProd.Evaluation_Per__c=='ASME Steam' || conProd.Evaluation_Per__c=='API Steam' || conProd.Evaluation_Per__c=='ISO Dry Steam' || conProd.Evaluation_Per__c=='ISO Wet Steam') {
    //             mediaTy='Dry and Saturated Steam*Dry and Saturated or Superheated Steam*Homogenous Wet Steam of Dryness 90% and Over';
    //         } else {
    //             mediaTy='';
    //         }
    //         System.debug('eeeeeeeeeee'+mediaTy);
    //         List<Media_Property__c> mediaPropertyList=[select Media_Phase__c,Media__c from Media_Property__c where Media_Phase__c=:mediaTy];
    //         for (Media_Property__c mP:mediaPropertyList) {
    //             options.add(new selectOption(mP.Media__c,mP.Media__c));
    //         }
    //     }
    //     System.debug('eeeeeeeeeee'+options);
    //     return options;
    // }
    // public PageReference applyDefaluts() {
    //     if (conProd.Pressure_Units__c!=null) {
    //         conProd.Pressure_Setting_Units__c=conProd.Pressure_Units__c;
    //         conProd.Back_Pressure_Units__c=conProd.Pressure_Units__c;
    //         conProd.Positive_Pressure_Units__c=conProd.Pressure_Units__c;
    //         conProd.Enter_Relieving_Pressure_units__c=conProd.Pressure_Units__c;    
    //         conProd.Vacuum_Setting_Units__c=conProd.Pressure_Units__c;
    //     }
    //     if (conProd.Temperature_Units__c!=null) {
    //         conProd.Temperature_Setting_Units__c =conProd.Temperature_Units__c;
    //         conProd.Enter_Different_Temperature_Units__c=conProd.Temperature_Units__c ; 
            
    //     }
    //     if(conProd.Flow_Rate_Units__c!=null) {
    //         //conProd.Required_Flow_Capacity_Units__c=conProd.Flow_Rate_Units__c;
    //         conProd.Required_Flow_Units__c=conProd.Flow_Rate_Units__c;
    //     }
    //     return null;
    // }
    // public PageReference saveRelief() {
    //     conProd.Relief_Flag__c=true;
    //     Result resultConvertPressure= new Result();
    //     Result resultConvertTemperature= new Result();
    //     Result resultConvertVaccum= new Result();
    //     Result resultConvertPositivePressure= new Result();
    //     if(conProd.Relief_Type__c=='Pressure Relief') {
            
    //         if (conProd.Pressure_Setting__c != Null)
    //         {
    //             resultConvertPressure=unitConversions.convertPressure(conProd.Pressure_Setting_Units__c,'psig',conProd.Pressure_Setting__c);
    //             if(resultConvertPressure.bResult)
    //                 conProd.Converted_Pressure_Setting__c=resultConvertPressure.dblRetValue;
    //             else
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
    //         }          
    //         if (conProd.Temperature_Setting__c != Null)
    //         {
    //             resultConvertTemperature=unitConversions.convertTemperature(conProd.Temperature_Setting_Units__c,'Deg F',conProd.Temperature_Setting__c);
    //             if(resultConvertTemperature.bResult)
    //                 conProd.Converted_Temperature_Setting__c=resultConvertTemperature.dblRetValue;
    //             else
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertTemperature.strErrorMessage));
    //         }
    //         Result resultConvertBackPressure= new Result();
    //         if (conProd.Back_Pressure_Value__c != Null)
    //         {
    //             resultConvertBackPressure=unitConversions.convertPressure(conProd.Back_Pressure_Units__c,'psig',conProd.Back_Pressure_Value__c);
    //             if(resultConvertBackPressure.bResult)
    //                 conProd.Converted_Back_Pressure_Value__c=resultConvertBackPressure.dblRetValue;
    //             else
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,resultConvertBackPressure.strErrorMessage));
    //         }
    //     } else if (conProd.Relief_Type__c=='Vacuum Relief') {
            
            
    //         if (conProd.Vacuum_Setting__c != Null)
    //         {
                
    //             resultConvertVaccum=unitConversions.convertPressure(conProd.Vacuum_Setting_Units__c,'psig',conProd.Vacuum_Setting__c);
    //             if(resultConvertVaccum.bResult)
    //                 conProd.Converted_Vacuum_Setting__c=resultConvertVaccum.dblRetValue;
    //             else
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertVaccum.strErrorMessage));
    //         }
    //         if (conProd.Temperature_Setting__c != Null)
    //         {
                
    //             resultConvertTemperature=unitConversions.convertTemperature(conProd.Temperature_Setting_Units__c,'Deg F',conProd.Temperature_Setting__c);
    //             if(resultConvertTemperature.bResult)
    //                 conProd.Converted_Temperature_Setting__c=resultConvertTemperature.dblRetValue;
    //             else
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,resultConvertTemperature.strErrorMessage));
    //         }
    //         if (conProd.Positive_Pressure_Value__c != Null)
    //         { 
                
    //             resultConvertPositivePressure=unitConversions.convertPressure(conProd.Positive_Pressure_Units__c,'psig',conProd.Positive_Pressure_Value__c);
    //             if(resultConvertPositivePressure.bResult)
    //                 conProd.Converted_Positive_Pressure_Value__c=resultConvertPositivePressure.dblRetValue;
    //             else
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPositivePressure.strErrorMessage));
    //         }
    //     } else {
    //         if (conProd.Pressure_Setting__c != Null)
    //         { 
    //             resultConvertPressure=unitConversions.convertPressure(conProd.Pressure_Setting_Units__c,'psig',conProd.Pressure_Setting__c);
    //             if(resultConvertPressure.bResult)
    //                 conProd.Converted_Pressure_Setting__c=resultConvertPressure.dblRetValue;
    //             else
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertPressure.strErrorMessage));
    //         }
    //         if (conProd.Temperature_Setting__c != Null)
    //         { 
                
    //             resultConvertTemperature=unitConversions.convertTemperature(conProd.Temperature_Setting_Units__c,'Deg F',conProd.Temperature_Setting__c);
    //             if(resultConvertTemperature.bResult)
    //                 conProd.Converted_Temperature_Setting__c=resultConvertTemperature.dblRetValue;
    //             else
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertTemperature.strErrorMessage));
    //         }
    //         if (conProd.Vacuum_Setting__c != Null)
    //         { 
                
    //             resultConvertVaccum=unitConversions.convertPressure(conProd.Vacuum_Setting_Units__c,'psig',conProd.Vacuum_Setting__c);
    //             if(resultConvertVaccum.bResult)
    //                 conProd.Converted_Vacuum_Setting__c=resultConvertVaccum.dblRetValue;
    //             else
    //                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, resultConvertVaccum.strErrorMessage)); 
    //         }
    //     }
    //     try {
    //         //string str=getProductNarrowFilterClause();
    //         string str= ' LIMIT 500 ';
    //         conProd.Bypass__c=false;
    //         upsert conProd;
    //     }
    //     catch(Exception dmle) 
    //     {
    //         ApexPages.addMessages(dmle);
    //         return null;                                   
    //     }
    //     return null;
    // }
    // public void clearDataBasedOnReliefType(){
    //     if (conProd.Relief_Type__c=='Pressure Relief'){
    //         conProd.Vacuum_Setting__c=null;
    //         conProd.Vacuum_Setting_Units__c=null;
    //         conProd.Positive_Pressure_Value__c=null;
    //         conProd.Positive_Pressure_Units__c=null;
    //         conProd.Pressure_Withstand__c=null;
    //         conProd.Constrain_product_selection__c=null;
    //     }
    //     if(conProd.Relief_Type__c=='Vacuum Relief'){
    //         conProd.Pressure_Setting__c=null;
    //         conProd.Pressure_Setting_Units__c=null;
    //         conProd.Vacuum_Withstand__c=null;
    //         conProd.Positive_Pressure_Value__c=null;
    //         conProd.Positive_Pressure_Units__c=null;
    //         conProd.Constrain_product_selection__c=null;
    //     }
    //     if (conProd.Relief_Type__c=='Pressure & Vacuum Relief'){
    //         conProd.Vacuum_Withstand__c=null;
    //         conProd.Back_Pressure_Value__c=null;
    //         conProd.Back_Pressure_Units__c=null;
    //         conProd.Positive_Pressure_Value__c=null;
    //         conProd.Positive_Pressure_Units__c=null;
    //         conProd.Pressure_Withstand__c=null;
    //     }
    // }
    // public void clearSizingData() {
    //     switch on conProd.Evaluation_Per__c {
    //         When 'ASME Gas/Vapor' {
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //         }
    //         when 'ASME Water'{
    //             conProd.Pressure_Relieving_Temperature__c=null;
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Enter_Different_Temperature_Value__c=null;
    //             conProd.Enter_Different_Temperature_Units__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //         }
    //         when 'ASME Steam'{
    //             conProd.Pressure_Relieving_Temperature__c=null;
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Enter_Different_Temperature_Value__c=null;
    //             conProd.Enter_Different_Temperature_Units__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //         }
    //         when 'API Gas/Vapor'{
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //         }
    //         when 'API Liquid'{
    //             conProd.Pressure_Relieving_Temperature__c=null;
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Enter_Different_Temperature_Value__c=null;
    //             conProd.Enter_Different_Temperature_Units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //         }
    //         when 'API Steam'{
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //         }
    //         when 'ISO Gas/Vapor'{
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //         }
    //         when 'ISO Liquid'{
    //             conProd.Pressure_Relieving_Temperature__c=null;
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Enter_Different_Temperature_Value__c=null;
    //             conProd.Enter_Different_Temperature_Units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //         }
    //         when 'ISO Dry Steam'{
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //         }
    //         when 'ISO Wet Steam'{
    //             conProd.Pressure_Relieving_Temperature__c=null;
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Enter_Different_Temperature_Value__c=null;
    //             conProd.Enter_Different_Temperature_Units__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //         }
    //         when 'API Omega Method 2 Phase Flashing or Nonflashing'{
    //             conProd.Pressure_Relieving_Temperature__c=null;
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Enter_Different_Temperature_Value__c=null;
    //             conProd.Enter_Different_Temperature_Units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //         }
    //         when 'API Omega Method Subcooled Liquid'{
    //             conProd.Pressure_Relieving_Temperature__c=null;
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Enter_Different_Temperature_Value__c=null;
    //             conProd.Enter_Different_Temperature_Units__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Liquid_density__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //         }
    //         when 'Fauske 2 Phase Gas-Liquid'{
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_vapor_density__c=null;
    //             conProd.Latent_heat_of_vaporization__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //         }
    //         when 'Fauske 2 Phase Vapor-Liquid'{
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_partial_pressure__c=null;
    //             conProd.Vapor_pres_correspond_to_stagnation_temp__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //         }
    //         when 'Fauske 2 Phase Hybrid Gas-Vapor-Liquid'{
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //         }
    //         when 'Fauske All Liquid Flashing'{
    //             conProd.Coefficient_of_Discharge__c=null;
    //             conProd.Density__c=null;
    //             conProd.Density_units__c=null;
    //             conProd.Specific_Gravity__c=null;
    //             conProd.Viscosity__c=null;
    //             conProd.Viscosity_units__c=null;
    //             conProd.Specific_Volume__c=null;
    //             conProd.Specific_Volume_Units__c=null;
    //             conProd.Dryness_of_Wet_Steam__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Pressure__c=null;
    //             conProd.Specific_Volume_at_90_of_Inlet_Units__c=null;
    //             conProd.Saturation_Pressure_at_Inlet_Temperature__c=null;
    //             conProd.Saturation_Pressure_at_inlet_temp_units__c=null;
    //             conProd.Stagnation_gas_vapor_quality__c=null;
    //             conProd.Isentropic_coefficient_gas__c=null;
    //             conProd.Isentropic_coefficient_vapor__c=null;
    //             conProd.Molecular_Weight_gas__c=null;
    //             conProd.Molecular_Weight_vapor__c=null;
    //             conProd.Liquid_specific_heat__c=null;
    //         }
    //     }
    // }
    // //Section B Logic
    // public PageReference saveSizing() { 
    //     conProd.Sizing_Flag__c =true;
    //     clearSizingData();
    //     //Reliveing Pressure Calculations
    //     System.debug('ConfigRD:saveSizing()');
    //     system.debug('saveSizing::Sizing Relieving Pressure'+conProd.Relieving_Pressure_at_Inlet__c);
    //     if (conProd.Relieving_Pressure_at_Inlet__c=='Enter Relieving Pressure Value/ units') {
    //         //decConRelievingPressure
    //         Result resultConvertRelievingPressure=unitConversions.convertPressure(conProd.Enter_Relieving_Pressure_units__c,unitConversions.relievPressBaseUOM,conProd.Enter_Relieving_Pressure_Value__c);
    //         if (resultConvertRelievingPressure.bResult) {
    //             decConRelievingPressure=resultConvertRelievingPressure.dblRetValue;
    //         }
    //     } else {
    //         System.debug('Presure Relieving1');
    //         if (conProd.Relieving_Pressure_at_Inlet__c.contains('%')) {
    //             System.debug('Presure Relieving2');
    //             Integer myInt = Integer.valueOf(conProd.Relieving_Pressure_at_Inlet__c.substringBefore('%'));
    //             System.debug('myInt r'+myInt);
    //             decimal adderVal;
    //             if (myInt==10) {
    //                 adderVal=0.1;
    //             } else if (myInt==16) {
    //                 adderVal=0.16;
    //             } else if (myInt==21) {
    //                 adderVal=2.1;
    //             } else {
    //                 adderVal=0;
    //             }
    //             System.debug('adderVal r'+adderVal);
    //             adderVal=decPBrustConvertedValue*adderVal;
    //             System.debug('adderVal'+adderVal);
    //             decConRelievingPressure=decPBrustConvertedValue+adderVal;
    //             System.debug('decConRelievingPressure'+decConRelievingPressure);
    //         } else {
    //             System.debug('Presure Relieving3');
    //             Integer myInt=Integer.valueOf(conProd.Relieving_Pressure_at_Inlet__c);
    //             decConRelievingPressure=decPBrustConvertedValue+myInt;
    //             System.debug('Presure Relieving4'+decConRelievingPressure);
    //         }
    //         decConRelievingPressure=unitConversions.convertPressure('psig',unitConversions.relievPressBaseUOM,decConRelievingPressure).dblRetValue;
    //     }
    //     //Reliveing Temperature Calculations
    //     if(conProd.Pressure_Relieving_Temperature__c =='Same As Temperature Setting') {
    //         System.debug('TEmp1 Units'+conProd.Temperature_Setting_Units__c);
    //         System.debug('TEmp1 '+conProd.Temperature_Setting__c);
    //         System.debug('TEmp Units'+unitConversions.mapRD_RelievingTemperatureBaseUOM);
    //         result doubleRelievingTemp=unitConversions.convertTemperature(conProd.Temperature_Setting_Units__c,unitConversions.relievTempBaseUOM,conProd.Temperature_Setting__c);
    //         if (doubleRelievingTemp.bResult) {
    //             decConRelievingTemp=doubleRelievingTemp.dblRetValue;
    //         }
    //     }
    //     else {
    //         System.debug('TEmp Units'+conProd.Enter_Different_Temperature_Units__c);
    //         System.debug('TEmp '+conProd.Enter_Different_Temperature_Value__c);
    //         System.debug('TEmp Units'+unitConversions.mapRD_RelievingTemperatureBaseUOM.get(conProd.Evaluation_Per__c));
    //         result doubleRelievingTemp=unitConversions.convertTemperature(conProd.Enter_Different_Temperature_Units__c ,unitConversions.relievTempBaseUOM,conProd.Enter_Different_Temperature_Value__c);
    //         if (doubleRelievingTemp.bResult) {
    //             decConRelievingTemp=doubleRelievingTemp.dblRetValue;
    //         }               
    //     }
    //     //Density Calculations will start here
    //     if (conProd.Density__c!=null) {
    //         Result resultConvertDensity=unitConversions.convertDensity(conProd.Density_units__c,'lb/ft3', conProd.Density__c);
    //         if(resultConvertDensity.bResult)
    //             conProd.Converted_Density__c=resultConvertDensity.dblRetValue;
    //         else
    //             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error Message'+resultConvertDensity.strErrorMessage));                   
    //     }
    //     //Required_Flow_Rate Conversion Calculations
    //     System.debug('Required_Flow_Rate Conversion Calculations');
    //     if (unitConversions.listGasFlowRatenew.contains(conProd.Evaluation_Per__c) || unitConversions.listStreamFlowRatenew.contains(conProd.Evaluation_Per__c)) {
    //         if(conProd.Required_Flow_Rate__c!=null && conProd.Required_Flow_units__c!=null) {
    //             result resultFlowCapacity=unitConversions.convertGasFlowRate(conProd.Required_Flow_units__c,unitConversions.mapRD_FlowRateBaseUOM.get(conProd.Evaluation_Per__c),conProd.Required_Flow_Rate__c,decConRelievingPressure,conProd.Molecular_Weight__c,decConRelievingTemp,conProd.Compressibility_Factor__c );
    //             if (resultFlowCapacity.bResult) {
    //                 doubleConvertedFlowCapacity=resultFlowCapacity.dblRetValue;
    //             }
    //         }
    //     } else {
    //         if(conProd.Converted_Density__c!=null && conProd.Required_Flow_Rate__c!=null) {
    //             result resultFlowCapacity=unitConversions.convertLiquidFlowRate(conProd.Required_Flow_units__c,unitConversions.mapRD_FlowRateBaseUOM.get(conProd.Evaluation_Per__c),conProd.Required_Flow_Rate__c,conProd.Converted_Density__c);
    //             if (resultFlowCapacity.bResult) {
    //                 doubleConvertedFlowCapacity=resultFlowCapacity.dblRetValue;
    //             }
    //         }
    //     }
    //     //Calculate Viscosity
    //     result resultConvertViscosity=new result();
    //     if (conProd.Viscosity__c !=null) {
    //         resultConvertViscosity=unitConversions.convertViscosity(conProd.Viscosity_units__c,unitConversions.mapRD_ViscosityBaseUOM.get(conProd.Evaluation_Per__c), conProd.Viscosity__c);
    //         if(resultConvertViscosity.bResult)
    //             conProd.Converted_Viscosity__c=resultConvertViscosity.dblRetValue;
    //         else
    //             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,resultConvertViscosity.strErrorMessage));                   
    //     }
    //     Result doubleFlowArea =new Result();
    //     if (unitConversions.relievPressBaseUOM !=unitConversions.mapRD_RelievingPressureBaseUOM.get(conProd.Evaluation_Per__c)) {
    //         decConRelievingPressure=unitConversions.convertPressure(unitConversions.relievPressBaseUOM,unitConversions.mapRD_RelievingPressureBaseUOM.get(conProd.Evaluation_Per__c),decConRelievingPressure).dblRetValue;
    //     }
    //     if (unitConversions.relievTempBaseUOM !=unitConversions.mapRD_RelievingTemperatureBaseUOM.get(conProd.Evaluation_Per__c)) {
    //         System.debug('decConRelievingTemp In'+unitConversions.relievTempBaseUOM);
    //         System.debug('decConRelievingTemp In'+unitConversions.mapRD_RelievingTemperatureBaseUOM.get(conProd.Evaluation_Per__c));
    //         result dec=unitConversions.convertTemperature(unitConversions.relievTempBaseUOM,unitConversions.mapRD_RelievingTemperatureBaseUOM.get(conProd.Evaluation_Per__c),decConRelievingTemp);
    //         if(dec.bResult) {
    //             decConRelievingTemp=dec.dblRetValue;
    //         }
    //     }
    //     System.debug('decConRelievingTemp'+decConRelievingTemp);
    //     switch on conProd.Evaluation_Per__c {
    //         When 'ASME Gas/Vapor' {
    //             if(conProd.Media_Type__c=='Air' )
    //                 doubleFlowArea=RDDiscSizingCapacity.ASMEAIRSize(doubleConvertedFlowCapacity.doubleValue(),decConRelievingPressure.doubleValue(),decConRelievingTemp.doubleValue(),conProd.Molecular_Weight__c.doubleValue());
    //             else
    //                 doubleFlowArea=RDDiscSizingCapacity.ASMEGASSize(doubleConvertedFlowCapacity.doubleValue(),decConRelievingPressure.doubleValue(),decConRelievingTemp.doubleValue(),conProd.Ratio_of_Specific_Heats__c.doubleValue(),conProd.Molecular_Weight__c.doubleValue(),conProd.Compressibility_Factor__c.doubleValue());
    //         }
    //         When 'ASME Water'	{
    //             doubleFlowArea= RDDiscSizingCapacity.ASMEWaterSize(doubleConvertedFlowCapacity.doubleValue(),decConRelievingPressure.doubleValue(),Double.valueOf(14.7), conProd.Specific_Gravity__c.doubleValue());
    //         }
    //         When 'ASME Steam' {
    //             doubleFlowArea=RDDiscSizingCapacity.ASMESteamSize(doubleConvertedFlowCapacity.doubleValue(),decConRelievingPressure.doubleValue());
    //         }
    //         when 'API Gas/Vapor' {
    //             doubleFlowArea=RDDiscSizingCapacity.APIGASSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(), Double.valueOf(14.7),conProd.Ratio_of_Specific_Heats__c.doubleValue(), decConRelievingTemp.doubleValue(), conProd.Molecular_Weight__c.doubleValue(), conProd.Compressibility_Factor__c.doubleValue());
    //         }
    //         When 'API Liquid' {
    //             System.debug('u r here gentleman');
    //             doubleFlowArea=RDDiscSizingCapacity.APILiquidSize(doubleConvertedFlowCapacity.doubleValue(),decConRelievingPressure.doubleValue(), conProd.Specific_Gravity__c.doubleValue(), resultConvertViscosity.dblRetValue, Double.valueOf(14.7));
    //         }
    //         when 'API Steam' {
    //             doubleFlowArea=RDDiscSizingCapacity.APISteamSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(),decConRelievingTemp.doubleValue());
    //         }
    //         When 'ISO Gas/Vapor' {
    //             //ISOGASSize(double Qm, double Po,double Pb,double To,double K, double M, double Zo)
    //             doubleFlowArea=RDDiscSizingCapacity.ISOGASSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(),double.valueOf(1.014),decConRelievingTemp.doubleValue(),conProd.Ratio_of_Specific_Heats__c.doubleValue(),conProd.Molecular_Weight__c.doubleValue(),conProd.Compressibility_Factor__c.doubleValue());
    //         }
    //         When 'ISO Liquid' {
    //             //doubleFlowArea=RDDiscSizingCapacity.ISOGASSize(doubleConvertedFlowCapacity, doubleRelievingPressure,Double.valueOf(1.014) , doubleRelievingTemp, conProd.Ratio_of_Specific_Heats__c.doubleValue(), conProd.Molecular_Weight__c.doubleValue(), conProd.Compressibility_Factor__c.doubleValue());
    //         }
    //         When 'ISO Dry Steam' {
    //                 doubleFlowArea=RDDiscSizingCapacity.ISODryStreamSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(), decConRelievingTemp.doubleValue());
    //             // System.debug('sfdsfdsgfdsyufgdshfgsdfg'+doubleFlowArea.strErrorMessage);
    //         }
    //         when 'ISO Wet Steam' {
    //                 doubleFlowArea=RDDiscSizingCapacity.ISOWetStreamSize(doubleConvertedFlowCapacity.doubleValue(), decConRelievingPressure.doubleValue(),Double.valueOf(conProd.Dryness_of_Wet_Steam__c));
    //             // System.debug('sfdsfdsgfdsyufgdshfgsdfg'+doubleFlowArea.strErrorMessage);
    //         }
    //     }
    //     try {
    //         conProd.Bypass__c=false;
    //         upsert conProd;
    //     }
    //     catch(Exception dmle) 
    //     {
    //         ApexPages.addMessages(dmle);
    //         return null;    
    //     }
    //     return null;
    // }
    // public PageReference saveProductSelection() {
    //     conProd.Product_Selection__c=true;
    //     try {
    //         conProd.Bypass__c=false;
    //         conProd.MNFA__c=RDDiscSizingCapacity.RDMasterBlaster(Integer.valueOf(conProd.Size__c), conProd.Product__c, conProd.Seat__c).dblRetValue;
    //         result resDSCVAR=RDDiscSizingCapacity.RD_DSCVAR(Integer.valueOf(conProd.Size__c), conProd.Product__c, conProd.Seat__c);
    //         if (resDSCVAR.bResult)
    //             conProd.DSCVAR__c=resDSCVAR.strRetValue;
    //         upsert conProd;
    //         rtgRngWrap = new RDRatingRange(conProd, conProd.Product__c, conProd.Size__c);
    //     } catch(Exception dmle) {
    //         ApexPages.addMessages(dmle);
    //         return null;                                   
    //     }
    //     return null;
    // }
    // public PageReference saveRatingRange() {
    //     try {
    //         List<ApexPages.Message> msgs = rtgRngWrap.runConstraints();
    //         if(msgs.size() > 0) {
    //             for(ApexPages.Message msg : msgs) {
    //                 ApexPages.addMessage(msg);
    //             }
    //         }
    //         update conProd;
    //     } catch (Exception e) {
    //         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
    //         System.debug(e.getMessage());
    //         System.debug(e.getCause());
    //     }
    //     return null;
    // }
    // public pageReference goBack() {
    //     Id qID=[SELECT Id,SBQQ__Quote__c FROM SBQQ__QuoteLine__c  WHERE id = :quoteLineId].SBQQ__Quote__c;
    //     PageReference pageRef = new PageReference('/apex/customQuoteLinePage?id='+qID);
    //     pageRef.setRedirect(true);
    //     return pageRef;
    // }

}