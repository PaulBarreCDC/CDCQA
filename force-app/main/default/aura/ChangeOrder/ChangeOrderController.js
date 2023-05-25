({
    doInit : function(component, event, helper) {        
        helper.retrieveComments(component, event, helper);
        component.set('v.showNew', true); 
    },
    
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            console.log("Record is loaded successfully.");
            
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    },
    
    handleLoad : function(component, event, helper) {
    },
    
    handleSubmit : function(component, event, helper) {
        event.preventDefault();
        let fields = event.getParam('fields');
        fields.Type__c ='Change Order';
        fields.Quote__c = component.get("v.recordId");
        component.set('v.showSpinner', true);
        component.find('commentForm').submit(fields);
    },
    
    handleSuccess : function(component, event, helper) {
        component.set('v.showNew', true);
        var payload = event.getParams(); 
        component.set('v.commentId', '');
        component.set('v.new_commentId', payload.response.id);
        component.set('v.new_commentValue',component.get('v.commentValue'));
        component.set('v.commentValue','');
        helper.retrieveComments(component, event, helper);
        helper.showToast('Success','dismissible','Success','Record Created Successfully');
        component.set('v.showSpinner',true);
		//window.open('/apex/RecallQuote?Id='+ component.get('v.recordId'),'_self');
        var action = component.get("c.callPageReference");
        action.setParams({  "quoteId" : component.get('v.recordId')  });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.showSpinner',false);
            if (state === "SUCCESS") {
                if(response.getReturnValue() != null || response.getReturnValue() != undefined && response.getReturnValue() !='')
                	window.open('/'+response.getReturnValue(), '_self');
                else{
                     var toastEvent = $A.get("e.force:showToast");
    					toastEvent.setParams({
        				"title": "Error!",
                        "message": "Error in Cloning Record.",
                            "type": "error"
    					});
    				toastEvent.fire();
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
// Display the message
console.error(message);
            }
        });
        $A.enqueueAction(action);      
    },
    
    handleSave: function(component, event, helper) {
        var form  = component.find("commentForm") || component.find("commentEditForm");
        form.submit();
        //call to vf page
    },
    
    handleRequestReview: function(component, event, helper) {
        if(component.get('v.new_commentId')) {
            component.set('v.commentId', component.get('v.new_commentId'));
        }
        if(component.get('v.new_commentValue')) {
            component.set('v.commentValue', component.get('v.new_commentValue'));
        }
        component.set('v.showNew', false);
        
    },
    
    handleCloseReview: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
})