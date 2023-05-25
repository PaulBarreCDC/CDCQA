/*********************************************************************************
* Class Name: IFS_ConstructCustomerReq
* This class constructs cusomer XML request from Account data for IFS Integration
*********************************************************************************/
public class IFS_ConstructCustReq{
    
    public void IFS_ConstructCustReq(){    
    }
    
    public static String generateReq(String accountId,String quoteId){
        
        SBQQ__Quote__c quote = [SELECT Ship_Via__c,Delivery_Terms__c,Shipment_Type__c,Freight_Information__c,Freight_Information__r.Entity__c,Freight_Information__r.Account__c,Freight_Information__r.Account__r.Account_Number__c,Freight_Information__r.Account_Number__c,Freight_Information__r.Bill_To__c,Shipping_Account__r.Account_Number__c,Shipping_Account__r.BillingStreet,
                                    Shipping_Account__r.BillingCity,Shipping_Account__r.Name,Shipping_Account__c,Shipping_Account__r.BillingState,Shipping_Account__r.BillingCountry,Shipping_Account__r.BillingPostalCode,Shipping_Account__r.BillingCountryCode,
                                    SBQQ__Account__r.Account_Number__c,SBQQ__Account__r.Name,SBQQ__Account__r.BillingStreet,SBQQ__Account__c,
                                    SBQQ__Account__r.BillingCity,SBQQ__Account__r.BillingState,SBQQ__Account__r.BillingCountry,SBQQ__Account__r.BillingPostalCode,SBQQ__Account__r.BillingCountryCode
                                    ,SBQQ__Opportunity2__r.CurrencyIsoCode
,SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c,SBQQ__Opportunity2__r.Contact__r.Name,SBQQ__Opportunity2__r.Contact__r.Description,SBQQ__Opportunity2__r.Contact__r.Phone,SBQQ__Opportunity2__r.Contact__r.Email,SBQQ__Opportunity2__r.Contact__r.Fax,SBQQ__Opportunity2__r.Contact__r.Primary_Contact_For_Account__c 
                                FROM SBQQ__Quote__c 
                WHERE id=:quoteId limit 1];                 
                        
        Account acc = [SELECT id,Name,Account_Number__c,
                            Visibility_Customer_ID__c,
            Rep_Code_District__c,Rep_Code_Region__c,
            CurrencyIsoCode,Type,Payment_Terms__c,Credit_Limit__c,
            Parent.Hierarchy_Group__c,BillingCountryCode
        FROM Account 
        WHERE id=:accountId Limit 1];
        
        String [] companies=new String[]{'10','20','30','40'};
        String [] addressTypes=new String[]{'Delivery','Home','Document','Pay','PrimaryContact','SecondardContact','Visit'};
        
        XmlStreamWriter xmlStream = new XmlStreamWriter();
        
        xmlStream.writeStartElement('soap','Envelope','http://schemas.xmlsoap.org/soap/envelope/');
        xmlStream.writeNamespace('soap','http://schemas.xmlsoap.org/soap/envelope/');   
        xmlStream.writeStartElement('soap','Body','');
        
        xmlStream.writeStartElement('','CUSTOMER_INFO','urn:ifsworld-com:schemas:inbound_sales_force_cpq_int_receive_customer_info_request');
        xmlStream.writeNamespace('xsi','http://www.w3.org/2001/XMLSchema-instance');
        xmlStream.writeNamespace('','urn:ifsworld-com:schemas:inbound_sales_force_cpq_int_receive_customer_info_request');             
        
        xmlStream.writeStartElement('', 'SF_MESSAGE_ID', '');
        xmlStream.writeCharacters('NO_MAPPING'); 
        xmlStream.writeEndElement();
        
        xmlStream.writeStartElement('', 'CUSTOMER_REC', '');//begin of CUSTOMER_REC
        xmlStream.writeStartElement('', 'CUSTOMER', '');// begin of CUSTOMER

        xmlStream.writeStartElement('', 'CUSTOMER_NO', '');
        /*if(acc.Id !=NULL){
            String accId=acc.Id;  
            xmlStream.writeCharacters(accId.toUpperCase()); 
        }*/
        if(acc.Account_Number__c !=NULL){              
            xmlStream.writeCharacters(acc.Account_Number__c); 
        }
        
        xmlStream.writeEndElement(); 

        xmlStream.writeStartElement('', 'CUSTOMER_NAME', '');
        if(acc.Name !=NULL){
            xmlStream.writeCharacters(acc.Name); 
        }
        xmlStream.writeEndElement(); 

        xmlStream.writeStartElement('', 'HIERARCHY', '');
        if(acc.Parent.Hierarchy_Group__c !=NULL){
            String localVar=acc.Parent.Hierarchy_Group__c;           
            xmlStream.writeCharacters(localVar.toUpperCase());             
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'COUNTRY_DB', '');
        if(acc.BillingCountryCode !=NULL){
            xmlStream.writeCharacters(acc.BillingCountryCode); 
        } 
        xmlStream.writeEndElement(); 

        xmlStream.writeStartElement('', 'CUSTOMER_INFO_ADDRESS_LIST', '');//begin of CUSTOMER_INFO_ADDRESS_LIST
        
        //Billing Address
        xmlStream.writeStartElement('', 'CUSTOMER_INFO_ADDRESS', '');// begin of CUSTOMER_INFO_ADDRESS
        
        xmlStream.writeStartElement('', 'ADDRESS_ID', '');
        if(quote.SBQQ__Account__r.Account_Number__c!=NULL){
            xmlStream.writeCharacters(quote.SBQQ__Account__r.Account_Number__c);
        }
        /*if(quote.SBQQ__Account__c !=NULL){
            xmlStream.writeCharacters(((string)(quote.SBQQ__Account__c)).toUpperCase());
        }*/
        xmlStream.writeEndElement(); 

        xmlStream.writeStartElement('', 'CUSTOMER_NAME', '');
        if(quote.SBQQ__Account__r.Name!=NULL){
            xmlStream.writeCharacters(quote.SBQQ__Account__r.Name);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'ADDRESS_1', '');
        if(quote.SBQQ__Account__r.BillingStreet!=NULL){
            xmlStream.writeCharacters(quote.SBQQ__Account__r.BillingStreet);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'ADDRESS_2', '');
        /*if(quote.SBQQ__Account__r.BillingStreet!=NULL){
            xmlStream.writeCharacters(quote.SBQQ__Account__r.BillingStreet); 
        }*/
        xmlStream.writeEndElement();
        
        xmlStream.writeStartElement('', 'CITY', '');
        if(quote.SBQQ__Account__r.BillingCity!=NULL){
            xmlStream.writeCharacters(quote.SBQQ__Account__r.BillingCity);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'STATE', '');
        if(quote.SBQQ__Account__r.BillingState!=NULL){
            xmlStream.writeCharacters(quote.SBQQ__Account__r.BillingState);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'COUNTY', '');
        if(quote.SBQQ__Account__r.BillingCountry!=NULL){
            xmlStream.writeCharacters(quote.SBQQ__Account__r.BillingCountry); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'ZIP_CODE', '');
        if(quote.SBQQ__Account__r.BillingPostalCode!=NULL){
            xmlStream.writeCharacters(quote.SBQQ__Account__r.BillingPostalCode); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'COUNTRY_DB', '');
        if(quote.SBQQ__Account__r.BillingCountryCode!=NULL){
            xmlStream.writeCharacters(quote.SBQQ__Account__r.BillingCountryCode); 
        }
        xmlStream.writeEndElement();


        xmlStream.writeStartElement('', 'ORDER_ADDRESS_LIST', '');//begin of ORDER_ADDRESS_LIST
        xmlStream.writeStartElement('', 'ORDER_ADDRESS_INFO', '');// begin of ORDER_ADDRESS_INFO
        
        xmlStream.writeStartElement('', 'DELIVERY_TERMS', '');
        if(quote.Delivery_Terms__c!=NULL){
            xmlStream.writeCharacters(quote.Delivery_Terms__c); 
        }
        xmlStream.writeEndElement();        

        xmlStream.writeStartElement('', 'SHIP_VIA_CODE', '');
        if(quote.Ship_Via__c!=NULL){
            xmlStream.writeCharacters(quote.Ship_Via__c); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'SHIPMENT_TYPE', '');
        if(quote.Shipment_Type__c!=NULL){
            xmlStream.writeCharacters(quote.Shipment_Type__c); 
        }
        xmlStream.writeEndElement();        

        xmlStream.writeStartElement('', 'DISTRICT_CODE', '');
        if(acc.Rep_Code_District__c!=NULL){
            xmlStream.writeCharacters(acc.Rep_Code_District__c); 
        }
        xmlStream.writeEndElement();
              
        xmlStream.writeStartElement('', 'REGION_CODE', '');
        if(acc.Rep_Code_Region__c!=NULL){
            xmlStream.writeCharacters(acc.Rep_Code_Region__c);
        }      
        xmlStream.writeEndElement();
                
        xmlStream.writeEndElement(); //end of ORDER_ADDRESS_INFO
        xmlStream.writeEndElement(); //end of ORDER_ADDRESS_LIST


        xmlStream.writeStartElement('', 'DELIVERY_TAX_INFO_LIST', '');//begin of DELIVERY_TAX_INFO_LIST
        for(String eachCompany:companies){
            xmlStream.writeStartElement('', 'DELIVERY_TAX_INFO', '');// begin of DELIVERY_TAX_INFO

            xmlStream.writeStartElement('', 'COMPANY_ID', '');
            xmlStream.writeCharacters(eachCompany); 
            xmlStream.writeEndElement();        

            xmlStream.writeEndElement();// end of DELIVERY_TAX_INFO
        }
        xmlStream.writeEndElement();// end of DELIVERY_TAX_INFO_LIST


        //start of COMM_METHOD_LIST
        xmlStream.writeStartElement('','COMM_METHOD_LIST','');
        xmlStream.writeStartElement('','COMM_METHOD','');

        xmlStream.writeStartElement('', 'COMM_ID', '');
        if(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c != NULL){
            if(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'PHONE'){
                xmlStream.writeCharacters('1');
            }else if(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'E_MAIL'){
                xmlStream.writeCharacters('2');
            }else if(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'FAX'){
                xmlStream.writeCharacters('3');
            }            
        }       
        xmlStream.writeEndElement();
                        
        xmlStream.writeStartElement('', 'NAME', '');
        xmlStream.writeCharacters(quote.SBQQ__Opportunity2__r.Contact__r.Name); 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'DESCRIPTION', '');
        if(quote.SBQQ__Opportunity2__r.Contact__r.Description != NULL){
            xmlStream.writeCharacters(quote.SBQQ__Opportunity2__r.Contact__r.Description); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'METHOD_ID', '');
        if(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c != NULL){
            xmlStream.writeCharacters(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c); 
        }
        xmlStream.writeEndElement();
          
