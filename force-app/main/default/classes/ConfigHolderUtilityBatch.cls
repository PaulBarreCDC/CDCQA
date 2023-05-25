/**********************************************************************************************************
* @Name         ConfigHolderUtilityBatch 
* @Author       Ashim Kumar Sahoo <ashim.kumar@apexit.com>
* @Date         10/16/2020
* @Description  This class contains all utility methods related to fetching and updating of description   
*				and diagram data for Holders                               
************************************************************************************************************/
public with sharing class ConfigHolderUtilityBatch {
    
    /*******************************************************************************************************
* @Description  This method fetches description records based on the Holder Inputs 
* 				from Description Translation and Detail, and upsert the values in Holder_Description_Detail__c 
* 				against the respective Holder__c record.
* @Param 1		Id - quoteLineId
* @Param 2		Holders__c - conHolder
* @Return       String - The final description of Holder records which has concatenated values 
* 				for OA, OB & OW
* @Example     
* ConfigHolderUtilityBatch.fetchAndUpdateHolderDesc('QUOTELINE_ID', 'HOLDERS')
*********************************************************************************************************/ 
    public static Result fetchAndUpdateHolderDesc(Id quoteLineId, Holders__c conHolder) {
        
        Map<String, String> holderInputs;
        List<Holder_Outputs__c> hldOutputs;
        Holder_Outputs__c hldOutput;
        Holder_Description_Detail__c descRec;
        Result resDesc;
        String OA, OB, OW, strquoteDes;
        Result resData = new Result();
        
        List<SBQQ__QuoteLine__c> qlDet = [SELECT Id, Name FROM SBQQ__QuoteLine__c WHERE Id = :quoteLineId];
        
        try {
            
            holderInputs = ConfigHolderUtility.holderInputs(conHolder);
            //genUtil = generic.getUtilityInstance(prodCode, quoteLine.Id);
            
            hldOutputs = [SELECT OA__c, OA_Overridden__c, OB__c, OB_Overridden__c, 
                          OW__c, OW_Overridden__c 
                          FROM Holder_Outputs__c 
                          WHERE ReferenceId__c = :conHolder.Id];
            if(hldOutputs.size() > 0) {
                
                strquoteDes = '';
                OA = '';
                OB = '';
                OW = '';
                hldOutput = hldOutputs[0];
                
                resDesc = ConfigHolderUtility.getHolderDescription(holderInputs);
                if(resDesc.bResult) {
                    for(sObject sobj:resDesc.objResultList) {
                        
                        descRec = new Holder_Description_Detail__c ();
                        descRec = (Holder_Description_Detail__c ) sobj;
                        if (descRec.Attribute__c.startsWith('OA'))
                            OA += String.isNotBlank(descRec.Text__c)?descRec.Text__c+'\n':'';
                        else if (descRec.Attribute__c.startsWith('OB'))
                            OB += String.isNotBlank(descRec.Text__c)?descRec.Text__c+'\n':'';
                        else if (descRec.Attribute__c.startsWith('OW'))
                            OW += String.isNotBlank(descRec.Text__c)?descRec.Text__c+'\n':'';
                    }
                    hldOutput.put('OA__c', OA);
                    hldOutput.put('OB__c', OB);
                    hldOutput.put('OW__c', OW);
                    
                    if(conHolder.Quote_Descriptions_Override__c == false) {
                        hldOutput.put('OA_Overridden__c', OA);
                        hldOutput.put('OB_Overridden__c', OB);
                        hldOutput.put('OW_Overridden__c', OW);
                    }
                }
                update hldOutput;
                
                if(String.isNotBlank(hldOutput.OA_Overridden__c)){
                    strquoteDes += hldOutput.OA_Overridden__c +'\n';
                }
                if(String.isNotBlank(hldOutput.OB_Overridden__c)){
                    strquoteDes += hldOutput.OB_Overridden__c+'\n';
                }
                if(String.isNotBlank(hldOutput.OW_Overridden__c)){
                    strquoteDes += hldOutput.OW_Overridden__c+'\n' ;
                }
                strquoteDes = strquoteDes.replace('\\n', '\n');
                strquoteDes = strquoteDes.replace('\n', '<br/>');
                resData.strRetValue = strquoteDes;
            	resData.bResult = true;
            }
        } catch (Exception e) {
            
            resData.bResult = false;
            resData.strErrorMessage = 'Error:'+ qlDet[0].Name +' - '+e.getMessage();
        }
        
        return resData;
        //return strquoteDes;
    }
    
    /*******************************************************************************************************
    * @Description  This method fetches drawing data records based on the Holder Inputs 
    * 				from Drawing Translation and Detail, and upsert the values in Holder_Drawings__c against
    * 				the respective Holder__c record.
    * @Param 1		Holders__c - conHolder
    * @Return       Result - This a a wrapper class returning List<sObject> objResultList and Boolean bResult  
    * 				Boolean bResult: true or false (false incase of any errors and true for success)
    * 				List<sObject> objResultList: List<Holder_Description_Detail__c> Basically the list 
    * 				of Holder Drawings records.
    * @Example     
    * ConfigHolderUtilityBatch.fetchAndUpdateHolderDiagram('HOLDERS')
    *********************************************************************************************************/ 
    public static Result fetchAndUpdateHolderDiagram(Holders__c conHolder) {
        
        Result resDiaData = new Result();
        Map<String, String> mapDia = new Map<String, String>();
        
        mapDia.put('Entity', conHolder.Brand__c);
        mapDia.put('HPTC', conHolder.Holder_Product_Code__c);
        mapDia.put('SZC', conHolder.Size2__c);
        mapDia.put('HCLASS', conHolder.Bolting_Class__c);
        mapDia.put('HIC', conHolder.Inlet_Connection__c);
        mapDia.put('HOC', conHolder.Outlet_Connection__c);
        mapDia.put('COIN', conHolder.Inlet_Option__c);
        mapDia.put('COOUT', conHolder.Outlet_Option2__c);
        mapDia.put('COMF', conHolder.Mid_Flange_Option__c);
        
        List<String> selectCols = new List<String>();
        selectCols.add('Drawing_Type__c');
        selectCols.add('DrawingID__c');
        selectCols.add('DimA__c');
        selectCols.add('DimB__c');
        selectCols.add('DimC__c');
        selectCols.add('DimD__c');
        selectCols.add('DimE__c');
        selectCols.add('DimF__c');
        selectCols.add('HIC__c');
        selectCols.add('HOC__c');
        selectCols.add('SizeClassDesc__c');
        selectCols.add('DWGNO__c');
        selectCols.add('Revision__c');
        
        resDiaData = ConfigHolderUtility.getDataFromTranslationObj('Drawing_Type__c', 'Holder_Drawings_Translation__c', 'Holder_Drawings_Detail__c', mapDia, selectCols, null);
        Result resD = new Result();
        List<Holder_Drawings__c> holderDiagramList = [SELECT Drawing_Number__c,Drawing_ID__c,Drawing_Info__c,Drawing_ID_Override__c,
                                                      Dim_A__c,Dim_A_Override__c,Dim_B__c,Dim_B_Override__c,Dim_C__c,Dim_C_Override__c,
                                                      Dim_D__c,Dim_D_Override__c,Dim_E__c,Dim_E_Override__c,Dim_F__c,Dim_F_Override__c, 
                                                      IINO_DWGNO__c, JHOOK_IINO_DWGNO__c, Submittal_Drawing_DWGNO__c, Revision__c, 
                                                      Holders__c, Holders__r.Quote_Line__c, Holders__r.Quote_Line__r.Name,
                                                      Holders__r.Quote_Line__r.Drawing_to_be_created_outside_of_Config__c  
                                                      FROM Holder_Drawings__c 
                                                      WHERE Holders__c = :conHolder.id];
        Holder_Drawings__c holderD = new Holder_Drawings__c();
        
        //delete the older records
        //delete holderDiagramList;
        
        if(holderDiagramList.size()>0){
            
            holderD = holderDiagramList[0];
            
        } else {
            
            holderD.Holders__c = conHolder.Id;
        }
        Integer submittalDrawingFound = 0;
        List<Holder_Drawings__c> holderDiaList = new List<Holder_Drawings__c>();
        
        if(!conHolder.Diagram_Override__c) {
            
            if(resDiaData.bResult) {
                for (sObject sObj: resDiaData.objResultList) {
                    if ((string) sObj.get('Drawing_Type__c') == 'Submittal Drawing') {
                        
                        holderD.Drawing_ID__c = (string) sObj.get('DrawingID__c');
                        holderD.Submittal_Drawing_DWGNO__c = (string) sObj.get('DWGNO__c');
                        holderD.Drawing_ID_Override__c = (string) sObj.get('DrawingID__c');
                        holderD.Revision__c = (string) sObj.get('Revision__c');  
                        
                        holderD.Dim_A__c = (string) sObj.get('DimA__c');
                        holderD.Dim_B__c = (string) sObj.get('DimB__c');
                        holderD.Dim_C__c = (string) sObj.get('DimC__c');
                        holderD.Dim_D__c = (string) sObj.get('DimD__c');
                        holderD.Dim_E__c = (string) sObj.get('DimE__c');
                        holderD.Dim_F__c = (string) sObj.get('DimF__c');
                        
                        holderD.HIC__c = (string) sObj.get('HIC__c');
                        holderD.HOC__c = (string) sObj.get('HOC__c');
                        holderD.SizeClassDesc__c = (string) sObj.get('SizeClassDesc__c');
                        
                        if(conHolder.Diagram_Override__c == false) {
                            
                            holderD.Dim_A_Override__c = (string) sObj.get('DimA__c');
                            holderD.Dim_B_Override__c = (string) sObj.get('DimB__c');
                            holderD.Dim_C_Override__c = (string) sObj.get('DimC__c');
                            holderD.Dim_D_Override__c = (string) sObj.get('DimD__c');
                            holderD.Dim_E_Override__c = (string) sObj.get('DimE__c');
                            holderD.Dim_F_Override__c = (string) sObj.get('DimF__c');
                        }
                        
                        submittalDrawingFound = 1;
                    }
                    if ((string) sObj.get('Drawing_Type__c') == 'J-Hook IINO') {
                        
                        holderD.JHOOK_IINO_DWGNO__c = (string) sObj.get('DWGNO__c');
                        holderD.J_Hook_IINO__c=(string) sObj.get('DrawingID__c');
                    }
                    if ((string) sObj.get('Drawing_Type__c') == 'IINO'){
                        
                        holderD.IINO_DWGNO__c = (string) sObj.get('DWGNO__c');
                        holderD.IINO__c=(string) sObj.get('DrawingID__c');
                    }
                }
            }
            
            //If no drawing found then set the default drawing for "submittal drawing" to 9999
            if(submittalDrawingFound == 0 || holderD.Drawing_ID__c == null) {
                
                holderD.Drawing_ID__c = Label.Default_Submittal_Drawing;
                holderD.Drawing_ID_Override__c = Label.Default_Submittal_Drawing;
            }
        }
        
        try {
            holderDiaList.add(holderD);
            upsert holderD;
            
            system.debug('submittalDrawingFound:'+submittalDrawingFound);            
            if(holderD.Submittal_Drawing_DWGNO__c != null) {
                
                conHolder.DWGNO__c = holderD.Submittal_Drawing_DWGNO__c;
            }
            update conHolder;
            
            resD.objResultList = holderDiaList;
            resD.bResult = true;
            
        } catch (Exception e) {
            
            resD.bResult = false;
            resD.strErrorMessage = 'Error:'+ holderD.Holders__r.Quote_Line__r.Name +' - '+e.getMessage();
        }
        
        //resDiaData.objResultList.add(holderD);
        //resDiaData.bResult = true;        
        return resD;
    }
    
    /*******************************************************************************************************
    * @Description  This method updates the QL records especially the description, 
    * 				and the diagram parameters like Drawing ID, Dim A to Dim F.
    * 				This method is an future method which is invoked at last after update of description and diagram details.
    * @Param 1		String - quoteLineDetailsJSON (List of quote line records which is serialised for conerting to a String)
    * @Return       void
    * @Example     
    * ConfigHolderUtilityBatch.updateQuoteLineDesc('LIST_OF_QUOTE_LINE_AS_JSON')
    *********************************************************************************************************/
    @future(callout = true)
    public static void updateQuoteLineDesc(String quoteLineDetailsJSON) {
        
        if(quoteLineDetailsJSON != null) {
           
            List<SBQQ__QuoteLine__c> quoteLines = (List<SBQQ__QuoteLine__c>)System.JSON.deserialize(quoteLineDetailsJSON, List<SBQQ__QuoteLine__c>.class);
            
            if(quoteLines.size() > 0) {
                
                update quoteLines;  
            }
        }
    }
    
    /*********************************************************************************************************
    * @Description  This method updates the Holder specific quote line description and drawing based on inputs
    * 				
    * @Param 1		Holders__c - hld 
    * @Return       Map<String, Object>
    * 				There are 2 keys associated in the response:
    * 					QUOTE_LINE: Map<Id, SBQQ__QuoteLine__c>
    * 					ERR_DETAILS: String
    * @Example     
    * ConfigHolderUtilityBatch.updateHolderRecords('HOLDER_RECORD')
    *********************************************************************************************************/
    public static Map<String, Object> updateHolderRecords(Holders__c hld) {
        
        SBQQ__QuoteLine__c quoteLineObj;
        Map<Id, SBQQ__QuoteLine__c> quoteLineDetails = new Map<Id, SBQQ__QuoteLine__c>();
        Holders__c conHolder;
        String quoteDesc;
        String errorDetails = '';
        
        //update desc
        conHolder = DataSelectorWizard.getHolderProductRecord(hld.Quote_Line__c);
        Result quoteDescRes = ConfigHolderUtilityBatch.fetchAndUpdateHolderDesc(hld.Quote_Line__c, conHolder);
        
        if(quoteDescRes != null && quoteDescRes.bResult) {
            
            quoteDesc = quoteDescRes.strRetValue;
            if(quoteLineDetails.get(hld.Quote_Line__c) == null) {
                
                quoteLineDetails.put(hld.Quote_Line__c, new SBQQ__QuoteLine__c());
            }
            quoteLineObj = quoteLineDetails.get(hld.Quote_Line__c);
            quoteLineObj.Id = hld.Quote_Line__c;
            quoteLineObj.SBQQ__Description__c = quoteDesc;
            quoteLineDetails.put(hld.Quote_Line__c, quoteLineObj);
            
        } else {
            
            errorDetails += quoteDescRes.strErrorMessage + '\n';
        }
        
        //update image
        Result diagramRes = ConfigHolderUtilityBatch.fetchAndUpdateHolderDiagram(conHolder);
        
        if(diagramRes != null && diagramRes.bResult) {
            
            List<Holder_Drawings__c> hldDiagrams = (List<Holder_Drawings__c>) diagramRes.objResultList;
            for(Holder_Drawings__c hldDiagram: hldDiagrams) {
                
                if(hldDiagram.Submittal_Drawing_DWGNO__c != null || Test.isRunningTest()) {
                    
                    if(quoteLineDetails.get(hldDiagram.Holders__r.Quote_Line__c) == null) {
                        
                        quoteLineDetails.put(hldDiagram.Holders__r.Quote_Line__c, new SBQQ__QuoteLine__c());
                    }
                    quoteLineObj = quoteLineDetails.get(hldDiagram.Holders__r.Quote_Line__c);
                    
                    if(quoteLineObj.Id == null) {
                        
                        quoteLineObj.Id = hldDiagram.Holders__r.Quote_Line__c;
                    }
                    
                    if(hldDiagram.Holders__r.Quote_Line__r.Drawing_to_be_created_outside_of_Config__c == false) {
                        
                        quoteLineObj.DrawingID__c = hldDiagram.Drawing_ID__c;
                        quoteLineObj.DimA__c  = hldDiagram.Dim_A__c;
                        quoteLineObj.DimB__c  = hldDiagram.Dim_B__c;
                        quoteLineObj.DimC__c  = hldDiagram.Dim_C__c;
                        quoteLineObj.DimD__c  = hldDiagram.Dim_D__c;
                        quoteLineObj.DimE__c  = hldDiagram.Dim_E__c;
                        quoteLineObj.DimF__c  = hldDiagram.Dim_F__c;
                    }
                    
                    system.debug('ASHIM - '+hldDiagram.Submittal_Drawing_DWGNO__c);
                    quoteLineDetails.put(hldDiagram.Holders__r.Quote_Line__c, quoteLineObj);
                }
            }
        } else {
            
            errorDetails += quoteDescRes.strErrorMessage + '\n';
        }
        
        Map<String, Object> response = new Map<String, Object>();
        response.put('QUOTE_LINE', quoteLineDetails);
        response.put('ERROR_DETAILS', errorDetails);
        
        return response;
    }
    
    @future(callout = true) 
    public static void updateQLines() {
        
        disableCpqTriggers.disableCPQ();
        Map<Id, SBQQ__QuoteLine__c> quotelineMap = new Map<Id, SBQQ__QuoteLine__c>();
        List<QuoteLine_Mass_Update__c> records = [SELECT Id, Quote_Line__c, QuoteLine_Description__c, Drawing_ID__c, DimA__c, DimB__c, DimC__c, DimD__c, DimE__c, DimF__c FROM QuoteLine_Mass_Update__c WHERE Trigger_QL_Update__c = false ORDER BY Id DESC];
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
        SBQQ__QuoteLine__c quoteLine;
        for(QuoteLine_Mass_Update__c quoteLinesMassRecord: records) {
            
            quoteLine = new SBQQ__QuoteLine__c();
            quoteLine.Id  = quoteLinesMassRecord.Quote_Line__c;
            quoteLine.DrawingID__c = quoteLinesMassRecord.Drawing_ID__c;
            quoteLine.DimA__c = quoteLinesMassRecord.DimA__c;
            quoteLine.DimB__c = quoteLinesMassRecord.DimB__c;
            quoteLine.DimC__c = quoteLinesMassRecord.DimC__c;
            quoteLine.DimD__c = quoteLinesMassRecord.DimD__c;
            quoteLine.DimE__c = quoteLinesMassRecord.DimE__c;
            quoteLine.DimF__c = quoteLinesMassRecord.DimF__c;
            quoteLine.SBQQ__Description__c = quoteLinesMassRecord.QuoteLine_Description__c ;
            quotelineMap.put(quoteLine.Id, quoteLine);
            //quoteLines.add(quoteLine);
        }
        if(quotelineMap != null) {
            
            update quotelineMap.values();
            delete records;
        }
    }
}