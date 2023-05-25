({
    checkRegenerationRequest: function(component, event, helper) {
		
        helper.showSpinner(component, event, helper);
        var action = component.get("c.checkRegenerationRequest");
        action.setParams({
            
        });

        action.setCallback(this, function(response) {
			
            var state = response.getState();
            if(state === 'SUCCESS') {
				
                helper.hideSpinner(component, event, helper);
                var response = response.getReturnValue();
                
                helper.setValues(component, response);
            }
            else {
                
                helper.hideSpinner(component, event, helper);
                helper.showErrorToast(component, event, helper, 'Error in getting data');
            }
        });
        $A.enqueueAction(action);
    },
    
    submitRegenerationRequest: function(component, event, helper) {
		
        helper.showSpinner(component, event, helper);
        var action = component.get("c.submitRegenerationRequest");
        action.setParams({
            
            product: component.get("v.product"),
            quoteNo: component.get("v.quoteId")
        });

        action.setCallback(this, function(response) {
			
            var state = response.getState();
            if(state === 'SUCCESS') {
				
                helper.hideSpinner(component, event, helper);
                var response = response.getReturnValue();
                
                helper.setValues(component, response);
                
                component.set("v.product", "");
                component.set("v.quoteId", "");
                if(response['STATUS'] == true) {
                    
                    helper.showConfirmationToast(component, event, helper, response['MESSAGE']);
                    
                } else {
                    
                    helper.showErrorToast(component, event, helper, response['MESSAGE']);
                }
            }
            else {
                
                helper.hideSpinner(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    showConfirmationToast : function(component, event, helper, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": message
        });
        toastEvent.fire();
    },
    
    showWarningToast : function(component, event, helper, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "warning",
            "title": "Info!",
            "message": message
        });
        toastEvent.fire();
    },
    
    showErrorToast : function(component, event, helper, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "error",
            "title": "Error!",
            "message": message
        });
        toastEvent.fire();
    },
    
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
    
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },
    
    setValues: function(component, response) {
        
        var completed_regeneration = response['COMPLETED_REGENERATION'];
        var current_req_details = response['REGENERATION_DETAILS'];
        component.set("v.request_pending", response['IS_REQUEST_PENDING']);
        component.set("v.current_request_details", current_req_details); 
        component.set("v.product_options", response['PRODUCT_OPTIONS']);        
        component.set("v.request_color", "green"); 
        component.set("v.completed_regeneration", completed_regeneration); 
        if(current_req_details && current_req_details.length > 0) {
            
            component.set("v.request_color", "red"); 
        }        
    }
})