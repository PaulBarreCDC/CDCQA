trigger TagTrigger on Tag__c (before insert,before update, before delete) {    
    
    list<SBQQ__QuoteLine__c> lstQTLine = new list<SBQQ__QuoteLine__c>();
    
    if (Trigger.isDelete) {
        
        for (Tag__c tag : Trigger.old) {
            if (tag.Quote_Line__c != null) {
                SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c(
                    Id = tag.Quote_Line__c,
                    Tag_Number__c = null
                );
                lstQTLine.add(ql);
            }
        }
        
    }
    else {
    
        for(Tag__c oTag : trigger.new){
            string recordTypeName = Schema.getGlobalDescribe().get('Tag__c').getDescribe().getRecordTypeInfosById().get(oTag.RecordTypeId).getName();
            string sTagType = (recordTypeName == 'Tag All (CDC/LaMOT Only)') ? 'TAGALL^_|' : (recordTypeName == 'Tag Each (CDC/LaMOT Only)') ? 'TAGEACH^_|' : (recordTypeName == 'Tag Individually') ? 'TAG^_|' : ''; 
            string sTagInstruction = '^_|TAGINSTRUCTION^_|' + oTag.Misc_Tagging_Instructions__c;
            string sBoxLabel = '^_|BOXLABEL^_|' + oTag.Box_Label__c + '^_|'; 
            string sTempTagString = '';
            string sTempTagStringPDF = '';
            for(integer i=1; i < 11;i++){
                string sTagNum;
                string sQty='';
                
                if(recordTypeName == 'Tag Each (CDC/LaMOT Only)'){
                    //'(' + qnty + ')^_&' +
                    //TAGEACH^_|(3)^_&PSE-3740-001 XS 3740-001^_^(3)^_&PSE-3750-001-XS-3750-001^_|TAGINSTRUCTION^_|^_|BOXLABEL^_|^_|
                    if(i == 10){
                        sQty = '(' + oTag.get('Quantity_' + i +'__c') + ')^_&' ;  
                    }else{
                        sQty = '(' + oTag.get('Quantity_0' + i +'__c') + ')^_&';  
                    }
                }
                
                if(i == 10){
                    sTagNum = 'Tag_Number_' + i +'__c';  
                }else{
                    sTagNum = 'Tag_Number_0' + i +'__c'; 
                }
                
                
                
                if(oTag.get(sTagNum) != null){
                    if(sTempTagString != ''){
                        sTempTagString += '^_^';
                        sTempTagStringPDF += ',';
                        sTempTagString += sQty + oTag.get(sTagNum);
                        sTempTagStringPDF += oTag.get(sTagNum);
                    }else{
                        sTempTagString += sQty + oTag.get(sTagNum);
                        sTempTagStringPDF += oTag.get(sTagNum);
                    }
                }   
            }
            
            string sTagVal = sTagType + sTempTagString + sTagInstruction + sBoxLabel;
            string sTagValFinal = sTagVal.replace(' : ', '^_&');
            system.debug('sTempTagString-sTagVal--> ' + sTagValFinal);
            oTag.Tag_Value_to_IFS__c = sTagValFinal.replaceall('null','');
            sTempTagStringPDF = sTempTagStringPDF.replaceAll('\\^_&','=>');
            oTag.Tag_Value_PDF__c = sTempTagStringPDF.replaceall('null','');
            //^_& =>
            
            SBQQ__QuoteLine__c oQTLine = new SBQQ__QuoteLine__c();
            oQTLine.Id = oTag.Quote_Line__c;
            oQTLine.Tag_Number__c = oTag.Tag_Value_to_IFS__c;
            oQTLine.Tag_Number_PDF__c = oTag.Tag_Value_PDF__c;
            if(!lstQTLine.contains(oQTLine)){
                lstQTLine.add(oQTLine);
            }
        }
        
    }
    
    if(lstQTLine.size() > 0 ){
        update lstQTLine;
    }
    
}