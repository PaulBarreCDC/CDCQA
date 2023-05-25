@isTest
public class unitConversionsTest {

 @isTest static void UnitTestMethod1(){

        Test.startTest();
        result res=new result();     	
     
     	List<SelectOption> options = new List<SelectOption>();
     	options=unitConversions.optsGasFlowRate;
     	options=unitConversions.optsLiquidFlowRate;
     	options=unitConversions.optsStreamFlowRate;

     	map<string,string> myMap1 =new map<string,string>();
     	myMap1=unitConversions.mapRD_DensityatSaturationPressureBaseUOM;
     	myMap1=unitConversions.mapRD_DensityBaseUOM;
     	myMap1=unitConversions.mapRD_DensitySpecificVolumeSpecificGravityBaseUOM;
        myMap1=unitConversions.mapRD_FlowRateBaseUOM;
        myMap1=unitConversions.mapRD_LiquidDensityBaseUOM;
        myMap1=unitConversions.mapRD_RelievingPressureBaseUOM;
        myMap1=unitConversions.mapRD_RelievingTemperatureBaseUOM;
        myMap1=unitConversions.mapRD_SaturationPressureAtInletBaseUOM;
        myMap1=unitConversions.mapRD_SpecificGravityBaseUOM;
        myMap1=unitConversions.mapRD_SpecificVolumeAt90inletBaseUOM;
        myMap1=unitConversions.mapRD_SpecificVolumeBaseUOM;
        myMap1=unitConversions.mapRD_StagnationGasPartialPressureBaseUOM;
        myMap1=unitConversions.mapRD_StagnationVaporDensityBaseUOM;
        myMap1=unitConversions.mapRD_VaporPressCorrespondToStagnationTempBaseUOM;
        myMap1=unitConversions.mapRD_ViscosityBaseUOM;

     	//convertArea Method
      	List<sObject> data1 = Test.loadData(Area__c.sObjectType, 'TestData_AreaTable');
        res=unitConversions.convertArea('cm2','m2',100);
     	res=unitConversions.convertArea('cm2','abc',100);      
		res=unitConversions.convertArea('cm2','m2',null);
     	//convertDensity Method
      	List<sObject> data2 = Test.loadData(Density__c.sObjectType, 'TestData_DensityTable');
        res=unitConversions.convertDensity('kg/L', 'kg/m3',10);
        res=unitConversions.convertDensity('kg/L', 'abc',10);
     	res=unitConversions.convertDensity('kg/L', 'kg/m3',null);
     	//convertDensitySpecifyVolume Method
      	List<sObject> data3 = Test.loadData(Density_SpecificVolume__c.sObjectType, 'TestData_DensitySpecificVolumeTable');
        res=unitConversions.convertDensitySpecifyVolume('kg/L', 'kg/m3',10);
     	res=unitConversions.convertDensitySpecifyVolume('kg/L', 'abc',10);
     	res=unitConversions.convertDensitySpecifyVolume('kg/L', 'kg/m3',null);
     	//convertDistance Method
      	List<sObject> data4 = Test.loadData(Distance__c.sObjectType, 'TestData_DistanceTable');
        res=unitConversions.convertDistance('cm','m', 100);
     	res=unitConversions.convertDistance('cm','abc', 100);
     	res=unitConversions.convertDistance('cm','m', null);
     	//convertLiquidFlowRate Method
      	List<sObject> data5 = Test.loadData(LiquidFlowRate__c.sObjectType, 'TestData_LiquidFlowRateTable');
        res=unitConversions.convertLiquidFlowRate('ft3/h','lb/h', 1, 1);
     	res=unitConversions.convertLiquidFlowRate('ft3/h','abc', 1, 1);
     	res=unitConversions.convertLiquidFlowRate('ft3/h','lb/h', null, null);
     	//convertViscosity Method
      	List<sObject> data6 = Test.loadData(Viscosity__c.sObjectType, 'TestData_ViscosityTable');
        res=unitConversions.convertViscosity('poise','centipoise', 1);
     	res=unitConversions.convertViscosity('poise','abc', 1);
     	res=unitConversions.convertViscosity('poise','centipoise', null);
     	//convertVolume Method
      	List<sObject> data7 = Test.loadData(Volume__c.sObjectType, 'TestData_VolumeTable');
        res=unitConversions.convertVolume('in3','liter',1);
     	res=unitConversions.convertVolume('in3','abc',1);
     	res=unitConversions.convertVolume('in3','liter',null);
     
     	//convertPressure Method
      	List<sObject> data8 = Test.loadData(Pressure__c.sObjectType, 'TestData_PressureTable');
        res=unitConversions.convertPressure('psig','psia',100);
     	res=unitConversions.convertPressure('psig','abc',100);
     	res=unitConversions.convertPressure('psig','psia',null);
     	res=unitConversions.getConvertedValErrorMsg('Pressure',0, 18, 'psig', 'psia',5,'PilotsSupplyPressure');     
        res=unitConversions.getConvertedValErrorMsg('Pressure',1, 1, 'psig', 'psig',1,'PilotsSupplyPressure');
     	res=unitConversions.getConvertedValErrorMsg('Pressure',null,null, 'psig', 'psig',null,'PilotsSupplyPressure');
     	//convertTemperature Method
      	List<sObject> data9 = Test.loadData(Temparature__c.sObjectType, 'TestData_TemperatureTable');
        res=unitConversions.convertTemperature('Deg C', 'Deg F', 100);
     	res=unitConversions.convertTemperature('Deg C', 'abc', 100);
     	res=unitConversions.convertTemperature('Deg C', 'Deg F', null);
     	res=unitConversions.getConvertedValErrorMsg('Temperature', 0, 1000, 'Deg C', 'Deg F',100,'Temperature');
        res=unitConversions.getConvertedValErrorMsg('Temperature', 1, 1, 'Deg C', 'Deg C',1,'Temperature');
     	res=unitConversions.getConvertedValErrorMsg('Temperature', null, null, 'Deg C', 'Deg C',null,'Temperature');
        //convertGasFlowRate Method
      	List<sObject> data10 = Test.loadData(GasFlowRate__c.sObjectType, 'TestData_GasFlowRateTable');
        res=unitConversions.convertGasFlowRate('SCFH','SCFH',10,1,1,1,1);
     	res=unitConversions.convertGasFlowRate('SCFH','abc',10,1,1,1,1);
     	res=unitConversions.convertGasFlowRate('SCFH','SCFH',null,1,1,1,1);
     	res=unitConversions.getConvertedValErrorMsg('GasFlowRate', 0, 1000, 'SCFH', 'SCFH',5,'FlowRate');
     	res=unitConversions.getConvertedValErrorMsg('GasFlowRate', 1, 0.1, 'SCFH', 'SCFH',1,'FlowRate');
     	res=unitConversions.getConvertedValErrorMsg('GasFlowRate', null, null, 'SCFH', 'SCFH',null,'FlowRate');
        res=unitConversions.getConvertedValErrorMsg('WGBGasFlowRate',0,1000, 'SCFH', 'SCFH',5,'FlowRate');
        res=unitConversions.getConvertedValErrorMsg('WGBGasFlowRate',1,0.1, 'SCFH', 'SCFH',1,'FlowRate');
        res=unitConversions.getConvertedValErrorMsg('WGBGasFlowRate',null,null, 'SCFH', 'SCFH',null,'FlowRate');
       
     	//Rounding Methods
     	decimal res1=unitConversions.RoundDown(100, 3);
        decimal res2=unitConversions.RoundUp(100, 3);
        decimal res3=unitConversions.RoundNormal(100, 3);
        decimal res4=unitConversions.RoundDown(null, null);
        decimal res5=unitConversions.RoundUp(null, null);
        decimal res6=unitConversions.RoundNormal(null, null);
        res=unitConversions.SignificantDigitsDown(100, 3, 3);
        res=unitConversions.SignificantDigitsDown(null, null, null);
        res=unitConversions.SignificantDigitsUp(100, 3, 3);
     	res=unitConversions.SignificantDigitsUp(null, null, null);
        res=unitConversions.SignificantDigitsNormal(100, 3, 3); 
      	res=unitConversions.SignificantDigitsNormal(100, 3, 0);         
        res=unitConversions.SignificantDigitsNormal(null, null, null);
     
     	decimal multiplyAddVar1= unitConversions.multiplyAndAdd(0.12, 10);
     	decimal multiplyAddVar2= unitConversions.multiplyAndAdd(0.001, 10);
     	decimal multiplyAddVar3= unitConversions.multiplyAndAdd(5, 10);
     	decimal multiplyAddVar4= unitConversions.multiplyAndAdd(50, 10);
     	    
        Test.stopTest();
    }
}