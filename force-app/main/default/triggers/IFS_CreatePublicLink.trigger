trigger IFS_CreatePublicLink on ContentVersion (before insert, after insert) {
    
  /*  if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            for(ContentVersion cont:trigger.new){
                cont.Document_Class__c = 'Sales-110';
            }
        }
    } */
    
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            List<ContentDistribution> cdList=new List<ContentDistribution>();   
            for(ContentVersion cv:trigger.new)
            {   
                if(cv.id != null)
                {
                    ContentDistribution cd = new ContentDistribution();
                    cd.Name = cv.Title;
                    cd.ContentVersionId = cv.id;            
                    cd.PreferencesAllowViewInBrowser= true;
                    cd.PreferencesLinkLatestVersion=true;
                    cd.PreferencesNotifyOnVisit=false;
                    cd.PreferencesPasswordRequired=false;
                    cd.PreferencesAllowOriginalDownload= true;
                    cdList.add(cd);
                }    
            }
            if(cdList.size()>0){
                insert cdList;
            }
        }
    }
}