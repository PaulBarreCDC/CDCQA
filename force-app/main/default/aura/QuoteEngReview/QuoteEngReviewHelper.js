({	
    updateQuoteStatus : function(component,status) {
        var quoteRecord = component.get("v.quoteRecord");
        quoteRecord.Eng_Review_Status__c = status;//Changed By Maanas Status s was lowercase
        component.set("v.quoteRecord",quoteRecord);
        
        component.find("recordHandler").saveRecord($A.getCallback(function(saveResult) {
            // use the recordUpdated event handler to handle generic logic when record is changed
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Quote Status updated to "+status);     
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Error",
                    "type": "error",
                    "message": JSON.stringify(saveResult.error)
                });
                resultsToast.fire();
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));  
    },
    retrieveComments : function(component, event, helper) {
        helper.serverAction(
            component,
            'getInfo',
            {'quoteId':component.get("v.recordId"),
             'commentType': 'Eng Review'},
            function(response) {
                component.set("v.showSpinner",false);
                let state = response.getState();
                if (state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    component.set("v.comments",resp.comments);
                    component.set("v.qlis",resp.qlis);
                    component.set("v.pendingApprovalCount",resp.pendingApprovalCount);
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
    serverAction : function(component, methodName, params, callback) {
        console.log('serverAction => methodName'+':' + methodName);
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
    
    hidecloseReview : function(component,event)
    {
        
        var action = component.get("c.CheckEngApproverUser");
        action.setParams({  "quoteId" : component.get('v.recordId')  });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                    component.set('v.showEngApprover',response.getReturnValue());
                    console.log(component.get('v.showEngApprover'));
                }
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": message,
                        "type": "error"
                    });
                    toastEvent.fire();
                    
                }
            }
        });
        $A.enqueueAction(action); 
        
    }
})