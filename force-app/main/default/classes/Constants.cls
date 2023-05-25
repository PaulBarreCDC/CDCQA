public class Constants {

    /* Profile Names */
    public static final String PARTNER_COMMUNITY_USER_PROFILE = 'CDC Partner Community Users Profile';
    public static final String PARTNER_COMMUNITY_REP_PROFILE = 'CDC Partner Community Rep Office manager';
    
    /* Public Group Names */
    public static final String COMMUNITY_REP_OFFICE_MANAGER_GROUP = 'Community  Rep Office Manager';
    
    public static String getUserInfo(){      
        return [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
    }
}