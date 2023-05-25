public class SizingsCtrl {
    public SBQQ__Quote__c oQuote {get;set;}
    public list<SBQQ__QuoteLine__c> lstQuoteLine {get;set;}
    public map<String,String> mapImageData {get;set;}
    public map<String,String> mapRDImageName {get;set;}
    public string logo {get;set;}
    public User oUser{get;set;}
    public Date Today { 
        get { 
            return Date.today(); 
        }
    }
    
    private string quoteId;
    private string baseURL {get;set;}
    private string logoName = '';
    
    
    public SizingsCtrl(){
        System.debug('@Developer -->SizingsCtrl:');
    }
    
    public PageReference init(){
        System.debug('@Developer -->init:' );
        
        for(User u : [SELECT Id,Name FROM User WHERE Id =: userInfo.getUserId()]){
        	oUser = u;    
        }
        System.debug('@Developer --> oUser :' + oUser);
        
        if(ApexPages.currentPage().getParameters().get('qid') != null){
            quoteId = ApexPages.currentPage().getParameters().get('qid');    
            System.debug('@Developer --> quoteId :' + quoteId);
            
            //baseURL = 'https://contdisccorp--uat--c.cs66.content.force.com/servlet/servlet.ImageServer?oid=' + userInfo.getOrganizationId() + '&id=';
            baseURL = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?oid=' + userInfo.getOrganizationId() + '&id=';
            System.debug('@Developer --> baseURL :' + baseURL);
            
            set<string> setDrawingId = new set<String>();
            
            lstQuoteLine = [SELECT Id,Name,Product_Name__c,SBQQ__Number__c,SBQQ__ProductCode__c ,Engineering_Status__c,Product_Planning_Status__c, 
                            Requires_Technical_Review__c,Drawings_Status__c, Expiration_Date__c,Customer_Leadtime__c, 
                            Leadtime__c, Discount_Amount__c, Discount__c,Non_Discountable_List_Price__c, Production_Planning_Leadtime__c,
                            Discountable_List_Price__c, SBQQ__Quantity__c, Total_List_Price_Cust_Curr__c, Customer_Currency__c, 
                            Regular_Total_Price_Cust_Curr__c, Net_Price_Each_Cust_Curr__c,SBQQ__Description__c,DrawingID__c,                           
                            DimA__c, DimB__c, DimC__c, DimD__c,DimE__c, DimF__c,QuoteLineNumber__c,
                            SBQQ__Quote__r.Revision__c,SBQQ__Quote__r.Quote_Number__c,SBQQ__Quote__r.QuoteNumberWithRevision__c,
                            SBQQ__Quote__r.SBQQ__ExpirationDate__c,SBQQ__Quote__r.Max_Lead_Time_in_Weeks__c,SBQQ__Quote__r.SBQQ__Account__r.Name,
                            SBQQ__Quote__r.DisplayCDCLogo__c,SBQQ__Quote__r.DisplayGrothContinentalLogo__c,
                            SBQQ__Quote__r.DisplayGrothLogo__c,SBQQ__Quote__r.DisplayLaMotLogo__c,SBQQ__Quote__r.DisplayLVALogo__c,
                            (SELECT Id,Name,Discountable_Price__c,Non_Discountable_Price__c,Size__c,Part_Number__c,
                             Evaluation_Type__c,Evaluation_Per__c,Process_Media__c,Customer_Specified_Media__c,
                             Pressure_Setting__c,Pressure_Setting_Units__c,Relieving_Pressure_at_Inlet__c,
                             Enter_Relieving_Pressure_Value__c,Enter_Relieving_Pressure_units__c,
                             Required_Flow_Rate__c,Required_Flow_units__c,Required_Flow_Area_Units__c,
                             Enter_Different_Temperature_Value__c,Enter_Different_Temperature_Units__c,
                             Molecular_Weight__c,Ratio_of_Specific_Heats__c,Compressibility_Factor__c,Coefficient_of_Discharge__c,
                             Density_Specific_Volume_Specific_Gravity__c,Density_SpecificVolume_SpcfcGravityUnits__c,
                             Viscosity__c,Viscosity_units__c,Dryness_of_Wet_Steam__c,
                             Specific_Volume_at_inlet__c,Specific_Volume_at_Inlet_Units__c,
                             Specific_Volume_at_90_of_Inlet_Pressure__c,Specific_Volume_at_90_of_Inlet_Units__c,
                             Density_at_Inlet__c,Density_at_Inlet_Units__c,Latent_heat_of_vaporization__c,
                             Saturation_Pressure_at_Inlet_Temperature__c,Saturation_Pressure_at_inlet_temp_units__c,
                             Density_at_90_of_Saturation_Pressure__c,Density_at_90_Saturation_Pressure_Units__c,
                             Stagnation_gas_vapor_quality__c,Stagnation_vapor_density__c,Stagnation_Vapor_Density_Units__c,
                             Stagnation_gas_partial_pressure__c,Stagnation_gas_partial_pressure_Units__c,
                             Liquid_density__c,Liquid_density_Units__c,Liquid_specific_heat__c,
                             Vapor_pres_correspond_to_stagnation_temp__c,Vapor_Pres_to_Stagnation_temp_Units__c,
                             Isentropic_coefficient_gas__c,Isentropic_coefficient_vapor__c,Relief_Type__c,VMNFA__c,
                             Molecular_Weight_gas__c,Molecular_Weight_vapor__c,Output_Required_Flow_Area__c,Flow_Area__c,MNFA__c,
                             SizeDesc__c,Size_Units__c,Seat__c,Product__c,Product_Flow_Capacity_Value__c,
                             Rupture_Disc_Flow_Capacity_Units__c,SizingKrText__c,SizingCertText__c,
                             VacEnter_Different_Temperature_Value__c,VacEnter_Different_Temperature_Units__c,
                             VacProduct_Flow_Capacity_Value__c,Quote_Descriptions_Override__c,
                             Pressure_Relieving_Temperature__c,Temperature_Setting__c 
                             FROM Rupture_Discs__r 
                             WHERE ShowPosSizingCapacityPage__c = TRUE) 
                            FROM SBQQ__QuoteLine__c  
                            WHERE SBQQ__Quote__c = :quoteId 
                            AND SBQQ__ProductName__c = 'Rupture Disc' 
                            AND Line_Status__c in ('Primary','Alternate')
                            ORDER BY CreatedDate DESC];
            
            System.debug('@Developer --> lstQuoteLine.size() :' + lstQuoteLine.size());
            
            if(lstQuoteLine.size() > 0 ){
                if(lstQuoteLine[0].SBQQ__Quote__r.DisplayCDCLogo__c){
                    logoName = 'CDC Logo New';    
                }
                else if(lstQuoteLine[0].SBQQ__Quote__r.DisplayGrothContinentalLogo__c){
                    logoName = 'groth continental manufacturing pvt ltdNew';    
                }
                else if(lstQuoteLine[0].SBQQ__Quote__r.DisplayGrothLogo__c){
                    logoName = 'grothLogoNew';    
                }
                else if(lstQuoteLine[0].SBQQ__Quote__r.DisplayLaMotLogo__c){
                    logoName = 'laMotLogoNew';    
                }
                else if(lstQuoteLine[0].SBQQ__Quote__r.DisplayLVALogo__c){
                    logoName = 'lamot_LVA_logo.pngNEW';    
                }
            }
            
            mapRDImageName = new map<String,String>();
            for(SBQQ__QuoteLine__c ql :lstQuoteLine){
                System.debug('@Developer --> ql :' + ql);
                Boolean bRuptureDescFound = false;
                System.debug('@Developer --> ql.SBQQ__Quote__r.SBQQ__Account__r.Name :' + ql.SBQQ__Quote__r.SBQQ__Account__r.Name);
                System.debug('@Developer --> ql.SBQQ__Quote__r.QuoteNumberWithRevision__c :' + ql.SBQQ__Quote__r.QuoteNumberWithRevision__c);
                System.debug('@Developer --> ql.SBQQ__Quote__r.SBQQ__ExpirationDate__c :' + ql.SBQQ__Quote__r.SBQQ__ExpirationDate__c);
                System.debug('@Developer --> oUser.Name :' + oUser.Name);
                System.debug('@Developer --> ql.SBQQ__Quote__r.Max_Lead_Time_in_Weeks__c :' + ql.SBQQ__Quote__r.Max_Lead_Time_in_Weeks__c);
                
                for(Rupture_Disc__c rd : ql.Rupture_Discs__r){
                    bRuptureDescFound = true;
                    System.debug('@Developer --> rd.Evaluation_Type__c :' + rd.Evaluation_Type__c);
                    System.debug('@Developer --> rd.Evaluation_Per__c :' + rd.Evaluation_Per__c);
                    
                    String sEvaluationType = '';
                    if(rd.Evaluation_Type__c != null){
                        sEvaluationType = rd.Evaluation_Type__c.replaceAll('&','-');
                        System.debug('@Developer --> sEvaluationType :' + sEvaluationType);
                    }
                    
                    String sEvaluationPer = '';
                    if(rd.Evaluation_Per__c != null){
                        //sEvaluationPer = rd.Evaluation_Per__c.replaceAll('/','-');
                        sEvaluationPer = rd.Evaluation_Per__c;
                        System.debug('@Developer --> sEvaluationPer :' + sEvaluationPer);
                    }
					
                    String sFileName = '';
                    String sKey = (sEvaluationType + '-' + sEvaluationPer).replaceAll('null', '');
                    System.debug('@Developer --> sKey :' + sKey);
                    
                    mapRDImageName.put(sKey,'-');
                    
                    if(sEvaluationType =='Capacity'){
                        if(sEvaluationPer == 'ASME Gas/Vapor'){
                            sFileName = 'AsmeGasCapacity';
                        }
                        if(sEvaluationPer == 'ASME Water'){
                            sFileName = 'AsmeLiquidCapacity';
                        }
                        if(sEvaluationPer == 'ASME Steam'){
                            sFileName = 'AsmeSteamCapacity';
                        }
                        if(sEvaluationPer == 'API Gas/Vapor'){
                            sFileName = 'ApiGasCapacity';
                        }
                        if(sEvaluationPer == 'API Liquid'){
                            sFileName = 'ApiLiquidCapacity';
                        }
                        if(sEvaluationPer == 'API Steam'){
                            sFileName = 'ApiSteamCapacity';
                        }
                        if(sEvaluationPer == 'ISO Gas/Vapor'){
                            sFileName = 'IsoGasCapacity';
                        }
                        if(sEvaluationPer == 'ISO Liquid'){
                            sFileName = 'IsoLiquidCapacity';
                        }
                        if(sEvaluationPer == 'ISO Dry Steam'){
                            sFileName = 'IsoSteamCapacity';
                        }
                        if(sEvaluationPer == 'ISO Wet Steam'){
                            sFileName = 'IsoWetSteamCapacity';
                        }
                    }
                    else if(sEvaluationType =='Sizing - Capacity'){
                        if(sEvaluationPer == 'ASME Gas/Vapor'){
                            sFileName = 'AsmeGasSizing';
                        }
                        if(sEvaluationPer == 'ASME Water'){
                            sFileName = 'AsmeLiquidSizing';
                        }
                        if(sEvaluationPer == 'ASME Steam'){
                            sFileName = 'AsmeSteamSizing';
                        }
                        if(sEvaluationPer == 'API Gas/Vapor'){
                            sFileName = 'ApiGasSizing';
                        }
                        if(sEvaluationPer == 'API Liquid'){
                            sFileName = 'ApiLiquidSizing';
                        }
                        if(sEvaluationPer == 'API Steam'){
                            sFileName = 'ApiSteamSizing';
                        }
                        if(sEvaluationPer == 'ISO Gas/Vapor'){
                            sFileName = 'IsoGasSizing';
                        }
                        if(sEvaluationPer == 'ISO Liquid'){
                            sFileName = 'IsoLiquidSizing';
                        }
                        if(sEvaluationPer == 'ISO Dry Steam'){
                            sFileName = 'IsoSteamSizing';
                        }
                        if(sEvaluationPer == 'ISO Wet Steam'){
                            sFileName = 'IsoWetSteamSizing';
                        }
                    }
                    
					mapRDImageName.put(sKey,sFileName);
                    setDrawingId.add(sFileName);
					
                    System.debug('@Developer --> rd.Process_Media__c :' + rd.Process_Media__c);
                    System.debug('@Developer --> rd.Customer_Specified_Media__c :' + rd.Customer_Specified_Media__c);
                    System.debug('@Developer --> rd.Pressure_Setting__c :' + rd.Pressure_Setting__c);
                    System.debug('@Developer --> rd.Relieving_Pressure_at_Inlet__c :' + rd.Relieving_Pressure_at_Inlet__c);
                    System.debug('@Developer --> rd.Required_Flow_Rate__c :' + rd.Required_Flow_Rate__c);
                    System.debug('@Developer --> rd.Customer_Specified_Media__c :' + rd.Customer_Specified_Media__c);
                    System.debug('@Developer --> rd.Compressibility_Factor__c :' + rd.Compressibility_Factor__c);
                    System.debug('@Developer --> rd.Coefficient_of_Discharge__c :' + rd.Coefficient_of_Discharge__c);
                    System.debug('@Developer --> rd.Output_Required_Flow_Area__c :' + rd.Output_Required_Flow_Area__c);
                    System.debug('@Developer --> rd.Size__c :' + rd.Size__c);
                    System.debug('@Developer --> rd.Size_Units__c :' + rd.Size_Units__c);
                    System.debug('@Developer --> rd.Product__c :' + rd.Product__c);
                    System.debug('@Developer --> rd.Required_Flow_Area_Units__c :' + rd.Required_Flow_Area_Units__c);
                    System.debug('@Developer --> rd.Product_Flow_Capacity_Value__c :' + rd.Product_Flow_Capacity_Value__c);
                    System.debug('@Developer --> rd.Rupture_Disc_Flow_Capacity_Units__c :' + rd.Rupture_Disc_Flow_Capacity_Units__c);
                }  
            }
            System.debug('@Developer --> setDrawingId :' + setDrawingId);
            System.debug('@Developer --> mapRDImageName :' + mapRDImageName);
            
            mapImageData = new map<String,String>();
            for(String sKey : mapRDImageName.keySet()){
                if(mapRDImageName.get(sKey) == '-'){
                    mapImageData.put(sKey,' '); 
                }
            }

            setDrawingId.add(logoName);
            for(String sDrawingId :setDrawingId){
                System.debug('@Developer --> sDrawingId :' + sDrawingId); 
                mapImageData.put(sDrawingId,' ');
            }
            
            for(Document doc : [SELECT Id,Name FROM Document WHERE Name IN :setDrawingId And Name != '9999']){
                mapImageData.put(doc.Name,baseURL + doc.Id);
            }
            System.debug('@Developer --> mapImageData :' + mapImageData);
            
            System.debug('@Developer --> logoName :' + logoName);
            if(mapImageData.containsKey(logoName)){
                logo = mapImageData.get(logoName);
                System.debug('@Developer --> logo :' + logo);
            }
        }
        
        return null;
    }
}