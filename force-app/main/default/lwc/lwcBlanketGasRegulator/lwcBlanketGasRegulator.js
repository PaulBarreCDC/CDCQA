import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';

import BGR_OBJECT from '@salesforce/schema/BGR__c';                       
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';

//import saveSetting from '@salesforce/apex/BlanketGasRegulatorController.saveSetting';
import saveRelief from '@salesforce/apex/BlanketGasRegulatorController.saveRelief';
//import saveAtm from '@salesforce/apex/BlanketGasRegulatorController.saveAtm';
import SupplyGas from '@salesforce/apex/BlanketGasRegulatorController.SupplyGas';
import saveSectionB from '@salesforce/apex/BlanketGasRegulatorController.saveSectionB';
import showSectionB from '@salesforce/apex/BlanketGasRegulatorController.showSectionB';
import saveCertificate from '@salesforce/apex/BlanketGasRegulatorController.saveCertificate';
import saveProductSelection from '@salesforce/apex/BlanketGasRegulatorController.saveProductSelection';
import saveProductMaterials from '@salesforce/apex/BlanketGasRegulatorController.saveProductMaterials';
import saveDocSourcing from '@salesforce/apex/BlanketGasRegulatorController.saveDocSourcing';
import saveValveExamination from '@salesforce/apex/BlanketGasRegulatorController.saveValveExamination';
import fetchFormAccessibility from '@salesforce/apex/BlanketGasRegulatorController.fetchFormAccessibility'; // @added by piyush
import fetchUserInfo from '@salesforce/apex/BlanketGasRegulatorController.fetchUserInfo'; // @added by piyush
//import savePressureSetting from '@salesforce/apex/BlanketGasRegulatorController.savePressureSetting';




import Service_Type_FIELD from '@salesforce/schema/BGR__c.Service_Type__c';
import Atex__c_FIELD from '@salesforce/schema/BGR__c.Atex__c';
import GOST_CU_Tr_010_2011_FIELD from '@salesforce/schema/BGR__c.GOST_CU_Tr_010_2011__c';
import CSA_Markings_FIELD from '@salesforce/schema/BGR__c.CSA_Markings__c';
import Radiography_FIELD from '@salesforce/schema/BGR__c.Radiography__c';
import Positive_Material_Identification_FIELD from '@salesforce/schema/BGR__c.Positive_Material_Identification__c';
import Shell_test_FIELD from '@salesforce/schema/BGR__c.Shell_test__c';
import Shell_Test_Valve_Body_FIELD from '@salesforce/schema/BGR__c.Shell_Test_Valve_Body__c';

import Setting_FIELD from '@salesforce/schema/BGR__c.Setting__c';
import Setting_Units_FIELD from '@salesforce/schema/BGR__c.Setting_Units__c';
import Supply_Pressure_FIELD from '@salesforce/schema/BGR__c.Supply_Pressure__c';
import Supply_Pressure_Units_FIELD from '@salesforce/schema/BGR__c.Supply_Pressure_Units__c';
import Brand_FIELD from '@salesforce/schema/BGR__c.Brand__c';
import Atmospheric_Pressure_FIELD from '@salesforce/schema/BGR__c.Atmospheric_Pressure__c';
import Atmospheric_Pressure_Units_FIELD from '@salesforce/schema/BGR__c.Atmospheric_Pressure_Units__c';
import Narrow_selection_on_flow_requirements_FIELD from '@salesforce/schema/BGR__c.Narrow_selection_on_flow_requirements__c';
import Converted_Supply_Pressure_FIELD from '@salesforce/schema/BGR__c.Converted_Supply_Pressure__c';
import Converted_Setting__FIELD from '@salesforce/schema/BGR__c.Converted_Setting__c';
import PresRatio_FIELD from '@salesforce/schema/BGR__c.PresRatio__c';
import Ratio_of_Specific_Heats_FIELD from '@salesforce/schema/BGR__c.Ratio_of_Specific_Heats__c';
import Converted_Atmospheric_Pressure_FIELD from '@salesforce/schema/BGR__c.Converted_Atmospheric_Pressure__c';
import Molecular_Weight_FIELD from '@salesforce/schema/BGR__c.Molecular_Weight__c';
import Converted_Supply_Gas_Temperature_FIELD from '@salesforce/schema/BGR__c.Converted_Supply_Gas_Temperature__c';
import Supply_Gas_Temperature_FIELD from '@salesforce/schema/BGR__c.Supply_Gas_Temperature__c';

import Minimum_Required_Flow_Capacity_FIELD from '@salesforce/schema/BGR__c.Minimum_Required_Flow_Capacity__c';
//import FlowUnits from '@salesforce/schema/BGR__c.Flow_Units__c';
import Compressibility_Factor_FIELD from '@salesforce/schema/BGR__c.Compressibility_Factor__c';
import Converted_Flow_Capacity_FIELD from '@salesforce/schema/BGR__c.Converted_Flow_Capacity__c';
import Quote_Line_FIELD from '@salesforce/schema/BGR__c.Quote_Line__c';
import Combo_Orifice_Setting_FIELD from '@salesforce/schema/BGR__c.Combo_Orifice_Setting__c';
import Supply_Gas_FIELD from '@salesforce/schema/BGR__c.Supply_Gas__c';
import Model_FIELD from '@salesforce/schema/BGR__c.Model__c';
import Size_FIELD from '@salesforce/schema/BGR__c.Size__c';
import Connection_FIELD from '@salesforce/schema/BGR__c.Connection__c';
import Soft_Goods_Material_FIELD from '@salesforce/schema/BGR__c.Soft_Goods_Material__c';
import Id from '@salesforce/user/Id';
const FIELDS = [
    'User.Name',
    'User.IsPortalEnabled'
];

import Price_Engineer_Override from '@salesforce/schema/BGR__c.Price_Engineer_Override__c';
import Lead_Time_Engineer_Override from '@salesforce/schema/BGR__c.Lead_Time_Engineer_Override__c';
import Build_Cost_Override from '@salesforce/schema/BGR__c.Build_Cost_Override__c';
import Quote_Description_Engineer_Override from '@salesforce/schema/BGR__c.Quote_Description_Engineer_Override__c';





const BGRFields = [Price_Engineer_Override,Lead_Time_Engineer_Override,Build_Cost_Override,Quote_Description_Engineer_Override,Service_Type_FIELD, Atex__c_FIELD, GOST_CU_Tr_010_2011_FIELD, CSA_Markings_FIELD, Radiography_FIELD, Positive_Material_Identification_FIELD, 
    Shell_test_FIELD,Shell_Test_Valve_Body_FIELD,  Setting_Units_FIELD, Supply_Pressure_Units_FIELD, Brand_FIELD, Supply_Pressure_FIELD, Setting_FIELD, Atmospheric_Pressure_FIELD, 
	Atmospheric_Pressure_Units_FIELD, Narrow_selection_on_flow_requirements_FIELD, Converted_Supply_Pressure_FIELD, Converted_Setting__FIELD, PresRatio_FIELD, Ratio_of_Specific_Heats_FIELD,
    Converted_Atmospheric_Pressure_FIELD, Molecular_Weight_FIELD, Converted_Supply_Gas_Temperature_FIELD, Supply_Gas_Temperature_FIELD, Minimum_Required_Flow_Capacity_FIELD, 
    //FlowUnits,
    Quote_Line_FIELD, Compressibility_Factor_FIELD, Converted_Flow_Capacity_FIELD, Combo_Orifice_Setting_FIELD, Supply_Gas_FIELD, Model_FIELD, Connection_FIELD, Size_FIELD,
    Soft_Goods_Material_FIELD,Brand_FIELD];
