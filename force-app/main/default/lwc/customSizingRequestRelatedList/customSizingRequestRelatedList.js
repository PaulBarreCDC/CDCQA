import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import Id from '@salesforce/user/Id';
import getUserSizingRequests from '@salesforce/apex/PartnerCommunityController.getUserSizingRequests';

const columns = [
    { label: 'Name', fieldName: 'cdcpc__ProjectName__c' },
    { label: 'Brand', fieldName: 'cdcpc__Brand__c' },
    { label: 'Ready to submit for quote', fieldName: 'cdcpc__Is_Ready_for_Quote__c' },
    { label: 'Processed to quote', fieldName: 'cdcpc__Processed_to_quote__c' }
]

export default class CustomSizingRequestRelatedList extends NavigationMixin(LightningElement) {
    loading = false;
    userSizingRequests = [];
    columns = columns;
    showModal = false;

    connectedCallback(){
        this.getUserSizingRequests();
        this.recordLoading();
    }

    getUserSizingRequests(){
        let userId = Id;
        getUserSizingRequests({ userId : userId })
        .then(result => {
            this.userSizingRequests = result;
            this.recordLoaded();
        })
        .catch(error => {
            console.log('error getting records: ' + JSON.stringify(error));
            this.recordLoaded();
        });
    }

    recordLoading(){
        console.log(`recordLoading: ${this.loading}`);
        if(!this.loading){
            this.loading = true;
        }
    }

    recordLoaded(){
        console.log(`recordLoaded: ${this.loading}`);
        if(this.loading){
            this.loading = false;
        }
    }

    openModal(){
        this.showModal = true;
        console.log(`openModal = ${this.showModal}`);
    }

    closeModal(event){
        this.showModal = false;
        console.log(`closeModal = ${this.showModal}`);
    }
}