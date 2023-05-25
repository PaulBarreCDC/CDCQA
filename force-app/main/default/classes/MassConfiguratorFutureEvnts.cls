/**********************************************************************************************************
* @Name         MassConfiguratorFutureEvnts 
* @Author       Ashim Kumar Sahoo <ashim.kumar@apexit.com>
* @Date         10/16/2020
* @Description  This class is responsible for updating the QuoteLine details                               
************************************************************************************************************/
public class MassConfiguratorFutureEvnts implements Queueable, Database.AllowsCallouts {
	
    public List<SBQQ__QuoteLine__c> quoteLineDetails;
    
    /*******************************************************************************************************
    * @Description  This method is a constructor which set the QuoteLine Ids
    * @Param 1		List<SBQQ__QuoteLine__c> - quoteLineDetails
    * @Return       N/A
    * @Example     
    * MassConfiguratorUpdateInitiation('List<QUOTELINE_DETAILS>')
    *********************************************************************************************************/
    public MassConfiguratorFutureEvnts() {}
    
    public MassConfiguratorFutureEvnts(List<SBQQ__QuoteLine__c> quoteLineDetails) {
    	
        this.quoteLineDetails = quoteLineDetails;
    }
    
    /*******************************************************************************************************
    * @Description  This method receives the List<SBQQ__QuoteLine__c> records, 
    * 				converts it to a JSON string (serializes it), and invoke the updateQuoteLineDesc() for
    * 				updating the QL details
    * 				Set<String> contains the respective QuoteLine IDs
    * @Param 1		QueueableContext - context
    * @Return       N/A
    *********************************************************************************************************/
    public void execute(QueueableContext context) {
     	
        /*
        if(quoteLineDetails != null && quoteLineDetails.size() > 0) {
        	
            ConfigHolderUtilityBatch.updateQuoteLineDesc(JSON.serialize(quoteLineDetails));
        }
		*/
        ConfigHolderUtilityBatch.updateQLines();
    }
}