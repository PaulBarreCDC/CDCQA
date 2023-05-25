({
    init: function(cmp, evt, helper) {
        var myPageRef = cmp.get("v.pageReference");


        if(myPageRef != null || myPageRef != undefined){
            var firstname = myPageRef.state.c__configId;
            cmp.set("v.configId", firstname);
        }
        else{
            var url_string = window.location.href;
            var url = new URL(url_string);
            var configId = url.searchParams.get("configId");
            cmp.set("v.configId", configId);
            
        }
        
    },

    reInit : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
})