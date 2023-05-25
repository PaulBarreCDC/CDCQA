/**
 * @File Name          : lwcFlameProduct.js
 * @Description        :
 * @Author             : ApexIT
 * @Group              :
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0        -              ApexIT                 Initial Version
 * 1.1      17-Mar-2021      Rohini Hathi           Support Ticket# 200107, for ATEX attribute
 **/
import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getRecord } from 'lightning/uiRecordApi';

import Flame_Product_OBJECT from '@salesforce/schema/Flame_Product__c';

import Quote_Line from '@salesforce/schema/Flame_Product__c.Quote_Line__c';
import Brand from '@salesforce/schema/Flame_Product__c.Brand__c';
//SecA
import FlowRateUnits_FIELD from '@salesforce/schema/Flame_Product__c.Flow_Rate_Units__c';
import TemperatureUnits_FIELD from '@salesforce/schema/Flame_Product__c.Temperature_Units__c';
import PressureUnits_FIELD from '@salesforce/schema/Flame_Product__c.Pressure_Units__c';

import Mounting from '@salesforce/schema/Flame_Product__c.Mounting__c';
import Pipe_Design from '@salesforce/schema/Flame_Product__c.Pipe_Design__c';
import Gas_Group from '@salesforce/schema/Flame_Product__c.GasGroupDynamic__c';
import GasGroupCode_FIELD from '@salesforce/schema/Flame_Product__c.Gas_Group_Code__c';
import Constrain_Product_Selection_by_Flow from '@salesforce/schema/Flame_Product__c.Constrain_Product_Selection_by_Flow__c';

//SecB
import Max_Allowable_Pressure_Drop from '@salesforce/schema/Flame_Product__c.Max_Allowable_Pressure_Drop__c';
import Max_Allowable_Pressure_Drop_Units from '@salesforce/schema/Flame_Product__c.Max_Allowable_Pressure_Drop_Units__c';
import Converted_Max_Allowable_Pressure_Drop from '@salesforce/schema/Flame_Product__c.Converted_Max_Allowable_Pressure_Drop__c';

import Required_Flow_Rate from '@salesforce/schema/Flame_Product__c.Required_Flow_Rate__c';
import Required_Flow_Rate_Units from '@salesforce/schema/Flame_Product__c.Required_Flow_Rate_Units__c';
import Converted_Required_Flow_Rate from '@salesforce/schema/Flame_Product__c.Converted_Required_Flow_Rate__c';

import Flowing_Media from '@salesforce/schema/Flame_Product__c.Flowing_Media__c';
import Media_Name from '@salesforce/schema/Flame_Product__c.Media_Name__c';
import Molecular_Weight from '@salesforce/schema/Flame_Product__c.Molecular_Weight__c';
import Compressibility_Factor from '@salesforce/schema/Flame_Product__c.Compressibility_Factor__c';
import Ratio_of_Specific_Heats from '@salesforce/schema/Flame_Product__c.Ratio_of_Specific_Heats__c';

import Atmospheric_Pressure from '@salesforce/schema/Flame_Product__c.Atmospheric_Pressure__c';
import Atmospheric_Pressure_Units from '@salesforce/schema/Flame_Product__c.Atmospheric_Pressure_Units__c';
import Converted_Atmospheric_Pressure from '@salesforce/schema/Flame_Product__c.Converted_Atmospheric_Pressure__c';

import Temperature_of_flowing_Vapor from '@salesforce/schema/Flame_Product__c.Temperature_of_flowing_Vapor__c';
import Temperature_of_flowing_Vapor_Units from '@salesforce/schema/Flame_Product__c.Temperature_of_flowing_Vapor_Units__c';
import Converted_Temprature_of_flowing_Vapor from '@salesforce/schema/Flame_Product__c.Converted_Temprature_of_flowing_Vapor__c';

import Pressure_of_flowing_Vapor from '@salesforce/schema/Flame_Product__c.Pressure_of_flowing_Vapor__c';
import Pressure_of_flowing_Vapor_Units from '@salesforce/schema/Flame_Product__c.Pressure_of_flowing_Vapor_Units__c';
import Converted_Pressure_of_flowing_Vapor from '@salesforce/schema/Flame_Product__c.Converted_Pressure_of_flowing_Vapor__c';
import Location_of_Flowing_Pressure_Specificati from '@salesforce/schema/Flame_Product__c.Location_of_Flowing_Pressure_Specificati__c';
import PresRatio_FIELD from '@salesforce/schema/Flame_Product__c.PresRatio__c';
import MinReqdFlowRateSCFH_FIELD from '@salesforce/schema/Flame_Product__c.MinReqdFlowRateSCFH__c';
import CriticalPresRatio_FIELD from '@salesforce/schema/Flame_Product__c.CriticalPresRatio__c';
import InletFlowPresPSIA__FIELD from '@salesforce/schema/Flame_Product__c.InletFlowPresPSIA__c';

//SecC
import Certfication_Requirement from '@salesforce/schema/Flame_Product__c.Certfication_Requirement__c';
import ATEXCertificate_FIELD from '@salesforce/schema/Flame_Product__c.Atex_Certificate_2014_34_EU__c';
import CUTR_FIELD from '@salesforce/schema/Flame_Product__c.CU_TR__c';
import USCG_FIELD from '@salesforce/schema/Flame_Product__c.US_Coast_guard__c';
import NACE_FIELD from '@salesforce/schema/Flame_Product__c.Nace_Backend__c';
import NACECertificate_FIELD from '@salesforce/schema/Flame_Product__c.NACE__c';
import CertificationSaveCheckFlag_FIELD from '@salesforce/schema/Flame_Product__c.Certification_Save_Check_Flag__c';

//SecD
import Operational_Pressure from '@salesforce/schema/Flame_Product__c.Operational_Pressure__c';
import Operational_Pressure_Units from '@salesforce/schema/Flame_Product__c.Operational_Pressure_Units__c';
import Converted_Operational_Pressure from '@salesforce/schema/Flame_Product__c.Converted_Operational_Pressure__c';

import Operational_Temperature from '@salesforce/schema/Flame_Product__c.Operational_Temperature__c';

import Arrester_for_Detonation_or_Deflagration from '@salesforce/schema/Flame_Product__c.Arrester_for_Detonation_or_Deflagration__c';
import Offset_or_Concentric_Bases from '@salesforce/schema/Flame_Product__c.Offset_or_Concentric_Bases__c';

