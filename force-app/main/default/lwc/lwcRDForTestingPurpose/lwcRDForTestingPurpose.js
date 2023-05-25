import { LightningElement, track,api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';



export default class LwcRDForTestingPurpose extends NavigationMixin {
    @api recordId;
    @api quoteId;
    @track reliefTypeOptions;

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
}