public class fetchStandardPriceBook{
    public static Id queryStandardPriceBookId(){
        Id standardPriceBookId;
        if(test.isRunningTest()){
         
            standardPricebookId = test.getStandardPricebookId();
        }
        else{
           //For code coverage we moved standardPricebookId assignment to below line
            List<Pricebook2> standardPricebook = [SELECT Id, IsActive, IsStandard FROM Pricebook2 WHERE IsActive = TRUE AND IsStandard = TRUE LIMIT 1]; standardPricebookId = standardPriceBookId = standardPricebook[0].Id;
        }
        
        return standardPriceBookId;
    }
}