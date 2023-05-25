import { LightningElement,wire, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getProductData from '@salesforce/apex/RuptureDiscController.getProductData';
import upsertQuoteLineItem from '@salesforce/apex/RuptureDiscController.upsertQuoteLineItem';
import ProductImages from '@salesforce/resourceUrl/ProductImages';
import branding_10Sep2020 from '@salesforce/resourceUrl/branding_10Sep2020';
import Brand_Logs from '@salesforce/resourceUrl/branding';
import { getRecord } from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id';
//added by piyush soni @6/23/2020 
import getQuoteLineData from '@salesforce/apex/RuptureDiscController.getQuoteLineData';
import getQuoteLineDetails from '@salesforce/apex/RuptureDiscController.getQuoteLineDetails';

const FIELDS = [
    'User.Name',
    'User.IsPortalEnabled'
];

export default class LwcProductSelection extends NavigationMixin(LightningElement) {
	@track isProductDataAvailable = true;
	@track products;
	@api recordId;
	@track addProductFlag = false;
	bShowSpinner = false;
	ruptureDiscImage = ProductImages + '/ProductImages/RuptureDisc.jpg';
	flameArresterImage = ProductImages + '/ProductImages/FlameArrester.jpg';
	blanketGasRegulatorImage = ProductImages + '/ProductImages/BlanketGasRegulator.jpg';
	wasteGasBurnerImage = ProductImages + '/ProductImages/WasteGasBurner.png';
	reliefValveGrothImage = ProductImages + '/ProductImages/1220A_1.png';

	RD_CDC = branding_10Sep2020 + '/HPX-1.jpg';
	RD_LAMOT = branding_10Sep2020 + '/LaMot_STD_ASME.jpg';

	HLD_CDC = branding_10Sep2020 + '/HPX_Double_Disc_Holder_2.jpg';
	HLD_LAMOT = branding_10Sep2020 + '/lamotinsertholder.jpg';

	PS_CDC = branding_10Sep2020 + '/Enviro_Guard.jpg';
	PS_GROTH = branding_10Sep2020 + '/6000.jpg';
	PS_LAMOT = branding_10Sep2020 + '/Universal_BDI_1.jpg';
	PS_LVA = branding_10Sep2020 + '/LH12-01.jpg';

	RV_GROTH = branding_10Sep2020 + '/1220A_1.jpg';
	RV_LVA = branding_10Sep2020 + '/L1200A_1.jpg';

	FA_GROTH = branding_10Sep2020 + '/L76L.jpg';
	FA_LVA = branding_10Sep2020 + '/L76L.jpg';

	BGR_GROTH = branding_10Sep2020 + '/3011_1.jpg';
	BGR_LVA = branding_10Sep2020 + '/L3011_1.jpg';

	WGB_GROTH = branding_10Sep2020 + '/8391.jpg';

	brand;
	brandUrl = Brand_Logs + '/';
	userId = Id;
	currentUserInfo = {};

	@wire(getRecord, { recordId: '$userId', fields: FIELDS })
    oUser({ error, data }) {
        if (data) {
			console.log('===> USER' + JSON.stringify(data));
			this.currentUserInfo = data;
        } else if (error) {
            console.log('===> error' + JSON.stringify(error));
        }
	}
	
	@wire(getProductData, {quoteId: '$recordId'})
	wiredProducts({ error, data }) {
		console.log('record id in select comp ', this.recordId);
		if (data) {
			this.products = [];
			data.forEach(element =>{
				this.brand = element.Family;
				let prodImgURL;
				console.log('Main Products -->> ',element.Name);
				if(this.brand && (this.brand.includes("CDC") || this.brand.includes("cdc"))){
					console.log('CDC Brand Products -->> ',element.Name);					
					if(element.Name === 'Rupture Disc'){
						prodImgURL = this.RD_CDC;
					} else if(element.Name === 'Holders'){
						prodImgURL = this.HLD_CDC;
					} else if(element.Name === 'Part Selector'){
						prodImgURL = this.PS_CDC;
					}
					console.log('CDC Products URL-->> ',prodImgURL);
				} else if(this.brand && (this.brand.includes("Groth") || this.brand.includes("groth"))){
					console.log('Groth Brand Products -->> ',element.Name);
					if(element.Name === 'Relief Valves'){
						prodImgURL = this.RV_GROTH;
					} else if(element.Name === 'Flame Products'){
						prodImgURL = this.FA_GROTH;
					} else if(element.Name === 'Blanket Gas Regulator'){
						prodImgURL = this.BGR_GROTH;
					} else if(element.Name === 'Waste Gas Burner'){
						prodImgURL = this.WGB_GROTH;
					} else if(element.Name === 'Part Selector'){
						prodImgURL = this.PS_GROTH;
					}
					console.log('Groth Products URL-->> ',prodImgURL);
				} else if(this.brand && (this.brand.includes("LaMOT") || this.brand.includes("lamot") || this.brand.includes("LAMOT"))){
					console.log('LaMOT Brand Products -->> ',element.Name);
					if(element.Name === 'Rupture Disc'){
						console.log('LaMOT RD Products -->> ',element.Name);
						prodImgURL = this.RD_CDC;
					} else if(element.Name === 'Holders'){
						prodImgURL = this.HLD_LAMOT;
					} else if(element.Name === 'Part Selector'){
						prodImgURL = this.PS_LAMOT;
					}
					console.log('LaMOT Products URL-->> ',prodImgURL);
				} else if(this.brand && (this.brand.includes("LVA") || this.brand.includes("lva"))){
					console.log('LVA Brand Products -->> ',element.Name);
					if(element.Name === 'Relief Valves'){
						prodImgURL = this.RV_LVA;
					} else if(element.Name === 'Flame Products'){
						prodImgURL = this.FA_LVA;
					} else if(element.Name === 'Blanket Gas Regulator'){
						prodImgURL = this.BGR_LVA;
					}  else if(element.Name === 'Waste Gas Burner'){
						prodImgURL = this.WGB_GROTH;
					} else if(element.Name === 'Part Selector'){
						prodImgURL = this.PS_LVA;
					}
					console.log('LVA Products URL-->> ',prodImgURL);
				} 
				// else if(element.Name === 'Blanket Gas Regulator'){
				// 	prodImgURL = this.blanketGasRegulatorImage;
				// } else if(element.Name === 'Rupture Disc CDC'){
				// 	prodImgURL = this.ruptureDiscImage;
				// } else if(element.Name === 'Waste Gas Burner'){
				// 		prodImgURL = this.wasteGasBurnerImage;
				// } else if(element.Name === 'Relief Valves'){
				// 		prodImgURL = this.reliefValveGrothImage;
				// } else if(element.Name === 'Holders'){
				// 	prodImgURL = this.flameArresterImage;
				// } else if(element.Name === 'Flame Products'){
				// 	prodImgURL = this.flameArresterImage;
				// }
				let newElement = {Id:element.Id,ProductCode:element.ProductCode,Description:element.Description,Name:element.Name,ImageURL:prodImgURL};
				this.products.push(newElement);
				
			});
			if(this.products.length > 0){
				this.isProductDataAvailable = true;
				if(this.brand && (this.brand.includes("Groth") || this.brand.includes("groth"))){
					this.brandUrl += 'grothlogo.gif';
				}else if(this.brand && (this.brand.includes("CDC") || this.brand.includes("cdc"))){
					this.brandUrl += 'cdclogo.gif';
				}else if(this.brand && (this.brand.includes("LVA") || this.brand.includes("lva"))){
					this.brandUrl += 'LVA_logo.png';
				}else if(this.brand && (this.brand.includes("LaMOT") || this.brand.includes("lamot"))){
					this.brandUrl += 'lamotlogo.gif';
				}else{
					this.brandUrl += this.brand+'.gif';
				}
				console.log('this.brandUrl ',this.brandUrl);
			}else{
				this.isProductDataAvailable = false;
			}
		   /* this.products = data;
			this.error = undefined;*/
		} else if (error) {
			this.error = error;
			this.products = undefined;
		}
	}
	handleAddProduct(){
		this.addProductFlag = true;
	}
	handleProductSelection(event) {
		this.bShowSpinner = true;
		window.console.log('Prod Id ', event.target.dataset.product);
		window.console.log('pcode ', event.target.dataset.pcode);
		const psCode = event.target.dataset.pcode;
		window.console.log('quote Id ',this.recordId);
		let quoteLineObj = { 'sobjectType': 'SBQQ__QuoteLine__c' };
		quoteLineObj.SBQQ__Quote__c = this.recordId;
		quoteLineObj.SBQQ__Product__c = event.target.dataset.product;
		upsertQuoteLineItem({quoteLine: quoteLineObj, productCode:event.target.dataset.pcode})
		.then(result => {
			console.log('result == ',JSON.stringify(result));
			let quote_id = result['QUOTE_ID'];
			let quoteline_id = result['QUOTELINE_ID'];

			if(quote_id === this.recordId){
				this.addProductFlag = false;
				const productAddEvent = new CustomEvent("productadd", {
					detail: false
				});
				this.dispatchEvent(productAddEvent);
				
				// added by piyush, to skip list view for Part selector @6/23/2020
				/*if(psCode === 'PS'){ 
					getQuoteLineData({quoteId: this.recordId})
					.then(data => {
					  //console.log(JSON.stringify(data));
					  const configId = data[data.length - 1].rD.Id; 
					  console.log('configId---> '  + configId);
					  let encodeURI = '';
					  let sUrl = '/apex/ConfigPartSelector?Id='+ configId;
					  let isPortalUser = this.currentUserInfo.fields.IsPortalEnabled.value;
					  if(isPortalUser){
						encodeURI  = '/s/sfdcpage/' + encodeURIComponent(sUrl);
						  
					  }else{
						  encodeURI = sUrl;
					  } 
					  window.open(encodeURI, "_parent");

					})
					.catch(error => {
						alert('Error : ' + JSON.stringify(error));
					});

				}else{
					this.navigateToQuoteLinePage();
				}*/


				//############ added by piyush @6/24/2020#################

				getQuoteLineDetails({quoteLineId: quoteline_id})
					.then(data => {
						const objData = data[data.length - 1];
						console.log('###====>' + JSON.stringify(objData));						
						const configId = objData.rD.Id;						
						console.log('on COnfig == ' + configId);

						let isPortalUser = this.currentUserInfo.fields.IsPortalEnabled.value;
						if (objData.ProdCode !== undefined && objData.ProdCode === 'RD') {
							if (isPortalUser) {
								window.open('/s/rupturedisccmp?quoteId=' + this.recordId + '&configId=' + configId, "_parent");
							} else {
								window.open('/lightning/cmp/c__ruptureDiscCmp?c__configId=' + configId + '&c__quoteId=' + this.recordId, "_parent");
							}

						} else if (objData.ProdCode !== undefined && objData.ProdCode === 'BGR') {

							if (isPortalUser) {
								window.open('/s/blanketgasregulatorcmp?quoteId=' + this.recordId + '&configId=' + configId, "_parent");
							} else {
								window.open('/lightning/cmp/c__BlanketGasRegulatorCmp?c__configId=' + configId + '&c__quoteId=' + this.recordId, "_parent");
							}

						} else if (objData.ProdCode !== undefined && objData.ProdCode === 'RLFVLV') {
							if (isPortalUser) {
								window.open('/s/reliefvalvecmp?quoteId=' + this.recordId + '&configId=' + configId, "_parent");
							} else {
								window.open('/lightning/cmp/c__reliefValveCmp?c__configId=' + configId + '&c__quoteId=' + this.recordId, "_parent");
							}

						} else if (objData.ProdCode !== undefined && objData.ProdCode === 'FlameProducts') {
							if (isPortalUser) {
								window.open('/s/flameproductscmp?quoteId=' + this.recordId + '&configId=' + configId, "_parent");
							} else {
								window.open('/lightning/cmp/c__flameProductsCmp?c__configId=' + configId + '&c__quoteId=' + this.recordId, "_parent");
							}
						} else if (objData.ProdCode !== undefined && objData.ProdCode === 'HLD') {

							let encodeURI = '';
							let sUrl = '/apex/ConfigHolders?id=' + configId + '&qId=' + objData.ql.Id;
							if (isPortalUser) {
								encodeURI = '/s/sfdcpage/' + encodeURIComponent(sUrl);
							} else {
								encodeURI = sUrl;
							}
							console.log('in navigation to holder apex ', configId);
							window.open(encodeURI, "_parent");
							/*this[NavigationMixin.Navigate]({
								type: 'standard__webPage',
								attributes: {
									url: encodeURI
								}
							},
								true // Replaces the current page in your browser history with the URL
							);*/
						} else if (objData.ProdCode !== undefined && objData.ProdCode === 'WGB') {

							console.log('in navigation to holder apex ', configId);
							let encodeURI = '';
							let sUrl = '/apex/ConfigWGBProduct?qId=' + objData.ql.Id;
							if (isPortalUser) {
								encodeURI = '/s/sfdcpage/' + encodeURIComponent(sUrl);
							} else {
								encodeURI = sUrl;
							}
							window.open(encodeURI, "_parent");
							/*this[NavigationMixin.Navigate]({
								type: 'standard__webPage',
								attributes: {
									url: encodeURI
								}
							},
								true // Replaces the current page in your browser history with the URL
							);*/
						} else if (objData.ProdCode !== undefined && objData.ProdCode === 'PS') {
							let encodeURI = '';
							let sUrl = '/apex/ConfigPartSelector?Id=' + configId;
							if (isPortalUser) {
								encodeURI = '/s/sfdcpage/' + encodeURIComponent(sUrl);
							} else {
								encodeURI = sUrl;
							}
							window.open(encodeURI, "_parent");
							/*this[NavigationMixin.Navigate]({
								type: 'standard__webPage',
								attributes: {
									url: encodeURI
								}
							},
								true // Replaces the current page in your browser history with the URL
							);*/
						} else {
							this.dispatchEvent(
								new ShowToastEvent({
									title: 'Configuration error',
									message: 'No Configuration for ' + objData.ProdCode,
									variant: 'error',
								}),
							);
						}

					})
					.catch(error => {
						alert('Error : ' + JSON.stringify(error));
						this.bShowSpinner = false;
					});

				//###############added by piyush @6/24/2020 ##############
				
			}
		})
		.catch(error => {
			console.log(error);
			this.bShowSpinner = false;
		});
	
	}

	navigateToQuoteLinePage() {
		//window.open('/apex/customQuoteLinePage?id='+this.recordId, "_self");

		let isPortalUser = this.currentUserInfo.fields.IsPortalEnabled.value;
        console.log('---IsPortalEnabled ->' + isPortalUser );
		if(isPortalUser){
			window.open('/s/productselectioncmp?quoteId='+this.recordId, "_parent");
		}
		else{
			window.open('/lightning/cmp/c__productSelectionCmp?c__quoteId='+this.recordId, "_parent");
		}
		
		/* this[NavigationMixin.Navigate]({ // commented by piyush @14 may 2020
			"type": "standard__component",
			"attributes": {
				"componentName": "c__productSelectionCmp"
			},
			"state": {
				"c__quoteId": this.recordId 
			}
		});*/
		/*
		// Navigate to a URL
		console.log('in navigation method');
		this[NavigationMixin.Navigate]({
			type: 'standard__webPage',
			attributes: {
				url: '/apex/customQuoteLinePage?id='+this.recordId
			}
		},
		true // Replaces the current page in your browser history with the URL
	  );*/
	}
	
}