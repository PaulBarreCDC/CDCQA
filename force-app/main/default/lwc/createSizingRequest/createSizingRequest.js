import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import UserId from '@salesforce/user/Id';
import PROFILE_NAME from '@salesforce/schema/User.Profile.Name';

export default class CreateSizingRequest extends NavigationMixin(LightningElement) {
    loading = false;
    userId = UserId;
    error;
    guestUserProfile = 'CDC Public Community User';
    isGuestUser = false;
    sizingRequestId;

    connectedCallback(){
        this.recordLoading();
    }

    @wire(getRecord, { recordId: '$userId', fields: [PROFILE_NAME] })
    userInfo({ error, data }) {
        if(error) {
            this.showToast(`error`, `Error getting user record`, `error`);
            this.error = error;
            this.recordLoaded();
        } else if(data) {
            let profileName = data.fields.Profile.value.fields.Name.value;
            this.isGuestUser = profileName === this.guestUserProfile ? true : false;
            this.recordLoaded();
        }
    }

    recordLoading(){
        this.loading = true;
    }

    recordLoaded(){
        if(this.loading){
            this.loading = false;
        }
        this.dispatchEvent(new CustomEvent('recordloaded'));
    }

    recordSubmit(event){
        this.loading = true;
    }

    handleSuccess(event){
        this.sizingRequestId = event.detail.id;
        this.showToast(`Success`, `New Sizing Request record created.`, `success`);
        let destination = this.isGuestUser ? 'community-configurator' : 'new-record-internal';
        this.handleNavigate(destination);       
    }

    handleNavigate(destination){
        switch (destination) {
            case 'community-configurator' :
                this[NavigationMixin.Navigate]({
                    type: "comm__namedPage",
                    attributes: {
                        name: "PartConfiguratorLauncher__c",
                    },
                    state: {
                        "c__d": "1",
                        "c__s": "s",
                        "c__i": this.sizingRequestId
                    }
                }, true);
                break;
            case 'new-record-internal' :
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        actionName: 'view',
                        recordId: this.sizingRequestId
                    }
                }, true);
                break;
            case 'object-home-internal' :
                this[NavigationMixin.Navigate]({
                    type: 'standard__objectPage',
                    attributes: {
                        actionName: 'list',
                        objectApiName: 'cdcpc__SizingRequest__c'
                    }
                }, true);
                break;
        }       
    }

    hideModal(event){
        this.showModal = false;
        if(this.isGuestUser){
            this.dispatchEvent(new CustomEvent('closequickaction'));
        } else {
            this.handleNavigate('object-home-internal');
        }        
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title,
            message,
            variant
        }));
    }
}