export default class lwcBlanketGasRegulator extends NavigationMixin(LightningElement) {
    
    @api number = 0;
    userId = Id;
    currentUserInfo = {};
    @api recordId;
    @api quoteId;
    @track quoteLineId;
    @track serviceTypeOptions;
    @track error;
    @track selectedTypeOption;
    @track atexOptions;
    @track selectedAtexOption;
    @track gOST_CU_Tr_010_2011Options;
    @track selectedGOST_CU_Tr_010_2011Option;
    @track cSA_MarkingsOptions;
    @track selectedCSA_MarkingsOption;
    @track radiographyOptions;
    @track selectedRadiographyOptions;
    @track PositiveMaterialIdentificationOptions;
    @track selectedPositiveMaterialIdentificationOption;
    @track ShellTestOptions;
    @track selectedShellTestOptions;
    @track ShellTestValveBodyOptions;
    @track selectedShellTestValveBodyOption;
    @track isNarrowSelectionOnFlowRequirements ;

    @track settings;
    @track settingUnits;
    @track bgrConvertedSetting;
    @track supplyPressureUnits;
    @track supplyPressure;
    @track Brand;
    @track bgrConvertedSupplyPressure;
    @track atmosphericPressure;
    @track atmosphericPressureUnits;
	@track bgrConvertedAtmosphericPressure;
	
	@track customerSpecifiedMedia;
	@track molecularWeight;
	@track compressibilityFactor;
    @track ratioOfSpecificHeats;
    
    @track SupplyGasTemperature;
    @track SupplyGasTemperatureUnits;
    @track MinimumRequiredFlowCapacity;
    @track flowUnits;
    @track supplyGasVal;

	bgrPresRatio;
	convertedSupplyGasTemperature;
    convertedFlowCapacity;
   

	@track comboOrificeSettingOptions;
    @track comboOrificeSettingVal;
    
    @track setRequiredCustomerSpecified = false;

    @track bgrRecord;
    @track sizeVal;
    @track disableForNonCustomerSpecified;
    supplyGasFieldVal;
    modelValue;
    @track sizeOptions = [];

    //Error Handling SectionWise
    @track section1ErrorMessage;
    @track isErrorSection1;
    @track section2ErrorMessage;
    @track isErrorSection2;
    @track section3ErrorMessage;
    @track isErrorSection3;
    @track section4ErrorMessage;
    @track isErrorSection4;

    section1Saved = true;
    section2Saved = true;
    section3Saved = true;
    bShowEditBtn = false;
    sDisabled = '';
    bDisabled = false;
    sEditBtnLabel = 'Edit';
    bShowProductReviewLink = false;
    oPopupPDF;
    bHideReturnToQuote = false;
    enableEditMode(){
        this.sEditBtnLabel = this.sEditBtnLabel == 'Edit' ? 'Cancel' : 'Edit'; 
        if(this.sEditBtnLabel == 'Cancel'){
            this.bShowProductReviewLink = false;
            this.thisoPopupPDF = window.open('/apex/ConfigBgrReference?Id=' + this.recordId , "", "width=500,height=500");
        }else{
            this.bShowProductReviewLink = true;
        }
        this.sDisabled = this.sDisabled == '' ? 'disabled' : '';
        this.bDisabled = this.bDisabled == true ? false : true;
    }

    @wire(getRecord, { recordId: '$userId', fields: FIELDS })
    oUser({ error, data }) {
        if (data) {
			console.log('===> USER' + JSON.stringify(data));
			this.currentUserInfo = data;
        } else if (error) {
            console.log('===> error' + JSON.stringify(error));
        }
    }

    @wire(getRecord, { recordId: '$recordId', fields: BGRFields})
    brgRecord({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while loading BGR',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data) {
            if(data !== undefined){
                //this.ruptureDiscRecordData = {...data};
                this.selectedTypeOption = data.fields.Service_Type__c.value;
                console.log('Data BGR ',JSON.stringify(data));

                this.selectedAtexOption = data.fields.Atex__c.value;
                this.selectedGOST_CU_Tr_010_2011Option = data.fields.GOST_CU_Tr_010_2011__c.value;
                this.selectedCSA_MarkingsOption = data.fields.CSA_Markings__c.value;
                this.settings = data.fields.Setting__c.value;
                this.settingUnits = data.fields.Setting_Units__c.value;
                this.supplyPressure = data.fields.Supply_Pressure__c.value;
                this.supplyPressureUnits = data.fields.Supply_Pressure_Units__c.value;
                this.Brand = data.fields.Brand__c.value;
                this.atmosphericPressure = data.fields.Atmospheric_Pressure__c.value;
                this.atmosphericPressureUnits = data.fields.Atmospheric_Pressure_Units__c.value;
                console.log('in get record method before',this.isNarrowSelectionOnFlowRequirements);
                this.isNarrowSelectionOnFlowRequirements = data.fields.Narrow_selection_on_flow_requirements__c.value;
                console.log('in get record method after',this.isNarrowSelectionOnFlowRequirements);
                this.bgrConvertedSupplyPressure = data.fields.Converted_Supply_Pressure__c.value;
                this.bgrConvertedSetting = data.fields.Converted_Setting__c.value;
				this.bgrPresRatio = data.fields.PresRatio__c.value;
				this.ratioOfSpecificHeats = data.fields.Ratio_of_Specific_Heats__c.value;
				this.bgrConvertedAtmosphericPressure = data.fields.Converted_Atmospheric_Pressure__c.value;
				this.molecularWeight = data.fields.Molecular_Weight__c.value;
                this.convertedSupplyGasTemperature = data.fields.Converted_Supply_Gas_Temperature__c.value;
                this.SupplyGasTemperature = data.fields.Supply_Gas_Temperature__c.value; 
				this.compressibilityFactor = data.fields.Compressibility_Factor__c.value;
                this.convertedFlowCapacity = data.fields.Converted_Flow_Capacity__c.value;
                this.MinimumRequiredFlowCapacity = data.fields.Minimum_Required_Flow_Capacity__c.value;
               // this.flowUnits = data.fields.Flow_Units__c.value;
                this.selectedRadiographyOptions = data.fields.Radiography__c.value;
                this.selectedPositiveMaterialIdentificationOption = data.fields.Positive_Material_Identification__c.value;
                this.selectedShellTestOptions = data.fields.Shell_test__c.value;
                this.selectedShellTestValveBodyOption = data.fields.Shell_Test_Valve_Body__c.value;
                this.quoteLineId = data.fields.Quote_Line__c.value;
                this.supplyGasFieldVal = data.fields.Supply_Gas__c.value;
                this.comboOrificeSettingVal = data.fields.Combo_Orifice_Setting__c.value;
                if(this.comboOrificeSettingVal){
                    this.comboOrificeSettingOptions = [
                        { label: this.comboOrificeSettingVal, value: this.comboOrificeSettingVal }];
                }
                this.modelValue = data.fields.Model__c.value;
                this.connectionVal = data.fields.Connection__c.value;
                this.sizeVal = data.fields.Size__c.value;
                this.sizeOptions.push({label:data.fields.Size__c.displayValue, value:this.sizeVal});
                this.SoftGoodsMaterialVal = data.fields.Soft_Goods_Material__c.value;
                this.bgrRecord = {...data};

                if(this.supplyGasFieldVal === 'Customer Specified'){
                    this.disableForNonCustomerSpecified = false;
                }else{
                    this.disableForNonCustomerSpecified = true;
                }
                
                console.log('BGR Record ## ', this.bgrRecord);

                this.afterBRGDataLoad();
            }
           
        }
    }

