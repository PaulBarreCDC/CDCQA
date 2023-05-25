public class AssignUserToPublicGroup {
    
    public static void addUserToPublicGroup(List<User> usrLst){
        Map<Id, User> userMap = new Map<Id, User>([select u.Profile.Name,u.IsActive from User u where u.id IN :usrLst]);
        List<GroupMember> gmList = new List<GroupMember>();
        Id pubicGrpId = [select id,name from group where type='Regular' and NAME =: Constants.COMMUNITY_REP_OFFICE_MANAGER_GROUP].Id;
        for(User usr:usrLst){
            User u = userMap.get(usr.Id);
            if(u.Profile.Name == Constants.PARTNER_COMMUNITY_REP_PROFILE && u.IsActive){
                GroupMember gm = new GroupMember();
                gm.GroupId = pubicGrpId;
                gm.UserOrGroupId = U.Id;
                gmList.add(gm); 
            } 
        }
        if(!gmList.isEmpty()) {
            System.debug('Group Member List is ' + gmList);
            insert gmList;
        }
    }
}