        xmlStream.writeStartElement('', 'VALUE', '');
        if(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'PHONE' && quote.SBQQ__Opportunity2__r.Contact__r.Phone != NULL){     
            xmlStream.writeCharacters(quote.SBQQ__Opportunity2__r.Contact__r.Phone);     
        }else if(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'E_MAIL' && quote.SBQQ__Opportunity2__r.Contact__r.Email != NULL){    
            xmlStream.writeCharacters(quote.SBQQ__Opportunity2__r.Contact__r.Email);     
        }else if(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'FAX' && quote.SBQQ__Opportunity2__r.Contact__r.Fax != NULL){      
            xmlStream.writeCharacters(quote.SBQQ__Opportunity2__r.Contact__r.Fax);       
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'METHOD_DEFAULT', '');
        if(quote.SBQQ__Opportunity2__r.Contact__r.Primary_Contact_For_Account__c!=NULL && quote.SBQQ__Opportunity2__r.Contact__r.Primary_Contact_For_Account__c){
            xmlStream.writeCharacters('TRUE'); 
        }else{
            xmlStream.writeCharacters('FALSE');
        }
        xmlStream.writeEndElement();


        xmlStream.writeEndElement();//end of COMM_METHOD
        xmlStream.writeEndElement();//end of COMM_METHOD_LIST 