import Run_Up_Length_A_Input from '@salesforce/schema/Flame_Product__c.Run_Up_Length_A_Input__c';
import Run_Up_Length_A_Input_Units from '@salesforce/schema/Flame_Product__c.Run_Up_Length_A_Input_Units__c';
import Converted_Run_up_Length_A from '@salesforce/schema/Flame_Product__c.Converted_Run_up_Length_A__c';

import Run_Up_Length_B_Input from '@salesforce/schema/Flame_Product__c.Run_Up_Length_B_Input__c';
import Run_Up_Length_B_Input_Units from '@salesforce/schema/Flame_Product__c.Run_Up_Length_B_Input_Units__c';
import Converted_Run_up_Length_B from '@salesforce/schema/Flame_Product__c.Converted_Run_up_Length_B__c';


//SecE
import Connection_Size from '@salesforce/schema/Flame_Product__c.Connection_Size__c';
import Element_Size from '@salesforce/schema/Flame_Product__c.Element_Size__c';
import Model__FIELD from '@salesforce/schema/Flame_Product__c.Model__c';
import SZC_FILED from '@salesforce/schema/Flame_Product__c.SZC__c';
import ESZC_FIELD from '@salesforce/schema/Flame_Product__c.ESZC__c';
import Size_FIELD from '@salesforce/schema/Flame_Product__c.Size__c';

//Apex Call Methods
import saveApplicationParameters from '@salesforce/apex/FlameProductController.saveApplicationParameters';
import saveCertifications from '@salesforce/apex/FlameProductController.saveCertifications';
import saveProductNarrowing from '@salesforce/apex/FlameProductController.saveProductNarrowing';
import saveProductSelection from '@salesforce/apex/FlameProductController.saveProductSelection';
import connectedCallBackMethod from '@salesforce/apex/FlameProductController.connectedCallBackMethod';
import fetchFormAccessibility from '@salesforce/apex/FlameProductController.fetchFormAccessibility'; // @added by piyush
import fetchUserInfo from '@salesforce/apex/FlameProductController.fetchUserInfo'; // @added by piyush
import FA_Images from '@salesforce/resourceUrl/Flame_Arrestor_Images';
import GasGroupPickValues from '@salesforce/apex/FlameProductController.GasGroupPickValues'; //@added on 8-dec


import Price_Engineer_Override from '@salesforce/schema/Flame_Product__c.Price_Engineer_Override__c';
import Lead_Time_Override from '@salesforce/schema/Flame_Product__c.Lead_Time_Override__c';
import Build_Cost_Override from '@salesforce/schema/Flame_Product__c.Build_Cost_Override__c';
import Quote_Description_Engineer_Override from '@salesforce/schema/Flame_Product__c.Quote_Description_Engineer_Override__c';


import Id from '@salesforce/user/Id';
const FIELDS = [
    'User.Name',
    'User.IsPortalEnabled'
];

const QUOTELINE_FIELDS = [
    'SBQQ__QuoteLine__c.SBQQ__Quote__c'
];

const rvFields = [Price_Engineer_Override,Lead_Time_Override,Build_Cost_Override,Quote_Description_Engineer_Override,Quote_Line, Brand,
    Mounting,Pipe_Design,Gas_Group,Constrain_Product_Selection_by_Flow,CertificationSaveCheckFlag_FIELD,
    Max_Allowable_Pressure_Drop,Max_Allowable_Pressure_Drop_Units,Converted_Max_Allowable_Pressure_Drop,Required_Flow_Rate,Required_Flow_Rate_Units,Converted_Required_Flow_Rate,
    Flowing_Media,Media_Name,Molecular_Weight,Compressibility_Factor,Ratio_of_Specific_Heats,Atmospheric_Pressure,Atmospheric_Pressure_Units,Converted_Atmospheric_Pressure,
    Temperature_of_flowing_Vapor,Temperature_of_flowing_Vapor_Units,Converted_Temprature_of_flowing_Vapor,Pressure_of_flowing_Vapor,Pressure_of_flowing_Vapor_Units,
    Converted_Pressure_of_flowing_Vapor,Location_of_Flowing_Pressure_Specificati,ESZC_FIELD,SZC_FILED,Size_FIELD,FlowRateUnits_FIELD,TemperatureUnits_FIELD,PressureUnits_FIELD,
    Certfication_Requirement, ATEXCertificate_FIELD, CUTR_FIELD, USCG_FIELD, NACE_FIELD,GasGroupCode_FIELD,NACECertificate_FIELD,
    Operational_Pressure,Operational_Pressure_Units,Converted_Operational_Pressure,Operational_Temperature,Arrester_for_Detonation_or_Deflagration,Offset_or_Concentric_Bases,
    Run_Up_Length_A_Input,Run_Up_Length_A_Input_Units,Converted_Run_up_Length_A,Run_Up_Length_B_Input,Run_Up_Length_B_Input_Units,Converted_Run_up_Length_B,
    Connection_Size,Element_Size,Model__FIELD,PresRatio_FIELD,MinReqdFlowRateSCFH_FIELD,CriticalPresRatio_FIELD,InletFlowPresPSIA__FIELD
    ];

export default class lwcFlameProduct extends NavigationMixin(LightningElement) {
    // Expose URL of assets included inside an archive file
    faConOff = FA_Images + '/FA-Concentric-Offset.PNG';

    userId = Id;
    currentUserInfo = {};
    QuoteLineInfo = {};
    @track quoteLineId;
    @api recordId;
    @api quoteId;

    @track flowRateUnitsApi;
    @track temperatureUnitsApi;
    @track pressureUnitsApi;

    @track mounting;
    @track mountingOptions;
    @track pipeDesign;
    @track pipeDesignOptions;
    @track gasGroup;
    @track gasGroupOptions;
    @track gasGroupCode;
    @track selectedConstraintProductSelectionByFlow;

    @track convertedMaxAllowablePressureDrop;
    @track convertedAtmosphericPressure;
    @track convertedRequiredFlowRate;
    @track convertedTempratureofFlowingVapor;
    @track convertedPressureofFlowingVapor;
    @track locationOfFlowingPressureSpecific;

    @track certificationRequirement;
    @track certificationRequirementOptions;
    @track naceCertificate;

