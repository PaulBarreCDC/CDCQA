({
	doInit : function(component, event, helper) {
		  
       
        var action = component.get("c.CheckEngProdStatus");
        action.setParams({  "quoteId" : component.get('v.recordId')  });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                    
                    window.open('/apex/sbaa__PreviewApprovals?Id='+ component.get('v.recordId'),'_self');
                }else{
                      var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": 'Engineering and Product Planning Reviews must be complete before submitting this Quote',
                        "type": "error"
                    });
                    toastEvent.fire();
                     $A.get("e.force:closeQuickAction").fire();
                }
                
            }if (state === "ERROR") {
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