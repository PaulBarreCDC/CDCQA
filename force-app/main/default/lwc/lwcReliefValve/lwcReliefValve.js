import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getRecord } from 'lightning/uiRecordApi';

import Relief_Valve_OBJECT from '@salesforce/schema/Relief_Valve__c';

import ReliefType_FIELD from '@salesforce/schema/Relief_Valve__c.Relief_Type__c';
import Constraint_Product_Selection_By_Flow_FIELD from '@salesforce/schema/Relief_Valve__c.Constraint_Product_Selection_By_Flow__c';
import Quote_Line_FIELD from '@salesforce/schema/Relief_Valve__c.Quote_Line__c';
import Brand_FIELD from '@salesforce/schema/Relief_Valve__c.Brand__c';

//SecA
import Converted_Back_Pressure_FIELD from '@salesforce/schema/Relief_Valve__c.Converted_Back_Pressure__c';
import Converted_Max_Process_Pressure_FIELD from '@salesforce/schema/Relief_Valve__c.Converted_Max_Process_Pressure__c';
import Converted_Pressure_Setting_FIELD from '@salesforce/schema/Relief_Valve__c.Converted_Pressure_Setting__c';
import Converted_Vacuum_Setting_FIELD from '@salesforce/schema/Relief_Valve__c.Converted_Vacuum_Setting__c';

import Pressure_Setting_FIELD from '@salesforce/schema/Relief_Valve__c.Pressure_Setting__c';
import Vacuum_Setting_FIELD from '@salesforce/schema/Relief_Valve__c.Vacuum_Setting__c';
import Back_Pressure_FIELD from '@salesforce/schema/Relief_Valve__c.Back_Pressure__c';
import Max_Pressure_FIELD from '@salesforce/schema/Relief_Valve__c.Max_Process_Pressure__c';

import PressureSettingUnits_FIELD from '@salesforce/schema/Relief_Valve__c.Pressure_Setting_Units__c'; //Service Ticket 161771
import VacuumSettingUnits_FIELD from '@salesforce/schema/Relief_Valve__c.Vacuum_Setting_Units__c'; //Service Ticket 161771

//SecB
import Converted_Relieving_Pressure_Valu_FIELD from '@salesforce/schema/Relief_Valve__c.Converted_Relieving_Pressure_Value__c';

import Converted_Pressure_Relieving_Temperature_FIELD from '@salesforce/schema/Relief_Valve__c.Converted_Pressure_Relieving_Temperature__c';
import V_Converted_Vacuum_Relieving_Temperature_FIELD from '@salesforce/schema/Relief_Valve__c.V_Converted_Vacuum_Relieving_Temperature__c';
import V_Converted_Relieving_Vacuum_Value_FIELD from '@salesforce/schema/Relief_Valve__c.V_Converted_Relieving_Vacuum_Value__c';
import Converted_Pressure_Relief_Req_Flow_FIELD from '@salesforce/schema/Relief_Valve__c.Converted_Pressure_Relief_Req_Flow__c';
import Converted_Vacuum_Relief_Req_Flow_FIELD from '@salesforce/schema/Relief_Valve__c.Converted_Vacuum_Relief_Req_Flow__c';
import Converted_Atmospheric_Pressure_FIELD from '@salesforce/schema/Relief_Valve__c.Converted_Atmospheric_Pressure__c';
import Molecular_Weight_FIELD from '@salesforce/schema/Relief_Valve__c.Molecular_Weight__c';
import Compressibility_Factor_FIELD from '@salesforce/schema/Relief_Valve__c.Compressibility_Factor__c';
import Ratio_of_Specific_Heats_FIELD from '@salesforce/schema/Relief_Valve__c.Ratio_of_Specific_Heats__c';
import V_Ratio_of_Specific_Heats_FIELD from '@salesforce/schema/Relief_Valve__c.V_Ratio_of_Specific_Heats__c';
import V_Molecular_Weight_FIELD from '@salesforce/schema/Relief_Valve__c.V_Molecular_Weight__c';
import V_Compressibility_Factor_FIELD from '@salesforce/schema/Relief_Valve__c.V_Compressibility_Factor__c';

//SecC
import Atex_Certificate_FIELD from '@salesforce/schema/Relief_Valve__c.Atex_Certificate__c';
import CU_TR__FIELD from '@salesforce/schema/Relief_Valve__c.CU_TR__c';
import PED_2014_68_EU_CE_mark__FIELD from '@salesforce/schema/Relief_Valve__c.PED_2014_68_EU_CE_mark__c';
import Gas_Group__FIELD from '@salesforce/schema/Relief_Valve__c.Gas_Group__c';
import Zone__FIELD from '@salesforce/schema/Relief_Valve__c.Zone__c';
import NACE__FIELD from '@salesforce/schema/Relief_Valve__c.NACE__c';

//SecD
import Type_of_model_FIELD from '@salesforce/schema/Relief_Valve__c.Type_of_model__c';
import Type_of_overpressure_valve_FIELD from '@salesforce/schema/Relief_Valve__c.Type_of_overpressure_valve__c';
import Is_flame_arrester_needed_with_your_valve_FIELD from '@salesforce/schema/Relief_Valve__c.Is_flame_arrester_needed_with_your_valve__c';

//SecE
import Model_Size__FIELD from '@salesforce/schema/Relief_Valve__c.Model_Size__c';
import Size_Preference__FIELD from '@salesforce/schema/Relief_Valve__c.Size_Preference__c';

import saveRelief from '@salesforce/apex/ReliefValveController.saveRelief';
import SaveCertifications from '@salesforce/apex/ReliefValveController.SaveCertifications';
import SaveProductNarrowing from '@salesforce/apex/ReliefValveController.SaveProductNarrowing';
import SaveProductSelection from '@salesforce/apex/ReliefValveController.SaveProductSelection';
import getRvRecord from '@salesforce/apex/ReliefValveController.getRvRecord';
import fetchFormAccessibility from '@salesforce/apex/ReliefValveController.fetchFormAccessibility'; // @added by piyush
/*Not used
import applyDefaluts from '@salesforce/apex/ReliefValveController.applyDefaluts';
import productMaterialAndOptions from '@salesforce/apex/ReliefValveController.productMaterialAndOptions';
import SaveProductMaterialOptions from '@salesforce/apex/ReliefValveController.SaveProductMaterialOptions';
import SaveValveExaminationOption from '@salesforce/apex/ReliefValveController.SaveValveExaminationOption';*/

import Price_Engineer_Override from '@salesforce/schema/Relief_Valve__c.Price_Engineer_Override__c';
import Lead_Time_Override from '@salesforce/schema/Relief_Valve__c.Lead_Time_Override__c';
import Build_Cost_Override from '@salesforce/schema/Relief_Valve__c.Build_Cost_Override__c';
import Quote_Description_Engineer_Override from '@salesforce/schema/Relief_Valve__c.Quote_Description_Engineer_Override__c';

import Id from '@salesforce/user/Id';
const FIELDS = [
    'User.Name',
    'User.IsPortalEnabled'
];

