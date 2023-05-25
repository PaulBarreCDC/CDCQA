({
	doInit : function(component, event, helper) {
        
        
        var action = component.get("c.rerun");
        action.setParams({  "quoteLineId" : component.get('v.recordId')  });
        action.setCallback(this, function(response) {
        var state = response.getState();
            
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Rules Success!",
                        "type": "success"
                    });
                    toastEvent.fire();
                component.set('v.showSpinner',false);
                
                 $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
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