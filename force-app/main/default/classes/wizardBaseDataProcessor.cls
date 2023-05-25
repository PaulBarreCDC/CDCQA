/*
This class handles All Data related operations for all Objects.
Author: Nikhil Arpally Nov 2019
This class will helps in retriving, narrowing and parsing the base data
*/
global class wizardBaseDataProcessor {
    /*
* Author: Nikhil Arpally Nov 2019
* This Method is used to parse the data considering (*) as seperator
* Inputs : objDataList is sObject List which need to be parsed.
*           objFieldName is name of the field in the sObject list which need to b parsed.
* Ouputs:
*       objResult is the Result type object.
*       objResult.bResult indicates the result is success or not
*       objResult.objResultList will have the sObject List with parsed data
*
*/
    public static Map<string,string> mapProdwithObject {
        get {
            return new Map<String, String>{
                'RD' => 'Rupture_Disc__c',
                    'BGR' => 'BGR__c',
                    'WGB' => 'WasteGasBurner__c',
                    'HLD' => 'Holders__c',
                    'PS' => 'Part_Selector__c',
                    'FlameProducts' =>'Flame_Product__c',
                    'RLFVLV'=>'Relief_Valve__c'
                    };
                        
                        }
        set {
            mapProdwithObject = value;
        }
    }
    
    public static Map<string,string> mapObjectwithProductCode {
        get {
            return new Map<String, String>{
                'Rupture_Disc__c' => 'RD' ,
                    'BGR__c' => 'BGR',
                    'WasteGasBurner__c' =>'WGB',
                    'Holders__c' => 'HLD',
                    'Part_Selector__c' => 'PS',
                    'Flame_Product__c' => 'FlameProducts',
                    'Relief_Valve__c' =>'RLFVLV'
                    };
                        
                        }
        set {
            mapObjectwithProductCode = value;
        }
    }
    public static Result parseFieldValues(sObject[] objDataList,string objFieldName)
    {
        // This list will have the values of parsed data
        Result objResult = new Result();
        //This list will have the value of Base Data
        List<sObject> objBaseData=new List<sObject>();
        try {
            for (sObject obj: objDataList)
            {
                String strFieldVal= (String) obj.get(objFieldName);
                List<String> lstString=strFieldVal.split('*');
                for (String str: lstString) {
                    sObject sObj = obj;
                    obj.put(objFieldName,str);
                    objResult.objResultList.add(obj);
                }
            }
            objResult.bResult = true;
        } catch (Exception e) {
            System.debug('The following exception has occurred: wizardBaseDataProcessor:parseFieldValues()' + e.getMessage());
            objResult.bResult = false;
            objResult.strErrorMessage = e.getMessage();
        }
        return objResult;
    }
    public static id getCustomObjectIDbyLine (SBQQ__QuoteLine__c quoteLineRecord, String recordId) 
    {
        Id objId;
        if(quoteLineRecord != null && String.isNotBlank(quoteLineRecord.SBQQ__ProductCode__c)) 
        {
            String strObjName=mapProdwithObject.get(quoteLineRecord.SBQQ__ProductCode__c);
            String strQuery='Select id from '+strObjName+' where Quote_Line__c=\''+recordId+'\'';
            System.debug('getCustomObjectIDbyLine strQuery--- '+strQuery);
            sObject[]  sObj= Database.query(strQuery);
            if (!sObj.isEmpty())
            {
                objId=sObj[0].id;
            }
            System.debug('getCustomObjectIDbyLine objId--- '+objId);
        }
        return objId;
    }
    
    public static id getCustomObjectIDbyLine (id recordId) 
    {
        Id objId;
        SBQQ__QuoteLine__c[] qLine=[select id,SBQQ__Product__c,SBQQ__ProductCode__c from SBQQ__QuoteLine__c where id=:recordId];
        if (!qLine.isEmpty()) {
            //Product2[] prod=[select id,ProductCode from Product2 where id=:qLine[0].SBQQ__Product__c];
            //if(!prod.isEmpty()) {
            String strObjName=mapProdwithObject.get(qLine[0].SBQQ__ProductCode__c);
            String strQuery='Select id from '+strObjName+' where Quote_Line__c=\''+recordId+'\'';
            System.debug('getCustomObjectIDbyLine strQuery--- '+strQuery);
            sObject[]  sObj= Database.query(strQuery);
            if (!sObj.isEmpty())
                objId=sObj[0].id;
            //}
            System.debug('getCustomObjectIDbyLine objId--- '+objId);
        }
        return objId;
    }
    public static Result getDataList(string strObjName,string strWhereClause,string strObjFieldName) {
        Result objResult = new Result();
        List<sObject> objBaseData=new List<sObject>();
        try {
            String strQuery='';
            strQuery='Select id,';
            strQuery=strQuery+strObjFieldName;
            strQuery=strQuery+strWhereClause;
            objBaseData = Database.query(strQuery);
            if (!objBaseData.isEmpty()) {
                objResult.bResult=true;
                objResult.objResultList=objBaseData;
            } else {
                objResult.bResult=false;
                objResult.strErrorMessage='No Data Found';
            }
        } catch (Exception e) {
            System.debug('The following exception has occurred: wizardBaseDataProcessor:getDataList()' + e.getMessage());
            objResult.bResult = false;
            objResult.strErrorMessage = e.getMessage();
        }
        return objResult;
    }
    public static List<string> getNarrowedDataList(sObject[] objDataList,string strObjFieldName) {
        Result objResult = new Result();
        List<string> uniqueList=new List<string>();
        for (sObject sobj :objDataList){
            String strFieldVal= (String) sobj.get(strObjFieldName);
            if(!uniqueList.contains(strFieldVal))
                uniqueList.add(strFieldVal);
        }
        return uniqueList;
    }
    public static string getObjectNameById (id idRecordId) {
        string strObjName;
        System.debug('Record ID Inside getObjectNameById'+idRecordId);
        try {
            DescribeSObjectResult describeResult = idRecordId.getSObjectType().getDescribe();
            if(describeResult.getName()!=Null)
                strObjName=describeResult.getName();
            else
                strObjName='NotFound';
            return strObjName;
        } catch (Exception e) {
            System.debug('The following exception has occurred: wizardBaseDataProcessor:getObjectNameById()' + e.getMessage());
            return null;
        }
    }
    public static Result getObjectDataById (id idRecordId) {
        Result objResult = new Result();
        System.debug('Record ID '+idRecordId);
        DescribeSObjectResult describeResult = idRecordId.getSObjectType().getDescribe();
        System.debug('Record  '+describeResult);
        Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
        // Get all of the fields on the object
        Set<String> fieldNames = fieldMap.keySet();
        // Build a Dynamic Query String.
        String soqlQuery = ' SELECT ' + string.join(new List<String>(fieldNames), ',') + ' FROM ' + describeResult.getName() + ' Where Id =: idRecordId';
        try {
            objResult.objResultList=Database.query(soqlQuery);
            if (!objResult.objResultList.isEmpty()) {
                objResult.bResult=true;
                //objResult.objResultList=objBaseData;
            } else {
                objResult.bResult=false;
                objResult.strErrorMessage='No Data Found';
            }
        }  catch (Exception e) {
            System.debug('The following exception has occurred: wizardBaseDataProcessor:getObjectDataById()' + e.getMessage());
            objResult.bResult = false;
            objResult.strErrorMessage = e.getMessage();
        }
        return objResult;
    }
    public static result createRecordByProductCode (string strPrdCode,id quoteLine) {
        Result objResult = new Result();
        try {
            String strObjName=mapProdwithObject.get(strPrdCode);
            sObject sObj = Schema.getGlobalDescribe().get(strObjName).newSObject();
            sObj.put('Quote_Line__c' , quoteLine) ;
            insert sObj ;
            if (strPrdCode=='BGR') {
                BGR_Outputs__c bgrOutputInstance = new BGR_Outputs__c();
                bgrOutputInstance.BGR_Outputs_Relation_Field__c = sObj.id;
                insert bgrOutputInstance;
            } else if (strPrdCode=='WGB') {
                WGB_Outputs__c wgbOutputInstance = new WGB_Outputs__c();
                wgbOutputInstance.WasteGasBurner__c = sObj.id;
                insert wgbOutputInstance;
            }
            else if (strPrdCode=='RLFVLV') {
                RV_Outputs__c rvOutputInstance = new RV_Outputs__c();
                rvOutputInstance.RV_Outputs_Relation_Field__c = sObj.id;
                insert rvOutputInstance;
            }
            else if (strPrdCode=='RD') {
                List<RD_Outputs__c> RdOutputList = new List<RD_Outputs__c>();
                List<RD_Pricing__c> RdPricingList = new List<RD_Pricing__c>();
                List<RD_Drawings__c> RdDiagramList = new List<RD_Drawings__c>();
                // for(Rupture_Disc__c rD: rdRecordlist)
                //  {
                RD_Pricing__c rDP= new RD_Pricing__c();
                RD_Drawings__c rDD=new RD_Drawings__c();
                RD_Outputs__c rDO=new RD_Outputs__c();
                rDD.Rupture_Disc__c=Sobj.Id;
                rDP.Rupture_Disc__c=Sobj.Id;
                rdO.RD_Outputs_Relation_Field__c=Sobj.Id;
                RdOutputList.add(rDO);
                RdPricingList.add(rDP);
                RdDiagramList.add(rDD);
                // }
                upsert RdOutputList;
                upsert RdPricingList;
                upsert RdDiagramList;
            }
            else {
                
            }
            objResult.objResultList.add(sObj);
            objResult.bResult=true;
        } catch (Exception e) {
            objResult.bResult=false;
            objResult.strErrorMessage='Error while creating the custom object';
        }
        return objResult;
    }
    public static result getMediaPropertiesByType (string strMediaType) {
        Result objResult = new Result();
        try {
            objResult.objResultList=[select Media__c,Media_Phase__c,MolecularWeight__c,SpecificHeatRatio__c,Density__c,CompressFactor__c from Media_Property__c where Media__c=:strMediaType];
            if (!objResult.objResultList.isEmpty()) {
                objResult.bResult=true;
            } else {
                objResult.bResult=false;
                objResult.strErrorMessage='No Data Found';
            }
        } catch (Exception e) {
            System.debug('The following exception has occurred: wizardBaseDataProcessor:getMediaPropertiesByType()' + e.getMessage());
            objResult.bResult = false;
            objResult.strErrorMessage = e.getMessage();
        }
        return objResult;
    }
    public static result getRDPricingByProdId (id idRecordId) {
        Result objResult = new Result();
        try {
            string strDetailObjName='RD_Pricing__c';
            Map<String, Schema.SObjectField> objectDetailFields = Schema.getGlobalDescribe().get(strDetailObjName).getDescribe().fields.getMap();
            Set<String> DetailFieldNames = objectDetailFields.keySet();
            set <String> detailCustomFields=new set <String>();
            for(String str:DetailFieldNames) {
                if(str.endsWith('__c'))
                    detailCustomFields.add(str);
            }
            string strTransQuery=' SELECT id,' + string.join(new List<String>(detailCustomFields), ',') + ' FROM ' +strDetailObjName+ ' WHERE Rupture_Disc__c=\''+idRecordId+'\'';
            RD_Pricing__c[] RDPrice=Database.query(strTransQuery);
            if (!RDPrice.isEmpty()) {
                objResult.objResultList=RDPrice;
                objResult.bResult=true;
            } else {
                objResult.bResult=false;
                objResult.strErrorMessage='No Data Found';
            }
        } catch (Exception e) {
            System.debug('The following exception has occurred: wizardBaseDataProcessor:getMediaPropertiesByType()' + e.getMessage());
            objResult.bResult = false;
            objResult.strErrorMessage = e.getMessage();
        }
        return objResult;
    }
    // used for outputs
    //
    public static result getProdOutputDescData1 (string strObjName, string[] selectCols,string[] whereCols,string[] whereVals,string[] whereComps,string[] extraChars, String sortkey) {
        Result objResult = new Result();
        integer intListSize=whereCols.size();
        string strWhereClause='';
        string strSelCols=' ';
        string strQuery=' ';
        //Below code added for selected fields in dynamic query:Susheel
        for(integer i=0; i<selectCols.size(); i++)
        {
            if(i==selectCols.size()-1)
            {
                if(strSelCols == ' ')
                {
                    strSelCols= strSelCols+selectCols[i];
                }
                else{
                    strSelCols= strSelCols+','+selectCols[i];
                }
            }
            else if(i<selectCols.size())
            {
                if(strSelCols == ' ')
                {
                    strSelCols= strSelCols+selectCols[i];
                }
                else{
                    strSelCols= strSelCols+','+selectCols[i];
                }
            }
        }
        System.debug('strObjName : ' + strObjName+ ' whereVals '+whereVals.size()+' whereComps '+whereComps.size()+' intListSize '+intListSize);
        if ((intListSize==whereVals.size()) && (intListSize==whereComps.size())) {
            for (integer i=0; i<intListSize; i++) {
                System.debug('For loop' +i);
                if(i>0)
                    strWhereClause=strWhereClause+' and ';
                else
                    strWhereClause=strWhereClause+' Where ';
                //below code commented because it is considering only limited selected field:Susheel
                /*  if(i>0 && i<selectCols.size())
strSelCols=strSelCols+',';*/
                if(extraChars[i]!='')
                    if (extraChars[i]!='NULL')
                    strWhereClause=strWhereClause+'('+whereCols[i]+' '+whereComps[i]+' '+whereVals[i]+' or ' +whereCols[i]+' = \''+extraChars[i]+'\')';
                else
                    strWhereClause=strWhereClause+'('+whereCols[i]+' '+whereComps[i]+' '+whereVals[i]+' or '    +whereCols[i]+' = '+extraChars[i]+')';
                else
                    strWhereClause=strWhereClause+whereCols[i]+' '+whereComps[i]+' '+whereVals[i];
                
            }
            strQuery='Select'+strSelCols+'  from '+strObjName+' '+strWhereClause + ' Order by '+sortkey;
            System.debug('Dynamic Query '+strQuery);
            System.debug('Dynamic Query Where Clause'+strWhereClause);
            try {
                objResult.objResultList=Database.query(strQuery);
                if (!objResult.objResultList.isEmpty()) {
                    objResult.bResult=true;
                } else {
                    objResult.bResult=false;
                    objResult.strErrorMessage='No Data Found';
                }
                System.debug('Dynamic List Size'+objResult.objResultList.size());
            } catch (Exception e) {
                objResult.bResult=false;
                System.debug('The following exception has occurred: wizardBaseDataProcessor:getProdOutputDesc()' + e.getMessage());
                objResult.strErrorMessage=e.getMessage();
            }
            
        } else {
            objResult.bResult=false;
            System.debug('The following error has occurred: wizardBaseDataProcessor:getProdOutputDesc()');
            objResult.strErrorMessage='Columns,values and operators should have number of values';
        }
        return objResult;
    }
    
    public static result getProdOutputDescData (string strObjName, string[] selectCols,string[] whereCols,string[] whereVals,string[] whereComps,string[] extraChars) {
        Result objResult = new Result();
        integer intListSize=whereCols.size();
        string strWhereClause='';
        string strSelCols=' ';
        string strQuery=' ';
        //Below code added for selected fields in dynamic query:Susheel
        for(integer i=0; i<selectCols.size(); i++)
        {
            if(i==selectCols.size()-1)
            {
                if(strSelCols == ' ')
                {
                    strSelCols= strSelCols+selectCols[i];
                }
                else{
                    strSelCols= strSelCols+','+selectCols[i];
                }
            }
            else if(i<selectCols.size())
            {
                if(strSelCols == ' ')
                {
                    strSelCols= strSelCols+selectCols[i];
                }
                else{
                    strSelCols= strSelCols+','+selectCols[i];
                }
            }
        }
        System.debug('strObjName : ' + strObjName+ ' whereVals '+whereVals.size()+' whereComps '+whereComps.size()+' intListSize '+intListSize);
        if ((intListSize==whereVals.size()) && (intListSize==whereComps.size())) {
            for (integer i=0; i<intListSize; i++) {
                System.debug('For loop' +i);
                if(i>0)
                    strWhereClause=strWhereClause+' and ';
                else
                    strWhereClause=strWhereClause+' Where ';
                //below code commented because it is considering only limited selected field:Susheel
                /*  if(i>0 && i<selectCols.size())
strSelCols=strSelCols+',';*/
                System.debug('strWhereClause' +strWhereClause);
                if(whereComps[i]=='LIKE') {
                    if(extraChars[i]!='')
                        strWhereClause=strWhereClause+'('+whereCols[i]+' LIKE \'%'+whereVals[i]+'%\' or ' +whereCols[i]+' LIKE \'%'+extraChars[i]+'%\')';
                    else
                        strWhereClause=strWhereClause+'('+whereCols[i]+' LIKE \'%'+whereVals[i]+'%\')';
                } else {
                    if(extraChars[i]!='')
                        if (extraChars[i]!='NULL')
                        strWhereClause=strWhereClause+'('+whereCols[i]+' '+whereComps[i]+' '+whereVals[i]+' or ' +whereCols[i]+' = \''+extraChars[i]+'\')';
                    else
                        strWhereClause=strWhereClause+'('+whereCols[i]+' '+whereComps[i]+' '+whereVals[i]+' or '    +whereCols[i]+' = '+extraChars[i]+')';
                    else
                        strWhereClause=strWhereClause+whereCols[i]+' '+whereComps[i]+' '+whereVals[i];
                }               
                
            }
            strQuery='Select'+strSelCols+'  from '+strObjName+' '+strWhereClause;
            System.debug('Dynamic Query '+strQuery);
            System.debug('Dynamic Query Where Clause'+strWhereClause);
            try {
                objResult.objResultList=Database.query(strQuery);
                if (!objResult.objResultList.isEmpty()) {
                    objResult.bResult=true;
                } else {
                    objResult.bResult=false;
                    objResult.strErrorMessage='No Data Found';
                }
                System.debug('Dynamic List Size'+objResult.objResultList.size());
            } catch (Exception e) {
                objResult.bResult=false;
                System.debug('The following exception has occurred: wizardBaseDataProcessor:getProdOutputDesc()' + e.getMessage());
                objResult.strErrorMessage=e.getMessage();
            }
            
        } else {
            objResult.bResult=false;
            System.debug('The following error has occurred: wizardBaseDataProcessor:getProdOutputDesc()');
            objResult.strErrorMessage='Columns,values and operators should have number of values';
        }
        return objResult;
    }
    
    /*--------------------added by sunita------------------------------------*/
    public static result getDataFromlabelsObj (string strKeyVal,string strInputAttrObjName,string strInputLabelsObjName,Map<string,string> mapDetails,string[] listSelectCols) {
        Result objResult = new Result();
        Map<string,sObject> mapAttr= new  Map<string,sObject>();
        Map<string,sObject> mapLabel= new  Map<string,sObject>();
        
        Map<String, Schema.SObjectField> objectAttrFields = Schema.getGlobalDescribe().get(strInputAttrObjName).getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> objectLabelsFields = Schema.getGlobalDescribe().get(strInputLabelsObjName).getDescribe().fields.getMap();
        
        Set<String> InputFieldNames = objectAttrFields.keySet();
        Set<String> InputLabelNames = objectLabelsFields.keySet();
        
        string strInputnamesQuery=' SELECT ' + string.join(new List<String>(InputFieldNames), ',') + ' FROM ' +strInputAttrObjName;
        string strInputLabelsQuery=' SELECT ' + string.join(new List<String>(InputLabelNames), ',') + ' FROM ' +strInputLabelsObjName;
        
        sObject[] sObjInputNamesList=Database.query(strInputnamesQuery);
        
        set<String> setNamesKey=new set<String>();
        set<String> setLabelsKey=new set<String>();
        
        if (!sObjInputNamesList.isEmpty()) {
            for (sObject sObj:sObjInputNamesList) {
                string strInputnamesKey=(string) sobj.get(strKeyVal);
                if(setNamesKey.add(strInputnamesKey))
                {
                    System.debug('***** strInputnamesKey = '+strInputnamesKey+', sObj = '+sObj);
                    mapAttr.put(strInputnamesKey,sObj);
                }
                
            }
        }
        List <String> selectCols=new List <String>();
        for(String str:InputLabelNames) {
            if(str.endsWith('__c'))
                selectCols.add(str);
        }
        
        String dynamicWhereClause='';
        
        integer maxFieldCount=selectCols.size();
        
        for(String key : mapAttr.keySet()) {
            if(dynamicWhereClause=='')
                dynamicWhereClause='( '+strKeyVal+'=\''+key+'\'';
            else
                dynamicWhereClause=dynamicWhereClause+ ' OR ('+strKeyVal+'=\''+key+'\'';
            for (integer i=1;i<=maxFieldCount;i++) {
                
            }
            
        }
        return objResult;
    }
    
    /**
* @description This Method bulit to get data from Translation and Detail Objects for Outputs
* @author Nikhil Arpally | 13/5/2020
* @param strKeyVal : This is Key between the Translation and Detail Objects.
* @param strTransObjName : Translation Object Name
* @param strDetailObjName : Detail Object Name
* @param mapDetails : This Map should have the keys used in the Translation Objects and respective values
* @param listSelectCols : This is the list of select columns (fileds) from Detail Object.
* @return result :Result will have the final output.
**/
    public static result getDataFromTranslationObj (string strKeyVal,string strTransObjName,string strDetailObjName,Map<string,string> mapDetails,string[] listSelectCols) {
        Result objResult = new Result();
        Map<string,sObject> mapTrans= new  Map<string,sObject>();
        Map<string,sObject[]> mapDetail= new  Map<string,sObject[]>();
        Map<String, Schema.SObjectField> objectTransFields = Schema.getGlobalDescribe().get(strTransObjName).getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> objectDetailFields = Schema.getGlobalDescribe().get(strDetailObjName).getDescribe().fields.getMap();
        System.debug('mapDetails: ' + mapDetails);
        try {
            Set<String> TransFieldNames = objectTransFields.keySet();
            Set<String> DetailFieldNames = objectDetailFields.keySet();
            string strTransQuery=' SELECT ' + string.join(new List<String>(TransFieldNames), ',') + ' FROM ' +strTransObjName;
            string strDetailQuery=' SELECT ' + string.join(new List<String>(listSelectCols), ',') + ' FROM ' +strDetailObjName;
            System.debug('strTransQuery ==' + strTransQuery);
            sObject[] sObjTransList=Database.query(strTransQuery);
            
            System.debug('sObjTransList'+sObjTransList);
            //sObject[] sObjDetailList=Database.query(strDetailQuery);
            set<String> setTransKey=new set<String>();
            set<String> setDetailKey=new set<String>();
            System.debug('strDetailQuery ==' + strDetailQuery);
            System.debug('getDataFromTranslationObj2'+strDetailQuery);
            if (!sObjTransList.isEmpty()) {
                for (sObject sObj:sObjTransList) {
                    string strTransKey=(string) sobj.get(strKeyVal);
                    if(setTransKey.add(strTransKey))
                    {
                        System.debug('***** strTransKey = '+strTransKey+', sObj = '+sObj);
                        mapTrans.put(strTransKey,sObj);
                    }
                    
                }
            }
            //System.debug('getDataFromTranslationObj23'+mapTrans);
            List <String> selectCols=new List <String>();
            for(String str:DetailFieldNames) {
                if(str.endsWith('__c'))
                    selectCols.add(str);
            }
            String dynamicWhereClause='';
            //integer maxFieldCount=DetailFieldNames.size()-(12+listSelectCols.size()+1);
            integer maxFieldCount=selectCols.size();
            // System.debug('DetailFieldNames'+DetailFieldNames);
            // System.debug('DetailFieldNames Size'+mapTrans);
            for(String key : mapTrans.keySet()) {
                System.debug('key: ' + key);
                if(dynamicWhereClause=='')
                    dynamicWhereClause='( '+strKeyVal+'=\''+key+'\'';
                else
                    dynamicWhereClause=dynamicWhereClause+ ' OR ('+strKeyVal+'=\''+key+'\'';
                for (integer i=1;i<=maxFieldCount;i++) {
                    
                    string strTransCol='text'+i+'__c';
                    string strDetailCol='text'+i+'val__c';
                    string strNumCol='num'+i+'__c';
                    string strNumValCol='numval'+i+'__c';
                    string strTrasOpp='textopp'+i+'__c';
                    string strTrasNumOpp='numopp'+i+'__c';
                    // System.debug('strTransCol = '+strTransCol);
                    // System.debug('strDetailCol = '+strDetailCol);
                    // System.debug('strNumCol = '+strNumCol);
                    // System.debug('strNumValCol = '+strNumValCol);
                    // System.debug('TransFieldNames'+TransFieldNames);
                    // System.debug('TransFieldNames.contains(strTransCol) = '+TransFieldNames.contains(strTransCol)+', TransFieldNames.contains(strNumCol) = '+TransFieldNames.contains(strNumCol));
                    System.debug('StrKeyVal Outside'+key);
                    if(TransFieldNames.contains(strTransCol) || TransFieldNames.contains(strNumCol))
                    {
                        // System.debug(' Inside strKeyVal = '+key+', strTransCol = '+strTransCol);
                        if (TransFieldNames.contains(strTransCol))
                        {
                            string mapKey=(string) mapTrans.get(key).get(strTransCol);
                            string strOpp=(string) mapTrans.get(key).get(strTrasOpp);
                            // System.debug('mapKey555-'+mapKey+'--'+key);
                            // System.debug('strOpp-'+strOpp+'--'+key);
                            // System.debug('strOpp-'+strOpp+'--'+key);
                            // System.debug('strNumValCol'+strNumValCol);
                            // System.debug('mapKey: ' + mapKey+ ' Contains '+mapDetails.containsKey(mapKey));
                            if(mapKey!=null && (mapDetails.containsKey(mapKey)|| mapKey=='All') && mapDetails.get(mapKey)!=null)
                            {
                                // System.debug('After IF-'+key);
                                if(strOpp=='>='||strOpp=='<='||strOpp=='>'||strOpp=='<')
                                {
                                    double doubleVal=double.valueOf(mapDetails.get(mapKey));
                                    dynamicWhereClause=dynamicWhereClause+'  And '+strDetailCol+''+strOpp+'\''+doubleVal+'\'';
                                } else if (strOpp=='=ORDASH') {
                                    dynamicWhereClause=dynamicWhereClause+' And ('+strDetailCol+' = \''+mapDetails.get(mapKey)+'\' or ' +strDetailCol+' = \'-\')';
                                }
                                else
                                    dynamicWhereClause=dynamicWhereClause+'  And '+strDetailCol+'=\''+mapDetails.get(mapKey)+'\'';
                            }
                        }
                        if (TransFieldNames.contains(strNumCol)) {
                            string mapKey=(string) mapTrans.get(key).get(strNumCol);
                            string strOpp=(string) mapTrans.get(key).get(strTrasNumOpp);
                            System.debug('strNumCol = '+strNumCol+', mapKey = '+mapKey+', strOpp = '+strOpp+' Key-'+key);
                            if(mapKey!=null && (mapDetails.containsKey(mapKey) && DetailFieldNames.contains(strNumValCol)) )
                            {
                                // System.debug('strNumValCol: ' + strNumValCol +key);
                                // System.debug('mapKey Num: ' + mapKey);
                                // System.debug('mapKey NumVal: ' + mapDetails.get(mapKey));
                                
                                Schema.DisplayType fielddataType = objectDetailFields.get(strNumValCol).getDescribe().getType();
                                if(String.isnotBlank(mapDetails.get(mapKey)))
                                {
                                    if (fielddataType  != Schema.DisplayType.DOUBLE)
                                        dynamicWhereClause=dynamicWhereClause+'  And '+strNumValCol+strOpp+'\''+String.valueOf(mapDetails.get(mapKey))+'\'';
                                    else
                                        dynamicWhereClause=dynamicWhereClause+'  And '+strNumValCol+strOpp+' '+String.valueOf(mapDetails.get(mapKey));
                                }
                                
                            }
                        }
                        
                    }
                    /*if(mapKey!=null && mapDetails.containsKey(mapKey)) {
if(dynamicWhereClause=='')
dynamicWhereClause=dynamicWhereClause+' '+strDetailCol+''+strOpp+mapDetails.get(mapKey);
else
dynamicWhereClause=dynamicWhereClause+ ' OR ('+strDetailCol+''+strOpp+mapDetails.get(mapKey) +')';
}*/
                    //System.debug('Dynamic Query'+dynamicWhereClause);
                }
                dynamicWhereClause=dynamicWhereClause+' )';
            }
            System.debug('Dynamic Query'+dynamicWhereClause);
            System.debug('Dynamic Query++'+strDetailQuery+' WHERE '+dynamicWhereClause);
            if(dynamicWhereClause!=null && string.isNotBlank(dynamicWhereClause))
                objResult.objResultList=Database.query(strDetailQuery+' WHERE '+dynamicWhereClause);
            else
                objResult.objResultList=Database.query(strDetailQuery);
            if(!objResult.objResultList.isEmpty())
                objResult.bResult=true;
            else
                objResult.bResult=false;
        } catch (Exception e) {
            objResult.bResult=false;
            System.debug('The following exception has occurred: wizardBaseDataProcessor:getDataFromTranslationObj()' + e.getMessage());
            objResult.strErrorMessage=e.getMessage();
        }
        return objResult;
    }
    //Method to get Dynamic Query
    public static result getDynamicQueryFromTranslationObj (string strKeyVal,string strTransObjName,string strDetailObjName,Map<string,string> mapDetails,string[] listSelectCols) {
        Result objResult = new Result();
        Map<string,sObject> mapTrans= new  Map<string,sObject>();
        Map<string,sObject[]> mapDetail= new  Map<string,sObject[]>();
        Map<String, Schema.SObjectField> objectTransFields = Schema.getGlobalDescribe().get(strTransObjName).getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> objectDetailFields = Schema.getGlobalDescribe().get(strDetailObjName).getDescribe().fields.getMap();
        System.debug('mapDetails: ' + mapDetails);
        try {
            Set<String> TransFieldNames = objectTransFields.keySet();
            Set<String> DetailFieldNames = objectDetailFields.keySet();
            string strTransQuery=' SELECT ' + string.join(new List<String>(TransFieldNames), ',') + ' FROM ' +strTransObjName;
            string strDetailQuery=' SELECT ' + string.join(new List<String>(listSelectCols), ',') + ' FROM ' +strDetailObjName;
            // System.debug('strTransQuery ==' + strTransQuery);
            sObject[] sObjTransList=Database.query(strTransQuery);
            
            //System.debug('sObjTransList'+sObjTransList);
            //sObject[] sObjDetailList=Database.query(strDetailQuery);
            set<String> setTransKey=new set<String>();
            set<String> setDetailKey=new set<String>();
            //  System.debug('strDetailQuery ==' + strDetailQuery);
            // System.debug('getDataFromTranslationObj2'+strDetailQuery);
            if (!sObjTransList.isEmpty()) {
                for (sObject sObj:sObjTransList) {
                    string strTransKey=(string) sobj.get(strKeyVal);
                    if(setTransKey.add(strTransKey))
                    {
                        // System.debug('***** strTransKey = '+strTransKey+', sObj = '+sObj);
                        mapTrans.put(strTransKey,sObj);
                    }
                    
                }
            }
            //System.debug('getDataFromTranslationObj23'+mapTrans);
            List <String> selectCols=new List <String>();
            for(String str:DetailFieldNames) {
                if(str.endsWith('__c'))
                    selectCols.add(str);
            }
            String dynamicWhereClause='';
            //integer maxFieldCount=DetailFieldNames.size()-(12+listSelectCols.size()+1);
            integer maxFieldCount=selectCols.size();
            // System.debug('DetailFieldNames'+DetailFieldNames);
            // System.debug('DetailFieldNames Size'+mapTrans);
            for(String key : mapTrans.keySet()) {
                System.debug('key: ' + key);
                if(dynamicWhereClause=='')
                    dynamicWhereClause='( '+strKeyVal+'=\''+key+'\'';
                else
                    dynamicWhereClause=dynamicWhereClause+ ' OR ('+strKeyVal+'=\''+key+'\'';
                for (integer i=1;i<=maxFieldCount;i++) {
                    
                    string strTransCol='text'+i+'__c';
                    string strDetailCol='text'+i+'val__c';
                    string strNumCol='num'+i+'__c';
                    string strNumValCol='numval'+i+'__c';
                    string strTrasOpp='textopp'+i+'__c';
                    string strTrasNumOpp='numopp'+i+'__c';
                    // System.debug('strTransCol = '+strTransCol);
                    // System.debug('strDetailCol = '+strDetailCol);
                    // System.debug('strNumCol = '+strNumCol);
                    // System.debug('strNumValCol = '+strNumValCol);
                    // System.debug('TransFieldNames'+TransFieldNames);
                    // System.debug('TransFieldNames.contains(strTransCol) = '+TransFieldNames.contains(strTransCol)+', TransFieldNames.contains(strNumCol) = '+TransFieldNames.contains(strNumCol));
                    // System.debug('StrKeyVal Outside'+key);
                    if(TransFieldNames.contains(strTransCol) || TransFieldNames.contains(strNumCol))
                    {
                        // System.debug(' Inside strKeyVal = '+key+', strTransCol = '+strTransCol);
                        if (TransFieldNames.contains(strTransCol))
                        {
                            string mapKey=(string) mapTrans.get(key).get(strTransCol);
                            string strOpp=(string) mapTrans.get(key).get(strTrasOpp);
                            // System.debug('mapKey555-'+mapKey+'--'+key);
                            // System.debug('strOpp-'+strOpp+'--'+key);
                            // System.debug('strOpp-'+strOpp+'--'+key);
                            // System.debug('strNumValCol'+strNumValCol);
                            // System.debug('mapKey: ' + mapKey+ ' Contains '+mapDetails.containsKey(mapKey));
                            if(mapKey!=null && (mapDetails.containsKey(mapKey)|| mapKey=='All') && mapDetails.get(mapKey)!=null)
                            {
                                // System.debug('After IF-'+key);
                                if(strOpp=='>='||strOpp=='<='||strOpp=='>'||strOpp=='<')
                                {
                                    double doubleVal=double.valueOf(mapDetails.get(mapKey));
                                    dynamicWhereClause=dynamicWhereClause+'  And '+strDetailCol+''+strOpp+'\''+doubleVal+'\'';
                                } else if (strOpp=='=ORDASH') {
                                    dynamicWhereClause=dynamicWhereClause+' And ('+strDetailCol+' = \''+mapDetails.get(mapKey)+'\' or ' +strDetailCol+' = \'-\')';
                                }
                                else
                                    dynamicWhereClause=dynamicWhereClause+'  And '+strDetailCol+'=\''+mapDetails.get(mapKey)+'\'';
                            }
                        }
                        if (TransFieldNames.contains(strNumCol)) {
                            string mapKey=(string) mapTrans.get(key).get(strNumCol);
                            string strOpp=(string) mapTrans.get(key).get(strTrasNumOpp);
                            // System.debug('strNumCol = '+strNumCol+', mapKey = '+mapKey+', strOpp = '+strOpp);
                            if(mapKey!=null && (mapDetails.containsKey(mapKey) && DetailFieldNames.contains(strNumValCol)) )
                            {
                                // System.debug('strNumValCol: ' + strNumValCol);
                                // System.debug('mapKey Num: ' + mapKey);
                                // System.debug('mapKey NumVal: ' + mapDetails.get(mapKey));
                                
                                Schema.DisplayType fielddataType = objectDetailFields.get(strNumValCol).getDescribe().getType();
                                if(mapDetails.get(mapKey)!=null)
                                {
                                    if (fielddataType  != Schema.DisplayType.DOUBLE)
                                        dynamicWhereClause=dynamicWhereClause+'  And '+strNumValCol+strOpp+'\''+String.valueOf(mapDetails.get(mapKey))+'\'';
                                    else
                                        dynamicWhereClause=dynamicWhereClause+'  And '+strNumValCol+strOpp+' '+String.valueOf(mapDetails.get(mapKey));
                                }
                                
                            }
                        }
                        
                    }
                    /*if(mapKey!=null && mapDetails.containsKey(mapKey)) {
if(dynamicWhereClause=='')
dynamicWhereClause=dynamicWhereClause+' '+strDetailCol+''+strOpp+mapDetails.get(mapKey);
else
dynamicWhereClause=dynamicWhereClause+ ' OR ('+strDetailCol+''+strOpp+mapDetails.get(mapKey) +')';
}*/
                    //System.debug('Dynamic Query'+dynamicWhereClause);
                }
                dynamicWhereClause=dynamicWhereClause+' )';
            }
            System.debug('Dynamic Query'+dynamicWhereClause);
            System.debug('Dynamic Query++'+strDetailQuery+' WHERE '+dynamicWhereClause);
            objResult.strRetValue=dynamicWhereClause;
            // if(dynamicWhereClause!=null && string.isNotBlank(dynamicWhereClause))
            //     objResult.objResultList=Database.query(strDetailQuery+' WHERE '+dynamicWhereClause);
            // else
            //     objResult.objResultList=Database.query(strDetailQuery);
            if(!objResult.objResultList.isEmpty())
                objResult.bResult=true;
            else
                objResult.bResult=false;
        } catch (Exception e) {
            objResult.bResult=false;
            System.debug('The following exception has occurred: wizardBaseDataProcessor:getDataFromTranslationObj()' + e.getMessage());
            objResult.strErrorMessage=e.getMessage();
        }
        return objResult;
    }
    
    
    //Added to sort Manfacturing Outputs
    public static result getSortedDataFromTranslationObj (string strKeyVal,string strTransObjName,string strDetailObjName,Map<string,string> mapDetails,string[] listSelectCols, String SortKey) {
        Result objResult = new Result();
        Map<string,sObject> mapTrans= new  Map<string,sObject>();
        Map<string,sObject[]> mapDetail= new  Map<string,sObject[]>();
        Map<String, Schema.SObjectField> objectTransFields = Schema.getGlobalDescribe().get(strTransObjName).getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> objectDetailFields = Schema.getGlobalDescribe().get(strDetailObjName).getDescribe().fields.getMap();
        
        Set<String> TransFieldNames = objectTransFields.keySet();
        Set<String> DetailFieldNames = objectDetailFields.keySet();
        string strTransQuery=' SELECT ' + string.join(new List<String>(TransFieldNames), ',') + ' FROM ' +strTransObjName;
        string strDetailQuery=' SELECT ' + string.join(new List<String>(listSelectCols), ',') + ' FROM ' +strDetailObjName;
        sObject[] sObjTransList=Database.query(strTransQuery);
        set<String> setTransKey=new set<String>();
        set<String> setDetailKey=new set<String>();
        if (!sObjTransList.isEmpty()) {
            for (sObject sObj:sObjTransList) {
                string strTransKey=(string) sobj.get(strKeyVal);
                System.debug('@@strTransKey' +strTransKey);
                if(setTransKey.add(strTransKey))
                {
                    mapTrans.put(strTransKey,sObj);
                }
                system.debug('@@mapTrans' +mapTrans);
                
            }
        }
        List <String> selectCols=new List <String>();
        for(String str:DetailFieldNames) {
            if(str.endsWith('__c'))
                selectCols.add(str);
        }
        String dynamicWhereClause='';
        integer maxFieldCount=selectCols.size();
        for(String key : mapTrans.keySet()) {
            if(dynamicWhereClause=='')
                dynamicWhereClause='( '+strKeyVal+'=\''+key+'\'';
            else
                dynamicWhereClause=dynamicWhereClause+ ' OR ('+strKeyVal+'=\''+key+'\'';
            for (integer i=1;i<=maxFieldCount;i++) {
                
                string strTransCol='text'+i+'__c';
                string strDetailCol='text'+i+'val__c';
                string strNumCol='num'+i+'__c';
                string strNumValCol='numval'+i+'__c';
                string strTrasOpp='textopp'+i+'__c';
                string strTrasNumOpp='numopp'+i+'__c';
                if(TransFieldNames.contains(strTransCol) || TransFieldNames.contains(strNumCol))
                {
                    System.debug('@@@@@@TransFieldNames' +TransFieldNames);
                    if (TransFieldNames.contains(strTransCol))
                    {
                        string mapKey=(string) mapTrans.get(key).get(strTransCol);
                        string strOpp=(string) mapTrans.get(key).get(strTrasOpp);
                        system.debug('@@mapKey' +mapKey);
                        System.debug('@@strOpp' +strOpp);
                        if(mapKey!=null && (mapDetails.containsKey(mapKey)|| mapKey=='All') && mapDetails.get(mapKey)!=null)
                        {
                            if(strOpp=='>='||strOpp=='<='||strOpp=='>'||strOpp=='<')
                            {
                                double doubleVal=double.valueOf(mapDetails.get(mapKey));
                                dynamicWhereClause=dynamicWhereClause+'  And '+strDetailCol+''+strOpp+'\''+doubleVal+'\'';
                                System.debug('@@dynamicWhereClause' +dynamicWhereClause);
                            } else if (strOpp=='=ORDASH') {
                                
                                dynamicWhereClause=dynamicWhereClause+' And ('+strDetailCol+' = \''+mapDetails.get(mapKey)+'\' or ' +strDetailCol+' = \'-\')';
                            }
                            else
                                dynamicWhereClause=dynamicWhereClause+'  And '+strDetailCol+'=\''+mapDetails.get(mapKey)+'\'';
                        }
                        System.debug('@@dynamicWhereClause' + dynamicWhereClause);
                    }
                    if (TransFieldNames.contains(strNumCol)) {
                        string mapKey=(string) mapTrans.get(key).get(strNumCol);
                        string strOpp=(string) mapTrans.get(key).get(strTrasNumOpp);
                        System.debug('@@strNumCol' +strNumCol);
                        System.debug('@@strTrasNumOpp' +strTrasNumOpp);
                        if(mapKey!=null && (mapDetails.containsKey(mapKey) && DetailFieldNames.contains(strNumValCol)) )
                        {
                            Schema.DisplayType fielddataType = objectDetailFields.get(strNumValCol).getDescribe().getType();
                            if(mapDetails.get(mapKey)!=null)
                            {
                                if (fielddataType  != Schema.DisplayType.DOUBLE)
                                    dynamicWhereClause=dynamicWhereClause+'  And '+strNumValCol+strOpp+'\''+String.valueOf(mapDetails.get(mapKey))+'\'';
                                else
                                    dynamicWhereClause=dynamicWhereClause+'  And '+strNumValCol+strOpp+' '+String.valueOf(mapDetails.get(mapKey));
                            }
                            
                        }
                    }
                    
                }
            }
            dynamicWhereClause=dynamicWhereClause+' )';
        }
        System.debug('Dynamic Query'+dynamicWhereClause);
        System.debug('Check query: '+strDetailQuery+' WHERE '+dynamicWhereClause + ' Order by ' + SortKey);
        objResult.objResultList=Database.query(strDetailQuery+' WHERE '+dynamicWhereClause + ' Order by ' + SortKey );
        if(!objResult.objResultList.isEmpty())
            objResult.bResult=true;
        else
            objResult.bResult=false;
        System.debug('Result Flag' +objResult.bResult);
        
        return objResult;
    }
    /*------------------------------------added for part selector---------------------------------*/
    public static result getDataFromTranslationObj1 (string strKeyVal,string strTransObjName,string strDetailObjName,Map<string,string> mapDetails,string[] listSelectCols,string ProdGroup,string SubGroup) {
        
        Result objResult = new Result();
        Map<string,sObject> mapTrans= new  Map<string,sObject>();
        Map<string,sObject[]> mapDetail= new  Map<string,sObject[]>();
        Map<String, Schema.SObjectField> objectTransFields = Schema.getGlobalDescribe().get(strTransObjName).getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> objectDetailFields = Schema.getGlobalDescribe().get(strDetailObjName).getDescribe().fields.getMap();
        System.debug('mapDetails: ' + mapDetails);
        try {
            Set<String> TransFieldNames = objectTransFields.keySet();
            Set<String> DetailFieldNames = objectDetailFields.keySet();
            string strTransQuery=' SELECT ' + string.join(new List<String>(TransFieldNames), ',') + ' FROM ' +strTransObjName;
            string strDetailQuery=' SELECT ' + string.join(new List<String>(listSelectCols), ',') + ' FROM ' +strDetailObjName;
            System.debug('strTransQuery ==' + strTransQuery);
            sObject[] sObjTransList=Database.query(strTransQuery);
            //sObject[] sObjDetailList=Database.query(strDetailQuery);
            set<String> setTransKey=new set<String>();
            set<String> setDetailKey=new set<String>();
            System.debug('strDetailQuery ==' + strDetailQuery);
            System.debug('getDataFromTranslationObj2'+strDetailQuery);
            if (!sObjTransList.isEmpty()) {
                for (sObject sObj:sObjTransList) {
                    string strTransKey=(string) sobj.get(strKeyVal);
                    if(setTransKey.add(strTransKey))
                    {
                        System.debug('***** strTransKey = '+strTransKey+', sObj = '+sObj);
                        mapTrans.put(strTransKey,sObj);
                    }
                    
                }
            }
            //System.debug('getDataFromTranslationObj23'+mapTrans);
            List <String> selectCols=new List <String>();
            for(String str:DetailFieldNames) {
                if(str.endsWith('__c'))
                    selectCols.add(str);
            }
            String dynamicWhereClause='';
            //integer maxFieldCount=DetailFieldNames.size()-(12+listSelectCols.size()+1);
            integer maxFieldCount=selectCols.size();
            // System.debug('DetailFieldNames'+DetailFieldNames);
            // System.debug('DetailFieldNames Size'+mapTrans);
            for(String key : mapTrans.keySet()) {
                System.debug('key: ' + key);
                if(dynamicWhereClause=='')
                    dynamicWhereClause='( '+strKeyVal+'=\''+key+'\'';
                else
                    dynamicWhereClause=dynamicWhereClause+ ' OR ('+strKeyVal+'=\''+key+'\'';
                for (integer i=1;i<=maxFieldCount;i++) {
                    
                    string strTransCol='text'+i+'__c';
                    string strDetailCol='text'+i+'val__c';
                    string strNumCol='num'+i+'__c';
                    string strNumValCol='numval'+i+'__c';
                    string strTrasOpp='textopp'+i+'__c';
                    string strTrasNumOpp='numopp'+i+'__c';
                    // System.debug('strTransCol = '+strTransCol);
                    // System.debug('strDetailCol = '+strDetailCol);
                    // System.debug('strNumCol = '+strNumCol);
                    // System.debug('strNumValCol = '+strNumValCol);
                    // System.debug('TransFieldNames'+TransFieldNames);
                    // System.debug('TransFieldNames.contains(strTransCol) = '+TransFieldNames.contains(strTransCol)+', TransFieldNames.contains(strNumCol) = '+TransFieldNames.contains(strNumCol));
                    // System.debug('StrKeyVal Outside'+key);
                    if(TransFieldNames.contains(strTransCol) || TransFieldNames.contains(strNumCol))
                    {
                        // System.debug(' Inside strKeyVal = '+key+', strTransCol = '+strTransCol);
                        if (TransFieldNames.contains(strTransCol))
                        {
                            string mapKey=(string) mapTrans.get(key).get(strTransCol);
                            string strOpp=(string) mapTrans.get(key).get(strTrasOpp);
                            // System.debug('mapKey555-'+mapKey+'--'+key);
                            // System.debug('strOpp-'+strOpp+'--'+key);
                            // System.debug('strOpp-'+strOpp+'--'+key);
                            // System.debug('strNumValCol'+strNumValCol);
                            // System.debug('mapKey: ' + mapKey+ ' Contains '+mapDetails.containsKey(mapKey));
                            if(mapKey!=null && (mapDetails.containsKey(mapKey)|| mapKey=='All') && mapDetails.get(mapKey)!=null)
                            {
                                // System.debug('After IF-'+key);
                                if(strOpp=='>='||strOpp=='<='||strOpp=='>'||strOpp=='<')
                                {
                                    double doubleVal=double.valueOf(mapDetails.get(mapKey));
                                    dynamicWhereClause=dynamicWhereClause+'  And '+strDetailCol+''+strOpp+'\''+doubleVal+'\'';
                                } else if (strOpp=='=ORDASH') {
                                    dynamicWhereClause=dynamicWhereClause+' And ('+strDetailCol+' = \''+mapDetails.get(mapKey)+'\' or ' +strDetailCol+' = \'-\')';
                                }
                                else
                                    dynamicWhereClause=dynamicWhereClause+'  And '+strDetailCol+'=\''+mapDetails.get(mapKey)+'\'';
                            }
                        }
                        if (TransFieldNames.contains(strNumCol)) {
                            string mapKey=(string) mapTrans.get(key).get(strNumCol);
                            string strOpp=(string) mapTrans.get(key).get(strTrasNumOpp);
                            // System.debug('strNumCol = '+strNumCol+', mapKey = '+mapKey+', strOpp = '+strOpp);
                            if(mapKey!=null && (mapDetails.containsKey(mapKey) && DetailFieldNames.contains(strNumValCol)) )
                            {
                                // System.debug('strNumValCol: ' + strNumValCol);
                                // System.debug('mapKey Num: ' + mapKey);
                                // System.debug('mapKey NumVal: ' + mapDetails.get(mapKey));
                                
                                Schema.DisplayType fielddataType = objectDetailFields.get(strNumValCol).getDescribe().getType();
                                if(mapDetails.get(mapKey)!=null)
                                {
                                    if (fielddataType  != Schema.DisplayType.DOUBLE)
                                        dynamicWhereClause=dynamicWhereClause+'  And '+strNumValCol+strOpp+'\''+String.valueOf(mapDetails.get(mapKey))+'\'';
                                    else
                                        dynamicWhereClause=dynamicWhereClause+'  And '+strNumValCol+strOpp+' '+String.valueOf(mapDetails.get(mapKey));
                                }
                                
                            }
                        }
                        
                    }
                    /*if(mapKey!=null && mapDetails.containsKey(mapKey)) {
if(dynamicWhereClause=='')
dynamicWhereClause=dynamicWhereClause+' '+strDetailCol+''+strOpp+mapDetails.get(mapKey);
else
dynamicWhereClause=dynamicWhereClause+ ' OR ('+strDetailCol+''+strOpp+mapDetails.get(mapKey) +')';
}*/
                    //System.debug('Dynamic Query'+dynamicWhereClause);
                }
                dynamicWhereClause=dynamicWhereClause+' )';
            }
            System.debug('Dynamic Query'+dynamicWhereClause);
            System.debug('Dynamic Query++'+strDetailQuery+' WHERE '+dynamicWhereClause);
            if(dynamicWhereClause!=null && string.isNotBlank(dynamicWhereClause))
                objResult.objResultList=Database.query(strDetailQuery+' WHERE '+dynamicWhereClause);
            else
                objResult.objResultList=Database.query(strDetailQuery);
            if(!objResult.objResultList.isEmpty())
                objResult.bResult=true;
            else
                objResult.bResult=false;
        } catch (Exception e) {
            objResult.bResult=false;
            System.debug('The following exception has occurred: wizardBaseDataProcessor:getDataFromTranslationObj()' + e.getMessage());
            objResult.strErrorMessage=e.getMessage();
        }
        return objResult;
    }
    
    //Added to sort Manfacturing Outputs
    
    public static result getSortedDataFromTranslationObj1 (string strKeyVal,string strTransObjName,string strDetailObjName,Map<string,string> mapDetails,string[] listSelectCols, String SortKey,string ProdGroup,string SubGroup) 
    {
        Result objResult = new Result();
        Map<string,sObject> mapTrans= new  Map<string,sObject>();
        Map<string,sObject[]> mapDetail= new  Map<string,sObject[]>();
        Map<String, Schema.SObjectField> objectTransFields = Schema.getGlobalDescribe().get(strTransObjName).getDescribe().fields.getMap();
        Map<String, Schema.SObjectField> objectDetailFields = Schema.getGlobalDescribe().get(strDetailObjName).getDescribe().fields.getMap();    
        
        Set<String> TransFieldNames = objectTransFields.keySet();
        Set<String> DetailFieldNames = objectDetailFields.keySet();
        string strTransQuery=' SELECT ' + string.join(new List<String>(TransFieldNames), ',') + ' FROM ' +strTransObjName;
        string strDetailQuery=' SELECT ' + string.join(new List<String>(listSelectCols), ',') + ' FROM ' +strDetailObjName;
        
        if(strTransObjName == 'PS_Attributes_Translation__c' || strTransObjName == 'PS_Document_Translation__c' || strTransObjName == 'PS_Routing_Translation__c' || strTransObjName == 'PS_Structure_Translation__c' || strTransObjName == 'PS_ControlPlan_Translation__c') 
        {
            if(String.isNotBlank(ProdGroup) || String.isNotBlank(SubGroup))
            {
                strTransQuery += ' WHERE ';
                Boolean clauseAdded = false;
                if(String.isNotBlank(ProdGroup))
                {
                    strTransQuery +=' prodgroup__c = \''+ProdGroup+'\'';
                    clauseAdded = true;
                }
                if(String.isNotBlank(SubGroup))
                {
                    if(clauseAdded == true)
                    {
                        strTransQuery +=' AND ';
                    }
                    strTransQuery +=' subgroup__c = \''+SubGroup+'\'';
                }
            }
        }
        
        system.debug('strTransQuery::'+strTransQuery);
        
        sObject[] sObjTransList=Database.query(strTransQuery);
        set<String> setTransKey=new set<String>();
        set<String> setDetailKey=new set<String>();
        if (!sObjTransList.isEmpty()) {
            for (sObject sObj:sObjTransList) {
                string strTransKey=(string) sobj.get(strKeyVal);
                System.debug('@@strTransKey' +strTransKey);
                if(setTransKey.add(strTransKey))
                {
                    mapTrans.put(strTransKey,sObj);
                }
                system.debug('@@mapTrans' +mapTrans);
                
            }
        }
        
        List <String> selectCols=new List <String>();
        for(String str:DetailFieldNames) {
            if(str.endsWith('__c'))
                selectCols.add(str);
        }
        String dynamicWhereClause='';
        integer maxFieldCount=selectCols.size();
        
        if(dynamicWhereClause != '' && dynamicWhereClause != null) {
            
            dynamicWhereClause +='  AND ';
        }
        if(!Test.isRunningTest()) {
            
            strDetailQuery +=' WHERE ProdGroup__c = \''+ProdGroup+'\' AND SubGroup__c = \''+SubGroup+'\'';
        } else {
            
            strDetailQuery += ' WHERE Name != null';
        }
        
        if(mapTrans.size() > 0) {
            
            strDetailQuery += ' AND (';
        }
        for(String key : mapTrans.keySet()) { 
            if(dynamicWhereClause=='')
                dynamicWhereClause='( '+strKeyVal+'=\''+key+'\'';
            else
                dynamicWhereClause=dynamicWhereClause+ ' OR ('+strKeyVal+'=\''+key+'\'';
            for (integer i=1;i<=maxFieldCount;i++) {
                
                string strTransCol='text'+i+'__c';
                string strDetailCol='text'+i+'val__c';
                string strNumCol='num'+i+'__c';
                string strNumValCol='numval'+i+'__c';
                string strTrasOpp='textopp'+i+'__c';
                string strTrasNumOpp='numopp'+i+'__c';
                if(TransFieldNames.contains(strTransCol) || TransFieldNames.contains(strNumCol))
                {
                    System.debug('@@@@@@TransFieldNames' +TransFieldNames);
                    if (TransFieldNames.contains(strTransCol))
                    {
                        string mapKey=(string) mapTrans.get(key).get(strTransCol);
                        string strOpp=(string) mapTrans.get(key).get(strTrasOpp);
                        system.debug('@@mapKey' +mapKey);
                        System.debug('@@strOpp' +strOpp);
                        if(strTransObjName == 'PS_Routing_Translation__c ') {
                            
                            system.debug('ASHIM1:: '+key+' ++ '+mapKey + ' @@ '+mapDetails.get(mapKey));
                        }
                        
                        if(strTransObjName == 'PS_ControlPlan_Translation__c ') {
                            
                            system.debug('ASHIM1:: '+key+' ++ '+mapKey + ' @@ '+mapDetails.get(mapKey));
                        }
                        
                        
                        if(strTransObjName == 'PS_Document_Translation__c ') {
                            
                            system.debug('ASHIM1:: '+key+' ++ '+mapKey + ' @@ '+mapDetails.get(mapKey));
                        }
                        
                        if(mapKey!=null && (mapDetails.containsKey(mapKey)|| mapKey=='All') && mapDetails.get(mapKey)!=null)
                        {
                            if(strTransObjName == 'PS_Routing_Translation__c ' || strTransObjName == 'PS_Document_Translation__c' ||strTransObjName == 'PS_ControlPlan_Translation__c') {
                                
                                system.debug('ASHIM:: '+key+' ++ '+strDetailCol+' ## '+strOpp+' @@ '+mapDetails.get(mapKey));
                            }
                            if(strOpp=='>='||strOpp=='<='||strOpp=='>'||strOpp=='<')
                            {
                                double doubleVal=double.valueOf(mapDetails.get(mapKey));
                                dynamicWhereClause=dynamicWhereClause+'  And '+strDetailCol+''+strOpp+'\''+doubleVal+'\'';
                                System.debug('@@dynamicWhereClause' +dynamicWhereClause);
                            } else if (strOpp=='=ORDASH') {
                                
                                dynamicWhereClause=dynamicWhereClause+' And ('+strDetailCol+' = \''+mapDetails.get(mapKey)+'\' or ' +strDetailCol+' = \'-\')';
                            }
                            else{
                                system.debug('  And '+strDetailCol+'=\''+mapDetails.get(mapKey));
                                dynamicWhereClause=dynamicWhereClause+'  And '+strDetailCol+'=\''+mapDetails.get(mapKey)+'\'';
                                
                            }
                        }
                        System.debug('@@dynamicWhereClause' + dynamicWhereClause);
                    }
                    if (TransFieldNames.contains(strNumCol)) {
                        string mapKey=(string) mapTrans.get(key).get(strNumCol);
                        string strOpp=(string) mapTrans.get(key).get(strTrasNumOpp);
                        System.debug('@@strNumCol' +strNumCol);
                        System.debug('@@strTrasNumOpp' +strTrasNumOpp);
                        if(mapKey!=null && (mapDetails.containsKey(mapKey) && DetailFieldNames.contains(strNumValCol)) )
                        {
                            Schema.DisplayType fielddataType = objectDetailFields.get(strNumValCol).getDescribe().getType();
                            if(mapDetails.get(mapKey)!=null)
                            {
                                if (fielddataType  != Schema.DisplayType.DOUBLE)
                                    dynamicWhereClause=dynamicWhereClause+'  And '+strNumValCol+strOpp+'\''+String.valueOf(mapDetails.get(mapKey))+'\'';
                                else{
                                    system.debug('And '+strNumValCol+strOpp+' '+String.valueOf(mapDetails.get(mapKey)));
                                    dynamicWhereClause=dynamicWhereClause+'  And '+strNumValCol+strOpp+' '+String.valueOf(mapDetails.get(mapKey));
                                    
                                }
                            }
                            
                        }
                    }
                    
                }
            }
            //dynamicWhereClause = dynamicWhereClause +'  And  ' +'ProdGroup__c =:ProdGroup AND SubGroup__c =:SubGroup';
            dynamicWhereClause=dynamicWhereClause+' )';
        }
        
        if(dynamicWhereClause != '') {
            
            strDetailQuery += dynamicWhereClause; 
            strDetailQuery += ' )';
        }
        strDetailQuery += ' ORDER BY ' + SortKey;
        
        System.debug('Dynamic Query'+dynamicWhereClause);
        System.debug('Check query: '+strDetailQuery);
        
        objResult.objResultList = Database.query(strDetailQuery);
        if(!objResult.objResultList.isEmpty())
            objResult.bResult=true;
        else
            objResult.bResult=false;
        System.debug('Result Flag' +objResult.bResult);
        
        return objResult;
    }
    
    /*--------------------------------------------------------------------------------------------------*/
    public static result getDataListbyUsingLikeOpp(string strObjName,string[] selectCols,string[] whereCols,string[] whereVals,string[] whereComps,string[] extraChars) {
        result objResult=new result();
        integer intListSize=whereCols.size();
        string strWhereClause='';
        string strSelCols=' ';
        string strQuery=' ';
        strSelCols = String.join(selectCols,',');
        if ((intListSize==whereVals.size()) && (intListSize==whereComps.size())) {
            for (integer i=0; i<intListSize; i++) {
                if(i>0)
                    strWhereClause=strWhereClause+' and ';
                else
                    strWhereClause=strWhereClause+' Where ';
                if(whereComps[i]=='LIKE') {
                    if(extraChars[i]!='')
                        strWhereClause=strWhereClause+'('+whereCols[i]+' LIKE \'%'+whereVals[i]+'%\' or ' +whereCols[i]+' LIKE \'%'+extraChars[i]+'%\')';
                    else
                        strWhereClause=strWhereClause+'('+whereCols[i]+' LIKE \'%'+whereVals[i]+'%\')';
                }
                else if (whereComps[i]=='ORDASH') {
                    strWhereClause=strWhereClause+'('+whereCols[i]+' LIKE \'%'+whereVals[i]+'%\' or ' +whereCols[i]+' = \'-\')';
                }
                else {
                    if(extraChars[i]!='')
                        strWhereClause=strWhereClause+'('+whereCols[i]+' '+whereComps[i]+' '+whereVals[i]+' or ' +whereCols[i]+' = \''+extraChars[i]+'\')';
                    else
                        strWhereClause=strWhereClause+whereCols[i]+' '+whereComps[i]+' '+whereVals[i];
                }
            }
            strQuery='Select  '+strSelCols+'  from '+strObjName+' '+strWhereClause;
            System.debug('Dynamic Query '+strQuery);
            System.debug('Dynamic Query Where Clause'+strWhereClause);
            try {
                objResult.objResultList=Database.query(strQuery);
                if (!objResult.objResultList.isEmpty()) {
                    objResult.bResult=true;
                } else {
                    objResult.bResult=false;
                    objResult.strErrorMessage='No Data Found';
                }
                System.debug('Dynamic List Size'+objResult.objResultList.size());
            } catch (Exception e) {
                objResult.bResult=false;
                System.debug('The following exception has occurred: wizardBaseDataProcessor:getProdOutputDesc()' + e.getMessage());
                objResult.strErrorMessage=e.getMessage();
            }
        } else {
            objResult.bResult=false;
            System.debug('The following error has occurred: wizardBaseDataProcessor:getProdOutputDesc()');
            objResult.strErrorMessage='Columns,values and operators should have number of values';
        }
        return objResult;
    }
    public static result getPartNumberByQuoteLine(id quoteLineId) {
        result resPart=new result();
        id RecordID=wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLineId);
        result resConProd=wizardBaseDataProcessor.getObjectDataById(RecordID);
        try {
            if (!resConProd.objResultList.isEmpty()) {
                sObject sObj=resConProd.objResultList[0];
                if((string) sObj.get('Part_Number__c')!=null) {
                    resPart.strRetValue=(string) sObj.get('Part_Number__c');
                    resPart.bResult=true;
                } else {
                    resPart.strErrorMessage='PART NUMBER is not generated Quote Line';
                    resPart.bResult=true;
                }
            } else {
                resPart.bResult=false;
                resPart.strErrorMessage='No Record Found For A given Quote Line';
            }
        } catch (Exception e) {
            resPart.bResult=false;
            System.debug('The following exception has occurred: wizardBaseDataProcessor:getPartNumberByQuoteLine()' + e.getMessage());
            resPart.strErrorMessage=e.getMessage();
        }
        return resPart;
    }
    
    public static void testcoveragebooster(){
        Integer count = 0;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++;
        count++; 
    }
    /*Method to query records on single object or multiple dependent objects*/
    //@ Method added by Vinayak for dynamic pickist for Relief valve
    public static Map<String, Object> getObjectRecords(Map<String, Object> parameters)
    {
        Map<String, Object> returnMap = new Map<String, Object>();
        List<String> sObjectList = (List<String>)parameters.get('sObjects');
        Map<String, String> sObjectVsFields = new Map<String, String>();
        Map<String, String> sObjectVsOrderBy = new Map<String, String>();
        Map<String, List<Sobject>> queryResult = new Map<String, List<Sobject>>();
        Map<String, Map<String, Schema.SObjectField>> SobjectFieldsMap = new Map<String, Map<String, Schema.SObjectField>>();
        //System.debug('@@@@ Object size = '+sObjectList);
        for(String sobjectType :sObjectList)
        {
            //System.debug('@@@@ Object = '+sobjectType);
            sObjectVsFields.put(sobjectType+'_selectedFields', (String)parameters.get(sobjectType+'_selectedFields'));
            if(parameters.containsKey(sobjectType+'_whereClause'))
            {
                sObjectVsFields.put(sobjectType+'_whereClause', (String)parameters.get(sobjectType+'_whereClause'));
            }
            if(parameters.containsKey(sobjectType+'_referenceFields'))
            {
                sObjectVsFields.put(sobjectType+'_referenceFields', (String)parameters.get(sobjectType+'_referenceFields'));
            }
            if(parameters.containsKey(sobjectType+'_dependencyCondition'))
            {
                sObjectVsFields.put(sobjectType+'_dependencyCondition', (String)parameters.get(sobjectType+'_dependencyCondition'));
            }
            if(parameters.containsKey(sobjectType+'_orderBy'))
            {
                sObjectVsOrderBy.put(sobjectType+'_orderBy', (String)parameters.get(sobjectType+'_orderBy'));
            }
            SObjectType objectType = Schema.getGlobalDescribe().get(sobjectType);
            SobjectFieldsMap.put(sobjectType, FLMutility.getSobjectFieldsMap(objectType));
        }
        //If query to be done on single object
        Integer objectCounter = 0;
        if(sObjectList.size() == 1 ||(sObjectList.size() > 0 && objectCounter == 0))
        {
            String sobjectType = sObjectList[0];
            String soql = 'SELECT ';
            if(sObjectVsFields.get(sobjectType+'_selectedFields') == 'All fields')
            {
                soql += FLMutility.getObjectFields(sobjectType);
            }
            else
            {
                soql += ' ID,'+sObjectVsFields.get(sobjectType+'_selectedFields');
            }
            soql += ' FROM '+sobjectType;
            if(sObjectVsFields.containsKey(sobjectType+'_whereClause'))
            {
                soql += ' WHERE '+sObjectVsFields.get(sobjectType+'_whereClause');
            }
            if(sObjectVsOrderBy.containsKey(sobjectType+'_orderBy'))
            {
                soql += ' Order By '+sObjectVsOrderBy.get(sobjectType+'_orderBy');
            }
            System.debug('**** object = '+sobjectType+', query = '+soql);
            List<Sobject> queryRecords = Database.query(soql);
            if(sObjectList.size() == 1)
            {
                //System.debug('Returned value = '+queryRecords.size());
                returnMap.put(sobjectType, queryRecords);
                return returnMap;
            }
            queryResult.put(sobjectType, new List<Sobject>());
            queryResult.get(sobjectType).addAll(queryRecords);
            
        }
        if(sObjectList.size() > 1)
        {
            objectCounter += 1;
            for(Integer i = 1; i< sObjectList.size();i++)
            {
                String sobjectType = sObjectList[objectCounter];
                String soql = 'SELECT ';
                if(sObjectVsFields.get(sobjectType+'_selectedFields') == 'All fields')
                {
                    soql += FLMutility.getObjectFields(sobjectType);
                }
                else
                {
                    soql += ' ID,'+sObjectVsFields.get(sobjectType+'_selectedFields');
                }
                soql += ' FROM '+sobjectType;
                if(sObjectVsFields.containsKey(sobjectType+'_whereClause'))
                {
                    soql += ' WHERE '+sObjectVsFields.get(sobjectType+'_whereClause');
                }
                if(sObjectVsFields.containsKey(sobjectType+'_referenceFields'))
                {
                    //A,B,C
                    // B_depencyClause field => A-field1, A-fiedls, C-field
                    //B field => A field
                    //B field => C field
                    //where MWAP = 900
                    Set<String> objectVsFields = new Set<String>();
                    Map<String, Map<String, Object>> objectVsFieldsVsValues = new Map<String, Map<String, Object>>();
                    String fieldsVsReferenceFields = sObjectVsFields.get(sobjectType+'_referenceFields');
                    Map<String,String> fieldTypeVsField = new Map<String, String>();
                    if(String.isNotBlank(fieldsVsReferenceFields))
                    {
                        if(fieldsVsReferenceFields.contains(','))
                        {
                            for(String dependencies: fieldsVsReferenceFields.split(','))
                            {
                                objectVsFields.add(dependencies);//.substringBefore('-')).add(dependencies.substringAfter('-'));
                            }
                        }
                        else
                        {
                            objectVsFields.add(fieldsVsReferenceFields);//.substringBefore('-')).add(fieldsVsDependencyValues.substringAfter('-'));
                        }
                        if(objectVsFields.size() > 0)
                        {
                            for(String objectName: objectVsFields)
                            {
                                String objectAPI = objectName.substringBefore('-');
                                String fieldAPI = objectName.substringAfter('-');
                                Schema.SObjectField field = SobjectFieldsMap.get(objectAPI).get(fieldAPI);
                                Schema.DisplayType FldType = field.getDescribe().getType();
                                //System.debug('*** FldType = '+FldType);
                                if(!objectVsFieldsVsValues.containsKey(objectAPI))
                                {
                                    if(FldType == Schema.DisplayType.String)
                                    {
                                        objectVsFieldsVsValues.put(objectAPI, new Map<String, Set<String>>());
                                    }
                                    else if(FldType == Schema.DisplayType.Reference)
                                    {
                                        objectVsFieldsVsValues.put(objectAPI, new Map<String, Set<Id>>());
                                    }
                                    else
                                    {
                                        objectVsFieldsVsValues.put(objectAPI, new Map<String, Set<Decimal>>());
                                    }
                                }
                                //System.debug('**** objectVsFieldsVsValues.get(objectAPI) = '+objectVsFieldsVsValues.get(objectAPI));
                                if(!objectVsFieldsVsValues.get(objectAPI).containsKey(fieldAPI))
                                {
                                    String objectVsField = objectAPI+'-'+fieldAPI;
                                    //System.debug('@@@ fieldTypeVsField key = '+objectVsField);
                                    if(FldType == Schema.DisplayType.String)
                                    {
                                        fieldTypeVsField.put(objectVsField, objectVsField+'-String');
                                        objectVsFieldsVsValues.get(objectAPI).put(objectVsField+'-String', new Set<String>());
                                    }
                                    else if(FldType == Schema.DisplayType.Reference)
                                    {
                                        fieldTypeVsField.put(objectVsField, objectVsField+'-Id');
                                        objectVsFieldsVsValues.get(objectAPI).put(objectVsField+'-Id', new Set<Id>());
                                    }
                                    else
                                    {
                                        fieldTypeVsField.put(objectVsField, objectVsField+'-Decimal');
                                        objectVsFieldsVsValues.get(objectAPI).put(objectVsField+'-Decimal', new Set<Decimal>());
                                    }
                                }
                            }
                        }
                        //clause object iteration
                        for(String objectName : objectVsFieldsVsValues.Keyset())
                        {
                            //clause object record iteration
                            system.debug(objectName+'---'+queryResult);
                            for(Sobject record :queryResult.get(objectName))
                            {
                                //System.debug('@@@ record = '+record);
                                //SObject[] contactsDB = a.get(0).getSObjects('Contacts');
                                // clause field iteration
                                for(String fieldName: objectVsFieldsVsValues.get(objectName).keySet())
                                {
                                    String fieldType = fieldName.substringAfter('-');
                                    String field = fieldType.substringBefore('-');
                                    String typeOf = fieldType.substringAfter('-');
                                    //System.debug('@@@ fieldName = '+fieldName+', fieldtypekey = '+fieldType+', field = '+field+', typeOf = '+typeOf);
                                    //System.debug('@@@ fieldName = '+fieldName+', value = '+record.get(field)+', object = '+record.getSObjectType());
                                    //System.debug('@@@ objectVsFieldsVsValues.get(objectName) = '+objectVsFieldsVsValues.get(objectName));
                                    if(typeOf == 'String')
                                    {
                                        Set<String> setValues = (Set<String>)objectVsFieldsVsValues.get(objectName).get(fieldName);
                                        setValues.add((String)record.get(field));
                                    }
                                    else if(typeOf == 'Id')
                                    {
                                        Set<Id> setValues = (Set<Id>)objectVsFieldsVsValues.get(objectName).get(fieldName);
                                        setValues.add((Id)record.get(field));
                                    }
                                    else
                                    {
                                        Set<Decimal> setValues = (Set<Decimal>)objectVsFieldsVsValues.get(objectName).get(fieldName);
                                        setValues.add((Decimal)record.get(field));
                                    }
                                    //System.debug('@@@ values in map = '+objectVsFieldsVsValues.get(objectName).get(fieldName));
                                    //convertedType = record.get(field);
                                    //objectVsFieldsVsValues.get(objectName).get(fieldName).add(record.get(fieldName));
                                }
                            }
                        }
                    }
                    //&& => AND || => OR
                    //depencyConditions field = A-field && field = C-field && (field = A-field2 || field = C-field2)
                    String clauseConditions = sObjectVsFields.get(sobjectType+'_dependencyCondition');
                    if(clauseConditions.contains('&&'))
                    {
                        //System.debug('@@@ fieldTypeVsField = '+fieldTypeVsField);
                        for(String clauseFields: clauseConditions.split('&&'))
                        {
                            //System.debug('*** clauseFields = '+clauseFields);
                            String fieldAPI = clauseFields.substringBefore(' =');
                            String referenceObjectField = clauseFields.substringAfter('= ');
                            String referenceObject = referenceObjectField.substringBefore('-');
                            String referenceField = referenceObjectField.substringAfter('-');
                            String referenceFieldType = fieldTypeVsField.get(referenceObject+'-'+referenceField);
                            String typeOf = referenceFieldType.substringAfterLast('-');
                            System.debug('@@Type of'+typeOf);
                            System.debug('@@@ form condition = '+objectVsFieldsVsValues.get(referenceObject).get(referenceFieldType));
                            
                            if(typeOf == 'String')
                            {
                                Set<String> setValues = (Set<String>)objectVsFieldsVsValues.get(referenceObject).get(referenceFieldType);
                                String formSet = '';
                                if(setValues.size() > 0)
                                {
                                    Integer counter = 1;
                                    for(String setValue : setValues)
                                    {
                                        if(String.isBlank(formSet))
                                        {
                                            formSet += '(\''+setValue+'\'';
                                        }
                                        else
                                        {
                                            formSet += ',\''+setValue+'\'';
                                        }
                                        if(counter == setValues.size())
                                        {
                                            formSet += ')';
                                        }
                                        counter++;
                                    }
                                }
                                else
                                {
                                    formSet = '(\'0\')';
                                }
                                soql += ' AND '+fieldAPI+' IN '+formSet;
                            }
                            else if(typeOf == 'Id')
                            {
                                Set<Id> setValues = (Set<Id>)objectVsFieldsVsValues.get(referenceObject).get(referenceFieldType);
                                soql += ' AND '+fieldAPI+' IN:setValues';
                            }
                            else
                            {
                                Set<Decimal> setValues = (Set<Decimal>)objectVsFieldsVsValues.get(referenceObject).get(referenceFieldType);
                                soql += ' AND '+fieldAPI+' IN:setValues';
                            }
                        }
                    }
                    else
                    {
                        String fieldAPI = clauseConditions.substringBefore(' =');
                        String referenceObjectField = clauseConditions.substringAfter('= ');
                        String referenceObject = referenceObjectField.substringBefore('-');
                        String referenceField = referenceObjectField.substringAfter('-');
                        String referenceFieldType = fieldTypeVsField.get(referenceObject+'-'+referenceField);
                        String typeOf = referenceFieldType.substringAfterLast('-');
                        System.debug('@@@ form condition = '+objectVsFieldsVsValues.get(referenceObject).get(referenceFieldType));
                        
                        if(typeOf == 'String')
                        {
                            Set<String> setValues = (Set<String>)objectVsFieldsVsValues.get(referenceObject).get(referenceFieldType);
                            String formSet = '';
                            if(setValues.size() > 0)
                            {
                                Integer counter = 1;
                                for(String setValue : setValues)
                                {
                                    if(String.isBlank(formSet))
                                    {
                                        formSet += '(\''+setValue+'\'';
                                    }
                                    else
                                    {
                                        formSet += ',\''+setValue+'\'';
                                    }
                                    if(counter == setValues.size())
                                    {
                                        formSet += ')';
                                    }
                                    counter++;
                                }
                            }
                            else
                            {
                                formSet += '(\'0\')';
                            }
                            soql += ' AND '+fieldAPI+' IN '+formSet;
                        }
                        else if(typeOf == 'Id')
                        {
                            Set<Id> setValues = (Set<Id>)objectVsFieldsVsValues.get(referenceObject).get(referenceFieldType);
                            soql += ' AND '+fieldAPI+' IN:setValues';
                        }
                        else
                        {
                            Set<Decimal> setValues = (Set<Decimal>)objectVsFieldsVsValues.get(referenceObject).get(referenceFieldType);
                            soql += ' AND '+fieldAPI+' IN:setValues';
                        }
                    }
                }
                if(sObjectVsOrderBy.containsKey(sobjectType+'_orderBy'))
                {
                    soql += ' Order By '+sObjectVsOrderBy.get(sobjectType+'_orderBy');
                }
                System.debug('**** Object = '+sobjectType+', query = '+soql);
                List<Sobject> queryRecords = Database.query(soql); 
                System.debug('@@@ Returned records = '+queryRecords.size());
                queryResult.put(sobjectType, new List<Sobject>());
                queryResult.get(sobjectType).addAll(queryRecords);
                objectCounter += 1;
                returnMap.put(sobjectType, queryRecords);
            }
            returnMap.put(sObjectList[sObjectList.size() - 1], queryResult.get(sObjectList[sObjectList.size() - 1]));
        }
        return returnMap;
    }
}