import { LightningElement,api, track ,wire} from 'lwc';
import getQuoteLineData from '@salesforce/apex/CustomQuoteLineItemsLwcController.getQuoteLineData';
import saveQuoteLine from '@salesforce/apex/CustomQuoteLineItemsLwcController.saveQuoteLine';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id';
const FIELDS = [
  'User.Name',
  'User.IsPortalEnabled'
];
export default class CustomQuoteLineItems extends LightningElement {
     @api recordId;
     @track qlineItems = [];
     qlineItemsMainData = [];
     metaDataAction = [];
     bShowModal = false;
     selectedActionName = '';
     lstActionQuoteLineFields = []; 
     userId = Id;
     selectedQlId = '';
    connectedCallback(){
       this.fetchQLines();
    }

    currentUserInfo = {};

    fetchQLines(){
      getQuoteLineData({quoteId: this.recordId})
      .then(data => {
        const objData = data;
                    console.log('###====>' + JSON.stringify(objData));			
                    this.metaDataAction = JSON.parse(JSON.stringify(data.lstQlaMDT));			
                   this.qlineItems = JSON.parse(JSON.stringify(data.qlLineList));
                   this.qlineItemsMainData = JSON.parse(JSON.stringify(data.qlLineList));
                   

                    // this.qlineItems = data.slice();

                    /*data.forEach(function (ql) {  
                       ql.bDisableDisAmount = false;
                       ql.bDisableDiscount = false;
                    });*/
              /*  let allRec = [];    
                var mLstData = data.slice();
                for(var i=0; i < mLstData.length; i++){
                  let d  = Object.assign({}, obj);
                  allRec.push(mLstData[i]);
                }

               this.qlineItemsMainData = allRec;*/

      })
      .catch(error => {
        alert('Error : ' + JSON.stringify(error));
     });
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

    onDiscountUpdate(event){
      const value = event.target.value;
      const recId = event.target.name;
      console.log('ID ===> '+ recId + 'recIdupdatedDiscount--> ' + value);
     
      const mainData = JSON.parse(JSON.stringify(this.qlineItemsMainData)) ; 
      console.log('!!Main Data ---> ' + JSON.stringify(mainData));
      
      var selectedObj = {};
      for(var i=0; i < mainData.length; i++){
         if(mainData[i].ql.Id == recId){
           selectedObj = mainData[i];
           break;
         }
      }
      

       console.log('!!Main Data after---> ' + JSON.stringify(mainData));
       console.log('Main Data ---> ' + JSON.stringify(selectedObj));
     

      if(selectedObj.ql.Discount__c == value){
         return;
      }
      let hasChanged = false;
      console.log('!!Main Data just before ---> ' + JSON.stringify(mainData));
      
      let updatedData = JSON.parse(JSON.stringify(this.qlineItems)) ;
      
      for(var i=0; i < updatedData.length; i++){
        if(updatedData[i].ql.Id == recId){
          hasChanged = true;
          updatedData[i].ql.Discount__c = value;
          updatedData[i].ql.Discount_Amount__c = 0;
          console.log('after process ql : ' + JSON.stringify(updatedData[i].ql));     
          break;
        }
      }

      if(hasChanged){
        console.log('!!Main Data =>=>---> ' + JSON.stringify(this.qlineItemsMainData));
        this.qlineItems = updatedData;
        console.log('!!Main Data $$$ ---> ' + JSON.stringify(mainData));
      }
      
    }
    
    navigateToQL(event){
       var qId = event.target.getAttribute("data-label");
       let isPortalUser1 = this.currentUserInfo.fields.IsPortalEnabled.value;
       //var bool = 
       //if(event.target.getAttribute("data-reroutng")=='false'){
       // window.open('/lightning/r/SBQQ__QuoteLine__c/' + qId + '/view'   , "_blank");

        if (isPortalUser1) {
          window.open('/s/detail/' + qId, "_blank");
        } else {
          window.open('/lightning/r/SBQQ__QuoteLine__c/' + qId + '/view'   , "_blank");
        }
       //}else{
        // alert('Access Denied');
      // }
    }

    onDiscountAmountUpdate(event){
        const value = event.target.value;
        const recId = event.target.name;
        console.log('ID ===> '+ recId + 'recIdupdatedDiscount--> ' + value);
        const mainData = JSON.parse(JSON.stringify(this.qlineItemsMainData)) ;
        var selectedObj =  mainData.filter(function(oQL) {
            return oQL.ql.Id ==  recId;
         });  
           console.log('Main Data ---> ' + JSON.stringify(selectedObj));
           
           if(selectedObj[0].ql.Discount_Amount__c == value){
            return;
           }
           
           
           let updatedData = JSON.parse(JSON.stringify(this.qlineItems)) ;
        let hasChanged = false;
        updatedData.forEach(function (ql) {  
          if(ql.ql.Id == recId){
              hasChanged = true;
              ql.ql.Discount_Amount__c = value;
              ql.ql.Discount__c = 0;
            //  ql.bDisableDiscount = true;
              console.log('after process ql : ' + JSON.stringify(ql));     
              return false;
          }   
        });
        console.table(updatedData);
        if(hasChanged){
            this.qlineItems = updatedData; 
        }
        
    }

    saveRow(event){
        const value = event.target.name; 
        var selectedObj =  this.qlineItems.filter(function(oQL) {
            return oQL.ql.Id ==  value;
         });
        console.log(JSON.stringify(selectedObj));

        saveQuoteLine({ql: selectedObj[0].ql})
        .then(data => {            
            const evt = new ShowToastEvent({
                title: 'Success',
                message: 'Record has been updated successfully ',
                variant: 'success',
            });
            this.dispatchEvent(evt);
            this.fetchQLines();
        })
        .catch(error => {
          console.log(JSON.stringify(error));
          if(error == undefined){
              return;
          }
          
          const evt = new ShowToastEvent({
            title: 'Review the errors on this page.',
            message: error.body.message,
            variant: 'error',
        });
        this.dispatchEvent(evt);

         });

    }
    

    onCustomerLeadTimeUpdate(event){
        const value = event.target.value;
        const recId = event.target.name;
        let updatedData = JSON.parse(JSON.stringify(this.qlineItems)) ;
        updatedData.forEach(function (ql) {  
            if(ql.ql.Id == recId){
                ql.ql.Customer_Leadtime__c = value;
                ql.ql.Product_Planning_Status__c = 'Yes';
                return false;
            }   
          });
          this.qlineItems = updatedData; 
    }


    undoRow(event){
        const value = event.target.name; 
        console.log('value===> ' + value);
        const mainData = JSON.parse(JSON.stringify(this.qlineItemsMainData)) ;
        console.log('undo !!Main Data ---> ' + JSON.stringify(mainData));
        let oldRec =  {};
        for(var i=0; i<mainData.length; i++){
          if(mainData[i].ql.Id == value){
            oldRec = mainData[i].ql;
           break;
          }
        }
        
         console.log('oldRec===> ' + JSON.stringify(oldRec));
         let updatedData = JSON.parse(JSON.stringify(this.qlineItems)) ;
         updatedData.forEach(function (ql,idx) {  
            if(ql.ql.Id == value){
                console.log('in');
                updatedData[idx].ql = oldRec;
                return false;
            }   
          });
          console.log(JSON.stringify(updatedData));
          this.qlineItems = updatedData; 
    }


    configProd(event){
      const whichAction = event.detail.value;
      this.selectedActionName = whichAction;
      const value = event.target.name; 
      this.selectedQlId = value;
      if(whichAction == 'Configure'){
     
      var selectedObj =  this.qlineItems.filter(function(oQL) {
        return oQL.ql.Id ==  value;
       });

      console.log(JSON.stringify(selectedObj)+'selected Obj');
      console.log('recordId ====> ' + this.recordId);
      
      const objData = selectedObj[0];
      console.log('###====>' + JSON.stringify(objData));						
      //if(!(objData.disableLineItem)){
        const configId = objData.rD.Id;						
        console.log('on COnfig == ' + configId);

        let isPortalUser = this.currentUserInfo.fields.IsPortalEnabled.value;
        if (objData.ql.SBQQ__ProductCode__c !== undefined && objData.ql.SBQQ__ProductCode__c === 'RD') {
          if (isPortalUser) {
            window.open('/s/rupturedisccmp?quoteId=' + this.recordId + '&configId=' + configId, "_blank");
          } else {
            window.open('/lightning/cmp/c__ruptureDiscCmp?c__configId=' + configId + '&c__quoteId=' + this.recordId, "_blank");
          }

        } else if (objData.ql.SBQQ__ProductCode__c !== undefined && objData.ql.SBQQ__ProductCode__c === 'BGR') {

          if (isPortalUser) {
            window.open('/s/blanketgasregulatorcmp?quoteId=' + this.recordId + '&configId=' + configId, "_blank");
          } else {
            window.open('/lightning/cmp/c__BlanketGasRegulatorCmp?c__configId=' + configId + '&c__quoteId=' + this.recordId, "_blank");
          }

        } else if (objData.ql.SBQQ__ProductCode__c !== undefined && objData.ql.SBQQ__ProductCode__c === 'RLFVLV') {
          if (isPortalUser) {
            window.open('/s/reliefvalvecmp?quoteId=' + this.recordId + '&configId=' + configId, "_blank");
          } else {
            window.open('/lightning/cmp/c__reliefValveCmp?c__configId=' + configId + '&c__quoteId=' + this.recordId, "_blank");
          }

        } else if (objData.ql.SBQQ__ProductCode__c !== undefined && objData.ql.SBQQ__ProductCode__c === 'FlameProducts') {
          if (isPortalUser) {
            window.open('/s/flameproductscmp?quoteId=' + this.recordId + '&configId=' + configId, "_blank");
          } else {
            window.open('/lightning/cmp/c__flameProductsCmp?c__configId=' + configId + '&c__quoteId=' + this.recordId, "_blank");
          }
        } else if (objData.ql.SBQQ__ProductCode__c !== undefined && objData.ql.SBQQ__ProductCode__c === 'HLD') {

          let encodeURI = '';
          let sUrl = '/apex/ConfigHolders?id=' + configId + '&qId=' + objData.ql.Id;
          if (isPortalUser) {
            encodeURI = '/s/sfdcpage/' + encodeURIComponent(sUrl);
          } else {
            encodeURI = sUrl;
          }
          console.log('in navigation to holder apex ', configId);
          window.open(encodeURI, "_blank");
          
        } else if (objData.ql.SBQQ__ProductCode__c !== undefined && objData.ql.SBQQ__ProductCode__c === 'WGB') {

          console.log('in navigation to holder apex ', configId);
          let encodeURI = '';
          let sUrl = '/apex/ConfigWGBProduct?qId=' + objData.ql.Id;
          if (isPortalUser) {
            encodeURI = '/s/sfdcpage/' + encodeURIComponent(sUrl);
          } else {
            encodeURI = sUrl;
          }
          window.open(encodeURI, "_blank");
          
        } else if (objData.ql.SBQQ__ProductCode__c !== undefined && objData.ql.SBQQ__ProductCode__c === 'PS') {
          let encodeURI = '';
          let sUrl = '/apex/ConfigPartSelector?Id=' + configId;
          if (isPortalUser) {
            encodeURI = '/s/sfdcpage/' + encodeURIComponent(sUrl);
          } else {
            encodeURI = sUrl;
          }
          window.open(encodeURI, "_blank");
          
        } else {
          this.dispatchEvent(
            new ShowToastEvent({
              title: 'Configuration error',
              message: 'No Configuration for ' + objData.ql.SBQQ__ProductCode__c,
              variant: 'error',
            }),
          );
        }
     /* }else{
        alert('Sorry Access is Denied');
      }*/
    }
     else  if(whichAction == 'Output'){
      
      window.open(event.target.getAttribute('data-outputurl'), "_blank");    
      
     }
    else{
      this.bShowModal = true;
      
      const metaDataAction = JSON.parse(JSON.stringify(this.metaDataAction)) ;
      console.log('metaDataAction=====> ' + JSON.stringify(metaDataAction));
      var tempFieldList = [];
      for(var i = 0; i < metaDataAction.length; i++){
        let oAction = metaDataAction[i];
        if(oAction.Action_Name__c == whichAction){
          
          if(oAction.Quote_Line_Action_Details__r != undefined){
            oAction.Quote_Line_Action_Details__r.sort(function (a, b) {
              return a.Order__c - b.Order__c;
            });

            for(var x = 0; x < oAction.Quote_Line_Action_Details__r.length;x++){
              console.log('####' + JSON.stringify(oAction.Quote_Line_Action_Details__r[x]));
              tempFieldList.push({fldApi : oAction.Quote_Line_Action_Details__r[x].Field_API__c,
                                  isReadOnly : oAction.Quote_Line_Action_Details__r[x].readOnly__c,
                                  isEmptySpace : oAction.Quote_Line_Action_Details__r[x].Field_API__c == 'BLANK' ? true : false,
                                } );
            }
          }
          break;
        }  
      }
      this.lstActionQuoteLineFields =  tempFieldList;
    
    }
    }

    closeModal() {    
      this.bShowModal = false;
  }

    handleSuccess(){
      this.dispatchEvent(
        new ShowToastEvent({
          title: 'Success',
          message: 'Record has been updated successfully.',
          variant: 'success',
        }),
      );
      this.closeModal();
   }
}