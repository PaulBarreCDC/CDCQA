({
    doInit : function(component, event, helper) {
        console.log('override doInit');
    },

    recordLoaded : function(component, event, helper){
        console.log('recordLoaded aura');
        component.set('v.loading', false);
    },

    closeQuickAction : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    }
})