const rvFields = [Price_Engineer_Override,Lead_Time_Override,Build_Cost_Override,Quote_Description_Engineer_Override,Brand_FIELD, ReliefType_FIELD, Constraint_Product_Selection_By_Flow_FIELD, Quote_Line_FIELD,
    Pressure_Setting_FIELD, Back_Pressure_FIELD, Max_Pressure_FIELD, Vacuum_Setting_FIELD,
    Converted_Back_Pressure_FIELD, Converted_Max_Process_Pressure_FIELD, Converted_Pressure_Setting_FIELD, Converted_Vacuum_Setting_FIELD, 
    Converted_Relieving_Pressure_Valu_FIELD, Converted_Pressure_Relieving_Temperature_FIELD, V_Converted_Vacuum_Relieving_Temperature_FIELD, 
    V_Converted_Relieving_Vacuum_Value_FIELD, Converted_Pressure_Relief_Req_Flow_FIELD, Converted_Vacuum_Relief_Req_Flow_FIELD, Converted_Atmospheric_Pressure_FIELD, 
    Molecular_Weight_FIELD, Compressibility_Factor_FIELD, Ratio_of_Specific_Heats_FIELD, V_Ratio_of_Specific_Heats_FIELD,  V_Molecular_Weight_FIELD, V_Compressibility_Factor_FIELD,
    Atex_Certificate_FIELD, CU_TR__FIELD,  PED_2014_68_EU_CE_mark__FIELD, Gas_Group__FIELD, Zone__FIELD, NACE__FIELD, 
    Type_of_model_FIELD, Type_of_overpressure_valve_FIELD, Is_flame_arrester_needed_with_your_valve_FIELD, 
    Model_Size__FIELD, Size_Preference__FIELD, PressureSettingUnits_FIELD, VacuumSettingUnits_FIELD
    ];
//Service Ticket 161771
let rvObj = { 'sobjectType': 'Relief_Valve__c' };

export default class lwcReliefValve extends NavigationMixin(LightningElement) {

    //not used
    reliefValveRecord;
    userId = Id;
    currentUserInfo = {};
    @api recordId;
    @api quoteId;
    @track quoteLineId;
    @track brand;

    @track temperatureUnitsApi;
    @track flowRateUnitsApi;
    @track pressureUnitsApi;

    //Section A track
    @track pressureSetting;
    @track backPressure = 0;
    @track vaccumSetting;
    @track maxPressure;

    @track PressureSettingUnitsVal;       
    ConvertedPressureSettingVal;
    @track BackPressureUnitsVal;
    ConvertedBackPressureVal;
    
    @track MaxProcessPressureUnitVal;
    ConvertedMaxProcessPressureVal;

    @track VacuumSettingUnitsVal;
    ConvertedVacuumSettingVal;

    @track reliefTypeOptions;
    @track selectedReliefType;
    @track constraintProductSelectionByFlowOptions;
    selectedConstraintProductSelectionByFlow;
    
    @track isSelectionByFlow;

    //Section B track
    ConvertedRelievingPressureValueVal; 
    V_ConvertedRelievingVacuumValueVal;

    ConvertedPressureRelievingTemperatureVal;
    V_ConvertedVacuumRelievingTemperature;

    ConvertedPressureReliefReqFlowVal;
    ConvertedVacuumReliefReqFlowVal;

    V_ConvertedVacuumRelievingTemperatureVal;
    ConvertedAtmosphericPressureVal;

    MolecularWeightVal;
    V_MolecularWeightVal;

    CompressibilityFactorVal;
    V_CompressibilityFactorVal;

    RatioofSpecificHeatsVal;
    V_RatioofSpecificHeatsVal;

    //Certification
    @track atexCertificate;
    @track pedCertificate;
    @track naceCertificate;
    @track cutrCertificate;
    @track zoneCertificate;
    @track gasGroupCertificate;

    //Product narrowing
    @track IsFlameArresterNeededWithYourValveOptions;
    @track selectedIsFlameArresterNeededWithYourValve;
    @track typeOfOverPressureValveOptions;
    @track selectedTypeOfOverPressureValveOption;
    @track typeOfModelOptions;
    @track selectedTypeOfModelOption;

    returnedPtcSzc;
    @track sizesAvailable;
    @track selectedModelSizeVal;
    @track isFiberglass = false;
    @track ModelSizeOptions;
    @track SizePreferenceOptions;
    @track SizePreferenceVal;


    //Error Handling SectionWise
    @track section1ErrorMessage;
    @track isErrorSection1;
    @track section2ErrorMessage;
    @track isErrorSection2;
    @track section3ErrorMessage;
    @track isErrorSection3;
    @track section4ErrorMessage;
    @track isErrorSection4;
    @track section5ErrorMessage;
    @track isErrorSection5;


    //added by piyush 
    section1Saved = true; // PRESET UNITS OF MEASURE
    section2Saved = true; // SIZING / FLOW AREA,child component section
    section3Saved = true; // CERTIFICATIONS
    section4Saved = true; // Product Narrowing

    bHideReturnToQuote = false; // added by piyush to control back button visibility 
    bShowEditBtn = false;
    sDisabled = '';
    bDisabled = false;
    sEditBtnLabel = 'Edit';
    bShowProductReviewLink = false;
    bMetaDataLoaded = false;

    @wire(getRecord, { recordId: '$userId', fields: FIELDS })
    oUser({ error, data }) {
        if (data) {
			console.log('===> USER' + JSON.stringify(data));
			this.currentUserInfo = data;
        } else if (error) {
            console.log('===> error' + JSON.stringify(error));
        }
    }
    
    
    @wire(getObjectInfo, { objectApiName: Relief_Valve_OBJECT })
        objectInfo;

