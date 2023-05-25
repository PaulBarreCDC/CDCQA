public class WizardCostProcessor {
    public List<Cost_Routing_Inside__c> routingInCost{get;set;}
    public List<Cost_Routing_Outside__c> routingOutCost{get;set;}
    public List<String> routingOpp {get;set;}
    public List<String> strucPartList {get;set;}
    public List<Cost_Part_Number__c> getAssemblyCost {get;set;}
    public List<Cost_Part_Number__c> getBuiltCost {get;set;}
    public List<RD_Cost__c> getRDBuiltCost {get;set;}
    public map<string,string> mapStrucComp {
        get{
            return new Map<string,string> {
                'WGB' => 'Part_Number__c',
                'BGR' => 'Component_part__c',
                'HLD'=> 'Part_Number__c',
                'FlameProducts'=> 'Component_part__c',   
                'RLFVLV' => 'Component_part__c',
                 'PS' => 'Component_Part__c'
            };
        }
    }
    public  map<string,string> mapSZCField{
        get {
            return new Map<string,string> {
                'WGB' => 'Size__c',
                'BGR' => 'Size_Backend__c',
                'HLD' => 'Size__c',
                'RD' => 'Size__c',
                'FlameProducts' => 'Size__c',
                'RLFVLV' => 'Size__c',
                 'PS' => 'Size__c' 
            };
        }
        set {
            this.mapSZCField=value;
        }
    }
    public  map<string,string> mapPTCField {
        get {
            return new Map<string,string> {
                'WGB' => 'Select_Model__c',
                'BGR' => 'Model__c',
                'RD' =>'Product__c',
                'HLD'=> 'Holder_Product_Code__c',
                'FlameProducts' => 'PTC__c',
                'RLFVLV' => 'Model_name__c',
                 'PS' => 'PTC__c'   
            };
        }
        set {
            this.mapPTCField=value;
        }
    }
    public  map<string,string> mapQTYField {
        get {
            return new Map<string,string> {
                'WGB' => 'Quantity__c',
                'BGR' => 'Quantity__c',
                'HLD'=> 'Quantity__c',
                'RD' => 'Quantity__c',
                'FlameProducts' => 'Quantity__c',
                'RLFVLV' => 'Quantity__c',
                 'PS' => 'Quantity__c'   
            };
        }
        set {
            this.mapQTYField=value;
        }
    }
    public result resRouting {set;get;}
    public result resStructure {set;get;}
    public string PARTNUMBER {set;get;}
    public BGROutputUtility BGROU {
        get{
            return new BGROutputUtility(recId);
        } set 
        {
            this.BGROU=value;
        }
    } 
    public string sObjCode {set;get;}
    public string PTC {set;get;}
    public string SZC {set;get;}
    public string QTY {set;get;}
    public string MCD {set;get;}
    public sObject sObj {set;get;}
    public id recId {get;set;}
    public BGR__c conBGR {get;set;}
    public List<Cost__c> assemblyCostList {get;set;}
    public List<Cost__c> buildCostList {get;set;}
    public List<Cost__c> routingCostList {get;set;}
    public WizardCostProcessor (id recordId) {
        recId=recordId;
        MCD='';
        assemblyCostList=new List<Cost__c>(); 
        buildCostList=new List<Cost__c>(); 
        routingCostList=new List<Cost__c>(); 
        string strObjName;
        DescribeSObjectResult describeResult = recordId.getSObjectType().getDescribe();
        strObjName=describeResult.getName();
        sObj=wizardBaseDataProcessor.getObjectDataById(recordID).objResultList[0];
        //conBGR=(BGR__c) wizardBaseDataProcessor.getObjectDataById(recordID).objResultList[0];
        resRouting=new result();
        sObjCode=AssyPartDefinationProcessor.mapObjectwithConfigurator1.get(strObjName);
        System.debug('sObjCode'+sObjCode);
        resStructure=new result();
        if (sObjCode=='WGB') {
            WGBOutputUtility WGBOU=new WGBOutputUtility(recordId);
            resRouting=WGBOU.getRouting();
            resStructure=WGBOU.getStructure();
            System.debug('resRouting'+resRouting);
            System.debug('resStructure'+resStructure);

        } else if (sObjCode=='BGR') {
            BGROutputUtility BGROU=new BGROutputUtility(recordId);
            resRouting=BGROU.getRouting();
            resStructure=BGROU.getStructure();
        } else if (sObjCode=='FlameProducts') {
            FAOutputUtility FAOU=new FAOutputUtility(recordId);
            resRouting=FAOU.getRouting();
            resStructure=FAOU.getStructure();
        }
          else if (sObjCode=='RLFVLV') {
            RVOutputUtility RVOU=new RVOutputUtility(recordId);
            resRouting=RVOU.getRouting();
            resStructure=RVOU.getStructure();
          }
            else if (sObjCode=='PS') {
            PSOutputUtility PSOU=new PSOutputUtility(recordId);
            resRouting=PSOU.getRouting();
            resStructure=PSOU.getStructure();   
        }
        
          else if (sObjCode=='HLD') {
          Holders__c  conHolder = (Holders__c) wizardBaseDataProcessor.getObjectDataById(recordID).objResultList[0];
            ConfigHolderUtility HLDU=new ConfigHolderUtility(recordId);
            map<string,string> holderInputs = ConfigHolderUtility.holderInputs(conHolder);
            resRouting=ConfigHolderUtility.getHLDRouting(holderInputs);
            //resStructure=HLDU.getStructure();
        } 
        else if (sObjCode=='RD') {
            string MCDD=(string) sObj.get('Material_of_Disc__c');
            string MCDT1=(string) sObj.get('Material_of_Top_Section__c');
            string MCDT2=(string) sObj.get('Material_of_Top_Section2__c');
            string MCDT;
            if (MCDT1!=null){
                MCDT=MCDT1;
            } else if (MCDT2!=null) {
                MCDT=MCDT2;
            }
            if(MCDD!=null)
                MCD= MCDD;
            else if(MCDT!=null)
                MCD= MCDT;
            else
                MCD='05';
        }
        System.debug('get(sObjCode)'+mapSZCField.get(sObjCode));
        System.debug('mapSZCField'+mapSZCField);
        System.debug('SZC ==> '+(string) sObj.get(mapSZCField.get(sObjCode))+'');
        SZC=(string) sObj.get(mapSZCField.get(sObjCode))+'';
        QTY=Integer.valueOf((decimal) sObj.get(mapQTYField.get(sObjCode)))+'';
        PTC=(string) sObj.get(mapPTCField.get(sObjCode));
        if(sObjCode=='BGR')
        {
            PARTNUMBER=(string) sObj.get('ASSYPARTEXISTING__c');
        }
        else
        {
             PARTNUMBER=(string) sObj.get('Part_Number__c');
        }
        
        //RResult=BGROU.getRouting();
        System.debug('SZC'+SZC);
        System.debug('QTY'+QTY);
        System.debug('PTC'+PTC);

        routingOpp=new List<String>();
        strucPartList=new List<String>();
        if(resRouting.bResult) {
            for (sObject sobj:resRouting.objResultList) 
            {
                routingOpp.add('\''+(String) sobj.get('Standard_Operation_Id__c')+'\'');
            }
        }
        System.debug('Routing'+routingOpp);
        //result strcResult=BGROU.getStructure();
       
        if(resStructure.bResult)
        { 
            for (sObject sobj:resStructure.objResultList) 
            {
                if ((String) sobj.get(mapStrucComp.get(sObjCode))!=null) {
                    strucPartList.add('\''+(String) sobj.get(mapStrucComp.get(sObjCode))+'\'');
                }
            }
        }
        System.debug('strucPartList'+strucPartList);
    }
    
    public list<Cost_Routing_Outside__c> getRoutingOutCost() {
        list<Cost_Routing_Outside__c> lstroutingout=new list<Cost_Routing_Outside__c>();
        string query='Select Outside_Cost__c,site__c,StdOpName__c from Cost_Routing_Outside__c  ';
        if (SZC!=null && routingOpp.size()>0) {
            String s = String.join(routingOpp,',');
            query=query+'where  StdOpName__c IN ('+s+') and PTC__c=\''+PTC+'\' and SZC__c='+SZC; 
        }
        System.debug('Routing Query OUt'+query);
        lstroutingout=Database.query(query) ; 
        System.debug('REcords Cost'+lstroutingout);
        return lstroutingout;
    }
    public list<Cost_Routing_Inside__c> getRoutingInCost() {
        list<Cost_Routing_Inside__c> lstroutingIn=new list<Cost_Routing_Inside__c>();
        string query='Select Inside_Cost__c,site__c,StdOpName__c from Cost_Routing_Inside__c  ';
        result RResult=new result();
        //BGROutputUtility myStrcDetail = new BGROutputUtility(conBGR.Id);
        if (SZC!=null && routingOpp.size()>0) {
            String s = String.join(routingOpp,',');
            query=query+'where  StdOpName__c IN ('+s+')'; 
        }
        System.debug('Routing Query In'+query);
        lstroutingIn=Database.query(query) ;  
        return lstroutingIn;
    }
    public List<Cost_Part_Number__c> getAssembleCost() {
        List<Cost_Part_Number__c> asmCost=new List<Cost_Part_Number__c>();
        string query='Select InsideCost__c,OutsideCost__c,PartNumber__c,Site__c from Cost_Part_Number__c ';
        //System.debug('hhfhfh'+BGROU.SZC);
        if (PARTNUMBER!=null) {
            query=query+'Where  PartNumber__c=\''+PARTNUMBER+'\' and QtyLL__c<='+QTY+' and QtyUL__c>='+QTY; 
            System.debug('Assembly Cost Query'+query);
            asmCost=Database.query(query);
        }
        return asmCost;
    }
    public List<RD_Cost__c> getRDBulidCost() {
        List<RD_Cost__c> asmCost=new List<RD_Cost__c>();
        string query='Select InsideCost__c,Outside_Cost__c,Site__c from RD_Cost__c ';
        //System.debug('hhfhfh'+BGROU.SZC);
        string sz=ConstantsUtil.getSizeDesc(SZC).SZC;
        query=query+'Where  PTC__c=\''+PTC+'\' and QtyLL__c<='+QTY+' and QtyUL__c>='+QTY+ ' AND SZC__c=\''+sz+'\'';
        System.debug('Cost query: ' + query);
        if (string.isNotBlank(MCD)) {
            query=query+' AND MCD__c=\''+MCD+'\''; 
            System.debug('bUILD Cost Query'+query);
            asmCost=Database.query(query);
        }
        return asmCost;
    }
    public List<Cost_Part_Number__c> getBuildCost() {
        List<Cost_Part_Number__c> buldCost=new List<Cost_Part_Number__c>();
        string query='Select InsideCost__c,OutsideCost__c,PartNumber__c,Site__c from Cost_Part_Number__c ';
        if (strucPartList.size()>0) {
            String s = String.join(strucPartList,',');
            query=query+'Where  PartNumber__c IN ('+s+') and QtyLL__c<='+QTY+' and QtyUL__c>='+QTY; 
            system.debug('**** query = '+query);
            buldCost=Database.query(query);
        }
        return buldCost;
    }
    public List<Cost__c> getRDCostData() {
        //List<CostWrapper> cstData=new List<CostWrapper>();
        //Get Assembly Cost;
        Boolean pickAssemblyCost=true;
        List<Cost__c> rdCostList = new List<Cost__c>();
        List<Cost_Part_Number__c> assmCost=getAssembleCost();
        List<Cost__c> exAssyCost=[SELECT id,name,Product__c,Cost_Method__c,Part_Number__c,Ref_Id__c,Cost_Sub_Type__c,
                            Inside_Cost_10__c,Inside_Cost_20__c,Inside_Cost_30__c,
                            Outside_Cost_10__c,Outside_Cost_20__c,Outside_Cost_30__c,
                            Inside_Cost_Override_10__c,Inside_Cost_Override_20__c,Inside_Cost_Override_30__c,
                            Outside_Cost_Override_10__c,Outside_Cost_Override_20__c,Outside_Cost_Override_30__c 
                            FROM Cost__c where Ref_Id__c=:sObj.Id And Cost_Method__c='Assembly'];
        List<Cost__c> exBuildCost=[SELECT id,name,Product__c,Cost_Method__c,Part_Number__c,Ref_Id__c,Cost_Sub_Type__c,
                            Inside_Cost_10__c,Inside_Cost_20__c,Inside_Cost_30__c,
                            Outside_Cost_10__c,Outside_Cost_20__c,Outside_Cost_30__c,
                            Inside_Cost_Override_10__c,Inside_Cost_Override_20__c,Inside_Cost_Override_30__c,
                            Outside_Cost_Override_10__c,Outside_Cost_Override_20__c,Outside_Cost_Override_30__c 
                            FROM Cost__c where Ref_Id__c=:sObj.Id And Cost_Method__c='Build Up'];
        List<Cost__c> exOverCost=[SELECT id,name,Product__c,Cost_Method__c,Part_Number__c,Ref_Id__c,Cost_Sub_Type__c,
                            Inside_Cost_10__c,Inside_Cost_20__c,Inside_Cost_30__c,
                            Outside_Cost_10__c,Outside_Cost_20__c,Outside_Cost_30__c,
                            Inside_Cost_Override_10__c,Inside_Cost_Override_20__c,Inside_Cost_Override_30__c,
                            Outside_Cost_Override_10__c,Outside_Cost_Override_20__c,Outside_Cost_Override_30__c 
                            FROM Cost__c where Ref_Id__c=:sObj.Id And Cost_Method__c='Overriden'];
        if (!assmCost.isEmpty()) {
            Cost__c newCost = new Cost__c();
            if(exAssyCost.size()>0)
                newCost=exAssyCost[0];  
            newCost.Ref_Id__c = sObj.Id;
            newCost.Product__c = sObjCode;
            newCost.Cost_Method__c = 'Assembly';
            newCost.Cost_Sub_Type__c = NULL;
            for (Cost_Part_Number__c cst:assmCost) {
                if(string.valueOf(cst.Site__c) == '10') 
                {
                    newCost.Inside_Cost_10__c = string.valueOf(cst.InsideCost__c);
                    newCost.Outside_Cost_10__c = string.valueOf(cst.OutsideCost__c);
                    System.debug('@@@@ 0 => inside cost = '+newCost.Inside_Cost_10__c+', outside cost = '+newCost.Outside_Cost_10__c);
                    if(String.isBlank(newCost.Inside_Cost_Override_10__c))
                    {
                        newCost.Inside_Cost_Override_10__c = newCost.Inside_Cost_10__c;
                    }
                    if(String.isBlank(newCost.Outside_Cost_Override_10__c))
                    {
                        newCost.Outside_Cost_Override_10__c = newCost.Outside_Cost_10__c;
                    }
                } 
                else if(string.valueOf(cst.Site__c) == '20') 
                {
                    newCost.Inside_Cost_20__c=string.valueOf(cst.InsideCost__c);
                    newCost.Outside_Cost_20__c=string.valueOf(cst.OutsideCost__c);
                    System.debug('@@@@ 20 => inside cost = '+newCost.Inside_Cost_20__c+', outside cost = '+newCost.Outside_Cost_20__c);
                    
                    if(String.isBlank(newCost.Inside_Cost_Override_20__c))
                    {
                        newCost.Inside_Cost_Override_20__c = newCost.Inside_Cost_20__c;
                    }
                    if(String.isBlank(newCost.Outside_Cost_Override_20__c))
                    {
                        newCost.Outside_Cost_Override_20__c = newCost.Outside_Cost_20__c;
                    }
                } 
                else if(string.valueOf(cst.Site__c) == '30') 
                {
                    newCost.Inside_Cost_30__c=string.valueOf(cst.InsideCost__c);
                    newCost.Outside_Cost_30__c=string.valueOf(cst.OutsideCost__c);
                    System.debug('@@@@ 30 => inside cost = '+newCost.Inside_Cost_30__c+', outside cost = '+newCost.Outside_Cost_30__c);
                    
                    if(String.isBlank(newCost.Inside_Cost_Override_30__c))
                    {
                        newCost.Inside_Cost_Override_30__c = newCost.Inside_Cost_30__c;
                    }
                    if(String.isBlank(newCost.Outside_Cost_Override_30__c))
                    {
                        newCost.Outside_Cost_Override_30__c = newCost.Outside_Cost_30__c;
                    }
                }
            }
            rdCostList.add(newCost);
        } else {
            pickAssemblyCost=false;
        }
        List<RD_Cost__c> rdbuildCost=getRDBulidCost();
        //if (!rdbuildCost.isEmpty()) {
            Cost__c newCost3 = new Cost__c();
            if(exBuildCost.size()>0)
                newCost3=exBuildCost[0];  
            newCost3.Ref_Id__c = sObj.Id;
            newCost3.Product__c = sObjCode;
            newCost3.Cost_Method__c = 'Build Up';
            newCost3.Cost_Sub_Type__c = NULL;
            for (RD_Cost__c cst:rdbuildCost) {
                if(string.valueOf(cst.Site__c) == '10') 
                {
                    newCost3.Inside_Cost_10__c = string.valueOf(cst.InsideCost__c);
                    newCost3.Outside_Cost_10__c = string.valueOf(cst.Outside_Cost__c);
                    System.debug('@@@@ getRDCostData 0 => inside cost = '+newCost3.Inside_Cost_10__c+', outside cost = '+newCost3.Outside_Cost_10__c);
                    if(String.isBlank(newCost3.Inside_Cost_Override_10__c))
                    {
                        newCost3.Inside_Cost_Override_10__c = newCost3.Inside_Cost_10__c;
                    }
                    if(String.isBlank(newCost3.Outside_Cost_Override_10__c))
                    {
                        newCost3.Outside_Cost_Override_10__c = newCost3.Outside_Cost_10__c;
                    }
                } 
                else if(string.valueOf(cst.Site__c) == '20') 
                {
                    newCost3.Inside_Cost_20__c=string.valueOf(cst.InsideCost__c);
                    newCost3.Outside_Cost_20__c=string.valueOf(cst.Outside_Cost__c);
                    System.debug('@@@@ getRDCostData 20 => inside cost = '+newCost3.Inside_Cost_20__c+', outside cost = '+newCost3.Outside_Cost_20__c);
                    
                    if(String.isBlank(newCost3.Inside_Cost_Override_20__c))
                    {
                        newCost3.Inside_Cost_Override_20__c = newCost3.Inside_Cost_20__c;
                    }
                    if(String.isBlank(newCost3.Outside_Cost_Override_20__c))
                    {
                        newCost3.Outside_Cost_Override_20__c = newCost3.Outside_Cost_20__c;
                    }
                } 
                else if(string.valueOf(cst.Site__c) == '30') 
                {
                    newCost3.Inside_Cost_30__c=string.valueOf(cst.InsideCost__c);
                    newCost3.Outside_Cost_30__c=string.valueOf(cst.Outside_Cost__c);
                    System.debug('@@@@ getRDCostData 30 => inside cost = '+newCost3.Inside_Cost_30__c+', outside cost = '+newCost3.Outside_Cost_30__c);
                    
                    if(String.isBlank(newCost3.Inside_Cost_Override_30__c))
                    {
                        newCost3.Inside_Cost_Override_30__c = newCost3.Inside_Cost_30__c;
                    }
                    if(String.isBlank(newCost3.Outside_Cost_Override_30__c))
                    {
                        newCost3.Outside_Cost_Override_30__c = newCost3.Outside_Cost_30__c;
                    }
                }
            }
            System.debug('@@@@ getRDCostData newCost3'+newCost3);
            rdCostList.add(newCost3);
            
        //}
        
       //Cost__c newCost1 = new Cost__c();
        Cost__c newCost1 = new Cost__c();
        if(exOverCost.size()>0)
            newCost1=exOverCost[0]; 
        if (pickAssemblyCost){
            
            newCost1.Ref_Id__c = sObj.Id;
            newCost1.Product__c = sObjCode;
            newCost1.Cost_Method__c = 'Overridden';
            newCost1.Cost_Sub_Type__c = NULL;
            for (Cost_Part_Number__c cst:assmCost) {
                if(string.valueOf(cst.Site__c) == '10') 
                {
                    newCost1.Inside_Cost_10__c = string.valueOf(cst.InsideCost__c);
                    newCost1.Outside_Cost_10__c = string.valueOf(cst.OutsideCost__c);
                    System.debug('@@@@ 0 => inside cost = '+newCost1.Inside_Cost_10__c+', outside cost = '+newCost1.Outside_Cost_10__c);
                    if(String.isBlank(newCost3.Inside_Cost_Override_10__c))
                    {
                        newCost1.Inside_Cost_Override_10__c = newCost1.Inside_Cost_10__c;
                    }
                    if(String.isBlank(newCost1.Outside_Cost_Override_10__c))
                    {
                        newCost1.Outside_Cost_Override_10__c = newCost1.Outside_Cost_10__c;
                    }
                } 
                else if(string.valueOf(cst.Site__c) == '20') 
                {
                    newCost1.Inside_Cost_20__c=string.valueOf(cst.InsideCost__c);
                    newCost1.Outside_Cost_20__c=string.valueOf(cst.OutsideCost__c);
                    System.debug('@@@@ 20 => inside cost = '+newCost1.Inside_Cost_20__c+', outside cost = '+newCost1.Outside_Cost_20__c);
                    
                    if(String.isBlank(newCost1.Inside_Cost_Override_20__c))
                    {
                        newCost1.Inside_Cost_Override_20__c = newCost1.Inside_Cost_20__c;
                    }
                    if(String.isBlank(newCost1.Outside_Cost_Override_20__c))
                    {
                        newCost1.Outside_Cost_Override_20__c = newCost1.Outside_Cost_20__c;
                    }
                } 
                else if(string.valueOf(cst.Site__c) == '30') 
                {
                    newCost1.Inside_Cost_30__c=string.valueOf(cst.InsideCost__c);
                    newCost1.Outside_Cost_30__c=string.valueOf(cst.OutsideCost__c);
                    System.debug('@@@@ 30 => inside cost = '+newCost1.Inside_Cost_30__c+', outside cost = '+newCost1.Outside_Cost_30__c);
                    
                    if(String.isBlank(newCost1.Inside_Cost_Override_30__c))
                    {
                        newCost1.Inside_Cost_Override_30__c = newCost1.Inside_Cost_30__c;
                    }
                    if(String.isBlank(newCost1.Outside_Cost_Override_30__c))
                    {
                        newCost1.Outside_Cost_Override_30__c = newCost1.Outside_Cost_30__c;
                    }
                }
            }
        } else {
            //Cost__c newCost = new Cost__c();
            newCost1.Ref_Id__c = sObj.Id;
            newCost1.Product__c = sObjCode;
            newCost1.Cost_Method__c = 'Overriden';
            newCost1.Cost_Sub_Type__c = NULL;
            for (RD_Cost__c cst:rdbuildCost) {
                if(string.valueOf(cst.Site__c) == '10') 
                {
                    newCost1.Inside_Cost_10__c = string.valueOf(cst.InsideCost__c);
                    newCost1.Outside_Cost_10__c = string.valueOf(cst.Outside_Cost__c);
                    System.debug('@@@@ 0 => inside cost = '+newCost1.Inside_Cost_10__c+', outside cost = '+newCost1.Outside_Cost_10__c);
                    if(String.isBlank(newCost1.Inside_Cost_Override_10__c))
                    {
                        newCost1.Inside_Cost_Override_10__c = newCost1.Inside_Cost_10__c;
                    }
                    if(String.isBlank(newCost1.Outside_Cost_Override_10__c))
                    {
                        newCost1.Outside_Cost_Override_10__c = newCost1.Outside_Cost_10__c;
                    }
                } 
                else if(string.valueOf(cst.Site__c) == '20') 
                {
                    newCost1.Inside_Cost_20__c=string.valueOf(cst.InsideCost__c);
                    newCost1.Outside_Cost_20__c=string.valueOf(cst.Outside_Cost__c);
                    System.debug('@@@@ 20 => inside cost = '+newCost1.Inside_Cost_20__c+', outside cost = '+newCost1.Outside_Cost_20__c);
                    
                    if(String.isBlank(newCost1.Inside_Cost_Override_20__c))
                    {
                        newCost1.Inside_Cost_Override_20__c = newCost1.Inside_Cost_20__c;
                    }
                    if(String.isBlank(newCost1.Outside_Cost_Override_20__c))
                    {
                        newCost1.Outside_Cost_Override_20__c = newCost1.Outside_Cost_20__c;
                    }
                } 
                else if(string.valueOf(cst.Site__c) == '30') 
                {
                    newCost1.Inside_Cost_30__c=string.valueOf(cst.InsideCost__c);
                    newCost1.Outside_Cost_30__c=string.valueOf(cst.Outside_Cost__c);
                    System.debug('@@@@ 30 => inside cost = '+newCost1.Inside_Cost_30__c+', outside cost = '+newCost1.Outside_Cost_30__c);
                    
                    if(String.isBlank(newCost1.Inside_Cost_Override_30__c))
                    {
                        newCost1.Inside_Cost_Override_30__c = newCost1.Inside_Cost_30__c;
                    }
                    if(String.isBlank(newCost1.Outside_Cost_Override_30__c))
                    {
                        newCost1.Outside_Cost_Override_30__c = newCost1.Outside_Cost_30__c;
                    }
                }
            }
        }
        rdCostList.add(newCost1);
        System.debug('varrdCostList: ' + rdCostList);
        if(!Test.isRunningTest())
        	upsert rdCostList;
        
        return rdCostList;
    }
    public class CostWrapper {
        public Cost__c costItem{set;get;}
        public String costMethod{set;get;}
        public String costSubType{set;get;}
        public String costPartNum{set;get;}
        public decimal costInsite10{set;get;}
        public decimal costOutsite10{set;get;}
        public decimal costInsite20{set;get;}
        public decimal costOutsite20{set;get;}
        public decimal costInsite30{set;get;}
        public decimal costOutsite30{set;get;}

        public CostWrapper(Cost__c c) {
            if(c.Inside_Cost_10__c!=null)
                this.costInsite10=decimal.valueOf(c.Inside_Cost_10__c);
            if(c.Outside_Cost_10__c!=null)
                this.costOutsite10=decimal.valueOf(c.Outside_Cost_10__c);
            if(c.Inside_Cost_20__c!=null)
                this.costInsite20=decimal.valueOf(c.Inside_Cost_20__c);
            if(c.Outside_Cost_20__c!=null)
                this.costOutsite20=decimal.valueOf(c.Outside_Cost_20__c);
            if(c.Inside_Cost_30__c!=null)
                this.costInsite30=decimal.valueOf(c.Inside_Cost_30__c);
            if(c.Outside_Cost_30__c!=null)
                this.costOutsite30=decimal.valueOf(c.Outside_Cost_30__c);
            this.costMethod=c.Cost_Method__c;
            this.costSubType=c.Cost_Sub_Type__c;
            this.costPartNum=c.Part_Number__c;
        }
    }
    public Map<String, Cost__c> getCostRecords()
    {
    	Map<String, Cost__c> costMap = new Map<String, Cost__c>();
        System.debug('Cosyttt'+sObj.Id);
        for(Cost__c cost: [SELECT id,name,Product__c,Cost_Method__c,Part_Number__c,Ref_Id__c,Cost_Sub_Type__c,
                           Inside_Cost_10__c,Inside_Cost_20__c,Inside_Cost_30__c,
                           Outside_Cost_10__c,Outside_Cost_20__c,Outside_Cost_30__c,
                           Inside_Cost_Override_10__c,Inside_Cost_Override_20__c,Inside_Cost_Override_30__c,
                           Outside_Cost_Override_10__c,Outside_Cost_Override_20__c,Outside_Cost_Override_30__c 
                           FROM Cost__c where Ref_Id__c=:String.valueOf(sObj.Id)])
        {
            
            String costKey = cost.Cost_Method__c + '_' + cost.Part_Number__c;
            System.debug('Cosyttt'+costKey);
            costMap.put(costKey, cost);        
        }
        return costMap;
    }
    public Map<String,List<Cost__c>> getBGRCostData() 
    {
        System.debug('@@@@@ method entry');
        List<CostWrapper> bgrCostWrap=new List<CostWrapper>();
        Map<String,List<Cost__c>> allCostMap = new Map<String,List<Cost__c>>();
        Result costRes = new Result();
        List<Cost__c> costlist = new List<Cost__c>();
        try 
        {
            Map<String, List<Cost_Part_Number__c>> assemblyBuildCostMap = getCosts();
            system.debug('Inside try for cost');
            Map<String, Cost__c> costsMap = getCostRecords();
            for(String mapKey: assemblyBuildCostMap.Keyset())
            {
                if(assemblyBuildCostMap.get(mapKey) != null && assemblyBuildCostMap.get(mapKey).size() > 0)
                {
                    for(Cost_Part_Number__c cst : assemblyBuildCostMap.get(mapKey)) 
                    {
                        Cost__c newCost = new Cost__c();
                        newCost.Ref_Id__c = sObj.Id;
                        newCost.Product__c = sObjCode;
                        newCost.Cost_Method__c = mapKey;
                        newCost.Cost_Sub_Type__c = NULL;
                        if(mapKey == 'Build Up')
                        {
                            newCost.Cost_Sub_Type__c = 'Structure';
                        }
                        
                        newCost.Part_Number__c = cst.PartNumber__c;
                        System.debug('@@@@@ key = '+newCost.Cost_Method__c +'_'+ newCost.Part_Number__c +' contains in map = '+costsMap.containsKey(newCost.Cost_Method__c +'_'+ newCost.Part_Number__c));
                        if(costsMap.containsKey(newCost.Cost_Method__c +'_'+ newCost.Part_Number__c))
                        {
                            newCost = costsMap.get(newCost.Cost_Method__c +'_'+ newCost.Part_Number__c);
                        }
                        System.debug('@@@@ Site = '+cst.Site__c);
                        if(string.valueOf(cst.Site__c) == '10') 
                        {
                            newCost.Inside_Cost_10__c = string.valueOf(cst.InsideCost__c);
                            newCost.Outside_Cost_10__c = string.valueOf(cst.OutsideCost__c);
                            System.debug('@@@@ 0 => inside cost = '+newCost.Inside_Cost_10__c+', outside cost = '+newCost.Outside_Cost_10__c);
                            if(String.isBlank(newCost.Inside_Cost_Override_10__c))
                            {
                                newCost.Inside_Cost_Override_10__c = newCost.Inside_Cost_10__c;
                            }
                            if(String.isBlank(newCost.Outside_Cost_Override_10__c))
                            {
                                newCost.Outside_Cost_Override_10__c = newCost.Outside_Cost_10__c;
                            }
                        }
                        else if(string.valueOf(cst.Site__c) == '20') 
                        {
                            newCost.Inside_Cost_20__c=string.valueOf(cst.InsideCost__c);
                            newCost.Outside_Cost_20__c=string.valueOf(cst.OutsideCost__c);
                            System.debug('@@@@ 20 => inside cost = '+newCost.Inside_Cost_20__c+', outside cost = '+newCost.Outside_Cost_20__c);
                            
                            if(String.isBlank(newCost.Inside_Cost_Override_20__c))
                            {
                                newCost.Inside_Cost_Override_20__c = newCost.Inside_Cost_20__c;
                            }
                            if(String.isBlank(newCost.Outside_Cost_Override_20__c))
                            {
                                newCost.Outside_Cost_Override_20__c = newCost.Outside_Cost_20__c;
                            }
                        } 
                        else if(string.valueOf(cst.Site__c) == '30') 
                        {
                            newCost.Inside_Cost_30__c=string.valueOf(cst.InsideCost__c);
                            newCost.Outside_Cost_30__c=string.valueOf(cst.OutsideCost__c);
                            System.debug('@@@@ 30 => inside cost = '+newCost.Inside_Cost_30__c+', outside cost = '+newCost.Outside_Cost_30__c);
                            
                            if(String.isBlank(newCost.Inside_Cost_Override_30__c))
                            {
                                newCost.Inside_Cost_Override_30__c = newCost.Inside_Cost_30__c;
                            }
                            if(String.isBlank(newCost.Outside_Cost_Override_30__c))
                            {
                                newCost.Outside_Cost_Override_30__c = newCost.Outside_Cost_30__c;
                            }
                        }
                        system.debug('@@@@ method = '+newCost.Cost_Method__c+', inside 10 override = '+newCost.Inside_Cost_Override_10__c);
                		costlist.add(newCost);
                    }
                }
            }
            /*List<Cost__c> cstList = new List<Cost__c>();
            cstList=[Select id from Cost__c where Ref_Id__c=:String.valueOf(conBGR.Id)];
            if(!cstList.isEmpty() && cstList.size() >0 )
            {
                delete cstList;
            }*/
        
            list<Cost_Routing_Inside__c> routIn=getRoutingInCost();
            list<Cost_Routing_Outside__c> routOut=getRoutingOutCost();
            Map<String,String> rtInList=new Map<String,String>();
            Map<String,String> rtOutList=new Map<String,String>();
            for(Cost_Routing_Inside__c rIn: routIn) 
            {
               string key=rIn.StdOpName__c+'->'+rIn.Site__c;
               string value=string.valueOf(rIn.Inside_Cost__c);
               rtInList.put(key,value);
            }
            for(Cost_Routing_Outside__c rOut: routOut) 
            {
                string key=rOut.StdOpName__c+'->'+rOut.Site__c;
                string value=string.valueOf(rOut.Outside_Cost__c);
                rtOutList.put(key,value);
            }
            for(string str:routingOpp) 
            {
                Cost__c newCost2=new Cost__c();
                newCost2.Ref_Id__c=sObj.Id;
                newCost2.Product__c=sObjCode;
                newCost2.Cost_Method__c='Build Up';
                newCost2.Cost_Sub_Type__c='Router';
                string s=str.removeEnd('\'').removeStart('\'');
                string key=s+'->10';
                string key2=s+'->20';
                string key3=s+'->30';
                System.debug('Side KEy In keyset'+rtInList.keyset());
                System.debug('Side KEy Out keyset'+rtOutList.keyset());
                newCost2.Part_Number__c=str.removeEnd('\'').removeStart('\'');
                System.debug('@@@@@ key = '+newCost2.Cost_Method__c +'_'+ newCost2.Part_Number__c +' contains in map = '+costsMap.containsKey(newCost2.Cost_Method__c +'_'+ newCost2.Part_Number__c));
                    
                if(costsMap.containsKey(newCost2.Cost_Method__c +'_'+ newCost2.Part_Number__c))
                {
                    newCost2 = costsMap.get(newCost2.Cost_Method__c +'_'+ newCost2.Part_Number__c);
                }
                if(rtInList.size() > 0)
                {
                    newCost2.Inside_Cost_10__c = rtInList.containsKey(key) ? rtInList.get(key) : '0';
                    newCost2.Inside_Cost_20__c = rtInList.containsKey(key2) ? rtInList.get(key2) : '0';
                    newCost2.Inside_Cost_30__c = rtInList.containsKey(key3) ? rtInList.get(key3) : '0';
                    if(String.isBlank(newCost2.Inside_Cost_Override_10__c))
                    {
                        newCost2.Inside_Cost_Override_10__c = newCost2.Inside_Cost_10__c;
                    }
                    if(String.isBlank(newCost2.Inside_Cost_Override_20__c))
                    {
                        newCost2.Inside_Cost_Override_20__c = newCost2.Inside_Cost_20__c;
                    }
                    if(String.isBlank(newCost2.Inside_Cost_Override_30__c))
                    {
                        newCost2.Inside_Cost_Override_30__c = newCost2.Inside_Cost_30__c;
                    }
                }
                if(rtOutList.size() > 0)
                {
                    newCost2.Outside_Cost_10__c= rtOutList.containsKey(key) ? rtOutList.get(key) : '0';
                    newCost2.Outside_Cost_20__c= rtOutList.containsKey(key2) ? rtOutList.get(key2) : '0';
                    newCost2.Outside_Cost_30__c= rtOutList.containsKey(key3) ? rtOutList.get(key3) : '0';
                    if(String.isBlank(newCost2.Outside_Cost_Override_10__c))
                    {
                        newCost2.Outside_Cost_Override_10__c = newCost2.Outside_Cost_10__c;
                    }
                    if(String.isBlank(newCost2.Outside_Cost_Override_20__c))
                    {
                        newCost2.Outside_Cost_Override_20__c = newCost2.Outside_Cost_20__c;
                    }
                    if(String.isBlank(newCost2.Outside_Cost_Override_30__c))
                    {
                        newCost2.Outside_Cost_Override_30__c = newCost2.Outside_Cost_30__c;
                    }
                }
                costlist.add(newCost2);
                System.debug('key1'+key);
                System.debug('key2'+key2);
                System.debug('key3'+key3);
                System.debug('Cost Routing '+rtInList.get(key2));
                System.debug('Cost Routing '+rtOutList.get(key2));
            }
        
        
            //upsert costlist;
            Cost__c newCost3=new Cost__c();
            newCost3.Ref_Id__c=sObj.Id;
            newCost3.Product__c=sObjCode;
            newCost3.Cost_Method__c=NULL;
            newCost3.Cost_Sub_Type__c=NULL;
            newCost3.Cost_Method__c='Overriden';
            decimal inside10Total = 0.00;
            decimal inside20Total = 0.00;
            decimal inside30Total = 0.00;
            decimal outside10Total = 0.00;
            decimal outside20Total = 0.00;
            decimal outside30Total = 0.00;            
            for(Cost__c cs:costlist) 
            {
                if(cs.Cost_Method__c=='Assembly' && cs.Part_Number__c!=null) 
                {
                    if(cs.Inside_Cost_Override_20__c != null)
                        inside20Total = double.ValueOf(checkforBlankNull(cs.Inside_Cost_Override_20__c));
                    if(cs.Inside_Cost_Override_30__c != null)
                        inside30Total = double.ValueOf(checkforBlankNull(cs.Inside_Cost_Override_30__c));
                    if(cs.Inside_Cost_Override_10__c != null)
                        inside10Total = double.ValueOf(checkforBlankNull(cs.Inside_Cost_Override_10__c));
                    if(cs.Outside_Cost_Override_10__c != null)
                        outside10Total = double.ValueOf(checkforBlankNull(cs.Outside_Cost_Override_10__c));
                    if(cs.Outside_Cost_Override_20__c != null)
                        outside20Total = double.ValueOf(checkforBlankNull(cs.Outside_Cost_Override_20__c));
                    if(cs.Outside_Cost_Override_30__c != null)
                        outside30Total = double.ValueOf(checkforBlankNull(cs.Outside_Cost_Override_30__c)); 
                    break;                 
                } 
                else
                {
                    if(cs.Inside_Cost_Override_10__c != null)
                        inside10Total += double.ValueOf(checkforBlankNull(cs.Inside_Cost_Override_10__c));
                    if(cs.Inside_Cost_Override_20__c != null)
                        inside20Total += double.ValueOf(checkforBlankNull(cs.Inside_Cost_Override_20__c));
                    if(cs.Inside_Cost_Override_30__c != null)
                        inside30Total += double.ValueOf(checkforBlankNull(cs.Inside_Cost_Override_30__c));
                    if(cs.Outside_Cost_Override_10__c != null)
                        outside10Total += double.ValueOf(checkforBlankNull(cs.Outside_Cost_Override_10__c));
                    if(cs.Outside_Cost_Override_20__c != null)
                        outside20Total += double.ValueOf(checkforBlankNull(cs.Outside_Cost_Override_20__c));
                    if(cs.Outside_Cost_Override_30__c != null)
                        outside30Total += double.ValueOf(checkforBlankNull(cs.Outside_Cost_Override_30__c));                 
                }
                System.debug('@@@ totals 10 inside = '+inside10Total+', outside10Total = '+outside10Total);
                System.debug('@@@ totals 20 inside = '+inside20Total+', outside20Total = '+outside20Total);
                System.debug('@@@ totals 30 inside = '+inside30Total+', outside30Total = '+outside30Total);
    
            }
            newCost3.Inside_Cost_10__c=inside10Total+'';
            newCost3.Outside_Cost_10__c=outside10Total+'';
            newCost3.Inside_Cost_20__c=inside20Total+'';
            newCost3.Outside_Cost_20__c=outside20Total+'';
            newCost3.Inside_Cost_30__c=inside30Total+'';
            newCost3.Outside_Cost_30__c=outside30Total+'';
            //upsert newCost3;
            costlist.add(newCost3);
            upsert costlist;
            for(Cost__c costRecord: costlist)
            {
                String costMethod = costRecord.Cost_Method__c;
                //System.debug('@@@@@@ costMethod = '+costMethod);
                if(!allCostMap.containsKey(costMethod))
                {
                    allCostMap.put(costMethod, new List<Cost__c>());
                }
                allCostMap.get(costMethod).add(costRecord);
            }
            costRes.bResult=true;
        }
        catch (Exception e) 
        {
           System.debug('Exception Cost '+e.getMessage()+', on line '+e.getLineNumber()+', trace = '+e.getStackTraceString());
        }
        return allCostMap;
    }
    
    public String checkforBlankNull(String checkValue)
    {
        String returnValue;
        if(String.isBlank(checkValue))
        {
            return '0.00';
        }
        return checkValue;
    }
    
    public Map<String, List<Cost_Part_Number__c>> getCosts()
    {
        Boolean hasPartNumber=false;
        Map<String, List<Cost_Part_Number__c>> costMap = new Map<String, List<Cost_Part_Number__c>>();
        String query = 'Select InsideCost__c,OutsideCost__c,PartNumber__c,Site__c from Cost_Part_Number__c ';
        if(PARTNUMBER != null) 
        {
            query += ' Where ( PartNumber__c=\''+PARTNUMBER+'\'';
            hasPartNumber = true;
        }
        if(strucPartList.size()>0)
        {
            String s = String.join(strucPartList,',');
            if(hasPartNumber)
            {
                query += ' OR ';
            }
            else
            {
                query += ' Where (';
            }
            query += ' PartNumber__c IN ('+s+'))';
        }
        system.debug('Quantity ***'+QTY+'Part number'+PARTNUMBER+'Structurte size'+strucPartList.size());
        if(QTY != null && (PARTNUMBER != null || strucPartList.size() > 0))
        {
            query += ' and QtyLL__c <= '+QTY+' and QtyUL__c >= '+QTY;
        	system.debug('@!@ dynamic query is'+query);
            for(Cost_Part_Number__c costPart: Database.query(query))
            {
                String costMethod;
                if(PARTNUMBER != null && costPart.PartNumber__c == PARTNUMBER)
                {
                    costMethod = 'Assembly';
                }
                else if(strucPartList.size()>0)
                {
                    costMethod = 'Build Up';
                }
                System.debug('***** costMethod = '+costMethod);
                if(String.isNotBlank(costMethod))
                {
                    if(!costMap.containsKey(costMethod))
                    {
                        System.debug('creating instance in map for '+costPart);
                        costMap.put(costMethod, new List<Cost_Part_Number__c>());
                    }
                    costMap.get(costMethod).add(costPart);            	
                }
            }
        }
        system.debug('***** costMap = '+costMap);
        return costMap;
    }
    
    public result addBGRCostData() {
        List<CostWrapper> bgrCostWrap=new List<CostWrapper>();
        Result costRes=new Result();
        List<Cost__c> costlist = new List<Cost__c>();
        List<Cost_Part_Number__c> asCost=getAssembleCost();
        Cost__c newCost=new Cost__c();
        newCost.Ref_Id__c=sObj.Id;
        newCost.Product__c=sObjCode;
        newCost.Cost_Method__c=NULL;
        newCost.Cost_Sub_Type__c=NULL;
        newCost.Cost_Method__c='Assembly';
        Cost__c[] cstList=[Select id from Cost__c where Ref_Id__c=:String.valueOf(sObj.Id)];
       
            if(!cstList.isEmpty())
                delete cstList;
       System.debug('Test Data'+asCost);
        for (Cost_Part_Number__c cst : asCost) {
            newCost.Part_Number__c=cst.PartNumber__c;
            if(string.valueOf(cst.Site__c)=='10') {
                newCost.Inside_Cost_10__c=string.valueOf(cst.InsideCost__c);
                //newCost.Inside_Cost_Override_10__c=
                newCost.Outside_Cost_10__c=string.valueOf(cst.OutsideCost__c);
                //newCost.Outside_Cost_Override_10__c=
            } else if (string.valueOf(cst.Site__c)=='20') {
                newCost.Inside_Cost_20__c=string.valueOf(cst.InsideCost__c);
                newCost.Outside_Cost_20__c=string.valueOf(cst.OutsideCost__c);
            } else if (string.valueOf(cst.Site__c)=='30') {
                newCost.Inside_Cost_30__c=string.valueOf(cst.InsideCost__c);
                newCost.Outside_Cost_30__c=string.valueOf(cst.OutsideCost__c);
            }
            
        }
        costlist.add(newCost);
        assemblyCostList.add(newCost);
        System.debug('CostList Size 2: ' + CostList.size());
        List<Cost_Part_Number__c> buldCost=getBuildCost();       
        for (Cost_Part_Number__c cst : buldCost) {
            Cost__c newCost1=new Cost__c();
            newCost1.Ref_Id__c=sObj.Id;
            newCost1.Product__c=sObjCode;
            newCost1.Cost_Method__c='Build Up';
            newCost1.Cost_Sub_Type__c='Structure';
            newCost1.Part_Number__c=cst.PartNumber__c;
            if(string.valueOf(cst.Site__c)=='10') {
                newCost1.Inside_Cost_10__c=string.valueOf(cst.InsideCost__c);
                //newCost.Inside_Cost_Override_10__c=
                newCost1.Outside_Cost_10__c=string.valueOf(cst.OutsideCost__c);
                //newCost.Outside_Cost_Override_10__c=
            } else if (string.valueOf(cst.Site__c)=='20') {
                newCost1.Inside_Cost_20__c=string.valueOf(cst.InsideCost__c);
                newCost1.Outside_Cost_20__c=string.valueOf(cst.OutsideCost__c);
            } else if (string.valueOf(cst.Site__c)=='30') {
                newCost1.Inside_Cost_30__c=string.valueOf(cst.InsideCost__c);
                newCost1.Outside_Cost_30__c=string.valueOf(cst.OutsideCost__c);
            }
            costlist.add(newCost1);
        }
        System.debug('CostList Size: ' + CostList.size());
        list<Cost_Routing_Inside__c> routIn=getRoutingInCost();
        list<Cost_Routing_Outside__c> routOut=getRoutingOutCost();
        Map<String,String> rtInList=new Map<String,String>();
        Map<String,String> rtOutList=new Map<String,String>();
        for (Cost_Routing_Inside__c rIn: routIn) {
           string key=rIn.StdOpName__c+'->'+rIn.Site__c;
           string value=string.valueOf(rIn.Inside_Cost__c);
           rtInList.put(key,value);
        }
        for (Cost_Routing_Outside__c rOut: routOut) {
            string key=rOut.StdOpName__c+'->'+rOut.Site__c;
            string value=string.valueOf(rOut.Outside_Cost__c);
            rtOutList.put(key,value);
        }
        System.debug('Side KEy Out'+rtOutList);
        System.debug('Side KEy In'+rtInList);
        for (string str:routingOpp) {
            Cost__c newCost2=new Cost__c();
            newCost2.Ref_Id__c=sObj.Id;
            newCost2.Product__c=sObjCode;
            newCost2.Cost_Method__c='Build Up';
            newCost2.Cost_Sub_Type__c='Router';
            string s=str.removeEnd('\'').removeStart('\'');
            string key=s+'->10';
            string key2=s+'->20';
            string key3=s+'->30';
            System.debug('Side KEy In keyset'+rtInList.keyset());
            System.debug('Side KEy Out keyset'+rtOutList.keyset());
            newCost2.Part_Number__c=str.removeEnd('\'').removeStart('\'');
            newCost2.Inside_Cost_10__c=rtInList.get(key);
            newCost2.Outside_Cost_10__c=rtOutList.get(key);
            newCost2.Inside_Cost_20__c=rtInList.get(key2);
            newCost2.Outside_Cost_20__c=rtOutList.get(key2);
            newCost2.Inside_Cost_30__c=rtInList.get(key3);
            newCost2.Outside_Cost_30__c=rtOutList.get(key3);
            costlist.add(newCost2);
            System.debug('key1'+key);
            System.debug('key2'+key2);
            System.debug('key3'+key3);
            System.debug('Cost Routing '+rtInList.get(key2));
            System.debug('Cost Routing '+rtOutList.get(key2));
        }
        //try {
            System.debug('CostList Size 3: ' + CostList.size());
            upsert costlist;
            Cost__c newCost3=new Cost__c();
            newCost3.Ref_Id__c=sObj.Id;
            newCost3.Product__c=sObjCode;
            newCost3.Cost_Method__c=NULL;
            newCost3.Cost_Sub_Type__c=NULL;
            newCost3.Cost_Method__c='Overriden';
            decimal inside10Total=0;
            decimal inside30Total=0;
            decimal outside10Total=0;
            decimal inside20Total=0;
            decimal outside20Total=0;
            decimal outside30Total=0;            
            for (Cost__c cs:costlist) {
                
                if (cs.Cost_Method__c=='Assembly' && cs.Part_Number__c!=null) {
                    if (cs.Inside_Cost_20__c!=null)
                        inside20Total =double.ValueOf(cs.Inside_Cost_20__c);
                    if (cs.Inside_Cost_30__c!=null)
                        inside30Total =double.ValueOf(cs.Inside_Cost_30__c);
                    if (cs.Inside_Cost_10__c!=null)
                        inside10Total =double.ValueOf(cs.Inside_Cost_10__c);
                    if (cs.Outside_Cost_10__c!=null)
                        outside10Total =double.ValueOf(cs.Outside_Cost_10__c);
                    if (cs.Outside_Cost_20__c!=null)
                        outside20Total =double.ValueOf(cs.Outside_Cost_20__c);
                    if (cs.Outside_Cost_30__c!=null)
                        outside30Total =double.ValueOf(cs.Outside_Cost_30__c); 
                    break;                 
                } else {
                    
                    if (cs.Inside_Cost_10__c!=null)
                        inside10Total +=double.ValueOf(cs.Inside_Cost_10__c);
                    if (cs.Inside_Cost_20__c!=null)
                        inside20Total +=double.ValueOf(cs.Inside_Cost_20__c);
                    if (cs.Inside_Cost_30__c!=null)
                        inside30Total +=double.ValueOf(cs.Inside_Cost_30__c);
                    if (cs.Outside_Cost_10__c!=null)
                        outside10Total +=double.ValueOf(cs.Outside_Cost_10__c);
                    if (!String.isBlank(cs.Outside_Cost_20__c))
                        outside20Total +=double.ValueOf(cs.Outside_Cost_20__c);
                    if (cs.Outside_Cost_30__c!=null)
                        outside30Total +=double.ValueOf(cs.Outside_Cost_30__c);                 
                }       

            }
            newCost3.Inside_Cost_10__c=inside10Total+'';
            newCost3.Outside_Cost_10__c=outside10Total+'';
            //newCost3.Inside_Cost_20__c=inside20Total+'';
            newCost3.Outside_Cost_20__c=outside20Total+'';
            newCost3.Inside_Cost_30__c=inside30Total+'';
            newCost3.Outside_Cost_30__c=outside30Total+'';
            upsert newCost3;
            costRes.bResult=true;
    //    }
    //     catch (Exception e) {
    //        System.debug('Exception Cost'+e.getMessage());

    //   }
    //     for (Cost__c cst:costlist) {
    //         CostWrapper ab=new CostWrapper(cst);
    //         bgrCostWrap.add(ab);
    //     }
        return costRes;
    }
}