    // added by piyush for readonly / editable
    afterBRGDataLoad(){
        console.log('record Id - ' + this.recordId);
        console.log('quote Id - ' + this.quoteId);
        console.log('quote line Id - ' + this.quoteLineId);


        fetchFormAccessibility({qliId : this.quoteLineId})
        .then(result => {
            console.log('Result ***** ---> ' + JSON.stringify(result));  
            this.bShowEditBtn = result.bShowEditButton;
            
            if(result.bConfigurationComplete){
              this.bShowProductReviewLink = true;
            }

            if(!result.bReadOnly){
                this.sDisabled = '';
                this.bDisabled = false;
            }else{
                this.sDisabled = 'disabled';
                this.bDisabled = true;
            }


            // added by piyush 
            fetchUserInfo()
         .then(sResult => {
            console.log('this.bgrRecord.fields.Price_Engineer_Override__c.value ---> ' + this.bgrRecord.fields.Price_Engineer_Override__c.value);
            console.log('this.bgrRecord.fields.Lead_Time_Engineer_Override__c.value ---> ' + this.bgrRecord.fields.Lead_Time_Engineer_Override__c.value);
            console.log('this.bgrRecord.fields.Build_Cost_Override__c.value ---> ' + this.bgrRecord.fields.Build_Cost_Override__c.value);
            console.log('this.bgrRecord.fields.Quote_Description_Engineer_Override__c.value ---> ' + this.bgrRecord.fields.Quote_Description_Engineer_Override__c.value);
            let profileName = sResult.Profile.Name;
            // added by piyush soni 10/14/2020
            if(profileName != 'CDC Engineering' &&  profileName != 'System Administrator'){
                if(this.bgrRecord.fields.Price_Engineer_Override__c.value == true || 
                  this.bgrRecord.fields.Lead_Time_Engineer_Override__c.value == true || 
                  this.bgrRecord.fields.Build_Cost_Override__c.value == true || 
                  this.bgrRecord.fields.Quote_Description_Engineer_Override__c.value == true
                ){
                       console.log('inside');
                     this.sDisabled = 'disabled';
                     this.bDisabled = true;
                     this.bShowEditBtn = false;
                }
            }
            
        })
        .catch(error => {
            console.log('error fetchUserInfo ---> ' + JSON.stringify(error)); 
        });

  

        })
        .catch(error => {
           console.log('error ---> ' + JSON.stringify(error)); 
        });
    }

    @wire(getObjectInfo, { objectApiName: BGR_OBJECT })
        objectInfo;

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : Service_Type_FIELD
    })
    wiredPickListValue({ data, error }){
        if(data){
            this.error = undefined;
            this.serviceTypeOptions = data.values;
        }
        if(error){
            this.error = error;
            this.serviceTypeOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : Atex__c_FIELD
    })
    wiredAtexPickListValue({ data, error }){
        if(data){
            this.atexOptions = [];

            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,dummyVal:element.value + "3",generatedId:'Atex'+element.value};
                this.atexOptions.push(newElement);
            });
            this.error = undefined;
            //this.atexOptions = data.values;
        }
        if(error){
            this.error = error;
            this.atexOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : GOST_CU_Tr_010_2011_FIELD
    })
    wiredGOST_CU_Tr_010_2011PickListValue({ data, error }){
        if(data){
            this.gOST_CU_Tr_010_2011Options = [];

            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,dummyVal:element.value + "1",generatedId:'GOST_CU_Tr_010_2011'+element.value};
                this.gOST_CU_Tr_010_2011Options.push(newElement);
            });
            this.error = undefined;
            //this.gOST_CU_Tr_010_2011Options = data.values;
        }
        if(error){
            this.error = error;
            this.gOST_CU_Tr_010_2011Options = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : CSA_Markings_FIELD
    })
    wiredCSA_MarkingsPickListValue({ data, error }){
        if(data){
            this.cSA_MarkingsOptions = [];

            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,dummyVal:element.value + "2",generatedId:'CSA_Markings'+element.value};
                this.cSA_MarkingsOptions.push(newElement);
            });
            this.error = undefined;
            //this.cSA_MarkingsOptions = data.values;
        }
        if(error){
            this.error = error;
            this.cSA_MarkingsOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : Radiography_FIELD
    })
    wiredRadiographyPickListValue({ data, error }){
        if(data){
            //this.radiographyOptions = data.values;
            this.radiographyOptions = [];

            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,dummyVal:element.value + "9966",generatedId:'radiography'+element.value+'Id'};
                this.radiographyOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.radiographyOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : Positive_Material_Identification_FIELD
    })
    wiredPositiveMaterialIdentificationPickListValue({ data, error }){
        if(data){
            this.PositiveMaterialIdentificationOptions = data.values;
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.PositiveMaterialIdentificationOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : Shell_test_FIELD
    })
    wiredShell_testPickListValue({ data, error }){
        if(data){
            //this.ShellTestOptions = data.values;
            this.ShellTestOptions = [];

            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,dummyVal:element.value + "1111",generatedId:'shellTest'+element.value+'Id'};
                this.ShellTestOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.ShellTestOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : Shell_Test_Valve_Body_FIELD
    })
    wiredShell_Test_Valve_BodyPickListValue({ data, error }){
        if(data){
            this.ShellTestValveBodyOptions = data.values;
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.ShellTestValveBodyOptions = undefined;
        }
    }

    
    handleServiceTypeOptions(event){
        this.selectedTypeOption = event.target.value;
        this.onPressureVacuumSettingsUpdate();
    }

    handleAtexOptions(event){
        this.selectedAtexOption = event.target.value;
        this.section3Saved = false; // @developer
    }

    handleGOST_CU_Tr_010_2011Options(event){
        this.selectedGOST_CU_Tr_010_2011Option = event.target.value;
        this.section3Saved = false; // @developer
    }

    handleCSA_MarkingsOptions(event){
        this.selectedCSA_MarkingsOption = event.target.value;
        this.section3Saved = false; // @developer
    }

    handleRadiographyOptions(event){
        this.selectedRadiographyOptions = event.target.value;
    }

    handlePositiveMaterialIdentificationOptions(event){
        this.selectedPositiveMaterialIdentificationOption = event.target.value;
    }

    handleShellTestOptions(event){
        this.selectedShellTestOptions = event.target.value;
    }

    handleShellTestValveBodyOptions(event){
        this.selectedShellTestValveBodyOption = event.target.value;
    }

    
    handleSetting(event){
        console.log("You selected " + event.detail.value);
        this.settings = event.detail.value;
        // if(this.settings){
        //     this.calculateConvertedSetting();
        // }
        
    }

    handleSettingUnits(event){
        this.settingUnits = event.detail.value;
        this.onPressureVacuumSettingsUpdate();
        // if(this.settingUnits){
        //     this.calculateConvertedSetting();
        // }
        
    }
    /*
    calculateConvertedSetting(){
        if(this.settingUnits !== null && this.settingUnits !== undefined  && this.settingUnits !== ''){
            let bgrObj = { 'sobjectType': 'BGR__c'};
            bgrObj.Setting__c = this.settings;
            bgrObj.Setting_Units__c = this.settingUnits;
            saveSetting({brgRecord: bgrObj})
            .then(result => {
                this.bgrConvertedSetting = result.Converted_Setting__c;
                console.log(' calculateConvertedSetting result === ', result);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: error.statusText,
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
        }
    }
    */
    handleSupplyPressure(event){
        this.supplyPressure = event.detail.value;
        // if(this.supplyPressure){
        //     this.calculateConvertedSupplyPressure();
        // }
        
    }

    handleSupplyPressureUnits(event){
        this.supplyPressureUnits = event.detail.value;
        this.onPressureVacuumSettingsUpdate();
        // if(this.supplyPressureUnits){
        //     this.calculateConvertedSupplyPressure();
        // }
    }
    /*
    calculateConvertedSupplyPressure(){
        if(this.supplyPressureUnits !== null && this.supplyPressureUnits !== undefined && this.supplyPressureUnits !== ''){
            let bgrObj = { 'sobjectType': 'BGR__c'};
            bgrObj.Supply_Pressure__c = this.supplyPressure;
            bgrObj.Supply_Pressure_Units__c = this.supplyPressureUnits;
            bgrObj.Setting__c = this.settings;
            bgrObj.Setting_Units__c = this.settingUnits;
            bgrObj.Id = this.recordId;
            bgrObj.Service_Type__c = this.selectedTypeOption;
            savePressureSetting({brgRecord: bgrObj})
            .then(result => {
                this.bgrConvertedSupplyPressure = result.Converted_Supply_Pressure__c;
                console.log('calculateConvertedSupplyPressure result === ', result);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: error.statusText,
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
        }
    }
    */
    handleAtmosphericPressure(event){
        this.atmosphericPressure = event.detail.value;
        // if(this.atmosphericPressure){
        //     this.calculateConvertedAtmosphericPressure();
        // }
        
    }

    handleAtmosphericPressureUnits(event){
        this.atmosphericPressureUnits = event.detail.value;
        // if(this.atmosphericPressureUnits){
        //     this.calculateConvertedAtmosphericPressure();
        // }
        
    }
