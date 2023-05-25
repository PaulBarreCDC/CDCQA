import { LightningElement, track,api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Id from '@salesforce/user/Id';

import EvaluationPer_FIELD from '@salesforce/schema/Rupture_Disc__c.Evaluation_Per__c';
import ReliefType_FIELD from '@salesforce/schema/Rupture_Disc__c.Relief_Type__c';
import isThereLiquidReliefScenario_FIELD from '@salesforce/schema/Rupture_Disc__c.Is_there_a_liquid_relief_scenario__c';
import constrainProductSelectionByFlow_FIELD from '@salesforce/schema/Rupture_Disc__c.constrain_product_selection_by_flow__c';
import pressureWithstand_FIELD from '@salesforce/schema/Rupture_Disc__c.Pressure_Withstand__c';
import vacuumWithstand_FIELD from '@salesforce/schema/Rupture_Disc__c.Vacuum_Withstand__c';
import constrainProductSelection_FIELD from '@salesforce/schema/Rupture_Disc__c.Constrain_product_selection__c';
import pED_2014_68_EU_CEmark_FIELD from '@salesforce/schema/Rupture_Disc__c.PED_2014_68_EU_CE_mark__c';
import ChinaManufacturingLicense_FIELD from '@salesforce/schema/Rupture_Disc__c.China_Manufacturing_License__c';
import NACE_FIELD from '@salesforce/schema/Rupture_Disc__c.NACE__c';
import operatingPressureRatio_FIELD from '@salesforce/schema/Rupture_Disc__c.Operating_Pressure_Ratio__c';
import applicationtype_FIELD from '@salesforce/schema/Rupture_Disc__c.Application_type__c';
import CU_TR__FIELD from '@salesforce/schema/Rupture_Disc__c.CU_TR__c';
import X3A_Sanitary_Standards_FIELD from '@salesforce/schema/Rupture_Disc__c.X3A_Sanitary_Standards__c';
import Atex_Certificate_FIELD from '@salesforce/schema/Rupture_Disc__c.Atex_Certificate__c';
import Non_Fragmenting_Design_Required_FIELD from '@salesforce/schema/Rupture_Disc__c.Non_Fragmenting_Design_Required__c';
import CSA_Marking_CRN_Number__c_FIELD from '@salesforce/schema/Rupture_Disc__c.CSA_Marking_CRN_Number__c';
import ASMESectionVIIIDivision1_FIELD from '@salesforce/schema/Rupture_Disc__c.ASME_Section_VIII_Division_1__c';
import ConvertedVacuumSetting_Field from '@salesforce/schema/Rupture_Disc__c.Converted_Vacuum_Setting__c';
import ConvertedPressureSetting_Field from '@salesforce/schema/Rupture_Disc__c.Converted_Pressure_Setting__c';
import ConvertedTemperatureSetting_FIELD from '@salesforce/schema/Rupture_Disc__c.Converted_Temperature_Setting__c';
import ConvertedPositivePressureValue_FIELD from '@salesforce/schema/Rupture_Disc__c.Converted_Positive_Pressure_Value__c';
import ConvertedBackPressureValue_FIELD from '@salesforce/schema/Rupture_Disc__c.Converted_Back_Pressure_Value__c';
import KOSHACompliance_FIELD from '@salesforce/schema/Rupture_Disc__c.KOSHA_Compliance__c';
import ComplyWithAD2000Merkblat_FIELD from '@salesforce/schema/Rupture_Disc__c.Comply_with_AD2000_Merkblat_A1__c';
import ComplyWithRegelsVoorTosellanOderDr_FIELD from '@salesforce/schema/Rupture_Disc__c.Comply_with_Regels_Voor_Tosellan_Oder_Dr__c';

import PressureSetting_FIELD from '@salesforce/schema/Rupture_Disc__c.Pressure_Setting__c';
import PressureSettingUnits_FIELD from '@salesforce/schema/Rupture_Disc__c.Pressure_Setting_Units__c';
import VacuumSetting_FIELD from '@salesforce/schema/Rupture_Disc__c.Vacuum_Setting__c';
import VacuumSettingUnits_FIELD from '@salesforce/schema/Rupture_Disc__c.Vacuum_Setting_Units__c';
import TemperatureSetting_FIELD from '@salesforce/schema/Rupture_Disc__c.Temperature_Setting__c';
import TemperatureSettingUnits_FIELD from '@salesforce/schema/Rupture_Disc__c.Temperature_Setting_Units__c';
import BackPressure_FIELD from '@salesforce/schema/Rupture_Disc__c.Back_Pressure_Value__c';
import BackPressureUnits_FIELD from '@salesforce/schema/Rupture_Disc__c.Back_Pressure_Units__c';
import PositivePressure_FIELD from '@salesforce/schema/Rupture_Disc__c.Positive_Pressure_Value__c';
import PositivePressureUnits_FIELD from '@salesforce/schema/Rupture_Disc__c.Positive_Pressure_Units__c';
import DiscMaterialOfConstruction_FIELD from '@salesforce/schema/Rupture_Disc__c.Disc_Material_of_Construction__c';
import SizeUnits_FIELD from '@salesforce/schema/Rupture_Disc__c.Size_Units__c';

import connectedCallBackMethod from '@salesforce/apex/RuptureDiscController.connectedCallBackMethod';
import saveCertificate from '@salesforce/apex/RuptureDiscController.saveCertificate';
import saveProductNarrowing from '@salesforce/apex/RuptureDiscController.saveProductNarrowing';
import saveRelief from '@salesforce/apex/RuptureDiscController.saveRelief';
//import getDiscMaterial from '@salesforce/apex/RuptureDiscController.getDiscMaterial';

import Rupture_Disc_OBJECT from '@salesforce/schema/Rupture_Disc__c';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getRecord } from 'lightning/uiRecordApi';
import Relief_Type_FIELD from '@salesforce/schema/Rupture_Disc__c.Relief_Type__c';
import QUOTELINE_FIELD from '@salesforce/schema/Rupture_Disc__c.Quote_Line__c';
import EDITQUOTELINE_FIELD from '@salesforce/schema/Rupture_Disc__c.Edit_QuoteLine__c';
import DiagramOverride from '@salesforce/schema/Rupture_Disc__c.Diagram_Override__c';
import PriceOverride from '@salesforce/schema/Rupture_Disc__c.Price_Override__c';
import LeadTimeOverride from '@salesforce/schema/Rupture_Disc__c.Lead_Time_Override__c';
import BuildCostOverride from '@salesforce/schema/Rupture_Disc__c.Build_Cost_Override__c';
import QuoteDescriptionsOverride from '@salesforce/schema/Rupture_Disc__c.Quote_Descriptions_Override__c';


import fetchFormAccessibility from '@salesforce/apex/RuptureDiscController.fetchFormAccessibility'; // @added by piyush
import fetchUserInfo from '@salesforce/apex/RuptureDiscController.fetchUserInfo'; // @added by piyush

const FIELDS = [
    'User.Name',
    'User.IsPortalEnabled'
];

const RuptureDiscFIELDS = [DiagramOverride,PriceOverride,LeadTimeOverride,BuildCostOverride,QuoteDescriptionsOverride,EDITQUOTELINE_FIELD,QUOTELINE_FIELD,Relief_Type_FIELD,isThereLiquidReliefScenario_FIELD,constrainProductSelectionByFlow_FIELD, pressureWithstand_FIELD, 
    constrainProductSelection_FIELD, vacuumWithstand_FIELD, CU_TR__FIELD, X3A_Sanitary_Standards_FIELD, KOSHACompliance_FIELD, ComplyWithAD2000Merkblat_FIELD,
    Atex_Certificate_FIELD, operatingPressureRatio_FIELD, applicationtype_FIELD, Non_Fragmenting_Design_Required_FIELD, NACE_FIELD, ComplyWithRegelsVoorTosellanOderDr_FIELD,
    ChinaManufacturingLicense_FIELD, pED_2014_68_EU_CEmark_FIELD,PressureSetting_FIELD, PressureSettingUnits_FIELD, VacuumSetting_FIELD, EvaluationPer_FIELD,
    VacuumSettingUnits_FIELD, TemperatureSetting_FIELD, TemperatureSettingUnits_FIELD, BackPressure_FIELD, BackPressureUnits_FIELD, SizeUnits_FIELD,
    PositivePressure_FIELD, PositivePressureUnits_FIELD, DiscMaterialOfConstruction_FIELD, CSA_Marking_CRN_Number__c_FIELD, ASMESectionVIIIDivision1_FIELD,
    ConvertedPressureSetting_Field, ConvertedVacuumSetting_Field, ConvertedBackPressureValue_FIELD, ConvertedPositivePressureValue_FIELD, ConvertedTemperatureSetting_FIELD];

