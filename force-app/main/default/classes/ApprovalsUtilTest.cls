@isTest
public class ApprovalsUtilTest {
    @isTest
    static void unittest(){
        ApprovalsUtil.getThresholds('CDC','D01');
        ApprovalsUtil.getThresholds('CDC','D02');
        ApprovalsUtil.getThresholds('DDC','D02');
    }
}