/*
    calculateConvertedAtmosphericPressure(){
        if(this.atmosphericPressureUnits !== null && this.atmosphericPressureUnits !== undefined && this.atmosphericPressureUnits !== ''){
            let bgrObj = { 'sobjectType': 'BGR__c'};
            bgrObj.Atmospheric_Pressure__c = this.atmosphericPressure;
            bgrObj.Atmospheric_Pressure_Units__c = this.atmosphericPressureUnits;
            saveAtm({brgRecord: bgrObj})
            .then(result => {
                this.bgrConvertedAtmosphericPressure = result.Converted_Atmospheric_Pressure__c;
                console.log(' calculateConvertedAtmosphericPressure result === ', result);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: error.statusText,
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
        }
    }*/

    handleNarrowSelection(event){
        this.onPressureVacuumSettingsUpdate();
        console.log('selected ++ ', this.template.querySelector('.narrowSelectionFlow').checked);
        this.isNarrowSelectionOnFlowRequirements = this.template.querySelector('.narrowSelectionFlow').checked;
        if(!this.isNarrowSelectionOnFlowRequirements){
           
            this.customerSpecifiedMedia = '';
            this.molecularWeight = null;
            this.compressibilityFactor = null;
            this.ratioOfSpecificHeats = null;
            this.setRequiredCustomerSpecified = false;
            this.SupplyGasTemperature = null;
            this.SupplyGasTemperatureUnits = null;
            this.MinimumRequiredFlowCapacity = null;
            this.flowUnits = null;
            this.supplyGasVal = '';
            
          
            /*let bgrObj = { 'sobjectType': 'BGR__c'};
            bgrObj.Narrow_selection_on_flow_requirements__c = this.isNarrowSelectionOnFlowRequirements;
            bgrObj.Id = this.recordId;
            showSectionB({conBGR: bgrObj})
            .then(result => {
                this.customerSpecifiedMedia = result.Customer_Specified_Media__c;
                this.molecularWeight = result.Molecular_Weight__c;
                this.compressibilityFactor = result.Compressibility_Factor__c;
                this.ratioOfSpecificHeats = result.Ratio_of_Specific_Heats__c;
                this.setRequiredCustomerSpecified = false;
                console.log('calculateConvertedSupplyPressure result === ', result);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: error.statusText,
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });*/
        }
       
    }
    
    handlePressureSettings(event){
        event.preventDefault(); 
        const bgrFields = event.detail.fields;
        bgrFields.Narrow_selection_on_flow_requirements__c = this.isNarrowSelectionOnFlowRequirements;
        bgrFields.Converted_Supply_Pressure__c = this.bgrConvertedSupplyPressure;
        bgrFields.Converted_Setting__c = this.bgrConvertedSetting;
        bgrFields.Converted_Atmospheric_Pressure__c = this.bgrConvertedAtmosphericPressure;
        bgrFields.Id = this.recordId;
        bgrFields.Service_Type__c = this.selectedTypeOption;
        bgrFields.Narrow_selection_on_flow_requirements__c = this.isNarrowSelectionOnFlowRequirements;
        //this.template.querySelector(".pressureSettingsForm").submit(bgrFields);
       saveRelief({brgRecord: bgrFields})
        .then(result => {
            this.bShowEditBtn = false; //added by piyush
            this.section1Saved = true; //@developer
            this.bHideReturnToQuote = true; //@piyush
            this.isErrorSection1 = false;
            this.section1ErrorMessage = [];
            let removeError = this.template.querySelectorAll(".section1");
            if(removeError){
                removeError.forEach((element)=>{element.classList.remove("slds-box")});
            }
            this.isErrorSection2 = false;
            this.section2ErrorMessage = [];
            let removeError2 = this.template.querySelectorAll(".section2");
            if(removeError2){
                removeError2.forEach((element)=>{element.classList.remove("slds-box")});
            }
            this.isErrorSection3 = false;
            this.section3ErrorMessage = [];
            let removeError3 = this.template.querySelectorAll(".section3");
            if(removeError3){
                removeError3.forEach((element)=>{element.classList.remove("slds-box")});
            }
            this.isErrorSection4 = false;
            this.section4ErrorMessage = [];
            let removeError4 = this.template.querySelectorAll(".section4");
            if(removeError4){
                removeError4.forEach((element)=>{element.classList.remove("slds-box")});
            }

            this.bgrConvertedSupplyPressure = result.Converted_Supply_Pressure__c;
            this.bgrConvertedSetting = result.Converted_Setting__c;
            this.bgrPresRatio = result.PresRatio__c;
            this.bgrConvertedAtmosphericPressure = result.Converted_Atmospheric_Pressure__c;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success', 
                    message: 'Saved Successfully',
                    variant: 'success',
                }),
            );
            console.log('calculateConvertedSupplyPressure result === ', result);
            this.supplyGasVal=null;
            this.customerSpecifiedMedia = null;
            this.molecularWeight = null;
            this.compressibilityFactor = null;
            this.disableForNonCustomerSpecified = false;
            this.ratioOfSpecificHeats = null;
            this.SupplyGasTemperature = null;
            this.SupplyGasTemperatureUnits = null;
            this.MinimumRequiredFlowCapacity = null;
            this.flowUnits = null;

            //clear certifications 
            this.clearCertifications();
        })
        .catch(error => {
            this.isErrorSection2 = false;
            this.section2ErrorMessage = [];
            let removeError2 = this.template.querySelectorAll(".section2");
            if(removeError2){
                removeError2.forEach((element)=>{element.classList.remove("slds-box")});
            }
            this.isErrorSection3 = false;
            this.section3ErrorMessage = [];
            let removeError3 = this.template.querySelectorAll(".section3");
            if(removeError3){
                removeError3.forEach((element)=>{element.classList.remove("slds-box")});
            }
            this.isErrorSection4 = false;
            this.section4ErrorMessage = [];
            let removeError4 = this.template.querySelectorAll(".section4");
            if(removeError4){
                removeError4.forEach((element)=>{element.classList.remove("slds-box")});
            }
            if(error.body.message){
                this.isErrorSection1 = true;
                this.section1ErrorMessage = [];
                this.section1ErrorMessage.push(error.body.message);
                let removeError = this.template.querySelectorAll(".section1");
                if(removeError){
                    removeError.forEach((element)=>{element.classList.add("slds-box")});
                }
            }
            else{
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: error.statusText,
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            }

            
        });
        
    }

    handlePressureSettingsOnSuccess(event){
      
        this.recordId =  event.detail.id;
        this.rDiscRecordId =  event.detail.id;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Saved Successfully',
                variant: 'success',
            }),
        );
        window.console.log('onsuccess: ', event.detail.id);
        const payload = event.detail;
        window.console.log('record payload: ',JSON.stringify(payload));
        this.section1Saved = true; // @developer
    }

    handleSupplyGasChange(event){
        this.onFlowCalculationUpdate(); // @developer
        if(event.detail.value){
			let bgrObj = { 'sobjectType': 'BGR__c'};
            bgrObj.Supply_Gas__c = event.detail.value;
            bgrObj.Service_Type__c = this.selectedTypeOption;
            bgrObj.Id = this.recordId;
            if(event.detail.value === 'Customer Specified'){
                this.setRequiredCustomerSpecified = true;
                this.disableForNonCustomerSpecified = false;
            }else{
                SupplyGas({brgRecord: bgrObj})
                .then(result => {
                    console.log(' calculateConvertedAtmosphericPressure result === ', result.Compressibility_Factor__c);
                    //this.recordId = result.Id;
                    this.customerSpecifiedMedia = result.Customer_Specified_Media__c;
                    this.molecularWeight = result.Molecular_Weight__c;
                    this.compressibilityFactor = result.Compressibility_Factor__c;
                    console.log(' this.compressibilityFactor ',this.compressibilityFactor);
                    this.ratioOfSpecificHeats = result.Ratio_of_Specific_Heats__c;
                    this.setRequiredCustomerSpecified = false;
                    this.disableForNonCustomerSpecified = true;
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: error.statusText,
                            message: error.body.message,
                            variant: 'error',
                        }),
                    );
                });
            }
            
        }
        else{
            this.disableForNonCustomerSpecified = true;
            this.customerSpecifiedMedia = '';
            this.molecularWeight = null;
            this.compressibilityFactor = '';
            this.ratioOfSpecificHeats = null;

        }
	}

	handleSectionB(event){
        event.preventDefault(); 
        const bgrFields = event.detail.fields;
        bgrFields.Id = this.recordId;
		//this.template.querySelector(".sectionBForm").submit(bgrFields);
		console.log('=== this.bgrFields '+this.bgrFields);
        bgrFields.Converted_Supply_Pressure__c = this.bgrConvertedSupplyPressure;
        bgrFields.Converted_Setting__c = this.bgrConvertedSetting;
        bgrFields.PresRatio__c = this.bgrPresRatio;
        bgrFields.Converted_Supply_Pressure__c = this.bgrConvertedSupplyPressure;
        bgrFields.Converted_Setting__c = this.bgrConvertedSetting;
        bgrFields.Brand__c = this.Brand;
        bgrFields.Converted_Atmospheric_Pressure__c = this.bgrConvertedAtmosphericPressure;
        //bgrFields.Flow_Units__c = this.flowUnits;
        
       saveSectionB({brgRecord: bgrFields})
        .then(result => {
            this.bShowEditBtn = false; //added by piyush
            this.bHideReturnToQuote = true; //@piyush
            this.isErrorSection2 = false;
            this.section2ErrorMessage = [];
            let removeError = this.template.querySelectorAll(".section2");
            if(removeError){
                removeError.forEach((element)=>{element.classList.remove("slds-box")});
            }
            
            this.isErrorSection3 = false;
            this.section3ErrorMessage = [];
            let removeError3 = this.template.querySelectorAll(".section3");
            if(removeError3){
                removeError3.forEach((element)=>{element.classList.remove("slds-box")});
            }
            this.isErrorSection4 = false;
            this.section4ErrorMessage = [];
            let removeError4 = this.template.querySelectorAll(".section4");
            if(removeError4){
                removeError4.forEach((element)=>{element.classList.remove("slds-box")});
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Saved Successfully',
                    variant: 'success',
                }),
            );
            this.section2Saved = true; // @developer
			this.convertedSupplyGasTemperature = result.Converted_Supply_Gas_Temperature__c;
            this.convertedFlowCapacity = result.Converted_Flow_Capacity__c;
            this.flowUnits=result.Flow_Units__c;
            this.sizeVal = result.Size__c;
            if(result.PresRatio__c !== undefined && result.PresRatio__c !== null){
                this.bgrPresRatio = result.PresRatio__c;
            }
            this.selectedAtexOption = null;
            this.clearCertifications();

        })
        .catch(error => {
            
            this.isErrorSection3 = false;
            this.section3ErrorMessage = [];
            let removeError3 = this.template.querySelectorAll(".section3");
            if(removeError3){
                removeError3.forEach((element)=>{element.classList.remove("slds-box")});
            }
            this.isErrorSection4 = false;
            this.section4ErrorMessage = [];
            let removeError4 = this.template.querySelectorAll(".section4");
            if(removeError4){
                removeError4.forEach((element)=>{element.classList.remove("slds-box")});
            }
            if(error.body.message){
                this.isErrorSection2 = true;
                this.section2ErrorMessage = [];
                this.section2ErrorMessage.push(error.body.message);
                let removeError = this.template.querySelectorAll(".section2");
                if(removeError){
                    removeError.forEach((element)=>{element.classList.add("slds-box")});
                }
            }
            else{
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: error.statusText,
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            }

            
        });
        
    }

    clearCertifications(){
        this.selectedAtexOption = undefined;
        this.selectedCSA_MarkingsOption = undefined;
        this.selectedGOST_CU_Tr_010_2011Option = undefined;
        this.comboOrificeSettingVal = undefined;
        this.sizeVal = undefined;
        if(this.template.querySelector('[class="AtexY"]') !== null && this.template.querySelector('[class="AtexY"]') !== undefined){
            console.log(' in AtexY ');
            this.template.querySelector('[class="AtexY"]').checked = undefined;
        }

        if(this.template.querySelector('[class="AtexN"]') !== null && this.template.querySelector('[class="AtexN"]') !== undefined){
            console.log(' in AtexN ');
            this.template.querySelector('[class="AtexN"]').checked = null;
        }

        if(this.template.querySelector('[class="CSA_MarkingsY"]') !== null && this.template.querySelector('[class="CSA_MarkingsY"]') !== undefined){
            this.template.querySelector('[class="CSA_MarkingsY"]').checked = false;
        }

        if(this.template.querySelector('[class="CSA_MarkingsN"]') !== null && this.template.querySelector('[class="CSA_MarkingsN"]') !== undefined){
            this.template.querySelector('[class="CSA_MarkingsN"]').checked = false;
        }

        if(this.template.querySelector('[class="GOST_CU_Tr_010_2011Y"]') !== null && this.template.querySelector('[class="GOST_CU_Tr_010_2011Y"]') !== undefined){
            this.template.querySelector('[class="GOST_CU_Tr_010_2011Y"]').checked = false;
        }

        if(this.template.querySelector('[class="GOST_CU_Tr_010_2011N"]') !== null && this.template.querySelector('[class="GOST_CU_Tr_010_2011N"]') !== undefined){
            this.template.querySelector('[class="GOST_CU_Tr_010_2011N"]').checked = false;
        }

    }

    handleSectionBOnSuccess(event){
       
        this.recordId =  event.detail.id;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Saved Successfully',
                variant: 'success',
            }),
        );
        window.console.log('onsuccess: ', event.detail.id);
        const payload = event.detail;
        window.console.log('record payload: ',JSON.stringify(payload));
	}
	
	handleSaveCertifications(event){
        event.preventDefault(); 
        const bgrFields = event.detail.fields;
        console.log('This Brand value '+this.Brand);
        console.log('This Setting value '+this.bgrConvertedSetting);
        console.log(event.detail.fields.Brand__c);
		bgrFields.Id = this.recordId;
		//this.template.querySelector(".CertificationsForm").submit(bgrFields);
		// This below code is for Support Ticket# 200091 added by Vivek Pandey
        if(this.selectedAtexOption == undefined || this.selectedAtexOption == null ){
            this.selectedAtexOption = 'N';
        }
        if(this.selectedGOST_CU_Tr_010_2011Option == undefined || this.selectedGOST_CU_Tr_010_2011Option == null ){
            this.selectedGOST_CU_Tr_010_2011Option = 'N';
        }
        if(this.selectedCSA_MarkingsOption == undefined || this.selectedCSA_MarkingsOption == null ){
            this.selectedCSA_MarkingsOption = 'N';
        }
        // Till above this block of code is for Support Ticket# 200091 added by Vivek Pandey
		bgrFields.Atex__c = this.selectedAtexOption ;
		bgrFields.GOST_CU_Tr_010_2011__c = this.selectedGOST_CU_Tr_010_2011Option;
		bgrFields.CSA_Markings__c = this.selectedCSA_MarkingsOption;
    	bgrFields.Setting__c = this.settings;
		bgrFields.Setting_Units__c = this.settingUnits;
		bgrFields.Supply_Pressure__c = this.supplyPressure;
		bgrFields.Supply_Pressure_Units__c = this.supplyPressureUnits;
		bgrFields.Atmospheric_Pressure__c = this.atmosphericPressure;
		bgrFields.Atmospheric_Pressure_Units__c = this.atmosphericPressureUnits;
		bgrFields.Narrow_selection_on_flow_requirements__c = this.isNarrowSelectionOnFlowRequirements;
        bgrFields.Converted_Supply_Pressure__c = this.bgrConvertedSupplyPressure;
        bgrFields.Converted_Setting__c = this.bgrConvertedSetting;
        bgrFields.Brand__c = this.Brand;
		bgrFields.Service_Type__c = this.selectedTypeOption;
		bgrFields.PresRatio__c = this.bgrPresRatio;
		bgrFields.Ratio_of_Specific_Heats__c = this.ratioOfSpecificHeats;
		bgrFields.Converted_Atmospheric_Pressure__c = this.bgrConvertedAtmosphericPressure;
		bgrFields.Molecular_Weight__c = this.molecularWeight;
		bgrFields.Converted_Supply_Gas_Temperature__c = this.convertedSupplyGasTemperature;
		bgrFields.Compressibility_Factor__c = this.compressibilityFactor;
        bgrFields.Converted_Flow_Capacity__c = this.convertedFlowCapacity;
        bgrFields.Flow_Units__c = this.flowUnits;
        console.log('quoteLineId ', this.quoteLineId);
		console.log('bgrFields ==== ',JSON.stringify(bgrFields));
		saveCertificate({conBGR: bgrFields, quoteLineItemId: this.quoteLineId})
        .then(result => {
            this.bShowEditBtn = false; //added by piyush
            this.bHideReturnToQuote = true; //@piyush
            this.section3Saved = true;
            this.isErrorSection3 = false;
            this.section3ErrorMessage = [];
            let removeError = this.template.querySelectorAll(".section3");
            if(removeError){
                removeError.forEach((element)=>{element.classList.remove("slds-box")});
            }

            this.isErrorSection4 = false;
            this.section4ErrorMessage = [];
            let removeError4 = this.template.querySelectorAll(".section4");
            if(removeError4){
                removeError4.forEach((element)=>{element.classList.remove("slds-box")});
            }
            console.log('calculateConvertedSupplyPressure result === ', result);
            this.comboOrificeSettingVal = undefined;
            this.sizeVal = undefined;
            this.comboOrificeSettingOptions = undefined;
            if(result.length < 2){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'No Model found from the above configurations',
                        variant: 'error',
                    }),
                );
                return;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Saved Successfully',
                    variant: 'success',
                }),
            );
            this.comboOrificeSettingOptions = result;
            this.modelValue = result.Model__c;
            
        })
        .catch(error => {
            
            this.isErrorSection4 = false;
            this.section4ErrorMessage = [];
            let removeError4 = this.template.querySelectorAll(".section4");
            if(removeError4){
                removeError4.forEach((element)=>{element.classList.remove("slds-box")});
            }

             if(error.body.message){
                this.isErrorSection3 = true;
                this.section3ErrorMessage = [];
                this.section3ErrorMessage.push(error.body.message);
                let removeError = this.template.querySelectorAll(".section3");
                if(removeError){
                    removeError.forEach((element)=>{element.classList.add("slds-box")});
                }
            }
            else{
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: error.statusText,
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            }
        });
        
    }

    handleCertificationOnSuccess(event){
       
        this.recordId =  event.detail.id;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Saved Successfully',
                variant: 'success',
            }),
        );
        window.console.log('onsuccess: ', event.detail.id);
        const payload = event.detail;
        window.console.log('record payload: ',JSON.stringify(payload));
	}

	handleComboOrificeSettingChange(event){
		console.log('comboOrificeSettingVal === ',this.comboOrificeSettingVal);
        this.comboOrificeSettingVal = event.detail.value;
        this.connectionVal = null;
		console.log('event.detail.value === ',event.detail.value);
    }
    
    @track renderConnection = false;
    @track connectionVal;

    handleConnectionChange(event){
        this.connectionVal = event.target.value;
    }

    
	handleSaveProductSelection(event){

        if(!this.comboOrificeSettingVal || this.comboOrificeSettingVal === '--None--'){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'No Model found from the above configurations',
                    variant: 'error',
                }),
            );
            return;
        }
        event.preventDefault(); 
        const bgrFields = event.detail.fields;
		bgrFields.Id = this.recordId;
        bgrFields.Combo_Orifice_Setting__c = this.comboOrificeSettingVal;
        bgrFields.Model__c = this.modelValue;
        this.renderConnection = true;
		//bgrFields.Model__c = ;
        // The code below is for Support Ticket# 200091 added by Vivek Pandey
        if(this.selectedAtexOption == undefined || this.selectedAtexOption == null ){
            this.selectedAtexOption = 'N';
        }
        if(this.selectedGOST_CU_Tr_010_2011Option == undefined || this.selectedGOST_CU_Tr_010_2011Option == null ){
            this.selectedGOST_CU_Tr_010_2011Option = 'N';
        }
        if(this.selectedCSA_MarkingsOption == undefined || this.selectedCSA_MarkingsOption == null ){
            this.selectedCSA_MarkingsOption = 'N';
        }
        bgrFields.Atex__c = this.selectedAtexOption ;
        bgrFields.GOST_CU_Tr_010_2011__c = this.selectedGOST_CU_Tr_010_2011Option;
        bgrFields.CSA_Markings__c = this.selectedCSA_MarkingsOption;
        // Till above this block of code is for Support Ticket# 200091 added by Vivek Pandey
		console.log('bgrFields ==== ',JSON.stringify(bgrFields));
		saveProductSelection({conBGR: bgrFields})
        .then(result => {
            this.isErrorSection4 = false;
           // this.oPopupPDF.close();
            this.section4ErrorMessage = [];
            let removeError = this.template.querySelectorAll(".section4");
            if(removeError){
                removeError.forEach((element)=>{element.classList.remove("slds-box")});
            }
            this.sizeVal = result.Size__c;
            this.sizeOptions.push({label:result.Size__c, value:result.Size__c});
            this.renderConnection = false;
            //this.connectionVal = null;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Saved Successfully',
                    variant: 'success',
                }),
            );
            console.log('Product Selection  result === ', result);


            let isPortalUser = this.currentUserInfo.fields.IsPortalEnabled.value;

            let encodeURI = '';
            let sUrl = '/apex/ConfigBGR?id='+this.recordId+'&qid='+this.quoteLineId+'&selectedTab=second';

            if (isPortalUser) {
                encodeURI = '/sfdcpage/' + encodeURIComponent(sUrl);
            } else {
                encodeURI = sUrl;
            }
           
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: encodeURI
                }
            },
                true // Replaces the current page in your browser history with the URL
            );

           /* this[NavigationMixin.Navigate]({
                "type": "standard__webPage",
                "attributes": {
                    "url": "/apex/ConfigBGR?id="+this.recordId+'&qid='+this.quoteLineId+'&selectedTab=second'
                }
            });*/
		})
        .catch(error => {
            if(error.body.message){
                this.isErrorSection4 = true;
                this.section4ErrorMessage = [];
                this.section4ErrorMessage.push(error.body.message);
                let removeError = this.template.querySelectorAll(".section4");
                if(removeError){
                    removeError.forEach((element)=>{element.classList.add("slds-box")});
                }
            }
            else{
               
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: error.statusText,
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            }
            
        });
        
    }

    /*
	handleSaveProductMaterialOptions(event){
        event.preventDefault(); 
        const bgrFields = event.detail.fields;
		bgrFields.Id = this.recordId;
		saveProductMaterials({brgRecord: bgrFields})
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Saved Product Material and Options data',
                    variant: 'success',
                }),
            );
			console.log('calculateConvertedSupplyPressure result === ', result);
		})
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: error.statusText,
                    message: error.body.message,
                    variant: 'error',
                }),
            );
        });
        
    }

    handleSaveValveExaminationOption(event){
        event.preventDefault(); 
        const bgrFields = event.detail.fields;
        bgrFields.Id = this.recordId;
        bgrFields.Radiography__c = this.selectedRadiographyOptions;
        bgrFields.Positive_Material_Identification__c = this.selectedPositiveMaterialIdentificationOption;
        bgrFields.Shell_test__c = this.selectedShellTestOptions;
        bgrFields.Shell_Test_Valve_Body__c = this.selectedShellTestValveBodyOption;
		saveValveExamination({brgRecord: bgrFields})
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Saved Valve Examination Options',
                    variant: 'success',
                }),
            );
			console.log('calculateConvertedSupplyPressure result === ', result);
		})
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: error.statusText,
                    message: error.body.message,
                    variant: 'error',
                }),
            );
        });
    }   

    @track SoftGoodsMaterialVal;

    handleSoftGoodMaterialChange(event){
        this.SoftGoodsMaterialVal = event.target.value;
    }
    handleSaveDocSourcing(event){
        event.preventDefault(); 
        const bgrFields = event.detail.fields;
        bgrFields.Id = this.recordId;
        bgrFields.Radiography__c = this.selectedRadiographyOptions;
        bgrFields.Positive_Material_Identification__c = this.selectedPositiveMaterialIdentificationOption;
        bgrFields.Shell_test__c = this.selectedShellTestOptions;
        bgrFields.Shell_Test_Valve_Body__c = this.selectedShellTestValveBodyOption;
        bgrFields.Model__c = this.modelValue;
        bgrFields.Size__c = this.sizeVal;
        bgrFields.Connection__c = this.connectionVal;
        bgrFields.Soft_Goods_Material__c = this.SoftGoodsMaterialVal;
		saveDocSourcing({conBGR: bgrFields, quoteId: this.quoteId})
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Saved Doc / Sourcing',
                    variant: 'success',
                }),
            );
            console.log(' a1N8A00000AxKcxUAF ', this.quoteLineId);
            console.log('calculateConvertedSupplyPressure result === ', result);
      		
		})
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: error.statusText,
                    message: error.body.message,
                    variant: 'error',
                }),
            );
        });
        
    }
    */

    renderedCallback() {
        if(this.recordId !== undefined && this.recordId !== null && this.recordId !== ''){
            if(this.template.querySelector('[class="'+this.selectedTypeOption+'"]') !== null && this.template.querySelector('[class="'+this.selectedTypeOption+'"]') !== undefined ){
                this.template.querySelector('[class="'+this.selectedTypeOption+'"]').checked = true;
                console.log('Im in call back');
            }

            if(this.template.querySelector('[class="Atex'+this.selectedAtexOption+'"]') !== null && this.template.querySelector('[class="Atex'+this.selectedAtexOption+'"]') !== undefined ){
                this.template.querySelector('[class="Atex'+this.selectedAtexOption+'"]').checked = true;
            }

            if(this.template.querySelector('[class="GOST_CU_Tr_010_2011'+this.selectedGOST_CU_Tr_010_2011Option+'"]') !== null && this.template.querySelector('[class="GOST_CU_Tr_010_2011'+this.selectedGOST_CU_Tr_010_2011Option+'"]') !== undefined ){
                this.template.querySelector('[class="GOST_CU_Tr_010_2011'+this.selectedGOST_CU_Tr_010_2011Option+'"]').checked = true;
            }

            if(this.template.querySelector('[class="CSA_Markings'+this.selectedCSA_MarkingsOption+'"]') !== null && this.template.querySelector('[class="CSA_Markings'+this.selectedCSA_MarkingsOption+'"]') !== undefined ){
                this.template.querySelector('[class="CSA_Markings'+this.selectedCSA_MarkingsOption+'"]').checked = true;
            }

            if(this.isNarrowSelectionOnFlowRequirements){
                this.template.querySelector('.narrowSelectionFlow').checked = true;
            }

            if(this.template.querySelector('[class="radiography'+this.selectedRadiographyOptions+'Id"]') !== null && this.template.querySelector('[class="radiography'+this.selectedRadiographyOptions+'Id"]') !== undefined ){
                this.template.querySelector('[class="radiography'+this.selectedRadiographyOptions+'Id"]').checked = true;
            }

            if(this.template.querySelector('[class="'+this.selectedPositiveMaterialIdentificationOption+'"]') !== null && this.template.querySelector('[class="'+this.selectedPositiveMaterialIdentificationOption+'"]') !== undefined ){
                this.template.querySelector('[class="'+this.selectedPositiveMaterialIdentificationOption+'"]').checked = true;
            }

            if(this.template.querySelector('[class="shellTest'+this.selectedShellTestOptions+'Id"]') !== null && this.template.querySelector('[class="shellTest'+this.selectedShellTestOptions+'Id"]') !== undefined ){
                this.template.querySelector('[class="shellTest'+this.selectedShellTestOptions+'Id"]').checked = true;
            }

            if(this.template.querySelector('[class="'+this.selectedShellTestValveBodyOption+'"]') !== null && this.template.querySelector('[class="'+this.selectedShellTestValveBodyOption+'"]') !== undefined ){
                this.template.querySelector('[class="'+this.selectedShellTestValveBodyOption+'"]').checked = true;
            }

            
        }
    }

    

    restrictNonNumericalValues(event){

        console.log('event.keycode'+event.keyCode);
        let charCode = (event.which) ? event.which : event.keyCode;
        if(charCode != 46 && charCode != 37 && charCode != 39 && charCode != 110 && charCode != 190 && ((charCode > 31 && charCode <48)||(charCode>57 && charCode<93) ||charCode >105 ))
            event.preventDefault();

    }

    restrictNonNumericalValuesTemp(event){
        let charCode = (event.which) ? event.which : event.keyCode;
        if(charCode == 69 ){
            event.preventDefault();
        }
        
    }

    onScrollMain(event){
        
        let number = event.target.scrollTop;
        console.log('Full height ======= '+event.target.scrollTop);
        
        var firstSection = this.template.querySelector('.section-1').offsetHeight;
        var secondSection = this.template.querySelector('.section-2').offsetHeight;
        var thirdSection = this.template.querySelector('.section-3').offsetHeight;
        var fourthSection = this.template.querySelector('.section-4').offsetHeight;

        let activeElements = this.template.querySelectorAll(".active");    
        if(activeElements){
            activeElements.forEach((element)=>{element.classList.remove("active")});
        }
        
        
        if(number < firstSection){
            this.template.querySelector(".PRESSURESETTINGSCls").classList.add("active");          
            
        }else if(number < firstSection + secondSection && this.isNarrowSelectionOnFlowRequirements){
            this.template.querySelector(".FLOWCALCULATIONSCls").classList.add("active");
           
        }else if(number < firstSection + secondSection + thirdSection){        
            this.template.querySelector(".CERTIFICATIONSCls").classList.add("active"); 
        }
        else{
            window.console.log('in fourth Section ');
            this.template.querySelector(".PRODUCTSELECTIONcls").classList.add("active");          
        }

    }

    focusSection(event){
        var sectionName = event.target.dataset.id;
        console.log('on click data ID ',event.target.dataset.id);

        this.template.querySelector("div[class='"+sectionName+"']").scrollIntoView({behavior: "smooth"});
      /*  if(sectionName === 'pressureSettings'){
            this.template.querySelector('.section-1').scrollIntoView({behavior: "smooth"});      
        }else if(sectionName === 'flowCalculations'){
            this.template.querySelector('.section-2').scrollIntoView({behavior: "smooth"});
        }else if(sectionName === 'certifications'){
            this.template.querySelector('.section-3').scrollIntoView({behavior: "smooth"});
        }else if(sectionName === 'productSelection'){
            this.template.querySelector('.section-4').scrollIntoView({behavior: "smooth"});
        }*/

    }

    navigateToProductView() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.quoteId,
                objectApiName: 'SBQQ__Quote__c', // objectApiName is optional
                actionName: 'view'
            }
        });
        
    }

    navigateToProductReview(){
        let isPortalUser = this.currentUserInfo.fields.IsPortalEnabled.value;

        let encodeURI = '';
        let sUrl = '/apex/ConfigBGR?id='+this.recordId+'&qid='+this.quoteLineId+'&selectedTab=second';

        if (isPortalUser) {
            encodeURI = '/sfdcpage/' + encodeURIComponent(sUrl);
        } else {
            encodeURI = sUrl;
        }
       
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: encodeURI
            }
        },
            true // Replaces the current page in your browser history with the URL
        );

    }

    RemoveDecimal(event){
        let targetName = event.target.name;
        if(targetName === 'setting')
            this.settings = event.target.value;
        else if(targetName === 'supplyPressure'){
            this.supplyPressure = event.target.value;
        }
        else if(targetName === 'atmosphericPressure'){
            this.atmosphericPressure = event.target.value;
        }
        else if(targetName === 'molecularWeight'){
            this.molecularWeight = event.target.value;
        }
        else if(targetName === 'compressibilityFactor'){
            this.compressibilityFactor = event.target.value;
        }
        else if(targetName === 'ratioOfSpecificHeats'){
            this.ratioOfSpecificHeats = event.target.value;
        }
        else if(targetName === 'SupplyGasTemperature'){
            this.SupplyGasTemperature = event.target.value;
        }
        else if(targetName === 'MinimumRequiredFlowCapacity'){
            this.MinimumRequiredFlowCapacity = event.target.value;
        }
    }

    //////////////////////////////

    onPressureVacuumSettingsUpdate(){
       
        this.section1Saved = false; // @developer
    }

    onFlowCalculationUpdate(){
       // alert('onFlowCalculationUpdate');
        this.section2Saved = false; // @developer
    }

    onFlowCalculationsClick(event){
        if(this.section1Saved == false && this.bDisabled == false){
            this.template.querySelector("div[class='section-1']").scrollIntoView({behavior: "smooth"});
             event.preventDefault();
             this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Unsaved Changes On "Pressure / Vacuum Settings" Section.',
                    message : '',
                    variant: 'warning',
                }),
            );
              return;
        }
    }
    
    
    onCertificationClick(event){
        if(this.section1Saved == false &&  this.bDisabled == false){
            this.template.querySelector("div[class='section-1']").scrollIntoView({behavior: "smooth"});
             event.preventDefault();
            
             this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Unsaved Changes On "Pressure / Vacuum Settings" Section.',
                    message : '',
                    variant: 'warning',
                }),
            );
              return;
        }

        if(this.isNarrowSelectionOnFlowRequirements && this.section2Saved == false && this.bDisabled == false){
            this.template.querySelector("div[class='section-2']").scrollIntoView({behavior: "smooth"});
             event.preventDefault();
            
             this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Unsaved Changes On "Flow Calculations" Section.',
                    message : '',
                    variant: 'warning',
                }),
            );
              return;
        }
    }

    onProductSelectionClick(event){
        if(this.section1Saved == false && this.bDisabled == false){
            this.template.querySelector("div[class='section-1']").scrollIntoView({behavior: "smooth"});
             event.preventDefault();
             this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Unsaved Changes On "Pressure / Vacuum Settings" Section.',
                    message : '',
                    variant: 'warning',
                }),
            );
              return;
        }


        if(this.isNarrowSelectionOnFlowRequirements && this.section2Saved == false && this.bDisabled == false){
            this.template.querySelector("div[class='section-2']").scrollIntoView({behavior: "smooth"});
             event.preventDefault();
            
             this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Unsaved Changes On "Flow Calculations" Section.',
                    message : '',
                    variant: 'warning',
                }),
            );
              return;
        }

        if(this.section3Saved == false && this.bDisabled == false){
            this.template.querySelector("div[class='section-3']").scrollIntoView({behavior: "smooth"});
             event.preventDefault();
            
             this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Unsaved Changes On "Certifications" Section.',
                    message : '',
                    variant: 'warning',
                }),
            );
              return;
        }

        
        
    }

}