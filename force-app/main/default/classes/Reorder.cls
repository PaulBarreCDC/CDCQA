public class Reorder {
    
    public static void bgrReorder(Id bgrId, boolean reorderflag){
        if(reorderflag){
        Bgr__c bg = [Select id,Quote_Line__c from Bgr__c where id = :bgrId limit 1];
         configureBGRProduct conBgrSc = new configureBGRProduct(bg.Quote_Line__c);         
         conBgrSc.saveProductMaterials();
         conBgrSc.showPopup();
         conBgrSc.saveValveExamination();
         conBgrSc.saveDocSourcing();
        }
    }

}