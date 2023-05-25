public class IFS_ConstructCustReqCPQ {
    
    public static String generateReq(String accountId, String orderId) {

        Order ord = [
            SELECT Ship_Via__c, Delivery_Terms__c, Shipment_Type__c, Freight_Information__c, Freight_Information__r.Entity__c, Freight_Information__r.Account__c, Freight_Information__r.Account__r.Account_Number__c, 
                Freight_Information__r.Account_Number__c, Freight_Information__r.Bill_To__c, SBQQ__Quote__r.Shipping_Account__r.Account_Number__c, SBQQ__Quote__r.Shipping_Account__r.BillingStreet, 
                SBQQ__Quote__r.Shipping_Account__r.BillingCity, SBQQ__Quote__r.Shipping_Account__r.Name, SBQQ__Quote__r.Shipping_Account__c, SBQQ__Quote__r.Shipping_Account__r.BillingState, 
                SBQQ__Quote__r.Shipping_Account__r.BillingCountry, SBQQ__Quote__r.Shipping_Account__r.BillingPostalCode, SBQQ__Quote__r.Shipping_Account__r.BillingCountryCode, 
                SBQQ__Quote__r.SBQQ__Account__r.Account_Number__c, SBQQ__Quote__r.SBQQ__Account__r.Name, SBQQ__Quote__r.SBQQ__Account__r.BillingStreet, SBQQ__Quote__r.SBQQ__Account__c, 
                SBQQ__Quote__r.SBQQ__Account__r.BillingCity, SBQQ__Quote__r.SBQQ__Account__r.BillingState, SBQQ__Quote__r.SBQQ__Account__r.BillingCountry, SBQQ__Quote__r.SBQQ__Account__r.BillingPostalCode, 
                SBQQ__Quote__r.SBQQ__Account__r.BillingCountryCode, SBQQ__Quote__r.SBQQ__Opportunity2__r.CurrencyIsoCode, SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c, SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Name, 
                SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Description, SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Phone, SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Email, SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Fax, 
                SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Primary_Contact_For_Account__c 
            FROM Order 
            WHERE Id = :orderId 
            LIMIT 1
        ];

        Account acc = [
            SELECT Id, Name, Account_Number__c, Visibility_Customer_ID__c, Rep_Code_District__c,Rep_Code_Region__c, CurrencyIsoCode,Type,Payment_Terms__c,Credit_Limit__c, Parent.Hierarchy_Group__c, 
                BillingCountryCode
            FROM Account 
            WHERE Id = :accountId 
            LIMIT 1
        ];
        
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
        if(ord.SBQQ__Quote__r.SBQQ__Account__r.Account_Number__c!=NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Account__r.Account_Number__c);
        }
        /*if(quote.SBQQ__Account__c !=NULL){
            xmlStream.writeCharacters(((string)(quote.SBQQ__Account__c)).toUpperCase());
        }*/
        xmlStream.writeEndElement(); 

        xmlStream.writeStartElement('', 'CUSTOMER_NAME', '');
        if(ord.SBQQ__Quote__r.SBQQ__Account__r.Name!=NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Account__r.Name);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'ADDRESS_1', '');
        if(ord.SBQQ__Quote__r.SBQQ__Account__r.BillingStreet!=NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Account__r.BillingStreet);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'ADDRESS_2', '');
        /*if(quote.SBQQ__Account__r.BillingStreet!=NULL){
            xmlStream.writeCharacters(quote.SBQQ__Account__r.BillingStreet); 
        }*/
        xmlStream.writeEndElement();
        
        xmlStream.writeStartElement('', 'CITY', '');
        if(ord.SBQQ__Quote__r.SBQQ__Account__r.BillingCity!=NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Account__r.BillingCity);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'STATE', '');
        if(ord.SBQQ__Quote__r.SBQQ__Account__r.BillingState!=NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Account__r.BillingState);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'COUNTY', '');
        if(ord.SBQQ__Quote__r.SBQQ__Account__r.BillingCountry!=NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Account__r.BillingCountry); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'ZIP_CODE', '');
        if(ord.SBQQ__Quote__r.SBQQ__Account__r.BillingPostalCode!=NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Account__r.BillingPostalCode); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'COUNTRY_DB', '');
        if(ord.SBQQ__Quote__r.SBQQ__Account__r.BillingCountryCode!=NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Account__r.BillingCountryCode); 
        }
        xmlStream.writeEndElement();


        xmlStream.writeStartElement('', 'ORDER_ADDRESS_LIST', '');//begin of ORDER_ADDRESS_LIST
        xmlStream.writeStartElement('', 'ORDER_ADDRESS_INFO', '');// begin of ORDER_ADDRESS_INFO
        
        xmlStream.writeStartElement('', 'DELIVERY_TERMS', '');
        if(ord.Delivery_Terms__c!=NULL){
            xmlStream.writeCharacters(ord.Delivery_Terms__c); 
        }
        xmlStream.writeEndElement();        

        xmlStream.writeStartElement('', 'SHIP_VIA_CODE', '');
        if(ord.Ship_Via__c!=NULL){
            xmlStream.writeCharacters(ord.Ship_Via__c); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'SHIPMENT_TYPE', '');
        if(ord.Shipment_Type__c!=NULL){
            xmlStream.writeCharacters(ord.Shipment_Type__c); 
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
        if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c != NULL){
            if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'PHONE'){
                xmlStream.writeCharacters('1');
            }else if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'E_MAIL'){
                xmlStream.writeCharacters('2');
            }else if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'FAX'){
                xmlStream.writeCharacters('3');
            }            
        }       
        xmlStream.writeEndElement();
                        
        xmlStream.writeStartElement('', 'NAME', '');
        xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Name); 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'DESCRIPTION', '');
        if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Description != NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Description); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'METHOD_ID', '');
        if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c != NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c); 
        }
        xmlStream.writeEndElement();
          
        xmlStream.writeStartElement('', 'VALUE', '');
        if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'PHONE' && ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Phone != NULL){     
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Phone);     
        }else if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'E_MAIL' && ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Email != NULL){    
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Email);     
        }else if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'FAX' && ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Fax != NULL){      
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Fax);       
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'METHOD_DEFAULT', '');
        if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Primary_Contact_For_Account__c!=NULL && ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Primary_Contact_For_Account__c){
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
        if(ord.SBQQ__Quote__r.Shipping_Account__r.Account_Number__c!=NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.Shipping_Account__r.Account_Number__c);
        }
        /*if(quote.Shipping_Account__c!=NULL){
            xmlStream.writeCharacters(((string)(quote.Shipping_Account__c)).toUpperCase());
        }*/
        xmlStream.writeEndElement(); 

        xmlStream.writeStartElement('', 'CUSTOMER_NAME', '');
        if(ord.SBQQ__Quote__r.Shipping_Account__r.Name!=NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.Shipping_Account__r.Name);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'ADDRESS_1', '');
        if(ord.SBQQ__Quote__r.Shipping_Account__r.BillingStreet!=NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.Shipping_Account__r.BillingStreet);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'ADDRESS_2', '');
        /*if(quote.Shipping_Account__r.BillingStreet!=NULL){
            xmlStream.writeCharacters(quote.Shipping_Account__r.BillingStreet); 
        }*/
        xmlStream.writeEndElement();
        
        xmlStream.writeStartElement('', 'CITY', '');
        if(ord.SBQQ__Quote__r.Shipping_Account__r.BillingCity!=NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.Shipping_Account__r.BillingCity);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'STATE', '');
        if(ord.SBQQ__Quote__r.Shipping_Account__r.BillingState!=NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.Shipping_Account__r.BillingState);
        } 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'COUNTY', '');
        if(ord.SBQQ__Quote__r.Shipping_Account__r.BillingCountry!=NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.Shipping_Account__r.BillingCountry); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'ZIP_CODE', '');
        if(ord.SBQQ__Quote__r.Shipping_Account__r.BillingPostalCode!=NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.Shipping_Account__r.BillingPostalCode); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'COUNTRY_DB', '');
        if(ord.SBQQ__Quote__r.Shipping_Account__r.BillingCountryCode!=NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.Shipping_Account__r.BillingCountryCode); 
        }
        xmlStream.writeEndElement();


        xmlStream.writeStartElement('', 'ORDER_ADDRESS_LIST', '');//begin of ORDER_ADDRESS_LIST
        xmlStream.writeStartElement('', 'ORDER_ADDRESS_INFO', '');// begin of ORDER_ADDRESS_INFO
        
        xmlStream.writeStartElement('', 'DELIVERY_TERMS', '');
        if(ord.Delivery_Terms__c!=NULL){
            xmlStream.writeCharacters(ord.Delivery_Terms__c); 
        }
        xmlStream.writeEndElement();        

        xmlStream.writeStartElement('', 'SHIP_VIA_CODE', '');
        if(ord.Ship_Via__c!=NULL){
            xmlStream.writeCharacters(ord.Ship_Via__c); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'SHIPMENT_TYPE', '');
        if(ord.Shipment_Type__c!=NULL){
            xmlStream.writeCharacters(ord.Shipment_Type__c); 
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
        if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c != NULL){
            if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'PHONE'){
                xmlStream.writeCharacters('1');
            }else if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'E_MAIL'){
                xmlStream.writeCharacters('2');
            }else if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'FAX'){
                xmlStream.writeCharacters('3');
            }            
        }       
        xmlStream.writeEndElement();
                        
        xmlStream.writeStartElement('', 'NAME', '');
        xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Name); 
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'DESCRIPTION', '');
        if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Description != NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Description); 
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'METHOD_ID', '');
        if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c != NULL){
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c); 
        }
        xmlStream.writeEndElement();
          
        xmlStream.writeStartElement('', 'VALUE', '');
        if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'PHONE' && ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Phone != NULL){     
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Phone);     
        }else if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'E_MAIL' && ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Email != NULL){    
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Email);     
        }else if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Default_Communication_Method__c == 'FAX' && ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Fax != NULL){      
            xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Fax);       
        }
        xmlStream.writeEndElement();

        xmlStream.writeStartElement('', 'METHOD_DEFAULT', '');
        if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Primary_Contact_For_Account__c!=NULL && ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.Contact__r.Primary_Contact_For_Account__c){
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
        if(ord.Freight_Information__c != NULL){ 
            xmlStream.writeStartElement('', 'UPS', '');         
            //String localVar1=ord.Freight_Information__r.Account__c;         
            if(ord.Freight_Information__r.Entity__c == 'UPS' && ord.Freight_Information__r.Bill_To__c    != NULL){
                xmlStream.writeCharacters(ord.Freight_Information__r.Bill_To__c);
            }               
            xmlStream.writeEndElement();
                
            xmlStream.writeStartElement('', 'FEDEX', '');           
            if(ord.Freight_Information__r.Entity__c == 'FedEx' && ord.Freight_Information__r.Bill_To__c  != NULL){
                xmlStream.writeCharacters(ord.Freight_Information__r.Bill_To__c);
            }   
            xmlStream.writeEndElement();

            if(ord.Freight_Information__r.Entity__c == 'UPS' && ord.Freight_Information__r.Account__c != NULL){             
                //start of UPS_ACCOUNT_LIST
                xmlStream.writeStartElement('','UPS_ACCOUNT_LIST','');
                xmlStream.writeStartElement('','FREIGHT_ACCOUNT','');

                xmlStream.writeStartElement('', 'ACCOUNT', '');
                if(ord.Freight_Information__r.Account_Number__c != NULL){                          
                    xmlStream.writeCharacters(ord.Freight_Information__r.Account_Number__c);            
                }               
                xmlStream.writeEndElement();                
                     
                xmlStream.writeStartElement('', 'ADDRESS_ID', '');       
                if(ord.Freight_Information__r.Account__r.Account_Number__c != NULL){                           
                    xmlStream.writeCharacters(ord.Freight_Information__r.Account__r.Account_Number__c);            
                }   
                xmlStream.writeEndElement();
                
                xmlStream.writeStartElement('', 'IS_DEFAULT', '');                 
                xmlStream.writeCharacters('TRUE');              
                xmlStream.writeEndElement();
                

                xmlStream.writeEndElement(); //endof FREIGHT_ACCOUNT
                xmlStream.writeEndElement(); //endof UPS_ACCOUNT_LIST 
            }

            if(ord.Freight_Information__r.Entity__c == 'FedEx' && ord.Freight_Information__r.Account__c != NULL){
                //start of FEDEX_ACCOUNT_LIST
                xmlStream.writeStartElement('','FEDEX_ACCOUNT_LIST','');
                xmlStream.writeStartElement('','FREIGHT_ACCOUNT','');

                xmlStream.writeStartElement('', 'ACCOUNT', '');
                if(ord.Freight_Information__r.Account_Number__c != NULL){                          
                    xmlStream.writeCharacters(ord.Freight_Information__r.Account_Number__c);            
                }   
                xmlStream.writeEndElement();
                     
                xmlStream.writeStartElement('', 'ADDRESS_ID', '');
                if(ord.Freight_Information__r.Account__r.Account_Number__c != NULL){                           
                    xmlStream.writeCharacters(ord.Freight_Information__r.Account__r.Account_Number__c);            
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
            if(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.CurrencyIsoCode!=NULL){
                xmlStream.writeCharacters(ord.SBQQ__Quote__r.SBQQ__Opportunity2__r.CurrencyIsoCode); 
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
System.debug('xmlRequest');
System.debug(xmlRequest);
        return xmlRequest;      
    }
   
}