({
    doInit: function(component, event, helper) {
        var action = component.get("c.syncCustomer");
		action.setParams({ "accountId" : "" });
        action.setParams({ "recordId" : component.get("v.recordId") });
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {
                console.log("SUCCESS");
                console.log("close quick action");
                $A.get("e.force:closeQuickAction").fire();
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
        $A.get("e.force:closeQuickAction").fire();
    }
})