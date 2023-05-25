public class TestConfigurePrartSelectorUtility {
    
    public static SBQQ__QuoteLine__c quoteLine = New SBQQ__QuoteLine__c(); 
    Public static Part_Selector__c psSelctors = New Part_Selector__c();
    Public static Part_Selector__c psSelctor = New Part_Selector__c();
    public static Map<String, String> mapWithPSValues = New Map<String, String>();
    
    public static void createPSTestRecords(){
        psSelctor.Name='Test PS';
        psSelctor.Quote_Line__c = quoteLine.Id;
        psSelctor.Quantity__c=2;
        psSelctor.ProductGroup__c='Valve';
        psSelctor.SubGroup__c= 'Thief Hatch'; 
        psSelctor.Part_Number_Base_Backup__c='65764747';
        psSelctor.Product_Attribute_Data__c='[{"sValue":"32","sAttributeCode":"PosSetCode"},{"sValue":"04","sAttributeCode":"VacSetCode"},{"sValue":"E","sAttributeCode":"GENOPT"},{"sValue":"12-TH","sAttributeCode":"PTC"},{"sValue":"08","sAttributeCode":"SZC"},{"sValue":"D","sAttributeCode":"HCLASS"},{"sValue":"1","sAttributeCode":"MCBODY"},{"sValue":"F","sAttributeCode":"MCENVG"},{"sValue":"F","sAttributeCode":"MCDPHM"},{"sValue":"G","sAttributeCode":"MCSPRG"}] ';
        psSelctor.Finish_Configuration_Flag__c=True;
        psSelctor.Part_Number__c='12TH081FFG3204EA0001';
        psSelctor.Part_Number_Backup__c='12TH081FFG3204EA0001';
        psSelctor.Diagram_Override__c=True;
        psSelctor.Drawing_Outside_Config__c=True;
        psSelctor.Drawing_id_override__c='2036';
        psSelctor.OA__c='testOA';
        psSelctor.OB__c='testOB';
        psSelctor.OW__c='testOW';
        psSelctor.PC__c='testPC';       
        psSelctor.Lead_Time_Site_10__c=7778;
        psSelctor.Lead_Time_Site_20__c=7779;
        psSelctor.Lead_Time_Site_30__c=350;
        psSelctor.Lead_Time_Site_40__c=8000;
        psSelctor.Lead_Time_10_Override__c=7778;//Service Ticket #203757
        psSelctor.Lead_Time_20_Override__c=7779;
        psSelctor.Lead_Time_30_Override__c=350;
        psSelctor.Lead_Time_40_Override__c=8000;
        psSelctor.PTC__c='12-TH';
        psSelctor.PosSetCode__c ='04';
        psSelctor.VacSetCode__c ='04';
        psSelctor.SETTING__c='04';
        psSelctor.GPRSC1__c='04';
        psSelctor.GVRSC1__c='35';
        insert psSelctor;
        psSelctor = [select id,ASSYPARTNO__c, Part_Number__c,Part_Number_Base_Backup__c, Part_Number_Backup__c, ATEX__c, Brand__c, Diagram_Override__c, Drawing_Outside_Config__c, Drawing_id_override__c,
                       ENGPARTREV__c,  Finish_Configuration_Flag__c, GMODEL__c ,Discountable_Price__c, Non_Discountable_Price__c, OA__c, OB__c, ORP__c, ORV__c, OW__c, OnEngrHoldFlag__c,
                       PartNum__c, PARTREV__c, PosSetCode__c, Quantity__c, Quote_Line__c, VacSetCode__c, SZC__c, SubGroup__c, PTC__c, ProductGroup__c,MCDPHM__c, MCBODY__c from Part_Selector__c Limit 1];
    }
    
    public static void createPSTestRecordss(){
        psSelctors.Name='Test PS';
        psSelctors.Quote_Line__c = quoteLine.Id;
        psSelctors.Product_Attribute_Data__c='[{"sValue":"32","sAttributeCode":"PosSetCode"},{"sValue":"04","sAttributeCode":"VacSetCode"},{"sValue":"E","sAttributeCode":"GENOPT"},{"sValue":"12-TH","sAttributeCode":"PTC"},{"sValue":"08","sAttributeCode":"SZC"},{"sValue":"D","sAttributeCode":"HCLASS"},{"sValue":"1","sAttributeCode":"MCBODY"},{"sValue":"F","sAttributeCode":"MCENVG"},{"sValue":"F","sAttributeCode":"MCDPHM"},{"sValue":"G","sAttributeCode":"MCSPRG"}] ';
        //psSelctors.Finish_Configuration_Flag__c=True;
        //psSelctors.Part_Number__c='12TH081FFG3204EA0001';
        //psSelctors.Diagram_Override__c=True;
        psSelctors.Lead_Time_Engineer_Override__c=true;
        psSelctors.Drawing_Outside_Config__c=True;
        psSelctors.Drawing_id_override__c='122343rtttt';
        insert psSelctors;
        psSelctors = [select id,ASSYPARTNO__c, Part_Number__c, Part_Number_Base_Backup__c, Part_Number_Backup__c, ATEX__c, Brand__c, Diagram_Override__c, Drawing_Outside_Config__c, Drawing_id_override__c,
                       ENGPARTREV__c,  Finish_Configuration_Flag__c, GMODEL__c ,Discountable_Price__c, Non_Discountable_Price__c, OA__c, OB__c, ORP__c, ORV__c, OW__c, OnEngrHoldFlag__c,
                       PartNum__c, PARTREV__c, PosSetCode__c, Quantity__c, Quote_Line__c, VacSetCode__c, SZC__c, SubGroup__c, PTC__c, ProductGroup__c,MCDPHM__c, MCBODY__c from Part_Selector__c Limit 1];
    }
    
    public static void createPSTestRecordsbluk(){             
        creteAssiPD();
        createPSOutput();
        creareCostPartNumber();
        csrateDrawing();
        createIFS();
        createPSGlobaltime();
        creteTranslation();
        createPSinputValues();
        
        List<Global_Site_Part_Parameters_ISPM__c> GlobalSitePartParametersISPMTable = Test.loadData(Global_Site_Part_Parameters_ISPM__c.sObjectType, 'GlobalSitePartParametersISPMTestData');
        List<Global_Site_Part_Parameters_PPS__c> Global_Site_Part_Parameters_PPSTable = Test.loadData(Global_Site_Part_Parameters_PPS__c.sObjectType, 'GlobalSitePartParametersPPSTestData');
        List<IFS_character_codes__c> IFS_character_codes_MasterData = Test.loadData(IFS_character_codes__c.sObjectType, 'IFS_character_codes_MasterData');
        
        //List<GlobalLeadTime__c> FAGlobalLeadTimeTable = Test.loadData(GlobalLeadTime__c.sObjectType, 'FAGlobalLeadTimeTestData');
        //List<PS_Lead_Time__c> PSLeadTimeTestdata = Test.loadData(PS_Lead_Time__c.sObjectType, 'PSLeadTimeTestdata');
        
        
        List<PS_Input_Attr_Value_Desc__c> PSInputAttrValueDescrecords = Test.loadData(PS_Input_Attr_Value_Desc__c.sObjectType, 'PSInputAttrValueDesc');
        List<PS_Input_Field_Labels__c> PSInputFieldLabelsRecords = Test.loadData(PS_Input_Field_Labels__c.sObjectType, 'PSInputFieldLabelsTestdata');
        //List<PS_AssyPartDefinition__c> PSAssyPartDefinitionRecords = Test.loadData(PS_AssyPartDefinition__c.sObjectType, 'PSAssyPartDefinitionTestdata');
        List<PS_Drawing__c> PSDrawingRecords = Test.loadData(PS_Drawing__c.sObjectType, 'PSDrawingTestdata');
        List<PS_Input_Attr_Matrix__c> PSInputAttrMatrixRecords = Test.loadData(PS_Input_Attr_Matrix__c.sObjectType, 'PSInputAttrMatrixTestdata');
        List<PS_Attributes_Details__c> PSAttributesDetails = Test.loadData(PS_Attributes_Details__c.sObjectType, 'PSAttributesDetailsTestData');
        List<PS_Attributes_Translation__c> PSAttributesTranslationRecords = Test.loadData(PS_Attributes_Translation__c.sObjectType, 'PSAttributesTranslationTestdata');
        List<PS_ControlPlan_Details__c> PScontrolplandetailsRecords = Test.loadData(PS_ControlPlan_Details__c.sObjectType, 'PSControlPlanDetailsTestdata');
        List<PS_ControlPlan_Translation__c> PScontrolplanTranslationRecords = Test.loadData(PS_ControlPlan_Translation__c.sObjectType, 'PSControlPlanTranslationTestdata');
        List<PS_Document_Details__c> PSDocumentDetailsRecords = Test.loadData(PS_Document_Details__c.sObjectType, 'PSDocumentDetailsTestdata');
        List<PS_Document_Translation__c> PSDocumentTranslationRecords = Test.loadData(PS_Document_Translation__c.sObjectType, 'PSDocumentTranslationTestData');
        List<PS_Routing_Details__c> PSRoutingDetailsRecords = Test.loadData(PS_Routing_Details__c.sObjectType, 'PSRoutingDetailsTestdata');
        List<PS_Routing_Translation__c> PSRoutingTranslationRecords = Test.loadData(PS_Routing_Translation__c.sObjectType, 'PSRoutingTranslationTestdata');
        List<PS_Structure_Details__c> PSStructureDetailsRecords = Test.loadData(PS_Structure_Details__c.sObjectType, 'PSStructureDetailsTestdata');
        List<PS_Structure_Translation__c> PSStructureTranslationRecords = Test.loadData(PS_Structure_Translation__c.sObjectType, 'PSStructureTranslationTestdata');
        List<PS_Work_Guidelines_Details__c> PSWorkGuidelinesDetailsRecords = Test.loadData(PS_Work_Guidelines_Details__c.sObjectType, 'PSWorkGuidelinesDetailsTestdata');
        List<PS_Work_Guidelines_Translation__c> PSWorkGuidelinesTranslationRecords = Test.loadData(PS_Work_Guidelines_Translation__c.sObjectType, 'PSWorkGuidelinesTranslationTestdata');
        //List<PS_Price__c> PSPriceRecords = Test.loadData(PS_Price__c.sObjectType, 'PSPriceTestdata');
        //List<PS_Lead_Time__c> PSLeadTimeRecords = Test.loadData(PS_Lead_Time__c.sObjectType, 'PSLeadTimeTestdata');
        
    }
    
    public static void createPSTestRecordsbluks(){             
        
        //createPSOutputs();
        //creareCostPartNumber();
        List<PS_Input_Attr_Value_Desc__c> PSInputAttrValueDescrecords = Test.loadData(PS_Input_Attr_Value_Desc__c.sObjectType, 'PSInputAttrValueDesc');
        List<PS_Input_Field_Labels__c> PSInputFieldLabelsRecords = Test.loadData(PS_Input_Field_Labels__c.sObjectType, 'PSInputFieldLabelsTestdata');
        List<PS_Drawing__c> PSDrawingRecords = Test.loadData(PS_Drawing__c.sObjectType, 'PSDrawingTestdata');
        List<PS_Input_Attr_Matrix__c> PSInputAttrMatrixRecords = Test.loadData(PS_Input_Attr_Matrix__c.sObjectType, 'PSInputAttrMatrixTestdata');
    }
    
    public static SBQQ__QuoteLine__c creteSBQline(){
        SBQQ__QuoteLine__c sbq = New SBQQ__QuoteLine__c();
        
        return sbq;
    }
    
    public static PS_AssyPartDefinition__c creteAssiPD(){
        PS_AssyPartDefinition__c psd = New PS_AssyPartDefinition__c();
        psd.Name='Test Assy';
        psd.Managed_In__c='IFS';
        psd.BRAND__c=psSelctor.Brand__c;
        psd.ProdGroup__c=psSelctor.ProductGroup__c;
        psd.SubGroup__c=psSelctor.SubGroup__c;
        psd.ASSYPARTNO__c=psSelctor.Part_Number__c;
        psd.Field3__c='PTC';
        psd.Field4__c='SZC';
        psd.Field5__c='HCLASS';
        psd.Field6__c='MCBODY';
        psd.Field7__c='MCENVG';
        psd.Field8__c='MCDPHM';
        psd.Field9__c='MCSPRG';
        psd.PartRevision__c='Test';
        insert psd;
        return psd; 
    }
    
    
    public static AssyPartDefinition__c creteAssyPD(){
        AssyPartDefinition__c psd = New AssyPartDefinition__c();
        psd.Name='Test Assy';
        psd.Managed_In__c='IFS';
        psd.BRAND__c=psSelctor.Brand__c;
        //psd.ProdGroup__c=psSelctor.ProductGroup__c;
        //psd.SubGroup__c=psSelctor.SubGroup__c;
        psd.ASSYPARTNO__c=psSelctor.Part_Number__c;
        insert psd;
        return psd;
    }
    
    
    public static PS_Drawing__c csrateDrawing(){
        PS_Drawing__c psd = New PS_Drawing__c();
        psd.name='Test Drawing';
        psd.DrawingID__c=psSelctor.Drawing_id_override__c;
        psd.ASSYPARTNO__c=psSelctor.Part_Number__c;
        insert psd;
        return psd;
    }
    
    Public static Cost_Part_Number__c creareCostPartNumber(){
        Cost_Part_Number__c cap= new Cost_Part_Number__c();
        cap.name='TeST NAme';
        cap.QtyLL__c=2;
        cap.QtyUL__c=2;
        cap.PartNumber__c=psSelctor.Part_Number__c;
        insert cap;
        return cap;
    }
    
    Public static PS_AssyPartDefinition__c creteASSYPratDef(){
        PS_AssyPartDefinition__c ASPD = New PS_AssyPartDefinition__c();
        ASPD.BRAND__c=psSelctor.Brand__c;
        ASPD.ASSYPARTNO__c=psSelctor.Part_Number__c;
        ASPD.Name = 'Tsst AASPD';
        ASPD.PartRevision__c='Test';
        insert ASPD;
        return ASPD;
    }
    
    Public static PS_Input_Attr_Matrix__c createInptAttr(){
        PS_Input_Attr_Matrix__c Attr = New PS_Input_Attr_Matrix__c();
        Attr.BRAND__c=psSelctor.Brand__c;
        Attr.ProdGroup__c=psSelctor.ProductGroup__c;
        Attr.SubGroup__c=psSelctor.SubGroup__c;
        Attr.Name = 'Tsst AASPD';
        insert Attr;
        return Attr;
    }
    
    public static PS_Input_Field_Labels__c createPSinputlabel(){
        PS_Input_Field_Labels__c psla = new PS_Input_Field_Labels__c();
        //psla.name='Test Label';
        psla.ProdGroup__c=psSelctor.ProductGroup__c;
        psla.SubGroup__c=psSelctor.SubGroup__c;
        psla.Attribute_Code__c='ygdgugf';
        insert psla;
        return psla;
    }
    
    public static list<PS_Input_Attr_Value_Desc__c> createPSinputValues(){
        list<PS_Input_Attr_Value_Desc__c> inputAttrlist = new list<PS_Input_Attr_Value_Desc__c>();
        PS_Input_Attr_Value_Desc__c psla = new PS_Input_Attr_Value_Desc__c();
        //psla.name='Test Label';
        psla.ProdGroup__c=psSelctor.ProductGroup__c;
        psla.SubGroup__c=psSelctor.SubGroup__c;
        psla.Attribute__c='Envelope Gasket';
        psla.Text_Description_of_Attribute_Value__c='tyu';
        psla.Display_Order__c=1;
        inputAttrlist.add(psla);
        
        PS_Input_Attr_Value_Desc__c psla1 = new PS_Input_Attr_Value_Desc__c();
        //psla.name='Test Label';
        psla1.ProdGroup__c=psSelctor.ProductGroup__c;
        psla1.SubGroup__c=psSelctor.SubGroup__c;
        psla1.Attribute__c='GENOPT';
        psla1.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(psla1);
        
        PS_Input_Attr_Value_Desc__c psl = new PS_Input_Attr_Value_Desc__c();
        //psla.name='Test Label';
        psl.ProdGroup__c=psSelctor.ProductGroup__c;
        psl.SubGroup__c=psSelctor.SubGroup__c;
        psl.Attribute__c='GENOPT';
        psl.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(psl);
        
        PS_Input_Attr_Value_Desc__c GVRSC1 = new PS_Input_Attr_Value_Desc__c();
        //psla.name='Test Label';
        GVRSC1.ProdGroup__c=psSelctor.ProductGroup__c;
        GVRSC1.SubGroup__c=psSelctor.SubGroup__c;
        GVRSC1.Attribute__c='GVRSC1';
        GVRSC1.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(GVRSC1);
        
        PS_Input_Attr_Value_Desc__c MCENVG = new PS_Input_Attr_Value_Desc__c();
        //psla.name='Test Label';
        MCENVG.ProdGroup__c=psSelctor.ProductGroup__c;
        MCENVG.SubGroup__c=psSelctor.SubGroup__c;
        MCENVG.Attribute__c='MCENVG';
        MCENVG.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(MCENVG);
        
        PS_Input_Attr_Value_Desc__c MCSPRG = new PS_Input_Attr_Value_Desc__c();
        MCSPRG.ProdGroup__c=psSelctor.ProductGroup__c;
        MCSPRG.SubGroup__c=psSelctor.SubGroup__c;
        MCSPRG.Attribute__c='MCSPRG';
        MCSPRG.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(MCSPRG);
        
        PS_Input_Attr_Value_Desc__c PilotGas = new PS_Input_Attr_Value_Desc__c();
        PilotGas.ProdGroup__c=psSelctor.ProductGroup__c;
        PilotGas.SubGroup__c=psSelctor.SubGroup__c;
        PilotGas.Attribute__c='PilotGas';
        PilotGas.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(PilotGas);
        
        PS_Input_Attr_Value_Desc__c PilotSupplyRange = new PS_Input_Attr_Value_Desc__c();
        PilotSupplyRange.ProdGroup__c=psSelctor.ProductGroup__c;
        PilotSupplyRange.SubGroup__c=psSelctor.SubGroup__c;
        PilotSupplyRange.Attribute__c='PilotSupplyRange';
        PilotSupplyRange.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(PilotSupplyRange);
        
        PS_Input_Attr_Value_Desc__c Port = new PS_Input_Attr_Value_Desc__c();
        Port.ProdGroup__c=psSelctor.ProductGroup__c;
        Port.SubGroup__c=psSelctor.SubGroup__c;
        Port.Attribute__c='Port';
        Port.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(Port);
        
        PS_Input_Attr_Value_Desc__c PortLoading = new PS_Input_Attr_Value_Desc__c();
        PortLoading.ProdGroup__c=psSelctor.ProductGroup__c;
        PortLoading.SubGroup__c=psSelctor.SubGroup__c;
        PortLoading.Attribute__c='PortLoading';
        PortLoading.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(PortLoading);
        
        PS_Input_Attr_Value_Desc__c Position = new PS_Input_Attr_Value_Desc__c();
        Position.ProdGroup__c=psSelctor.ProductGroup__c;
        Position.SubGroup__c=psSelctor.SubGroup__c;
        Position.Attribute__c='Position';
        Position.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(Position);
        
        PS_Input_Attr_Value_Desc__c SpringRange = new PS_Input_Attr_Value_Desc__c();
        SpringRange.ProdGroup__c=psSelctor.ProductGroup__c;
        SpringRange.SubGroup__c=psSelctor.SubGroup__c;
        SpringRange.Attribute__c='MCSPRG';
        SpringRange.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(SpringRange);
        
        PS_Input_Attr_Value_Desc__c Thickness = new PS_Input_Attr_Value_Desc__c();
        Thickness.ProdGroup__c=psSelctor.ProductGroup__c;
        Thickness.SubGroup__c=psSelctor.SubGroup__c;
        Thickness.Attribute__c='Thickness';
        Thickness.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(Thickness);
        
        PS_Input_Attr_Value_Desc__c Type = new PS_Input_Attr_Value_Desc__c();
        Type.ProdGroup__c=psSelctor.ProductGroup__c;
        Type.SubGroup__c=psSelctor.SubGroup__c;
        Type.Attribute__c='Type';
        Type.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(Type);
        
        PS_Input_Attr_Value_Desc__c Weight = new PS_Input_Attr_Value_Desc__c();
        Weight.ProdGroup__c=psSelctor.ProductGroup__c;
        Weight.SubGroup__c=psSelctor.SubGroup__c;
        Weight.Attribute__c='Weight';
        Weight.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(Weight);
        
        PS_Input_Attr_Value_Desc__c MCWGHT = new PS_Input_Attr_Value_Desc__c();
        MCWGHT.ProdGroup__c=psSelctor.ProductGroup__c;
        MCWGHT.SubGroup__c=psSelctor.SubGroup__c;
        MCWGHT.Attribute__c='MCWGHT';
        MCWGHT.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(MCWGHT);
        
        PS_Input_Attr_Value_Desc__c SPRING = new PS_Input_Attr_Value_Desc__c();
        SPRING.ProdGroup__c=psSelctor.ProductGroup__c;
        SPRING.SubGroup__c=psSelctor.SubGroup__c;
        SPRING.Attribute__c='SPRING';
        SPRING.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(SPRING);
        
        PS_Input_Attr_Value_Desc__c SETTING = new PS_Input_Attr_Value_Desc__c();
        SETTING.ProdGroup__c=psSelctor.ProductGroup__c;
        SETTING.SubGroup__c=psSelctor.SubGroup__c;
        SETTING.Attribute__c='SETTING';
        SETTING.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(SETTING);
        
        PS_Input_Attr_Value_Desc__c NACE = new PS_Input_Attr_Value_Desc__c();
        NACE.ProdGroup__c=psSelctor.ProductGroup__c;
        NACE.SubGroup__c=psSelctor.SubGroup__c;
        NACE.Attribute__c='NACE';
        NACE.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(NACE);
        
        PS_Input_Attr_Value_Desc__c MCPALL = new PS_Input_Attr_Value_Desc__c();
        MCPALL.ProdGroup__c=psSelctor.ProductGroup__c;
        MCPALL.SubGroup__c=psSelctor.SubGroup__c;
        MCPALL.Attribute__c='MCPALL';
        MCPALL.Text_Description_of_Attribute_Value__c='tyu';
        inputAttrlist.add(MCPALL);
        
        PS_Input_Attr_Value_Desc__c MCHOUS = new PS_Input_Attr_Value_Desc__c();
        MCHOUS.ProdGroup__c=psSelctor.ProductGroup__c;
        MCHOUS.SubGroup__c=psSelctor.SubGroup__c;
        MCHOUS.Text_Description_of_Attribute_Value__c='rty';
        MCHOUS.Attribute__c='MCHOUS';
        inputAttrlist.add(MCHOUS);
        
        PS_Input_Attr_Value_Desc__c MCELMT = new PS_Input_Attr_Value_Desc__c();
        MCELMT.ProdGroup__c=psSelctor.ProductGroup__c;
        MCELMT.SubGroup__c=psSelctor.SubGroup__c;
        MCELMT.Text_Description_of_Attribute_Value__c='rty';
        MCELMT.Attribute__c='MCELMT';
        inputAttrlist.add(MCELMT);
        
        PS_Input_Attr_Value_Desc__c MCDPHM = new PS_Input_Attr_Value_Desc__c();
        MCDPHM.ProdGroup__c=psSelctor.ProductGroup__c;
        MCDPHM.SubGroup__c=psSelctor.SubGroup__c;
        MCDPHM.Text_Description_of_Attribute_Value__c='rty';
        MCDPHM.Attribute__c='MCDPHM';
        inputAttrlist.add(MCDPHM);
        
        PS_Input_Attr_Value_Desc__c ESZC = new PS_Input_Attr_Value_Desc__c();
        ESZC.ProdGroup__c=psSelctor.ProductGroup__c;
        ESZC.SubGroup__c=psSelctor.SubGroup__c;
        ESZC.Text_Description_of_Attribute_Value__c='rty';
        ESZC.Attribute__c='ESZC';
        inputAttrlist.add(ESZC);
        
        PS_Input_Attr_Value_Desc__c CUTR = new PS_Input_Attr_Value_Desc__c();
        CUTR.ProdGroup__c=psSelctor.ProductGroup__c;
        CUTR.SubGroup__c=psSelctor.SubGroup__c;
        CUTR.Text_Description_of_Attribute_Value__c='rty';
        CUTR.Attribute__c='CUTR';
        inputAttrlist.add(CUTR);
        
        PS_Input_Attr_Value_Desc__c ATEX = new PS_Input_Attr_Value_Desc__c();
        ATEX.ProdGroup__c=psSelctor.ProductGroup__c;
        ATEX.SubGroup__c=psSelctor.SubGroup__c;
        ATEX.Text_Description_of_Attribute_Value__c='rty';
        ATEX.Attribute__c='ATEX';
        inputAttrlist.add(ATEX);
        
        PS_Input_Attr_Value_Desc__c HCLASS = new PS_Input_Attr_Value_Desc__c();
        HCLASS.ProdGroup__c=psSelctor.ProductGroup__c;
        HCLASS.SubGroup__c=psSelctor.SubGroup__c;
        HCLASS.Text_Description_of_Attribute_Value__c='rty';
        HCLASS.Attribute__c='HCLASS';
        inputAttrlist.add(HCLASS);
        
        PS_Input_Attr_Value_Desc__c MCBODY = new PS_Input_Attr_Value_Desc__c();
        MCBODY.ProdGroup__c=psSelctor.ProductGroup__c;
        MCBODY.SubGroup__c=psSelctor.SubGroup__c;
        MCBODY.Text_Description_of_Attribute_Value__c='rty';
        MCBODY.Attribute__c='MCBODY';
        inputAttrlist.add(MCBODY);
        
        PS_Input_Attr_Value_Desc__c PTC = new PS_Input_Attr_Value_Desc__c();
        PTC.ProdGroup__c=psSelctor.ProductGroup__c;
        PTC.SubGroup__c=psSelctor.SubGroup__c;
        PTC.Text_Description_of_Attribute_Value__c='rty';
        PTC.Attribute__c='PTC';
        inputAttrlist.add(PTC);
        
        PS_Input_Attr_Value_Desc__c SZC = new PS_Input_Attr_Value_Desc__c();
        SZC.ProdGroup__c=psSelctor.ProductGroup__c;
        SZC.SubGroup__c=psSelctor.SubGroup__c;
        SZC.Text_Description_of_Attribute_Value__c='rty';
        SZC.Attribute__c='SZC';
        inputAttrlist.add(SZC);
        
        
        insert inputAttrlist;
        return inputAttrlist;
    }
    
    public static PS_Price__c createprice(){
        PS_Price__c ps = new PS_Price__c();
        ps.ASSYPARTNO__c = '65764747';//psSelctor.Part_Number_Base_Backup__c;
        ps.Price__c=22; 
        ps.QuantityLL__c=1;
        ps.QuantityUL__c=3;
        insert ps;
        return ps;
    }
    
    Public static PS_Output__c createPSOutput(){
        PS_Output__c pso = new PS_Output__c();
        pso.Part_Selector__c = psSelctor.ID;
        insert pso;        
        return pso;
        
    }
    
    Public static list<PS_Output__c> listcreatePSOutput(){
        list<PS_Output__c> pso = new list<PS_Output__c>();
        PS_Output__c ps=new PS_Output__c();
        ps.Part_Selector__c = psSelctor.ID;
        pso.add(ps);
        PS_Output__c pss=new PS_Output__c();
        pss.Part_Selector__c = psSelctor.ID;
        pso.add(pss);
        insert pso;        
        return pso;
        
    }
    
    Public static PS_Output__c createPSOutputs(){
        PS_Output__c pso = new PS_Output__c();
        PS_Output__c psoUpdate = new PS_Output__c();
        pso.Part_Selector__c = psSelctors.ID;
        insert pso;
        System.debug('PSO+++++>'+pso);
        if(pso!=Null){
            System.debug('PSO+++++>insede');
            psoUpdate.Id=pso.Id;
            psoUpdate.OA_Override__c='testOA';
            psoUpdate.OB_Override__c='testOB';
            psoUpdate.OW_Override__c='testOW';
            psoUpdate.PC_Override__c='testPC';
            update psoUpdate;
            System.debug('PSO+++++>insede'+psoUpdate);
        }
        
        return psoUpdate;
     }
    
    Public static PS_Lead_Time__c createPSleadtime(){
        PS_Lead_Time__c psoo = new PS_Lead_Time__c();
        psoo.ASSYPARTNO__c = psSelctor.Part_Number_Base_Backup__c;
        psoo.RunTimeSchedule__c='234';
        //pso.name='test';
        insert psoo;        
        return psoo;
    }
    
    Public static GlobalLeadTime__c createPSGlobaltime(){
        GlobalLeadTime__c pso = new GlobalLeadTime__c();
        pso.Schedule__c='234';
        pso.QtyLL__c = 1;
        pso.QtyUL__c=3;
        //pso.name='test';
        insert pso;        
        return pso;
    }
    
    public static PS_IFS_Description__c createIFS(){
        PS_IFS_Description__c ifs = new PS_IFS_Description__c();
        ifs.name='test';
        ifs.OA__c='TestOA';
        ifs.OB__c='TestOB';
        ifs.ORP__c='TestORP';
        ifs.ORV__c='TestORV';
        ifs.OW__c='TestOW';
        ifs.ASSYPARTNO__c=psSelctor.Part_Number_Backup__c;
        insert ifs;
        return ifs;
    }
    
    Public static PS_Attributes_Translation__c creteTranslation(){
        PS_Attributes_Translation__c tra = new PS_Attributes_Translation__c();
        tra.name='testtra';
        insert tra;
        return tra;
    }
    
    public static Cost__c createcost(){
        Cost__c cs = new Cost__c();
        insert cs;
        return cs;
    }
    
     public static User createUser(string strProfile, string strUsername) {
        strUsername = Math.random()+ strUsername;
        user newUser;
        try {
            Profile userProfile = [select Name,id from Profile where Name = : strProfile];
            system.debug('userProfile:'+userProfile);
            newUser = new User(alias = 'test', email = strUsername, emailencodingkey = 'UTF-8', lastname = strProfile + ' User',
                               languagelocalekey = 'en_US', city = 'Smallville', Country = 'United States', State = 'Alabama', localesidkey = 'en_US', 
                               profileid = userProfile.Id, timezonesidkey = 'America/Los_Angeles',username = strUsername);
        } Catch(Exception e) {
            system.assertEquals('List has no rows for assignment to SObject', e.getMessage());
        }
        return newUser;
    }
    
    //public static PS_Input_Attr_Value_Desc__c    
}