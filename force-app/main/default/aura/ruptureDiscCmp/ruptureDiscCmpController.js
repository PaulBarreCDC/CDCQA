({
    init: function(cmp, evt, helper) {
        var myPageRef = cmp.get("v.pageReference");

        if(myPageRef != null || myPageRef != undefined){
            var firstname = myPageRef.state.c__configId;
            cmp.set("v.configId", firstname);
            cmp.set("v.quoteId", myPageRef.state.c__quoteId);
        }
        else{
            var url_string = window.location.href;
            var url = new URL(url_string);
            var quoteId = url.searchParams.get("quoteId");
            var configId = url.searchParams.get("configId");
            if(quoteId != undefined){
                cmp.set("v.configId", configId);
            cmp.set("v.quoteId", quoteId);

            }
        }


        
        console.log('@@@ quote Id Check', cmp.get("v.quoteId"));
    },

    reInit : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
})