/**
* @author COmpany/Developer Name
* @date 2019
*
* @group All sObjects
*
* @description RecordTypeUtil is used to store RecordTypeId's of all the object's into static variables.
*/
public class RecordTypeUtil {
    
    /* Account RecordTypes */
    public static final String PARENT_RECORDTYPE_Id = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Parent_Account').getRecordTypeId();
    public static final String CUSTOMER_RECORDTYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer_Account').getRecordTypeId();
    public static final String PARTNER_RECORDTYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Partner_House_Account').getRecordTypeId();
    
    
    
    /* Quote RecordTypes */
    public static final String QT_PND_RECORDTYPE_ID = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName().get('Pending').getRecordTypeId();
    public static final String QT_PRTNR_RECORDTYPE_ID = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName().get('Partner_Submitted').getRecordTypeId();
    public static final String QT_PND_APP_RECORDTYPE_ID = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName().get('Pending_Approval').getRecordTypeId();
    public static final String QT_APP_RECORDTYPE_ID = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName().get('Approved').getRecordTypeId();
    public static final String QT_ORD_SUB_RECORDTYPE_ID = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName().get('Order_Submitted').getRecordTypeId();
}