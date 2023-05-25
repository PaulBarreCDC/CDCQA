/*********************************************************************************
* Class Name: IFS_ConstructOrderReq
* This class constructs Order XML request from quote for IFS Integration
* @Modification Log   :
* Ver       Date            Author      		    Modification
* 1.0        -               ApexIT                 Initial Version
* 1.1      11-03-2021      Drew/Rohini Hathi        Service Ticket# 200994 replace by Order_Priority2__c field
*********************************************************************************/
public class IFS_ConstructOrderReq{

    public void IFS_ConstructOrderReq(){
    }

    public static String generateReq(String quoteId){
        List<String> listofQuoteLineStatus = new List<String>();        
        listofQuoteLineStatus.add('Primary');
        listofQuoteLineStatus.add('Blocked');
        listofQuoteLineStatus.add('Unblock');
        //Service Ticket# 200994 replace by Order_Priority2__c field
        SBQQ__Quote__c quote = [SELECT Id,Name,Eng_Rep_1__c,SBQQ__PrimaryContact__r.Name,Freight_Information__c,Freight_Information__r.Entity__c,Freight_Information__r.Bill_To__c,Freight_Information__r.Account_Number__c,Freight_Information__r.Freight_Contact_Email__c,Freight_Information__r.Freight_Contact_Phone__c,Order_Number__c,Order_Type__c,Shipping_Instructions__c,Drawings_Attached__c,
                                        Ship_Via__c,Delivery_District__c,Change_Order_Log__c,CO_Clause__c,Currency__c,SBQQ__Key__c,Wanted_Delivery_Date__c,SBQQ__QuoteLanguage__c,Delivery_Terms_Location__c,
                                        Quote_Product_Group__c,Eng_Rep_2__c,Sold_By_Rep__c,
                                        End_Use_Application__c,Commission_Split_Sold_By_Rep__c,Sold_By_Rep__r.Rep_Code__c,Commission_Split_Dest_Rep__c,Commission_Split_Eng_Rep_1__c,Commission_Split_Eng_Rep_2__c,Shipment_Type__c,Delivery_Terms__c,
                                        Backorder_Option__c,Customer_s_PO_Number__c,End_User__r.Name,End_User_Street__c,End_User_City__c,End_User_State__c,End_User_PostalCode__c,End_User_Country__c
                                        ,Sourcing_Entity__c,Order_Priority2__c,Destination_Rep__c,Change_Order_No__c,SBQQ__PaymentTerms__c,Delivery_Market__c,Ordering_Region__c,Ordering_District__c,Project_Coordinator__r.Authorize_Code__c,Shipping_Account__r.Account_Number__c,SBQQ__Account__r.Account_Number__c,(SELECT Sequence__c,Type__c,Amount__c,Quantity__c,Status__c, Comments__c from Charges__r where Sent_To_IFS__c=true) Charge__c,
                                        Sold_By_Rep__r.Rep_Code_Formula__c,Planned_Delivery_Date__c,
                                        Destination_Rep__r.Rep_Code_Formula__c,Destination_Rep__r.Rep_Code__c,
                                        Eng_Rep_1__r.Rep_Code_Formula__c,Eng_Rep_1__r.Rep_Code__c,
                                        Eng_Rep_2__r.Rep_Code_Formula__c,Eng_Rep_2__r.Rep_Code__c,                                      
                                        (SELECT Id,Line_Number__c,QuoteLineNumber__c,Delivery_Number__c,SBQQ__Quote__c,
                                        Shipment_Creation__c,Additional_Discount_Type__c,Priority__c,Milestone_Template_Id__c,Tag_Number__c,SBQQ__ProductCode__c,PARTNUMBER__c,Wanted_Delivery_Date__c,Vendor__c,Planned_Delivery_Date__c,Name,SBQQ__OriginalQuoteLineId__c,Supply_Code__c,Maximum_Commission__c,Adjusted_Commission_PCT__c,
                                        SBQQ__Quantity__c,SBQQ__ListPrice__c,Net_Price_Each_Cust_Curr__c,Discount__c,Customer_s_Part_No__c, Same_As_Reference__c FROM SBQQ__LineItems__r WHERE Line_Status__c IN:listofQuoteLineStatus) 
                                        SBQQ__QuoteLine__c, Sales_Division__c, SBQQ__Opportunity2__r.Quote_Type__c, SBQQ__Opportunity2__r.Type  
                                FROM SBQQ__Quote__c WHERE Id=:quoteId Limit 1];               
                
        List<Id> listOfRecords=new List<Id>();
        List<Id> contentDocumentIds=new List<Id>();
        List<Id> contentVersionIds=new List<Id>();
        Map<Id,Id> recordContentDocIdMap = new Map<Id,Id>();
        Map<Id,String> publicLinks = new Map<Id,String>();
        Map<Id,List<ContentVersion>> fileMap = new Map<id,List<ContentVersion>>();  
        listOfRecords.add(quote.Id);
        if((quote.SBQQ__LineItems__r).size()>0){            
            for(SBQQ__QuoteLine__c quoteLine : quote.SBQQ__LineItems__r){
                listOfRecords.add(quoteLine.Id);
            }
        }       
        
        for(ContentDocumentLink eachContentDocumentLink : [SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN:listOfRecords]){
            contentDocumentIds.add(eachContentDocumentLink.ContentDocumentId);
            recordContentDocIdMap.put(eachContentDocumentLink.ContentDocumentId,eachContentDocumentLink.LinkedEntityId);
        }       
        
        for(ContentVersion eachContentVersion : [SELECT Id,ContentDocumentId,FirstPublishLocationId,Title,FileType,FileExtension,ContentSize,VersionNumber,Document_Class__c FROM ContentVersion WHERE ContentDocumentId IN:contentDocumentIds AND IsLatest=true]){
            Id objRecordId=recordContentDocIdMap.get(eachContentVersion.ContentDocumentId);
            contentVersionIds.add(eachContentVersion.Id);
            if(fileMap.get(objRecordId)!=NULL){
                List<ContentVersion> fileList = fileMap.get(objRecordId);
                fileList.add(eachContentVersion);
                fileMap.put(objRecordId,fileList);
            }else{
                List<ContentVersion> fileList = new List<ContentVersion>();
                fileList.add(eachContentVersion);
                fileMap.put(objRecordId,fileList);
            }
        }  
        
        //DistributionPublicUrl
        for(ContentDistribution eachContentDistribution : [SELECT ContentVersionId,ContentDownloadUrl FROM ContentDistribution WHERE ContentVersionId IN:contentVersionIds AND ExpiryDate=null]){
            publicLinks.put(eachContentDistribution.ContentVersionId,eachContentDistribution.ContentDownloadUrl);
        }   
        XmlStreamWriter xmlStream = new XmlStreamWriter();
        xmlStream.writeStartElement('soap','Envelope','http://schemas.xmlsoap.org/soap/envelope/');
        xmlStream.writeNamespace('soap','http://schemas.xmlsoap.org/soap/envelope/'); 
        xmlStream.writeStartElement('soap','Body','');
        xmlStream.writeStartElement('','CUSTOMER_ORDER','urn:ifsworld-com:schemas:inbound_sales_force_cpq_int_receive_customer_order_request');
        xmlStream.writeNamespace('xsi','http://www.w3.org/2001/XMLSchema-instance');
        xmlStream.writeNamespace('','urn:ifsworld-com:schemas:inbound_sales_force_cpq_int_receive_customer_order_request'); 

        xmlStream.writeStartElement(NULL, 'SF_MESSAGE_ID', NULL);
        xmlStream.writeCharacters('NO_MAPPING'); 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL,'CUSTOMER_ORDER_REC',NULL);
        xmlStream.writeStartElement(NULL,'ORDER_HEADER',NULL);
        