        xmlStream.writeStartElement('', 'CUSTOMER_ADDRESS_TYPE_LIST', '');
        for(String eachAddressType:addressTypes){
            xmlStream.writeStartElement('', 'CUSTOMER_ADDRESS_TYPE', '');    
            xmlStream.writeStartElement('', 'ADDRESS_TYPE', '');
            xmlStream.writeCharacters(eachAddressType);             
            xmlStream.writeEndElement();
            xmlStream.writeEndElement();
        }
        xmlStream.writeEndElement();

        xmlStream.writeEndElement(); //end of CUSTOMER_INFO_ADDRESS
        
        //Shipping Address
        xmlStream.writeStartElement('', 'CUSTOMER_INFO_ADDRESS', '');// begin of CUSTOMER_INFO_ADDRESS
        
        xmlStream.writeStartElement('', 'ADDRESS_ID', '');
        if(quote.Shipping_Account__r.Account_Number__c!=NULL){
            xmlStream.writeCharacters(quote.Shipping_Account__r.Account_Number__c);
        }
        /*if(quote.Shipping_Account__c!=NULL){
            xmlStream.writeCharacters(((string)(quote.Shipping_Account__c)).toUpperCase());
        }*/
        xmlStream.writeEndElement(); 

        xmlStream.writeStartElement('', 'CUSTOMER_NAME', '');
        if(quote.Shipping_Account__r.Name!=NULL){
            xmlStream.writeCharacters(quote.Shipping_Account__r.Name);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'ADDRESS_1', '');
        if(quote.Shipping_Account__r.BillingStreet!=NULL){
            xmlStream.writeCharacters(quote.Shipping_Account__r.BillingStreet);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'ADDRESS_2', '');
        /*if(quote.Shipping_Account__r.BillingStreet!=NULL){
            xmlStream.writeCharacters(quote.Shipping_Account__r.BillingStreet); 
        }*/
        xmlStream.writeEndElement();
        
