({
	doInIt : function(component, event, helper) {
        var action = component.get("c.cloneQuoteLine");
        action.setParams({ quoteLineId : component.get('v.recordId')});
 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var getReturnValue = response.getReturnValue();
                 component.set('v.isLoading',false);
                
                 // Close the action panel
                   var dismissActionPanel = $A.get("e.force:closeQuickAction");
                       dismissActionPanel.fire();
                
                 var message = 'Quote Line has clone  Successfully!';
                if(getReturnValue != null){
                 
                helper.showToast(component, event, 'success',message);
                    component.find("navigation").navigate({
                           "type" : "standard__recordPage",
                            "attributes": {
                            "recordId"      : getReturnValue,
                            "actionName"    : "view"  
        }
    }, true);
                   
                }
                else {
                      helper.showToast(component, event, 'error',getReturnValue); 
                }
              
            }
            else if (state === "INCOMPLETE") {
                // do something
                   component.set('v.isLoading',false);
                         var dismissActionPanel = $A.get("e.force:closeQuickAction");
                       dismissActionPanel.fire();
                helper.showToast(component, event, 'error','Error');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                          component.set('v.isLoading',false);
                         var dismissActionPanel = $A.get("e.force:closeQuickAction");
                       dismissActionPanel.fire();
                   helper.showToast(component, event, 'error',errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
 
      
        $A.enqueueAction(action);
    }

})