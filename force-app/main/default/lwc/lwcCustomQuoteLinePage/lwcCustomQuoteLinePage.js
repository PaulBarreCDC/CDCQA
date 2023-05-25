import { LightningElement, api, wire, track } from 'lwc';
import getQuoteLineData from '@salesforce/apex/RuptureDiscController.getQuoteLineData';
import getQuoteLineDataImpa from '@salesforce/apex/RuptureDiscController.getQuoteLineDataImpa';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id';
const FIELDS = [
    'User.Name',
    'User.IsPortalEnabled'
];

const actions = [
    { label: 'Configure', name: 'configure_product' }
];
export default class lwcCustomQuoteLinePage extends NavigationMixin(LightningElement) {
    userId = Id;
    @api recordId;
    @track error;
    @track data ;
    @track showAddProduct = false;
    @track dataWithScroll = false;
    currentUserInfo = {};
    @track columns = [{
        label: 'Line Name',
        fieldName: 'quoteLineURL',
        type: 'url',
        typeAttributes: {label:{ fieldName: 'Name' },target: '_blank' }
    }
    // {
    //     label: 'Quote',
    //     fieldName: 'quoteURL',
    //     type: 'url',
    //     typeAttributes: { value: { fieldName: 'quoteURL' },label:{ fieldName: 'quoteName' },target: '_blank' }
    // }
    ,{
        label: 'Redirection to Outputs',
        fieldName: 'OutputURL',
        type: 'url',
        typeAttributes: { value: { fieldName: 'OutputURL' },label:{ fieldName: 'Outputname' },target: '_blank' }
    },
    // {
    //     label: 'Product',
    //     fieldName: 'productURL',
    //     type: 'text',
    //     typeAttributes: { value: { fieldName: 'productURL' },label:{ fieldName: 'productName' },target: '_blank' }
    // },
    // {
    //     label: 'Product Reference',
    //     fieldName: 'productRefURL',
    //     type: 'url',
    //     typeAttributes: { value: { fieldName: 'productRefURL' },label:{ fieldName: 'productRefName' },target: '_blank' }
    // },
    // {
    //     label: 'Additional Disc. (%)',
    //     fieldName: 'SBQQ__Discount__c',
    //     type: 'percent'
        
    // },
    {
        label: 'Product',
        fieldName: 'Product',
        type: 'text'
        
    },{
        label: 'Discountable Price',
        fieldName: 'discountablePrice',
        type: 'currency'
        
    },{
        label: 'Non Discountable Price',
        fieldName: 'nonDiscountablePrice',
        type: 'currency'
        
    },{
        label: 'Size',
        fieldName: 'size',
        type: 'text'
        
    },{
        label: 'Part Number',
        fieldName: 'partNumber',
        type: 'text'
        
    },{
        label: 'Requires Eng Review',
        fieldName: 'engStatus',
        type: 'text'
        
    },{
        label: 'Requires PP Review',
        fieldName: 'ppStatus',
        type: 'text'
        
    },{
        type: 'action',
        typeAttributes: { rowActions: actions }
    }]

    
	@wire(getRecord, { recordId: '$userId', fields: FIELDS })
    oUser({ error, data }) {
        if (data) {
			console.log('===> USER' + JSON.stringify(data));
			this.currentUserInfo = data;
        } else if (error) {
            console.log('===> error' + JSON.stringify(error));
        }
    }
    
    @wire(getQuoteLineData, {quoteId:'$recordId'})
    wiredQuoteLineData(result){
        this.data=[];
        if(result.data){
            result.data.forEach(value=>{
                this.data.push({
                    ...value.ql,
                    quoteLineName:value.quoteLineName,
                    quoteLineURL:value.quoteLineURL,
                    quoteName:value.quoteName,
                    quoteURL:value.quoteURL,
                    Outputname:value.Outputname,
                    OutputURL:value.OutputURL,
                    productName:value.productName,
                    productRefName:value.productRefName,
                    productURL:value.productURL,
                    productRefURL:value.productRefURL,
                    Product:value.ProdCode,
                    discountablePrice:value.rD.Discountable_Price__c,
                    nonDiscountablePrice:value.rD.Non_Discountable_Price__c,
                    size:value.rD.Size__c,
                    partNumber:value.rD.Part_Number__c,
                    engStatus:value.engStatus,
                    ppStatus:value.ppStatus,
                    configId:value.rD.Id,
                    redirectDisabled:value.redirectDisabled,
                    
                });
                console.log(value.redirectDisabled +'value.redirectDisabled');              
            });
            console.log(JSON.stringify(this.data));
            console.log('Result ', this.data);
            //this.data = {...result.data.comp,vendor:result.data.vendor};
            //window.console.log(JSON.stringify(result.data, null, '\t'));*/
            //window.console.log(JSON.stringify(result.data, null, '\t'));
            if(this.data.length > 12){
                this.dataWithScroll = true;
            }
        }
        else if(result.error){
            this.error = result.error;
        }
    }

    handleRowAction(event) {
        console.log('in handle config ==');
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        //alert(row.redirectDisabled);
        //if(row.redirectDisabled == 'false'){
            switch (actionName) {
                case 'configure_product':
                    this.configureProduct(row);
                    break;
                default:
            }
            /*
        }else{
            alert('Sorry, You dont have access to configure ');
        }
        */
    }

