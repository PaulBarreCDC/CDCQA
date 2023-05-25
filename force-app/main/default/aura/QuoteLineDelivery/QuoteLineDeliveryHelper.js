({
    serverAction : function(component, methodName, params, callback) {
        component.set("v.showSpinner",true);
        var action = component.get("c." + methodName);
        if (params) {
            action.setParams(params);
        }
        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    showToast : function(type, mode, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "mode": mode,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    },
    retrieveQuoteLines : function(component, event, helper) {
        helper.serverAction(
            component,
            'retrieveRecords',
            {
                'qliId':component.get("v.recordId")
            },
            function(response) {
                component.set("v.showSpinner",false);
                let state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    console.log(resp);
                    if(resp.status === "SUCCESS") {
                        console.log("Setting deliverylist");
                        var deliveryList = resp.value;
                        var totalQty = 0;
                        for(var i=0; i<deliveryList.length; i++) {
                            totalQty += deliveryList[i].SBQQ__Quantity__c;
                        }
                        component.set("v.originalQuoteLine", deliveryList[0].Name);
                        component.set("v.originalQty", totalQty);
                        component.set("v.deliveryList", deliveryList);
                    }
                } else {
                    let errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            helper.showToast('error','dismissible','Error',errors[0].message);
                        }
                    }
                }
            }
        );
    },
    saveQuoteLines : function(component, event, helper) {
        helper.serverAction(
            component,
            'saveQuoteLineInfo',
            {
                'qliId':component.get("v.recordId"),
                'qlis':component.get("v.deliveryList")
            },
            function(response) {
                component.set("v.showSpinner",false);
                let state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    console.log(resp);
                    $A.get("e.force:closeQuickAction").fire();
                } else {
                    let errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            helper.showToast('error','dismissible','Error',errors[0].message);
                        }
                    }
                }
            }
        );
    },
    deleteQuoteLine : function(component, event, helper, idx) {
        helper.serverAction(
            component,
            'deleteQuoteLine',
            {
                'idx':idx,
                'qlis':component.get("v.deliveryList")
            },
            function(response) {
                component.set("v.showSpinner",false);
                let state = response.getState();
                if(state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    console.log(resp.message);
                    component.set("v.deliveryList", resp.value);
                } else {
                    let errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            helper.showToast('error','dismissible','Error',errors[0].message);
                        }
                    }
                }
            }
        );
    }
})