/*********************************************************************************
* Class Name: IFS_ConstructCancelOrderReq
* This class constructs Cancel Order XML request from quote for IFS Integration
*********************************************************************************/
public class IFS_ConstructCancelOrderReq{

    public void IFS_ConstructCancelOrderReq(){
    }
    
    public static String generateReq(SBQQ__Quote__c quote){
        XmlStreamWriter xmlStream = new XmlStreamWriter();       
        xmlStream.writeStartElement('soap','Envelope','http://schemas.xmlsoap.org/soap/envelope/');
        xmlStream.writeNamespace('soap','http://schemas.xmlsoap.org/soap/envelope/');    
        xmlStream.writeStartElement('soap','Body','');
        xmlStream.writeStartElement('','ORDER_CANCEL_BLOCK','urn:ifsworld-com:schemas:inbound_sales_force_cpq_int_receive_order_cancel_block_request');// begin ORDER_CANCEL_BLOCK
        xmlStream.writeNamespace('xsi','http://www.w3.org/2001/XMLSchema-instance');
        xmlStream.writeNamespace('','urn:ifsworld-com:schemas:inbound_sales_force_cpq_int_receive_order_cancel_block_request');         
        
        xmlStream.writeStartElement('', 'SF_MESSAGE_ID', '');
        xmlStream.writeCharacters('NO_MAPPING'); 
        xmlStream.writeEndElement();
                               
        if(quote.SBQQ__Opportunity2__r.Integration_Message_Counter__c!=NULL){ 
            xmlStream.writeStartElement('', 'CONTRACT', '');
            xmlStream.writeCharacters(String.valueof(quote.SBQQ__Opportunity2__r.Integration_Message_Counter__c)); 
            xmlStream.writeEndElement();
        }
        if(quote.Order_Number__c!=NULL){
            xmlStream.writeStartElement('', 'ORDER_NO', '');
            xmlStream.writeCharacters(quote.Order_Number__c); 
            xmlStream.writeEndElement();
        }
        if(quote.Change_Order_Status__c!=NULL){
            xmlStream.writeStartElement('', 'STATUS', '');
            xmlStream.writeCharacters(quote.Change_Order_Status__c); 
            xmlStream.writeEndElement();
        }                                    
        if(quote.Status_Reason__c!=NULL){
            xmlStream.writeStartElement('', 'REASON', '');
            xmlStream.writeCharacters(quote.Status_Reason__c); 
            xmlStream.writeEndElement();
        }
        /*if(quote.IFS_Order_Status__c!=NULL){
            xmlStream.writeStartElement('', 'TRANSACTION_STATUS', '');
            xmlStream.writeCharacters(quote.IFS_Order_Status__c); 
            xmlStream.writeEndElement();
        }
        if(quote.Change_Order_Comments__c!=NULL){
            xmlStream.writeStartElement('', 'MESSAGE', '');
            xmlStream.writeCharacters(quote.Change_Order_Comments__c); 
            xmlStream.writeEndElement();
        }*/
                                    
        xmlStream.writeEndElement(); // end of ORDER_CANCEL_BLOCK 
        xmlStream.writeEndElement();      // end of body
        xmlStream.writeEndElement();      // end of Envelope        
        //System.debug('Order/Quote Req:'+xmlStream.getXMLString());
        
        String xmlRequest = xmlStream.getXMLString();
        return xmlRequest;
    }
}