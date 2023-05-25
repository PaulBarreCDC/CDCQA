({
    doInit: function(component, event, helper) {
        var action = component.get("c.syncCustomer");
		action.setParams({ "accountId" : "" });
        action.setParams({ "recordId" : component.get("v.recordId") });
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {
                console.log("SUCCESS");
            }else if (state === "INCOMPLETE") {
                console.log("INCOMPLETE");
            } else if (state === "ERROR") {
                var errors = response.getError();
				if (errors) {
                	 if (errors[0] && errors[0].message) {
                     	console.log("Error message: " + errors[0].message);
                     }
                }else {
                 	console.log("Unknown error");
                }
            }
            
        });
        $A.enqueueAction(action);

       var action2 = component.get("c.generateAndSyncParts");		
        action2.setParams({ "recordId" : component.get("v.recordId") });
        action2.setCallback(this, function(response) {
        	var state1 = response.getState();
        	if (state1 === "SUCCESS") {
                console.log("SUCCESS");
            }else if (state1 === "INCOMPLETE") {
                console.log("INCOMPLETE");
            } else if (state1 === "ERROR") {
                var errors = response.getError();
				if (errors1) {
                	 if (errors1[0] && errors1[0].message) {
                     	console.log("Error message: " + errors1[0].message);
                     }
                }else {
                 	console.log("Unknown error");
                }
            }
            
        });
        $A.enqueueAction(action2);       
        
        /*var action1 = component.get("c.syncParts");
		action1.setParams({ "accountId" : "" });
        action1.setParams({ "quoteId" : component.get("v.recordId") });
        action1.setCallback(this, function(response) {
        	var state1 = response.getState();
        	if (state1 === "SUCCESS") {
                console.log("SUCCESS");
            }else if (state1 === "INCOMPLETE") {
                console.log("INCOMPLETE");
            } else if (state1 === "ERROR") {
                var errors = response.getError();
				if (errors1) {
                	 if (errors1[0] && errors1[0].message) {
                     	console.log("Error message: " + errors1[0].message);
                     }
                }else {
                 	console.log("Unknown error");
                }
            }
            
        });
        $A.enqueueAction(action1);*/
        $A.get("e.force:closeQuickAction").fire();
    }
})