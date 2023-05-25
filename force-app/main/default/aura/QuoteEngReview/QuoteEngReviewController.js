({
    doInit : function(component, event, helper) {
        var path = {
            field1: 'No Applicable',
            field1Style: 'slds-is-complete',
            field2: 'In Review',
            field2Style: 'slds-is-active slds-is-current',
            field3: 'Completed',
            field3Style: 'slds-is-incomplete'
        };
        component.set('v.path',path);
        helper.hidecloseReview(component, event, helper);
        helper.retrieveComments(component, event, helper);
        
        component.set('v.showNew', true); 
    },
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            console.log("Record is loaded successfully.");
            helper.updateQuoteStatus(component,"In Review");
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
        console.log(event.getName());
        console.log(event.getSource());
        let fields = event.getParam('fields');
        fields.Type__c ='Eng Review';
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
        var path = component.get('v.path');
        path.field2Style = 'slds-is-complete';
        path.field3Style = 'slds-is-active slds-is-current';
        component.set('v.path',path);
	},
    handleSave: function(component, event, helper) {
        var form  = component.find("commentForm") || component.find("commentEditForm");
        form.submit();
	},
    handleRequestReview: function(component, event, helper) {
		if(component.get('v.new_commentId')) {
            component.set('v.commentId', component.get('v.new_commentId'));
        }
        if(component.get('v.new_commentValue')) {
            component.set('v.commentValue', component.get('v.new_commentValue'));
        }
        component.set('v.showNew', false);
        
        helper.updateQuoteStatus(component,"In Review");
        
        var path = component.get('v.path');
        path.field2Style = 'slds-is-active slds-is-current';
        path.field3Style = 'slds-is-incomplete';
        component.set('v.path',path);
	},
    handleCloseReview: function(component, event, helper) {
        var pending = component.get("v.pendingApprovalCount");
        if(pending > 0) {
            helper.showToast('error','dismissible','Error',`There ${pending == 1 ? 'is ' + pending + ' line item ': 'are ' + pending + ' line items '} pending approval. Please review the line item grid`);
        } else {
            var form  = component.find("commentForm") || component.find("commentEditForm");
            form.submit();
            helper.updateQuoteStatus(component,"Completed");
            $A.get("e.force:closeQuickAction").fire();
        }
	},
})