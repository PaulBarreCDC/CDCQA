trigger setPassword on User (before update) {
    for (User u:Trigger.New) {
        User oldUser = Trigger.OldMap.get(u.id);
        if ((u.Password__c != null) && (oldUser.Password__c != u.Password__c)) {
            System.SetPassword(u.id,u.password__c);
        }    
    }
}