public class DrawingsCtrl {
    private string quoteId;
    public SBQQ__Quote__c oQuote {get;set;}
    public list<SBQQ__QuoteLine__c> lstQuoteLine {get;set;}
    public list<Charge__c> lstCharge {get;set;} 
    public map<String,String> mapImageData {get;set;}
    public map<String,List<String>> mapDescription {get;set;}
    public string baseURL {get;set;}
    
    private string logoName = '';
    public string logo {get;set;}
    
    public DrawingsCtrl(){
        System.debug('@Developer -->DrawingsCtrl:' );
    }
    
    public PageReference init(){
            System.debug('@Developer -->init:' );
        
        if(ApexPages.currentPage().getParameters().get('qid') != null){
            quoteId = ApexPages.currentPage().getParameters().get('qid');    
            System.debug('@Developer --> quoteId :' + quoteId);

            //baseURL = 'https://' + ApexPages.currentPage().getHeaders().get('Host') + '/servlet/servlet.ImageServer?oid=' + userInfo.getOrganizationId() + '&id=';
            //baseURL = 'https://contdisccorp--uat--c.cs66.content.force.com/servlet/servlet.ImageServer?oid=' + userInfo.getOrganizationId() + '&id=';
            baseURL = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?oid=' + userInfo.getOrganizationId() + '&id=';
            System.debug('@Developer --> baseURL :' + baseURL);
            
            mapDescription = new map<String,list<String>>();
            
            set<string> setDrawingId = new set<String>();
            
            for(SBQQ__Quote__c qt : [SELECT Id,Name,Quote_Number__c,Change_Order_No__c,
                                     DisplayCDCLogo__c, DisplayGrothContinentalLogo__c, DisplayGrothLogo__c, 
                                     DisplayLaMotLogo__c, DisplayLVALogo__c,
                                     (SELECT Id,Name,DimA__c, DimB__c, DimC__c, DimD__c,DimE__c, DimF__c,SBQQ__Number__c,  
                                      DrawingID__c, Drawings_Status__c, SBQQ__Description__c 
                                      FROM SBQQ__LineItems__r
                                      WHERE Line_Status__c in ('Primary','Alternate')
                                      ORDER BY CreatedDate DESC
                                     )
                                     FROM SBQQ__Quote__c
                                     WHERE Id = :quoteId
                                    ])
            {
                oQuote = qt;
                if(qt.DisplayCDCLogo__c){
                	logoName = 'CDC Logo New';    
                }
                else if(qt.DisplayGrothContinentalLogo__c){
                	logoName = 'groth continental manufacturing pvt ltdNew';    
                }
                else if(qt.DisplayGrothLogo__c){
                	logoName = 'grothLogoNew';    
                }
                else if(qt.DisplayLaMotLogo__c){
                	logoName = 'laMotLogoNew';    
                }
                else if(qt.DisplayLVALogo__c){
                	logoName = 'lamot_LVA_logo.pngNEW';    
                }
                
                lstQuoteLine = new list<SBQQ__QuoteLine__c>();
                for(SBQQ__QuoteLine__c qln : qt.SBQQ__LineItems__r){
                    System.debug('@Developer --> qln :' + qln);
                    if(qln.DrawingID__c != null){
                        setDrawingId.add(qln.DrawingID__c);
                    }
                    lstQuoteLine.add(qln);
                    
                    //qln.SBQQ__Description__c = qln.SBQQ__Description__c.replaceAll('<[^>]+>',' ');
                    if(qln.SBQQ__Description__c != null ){
                        list<String> lstDesc = new list<String>();
                        list<String> lstTmp = qln.SBQQ__Description__c.split('<br>');
                        Integer nCount = lstTmp.size() > 20 ? 20 : lstTmp.size();
                        for(integer indx=0; indx < nCount; indx++){
                            String sTmp = lstTmp[indx];
                            if(sTmp != null && sTmp != ''){
                                lstDesc.add(sTmp); 
                            }
                        }
                        mapDescription.put(qln.Id,lstDesc);
                    }
                    else{
                    	mapDescription.put(qln.Id,new list<String>());    
                    }
                }
            }
            
            setDrawingId.add(logoName);
            mapImageData = new map<String,String>();
            for(String sDrawingId :setDrawingId){
                System.debug('@Developer --> sDrawingId :' + sDrawingId);
                mapImageData.put(sDrawingId,' ');
            }
            for(Document doc : [SELECT Id,Name FROM Document WHERE Name IN :setDrawingId And Name != '9999']){
                mapImageData.put(doc.Name,baseURL + doc.Id);
            }
            System.debug('@Developer --> mapImageData :' + mapImageData);
            
            System.debug('@Developer --> logoName :' + logoName);
            if(mapImageData.containsKey(logoName)){
                logo = mapImageData.get(logoName);
                System.debug('@Developer --> logo :' + logo);
            }
            
            lstCharge = [SELECT Id, Amount__c, Quantity__c, Type__c, Status__c,Total_Charge__c,Quote_Customer_Currency__c,
                         Total_Charge_Cust_Curr__c,Amount_Cust_Curr__c,Total_Charge_Cust_Curr_Flow__c
                         FROM Charge__c 
                         WHERE Parent_Quote__c =:quoteId
                         ORDER BY CreatedDate];
            System.debug('@Developer --> lstCharge :' + lstCharge);
        }
        else{
            System.debug('@Developer -->Invalid quote reference:' );
        }
        return null;
    }
}