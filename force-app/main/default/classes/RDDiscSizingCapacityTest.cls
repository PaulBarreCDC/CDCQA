// Test Class For RDDiscSizingCapacity
// shailesh kolhe Aug 2019
@isTest
public class RDDiscSizingCapacityTest {
    @testSetup
    public static void dataSetup() {

        TestDataRDUtility.createRDMasterTestRecords();
        APIDryKs__c[] ls = Test.loadData(APIDryKs__c.sObjectType, 'APIDryKs');
        ISODryKs__c[] ls1 = Test.loadData(ISODryKs__c.sObjectType, 'ISODryStreamKs');
    }
    @isTest static void testAPISteamCommon() {
         Result ret =  RDDiscSizingCapacity.APISteamCommon(32001);
         ret= RDDiscSizingCapacity.APISteamCommon(27);
         DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='API Steam1',Available_Coeffient_of_Discharge__c='0.62');
    	 insert objDiscCoef;
         ret=RDDiscSizingCapacity.APISteamCommon(320);
    }

    @isTest static void RDMasterBlaster1(){

        RDMasterBlaster__c objRDMasterBlaster=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',MNFA__c = 2.25);
    	insert objRDMasterBlaster;


        double   P=100,  T=600,  M=28.964 ;
        String stPTC = 'KBA', stSeat = 'FS';
        integer nSize = 100;
        Result ret =  RDDiscSizingCapacity.RDMasterBlaster(100,stPTC,stSeat);

    }

    // // Test method for ASMEAIRSize
    @isTest static void testASMEAIRSize(){
        System.debug('###Started ASMEAIRSize Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Air',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        double W =50,  P=100,  T=600,  M=28.964 ;
        Result ret =  RDDiscSizingCapacity.ASMEAIRSize(W,P,T,M);

        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check size
        System.assertEquals(ret.dblRetValue ,0.010310);
    }
    @isTest static void testASMEAIRSize1(){
        System.debug('###Started ASMEAIRSize Test ###');
       DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Air11',Available_Coeffient_of_Discharge__c='0.62');
       insert objDiscCoef;

       double W =50,  P=100,  T=600,  M=28.964 ;
       Result ret =  RDDiscSizingCapacity.ASMEAIRSize(W,P,T,M);

       // Make sure operation is success
       System.assertEquals(ret.bResult,false);

       // Check size
       //System.assertEquals(ret.dblRetValue ,0.010310);
   }
   @isTest static void testASMEAIRSize2(){
    System.debug('###Started ASMEAIRSize Test ###');
   DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Air',Available_Coeffient_of_Discharge__c='0.62');
   insert objDiscCoef;

   double W =50,  P=100,  T=600,  M=28.964 ;
   try {
    Result ret =  RDDiscSizingCapacity.ASMEAIRSize(0,0,0,0);

    //System.assertEquals(ret.bResult,true);

   // Check size
   //System.assertEquals(ret.dblRetValue ,0.010310);
   } catch (Exception e) {

   }


   // Make sure operation is success

}
    // // Test method for ASMEAIRCapacity
    @isTest static void testASMEAIRCapacity(){
       // TestDataRDUtility.createRDMasterTestRecords();
        System.debug('###Started ASMEAIRCapacity Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Air',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        RDMasterBlaster__c objRDMasterBlaster=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',MNFA__c = 2.25);
    	insert objRDMasterBlaster;

        double   P=100,  T=600,  M=28.964 ;
        String stPTC = 'KBA', stSeat = 'FS';
        integer nSize = 100;
        Result ret =  RDDiscSizingCapacity.ASMEAIRCapacity(P,T,M, nSize,stPTC, stSeat,double.valueOf('1.1'));
        Result ret1 =  RDDiscSizingCapacity.ASMEAIRCapacity(P,T,M, 200,stPTC, stSeat,double.valueOf('1.1'));
        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check capacity
      //  System.assertEquals(ret.dblRetValue ,10911.333998);
    }
    @isTest static void testASMEAIRCapacity1(){
        //TestDataRDUtility.createRDMasterTestRecords();
        System.debug('###Started ASMEAIRCapacity Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Air112',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        RDMasterBlaster__c objRDMasterBlaster=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',MNFA__c = 2.25);
    	insert objRDMasterBlaster;

        double   P=100,  T=600,  M=28.964 ;
        String stPTC = 'KBA', stSeat = 'FS';
        integer nSize = 100;
        Result ret =  RDDiscSizingCapacity.ASMEAIRCapacity(P,T,M, nSize,stPTC, stSeat,double.valueOf('1.1'));
        Result ret1 =  RDDiscSizingCapacity.ASMEAIRCapacity(P,T,M, 200,stPTC, stSeat,double.valueOf('1.1'));
        // Make sure operation is success
       // System.assertEquals(ret.bResult,true);

        // Check capacity
       // System.assertEquals(ret.dblRetValue ,10911.333998);
    }
    @isTest static void testASMEAIRCapacity12(){
       // TestDataRDUtility.createRDMasterTestRecords();
        System.debug('###Started ASMEAIRCapacity Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Air',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        RDMasterBlaster__c objRDMasterBlaster=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',MNFA__c = 2.25);
    	insert objRDMasterBlaster;

        double   P=100,  T=600,  M=28.964 ;
        String stPTC = 'KBA', stSeat = 'FS';
        integer nSize = 100;
        try {
            Result ret =  RDDiscSizingCapacity.ASMEAIRCapacity(0,0,0, nSize,stPTC, stSeat,double.valueOf('1.1'));
            Result ret1 =  RDDiscSizingCapacity.ASMEAIRCapacity(P,T,M, 200,stPTC, stSeat,double.valueOf('1.1'));
        } catch (exception e) {

        }
        // Make sure operation is success
       // System.assertEquals(ret.bResult,true);

        // Check capacity
       // System.assertEquals(ret.dblRetValue ,10911.333998);
    }
    // // Test method for ASMEGASSize
    @isTest static void testASMEGASSize(){

        System.debug('###Started ASMEGASSize Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Gas',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;


        double W = 200,  P = 30, T = 463.77, smallk = 1.41,
                              M = 2.016,  Z = 1;
        Result ret =  RDDiscSizingCapacity.ASMEGasSize(W,P,T,smallk,M,Z);

        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check size
        System.assertEquals(ret.dblRetValue ,0.456913);

        System.debug('### ASMEGASSize Test Checking CRITICAL FLOW in separate test. ###');
        // Test case if its not CRITICAL FLOW
        P = 20;
        ret =  RDDiscSizingCapacity.ASMEGasSize(W,P,T,smallk,M,Z);

        // Make sure operation is success. In this case it will actually be false as we Do not allow non critical flow
        System.assertEquals(ret.bResult,false);
    }
@isTest static void testASMEGASSize1(){

        System.debug('###Started ASMEGASSize Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Gas1',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;


        double W = 200,  P = 30, T = 463.77, smallk = 1.41,
                              M = 2.016,  Z = 1;
        Result ret =  RDDiscSizingCapacity.ASMEGasSize(W,P,T,smallk,M,Z);

        // Make sure operation is success
       // System.assertEquals(ret.bResult,true);

        // Check size
        //System.assertEquals(ret.dblRetValue ,0.456913);

        System.debug('### ASMEGASSize Test Checking CRITICAL FLOW in separate test. ###');
        // Test case if its not CRITICAL FLOW
        P = 20;
        ret =  RDDiscSizingCapacity.ASMEGasSize(W,P,T,smallk,M,Z);

        // Make sure operation is success. In this case it will actually be false as we Do not allow non critical flow
        System.assertEquals(ret.bResult,false);
    }

    @isTest static void testASMEGASSize12(){

        System.debug('###Started ASMEGASSize Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Gas',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;


        double W = 200,  P = 30, T = 463.77, smallk = 1.41,
                              M = 2.016,  Z = 1;
        Result ret =  RDDiscSizingCapacity.ASMEGasSize(W,P,T,smallk,M,Z);

        // Make sure operation is success
       // System.assertEquals(ret.bResult,true);

        // Check size
        //System.assertEquals(ret.dblRetValue ,0.456913);

        System.debug('### ASMEGASSize Test Checking CRITICAL FLOW in separate test. ###');
        // Test case if its not CRITICAL FLOW
        P = 20;
        try{
            ret =  RDDiscSizingCapacity.ASMEGasSize(0,0,0,smallk,M,Z);
        } catch(exception e) {

        }


        // Make sure operation is success. In this case it will actually be false as we Do not allow non critical flow
       // System.assertEquals(ret.bResult,false);
    }
    //  // Test method for ASMEGASCapacity
    @isTest static void testASMEGASCapacity(){

        System.debug('###Started ASMEGASCapacity Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Gas',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        RDMasterBlaster__c objRDMasterBlaster=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',MNFA__c = 0.72);
    	insert objRDMasterBlaster;
       // TestDataRDUtility.createRDMasterTestRecords();
        double  P = 30, T = 463.77, smallk = 1.41,
                              M = 2.016,  Z = 1;
        String stPTC = 'KBA', stSeat = 'FS';
        integer nSize = 100;
        Result ret =  RDDiscSizingCapacity.ASMEGasCapacity(P,T,smallk,M,Z,nSize,stPTC, stSeat,double.valueOf('1.1'));
        Result ret1 =  RDDiscSizingCapacity.ASMEGasCapacity(P,T,smallk,M,Z,200,stPTC, stSeat,double.valueOf('1.1'));
        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check capacity
      //  System.assertEquals(ret.dblRetValue ,315.158752);

        System.debug('### ASMEGASCapacity Test Checking CRITICAL FLOW in separate test. ###');
        // Test case if its not CRITICAL FLOW
        P = 20;
        ret =  RDDiscSizingCapacity.ASMEGasCapacity(P,T,smallk,M,Z,nSize,stPTC, stSeat,double.valueOf('1.1'));

        // Make sure operation is success. In this case it will actually be false as we Do not allow non critical flow
        System.assertEquals(ret.bResult,false);
    }

    // Test method for ASMEWaterSize
    @isTest static void testASMEWaterSize(){

        System.debug('###Started ASMEWaterSize Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Water',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        double W = 56,  P=46.325,  Pd=14.7,  smallw=27.77003;
        Result ret =  RDDiscSizingCapacity.ASMEWaterSize(W,P,Pd,smallw);

        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check size
        System.assertEquals(ret.dblRetValue ,0.001266);
    }
    @isTest static void testASMEWaterSize1(){

        System.debug('###Started ASMEWaterSize Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Water1',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        double W = 56,  P=46.325,  Pd=14.7,  smallw=27.77003;
        Result ret =  RDDiscSizingCapacity.ASMEWaterSize(W,P,Pd,smallw);

        // Make sure operation is success
        //System.assertEquals(ret.bResult,true);

        // Check size
       // System.assertEquals(ret.dblRetValue ,0.001266);
    }
    @isTest static void testASMEAIRCommon(){
        double P=29;
        Result ret1 =  RDDiscSizingCapacity.ASMEAIRCommon(P);
        System.debug('###Started ASMEAIRCommon Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Air',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        P=27;
        Result ret2 =  RDDiscSizingCapacity.ASMEAIRCommon(P);

        P=29;
        Result ret =  RDDiscSizingCapacity.ASMEAIRCommon(P);
        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check size
       // System.assertEquals(ret.dblRetValue ,0.001266);
    }

    @isTest static void testASMESteamCommon(){
        double P=3201;
        Result ret1 =  RDDiscSizingCapacity.ASMESteamCommon(P);
        System.debug('###Started ASMEAIRCommon Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Steam',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        P=27;
        Result ret2 =  RDDiscSizingCapacity.ASMESteamCommon(P);

        P=29;
        Result ret =  RDDiscSizingCapacity.ASMESteamCommon(P);
        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check size
        //System.assertEquals(ret.dblRetValue ,0.001266);
    }
    // Test method for ASMEWaterCapacity
    @isTest static void testASMEWaterCapacity(){

        System.debug('###Started ASMEWaterCapacity Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Water',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

         RDMasterBlaster__c objRDMasterBlaster=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',MNFA__c = 2.25);
    	insert objRDMasterBlaster;
      //  TestDataRDUtility.createRDMasterTestRecords();
        double P=46.325,  Pd=14.7,  smallw=27.77003;

        String stPTC = 'KBA', stSeat = 'FS';
        integer nSize = 100;
        Result ret =  RDDiscSizingCapacity.ASMEWaterCapacity(P,Pd,smallw,nSize,stPTC, stSeat,double.valueOf('1.1'));
        Result ret1 =  RDDiscSizingCapacity.ASMEWaterCapacity(P,Pd,smallw,200,stPTC, stSeat,double.valueOf('1.1'));
        // Make sure operation is success
      //  System.assertEquals(ret.bResult,true);

        // Check size
      //  System.assertEquals(ret.dblRetValue ,99507.024375);
    }
@isTest static void testASMEWaterCapacity1(){

        System.debug('###Started ASMEWaterCapacity Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Water1',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

         RDMasterBlaster__c objRDMasterBlaster=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',MNFA__c = 2.25);
    	insert objRDMasterBlaster;
      //  TestDataRDUtility.createRDMasterTestRecords();
        double P=46.325,  Pd=14.7,  smallw=27.77003;

        String stPTC = 'KBA', stSeat = 'FS';
        integer nSize = 100;
        Result ret =  RDDiscSizingCapacity.ASMEWaterCapacity(P,Pd,smallw,nSize,stPTC, stSeat,double.valueOf('1.1'));
        Result ret1 =  RDDiscSizingCapacity.ASMEWaterCapacity(P,Pd,smallw,200,stPTC, stSeat,double.valueOf('1.1'));
        // Make sure operation is success
    }
     // Test method for ASMESteamSize
    @isTest static void testASMESteamSize(){

        System.debug('###Started ASMESteamSize Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Steam',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        //double W =712.36,  P = 3100.56 ;
        double W =712.36,  P = 400.23 ;
        Result ret =  RDDiscSizingCapacity.ASMESteamSize(W,P);

        // Make sure operation is success
        //System.assertEquals(ret.bResult,true);//nikhil, 19 feb

        // Check size
        //System.assertEquals(ret.dblRetValue ,0.055743);//nikhil, 19 feb
    }

@isTest static void testASMESteamSize1(){

        System.debug('###Started ASMESteamSize Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Steam1',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        //double W =712.36,  P = 3100.56 ;
        double W =712.36,  P = 400.23 ;
        Result ret =  RDDiscSizingCapacity.ASMESteamSize(W,P);

        // Make sure operation is success
       // System.assertEquals(ret.bResult,true);

        // Check size
        //System.assertEquals(ret.dblRetValue ,0.055743);
    }
    @isTest static void testASMESteamSize2(){

        System.debug('###Started ASMESteamSize Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Steam',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        //double W =712.36,  P = 3100.56 ;
        try {
            double W =712.36,  P = 400.23 ;
        	Result ret =  RDDiscSizingCapacity.ASMESteamSize(0,0);
        } catch (exception e) {

        }


        // Make sure operation is success
       // System.assertEquals(ret.bResult,true);

        // Check size
        //System.assertEquals(ret.dblRetValue ,0.055743);
    }
     // Test method for ASMESteamCapacity
    @isTest static void testASMESteamCapacity(){

         System.debug('###Started ASMESteamCapacity Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ASME Steam',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

         RDMasterBlaster__c objRDMasterBlaster=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',MNFA__c = 12.7);
    	insert objRDMasterBlaster;
       // TestDataRDUtility.createRDMasterTestRecords();
        //double   P = 3100.56 ;
        double   P = 400.23 ;
        String stPTC = 'KBA', stSeat = 'FS';
        integer nSize = 100;
        Result ret =  RDDiscSizingCapacity.ASMESteamCapacity(P,nSize,stPTC, stSeat,double.valueOf('1.1'));
        Result ret1 =  RDDiscSizingCapacity.ASMESteamCapacity(P,200,stPTC, stSeat,double.valueOf('1.1'));
        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check size
      //  System.assertEquals(ret.dblRetValue ,162297.667530);
    }
     // Test method for APIGASSize
    @isTest static void testAPIGASSize(){

         System.debug('###Started APIGASSize Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='API Gas',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        System.debug('### Testing Critical flow ###');
        // Test Critical flow
        double W = 320.59,  P1=50, P2=6, K=1.4,  T=35, M=28.96,  Z=1;

        Result ret =  RDDiscSizingCapacity.APIGasSize(W,P1,P2,K,T,M,Z);

        // Make sure operation is success
        //System.assertEquals(ret.bResult,true); //nikhil, 19 feb

        // Check size IMP Use rounding and match up these numbers. Else the test will terminat here and wont go next level
        // to test SubCritical flow below
        //System.assertEquals(ret.dblRetValue ,0.031930); //19, feb

         System.debug('### Testing SubCritical flow ###');
        // Test SubCritical flow
        W = 320.59;  P1=20.6959; P2=14.7; K=1.41;  T=529.67;
                              M=2.016;  Z=1 ;
        ret =  RDDiscSizingCapacity.APIGasSize(W,P1,P2,K,T,M,Z);

        // Make sure operation is success
      //  System.assertEquals(ret.bResult,true);

        // Check size
      //  System.assertEquals(ret.dblRetValue ,1.230700);
    }
        @isTest static void testAPIGASSize1(){

         System.debug('###Started APIGASSize Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='API Gas1',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        System.debug('### Testing Critical flow ###');
        // Test Critical flow
        double W = 320.59,  P1=50, P2=6, K=1.4,  T=35, M=28.96,  Z=1;

        Result ret =  RDDiscSizingCapacity.APIGasSize(W,P1,P2,K,T,M,Z);

        // Make sure operation is success
        //System.assertEquals(ret.bResult,true);

        // Check size IMP Use rounding and match up these numbers. Else the test will terminat here and wont go next level
       // // to test SubCritical flow below
        //System.assertEquals(ret.dblRetValue ,0.031930);

        // System.debug('### Testing SubCritical flow ###');
        // Test SubCritical flow
        W = 320.59;  P1=20.6959; P2=14.7; K=1.41;  T=529.67;
                              M=2.016;  Z=1 ;
        ret =  RDDiscSizingCapacity.APIGasSize(W,P1,P2,K,T,M,Z);

        // Make sure operation is success
        //System.assertEquals(ret.bResult,true);

        // Check size
//        System.assertEquals(ret.dblRetValue ,1.230700);
    }
    //  // Test method for APIGASCapacity
    @isTest static void testAPIGASCapacity(){

		System.debug('###Started APIGASCapacity Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='API Gas',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        RDMasterBlaster__c objRDMasterBlaster=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',MNFA__c = 3.36);
    	insert objRDMasterBlaster;

       System.debug('### Testing SubCritical flow ###');
        // Test SubCritical flow
        double  P1=20.6959, P2=14.7, K=1.41,  T=529.67, M=2.016,  Z=1  ;
         String stPTC = 'KBA', stSeat = 'FS';
        integer nSize = 100;
       // TestDataRDUtility.createRDMasterTestRecords();
        Result ret =  RDDiscSizingCapacity.APIGasCapacity(P1,P2,K,T,M,Z,nSize,stPTC, stSeat,double.valueOf('1.1'));
        Result ret1 =  RDDiscSizingCapacity.APIGasCapacity(P1,P2,K,T,M,Z,200,stPTC, stSeat,double.valueOf('1.1'));
        // Make sure operation is success
        System.assertEquals(ret.bResult,true);
       // Check capacity
     //   System.assertEquals(ret.dblRetValue ,875.260115);
        System.debug('### Testing Critical flow ###');
        // Test Critical flow
        P1=50; P2=6; K=1.4;  T=35; M=28.96;  Z=1 ;

        ret =  RDDiscSizingCapacity.APIGasCapacity(P1,P2,K,T,M,Z,nSize,stPTC, stSeat,double.valueOf('1.1'));

        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check size
      //  System.assertEquals(ret.dblRetValue ,33735.709692);
    }

     // Test method for VACUUMSize
    @isTest static void testVACUUMSize(){

         System.debug('###Started VACUUMSize Test ###');


         System.debug('### Testing SubCritical flow ###');
        // Test SubCritical flow
        double W = 320.59;  double P1=15;  double T=519.67;

        Result ret =  RDDiscSizingCapacity.VACUUMSize(W,P1,T);

        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check size
        System.assertEquals(ret.dblRetValue ,0.874605);
    }

     // Test method for VACUUMCapacity
    @isTest static void testVACUUMCapacity(){

		System.debug('###Started VACUUMCapacity Test ###');

        RDMasterBlaster__c objRDMasterBlaster=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',VMNFA__c = 5,DSCVAR__c='A',VACUL__c=1000,VACLL__c=0);
    	insert objRDMasterBlaster;
       //
       // TestDataRDUtility.createRDMasterTestRecords();
       System.debug('### Testing SubCritical flow ###');
        // Test SubCritical flow
        double  P1=15;   double T=519.67  ;
         String stPTC = 'KBA', stSeat = 'FS';
        integer nSize = 100;
        Result ret =  RDDiscSizingCapacity.VACUUMCapacity(P1,T,nSize,stPTC, stSeat,'A',10);
        Result ret1 =  RDDiscSizingCapacity.VACUUMCapacity(P1,T,200,stPTC, stSeat,'A',10);
        // Make sure operation is success
        System.assertEquals(ret.bResult,true);
       // Check capacity
        System.assertEquals(ret.dblRetValue ,1832.770346);

    }

    // Test method for APILIQUIDSize
    @isTest static void testAPILiquidSize(){

        System.debug('###Started APILIQUIDSize Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='API Liquid',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        double Q=330.65,  P1=213.67,  G=23.32, U=13,  P2=0 ;

        Result ret =  RDDiscSizingCapacity.APILiquidSize(Q,P1,G,U,P2);

        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check size IMP Use rounding and match up these numbers.
       // System.assertEquals(ret.dblRetValue ,4.621511);

    }

    // Test method for APILIQUIDCapacity
    @isTest static void testAPILiquidCapacity(){

        System.debug('###Started APILIQUIDCapacity Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='API Liquid',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

         RDMasterBlaster__c objRDMasterBlaster=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',MNFA__c = 0.86);
    	insert objRDMasterBlaster;

        String stPTC = 'KBA', stSeat = 'FS';
        integer nSize = 100;
       // TestDataRDUtility.createRDMasterTestRecords();
        double   P1=213.67,  G=23.32, U=78.87,  P2=23.987 ;
        Result ret =  RDDiscSizingCapacity.APILiquidCapacity(P1,G,U,P2,nSize,stPTC, stSeat,double.valueOf('1.1'));
        Result ret1 =  RDDiscSizingCapacity.APILiquidCapacity(P1,G,U,P2,200,stPTC, stSeat,double.valueOf('1.1'));
        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check capacity IMP Use rounding and match up these numbers.

        //commented by Vikram

        //  System.assertEquals(ret.dblRetValue ,57.42778);

    }
    // Test method for RD_DSCVAR
    @isTest static void testRD_DSCVAR(){
        RDMasterBlaster__c objRDMasterBlaster=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',MNFA__c = 0.86,DSCVAR__C='R',Derate_EQN__c='COMA',PressLL__c=80,PressUL__c=120,Teflon_Ambient__c=0.4,DerateType__c='REV',MatlCodePos__c='005');//nikhil, 19 feb
        insert objRDMasterBlaster;
       //  TestDataRDUtility.createRDMasterTestRecords();
        String stPTC = 'KBA', stSeat = 'FS';
        integer nSize = 100;
        Result ret =  RDDiscSizingCapacity.RD_DSCVAR(nSize,stPTC, stSeat,'ID!=NULL',72,100); //nikhil, 19 feb
        // System.assertEquals(ret.bResult,true);

        // System.assertEquals(ret.strRetValue ,'R'); //nikhil, 19 feb
        RDMasterBlaster__c objRDMasterBlaster1=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',MNFA__c = 0.86,DSCVAR__C='AL',PressLL__c=80,PressUL__c=120,Derate_EQN__c='COMT',Teflon_Ambient__c=0.4,DerateType__c='REV',MatlCodePos__c='005');
        insert objRDMasterBlaster1;
        Derate_Value__c derateVal=new Derate_Value__c(Derate__c=0.5,DerateType__c='REV',TempLL__c=70,TempUL__c=80,MatlCode__c='005');
        insert derateVal;
        
        //Id, Derate__c, DerateType__c, TempUL__c, TempLL__c, MatlCode__c FROM Derate_Value__c
        // TestDataRDUtility.createRDMasterTestRecords();
        String stPTC1 = 'KBA', stSeat1 = 'FS';
        integer nSize1 = 100;
        ret =  RDDiscSizingCapacity.RD_DSCVAR(nSize1,stPTC1, stSeat1,'ID!=NULL',72,100);

        // System.assertEquals(ret.bResult,true);

        // System.assertEquals(ret.strRetValue ,'N');
        try {
            ret =  RDDiscSizingCapacity.RD_DSCVAR(nSize1,stPTC1, stSeat1,'ID!=ID',72,100);
        } catch (exception e) {

        }
        try {
            ret =  RDDiscSizingCapacity.RD_DSCVAR(900,stPTC1, stSeat1,'ID!=NULL',72,100);
        } catch (exception e) {

        }

    }
     // Test method for ISOLIQUIDSize
    @isTest static void testISOLiquidSize(){

        System.debug('###Started ISOLIQUIDSize Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ISO Liquid',Available_Coeffient_of_Discharge__c='0.62');
        insert objDiscCoef;

        double Qm=3000,  Po=213.67,  Vo=0.001, U=1,  Pb=23.987 ;

        Result ret =  RDDiscSizingCapacity.ISOLiquidSize(Qm,Po,Vo,U,Pb);

        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check size IMP Use rounding and match up these numbers.
        System.assertEquals(ret.dblRetValue ,7.267303);

    }

     // Test method for ISOLIQUIDCapacity
    @isTest static void testISOLiquidCapacity(){

        System.debug('###Started ISOLIQUIDCapacity Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ISO Liquid',Available_Coeffient_of_Discharge__c='0.62');
        insert objDiscCoef;

         RDMasterBlaster__c objRDMasterBlaster=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',MNFA__c = 10);
        insert objRDMasterBlaster;

        String stPTC = 'KBA', stSeat = 'FS';
        integer nSize = 100;
       // TestDataRDUtility.createRDMasterTestRecords();
        double   Po=213.67, Vo=0.001, Uo=1,  Pb=23.987 ;
        Result ret =  RDDiscSizingCapacity.ISOLiquidCapacity(Po,Vo,Uo,Pb,nSize,stPTC, stSeat,double.valueOf('1.1'));
        Result ret1 =  RDDiscSizingCapacity.ISOLiquidCapacity(Po,Vo,Uo,Pb,200,stPTC, stSeat,double.valueOf('1.1'));
        // Make sure operation is success
       //System.assertEquals(ret.bResult,true);

        // Check capacity IMP Use rounding and match up these numbers.
       //System.assertEquals(ret.dblRetValue ,4182.287482);

    }

     // Test method for APISteamSize
    @isTest static void testAPISteamSize(){

        System.debug('###Started APISteamSize Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='API Steam',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        RDDiscSizingCapacity objSizCap = new  RDDiscSizingCapacity();

        double W =65.76,  P1=43.987,  T=722.34789 ;

        // Load test data from static resource and add that data to table so that we have as accurate test env
       // APIDryKs__c[] ls = Test.loadData(APIDryKs__c.sObjectType, 'APIDryKs');
        //System.debug('Size:' + ls.Size());

        /*
        List<APIDryKs__c> dryks = new List<APIDryKs__c>();
        for(APIDryKs__c obj : ls){
            APIDryKs__c a = new APIDryKs__c(Pressure__c=obj.Pressure__c, Temprature__c = obj.Temprature__c,
                                            SteamCond__c=obj.SteamCond__c,Ks__c=obj.Ks__c);
           dryks.add(a);
            //System.debug('Pressure' + obj.Pressure__c);
            //System.debug('Temprature' + obj.Temprature__c);
        }
        //insert dryks;
        //*/

        Result ret =  RDDiscSizingCapacity.APISteamSize(W,P1,T);

        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check size IMP Use rounding and match up these numbers.
        System.assertEquals(ret.dblRetValue ,0.056187);

    }

     // Test method for APISteamCapacity
    @isTest static void testAPISteamCapacity(){

        System.debug('###Started APISteamCapacity Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='API Steam',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

         RDMasterBlaster__c objRDMasterBlaster=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',MNFA__c = 0.86);
    	insert objRDMasterBlaster;
       // TestDataRDUtility.createRDMasterTestRecords();
         // Load test data from static resource and add that data to table so that we have as accurate test env
       // APIDryKs__c[] ls = Test.loadData(APIDryKs__c.sObjectType, 'APIDryKs');
       // System.debug('Size:' + ls.Size());

        //double   P = 3100.56 ;
        double   P1 = 43.987 , T = 722.34789;
        String stPTC = 'KBA', stSeat = 'FS';
        integer nSize = 100;
        Result ret =  RDDiscSizingCapacity.APISteamCapacity(P1,T,nSize,stPTC, stSeat,double.valueOf('1.1'));
        Result ret1 =  RDDiscSizingCapacity.APISteamCapacity(P1,T,200,stPTC, stSeat,double.valueOf('1.1'));
        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check size
       // System.assertEquals(ret.dblRetValue ,1006.516315);
    }
     // Test method for ISOGASSize
    @isTest static void testISOGASSize(){

         System.debug('###Started ISOGASSize Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ISO Gas',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        System.debug('### Testing Critical flow ###');
        // Test Critical flow
        double Qm = 320.59,  Po=50, Pb=6, K=1.4,  To=35, M=28.96,  Zo=1,X=0.62;

        Result ret =  RDDiscSizingCapacity.ISOGasSize( Qm,  Po, Pb, To, K,  M, Zo,X);

        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check size IMP Use rounding and match up these numbers. Else the test will terminat here and wont go next level
        // to test SubCritical flow below
        System.assertEquals(ret.dblRetValue ,4.205577);

         System.debug('### Testing SubCritical flow ###');
        // Test SubCritical flow
        Qm = 320.59;  Po=20.6959; Pb=14.9659; K=1.41;  To=529.67;
                              M=29.96;  Zo=1 ;
        ret =  RDDiscSizingCapacity.ISOGasSize( Qm,  Po, Pb, To, K,  M, Zo,X);

        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check size
        System.assertEquals(ret.dblRetValue ,42.572775);
    }

     // Test method for ISOGASCapacity
    @isTest static void testISOGASCapacity(){

        System.debug('###Started ISOGASCapacity Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ISO Gas',Available_Coeffient_of_Discharge__c='0.62');
    	insert objDiscCoef;

        RDMasterBlaster__c objRDMasterBlaster=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',MNFA__c = 0.86);
    	insert objRDMasterBlaster;
       // TestDataRDUtility.createRDMasterTestRecords();
        System.debug('### Testing SubCritical flow ###');
        // Test SubCritical flow
       double Qm = 320.59,  Po=20.6959, Pb=14.9659, K=1.41,  To=529.67,
                              M=29.96,  Zo=1,X=0.62 ;

         String stPTC = 'KBA', stSeat = 'FS';
        integer nSize = 100;
       Result ret =  RDDiscSizingCapacity.ISOGasCapacity( Po, Pb, To, K,  M, Zo,nSize,stPTC, stSeat,X,double.valueOf('1.1'));
       Result ret1 =  RDDiscSizingCapacity.ISOGasCapacity( Po, Pb, To, K,  M, Zo,200,stPTC, stSeat,X,double.valueOf('1.1'));
        // Make sure operation is success
        System.assertEquals(ret.bResult,true);
       // Check capacity
      //  System.assertEquals(ret.dblRetValue ,6.476144);
        System.debug('### Testing Critical flow ###');
        // Test Critical flow
        Qm = 320.59;  Po=50; Pb=6; K=1.4;  To=35; M=28.96;  Zo=1;

        ret =  RDDiscSizingCapacity.ISOGasCapacity(  Po, Pb, To, K,  M, Zo,nSize,stPTC, stSeat,X,double.valueOf('1.1'));

        // Make sure operation is success
        System.assertEquals(ret.bResult,true);

        // Check size
       // System.assertEquals(ret.dblRetValue ,65.557567);
    }
    // Test method for ISODrySteamSize
    @isTest static void testISODrySteamSize(){

		System.debug('###Started ISODrySteamSize Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ISO Dry Stream',Available_Coeffient_of_Discharge__c='0.68');
    	insert objDiscCoef;

        System.debug('Test1:');
          // Load test data from static resource and add that data to table so that we have as accurate test env

       // ISODryKs__c[] ls = Test.loadData(ISODryKs__c.sObjectType, 'ISODryStreamKs');
       // System.debug('Size:' + ls.Size());

        System.debug('Test2:');
       double Qm = 24, P0 = 1.1, T0 = 700,Alpha=0.68;

        Result ret =  RDDiscSizingCapacity.ISODryStreamSize(Qm,P0,T0,Alpha);

        // Make sure operation is success
        //System.assertEquals(ret.bResult,true);

        // Check size IMP Use rounding and match up these numbers.
        //System.assertEquals(ret.dblRetValue ,148.267380);

    }

     // Test method for ISODrySteamCapacity
    @isTest static void testISODrySteamCapacity(){

        System.debug('###Started ISODrySteamCapacity Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ISO Dry Stream',Available_Coeffient_of_Discharge__c='0.68');
    	insert objDiscCoef;

        RDMasterBlaster__c objRDMasterBlaster=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',MNFA__c = 0.86);
    	insert objRDMasterBlaster;
       // TestDataRDUtility.createRDMasterTestRecords();
         // Load test data from static resource and add that data to table so that we have as accurate test env
         // Note: Needed to rename according to the actual configured Object name

       // ISODryKs__c[] ls = Test.loadData(ISODryKs__c.sObjectType, 'ISODryStreamKs');
        // System.debug('Size:' + ls.Size());

         double Qm = 24, P0 = 1.1, T0 = 700,Alpha=0.68;
        String stPTC = 'KBA', stSeat = 'FS';
        integer nSize = 100;

        Result ret =  RDDiscSizingCapacity.ISODryStreamCapacity(Qm,P0,T0,nSize,stPTC, stSeat,Alpha,double.valueOf('1.1'));
        Result ret1 =  RDDiscSizingCapacity.ISODryStreamCapacity(Qm,P0,T0,200,stPTC, stSeat,Alpha,double.valueOf('1.1'));
        // Make sure operation is success
       // System.assertEquals(ret.bResult,true);

        // Check size
     //   System.assertEquals(ret.dblRetValue ,0.139208);
    }

	// // Test method for ISOWetSteamSize
    @isTest static void testISOWetSteamSize(){

		System.debug('###Started ISOWetSteamSize Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ISO Wet Stream',Available_Coeffient_of_Discharge__c='0.68');
    	insert objDiscCoef;

          // Load test data from static resource and add that data to table so that we have as accurate test env
         // Note: Needed to rename according to the actual configured Object name
         // ISODry and ISOWet table and data is same.
      //   ISODryKs__c[] ls = Test.loadData(ISODryKs__c.sObjectType, 'ISODryStreamKs');
        // System.debug('Size:' + ls.Size());

        double Qm = 24, P0 = 21.63, Xo = 111.26,Alpha=0.68;
       // TestDataRDUtility.createRDMasterTestRecords();
        Result ret =  RDDiscSizingCapacity.ISOWetStreamSize(Qm,P0,Xo,Alpha);

        // Make sure operation is success
        // System.assertEquals(ret.bResult,true);

        // // Check size IMP Use rounding and match up these numbers.
        // System.assertEquals(ret.dblRetValue ,33.641852);

    }

    //  // Test method for ISOWetSteamCapacity
    @isTest static void testISOWetSteamCapacity(){

        System.debug('###Started ISOWetSteamCapacity Test ###');
        DiscCoef__c objDiscCoef=new DiscCoef__c(Evaluation__c='ISO Wet Stream',Available_Coeffient_of_Discharge__c='0.68');
    	insert objDiscCoef;

        String stPTC = 'KBA', stSeat = 'FS';
        Integer nSize = 100;
       // TestDataRDUtility.createRDMasterTestRecords();
        RDMasterBlaster__c objRDMasterBlaster=new RDMasterBlaster__c(SZC__c='0100', PTC__c='KBA' , STC__c='FS',MNFA__c = 0.86);
    	insert objRDMasterBlaster;

         // Load test data from static resource and add that data to table so that we have as accurate test env
         // Note: Needed to rename according to the actual configured Object name
        // ISODryKs__c[] ls = Test.loadData(ISODryKs__c.sObjectType, 'ISODryStreamKs');
        // System.debug('Size:' + ls.Size());

        double Qm = 24, P0 = 21.63, Xo = 2.678,Alpha=0.68;

        Result ret =  RDDiscSizingCapacity.ISOWetStreamCapacity(Qm,P0,Xo,nSize,stPTC, stSeat,Alpha,double.valueOf('1.1'));
        Result ret1 =  RDDiscSizingCapacity.ISOWetStreamCapacity(Qm,P0,Xo,200,stPTC, stSeat,Alpha,double.valueOf('1.1'));
        // Make sure operation is success
        // System.assertEquals(ret.bResult,true);

        // // Check size
        // System.assertEquals(ret.dblRetValue ,0.613522);
    }
    // // Test method for APIOmegaMTD2Phase Size
    @isTest static void testAPIOmegaMTD2PhaseSize() {

     System.debug('###Started APIOmegaMTD2Phase Test ###');
     DiscCoef__c objDiscCoef = new DiscCoef__c(Evaluation__c = 'API Omega Mtd 2-phase', Available_Coeffient_of_Discharge__c = '0.62');
     insert objDiscCoef;

     double Q = 350;
     double P0 = 80.6959;
     double V0 = 2.1;
     double V9 = 35;
     double MU = 2.5;
     double PA = 65.32;

     Result ret =  RDDiscSizingCapacity.APIOmegaMTD2PhaseSize(Q, P0, V0, V9, MU, PA);

     // Make sure operation is success
     System.assertEquals(ret.bResult, true);

     // Check size IMP Use rounding and match up these numbers.
     System.assertEquals(ret.dblRetValue, 0.686404);

    }


    // // Test method for FauskeHybridGVL  Capacity
    @isTest static void testAPIOmegaMTD2PhaseCapacity() {

     System.debug('###Started APIOmegaMTD2PhaseCapacity Test ###');
     DiscCoef__c objDiscCoef = new DiscCoef__c(Evaluation__c = 'API Omega Mtd 2-phase', Available_Coeffient_of_Discharge__c = '0.62');
     insert objDiscCoef;

     String stPTC = 'KBA', stSeat = 'FS';
     Integer nSize = 100;
  //   TestDataRDUtility.createRDMasterTestRecords();
     RDMasterBlaster__c objRDMasterBlaster = new RDMasterBlaster__c(SZC__c = '0100', PTC__c = stPTC, STC__c = stSeat, MNFA__c = 52.129);
     insert objRDMasterBlaster;

     double Q = 350;
     double P0 = 80.6959;
     double V0 = 2.1;
     double V9 = 35;
     double MU = 2.5;
     double PA = 65.32;

     Result ret =  RDDiscSizingCapacity.APIOmegaMTD2PhaseCapacity(P0, V0, V9, MU, PA, nSize, stPTC, stSeat,double.valueOf('1.1'));
     Result ret1 =  RDDiscSizingCapacity.APIOmegaMTD2PhaseCapacity(P0, V0, V9, MU, PA, 200, stPTC, stSeat,double.valueOf('1.1'));
     // Make sure operation is success
     System.assertEquals(ret.bResult, true);

     // Check size
   //  System.assertEquals(ret.dblRetValue,27722.761484);
    }
    // // Test method for APIOmegaMtdSubcool Size
    @isTest static void testAPIOmegaMtdSubcoolSize() {

     System.debug('###Started APIOmegaMtdSubcoolSize Test ###');
     DiscCoef__c objDiscCoef = new DiscCoef__c(Evaluation__c = 'API Omega Mtd Subcool', Available_Coeffient_of_Discharge__c = '0.62');
     insert objDiscCoef;

    /*
     double Q = 350;
     double PS = 80.6959;
     double P0 = 400;
     double P10 = 47;
     double P9 = 23;
     double MU = 0.1;
     double PA = 29.999;
    */
     double Q = 100;
     double PS = 107.6;
     double P0 = 300.6959;
     double P10 = 31.92;
     double P9 = 16.4;
     double MU = 0.01;
     double PA = 24.6959;
    // TestDataRDUtility.createRDMasterTestRecords();
     Result ret =  RDDiscSizingCapacity.APIOmegaMtdSubcoolSize(Q, PS, P0, P10, P9, MU, PA);

     // Make sure operation is success
     System.assertEquals(ret.bResult, true);

     // Check size IMP Use rounding and match up these numbers.
     System.assertEquals(ret.dblRetValue, 0.218455);

    }


    // Test method for APIOmegaMtdSubcool  Capacity
    @isTest static void testAPIOmegaMtdSubcoolCapacity() {

     System.debug('###Started APIOmegaMtdSubcoolCapacity Test ###');
     DiscCoef__c objDiscCoef = new DiscCoef__c(Evaluation__c = 'API Omega Mtd Subcool', Available_Coeffient_of_Discharge__c = '0.62');
     insert objDiscCoef;

     String stPTC = 'KBA', stSeat = 'FS';
     Integer nSize = 100;

     RDMasterBlaster__c objRDMasterBlaster = new RDMasterBlaster__c(SZC__c = '0100', PTC__c = stPTC, STC__c = stSeat, MNFA__c = 0.267623);
     insert objRDMasterBlaster;

     double Q = 100;
     double PS = 107.6;
     double P0 = 300.6959;
     double P10 = 31.92;
     double P9 = 16.4;
     double MU = 0.01;
     double PA = 24.6959;
//     TestDataRDUtility.createRDMasterTestRecords();
     Result ret =  RDDiscSizingCapacity.APIOmegaMtdSubcoolCapacity(PS, P0, P10, P9, MU, PA, nSize, stPTC, stSeat,double.valueOf('1.1'));
     Result ret1 =  RDDiscSizingCapacity.APIOmegaMtdSubcoolCapacity(PS, P0, P10, P9, MU, PA, 200, stPTC, stSeat,double.valueOf('1.1'));
     // Make sure operation is success
     System.assertEquals(ret.bResult, true);

     // Check size
     //System.assertEquals(ret.dblRetValue, 31361.684945);
    }
    //
    @isTest static void testSteamInterpolationISODryKs() {
        System.debug('###Started FauskeGasLiquidSize Test ###');
        DiscCoef__c objDiscCoef = new DiscCoef__c(Evaluation__c = 'Fauske Gas-Liquid', Available_Coeffient_of_Discharge__c = '0.62');
        insert objDiscCoef;
        //TestDataRDUtility.createRDMasterTestRecords();
        //TestDataRDUtility.createRDMasterTestRecords();
        double P0 = 1.1;
        double T0 = 104;
        Result ret =  RDDiscSizingCapacity.SteamInterpolationISODryKs(P0,T0);

        // Make sure operation is success
       // System.assertEquals(ret.bResult, true);
    }
     // Test method for FauskeGasLiquidSize
    @isTest static void testFauskeGasLiquidSize() {

        System.debug('###Started FauskeGasLiquidSize Test ###');
        DiscCoef__c objDiscCoef = new DiscCoef__c(Evaluation__c = 'Fauske Gas-Liquid', Available_Coeffient_of_Discharge__c = '0.62');
        insert objDiscCoef;

        double W = 50;
        double P0 = 700000;
        double PB = 100000;
        double K = 1.4;
        double T0 = 300;
        double MW = 29;
        double R = 8314;
        double X0 = 0.01;
        double P10 = 1000;

        Result ret =  RDDiscSizingCapacity.FauskeGasLiquidSize(W, P0, PB,K,T0,MW,R,X0,P10);

        // Make sure operation is success
        System.assertEquals(ret.bResult, true);

        // Check size IMP Use rounding and match up these numbers.
        System.assertEquals(ret.dblRetValue, 0.005451);

    }


    // Test method for FauskeGasLiquid  Capacity
    @isTest static void testFauskeGasLiquidCapacity() {

        System.debug('###Started FauskeGasLiquidCapacity Test ###');
        DiscCoef__c objDiscCoef = new DiscCoef__c(Evaluation__c = 'Fauske Gas-Liquid', Available_Coeffient_of_Discharge__c = '0.62');
        insert objDiscCoef;

        String stPTC = 'KBA', stSeat = 'FS';
        Integer nSize = 100;

        RDMasterBlaster__c objRDMasterBlaster = new RDMasterBlaster__c(SZC__c = '0100', PTC__c = stPTC, STC__c = stSeat, MNFA__c = 0.86);
        insert objRDMasterBlaster;

        double W = 50;
        double P0 = 700000;
        double PB = 100000;
        double K = 1.4;
        double T0 = 300;
        double MW = 29;
        double R = 8314;
        double X0 = 0.01;
        double P10 = 1000;
       // TestDataRDUtility.createRDMasterTestRecords();
        Result ret =  RDDiscSizingCapacity.FauskeGasLiquidCapacity(P0, PB,K,T0,MW,R,X0,P10, nSize, stPTC, stSeat,double.valueOf('1.1'));
        Result ret1 =  RDDiscSizingCapacity.FauskeGasLiquidCapacity(P0, PB,K,T0,MW,R,X0,P10, 200, stPTC, stSeat,double.valueOf('1.1'));
        // Make sure operation is success
        System.assertEquals(ret.bResult, true);

        // Check size
    //    System.assertEquals(ret.dblRetValue, 7888.521682);
    }
    // Test method for FauskeHybridGVL  Size
    @isTest static void testFauskeHybridGVLSize() {

     System.debug('###Started FauskeHybridGVLSize Test ###');
     DiscCoef__c objDiscCoef = new DiscCoef__c(Evaluation__c = 'Fauske Hybrid GVL', Available_Coeffient_of_Discharge__c = '0.62');
     insert objDiscCoef;

     double W = 100;
     double P0 = 1000000;
     double PB = 100000;
     double T0 = 443;
     double PG0 = 208000;
     double PV0 = 792000;
     double KG = 1.4;
     double KV = 1.324;
     double MWG = 29;
     double MWV = 18;
     double R = 8314;
     double X0 = 0.01;
     double P10 = 897;
     double C0 = 4366;
     double L0 = 2050000;
     double PV0_d = 4.12;

     Result ret = RDDiscSizingCapacity.FauskeHybridGVLSize(W, P0, PB, T0, PG0, PV0, KG, KV, MWG, MWV, R, X0, P10, C0, L0, PV0_d);

     // Make sure operation is success
     System.assertEquals(ret.bResult, true);

     // Check size IMP Use rounding and match up these numbers.
     //System.assertEquals(ret.dblRetValue, 0.012910);

    }


    // Test method for FauskeHybridGVL  Capacity
    @isTest static void testFauskeHybridGVLCapacity() {

     System.debug('###Started FauskeHybridGVLCapacity Test ###');
     DiscCoef__c objDiscCoef = new DiscCoef__c(Evaluation__c = 'Fauske Hybrid GVL', Available_Coeffient_of_Discharge__c = '0.62');
     insert objDiscCoef;

     String stPTC = 'KBA', stSeat = 'FS';
     Integer nSize = 100;

     RDMasterBlaster__c objRDMasterBlaster = new RDMasterBlaster__c(SZC__c = '0100', PTC__c = stPTC, STC__c = stSeat, MNFA__c = 0.0129);
     insert objRDMasterBlaster;

     double W = 100;
     double P0 = 1000000;
     double PB = 100000;
     double T0 = 443;
     double PG0 = 208000;
     double PV0 = 792000;
     double KG = 1.4;
     double KV = 1.324;
     double MWG = 29;
     double MWV = 18;
     double R = 8314;
     double X0 = 0.01;
     double P10 = 897;
     double C0 = 4366;
     double L0 = 2050000;
     double PV0_d = 4.12;
   //  TestDataRDUtility.createRDMasterTestRecords();
     Result ret = RDDiscSizingCapacity.FauskeHybridGVLCapacity(P0, PB, T0, PG0, PV0, KG,
                                                               KV, MWG, MWV, R, X0, P10, C0, L0, PV0_d, nSize, stPTC, stSeat,double.valueOf('1.1'));
    Result ret1 = RDDiscSizingCapacity.FauskeHybridGVLCapacity(P0, PB, T0, PG0, PV0, KG,
                                                               KV, MWG, MWV, R, X0, P10, C0, L0, PV0_d, 200, stPTC, stSeat,double.valueOf('1.1'));

     // Make sure operation is success
     System.assertEquals(ret.bResult, true);

     // Check size
    // System.assertEquals(ret.dblRetValue, 99.924655);
    }
    // Test method for FauskeVaporLiquid Size
    @isTest static void testFauskeVaporLiquidSize() {

        System.debug('###Started FauskeVaporLiquidSize Test ###');
        DiscCoef__c objDiscCoef = new DiscCoef__c(Evaluation__c = 'Fauske Vapor-Liquid', Available_Coeffient_of_Discharge__c = '0.62');
        insert objDiscCoef;

        double W = 300;
        double P0 = 2000000;
        double PB = 100000;
        double K = 1.26;
        double T0 = 245;
        double MW = 28;
        double R = 8314;
        double X0 = 0.01;
        double PV0 = 38.5;
        double L0 = 320000;
        double C0 = 3050;

        Result ret = RDDiscSizingCapacity.FauskeVaporLiquidSize(W, P0, PB,K,T0,MW,R,X0,PV0,L0,C0);

        // Make sure operation is success
        System.assertEquals(ret.bResult, true);

        // Check size IMP Use rounding and match up these numbers.
       // System.assertEquals(ret.dblRetValue, 0.035198);

    }


    // Test method for FauskeVaporLiquid  Capacity
    @isTest static void testFauskeVaporLiquidCapacity() {

        System.debug('###Started FauskeVaporLiquidCapacity Test ###');
        DiscCoef__c objDiscCoef = new DiscCoef__c(Evaluation__c = 'Fauske Vapor-Liquid', Available_Coeffient_of_Discharge__c = '0.62');
        insert objDiscCoef;

        String stPTC = 'KBA', stSeat = 'FS';
        Integer nSize = 100;

        RDMasterBlaster__c objRDMasterBlaster = new RDMasterBlaster__c(SZC__c = '0100', PTC__c = stPTC, STC__c = stSeat, MNFA__c = 0.86);
        insert objRDMasterBlaster;

       double W = 300;
        double P0 = 2000000;
        double PB = 100000;
        double K = 1.26;
        double T0 = 245;
        double MW = 28;
        double R = 8314;
        double X0 = 0.01;
        double PV0 = 38.5;
        double L0 = 320000;
        double C0 = 3050;
      //  TestDataRDUtility.createRDMasterTestRecords();
        Result ret = RDDiscSizingCapacity.FauskeVaporLiquidCapacity(P0, PB,K,T0,MW,R,X0,PV0,L0,C0, nSize, stPTC, stSeat,double.valueOf('1.1'));
        Result ret1 = RDDiscSizingCapacity.FauskeVaporLiquidCapacity(P0, PB,K,T0,MW,R,X0,PV0,L0,C0, 200, stPTC, stSeat,double.valueOf('1.1'));
        // Make sure operation is success
        System.assertEquals(ret.bResult, true);

        // Check size
        //System.assertEquals(ret.dblRetValue, 7329.920604);
	}
    // Test method for FauskeAllLiquidFlashingSize - SATURATED/Subcooled
    @isTest static void testFauskeAllLiquidFlashingSize() {

        System.debug('###Started FauskeAllLiquidFlashingSize Test ###');
        DiscCoef__c objDiscCoef = new DiscCoef__c(Evaluation__c = 'Fauske All Liquid Flashing', Available_Coeffient_of_Discharge__c = '0.62');
        insert objDiscCoef;

        double W = 100;
        double P0 = 1000000;
        double PB = 100000;
        double T0 = 443;
        double PG0 = 208000;
        double PV0 = 792000;
        double R = 8314;
        double C0 = 4366;
        double L0 = 2050000;
        double PV0_d = 4.12;
        double P10 = 897;
        boolean isSaturated = true;
       // public static Result FauskeAllLiquidFlashingSize(double W, double P0, double PB, double T0,
        //double PV0, double R, double C0,double L0, double PV0_d, double P10, boolean isSaturated)
        Result ret = RDDiscSizingCapacity.FauskeAllLiquidFlashingSize(W, P0, PB, T0, PV0,
                                                                      R, C0, L0, PV0_d, P10,isSaturated);

        // Make sure operation is success
        System.assertEquals(ret.bResult, true);

        // Check size IMP Use rounding and match up these numbers.
        //System.assertEquals(ret.dblRetValue, 0.026558);

        /////////////////////////////////////////// SUBCOOLED ////////////////////////////////////////
         W = 100;
         P0 = 1000000;
         PB = 100000;
         T0 = 443;
         PG0 = 208000;
         PV0 = 792000;
         R = 8314;
         C0 = 4366;
         L0 = 2050000;
         PV0_d = 4.12;
         P10 = 897;
        isSaturated = false;

        ret = RDDiscSizingCapacity.FauskeAllLiquidFlashingSize(W, P0, PB, T0, PV0, R, C0, L0, PV0_d, P10,isSaturated);

        // Make sure operation is success
        System.assertEquals(ret.bResult, true);

        // Check size IMP Use rounding and match up these numbers.
       // System.assertEquals(ret.dblRetValue, 0.007965);


    }

    // Test method for FauskeAllLiquidFlashingCapacity
    @isTest static void testFauskeAllLiquidFlashingCapacity() {

        System.debug('###Started testFauskeAllLiquidFlashingCapacity Test ###');
        DiscCoef__c objDiscCoef = new DiscCoef__c(Evaluation__c = 'Fauske All Liquid Flashing', Available_Coeffient_of_Discharge__c = '0.62');
        insert objDiscCoef;

        String stPTC = 'KBA', stSeat = 'FS';
        Integer nSize = 100;

        RDMasterBlaster__c objRDMasterBlaster = new RDMasterBlaster__c(SZC__c = '0100', PTC__c = stPTC, STC__c = stSeat, MNFA__c = 0.86);
        insert objRDMasterBlaster;


        double W = 100;
        double P0 = 1000000;
        double PB = 100000;
        double T0 = 443;
        double PG0 = 208000;
        double PV0 = 792000;
        double R = 8314;
        double C0 = 4366;
        double L0 = 2050000;
        double PV0_d = 4.12;
        double P10 = 897;
        boolean isSaturated = true;
       // TestDataRDUtility.createRDMasterTestRecords();
        Result ret = RDDiscSizingCapacity.FauskeAllLiquidFlashingCapacity(double.valueOf('1.1'),T0,
                                                               C0, L0, PV0_d, P10, nSize, stPTC, stSeat,isSaturated,P0,double.valueOf('1.1'));
        Result ret1 = RDDiscSizingCapacity.FauskeAllLiquidFlashingCapacity(double.valueOf('1.1'),T0,
                                                               C0, L0, PV0_d, P10, 200, stPTC, stSeat,isSaturated,P0,double.valueOf('1.1'));

        // Make sure operation is success
        System.assertEquals(ret.bResult, true);

        // Check size
    //    System.assertEquals(ret.dblRetValue, 3238.153925);


        //////////////////////////////////////////////SUBCOOLED///////////////////////
         W = 100;
         P0 = 1000000;
         PB = 100000;
         T0 = 443;
         PG0 = 208000;
         PV0 = 792000;
         R = 8314;
         C0 = 4366;
         L0 = 2050000;
         PV0_d = 4.12;
         P10 = 897;
         isSaturated = false ;

        ret =  RDDiscSizingCapacity.FauskeAllLiquidFlashingCapacity(double.valueOf('1.1'),T0,C0, L0, PV0_d, P10, nSize, stPTC, stSeat,isSaturated,P0,double.valueOf('1.1'));
        ret1 =  RDDiscSizingCapacity.FauskeAllLiquidFlashingCapacity(double.valueOf('1.1'),T0,C0, L0, PV0_d, P10, 200, stPTC, stSeat,isSaturated,P0,double.valueOf('1.1'));
        // Make sure operation is success
        System.assertEquals(ret.bResult, true);

        // Check size
       // System.assertEquals(ret.dblRetValue, 10796.925039);
    }
}