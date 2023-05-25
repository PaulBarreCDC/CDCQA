public class configBgrReferenceCtrl {
    public BGR__c oBGR{get;set;}
    public User oUser {get;set;}
    public string getUserTimeZone(){
        return userinfo.getTimeZone().toString();
    }
    
    public configBgrReferenceCtrl(ApexPages.StandardController controller){
        if (!Test.isRunningTest()) { 
	   controller.addFields(new String[]{'Soft_Goods_Material_dynamic__c','Size__c','Connection_dynamic__c'});
        }
        oBGR = (BGR__c)controller.getRecord();    
        for(User u : [Select Id,Name From User Where Id =: userinfo.getUserId()]){
            oUser = u;
        }
    }
    
    
    public string getSoftGoodsMaterial() {
        List<BGR_Matlist__c> BodyMaterial = new List<BGR_Matlist__c>();
        Set<string> BodyMaterialSet = new Set<string>();
        String BaseQuery = 'Select SZC__c,Component__c,MatlCode__c,Description__c from BGR_Matlist__c ';
        String WhereClause ='';
        String Comp = 'Soft Goods Material';
        if(oBGR.Size__c!=null) { 
            BaseQuery = BaseQuery+'where SZC__c =\''+oBGR.Size__c+'\' and Component__c=\''+Comp+'\'' ;
        }
        BodyMaterial = Database.query(BaseQuery) ;
        
        for (BGR_Matlist__c bm :BodyMaterial) {
            if(bm.MatlCode__c == string.valueOf(oBGR.Soft_Goods_Material_dynamic__c) ){
               return bm.Description__c;
            }
        }
        return null;
    }
    
    public string getConnection() {
        List<BGR_Connections__c> Connection = new List<BGR_Connections__c>();
        Set<string> ConnectionSet = new Set<string>();
        String BaseQuery = 'Select SZC__c,ConnectionCode__c,ConnectionDesc__c from BGR_Connections__c ';
        String WhereClause ='';
        if(oBGR.Size__c!=null) 
            WhereClause = 'where  SZC__c =\''+oBGR.Size__c+'\'';
        //WhereClause = WhereClause +' '+ 'and'+' '+'Component__c=\''+Comp+'\'';
        
        Connection=Database.query(BaseQuery + WhereClause) ;
        
        for (BGR_Connections__c con :Connection) {
            if(con.ConnectionCode__c == string.valueOf(oBGR.Connection_dynamic__c) ){
               return con.ConnectionDesc__c;
            }
        }
        return null;
    }
}