({
    doInit : function(component, event, helper) {
        component.set(
            "v.columns",
            [
                {
                    "fieldName":"Delivery_Number__c",
                    "label":"Delivery No",
                    "type": "number"
                },
                {
                    "fieldName":"SBQQ__Quantity__c",
                    "editable":"true",
                    "label":"Quantity",
                    "type": "number"
                },
                {
                    "fieldName":"Planned_Delivery_Date__c",
                    "editable":"true",
                    "label":"Planned Delivery Date",
                    "type": "text"
                },
                {
                    "type": 'action', 
                    "typeAttributes": { 
                        "rowActions": [{
                            "label" : "Delete",
                            "name" : "Delete"
                        }],
                        "menuAlignment": 'left'
                    }
                }
            ]
        );
        helper.retrieveQuoteLines(component, event, helper);
        //retrieveRecords
    },
    cancelInfo : function(component, event, helpler) {
        console.log("Cancelled");
    },
    addInfo : function(component, event, helpler) {
        var deliveryList = component.get("v.deliveryList");
        
        deliveryList.push({
            "Name": "",
            "Delivery_Number__c": deliveryList.length + 1,
            "SBQQ__Quantity__c": "",
            "Planned_Delivery_Date__c": "",
            "SBQQ__QuoteLine__c": ""
        });
        component.set("v.deliveryList", deliveryList);
    },
    deleteInfo : function(component, event, helper) {
        var idx = event.getSource().get("v.name");
        var deliveryList = component.get("v.deliveryList");
        // Check for ID; IF no ID, just delete the row
        if(deliveryList[idx].Id === undefined) {
            deliveryList.splice(idx,1);
            component.set("v.deliveryList", deliveryList);
        } else {
            console.log("Delete from DB");
            helper.deleteQuoteLine(component, event, helper, idx);
        }
    },
    saveInfo : function(component, event, helper) {
        //validate quantity
        var originalQty = component.get("v.originalQty");
        var deliveryList = component.get("v.deliveryList");
        for(var i=0; i<deliveryList.length; i++) {
            originalQty -= deliveryList[i].SBQQ__Quantity__c;
        }
        if(originalQty === 0) {
            helper.saveQuoteLines(component, event, helper);
        } else {
            helper.showToast('error','dismissible','Error',"The sum of all quantities must equal the original line item's quantity!");
        }
    }
})