/***************************************************************************************************************
* @Name         ReorderDriverFutureEvents
* @Author       Vikram Natikar <vikram.natikar@apexit.com>
* @Date         10/14/2020
* @Description  This class is a which handles the Reorder functionality for RuptureDisc,Holders,
				WasteGasBurner,FlameProducts,BlanketGasRegulator and Relief Valve products
*****************************************************************************************************************/

public class ReorderDriverFutureEvents {
	
    @future(callout = true) 
    public static void invokeEventWGB(String quoteLineId) {
        
        WasteGasBurner__c wgb = [SELECT Id, Quote_Line__c FROM WasteGasBurner__c WHERE Id = :quoteLineId LIMIT 1];
        ConfigureWasteGasBurner conWGB = new ConfigureWasteGasBurner(wgb.Quote_Line__c);        
        conWGB.ReorderFlag = true;
        
        conWGB.saveSelections();
    }
    @future(callout = true) 
    public static void invokeEventFA(String quoteLineId) {
        
        Flame_Product__c fa = [SELECT Id, Quote_Line__c FROM Flame_Product__c WHERE Id = :quoteLineId LIMIT 1];
        configureFLAMEproduct conFA = new configureFLAMEproduct(fa.Quote_Line__c);        
        conFA.ReorderFlag = true;
        
        conFA.saveCertificateDocumentOrSourcingRestrictions();
    }
    @future(callout = true) 
    public static void invokeEventBGR(String quoteLineId) {
        
        BGR__c bgr = [SELECT Id, Quote_Line__c FROM BGR__c WHERE Id = :quoteLineId LIMIT 1];
        configureBGRProduct conBGR = new configureBGRProduct(bgr.Quote_Line__c);      
        conBGR.ReorderFlag = true;
        
        conBGR.saveDocSourcing();
    }
     @future(callout = true) 
    public static void invokeEventRV(String quoteLineId) {
        
        Relief_Valve__c rv = [SELECT Id, Quote_Line__c FROM Relief_Valve__c WHERE Id = :quoteLineId LIMIT 1];
        configureRVproduct conRV = new configureRVproduct(rv.Quote_Line__c);        
        conRV.ReorderFlag = true;
        
        conRV.saveDocSourcing();
    }
    @future(callout = true) 
    public static void invokeEventHLD(String quoteLineId) {
        
        Holders__c hld = [SELECT Id, Quote_Line__c FROM Holders__c WHERE Id = :quoteLineId LIMIT 1];
        ConfigHolderController conHLD = new ConfigHolderController(hld.Quote_Line__c);        
        conHLD.ReorderFlag = true;
        
        conHLD.saveCleaningMarkingsTesting();
    }
    @future(callout = true) 
    public static void invokeEventHLD2(String quoteLineId) {
        
        Holders__c hld = [SELECT Id, Quote_Line__c FROM Holders__c WHERE Id = :quoteLineId LIMIT 1];
        ConfigHoldersOutputController conHLD2 = new ConfigHoldersOutputController(HLD.Quote_Line__c);
        
        conHLD2.SavePriceOverride();
    }
    @future(callout = true) 
    public static void invokeEventRD(String quoteLineId) {
        
        Rupture_Disc__c rd = [SELECT Id, Quote_Line__c FROM Rupture_Disc__c WHERE Id = :quoteLineId LIMIT 1];
        ConfigureRD conRD = new ConfigureRD(rd.Quote_Line__c);        
        conRD.ReorderFlag = true;
        
        conRD.saveCleaningsTestsandProcesses();
    }
  /*  @future(callout = true) 
    public static void invokeEventPS(String quoteLineId) {
        
       	Part_Selector__c psrecord = [SELECT Id, Quote_Line__c FROM Part_Selector__c WHERE Id = :quoteLineId LIMIT 1];
        configurePartSelector PS = new configurePartSelector(psrecord.Quote_Line__c);        
      //  conRD.ReorderFlag = true;
        
        PS.saveProdPartNumber();
    }*/
    
    
}