({
    doInit : function(component, event, helper) {
        component.set('v.quoteId', component.get('v.pageReference').state.c__quoteId);
    },

    onPageReferenceChange: function(component, event, helper) {
        component.set('v.quoteId', component.get('v.pageReference').state.c__quoteId);
        $A.get('e.force:refreshView').fire();
    },
})