import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getQuoteLines from '@salesforce/apex/PartnerCommunityController.getQuoteLines';
import viewConfiguredProduct from '@salesforce/apex/cdcpc.LWCHost_Configurator.getConfiguratorIdForQuoteLine';
import editConfiguredProduct from '@salesforce/apex/cdcpc.LWCHost_Configurator.getEditableInstanceFromQuoteLine';

export default class ConfiguratorEdit extends NavigationMixin(LightningElement) {

    @api quoteId;
    isLoading = false;
    productOptions;
    selectedValue;
    productSelected = false;
    buttonsDisabled = false;

    connectedCallback(){
        this.isLoading = true;
        this.getQuoteLines();
    }

    // renderedCallback(){
    //     this.isLoading = !this.isLoading;
    //     this.getQuoteLines();
    // }

    // disconnectedCallback(){
    //     this.isLoading = false;
    //     this.buttonsDisabled = false;
    //     this.productSelected = false;
    // }

    getQuoteLines(){
        getQuoteLines({ quoteId: this.quoteId })
        .then(result => {
            if(result){
                this.productOptions = result.map(line => {
                    return {
                        label: line.SBQQ__ProductName__c,
                        value: line.Id
                    };
                });
                this.isLoading = false;
            } else {
                this.isLoading = false;
            }          
        })
        .catch(error => {
            this.showToast('error', 'error retrieving quote lines.', 'error');
            this.isLoading = false;
        });
    }

    navigateBackToQuote(){
        this.isLoading = true;
        let qleLink = '/apex/sbqq__sb?scontrolCaching=1&id='+this.quoteId+'#quote/le?qId='+this.quoteId;
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
                attributes: {
                    url: qleLink
                }           
        });
    }

    handleChange(event){
        this.selectedValue = event.detail.value;
        this.productSelected = true;
    }

    viewConfiguredProduct(event){
        this.buttonsDisabled = true;
        this.isLoading = true;
        viewConfiguredProduct({ quoteLineId: this.selectedValue })
        .then(result => {
            if(result.isSuccess){
                let configuratorId = result.result;
                this.handleNavigate(configuratorId, false);
            } else {
                this.showToast('error', 'error getting configurator Id.', 'error');
            }       
        })
        .catch(error => {
            this.showToast('error', 'error getting product information.', 'error');
        })
    }

    reconfigureProduct(event){
        this.buttonsDisabled = true;
        this.isLoading = true;
        editConfiguredProduct({ quoteLineId: this.selectedValue })
        .then(result => {
            console.log(result);
            if(result.isSuccess){
                let configuratorId = result.result;
                this.handleNavigate(configuratorId, true);
            } else {
                this.showToast('error', 'error getting configurator Id.', 'error');
            }       
        })
        .catch(error => {
            this.showToast('error', 'error getting product information.', 'error');
        })
    }

    handleNavigate(configuratorId, edit){
        let hostName = window.location.hostname;
        let baseUrl = `https://${hostName}/lightning/n/cdcpc__RuptureDisc_PartConfigurator?c__d=1`;
        let viewLink = `${baseUrl}&c__s=e&c__i=${configuratorId}&c__b=${this.quoteId}`;
        let editLink = `${baseUrl}&c__s=i&c__i=${configuratorId}`;
        let configuratorLink = !!edit ? editLink : viewLink;
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
                attributes: {
                    url: configuratorLink
                }
        }, true);
    }

    showToast(title, message, variant){
        this.dispatchEvent(new ShowToastEvent({
            title, message, variant
        }));
    }

}