    @track operationalPressure = 14.7;
    @track operationalPressureUnits = "psia";

    @track operationalTemperature;

    @track arrestorDetonationDeflagration = "Both";
    @track isDetonation;
    @track detonationDeflagrationOptions;

    @track offsetConcentricBases;
    @track offsetConcentricOptions;

    @track runUpLengthA;
    @track runUpLengthAUnits = "in";

    @track runUpLengthB;
    @track runUpLengthBUnits = "in";

    //Section - C
    @track ATEX;
    @track CUTR;
    @track USCG;
    @track NACE;

    //Section - Product Selection
    @api selConnSize;
    @api connSizeOptions;
    @api selEleSize;
    @api eleSizeOptions;
    @api selModConnSize;
    @api modConnSizeOptions;
    @api substringModelArray;

    @api eleFilterArray;
    @api sizeFilterArray;
    @api filterModSZC;

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

    @api lstOfModOptions;
    @track navToVF;

    @track molWeight;
    @track compFactor;
    @track ratioOfSpecHeats;
    @track presRatio;
    @track minReqFlowRateSCFH;
    @track criticalPresRatio;
    @track inletFlowPresPSIA;

    @track certificationSaveCheckFlag;


    //added by piyush
    section1Saved = true; // application params
    section2Saved = true; // sizing flow option,child component section
    section3Saved = true; // certificate section
    section4Saved = true; // Product Narrowing
    bDisabled = false;
    bHideReturnToQuote = false; // added by piyush to control back button visibility

    bShowEditBtn = false;
    sDisabled = '';
    bDisabled = false;
    sEditBtnLabel = 'Edit';
    bShowProductReviewLink = false;
    bMetaDataLoaded = false;

    @track FPRecordData;
    // @track conTempOfFlowingVapor;
    // @track conRequiredFlowRate;
    // @track conAtmosphericPressure;
    // @track conMaxAllowablePressureDrop;


    get endOfLineMountingCheck(){
        return this.mounting != 'End-of-Line';
    }

