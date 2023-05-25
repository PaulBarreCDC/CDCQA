({	    
    retrieveComments : function(component, event, helper) {
        helper.serverAction(
            component,
            'getComments',
            {'quoteId':component.get("v.recordId"),
            'commentType': 'Revision'},
            function(response) {
                component.set("v.showSpinner",false);
                let state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.comments",response.getReturnValue());
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
	}
})