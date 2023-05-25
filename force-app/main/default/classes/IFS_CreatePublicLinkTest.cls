@isTest
public class IFS_CreatePublicLinkTest{
    public static testmethod void validateIFS_CreatePublicLinkTrigger(){
        Integration_Logs__c log=new Integration_Logs__c();
        log.External_Id__c='123243546';
        upsert log;

        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
        cVersion.PathOnClient = 'test.txt';//File name with extention
        cVersion.Origin = 'C';//C-Content Origin. H-Chatter Origin.
        cVersion.OwnerId = UserInfo.getUserId();//Owner of the file
        cVersion.Title = 'test';//Name of the file
        cVersion.VersionData = Blob.valueOf('test');//File content
        Insert cVersion;

        //After saved the Content Verison, get the ContentDocumentId
        Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;

        //Insert ContentDocumentLink
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
        cDocLink.LinkedEntityId = log.Id;//Add attachment parentId
        cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
        cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
        Insert cDocLink;
    }
}