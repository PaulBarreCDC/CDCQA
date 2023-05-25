import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import FA_Images from '@salesforce/resourceUrl/Flame_Arrestor_Images';

import Flame_Product_OBJECT from '@salesforce/schema/Flame_Product__c';

import fetchFlowingMedia from '@salesforce/apex/FlameProductController.fetchFlowingMedia';
import flowingMediaValues from '@salesforce/apex/FlameProductController.flowingMediaValues';
import saveSizing from '@salesforce/apex/FlameProductController.saveSizing';

//SecA
import Mounting_Field from '@salesforce/schema/Flame_Product__c.Mounting__c';
import Pipe_Design from '@salesforce/schema/Flame_Product__c.Pipe_Design__c';
import Gas_Group from '@salesforce/schema/Flame_Product__c.Gas_Group__c';
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


const faFields = [
    Mounting_Field,Pipe_Design,Gas_Group,Constrain_Product_Selection_by_Flow,
    Max_Allowable_Pressure_Drop,Max_Allowable_Pressure_Drop_Units,Converted_Max_Allowable_Pressure_Drop,Required_Flow_Rate,Required_Flow_Rate_Units,Converted_Required_Flow_Rate,
    Flowing_Media,Media_Name,Molecular_Weight,Compressibility_Factor,Ratio_of_Specific_Heats,Atmospheric_Pressure,Atmospheric_Pressure_Units,Converted_Atmospheric_Pressure,
    Temperature_of_flowing_Vapor,Temperature_of_flowing_Vapor_Units,Converted_Temprature_of_flowing_Vapor,Pressure_of_flowing_Vapor,Pressure_of_flowing_Vapor_Units,
    Converted_Pressure_of_flowing_Vapor,Location_of_Flowing_Pressure_Specificati
    ];

export default class LwcFlameProductSizeFlow extends NavigationMixin(LightningElement) {
    // Expose URL of assets included inside an archive file
    faInOut = FA_Images + '/FA-Inlet-Outlet.PNG';

    @api flowRateUnitsApi;
    @api temperatureUnitsApi;
    @api pressureUnitsApi;
    @api recordId;
    @api quoteId;

    @track maxAllowablePressureDrop;
    @track maxAllowablePressureDropUnits;

    @track selectedFlowingMedia = 'Air'; 
    @track customerSpecified;
    @track ratioOfSpecificHeats = 1.4;
    @track molecularWeight = 28.964;
    @track CompressibilityFactor = 1;

    @track atmosphericPressure;
    @track AtmosphericPressureUnitsVal = 'psia';
    @track requiredFlowRate;
    @track requiredFlowRateUnits;
    
    @track tempOfFlowingVapor;
    @track tempOfFlowingVaporUnits;
    @track pressureOfFlowingVapor;
    @track pressureOfFlowingVaporUnits = 'psia';

    @track CustomSpecified;
    @track disableForNonCustomerSpecified;
    @track FlowingMediaOptions;

    @track mounting;
    @track mountingCheck = false;
    @track pipeDesign;
    @track gasGroup;
    @track locationOFFlowingPressure;
    @track locationOFFlowingPressureOptions;

    @track isErrorSizingArea;
    @track sizingFlowAreaMessage;

    //added by piyush
    @api sDisabled = '';
    @api bDisabled = false;

    connectedCallback(){          
        this.tempOfFlowingVaporUnits = this.temperatureUnitsApi;
        this.requiredFlowRateUnits = this.flowRateUnitsApi;
        this.maxAllowablePressureDropUnits =  this.pressureUnitsApi;
        this.pressureOfFlowingVaporUnits =  this.pressureUnitsApi;
    }  


