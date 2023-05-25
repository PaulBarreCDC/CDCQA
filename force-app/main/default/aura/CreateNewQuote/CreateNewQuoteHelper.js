({
    creatQuote : function(component,event) {
        
        component.set('v.showSpinner',true);
        var action = component.get("c.createQuote");
        action.setParams({  "oppId" : component.get('v.recordId')  });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                if(response.getReturnValue() != null){
                    component.set('v.showSpinner',false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": 'Success! Navigating to Quote...',
                        "type": "success"
                    });
                    toastEvent.fire();
                    window.open('/'+ response.getReturnValue(),'_self');
                    $A.get("e.force:closeQuickAction").fire();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": 'Error Creating Quote!',
                        "type": "error"
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                }
            }else if (state === "ERROR") {
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