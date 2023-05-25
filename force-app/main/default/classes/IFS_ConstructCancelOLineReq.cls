/******************************************************************************************
* Class Name: IFS_ConstructCancelOLineReq
* This class constructs Cancel Order Line XML request from quote line for IFS Integration
******************************************************************************************/
public class IFS_ConstructCancelOLineReq{

    public void IFS_ConstructCancelOLineReq(){
    }
   
    public static String generateReq(SBQQ__QuoteLine__c quoteLine){ 

        XmlStreamWriter xmlStream = new XmlStreamWriter();         
         
        xmlStream.writeStartElement('soap','Envelope','http://schemas.xmlsoap.org/soap/envelope/');
        xmlStream.writeNamespace('soap','http://schemas.xmlsoap.org/soap/envelope/');    
        xmlStream.writeStartElement('soap','Body','');
        xmlStream.writeStartElement('','ORDER_LINE_CANCEL_BLOCK','urn:ifsworld-com:schemas:inbound_sales_force_cpq_int_receive_line_cancel_block_request');// begin order line cancel block
        xmlStream.writeNamespace('xsi','http://www.w3.org/2001/XMLSchema-instance');
        xmlStream.writeNamespace('','urn:ifsworld-com:schemas:inbound_sales_force_cpq_int_receive_line_cancel_block_request');        
        
        xmlStream.writeStartElement('', 'SF_MESSAGE_ID', '');
        xmlStream.writeCharacters('NO_MAPPING'); 
        xmlStream.writeEndElement();
                              
        if(quoteLine.SBQQ__Quote__r.SBQQ__Opportunity2__r.Integration_Message_Counter__c!=NULL){
            xmlStream.writeStartElement('', 'CONTRACT', '');
            xmlStream.writeCharacters(String.valueof(quoteLine.SBQQ__Quote__r.SBQQ__Opportunity2__r.Integration_Message_Counter__c)); 
            xmlStream.writeEndElement();                                    
        }
        if(quoteLine.SBQQ__Quote__r.Order_Number__c!=NULL){
            xmlStream.writeStartElement('', 'ORDER_NO', '');
            xmlStream.writeCharacters(String.valueof(quoteLine.SBQQ__Quote__r.Order_Number__c)); 
            xmlStream.writeEndElement();
        }
        if(quoteLine.Line_Number__c!=NULL || quoteLine.QuoteLineNumber__c!=NULL){
            xmlStream.writeStartElement('', 'LINE_NO', '');            
            if(quoteLine.Line_Number__c!=NULL){
                xmlStream.writeCharacters(String.valueof(quoteLine.Line_Number__c)); 
            }else if(quoteLine.QuoteLineNumber__c!=NULL){
                xmlStream.writeCharacters(String.valueof(quoteLine.QuoteLineNumber__c)); 
            }             
            xmlStream.writeEndElement();
        }
        if(quoteLine.Delivery_Number__c!=NULL){
            xmlStream.writeStartElement('', 'DEL_NO', '');
            //xmlStream.writeCharacters(String.valueof(quoteLine.SBQQ__Number__c));
            xmlStream.writeCharacters(String.valueof(quoteLine.Delivery_Number__c));            
            xmlStream.writeEndElement();
        }        
        if(quoteLine.Change_Order_Status__c!=NULL){
            xmlStream.writeStartElement('', 'STATUS', '');
            xmlStream.writeCharacters(quoteLine.Change_Order_Status__c); 
            xmlStream.writeEndElement();
        }
        if(quoteLine.Status_Reason__c!=NULL){
            xmlStream.writeStartElement('', 'REASON', '');
            xmlStream.writeCharacters(quoteLine.Status_Reason__c); 
            xmlStream.writeEndElement();
        }
        /*if(quoteLine.SBQQ__Quote__r.IFS_Order_Status__c!=NULL){
            xmlStream.writeStartElement('', 'TRANSACTION_STATUS', '');
            xmlStream.writeCharacters(quoteLine.SBQQ__Quote__r.IFS_Order_Status__c); 
            xmlStream.writeEndElement();
        }
        if(quoteLine.SBQQ__Quote__r.Change_Order_Comments__c!=NULL){
            xmlStream.writeStartElement('', 'MESSAGE', '');
            xmlStream.writeCharacters(quoteLine.SBQQ__Quote__r.Change_Order_Comments__c); 
            xmlStream.writeEndElement();
        }*/
                                    
        xmlStream.writeEndElement(); //endof order line cancel block  
        xmlStream.writeEndElement();      // end og body
        xmlStream.writeEndElement();     // end of Envelope         
        //System.debug('Order/Quote Req:'+xmlStream.getXMLString());
        
        String xmlRequest = xmlStream.getXMLString();
        return xmlRequest;        
      }
}