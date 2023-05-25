({	
    handleCheckBox1 : function(component, event, helper) {      
        var checkCmp = component.find("checkBox1"); 
        component.set("v.checkBox1", checkCmp.get("v.checked"));   
        component.set("v.selectedCheckbox",event.getSource().get("v.label"));
    },
    handleCheckBox2 : function(component, event, helper) {
        var checkCmp = component.find("checkBox2");
        component.set("v.checkBox2", checkCmp.get("v.checked"));
        component.set("v.selectedCheckbox",event.getSource().get("v.label"));
    },
    handleCheckBox3 : function(component, event, helper) {
        var checkCmp = component.find("checkBox3");
        component.set("v.checkBox3", checkCmp.get("v.checked"));
        component.set("v.selectedCheckbox",event.getSource().get("v.label"));
    },
    handleCheckBox4 : function(component, event, helper) {
        var checkCmp = component.find("checkBox4");
        component.set("v.checkBox4", checkCmp.get("v.checked"));
        component.set("v.selectedCheckbox",event.getSource().get("v.label"));
    },
    clickAdd : function(component, event, helper) {
        
        // Get the values from the form
        var checkBox1 = component.find("checkBox1").get("v.checked");
        var checkBox2 = component.find("checkBox2").get("v.checked");
        var checkBox3 = component.find("checkBox3").get("v.checked");
        var checkBox4 = component.find("checkBox4").get("v.checked");
        
        if(checkBox1 || checkBox2 || checkBox3 || checkBox4) {
            var simpleRecord = component.get("v.simpleRecord");
            simpleRecord.Terms_and_Conditions_Reviewer__c = $A.get("$SObjectType.CurrentUser.Id");
            simpleRecord.Terms_and_Conditions_Review_Date__c = new Date();
            //alert(component.get("v.selectedCheckbox"));
            simpleRecord.Terms_and_Conditions_Review__c = component.get("v.selectedCheckbox");
            component.set("v.simpleRecord",simpleRecord);
            
            
            component.find("recordHandler").saveRecord($A.getCallback(function(saveResult) {
                // use the recordUpdated event handler to handle generic logic when record is changed
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                    
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Success",
                        "type": "success",
                        "message": ""
                    });
                    resultsToast.fire();
                    
                    // Close the action panel
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    
                } else if (saveResult.state === "INCOMPLETE") {
                    console.log("User is offline, device doesn't support drafts.");
                } else if (saveResult.state === "ERROR") {
                    console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Error",
                        "type": "error",
                        "message": JSON.stringify(saveResult.error)
                    });
                    resultsToast.fire();
                } else {
                    console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                }
            }));
        }
    }
})