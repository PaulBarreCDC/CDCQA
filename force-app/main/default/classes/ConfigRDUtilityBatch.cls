public class ConfigRDUtilityBatch {

    public static Map<String, Object> updateRDRecords(Rupture_Disc__c rdRecord) {
		system.debug('RD Update...');
        String errorDetails = '';
        String quoteDesc;
        Result resData = new Result();
        SBQQ__QuoteLine__c quoteLine;

        ConfigureRD conObj = new ConfigureRD(rdRecord.Quote_Line__c);
    
        //update diagrams
        Result diagramRes = conObj.loadDiagramData();
        
        //update sizing
        RuptureDiscController.ReorderFlagLWC = true;
        Rupture_Disc__c rdDetails  = conObj.conProd;
        if(rdDetails.Product_Narrowing_Flag__c) {
            RuptureDiscController.saveSizingFlowArea(rdDetails);
        }
        RuptureDiscController.saveProductSelection(rdDetails, rdDetails.Id, null);
        RuptureDiscController.saveHClass(rdDetails);

        //update pricing
        WizardPricingProcessor wzdPrz = new WizardPricingProcessor(rdDetails.id);
        Result resPric = wzdPrz.getRDAdderPriceValues();
        
        //update lead time  
        system.debug('RD Update...'+rdDetails.Lead_Time_Override__c);
        RdOutputBaseUtility RDOU = new RdOutputBaseUtility(rdDetails.id);
        List<RdOutputBaseUtility.RDStructureWrapper> structureDetails = RDOU.getConsolidatedStructureDetails();
        if(!rdDetails.Lead_Time_Override__c) {
            
            system.debug('RD Update...Invoke LeadTime:'+rdDetails.Id);
            RDOU.getRDLeadTime();
        }

        //fetch and update descriptions
        String resStrOA = '';
        String strOA = '';
        String strLABDSC = '';
        String strOB = '';
        String strOBOverRide = '';
        String strOW = '';
        
        Result resOA = conObj.RDOU.getOA();
        if (resOA.bResult) {
            for (sObject sOb:resOA.objResultList) {
                if ((String) sOb.get('OA__c')!=null){
                    strOA = (String) sOb.get('OA__c');
                    strOA = strOA.replace('\\n','\n');
                    strOA+= '\n';
                }

                if ((String) sOb.get('LABDSC__c')!=null)
                    strLABDSC+= (String) sOb.get('LABDSC__c')+'\n';
            }
        }

        Map<String, String> OBMAP = conObj.RDOU.getOB_LABMAT_Ouput();
        
        if(OBMAP.get('OB').length()>251) {
            strOB = OBMAP.get('OB').substring(0, 250);
            if(!rdRecord.Quote_Descriptions_Override__c)
                strOBOverRide=OBMAP.get('OB').substring(0, 250);
        } else {
            strOB=OBMAP.get('OB');
            if(!rdRecord.Quote_Descriptions_Override__c)
                strOBOverRide=OBMAP.get('OB');
        }

        Result resOW = conObj.RDOU.getOW();
        if (resOW.bResult) {
            strOW = resOW.strRetValue;
            strOW = strOW.replace('\\n','\n');
        }
        
        RD_Outputs__c outputs = conObj.rdOutput;
        List<RD_Outputs__c> rdOutputs = [SELECT Id, ORV__c, ORP__c, ORP_Override__c, ORV_Override__c, OA__c, OB__c, OW__c, OA_Override__c, OB_Override__c, OW_Override__c FROM RD_Outputs__c WHERE Id = :outputs.Id];
        outputs = rdOutputs[0];
        outputs.OA__c = strOA;
        outputs.OB__c = strOB;
        outputs.OW__c = strOW;
        Rupture_Disc__c recDetail = rdRecord;

        try {
            if(!recDetail.Quote_Descriptions_Override__c){
                outputs.OA_Override__c = strOA;
                outputs.OB_Override__c = strOB;
                outputs.OW_Override__c = strOW;
            }
            
            update outputs;
            //update recDetail;

            if(recDetail.Quote_Descriptions_Override__c) {
                quoteDesc = '';
                if(outputs.OA_Override__c != null) {
                	
                    quoteDesc = outputs.OA_Override__c;
                }
                if(outputs.OB_Override__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += outputs.OB_Override__c;
                }
                
                if(outputs.ORP_Override__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += outputs.ORP_Override__c;
                }
                
                if(outputs.ORV_Override__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += outputs.ORV_Override__c;
                }
                
                if(outputs.OW_Override__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += outputs.OW_Override__c;
                }
                                
            } else {
                
                quoteDesc = '';
                if(outputs.OA__c != null) {
                	
                    quoteDesc = strOA;
                }
                if(outputs.OB__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += strOB;
                }
                if(outputs.ORP__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += outputs.ORP__c;
                }
                if(outputs.ORV__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += outputs.ORV__c;
                }
                
                if(outputs.OW__c != null) {
                    if(quoteDesc != '') {
                        
                       quoteDesc += '\n'; 
                    }
                    quoteDesc += strOW;
                }
            }

            quoteDesc = quoteDesc.replace('\\n', '\n');
            quoteDesc = quoteDesc.replace('\n', '<br/>');
            quoteLine = new SBQQ__QuoteLine__c();
            quoteLine.Id = recDetail.Quote_Line__c;
            quoteLine.SBQQ__Description__c = quoteDesc;
            
            //assign diagram dtails to QL
            
            if(diagramRes != null && diagramRes.bResult) {
                
                List<RD_Drawings__c> rdDiagrams = (List<RD_Drawings__c>) diagramRes.objResultList;
                List<RD_Drawings__c> rdDiagramDetails = [SELECT Drawing_Number__c, Rupture_Disc__r.Quote_Line__r.Drawing_to_be_created_outside_of_Config__c, Drawing_ID__c, Dim_A__c, Dim_B__c, Dim_C__c, Dim_D__c, Dim_E__c, Dim_F__c FROM RD_Drawings__c WHERE Id IN :rdDiagrams];
                for(RD_Drawings__c rdDiagram: rdDiagramDetails) {
                    
                    if(rdDiagram.Drawing_Number__c != null) {
                        
                        if(rdDiagram.Rupture_Disc__r.Quote_Line__r.Drawing_to_be_created_outside_of_Config__c == false) {
                            
                            quoteLine.DrawingID__c = rdDiagram.Drawing_ID__c;
                            quoteLine.DimA__c  = rdDiagram.Dim_A__c;
                            quoteLine.DimB__c  = rdDiagram.Dim_B__c;
                            quoteLine.DimC__c  = rdDiagram.Dim_C__c;
                            quoteLine.DimD__c  = rdDiagram.Dim_D__c;
                            quoteLine.DimE__c  = rdDiagram.Dim_E__c;
                            quoteLine.DimF__c  = rdDiagram.Dim_F__c;
                        }
                    }
                }
            }
            
        } catch (Exception e) {       
            
            errorDetails = 'Error:'+ recDetail.Quote_Line__c +' - '+e.getMessage();
        }

        Map<String, Object> response = new Map<String, Object>();
        response.put('QUOTE_LINE', quoteLine);
        response.put('ERROR_DETAILS', errorDetails);

        return response;
    }
}