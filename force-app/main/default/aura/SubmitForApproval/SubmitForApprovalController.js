({
    doInit : function(component, event, helper) {
        var action = component.get("c.validateAndSubmitApproval");  // Get the method QuoteExtController.validateAndSubmitApproval
        action.setParams({                                          // Set the quoteId parameter
            "quoteId" : component.get('v.recordId'),
            "userId" : $A.get("$SObjectType.CurrentUser.Id")
        });
        action.setCallback(this, function(response) {               // Set the code that runs once the QuoteExtController sends a response
            var state = response.getState();
            // IF the system sends a success message from the server (QuoteExtController)
            //  IF the server side code states that an error occurred (rw.status === 'ERROR')
            //   Display a toast error message to the user
            //  ELSE Navigate to the quote view page, to force a refresh
            // ELSE IF the system sends an error message (could not reach QuoteExtController, or fatal error occurrs)
            //  Display the first message to the user
            if (state === "SUCCESS") {
                var rw = response.getReturnValue();
                if(rw.status === 'ERROR') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "ERROR!",
                        "message": rw.message,
                        "type": rw.status
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                } else {
                    window.location.reload();
                    // Navigate to force a refresh
                    component.find("navigation")
                    .navigate(
                        {
                            "type" : "standard__recordPage",
                            "attributes": {
                                "recordId"      : component.get('v.recordId'),
                                "objectApiName" : "SBQQ__Quote__c",
                                "actionName"    : "view"
                            }
                        },
                        true
                    );
                   /*$A.get('e.force:refreshView').fire();*/
                }
            } else if (state === "ERROR") {
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
                    $A.get("e.force:closeQuickAction").fire();
                }
            } 
        });
        $A.enqueueAction(action);
    }
    
})