        xmlStream.writeStartElement('', 'CITY', '');
        if(quote.Shipping_Account__r.BillingCity!=NULL){
            xmlStream.writeCharacters(quote.Shipping_Account__r.BillingCity);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'STATE', '');
        if(quote.Shipping_Account__r.BillingState!=NULL){
            xmlStream.writeCharacters(quote.Shipping_Account__r.BillingState);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'COUNTY', '');
        if(quote.Shipping_Account__r.BillingCountry!=NULL){
            xmlStream.writeCharacters(quote.Shipping_Account__r.BillingCountry); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'ZIP_CODE', '');
        if(quote.Shipping_Account__r.BillingPostalCode!=NULL){
            xmlStream.writeCharacters(quote.Shipping_Account__r.BillingPostalCode); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'COUNTRY_DB', '');
        if(quote.Shipping_Account__r.BillingCountryCode!=NULL){
            xmlStream.writeCharacters(quote.Shipping_Account__r.BillingCountryCode); 
        }
        xmlStream.writeEndElement();


        xmlStream.writeStartElement('', 'ORDER_ADDRESS_LIST', '');//begin of ORDER_ADDRESS_LIST
        xmlStream.writeStartElement('', 'ORDER_ADDRESS_INFO', '');// begin of ORDER_ADDRESS_INFO
        
        xmlStream.writeStartElement('', 'DELIVERY_TERMS', '');
        if(quote.Delivery_Terms__c!=NULL){
            xmlStream.writeCharacters(quote.Delivery_Terms__c); 
        }
        xmlStream.writeEndElement();        

        xmlStream.writeStartElement('', 'SHIP_VIA_CODE', '');
        if(quote.Ship_Via__c!=NULL){
            xmlStream.writeCharacters(quote.Ship_Via__c); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'SHIPMENT_TYPE', '');
        if(quote.Shipment_Type__c!=NULL){
            xmlStream.writeCharacters(quote.Shipment_Type__c); 
        }
        xmlStream.writeEndElement();        

        xmlStream.writeStartElement('', 'DISTRICT_CODE', '');
        if(acc.Rep_Code_District__c!=NULL){
            xmlStream.writeCharacters(acc.Rep_Code_District__c); 
        }
        xmlStream.writeEndElement();
              
        xmlStream.writeStartElement('', 'REGION_CODE', '');
        if(acc.Rep_Code_Region__c!=NULL){
            xmlStream.writeCharacters(acc.Rep_Code_Region__c);
        }      
        xmlStream.writeEndElement();
                
        xmlStream.writeEndElement(); //end of ORDER_ADDRESS_INFO
        xmlStream.writeEndElement(); //end of ORDER_ADDRESS_LIST


