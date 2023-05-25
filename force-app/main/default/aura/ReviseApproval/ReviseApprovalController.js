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
        fields.Type__c ='Revision';
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
        /*  var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
              "url": "/apex/RecallQuote?Id",
              "isredirect": "true"
            });
            urlEvent.fire();*/      
        window.open('/apex/RecallQuote?Id='+ component.get('v.recordId'),'_self');
    },
    handleSave: function(component, event, helper) {
        var form  = component.find("commentForm") || component.find("commentEditForm");
        form.submit();
        window.location.reload();        
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
        window.location.reload();
        $A.get("e.force:closeQuickAction").fire();
        
    },
})