export default class LwcRuptureDisc extends NavigationMixin(LightningElement) {
    @track myStep = '1';
    @api number = 0;
    userId = Id;
    currentUserInfo = {};
    //@api recordId = 'a1p8A000000YJedQAG'; //Pressure
    //@api recordId = 'a1p8A000000YJH1QAO'; // Pressure and vacuum 
    //@api recordId = 'a1p8A000000YJH6QAO'; // vacuum 
    //@api recordId = 'a1p8A000000YK0jQAG'; // sizing / flow area 
    @api recordId;
    @api quoteId;
    @track rDiscRecordId;
    @track selectedReliefType = '';
    @track reliefTypeOptions;
    @track isThereLiquidReliefScenarioOptions;
    @track selectedIsThereLiquidReliefScenario;
    @track constrainProductSelectionByFlowOptions;
    @track selectedConstrainProductSelectionByFlow;
    @track pressureWithstandOptions;
    @track selectedPressureWithstand;
    @track constrainProductSelectionOptions;
    @track selectedConstrainProductSelection;
    @track pED_2014_68_EU_CEmarkOptions;
    @track selectedPED_2014_68_EU_CEmark;
    @track chinaManufacturingLicenseOptions;
    @track selectedChinaManufacturingLicense;
    @track nACEOptions;
    @track selectedNACE;
    @track operatingPressureRatioOptions;
    @track selectedOperatingPressureRatio;
    @track applicationTypeOptions;
    @track selectedApplicationType;
    @track vacuumWithstandOptions;
    @track selectedVacuumWithstand;
    @track atexCertificate = false;
    @track CSAMarkingCRNNumber = false;
    @track ASMESectionVIIIDivision1 = false;
    @track KOSHACompliance;
    @track disableCheckbox;
    @api ruptureDiscRecordData;
    @track productPickListValues;
    @track seatPickListOptions;
    @track sizePickListOptions;
    @track ComplywithAD2000MerkblatA1;
    @track ComplywithRegelsVoorTosellanOderDr;
    
    @track pressureSetting;
    @track pressureSettingUnits;
    @track vacuumSetting;
    @track vacuumSettingUnits;
    @track temperatureSetting;
    @track temperatureSettingUnits;
    @track backPressure;
    @track backPressureUnits;
    @track positivePressure;
    @track positivePressureUnits;
    @track discMaterialOfConstruction;
    @track discMaterialOfConstructionOptions;
    @track disableKOSHACB;
    
    @track showSizingFlowAreaSection = false;
    @track showRbackPressureInputs = false;
    @track showVpossitivePressureFields = false;

    @track conPressureSettingField;
    @track conVacuumSettingField;
    @track conBackPressureSettingField;
    @track conPositivePressureField;
    @track conTemperatureSettingField;


    @track cutrCertificate;
    @track aSanitaryStandards;
    @track nonFragmnetingDesignRequired;

    //Error Handling SectionWise
    @track section1ErrorMessage;
    @track isErrorSection1;   
    @track section3ErrorMessage;
    @track isErrorSection3;
    @track section4ErrorMessage;
    @track isErrorSection4;

    @track sizeUnitsOptions;
    @track evalPer;
    @api disableASME;

    @track convPressSetting;
    @track convTempSetting;

    //added by piyush 
    section1Saved = true; // RELIEF TYPE params 
    section2Saved = true; // sizing flow option,child component section
    section3Saved = true; // certificate section 
    

    bDisabled = false;
    bHideReturnToQuote = false; // added by piyush to control back button visibility 