        xmlStream.writeStartElement('', 'DELIVERY_TAX_INFO_LIST', '');//begin of DELIVERY_TAX_INFO_LIST
        for(String eachCompany:companies){
            xmlStream.writeStartElement('', 'DELIVERY_TAX_INFO', '');// begin of DELIVERY_TAX_INFO

            xmlStream.writeStartElement('', 'COMPANY_ID', '');
            xmlStream.writeCharacters(eachCompany); 
            xmlStream.writeEndElement();        

            xmlStream.writeEndElement();// end of DELIVERY_TAX_INFO
        }
        xmlStream.writeEndElement();// end of DELIVERY_TAX_INFO_LIST


        //start of COMM_METHOD_LIST
        xmlStream.writeStartElement('','COMM_METHOD_LIST','');
        xmlStream.writeStartElement('','COMM_METHOD','');

        xmlStream.writeStartElement('', 'COMM_ID', '');
        if(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c != NULL){
            if(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'PHONE'){
                xmlStream.writeCharacters('1');
            }else if(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'E_MAIL'){
                xmlStream.writeCharacters('2');
            }else if(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'FAX'){
                xmlStream.writeCharacters('3');
            }            
        }       
        xmlStream.writeEndElement();
                        
        xmlStream.writeStartElement('', 'NAME', '');
        xmlStream.writeCharacters(quote.SBQQ__Opportunity2__r.Contact__r.Name); 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'DESCRIPTION', '');
        if(quote.SBQQ__Opportunity2__r.Contact__r.Description != NULL){
            xmlStream.writeCharacters(quote.SBQQ__Opportunity2__r.Contact__r.Description); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'METHOD_ID', '');
        if(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c != NULL){
            xmlStream.writeCharacters(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c); 
        }
        xmlStream.writeEndElement();
          
        xmlStream.writeStartElement('', 'VALUE', '');
        if(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'PHONE' && quote.SBQQ__Opportunity2__r.Contact__r.Phone != NULL){     
            xmlStream.writeCharacters(quote.SBQQ__Opportunity2__r.Contact__r.Phone);     
        }else if(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'E_MAIL' && quote.SBQQ__Opportunity2__r.Contact__r.Email != NULL){    
            xmlStream.writeCharacters(quote.SBQQ__Opportunity2__r.Contact__r.Email);     
        }else if(quote.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'FAX' && quote.SBQQ__Opportunity2__r.Contact__r.Fax != NULL){      
            xmlStream.writeCharacters(quote.SBQQ__Opportunity2__r.Contact__r.Fax);       
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'METHOD_DEFAULT', '');
        if(quote.SBQQ__Opportunity2__r.Contact__r.Primary_Contact_For_Account__c!=NULL && quote.SBQQ__Opportunity2__r.Contact__r.Primary_Contact_For_Account__c){
            xmlStream.writeCharacters('TRUE'); 
        }else{
            xmlStream.writeCharacters('FALSE');
        }
        xmlStream.writeEndElement();


        xmlStream.writeEndElement();//end of COMM_METHOD
        xmlStream.writeEndElement();//end of COMM_METHOD_LIST 


        xmlStream.writeStartElement('', 'CUSTOMER_ADDRESS_TYPE_LIST', '');
       
        xmlStream.writeStartElement('', 'CUSTOMER_ADDRESS_TYPE', '');    
        xmlStream.writeStartElement('', 'ADDRESS_TYPE', '');
        xmlStream.writeCharacters('Delivery');             
        xmlStream.writeEndElement();
        xmlStream.writeEndElement();
        
        xmlStream.writeEndElement();

        xmlStream.writeEndElement(); //end of CUSTOMER_INFO_ADDRESS
            
        
        xmlStream.writeEndElement(); //end of CUSTOMER_INFO_ADDRESS_LIST

        //start of ORDER_INFO_LIST
        xmlStream.writeStartElement('','ORDER_INFO_LIST','');
        xmlStream.writeStartElement('','ORDER_INFO','');

        xmlStream.writeStartElement('', 'CURRENCY_CODE', '');
        if(acc.CurrencyIsoCode!=NULL){
            xmlStream.writeCharacters(acc.CurrencyIsoCode);
        }      
        xmlStream.writeEndElement();
         
        xmlStream.writeStartElement('', 'CUST_GRP', '');        
        if(acc.Type!=NULL){
            xmlStream.writeCharacters((acc.Type).toUpperCase());
        }       
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'SALESMAN_CODE', '');        
        /*if(acc.Rep_Code__c!=NULL){
            xmlStream.writeCharacters(acc.Rep_Code__c); 
        }*/       
        xmlStream.writeEndElement();

        xmlStream.writeEndElement(); //endof order info 
        xmlStream.writeEndElement(); //endof order info rec 

        xmlStream.writeStartElement('','FREIGHT_INTFC_INFO_LIST','');//begin of FREIGHT_INTFC_INFO_LIST
        xmlStream.writeStartElement('','FREIGHT_INTFC_INFO','');//begin of FREIGHT_INTFC_INFO
        if(quote.Freight_Information__c != NULL){ 
            xmlStream.writeStartElement('', 'UPS', '');         
            //String localVar1=quote.Freight_Information__r.Account__c;         
            if(quote.Freight_Information__r.Entity__c == 'UPS' && quote.Freight_Information__r.Bill_To__c    != NULL){
                xmlStream.writeCharacters(quote.Freight_Information__r.Bill_To__c);
            }               
            xmlStream.writeEndElement();
                
            xmlStream.writeStartElement('', 'FEDEX', '');           
            if(quote.Freight_Information__r.Entity__c == 'FedEx' && quote.Freight_Information__r.Bill_To__c  != NULL){
                xmlStream.writeCharacters(quote.Freight_Information__r.Bill_To__c);
            }   
            xmlStream.writeEndElement();

            if(quote.Freight_Information__r.Entity__c == 'UPS' && quote.Freight_Information__r.Account__c != NULL){             
                //start of UPS_ACCOUNT_LIST
                xmlStream.writeStartElement('','UPS_ACCOUNT_LIST','');
                xmlStream.writeStartElement('','FREIGHT_ACCOUNT','');

                xmlStream.writeStartElement('', 'ACCOUNT', '');
                if(quote.Freight_Information__r.Account_Number__c != NULL){                          
                    xmlStream.writeCharacters(quote.Freight_Information__r.Account_Number__c);            
                }               
                xmlStream.writeEndElement();                
                     
                xmlStream.writeStartElement('', 'ADDRESS_ID', '');       
                if(quote.Freight_Information__r.Account__r.Account_Number__c != NULL){                           
                    xmlStream.writeCharacters(quote.Freight_Information__r.Account__r.Account_Number__c);            
                }   
                xmlStream.writeEndElement();
                
                xmlStream.writeStartElement('', 'IS_DEFAULT', '');                 
                xmlStream.writeCharacters('TRUE');              
                xmlStream.writeEndElement();
                

                xmlStream.writeEndElement(); //endof FREIGHT_ACCOUNT
                xmlStream.writeEndElement(); //endof UPS_ACCOUNT_LIST 
            }

            if(quote.Freight_Information__r.Entity__c == 'FedEx' && quote.Freight_Information__r.Account__c != NULL){
                //start of FEDEX_ACCOUNT_LIST
                xmlStream.writeStartElement('','FEDEX_ACCOUNT_LIST','');
                xmlStream.writeStartElement('','FREIGHT_ACCOUNT','');

                xmlStream.writeStartElement('', 'ACCOUNT', '');
                if(quote.Freight_Information__r.Account_Number__c != NULL){                          
                    xmlStream.writeCharacters(quote.Freight_Information__r.Account_Number__c);            
                }   
                xmlStream.writeEndElement();
                     
                xmlStream.writeStartElement('', 'ADDRESS_ID', '');
                if(quote.Freight_Information__r.Account__r.Account_Number__c != NULL){                           
                    xmlStream.writeCharacters(quote.Freight_Information__r.Account__r.Account_Number__c);            
                }      
                xmlStream.writeEndElement();
                    
                xmlStream.writeStartElement('', 'IS_DEFAULT', '');                 
                xmlStream.writeCharacters('TRUE');
                xmlStream.writeEndElement();
                

                xmlStream.writeEndElement(); //endof FEDEX_ACCOUNT_LIST
                xmlStream.writeEndElement(); //endof FREIGHT_ACCOUNT
            }
        }
        xmlStream.writeEndElement(); //endof FREIGHT_INTFC_INFO
        xmlStream.writeEndElement(); //endof FREIGHT_INTFC_INFO_LIST


        //start of INVOICE_INFO_LIST
        xmlStream.writeStartElement('','INVOICE_INFO_LIST','');
        for(String eachCompany:companies){
            xmlStream.writeStartElement('','INVOICE_INFO','');

            xmlStream.writeStartElement('', 'COMPANY', '');
            xmlStream.writeCharacters(eachCompany);
            xmlStream.writeEndElement();        
                  
            xmlStream.writeStartElement('', 'CURRENCY_CODE', '');
            if(quote.SBQQ__Opportunity2__r.CurrencyIsoCode!=NULL){
                xmlStream.writeCharacters(quote.SBQQ__Opportunity2__r.CurrencyIsoCode); 
            }
            xmlStream.writeEndElement();

            xmlStream.writeStartElement('', 'GROUP_ID', '');       
            xmlStream.writeCharacters('0');
            xmlStream.writeEndElement();

            xmlStream.writeStartElement('', 'PAY_TERM_ID', '');
            if(acc.Payment_Terms__c!=NULL){
                xmlStream.writeCharacters(acc.Payment_Terms__c); 
            }
            xmlStream.writeEndElement();

            xmlStream.writeEndElement(); //endof INVOICE_INFO
        }
        xmlStream.writeEndElement(); //endof INVOICE_INFO_LIST 


        //start of IDENTITY_PAY_INFO_LIST
        xmlStream.writeStartElement('','IDENTITY_PAY_INFO_LIST','');
        for(String eachCompany:companies){
            xmlStream.writeStartElement('','IDENTITY_PAY_INFO','');

            xmlStream.writeStartElement('', 'COMPANY', '');
            xmlStream.writeCharacters(eachCompany);
            xmlStream.writeEndElement();        
             
            xmlStream.writeStartElement('', 'AR_CONTACT', '');
            /*if(acc.Payment_Contact__r.Name!=NULL){
                xmlStream.writeCharacters(acc.Payment_Contact__r.Name);
            }*/
            xmlStream.writeEndElement();

            xmlStream.writeStartElement('','PAYMENT_WAY_LIST','');
            xmlStream.writeStartElement('','PAYMENT_WAY','');

            xmlStream.writeStartElement('', 'WAY_ID', '');        
            xmlStream.writeCharacters('CHK');
            xmlStream.writeEndElement();        
                 
            xmlStream.writeStartElement('', 'IS_DEFAULT', '');
            xmlStream.writeCharacters('TRUE'); 
            xmlStream.writeEndElement();

            xmlStream.writeEndElement(); //endof PAYMENT_WAY
            xmlStream.writeEndElement(); //endof PAYMENT_WAY_LIST

            xmlStream.writeEndElement(); //endof IDENTITY_PAY_INFO
        }
        xmlStream.writeEndElement(); //endof IIDENTITY_PAY_INFO_LIST

        //start of CREDIT_INFO_RE
        xmlStream.writeStartElement('','CREDIT_INFO_LIST','');
        for(String eachCompany:companies){
            xmlStream.writeStartElement('','CREDIT_INFO',''); 

            xmlStream.writeStartElement('', 'COMPANY', '');
            xmlStream.writeCharacters(eachCompany);
            xmlStream.writeEndElement();

            xmlStream.writeStartElement('', 'CREDIT_LIMIT', '');
            if(acc.Credit_Limit__c!=NULL){
                xmlStream.writeCharacters(String.valueof(acc.Credit_Limit__c)); 
            }
            xmlStream.writeEndElement(); 
            
            xmlStream.writeEndElement(); //endof CREDIT_INFO
        }
        xmlStream.writeEndElement(); //endof CREDIT_INFO_LIST

        xmlStream.writeEndElement(); //end of CUSTOMER
        xmlStream.writeEndElement(); //end of CUSTOMER_REC

        xmlStream.writeEndElement();// end of customer info
           
        xmlStream.writeEndElement(); // end of body 
        xmlStream.writeEndElement(); //end of begin
        //system.debug('Customer Req:'+xmlStream.getXMLString());
        
        String xmlRequest = xmlStream.getXMLString();
        return xmlRequest;      
    }
   
}