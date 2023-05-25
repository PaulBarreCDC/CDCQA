({
    doInit : function(component, event, helper) {
        
        var showError ;
        var action = component.get("c.syncOrderValidation");    
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        // Call the syncOrderValidation method
        action.setCallback(this,function(syncOrderValidation_response) {
            var state = syncOrderValidation_response.getState();
            console.log('line #14:' + state);
            if (state === "SUCCESS") {
                var rw = syncOrderValidation_response.getReturnValue();
                console.log('line#17:'+rw.status);
                // IF there was an error, display the message to the user
                //  ELSE Call the generateAndSyncPartsAndOrder method
                if(rw.status === 'ERROR') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "ERROR!",
                        "type" : rw.status,
                        "message": rw.message
                    });
                    toastEvent.fire(); 
                    component.set('v.showSpinner',false);
                    $A.get("e.force:closeQuickAction").fire();
                } 
                else {
                    console.log('syncCustomer>>'); 
                    var syncCustomer = component.get("c.syncCustomer");
                    /*syncCustomer.setParams({ "accountId" : "" });
                    syncCustomer.setParams({ "quoteId" : component.get("v.recordId") });*/
                    
                    syncCustomer.setParams({ 
                        "accountId" : "" ,
                        "recordId" : component.get("v.recordId")
                    });
                    
                    syncCustomer.setCallback(this, function(response) {
                        console.log('response'+JSON.stringify(response));
                        var state = response.getState();
                        console.log('line#36>' + state);
                        if (state === "SUCCESS") {
                            var syncPartsAndOrder = component.get("c.generateAndSyncPartsAndOrder");                  
                            syncPartsAndOrder.setParams({
                                "recordId" : component.get("v.recordId")
                            });
                            // Call the generateAndSyncPartsAndOrder method
                            syncPartsAndOrder.setCallback(
                                this,
                                function(response) {
                                    var syncPartsAndOrderState = response.getState();
                                    // IF the method returns a success
                                    //  THEN call the createCreditsAndBooking method
                                    if (syncPartsAndOrderState === "SUCCESS") {                               
                                        var actionCreditBooking = component.get("c.createCreditsAndBooking");        
                                        actionCreditBooking.setParams({
                                            "recordId" : component.get("v.recordId")
                                        });
                                        actionCreditBooking.setCallback(
                                            this,
                                            function(response) {
                                                var state2 = response.getState();
                                                if (state2 === "SUCCESS") {
                                                    //window.open('/'+component.get('v.recordId'),'_self');
                                                    window.open('/lightning/r/SBQQ__Quote__c/' + component.get('v.recordId') + '/view','_self');
                                                } 
                                                else if (state2 === "INCOMPLETE") {
                                                    console.log("INCOMPLETE");
                                                } 
                                                    else if (state2 === "ERROR") {
                                                        var errors2 = response.getError();
                                                        if (errors2) {
                                                            if (errors2[0] && errors2[0].message) {
                                                                var toastEvent = $A.get("e.force:showToast");
                                                                toastEvent.setParams({
                                                                    "title": "ERROR!",
                                                                    "type" : "ERROR",
                                                                    "message": errors2[0].message
                                                                });
                                                                toastEvent.fire(); 
                                                                component.set('v.showSpinner',false);
                                                                $A.get("e.force:closeQuickAction").fire();
                                                            }
                                                        } 
                                                        else {
                                                            console.log("Unknown error");
                                                        }
                                                    }
                                            }
                                        );
                                        $A.enqueueAction(actionCreditBooking);                             
                                    }
                                    else if (syncPartsAndOrderState === "INCOMPLETE") {
                                        console.log("INCOMPLETE");
                                    } 
                                    else if (syncPartsAndOrderState === "ERROR") {
                                        var errors = response.getError();
                                        if (errors) {
                                            if (errors[0] && errors[0].message) {
                                                var toastEvent = $A.get("e.force:showToast");
                                                toastEvent.setParams({
                                                    "title": "ERROR!",
                                                    "type" : "ERROR",
                                                    "message": errors[0].message
                                                });
                                                toastEvent.fire(); 
                                                component.set('v.showSpinner',false);
                                                $A.get("e.force:closeQuickAction").fire();
                                            }
                                        }else {
                                            console.log("Unknown error");
                                        }
                                    }                            
                                }
                            );
                            $A.enqueueAction(syncPartsAndOrder);
                        }
                        else if (state === "INCOMPLETE") {
                            console.log("INCOMPLETE");
                        } 
                        else if (state === "ERROR") {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "ERROR!",
                                        "type" : "ERROR",
                                        "message": errors[0].message
                                    });
                                    toastEvent.fire(); 
                                    component.set('v.showSpinner',false);
                                    $A.get("e.force:closeQuickAction").fire();
                                }
                            }
                            else{
                                console.log("Unknown error");
                            }
                        }
                        
                    });
                    $A.enqueueAction(syncCustomer);                      
                }
            } 
            else if (state === "INCOMPLETE") {
                console.log("INCOMPLETE");
            } 
            else if (state === "ERROR") {
                var errors = syncOrderValidation_response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "ERROR!",
                            "type" : "ERROR",
                            "message": errors[0].message
                        });
                        toastEvent.fire(); 
                        component.set('v.showSpinner',false);
                        $A.get("e.force:closeQuickAction").fire();
                    }
                } 
                else {
                    console.log("Unknown error");
                }
            }
            
        });
        $A.enqueueAction(action);
        //$A.get("e.force:closeQuickAction").fire();	
    }
})