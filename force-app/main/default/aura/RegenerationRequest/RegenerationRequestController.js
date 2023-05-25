({
    doInit: function(component, event, helper) {
        
        helper.checkRegenerationRequest(component, event, helper);
    },
    
    handleClick : function(component, event, helper) {
        
        //helper.onSelectChange(component, event);
        var allValid = component.find('fieldId').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        
        if (allValid) {
            
            //alert('All form entries look valid. Ready to submit!');
            helper.submitRegenerationRequest(component, event, helper);
            
        } else {
            
            helper.showErrorToast(component, event, helper, 'Please enter the mandatory fields');
        }
    }
    
    
})