        xmlStream.writeStartElement(NULL, 'EXTERNAL_FIELD_ID', NULL);
        if(quote.SBQQ__Key__c!=NULL){
            xmlStream.writeCharacters(quote.SBQQ__Key__c);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'CONTRACT', NULL);
        //if(quote.Sourcing_Entity__c!=NULL){
        if(quote.Sales_Division__c!=NULL){
            xmlStream.writeCharacters(quote.Sales_Division__c); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'CURRENCY_CODE', NULL);
        if(quote.Currency__c!=NULL){
            xmlStream.writeCharacters(quote.Currency__c);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'CUSTOMER_NO', NULL);
        if(quote.SBQQ__Account__r.Account_Number__c!=NULL){            
            xmlStream.writeCharacters(quote.SBQQ__Account__r.Account_Number__c);
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'ORDER_NO', NULL);
        if(quote.Order_Number__c!=NULL){           
            xmlStream.writeCharacters(quote.Order_Number__c);
        }       
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'ORDER_ID', NULL);
        if(quote.Order_Type__c!=NULL){
            xmlStream.writeCharacters(quote.Order_Type__c);            
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'WANTED_DELIVERY_DATE', NULL);
        if(quote.Wanted_Delivery_Date__c!=NULL){            
            Date d = quote.Wanted_Delivery_Date__c;
            String dateStr= String.valueof(d);
            dateStr=dateStr+'T00:00:00';            
            xmlStream.writeCharacters(dateStr);
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'AUTHORIZE_CODE', NULL);
        if(quote.Project_Coordinator__r.Authorize_Code__c!=NULL){
            xmlStream.writeCharacters(String.valueof(quote.Project_Coordinator__r.Authorize_Code__c));
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'CUST_REF', NULL);
        if(quote.SBQQ__PrimaryContact__r.Name!=NULL){
            xmlStream.writeCharacters(quote.SBQQ__PrimaryContact__r.Name);
        } 
        xmlStream.writeEndElement(); 

        xmlStream.writeStartElement(NULL, 'CUSTOMER_PO_NO', NULL);
        if(quote.Customer_s_PO_Number__c!=NULL){
            xmlStream.writeCharacters(quote.Customer_s_PO_Number__c);
        } 
        xmlStream.writeEndElement(); 

        xmlStream.writeStartElement(NULL, 'PRIORITY', NULL);
        if(quote.Order_Priority2__c!=NULL){//Service Ticket 200994 
            xmlStream.writeCharacters(quote.Order_Priority2__c);
        } 
        xmlStream.writeEndElement(); 

        xmlStream.writeStartElement(NULL, 'SHIP_ADDR_NO', NULL);
        if(quote.Shipping_Account__r.Account_Number__c!=NULL){
            xmlStream.writeCharacters(quote.Shipping_Account__r.Account_Number__c);
        }
        xmlStream.writeEndElement(); 

        xmlStream.writeStartElement(NULL, 'BILL_ADDR_NO', NULL);
        if(quote.SBQQ__Account__r.Account_Number__c !=NULL){
            xmlStream.writeCharacters(quote.SBQQ__Account__r.Account_Number__c);
        } 
        xmlStream.writeEndElement(); 

        xmlStream.writeStartElement(NULL, 'PRODUCT_GROUP', NULL);
        if(quote.Quote_Product_Group__c !=NULL){
            xmlStream.writeCharacters(quote.Quote_Product_Group__c);
        } 
        xmlStream.writeEndElement(); 

        xmlStream.writeStartElement(NULL, 'OUTPUT_LANGUAGE', NULL);
        if(quote.SBQQ__QuoteLanguage__c !=NULL){
            xmlStream.writeCharacters(quote.SBQQ__QuoteLanguage__c);
        } 
        xmlStream.writeEndElement();
        
        xmlStream.writeStartElement(NULL, 'DEL_TERMS_LOCATION', NULL);
        if(quote.Delivery_Terms_Location__c !=NULL){
            xmlStream.writeCharacters(quote.Delivery_Terms_Location__c);
        } 
        xmlStream.writeEndElement();
        
        xmlStream.writeStartElement(NULL, 'ENGINEERING_2_REP', NULL);
        if(quote.Eng_Rep_2__r.Rep_Code__c !=NULL){
            xmlStream.writeCharacters(quote.Eng_Rep_2__r.Rep_Code__c);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'BOOKINGS_ASSIGNMENT1', NULL);       
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'BOOKINGS_ASSIGNMENT2', NULL);        
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'BOOKINGS_ASSIGNMENT3', NULL);       
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'BOOKINGS_ASSIGNMENT4', NULL);        
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'BOOKINGS_SPLIT1', NULL);
        if(quote.Commission_Split_Sold_By_Rep__c !=NULL){
            xmlStream.writeCharacters(String.valueof(quote.Commission_Split_Sold_By_Rep__c));
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'BOOKINGS_SPLIT2', NULL);
        if(quote.Commission_Split_Dest_Rep__c !=NULL){
            xmlStream.writeCharacters(String.valueof(quote.Commission_Split_Dest_Rep__c));
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'BOOKINGS_SPLIT3', NULL);
        if(quote.Commission_Split_Eng_Rep_1__c !=NULL){
            xmlStream.writeCharacters(String.valueof(quote.Commission_Split_Eng_Rep_1__c));
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'BOOKINGS_SPLIT4', NULL);
        if(quote.Commission_Split_Eng_Rep_2__c !=NULL){
            xmlStream.writeCharacters(String.valueof(quote.Commission_Split_Eng_Rep_2__c));
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'REVISION', NULL);
        if(quote.Change_Order_No__c !=NULL){
            xmlStream.writeCharacters(String.valueof(quote.Change_Order_No__c));
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'REVISION_REASON', NULL);
        if(quote.Change_Order_Log__c !=NULL){
            xmlStream.writeCharacters(quote.Change_Order_Log__c);
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'END_USE', NULL);
        if(quote.End_Use_Application__c!=NULL){
            xmlStream.writeCharacters(String.valueof(quote.End_Use_Application__c));
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'SOLD_BY_REP', NULL);
        if(quote.Sold_By_Rep__r.Rep_Code__c!=NULL){                  
            xmlStream.writeCharacters(quote.Sold_By_Rep__r.Rep_Code__c);            
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'END_USER', NULL);
        if(quote.End_User__r.Name!=NULL){                       
            xmlStream.writeCharacters(quote.End_User__r.Name);            
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'END_USER_ADDRESS', NULL);
        if(quote.End_User_Street__c!=NULL){                     
            xmlStream.writeCharacters(quote.End_User_Street__c);            
        } 
        xmlStream.writeEndElement();
        
        xmlStream.writeStartElement(NULL, 'END_USER_CITY', NULL);
        if(quote.End_User_City__c!=NULL){                     
            xmlStream.writeCharacters(quote.End_User_City__c);            
        } 
        xmlStream.writeEndElement();
        
        xmlStream.writeStartElement(NULL, 'END_USER_STATE', NULL);
        if(quote.End_User_State__c!=NULL){                        
            xmlStream.writeCharacters(quote.End_User_State__c);            
        } 
        xmlStream.writeEndElement();
        
        xmlStream.writeStartElement(NULL, 'END_USER_ZIP_CODE', NULL);
        if(quote.End_User_PostalCode__c!=NULL){                       
            xmlStream.writeCharacters(quote.End_User_PostalCode__c);            
        } 
        xmlStream.writeEndElement();
        
        xmlStream.writeStartElement(NULL, 'END_USER_COUNTRY', NULL);
        if(quote.End_User_Country__c!=NULL){                        
            xmlStream.writeCharacters(quote.End_User_Country__c);            
        } 
        xmlStream.writeEndElement();
        
        xmlStream.writeStartElement(NULL, 'DESTINATION_REP', NULL);
        if(quote.Destination_Rep__r.Rep_Code__c!=NULL){                        
            xmlStream.writeCharacters(quote.Destination_Rep__r.Rep_Code__c);             
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'ENGINEERING_REP', NULL);
        if(quote.Eng_Rep_1__r.Rep_Code__c!=NULL){                        
            xmlStream.writeCharacters(quote.Eng_Rep_1__r.Rep_Code__c);            
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'SHIPPING_INSTRUCTIONS', NULL);
        if(quote.Shipping_Instructions__c!=NULL){
            xmlStream.writeCharacters(quote.Shipping_Instructions__c); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'SUBMITTAL_DRAWINGS', NULL);
        if(quote.Drawings_Attached__c != null && quote.Drawings_Attached__c == 'Submittal Drawings'){
            xmlStream.writeCharacters('true');
        }       
        xmlStream.writeEndElement();


        xmlStream.writeStartElement(NULL, 'APPROVAL_DRAWINGS', NULL);
        if(quote.Drawings_Attached__c != null && quote.Drawings_Attached__c == 'Approval Drawings'){
            xmlStream.writeCharacters('true');
        }        
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'SHIP_VIA_CODE', NULL);
        if(quote.Ship_Via__c!=NULL){
            xmlStream.writeCharacters(quote.Ship_Via__c);
        } 
        xmlStream.writeEndElement();


       xmlStream.writeStartElement(NULL, 'DELIVERY_TERMS', NULL);
        if(quote.Delivery_Terms__c!=NULL){
            xmlStream.writeCharacters(quote.Delivery_Terms__c);
        }
        xmlStream.writeEndElement();

       xmlStream.writeStartElement(NULL, 'SALESMAN_CODE', NULL);
        //No Mapping
       xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'PAY_TERM_ID', NULL);
        if(quote.SBQQ__PaymentTerms__c!=NULL){
            xmlStream.writeCharacters(quote.SBQQ__PaymentTerms__c);
        }
        xmlStream.writeEndElement();


        xmlStream.writeStartElement(NULL, 'MARKET_CODE', NULL);
        if(quote.Delivery_Market__c!=NULL){
            xmlStream.writeCharacters(quote.Delivery_Market__c);
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'BACKORDER_OPTION_DB', NULL);
        if(quote.Backorder_Option__c!=NULL){
            xmlStream.writeCharacters(quote.Backorder_Option__c);
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'SHIPMENT_TYPE', NULL);
        if(quote.Shipment_Type__c!=NULL){
            xmlStream.writeCharacters(quote.Shipment_Type__c);
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'REGION_CODE', NULL);
        if(quote.Ordering_Region__c!=NULL){
            xmlStream.writeCharacters(quote.Ordering_Region__c);
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement(NULL, 'DISTRICT_CODE', NULL);
        if(quote.Ordering_District__c!=NULL){
            xmlStream.writeCharacters(quote.Ordering_District__c);
        }
        xmlStream.writeEndElement();
        
        xmlStream.writeStartElement(NULL, 'CF$_QUOTE_ID', NULL);
        if(quote.Name!=NULL){
            xmlStream.writeCharacters(quote.Name);
        }
        xmlStream.writeEndElement();
        
        xmlStream.writeStartElement(NULL, 'CF$_QUOTE_TYPE', NULL);
        if(quote.SBQQ__Opportunity2__r.Quote_Type__c!=NULL){
            xmlStream.writeCharacters(quote.SBQQ__Opportunity2__r.Quote_Type__c);
        }
        xmlStream.writeEndElement();
        
        xmlStream.writeStartElement(NULL, 'CF$_OPPORTUNITY_TYPE', NULL);
        if(quote.SBQQ__Opportunity2__r.Type!=NULL){
            xmlStream.writeCharacters(quote.SBQQ__Opportunity2__r.Type);
        }
        xmlStream.writeEndElement();

        // begin ORDER_LINE_LIST
        integer lineNo=1;
        Map<String,integer> lineNoMap = new Map<String,integer>();
        Map<String,integer> relNoMap = new Map<String,integer>();       
        if((quote.SBQQ__LineItems__r).size()>0){            
            xmlStream.writeStartElement(NULL, 'ORDER_LINE_LIST', NULL); 
            for(SBQQ__QuoteLine__c quoteLine : quote.SBQQ__LineItems__r){             
                
                xmlStream.writeStartElement(NULL, 'ORDER_LINE', NULL);// begin of ORDER_LINE

                xmlStream.writeStartElement(NULL, 'ORDER_NO', NULL);
                if(quote.Order_Number__c!=NULL){
                    xmlStream.writeCharacters(quote.Order_Number__c);
                } 
                xmlStream.writeEndElement();
                
                xmlStream.writeStartElement(NULL, 'EXTERNAL_FIELD_ID', NULL);
                if(quoteLine.SBQQ__OriginalQuoteLineId__c!=NULL){
                    xmlStream.writeCharacters(String.valueof(quoteLine.SBQQ__OriginalQuoteLineId__c)); 
                }                
                xmlStream.writeEndElement();
                
                xmlStream.writeStartElement(NULL, 'CATALOG_NO', NULL);                
                /*Id currentId=wizardBaseDataProcessor.getCustomObjectIDbyLine(quoteLine.Id);
                GenericUtilityForXML generic=new GenericUtilityForXML();
                //HandlerInterface genUtil = generic.getUtilityInstance(quoteLine.PARTNUMBER__c,currentId);
                HandlerInterface genUtil = generic.getUtilityInstance(quoteLine.SBQQ__ProductCode__c,currentId);
                Result res=genUtil.getPartNumber();             
                if(res.strRetValue != NULL && res.strRetValue != ''){
                        String CatalogNo=(res.strRetValue).toUpperCase();                                                   
                       xmlStream.writeCharacters(CatalogNo);
                }*/
                result res=wizardBaseDataProcessor.getPartNumberByQuoteLine(quoteLine.Id);
                if(res.strRetValue!=NULL){                  
                    xmlStream.writeCharacters(res.strRetValue); 
                }                
                xmlStream.writeEndElement();

                xmlStream.writeStartElement(NULL, 'LINE_NO', NULL);
                if(quoteLine.Line_Number__c!=NULL){
                    xmlStream.writeCharacters(String.valueof(quoteLine.Line_Number__c)); 
                }else if(quoteLine.QuoteLineNumber__c!=NULL){
                    xmlStream.writeCharacters(String.valueof(quoteLine.QuoteLineNumber__c)); 
                }                                   
                xmlStream.writeEndElement();

                xmlStream.writeStartElement(NULL, 'REL_NO', NULL);
                if(quoteLine.Delivery_Number__c!=NULL){
                    //xmlStream.writeCharacters(String.valueof(quoteLine.SBQQ__Number__c));
                    xmlStream.writeCharacters(String.valueof(quoteLine.Delivery_Number__c));    
                }               
                xmlStream.writeEndElement();

                xmlStream.writeStartElement(NULL, 'BUY_QTY_DUE', NULL);
                if(quoteLine.SBQQ__Quantity__c!=NULL){
                    xmlStream.writeCharacters(String.valueof(quoteLine.SBQQ__Quantity__c)); 
                }
                xmlStream.writeEndElement();
                
                xmlStream.writeStartElement(NULL, 'WANTED_DELIVERY_DATE', NULL);
                if(quoteLine.Wanted_Delivery_Date__c!=NULL){                   
                    Date d = quoteLine.Wanted_Delivery_Date__c;
                    String dateStr= String.valueof(d);
                    dateStr=dateStr+'T00:00:00';                    
                    xmlStream.writeCharacters(dateStr);  
                }else if(quote.Wanted_Delivery_Date__c!=NULL){            
                    Date d = quote.Wanted_Delivery_Date__c;
                    String dateStr= String.valueof(d);
                    dateStr=dateStr+'T00:00:00';            
                    xmlStream.writeCharacters(dateStr);
                }
                xmlStream.writeEndElement();

                xmlStream.writeStartElement(NULL, 'PLANNED_DELIVERY_DATE', NULL);
                if(quoteLine.Planned_Delivery_Date__c!=NULL){                   
                    Date d = quoteLine.Planned_Delivery_Date__c;
                    String dateStr= String.valueof(d);
                    dateStr=dateStr+'T00:00:00';                    
                    xmlStream.writeCharacters(dateStr);  
                }else if(quote.Planned_Delivery_Date__c!=NULL){            
                    Date d = quote.Planned_Delivery_Date__c;
                    String dateStr= String.valueof(d);
                    dateStr=dateStr+'T00:00:00';            
                    xmlStream.writeCharacters(dateStr);
                }
                xmlStream.writeEndElement();

                xmlStream.writeStartElement(NULL, 'SUPPLY_CODE_DB', NULL);
                if(quoteLine.Supply_Code__c!=NULL){
                    xmlStream.writeCharacters(quoteLine.Supply_Code__c); 
                }
                xmlStream.writeEndElement();

                if(quoteLine.Supply_Code__c!=NULL && (quoteLine.Supply_Code__c=='IPT' || quoteLine.Supply_Code__c=='IPD')){
                    xmlStream.writeStartElement(NULL, 'VENDOR_NO', NULL);
                    if(quoteLine.Vendor__c!=NULL){
                        xmlStream.writeCharacters(quoteLine.Vendor__c); 
                    }
                    xmlStream.writeEndElement();
                }

                xmlStream.writeStartElement(NULL, 'SALE_UNIT_PRICE', NULL);
                if(quoteLine.Net_Price_Each_Cust_Curr__c!=NULL){
                    xmlStream.writeCharacters(String.valueof(quoteLine.Net_Price_Each_Cust_Curr__c)); 
                }else{
                    xmlStream.writeCharacters('0');
                }
                xmlStream.writeEndElement();

                xmlStream.writeStartElement(NULL, 'SHIP_ADDR_NO', NULL);
                if(quote.Shipping_Account__r.Account_Number__c !=NULL){
                    xmlStream.writeCharacters(quote.Shipping_Account__r.Account_Number__c); 
                }
                xmlStream.writeEndElement();

               xmlStream.writeStartElement(NULL, 'DELIVERY_TERMS', NULL);
                if(quote.Delivery_Terms__c !=NULL){
                    xmlStream.writeCharacters(quote.Delivery_Terms__c); 
                } 
                xmlStream.writeEndElement();

               xmlStream.writeStartElement(NULL, 'DELIVERY_TYPE', NULL);
                if(quote.Shipment_Type__c !=NULL){
                    xmlStream.writeCharacters(quote.Shipment_Type__c); 
                } 
                xmlStream.writeEndElement();

                xmlStream.writeStartElement(NULL, 'SHIP_VIA_CODE', NULL);
                if(quote.Ship_Via__c !=NULL){
                    xmlStream.writeCharacters(quote.Ship_Via__c); 
                } 
                xmlStream.writeEndElement();

                xmlStream.writeStartElement(NULL, 'SHIPMENT_CREATION', NULL);
                if(quoteLine.Shipment_Creation__c!=NULL){
                    xmlStream.writeCharacters(quoteLine.Shipment_Creation__c); 
                }
                xmlStream.writeEndElement();

                xmlStream.writeStartElement(NULL, 'REGION_CODE', NULL);
                if(quote.Ordering_Region__c !=NULL){
                    xmlStream.writeCharacters(quote.Ordering_Region__c); 
                }
                xmlStream.writeEndElement();

                xmlStream.writeStartElement(NULL, 'DISTRICT_CODE', NULL);
                if(quote.Delivery_District__c !=NULL){
                    xmlStream.writeCharacters(quote.Delivery_District__c); 
                } 
                xmlStream.writeEndElement();

                xmlStream.writeStartElement(NULL, 'PRIORITY', NULL);
                if(quoteLine.Priority__c!=NULL){
                    xmlStream.writeCharacters(quoteLine.Priority__c); 
                }
                xmlStream.writeEndElement();
                
                xmlStream.writeStartElement(NULL, 'CUSTOMER_PART_NO', NULL);
                if(quoteLine.Customer_s_Part_No__c!=NULL){
                    xmlStream.writeCharacters(quoteLine.Customer_s_Part_No__c); 
                }
                xmlStream.writeEndElement();

                xmlStream.writeStartElement(NULL, 'TAGGING_INFO', NULL);
                if(quoteLine.Tag_Number__c!=NULL){
                    xmlStream.writeCharacters(quoteLine.Tag_Number__c); 
                }
                xmlStream.writeEndElement();

                xmlStream.writeStartElement(NULL, 'MILESTONE_TEMPLATE_ID', NULL);
                if(quoteLine.Milestone_Template_Id__c!=NULL){
                    String localVar=quoteLine.Milestone_Template_Id__c;            
                    xmlStream.writeCharacters(localVar.toUpperCase());                    
                } 
                xmlStream.writeEndElement();

                /*xmlStream.writeStartElement(NULL, 'LINE_DISCOUNT_LIST', NULL); // begin LINE_DISCOUNT_LIST
                xmlStream.writeStartElement(NULL, 'DISCOUNT', NULL); // begin discount

                xmlStream.writeStartElement(NULL, 'DISCOUNT_TYPE', NULL);               
                xmlStream.writeCharacters('G'); 
                xmlStream.writeEndElement();

                xmlStream.writeStartElement(NULL, 'DISCOUNT', NULL); 
                if(quoteLine.Discount__c!=NULL){
                    //xmlStream.writeCharacters(String.valueof(quoteLine.Discount__c));
                    xmlStream.writeCharacters('0'); 
                }else{
                    xmlStream.writeCharacters('0'); 
                } 
                xmlStream.writeEndElement();

                xmlStream.writeEndElement();// end DISCOUNT
                xmlStream.writeEndElement();//end LINE_DISCOUNT_LIST*/

                if(quote.Sold_By_Rep__c != NULL || quote.Destination_Rep__c != NULL || quote.Eng_Rep_1__c != NULL || quote.Eng_Rep_2__c != NULL){
                    xmlStream.writeStartElement(NULL, 'LINE_COMMISSION_LIST', NULL);//begin of LINE_COMMISSION_LIST

                    if(quote.Sold_By_Rep__c != NULL){
                        xmlStream.writeStartElement(NULL, 'COMMISSION', NULL);// begin of COMMISSION 
                        
                        xmlStream.writeStartElement(NULL, 'COMMISSION_PERCENTAGE', NULL);
                        /*if(quote.Sold_By_Commission_Percent__c!=NULL){
                            xmlStream.writeCharacters(String.valueof(quote.Sold_By_Commission_Percent__c)); 
                        }*/
                        if(quoteLine.Adjusted_Commission_PCT__c!=NULL){
                            xmlStream.writeCharacters(String.valueof(quoteLine.Adjusted_Commission_PCT__c)); 
                        }
                        xmlStream.writeEndElement(); 

                        xmlStream.writeStartElement(NULL, 'COMMISSION_RECEIVER', NULL);
                        if(quote.Sold_By_Rep__r.Rep_Code__c != NULL){
                            xmlStream.writeCharacters(quote.Sold_By_Rep__r.Rep_Code__c);
                        }                       
                        xmlStream.writeEndElement();

                        xmlStream.writeStartElement(NULL, 'COMMISSION_SPLIT', NULL);
                        if(quote.Commission_Split_Sold_By_Rep__c!=NULL){
                            xmlStream.writeCharacters(String.valueof(quote.Commission_Split_Sold_By_Rep__c)); 
                        }                       
                        xmlStream.writeEndElement(); 
                        
                        xmlStream.writeEndElement();// end of COMMISSION
                    }
                    
                    if(quote.Destination_Rep__c != NULL){
                        xmlStream.writeStartElement(NULL, 'COMMISSION', NULL);// begin of COMMISSION 
                        
                        xmlStream.writeStartElement(NULL, 'COMMISSION_PERCENTAGE', NULL);
                        /*if(quote.Destination_Rep_Commission_Percent__c!=NULL){
                            xmlStream.writeCharacters(String.valueof(quote.Destination_Rep_Commission_Percent__c)); 
                        }*/
                        if(quoteLine.Adjusted_Commission_PCT__c!=NULL){
                            xmlStream.writeCharacters(String.valueof(quoteLine.Adjusted_Commission_PCT__c)); 
                        }
                        xmlStream.writeEndElement(); 

                        xmlStream.writeStartElement(NULL, 'COMMISSION_RECEIVER', NULL);
                        if(quote.Destination_Rep__r.Rep_Code__c != NULL){
                        xmlStream.writeCharacters(quote.Destination_Rep__r.Rep_Code__c);
                        }
                        xmlStream.writeEndElement();

                        xmlStream.writeStartElement(NULL, 'COMMISSION_SPLIT', NULL);
                        if(quote.Commission_Split_Dest_Rep__c!=NULL){
                            xmlStream.writeCharacters(String.valueof(quote.Commission_Split_Dest_Rep__c)); 
                        }
                        xmlStream.writeEndElement(); 
                        
                        xmlStream.writeEndElement();// end of COMMISSION
                    }
                    if(quote.Eng_Rep_1__c != NULL){
                        xmlStream.writeStartElement(NULL, 'COMMISSION', NULL);// begin of COMMISSION 
                        
                        xmlStream.writeStartElement(NULL, 'COMMISSION_PERCENTAGE', NULL);
                        /*if(quote.Eng_Rep_1_Commission_Percent__c!=NULL){
                            xmlStream.writeCharacters(String.valueof(quote.Eng_Rep_1_Commission_Percent__c)); 
                        }*/
                        if(quoteLine.Adjusted_Commission_PCT__c!=NULL){
                            xmlStream.writeCharacters(String.valueof(quoteLine.Adjusted_Commission_PCT__c)); 
                        }
                        xmlStream.writeEndElement(); 

                        xmlStream.writeStartElement(NULL, 'COMMISSION_RECEIVER', NULL);
                        if(quote.Eng_Rep_1__r.Rep_Code__c != NULL){
                           // xmlStream.writeCharacters(quote.Eng_Rep_1__r.Rep_Code__c);
                            xmlStream.writeCharacters(quote.Eng_Rep_1__r.Rep_Code__c);
                            
                        }
                        xmlStream.writeEndElement();

                        xmlStream.writeStartElement(NULL, 'COMMISSION_SPLIT', NULL);
                        if(quote.Commission_Split_Eng_Rep_1__c!=NULL){
                            xmlStream.writeCharacters(String.valueof(quote.Commission_Split_Eng_Rep_1__c)); 
                        } 
                        xmlStream.writeEndElement();
                        
                        xmlStream.writeEndElement();// end of COMMISSION
                    }
                    
                    if(quote.Eng_Rep_2__c != NULL){
                        xmlStream.writeStartElement(NULL, 'COMMISSION', NULL);// begin of COMMISSION 
                        
                        xmlStream.writeStartElement(NULL, 'COMMISSION_PERCENTAGE', NULL);
                        /*if(quote.Eng_Rep_2_Commission_Percent__c!=NULL){
                            xmlStream.writeCharacters(String.valueof(quote.Eng_Rep_2_Commission_Percent__c)); 
                        }*/
                        if(quoteLine.Adjusted_Commission_PCT__c!=NULL){
                            xmlStream.writeCharacters(String.valueof(quoteLine.Adjusted_Commission_PCT__c)); 
                        }
                        xmlStream.writeEndElement(); 

                        xmlStream.writeStartElement(NULL, 'COMMISSION_RECEIVER', NULL);
                        if(quote.Eng_Rep_2__r.Rep_Code__c != NULL){
                            xmlStream.writeCharacters(quote.Eng_Rep_2__r.Rep_Code__c);
                        }
                        xmlStream.writeEndElement();

                        xmlStream.writeStartElement(NULL, 'COMMISSION_SPLIT', NULL);
                        if(quote.Commission_Split_Eng_Rep_2__c!=NULL){
                            xmlStream.writeCharacters(String.valueof(quote.Commission_Split_Eng_Rep_2__c)); 
                        } 
                        xmlStream.writeEndElement(); 
                        
                        xmlStream.writeEndElement();// end of COMMISSION
                    }

                    xmlStream.writeEndElement();// end of LINE_COMMISSION_LIST
                }
                
                xmlStream.writeStartElement(NULL, 'CF$_SAME_AS', NULL);
                if(quoteLine.Same_As_Reference__c != NULL) {           
                    xmlStream.writeCharacters(quoteLine.Same_As_Reference__c);                    
                } 
                xmlStream.writeEndElement();

                xmlStream.writeStartElement(NULL, 'LINE_DOCUMENT_LIST', NULL);//begin of LINE_DOCUMENT_LIST            
                List<ContentVersion> files = new List<ContentVersion>();
                if(fileMap.get(quoteLine.Id)!=NULL){
                    files= fileMap.get(quoteLine.Id);
                }
                if(files.size()>0){
                    for(ContentVersion eachFile : files){
                        String publicLink='';
                        if(publicLinks.get(eachFile.Id)!=NULL){
                            publicLink=publicLinks.get(eachFile.Id);    
                        }
                        xmlStream = IFS_ConstructDocumentTag.generateReq(xmlStream,eachFile,publicLink);
                    }
                }
                xmlStream.writeEndElement();// end of LINE_DOCUMENT_LIST

                xmlStream.writeEndElement();//end of ORDER_LINE                
            } 
            xmlStream.writeEndElement();//end of ORDER_LINE_LIST 
        } 
        //end of ORDER_LINE_LIST
        
        if(quote.Change_Order_Log__c !=NULL){
            xmlStream.writeStartElement(NULL, 'CHANGE_ORDER_REC', NULL);//begin of CHANGE_ORDER_REC
            xmlStream.writeStartElement(NULL, 'CHANGE_ORDER', NULL);// begin of CHANGE_ORDER

            xmlStream.writeStartElement(NULL, 'INFORMATION', NULL);
            xmlStream.writeCharacters(quote.Change_Order_Log__c);           
            xmlStream.writeEndElement();

            xmlStream.writeStartElement(NULL, 'ECO_CAUSE', NULL);
            if(quote.CO_Clause__c !=NULL){
                xmlStream.writeCharacters(quote.CO_Clause__c); 
            } else {xmlStream.writeCharacters('No details provided'); }
            xmlStream.writeEndElement();

            xmlStream.writeEndElement();// end of CHANGE_ORDER
            xmlStream.writeEndElement();// end of CHANGE_ORDER_REC
        }

        xmlStream.writeStartElement(NULL, 'FREIGHT_REC', NULL);//begin of FREIGHT_RE
        xmlStream.writeStartElement(NULL, 'FREIGHT', NULL);// begin of FREIGHT
        //if(quote.Freight_Information__c != NULL){
            
            xmlStream.writeStartElement(NULL, 'ORDER_NO', NULL);
            if(quote.Order_Number__c !=NULL){
                //xmlStream.writeCharacters(quote.IFS_Order_Number__c);
                xmlStream.writeCharacters(quote.Order_Number__c);    
            }
            xmlStream.writeEndElement(); 

            xmlStream.writeStartElement(NULL, 'BILLING_OPTION_FEDEX', NULL);
            if(quote.Freight_Information__c != NULL && quote.Freight_Information__r.Entity__c !=NULL && quote.Freight_Information__r.Entity__c =='FedEx'){
                xmlStream.writeCharacters(quote.Freight_Information__r.Bill_To__c); 
            }
            xmlStream.writeEndElement();

            xmlStream.writeStartElement(NULL, 'BILLING_OPTION_UPS', NULL);
            if(quote.Freight_Information__c != NULL && quote.Freight_Information__r.Entity__c !=NULL && quote.Freight_Information__r.Entity__c =='UPS'){
                xmlStream.writeCharacters(quote.Freight_Information__r.Bill_To__c);
            }
            xmlStream.writeEndElement();

            xmlStream.writeStartElement(NULL, 'CUSTOMER_FEDEX_ACCOUNT', NULL);
            if(quote.Freight_Information__c != NULL && quote.Freight_Information__r.Account_Number__c !=NULL && quote.Freight_Information__r.Entity__c =='FedEx'){        
                String localVar=quote.Freight_Information__r.Account_Number__c;            
                xmlStream.writeCharacters(localVar.toUpperCase());  
            }
            xmlStream.writeEndElement();

            xmlStream.writeStartElement(NULL, 'CUSTOMER_UPS_ACCOUNT', NULL);
            if(quote.Freight_Information__c != NULL && quote.Freight_Information__r.Account_Number__c !=NULL && quote.Freight_Information__r.Entity__c =='UPS'){          
                String localVar=quote.Freight_Information__r.Account_Number__c;            
                xmlStream.writeCharacters(localVar.toUpperCase());          
            }
            xmlStream.writeEndElement();

            xmlStream.writeStartElement(NULL, 'FREIGHT_EMAIL', NULL);
            if(quote.Freight_Information__c != NULL && quote.Freight_Information__r.Freight_Contact_Email__c !=NULL){
                xmlStream.writeCharacters(quote.Freight_Information__r.Freight_Contact_Email__c); 
            }
            xmlStream.writeEndElement();

            xmlStream.writeStartElement(NULL, 'FREIGHT_PHONE', NULL);
            if(quote.Freight_Information__c != NULL && quote.Freight_Information__r.Freight_Contact_Phone__c !=NULL){
                xmlStream.writeCharacters(quote.Freight_Information__r.Freight_Contact_Phone__c); 
            }
            xmlStream.writeEndElement();
        //}
        xmlStream.writeEndElement();// end of FREIGHT
        xmlStream.writeEndElement();// end of FREIGHT_REC


        xmlStream.writeStartElement(NULL, 'ORDER_CHARGE_LIST', NULL);//begin of ORDER_CHARGE_LIST        
        if((quote.Charges__r).size()>0){
            for(Charge__c charge : quote.Charges__r){
                xmlStream.writeStartElement(NULL, 'CHARGE', NULL);// begin of CHARGE

                xmlStream.writeStartElement(NULL, 'SF_CHARGE_SEQ', NULL);
                if(charge.Sequence__c !=NULL){
                    xmlStream.writeCharacters(String.valueof(charge.Sequence__c)); 
                }
                xmlStream.writeEndElement(); 

                xmlStream.writeStartElement(NULL, 'CHARGE_TYPE', NULL);
                if(charge.Type__c !=NULL){
                    xmlStream.writeCharacters(charge.Type__c); 
                }
                xmlStream.writeEndElement();

                xmlStream.writeStartElement(NULL, 'CHARGE_AMOUNT', NULL);
                if(charge.Amount__c !=NULL){
                    xmlStream.writeCharacters(String.valueof(charge.Amount__c)); 
                }
                xmlStream.writeEndElement();

                xmlStream.writeStartElement(NULL, 'CHARGE_QTY', NULL);
                if(charge.Quantity__c !=NULL){
                    xmlStream.writeCharacters(String.valueof(charge.Quantity__c)); 
                }
                xmlStream.writeEndElement(); 

                xmlStream.writeStartElement(NULL, 'STATUS', NULL);
                if(charge.Status__c !=NULL){
                    xmlStream.writeCharacters(charge.Status__c); 
                }
                xmlStream.writeEndElement();
                
                xmlStream.writeStartElement(NULL, 'CF$_CHARGE_DESCRIPTION', NULL);
                if(charge.Status__c !=NULL){
                    xmlStream.writeCharacters(charge.Comments__c); 
                }
                xmlStream.writeEndElement();

                xmlStream.writeEndElement();// end of CHARGE
            }
        }
        xmlStream.writeEndElement();// end of ORDER_CHARGE_LIST

        //2nd time document is coming 
        xmlStream.writeStartElement(NULL, 'DOCUMENT_LIST', NULL);//begin of DOCUMENT_LIST        
        List<ContentVersion> files = new List<ContentVersion>();
        if(fileMap.get(quote.Id)!=NULL){
            files= fileMap.get(quote.Id);
        }
        if(files.size()>0){
            for(ContentVersion eachFile : files){
                String publicLink='';
                if(publicLinks.get(eachFile.Id)!=NULL){
                    publicLink=publicLinks.get(eachFile.Id);    
                }
                xmlStream = IFS_ConstructDocumentTag.generateReq(xmlStream,eachFile,publicLink);              
            }
        }
        xmlStream.writeEndElement();// end of DOCUMENT_LIST

        xmlStream.writeEndElement(); // end of customer
        xmlStream.writeEndElement(); // end of customer rec

        xmlStream.writeEndElement(); // end of customer oder
        xmlStream.writeEndElement(); // end of body
        xmlStream.writeEndElement(); // end of envelope  
        
        String xmlRequest = xmlStream.getXMLString();
        return xmlRequest;
    }

}