    get inlinePipeWithBendMountingCheck(){
        return this.mounting == 'In-Line Pipe with Bend';
    }
  //added by piyush
    enableEditMode(){
        this.sEditBtnLabel = this.sEditBtnLabel == 'Edit' ? 'Cancel' : 'Edit';
        if(this.sEditBtnLabel == 'Cancel'){
            this.bShowProductReviewLink = false;

              this.thisoPopupPDF = window.open('/apex/ConfigFlameProductReference?Id=' + this.recordId , "", "width=500,height=500");
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
        let sUrl = '/apex/ConfigFLAME?qid='+ this.quoteLineId;

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

    //@added on 8-dec
    @wire(GasGroupPickValues, {})
    getGasGroupPickValues({ data, error }){
        if(data){
            console.log('Data --> ',data);
            this.gasGroupOptions = data;
            this.error = undefined;
        }
        if(error){
            console.log('Error --> ',error);
            this.error = error;
            this.gasGroupOptions = undefined;
        }
    }


    @wire(getRecord, { recordId: '$userId', fields: FIELDS })
    oUser({ error, data }) {
        if (data) {
			console.log('===> USER' + JSON.stringify(data) + 'recordId----> ' + this.recordId);
			this.currentUserInfo = data;
        } else if (error) {
            console.log('===> error' + JSON.stringify(error));
        }
    }

    @wire(getObjectInfo, { objectApiName: Flame_Product_OBJECT })
        objectInfo;

    @wire(getRecord, { recordId: '$recordId', fields: rvFields})
    fpRecord({ error, data }) {

        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while loading Flame Product',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data) {

            if(data !== undefined){
                // this.FPRecordData = {...data}; //Service Ticket 200107 , commented off as it is incorrect syntax
                this.quoteLineId = data.fields.Quote_Line__c.value;
                this.mounting = data.fields.Mounting__c.value;
                this.pipeDesign = data.fields.Pipe_Design__c.value;
                this.gasGroup = data.fields.GasGroupDynamic__c.value;
                this.selectedConstraintProductSelectionByFlow = data.fields.Constrain_Product_Selection_by_Flow__c.value;
                this.certificationRequirement = data.fields.Certfication_Requirement__c.value;
                if(data.fields.Operational_Pressure__c.value != null){
                    this.operationalPressure = data.fields.Operational_Pressure__c.value;
                }
                this.operationalTemperature = data.fields.Operational_Temperature__c.value;
                if(data.fields.Arrester_for_Detonation_or_Deflagration__c.value != null){
                    this.arrestorDetonationDeflagration = data.fields.Arrester_for_Detonation_or_Deflagration__c.value;
                }
                if(data.fields.Offset_or_Concentric_Bases__c.value != null){
                    this.offsetConcentricBases = data.fields.Offset_or_Concentric_Bases__c.value;
                }
                // if(data.fields.Run_Up_Length_A_Input__c.value == 0){
                //     this.runUpLengthA = null;
                // } else if(data.fields.Run_Up_Length_A_Input__c.value != null) {
                //     this.runUpLengthA = data.fields.Run_Up_Length_A_Input__c.value;
                // }

                // if(data.fields.Run_Up_Length_B_Input__c.value == 0){
                //     this.runUpLengthB = null;
                // } else if(data.fields.Run_Up_Length_B_Input__c.value != null){
                //     this.runUpLengthB = data.fields.Run_Up_Length_B_Input__c.value;
                // }
                this.runUpLengthA = data.fields.Run_Up_Length_A_Input__c.value;
                this.runUpLengthB = data.fields.Run_Up_Length_B_Input__c.value;

                if(data.fields.Run_Up_Length_A_Input_Units__c.value != null){
                    this.runUpLengthAUnits = data.fields.Run_Up_Length_A_Input_Units__c.value;
                }

                if(data.fields.Run_Up_Length_B_Input_Units__c.value != null){
                    this.runUpLengthBUnits = data.fields.Run_Up_Length_B_Input_Units__c.value;
                }

                this.selModConnSize = data.fields.Model__c.value;
                this.NACE = data.fields.Nace_Backend__c.value;
                this.USCG = data.fields.US_Coast_guard__c.value;
                this.CUTR = data.fields.CU_TR__c.value;
                this.ATEX = data.fields.Atex_Certificate_2014_34_EU__c.value;
                this.gasGroupCode = data.fields.Gas_Group_Code__c.value;
                this.naceCertificate = data.fields.NACE__c.value;
                this.selConnSize = data.fields.SZC__c.value;
                this.selEleSize = data.fields.ESZC__c.value;
                this.selConnSize = data.fields.Size__c.value;

                this.flowRateUnitsApi = data.fields.Flow_Rate_Units__c.value;
                this.temperatureUnitsApi = data.fields.Temperature_Units__c.value;
                this.pressureUnitsApi = data.fields.Pressure_Units__c.value;

                this.molWeight = data.fields.Molecular_Weight__c.value;
                this.compFactor = data.fields.Compressibility_Factor__c.value;
                this.ratioOfSpecHeats = data.fields.Ratio_of_Specific_Heats__c.value;
                this.presRatio = data.fields.PresRatio__c.value;
                this.minReqFlowRateSCFH = data.fields.MinReqdFlowRateSCFH__c.value;
                this.criticalPresRatio = data.fields.CriticalPresRatio__c.value;
                this.convertedMaxAllowablePressureDrop = data.fields.Converted_Max_Allowable_Pressure_Drop__c.value;
                this.convertedAtmosphericPressure = data.fields.Converted_Atmospheric_Pressure__c.value;
                this.convertedRequiredFlowRate = data.fields.Converted_Required_Flow_Rate__c.value;
                this.convertedTempratureofFlowingVapor = data.fields.Converted_Temprature_of_flowing_Vapor__c.value;
                this.convertedPressureofFlowingVapor = data.fields.Converted_Pressure_of_flowing_Vapor__c.value;
                this.inletFlowPresPSIA = data.fields.InletFlowPresPSIA__c.value;
                this.certificationSaveCheckFlag = data.fields.Certification_Save_Check_Flag__c.value;

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



                fetchUserInfo()
                .then(sResult => {
                    console.log('this.FPRecordData.fields.Price_Engineer_Override__c.value ---> ' + this.FPRecordData.fields.Price_Engineer_Override__c.value);
                    console.log('this.FPRecordData.fields.Lead_Time_Override__c.value ---> ' + this.FPRecordData.fields.Lead_Time_Override__c.value);
                    console.log('this.FPRecordData.fields.Build_Cost_Override__c.value ---> ' + this.FPRecordData.fields.Build_Cost_Override__c.value);
                    console.log('this.FPRecordData.fields.Quote_Description_Engineer_Override__c.value ---> ' + this.FPRecordData.fields.Quote_Description_Engineer_Override__c.value);
                    let profileName = sResult.Profile.Name;
                    // added by piyush soni 10/14/2020
                    if (profileName != 'CDC Engineering' && profileName != 'System Administrator') {
                        if (this.FPRecordData.fields.Price_Engineer_Override__c.value == true ||
                            this.FPRecordData.fields.Lead_Time_Override__c.value == true ||
                            this.FPRecordData.fields.Build_Cost_Override__c.value == true ||
                            this.FPRecordData.fields.Quote_Description_Engineer_Override__c.value == true
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

            }
        }
    }

    connectedCallback() {
        console.log('connectedCallback');
        connectedCallBackMethod({flmprodId : this.recordId})
        .then(results=>{
            this.modConnSizeOptions = results;
        })
        .catch(error=>{});
    }

    get showSizingFlowArea(){
        return this.selectedConstraintProductSelectionByFlow;
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : Mounting
    })
    wiredPickListValueMounting({ data, error }){
        if(data){
            this.mountingOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:element.value+'Id'};
                this.mountingOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            console.log(` Error while fetching Picklist values  ${error}`);
            this.error = error;
            this.mountingOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : Pipe_Design
    })
    wiredPickListValuePipe_Design({ data, error }){
        if(data){
            this.pipeDesignOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:element.value+'Id'};
                this.pipeDesignOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            console.log(` Error while fetching Picklist values  ${error}`);
            this.error = error;
            this.pipeDesignOptions = undefined;
        }
    }

    // @wire(getPicklistValues, {
    //     recordTypeId : '$objectInfo.data.defaultRecordTypeId',
    //     fieldApiName : Gas_Group
    // })
    // wiredPickListValueGas_Group({ data, error }){
    //     if(data){
    //         this.gasGroupOptions = [];
    //         data.values.forEach(element =>{
    //             let newElement = {label:element.label,value:element.value,generatedId:element.value+'Id'};
    //             this.gasGroupOptions.push(newElement);
    //         });
    //         this.error = undefined;
    //     }
    //     if(error){
    //         console.log(` Error while fetching Picklist values  ${error}`);
    //         this.error = error;
    //         this.gasGroupOptions = undefined;
    //     }
    // }


    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : Certfication_Requirement
    })
    wiredPickListValueCertfication_Requirement({ data, error }){
        if(data){
            this.certificationRequirementOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:element.value+'Id'};
                this.certificationRequirementOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            console.log(` Error while fetching Picklist values  ${error}`);
            this.error = error;
            this.certificationRequirementOptions = undefined;
        }
    }

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : Arrester_for_Detonation_or_Deflagration
    })
    wiredPickListValueArrester_for_Detonation_or_Deflagration({ data, error }){
        if(data){
            this.detonationDeflagrationOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:element.value+'Id'};
                this.detonationDeflagrationOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            console.log(` Error while fetching Picklist values  ${error}`);
            this.error = error;
            this.detonationDeflagrationOptions = undefined;
        }
    }


    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : Offset_or_Concentric_Bases
    })
    wiredPickListValueOffset_or_Concentric_Bases({ data, error }){
        if(data){
            this.offsetConcentricOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:element.value+'Id'};
                this.offsetConcentricOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            console.log(` Error while fetching Picklist values  ${error}`);
            this.error = error;
            this.offsetConcentricOptions = undefined;
        }
    }

    renderedCallback() {
        if(this.recordId !== undefined && this.recordId !== null && this.recordId !== ''){
            if(this.template.querySelector('[class="'+this.mounting+'Id"]') !== null && this.template.querySelector('[class="'+this.mounting+'Id"]') !== undefined ){
                this.template.querySelector('[class="'+this.mounting+'Id"]').checked = true;
            }
            if(this.selectedConstraintProductSelectionByFlow){
                this.template.querySelector('.constrainProductSelectByFlow').checked = true;
            }
            if(this.template.querySelector('[class="'+this.pipeDesign+'Id"]') !== null && this.template.querySelector('[class="'+this.pipeDesign+'Id"]') !== undefined ){
                this.template.querySelector('[class="'+this.pipeDesign+'Id"]').checked = true;
            }
            if(this.template.querySelector('[class="'+this.certificationRequirement+'Id"]') !== null && this.template.querySelector('[class="'+this.certificationRequirement+'Id"]') !== undefined ){
                this.template.querySelector('[class="'+this.certificationRequirement+'Id"]').checked = true;
            }
            if(this.template.querySelector('[class="'+this.arrestorDetonationDeflagration+'Id"]') !== null && this.template.querySelector('[class="'+this.arrestorDetonationDeflagration+'Id"]') !== undefined ){
                this.template.querySelector('[class="'+this.arrestorDetonationDeflagration+'Id"]').checked = true;
            }
            if(this.template.querySelector('[class="'+this.offsetConcentricBases+'Id"]') !== null && this.template.querySelector('[class="'+this.offsetConcentricBases+'Id"]') !== undefined ){
                this.template.querySelector('[class="'+this.offsetConcentricBases+'Id"]').checked = true;
            }

            if(this.arrestorDetonationDeflagration != 'Detonation'){
                this.isDetonation = true;
            } else if(this.arrestorDetonationDeflagration == 'Detonation'){
                this.isDetonation = false;
            }
        }
    }

    navigateToProductView() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.quoteId,
                objectApiName: 'SBQQ__Quote__c',
                actionName: 'view'
            }
        });
    }

    focusSection(event){
        var sectionName = event.target.dataset.id;
        //console.log('on click data ID ',event.target.dataset.id);
        this.template.querySelector("div[data-id='"+sectionName+"']").scrollIntoView({behavior: "smooth"});
    }

    handleFlowRateUnits(event){
        this.section1Saved = false; // @developer
        this.flowRateUnitsApi = event.detail.value;
        console.log('this.flowRateUnitsApi : -- ',this.flowRateUnitsApi);
        if(this.flowRateUnitsApi && this.template.querySelector("c-lwc-flame-product-size-flow")){
            this.template.querySelector("c-lwc-flame-product-size-flow").defaultFlowRateUnits(this.flowRateUnitsApi);
        }
    }

    handleTemperatureUnits(event){
        this.section1Saved = false; // @developer
        this.temperatureUnitsApi = event.detail.value;
        console.log('this.temperatureUnitsApi : -- ',this.temperatureUnitsApi);
        if(this.temperatureUnitsApi && this.template.querySelector("c-lwc-flame-product-size-flow")){
                this.template.querySelector("c-lwc-flame-product-size-flow").defaultTemperatureUnits(this.temperatureUnitsApi);
        }
    }

    handlePressureUnits(event){
        this.section1Saved = false; // @developer
        this.pressureUnitsApi = event.detail.value;
        console.log('this.pressureUnitsApi : -- ',this.pressureUnitsApi);
        if(this.pressureUnitsApi && this.template.querySelector("c-lwc-flame-product-size-flow")){
            this.template.querySelector("c-lwc-flame-product-size-flow").defaultPressureUnits(this.pressureUnitsApi);
        }
    }

    handleMountingChange(event){
        this.section1Saved = false; // @developer
        this.mounting = event.target.value;
    }

    handlePipeDesignChange(event){
        this.section1Saved = false; // @developer
        this.pipeDesign = event.target.value;
    }

    handleGasGroupChange(event){
        this.section1Saved = false; // @developer
        this.gasGroup = event.target.value;
    }

    handleRunUpLengthAUnits(event){
        this.section4Saved = false; //added bu piyush
        this.runUpLengthAUnits = event.target.value;
    }

    handleRunUpLengthBUnits(event){
        this.section4Saved = false; //added bu piyush
        this.runUpLengthBUnits = event.target.value;
    }

    handleConnSizePicklistValues(event){
        this.selConnSize = event.target.value;
        let selTrimCon = this.selConnSize.replace(/^0+/, '');
        let modArr = this.filterModSZC;
        this.modConnSizeOptions = [];
        this.eleFilterArray = [];

        console.log(' @@@- this.selEleSize -- ',this.selEleSize);
        if(this.selEleSize){
            let selTrimEle = this.selEleSize.replace(/^0+/, '');
            for (let eachElement of modArr) {
                let lastIndexOf = eachElement.label.lastIndexOf('"');
                let lastIndexValOf = eachElement.label.substring(lastIndexOf-2,lastIndexOf);
                let trimmedLastIndexValueOf = lastIndexValOf.trim();
                if(selTrimEle === trimmedLastIndexValueOf){
                    this.eleFilterArray.push({
                        label: eachElement.label, value: `${eachElement.value}`
                    })
                }
            }
            console.log(' this.eleFilterArray -- ',this.eleFilterArray);
            if(this.selConnSize){
                let selEleFilterArr = this.eleFilterArray;
                for (let eachElement of selEleFilterArr) {
                    let firstIndexOf = eachElement.label.indexOf('"');
                    let firstIndexValOf = eachElement.label.substring(firstIndexOf-2,firstIndexOf);
                    let trimmedFirstIndexValueOf = firstIndexValOf.trim();
                    if(selTrimCon === trimmedFirstIndexValueOf){
                        this.modConnSizeOptions.push({
                            label: eachElement.label, value: `${eachElement.value}`
                        })
                    }
                }
            } else {
                this.modConnSizeOptions = this.eleFilterArray;
            }
        } else if(this.selConnSize){
            for (let eachElement of modArr) {
                let firstIndexOf = eachElement.label.indexOf('"');
                let firstIndexValOf = eachElement.label.substring(firstIndexOf-2,firstIndexOf);
                let trimmedFirstIndexValueOf = firstIndexValOf.trim();
                if(selTrimCon === trimmedFirstIndexValueOf){
                    this.modConnSizeOptions.push({
                        label: eachElement.label, value: `${eachElement.value}`
                    })
                }
            }
        } else {
            this.modConnSizeOptions = this.filterModSZC;
        }
        return this.modConnSizeOptions;
    }


    handleEleSizePicklistValues(event){
        this.selEleSize = event.target.value;
        let selTrimEle = this.selEleSize.replace(/^0+/, '');
        let modArr = this.filterModSZC;
        this.modConnSizeOptions = [];
        this.sizeFilterArray = [];

        if(this.selConnSize) {
            console.log(' If -- ',this.selConnSize);
            let selTrimCon = this.selConnSize.replace(/^0+/, '');
            for (let eachElement of modArr) {
                let firstIndexOf = eachElement.label.indexOf('"');
                let firstIndexValOf = eachElement.label.substring(firstIndexOf-2,firstIndexOf);
                let trimmedFirstIndexValueOf = firstIndexValOf.trim();
                if(selTrimCon === trimmedFirstIndexValueOf){
                    this.sizeFilterArray.push({
                        label: eachElement.label, value: `${eachElement.value}`
                    })
                }
            }
            if(this.selEleSize){
                let selConnFilterArr = this.sizeFilterArray;
                for (let eachElement of selConnFilterArr) {
                    let lastIndexOf = eachElement.label.lastIndexOf('"');
                    let lastIndexValOf = eachElement.label.substring(lastIndexOf-2,lastIndexOf);
                    let trimmedLastIndexValueOf = lastIndexValOf.trim();
                    if(selTrimEle === trimmedLastIndexValueOf){
                        this.modConnSizeOptions.push({
                            label: eachElement.label, value: `${eachElement.value}`
                        })
                    }
                }
            } else {
                this.modConnSizeOptions = this.sizeFilterArray;
            }
        } else if(this.selEleSize) {
            for (let eachElement of modArr) {
                let lastIndexOf = eachElement.label.lastIndexOf('"');
                let lastIndexValOf = eachElement.label.substring(lastIndexOf-2,lastIndexOf);
                let trimmedLastIndexValueOf = lastIndexValOf.trim();
                if(selTrimEle === trimmedLastIndexValueOf){
                    this.modConnSizeOptions.push({
                        label: eachElement.label, value: `${eachElement.value}`
                    })
                }
            }
        } else {
            this.modConnSizeOptions = this.filterModSZC;
        }
        console.log('this.modConnSizeOptions : -- ',this.modConnSizeOptions);
        return this.modConnSizeOptions;
    }

    @api setConnSize;
    @api setEleSize;
    handleModConnSizePicklistValues(event){
        this.selModConnSize = event.target.value;
        console.log('handleModConnSizePicklistValues',this.selModConnSize);

        let firstIndexOf = this.selModConnSize.indexOf('"');
        let firstIndexValOf = this.selModConnSize.substring(firstIndexOf-2,firstIndexOf);
        let firstIndexValOfBlankCheck = this.selModConnSize.substring(firstIndexOf-2,firstIndexOf-1);
        let firstIndexValOflastElement = this.selModConnSize.substring(firstIndexOf-1,firstIndexOf);
        let trimmedFirstIndexValueOf = firstIndexValOfBlankCheck.trim();
        if(trimmedFirstIndexValueOf != ''){
            this.setConnSize = firstIndexValOf;
        } else {
            this.setConnSize = '0' + firstIndexValOflastElement;
        }


        let lastIndexOf = this.selModConnSize.lastIndexOf('"');
        let lastIndexValOf = this.selModConnSize.substring(lastIndexOf-2,lastIndexOf);
        let lastIndexValOfBlankCheck = this.selModConnSize.substring(lastIndexOf-2,lastIndexOf-1);
        let lastIndexValOflastElement = this.selModConnSize.substring(lastIndexOf-1,lastIndexOf);
        let trimmedLastIndexValueOf = lastIndexValOfBlankCheck.trim();
        if(trimmedLastIndexValueOf != ''){
            this.setEleSize = lastIndexValOf;
        } else {
            this.setEleSize = '0' + lastIndexValOflastElement;
        }

    }

    handleconstraintProductSelectionByFlowOptions(event){
        this.section1Saved = false; // @developer
        console.log('handleconstraintProductSelectionByFlowOptions : - ',event.target.name);
        this.selectedConstraintProductSelectionByFlow = this.template.querySelector('.constrainProductSelectByFlow').checked;
        console.log('handleconstraintProductSelectionByFlowOptions @@@this.selectedConstraintProductSelectionByFlow : - ',this.selectedConstraintProductSelectionByFlow );
    }

     // Save and Continue Start
     handleSaveApplicationParameters(event){
        event.preventDefault();
        const flmProdFields = event.detail.fields;
        flmProdFields.Id = this.recordId;
        flmProdFields.Mounting__c = this.mounting;
        flmProdFields.Pipe_Design__c = this.pipeDesign;
        flmProdFields.GasGroupDynamic__c = this.gasGroup;
        flmProdFields.Constrain_Product_Selection_by_Flow__c = this.selectedConstraintProductSelectionByFlow;
        flmProdFields.Flow_Rate_Units__c = this.flowRateUnitsApi;
        flmProdFields.Temperature_Units__c = this.temperatureUnitsApi;
        flmProdFields.Pressure_Units__c = this.pressureUnitsApi;
		saveApplicationParameters({conFA: flmProdFields})
        .then(result => {
            this.bShowEditBtn = false; //added by piyush
            this.bHideReturnToQuote = true; //@piyush
            this.section1Saved = true; //@developer
            console.log('Result : -- ',JSON.stringify(result));
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

            this.isErrorSection5 = false;
            this.section5ErrorMessage = [];
            let removeError5 = this.template.querySelectorAll(".section5");
            if(removeError5){
                removeError5.forEach((element)=>{element.classList.remove("slds-box")});
            }
            this.flmProdFields = result;
            if(this.selectedConstraintProductSelectionByFlow){
                this.template.querySelector("c-lwc-flame-product-size-flow").afterSectionASave(result);
            }
            this.template.querySelector(".ApplicationParametersForm").submit(result);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Saved Successfully',
                    variant: 'success',
                }),
            );
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

    //added by piyush

    handleChildCmpFieldUpdate(event){
        this.section2Saved = false; // added by piyush
    }

    handleSaveSizingArea(event) {
        this.bShowEditBtn = false; //added by piyush
        this.section2Saved = true; // added by piyush
        this.bHideReturnToQuote = true; //@piyush
        this.convertedMaxAllowablePressureDrop = event.detail.convertedMaxAllowablePressureDrop;
        this.convertedAtmosphericPressure = event.detail.convertedAtmosphericPressure;
        this.convertedRequiredFlowRate = event.detail.convertedRequiredFlowRate;
        this.convertedTempratureofFlowingVapor = event.detail.convertedTempratureofFlowingVapor;
        this.convertedPressureofFlowingVapor = event.detail.convertedPressureofFlowingVapor;
        this.locationOfFlowingPressureSpecification = event.detail.locationOfFlowingPressureSpecification;
        this.certificationRequirement = event.detail.certificationRequirement;
        this.naceCertificate = event.detail.naceCertificate;
        this.operationalPressure = event.detail.operationalPressure;
        this.operationalTemperature = event.detail.operationalTemperature;
        this.arrestorDetonationDeflagration = event.detail.arrestorDetonationDeflagration;
        this.offsetConcentricBases = event.detail.offsetConcentricBases;
        this.runUpLengthA = event.detail.runUpLengthA;
        this.runUpLengthB = event.detail.runUpLengthB;

        this.molWeight = event.detail.molWeight;
        this.compFactor = event.detail.compFactor;
        this.ratioOfSpecHeats = event.detail.ratioOfSpecHeats;
        this.presRatio = event.detail.presRatio;
        this.minReqFlowRateSCFH = event.detail.minReqFlowRateSCFH;
        this.criticalPresRatio = event.detail.criticalPresRatio;
        this.inletFlowPresPSIA = event.detail.inletFlowPresPSIA;

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

        /*

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
        this.ModelSizeOptions = [];*/
   }

   handleCertificationRequirementChange(event){
        this.section3Saved = false; //added by piyush
        this.certificationRequirement = event.target.value;
   }

   //added by piyush
   onCertificateFieldUpdate(){
    this.section3Saved = false; //added by piyush
   }

    handleSaveCertifications(event){
        event.preventDefault();
        const flmProdFields = event.detail.fields;
        flmProdFields.Id = this.recordId;
        flmProdFields.Certfication_Requirement__c = this.certificationRequirement;
		saveCertifications({flmProd: flmProdFields})
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
            this.flmProdFields = result;
            console.log('this.flmProdFields : --',this.flmProdFields);
            this.template.querySelector(".CertificationsForm").submit(this.flmProdFields);

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
            }else{
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

    handleDetonationDeflagrationOptions(event){
        this.section4Saved = false; //added by piyush
        this.arrestorDetonationDeflagration = event.target.value;
        if(this.arrestorDetonationDeflagration != 'Detonation'){
            this.isDetonation = true;
        } else if(this.arrestorDetonationDeflagration == 'Detonation'){
            this.isDetonation = false;
        }
    }

    handleOffsetConcentricChange(event){
        this.section4Saved = false; //added by piyush
        this.offsetConcentricBases = event.target.value;
    }

    handleSaveProductNarrowing(event){
        event.preventDefault();
        const flmProdFields = event.detail.fields;
        flmProdFields.Id = this.recordId;
        flmProdFields.Mounting__c = this.mounting;
        flmProdFields.Pipe_Design__c = this.pipeDesign;
        flmProdFields.GasGroupDynamic__c = this.gasGroup;
        flmProdFields.Nace_Backend__c = this.NACE;
        flmProdFields.US_Coast_guard__c = this.USCG;
        flmProdFields.CU_TR__c = this.CUTR;
        flmProdFields.Atex_Certificate_2014_34_EU__c = this.ATEX;
        flmProdFields.Gas_Group_Code__c = this.gasGroupCode;
        flmProdFields.Operational_Pressure__c = this.operationalPressure;
        flmProdFields.Operational_Temperature__c = this.operationalTemperature;
        flmProdFields.Arrester_for_Detonation_or_Deflagration__c = this.arrestorDetonationDeflagration;
        flmProdFields.Offset_or_Concentric_Bases__c = this.offsetConcentricBases;
        flmProdFields.Constrain_Product_Selection_by_Flow__c = this.selectedConstraintProductSelectionByFlow;

        flmProdFields.Molecular_Weight__c = this.molWeight;
        flmProdFields.Compressibility_Factor__c = this.compFactor;
        flmProdFields.Ratio_of_Specific_Heats__c = this.ratioOfSpecHeats;
        flmProdFields.PresRatio__c = this.presRatio;
        flmProdFields.MinReqdFlowRateSCFH__c = this.minReqFlowRateSCFH;
        flmProdFields.CriticalPresRatio__c = this.criticalPresRatio;
        flmProdFields.Converted_Max_Allowable_Pressure_Drop__c = this.convertedMaxAllowablePressureDrop;
        flmProdFields.Converted_Atmospheric_Pressure__c = this.convertedAtmosphericPressure;
        flmProdFields.Converted_Required_Flow_Rate__c = this.convertedRequiredFlowRate;
        flmProdFields.Converted_Temprature_of_flowing_Vapor__c = this.convertedTempratureofFlowingVapor;
        flmProdFields.Converted_Pressure_of_flowing_Vapor__c = this.convertedPressureofFlowingVapor;
        flmProdFields.InletFlowPresPSIA__c = this.inletFlowPresPSIA;
        flmProdFields.Certification_Save_Check_Flag__c = this.certificationSaveCheckFlag;

        if(flmProdFields.Arrester_for_Detonation_or_Deflagration__c == 'Detonation' || flmProdFields.Mounting__c == 'End-of-Line'){
            flmProdFields.Run_Up_Length_A_Input__c = 0;
            flmProdFields.Run_Up_Length_B_Input__c = 0;
            flmProdFields.Run_Up_Length_A_Input_Units__c = 'in';
            flmProdFields.Run_Up_Length_B_Input_Units__c = 'in';
        } else if(flmProdFields.Mounting__c == 'In-Line Pipe with Bend') {
            if(flmProdFields.Run_Up_Length_A_Input__c == null){
                flmProdFields.Run_Up_Length_A_Input__c = 0;
            } else {
                flmProdFields.Run_Up_Length_A_Input__c = this.runUpLengthA;
            }

            if(flmProdFields.Run_Up_Length_B_Input__c == null){
                flmProdFields.Run_Up_Length_B_Input__c = 0;
            } else {
                flmProdFields.Run_Up_Length_B_Input__c = this.runUpLengthB;
            }
            flmProdFields.Run_Up_Length_A_Input_Units__c = this.runUpLengthAUnits;
            flmProdFields.Run_Up_Length_B_Input_Units__c = this.runUpLengthBUnits;
            console.log('flmProdFields.Run_Up_Length_A_Input_Units__c : -- '+flmProdFields.Run_Up_Length_A_Input_Units__c);
            console.log('flmProdFields.Run_Up_Length_B_Input_Units__c : -- '+flmProdFields.Run_Up_Length_B_Input_Units__c);
        } else {
            if(flmProdFields.Run_Up_Length_A_Input__c == null){
                flmProdFields.Run_Up_Length_A_Input__c = 0;
            } else {
                flmProdFields.Run_Up_Length_A_Input__c = this.runUpLengthA;
            }
            flmProdFields.Run_Up_Length_A_Input_Units__c = this.runUpLengthAUnits;
            flmProdFields.Run_Up_Length_B_Input__c = 0;
            flmProdFields.Run_Up_Length_B_Input_Units__c = 'in';
        }
		saveProductNarrowing({flmProd: flmProdFields,flmProdId: this.recordId})
        .then(result => {
            this.bShowEditBtn = false; //added by piyush
            this.section4Saved = true; // added by piyush
            this.bHideReturnToQuote = true; //@piyush
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

            this.flmProdFields = result.flameProd;
            if(result.modelDesc.length > 1 && result.eleSizeOptions.length > 1 && result.connSizeOptions.length > 1){

                this.connSizeOptions = result.connSizeOptions;
                this.eleSizeOptions  = result.eleSizeOptions;
                this.modConnSizeOptions  = result.modelDesc;
                this.filterModSZC = result.modelDesc;
                this.template.querySelector(".ProductNarrowingForm").submit(this.flmProdFields);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Saved Successfully',
                        variant: 'success',
                    }),
                );
            } else{
                this.modConnSizeOptions = [];
                this.eleSizeOptions = [];
                this.connSizeOptions = [];
                this.selModConnSize = '';
                this.selEleSize = '';
                this.selConnSize = '';
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Note',
                        message: 'No Model, Size, and Element Size found for the selected inputs',
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
                let removeError4 = this.template.querySelectorAll(".section4");
                if(removeError4){
                    removeError4.forEach((element)=>{element.classList.add("slds-box")});
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

    handleSaveProductSelection(event){
        event.preventDefault();
        const flmProdFields = event.detail.fields;
        flmProdFields.Id = this.recordId;
        flmProdFields.Model__c = this.selModConnSize;
        flmProdFields.SZC__c = this.setConnSize;
        flmProdFields.ESZC__c =  this.setEleSize;
        flmProdFields.Size__c = this.setConnSize;
        flmProdFields.IsConfig__c = false; // added by piyush
        flmProdFields.Certification_Save_Check_Flag__c = this.certificationSaveCheckFlag; //Service Ticket # 200107
        saveProductSelection({flmProd: flmProdFields})
        .then(result => {
            this.isErrorSection5 = false;
            this.section5ErrorMessage = [];
            let removeError5 = this.template.querySelectorAll(".section5");
            if(removeError5){
                removeError5.forEach((element)=>{element.classList.remove("slds-box")});
            }
            this.flmProdFields = result;
            this.template.querySelector(".ProductSelectionForm").submit(this.flmProdFields);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Saved Successfully',
                    variant: 'success',
                }),
            );

            let isPortalUser = this.currentUserInfo.fields.IsPortalEnabled.value;
            console.log('ScurrentUserInfo ', isPortalUser);
            let encodeURI = '';
            let sUrl = '/apex/ConfigFLAME?id=' + this.recordId + '&qid=' + this.quoteLineId;
            // + '&selectedTab=second';

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
            console.log('ProductSelection result === ', result);
		})
        .catch(error => {
             if(error.body.message){
                this.isErrorSection5 = true;
                this.section5ErrorMessage = [];
                this.section5ErrorMessage.push(error.body.message);
                let removeError5 = this.template.querySelectorAll(".section5");
                if(removeError5){
                    removeError5.forEach((element)=>{element.classList.add("slds-box")});
                }
            } else {
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


    //************************Next Without Save Button*****************/
    // navToVFPage(event){
    //     event.preventDefault();
    //     //if(this.navToVF == false){
    //         let isPortalUser = this.currentUserInfo.fields.IsPortalEnabled.value;
    //         console.log('ScurrentUserInfo ', isPortalUser);
    //         let encodeURI = '';
    //         let sUrl = '/apex/ConfigFLAME?id=' + this.recordId + '&qid=' + this.quoteLineId;
    //         // + '&selectedTab=second';
    //         if (isPortalUser) {
    //             encodeURI = '/sfdcpage/' + encodeURIComponent(sUrl);
    //         } else {
    //             encodeURI = sUrl;
    //         }
    //         this[NavigationMixin.Navigate]({
    //             type: 'standard__webPage',
    //             attributes: {
    //                 url: encodeURI
    //             }
    //         },
    //             true // Replaces the current page in your browser history with the URL
    //         );
    //     //}
    // }


    RemoveDecimal(event){
        let targetName = event.target.name;
        if(targetName === 'operationalPressure')
            this.operationalPressure = event.target.value;
        else if(targetName === 'runUpLengthA')
            this.runUpLengthA = event.target.value;
        else if(targetName === 'runUpLengthB')
            this.runUpLengthB = event.target.value;
    }

    restrictNonNumericalValues(event){
        this.section4Saved = false; // added by piyush
        console.log('event.keycode'+event.keyCode);
        let charCode = (event.which) ? event.which : event.keyCode;
        if(charCode != 46 && charCode != 37 && charCode != 39 && charCode != 110 && charCode != 190 && ((charCode > 31 && charCode <48)||(charCode>57 && charCode<93) ||charCode >105 ))
            event.preventDefault();
    }

    onScrollMain(event) {

        let number = event.target.scrollTop;

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

     /* Added by piyush */


     onProductNarrowingFieldChange(){
       this.section4Saved = false;
     }

     onSizingFlowAreaFormOver(event){

        if(this.section1Saved == false && this.bDisabled == false){
            this.template.querySelector("div[class='section-1']").scrollIntoView({behavior: "smooth"});
             event.preventDefault();
             this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Unsaved Changes On "Application Parameters" Section.',
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
                        title: 'Unsaved Changes On "Sizing/Flow.',
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