({
    init: function(component, evt, helper) {
        var myPageRef = component.get("v.pageReference");
        var firstname = myPageRef.state.c__configId;
        component.set("v.configId", firstname);
        component.set("v.quoteId", myPageRef.state.c__quoteId);
    },

    reInit : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
})