    @wire(getRecord, { recordId: '$recordId', fields: faFields})
    rvRec({ error, data }) {
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
            this.mounting = data.fields.Mounting__c.value;
            if(this.mounting != 'End-of-Line'){
                this.mountingCheck = true;
            } else {
                this.mountingCheck = false;
            }
            console.log('this.mountingCheck = true -- in Data : -- ',this.mountingCheck);
            console.log('this.mounting = in data : -- ',this.mounting);

            this.pipeDesign = data.fields.Pipe_Design__c.value;
            this.gasGroup = data.fields.Gas_Group__c.value;

            this.maxAllowablePressureDrop = data.fields.Max_Allowable_Pressure_Drop__c.value;
            this.maxAllowablePressureDropUnits = data.fields.Max_Allowable_Pressure_Drop_Units__c.value;
            
            this.selectedFlowingMedia = data.fields.Flowing_Media__c.value;
            this.customerSpecified = data.fields.Media_Name__c.value;
            if(this.selectedFlowingMedia != 'Customer Specified' || this.selectedFlowingMedia === '' || this.selectedFlowingMedia === undefined || this.selectedFlowingMedia === null){
                this.disableForNonCustomerSpecified = true;                
            }else{
                this.disableForNonCustomerSpecified = false;
            }

            this.CompressibilityFactor = data.fields.Compressibility_Factor__c.value;
            this.molecularWeight = data.fields.Molecular_Weight__c.value;
            this.ratioOfSpecificHeats = data.fields.Ratio_of_Specific_Heats__c.value;

            this.atmosphericPressure = data.fields.Atmospheric_Pressure__c.value;
            this.AtmosphericPressureUnitsVal = data.fields.Atmospheric_Pressure_Units__c.value;

            this.requiredFlowRate = data.fields.Required_Flow_Rate__c.value;
            this.requiredFlowRateUnits = data.fields.Required_Flow_Rate_Units__c.value;
            
            this.tempOfFlowingVapor = data.fields.Temperature_of_flowing_Vapor__c.value;
            this.tempOfFlowingVaporUnits = data.fields.Temperature_of_flowing_Vapor_Units__c.value;

            this.pressureOfFlowingVapor = data.fields.Pressure_of_flowing_Vapor__c.value;
            this.pressureOfFlowingVaporUnits = data.fields.Pressure_of_flowing_Vapor_Units__c.value;

            this.locationOFFlowingPressure = data.fields.Location_of_Flowing_Pressure_Specificati__c.value;
        }
    }

    renderedCallback() {
        if(this.recordId !== undefined && this.recordId !== null && this.recordId !== ''){
            if(this.template.querySelector('[class="'+this.locationOFFlowingPressure+'Id"]') !== null && this.template.querySelector('[class="'+this.locationOFFlowingPressure+'Id"]') !== undefined ){
                this.template.querySelector('[class="'+this.locationOFFlowingPressure+'Id"]').checked = true;
            }
        }
    }

    @wire(fetchFlowingMedia)
    FlowingMediaList({ data, error }){
        if(data){
            this.FlowingMediaOptions = data;
            this.error = undefined;
        }
        if(error){
            this.error = error;
            this.FlowingMediaOptions = undefined;
        }
    }

    @wire(getObjectInfo, { objectApiName: Flame_Product_OBJECT })
        objectInfo;

    @wire(getPicklistValues, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        fieldApiName : Location_of_Flowing_Pressure_Specificati
    })
    wiredPickListValueLocation({ data, error }){
        if(data){
            this.locationOFFlowingPressureOptions = [];
            data.values.forEach(element =>{
                let newElement = {label:element.label,value:element.value,generatedId:'locationOff'+element.value+'Id'};
                this.locationOFFlowingPressureOptions.push(newElement);
            });
            this.error = undefined;
        }
        if(error){
            console.log(` Error while fetching Picklist values  ${error}`);
            this.error = error;
            this.locationOFFlowingPressureOptions = undefined;
        }
    } 

    @api
    defaultTemperatureUnits(temperatureUnits) {
         this.tempOfFlowingVaporUnits = temperatureUnits;
    }

    @api 
    defaultFlowRateUnits(flowRateUnits){
        this.requiredFlowRateUnits = flowRateUnits;
    }

    @api 
    defaultPressureUnits(pressureUnits){
        this.maxAllowablePressureDropUnits = pressureUnits;
        this.pressureOfFlowingVaporUnits = pressureUnits;
    }

    @api
    afterSectionASave(conFARecords){
        this.isErrorSizingArea = false;
        this.sizingFlowAreaMessage = [];
        let removeError = this.template.querySelectorAll(".sizingArea");
        if(removeError){
            removeError.forEach((element)=>{element.classList.remove("slds-box")});
        }    
            
        this.selectedFlowingMedia = conFARecords.Flowing_Media__c;
        this.customerSpecified = conFARecords.Media_Name__c;
        this.ratioOfSpecificHeats = conFARecords.Ratio_of_Specific_Heats__c;
        this.molecularWeight = conFARecords.Molecular_Weight__c;
        this.CompressibilityFactor = conFARecords.Compressibility_Factor__c;
        this.disableForNonCustomerSpecified = true;
        this.mounting = conFARecords.Mounting__c;
        console.log('afterSectionASave -- this.mountingCheck : --- ',this.mountingCheck);
        if(this.mounting != 'End-of-Line'){
            this.mountingCheck = true;
        } else {
            this.mountingCheck = false;
        }
        console.log('afterSectionASave -- this.mountingCheck : --- ',this.mountingCheck);
        console.log('afterSectionASave -- this.mounting : --- ',this.mounting);
        this.atmosphericPressure = conFARecords.Atmospheric_Pressure__c;
        this.AtmosphericPressureUnitsVal = conFARecords.Atmospheric_Pressure_Units__c;
        this.requiredFlowRate = conFARecords.Required_Flow_Rate__c;
        this.maxAllowablePressureDrop = conFARecords.Max_Allowable_Pressure_Drop__c;
        this.tempOfFlowingVapor = conFARecords.Temperature_of_flowing_Vapor__c;
        this.pressureOfFlowingVapor = conFARecords.Pressure_of_flowing_Vapor__c;	
        if(this.locationOFFlowingPressure && this.template.querySelector('[class="locationOff'+this.locationOFFlowingPressure+'Id"]')){
            this.template.querySelector('[class="locationOff'+this.locationOFFlowingPressure+'Id"]').checked = false;    
        }
        updateRecord({ fields: { Id: this.recordId } });
    }


    handleFlowingMediaChange(event){
        this.sizingFlowChanged(); //added by piyush
        let faObj = { 'sobjectType': 'Flame_Product__c' };
        faObj.Id = this.recordId;
        faObj.Flowing_Media__c = event.target.value;   
        this.selectedFlowingMedia =  event.target.value;
        
        if(event.detail.value === 'Customer Specified'){            
            this.disableForNonCustomerSpecified = false;
            this.ratioOfSpecificHeats = null;
            this.molecularWeight = null;
            this.CompressibilityFactor = null;
            this.CustomSpecified = true;
        }else{
            this.CustomSpecified = false;
            flowingMediaValues({flmprod: faObj})
            .then(result => {
                if(result.Ratio_of_Specific_Heats__c){
                    this.ratioOfSpecificHeats = result.Ratio_of_Specific_Heats__c;
                }else{
                    this.ratioOfSpecificHeats = null;
                }

                if(result.Molecular_Weight__c){
                    this.molecularWeight = result.Molecular_Weight__c;
                }else{
                    this.molecularWeight = null;
                }

                if(result.Compressibility_Factor__c){
                    this.CompressibilityFactor = result.Compressibility_Factor__c;
                }else{
                    this.CompressibilityFactor = null;
                }
                this.disableForNonCustomerSpecified = true;
                this.selectedFlowingMedia =  result.Flowing_Media__c;
            })
            .catch(error => {
                console.log(error);
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

    handlelocationOFFlowingPressureChange(event){
        this.sizingFlowChanged(); //added by piyush
        this.locationOFFlowingPressure = event.target.value;
    }

    restrictNonNumericalValues(event){
        this.sizingFlowChanged(); //added by piyush
        let targetValue = event.target.value;
        let charCode = (event.which) ? event.which : event.keyCode;

        if((charCode != 46 && charCode != 37 && charCode != 39 && charCode != 110 && charCode != 190 && ((charCode > 31 && charCode <48)||(charCode>57 && charCode<93) ||charCode >105 )) || event.shiftKey==1 || ((charCode == 110 || charCode == 190) &&  (targetValue.match(/\./g) || []).length > 0) ){
            event.preventDefault();
        }            
    }

    restrictNonNumericalValuesWithoutNegative(event){
        this.sizingFlowChanged(); //added by piyush
        let charCode = (event.which) ? event.which : event.keyCode;
        if(charCode != 45 && charCode != 46 && charCode != 37 && charCode != 39 && charCode != 110 && charCode != 189 && charCode != 190 && ((charCode > 31 && charCode <48)||(charCode>57 && charCode<93) ||charCode >105 ))
            event.preventDefault();
    }


    RemoveDecimal(event){
        let targetName = event.target.name;

        if(targetName === 'atmosphericPressure'){
            this.atmosphericPressure = event.target.value;
        }
        else if(targetName === 'ratioOfSpecificHeats'){
            this.ratioOfSpecificHeats = event.target.value;
        }   
        else if(targetName === 'molecularWeight'){
            this.molecularWeight = event.target.value;
        }
        else if(targetName === 'CompressibilityFactor'){
            this.CompressibilityFactor = event.target.value;
        }
        else if(targetName === 'requiredFlowRate'){
            this.requiredFlowRate = event.target.value;
        }   
        else if(targetName === 'maxAllowablePressureDrop'){
            this.maxAllowablePressureDrop = event.target.value;
        }
        else if(targetName === 'tempOfFlowingVapor'){
            this.tempOfFlowingVapor = event.target.value;
        }
        else if(targetName === 'pressureOfFlowingVapor'){
            this.pressureOfFlowingVapor = event.target.value;
        }
    }

    handleSaveSizingFlowArea(event){
        event.preventDefault(); 
        const faFields = event.detail.fields;
        faFields.Id = this.recordId;
        faFields.Media__c = this.selectedFlowingMedia;
        faFields.Mounting__c = this.mounting;
        faFields.Pipe_Design__c = this.pipeDesign;
        faFields.Gas_Group__c = this.gasGroup;
        faFields.Pressure_of_flowing_Vapor__c = this.pressureOfFlowingVapor;
        faFields.Pressure_of_flowing_Vapor_Units = this.pressureOfFlowingVaporUnits;
        faFields.Location_of_Flowing_Pressure_Specificati__c = this.locationOFFlowingPressure;
        faFields.Flowing_Media__c = this.selectedFlowingMedia;
		saveSizing({flmprod: faFields})
        .then(result => {
           
            this.isErrorSizingArea = false;
            this.sizingFlowAreaMessage = [];
            let removeError = this.template.querySelectorAll(".sizingArea");
            if(removeError){
                removeError.forEach((element)=>{element.classList.remove("slds-box")});
            }
             
            // Creates the event with the data.
            const selectedEvent = new CustomEvent("savesizingarea", {
                detail: { 
                    convertedMaxAllowablePressureDrop : result.Converted_Max_Allowable_Pressure_Drop__c,
                    convertedRequiredFlowRate : result.Converted_Required_Flow_Rate__c,
                    convertedAtmosphericPressure : result.Converted_Atmospheric_Pressure__c,
                    convertedTempratureofFlowingVapor : result.Converted_Temprature_of_flowing_Vapor__c,
                    convertedPressureofFlowingVapor : result.Converted_Pressure_of_flowing_Vapor__c,
                    locationOfFlowingPressureSpecification : result.Location_of_Flowing_Pressure_Specificati__c,
                    certificationRequirement : result.Certfication_Requirement__c,
                    naceCertificate : result.NACE__c,
                    operationalPressure : result.Operational_Pressure__c,
                    operationalTemperature : result.Operational_Temperature__c,
                    arrestorDetonationDeflagration : result.Arrester_for_Detonation_or_Deflagration__c,
                    offsetConcentricBases : result.Offset_or_Concentric_Bases__c,
                    runUpLengthA : result.Run_Up_Length_A_Input__c,
                    runUpLengthB : result.Run_Up_Length_B_Input__c,

                    molWeight : result.Molecular_Weight__c,
                    compFactor : result.Compressibility_Factor__c,
                    ratioOfSpecHeats : result.Ratio_of_Specific_Heats__c,
                    presRatio : result.PresRatio__c,
                    minReqFlowRateSCFH : result.MinReqdFlowRateSCFH__c,
                    criticalPresRatio : result.CriticalPresRatio__c,
                    inletFlowPresPSIA : result.InletFlowPresPSIA__c      
                }
           
            });
            // Dispatches the event.
            this.dispatchEvent(selectedEvent);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Saved Successfully',
                    variant: 'success',
                }),
            );
			console.log('Sizing FLow Area result === ', result);
		})
        .catch(error => {

            if(error.body.message){

                this.isErrorSizingArea = true;
                this.sizingFlowAreaMessage = [];
                this.sizingFlowAreaMessage.push(error.body.message);
                let removeError = this.template.querySelectorAll(".sizingArea");
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


    // added by piyush 
    sizingFlowChanged(){
        const selectedEvent = new CustomEvent("anyfieldupdate");
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }
}