    @wire(getRecord, { recordId: '$recordId', fields: rvFields})
    rvRecord({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while loading Relief Valve',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data) {
            if(data !== undefined){
                
                this.brand = data.fields.Brand__c.value;
                this.selectedReliefType = data.fields.Relief_Type__c.value;
                if(this.selectedReliefType == 'Pressure' || this.selectedReliefType == 'Pressure & Vacuum'){
                    this.pressureSetting = data.fields.Pressure_Setting__c.value;
                    this.backPressure = data.fields.Back_Pressure__c.value;
                    this.PressureSettingUnitsVal = data.fields.Pressure_Setting_Units__c.value; //Service Ticket 161771
                   
                }
                if(this.selectedReliefType == 'Vacuum' || this.selectedReliefType == 'Pressure & Vacuum'){
                    this.vaccumSetting = data.fields.Vacuum_Setting__c.value;
                    this.maxPressure = data.fields.Max_Process_Pressure__c.value;
                    this.VacuumSettingUnitsVal = data.fields.Vacuum_Setting_Units__c.value; //Service Ticket 161771
                }
                this.selectedConstraintProductSelectionByFlow = data.fields.Constraint_Product_Selection_By_Flow__c.value;
                this.quoteLineId = data.fields.Quote_Line__c.value;
                //SecA
                this.ConvertedBackPressureVal = data.fields.Converted_Back_Pressure__c.value; 
                this.ConvertedVacuumSettingVal = data.fields.Converted_Vacuum_Setting__c.value;
                this.ConvertedPressureSettingVal = data.fields.Converted_Pressure_Setting__c.value;
                this.ConvertedMaxProcessPressureVal = data.fields.Converted_Max_Process_Pressure__c.value;

                //SecB
                this.ConvertedPressureRelievingTemperatureVal = data.fields.Converted_Pressure_Relieving_Temperature__c.value;
                this.ConvertedRelievingPressureValueVal = data.fields.Converted_Relieving_Pressure_Value__c.value;
                this.V_ConvertedVacuumRelievingTemperatureVal = data.fields.V_Converted_Vacuum_Relieving_Temperature__c.value;
                this.V_ConvertedRelievingVacuumValueVal = data.fields.V_Converted_Relieving_Vacuum_Value__c.value;
                this.ConvertedPressureReliefReqFlowVal = data.fields.Converted_Pressure_Relief_Req_Flow__c.value;
                this.ConvertedVacuumReliefReqFlowVal = data.fields.Converted_Vacuum_Relief_Req_Flow__c.value;
                this.ConvertedAtmosphericPressureVal = data.fields.Converted_Atmospheric_Pressure__c.value;
                this.MolecularWeightVal = data.fields.Molecular_Weight__c.value;
                this.CompressibilityFactorVal = data.fields.Compressibility_Factor__c.value;
                this.RatioofSpecificHeatsVal = data.fields.Ratio_of_Specific_Heats__c.value;
                this.V_RatioofSpecificHeatsVal = data.fields.V_Ratio_of_Specific_Heats__c.value;   
                this.V_MolecularWeightVal = data.fields.V_Molecular_Weight__c.value;
                this.V_CompressibilityFactorVal = data.fields.V_Compressibility_Factor__c.value;

                //SecC
                this.atexCertificate = data.fields.Atex_Certificate__c.value;
                this.pedCertificate = data.fields.PED_2014_68_EU_CE_mark__c.value;
                this.cutrCertificate = data.fields.CU_TR__c.value;
                this.naceCertificate = data.fields.NACE__c.value;
                //Need to Check
                this.zoneCertificate = data.fields.Zone__c.value;
                this.gasGroupCertificate = data.fields.Gas_Group__c.value;

                //SecD
                this.selectedTypeOfModelOption = data.fields.Type_of_model__c.value;
                this.selectedTypeOfOverPressureValveOption = data.fields.Type_of_overpressure_valve__c.value;
                this.selectedIsFlameArresterNeededWithYourValve = data.fields.Is_flame_arrester_needed_with_your_valve__c.value;

                //SecE
                this.selectedModelSizeVal = data.fields.Model_Size__c.value;
                this.SizePreferenceVal = data.fields.Size_Preference__c.value;
                this.reliefValveRecord = {...data};
                console.log('reliefValve Record ## ', this.reliefValveRecord);


            /* added by piyush start -----*/
                if(!this.bMetaDataLoaded){
                    this.bMetaDataLoaded = true;
                    // added by piyush 
                    console.log('record Id - ' + this.recordId);
                    console.log('quote Id - ' + this.quoteId);
                    console.log('quote line Id - ' + this.quoteLineId);
    
    
                fetchFormAccessibility({rvId : this.recordId, qliId : this.quoteLineId})
                .then(result => {
                    console.log('Result fetchFormAccessibility***** ---> ' + JSON.stringify(result));  
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


                    fetchUserInfo()
                    .then(sResult => {
                        console.log('this.reliefValveRecord.fields.Price_Engineer_Override__c.value ---> ' + this.reliefValveRecord.fields.Price_Engineer_Override__c.value);
                        console.log('this.reliefValveRecord.fields.Lead_Time_Override__c.value ---> ' + this.reliefValveRecord.fields.Lead_Time_Override__c.value);
                        console.log('this.reliefValveRecord.fields.Build_Cost_Override__c.value ---> ' + this.reliefValveRecord.fields.Build_Cost_Override__c.value);
                        console.log('this.reliefValveRecord.fields.Quote_Description_Engineer_Override__c.value ---> ' + this.reliefValveRecord.fields.Quote_Description_Engineer_Override__c.value);
                        let profileName = sResult.Profile.Name;
                        // added by piyush soni 10/14/2020
                        if (profileName != 'CDC Engineering' && profileName != 'System Administrator') {
                            if (this.reliefValveRecord.fields.Price_Engineer_Override__c.value == true ||
                                this.reliefValveRecord.fields.Lead_Time_Override__c.value == true ||
                                this.reliefValveRecord.fields.Build_Cost_Override__c.value == true ||
                                this.reliefValveRecord.fields.Quote_Description_Engineer_Override__c.value == true
                            ) {
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
                    console.log('error fetchFormAccessibility ---> ' + JSON.stringify(error)); 
                });
               }

               /* added by piyush end -----*/
            }
            
        }
    }


    //added by piyush
    enableEditMode(){
        this.sEditBtnLabel = this.sEditBtnLabel == 'Edit' ? 'Cancel' : 'Edit'; 
        if(this.sEditBtnLabel == 'Cancel'){
            this.bShowProductReviewLink = false;
            
             this.thisoPopupPDF = window.open('/apex/configRVReference?Id=' + this.recordId , "", "width=500,height=500");
        }else{
            this.bShowProductReviewLink = true;
        }
        this.sDisabled = this.sDisabled == '' ? 'disabled' : '';
        this.bDisabled = this.bDisabled == true ? false : true;
    }

    //added by piyush 
    navigateToProductReview(){
        let isPortalUser = this.currentUserInfo.fields.IsPortalEnabled.value;

        let encodeURI = '';
        let sUrl = '/apex/RVConfig?qid='+ this.quoteLineId;

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


    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : ReliefType_FIELD
    })
    wiredPickListValue({ data, error }){
        if(data){
            this.reliefTypeOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:element.value+'Id'};
                this.reliefTypeOptions.push(newElement);
            });
            //this.selectedReliefType = this.reliefTypeOptions[0].value;
            this.error = undefined;
        }
        if(error){
            console.log(` Error while fetching Picklist values  ${error}`);
            this.error = error;
            this.reliefTypeOptions = undefined;
        }
    }    

    handleReliefTypeChange(event){
        this.section1Saved = false; // @developer
        window.console.log('selected value ===> '+event.target.value);
        this.selectedReliefType = event.target.value;
        //this.selectedConstraintProductSelectionByFlow = undefined;
    }

  /*  @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : Constraint_Product_Selection_By_Flow_FIELD
    })
    wiredConstraintProductSelectionByFlowPickListValue({ data, error }){
        if(data){
            this.constraintProductSelectionByFlowOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'constrainProductSelectByFlow'+element.value+'Id'};
                this.constraintProductSelectionByFlowOptions.push(newElement);
            });
           // this.constraintProductSelectionByFlowOptions = data.values;
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.constraintProductSelectionByFlowOptions = undefined;
        }
    }*/