    configureProduct(row) {
        console.log('on  == '+JSON.stringify(row));
        console.log('on COnfig == '+row.configId);
        let isPortalUser = this.currentUserInfo.fields.IsPortalEnabled.value;
        if(row !== undefined && row.SBQQ__ProductCode__c === 'RD'){
        console.log('---IsPortalEnabled ->' + isPortalUser );
		if(isPortalUser){
            window.open('/s/rupturedisccmp?quoteId='+this.recordId + '&configId=' + row.configId, "_parent");  
		}else{
            window.open('/lightning/cmp/c__ruptureDiscCmp?c__configId='+row.configId + '&c__quoteId=' + this.recordId, "_parent");
        }    
        
        /* this[NavigationMixin.Navigate]({
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__ruptureDiscCmp"
                },
                "state": {
                    "c__configId": row.configId,
                    "c__quoteId": this.recordId
                }
            });*/
        }else if(row !== undefined && row.SBQQ__ProductCode__c === 'BGR'){

            console.log('---IsPortalEnabled ->' + isPortalUser );
		    if(isPortalUser){
                window.open('/s/blanketgasregulatorcmp?quoteId='+this.recordId + '&configId=' + row.configId, "_parent");  
		    }else{
                window.open('/lightning/cmp/c__BlanketGasRegulatorCmp?c__configId='+row.configId + '&c__quoteId=' + this.recordId, "_parent");
            } 

            /*this[NavigationMixin.Navigate]({
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__BlanketGasRegulatorCmp"
                },
                "state": {
                    "c__configId": row.configId,
                    "c__quoteId": this.recordId 
                }
            });*/
        }else if(row !== undefined && row.SBQQ__ProductCode__c === 'RLFVLV'){
            if(isPortalUser){
                window.open('/s/reliefvalvecmp?quoteId='+this.recordId + '&configId=' + row.configId, "_parent");  
		    }else{
                window.open('/lightning/cmp/c__reliefValveCmp?c__configId='+row.configId + '&c__quoteId=' + this.recordId, "_parent");
            } 

           /* this[NavigationMixin.Navigate]({
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__reliefValveCmp"
                },
                "state": {
                    "c__configId": row.configId,
                    "c__quoteId": this.recordId 
                }
            });*/
        }else if(row !== undefined && row.SBQQ__ProductCode__c === 'FlameProducts'){
            if(isPortalUser){
                window.open('/s/flameProductsCmp?quoteId='+this.recordId + '&configId=' + row.configId, "_parent");  
		    }else{
                window.open('/lightning/cmp/c__flameProductsCmp?c__configId='+row.configId + '&c__quoteId=' + this.recordId, "_parent");
            }
        }
        else if(row !== undefined && row.SBQQ__ProductCode__c === 'HLD'){
        
            let encodeURI = '';
            let sUrl = '/apex/ConfigHolders?id='+row.configId+'&qId='+row.Id;
            if(isPortalUser){
                encodeURI  = '/sfdcpage/' + encodeURIComponent(sUrl);
            }else{
                encodeURI = sUrl;
            }    
            	console.log('in navigation to holder apex ', row.configId);
                this[NavigationMixin.Navigate]({
                    type: 'standard__webPage',
                    attributes: {
                        url:  encodeURI
                    }
                },
                true // Replaces the current page in your browser history with the URL
            );
        }
        else if(row !== undefined && row.SBQQ__ProductCode__c === 'WGB'){

            console.log('in navigation to holder apex ', row.configId);
            let encodeURI = '';
            let sUrl = '/apex/ConfigWGBProduct?qId='+row.Id;
            if(isPortalUser){
                encodeURI  = '/sfdcpage/' + encodeURIComponent(sUrl);
            }else{
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
    else if(row !== undefined && row.SBQQ__ProductCode__c === 'PS'){
        let encodeURI = '';
        let sUrl = '/apex/ConfigPartSelector?Id='+row.configId;
        if(isPortalUser){
            encodeURI  = '/sfdcpage/' + encodeURIComponent(sUrl);
        }else{
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
//     else if(row !== undefined && row.SBQQ__ProductCode__c === 'RLFVLV'){

//         console.log('in navigation to holder apex ', row.configId);
//         this[NavigationMixin.Navigate]({
//             type: 'standard__webPage',
//             attributes: {
//                 url: '/apex/RVConfig?qId='+row.Id
//             }
//         },
//         true // Replaces the current page in your browser history with the URL
//     );
// }
        else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Configuration error',
                    message: 'No Configuration for '+row.SBQQ__ProductCode__c,
                    variant: 'error',
                }),
            );
        }
        
    }

    handleAddProduct(){
        this.showAddProduct = true;
    }

    handleAddProductCancel(){
        this.showAddProduct = false;
    }

    handleAddProductFromParent(event){
        this.showAddProduct = event.detail;
        getQuoteLineDataImpa({quoteId: this.recordId})
        .then(result => {
            console.log('result in imp : ',JSON.stringify(result));
            this.data=[];
            if(result){
                result.forEach(value=>{
                    this.data.push({...value.ql,quoteName:value.quoteName,
                        quoteURL:value.quoteURL,
                        Outputname:value.Outputname,
                        OutputURL:value.OutputURL,
                        productName:value.productName,
                        productURL:value.productURL,
                        productRefName:value.productRefName,
                        productRefURL:value.productRefURL,
                        Product:value.ProdCode,
                        discountablePrice:value.rD.Discountable_Price__c,
                        nonDiscountablePrice:value.rD.Non_Discountable_Price__c,
                        size:value.rD.Size__c,
                        partNumber:value.rD.Part_Number__c,
                        configId:value.rD.Id});
                                        window.console.log(JSON.stringify('modified ==== ',this.data));
                });
                //this.data = {...result.data.comp,vendor:result.data.vendor};
                //window.console.log(JSON.stringify(result.data, null, '\t'));*/
                window.console.log(JSON.stringify(result, null, '\t'));
                if(this.data.length > 12){
                    this.dataWithScroll = true;
                }
            }else{
                this.error = result.error;
            }
        })
        .catch(error => {
            console.log(error);
        });
        
    }
   
}