    bShowEditBtn = false;
    sDisabled = '';
    bDisabled = false;
    sEditBtnLabel = 'Edit';
    bShowProductReviewLink = false;
    bMetaDataLoaded = false;
    @track quoteLineId;
      //added by piyush
      enableEditMode(){
        this.sEditBtnLabel = this.sEditBtnLabel == 'Edit' ? 'Cancel' : 'Edit'; 
        if(this.sEditBtnLabel == 'Cancel'){
            this.bShowProductReviewLink = false;
              this.thisoPopupPDF = window.open('/apex/ConfigureProductScreen?qid=' + this.quoteLineId , "", "width=500,height=500");
              
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
        let sUrl = '/apex/ConfigRD?qid='+ this.quoteLineId;

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

    @wire(getRecord, { recordId: '$userId', fields: FIELDS })
    oUser({ error, data }) {
        if (data) {
			console.log('===> USER' + JSON.stringify(data));
			this.currentUserInfo = data;
        } else if (error) {
            console.log('===> error' + JSON.stringify(error));
        }
    }

    @wire(getObjectInfo, { objectApiName: Rupture_Disc_OBJECT })
        objectInfo;

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : ReliefType_FIELD
    })
    wiredPickListValue({ data, error }){
        if(data){
            this.reliefTypeOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:element.value.split(' ').join('').split('&').join('')+'Id'};
                this.reliefTypeOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.reliefTypeOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : isThereLiquidReliefScenario_FIELD
    })
    isThereLiquidReliefScenario_FIELDPickListValues({ data, error }){
        if(data){
            this.isThereLiquidReliefScenarioOptions = [];

            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,dummyVal:element.value + "1",generatedId:'isthereALiquidScenario'+element.value+'Id'};
                this.isThereLiquidReliefScenarioOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.isThereLiquidReliefScenarioOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : constrainProductSelectionByFlow_FIELD
    })
    constrainProductSelectionByFlow_FIELDPickListValues({ data, error }){
        if(data){
            //this.constrainProductSelectionByFlowOptions = data.values;
            this.constrainProductSelectionByFlowOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'constrainProductSelectByFlow'+element.value+'Id'};
                this.constrainProductSelectionByFlowOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.constrainProductSelectionByFlowOptions = undefined;
        }
    }
    

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : pressureWithstand_FIELD
    })
    pressureWithstandPickListValues({ data, error }){
        if(data){
            //this.pressureWithstandOptions = data.values;
            this.pressureWithstandOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'pressureWithstand'+element.value.split(' ').join('')+'Id'};
                this.pressureWithstandOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.pressureWithstandOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : vacuumWithstand_FIELD
    })
    vacuumWithstandPickListValues({ data, error }){
        if(data){
            //this.vacuumWithstandOptions = data.values;
            this.vacuumWithstandOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'vacuumWithstand'+element.value.split(' ').join('')+'Id'};
                this.vacuumWithstandOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.vacuumWithstandOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : SizeUnits_FIELD
    })
    sizeUnitsPickListValues({ data, error }){
        if(data){
            this.sizeUnitsOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'SizeUnits'+element.value.split(' ').join('')+'Id'};
                this.sizeUnitsOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.sizeUnitsOptions = undefined;
        }
    }

    
    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : constrainProductSelection_FIELD
    })
    constrainProductSelectionPickListValues({ data, error }){
        if(data){
            //this.constrainProductSelectionOptions = data.values;
            this.constrainProductSelectionOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'constrainProductSelection'+element.value.split(' ').join('').split('&').join('')+'Id'};
                this.constrainProductSelectionOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.constrainProductSelectionOptions = undefined; 
        }
    }


    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : pED_2014_68_EU_CEmark_FIELD
    })
    pED_2014_68_EU_CEmarkPickListValues({ data, error }){
        if(data){
            //this.pED_2014_68_EU_CEmarkOptions = data.values;
            this.pED_2014_68_EU_CEmarkOptions = [];
            //this.pED_2014_68_EU_CEmarkOptions.push({label : "None", value: "pedNone"});
            //data.values.push({label : "None", value: "None"});
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'PED'+element.value+'Id'};                
                this.pED_2014_68_EU_CEmarkOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.pED_2014_68_EU_CEmarkOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : ChinaManufacturingLicense_FIELD
    })
    chinaManufacturingLicenseOptionsPickListValues({ data, error }){
        if(data){
            //this.chinaManufacturingLicenseOptions = data.values;
            this.chinaManufacturingLicenseOptions = [];
            //this.chinaManufacturingLicenseOptions.push({ label: 'None', value: 'cmlNone' });
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'ChinaManufacturingLicense'+element.value+'Id'};
                this.chinaManufacturingLicenseOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.chinaManufacturingLicenseOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : NACE_FIELD
    })
    nACEOptionsPickListValues({ data, error }){
        if(data){
            //this.nACEOptions = data.values;
            this.nACEOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'NACE'+element.value+'Id'}
                this.nACEOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.nACEOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : operatingPressureRatio_FIELD
    })
    operatingPressureRatioPickListValues({ data, error }){
        if(data){
            //this.operatingPressureRatioOptions = data.values;
            this.operatingPressureRatioOptions = [];
            /*data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'operatingPressureRatioId'+element.value.split('.').join('')+'Id'};
                this.operatingPressureRatioOptions.push(newElement);
            });*/
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'OPR'+element.value.split('.').join('')+'Id'};
                this.operatingPressureRatioOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.operatingPressureRatioOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : applicationtype_FIELD
    })
    applicationTypePickListValues({ data, error }){
        if(data){
            //this.applicationTypeOptions = data.values;
            this.applicationTypeOptions = [];
            /*data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'applicationType'+element.value.split('/').join('').split('-').join('')+'Id'};
                this.applicationTypeOptions.push(newElement);
            });*/
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'applicationType'+element.value+'Id'};
                this.applicationTypeOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.applicationTypeOptions = undefined;
        }
    }

    @wire(getRecord, { recordId: '$recordId', fields: RuptureDiscFIELDS})
    ruptureDiscRec({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while loading Rupture Disc',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data) {
            if(data !== undefined){
                this.ruptureDiscRecordData = {...data};
                this.quoteLineId = data.fields.Quote_Line__c.value;   // added by piyush
                this.selectedConstrainProductSelectionByFlow = data.fields.constrain_product_selection_by_flow__c.value;
                this.selectedIsThereLiquidReliefScenario = data.fields.Is_there_a_liquid_relief_scenario__c.value;
                this.selectedPressureWithstand = data.fields.Pressure_Withstand__c.value;
                this.selectedConstrainProductSelection =  data.fields.Constrain_product_selection__c.value;
                this.selectedVacuumWithstand = data.fields.Vacuum_Withstand__c.value;
                this.selectedReliefType = data.fields.Relief_Type__c.value;                
                this.pressureSetting = data.fields.Pressure_Setting__c.value;
                this.pressureSettingUnits = data.fields.Pressure_Setting_Units__c.value;
                this.vacuumSetting = data.fields.Vacuum_Setting__c.value;
                this.vacuumSettingUnits = data.fields.Vacuum_Setting_Units__c.value;
                this.temperatureSetting = data.fields.Temperature_Setting__c.value;
                this.temperatureSettingUnits = data.fields.Temperature_Setting_Units__c.value;
                this.backPressure = data.fields.Back_Pressure_Value__c.value;
                this.backPressureUnits = data.fields.Back_Pressure_Units__c.value;
                this.positivePressure = data.fields.Positive_Pressure_Value__c.value;
                this.positivePressureUnits = data.fields.Positive_Pressure_Units__c.value;
                this.discMaterialOfConstruction = data.fields.Disc_Material_of_Construction__c.value;
                this.selectedNACE = data.fields.NACE__c.value;
                this.selectedPED_2014_68_EU_CEmark = data.fields.PED_2014_68_EU_CE_mark__c.value;
                this.selectedChinaManufacturingLicense = data.fields.China_Manufacturing_License__c.value;
                this.atexCertificate = data.fields.Atex_Certificate__c.value;
                this.CSAMarkingCRNNumber = data.fields.CSA_Marking_CRN_Number__c.value;
                this.ASMESectionVIIIDivision1 = data.fields.ASME_Section_VIII_Division_1__c.value; 
                this.selectedApplicationType =data.fields.Application_type__c.value;  
                this.selectedOperatingPressureRatio = data.fields.Operating_Pressure_Ratio__c.value;
                this.KOSHACompliance = data.fields.KOSHA_Compliance__c.value;
                this.ComplywithAD2000MerkblatA1 = data.fields.Comply_with_AD2000_Merkblat_A1__c.value;
                this.ComplywithRegelsVoorTosellanOderDr = data.fields.Comply_with_Regels_Voor_Tosellan_Oder_Dr__c.value;
                this.aSanitaryStandards = data.fields.X3A_Sanitary_Standards__c.value;
                this.nonFragmnetingDesignRequired = data.fields.Non_Fragmenting_Design_Required__c.value;
                this.sizeUnits = data.fields.Size_Units__c.value;    
                this.evalPer = data.fields.Evaluation_Per__c.value;
                this.convPressSetting = data.fields.Converted_Pressure_Setting__c.value;
                this.convTempSetting = data.fields.Converted_Temperature_Setting__c.value;
                if(this.evalPer == 'ASME Water' || this.evalPer == 'ASME Gas/Vapor' || this.evalPer == 'ASME Steam'){
                    this.disableASME = true;
                } else {
                    this.disableASME = false;
                }        
                console.log('disableASME:-- ',this.disableASME);  
                
                
                if(!this.bMetaDataLoaded){
                    this.bMetaDataLoaded = true;
                    // added by piyush 
                    console.log('record Id - ' + this.recordId);
                    console.log('quote Id - ' + this.quoteId);
                    console.log('quote line Id - ' + this.quoteLineId);
    
    
                fetchFormAccessibility({qliId : this.quoteLineId})
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

                    console.log('this.ruptureDiscRecordData.fields.Edit_QuoteLine__c.value--> ' + this.ruptureDiscRecordData.fields.Edit_QuoteLine__c.value);
                    if(this.ruptureDiscRecordData.fields.Edit_QuoteLine__c.value){
                        this.sDisabled = '' ;
                        this.bDisabled = false;

                        this.bShowEditBtn = false; //added by piyush
                        this.bHideReturnToQuote = true; //@piyush
                        this.section1Saved = true; //@developer
                        this.bShowProductReviewLink = false;
                    }
    
                fetchUserInfo()
                 .then(sResult => {
                    console.log('this.ruptureDiscRecordData.fields.Diagram_Override__c.value ---> ' + this.ruptureDiscRecordData.fields.Diagram_Override__c.value);
                    console.log('this.ruptureDiscRecordData.fields.Price_Override__c.value ---> ' + this.ruptureDiscRecordData.fields.Price_Override__c.value);
                    console.log('this.ruptureDiscRecordData.fields.Lead_Time_Override__c.value ---> ' + this.ruptureDiscRecordData.fields.Lead_Time_Override__c.value);
                    console.log('this.ruptureDiscRecordData.fields.Build_Cost_Override__c.value ---> ' + this.ruptureDiscRecordData.fields.Build_Cost_Override__c.value);
                    console.log('this.ruptureDiscRecordData.fields.Quote_Descriptions_Override__c.value ---> ' + this.ruptureDiscRecordData.fields.Quote_Descriptions_Override__c.value);
                    let profileName = sResult.Profile.Name;
                    // added by piyush soni 10/14/2020
                    if(profileName != 'CDC Engineering' &&  profileName != 'System Administrator'){
                        if(this.ruptureDiscRecordData.fields.Diagram_Override__c.value == true || 
                          this.ruptureDiscRecordData.fields.Price_Override__c.value == true || 
                          this.ruptureDiscRecordData.fields.Lead_Time_Override__c.value == true || 
                          this.ruptureDiscRecordData.fields.Build_Cost_Override__c.value == true || 
                          this.ruptureDiscRecordData.fields.Quote_Descriptions_Override__c.value == true
                        ){
                               console.log('inside');
                             this.sDisabled = 'disabled';
                             this.bDisabled = true;
                             this.bShowEditBtn = false;
                        }
                    }
    
                    //++++++++++++++++++++++++++++++++++++++
    
                })
                .catch(error => {
                    console.log('error fetchUserInfo ---> ' + JSON.stringify(error)); 
                });

    
                })
                .catch(error => {
                    console.log('error fetchFormAccessibility ---> ' + JSON.stringify(error)); 
                });

               }
            }
        }
    }

    get isVacuumSelected(){
        return this.selectedReliefType === 'Vacuum Relief'
    }

    get isPressureSelected(){
        return this.selectedReliefType === 'Pressure Relief'
    }

    get isVacuumAndPressureSelected(){
        return this.selectedReliefType === 'Pressure & Vacuum Relief'
    }

    get isVPAndProdSelByFlowNoSelected(){
        return this.selectedReliefType === 'Pressure & Vacuum Relief' && this.selectedConstrainProductSelectionByFlow != 'No';
    }

    handleMaterialOfDisc(event){
        this.discMaterialOfConstruction = event.detail.value;
    }
    
    handlePressureSettingUnits(event){
        this.pressureSettingUnits = event.detail.value;
    }

    handleTemperatureSettingUnits(event){
        this.temperatureSettingUnits = event.detail.value;
    }

    handleVacuumSettingUnits(event){
        this.vacuumSettingUnits = event.detail.value;
    }

    // @track selectedVacuumSetting;
    // handleVacuumSetting(event){
    //     this.selectedVacuumSetting = event.detail.value;
    // }

    handlePositivePressureUnits(event){
        this.positivePressureUnits = event.detail.value;
    }

    handleBackPressureUnits(event){
        this.backPressureUnits = event.detail.value;
    }

    handleisThereLiquidReliefScenarioOptions(event){
        this.section1Saved = false; // @developer
        this.selectedIsThereLiquidReliefScenario = event.target.value;
    }

    handleisconstrainProductSelectionByFlowOptions(event){
        this.section1Saved = false; // @developer
        this.selectedConstrainProductSelectionByFlow = event.target.value;
        if(this.selectedConstrainProductSelectionByFlow === 'Yes'){
            this.showSizingFlowAreaSection = true;
        }else{
            this.showSizingFlowAreaSection = false;
        }
    }

    handlePressureWithstandOptions(event){
        this.section1Saved = false; // @developer
        this.selectedPressureWithstand = event.target.value;
        if(this.selectedPressureWithstand === 'Positive Pressure'){
            this.showVpossitivePressureFields = true;
        }else{
            this.showVpossitivePressureFields = false;
        }
    }

    handleVacuumWithstandOptions(event){    
        this.section1Saved = false; // @developer    
        this.selectedVacuumWithstand = event.target.value;
        if(this.selectedVacuumWithstand === 'Back Pressure'){
            this.showRbackPressureInputs = true;
        }else{
            this.showRbackPressureInputs = false;
        }
    }

    handleConstrainProductSelectionOptions(event){  
        this.section1Saved = false; // @developer       
        this.selectedConstrainProductSelection = event.target.value;
        console.log('this.selectedConstrainProductSelection =: ',this.selectedConstrainProductSelection );
      ////  this.template.querySelector('c-lwc-r-d-sizing-flow-area').updateEvaluationPer(this.selectedConstrainProductSelection);
        //Added 10/7/2020
        // if(this.selectedConstrainProductSelection && this.template.querySelector("c-lwc-r-d-sizing-flow-area ")){
        //     this.template.querySelector("c-lwc-r-d-sizing-flow-area ").defaultSelConstrain(this.selectedConstrainProductSelection);
        // }
    }

    handlePED_2014_68_EU_CEmarkOptions(event){   
        this.section3Saved = false; //added by piyush     
        if( event.target.value != 'pedNone'){
            this.selectedPED_2014_68_EU_CEmark = event.target.value;
        } else {
            this.selectedPED_2014_68_EU_CEmark = '';
        }
    }

    handleChinaManufacturingLicenseOptions(event){    
        this.section3Saved = false; //added by piyush       
        if( event.target.value != 'cmlNone'){
            this.selectedChinaManufacturingLicense = event.target.value;
        } else {
            this.selectedChinaManufacturingLicense = '';
        }
    }

    handlenACEOptions(event){
        this.section3Saved = false; //added by piyush
        this.selectedNACE = event.target.value; 
    }

    handleOperatingPressureRatioOptions(event){
        this.selectedOperatingPressureRatio = event.target.value;
    }

    handleApplicationTypeOptions(event){
        this.selectedApplicationType = event.target.value;
    }

    @track sizeUnits;
    handleSizeUnits(event){
        this.section1Saved = false; // @developer
        this.sizeUnits = event.target.value;
    }

    ///handleSavePresetUnitOfMeasure
    handleSavePresetUnitOfMeasure(event){
        event.preventDefault();
        const rFields = event.detail.fields;
        rFields.Id = this.recordId;
        
        rFields.Relief_Type__c = this.selectedReliefType;
        rFields.Pressure_Withstand__c = this.selectedPressureWithstand;
        rFields.Vacuum_Withstand__c = this.selectedVacuumWithstand;
        rFields.Is_there_a_liquid_relief_scenario__c = this.selectedIsThereLiquidReliefScenario;
        rFields.constrain_product_selection_by_flow__c = this.selectedConstrainProductSelectionByFlow;
        rFields.Constrain_product_selection__c = this.selectedConstrainProductSelection;
        rFields.Size_Units__c = this.sizeUnits;
        rFields.Bypass__c=false;
        rFields.Finish_Configuration_Flag__c = false;
        saveRelief({ruptureDisc: rFields})
        .then(result => {
            this.bShowEditBtn = false; //added by piyush
            this.bHideReturnToQuote = true; //@piyush
            this.section1Saved = true; //@developer

            console.log('result'+JSON.stringify(result));
            if(this.selectedConstrainProductSelectionByFlow == 'Yes'){
                this.template.querySelector("c-lwc-r-d-sizing-flow-area").afterSectionASave(result);
            }
            
            this.isErrorSection0 = false;
            this.section0ErrorMessage = [];
            let removeError0 = this.template.querySelectorAll(".section0");
            if(removeError0){
                removeError0.forEach((element)=>{element.classList.remove("slds-box")});
            }

            this.isErrorSection1 = false;
            this.section1ErrorMessage = [];
            let removeError = this.template.querySelectorAll(".section1");
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
            
            if(this.selectedPED_2014_68_EU_CEmark && this.template.querySelector('[class="PED'+this.selectedPED_2014_68_EU_CEmark+'Id"]')){
                this.template.querySelector('[class="PED'+this.selectedPED_2014_68_EU_CEmark+'Id"]').checked = false;
            }

            if(this.selectedChinaManufacturingLicense && this.template.querySelector('[class="ChinaManufacturingLicense'+this.selectedChinaManufacturingLicense+'Id"]')){
                this.template.querySelector('[class="ChinaManufacturingLicense'+this.selectedChinaManufacturingLicense+'Id"]').checked = false;
            }
            
            if(this.selectedNACE && this.template.querySelector('[class="NACE'+this.selectedNACE+'Id"]')){
                this.template.querySelector('[class="NACE'+this.selectedNACE+'Id"]').checked = false;
            }  
            
            if(this.selectedOperatingPressureRatio && this.template.querySelector('[class="OPR'+this.selectedOperatingPressureRatio.split('.').join('')+'Id"]')){
                this.template.querySelector('[class="OPR'+this.selectedOperatingPressureRatio.split('.').join('')+'Id"]').checked = false;
            }

            if(this.selectedApplicationType && this.template.querySelector('[class="applicationType'+this.selectedApplicationType+'Id"]')){
                this.template.querySelector('[class="applicationType'+this.selectedApplicationType+'Id"]').checked = false;
            }

            if(this.CSAMarkingCRNNumber && this.template.querySelector(".CSAMarkingCRNNumberInputCls") ){
                this.template.querySelector(".CSAMarkingCRNNumberInputCls").checked = false;
            }
    
            if(this.ASMESectionVIIIDivision1 && this.template.querySelector(".ASMESectionVIIIDivision1InputCls") ){
                this.template.querySelector(".ASMESectionVIIIDivision1InputCls").checked = false;
            }
            
            this.CSAMarkingCRNNumber        =   result.CSA_Marking_CRN_Number__c;
            this.ASMESectionVIIIDivision1   =   result.ASME_Section_VIII_Division_1__c;
            this.cutrCertificate = event.detail.CU_TR__c; 
            this.selectedPED_2014_68_EU_CEmark = result.PED_2014_68_EU_CE_mark__c;
            this.selectedChinaManufacturingLicense = result.China_Manufacturing_License__c;
            this.selectedNACE = result.NACE__c;
            this.selectedOperatingPressureRatio = result.Operating_Pressure_Ratio__c;
            this.selectedApplicationType = result.Application_type__c;
            this.discMaterialOfConstruction = result.Disc_Material_of_Construction__c;
            this.nonFragmnetingDesignRequired = result.Non_Fragmenting_Design_Required__c;
            this.rFields = result;            
            this.template.querySelector(".PresetUnitOfMeasureForm").submit(result);
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Saved Successfully',
                    variant: 'success',
                }),
            );
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
            if(error.body.message){
                if(this.selectedReliefType == '' || this.selectedReliefType == null || this.selectedReliefType == undefined){
                    this.isErrorSection0 = true;
                    this.section0ErrorMessage = [];
                    this.section0ErrorMessage.push(error.body.message);
                    let removeError0 = this.template.querySelectorAll(".section0");
                    if(removeError0){
                        removeError0.forEach((element)=>{element.classList.add("slds-box")});
                    }
                } else if(this.selectedReliefType != '' || this.selectedReliefType != null || this.selectedReliefType != undefined){
                    this.isErrorSection0 = false;
                    this.section0ErrorMessage = [];
                    let removeError0 = this.template.querySelectorAll(".section0");
                    if(removeError0){
                        removeError0.forEach((element)=>{element.classList.remove("slds-box")});
                    }
                    this.isErrorSection1 = true;
                    this.section1ErrorMessage = [];
                    this.section1ErrorMessage.push(error.body.message);
                    let removeError = this.template.querySelectorAll(".section1");
                    if(removeError){
                        removeError.forEach((element)=>{element.classList.add("slds-box")});
                    }
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
        this.rDiscRecordId =  event.detail.id;
        const payload = event.detail;
    }    

    handleAtexCertificate(){
        this.section3Saved = false; //added by piyush
        this.atexCertificate = this.template.querySelector(".atexCertificateInputCls").checked;
    }

      //added by piyush 
   onCertificateFieldUpdate(){
    this.section3Saved = false; //added by piyush
   }

    handleCSAMarkingCRNNumber(){
        this.section3Saved = false; //added by piyush
        this.CSAMarkingCRNNumber = this.template.querySelector(".CSAMarkingCRNNumberInputCls").checked;
        this.template.querySelector(".ASMESectionVIIIDivision1InputCls").checked = this.CSAMarkingCRNNumber;
        this.ASMESectionVIIIDivision1 = this.CSAMarkingCRNNumber;
        
        if(this.disableASME == true){
            console.log('test: Eval Per : -- ',this.disableASME); 
            this.ASMESectionVIIIDivision1 = this.disableASME;
        }
    }

    handleASMESectionVIIIDivision1(){
        this.section3Saved = false; //added by piyush
        this.ASMESectionVIIIDivision1 = this.template.querySelector(".ASMESectionVIIIDivision1InputCls").checked;
    }
    
    handleComplywithAD2000MerkblatA1(event){
        this.section3Saved = false; //added by piyush
        this.ComplywithAD2000MerkblatA1 = event.target.value;
        if(this.ComplywithAD2000MerkblatA1 === true){
            this.disableKOSHACB = true
        }
        if(this.ComplywithAD2000MerkblatA1 === false && this.ComplywithRegelsVoorTosellanOderDr === false) {
            this.disableKOSHACB = false;
        }
    }

    handleRegelsVoorTosellanOderDr(event){
        this.section3Saved = false; //added by piyush
        this.ComplywithRegelsVoorTosellanOderDr = event.target.value;
        if(this.ComplywithRegelsVoorTosellanOderDr === true){
            this.disableKOSHACB = true
        }
        if(this.ComplywithAD2000MerkblatA1 === false && this.ComplywithRegelsVoorTosellanOderDr === false) {
            this.disableKOSHACB = false;
        }
    }

    handleKOSHACompliance(event){
        this.section3Saved = false; //added by piyush
        this.KOSHACompliance = event.target.value;
        if(this.KOSHACompliance === true){
            this.disableCheckbox = true;
        } else {
            this.disableCheckbox = false;
        }
    }    

    handleSaveCertifications(event){
        event.preventDefault(); 
        const rFields = event.detail.fields;
        rFields.Id = this.recordId;

        //Section C Fields
        rFields.PED_2014_68_EU_CE_mark__c = this.selectedPED_2014_68_EU_CEmark;
        rFields.China_Manufacturing_License__c = this.selectedChinaManufacturingLicense;
        rFields.NACE__c = this.selectedNACE;        
        rFields.Atex_Certificate__c=this.atexCertificate;
        rFields.CSA_Marking_CRN_Number__c=this.CSAMarkingCRNNumber;
        rFields.ASME_Section_VIII_Division_1__c=this.ASMESectionVIIIDivision1;
        rFields.Finish_Configuration_Flag__c = false;
        saveCertificate({ruptureDisc: rFields})
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

            if(this.selectedOperatingPressureRatio && this.template.querySelector('[class="OPR'+this.selectedOperatingPressureRatio.split('.').join('')+'Id"]')){
                this.template.querySelector('[class="OPR'+this.selectedOperatingPressureRatio.split('.').join('')+'Id"]').checked = false;
            }

            if(this.selectedApplicationType && this.template.querySelector('[class="applicationType'+this.selectedApplicationType+'Id"]')){
                this.template.querySelector('[class="applicationType'+this.selectedApplicationType+'Id"]').checked = false;
            }
            this.selectedOperatingPressureRatio = result.Operating_Pressure_Ratio__c;
            this.selectedApplicationType = result.Application_type__c;
            this.discMaterialOfConstruction = result.Disc_Material_of_Construction__c;
            this.nonFragmnetingDesignRequired = result.Non_Fragmenting_Design_Required__c;
            this.discMaterialOfConstructionOptions = [];
            
            this.navToProd = true;  
            console.log('this.navToProd :-- ',this.navToProd);
            this.rFields = result.ruptDisc;
            this.discMaterialOfConstructionOptions = result.selOptions;
            this.template.querySelector(".CertificationsForm").submit(rFields);
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
        this.rDiscRecordId =  event.detail.id;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Saved Certifications',
                variant: 'success',
            }),
        );
        this.ruptureDiscRecordData = event.detail;
        const payload = event.detail;
    }
    @track navToProdnavToProd;   

    navToProdSelClick(event){
        event.preventDefault();
        console.log('this.navToProd navToProdSelClick: - '+this.navToProd);
       // if(this.navToProd == false){
            let isPortalUser = this.currentUserInfo.fields.IsPortalEnabled.value;        
            if(isPortalUser)
                window.open('/s/productrecommendationscmp?configId='+this.recordId, "_parent");  
            else
                window.open('/lightning/cmp/c__productRecommendationsCmp?c__configId='+ this.recordId, "_parent"); 
       // }        
    }

    handleSaveProductNarrowing(event){
        event.preventDefault(); 
        const rFields = event.detail.fields;        
        rFields.Finish_Configuration_Flag__c = false;
        rFields.Converted_Pressure_Setting__c = this.convPressSetting;
        rFields.Converted_Temperature_Setting__c = this.convTempSetting;
        rFields.Disc_Material_of_Construction__c = this.discMaterialOfConstruction;
        rFields.Operating_Pressure_Ratio__c = this.selectedOperatingPressureRatio;
        rFields.Application_type__c = this.selectedApplicationType;
        rFields.Bypass__c=false;
        rFields.Id = this.recordId;

        saveProductNarrowing({ruptureDisc: rFields})
        .then(result => {
            this.isErrorSection4 = false;
            this.section4ErrorMessage = [];
            let removeError4 = this.template.querySelectorAll(".section4");
            if(removeError4){
                removeError4.forEach((element)=>{element.classList.remove("slds-box")});
            }
            this.rFields = result;
            this.template.querySelector(".ProductNarrowingForm").submit(rFields);            
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: error.statusText,
                    message: error.body.message,
                    variant: 'error',
                }),
            );
            /*if(error.body.message){
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
            }*/
        });        
    }

    handleProductNarrowingOnSuccess(event){
        this.recordId =  event.detail.id;
        this.rDiscRecordId =  event.detail.id;
        //this.generateProductSelectionDropDown(event.detail);
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Saved Product Narrowing data',
                variant: 'success',
            }),
        );
        this.ruptureDiscRecordData = event.detail;
        const payload = event.detail;
        this.navigateToProductRecommendation();
    }

    generateProductSelectionDropDown(RuptureDiscObj){
        let rDisc = { 'sobjectType': 'Rupture_Disc__c'};
        rDisc.Application_type__c = RuptureDiscObj.fields.Application_type__c.value;
        rDisc.Operating_Pressure_Ratio__c = RuptureDiscObj.fields.Operating_Pressure_Ratio__c.value;
        rDisc.CU_TR__c = RuptureDiscObj.fields.CU_TR__c.value;
        rDisc.X3A_Sanitary_Standards__c = RuptureDiscObj.fields.X3A_Sanitary_Standards__c.value;
        rDisc.Atex_Certificate__c = RuptureDiscObj.fields.Atex_Certificate__c.value;
        rDisc.Relief_Type__c = RuptureDiscObj.fields.Relief_Type__c.value;
        rDisc.Non_Fragmenting_Design_Required__c = RuptureDiscObj.fields.Non_Fragmenting_Design_Required__c.value;        
    }
    
    //added by piyush
    onSizingFlowAreaFormOver(event){
         
        if(this.section1Saved == false && this.bDisabled == false){
            this.template.querySelector("div[class='section-1']").scrollIntoView({behavior: "smooth"});
             event.preventDefault();
             this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Unsaved Changes On "Relief Type" Section.',
                    message : '',
                    variant: 'warning',
                }),
            );
              return;
        }
     }


     onCertificationOver(event){
        if(this.showSizingFlowAreaSection == false){
           this.onSizingFlowAreaFormOver(event);
        }

        if(this.showSizingFlowAreaSection == true){ // if 2nd section visiable 
      
        console.log('on mouse over' + this.section2Saved);
           if(this.section2Saved == false && this.bDisabled == false){
               this.template.querySelector("div[class='section-2']").scrollIntoView({behavior: "smooth"});
                event.preventDefault();
                this.dispatchEvent(
                   new ShowToastEvent({
                       title: 'Unsaved Changes On "Sizing Flow Area',
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


   // relif Type fields handler // added by piyush  
    handleRelifTypeChange(){
        this.section1Saved = false; // @developer
    }

    // handle the selected value
    handleReliefTypeSelected(event) {
        this.selectedReliefType = event.target.value;
        this.section1Saved = false; // @developer
        //Added 10/7/2020
        // if(this.selectedReliefType && this.template.querySelector("c-lwc-r-d-sizing-flow-area ")){
        //     this.template.querySelector("c-lwc-r-d-sizing-flow-area ").defaultSelReliefType(this.selectedReliefType);
        // }
    }

    renderedCallback() {
        if(this.recordId !== undefined && this.recordId !== null && this.recordId !== ''){

            if(this.selectedReliefType === 'Pressure Relief'){
                if(this.template.querySelector('.PressureReliefId') !== null && this.template.querySelector('.PressureReliefId') !== undefined ){
                    this.template.querySelector('.PressureReliefId').checked = true;
                }
            }else if(this.selectedReliefType === 'Vacuum Relief'){
               if(this.template.querySelector('.VacuumReliefId') !== null && this.template.querySelector('.VacuumReliefId') !== undefined ){
                    this.template.querySelector('.VacuumReliefId').checked = true;
                }                
            }else if(this.selectedReliefType === 'Pressure & Vacuum Relief'){
                if(this.template.querySelector('.PressureVacuumReliefId') !== null && this.template.querySelector('.PressureVacuumReliefId') !== undefined ){
                    this.template.querySelector('.PressureVacuumReliefId').checked = true;
                }
            }

            if(this.selectedConstrainProductSelectionByFlow === 'Yes'){
                if(this.template.querySelector('.constrainProductSelectByFlowYesId') !== null && this.template.querySelector('.constrainProductSelectByFlowYesId') !== undefined){
                    this.template.querySelector('.constrainProductSelectByFlowYesId').checked = true;
                    this.showSizingFlowAreaSection = true;
                }
            }else if(this.selectedConstrainProductSelectionByFlow === 'No'){
                if(this.template.querySelector('.constrainProductSelectByFlowNoId') !== null && this.template.querySelector('.constrainProductSelectByFlowNoId') !== undefined){
                    this.template.querySelector('.constrainProductSelectByFlowNoId').checked = true;
                    this.showSizingFlowAreaSection = false;
                }
            }             
                
            if(this.selectedIsThereLiquidReliefScenario === 'Yes' && this.template.querySelector('[class="isthereALiquidScenario'+this.selectedIsThereLiquidReliefScenario+'Id"]')){
                this.template.querySelector('[class="isthereALiquidScenario'+this.selectedIsThereLiquidReliefScenario+'Id"]').checked = true;
            }else if(this.selectedIsThereLiquidReliefScenario == 'No' && this.template.querySelector('[class="isthereALiquidScenario'+this.selectedIsThereLiquidReliefScenario+'Id"]')){
                this.template.querySelector('[class="isthereALiquidScenario'+this.selectedIsThereLiquidReliefScenario+'Id"]').checked = true;
            }

            if(this.sizeUnits === 'Metric' && this.template.querySelector('[class="SizeUnits'+this.sizeUnits+'Id"]')){
                this.template.querySelector('[class="SizeUnits'+this.sizeUnits+'Id"]').checked = true;
            }else if(this.sizeUnits == 'US Units' && this.template.querySelector('[class="SizeUnitsUSUnitsId"]')){
                this.template.querySelector('[class="SizeUnitsUSUnitsId"]').checked = true;
            }


            if(this.selectedConstrainProductSelection === 'Pressure'){
                if(this.template.querySelector('.constrainProductSelectionPressureId') !== null && this.template.querySelector('.constrainProductSelectionPressureId') !== undefined){
                    this.template.querySelector('.constrainProductSelectionPressureId').checked = true;
                }
            }else if(this.selectedConstrainProductSelection == 'Vacuum'){
                if(this.template.querySelector('.constrainProductSelectionVacuumId') !== null && this.template.querySelector('.constrainProductSelectionVacuumId') !== undefined){
                    this.template.querySelector('.constrainProductSelectionVacuumId').checked = true;
                }
            }else if(this.selectedConstrainProductSelection === 'Pressure & Vacuum'){
                if(this.template.querySelector('.constrainProductSelectionPressureVacuumId') !== null && this.template.querySelector('.constrainProductSelectionPressureVacuumId') !== undefined){
                    this.template.querySelector('.constrainProductSelectionPressureVacuumId').checked = true;
                }
            }

            // vacuum Withstand
            if(this.selectedPressureWithstand == 'Positive Pressure' && this.template.querySelector('[class="pressureWithstand'+this.selectedPressureWithstand.split(' ').join('')+'Id"]')){
                this.template.querySelector('[class="pressureWithstand'+this.selectedPressureWithstand.split(' ').join('')+'Id"]').checked = true;
                this.showVpossitivePressureFields = true;               
            }else if(this.selectedPressureWithstand == 'No Requirements' && this.template.querySelector('[class="pressureWithstand'+this.selectedPressureWithstand.split(' ').join('')+'Id"]')){
				this.template.querySelector('[class="pressureWithstand'+this.selectedPressureWithstand.split(' ').join('')+'Id"]').checked = true;
				this.showVpossitivePressureFields =false;				
			}

            if(this.selectedVacuumWithstand == 'Back Pressure' && this.template.querySelector('[class="vacuumWithstand'+this.selectedVacuumWithstand.split(' ').join('')+'Id"]')){
                this.template.querySelector('[class="vacuumWithstand'+this.selectedVacuumWithstand.split(' ').join('')+'Id"]').checked = true;
                this.showRbackPressureInputs = true;
            } else if(this.selectedVacuumWithstand == 'Full Vacuum' && this.template.querySelector('[class="vacuumWithstand'+this.selectedVacuumWithstand.split(' ').join('')+'Id"]')){
				this.template.querySelector('[class="vacuumWithstand'+this.selectedVacuumWithstand.split(' ').join('')+'Id"]').checked = true;
				this.showRbackPressureInputs = false;
			} else if(this.selectedVacuumWithstand == 'No Requirements' && this.template.querySelector('[class="vacuumWithstand'+this.selectedVacuumWithstand.split(' ').join('')+'Id"]')){
			    this.template.querySelector('[class="vacuumWithstand'+this.selectedVacuumWithstand.split(' ').join('')+'Id"]').checked = true;
				this.showRbackPressureInputs = false;
			}

            if(this.ruptureDiscRecordData !== undefined && this.ruptureDiscRecordData !== null && this.ruptureDiscRecordData !== ''){

                
                if(this.ruptureDiscRecordData.fields.PED_2014_68_EU_CE_mark__c !== null && this.ruptureDiscRecordData.fields.PED_2014_68_EU_CE_mark__c !== undefined){
                    if(this.selectedPED_2014_68_EU_CEmark == 'CET' && this.template.querySelector('[class="PED'+this.selectedPED_2014_68_EU_CEmark+'Id"]')){
                        this.template.querySelector('[class="PED'+this.selectedPED_2014_68_EU_CEmark+'Id"]').checked = true;
                    }else if(this.selectedPED_2014_68_EU_CEmark == 'CEC' && this.template.querySelector('[class="PED'+this.selectedPED_2014_68_EU_CEmark+'Id"]')){
                        this.template.querySelector('[class="PED'+this.selectedPED_2014_68_EU_CEmark+'Id"]').checked = true;
                    }else if(this.selectedPED_2014_68_EU_CEmark == 'NonePED' && this.template.querySelector('[class="PED'+this.selectedPED_2014_68_EU_CEmark+'Id"]')){
                        this.template.querySelector('[class="PED'+this.selectedPED_2014_68_EU_CEmark+'Id"]').checked = true;
                    }
                }

                if(this.ruptureDiscRecordData.fields.China_Manufacturing_License__c !== null && this.ruptureDiscRecordData.fields.China_Manufacturing_License__c !== undefined){
	                if(this.selectedChinaManufacturingLicense == 'WSI' && this.template.querySelector('[class="ChinaManufacturingLicense'+this.selectedChinaManufacturingLicense+'Id"]')){
                        this.template.querySelector('[class="ChinaManufacturingLicense'+this.selectedChinaManufacturingLicense+'Id"]').checked = true;
                    } else if(this.selectedChinaManufacturingLicense == 'CUSTSI' && this.template.querySelector('[class="ChinaManufacturingLicense'+this.selectedChinaManufacturingLicense+'Id"]')){
                        this.template.querySelector('[class="ChinaManufacturingLicense'+this.selectedChinaManufacturingLicense+'Id"]').checked = true;
                    } else if(this.selectedChinaManufacturingLicense == 'CDCSI' && this.template.querySelector('[class="ChinaManufacturingLicense'+this.selectedChinaManufacturingLicense+'Id"]')){
                        this.template.querySelector('[class="ChinaManufacturingLicense'+this.selectedChinaManufacturingLicense+'Id"]').checked = true;
                    } else if(this.selectedChinaManufacturingLicense == 'NoneCML' && this.template.querySelector('[class="ChinaManufacturingLicense'+this.selectedChinaManufacturingLicense+'Id"]')){
                        this.template.querySelector('[class="ChinaManufacturingLicense'+this.selectedChinaManufacturingLicense+'Id"]').checked = true;
                    }		
                }

                
                if(this.ruptureDiscRecordData.fields.NACE__c !== undefined && this.ruptureDiscRecordData.fields.NACE__c !== null){
                    if(this.selectedNACE == 'MR0103' && this.template.querySelector('[class="NACE'+this.selectedNACE+'Id"]')){
                        this.template.querySelector('[class="NACE'+this.selectedNACE+'Id"]').checked = true;
                    } else if(this.selectedNACE == 'MR0175' && this.template.querySelector('[class="NACE'+this.selectedNACE+'Id"]')){
                        this.template.querySelector('[class="NACE'+this.selectedNACE+'Id"]').checked = true;
                    } else if(this.selectedNACE == 'N' && this.template.querySelector('[class="NACE'+this.selectedNACE+'Id"]')){
                        this.template.querySelector('[class="NACE'+this.selectedNACE+'Id"]').checked = true;
                    }
                }
                
                if(this.atexCertificate == true){
                    this.template.querySelector(".atexCertificateInputCls").checked = true;
                } else {
                    this.template.querySelector(".atexCertificateInputCls").checked = false;
                }
				
                if(this.CSAMarkingCRNNumber == true){
                    this.template.querySelector(".CSAMarkingCRNNumberInputCls").checked = true;
                    this.template.querySelector(".ASMESectionVIIIDivision1InputCls").checked = true;
                } else {
                    this.template.querySelector(".CSAMarkingCRNNumberInputCls").checked = false;
                    this.template.querySelector(".ASMESectionVIIIDivision1InputCls").checked = false;
                }

                if(this.ASMESectionVIIIDivision1 == true){
                    this.template.querySelector(".ASMESectionVIIIDivision1InputCls").checked = true;
                } else {
                    this.template.querySelector(".ASMESectionVIIIDivision1InputCls").checked = false;
                }
                
                if(this.KOSHACompliance == true){
                	this.ComplywithAD2000MerkblatA1 = false;
                    this.ComplywithRegelsVoorTosellanOderDr = false;
                    this.disableCheckbox = true;
                } else {
                    this.disableCheckbox = false;
                }
                
                if(this.ComplywithAD2000MerkblatA1 == true){
                    this.disableKOSHACB = true
                }

                if(this.ComplywithRegelsVoorTosellanOderDr == true){
                    this.disableKOSHACB = true
                } 

                if(this.ComplywithAD2000MerkblatA1 == false && this.ComplywithRegelsVoorTosellanOderDr == false) {
                    this.disableKOSHACB = false;
                }
                
                if(this.ruptureDiscRecordData.fields.Operating_Pressure_Ratio__c !== undefined && this.ruptureDiscRecordData.fields.Operating_Pressure_Ratio__c !== null){
                    if(this.selectedOperatingPressureRatio != '' && this.selectedOperatingPressureRatio != null && this.selectedOperatingPressureRatio != undefined){
                        if(this.template.querySelector('[class="OPR'+this.selectedOperatingPressureRatio.split('.').join('')+'Id"]')){
                            this.template.querySelector('[class="OPR'+this.selectedOperatingPressureRatio.split('.').join('')+'Id"]').checked = true;
                        }
                    }                    
                }

                if(this.ruptureDiscRecordData.fields.Application_type__c !== undefined && this.ruptureDiscRecordData.fields.Application_type__c !== null){
                    if(this.selectedApplicationType != '' && this.template.querySelector('[class="applicationType'+this.selectedApplicationType+'Id"]')){
                        this.template.querySelector('[class="applicationType'+this.selectedApplicationType+'Id"]').checked = true;
                    }
                }
            }            
        }        
    }

    get constraintsProdSelctions() {
        return [
            { label: 'Yes', value: 'Yes' },
            { label: 'No', value: 'No' }
        ];
    }
    
    onScrollMain(event) {        
        let number = event.target.scrollTop;
        
        var firstSection = this.template.querySelector(".section-1").offsetHeight;        
        var secondSection = this.template.querySelector(".section-2").offsetHeight;     
        var thirdSection = this.template.querySelector(".section-3").offsetHeight;
 
        let activeElements = this.template.querySelectorAll(".active");    
        if(activeElements){
            activeElements.forEach((element)=>{element.classList.remove("active")});
        }
        if(number < firstSection){
            this.template.querySelector(".RELIEFTYPECls").classList.add("active");
        }else if(number < firstSection + secondSection && this.selectedConstrainProductSelectionByFlow == "Yes"){
            this.template.querySelector(".SIZINGFLOWAREACls").classList.add("active");           
        }else if(number < firstSection + secondSection + thirdSection){          
            this.template.querySelector(".CERTIFICATIONSCls").classList.add("active"); 
        }else{
            this.template.querySelector(".PRODUCTNARROWINGcls").classList.add("active");
        }
     }
 
    focusProductNarrowing(event){
        var sectionName = event.target.dataset.id;
        this.template.querySelector("div[data-id='"+sectionName+"']").scrollIntoView({behavior: "smooth"});
    }

    restrictNonNumericalValues(event){
        let charCode = (event.which) ? event.which : event.keyCode;
        if(charCode != 46 && charCode != 37 && charCode != 39 && charCode != 110 && charCode != 190 && ((charCode > 31 && charCode <48)||(charCode>57 && charCode<93) ||charCode >105 ))
        event.preventDefault();
    }

    restrictNonNumericalValuesWithoutNegative(event){
        let charCode = (event.which) ? event.which : event.keyCode;
        console.log('charCode: --',charCode);
        if(charCode != 109 && charCode != 45 && charCode != 46 && charCode != 37 && charCode != 39 && charCode != 110 && charCode != 189 && charCode != 190 && ((charCode > 31 && charCode <48)||(charCode>57 && charCode<93) ||charCode >105 ))
            event.preventDefault();
    }

    RemoveDecimal(event){
        let targetName = event.target.name;
        if(targetName === 'pressureSetting')
            this.pressureSetting = event.target.value;
        else if(targetName === 'temperatureSetting')
            this.temperatureSetting = event.target.value;
        else if(targetName === 'vacuumSetting')
            this.vacuumSetting = event.target.value;
        else if(targetName === 'backPressure')
            this.backPressure = event.target.value;
        else if(targetName === 'positivePressure')
            this.positivePressure = event.target.value;
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

    navigateToProductRecommendation(){

        let isPortalUser = this.currentUserInfo.fields.IsPortalEnabled.value;
        
		if(isPortalUser){
            window.open('/s/productrecommendationscmp?configId='+this.recordId, "_parent");  
		}else{
            window.open('/lightning/cmp/c__productRecommendationsCmp?c__configId='+ this.recordId, "_parent");
        } 
        /*
        this[NavigationMixin.Navigate]({
            "type": "standard__component",
            "attributes": {
                "componentName": "c__productRecommendationsCmp"    
            },
            "state": {
                "c__configId": this.recordId,
            }
        });*/
    }

    loadDiscMaterialValue(){
        connectedCallBackMethod({ruptId : this.recordId})
        .then(results=>{
            this.discMaterialOfConstructionOptions = results.selOptions;
            this.navToProd = results.navToProdCheck;
            console.log('connectedCallback --- this.navToProd :-- ',this.navToProd);
        })
        .catch(error=>{});
    }

    connectedCallback(){
        this.loadDiscMaterialValue();
    }

     //added by piyush 

     handleChildCmpFieldUpdate(event){
        console.log('somthing got changed in section 2 before ' + this.section2Saved);
        this.section2Saved = false; // added by piyush
        console.log('somthing got changed in section 2 after ' + this.section2Saved);
    }

    handleSaveSizingArea(event){
     

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

        
        if(this.CSAMarkingCRNNumber && this.template.querySelector(".CSAMarkingCRNNumberInputCls") ){
            this.template.querySelector(".CSAMarkingCRNNumberInputCls").checked = false;
        }

        if(this.ASMESectionVIIIDivision1 && this.template.querySelector(".ASMESectionVIIIDivision1InputCls") ){
            this.template.querySelector(".ASMESectionVIIIDivision1InputCls").checked = false;
        }
        
        this.CSAMarkingCRNNumber        =   event.detail.CSA_Marking_CRN_Number;
        this.ASMESectionVIIIDivision1   =   event.detail.ASME_Section_VIII_Division_1;
        this.KOSHACompliance = event.detail.KOSHA_Compliance;
        this.cutrCertificate = event.detail.CU_tR;      
        this.aSanitaryStandards = event.detail.X3A_Sanitary_Standards; 
        this.ComplywithAD2000MerkblatA1 = event.detail.Comply_with_AD2000_Merkblat_A1; 
        this.ComplywithRegelsVoorTosellanOderDr = event.detail.Comply_with_Regels_Voor_Tosellan_Oder_Dr;
        this.atexCertificate = event.detail.Atex_Certificate;  
        //this.gasGroup = event.detail.Gas_Group;  
        //this.zone02 = event.detail.Zone_0_2;  
        this.disableCheckbox = false;
        this.disableKOSHACB = false;

        

        if(this.selectedPED_2014_68_EU_CEmark && this.template.querySelector('[class="PED'+this.selectedPED_2014_68_EU_CEmark+'Id"]')){
            this.template.querySelector('[class="PED'+this.selectedPED_2014_68_EU_CEmark+'Id"]').checked = false;
        }

        if(this.selectedChinaManufacturingLicense && this.template.querySelector('[class="ChinaManufacturingLicense'+this.selectedChinaManufacturingLicense+'Id"]')){
            this.template.querySelector('[class="ChinaManufacturingLicense'+this.selectedChinaManufacturingLicense+'Id"]').checked = false;
        }
        
        if(this.selectedNACE && this.template.querySelector('[class="NACE'+this.selectedNACE+'Id"]')){
            this.template.querySelector('[class="NACE'+this.selectedNACE+'Id"]').checked = false;
        }  

        this.selectedNACE = event.detail.NACE;
        this.selectedChinaManufacturingLicense = event.detail.China_Manufacturing_License;
        this.selectedPED_2014_68_EU_CEmark = event.detail.PED_2014_68_EU_CE_mark;
        
        
        if(this.selectedOperatingPressureRatio && this.template.querySelector('[class="OPR'+this.selectedOperatingPressureRatio.split('.').join('')+'Id"]')){
            this.template.querySelector('[class="OPR'+this.selectedOperatingPressureRatio.split('.').join('')+'Id"]').checked = false;
        }

        if(this.selectedApplicationType && this.template.querySelector('[class="applicationType'+this.selectedApplicationType+'Id"]')){
            this.template.querySelector('[class="applicationType'+this.selectedApplicationType+'Id"]').checked = false;
        }
        this.selectedOperatingPressureRatio = event.detail.Operating_Pressure_Ratio;
        this.selectedApplicationType = event.detail.Application_type;
        this.nonFragmnetingDesignRequired = event.detail.Non_Fragmenting_Design_Required;
        this.discMaterialOfConstruction = event.detail.Disc_Material_of_Construction;
        this.evalPer = event.detail.Evaluation_Per;
        
        if(this.evalPer == 'ASME Water' || this.evalPer == 'ASME Gas/Vapor' || this.evalPer == 'ASME Steam'){
            this.disableASME = true;
        } else {
            this.disableASME = false;
        }

        
        this.bShowEditBtn = false; //added by piyush
        this.section2Saved = true; // added by piyush
        this.bHideReturnToQuote = true; //@piyush
        
        //event.detail.ASME_BPE;
    }


    handleSizingFlowAreaSuccess(){
        this.bShowEditBtn = false; //added by piyush
        this.section2Saved = true; // added by piyush
        this.bHideReturnToQuote = true; //@piyush
    }
}