    handleconstraintProductSelectionByFlowOptions(event){
        
        this.section1Saved = false; // @developer
        this.selectedConstraintProductSelectionByFlow = this.template.querySelector('.constrainProductSelectByFlow').checked;
        this.selectedConstraintProductSelectionByFlowTmp = this.selectedConstraintProductSelectionByFlow;
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : Type_of_model_FIELD
    })
    wiredTypeOfModelPickListValue({ data, error }){
        if(data){
            this.typeOfModelOptions = [];
            data.values.forEach(element =>{
               // let newElement = {label:element.label,value:element.value,generatedId:'TypeOfModel'+element.value+'Id'};
               let newElement = {label:element.label,value:element.value,dummyVal:element.value + "typeOfModel",generatedId:'TypeOfModel'+element.value+'Id'}; 
               this.typeOfModelOptions.push(newElement);
            });
           // this.reliefTypeOptions = data.values;
            this.error = undefined;
        }
        if(error){
            console.log(` Error while fetching Picklist values  ${error}`);
            this.error = error;
            this.typeOfModelOptions = undefined;
        }
    }

    handleTypeOfModelOptions(event){
        this.section4FieldChangeHandler();
        window.console.log('selected value ===> '+event.target.value);
        this.selectedTypeOfModelOption = event.target.value;
    }

 
    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : Type_of_overpressure_valve_FIELD
    })
    wiredTypeOfOverPressureValvePickListValue({ data, error }){
        if(data){
            this.typeOfOverPressureValveOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'TypeOfOverPressureValve'+element.value+'Id'};
                this.typeOfOverPressureValveOptions.push(newElement);
            });
           // this.typeOfOverPressureValveOptions = data.values;
            this.error = undefined;
        }
        if(error){
            console.log(` Error while fetching Picklist values  ${error}`);
            this.error = error;
            this.typeOfOverPressureValveOptions = undefined;
        }
    }

    handleTypeOfOverPressureValveOptions(event){
        this.section4FieldChangeHandler();
        window.console.log('selected value ===> '+event.target.value);
        this.selectedTypeOfOverPressureValveOption = event.target.value;
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : Is_flame_arrester_needed_with_your_valve_FIELD
    })
    wiredIsFlameArresterNeededWithYourValvePickListValue({ data, error }){
        if(data){
            this.IsFlameArresterNeededWithYourValveOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,dummyVal:element.value + "flame",generatedId:'IsFlameArrester'+element.value+'Id'};
                this.IsFlameArresterNeededWithYourValveOptions.push(newElement);
            });
           // this.IsFlameArresterNeededWithYourValveOptions = data.values;
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.IsFlameArresterNeededWithYourValveOptions = undefined;
        }
    }


    connectedCallback() {

        if(this.recordId !== undefined && this.recordId !== null && this.recordId !== ''){
            
            getRvRecord({recordId: this.recordId})
            .then(result => {

                
                this.ConvertedMaxProcessPressureVal = result.Converted_Max_Process_Pressure__c;
                this.ConvertedBackPressureVal = result.Converted_Back_Pressure__c;
                this.ConvertedVacuumSettingVal = result.Converted_Vacuum_Setting__c;
                this.ConvertedPressureSettingVal = result.Converted_Pressure_Setting__c;

                this.ConvertedRelievingPressureValueVal = result.Converted_Relieving_Pressure_Value__c;
                this.V_ConvertedRelievingVacuumValueVal = result.V_Converted_Relieving_Vacuum_Value__c;
                this.ConvertedPressureRelievingTemperatureVal = result.Converted_Pressure_Relieving_Temperature__c;
                this.V_ConvertedVacuumRelievingTemperatureVal = result.V_Converted_Vacuum_Relieving_Temperature__c;
                this.ConvertedPressureReliefReqFlowVal = result.Converted_Pressure_Relief_Req_Flow__c;
                this.ConvertedVacuumReliefReqFlowVal = result.Converted_Vacuum_Relief_Req_Flow__c;
                this.ConvertedAtmosphericPressureVal = result.Converted_Atmospheric_Pressure__c;

                if(result.Size_Preference__c != null){
                    this.SizePreferenceVal = result.Size_Preference__c;
                    this.SizePreferenceOptions = [];
                    this.SizePreferenceOptions.push({label: this.SizePreferenceVal, value: this.SizePreferenceVal});
                }
                
                if(result.Model_Size__c != null){
                    this.selectedModelSizeVal = result.Model_Size__c;         
                    this.ModelSizeOptions = [];
                    this.ModelSizeOptions.push({label: this.selectedModelSizeVal, value: this.selectedModelSizeVal});
                }

                //Service Ticket 161771
                this.pressureSetting = result.Pressure_Setting__c;
                this.PressureSettingUnitsVal = result.Pressure_Setting_Units__c;
                this.vaccumSetting = result.Vacuum_Setting__c;
                this.VacuumSettingUnitsVal = result.Vacuum_Setting_Units__c;
               
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

    @track selectedConstraintProductSelectionByFlowTmp = false;
    @track atexCertificateTmp = false;
    renderedCallback() {
        
        // this.template.querySelector("lightning-input-field[data-id='testinput']");
         if(this.recordId !== undefined && this.recordId !== null && this.recordId !== ''){

            this.atexCertificate = this.atexCertificateTmp;
            this.selectedConstraintProductSelectionByFlow = this.selectedConstraintProductSelectionByFlowTmp;

             if(this.template.querySelector('[class="'+this.selectedReliefType+'Id"]') !== null && this.template.querySelector('[class="'+this.selectedReliefType+'Id"]') !== undefined ){
                 this.template.querySelector('[class="'+this.selectedReliefType+'Id"]').checked = true;
             }
 
             if(this.selectedConstraintProductSelectionByFlow ){
                this.template.querySelector('.constrainProductSelectByFlow').checked = true;
                //this.template.querySelector('[class="constrainProductSelectByFlow'+this.selectedConstraintProductSelectionByFlow+'Id"]').checked = true;
             }
 
             if(this.template.querySelector(".atexCertificateInputCls") !== null && this.template.querySelector(".atexCertificateInputCls") !== undefined ){
                
                this.template.querySelector(".atexCertificateInputCls").checked = this.atexCertificate;
             }
             
             if(this.selectedIsFlameArresterNeededWithYourValve && this.template.querySelector('[class="IsFlameArrester'+this.selectedIsFlameArresterNeededWithYourValve+'Id"]') !== null && this.template.querySelector('[class="IsFlameArrester'+this.selectedIsFlameArresterNeededWithYourValve+'Id"]') !== undefined ){
                this.template.querySelector('[class="IsFlameArrester'+this.selectedIsFlameArresterNeededWithYourValve+'Id"]').checked = true;
               // console.log('render'+this.template.querySelector('class="IsFlameArrester'+this.selectedIsFlameArresterNeededWithYourValve+'Id"]').checked);
            }
            
            if(this.selectedTypeOfModelOption && this.template.querySelector('[class="TypeOfModel'+this.selectedTypeOfModelOption+'Id"]') !== null && this.template.querySelector('[class="IsFlameArrester'+this.selectedTypeOfModelOption+'Id"]') !== undefined ){
                this.template.querySelector('[class="TypeOfModel'+this.selectedTypeOfModelOption+'Id"]').checked = true;
                
            }
            
            if(this.selectedTypeOfOverPressureValveOption && this.template.querySelector('[class="TypeOfOverPressureValve'+this.selectedTypeOfOverPressureValveOption+'Id"]') !== null && this.template.querySelector('[class="TypeOfOverPressureValve'+this.selectedTypeOfOverPressureValveOption+'Id"]') !== undefined ){
                this.template.querySelector('[class="TypeOfOverPressureValve'+this.selectedTypeOfOverPressureValveOption+'Id"]').checked = true;
                
            }
         }
    }

    handleIsFlameArresterNeededWithYourValveChange(event){
        this.section4FieldChangeHandler();
        window.console.log('selected value ===> '+event.target.value);
        this.selectedIsFlameArresterNeededWithYourValve = event.target.value;
    }

    get pressureSelected(){
        return this.selectedReliefType === 'Pressure' || this.selectedReliefType === 'Pressure & Vacuum';
    }
    

    get isVacuumSelected(){
        return this.selectedReliefType === 'Vacuum';
    }

    get isPressureSelected(){
        return this.selectedReliefType === 'Pressure';
    }

    get isVacuumAndPressureSelected(){
        return this.selectedReliefType === 'Pressure & Vacuum';
    }

    get showSizingFlowArea(){
        return this.selectedConstraintProductSelectionByFlow;
    }

    handleFlowRateUnits(event){
        this.section1Saved = false; // @developer
        let flowRateUnits = event.detail.value;
        this.flowRateUnitsApi = event.detail.value;
        console.log('selected flow rate ',flowRateUnits);
        if(flowRateUnits){
            if(this.template.querySelector("c-lwc-relief-valve-size-flow-area") !== null && this.template.querySelector("c-lwc-relief-valve-size-flow-area") !== undefined){
                this.template.querySelector("c-lwc-relief-valve-size-flow-area").defaultFlowRateUnits(flowRateUnits);
            }
            
        }
    }
    
    handleTemperatureUnits(event){
        this.section1Saved = false; // @developer
        //let temperatureUnits = event.detail.value;
        this.temperatureUnitsApi = event.detail.value;
        //console.log('selected temperatureUnits ',temperatureUnits);
        if(this.temperatureUnitsApi && this.template.querySelector("c-lwc-relief-valve-size-flow-area")){
           // if(this.template.querySelector("c-lwc-relief-valve-size-flow-area") !== null && this.template.querySelector("c-lwc-relief-valve-size-flow-area") !== undefined){
                this.template.querySelector("c-lwc-relief-valve-size-flow-area").defaultTemperatureUnits(this.temperatureUnitsApi);
            //}
            
        }
    }

    handlePressureUnits(event){
        this.section1Saved = false; // @developer
        let pressureUnits = event.detail.value;
        this.pressureUnitsApi = event.detail.value;
        console.log('selected pressureUnits ',pressureUnits);
        if(pressureUnits){
            this.PressureSettingUnitsVal = pressureUnits;
            this.BackPressureUnitsVal = pressureUnits;
            //this.MaxProcessPressureUnitVal = pressureUnits;
            this.VacuumSettingUnitsVal = pressureUnits;
            if(this.template.querySelector("c-lwc-relief-valve-size-flow-area") !== null && this.template.querySelector("c-lwc-relief-valve-size-flow-area") !== undefined){
                this.template.querySelector("c-lwc-relief-valve-size-flow-area").defaultPressureUnits(pressureUnits);
            }
        }
    }

    // Save and Continue Start
    handleSavePresetUnitOfMeasure(event){
        event.preventDefault(); 
        const rvFields = event.detail.fields;
		
		rvFields.Id = this.recordId;
		//this.template.querySelector(".CertificationsForm").submit(bgrFields);
		console.log('=== this.bgrConvertedSupplyPressure '+this.bgrConvertedSupplyPressure);
        rvFields.Relief_Type__c = this.selectedReliefType;
        console.log('rvFields Pressure',rvFields.Converted_Pressure_Setting__c);
	    rvFields.Constraint_Product_Selection_By_Flow__c = this.selectedConstraintProductSelectionByFlow;
		console.log('rvFields ==== ',JSON.stringify(rvFields));
        
		saveRelief({conRV: rvFields})
        .then(result => {
            this.bShowEditBtn = false; //added by piyush
            this.bHideReturnToQuote = true; //@piyush
            this.section1Saved = true; // @developer
            this.isErrorSection1 = false;
            this.section1ErrorMessage = [];
            let removeError = this.template.querySelectorAll(".section1");
            if(removeError){
                removeError.forEach((element)=>{element.classList.remove("slds-box")});
            }
            /*this.isErrorSection2 = false;
            this.section2ErrorMessage = [];
            let removeError2 = this.template.querySelectorAll(".section2");
            if(removeError2){
                removeError2.forEach((element)=>{element.classList.remove("slds-box")});
            }*/
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

            this.isErrorSection5 = false;
            this.section5ErrorMessage = [];
            let removeError5 = this.template.querySelectorAll(".section5");
            if(removeError5){
                removeError5.forEach((element)=>{element.classList.remove("slds-box")});
            }


            if(this.selectedIsFlameArresterNeededWithYourValve && this.template.querySelector('[class="IsFlameArrester'+this.selectedIsFlameArresterNeededWithYourValve+'Id"]') ){
                this.template.querySelector('[class="IsFlameArrester'+this.selectedIsFlameArresterNeededWithYourValve+'Id"]').checked = false;
            }

            if(this.selectedTypeOfModelOption && this.template.querySelector('[class="TypeOfModel'+this.selectedTypeOfModelOption+'Id"]')){
                this.template.querySelector('[class="TypeOfModel'+this.selectedTypeOfModelOption+'Id"]').checked = false;    
            }
            if(this.selectedTypeOfOverPressureValveOption && this.template.querySelector('[class="TypeOfOverPressureValve'+this.selectedTypeOfOverPressureValveOption+'Id"]') !== null && this.template.querySelector('[class="TypeOfOverPressureValve'+this.selectedTypeOfOverPressureValveOption+'Id"]') !== undefined ){
                this.template.querySelector('[class="TypeOfOverPressureValve100Id"]').checked = true;               
            }
            this.selectedTypeOfModelOption = result.Type_of_model__c;
            this.selectedTypeOfOverPressureValveOption = result.Type_of_overpressure_valve__c;
            this.selectedIsFlameArresterNeededWithYourValve = result.Is_flame_arrester_needed_with_your_valve__c;
            this.SizePreferenceOptions = [];
            this.ModelSizeOptions = [];

            if(this.selectedConstraintProductSelectionByFlow){
                this.template.querySelector("c-lwc-relief-valve-size-flow-area").afterSectionASave(result);
            }

            

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Saved Successfully',
                    variant: 'success',
                }),
            );
            //
            this.pressureSetting = result.Pressure_Setting__c;
            this.backPressure = result.Back_Pressure__c;
            this.vaccumSetting = result.Vacuum_Setting__c;
            this.maxPressure = result.Max_Process_Pressure__c;
            this.PressureSettingUnitsVal = result.Pressure_Setting_Units__c; //161771
            this.VacuumSettingUnitsVal = result.Vacuum_Setting_Units__c;//161771
            //
            this.ConvertedMaxProcessPressureVal = result.Converted_Max_Process_Pressure__c;
            this.ConvertedBackPressureVal = result.Converted_Back_Pressure__c;
            this.ConvertedVacuumSettingVal = result.Converted_Vacuum_Setting__c;
            this.ConvertedPressureSettingVal = result.Converted_Pressure_Setting__c;
            console.log('calculateConvertedSupplyPressure result === ', result);
		})
        .catch(error => {
            /*this.isErrorSection2 = false;
            this.section2ErrorMessage = [];
            let removeError2 = this.template.querySelectorAll(".section2");
            if(removeError2){
                removeError2.forEach((element)=>{element.classList.remove("slds-box")});
            }*/
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

            this.isErrorSection5 = false;
            this.section5ErrorMessage = [];
            let removeError5 = this.template.querySelectorAll(".section5");
            if(removeError5){
                removeError5.forEach((element)=>{element.classList.remove("slds-box")});
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

    handlePresetUnitOfMeasureSuccess(event){
        this.recordId =  event.detail.id;
        /*
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Saved Successfully',
                variant: 'success',
            }),
        );
        window.console.log('onsuccess: ', event.detail.id);*/
        const payload = event.detail;
        window.console.log('record payload: ',JSON.stringify(payload));
    }

    handleSaveSizingArea(event) {
        this.bShowEditBtn = false; //added by piyush
        this.section2Saved = true; // added by piyush
        this.bHideReturnToQuote = true; //@piyush
        this.ConvertedRelievingPressureValueVal = event.detail.ConvertedRelievingPressureValue;
        this.V_ConvertedRelievingVacuumValueVal = event.detail.V_ConvertedRelievingVacuumValue;
        this.ConvertedPressureRelievingTemperatureVal = event.detail.ConvertedPressureRelievingTemperature;
        this.V_ConvertedVacuumRelievingTemperatureVal = event.detail.V_ConvertedVacuumRelievingTemperature;
        this.ConvertedPressureReliefReqFlowVal = event.detail.ConvertedPressureReliefReqFlow;
        this.ConvertedVacuumReliefReqFlowVal = event.detail.ConvertedVacuumReliefReqFlow;
        this.ConvertedAtmosphericPressureVal = event.detail.ConvertedAtmosphericPressure;

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

        this.isErrorSection5 = false;
        this.section5ErrorMessage = [];
        let removeError5 = this.template.querySelectorAll(".section5");
        if(removeError5){
            removeError5.forEach((element)=>{element.classList.remove("slds-box")});
        }

        this.pedCertificate = event.detail.PED_2014_68_EU_CE_mark__c;
        this.atexCertificate = event.detail.Atex_Certificate__c;
        this.gasGroupCertificate = event.detail.Gas_Group__c;
        this.zoneCertificate = event.detail.Zone__c;
        this.cutrCertificate = event.detail.CU_TR__c;
        this.naceCertificate = event.detail.NACE__c;

        if(this.selectedIsFlameArresterNeededWithYourValve && this.template.querySelector('[class="IsFlameArrester'+this.selectedIsFlameArresterNeededWithYourValve+'Id"]') ){
            this.template.querySelector('[class="IsFlameArrester'+this.selectedIsFlameArresterNeededWithYourValve+'Id"]').checked = false;
        }

        if(this.selectedTypeOfModelOption && this.template.querySelector('[class="TypeOfModel'+this.selectedTypeOfModelOption+'Id"]')){
            this.template.querySelector('[class="TypeOfModel'+this.selectedTypeOfModelOption+'Id"]').checked = false;    
        }
        if(this.selectedTypeOfOverPressureValveOption && this.template.querySelector('[class="TypeOfOverPressureValve'+this.selectedTypeOfOverPressureValveOption+'Id"]') !== null && this.template.querySelector('[class="TypeOfOverPressureValve'+this.selectedTypeOfOverPressureValveOption+'Id"]') !== undefined ){
            this.template.querySelector('[class="TypeOfOverPressureValve100Id"]').checked = true;               
        }
        this.selectedTypeOfModelOption = event.detail.selectedTypeOfModelOption;
        this.selectedTypeOfOverPressureValveOption = event.detail.selectedTypeOfOverPressureValveOption;
        this.selectedIsFlameArresterNeededWithYourValve = event.detail.selectedIsFlameArresterNeededWithYourValve;
        this.SizePreferenceOptions = [];
        this.ModelSizeOptions = [];
   }

    handleSaveCertifications(event){
        event.preventDefault(); 
        const certificationRVFields = event.detail.fields;
        certificationRVFields.Id = this.recordId;
        certificationRVFields.Atex_Certificate__c = this.atexCertificate;
        certificationRVFields.CU_TR__c = this.cutrCertificate;
        certificationRVFields.PED_2014_68_EU_CE_mark__c = this.pedCertificate;
        certificationRVFields.NACE__c = this.naceCertificate;
        if(this.atexCertificate){
            certificationRVFields.Zone__c = this.zoneCertificate;
            certificationRVFields.Gas_Group__c = this.gasGroupCertificate;
        }
        

        console.log('certificationRVFields ==== ',JSON.stringify(certificationRVFields));
		SaveCertifications({conRV: certificationRVFields})
        .then(result => {
            this.bShowEditBtn = false; //added by piyush
            this.section3Saved = true; //added by piyush
            this.bHideReturnToQuote = true; //@piyush

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

            this.isErrorSection5 = false;
            this.section5ErrorMessage = [];
            let removeError5 = this.template.querySelectorAll(".section5");
            if(removeError5){
                removeError5.forEach((element)=>{element.classList.remove("slds-box")});
            }


            if(this.selectedIsFlameArresterNeededWithYourValve && this.template.querySelector('[class="IsFlameArrester'+this.selectedIsFlameArresterNeededWithYourValve+'Id"]') ){
                this.template.querySelector('[class="IsFlameArrester'+this.selectedIsFlameArresterNeededWithYourValve+'Id"]').checked = false;
            }

            if(this.selectedTypeOfModelOption && this.template.querySelector('[class="TypeOfModel'+this.selectedTypeOfModelOption+'Id"]')){
                this.template.querySelector('[class="TypeOfModel'+this.selectedTypeOfModelOption+'Id"]').checked = false;    
            }
            if(this.selectedTypeOfOverPressureValveOption && this.template.querySelector('[class="TypeOfOverPressureValve'+this.selectedTypeOfOverPressureValveOption+'Id"]') !== null && this.template.querySelector('[class="TypeOfOverPressureValve'+this.selectedTypeOfOverPressureValveOption+'Id"]') !== undefined ){
                this.template.querySelector('[class="TypeOfOverPressureValve100Id"]').checked = true;               
            }
            this.selectedTypeOfModelOption = result.Type_of_model__c;
            this.selectedTypeOfOverPressureValveOption = result.Type_of_overpressure_valve__c;
            this.selectedIsFlameArresterNeededWithYourValve = result.Is_flame_arrester_needed_with_your_valve__c;
            this.SizePreferenceOptions = [];
            this.ModelSizeOptions = [];
            //rvWrapper.rvObjData = conRV;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Saved Successfully',
                    variant: 'success',
                }),
            );
            console.log('Certification result === ', result);
		})
        .catch(error => {

            this.isErrorSection4 = false;
            this.section4ErrorMessage = [];
            let removeError4 = this.template.querySelectorAll(".section4");
            if(removeError4){
                removeError4.forEach((element)=>{element.classList.remove("slds-box")});
            }

            this.isErrorSection5 = false;
            this.section5ErrorMessage = [];
            let removeError5 = this.template.querySelectorAll(".section5");
            if(removeError5){
                removeError5.forEach((element)=>{element.classList.remove("slds-box")});
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

    handleSaveProductNarrowing(event){

        event.preventDefault(); 
        const rvObjFields = event.detail.fields;

        rvObjFields.Id = this.recordId;
        rvObjFields.Relief_Type__c = this.selectedReliefType ;
        rvObjFields.Constraint_Product_Selection_By_Flow__c = this.selectedConstraintProductSelectionByFlow;
        rvObjFields.Pressure_Setting__c = this.pressureSetting; // Service Ticket 161771
        rvObjFields.Pressure_Setting_Units__c =this.PressureSettingUnitsVal;  //Service Ticket 161771 
        rvObjFields.Vacuum_Setting__c = this.vaccumSetting; // Service Ticket 161771
        rvObjFields.Vacuum_Setting_Units__c = this.VacuumSettingUnitsVal; // Service Ticket 161771
        rvObjFields.Is_flame_arrester_needed_with_your_valve__c = this.selectedIsFlameArresterNeededWithYourValve;
        rvObjFields.Type_of_overpressure_valve__c = this.selectedTypeOfOverPressureValveOption;
        rvObjFields.Type_of_model__c = this.selectedTypeOfModelOption;
        
        rvObjFields.Ratio_of_Specific_Heats__c = this.RatioofSpecificHeatsVal;
        rvObjFields.Molecular_Weight__c = this.MolecularWeightVal;
        rvObjFields.Compressibility_Factor__c = this.CompressibilityFactorVal;
        rvObjFields.V_Compressibility_Factor__c = this.V_CompressibilityFactorVal;
        rvObjFields.V_Molecular_Weight__c = this.V_MolecularWeightVal;
        rvObjFields.V_Ratio_of_Specific_Heats__c = this.V_RatioofSpecificHeatsVal;
        //rvObjFields.V_Converted_Vacuum_Relieving_Temperature__c = this.V_ConvertedVacuumRelievingTemperatureVal;
        
        rvObjFields.Brand__c = this.brand;
        rvObjFields.Atex_Certificate__c = this.atexCertificate ;      
        rvObjFields.PED_2014_68_EU_CE_mark__c = this.pedCertificate ;
        rvObjFields.NACE__c = this.naceCertificate ;
        rvObjFields.CU_TR__c = this.cutrCertificate ;
        if(this.atexCertificate){
            rvObjFields.Gas_Group__c = this.gasGroupCertificate ;
            rvObjFields.Zone__c = this.zoneCertificate;
        }
        
        rvObjFields.Converted_Max_Process_Pressure__c = this.ConvertedMaxProcessPressureVal;
        rvObjFields.Converted_Back_Pressure__c = this.ConvertedBackPressureVal ;
        rvObjFields.Converted_Pressure_Setting__c = this.ConvertedPressureSettingVal ;
        rvObjFields.Converted_Vacuum_Setting__c = this.ConvertedVacuumSettingVal ;

        rvObjFields.Converted_Relieving_Pressure_Value__c = this.ConvertedRelievingPressureValueVal;
        rvObjFields.Converted_Atmospheric_Pressure__c = this.ConvertedAtmosphericPressureVal;
        rvObjFields.V_Converted_Relieving_Vacuum_Value__c  = this.V_ConvertedRelievingVacuumValueVal;
        rvObjFields.Converted_Pressure_Relief_Req_Flow__c = this.ConvertedPressureReliefReqFlowVal;
        rvObjFields.Converted_Vacuum_Relief_Req_Flow__c = this.ConvertedVacuumReliefReqFlowVal;
        rvObjFields.V_Converted_Vacuum_Relieving_Temperature__c =this.V_ConvertedVacuumRelievingTemperatureVal;   
        rvObjFields.Converted_Pressure_Relieving_Temperature__c = this.ConvertedPressureRelievingTemperatureVal;
        
		//this.template.querySelector(".CertificationsForm").submit(bgrFields);
        console.log('rvObjFields ==== ',JSON.stringify(rvObjFields));
        
		SaveProductNarrowing({conRV: rvObjFields})
        .then(results => {
            this.bShowEditBtn = false; //added by piyush
            this.section4Saved = true; // added by piyush
            this.bHideReturnToQuote = true; //@piyush



            this.ModelSizeOptions = [];
            this.isErrorSection4 = false;
            this.section4ErrorMessage = [];
            let removeError4 = this.template.querySelectorAll(".section4");
            if(removeError4){
                removeError4.forEach((element)=>{element.classList.remove("slds-box")});
            }

            this.isErrorSection5 = false;
            this.section5ErrorMessage = [];
            let removeError5 = this.template.querySelectorAll(".section5");
            if(removeError5){
                removeError5.forEach((element)=>{element.classList.remove("slds-box")});
            }

            this.SizePreferenceVal = '';
            this.selectedModelSizeVal = '';
            if(results['productNarrowedRecords'] && results.productNarrowedRecords.length > 0){
                let result = results.productNarrowedRecords;
                this.returnedPtcSzc = result.map(function(element) {
                    return {
                        ptc: element.split(',')[0].split('=')[1].trim(), szc: +element.split(',')[1].split('=')[1].trim()  
                    } 
                    });
    
                let sizesAvailable = []; 
                result.forEach((element) => { 
                    let size = +element.split(",")[1].split('=')[1].trim(); 
                    if(sizesAvailable.indexOf(size) === -1) 
                    { 
                        sizesAvailable.push(size) ;
                    } 
                }); 
                sizesAvailable = sizesAvailable.sort((a,b)=>a-b);
                this.sizesAvailable = sizesAvailable;
               // alert('sizesAvailable'+this.sizesAvailable);
                this.SizePreferenceOptions = [];
                this.SizePreferenceOptions.push({label: "smallest", value: "smallest"});
                sizesAvailable.forEach((sizePre) => {
                    this.SizePreferenceOptions.push({
                        label: sizePre, value: `${sizePre}`
                    })
                }); 
    

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Saved Successfully',
                        variant: 'success',
                    }),
                );

            }
            else{
                this.ModelSizeOptions = [];
                this.SizePreferenceOptions = [];
                this.SizePreferenceVal = '';
                this.selectedModelSizeVal = '';
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Note',
                        message: 'No Model and Size can be found for the selected inputs',
                        variant: 'warning',
                    }),
                );

            }   
            
		})
        .catch(error => {

            this.isErrorSection5 = false;
            this.section5ErrorMessage = [];
            let removeError5 = this.template.querySelectorAll(".section5");
            if(removeError5){
                removeError5.forEach((element)=>{element.classList.remove("slds-box")});
            }

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

    handleSizePreferenceChange(event){
        let selectedSize = event.target.value;
        this.SizePreferenceVal =  event.target.value;
        var modelAndSize;
        // this.SizePreferenceVal.push({label: selectedSize, value: selectedSize});
        if(selectedSize == 'smallest'){

            let setPtcSzcSmallest = this.returnedPtcSzc;

            let models = [];
            setPtcSzcSmallest.forEach((ptcs) => { 
                if(models.indexOf(ptcs['ptc']) === -1) 
                { 
                    models.push(ptcs['ptc']) ;
                } 
            });

            modelAndSize = models.map(function(mName){ 
                let smallestSize;
                setPtcSzcSmallest.forEach((ptcSzcsCombo) => {   
                    if(ptcSzcsCombo['ptc'] === mName ){
                    if(smallestSize != null){
                        if(ptcSzcsCombo['szc'] < smallestSize)
                        smallestSize = ptcSzcsCombo['szc'];
                    }
                    else{
                        smallestSize = ptcSzcsCombo['szc'];
                    }
                    }

                }); 
                return `${smallestSize}" ${mName}`
            });
        }
        else{
            let setPtcSzc = this.returnedPtcSzc;

            modelAndSize = setPtcSzc.filter(function(element) {
                return element['szc'] == selectedSize 
            }); 
            modelAndSize = modelAndSize.map(function(element) {
            
                return `${element.szc}" ${element.ptc}` 
            });
            console.log('modelAndSize'+modelAndSize);
        }
        modelAndSize.sort();
        this.ModelSizeOptions = modelAndSize.map(function(element) {
        return {
            label: element, value: element
        } 
        }); 
    }

    handleModelSizeChange(event){
        this.selectedModelSizeVal = event.target.value;
        if(this.selectedModelSizeVal.includes("Fiberglass")){
            this.isFiberglass = true;
        }else{
            this.isFiberglass = false;
        }
    }

    handleAtexCertificate(event){

        this.section3FieldChangeHandler();
        console.log('==event.target.value ',event.target.value);
        this.atexCertificate = this.template.querySelector(".atexCertificateInputCls").checked;
        this.atexCertificateTmp = this.atexCertificate;

        this.template.querySelector(".atexCertificateInputCls").checked = this.atexCertificate;
        console.log('==atexCertificate ', this.atexCertificate);
        this.zoneCertificate = '';
        this.gasGroupCertificate = '';
    }

    changeCertificates(event){
        this.section3FieldChangeHandler();
        let val = event.target.value;
        let eleId = event.target.dataset.id;
        this[eleId] = val;
        //this.cutrCertificate = event.target.value;
    }

    handleSaveProductSelection(event){
        event.preventDefault(); 
        const rvObjFields = event.detail.fields;
        rvObjFields.Id = this.recordId;
        rvObjFields.Converted_Pressure_Setting__c = this.ConvertedPressureSettingVal ;
        rvObjFields.Converted_Vacuum_Setting__c = this.ConvertedVacuumSettingVal ;
        rvObjFields.Vacuum_Setting__c = this.vaccumSetting ;
        rvObjFields.Brand__c = this.brand;
        rvObjFields.Converted_Vacuum_Setting__c = this.ConvertedVacuumSettingVal ;
        rvObjFields.Size_Preference__c = this.SizePreferenceVal;
        rvObjFields.Model_Size__c = this.selectedModelSizeVal;
        rvObjFields.Finish_Configuration_Flag__c = false; // added by piyush
		//this.template.querySelector(".CertificationsForm").submit(bgrFields);
        console.log('rvObjFields ==== ',JSON.stringify(rvObjFields));

        if(this.SizePreferenceVal && this.selectedModelSizeVal){
            SaveProductSelection({conRV: rvObjFields})
            .then(result => {

                this.isErrorSection5 = false;
                this.section5ErrorMessage = [];
                let removeError5 = this.template.querySelectorAll(".section5");
                if(removeError5){
                    removeError5.forEach((element)=>{element.classList.remove("slds-box")});
                }
    
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Saved Successfully',
                        variant: 'success',
                    }),
                );
                console.log('SaveProductSelection result === ', result);
    
                let isPortalUser = this.currentUserInfo.fields.IsPortalEnabled.value;
                console.log('ScurrentUserInfo ', isPortalUser);
                let encodeURI = '';
                let sUrl = '/apex/RVConfig?id=' + this.recordId + '&qid=' + this.quoteLineId + '&selectedTab=second';

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
                        "url": "/apex/RVConfig?id="+this.recordId+'&qid='+this.quoteLineId+'&selectedTab=second'
                    }
                });*/
            })
            .catch(error => {
                if(error.body.message){
                    this.isErrorSection5 = true;
                    this.section5ErrorMessage = [];
                    this.section5ErrorMessage.push(error.body.message);
                    let removeError = this.template.querySelectorAll(".section5");
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
        else{
            this.isErrorSection5 = true;
            this.section5ErrorMessage = [];
            this.section5ErrorMessage.push('Please select a Model & Size and Size Preference from the dropdown');
            let removeError = this.template.querySelectorAll(".section5");
            if(removeError){
                removeError.forEach((element)=>{element.classList.add("slds-box")});
            } 
        }
		
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

    focusSection(event){
 
       /* event.target.parentNode.childNodes.forEach((element) => { element.classList.remove("active") });
        event.target.classList.add("active");
        let dataid = event.target.dataset.id;

       var firstSection = this.template.querySelector(".section-1").offsetHeight;        
       var secondSection = this.template.querySelector(".section-2").offsetHeight;     
       var thirdSection = this.template.querySelector(".section-3").offsetHeight;     
       var fourthSection = this.template.querySelector(".section-4").offsetHeight;

        let getDiv =  this.template.querySelector("div[data-id='"+dataid+"']");
        if(getDiv){
           
            getDiv.scrollIntoView();
            var scrolledY = window.scrollY;
            if(scrolledY){

                window.scroll(0, scrolledY - 300);
            }       
       }*/
       var sectionName = event.target.dataset.id;
       console.log('on click data ID ',event.target.dataset.id);

       this.template.querySelector("div[data-id='"+sectionName+"']").scrollIntoView({behavior: "smooth"});
       //window.scrollTo(0, 190);

    }

    RemoveDecimal(event){
        let targetName = event.target.name;
        if(targetName === 'pressureSetting')
            this.pressureSetting = event.target.value;
        else if(targetName === 'backPressure'){
            this.backPressure = event.target.value;
        }
        else if(targetName === 'vaccumSetting'){
            this.vaccumSetting = event.target.value;
        }
        else if(targetName === 'maxPressure'){
            this.maxPressure = event.target.value;
        }
    }

    section1FieldChangeHandler(){
        this.section1Saved = false; // @developer
    }

    handleChildCmpFieldUpdate(event){
        this.section2Saved = false; // added by piyush
    }

    section3FieldChangeHandler(event){
        this.section3Saved = false; // added by piyush
    }

    section4FieldChangeHandler(event){
        this.section4Saved = false; // added by piyush
    }
    restrictNonNumericalValues(event){
        this.section1Saved = false; // @developer
        console.log('event.keycode'+event.keyCode);
        let charCode = (event.which) ? event.which : event.keyCode;
        if(charCode != 46 && charCode != 37 && charCode != 39 && charCode != 110 && charCode != 190 && ((charCode > 31 && charCode <48)||(charCode>57 && charCode<93) ||charCode >105 ))
            event.preventDefault();
    }

    onScrollMain(event) {
        
       let number = event.target.scrollTop;
       console.log('Full height ======= '+event.target.scrollTop);
       
       var firstSection = this.template.querySelector(".section-1").offsetHeight;        
       var secondSection = this.template.querySelector(".section-2").offsetHeight;     
       var thirdSection = this.template.querySelector(".section-3").offsetHeight;     
       var fourthSection = this.template.querySelector(".section-4").offsetHeight;

       let activeElements = this.template.querySelectorAll(".active");    
       if(activeElements){
           activeElements.forEach((element)=>{element.classList.remove("active")});
       }
      
       if(number < firstSection){
           window.console.log('in first Section ');
           this.template.querySelector(".PresetUnitOfMeasureCls").classList.add("active");          
           
       }else if(number < firstSection + secondSection && this.selectedConstraintProductSelectionByFlow){
           window.console.log('in second Section ');
           this.template.querySelector(".SizingAreaCls").classList.add("active");
          
       }else if(number < firstSection + secondSection + thirdSection){
           window.console.log('in third Section ');            
           this.template.querySelector(".CERTIFICATIONSCls").classList.add("active"); 
       }
       else if(number < firstSection + secondSection + thirdSection + fourthSection){
           window.console.log('in fourth Section ');
           this.template.querySelector(".ProductNarrowingCls").classList.add("active");          
       }
       else{
           window.console.log('in fifth Section ');
           this.template.querySelector(".ProductSelectionCls").classList.add("active");
       }
    }


    onSizingFlowAreaFormOver(event){
         
        if(this.section1Saved == false && this.bDisabled == false){
            this.template.querySelector("div[class='section-1']").scrollIntoView({behavior: "smooth"});
             event.preventDefault();
             this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Unsaved Changes On "Preset Units of Measure" Section.',
                    message : '',
                    variant: 'warning',
                }),
            );
              return;
        }
     }

     onCertificationOver(event){
        if(this.showSizingFlowArea == false){
           this.onSizingFlowAreaFormOver(event);
        }

        if(this.showSizingFlowArea == true){ // if 2nd section visiable 

           if(this.section2Saved == false && this.bDisabled == false){
               this.template.querySelector("div[class='section-2']").scrollIntoView({behavior: "smooth"});
                event.preventDefault();
                this.dispatchEvent(
                   new ShowToastEvent({
                       title: 'Unsaved Changes On "Sizing/Flow Area.',
                       message : '',
                       variant: 'warning',
                   }),
               );
                 return;
           }
        }
    }

    onProductNarrowingOver(event){
         
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

     onProductSelectionOver(event){
        if(this.section4Saved == false && this.bDisabled == false){
            this.template.querySelector("div[class='section-4']").scrollIntoView({behavior: "smooth"});
             event.preventDefault();
             this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Unsaved Changes On "Product Narrowing.',
                    message : '',
                    variant: 'warning',
                }),
            );
              return;
        }
     }

    
}